#!/bin/bash

# Initialize flag variable
link=false
stupid_glags="-fsanitize=address -fsanitize=leak -fsanitize=undefined -fsanitize=unreachable"

# Function to print usage
usage() {
    echo "Usage: $0 [-m]"
    exit 1
}

# Parse options
while getopts "m" opt; do
    case $opt in
        m)
            link=true
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND - 1))

if [ -f ../materials/linters/.clang-format ]; then
    mv ../materials/linters/.clang-format .
fi

if [ $# -ne 1 ]
  then
    echo "checking test.c ..."
    target='test.c'
  else
    target=$1
fi

if [ -f $target ]; then
    echo 'CLAMG??'
    clang-format -i $target
    echo 'CLAMG SAID: '$(clang-format -n $target)

    cppcheck --enable=all --suppress=missingIncludeSystem $target

    # Check flag
    if $link; then
         gcc -x c -std=c11 -Wall -Werror -Wextra $target -lm $stupid_glags
    else gcc -x c -std=c11 -Wall -Werror -Wextra $target $stupid_glags
    fi

    if [ $? -ne 0 ]; then
        exit 1
    fi
    echo 'COMPILEMD!!!'
    valgrind --tool=memcheck --leak-check=yes ./a.out
    printf "*-*-*-*-*-*-*-*-*-*-*result*-*-*-*-*-*-*-*-*-*-*\n\n"
    ./a.out
else
    echo "hey bitch your $target sucks cos such file doesnt exist"
    exit 1
fi
