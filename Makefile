# Makefile to automate rdiff-backup build and install steps

all: test build

test: test-static test-runtime

test-static:
	tox -c tox.ini -e flake8

test-runtime:
	@echo "=== Install files required by the tests: ==="
	./install-testfiles.sh
	
	@echo "\n\
	=== Verify a normal user for tests exist: ===\n\
	RDIFF_TEST_UID: ${RDIFF_TEST_UID} \n\
	RDIFF_TEST_USER: ${RDIFF_TEST_USER} \n\
	RDIFF_TEST_GROUP: ${RDIFF_TEST_GROUP} \n\
	"

	@echo "=== Basic tests: ==="
	tox -c tox.ini -e py37

	@echo "=== Tests that require root permissions: ==="
	tox -c tox_root.ini -e py37 # This must be run as root

	@echo "=== Long running performance tests: ==="
	tox -c tox_slow.ini -e py37
	
build:
	./setup.py build

container:
	docker build --pull --tag rdiff-backup-dev:debian-sid .
	
