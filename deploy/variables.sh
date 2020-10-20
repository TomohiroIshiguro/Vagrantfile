#!/bin/bash

# ----------------------------------------
# Network configs
# ----------------------------------------

ip_address=192.168.33.1
domain_name=localDevEnv.vm

# ----------------------------------------
# Database configs
# ----------------------------------------

mysql_root_password=Root@000

# ----------------------------------------
# Application workspace
# ----------------------------------------

work_directory=/vagrant/mnt
app_folder=myApp

# ----------------------------------------
# Application code
# ----------------------------------------

github_user=
github_password=

repository_owner=
repository_name=
target_branch="-b develop"

repository_url=https://${github_user}:${github_password}@github.com/${repository_owner}/${repository_name}.git