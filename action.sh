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
    git config --global merge.log 3000
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
    tg_cast "<b>Triggering Weekly Build</b> @Hiitagiii"
}

# Telegram
CHATID="-1001362559368" # Group/channel chatid (use rose/userbot to get it)
TELEGRAM_TOKEN="${TG_TOKEN}"

# Export Telegram.sh
TELEGRAM_FOLDER="${HOME}"/telegram
if ! [ -d "${TELEGRAM_FOLDER}" ]; then
    git clone https://github.com/fabianonline/telegram.sh/ "${TELEGRAM_FOLDER}"
fi

TELEGRAM="${TELEGRAM_FOLDER}"/telegram
tg_cast() {
    "${TELEGRAM}" -t "${TELEGRAM_TOKEN}" -c "${CHATID}" -H \
    "$(
		for POST in "${@}"; do
			echo "${POST}"
		done
    )"
}

merge
