#compdef @exeName@
local curcontext="$curcontext"

# caching config
_usage_@exeName@_cache_policy() {
  if [[ -z "${lifetime}" ]]; then
    lifetime=$((60*60*4)) # 4 hours
  fi
  local -a oldp
  oldp=( "$1"(Nms+${lifetime}) )
  (( $#oldp ))
}

_@exeName@() {
  typeset -A opt_args
  local curcontext="$curcontext" spec cache_policy

  zstyle -s ":completion:${curcontext}:" cache-policy cache_policy
  if [[ -z $cache_policy ]]; then
    zstyle ":completion:${curcontext}:" cache-policy _usage_@exeName@_cache_policy
  fi

  if ( [[ -z "${_usage_@exeName@_spec:-}" ]] || _cache_invalid _usage_@exeName_spec ) \
      && ! _retrieve_cache _usage_@exeName@_spec;
  then
    spec="$(@usageCmd@)"
    _store_cache _usage_@exeName@_spec spec
  fi

  _arguments '*: :($(@usageBin@ complete-word --shell zsh -s "$spec" -- "${words[@]}" ))'
  return 0
}

if [ "$funcstack[1]" = "_@exeName@" ]; then
    _@exeName@ "$@"
else
    compdef _@exeName@ @exeName@
fi

# vim: noet ci pi sts=0 sw=4 ts=4
