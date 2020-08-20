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
	echo 'error: could not find either fzf or skim, is it installed?'
	exit 1
fi

REPO=${BASH_SOURCE%/*}
mapfile -t LICENSE < <(find "$REPO/list" -type f 2> /dev/null | $FUZZY --multi --color=16 --preview="cat {}" -q "$*")

[[ -n "$LICENSE" ]] || {
	echo 'error: no license is selected'
	exit 1
}

printf 'Enter copyright year: ' && read -r year
printf 'Enter name of copyright owner: ' && read -r name

if [[ ${#LICENSE[@]} -eq 1 ]]; then
	for license in "${LICENSE[@]}"; do
		sed "s/\[year\]/$year/g;s/\[fullname\]/$name/g" "$license" > ./LICENSE
	done
elif [[ ${#LICENSE[@]} -gt 1 ]]; then
	mkdir ./LICENSE || exit 1
	for license in "${LICENSE[@]}"; do
		sed "s/\[year\]/$year/g;s/\[fullname\]/$name/g" "$license" > "./LICENSE/$(basename -- "$license")"
	done
fi
