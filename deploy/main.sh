#!/bin/bash

# Read variables which are used in deploy process.
source /vagrant/deploy/variables.sh

# Initial database
source /vagrant/deploy/sections/init_database.sh

# Deploy application
source /vagrant/deploy/sections/set_workspace.sh
source /vagrant/deploy/sections/deploy_application.sh
source /vagrant/deploy/sections/add_libraries.sh