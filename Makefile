include common.mk

export GOPATH=${HOME}/repos

BUILD_DIR=${GOPATH}
ME_DIR=${GH_HOST}/comagnaw
DEP=${BUILD_DIR}/src
GH_DEP=${DEP}/${GH_HOST}

.PHONY: *


all: prep get finish

prep:
	@mkdir -p ${BUILD_DIR}/src/${ME_DIR}
	@mkdir -p ${HOME}/virtualBoxes
get:
	@echo "Checking dependencies..."
	$(call gitclone,${GH_HOST},comagnaw/home-stuff,                   ${GH_DEP}/comagnaw/home-stuff)

finish:
	@if [ ! -L ${HOME}/home ] ; \
		then \
		ln -s ${BUILD_DIR}/src/${ME_DIR}/home-stuff ${HOME}/home ; \
	fi ;
	@if [ ! -L ${HOME}/vagrantFiles ] ; \
		then \
		ln -s ${BUILD_DIR}/src/${ME_DIR}/home-stuff/vagrantFiles ${HOME}/vagrantFiles ; \
	fi ;

	@${HOME}/home/bin/sync2home.sh git_include
	
	scripts/install-homebrew.sh
	scripts/install-formulas.sh
	scripts/install-fonts.sh
	scripts/setup-golang.sh
	scripts/setup-pinentry.sh
    
