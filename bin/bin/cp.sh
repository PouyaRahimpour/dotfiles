#!/bin/zsh

# ============================================================
# Competitive Programming Utilities
# ============================================================
#
# Stress testing:
#
#   stest -d  foo
#       Differential testing:
#       foo.cpp vs foo.bf.cpp
#
#   stest -c  foo
#       Checker testing without reference answer.
#       foo.checker.cpp uses inf/ouf and ignores ans.
#
#   stest -ca foo
#       Checker testing with reference answer.
#       foo.checker.cpp uses inf/ouf/ans.
#
# Expected files:
#
#   foo.cpp
#   foo.gen.cpp
#   foo.bf.cpp          (-d and -ca only)
#   foo.checker.cpp     (-c and -ca only)
#
# ============================================================


# ============================================================
# Configuration
# ============================================================

CP_LIB="/home/pouya/dev/cp/lib"

CP_FLAGS=(
    -std=c++23
    -DLOCAL
    -I$CP_LIB
)


# ============================================================
# atcoder-library code expansion
# ============================================================
function expand {
    $CP_LIB/expander.py -c --lib $CP_LIB $1 | clip
}

# ============================================================
# cpinit
# ============================================================

function cpinit {
    local name="poconut"
    local loc="/home/pouya/cptmp1.cpp"
    local date=$(date +"%D %R")

    if [[ ! -f "$loc" ]]; then
        echo "Template does not exist:"
        echo "$loc"
        return 1
    fi

    touch in

    for file in {a..g}.cpp; do
        {
            echo "/**"
            echo " * created: $date"
            echo " * by: $name"
            echo " */"
            cat "$loc"
        } > "$file"
    done

    echo "Created a.cpp through g.cpp."
}


# ============================================================
# ide
# ============================================================

function ide {
    if ! command -v tmux >/dev/null 2>&1; then
        echo "tmux is not installed."
        return 1
    fi

    tmux split-window -v -p 30
}


# ============================================================
# compile_cpp
#
# Internal helper.
# ============================================================

function compile_cpp {
    local source="$1"
    local output="$2"

    if [[ ! -f "$source" ]]; then
        echo "File does not exist: $source"
        return 1
    fi

    echo "Compiling $source..."

    g++ "${CP_FLAGS[@]}" "$source" -o "$output"

    if (( $? != 0 )); then
        echo "Compilation failed: $source"
        return 1
    fi

    return 0
}


# ============================================================
# test_diff
#
# Differential testing.
#
#   generator
#       |
#       +----> solution
#       |
#       +----> brute force
#                    |
#                    v
#                  diff
#
# Usage:
#
#   stest -d foo
#
# Required:
#
#   foo.cpp
#   foo.gen.cpp
#   foo.bf.cpp
# ============================================================

function test_diff {
    local name="$1"

    if [[ -z "$name" ]]; then
        echo "Usage: stest -d <name>"
        return 1
    fi

    name="${name%.cpp}"

    local solution="$name"
    local input="$name.in"
    local output="$name.out"
    local bf_output="$name.bf.out"

    echo
    echo "========================================"
    echo "Differential Stress Test"
    echo "========================================"
    echo "Solution : $name.cpp"
    echo "Generator: $name.gen.cpp"
    echo "Bruteforce: $name.bf.cpp"
    echo "========================================"
    echo

    # --------------------------------------------------------
    # Check files
    # --------------------------------------------------------

    if [[ ! -f "$name.cpp" ]]; then
        echo "$name.cpp file does not exist."
        return 1
    fi

    if [[ ! -f "$name.gen.cpp" ]]; then
        echo "$name.gen.cpp file does not exist."
        return 1
    fi

    if [[ ! -f "$name.bf.cpp" ]]; then
        echo "$name.bf.cpp file does not exist."
        return 1
    fi

    # --------------------------------------------------------
    # Compile
    # --------------------------------------------------------

    compile_cpp "$name.cpp" "$solution" || return 1
    compile_cpp "$name.gen.cpp" gen || return 1
    compile_cpp "$name.bf.cpp" bf || return 1

    echo
    echo "Starting stress test..."
    echo "Press Ctrl+C to stop."
    echo

    # --------------------------------------------------------
    # Stress loop
    # --------------------------------------------------------

    for ((i = 1; ; ++i)); do

        # Generate test
        if ! ./gen "$i" > "$input"; then
            echo
            echo "========================================"
            echo "GENERATOR CRASHED"
            echo "Test: $i"
            echo "========================================"
            echo
            echo "Input:"
            cat "$input"
            echo
            return 1
        fi


        # Run contestant solution
        if ! "./$solution" < "$input" > "$output"; then
            echo
            echo "========================================"
            echo "SOLUTION CRASHED"
            echo "Test: $i"
            echo "========================================"
            echo
            echo "Input:"
            cat "$input"
            echo
            echo "Partial output:"
            cat "$output"
            echo
            return 1
        fi


        # Run brute force
        if ! ./bf < "$input" > "$bf_output"; then
            echo
            echo "========================================"
            echo "BRUTE FORCE CRASHED"
            echo "Test: $i"
            echo "========================================"
            echo
            echo "Input:"
            cat "$input"
            echo
            return 1
        fi


        # Compare
        if ! diff -Z "$output" "$bf_output" > /dev/null; then
            echo
            echo "========================================"
            echo "WRONG ANSWER"
            echo "Test: $i"
            echo "========================================"
            echo

            echo "Input:"
            cat "$input"

            echo
            echo "Your answer:"
            cat "$output"

            echo
            echo "Correct answer:"
            cat "$bf_output"

            echo
            echo "Diff:"
            diff -Z "$output" "$bf_output"

            echo

            return 1
        fi

        echo "Passed test: $i"
    done
}


# ============================================================
# test_checker
#
# Testlib-based checker testing.
#
# IMPORTANT:
#
# The checker is ALWAYS invoked as:
#
#   ./ch input output answer
#
# This means the checker can always use:
#
#   inf
#   ouf
#   ans
#
# In -c mode, answer is a dummy empty file.
#
# Environment variable:
#
#   STEST_HAS_ANSWER=0
#       -c
#
#   STEST_HAS_ANSWER=1
#       -ca
#
# ============================================================

function test_checker {
    local name="$1"
    local use_answer="$2"

    if [[ -z "$name" ]]; then
        echo "Usage:"
        echo "  stest -c  <name>"
        echo "  stest -ca <name>"
        return 1
    fi

    name="${name%.cpp}"

    local solution="$name"
    local input="$name.in"
    local output="$name.out"
    local answer="$name.ans"
    local dummy_answer="$name.empty.ans"
    local checker_log="$name.chlog"

    echo
    echo "========================================"
    echo "Checker Stress Test"
    echo "========================================"
    echo "Solution : $name.cpp"
    echo "Generator: $name.gen.cpp"
    echo "Checker  : $name.checker.cpp"

    if [[ "$use_answer" == "1" ]]; then
        echo "Reference: $name.bf.cpp"
        echo "Mode     : checker + answer"
    else
        echo "Reference: none"
        echo "Mode     : checker only"
    fi

    echo "========================================"
    echo

    # --------------------------------------------------------
    # Check files
    # --------------------------------------------------------

    if [[ ! -f "$name.cpp" ]]; then
        echo "$name.cpp file does not exist."
        return 1
    fi

    if [[ ! -f "$name.gen.cpp" ]]; then
        echo "$name.gen.cpp file does not exist."
        return 1
    fi

    if [[ ! -f "$name.checker.cpp" ]]; then
        echo "$name.checker.cpp file does not exist."
        return 1
    fi

    if [[ "$use_answer" == "1" && ! -f "$name.bf.cpp" ]]; then
        echo "$name.bf.cpp file does not exist."
        echo "-ca requires $name.bf.cpp"
        return 1
    fi

    # --------------------------------------------------------
    # Compile
    # --------------------------------------------------------

    compile_cpp "$name.cpp" "$solution" || return 1
    compile_cpp "$name.gen.cpp" gen || return 1
    compile_cpp "$name.checker.cpp" ch || return 1

    if [[ "$use_answer" == "1" ]]; then
        compile_cpp "$name.bf.cpp" bf || return 1
    fi

    # --------------------------------------------------------
    # Create dummy answer for -c mode
    #
    # testlib still gets argv[3], but the checker knows
    # that this is not a real answer through STEST_HAS_ANSWER.
    # --------------------------------------------------------

    if [[ "$use_answer" != "1" ]]; then
        : > "$dummy_answer"
    fi

    echo
    echo "Starting stress test..."
    echo "Press Ctrl+C to stop."
    echo

    # --------------------------------------------------------
    # Stress loop
    # --------------------------------------------------------

    for ((i = 1; ; ++i)); do

        # ----------------------------------------------------
        # Generate input
        # ----------------------------------------------------

        if ! ./gen "$i" > "$input"; then
            echo
            echo "========================================"
            echo "GENERATOR CRASHED"
            echo "Test: $i"
            echo "========================================"
            echo
            echo "Input:"
            cat "$input"
            echo
            return 1
        fi


        # ----------------------------------------------------
        # Run solution
        # ----------------------------------------------------

        if ! "./$solution" < "$input" > "$output"; then
            echo
            echo "========================================"
            echo "SOLUTION CRASHED"
            echo "Test: $i"
            echo "========================================"
            echo
            echo "Input:"
            cat "$input"
            echo
            echo "Partial output:"
            cat "$output"
            echo
            return 1
        fi


        # ----------------------------------------------------
        # Generate reference answer if needed
        # ----------------------------------------------------

        if [[ "$use_answer" == "1" ]]; then

            if ! ./bf < "$input" > "$answer"; then
                echo
                echo "========================================"
                echo "BRUTE FORCE CRASHED"
                echo "Test: $i"
                echo "========================================"
                echo
                echo "Input:"
                cat "$input"
                echo
                return 1
            fi

            local checker_answer="$answer"
            local has_answer="1"

        else

            local checker_answer="$dummy_answer"
            local has_answer="0"

        fi


        # ----------------------------------------------------
        # Run testlib checker
        #
        # Always:
        #
        #   argv[1] = input
        #   argv[2] = contestant output
        #   argv[3] = answer/dummy answer
        #
        # ----------------------------------------------------

        STEST_HAS_ANSWER="$has_answer" \
            ./ch "$input" "$output" "$checker_answer" \
            > "$checker_log" 2>&1

        local result=$?


        # ----------------------------------------------------
        # Checker failed
        # ----------------------------------------------------

        if (( result != 0 )); then
            echo
            echo "========================================"
            echo "WRONG ANSWER"
            echo "Test: $i"
            echo "========================================"
            echo

            echo "Input:"
            cat "$input"

            echo
            echo "Your answer:"
            cat "$output"

            if [[ "$use_answer" == "1" ]]; then
                echo
                echo "Correct answer:"
                cat "$answer"
            fi

            echo
            echo "Checker output:"
            cat "$checker_log"

            echo

            return 1
        fi


        echo "Passed test: $i"
    done
}


# ============================================================
# stest
#
# Main command.
#
#   stest -d  foo
#   stest -c  foo
#   stest -ca foo
#
# .cpp is optional.
# ============================================================

function stest {
    local mode="$1"
    local name="$2"

    if [[ -z "$mode" || -z "$name" ]]; then
        echo "Usage:"
        echo
        echo "  stest -d  <name>    Differential testing"
        echo "  stest -c  <name>    Checker without answer"
        echo "  stest -ca <name>    Checker with answer"
        echo
        return 1
    fi

    name="${name%.cpp}"

    case "$mode" in

        -d)
            test_diff "$name"
            return $?
            ;;

        -c)
            test_checker "$name" 0
            return $?
            ;;

        -ca)
            test_checker "$name" 1
            return $?
            ;;

        *)
            echo "Unknown stest mode: $mode"
            echo
            echo "Usage:"
            echo
            echo "  stest -d  <name>"
            echo "  stest -c  <name>"
            echo "  stest -ca <name>"
            echo
            return 1
            ;;
    esac
}
