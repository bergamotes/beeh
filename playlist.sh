#!/usr/bin/env bash
#
# playlist.sh v0.0
# Outputs .tsv overview of mp3 files in Music directory
# 2020/08/11 - Edouard De Grave (edouarddegrave@gmail.com)
# on GNU bash, version 4.4.12(1)-release (x86_64-pc-linux-gnu)
# with Coreutils 8.26-3
#
#
# Description:
#    Outputs .tsv overview of mp3 files in Music directory
#
# Notes:
#    Made for viewing playing order of SD card mp3 player
#    in Julien's estive
#    Render to svg for shareable/color coded image.
#
# Requires:
#    GNU bash, version 4.4.12(1)-release (x86_64-pc-linux-gnu)
#
# Usage:
#    ./playlist.sh > playlist.tsv

i=1
na='./NA'
format="%03d\t(%02d)\t%s\t%s\n"
# format="%03d\t%s\t%(%02d)\t%s\n"
find . -type d -print0 | while read -d '' -r dir; do
    mp3s=$(find "${dir}" -maxdepth 1 -type f -name '*.mp3' | wc -l)
    [ "$mp3s" == '0' ] && continue
    if [ "$dir" == "$na" ] || [ "$dir" == '.' ]
    #if [[ "$dir" =~ \.\/NA|\. ]]
    then
        IFS=$'\n'
        for album in $(find "${dir}" -maxdepth 1 -type f -name '*.mp3'); do
            album=${album/'./NA/'/}
            if [ "$dir" == '.' ]
            then
              album=${album/'./'/}
            fi
            # Set album identifier
            # case "${album}" in
            #     Album) item="*" ;;
            #     *) echo "${album}";item="." ;;
            # esac
            [[ "$album" =~ "(" ]] && item="*" || item="."

            printf "%03d\t%3s\t%s\n" $i "${item}" "${album/'.mp3'/}"

            i=$((i+1))
        done
        IFS=' '
    else
        # printf "${format}" $i "${mp3s}" "/" "$dir"
        # printf "%03d\t%s%02d\t%s\n" $i "/" "${mp3s}" "${dir/'./'/}"
        dir=${dir/'./'/}
        printf "%03d\t%s%s\t%s\n" $i "/" "+" "${dir/'/'/' - '}"
        i=$((i+mp3s))
    fi
done
