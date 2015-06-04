function debug() {
    if [[ X${DEBUGON} == X"TRUE" ]]; then
        echo "$*"
    fi
}

function abort() {
    echo "ERROR: $*" >/dev/stderr
    echo "exiting..." >/dev/stderr
    exit 1
}
function abend() {
    abort $*
}
