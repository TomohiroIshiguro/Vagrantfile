#!/bin/bash

# Set OS settings
source /vagrant/provision/sections/init_os_settings.sh

# Install utilities
source /vagrant/provision/sections/install_utilities.sh

# Install middlewares
source /vagrant/provision/sections/install_web_server.sh
source /vagrant/provision/sections/install_db_server.sh

# Install SDK to develop an application.
source /vagrant/provision/sections/install_sdk.sh