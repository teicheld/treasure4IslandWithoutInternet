curl "$1" | grep -o 'a href.*"><h4' | sed 's/a href="//; s/"><h4//'
