set _usage_spec_@baseName@ (@usageCmd@ | string collect)
complete -xc @exeName@ -a '(@usageBin@ complete-word --shell fish -s "$_usage_spec_@baseName@" -- (commandline -cop) (commandline -t))'
