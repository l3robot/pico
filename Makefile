
# Name of the requirements files
REQS_FILE := requirements.txt
REQS_DEV_FILE := requirements-dev.txt

# ----------------------------------------------------------------------
# Installation 
# ----------------------------------------------------------------------
.PHONY: install install-dev  

venv/touchfile: 
	virtualenv -p python3.10 venv
	touch venv/touchfile

install: venv/touchfile
	venv/bin/pip install -r $(REQS_FILE)

install-dev: venv/touchfile
	venv/bin/pip install -r $(REQS_DEV_FILE)
	venv/bin/pip install -r $(REQS_FILE)

clean:
	rm -rf venv

# ----------------------------------------------------------------------
# Update requirements
# ----------------------------------------------------------------------
.PHONY: update

update:
	venv/bin/pip-compile --output-file=$(REQS_FILE) requirements.in
	venv/bin/pip-compile --output-file=$(REQS_DEV_FILE) requirements-dev.in

# ----------------------------------------------------------------------
# Linting
# ----------------------------------------------------------------------
.PHONY: black isort format mypy ruff black-check isort-check lint

black: venv
	venv/bin/black .

format: venv black isort
	venv/bin/black .

isort:
	venv/bin/isort .

mypy: venv
	venv/bin/mypy --install-types .

ruff: venv
	venv/bin/ruff .

black-check: venv
	venv/bin/black --check .

isort-check:
	venv/bin/isort --check .

lint: venv ruff black-check isort-check

# ----------------------------------------------------------------------
# Testing
# ----------------------------------------------------------------------
.PHONY: unit-test

unit-test: venv
	venv/bin/pytest tests/unit

