#!/usr/bin/env bash

### Description: Install AzuraCast
### OS: Ubuntu 22.04 LTS
### Run this script as root only
### mkdir /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && chmod +x install.sh && ./install.sh -i

##############################################################################
# AzuraCast Installer
##############################################################################

set -eu -o errexit -o pipefail -o noclobber -o nounset

! getopt --test >/dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo '`getopt --test` failed in this environment.'
    exit 1
fi

# Generate random passwords
mysql_root_pass=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

generate_azuracast_username=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

generate_azuracast_password=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

### Global Installer Options
# Installer Home
installerHome=$PWD

# Misc Options
set_php_version=8.1

# AzuraCast Database cant be custom. Migrate function does actually not respect different database names.
set_azuracast_database=azuracast
set_azuracast_username=$generate_azuracast_username
set_azuracast_password=$generate_azuracast_password

# Show AzuraCast and Installer Version
set_azuracast_version=0.17.6
set_installer_version=0.0.6

# Commands
LONGOPTS=help,version,upgrade,install,install_scyonly,upgrade_scyonly
OPTIONS=hvuixy

if [ "$#" -eq 0 ]; then
    echo "No options specified. Use --help to learn more."
    exit 1
fi

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

h=n v=n u=n i=n x=n y=n

while true; do
    case "$1" in
    -h | --help)
        h=y
        break
        ;;
    -v | --version)
        v=y
        shift
        ;;
    -u | --upgrade)
        u=y
        break
        ;;
    -i | --install)
        i=y
        break
        ;;
    -x | --install_scyonly)
        x=y
        break
        ;;
    -y | --upgrade_scyonly)
        y=y
        break
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Invalid option(s) specified. Use help(-h) to learn more."
        exit 3
        ;;
    esac
done

if [ "$(id -u)" -ne 0 ]; then
    echo 'This needs to be run as root.' >&2
    exit 1
fi

### Wait for APT: Not in use. Maybe better variant than -o DPkg::Lock::Timeout=-1
wait_for_apt_lock() {
    apt_lock=/var/lib/dpkg/lock-frontend
    if [ -f "$apt_lock" ]; then
        echo "$apt_lock exists. So lets wait a little bit."
        sleep 6
        # Start new
        wait_for_apt_lock
    else
        echo "$apt_lock not exists."
    fi
}

trap exit_handler EXIT

##############################################################################
# Invoked upon EXIT signal from bash
##############################################################################
function exit_handler() {
    if [ "$?" -ne 0 ]; then
        echo -en "\nSome error has occured. Check '$installerHome/azuracast_installer.log' for details.\n"
        #echo -en "\nThe current working directory: $PWD\n\n"
        exit 1
    fi
}

##############################################################################
# Setup Installer Logging
##############################################################################
function azuracast_installer_logging() {
    touch $installerHome/azuracast_installer.log
    LOG_FILE="$installerHome/azuracast_installer.log"
}

##############################################################################
# Print help (-h/--help)
##############################################################################
function azuracast_help() {
    cat <<EOF
---
Install and manage your AzuraCast installation.

Installation / Upgrade
  -i, --install             Install the latest stable version of AzuraCast
  -u, --upgrade             Upgrade to the latest stable version of AzuraCast
  -v, --version             Display version information
  -h, --help                Display this help text

Exit status:
Returns 0 if successful; non-zero otherwise.
---
EOF
}

##############################################################################
# Print version (-v/--version)
##############################################################################
function azuracast_version() {

    echo "---
Installer Version: $set_installer_version
Available AzuraCast Version: $set_azuracast_version"

    azv=/var/azuracast/www/src/Version.php
    if [ -f "$azv" ]; then
        FALLBACK_VERSION="$(grep -oE "\FALLBACK_VERSION = .*;" $azv | sed "s/FALLBACK_VERSION = '//g;s/';//g")"
        echo -en "Installed AzuraCast Version: $FALLBACK_VERSION \n\n"
    else
        echo -en "\nAzuraCast is actually not installed.\n---\n"
    fi
}

##############################################################################
# Install the latest stable version of AzuraCast (-i/--install)
##############################################################################
function azuracast_install() {
    azuracast_git_version="stable"

    export DEBIAN_FRONTEND=noninteractive

    # Options
    set_mariadb_version=10.9

    # Include source
    source install_default.sh
}

##############################################################################
# Upgrade an existing installation to latest stable version of AzuraCast (-u/--upgrade)
##############################################################################
function azuracast_upgrade() {
    echo "TODO: AzuraCast Upgrade"
    exit 0
    #source upgrade_default.sh
}

##############################################################################
# Do not Use! (-x/--install_scyonly)
##############################################################################
function azuracast_install_scyonly() {
    azuracast_git_version="blub"

    export DEBIAN_FRONTEND=noninteractive

    # Options
    set_mariadb_version=10.8

    # Include source
    source install_scyonly.sh
}

##############################################################################
# Do not Use! (-x/--upgrade_scyonly)
##############################################################################
function azuracast_upgrade_scyonly() {
    echo "TODO: AzuraCast Upgrade"
    exit 0
    #source upgrade_scyonly.sh
}

##############################################################################
# main function that handles the control flow
##############################################################################
function main() {
    azuracast_installer_logging

    if [ "$h" == "y" ]; then
        azuracast_help
    fi

    if [ "$v" == "y" ]; then
        azuracast_version
    fi

    if [ "$i" == "y" ]; then
        azuracast_install
    fi

    if [ "$u" == "y" ]; then
        azuracast_upgrade
    fi

    if [ "$x" == "y" ]; then
        azuracast_install_scyonly
    fi

    if [ "$y" == "y" ]; then
        azuracast_upgrade_scyonly
    fi

}

main "$@"
