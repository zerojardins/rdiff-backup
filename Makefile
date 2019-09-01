# Makefile to automate rdiff-backup build and install steps

#RUN_COMMAND ?= docker run -it -v ${PWD}/..:/build -w /build/rdiff-backup rdiff-backup-dev:debian-sid

all: test build

test: test-static test-runtime

test-static:
	${RUN_COMMAND} tox -c tox.ini -e flake8

test-runtime: test-runtime-basic test-runtime-root test-runtime-slow

test-runtime-files:
	@echo "=== Install files required by the tests: ==="
	${RUN_COMMAND}  ./setup-testfiles.sh

test-runtime-basic: test-runtime-files
	@echo "=== Basic tests: ==="
	${RUN_COMMAND} tox -c tox.ini -e py37

test-runtime-root: test-runtime-files
	@echo "=== Tests that require root permissions: ==="
	${RUN_COMMAND}  tox -c tox_root.ini -e py37 # This must be run as root

test-runtime-slow: test-runtime-files
	@echo "=== Long running performance tests: ==="
	${RUN_COMMAND} tox -c tox_slow.ini -e py37

build:
	${RUN_COMMAND} ./setup.py build

container:
	docker build --pull --tag rdiff-backup-dev:debian-sid .
