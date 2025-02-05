autoload -U colors && colors

typeset -gA SWITCHENV_PREFIX_MAP

: ${SWITCHENV_ENVIRONMENTS:="production staging development"}
: ${SWITCHENV_PREFIX_MAP[production]:="PRD_"}
: ${SWITCHENV_PREFIX_MAP[staging]:="STG_"}
: ${SWITCHENV_PREFIX_MAP[development]:="DEV_"}
: ${SWITCHENV_NEW_VAR_COLOR:="green"}
: ${SWITCHENV_OLD_VAR_COLOR:="blue"}

(( $+commands[fzf] )) || _SWITCHENV_USE_SELECT=1

function switchenv() {
    local selected_env

    if [[ -n "$_SWITCHENV_USE_SELECT" ]]; then
        echo "Select environment:"
        select selected_env in ${=SWITCHENV_ENVIRONMENTS}; do
            break
        done
    else
        selected_env=$(echo $SWITCHENV_ENVIRONMENTS | tr ' ' '\n' | fzf --height=20% --prompt="Select environment: ")
    fi

    [[ -z "$selected_env" ]] && return 1

    # Get prefix from mapping.
    local prefix="${SWITCHENV_PREFIX_MAP[$selected_env]}"
    if [[ -z "$prefix" ]]; then
        echo "No prefix mapping found for environment: $selected_env" >&2
        return 1
    fi

    # Clear the file of the existing environment.
    : > ~/.switchenv

    # Find and set environment variables.
    local vars=(${(M)${(k)parameters}:#${prefix}*})
    for var in $vars; do
        local new_var=${var#$prefix}
        export $new_var="${(P)var}"
        echo "export ${new_var}=\"${(P)var}\"" >> ~/.switchenv
        echo "Setting ${fg[$SWITCHENV_NEW_VAR_COLOR]}\$${new_var}${reset_color} to ${fg[$SWITCHENV_OLD_VAR_COLOR]}\$${var}${reset_color}"
    done

    echo "Switched to $selected_env environment"
}

_switchenv() {
    local -a environments
    environments=(${=SWITCHENV_ENVIRONMENTS})
    _describe 'environment' environments
}
compdef _switchenv switchenv

alias swenv='switchenv'
