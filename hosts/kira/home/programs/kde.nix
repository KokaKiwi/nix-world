{ pkgs, ... }:
{
  programs.kde = {
    akonadi = {
      postgresql = pkgs.postgresql_16;
    };
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = 1;
    ELECTRON_TRASH = "kioclient";
    XAUTHORITY = "$(ls $XDG_RUNTIME_DIR/xauth_*)";
  };
}
