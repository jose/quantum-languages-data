#!/usr/bin/env bash
#
# ------------------------------------------------------------------------------
# This script replaces non ASCII characters with ASCII characters.
#
# Usage:
# fix-data-headers.sh
#   [--data_file <path, survey.csv (by default)>]
#   [help]
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"

#
# Print error message to the stdout and exit.
#
die() {
  echo "$@" >&2
  exit 1
}


# ------------------------------------------------------------------------- Args

USAGE="Usage: ${BASH_SOURCE[0]} \
  [--data_file <path, survey.csv (by default)>] \
  [help]"
if [ "$#" -ne "0" ] && [ "$#" -ne "1" ] && [ "$#" -ne "2" ]; then
  die "$USAGE"
fi

data_file="$SCRIPT_DIR/survey.csv"

while [[ "$1" = --* ]]; do
  OPTION=$1; shift
  case $OPTION in
    (--data_file)
      data_file=$1;
      shift;;
    (--help)
      echo "$USAGE"
      exit 0
    (*)
      die "$USAGE";;
  esac
done

[ "$data_file" != "" ] || die "[ERROR] Missing --data_file argument!"
[ -s "$data_file" ]    || die "[ERROR] $data_file does not exist or it is empty!"

# ------------------------------------------------------------------------- Main

# Fix header
head -n1 "$data_file" | \
  sed 's|𝐐𝐮𝐚𝐧𝐭𝐮𝐦 𝐏𝐫𝐨𝐠𝐫𝐚𝐦𝐦𝐢𝐧𝐠 𝐋𝐚𝐧𝐠𝐮𝐚𝐠𝐞𝐬|Quantum Programming Languages|g' | \
  sed 's|𝐩𝐫𝐨𝐟𝐞𝐬𝐬𝐢𝐨𝐧𝐚𝐥𝐥𝐲|professionally|g' | \
  sed 's|𝐩𝐫𝐢𝐦𝐚𝐫𝐲|primary|g' | \
  sed 's|𝗱𝗼 𝗻𝗼𝘁 𝗹𝗶𝗸𝗲|do not like|g' | \
  sed 's|𝗹𝗶𝗸𝗲 𝘁𝗵𝗲 𝗺𝗼𝘀𝘁|like the most|g' | \
  sed 's/𝐿𝐼𝑄𝑈𝑖|⟩/LIQUi|>/g' | \
  sed 's/𝑄|𝑆𝐼⟩/Q|SI>/g' | \
  sed 's|𝜆𝑞 (Lambda Calculi)|Lambda Calculi|g' > "$data_file.tmp"

# Get content
tail -n +2 "$data_file" >> "$data_file.tmp"

# Replace input
mv "$data_file.tmp" "$data_file"

echo "DONE!"
exit 0

# EOF
