#!/bin/bash

# Exit on erros immediately
set -e

# Debug cache:
pwd
ls -la ../rdiff-backup_testfiles

if [ -d ../rdiff-backup_testfiles/bigdir ]
then
  echo "Test files found, not re-installng them.."
else
  echo "Test files not found, installng them.."
  cd ..
  if [ ! -f rdiff-backup_testfiles_2019-08-10.tar.gz ]
  then
    curl -LO https://github.com/ericzolf/rdiff-backup/releases/download/Testfiles2019-08-10/rdiff-backup_testfiles_2019-08-10.tar.gz
  fi
  tar xvf rdiff-backup_testfiles_*.tar.gz # This must be run as root
  ./rdiff-backup_testfiles.fix.sh ${RDIFF_TEST_USER} ${RDIFF_TEST_GROUP} # This must be run as root
  cd rdiff-backup
fi

echo "
Verify a normal user for tests exist:
RDIFF_TEST_UID: ${RDIFF_TEST_UID}
RDIFF_TEST_USER: ${RDIFF_TEST_USER}
RDIFF_TEST_GROUP: ${RDIFF_TEST_GROUP}
"
