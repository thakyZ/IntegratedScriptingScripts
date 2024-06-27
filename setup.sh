#!/bin/bash

# Path to a minecraft instance with IntegratedScripting installed and one SinglePlayer save.
MINECRAFT_PATH="${1}";

if [[ -z "${MINECRAFT_PATH}" ]]; then
  read -rp "Path to minecraft folder (See script file for info): " MINECRAFT_PATH
fi

TYPING_FILE_END_PATH="integratedscripting/integratedscripting.d.ts";

# Fetched from https://stackoverflow.com/a/246128/1112800
function get_script_path() {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -L "${SOURCE}" ]; do # resolve $SOURCE until the file is no longer a symlink
    TARGET=$(readlink "${SOURCE}")
    if [[ $TARGET == /* ]]; then
      SOURCE=$TARGET
    else
      DIR=$(dirname "${SOURCE}")
      SOURCE="${DIR}/${TARGET}" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    fi
  done
  RDIR=$(dirname "${SOURCE}")
  DIR=$(cd -P "${RDIR}" >/dev/null 2>&1 && pwd)
  echo "${DIR}"
}

output_path="$(get_script_path)/typings/integratedscripting.d.ts"

saves_path="${MINECRAFT_PATH}/saves"
saves=$(ls -d "${saves_path}/*/")
typing_file_path=""
for save in "${saves[@]}"; do
  if [[ -z "${typing_file_path}" ]]; then
    typing_file_path="${save}/${TYPING_FILE_END_PATH}"
  fi

  if [[ ! -f "${typing_file_path}" ]]; then
    typing_file_path=""
  fi
done

if [[ -z "${typing_file_path}" ]]; then
  echo "Failed to find the IntegratedScripting typing file at \"${saves_path}/<save>/${TYPING_FILE_END_PATH}\".";
  exit 1;
fi

ln -s "${output_path}" "${typing_file_path}";
exit $?;