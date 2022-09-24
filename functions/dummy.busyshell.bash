# shellcheck shell=bash
#
# dummy.busyshell.bash
# Description: This is a dummy function, it will do nothing successfully.
# Author: Megaf - https://www.github.com/Megaf - mmegaf [at] gmail [dot] com
# Version: Dummy.1
# Date: 24/09/2022
# License: GPL 3.0

dummy()
{
  local variable_a
  # variable_a stores this text.
  variable_a="I'm a variable."

  # This is a dummy function, it does nothing.
  # So will unset the variable already.
  unset -v "$variable_a"

  # But in the description I said, "do nothing successfully", so let's do that.
  true
  # Do 'man true' if you didn't understand. ;)

  if true; then
    # Now we can close the function with success.
    return 0
  fi
}
