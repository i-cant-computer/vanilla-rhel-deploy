## Default make target
.DEFAULT_GOAL := help

## Collection coordinates
NAMESPACE := i_cant_computer
NAME := vanilla_rhel_deploy
COLLECTION_DIR := i_cant_computer/vanilla_rhel_deploy

## Output/install locations
DEST ?= $(HOME)/.ansible/collections
TARBALL_GLOB := $(COLLECTION_DIR)/$(NAMESPACE)-$(NAME)-*.tar.gz

## Tooling
GALAXY ?= ansible-galaxy
ANSIBLE_PLAYBOOK ?= ansible-playbook
ANSIBLE_LINT ?= ansible-lint
YAMLLINT ?= yamllint

## Optional flags
ANSIBLE_GALAXY_FLAGS ?=
EXTRA_VARS ?=

## Example playbook for local checks
PLAYBOOK ?= examples/update.yml

.PHONY: help build install lint check clean

## help: Show this help
help:
	@grep -E '^[a-zA-Z_.-]+:|^##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS=":"} /^##/ {sub(/^## /, ""); h=$$0} /^[a-zA-Z_.-]+:/ {sub(/:.*/, ""); if (length(h)) {printf "\033[36m%-18s\033[0m %s\n", $$1, h; h=""}}'

## build: Build the collection tarball (force overwrite)
build:
	cd $(COLLECTION_DIR) && $(GALAXY) collection build --force

## install: Install the last built tarball into DEST (force overwrite)
install: build
	$(GALAXY) collection install --force $(ANSIBLE_GALAXY_FLAGS) $(TARBALL_GLOB) -p $(DEST)

## lint: Run ansible-lint and yamllint over the collection
lint:
	$(ANSIBLE_LINT) $(COLLECTION_DIR)
	$(YAMLLINT) $(COLLECTION_DIR)

## check: Dry-run the example playbook against localhost with diff
check:
	$(ANSIBLE_PLAYBOOK) -i localhost, -c local $(PLAYBOOK) --check --diff $(if $(EXTRA_VARS),-e '$(EXTRA_VARS)')

## clean: Remove built tarballs
clean:
	rm -f $(TARBALL_GLOB)
