addUsageCompletion() {
  local baseName="$1"
  local destDir="$2"
  local usageCmd="$3"

  _doSubstitute() {
    local completionsFile="$1"
    local destFile="$2"

    substitute "$completionsFile" "$destFile" \
      --subst-var-by exeName  "$baseName" \
      --subst-var-by baseName "${baseName//-/_}" \
      --subst-var-by usageBin "@usageBin@" \
      --subst-var-by usageCmd "$usageCmd"
  }

  _doSubstitute @bashCompletions@ "$destDir/$baseName.bash"
  _doSubstitute @fishCompletions@ "$destDir/$baseName.fish"
  _doSubstitute @zshCompletions@ "$destDir/_$baseName"
}
