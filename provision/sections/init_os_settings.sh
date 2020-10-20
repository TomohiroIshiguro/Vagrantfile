#!/bin/bash

# ----------------------------------------
# Set timezone
# ----------------------------------------

sudo timedatectl set-timezone Asia/Tokyo

# ----------------------------------------
# Set SELinux
# ----------------------------------------

sudo setenforce 0
set cat <<-SELINUX > /etc/selinux/config
SELINUX=disabled
SELINUXTYPE=targeted
SELINUX