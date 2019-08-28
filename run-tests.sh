#!/bin/bash

# Exit on erros immediately
set -e

echo "
Environment:
RDIFF_TEST_UID: $RDIFF_TEST_UID
RDIFF_TEST_USER: $RDIFF_TEST_USER
RDIFF_TEST_GROUP: $RDIFF_TEST_GROUP
"

# Debug: cache:
pwd
ls -la ../

if [ -d ../rdiff-backup_testfiles ]
then
  echo "Test files found, not re-installng them.."
else
  echo "Test files not found, installng them.."
  cd ..
  curl -LO https://github.com/ericzolf/rdiff-backup/releases/download/Testfiles2019-08-10/rdiff-backup_testfiles_2019-08-10.tar.gz
  tar xvf *.tar.gz # This must be run as root
  ./rdiff-backup_testfiles.fix.sh ${RDIFF_TEST_USER} ${RDIFF_TEST_GROUP} # This must be run as root
  cd rdiff-backup
fi

tox -c tox.ini -e py37
tox -c tox_root.ini -e py37 # This must be run as root
tox -c tox_slow.ini -e py37
