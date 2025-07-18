#!/bin/sh
# shellcheck disable=SC2059 disable=SC2181 disable=SC2154 disable=SC2317 disable=SC2034
# virtualmin-install.sh
# Copyright 2005-2025 Virtualmin
# Simple script to install Virtualmin on a supported OS

# Different installation guides are available at:
# https://www.virtualmin.com/docs/installation/guides
####################################################################
# METADATA
####################################################################
# Name:
# Desc:
# Tags:
####################################################################
# License and version
SERIAL=GPL
KEY=GPL
VER=7.5.2
vm_version=7

# Server
download_virtualmin_host="${download_virtualmin_host:-software.virtualmin.com}"
download_virtualmin_host_lib="$download_virtualmin_host/lib"

# Save current working directory
pwd="$PWD"

# Script name
if [ "$0" = "--" ] || [ -z "$0" ]; then
  script_name="virtualmin-install.sh"
else
  script_name=$(basename -- "$0")
fi

# Set log type
log_file_name="${install_log_file_name:-virtualmin-install}"

# Set defaults
bundle='LAMP' # Other option is LEMP
mode='full'   # Other option is minimal
skipyesno=0

usage() {
  # shellcheck disable=SC2046
  echo
  printf "Usage: %s [options]\\n" "$(basename "$0")"
  echo
  echo "  If called without arguments, installs Virtualmin with default options."
  echo
  printf "  --bundle|-b <LAMP|LEMP>  choose bundle to install (defaults to LAMP)\\n"
  printf "  --minimal|-m             install a minimal package set for low-memory systems\\n"
  printf "  --unstable|-e            enable Grade B system support (see documentation)\\n"
  printf "  --module|-o              source custom shell module in post-install phase\\n"
  echo
  printf "  --hostname|-n            force hostname during installation\\n"
  printf "  --no-package-updates|-x  skip package updates during installation\\n"
  echo
  printf "  --setup|-s               reconfigure Virtualmin repos without installation\\n"
  printf "  --connect|-C <ipv4|ipv6> test connectivity to the repos without installation\\n"
  echo
  printf "  --insecure-downloads|-i  skip SSL certificate check for remote downloads\\n"
  echo
  printf "  --uninstall|-u           remove all Virtualmin packages and dependencies\\n"
  echo
  printf "  --force|-f|--yes|-y      assume \"yes\" to all prompts\\n"
  printf "  --force-reinstall|-fr    force reinstall Virtualmin (not recommended)\\n"
  printf "  --no-banner|-nb          suppress installation messages and warnings\\n"
  printf "  --verbose|-v             enable verbose mode\\n"
  printf "  --version|-V             show installer version\\n"
  printf "  --help|-h                show this help\\n"
  echo
}

# Bind hooks
bind_hook() {
    hook="$1"
    shift
    pre_hook="pre_hook__$hook"
    post_hook="post_hook__$hook"
    # Do we want to completely override the original function?
    if command -v "hook__$hook" > /dev/null 2>&1; then
        "hook__$hook" "$@"
    # Or do we want to run the original function wrapped by third-party functions?
    else
        if command -v "$pre_hook" > /dev/null 2>&1; then
            "$pre_hook" "$@"
        fi
        if command -v "$hook" > /dev/null 2>&1; then
            "$hook" "$@"
        fi
        if command -v "$post_hook" > /dev/null 2>&1; then
            "$post_hook" "$@"
        fi
    fi
}

test_connection() {
  input="$1"
  ip_version="$2"
  ip_version_nice=$(echo "$ip_version" | sed 's/ip/IP/')
  timeout=5
  http_protocol="http"
  http_protocol_nice=$(echo "$http_protocol" | tr '[:lower:]' '[:upper:]')

  # Setup colors for messages
  GREEN="" BLACK="" RED="" RESET="" BOLD="" GRBG="" REDBG=""
  if command -pv 'tput' > /dev/null; then
    GREEN=$(tput setaf 2)
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    RESET=$(tput sgr0)
    BOLD=$(tput bold)
    GRBG=$(tput setab 22; tput setaf 10)
    REDBG=$(tput setab 52; tput setaf 9)
  fi

  # Extract the domain from the input
  domain=$(echo "$input" | awk -F[/:] '{print $4}')
  [ -z "$domain" ] && domain="$input"

  # Validate parameters
  if [ -z "$domain" ] || [ -z "$ip_version" ]; then
    echo "${RED}[ERROR]  ${RESET} Domain and IP version are required" >&2
    return 1
  fi

  # Setup protocol-specific flags
  case "$ip_version" in
    ipv4)
      if ! getent ahostsv4 "$domain" >/dev/null 2>&1; then
        echo "${RED}[ERROR]  ${RESET} ${BOLD}$domain${RESET} — cannot find IPv4 address" >&2
        return 1
      fi
      ping_cmd="ping -c 1 -W $timeout $domain"
      http_cmd="curl -sS --ipv4 --max-time $timeout --head $http_protocol://$domain \
        || wget --spider -4 -T $timeout $http_protocol://$domain"
      ;;
    ipv6)
      if ! getent ahostsv6 "$domain" >/dev/null 2>&1; then
        echo "${RED}[ERROR]  ${RESET} ${BOLD}$domain${RESET} — cannot find IPv6 address" >&2
        return 1
      fi
      ping_cmd="ping6 -c 1 -W $timeout $domain"
      http_cmd="curl -sS --ipv6 --max-time $timeout --head $http_protocol://$domain \
        || wget --spider -6 -T $timeout $http_protocol://$domain"
      ;;
  esac

  # Try ping first
  if eval "$ping_cmd" >/dev/null 2>&1; then
    echo "${GREEN}[SUCCESS]${RESET} ${GRBG}[$ip_version_nice]${RESET} ${GRBG}[ICMP]${RESET} ${BOLD}$domain${RESET}"
  else
    echo "${RED}[ERROR]  ${RESET} ${REDBG}[$ip_version_nice]${RESET} ${REDBG}[ICMP]${RESET} ${BOLD}$domain${RESET}"
  fi

  # HTTP test as well
  if command -v 'curl' > /dev/null || command -v 'wget' > /dev/null; then
    if eval "$http_cmd" >/dev/null 2>&1; then
      echo "${GREEN}[SUCCESS]${RESET} ${GRBG}[$ip_version_nice]${RESET} ${GRBG}[$http_protocol_nice]${RESET} ${BOLD}$domain${RESET}"
      return 0
    else
      echo "${RED}[ERROR]  ${RESET} ${REDBG}[$ip_version_nice]${RESET} ${REDBG}[$http_protocol_nice]${RESET} ${BOLD}$domain${RESET}"
      return 1
    fi
  fi
}

# Default function to parse arguments
parse_args() {
  while [ "$1" != "" ]; do
    case $1 in
    --help | -h)
      bind_hook "usage"
      exit 0
      ;;
    --bundle | -b)
      shift
      case "$1" in
      LAMP)
        shift
        bundle='LAMP'
        ;;
      LEMP)
        shift
        bundle='LEMP'
        ;;
      *)
        printf "Unknown bundle $1: exiting\\n"
        exit 1
        ;;
      esac
      ;;
    --minimal | -m)
      shift
      mode='minimal'
      ;;
    --insecure-downloads | -i)
      shift
      insecure_download_wget_flag=' --no-check-certificate'
      insecure_download_curl_flag=' -k'
      ;;
    --no-package-updates | -x)
      shift
      noupdates=1
      ;;
    --setup | -s)
      shift
      setup_only=1
      mode='setup'
      unstable='unstable'
      log_file_name="${setup_log_file_name:-virtualmin-repos-setup}"
      ;;
    --connect | -C)
      shift
      if [ -z "$1" ]; then
        test_connection "$download_virtualmin_host" "ipv4"
        test_connection "$download_virtualmin_host" "ipv6"
        exit 0
      else
        if [ "$1" != "ipv4" ] && [ "$1" != "ipv6" ]; then
          usage
          exit 1
        fi
        test_connection "$download_virtualmin_host" "$1"
        exit 0
      fi
      ;;
    --unstable | -e)
      shift
      unstable='unstable'
      virtualmin_config_system_excludes=""
      virtualmin_stack_custom_packages=""
      ;;
    --module | -o)
      shift
      module_name=$1
      shift
      ;;
    --hostname | -n)
      shift
      forcehostname=$1
      shift
      ;;
    --force | -f | --yes | -y)
      shift
      skipyesno=1
      ;;
    --force-reinstall | -fr)
      shift
      forcereinstall=1
      ;;
    --no-banner | -nb)
      shift
      skipbanner=1
      ;;
    --verbose | -v)
      shift
      VERBOSE=1
      ;;
    --version | -V)
      shift
      showversion=1
      ;;
    --uninstall | -u)
      shift
      mode="uninstall"
      log_file_name="${uninstall_log_file_name:-virtualmin-uninstall}"
      ;;
    *)
      printf "Unrecognized option: $1\\n"
      bind_hook "usage"
      exit 1
      ;;
    esac
  done
}

# Hook arguments
bind_hook "parse_args" "$@"

# Default function to show installer version
show_version() {
  echo "$VER"
  exit 0
}

# Hook version
if [ -n "$showversion" ]; then
  bind_hook "show_version"
fi

# Force setup mode, if script name is `setup-repos.sh` as it
# is used by Virtualmin API, to make sure users won't run an
# actuall install script under any circumstances
if [ "$script_name" = "setup-repos.sh" ]; then
  setup_only=1
  mode='setup'
  unstable='unstable'
fi

# Store new log each time
log="$pwd/$log_file_name.log"
if [ -e "$log" ]; then
  while true; do
    logcnt=$((logcnt+1))
    logold="$log.$logcnt"
    if [ ! -e "$logold" ]; then
      mv "$log" "$logold"
      break
    fi
  done
fi

# If Pro user downloads GPL version of `install.sh` script
# to fix repos check if there is an active license exists
if [ -n "$setup_only" ]; then
  if [ "$SERIAL" = "GPL" ] && [ "$KEY" = "GPL" ] && [ -f /etc/virtualmin-license ]; then
    virtualmin_license_existing_serial="$(grep 'SerialNumber=' /etc/virtualmin-license | sed 's/SerialNumber=//')"
    virtualmin_license_existing_key="$(grep 'LicenseKey=' /etc/virtualmin-license | sed 's/LicenseKey=//')"
    if [ -n "$virtualmin_license_existing_serial" ] && [ -n "$virtualmin_license_existing_key" ]; then
      SERIAL="$virtualmin_license_existing_serial"
      KEY="$virtualmin_license_existing_key"
    fi
  fi
fi

arch="$(uname -m)"
if [ "$arch" = "i686" ]; then
  arch="i386"
fi
if [ "$SERIAL" = "GPL" ]; then
  LOGIN=""
  PRODUCT="GPL"
  repopath="gpl/"
  packagetype="gpl"
else
  LOGIN="$SERIAL:$KEY@"
  PRODUCT="Professional"
  packagetype="pro"
  repopath="pro/"
fi

# Virtualmin-provided packages
vmgroup="'Virtualmin Core'"
vmgrouptext="Virtualmin $vm_version provided packages"
debvmpackages="virtualmin-core"
deps=

if [ "$mode" = 'full' ]; then
  if [ "$bundle" = 'LAMP' ]; then
    rhgroup="'Virtualmin LAMP Stack'"
    rhgrouptext="Virtualmin $vm_version LAMP stack"
    debdeps="virtualmin-lamp-stack"
    ubudeps="virtualmin-lamp-stack"
  elif [ "$bundle" = 'LEMP' ]; then
    rhgroup="'Virtualmin LEMP Stack'"
    rhgrouptext="Virtualmin $vm_version LEMP stack"
    debdeps="virtualmin-lemp-stack"
    ubudeps="virtualmin-lemp-stack"
  fi
elif [ "$mode" = 'minimal' ]; then
  if [ "$bundle" = 'LAMP' ]; then
    rhgroup="'Virtualmin LAMP Stack Minimal'"
    rhgrouptext="Virtualmin $vm_version LAMP stack minimal"
    debdeps="virtualmin-lamp-stack-minimal"
    ubudeps="virtualmin-lamp-stack-minimal"
  elif [ "$bundle" = 'LEMP' ]; then
    rhgroup="'Virtualmin LEMP Stack Minimal'"
    rhgrouptext="Virtualmin $vm_version LEMP stack minimal'"
    debdeps="virtualmin-lemp-stack-minimal"
    ubudeps="virtualmin-lemp-stack-minimal"
  fi
fi

# Find temp directory
if [ -z "$TMPDIR" ]; then
  TMPDIR=/tmp
fi

# Check whether $TMPDIR is mounted noexec (everything will fail, if so)
# XXX: This check is imperfect. If $TMPDIR is a full path, but the parent dir
# is mounted noexec, this won't catch it.
TMPNOEXEC="$(grep "$TMPDIR" /etc/mtab | grep noexec)"
if [ -n "$TMPNOEXEC" ]; then
  echo "Error: $TMPDIR directory is mounted noexec. Cannot continue."
  exit 1
fi

if [ -z "$VIRTUALMIN_INSTALL_TEMPDIR" ]; then
  VIRTUALMIN_INSTALL_TEMPDIR="$TMPDIR/.virtualmin-$$"
  if [ -e "$VIRTUALMIN_INSTALL_TEMPDIR" ]; then
    rm -rf "$VIRTUALMIN_INSTALL_TEMPDIR"
  fi
  mkdir "$VIRTUALMIN_INSTALL_TEMPDIR"
fi

# Export temp directory for Virtualmin Config
export VIRTUALMIN_INSTALL_TEMPDIR

# "files" subdir for libs
mkdir "$VIRTUALMIN_INSTALL_TEMPDIR/files"
srcdir="$VIRTUALMIN_INSTALL_TEMPDIR/files"

# Switch to temp directory or exit with error
goto_tmpdir() {
  if ! cd "$srcdir" >>"$log" 2>&1; then
    echo "Error: Failed to enter $srcdir temporary directory"
    exit 1
  fi
}
goto_tmpdir

pre_check_http_client() {
  # Check for wget or curl or fetch
  printf "Checking for HTTP client .." >>"$log"
  while true; do
    if [ -x "/usr/bin/wget" ]; then
      download="/usr/bin/wget -nv$insecure_download_wget_flag"
      break
    elif [ -x "/usr/bin/curl" ]; then
      download="/usr/bin/curl -f$insecure_download_curl_flag -s -L -O"
      break
    elif [ -x "/usr/bin/fetch" ]; then
      download="/usr/bin/fetch"
      break
    elif [ "$wget_attempted" = 1 ]; then
      printf " error: No HTTP client available. The installation of a download command has failed. Cannot continue.\\n" >>"$log"
      return 1
    fi

    # Made it here without finding a downloader, so try to install one
    wget_attempted=1
    if [ -x /usr/bin/dnf ]; then
      dnf -y install wget >>"$log"
    elif [ -x /usr/bin/yum ]; then
      yum -y install wget >>"$log"
    elif [ -x /usr/bin/apt-get ]; then
      apt-get update >>/dev/null
      apt-get -y -q install wget >>"$log"
    fi
  done
  if [ -z "$download" ]; then
    printf " not found\\n" >>"$log"
    return 1
  else
    printf " found %s\\n" "$download" >>"$log"
    return 0;
  fi
}

download_slib() {
  # If slib.sh is available locally in the same directory use it
  if [ -f "$pwd/slib.sh" ]; then
    chmod +x "$pwd/slib.sh"
    # shellcheck disable=SC1091
    . "$pwd/slib.sh"
  # Download the slib (source: http://github.com/virtualmin/slib)
  else
    # We need HTTP client first
    pre_check_http_client
    $download "https://$download_virtualmin_host_lib/slib.sh" >>"$log" 2>&1
    if [ $? -ne 0 ]; then
      echo "Error: Failed to download utility function library. Cannot continue. Check your network connection and DNS settings, and verify that your system's time is accurately synchronized."
      exit 1
    fi
    chmod +x slib.sh
    # shellcheck disable=SC1091
    . ./slib.sh
  fi
}

# Check if already installed successfully
already_installed_block() {
  log_error "Your system already has a successful Virtualmin installation deployed."
  log_error "Re-installation is neither possible nor necessary. This script must be"
  log_error "run on a freshly installed supported operating system. It does not fit"
  log_error "for package updates or license changes. For further assistance, please"
  log_error "visit the Virtualmin Community forum."
  exit 100
}

# Utility function library
##########################################
download_slib # for production this block
              # can be replaces with the
              # content of slib.sh file,
              # minus its header
##########################################

# Get OS type
get_distro

# Check the serial number and key
serial_ok "$SERIAL" "$KEY"
# Setup slog
LOG_PATH="$log"
# Setup run_ok
RUN_LOG="$log"
# Exit on any failure during shell stage
RUN_ERRORS_FATAL=1

# Console output level; ignore debug level messages.
if [ "$VERBOSE" = "1" ]; then
  LOG_LEVEL_STDOUT="DEBUG"
else
  LOG_LEVEL_STDOUT="INFO"
fi
# Log file output level; catch literally everything.
LOG_LEVEL_LOG="DEBUG"

# If already installed successfully, do not allow running again
if [ -f "/etc/webmin/virtual-server/installed-auto" ] &&
   [ -z "$setup_only" ] && [ -z "$forcereinstall" ] &&
   [ "$mode" != "uninstall" ]; then
  bind_hook "already_installed_block"
fi
if [ -n "$setup_only" ]; then
  log_info "Setup log is written to $LOG_PATH"
elif [ "$mode" = "uninstall" ]; then
  log_info "Uninstallation log is written to $LOG_PATH"
else
  log_info "Installation log is written to $LOG_PATH"
fi
log_debug "LOG_ERRORS_FATAL=$RUN_ERRORS_FATAL"
log_debug "LOG_LEVEL_STDOUT=$LOG_LEVEL_STDOUT"
log_debug "LOG_LEVEL_LOG=$LOG_LEVEL_LOG"

# log_fatal calls log_error
log_fatal() {
  log_error "$1"
}

# Test if grade B system
grade_b_system() {
  case "$os_type" in
    rhel | centos | rocky | almalinux | debian)
      return 1
      ;;
    ubuntu)
      case "$os_version" in
        *\.10|*[13579].04) # non-LTS versions are unstable
          return 0
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    *)
      return 0
      ;;
  esac
}

if grade_b_system && [ "$unstable" != 'unstable' ]; then
  log_error "Unsupported operating system detected. You may be able to install with"
  log_error "${BOLD}--unstable${NORMAL} flag, but this is not recommended. Consult the installation"
  log_error "documentation."
  exit 1
fi

remove_virtualmin_release() {
  case "$os_type" in
  rhel | fedora | centos | centos_stream | rocky | almalinux | openEuler | ol | cloudlinux | amzn )
    rm -f /etc/yum.repos.d/virtualmin.repo
    rm -f /etc/pki/rpm-gpg/RPM-GPG-KEY-virtualmin*
    rm -f /etc/pki/rpm-gpg/RPM-GPG-KEY-webmin
    ;;
  debian | ubuntu | kali)
    grep -v "virtualmin" /etc/apt/sources.list >"$VIRTUALMIN_INSTALL_TEMPDIR"/sources.list
    mv "$VIRTUALMIN_INSTALL_TEMPDIR"/sources.list /etc/apt/sources.list
    rm -f /etc/apt/sources.list.d/virtualmin.list
    rm -f /etc/apt/auth.conf.d/virtualmin.conf
    rm -f /usr/share/keyrings/debian-virtualmin*
    rm -f /usr/share/keyrings/debian-webmin
    rm -f /usr/share/keyrings/ubuntu-virtualmin*
    rm -f /usr/share/keyrings/ubuntu-webmin
    rm -f /usr/share/keyrings/kali-virtualmin*
    rm -f /usr/share/keyrings/kali-webmin
    ;;
  esac
}

fatal() {
  echo
  log_fatal "Fatal Error Occurred: $1"
  printf "${RED}Cannot continue installation.${NORMAL}\\n"
  remove_virtualmin_release
  if [ -x "$VIRTUALMIN_INSTALL_TEMPDIR" ]; then
    log_warning "Removing temporary directory and files."
    rm -rf "$VIRTUALMIN_INSTALL_TEMPDIR"
  fi
  log_fatal "If you are unsure of what went wrong, you may wish to review the log"
  log_fatal "in $log"
  exit 1
}

success() {
  log_success "$1 Succeeded."
}

# Function to find out if some services were pre-installed
is_preconfigured() {
  preconfigured=""
  if named -v 1>/dev/null 2>&1; then
    preconfigured="${preconfigured}${YELLOW}${BOLD}BIND${NORMAL} "
  fi
  if apachectl -v 1>/dev/null 2>&1; then
    preconfigured="${preconfigured}${YELLOW}${BOLD}Apache${NORMAL} "
  fi
  if nginx -v 1>/dev/null 2>&1; then
    preconfigured="${preconfigured}${YELLOW}${BOLD}Nginx${NORMAL} "
  fi
  if command -pv mariadb 1>/dev/null 2>&1; then
    preconfigured="${preconfigured}${YELLOW}${BOLD}MariaDB${NORMAL} "
  fi
  if postconf mail_version 1>/dev/null 2>&1; then
    preconfigured="${preconfigured}${YELLOW}${BOLD}Postfix${NORMAL} "
  fi
  if php -v 1>/dev/null 2>&1; then
    preconfigured="${preconfigured}${YELLOW}${BOLD}PHP${NORMAL} "
  fi
  preconfigured=$(echo "$preconfigured" | sed 's/ /, /g' | sed 's/, $/ /')
  echo "$preconfigured"
}

# Function to find out if Virtualmin is already installed, so we can get
# rid of some of the warning message. Nobody reads it, and frequently
# folks run the install script on a production system; either to attempt
# to upgrade, or to "fix" something. That's never the right thing.
is_installed() {
  if [ -f /etc/virtualmin-license ]; then
    # looks like it's been installed before
    return 0
  fi
  # XXX Probably not installed? Maybe we should remove license on uninstall, too.
  return 1
}

# This function performs a rough uninstallation of Virtualmin
# all related packages and configurations
uninstall() {
  log_debug "Initiating Virtualmin uninstallation procedure"
  log_debug "Operating system name:    $os_real"
  log_debug "Operating system version: $os_version"
  log_debug "Operating system type:    $os_type"
  log_debug "Operating system major:   $os_major_version"

  if [ "$skipyesno" -ne 1 ]; then
    echo
    printf "  ${REDBG}WARNING${NORMAL}\\n"
    echo
    echo "  This operation is highly disruptive and cannot be undone. It removes all of"
    echo "  the packages and configuration files installed by the Virtualmin installer."
    echo
    echo "  It must never be executed on a live production system."
    echo
    printf " ${RED}Uninstall?${NORMAL} (y/N) "
    if ! yesno; then
      exit
    fi
  fi

  # Always sleep just a bit in case the user changes their mind
  sleep 3

  # Go to the temp directory
  goto_tmpdir

  # Uninstall packages
  uninstall_packages()
  {
    # Detect the package manager
    case "$os_type" in
    rhel | fedora | centos | centos_stream | rocky | almalinux | openEuler | ol | cloudlinux | amzn )
      package_type=rpm
      if command -pv dnf 1>/dev/null 2>&1; then
        uninstall_cmd="dnf remove -y"
        uninstall_cmd_group="dnf groupremove -y"
      else
        uninstall_cmd="yum remove -y"
        uninstall_cmd_group="yum groupremove -y"
      fi
      ;;
    debian | ubuntu | kali)
      package_type=deb
      uninstall_cmd="apt-get remove --assume-yes --purge"
      ;;
    esac

    case "$package_type" in
    rpm)
      $uninstall_cmd_group "Virtualmin Core" "Virtualmin LAMP Stack" "Virtualmin LEMP Stack" "Virtualmin LAMP Stack Minimal" "Virtualmin LEMP Stack Minimal"
      $uninstall_cmd wbm-* wbt-* webmin* usermin* virtualmin*
      os_type="rhel"
      return 0
      ;;
    deb)
      $uninstall_cmd "virtualmin*" "webmin*" "usermin*"
      uninstall_cmd_auto="apt-get autoremove --assume-yes"
      $uninstall_cmd_auto
      os_type="debian"
      return 0
      ;;
    *)
      log_error "Unknown package manager, cannot uninstall"
      return 1
      ;;
    esac
  }

  # Uninstall repos and helper command
  uninstall_repos()
  {
    echo "Removing Virtualmin $vm_version repo configuration"
    remove_virtualmin_release
    virtualmin_license_file="/etc/virtualmin-license"
    if [ -f "$virtualmin_license_file" ]; then
      echo "Removing Virtualmin license"
      rm "$virtualmin_license_file"
    fi

    echo "Removing Virtualmin helper command"
    rm "/usr/sbin/virtualmin"
    echo "Virtualmin uninstallation complete."
  }

  phase_number=${phase_number:-1}
  phases_total=${phases_total:-1}
  uninstall_phase_description=${uninstall_phase_description:-"Uninstall"}
  echo
  phase "$uninstall_phase_description" "$phase_number"
  run_ok "uninstall_packages" "Uninstalling Virtualmin $vm_version and all stack packages"
  run_ok "uninstall_repos" "Uninstalling Virtualmin $vm_version release package"
}

# Phase control
phase() {
    phases_total="${phases_total:-4}"
    phase_description="$1"
    phase_number="$2"
    # Print completed phases (green)
    printf "${GREEN}"
    for i in $(seq 1 $(( phase_number - 1 ))); do
        printf "▣"
    done
    # Print current phase (yellow)
    printf "${YELLOW}▣"
    # Print remaining phases (cyan)
    for i in $(seq $(( phase_number + 1 )) "$phases_total"); do
        printf "${CYAN}◻"
    done
    log_debug "Phase ${phase_number} of ${phases_total}: ${phase_description}"
    printf "${NORMAL} Phase ${YELLOW}${phase_number}${NORMAL} of ${GREEN}${phases_total}${NORMAL}: ${phase_description}\\n"
}

if [ "$mode" = "uninstall" ]; then
  bind_hook "uninstall"
  exit 0
fi

# Calculate disk space requirements (this is a guess, for now)
if [ "$mode" = 'minimal' ]; then
  disk_space_required=1
else
  disk_space_required=2
fi

# Message to display in interactive mode
install_msg() {
  supported="    ${CYANBG}${BLACK}${BOLD}Red Hat Enterprise Linux and derivatives${NORMAL}${CYAN}
      - RHEL 8 and 9 on x86_64
      - Alma and Rocky 8 and 9 on x86_64
      - CentOS 7 on x86_64${NORMAL}
      UNSTABLERHEL
    ${CYANBG}${BLACK}${BOLD}Debian Linux and derivatives${NORMAL}${CYAN}
      - Debian 10, 11 and 12 on i386 and amd64
      - Ubuntu 20.04 LTS, 22.04 LTS and 24.04 LTS on i386 and amd64${NORMAL}
      UNSTABLEDEB"

  cat <<EOF

  Welcome to the Virtualmin ${GREEN}$PRODUCT${NORMAL} installer, version ${GREEN}$VER${NORMAL}

  This script must be run on a freshly installed supported OS. It does not
  perform updates or upgrades (use your system package manager) or license
  changes (use the "virtualmin change-license" command).

  The systems currently supported by the install script are:

EOF
  supported_all=$supported
  if [ -n "$unstable" ]; then
    unstable_rhel="${YELLOW}- Fedora Server 40 and above on x86_64\\n \
     - CentOS Stream 8 and 9 on x86_64\\n \
     - Amazon Linux 2023 and above on x86_64\\n \
     - Oracle Linux 8 and 9 on x86_64\\n \
     - CloudLinux 8 and 9 on x86_64\\n \
     - openEuler 24.03 and above on x86_64\\n \
          ${NORMAL}"
    unstable_deb="${YELLOW}- Kali Linux Rolling 2023 and above on x86_64\\n \
     - Ubuntu interim (non-LTS) on i386 and amd64\\n \
          ${NORMAL}"
    supported_all=$(echo "$supported_all" | sed "s/UNSTABLERHEL/$unstable_rhel/")
    supported_all=$(echo "$supported_all" | sed "s/UNSTABLEDEB/$unstable_deb/")
  else
    supported_all=$(echo "$supported_all" | sed 's/UNSTABLERHEL//')
    supported_all=$(echo "$supported_all" | sed 's/UNSTABLEDEB//')
  fi
  echo "$supported_all"
  cat <<EOF
  If your OS/version/arch is not listed, installation ${BOLD}${RED}will fail${NORMAL}. More
  details about the systems supported by the script can be found here:

    ${UNDERLINE}https://www.virtualmin.com/os-support${NORMAL}

  The selected package bundle is ${CYAN}${bundle}${NORMAL} and the size of install is
  ${CYAN}${mode}${NORMAL}. It will require up to ${CYAN}${disk_space_required} GB${NORMAL} of disk space.

EOF

  if [ "$skipyesno" -ne 1 ]; then
  cat <<EOF
  Exit and re-run this script with ${CYAN}--help${NORMAL} flag to see available options.

EOF
  fi
  if [ "$skipyesno" -ne 1 ]; then
    printf " Continue? (y/n) "
    if ! yesno; then
      exit
    fi
  fi
}

if [ -z "$setup_only" ] && [ -z "$skipbanner" ]; then
    bind_hook "install_msg"
fi

os_unstable_pre_check() {
  if [ -n "$unstable" ]; then
    cat <<EOF

  ${YELLOWBG}${BLACK}${BOLD} INSTALLATION WARNING! ${NORMAL}

  You are about to install Virtualmin $PRODUCT on a ${BOLD}Grade B${NORMAL} operating
  system. Be advised that this OS version is not recommended for servers,
  and may have bugs that could affect the performance and stability of
  the system.

  Certain features may not work as intended or might be unavailable on
  this OS.

EOF
    if [ "$skipyesno" -ne 1 ]; then
      printf " Continue? (y/n) "
      if ! yesno; then
        exit
      fi
    fi
  fi
}

preconfigured_system_msg() {
  # Double check if installed, just in case above error ignored.
  is_preconfigured_rs=$(is_preconfigured)
  if [ -n "$is_preconfigured_rs" ]; then
    cat <<EOF

  ${WHITEBG}${RED}${BOLD} ATTENTION! ${NORMAL}

  Pre-installed software detected: $is_preconfigured_rs

  It is highly advised ${BOLD}${RED}not to pre-install${NORMAL} any additional packages on your
  OS. The installer expects a freshly installed OS, and anything you do
  differently might cause conflicts or configuration errors. If you need
  to enable third-party package repositories, do so after installation
  of Virtualmin, and only with extreme caution.

EOF
    if [ "$skipyesno" -ne 1 ]; then
      printf " Continue? (y/n) "
      if ! yesno; then
        exit
      fi
    fi
  fi
}

already_installed_msg() {
  # Double check if installed, just in case above error ignored.
  if is_installed; then
    cat <<EOF

  ${WHITEBG}${RED}${BOLD} WARNING! ${NORMAL}

  Virtualmin may already be installed. This can happen if an installation
  failed, and can be ignored in that case.

  However, if Virtualmin has already been successfully installed you
  ${BOLD}${RED}must not${NORMAL} run this script again! It will cause breakage to your
  existing configuration.

  Virtualmin repositories can be fixed using ${WHITEBG}${BLACK}${BOLD}$script_name --setup${NORMAL}
  command.

  License can be changed using ${WHITEBG}${BLACK}${BOLD}virtualmin change-license${NORMAL} command.
  Changing the license never requires re-installation.

  Updates and upgrades must be performed from within either Virtualmin or
  using system package manager on the command line.

EOF
    if [ "$skipyesno" -ne 1 ]; then
      printf " Continue? (y/n) "
      if ! yesno; then
        exit
      fi
    fi
  fi
}

post_install_message() {
  log_success "Installation Complete!"
  log_success "If there were no errors above, Virtualmin should be ready"
  log_success "to configure at https://${hostname}:10000 (or https://${address}:10000)."
  if [ -z "$ssl_host_success" ]; then
    log_success "You may receive a security warning in your browser on your first visit."
  fi
}

if [ -z "$setup_only" ] && [ -z "$skipbanner" ]; then
  if grade_b_system; then
    bind_hook "os_unstable_pre_check"
  fi
  bind_hook "preconfigured_system_msg"
  bind_hook "already_installed_msg"
fi

# Check memory
if [ "$mode" = "full" ]; then
  minimum_memory=1610613
else
  # minimal mode probably needs less memory to succeed
  minimum_memory=1048576
fi
if ! memory_ok "$minimum_memory" "$disk_space_required"; then
  log_fatal "Too little memory, and unable to create a swap file. Consider adding swap"
  log_fatal "or more RAM to your system."
  exit 1
fi

# Check for localhost in /etc/hosts
if [ -z "$setup_only" ]; then
  grep localhost /etc/hosts >/dev/null
  if [ "$?" != 0 ]; then
    log_warning "There is no localhost entry in /etc/hosts. This is required, so one will be added."
    run_ok "echo 127.0.0.1 localhost >> /etc/hosts" "Editing /etc/hosts"
    if [ "$?" -ne 0 ]; then
      log_error "Failed to configure a localhost entry in /etc/hosts."
      log_error "This may cause problems, but we'll try to continue."
    fi
  fi
fi

pre_check_system_time() {
  # Check if current time
  # is not older than
  # Wed Dec 01 2022
  printf "Syncing system time ..\\n" >>"$log"
  TIMEBASE=1669888800
  TIME=$(date +%s)
  if [ "$TIME" -lt "$TIMEBASE" ]; then

    # Try to sync time automatically first
    if systemctl restart chronyd 1>/dev/null 2>&1; then
      sleep 30
    elif systemctl restart systemd-timesyncd 1>/dev/null 2>&1; then
      sleep 30
    fi

    # Check again after all
    TIME=$(date +%s)
    if [ "$TIME" -lt "$TIMEBASE" ]; then
      printf ".. failed to automatically sync system time; it should be corrected manually to continue\\n" >>"$log"
      return 1;
    fi
  # Graceful sync
  else
    if systemctl restart chronyd 1>/dev/null 2>&1; then
      sleep 10
    elif systemctl restart systemd-timesyncd 1>/dev/null 2>&1; then
      sleep 10
    fi
  fi
  printf ".. done\\n" >>"$log"
  return 0
}

pre_check_ca_certificates() {
  printf "Checking for an update for a set of CA certificates ..\\n" >>"$log"
  if [ -x /usr/bin/dnf ]; then
    dnf -y update ca-certificates >>"$log" 2>&1
  elif [ -x /usr/bin/yum ]; then
    yum -y update ca-certificates >>"$log" 2>&1
  elif [ -x /usr/bin/apt-get ]; then
    apt-get -y install ca-certificates >>"$log" 2>&1
  fi
  res=$?
  printf ".. done\\n" >>"$log"
  return "$res"
}

pre_check_perl() {
  printf "Checking for Perl .." >>"$log"
  # loop until we've got a Perl or until we can't try any more
  while true; do
    perl="$(command -pv perl 2>/dev/null)"
    if [ -z "$perl" ]; then
      if [ -x /usr/bin/perl ]; then
        perl=/usr/bin/perl
        break
      elif [ -x /usr/local/bin/perl ]; then
        perl=/usr/local/bin/perl
        break
      elif [ -x /opt/csw/bin/perl ]; then
        perl=/opt/csw/bin/perl
        break
      elif [ "$perl_attempted" = 1 ]; then
        printf ".. Perl could not be installed. Cannot continue\\n" >>"$log"
        return 1
      fi
      # couldn't find Perl, so we need to try to install it
      if [ -x /usr/bin/dnf ]; then
        dnf -y install perl >>"$log" 2>&1
      elif [ -x /usr/bin/yum ]; then
        yum -y install perl >>"$log" 2>&1
      elif [ -x /usr/bin/apt-get ]; then
        apt-get update >>"$log" 2>&1
        apt-get -q -y install perl >>"$log" 2>&1
      fi
      perl_attempted=1
      # Loop. Next loop should either break or exit.
    else
      break
    fi
  done
  printf ".. found Perl at $perl\\n" >>"$log"
  return 0
}

pre_check_gpg() {
  if [ -x /usr/bin/apt-get ]; then
    printf "Checking for GPG .." >>"$log"
    if [ ! -x /usr/bin/gpg ]; then
      printf " not found, attempting to install .." >>"$log"
      apt-get update >>/dev/null
      apt-get -y -q install gnupg >>"$log"
      printf " finished : $?\\n" >>"$log"
    else
      printf " found GPG command\\n" >>"$log"
    fi
  fi
}

pre_check_all() {

  if [ -z "$setup_only" ]; then
    # Check system time
    run_ok pre_check_system_time "Checking system time"

    # Make sure Perl is installed
    run_ok pre_check_perl "Checking Perl installation"

    # Update CA certificates package
    run_ok pre_check_ca_certificates "Checking CA certificates package"
  else
    # Make sure Perl is installed
    run_ok pre_check_perl "Checking Perl installation"
  fi

  # Checking for HTTP client
  run_ok pre_check_http_client "Checking HTTP client"

  # Check for gpg, debian 10 doesn't install by default!?
  run_ok pre_check_gpg "Checking GPG package"
}

# download()
# Use $download to download the provided filename or exit with an error.
download() {
  # XXX Check this to make sure run_ok is doing the right thing.
  # Especially make sure failure gets logged right.
  # awk magic prints the filename, rather than whole URL
  export download_file
  download_file=$(echo "$1" | awk -F/ '{print $NF}')
  run_ok "$download $1" "$2"
  if [ $? -ne 0 ]; then
    fatal "Failed to download Virtualmin release package. Cannot continue. Check your network connection and DNS settings, and verify that your system's time is accurately synchronized."
  else
    return 0
  fi
}

# Only root can run this
if [ "$(id -u)" -ne 0 ]; then
  uname -a | grep -i CYGWIN >/dev/null
  if [ "$?" != "0" ]; then
    fatal "${RED}Fatal:${NORMAL} The Virtualmin install script must be run as root"
  fi
fi

bind_hook "phases_all_pre"

if [ -n "$setup_only" ]; then
  pre_check_perl
  pre_check_http_client
  pre_check_gpg
  log_info "Started Virtualmin $vm_version $PRODUCT software repositories setup"
else
  echo
  phase "Check" 1
  bind_hook "phase1_pre"
  pre_check_all
  bind_hook "phase1_post"
  echo

  phase "Setup" 2
  bind_hook "phase2_pre"
fi

# Print out some details that we gather before logging existed
log_debug "Install mode: $mode"
log_debug "Product: Virtualmin $PRODUCT"
log_debug "virtualmin-install.sh version: $VER"

# Check for a fully qualified hostname
if [ -z "$setup_only" ]; then
  log_debug "Checking for fully qualified hostname .."
  name="$(hostname -f)"
  if [ $? -ne 0 ]; then
    name=$(hostnamectl --static)
  fi
  if [ -n "$forcehostname" ]; then
    set_hostname "$forcehostname"
  elif ! is_fully_qualified "$name"; then
    set_hostname
  else
    # Hostname is already FQDN, yet still set it
    # again to make sure to have it updated everywhere
    set_hostname "$name"
  fi
fi

# Insert the serial number and password into /etc/virtualmin-license
log_debug "Installing serial number and license key into /etc/virtualmin-license"
echo "SerialNumber=$SERIAL" >/etc/virtualmin-license
echo "LicenseKey=$KEY" >>/etc/virtualmin-license
chmod 700 /etc/virtualmin-license
cd ..

# Populate some distro version globals
log_debug "Operating system name:    $os_real"
log_debug "Operating system version: $os_version"
log_debug "Operating system type:    $os_type"
log_debug "Operating system major:   $os_major_version"

install_virtualmin_release() {
  # Grab virtualmin-release from the server
  log_debug "Configuring package manager for ${os_real} ${os_version} .."
  case "$os_type" in
  rhel | fedora | centos | centos_stream | rocky | almalinux | openEuler | ol | cloudlinux | amzn )
    case "$os_type" in
    rhel | centos | centos_stream)
      if [ "$os_type" = "centos_stream" ]; then
        if [ "$os_major_version" -lt 8 ]; then
          printf "${RED}${os_real} ${os_version}${NORMAL} is not supported by this installer.\\n"
          exit 1
        fi
      else
        if [ "$os_major_version" -lt 7 ]; then
          printf "${RED}${os_real} ${os_version}${NORMAL} is not supported by this installer.\\n"
          exit 1
        fi
      fi
      ;;
    rocky | almalinux | openEuler | ol)
      if [ "$os_major_version" -lt 8 ]; then
        printf "${RED}${os_real} ${os_version}${NORMAL} is not supported by this installer.\\n"
        exit 1
      fi
      ;;
    cloudlinux)
      if [ "$os_major_version" -lt 8 ] && [ "$os_type" = "cloudlinux" ]; then
        printf "${RED}${os_real} ${os_version}${NORMAL} is not supported by this installer.\\n"
        exit 1
      fi
      ;;
    fedora)
      if [ "$os_major_version" -lt 35 ] && [ "$os_type" = "fedora" ]  ; then
        printf "${RED}${os_real} ${os_version}${NORMAL} is not supported by this installer.\\n"
        exit 1
      fi
      ;;
    amzn)
      if [ "$os_major_version" -lt 2023 ] && [ "$os_type" = "amzn" ]  ; then
        printf "${RED}${os_real} ${os_version}${NORMAL} is not supported by this installer.\\n"
        exit 1
      fi
      ;;
    *)
      printf "${RED}This OS/version is not recognized! Cannot continue!${NORMAL}\\n"
      exit 1
      ;;
    esac
    if [ -x /usr/sbin/setenforce ]; then
      log_debug "Disabling SELinux during installation .."
      if /usr/sbin/setenforce 0 1>/dev/null 2>&1; then
        log_debug " setenforce 0 succeeded"
      else
        log_debug "  setenforce 0 failed: $?"
      fi
    fi
    package_type="rpm"
    if command -pv dnf 1>/dev/null 2>&1; then
      install_cmd="dnf"
      install="$install_cmd -y install"
      upgrade="$install_cmd -y update"
      update="$install_cmd clean all ; $install_cmd makecache"
      install_group_opts="-y --quiet --skip-broken group install --setopt=group_package_types=mandatory,default"
      install_group="$install_cmd $install_group_opts"
      install_config_manager="$install_cmd config-manager"
      # Do not use package manager when fixing repos
      if [ -z "$setup_only" ]; then
        run_ok "$install dnf-plugins-core" "Installing core plugins for package manager"
      fi
    else
      install_cmd="yum"
      install="$install_cmd -y install"
      upgrade="$install_cmd -y update"
      update="$install_cmd clean all ; $install_cmd makecache"
      if [ "$os_major_version" -ge 7 ]; then
        # Do not use package manager when fixing repos
        if [ -z "$setup_only" ]; then
          run_ok "$install_cmd --quiet groups mark convert" "Updating groups metadata"
        fi
      fi
      install_group_opts="-y --quiet --skip-broken groupinstall --setopt=group_package_types=mandatory,default"
      install_group="$install_cmd $install_group_opts"
      install_config_manager="yum-config-manager"
    fi

    # Download release file
    rpm_release_file_download="virtualmin-$packagetype-release.noarch.rpm"
    download "https://${LOGIN}$download_virtualmin_host/vm/$vm_version/rpm/$rpm_release_file_download" "Downloading Virtualmin $vm_version release package"

    # Remove existing pkg files as they will not
    # be replaced upon replease package upgrade
    if [ -x "/usr/bin/rpm" ]; then
      rpm_release_files="$(rpm -qal virtualmin*release)"
      rpm_release_files=$(echo "$rpm_release_files" | tr '\n' ' ')
      if [ -n "$rpm_release_files" ]; then
        for rpm_release_file in $rpm_release_files; do
           rm -f "$rpm_release_file"
        done
      fi
    fi

    # Remove releases first, as the system can
    # end up having both GPL and Pro installed
    rpm -e --nodeps --quiet "$(rpm -qa virtualmin*release 2>/dev/null)" >> "$RUN_LOG" 2>&1

    # Install release file
    run_ok "rpm -U --replacepkgs --replacefiles --quiet $rpm_release_file_download" "Installing Virtualmin $vm_version release package"

    # Fix login credentials if fixing repos
    if [ -n "$setup_only" ]; then
      sed -i "s/SERIALNUMBER:LICENSEKEY@/$LOGIN/" /etc/yum.repos.d/virtualmin.repo
      sed -i 's/http:\/\//https:\/\//' /etc/yum.repos.d/virtualmin.repo
    fi
    ;;
  debian | ubuntu | kali)
    case "$os_type" in
    ubuntu)
      case "$os_version:$unstable" in
        18.04:*|20.04:*|22.04:*|24.04:*|*\.10:unstable|*[13579].04:unstable)
          : ;; # Do nothing for supported or allowed unstable versions
        *)
          printf "${RED}${os_real} ${os_version} is not supported by this installer.${NORMAL}\\n"
          exit 1
          ;;
      esac
      ;;
    debian)
      if [ "$os_major_version" -lt 10 ]; then
        printf "${RED}${os_real} ${os_version} is not supported by this installer.${NORMAL}\\n"
        exit 1
      fi
      ;;
    kali)
      if [ "$os_major_version" -lt 2023 ] && [ "$os_type" = "kali" ]  ; then
        printf "${RED}${os_real} ${os_version}${NORMAL} is not supported by this installer.\\n"
        exit 1
      fi
      ;;
    esac
    package_type="deb"
    if [ "$os_type" = "ubuntu" ]; then
      deps="$ubudeps"
      repos="virtualmin"
    else
      deps="$debdeps"
      repos="virtualmin"
    fi
    log_debug "apt-get repos: ${repos}"
    if [ -z "$repos" ]; then # Probably unstable with no version number
      log_fatal "No repositories available for this OS. Are you running unstable/testing?"
      exit 1
    fi
    # Remove any existing repo config, in case it's a reinstall
    remove_virtualmin_release

    # Set correct keys name for Debian vs derivatives
    repoid_debian_like=debian
    if [ -n "${os_type}" ]; then
      repoid_debian_like="${os_type}"
    fi

    # Setup repo file
    apt_auth_dir='/etc/apt/auth.conf.d'
    LOGINREAL=$LOGIN
    if [ -d "$apt_auth_dir" ]; then
      if [ -n "$LOGIN" ]; then
        LOGINREAL=""
        printf "machine $download_virtualmin_host login $SERIAL password $KEY\\n" >"$apt_auth_dir/virtualmin.conf"
      fi
    fi
    for repo in $repos; do
      printf "deb [signed-by=/usr/share/keyrings/$repoid_debian_like-virtualmin-$vm_version.gpg] https://${LOGINREAL}$download_virtualmin_host/vm/${vm_version}/${repopath}apt ${repo} main\\n" >/etc/apt/sources.list.d/virtualmin.list
    done

    # Install our keys
    log_debug "Installing Webmin and Virtualmin package signing keys .."
    download "https://$download_virtualmin_host_lib/RPM-GPG-KEY-virtualmin-$vm_version" "Downloading Virtualmin $vm_version key"
    run_ok "gpg --import RPM-GPG-KEY-virtualmin-$vm_version && cat RPM-GPG-KEY-virtualmin-$vm_version | gpg --dearmor > /usr/share/keyrings/$repoid_debian_like-virtualmin-$vm_version.gpg" "Installing Virtualmin $vm_version key"
    run_ok "apt-get update" "Downloading repository metadata"
    # Make sure universe repos are available
    # XXX Test to make sure this run_ok syntax works as expected (with single quotes inside double)
    if [ "$os_type" = "ubuntu" ]; then
      if [ -x "/bin/add-apt-repository" ] || [ -x "/usr/bin/add-apt-repository" ]; then
        run_ok "add-apt-repository -y universe" \
          "Enabling universe repositories, if not already available"
      else
        run_ok "sed -ie '/backports/b; s/#*[ ]*deb \\(.*\\) universe$/deb \\1 universe/' /etc/apt/sources.list" \
          "Enabling universe repositories, if not already available"
      fi
    fi
    # XXX Is this still enabled by default on Debian/Ubuntu systems?
    run_ok "sed -ie 's/^deb cdrom:/#deb cdrom:/' /etc/apt/sources.list" "Disabling cdrom: repositories"
    install="DEBIAN_FRONTEND='noninteractive' /usr/bin/apt-get --quiet --assume-yes --install-recommends -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' -o Dpkg::Pre-Install-Pkgs::='/usr/sbin/dpkg-preconfigure --apt' install"
    upgrade="DEBIAN_FRONTEND='noninteractive' /usr/bin/apt-get --quiet --assume-yes --install-recommends -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' -o Dpkg::Pre-Install-Pkgs::='/usr/sbin/dpkg-preconfigure --apt' upgrade"
    update="/usr/bin/apt-get clean ; /usr/bin/apt-get update"
    #export DEBIAN_FRONTEND=noninteractive
    install_updates="$install $deps"
    run_ok "apt-get clean" "Cleaning up software repo metadata"
    sed -i "s/\\(deb[[:space:]]file.*\\)/#\\1/" /etc/apt/sources.list
    ;;
  *)
    log_error " Your OS is not currently supported by this installer."
    log_error " You can probably run Virtualmin Professional on your system, anyway,"
    log_error " but you'll have to install it using the manual installation process."
    exit 1
    ;;
  esac

  return 0
}

# Setup repos only
if [ -n "$setup_only" ]; then
  if install_virtualmin_release; then
    log_success "Repository configuration successful. You can now install Virtualmin"
    log_success "components using your OS package manager."
  else
    log_error "Errors occurred during setup of Virtualmin software repositories. You may find more"
    log_error "information in ${RUN_LOG}."
  fi
  exit $?
fi

# Install Functions
install_with_apt() {
  # Install system package upgrades, if any
  if [ -z "$noupdates" ]; then
    run_ok "$upgrade" "Checking and installing system package updates"
  fi

  # Silently purge packages that may cause issues upon installation
  /usr/bin/apt-get --quiet --assume-yes purge ufw >> "$RUN_LOG" 2>&1

  # Install Webmin/Usermin first, because it needs to be already done
  # for the deps. Then install Virtualmin Core and then Stack packages
  # Do it all in one go for the nicer UI
  run_ok "$install webmin && $install usermin && $install $debvmpackages && $install $deps" "Installing Virtualmin $vm_version and all related packages"
  if [ $? -ne 0 ]; then
    log_warning "apt-get seems to have failed. Are you sure your OS and version is supported?"
    log_warning "https://www.virtualmin.com/os-support"
    fatal "Installation failed: $?"
  fi

  # Make sure the time is set properly
  /usr/sbin/ntpdate-debian >> "$RUN_LOG" 2>&1

  return 0
}

install_with_yum() {
  # Enable CodeReady and EPEL on RHEL 8+
  if [ "$os_major_version" -ge 8 ] && [ "$os_type" = "rhel" ]; then
    # Important Perl packages are now hidden in CodeReady repo
    run_ok "$install_config_manager --set-enabled codeready-builder-for-rhel-$os_major_version-x86_64-rpms" "Enabling Red Hat CodeReady package repository"
    # Install EPEL
    download "https://dl.fedoraproject.org/pub/epel/epel-release-latest-$os_major_version.noarch.rpm" >>"$log" 2>&1
    run_ok "rpm -U --replacepkgs --quiet epel-release-latest-$os_major_version.noarch.rpm" "Installing EPEL $os_major_version release package"
  # Install EPEL on RHEL 7
  elif [ "$os_major_version" -eq 7 ] && [ "$os_type" = "rhel" ]; then
    download "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm" >>"$log" 2>&1
    run_ok "rpm -U --replacepkgs --quiet epel-release-latest-7.noarch.rpm" "Installing EPEL 7 release package"
  # Install EPEL on CentOS/Alma/Rocky
  elif [ "$os_type" = "centos" ] || [ "$os_type" = "centos_stream" ] || [ "$os_type" = "rocky" ] || [ "$os_type" = "almalinux" ]; then
    run_ok "$install epel-release" "Installing EPEL release package"
  # CloudLinux EPEL
  elif [ "$os_type" = "cloudlinux" ]; then
    # Install EPEL on CloudLinux
    download "https://dl.fedoraproject.org/pub/epel/epel-release-latest-$os_major_version.noarch.rpm" >>"$log" 2>&1
    run_ok "rpm -U --replacepkgs --quiet epel-release-latest-$os_major_version.noarch.rpm" "Installing EPEL $os_major_version release package"
  # Install EPEL on Oracle 7+
  elif [ "$os_type" = "ol" ]; then
    run_ok "$install oracle-epel-release-el$os_major_version" "Installing EPEL release package"
  # Installation on Amazon Linux
  elif [ "$os_type" = "amzn" ]; then
    # Set for installation packages whichever available on Amazon Linux as they
    # go with different name, e.g. mariadb105-server instead of mariadb-server
    virtualmin_stack_custom_packages="mariadb*-server"
    # Exclude from config what's not available on Amazon Linux
    virtualmin_config_system_excludes=" --exclude AWStats --exclude Etckeeper --exclude Fail2banFirewalld --exclude ProFTPd"
  fi

  # Important Perl packages are now hidden in PowerTools repo
  if [ "$os_major_version" -ge 8 ] && [ "$os_type" = "centos" ] || [ "$os_type" = "centos_stream" ] || [ "$os_type" = "rocky" ] || [ "$os_type" = "almalinux" ] || [ "$os_type" = "cloudlinux" ]; then
    # Detect CRB/PowerTools repo name
    if [ "$os_major_version" -ge 9 ]; then
      extra_packages=$(dnf repolist all | grep "^crb")
      if [ -n "$extra_packages" ]; then
        extra_packages="crb"
        extra_packages_name="CRB"
      fi
    else
      extra_packages=$(dnf repolist all | grep "^powertools")
      extra_packages_name="PowerTools"
      if [ -n "$extra_packages" ]; then
        extra_packages="powertools"
      else
        extra_packages="PowerTools"
      fi
    fi

    run_ok "$install_config_manager --set-enabled $extra_packages" "Enabling $extra_packages_name package repository"
  fi


  # Important Perl packages are hidden in ol8_codeready_builder repo in Oracle
  if [ "$os_major_version" -ge 8 ] && [ "$os_type" = "ol" ]; then
    run_ok "$install_config_manager --set-enabled ol${os_major_version}_codeready_builder" "Enabling Oracle Linux $os_major_version CodeReady Builder"
  fi

  # XXX This is so stupid. Why does yum insists on extra commands?
  if [ "$os_major_version" -eq 7 ]; then
    run_ok "yum --quiet groups mark install $rhgroup" "Marking $rhgrouptext for install"
    run_ok "yum --quiet groups mark install $vmgroup" "Marking $vmgrouptext for install"
  fi

  # Clear cache
  run_ok "$install_cmd clean all" "Cleaning up software repo metadata"

  # Upgrade system packages first
  if [ -z "$noupdates" ]; then
    run_ok "$upgrade" "Checking and installing system package updates"
  fi

  # Install custom stack packages
  if [ -n "$virtualmin_stack_custom_packages" ]; then
    run_ok "$install $virtualmin_stack_custom_packages" "Installing missing stack packages"
  fi

  # Install core and stack
  run_ok "$install_group $rhgroup" "Installing dependencies and system packages"
  run_ok "$install_group $vmgroup" "Installing Virtualmin $vm_version and all related packages"
  rs=$?
  if [ $? -ne 0 ]; then
    fatal "Installation failed: $rs"
  fi

  return 0
}

install_virtualmin() {
  case "$package_type" in
  rpm)
    install_with_yum
    ;;
  deb)
    install_with_apt
    ;;
  *)
    install_with_tar
    ;;
  esac
  rs=$?
  if [ $? -eq 0 ]; then
    return 0
  else
    return "$rs"
  fi
}

yum_check_skipped() {
  loginstalled=0
  logskipped=0
  skippedpackages=""
  skippedpackagesnum=0
  while IFS= read -r line
  do
    if [ "$line" = "Installed:" ]; then
      loginstalled=1
    elif [ "$line" = "" ]; then
      loginstalled=0
      logskipped=0
    elif [ "$line" = "Skipped:" ] && [ "$loginstalled" = 1 ]; then
      logskipped=1
    elif [ "$logskipped" = 1 ]; then
      skippedpackages="$skippedpackages$line"
      skippedpackagesnum=$((skippedpackagesnum+1))
    fi
  done < "$log"
  if [ -z "$noskippedpackagesforce" ] && [ "$skippedpackages" != "" ]; then
    if [ "$skippedpackagesnum" != 1 ]; then
      ts="s"
    fi
    skippedpackages=$(echo "$skippedpackages" | tr -s ' ')
    log_warning "Skipped package${ts}:${skippedpackages}"
  fi
}

# virtualmin-release only exists for one platform...but it's as good a function
# name as any, I guess.  Should just be "setup_repositories" or something.
errors=$((0))
install_virtualmin_release
bind_hook "phase2_post"
echo
phase "Installation" 3
bind_hook "phase3_pre"
install_virtualmin
if [ "$?" != "0" ]; then
  errorlist="${errorlist}  ${YELLOW}◉${NORMAL} Package installation returned an error.\\n"
  errors=$((errors + 1))
fi

# We want to make sure we're running our version of packages if we have
# our own version.  There's no good way to do this, but we'll
run_ok "$install_updates" "Installing Virtualmin $vm_version related package updates"
if [ "$?" != "0" ]; then
  errorlist="${errorlist}  ${YELLOW}◉${NORMAL} Installing updates returned an error.\\n"
  errors=$((errors + 1))
fi

bind_hook "phase3_post"

# Initialize embedded module if any
if [ -n "$module_name" ]; then
  bind_hook "modules_pre"
  # If module is available locally in the same directory use it
  if [ -f "$pwd/${module_name}.sh" ]; then
    chmod +x "$pwd/${module_name}.sh"
    # shellcheck disable=SC1090
    . "$pwd/${module_name}.sh"
  else
    log_warning "Requested module with the filename $pwd/${module_name}.sh does not exist."
  fi
  bind_hook "modules_post"
fi

# Reap any clingy processes (like spinner forks)
# get the parent pids (as those are the problem)
allpids="$(ps -o pid= --ppid $$) $allpids"
for pid in $allpids; do
  kill "$pid" 1>/dev/null 2>&1
done

# Final step is configuration. Wait here for a moment, hopefully letting any
# apt processes disappear before we start, as they're huge and memory is a
# problem. XXX This is hacky. I'm not sure what's really causing random fails.
sleep 1
echo
phase "Configuration" 4
bind_hook "phase4_pre"
if [ "$mode" = "minimal" ]; then
  bundle="Mini${bundle}"
fi
# shellcheck disable=SC2086
virtualmin-config-system --bundle "$bundle" $virtualmin_config_system_excludes --log "$log"
if [ "$?" != "0" ]; then
  errorlist="${errorlist}  ${YELLOW}◉${NORMAL} Postinstall configuration returned an error.\\n"
  errors=$((errors + 1))
fi
sleep 1
# Do we still need to kill stuck spinners?
kill $! 1>/dev/null 2>&1

# Log SSL request status, if available
if [ -f "$VIRTUALMIN_INSTALL_TEMPDIR/virtualmin_ssl_host_status" ]; then
  virtualmin_ssl_host_status=$(cat "$VIRTUALMIN_INSTALL_TEMPDIR/virtualmin_ssl_host_status")
  log_debug "$virtualmin_ssl_host_status"
fi

# Functions that are used in the OS specific modifications section
disable_selinux() {
  seconfigfiles="/etc/selinux/config /etc/sysconfig/selinux"
  for i in $seconfigfiles; do
    if [ -e "$i" ]; then
      perl -pi -e 's/^SELINUX=.*/SELINUX=disabled/' "$i"
    fi
  done
}

# Changes that are specific to OS
case "$os_type" in
rhel | fedora | centos | centos_stream | rocky | almalinux | openEuler | ol | cloudlinux | amzn)
  disable_selinux
  ;;
esac

bind_hook "phase4_post"

# Process additional phases if set in third-party functions
if [ -n "$hooks__phases" ]; then
    # Trim leading and trailing whitespace
    trim() {
        echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
    }
    bind_hook "phases_pre"
    unset current_phase
    phases_error_occurred=0
    printf '%s\n' "$hooks__phases" | sed '/^$/d' > hooks__phases_tmp
    while IFS= read -r line; do
        # Split the line into components
        phase_number=$(trim "${line%%	*}")
        rest="${line#*	}"
        phase_name=$(trim "${rest%%	*}")
        rest="${rest#*	}"
        command=$(trim "${rest%%	*}")
        description=$(trim "${rest#*	}")
        # If it's a new phase, display phase progress
        if [ "$phase_number" != "$current_phase" ]; then
            echo
            phase "$phase_name" "$phase_number"
            current_phase="$phase_number"
        fi
        # Run the command
        if ! run_ok "$command" "$description"; then
            phases_error_occurred=1
            break
        fi
    done < hooks__phases_tmp
    # Exit if an error occurred
    if [ "$phases_error_occurred" -eq 1 ]; then
        exit 1
    fi
    bind_hook "phases_post"
fi

bind_hook "phases_all_post"

# Was LE SSL for hostname request successful?
if [ -d "$VIRTUALMIN_INSTALL_TEMPDIR/virtualmin_ssl_host_success" ]; then
  ssl_host_success=1
fi

# Cleanup the tmp files
bind_hook "clean_pre"
printf "${GREEN}▣▣▣${NORMAL} Cleaning up\\n"
if [ "$VIRTUALMIN_INSTALL_TEMPDIR" != "" ] && [ "$VIRTUALMIN_INSTALL_TEMPDIR" != "/" ]; then
  log_debug "Cleaning up temporary files in $VIRTUALMIN_INSTALL_TEMPDIR."
  find "$VIRTUALMIN_INSTALL_TEMPDIR" -delete
else
  log_error "Could not safely clean up temporary files because TMPDIR set to $VIRTUALMIN_INSTALL_TEMPDIR."
fi

if [ -n "$QUOTA_FAILED" ]; then
  log_warning "Quotas were not configurable. A reboot may be required. Or, if this is"
  log_warning "a VM, configuration may be required at the host level."
fi
bind_hook "clean_post"
echo
if [ $errors -eq "0" ]; then
  hostname=$(hostname -f)
  detect_ip
  if [ "$package_type" = "rpm" ]; then
    yum_check_skipped
  fi
  bind_hook "post_install_message"
  TIME=$(date +%s)
  echo "$VER=$TIME" > "/etc/webmin/virtual-server/installed"
  echo "$VER=$TIME" > "/etc/webmin/virtual-server/installed-auto"
else
  log_warning "The following errors occurred during installation:"
  echo
  printf "${errorlist}"
fi

exit 0
