#!/usr/bin/env bash

# Set-up envvars necessary to find brew command
#  - Reference: https://docs.brew.sh/Installation

# Default location for homebrew on i386
BREW_PATH=/usr/local/bin

# Determine platorm (i386 vs arm)
PLATFORM=$(uname -p)

# Change brew_path if arm platform
if [[ "$PLATFORM" == 'arm' ]]
then
    BREW_PATH=/opt/homebrew/bin
fi

# Variables to provide path scope for various uses
ME=comagnaw
GH_HOST=github.com
GOPATH=${HOME}/repos
ME_DIR=${GH_HOST}/${ME}
DEP=${GOPATH}/src

# clone - creates directories and clones necessary git repositories
clone() {
	mkdir -p ${DEP}/${ME_DIR}

    get ${GH_HOST} ${ME}/home-stuff ${DEP}/${ME_DIR}/home-stuff

}

# get - utility script to perform git clone
get() {
    local host=${1}
    local repo=${2}
    local dest=${3}
    if [ -d ${dest} ]
    then
        printf "Repo ${repo} already exists, skipping\n"
    else
        printf "Cloning repo ${repo}...\n"
        git clone git@${host}:${repo}.git ${dest}
        printf "Done\n"
    fi  
}

# setup_home - create symlink to home_osx repo and sync files to various locations
setup_home() {
    if [ ! -L ${HOME}/home ]
    then
        ln -s ${DEP}/${ME_DIR}/home-stuff ${HOME}/home
    fi
    ${HOME}/home/bin/sync2home.sh git_include
}

# ssh_config - create .ssh/config, generate ssh key, and add it to ssh agent and keychain
ssh_config() {
    local sshPath=${HOME}/.ssh
    if [ ! -d ${sshPath} ]
    then
        mkdir -p ${sshPath}
        chmod 600 ${sshPath}
    fi
    if [ ! -f ${sshPath}/config ]
    then
        touch ${sshPath}/config
        chmod 600 ${sshPath}/config
        cat << EOT > ${sshPath}/config
Host github.com
  Hostname github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/${ME}_id_ed25519
  IdentitiesOnly yes

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/local_id_ed25519
  ServerAliveInterval 30
EOT
    fi

    ssh-keygen -t ed25519 -C "${ME}@gmail.com" -f ${sshPath}/${ME}_id_ed25519
    ssh-keygen -t ed25519 -C "${USER}@${HOST}" -f ${sshPath}/local_id_ed25519

    eval "$(ssh-agent -s)"
    ssh-add --apple-use-keychain ${sshPath}/${ME}_id_ed25519
    ssh-add --apple-use-keychain ${sshPath}/local_id_ed25519

}

# homebrew - install homebrew if not already installed 
homebrew() {

    # If brew is not found, then install it, else skip install
    if [ ! -f "${BREW_PATH}/brew" ]
    then
        printf "# Installing homebrew...\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        printf "# Done installing homebrew\n"
    else
        printf "# Homebrew already installed"
    fi

}

# formulas - installs homebrew formulas and casks
formulas() {

    printf "# Installing homebrew formulas...\n"
    ${BREW_PATH}/brew install gnupg pinentry-mac python go \
    protobuf pyenv pyenv-virtualenv pyenv-virtualenvwrapper \
    terminal-notifier zsh rg jq yq git hub plantuml graphviz \
    ruby bitwarden-cli gnu-tar rpm docker docker-compose

    # Symlink python and pip
    ln -s ${BREW_PATH}/pip3 ${BREW_PATH}/pip
     ln -s ${BREW_PATH}/python3 ${BREW_PATH}/python

    printf "# Done installing homebrew formulas\n"

    # Add sfdx
    printf "# Installing homebrew sfdx cask...\n"
    ${BREW_PATH}/brew install --cask sfdx
    sfdx plugins:install @oclif/plugin-autocomplete
    sfdx autocomplete
    printf "Done installing homebrew sfdx cask\n"

    # Set-up fonts
    printf "# Installing homebrew fonts cask...\n"
    ${BREW_PATH}/brew tap homebrew/cask-fonts
    ${BREW_PATH}/brew install cask font-hack-nerd-font
    /usr/bin/git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
    printf "Done installing homebrew fonts cask\n"
}

# pinentry - initializes necssary gnupg config to use pinentry-mac for gpg signing
pinentry() {
    printf "# Setting up gpg/gnupg...\n"
    mkdir ~/.gnupg
    chmod 700 ~/.gnupg
    echo "pinentry-program ${BREW_PATH}/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    ${BREW_PATH}/gpgconf --kill gpg-agent
    printf "Done setting up gpg/gnupg\n"
}

# ohmyzsh - installs ohmyzsh and other zsh plugins
ohmyzsh() {
    printf "# Installing oh-my-zsh...\n"
    export KEEP_ZSHRC=yes
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ${BREW_PATH}/git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ${BREW_PATH}/git clone https://github.com/Kallahan23/zsh-colorls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-colorls
    ${BREW_PATH}/git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
    ${BREW_PATH}/git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    ${BREW_PATH}/git clone https://github.com/denysdovhan/spaceship-prompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt --depth=1
    ln -s ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship.zsh-theme
    /opt/homebrew/opt/ruby/bin/gem install colorls
    printf "# Done installing oh-my-zsh\n"
}

# Creates directory for LaunchAgent that will check for homebrew updates
launchagent() {
    printf "# Setting up launchagent..."
    mkdir -p ~/Library/LaunchAgents
    cp ~/home/sync/homebrew.simonsimcity.update-notifier.plist ~/Library/LaunchAgents/homebrew.simonsimcity.update-notifier.plist
    launchctl load ~/Library/LaunchAgents/homebrew.simonsimcity.update-notifier.plist
    printf "Done setting up launchagent\n"
}

# usage - prints message for how to run this
usage() {
    echo "Usage: $0 <all|clone|setup_home|homebrew|formulas|pinentry|ohmyzsh|launchagent>"
    exit 1
}

# Either `all` can be used to run all functions or user can provide function name they want to run.
main() {

    local func=${1}
    if [ -z "${func}" ]
    then
        usage
    fi

    case ${func} in
        all)
            clone
            setup_home
            homebrew
            formulas
            pinentry
            ohmyzsh
            launchagent
            ssh_config
            ;;
        *)
            "${func}"
            ;;

    esac
}

main ${1}
