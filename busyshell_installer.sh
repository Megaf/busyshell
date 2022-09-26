#!/bin/bash
#
# busyshell - Version: 0.1-202209.24.153000
# busyshell_installer.sh
#
# This is an installer for busyshell's functions.
# These functions are loaded from your '.bashrc' and add extra
# functionality to your shell.
#
# Author:       Megaf - https://github.com/Megaf - mmegaf [at] gmail [dot] com
# Date:         23/09/2022
# GitHub:       https://github.com/Megaf/busyshell
# License:      GPL V3

# Custom "writer", use 'say' or echo if no 'say'.
[ -z "$debug" ] && debug="false"
_printer() {
  if command -v say &> /dev/null; then
    say "$*"
  elif [ "$debug" = "false" ] && [[ ! "$*" == "DEBUG: "* ]]; then
    echo "$*"
  elif [ "$debug" = "true" ]; then
    echo "$*"
  fi
  }

# Scripts variables/definitions.
projects_name="busyshell"
projects_name_long="busyshell functions installer."
project_version="0.1-202209.24.153000"

# Files and directories locations.
_home="$HOME"
backup_dir="$_home/Backups/$projects_name"
download_dir="$_home/Downloads"
download_location="$download_dir/$projects_name"
functions_location="$download_location/functions"
shell_loader_file=".bashrc"
shell_loader="$_home/$shell_loader_file"
functions_destination="$_home/.local/lib"

# Internet resources.
megafs_git="https://github.com/Megaf"
projects_git="$megafs_git"
projects_repo="$projects_name"
#git_branch="stable"
git_branch="development"

# Messages
read -r -d '' welcome_text << EOM
TITLE: Welcome to $projects_name_long $project_version!

INFO: This will install busyshell functions to your $shell_loader.
EOM

read -r -d '' help_text << EOM
▁▂▃▄▅▆▇██████████████████████████████████████████▇▆▅▄▃▂▁
█            ░▒▓ busyshell's help menu. ▓▒░            █
█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
█                   About busyshell:                   █
█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
█ busyshell, a collection of small shell scripts apps  █
█ that reside directly in your .bashrc!                █
█ It adds handy commands to your system to make        █
█ day-to-day life easier.                              █
█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
█                 Installer's commands:                █
█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
█  → 'install "app_name"'       Installs a mini app.   █
█  → 'uninstall "app_name"'     Uninstall a mini app.  █
█  → 'help'                     Prints this help menu. █
█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
█ Please note, if the function was already installed,  █
█ then the installed will try to update it.            █
████████████████████████████████████████████████████████
EOM

print_welcome() { _printer "$welcome_text"; unset -v welcome_text ; }
print_bye()
{
  if [ "$?" = "0" ]; then
    _printer "NOTICE: All done! Thanks for using $projects_name_long! Wish you a lovely day!"
  else
    _printer "WARNING: Something went wront, please submit an issue to $projects_git/$projects_repo"
  fi
}

error_text() { _printer "ERROR: Something went wrong in $1, it exit with code $2"; }

is_it_error()
{
#  if [[ "$*" =~ ^[0-9]+$ ]]; then
#    if (("$*" >= 0 && "$*" <= 512)); then
  local error_code="$?"
  local error_function="$1"
  if [ "$error_code" != "0" ]; then
    error_text "$error_function" "$error_code"
    unset -v error_function error_code
    exit 1
  else
    return 0
  fi
}

# hide(){ [ "$hide_git" = "true" ] && 2>/dev/null; }

# Git function to clone a repository or update it if it was already cloned.
# Will switch to branch set by ''$git_branch' variable.
do_git()
{
  local git_jobs="9"
  _printer "INFO: Checking if $projects_name was already downloaded."
  if [ -d "$download_location" ]; then
    _printer "INFO: $projects_name found, checking for updates and updating it..."
    cd "$download_location" || is_it_error "${FUNCNAME[0]}."
    git remote update || is_it_error "${FUNCNAME[0]}."
    _printer "INFO: Updating $projects_name repository."
    git pull -j "$git_jobs" || is_it_error "${FUNCNAME[0]}."
    _printer "INFO: Switching to branch $git_branch."
    git checkout $git_branch || is_it_error "${FUNCNAME[0]}."
  else
    mkdir -p "$download_dir" || is_it_error "${FUNCNAME[0]}."
    cd "$download_dir" || is_it_error "${FUNCNAME[0]}."
    _printer "INFO: Running 'git clone $projects_git/$projects_repo'."
    git clone -j "$git_jobs" "$projects_git/$projects_repo" "$projects_name" 2> /dev/null || is_it_error "${FUNCNAME[0]}."
    cd "$download_location" || is_it_error "${FUNCNAME[0]}."
    _printer "INFO: Running 'git checkout $git_branch'."
    git checkout "$git_branch" || is_it_error "${FUNCNAME[0]}."
  fi
  unset -v git_jobs
}

remove_from_shellrc()
{
  _printer "Removing $function_name from $shell_loader."
  local line_number line_text function_found

  line_number="1"
  while IFS='' read -r line_text; do
  _printer "DEBUG: Reading $shell_loader file, line number $line_number."
    if [ "$line_text" = "$shell_loader_text" ]; then
      function_found="true"
      _printer "Found '$shell_loader_text' on line number $line_number."
    else
      line_number=$((line_number+1))
    fi
  done < "$shell_loader"

  if [ "$function_found" = "true" ]; then
    sed -i "$line_number"d "$shell_loader" || is_it_error "${FUNCNAME[0]}."
  elif [ "$function_found" != "true" ]; then
    _printer "WARNING: Couldn't find $function_name on your $shell_loader."
    _printer "INFO: Doing nothing."
  fi
  unset -v line_number line_text function_found
}

install_to_shellrc()
{
  [ -f "$functions_destination/$file_name" ] || is_it_error "${FUNCNAME[0]}."

  unset -v function_already_installed
  local function_already_installed line_text line_number

  line_number="1"
  while IFS='' read -r line_text; do
    _printer "DEBUG: Reading $shell_loader file, line number $line_number"
    if [ "$line_text" = "$shell_loader_text" ]; then
      function_already_installed="true"
      _printer "DEBUG: Found '$shell_loader_text' on line number $line_number."
      _printer "INFO: '$function_name' was already in $shell_loader."
    else
      line_number=$((line_number+1))
    fi
  done < "$shell_loader"

  if [ "$function_already_installed" != "true" ]; then
    _printer "INFO: Adding '$function_name' to the end of the $shell_loader file."
    echo "$shell_loader_text" >> "$shell_loader"
  fi

  unset -v line_text line_number
}

read_args_and_do_stuff()
{
  print_welcome # Prints the welcome message.

  local now_ backup_name
  now_="$(date +%Y-%m-%d_%H-%M-%S)"
  backup_name="$projects_name-$shell_loader_file-$now_.backup"

  do_backup()
  {
  _printer "DEBUG: Now is '$now_'."
  _printer "DEBUG: Backup file name is '$backup_name'."
  _printer "DEBUG: Backup location is '$backup_dir'."
  _printer "DEBUG: Full path is '$backup_dir/$backup_name'."

  copy_file()
  {
    [ "$1" = "first" ] && backup_name="FIRST-$backup_name"
    cp -a "$shell_loader" "$backup_dir/$backup_name" || is_it_error "${FUNCNAME[0]}."
    _printer "NOTICE: A backup of your $shell_loader has been made!"
    _printer "NOTICE: $shell_loader saved to '$backup_dir/$backup_name'."
  }
  # If backup directory doesn't exist, make one.
  if [ ! -d "$backup_dir" ]; then
    # Making a backup of shell_loader to backup_dir
    _printer "INFO: Creating Backup directory '$backup_dir'."
    mkdir -p "$backup_dir" || is_it_error "${FUNCNAME[0]}."
    copy_file "first"
  elif [ -d "$backup_dir" ]; then # Then make the backup.
    copy_file
  else # If fail, quit.
    is_it_error "${FUNCNAME[0]}."
  fi

  unset -v now_ backup_name
}

  # Install function
  do_install()
  {
    # Clones/Updates Git repository.
    do_git || is_it_error "${FUNCNAME[0]}."

    [ ! -f "$functions_location/$file_name" ] &&_printer "INFO: Installing '$function_name'."
    [ -f "$functions_location/$file_name" ] &&_printer "INFO: Updating '$function_name'."
    cp -u "$functions_location/$file_name" "$functions_destination/" || is_it_error "${FUNCNAME[0]}."
    install_to_shellrc || is_it_error "${FUNCNAME[0]}."
  }

  # Uninstalls function
  do_remove()
  {
    _printer "INFO: Uninstalling $function_name."
    rm -f "$functions_destination/$file_name" || is_it_error "${FUNCNAME[0]}."
    remove_from_shellrc || is_it_error "${FUNCNAME[0]}."
    _printer "$function_name uninstalled!"
  }

  do_backup
  local name search_ shell_loader_text
  export file_name function_name
  for name in "${command_args[@]}"; do # Checks if the args represent valid function names.
    _printer "INFO: Checking if $name is a valid function name:"
    search_="dummy"
    if [ "$name" = "$search_" ]; then
      _printer "INFO: Function $name is valid!"
      file_name="$search_.busyshell.bash" # Sets the filename for the function file from the function name.
      function_name="$search_"
      shell_loader_text="source $functions_destination/$file_name"
      if [ "$do_install" = "true" ] && [ "$do_uninstall" = "false" ]; then
        do_install
      elif [ "$do_install" = "false" ] && [ "$do_uninstall" = "true" ]; then
        do_remove
      fi
    fi
  done
  # print_bye
  unset -v search_ name shell_loader_text
  unset -f do_backup do_install do_remove
  is_it_error "${FUNCNAME[0]}."
}

if [ "$*" ]; then
  case "$*" in
    install*)
            _printer "DEBUG: Selected 'install'"
            do_install="true"
            do_uninstall="false"
            shift 1
            command_args=( "$@" )
            read_args_and_do_stuff || is_it_error "${FUNCNAME[0]}."
            ;;
  uninstall*)
            _printer "DEBUG: Selected 'uninstall'"
            do_install="false"
            do_uninstall="true"
            shift 1
            command_args=( "$@" )
            read_args_and_do_stuff || is_it_error "${FUNCNAME[0]}."
            ;;
           *)
            _printer "$help_text"
            ;;
  esac
else
  _printer "NOTICE: Please tell the installer which functions you want to install."
  exit 1
fi

unset -v function_name command_line_args
unset -f read_args_and_do_stuff install_function do_git print_welcome install_to_shellrc
