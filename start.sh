#!/bin/bash

set -e

# setup environment variables
WORKDIR=${WORKDIR:=~/mod-workdir}

export MOD_DEV_ENVIRONMENT=0
export MOD_LOG=1
export MOD_DEV_HOST=1

export MOD_IMAGE_VERSION_PATH="${PWD}/../../data/release"
export MOD_USER_FILES_DIR="${WORKDIR}/user-files"

# if coming through PawPaw, reset PATH
if [ -n "${OLD_PATH}" ]; then
    export PATH="${OLD_PATH}"
else
    export PATH="~/.local/bin:${PATH}"
fi

# check for pip3 tool
if ! command -v pip3 >/dev/null; then
    echo "pip3 tool not available, cannot continue"
    exit 1
fi

# install virtualenv as needed
if ! virtualenv --version 2>/dev/null; then
    pip3 install virtualenv
fi

# activate virtualenv
virtualenv modui-env
source modui-env/bin/activate

# install required mod-ui dependencies in virtualenv
pip3 install -r requirements.txt

make -C utils

# fix compatibility with python3.10+
if [ -e modui-env/lib/python3.10/site-packages/tornado/httputil.py ]; then
    sed -i -e 's/collections.MutableMapping/collections.abc.MutableMapping/' modui-env/lib/python3.10/site-packages/tornado/httputil.py
elif [ -e modui-env/lib/python3.11/site-packages/tornado/httputil.py ]; then
    sed -i -e 's/collections.MutableMapping/collections.abc.MutableMapping/' modui-env/lib/python3.11/site-packages/tornado/httputil.py
fi

# start mod-ui inside virtualenv
exec python3 ./server.py
