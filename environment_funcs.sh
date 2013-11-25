#!/bin/bash

VALID_ENVIRONMENTS=( home curve )

install_home() {
    make_link `pwd`/oh-my-zsh_custom/joel.zsh $HOME/.oh-my-zsh/custom/joel.zsh
}

install_curve() {
    make_link `pwd`/oh-my-zsh_custom/curve.zsh $HOME/.oh-my-zsh/custom/curve.zsh
}

process_environment() {
    for env in $VALID_ENVIRONMENTS
    do
        if [ $1 = $env ]; then
            install_$env
        fi
    done
}

