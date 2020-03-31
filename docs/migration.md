
Migration from v1.2.8 to v2.0.0
-------------------------------

  

This document is a guide to help you migrate from rdiff-backup v1.2.8
(legacy version) to rdiff-backup v2.0.0 (new version).

  

This new version of rdiff-backup is compatible with repositories created
with the legacy version. In other words, the data on the disk is fully
compatible between the two. But the network protocol is not. For this
reason, you might need to have a plan to transition from the legacy
version to the new version depending of your use case.

  

Use Case: Local to Local
------------------------

You are using rdiff-backup locally if you are running a command line
where the source and the destination are defined as a path on the same
computer. e.g.:

       rdiff-backup /source /destination

`/source` and `/destination` are paths that reside on the same computer.
/source or /destination might be remote mounted filesystem like NFS or
SSHFS.

With this use case to migrate to the latest version, we recommend you to
simply upgrade your existing installation of rdiff-backup “in-place”.

Follow the instructions <span
style="font-weight: normal">[here](https://github.com/rdiff-backup/rdiff-backup#installation).</span>

Use Case: Local to Remote (push)
--------------------------------

You are using rdiff-backup Local to Remote if you are running a command
line where the source is local and the destination is remote. e.g.:

       rdiff-backup /source user@10.255.1.102:/destination

  

**Notice:** With this use case you must be careful as rdiff-backup
legacy version is not compatible with the new version due to the
migration to Python 3.

  

You have two options for your migration:

1. Upgrade all instances of rdiff-backup to the new version. This option
is recommended for **small deployment**. If this is your case, just
follow the instructions <span
style="font-weight: normal">[here](https://github.com/rdiff-backup/rdiff-backup#installation).
</span>

2. Upgrade rdiff-backup progressively to the new version. This option is
recommended for **large deployment**. If this is your case, just
continue reading.

  

If your rdiff-backup deployment is large, upgrading all instances at the
same time might not be possible. The following section describes a way
for you to mitigate this problem. By installing both versions side by
side. <span style="font-weight: normal">To achieve this, we recommend
installing the new rdiff-backup version in a virtualenv.</span>

#### <span style="font-weight: normal">On </span><span style="font-weight: normal">R</span><span style="font-weight: normal">emote</span>

<span style="font-weight: normal">S</span><span
style="font-weight: normal">tart by installing the new rdiff-backup
side-by-side on the remote server as follows:</span>

**On Debian**

       $ sudo apt update
        $ sudo apt install python3-dev libacl1-dev virtualenv build-essential curl  
        $ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        $ sudo python3 get-pip.py
        $ sudo virtualenv -p python3 /opt/rdiff-backup2
        $ sudo /opt/rdiff-backup2/bin/pip3 install rdiff-backup pyxattr pylibacl
        $ sudo ln -s /opt/rdiff-backup2/bin/rdiff-backup /usr/bin/rdiff-backup2
        $ rdiff-backup –version
        rdiff-backup 2.0.0
        $ rdiff-backup –version
        rdiff-backup 1.2.8

**On CentOS/Redhat**

TODO

#### On Local

Once the remote server is supporting both versions, you may then start
upgrading local instances to the new version by following the
instruction
[here](https://github.com/rdiff-backup/rdiff-backup#installation). This
will upgrade rdiff-backup to the new version.

Next, you will need to tweak the command line used to run your backup to
something similar:

rdiff-backup --remote-schema “ssh %s rdiff-backup2 --server”

**Use Case: Remote to Local (push)**
------------------------------------