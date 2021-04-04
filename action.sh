#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Author: Azrim

SSH_KEY="${SSHKEY}"
SSHSTORE=ssh

setup() {
    mkdir -p $SSHSTORE 
    echo "${SSH_KEY}" >> $SSHSTORE/key
    chmod 400 $SSHSTORE/key
    eval "$(ssh-agent -s)"
    ssh-add $SSHSTORE/key
    git config --global user.mail "mirzaspc@gmail.com"
    git config --global user.name "azrim"
}

setup_github() {
    ssh -o StrictHostKeyChecking=no git@github.com
}

merge() {
    setup
    setup_github
    git clone git@github.com:silont-project/kernel_xiaomi_surya.git -b weekly surya && cd surya
    git fetch origin FBK
    git merge origin/FBK --no-edit
    git push
}

merge
