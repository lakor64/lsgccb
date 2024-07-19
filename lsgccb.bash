#!/bin/bash

# --- globals setup ---

root="${BASH_SOURCE[0]}"
root="$(realpath -ms "$root")"
root="$(dirname "$root")/"
bindir=${root}bin/
blddir=${root}build/
distdir=${root}dist/
patchdir=${root}comp/patches/
cpucount=5


# --- utility functions ---

print_valid_targets()
{
    for entry in "${root}comp/target"/*.bash
    do
        out=${entry%.bash*}
        out=${out#*comp/target/}
        echo $out
    done
}

print_valid_stages()
{
    for entry in "${root}comp/stages"/*.bash
    do
        out=${entry%.bash*}
        out=${out#*comp/stages/}
        echo $out
    done
    echo "(Use \`all\` to include all of them)"
}

add_all_stages()
{
    out=""
    for entry in "${root}comp/stages"/*.bash
    do
        x=${entry%.bash*}
        x=${x#*comp/stages/}
        out="$out,$x"
    done
    out=${out/,/$null}
    echo $out
}

# --- main bootstrap ---

# print arguments
if ! [[ $1 ]]; then
    echo "Usage: ${BASH_SOURCE[0]} [target] (stage)"
    echo
    echo "Available targets:"
    print_valid_targets
    echo
    echo "Available stages:"
    print_valid_stages
    exit 0
fi

# target check
if ! [[ -e "comp/target/$1.bash" ]]; then
    echo "Invalid target \[$1\], please specify a valid target"
    echo
    echo "Valid targets are:"
    print_valid_targets
    exit 1
fi

target=${1}

# load target!
source "${root}comp/target/${target}.bash"

# stages check
if [[ $2 ]];  then
    stages_input=$2
    if [ "$2" = "all" ]; then
        stages_input="$(add_all_stages)"
    fi
    
    IFS=',' read -r -a stages <<< "$stages_input"

	for element in ${stages[@]}
	do
		if ! [[ -e comp/stages/$element.bash ]]; then
			echo "Invalid stage [$element], please specify a valid stage"
			echo
			echo "Valid stages are:"
			print_valid_stages
			exit 1
		fi
	done
else
	stages=${default_stages[@]}
fi

if [[ $BINDIR ]]; then
    bindir=$BINDIR
fi
if [[ $BUILDDIR ]]; then
    blddir=$BUILDDIR
fi
if [[ $DISTDIR ]]; then
    distdir=$DISTDIR
fi
if [[ $CPUCOUNT ]]; then
    cpucount=$CPUCOUNT
fi

echo Output dir: \[${bindir}\]
echo Build dir: \[${blddir}\]
echo Dist dir: \[${distdir}\]
echo Target: \[${target}\]
echo Stages: \[${stages[@]}\]
echo CPU count: \[${cpucount}\]

if ! [[ $QUIET ]]; then
    echo Are this settings correct? \[yes/no\]
    read option
    case $option in
        "no"|"n")
            echo Please adjust the variables accordingly
            exit 0
            ;;
        "yes"|"y")
            ;;
        *)
            echo Invalid choice, defaulting to no...
            exit 0
            ;;
    esac
fi

clear

mkdir -p ${distdir}
mkdir -p ${bindir}/${target}

source "${root}comp/utils.bash"

for stage in $stages
do
    mkdir -p ${blddir}/${target}/${stage}/
    source "${root}comp/stages/${stage}.bash"
    run_stage
done
