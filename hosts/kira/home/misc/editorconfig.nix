{ ... }:
{
  editorconfig = {
    enable = true;

    settings = let
      makefile = {
        indent_style = "tab";
        indent_size = 8;
        tab_width = 8;
      };
    in {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";

        indent_size = 2;
        indent_style = "space";

        insert_final_newline = true;
        max_line_length = 120;
        tab_width = 2;
        trim_trailing_whitespace = true;
      };
      "*.go" = {
        indent_size = 4;
        tab_width = 4;
      };

      "*.{rs,py,pyi,cs}" = {
        indent_size = 4;
      };

      "Makefile" = makefile;
      "*.mk" = makefile;

      "*.nix" = {
        indent_size = 2;
      };
    };
  };
}
