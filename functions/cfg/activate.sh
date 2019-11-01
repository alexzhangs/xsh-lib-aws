#? Usage:
#?   @activate PROFILE
#?
#? Options:
#?   PROFILE  Profile name to activate
#?
#? Output:
#?   Activated profile.
#?
function activate () {
    local profile=$1
    local base_dir property n

    base_dir=${XSH_HOME}/lib/aws/functions/cfg  # TODO: use varaible instead
    . "${base_dir}/config.conf"

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
    n=0
    for property in $(xsh aws/cfg/get "${profile}" \
                          | column -s, -t \
                          | awk '{$1=""; print}'); do
        aws configure set "default.${AWS_CFG_PROPERTIES[n]#*.}" "${property}"
        n=$((n+1))
    done
    xsh aws/cfg/list
}
