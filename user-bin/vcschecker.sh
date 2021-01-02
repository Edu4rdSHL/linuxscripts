#!/usr/bin/env sh
STATIC_NAME="VCS checker"
VERSION="1.0"

summary() {
  if [ "$TO_UPDATE_COUNTER" -eq 0 ]; then
    echo
    echo "No packages to update, leaving."
  else
    echo
    echo "Packages to update: $TO_UPDATE_COUNTER"
    echo "Packages list saved in: $OUTPUT_FILE"
  fi
}

ctrl_c() {
  echo "Keyboard Interrupt detected, leaving."
  echo
  summary
  exit
}

trap ctrl_c 2

version() {
  echo "$STATIC_NAME version $VERSION"
}

usage() {
  echo "Menu usage for $STATIC_NAME"
  echo 
  echo "-h/--help	      Show this help menu."
  echo "-v/--version    Prints the version number."
  echo "-o/--output   	Path to the output filename for the list of packages to update. Default: Curren_dir/to_update.txt."
  echo "-p/--pkgpath  	Path to the directory having the packages directories. Default: Current directory."
  echo "-k/--holdver	  Do not update pkgver inside the PKGBUILD. Default: false."
}

HOLD_PKGVER=false
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -v|--version)
    version
    exit
    ;;
    -h|--help)
    usage
    exit
    ;;
    -o|--output)
    OUTPUT_FILE="$2"
    shift
    shift
    ;;
    -p|--pkgpath)
    PKGBUILDS_PATH="$2"
    shift
    shift
    ;;
    -k|--holdver)
    HOLD_PKGVER=true
    shift
    ;;
    *)
    POSITIONAL+=("$1")
    shift
    ;;
  esac
done
set -- "${POSITIONAL[@]}"

if [ -z "$PKGBUILDS_PATH" ]; then
  PKGBUILDS_PATH="$(pwd)"
fi

if [ -z "$OUTPUT_FILE" ]; then
  OUTPUT_FILE="$PKGBUILDS_PATH/to_update.txt"
fi

TO_UPDATE_COUNTER=0;

for f in "$PKGBUILDS_PATH"/*; do
  pkgbuild_path="$f/PKGBUILD"
  if [ -f "$pkgbuild_path" ]; then
  matches="$(grep -c 'git+\|pkgver()' "$pkgbuild_path")"
    if [ -f "$pkgbuild_path" ] && [ "$matches" -eq 2 ]; then
      . "$pkgbuild_path"
      echo "Git VCS detected for $pkgname."
      remote_ver="$(GIT_TERMINAL_PROMPT=0 git ls-remote "${source/*git+/}" HEAD | head -c 7)"
      if [[ $pkgver =~ $remote_ver ]]; then
        echo "Package $pkgname is up to date."
      else
        echo "Package $pkgname is outdated, adding to $OUTPUT_FILE"
        echo "$pkgname" >> "$OUTPUT_FILE"
        TO_UPDATE_COUNTER=$((TO_UPDATE_COUNTER + 1))
        if ! $HOLD_PKGVER; then
  	      clone_path="$f/$pkgname"
          git clone -q "${source/*git+/}" "$clone_path" && cd "$clone_path" || return
          current_ver="$(pkgver 2>/dev/null)"
          sed -i "s/pkgver=.*/pkgver=$current_ver/" "$pkgbuild_path"
	        echo "pkgver for $pkgname was updated in the PKGBUILD."
      	  cd "$PKGBUILDS_PATH" && rm -rf "$clone_path"
	      fi
      fi
    fi
  fi
done

summary
