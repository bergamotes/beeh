#!/usr/bin/env bash
#
# 2mp3.sh v0.0
# Convert music file (.wav, .opus, .ogg,...) into .mp3 with ffmpeg
# 2020/07/21 - Edouard De Grave (edouarddegrave@gmail.com)
# on GNU bash, version 4.4.12(1)-release (x86_64-pc-linux-gnu)
# with Coreutils 8.26-3
#
#
# Description:
#    Convert music file (.wav, .opus, .ogg,...) into .mp3 with ffmpeg
#
# Notes:
#    Made for batch processing .opus files from youtube-dl
#
# Requires:
#    GNU bash, version 4.4.12(1)-release (x86_64-pc-linux-gnu)
#    ffmpeg
#
# Usage:
#    NOT WORKING!!!
#    $ 2mp3.sh listOfFiles.txt
#    $ find . -name *.opus -print0 | 2mp3.sh
#    reads from stdin or file with list of filenames
#    Helpful message describing script process, good practices,
#    quirks and features. Mention defaults if any.
#    Example: oneliner example
# files=()
# mapfile -d $'\0' files < <(find $1 -name "${2}" -print0)
# files=$(find $1 -name "*.opus" -print0)

# for f in *.opus; do ffmpeg -i "$f" -f mp3 "${f%.*}.mp3"; done

# for dir in ./*/     # list directories in the form "/tmp/dirname/"
# do
#     dir=${dir%*/}      # remove the trailing "/"
#     echo "${dir##*/}"    # print everything after the final "/"
#     for f in "${dir}"*.opus;
#     do
#         echo "converting ${f}";
#         echo "to ${f%.*}.mp3";
#         # ffmpeg -i "$f" -f mp3 "${f%.*}.mp3"; done
#     done
# done

find . -type f -name '*.opus' -print0 |
while IFS= read -r -d '' file; do
    # output to /dev/null to avoid having ffmpeg read its own output
    # and trigger weird behavior
    printf '>>> %s\n' "${file}";
    < /dev/null ffmpeg -y -i "${file}" -f mp3 "${file%.*}.mp3";
    rm "${file}"
done

# for filename in *.opus; do
#     outfile="${filename%.*}.mp3"
#     ffmpeg -i "${filename}" -f mp3 "${outfile}";
#     unlink "${filename}"
# done

# while read filename;
# do
#     outfile="${filename%.*}.mp3"
#     # echo "${filename}" "${outfile}"
#     ffmpeg -i "${filename}" "${outfile}";
#     unlink "${filename}"
# done < $1
# for filename in $files; do
#     outfile="${filename%.*}.mp3"
#     echo $filename $outfile
#     #ffmpeg -i "${filename}" "${outfile}";
#     #unlink "${filename}"
# done
