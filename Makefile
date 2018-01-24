include common.mk

export GOPATH=${HOME}/repos

BUILD_DIR=${GOPATH}/
ME_DIR=${GH_HOST}/comagnaw
DEP=${BUILD_DIR}/src
GHE_DEP=${DEP}/${GHE_HOST}

.PHONY: *


all: prep get finish

prep:
	@mkdir -p ${BUILD_DIR}/src/${ME_DIR}
	@mkdir -p ${HOME}/virtualBoxes
get:
	@echo "Checking dependencies..."
	$(call gitclone,${GHE_HOST},comagnaw/home-stuff,                   ${GHE_DEP}/comagnaw/home-stuff)

finish:
	@if [ ! -L ${HOME}/home ] ; \
		then \
		ln -s ${BUILD_DIR}src/${ME_DIR}/home-stuff ${HOME}/home ; \
	fi ;
	@if [ ! -L ${HOME}/vagrantFiles ] ; \
		then \
		ln -s ${BUILD_DIR}src/${ME_DIR}/home-stuff/vagrantFiles ${HOME}/vagrantFiles ; \
	fi ;
	@${HOME}/home/bin/sync_home.sh
    
