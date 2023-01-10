echo $(whoami)@$(ip a | grep -o 192.*24 | cut -d '/' -f1)
