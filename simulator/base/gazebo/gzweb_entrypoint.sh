#!/bin/bash

# Problematic things...
# gzweb needs the model paths and the models before deploy
# gzweb model paths are not known at docker build time
# Some models only exist as a URDF so will need to be
#  "preprocessed" before gzweb deploy
# If running this from a launch script, the model paths
#  should be established

# Setup npm installation
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if [ ! -f GZWEB_DEPLOYED ]; then
    # Run the deploy script to build local models (skip build)
    npm run deploy --- -s -m local

    # The deploy script doesnt seem to copy the media files across.. without these
    # no gazebo standard materials work
    # Need to change this for looking up paths
    #cp -r /usr/share/gazebo-11/media /root/gzweb/http/client/assets/
    #cd /root/gzweb/http/client/assets/media/materials/textures \
    #    && for f in *jpg; do convert $f ${f%.*}.png; done

    touch GZWEB_DEPLOYED
fi

exec npm start