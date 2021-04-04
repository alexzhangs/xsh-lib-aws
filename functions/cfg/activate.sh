#? Usage:
#?   @activate PROFILE
#?
#? Options:
#?   PROFILE  Profile name to activate
#?
#? Output:
#?   Activated profile.
#?
#? @xsh /trap/err -eE
#? @subshell
#?
function activate () {
    declare profile=$1

    if [[ -z ${profile} ]]; then
        xsh log error "profile: parameter null or not set."
        return 255
    elif [[ ${profile} == 'default' ]]; then
        xsh log error "default profile doesn't need to activate."
        return 255
    else
        :
    fi

    printf "activating profile: ${profile}\n"
    declare property n=0
    for property in $(xsh aws/cfg/get "${profile}" \
                          | column -s, -t \
                          | awk '{$1=""; print}'); do
        aws configure set "default.${XSH_AWS_CFG_PROPERTIES[n]#*.}" "${property}"
        n=$((n+1))
    done
    xsh aws/cfg/list
}
