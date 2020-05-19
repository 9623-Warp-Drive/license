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
LICENSE=$(ls $REPO/list | $FUZZY --color=16)

main() {
        command cp -v $REPO/list/$LICENSE ./LICENSE
}

main '$@'
