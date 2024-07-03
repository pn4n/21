#!/bin/bash

#math
link=""
#valgrind
grinder=false
#autosyle
style=true
#gcc flags
stupid_glags="-fsanitize=address -fsanitize=leak -fsanitize=undefined -fsanitize=unreachable"

# Function to print usage
usage() {
    echo "\nUsage:  $0  \t\t| run test.c (wth gcc flags)\n"
    echo "\t$0 file.c \t| run file.c (wth gcc flags)\n"
    echo "\t$0 -m file.c \t| run file.c and link math (wth gcc flags)\n"
    echo "\t$0 -v file.c \t| run file.c and valgrind WITHOUT gcc flags\n"
    echo "\t$0 -c file.c \t| run file.c without autostyle (clang-format -i)\n"
    exit 1
}

# Parse options
while getopts "mvc" opt; do
    case $opt in
        m)
            link="-lm"
            ;;
        v)
            grinder=true
            ;;
        c)
            style=false
            ;;
        *)
            usage
            ;;
    esac
done

# remove flags to read <filename> in args instead
shift $((OPTIND - 1))

# move .clang-format from materials if exist
if [ -f ../materials/linters/.clang-format ]; then
    mv ../materials/linters/.clang-format .
fi

# tun test.c if no <filename> in args
if [ $# -ne 1 ]
  then
    echo "checking test.c ..."
    target='test.c'
  else
    target=$1
fi

# check if <filename> or test.c exists
if [ -f $target ]; then
    echo 'CLAMG??'

    if $style; then clang-format -i $target; fi

    echo 'CLAMG FOMAT SAID: '$(clang-format -n $target)

    cppcheck --enable=all --suppress=missingIncludeSystem $target

    # Check grinder, if so DONT put stupid flags
    if $grinder; then
        gcc -x c -std=c11 -Wall -Werror -Wextra $target $link;
    else 
        gcc -x c -std=c11 -Wall -Werror -Wextra $target $link $stupid_glags;
    fi

    if [ $? -ne 0 ]; then
        echo "EBANIY ROT ETOGO KAZINO"
        exit 1
    fi
    echo 'COMPILEMD!!!'

    if $grinder; then $(valgrind --tool=memcheck --leak-check=yes ./a.out); 
    else
        printf "*-*-*-*-*-*-*-*-*-*-*result*-*-*-*-*-*-*-*-*-*-*\n\n"
        ./a.out
    fi
else
    echo "hey bitch your $target sucks cos such file doesnt exist"
    exit 1
fi
