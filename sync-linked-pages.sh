#!/bin/sh
echo "Knowl script running to review linked documents..."

BIN_PATH="$HOME"
WORKING_DIR="$BIN_PATH/knowl_temp"
KNOWL_CLI_NAME="knowl-cli"
#CLI_DOWNLOAD_URL_MAC='https://releases.knowl.io/cli/mac/Contents/MacOS/knowl-cli'	
CLI_DOWNLOAD_URL_LINUX='https://releases.knowl.io/cli/linux/knowl-cli'	
#VERSION_FILE_URL_MAC='https://releases.knowl.io/cli/mac/version.txt'	
VERSION_FILE_URL_LINUX='https://releases.knowl.io/cli/linux/version.txt'

#VERSION_FILE_NAME="version.txt"


verify_wget() {
    BIN_WGET=$(which wget) || {
        echo "You need to install 'wget' to use this hook."
    }
}

verify_tmp() {
    touch $BIN_PATH || {
        error_out "Could not write to $BIN_PATH"
    }
}

create_working_dir(){
    working_dir=$1
    if [ ! -d "$working_dir" ]
        then
            mkdir -p -- "$working_dir"
    fi
}


get_machine_os() {
    unameOut="$(uname -s)"
    case "${unameOut}" in
    Linux*)     machine_type=linux;;
    Darwin*)    machine_type=mac;;
    CYGWIN*)    machine_type=cygwin;;
    MINGW*)     machine_type=minGw;;
    *)          machine_type="UNKNOWN:${unameOut}"
    esac
}

download_from_link() {
    echo "download begins ..."
    echo "$1"
    download_url="$1"
    directory_name="$2"
    file_path="$3"
    
    create_working_dir $directory_name
    $BIN_WGET --no-check-certificate $download_url -O $file_path
    chmod +x $file_path
    echo "download ends ..."

}

check_knowl_cli_version() {
    echo "downloading the latest cli version"
    cli_file_url=$CLI_DOWNLOAD_URL_LINUX
    #get folder names in the working directory
    download_from_link $cli_file_url $WORKING_DIR/ $WORKING_DIR/$KNOWL_CLI_NAME

    export PATH=$PATH:$WORKING_DIR

}

cleanup() {
    echo "Cleaning up..."
}

#machine_type=""
verify_wget
verify_tmp
check_knowl_cli_version
knowl-cli knowl-cli-pr-request
cleanup

