{ sources, ... }:
{
  imports = [
    "${sources.catppuccin}/modules/home-manager"
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "green";
  };
}
