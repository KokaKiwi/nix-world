{ makeSetupHook

, usage
}:
makeSetupHook {
  name = "add-usage-completion";
  substitutions = {
    usageBin = "${usage}/bin/usage";

    bashCompletions = ./completions.bash;
    fishCompletions = ./completions.fish;
    zshCompletions = ./completions.zsh;
  };
} ./add-usage-completion.sh
