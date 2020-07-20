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

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
LICENSE=$(ls "$REPO/list" 2> /dev/null | $FUZZY --multi --color=16 --preview="cat $REPO/list/{}" -q "$*")
LICENSE_ARRAY=($(echo "$LICENSE" | tr " " "\n"))

main() {
	if [[ -n "$LICENSE" ]]; then
		printf 'Enter copyright year: '
		read -r year
		printf 'Enter name of copyright owner: '
		read -r name

		if [[ ${#LICENSE_ARRAY[@]} -eq 1 ]]; then
			sed "s/\[year\]/$year/g;s/\[fullname\]/$name/g" "$REPO/list/$LICENSE" > ./LICENSE
		elif [[ ${#LICENSE_ARRAY[@]} -gt 1 ]]; then
			mkdir ./LICENSE
			for license in "${LICENSE_ARRAY[@]}"; do
				sed "s/\[year\]/$year/g;s/\[fullname\]/$name/g" "$REPO/list/$license" > ./LICENSE/"$license"
			done
		fi

	else
		echo 'error: no license is selected'
		exit 1
	fi
}

main '$@'
