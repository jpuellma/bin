#!/usr/bin/env bash
debugon=${debugon:-false}
dump_on_exit=${dump_on_exit:-false}
# set -o errexit
# set -o pipefail
# set -o nounset
# set -o xtrace

# Global vars
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__name="$(basename ${__file})"
(( verbosity=0 ))


do_exit_trap() {
# Take care of any last minute business before exiting.
# - If debug is true, _OR_ if dump_on_exit is true, then dump the env
# - cd back to original directory.
# Input: None.
# Output: If dump is set, then all env vars are sorted and output.
    if [[ "${dump_on_exit}" = "true" ]]; then
        env|sort
    fi
    original_dir=${original_dir:-.}
    cd "${original_dir}" || log_error "Couldn't cd back to original dir."
    set +ex

}  # end do_exit_trap()
trap do_exit_trap EXIT


log_debug() {
# Print formatted message _only_ if debug flag is set.
# Input: String
# Output: Formatted string.
# Returns: 0
    if [[ "${debugon}" == "true" ]]; then
        printf 'Debug [%s: %s]: %s\n' "${__name}" "${FUNCNAME[1]}" "$*" > /dev/stderr
    fi
}  # end log_debug()


log_error() {
# Print formatted error message.
# Input: String
# Output: Formatted string.
# Returns: 0
    printf 'Error [%s: %s]: %s\n' "${__name}" "${FUNCNAME[1]}" "$*" > /dev/stderr
}  # end log_error()


log_info() {
# Print formatted message.
# Input: String
# Output: Formatted string.
# Returns: 0
    printf '[%s]: %s\n' "${__name}" "$*"
}  # end log_info()


do_get_args() {
# Read cmdline args and set global variables.
# Check do_print_usage() for details on args.
# Input: "$@"
# Output: None.
# Returns: 0
    log_debug "Begin ${FUNCNAME[0]}()."
    local return_value
    package_type="unset"
    one_per_line=false
    while getopts ":hvfrcdn" opt; do
        case ${opt} in
            h)
                do_print_usage
                exit 0
                ;;
            v)
                (( verbosity++ ))
                ;;
            d)
                package_type="dpkg"
                ;;
            f)
                package_type="formula"
                ;;
            r)
                package_type="rpm"
                ;;
            c)
                package_type="cask"
                ;;
            n)
                one_per_line=true
                ;;
            \?)
                log_error "Invalid option -${OPTARG}." >& /dev/stderr
                exit 1
                ;;
            :)
                log_error "Option -${OPTARG} requires an argument." >& /dev/stderr
                exit 1
                ;;
        esac
    done
    if [[ ${verbosity} -ge 2 ]]; then
        debugon=true
    fi
    log_debug "verbosity is ${verbosity}."
    log_debug "package type arg is \"${package_type}\"."
    log_debug "End ${FUNCNAME[0]}(). Returning ${return_value}."
    return ${return_value}
}  # end do_get_args()


do_print_usage() {
# Print a usage message for this tool.
# Input: None.
# Output: Formatted usage message (multiline).
# Returns: 0
    log_debug "Begin ${FUNCNAME[0]}."
    cat << eof
Usage: ${__name} [ -h ] [ -d | -r | -f | -c ] [ -n ]
    -h      Print this help message.
    -d      Output a list of installed dpkg packages.
    -f      Output a list of installed homebrew formulae.
    -c      Output a list of installed homebrew casks.
    -r      Output a list of installed rpm packages.
    -n      Optional: print one package per line.
eof
    log_debug "End ${FUNCNAME[0]}."
}  # end do_print_usage()


do_setup() {
# Prelminary setup actions.
# - Save original dir as a global so we can cd back to it later.
# Input: None.
# Output: None.
# Returns: 0 for success; 1 on error.
    log_debug "Begin ${FUNCNAME[0]}()."
    local return_value
    original_dir="$(pwd)"
    (( return_value=return_value+$? ))
    log_debug "End ${FUNCNAME[0]}(). Returning ${return_value}."
    return ${return_value}
}  # end do_setup()


function_template() {
# Template function.
# Input: None.
# Output: None.
# Returns: 0 for success; 1 on error.
    log_debug "Begin ${FUNCNAME[0]}()."
    local return_value
    do_stuff
    (( return_value=return_value+$? ))
    log_debug "End ${FUNCNAME[0]}(). Returning ${return_value}."
    return ${return_value}
}  # end function_template()


do_print_installed_dpkgs() {
# Get a list of installed dpkg packages.
# Input: None.
# Output: A list of package names.
# Returns: 0.
    log_debug "Begin ${FUNCNAME[0]}()."
    local return_value
    dpkg -l | awk '{print $2}'
    (( return_value=return_value+$? ))
    log_debug "End ${FUNCNAME[0]}(). Returning ${return_value}."
    return ${return_value}
}  # end function_template()


main() {
    log_debug "Begin ${FUNCNAME[0]}()."
    local return_value
    (( return_value=0 ))
    log_debug "__dir is ${__dir}."
    log_debug "__file is ${__file}."
    log_debug "__name is ${__name}."
    do_get_args "$@"

    case "${package_type}" in
        "dpkg")
            packages=$(do_print_installed_dpkgs)
            ;;
        *)
            log_info "Reporting for package type \"${package_type}\" is not yet implemented."
            exit 0
            ;;
    esac

    if [[ "${one_per_line}" == "true" ]]; then
        log_debug "Printing one package per line."
        for i in ${packages}; do
            echo ${i}
        done
    else
        log_debug "Printing all packages on one line."
        echo ${packages}
    fi

    log_debug "End ${FUNCNAME[0]}(). Returning ${return_value}."
    return ${return_value}
}  # end main()


# Only invoke main() if we were NOT sourced. This allows other scripts to source this file and cherry-pick functions.
[[ "$0" = "${BASH_SOURCE[0]}" ]] && nature=executed || nature=sourced
if [[ "${nature}" != "sourced" ]]; then
    log_debug "Not sourced. Invoking main function."
    main "$@"
else
    log_debug "Being read as source. Skipping main() execution."
fi
