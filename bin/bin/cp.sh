#!/bin/zsh
# This is where I put my custom commands

function cpinit {
  local name="poconut"
  local loc="/home/pouya/cptmp1.cpp"
  local date=$(date +"%D %R")
  touch in
  echo "/**\n* created: $date\n* by: $name\n*/" > {a..g}.cpp
  cat $loc >> {a..g}.cpp
}

function ide() {
  tmux split-window -v -p 30
}

#function stest_old {
  #for ((i = 1; ; i++)); do
    #local name=$(echo $1 | awk -F. '{print $1}')
    #echo $i
    #./gen $i > gin
    #diff -w <(./$name < gin) <(./bf < gin) || break
  #done
#}

function test_checker {
    local name=$1
    echo $name
    touch $name.in $name.out $name.chlog

    if ! [ -f ./$name.cpp ]; then
      echo "$name.cpp file does not exist."
      return
    fi
    g++ -std=c++20 -DLOCAL $name.cpp -o $name

    if ! [ -f ./$name.gen.cpp ]; then
      echo "Generator file does not exist."
      return
    fi
    g++ -std=c++20 -DLOCAL $name.gen.cpp -o gen

    if ! [ -f ./$name.checker.cpp ]; then
      echo "Checker file does not exist."
      return
    fi
    g++ -std=c++20 -DLOCAL $name.checker.cpp -o ch
    
    for (( i=1; ; ++i )); do
        ./gen $i > $name.in
        ./$name < $name.in > $name.out
        ./ch < $name.out > $name.chlog
        echo "Passed test: " $i
    done
}
function test_diff {
    local name=$1
    touch $name.in $name.out $name.bf.out
    
    if ! [ -f ./$name.cpp ]; then
      echo "$name.cpp file does not exist."
      return
    fi
    g++ -std=c++20 -DLOCAL $name.cpp -o $name

    if ! [ -f ./$name.gen.cpp ]; then
      echo "Generator file does not exist."
      return
    fi
    g++ -std=c++20 -DLOCAL $name.gen.cpp -o gen

    if ! [ -f ./$name.bf.cpp ]; then
      echo "Bruteforce file does not exist."
      return
    fi
    g++ -std=c++20 -DLOCAL $name.bf.cpp -o bf

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
}

function stest {
    set -e
    while getopts "d:c:" option; do 
        case $option in
            c)
                local name=$(echo $OPTARG | awk -F. '{print $1}')
                echo $name
                test_checker $name
            exit;;

            d)
                local name=$(echo $OPTARG | awk -F. '{print $1}')
                echo $name
                test_diff $name
            exit;;

        esac
    done

    test_diff $name
}

