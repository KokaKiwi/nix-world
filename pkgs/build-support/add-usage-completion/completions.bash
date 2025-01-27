_@exeName@() {
    if [[ -z ${_USAGE_SPEC_@baseName@:-} ]]; then
        _USAGE_SPEC_@baseName@="$(@usageCmd@)"
    fi

    COMPREPLY=( $(usage complete-word --shell bash -s "${_USAGE_SPEC_@baseName@}" --cword="$COMP_CWORD" -- "${COMP_WORDS[@]}" ) )
    if [[ $? -ne 0 ]]; then
        unset COMPREPLY
    fi
    return 0
}

shopt -u hostcomplete && complete -o nospace -o bashdefault -o nosort -F _@exeName@ @exeName@
# vim: noet ci pi sts=0 sw=4 ts=4 ft=sh
