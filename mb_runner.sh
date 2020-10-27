#!/bin/bash

# This is just a little helper-script to make ConnectIQ-development on UNIX-systems easier (without using the Eclipse-plugin).
#
# Based on the (Linux) ConnectIQ SDK 3.1.0
# ( https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.1.6-2019-10-23-2de4665c6.zip )
#
# The following tasks can be invoked:
#   * compiling (re)sources and building a PRG-file for testing
#   * run unit-tests (requires a running simulator)
#   * creating a signed IQ-file package for publishing
#   * cleaning up previously built files
#   * starting the ConnectIQ-simulator
#   * pushing the generated PRG-file to the running simulator
#
# Usage:
#   mb_runner.sh {build|test|package|clean|simulator|push} [full-path-to-ciq-project-root] [relative-resources-folder-path] [relative-source-folder-path]
#
# Example (for a standard project with jungle-file; script directly run from within project-root):
#   mb_runner.sh package
#
# Example (for a standard project with jungle-file; using a specified project-root):
#   mb_runner.sh package /home/achim/projects/HueCIQ
#
# Example (for a "legacy" project WITHOUT jungle file; using custom paths for root/resources/sources):
#   mb_runner.sh package /home/achim/projects/HueCIQ resources source

# **********
# env checks
# **********

[ -z "${MB_HOME}" ] && { echo "MB_HOME not set!"; exit 1; }
[ -z "${MB_PRIVATE_KEY}" ] && { echo "MB_PRIVATE_KEY not set!"; exit 1; }

# ***********
# param check
# ***********

case "${1}" in
   build|test|package|clean|simulator|push)
      ;;
   *)
      echo "Usage: `basename ${0}` {build|test|package|clean|simulator|push} [full-path-to-ciq-project-root] [relative-resources-folder-path] [relative-source-folder-path]"
      exit 1
      ;;
esac

if [ -n "${2}" ]; then
   PROJECT_HOME="${2}"
else
   PROJECT_HOME="${PWD}"
fi

if [ ! -n ${3} ]; then
   RESOURCES_FOLDER="${3}"
else
   RESOURCES_FOLDER="resources"
fi

if [ ! -n ${4} ]; then
   SOURCE_FOLDER="${4}"
else
   SOURCE_FOLDER="source"
fi

# *****************
# defaults & config
# *****************

JUNGLE_FILES=("${PROJECT_HOME}/monkey.jungle")
TEST_JUNGLE_FILES=("${PROJECT_HOME}/test.jungle" "${PROJECT_HOME}/test_barrels.jungle")
MANIFEST_FILE="${PROJECT_HOME}/manifest.xml"
CONFIG_FILE="${PROJECT_HOME}/mb_runner.cfg"

if [ ! -e "${CONFIG_FILE}" ] ; then
    echo "Config file \"${CONFIG_FILE}\" not found!"
    exit 1
else
    source "${CONFIG_FILE}"
fi

[ -z "${APP_NAME}" ] && { echo "APP_NAME not set!"; exit 1; }

OUT_DIR="${PROJECT_HOME}/bin"

# ******************
# sdk specific stuff
# ******************

API_DB="${MB_HOME}/bin/api.db"
PROJECT_INFO="${MB_HOME}/bin/projectInfo.xml"
API_DEBUG="${MB_HOME}/bin/api.debug.xml"
DEVICES="${MB_HOME}/bin/devices.xml"

# **********
# processing
# **********

# possible parameters ...

#PARAMS+="--apidb \"${API_DB}\" "
#PARAMS+="--buildapi "
#PARAMS+="--configs-dir <arg> "
#PARAMS+="--device \"${TARGET_DEVICE}\" "
#PARAMS+="--package-app "
#PARAMS+="--debug "
#PARAMS+="--excludes-map-file <arg> "
#PARAMS+="--import-dbg \"${API_DEBUG}\" "
#PARAMS+="--write-db "
#PARAMS+="--manifest <arg> "
#PARAMS+="--api-version <arg> "
#PARAMS+="--output \"${APP_NAME}.prg\" "
#PARAMS+="--project-info \"${PROJECT_INFO}\" "
#PARAMS+="--release "
#PARAMS+="--sdk-version \"${TARGET_SDK_VERSION}\" "
#PARAMS+="--unit-test "
#PARAMS+="--devices \"${DEVICES}\" "
#PARAMS+="--version "
#PARAMS+="--warn "
#PARAMS+="--excludes <arg> "
#PARAMS+="--private-key \"${MB_PRIVATE_KEY}\" "
#PARAMS+="--rez <arg> "
function common_params
{
  local -n JUNGLES=$1
  #PARAMS+="--sdk-version \"${TARGET_SDK_VERSION}\" "

  PARAMS+="--apidb \"${API_DB}\" "
  PARAMS+="--import-dbg \"${API_DEBUG}\" "
  PARAMS+="--project-info \"${PROJECT_INFO}\" "

  PARAMS+="--warn "

  JUNGLES=$(printf "%s;" "${JUNGLES[@]}")
  JUNGLES=${JUNGLES::-1}
  PARAMS+="-f $JUNGLES "
}

function params_for_package
{
    common_params JUNGLE_FILES
    GIT_VER=$(git describe --long --dirty)
    PARAMS+="-o \"${OUT_DIR}/${APP_NAME}-${GIT_VER}.barrel\" "
}

function params_for_build
{
    common_params JUNGLE_FILES
    PARAMS+="-o \"${OUT_DIR}/${APP_NAME}.barrel\" "
}

function params_for_test
{
    common_params TEST_JUNGLE_FILES
    PARAMS+="--unit-test "
    PARAMS+="-d \"${TARGET_DEVICE}\" "
    PARAMS+="-o \"${OUT_DIR}/${APP_NAME}.prg\" "
    PARAMS+="--private-key \"${MB_PRIVATE_KEY}\" "
}

function prep_out_dir
{
if [ ! -d "$OUT_DIR" ]; then
  mkdir $OUT_DIR
fi
}

function barrel
{
    "${MB_HOME}/bin/barrelbuild" ${PARAMS}
}

function build_tests
{
    "${MB_HOME}/bin/monkeyc" ${PARAMS}
}

function tests
{
    "${MB_HOME}/bin/monkeydo" "${OUT_DIR}/${APP_NAME}.prg" "${TARGET_DEVICE}" -t
}

function clean
{
    rm -rf $OUT_DIR
}

function simulator
{
    SIM_PID=$(ps aux | grep simulator | grep -v "grep" | grep -v `basename "${0}"` | awk '{print $2}')
    [[ ${SIM_PID} ]] && kill ${SIM_PID}

    "${MB_HOME}/bin/connectiq" &
}

###

cd ${PROJECT_HOME}

case "${1}" in
   build)
        prep_out_dir
        params_for_build
        barrel
        ;;
   package)
        prep_out_dir
        params_for_package
        barrel
        ;;
   test)
        prep_out_dir
        params_for_test
        build_tests
        tests
        ;;
   clean)
        clean
        ;;
   simulator)
        simulator
        ;;
esac
