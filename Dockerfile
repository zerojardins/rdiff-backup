# rdiff-backup build environment (for developers)
FROM debian:sid

# General Debian build dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update -yqq && \
    apt-get install -y --no-install-recommends \
    devscripts \
    equivs \
    curl \
    ccache \
    git \
    git-buildpackage \
    pristine-tar

# Build dependencies specific for rdiff-backup
RUN DEBIAN_FRONTEND=noninteractive apt-get update -yqq && \
    apt-get install -y --no-install-recommends \
    librsync-dev \
    python3-all-dev \
    python3-pylibacl \
    python3-pyxattr

# Build dependencies specific for rdiff-backup development and testing
RUN DEBIAN_FRONTEND=noninteractive apt-get update -yqq && \
    apt-get install -y --no-install-recommends \
    tox \
    rdiff \
    # /usr/include/sys/acl.h is required by test builds
    libacl1-dev \
    # tox_slow uses rsync for comperative benchmarking
    rsync

# Tests require that there is a regular user
ENV RDIFF_TEST_UID 1000
ENV RDIFF_TEST_USER testuser
ENV RDIFF_TEST_GROUP testuser

RUN useradd -ms /bin/bash --uid ${RDIFF_TEST_UID} ${RDIFF_TEST_USER}

# Build dev image
# docker build --pull --tag rdiff-backup-dev:debian-sid .

# Build rdiff-backup (assumes source is in directory 'rdiff-backup' and it's parent is writeable)
# docker run -it -v ${PWD}/..:/build -w /build/rdiff-backup rdiff-backup-dev:debian-sid ./setup.py build

# Run tests (note session will user=root inside Docker)
# docker run -it -v ${PWD}/..:/build -w /build/rdiff-backup rdiff-backup-dev:debian-sid ./run-tests.sh
