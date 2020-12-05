#!/bin/bash

set -eu

trap cleanup EXIT

#
##
update_system() {
    #
    apt update
    apt -yqq upgrade
}

#
##
install_base_system() {
    #
    apt -yqq install --no-install-recommends apt-utils 2>&1
    apt -yqq install --no-install-recommends apt-transport-https 2>&1
    #
    apt -yqq install build-essential curl lsb-release git procps 2>&1
    apt -yqq install net-tools nano htop iftop mariadb-client 2>&1
    #
    apt-get autoremove -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}

#
##
get_environment_file() {
    apt -yqq install wget
    wget https://raw.githubusercontent.com/deploy-script/node-js/master/.env
}

#
##
setup_environment() {
    # check .env file exists
    if [ ! -f .env ]; then
        get_environment_file
    fi

    # load env file
    set -o allexport
    source .env
    set +o allexport

    echo >&2 "Deploy-Script: [ENV]"
    echo >&2 "$(printenv)"
}

#
##
install_nvm() {
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" 
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    nvm install $NODE_VERSION
    
    npm i npm@latest -g
    
    npm install pm2 -g
}

#
##
cleanup() {
    #
    rm -f .env
    rm -f script.sh
}

#
##
main() {
    echo >&2 "Deploy-Script: [OS] $(uname -a)"

    #
    update_system
    
    #
    install_base_system

    #
    setup_environment

    #
    install_nvm

    #
    cleanup

    echo >&2 "Install completed"
}

# Check is root user
if [[ $EUID -ne 0 ]]; then
    echo "You must be root user to install scripts."
    sudo su
fi

main
