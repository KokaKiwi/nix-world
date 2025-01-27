{ ... }:
{
  programs.taplo = {
    enable = true;

    rootConfig = {
      formatting = {
        array_auto_expand = false;
        array_auto_collapse = false;
        inline_table_expand = false;
      };
    };
  };
}
