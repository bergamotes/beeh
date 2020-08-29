#!/usr/bin/env bash
#
#
# rename.sh.sh v0.0
# Change file name if longer than n character
# 2020/08/21 - Edouard De Grave (edouarddegrave@gmail.com)
# on GNU bash, version 4.4.12(1)-release (x86_64-pc-linux-gnu)
# with Coreutils 8.26-3
#
#
# Description:
#    Change file name if longer than n character
#    Defaults to 60 characters
#
# Notes:
#
#
# Requires:
#    GNU bash, version 4.4.12(1)-release (x86_64-pc-linux-gnu)
#
# Usage:
#    rename.sh nchars
#    Helpful message describing script process, good practices,
#    quirks and features. Mention defaults if any.
#    Example: oneliner example
i=0
rank=1
nchars=60
[[ -z $1 ]] && echo "No char limit provided - defaults to 60 chars" \
            || nchars=${1}
[[ -z $2 ]] && echo "No rank provided - start at beginning" \
            || rank=${1}
IFS=$'\n'
for album in $(find . -mindepth 2 -type f -name 'NA*.mp3');
# for album in $(find . -type d);
do
    echo
    echo "${album}";
    i=$((i+1))
    [[ ${i} -lt $2 ]] && continue
    [[ ${#album} -lt ${nchars} ]] && continue
    extras=$(( ${#album} - ${nchars} ))
    echo "> [${#album}] ${extras} extra characters >> replace below: "
    read -p '' -r new;
    if [[ ${#new} -gt 60 ]]
    then
    echo "> ${#new} characters!!! >> try again below: "
    read -p '' -r new;
    fi
    [[ ! -z ${new} ]] && mv -v "${album}" "${new}" || echo "filename has not changed";
done

