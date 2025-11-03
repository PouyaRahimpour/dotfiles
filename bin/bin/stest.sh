#!/bin/zsh
# This is where I put my custom commands

#function cpinit {
#  local name="poconut"
#  local loc="/home/pouya/cptmp1.cpp"
#  local date=$(date +"%D %R")
#  touch in
#  echo "/**\n* created: $date\n* by: $name\n*/" > {a..g}.cpp
#  cat $loc >> {a..g}.cpp
#}

#function stest_old {
#  for ((i = 1; ; i++)); do
#    local name=$(echo $1 | awk -F. '{print $1}')
#    echo $i
#    ./gen $i > gin
#    diff -w <(./$name < gin) <(./bf < gin) || break
#  done
#}

function __test_checker() (
    #set -e
    local name=$1
    touch $name.in $name.out $name.chlog

    if ! [ -f ./$name.cpp ]; then
      echo "$name.cpp file does not exist."
      return 1
    fi
    g++ $name.cpp -o $name
    echo "compiled to $name"

    if ! [ -f ./$name.gen.cpp ]; then
      echo "Generator file does not exist."
      return 1
    fi
    g++ $name.gen.cpp -o gen
    echo "compiled to gen"

    if ! [ -f ./$name.checker.cpp ]; then
      echo "Checker file does not exist."
      return 1
    fi
    g++ $name.checker.cpp -o ch
    echo "compiled to ch"
    
    for (( i=1; ; ++i )); do
        ./gen $i > $name.in
        ./$name < $name.in > $name.out
        if ./ch > $name.chlog; then
            echo "Passed test: " $i
        else 
            cat $name.chlog
            return 0
        fi
    done
)

function __test_diff() (
    #set -e
    local name=$1
    touch $name.in $name.out $name.bf.out
    
    if ! [ -f ./$name.cpp ]; then
      echo "$name.cpp file does not exist."
      return 1
    fi
    g++ $name.cpp -o $name

    if ! [ -f ./$name.gen.cpp ]; then
      echo "Generator file does not exist."
      return 1
    fi
    g++ $name.gen.cpp -o gen

    if ! [ -f ./$name.bf.cpp ]; then
      echo "Bruteforce file does not exist."
      return 1
    fi
    g++ $name.bf.cpp -o bf

    for (( i=1; ; ++i )); do
        ./gen $i > $name.in
        ./$name < $name.in > $name.out
        ./bf < $name.in > $name.bf.out
        diff -Z $name.out $name.bf.out > /dev/null || break
        echo "Passed test: "  $i
    done
    
    echo "WA on the following test:"
    cat $name.in
    echo "Your answer is:"
    cat $name.out
    echo "Correct answer is:"
    cat $name.bf.out
    return 0
)

function stest {
    while getopts "d:c:" option; do 
        case $option in
            c)
                local name=$(echo $OPTARG | awk -F. '{print $1}')
                #echo $(zsh -c "source ~/.my_commands.sh && __test_checker $name")
                __test_checker $name
            ;;

            d)
                local name=$(echo $OPTARG | awk -F. '{print $1}')
                #echo $(zsh -c "source ~/.my_commands.sh && __test_diff $name")
                __test_diff $name
            ;;

            *)
                local name=$(echo $1 | awk -F. '{print $1}')
                #echo $(zsh -c "source ~/.my_commands.sh && __test_diff $name")
                __test_diff $name
        esac
    done
    return 0
}


