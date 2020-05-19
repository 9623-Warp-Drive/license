#!/usr/bin/env bash
#
# Add license to current directory
#
# Dependency: skim or fzf

if command -v sk > /dev/null; then
        FUZZY=sk
elif command -v fzf > /dev/null; then
        FUZZY=fzf
else
        echo 'missing: skim or fzf'
fi

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
LICENSE=$(ls $REPO/list 2> /dev/null | $FUZZY --color=16 --preview="cat $REPO/list/{}" -q "$*")

main() {
        if [[ ! -z $LICENSE ]]; then
                printf 'Enter copyright year: '
                read year
                printf 'Enter name of copyright owner: '
                read name
                sed "s/\[year\]/$year/g;s/\[fullname\]/$name/g" $REPO/list/$LICENSE > ./LICENSE
        else
                return 0
        fi
}

main '$@'
