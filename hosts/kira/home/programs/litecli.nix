{ ... }:
{
  programs.litecli = {
    enable = true;

    config = {
      main = {
        syntax_style = "monokai-dark";
        less_chatty = true;
      };
    };
  };
}
