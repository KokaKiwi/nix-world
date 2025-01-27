{ ... }:
{
  programs.git-cliff = {
    enable = true;

    settings = {
      changelog = {
        trim = true;
      };

      git = {
        conventional_commits = true;

        commit_parsers = let
          groupParser = message: group: {
            inherit message group;
          };
        in [
          (groupParser "^feat" "Features")
          (groupParser "^fix" "Bug fixes")
          (groupParser "^doc" "Documentation")
          (groupParser "^perf" "Performance")
          (groupParser "^refactor" "Refactor")
          (groupParser "^style" "Style")
          (groupParser "^test" "Tests")
        ];

        link_parsers = [
          {
            pattern = "RFC(\\d+)";
            text = "IETF RFC$1";
            href = "https://datatracker.ietf.org/doc/html/rfc$1";
          }
        ];
      };
    };
  };
}
