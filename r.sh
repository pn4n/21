#!/bin/bash

#math
link=false
#valgrind
grinder=false
#gcc flags
stupid_glags="-fsanitize=address -fsanitize=leak -fsanitize=undefined -fsanitize=unreachable"

# Function to print usage
usage() {
    echo "\nUsage:  $0  \t\t| run test.c\n"
    echo "\t$0 file.c \t| run file.c\n"
    echo "\t$0 -m file.c \t| run file.c and link math\n"
    echo "\t$0 -v file.c \t| run file.c anf valgrind\n"
    exit 1
}

# Parse options
while getopts "mv" opt; do
    case $opt in
        m)
            link=true
            ;;
        v)
            grinder=true
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

    if $grinder; then valgrind --tool=memcheck --leak-check=yes ./a.out; fi
    
    printf "*-*-*-*-*-*-*-*-*-*-*result*-*-*-*-*-*-*-*-*-*-*\n\n"
    ./a.out
else
    echo "hey bitch your $target sucks cos such file doesnt exist"
    exit 1
fi
