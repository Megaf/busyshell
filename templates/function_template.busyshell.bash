# Welcome to this template!
#
# From this you will hopefully learn how to develop your own functions
# for busyshell.
#
# Naming:
# Functions for busyshell must use the extension ".bash"
# Please don't use dashes, dots, spaces or special symbols.
# "my_function.busyshell.bash" is a good name.
#
# The function name will follow the file's name.
# This function's name is "function_template",
# so the filename will be "function_template.busyshell.bash" and,
# the function name to be used will be "function_template".
#
# Coding Style:
## identantion:
# Use correct identantion!
# Use spaces instead of tabs!
# I personally like 4 spaces for idents.
#
## Comments:
# Please use plenty of comments on your code!
# Not only this will help anyone who whants to help or improve your code but
# it will help yourself later when you get back at it and will be trying to
# figure out what your own code is doing!
#
# Licensing:
# Please use any Open Source license.
#
# Linting and Stability:
# Functions for busyshell must be linted!!
# They must be written for BASH! No KSH/POSTIX/SH stuff!
# You can lint your function at 'https://shellcheck.net/'
# or by installing 'shellcheck' to your system and running
# 'shellcheck my_function.busyshell.bash'
#
# Make sure your function work!
# To test it, you can do in your terminal:
# '~$ source my_function.busyshell.bash'.     # Loads your functions.
# '~$ my_function --args'          # Runs the function with "--args".
#
# Note:
# Only one function allowed here,
# Though it can have many sub-functions.
# Declaration to checkshell linter so it knows how to parse
# this function.
# shellcheck shell=bash
#
# Atention!
# DO NOT USE "exit" commands! They will close the user's shell!
# Use instead "return 0" for clean exists and "reaturn 1" for exits with errors.
#
# Header:
# Contains information about your function.
# You must include: filename, description, author, version, creation date,
# and License.
# Below an example of a good header.
#
# function_template.busyshell.bash
# Description: This is a template for a function for busyshell.
# Author: Megaf - https://www.github.com/Megaf - mmegaf [at] gmail [dot] com
# Version: 0.1
# Date: 24/09/2022
# License: GPL 3.0

# Start of the main function.
function_template()
{
    # Creating a local variable to get the args that
    # are given to the function. It must be local!
    # You really don't want your precious variables getting lost in the big
    # and mad wolrd of the OS.
    # And the OS, and other devs, likely don't want to be flooded by
    # your variables either.
    #
    # Please name them after the Function name.
    # The variable definition bellow allows the
    # function to take command line args.
    local function_template_argument
    function_template_argument="$*"

    # If using subfunctions, add them here.
    # Name them after the Function name.

    # Subfunctions are nice because they will not "leak" to the rest of the OS.
    # Subfuction to do stuff
    function_template_im_subfunction()
    {
        echo "Look at me, I am a SUB function!"
        echo "You can call me nested!"
        if [ "$*" ]; then
          echo "BTW, the args given to me, were '$*'."
        fi
        # If all went well, we can "exit" this function.
        return 0
    }

    # Do stuff after definitions of vars and stuff.
    echo "Look at me, I am a function."

    # Running the subfunction and passing to it cmd args.
    function_template_im_subfunction "$function_template_argument"

    # Remember to unset your vars and subfunctions!
    # unsetting functions.
    unset -f function_template_im_subfunction
    # unsetting vars.
    unset -v function_template_argument
    # All done, time to "exit".
    return 0
}
