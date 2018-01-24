# common.mk: this contains commonly used helpers for makefiles.

## Common variables
SHELL=/bin/bash
ROOT := $(shell pwd)
GH_HOST := github.com
# GHE_HOST := github-enterprise-server.com

# SSH clones over the VPN get killed by some kind of DOS protection run amook
# set clone_delay to add a delay between each git clone/fetch to work around that
# e.g. CLONE_DELAY=1 make all
# the default is no delay
CLONE_DELAY ?= 0

# gitclone is a function that will do a clone, or a fetch / checkout [if we'd previous done a clone]
# usage, $(call gitclone,github.com,<org>/foo,/some/directory,some_sha)
# it builds a repo url from the first 2 params, the 3rd param is the directory to place the repo
# and the final param is the commit to checkout [a sha or branch or tag]
define gitclone
	@echo "Checking/Updating dependency $(2)"
	@if [ -d $(3) ]; then cd $(3) && git fetch origin; fi			                                        # update from remote if we've already cloned it
	@if [ ! -d $(3) ] && [ $(1) == ${GHE_HOST} ]; then git clone -q -n git@$(1):$(2) $(3); fi	            # clone a new copy from GHE
	@if [ ! -d $(3) ] && [ $(1) != ${GHE_HOST} ]; then git clone -q -n https://$(1)/$(2).git $(3); fi	# clone a new copy from other sources
	@cd $(3) && git checkout -q $(4)								                                        # checkout out specific commit
	@sleep ${CLONE_DELAY}
endef

define goget
	@echo "Checking/Updating dependency $(2)"
	@go get -u $(1)/$(2)
	@sleep ${CLONE_DELAY}
endef
