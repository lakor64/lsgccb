#!/bin/bash

# --- globals setup ---

root="${BASH_SOURCE[0]}"
root="$(realpath -ms "$root")"
root="$(dirname "$root")/"
bin_dir="${root}bin/"
build_dir="${root}build/"
dist_dir="${root}dist/"
patch_dir="${root}comp/patches/"
tar_dir="${dist_dir}downloads/"
target_dir="${root}comp/target/"
stages_dir="${root}comp/stages/"
cache_dir=""
cpucount=5


# --- utility functions ---

print_valid_targets()
{
    for entry in "$target_dir"/*.bash
    do
        out=${entry%.bash*}
        out=${out#*comp/target//}
        echo "$out"
    done
}

print_valid_stages()
{
    for entry in "$stages_dir"/*.bash
    do
        out=${entry%.bash*}
        out=${out#*comp/stages//}
        echo "$out"
    done
    echo "(Use \`all\` to include all of them)"
}

add_all_stages()
{
    out=""
    for entry in "$stages_dir"/*.bash
    do
        x=${entry%.bash*}
        x=${x#*comp/stages//}
        out="$out,$x"
    done
    out=${out/,/$null}
    echo "$out"
}

# --- main bootstrap ---

# print arguments
if ! [[ $1 ]]; then
    echo "Usage: ${BASH_SOURCE[0]} [target] [stage]"
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
source "$target_dir${target}.bash"

# stages check
if [[ $2 ]];  then
    stages_input=$2
    if [ "$2" = "all" ]; then
        stages_input="$(add_all_stages)"
    fi
    
    IFS=',' read -r -a stages <<< "$stages_input"

	for element in "${stages[@]}"
	do
		if ! [[ -e "comp/stages/$element.bash" ]]; then
			echo "Invalid stage [$element], please specify a valid stage"
			echo
			echo "Valid stages are:"
			print_valid_stages
			exit 1
		fi
	done
else
    echo "No stages specified!"
    echo
    echo "Valid stages are:"
    print_valid_stages
    exit 1
fi

if [[ $BINDIR ]]; then
    bin_dir=$BINDIR
fi
if [[ $BUILDDIR ]]; then
    build_dir=$BUILDDIR
fi
if [[ $DISTDIR ]]; then
    dist_dir=$DISTDIR
fi
if [[ $CPUCOUNT ]]; then
    cpucount=$CPUCOUNT
fi

echo "Output dir: [" "$bin_dir" "]"
echo "Build dir: [" "$build_dir" "]"
echo "Dist dir: [" "$dist_dir" "]"
echo "Target: [" "$target" "]"
echo "Stages: [" "${stages[@]}" "]"
echo "CPU count: [" "$cpucount" "]"

if ! [[ $QUIET ]]; then
    echo Are this settings correct? \[yes/no\]
    read -r option
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

mkdir -p "${tar_dir}"
mkdir -p "${dist_dir}"
mkdir -p "${bin_dir}${target}"

source "${root}comp/utils.bash"

for stage in "${stages[@]}"
do
    mkdir -p "${build_dir}${target}/${stage}/"
    source "${stages_dir}${stage}.bash"
    cache_dir="${dist_dir}${stage_target}-cache/"
    mkdir -p "${cache_dir}"
    run_stage
done
