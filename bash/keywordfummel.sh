#!/bin/bash

# this should eventually find entries in package.accept_keywords for which stable package versions
# exist and which are not required as unstable by any installed package

check() {
    equery --no-color --quiet l --exclude-installed --portage-tree --format='$cpv $mask' $1 | \
    while read atom mask; do
        if [[ "$mask" =~ ^\s*$ ]]; then
            echo "      $atom"
        #else
            #echo "    masked: >>>>> $atom ==== $mask"
        fi
    done
}

files=/etc/portage/package.accept_keywords/*
for file in ${files}; do
    echo "Checking ${file}"
    while read atom keyword; do
        [[ ! "${keyword}" =~ ^~.* ]] && continue
        echo -n "  - ${atom} ${keyword}"
        if ! equery --quiet l ${atom} > /dev/null; then
            echo " (not installed)"
            continue
        else
            echo ":"
            check ${atom}
        fi
    done < ${file}
done


