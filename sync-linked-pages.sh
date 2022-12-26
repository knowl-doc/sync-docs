#!/bin/sh
echo "Knowl script running to review linked documents..."

BIN_PATH="$HOME"
WORKING_DIR="$BIN_PATH/knowl_temp"
KNOWL_CLI_NAME="knowl-cli"
CLI_DOWNLOAD_URL='https://releases.knowl.io/cli/linux/knowl-cli'
PRE_COMMIT_TYPE=$1 #0 - for blocker, 1 for non-blocker
TEMP_DATA_FILE="$WORKING_DIR/tmp_data.txt"
EVENT_PR_REQUEST = 'pr_request'




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
    cli_file_url=$CLI_DOWNLOAD_URL
    #get folder names in the working directory
    download_from_link $cli_file_url $WORKING_DIR/ $WORKING_DIR/$KNOWL_CLI_NAME

    export PATH=$PATH:$WORKING_DIR

}

cleanup() {
    rm $TEMP_DATA_FILE
    echo "Cleaning up..."
}

#machine_type=""
verify_wget
verify_tmp
check_knowl_cli_version
echo $EVENT_PR_REQUEST
echo $$TEMP_DATA_FILE
./knowl-cli cli $EVENT_PR_REQUEST $TEMP_DATA_FILE
is_pass=$(head -n 1 $TEMP_DATA_FILE)
echo $is_pass 
if [ $is_pass -eq 0 ]
    then 
        echo "error: block pull request"
        exit 1
fi
cleanup

