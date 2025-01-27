{ config, pkgs, ... }:
let
  inherit (config.lib) opengl;
in {
  programs.discord = {
    enable = true;

    flavour = "vesktop";
    package = let
      discord = pkgs.vesktop;
    in opengl.wrapPackage discord { };

    vesktop = {
      settings = {
        minimizeToTray = "on";
        discordBranch = "stable";
        arRPC = "on";
        splashColor = "rgb(205, 214, 244)";
        splashBackground = "rgb(30, 30, 46)";
        enableMenu = false;
      };

      vencord = {
        theme = ''
          @import "https://discordstyles.github.io/RadialStatus/dist/RadialStatus.css";

          :root {
            --rs-small-spacing: 2px;
            --rs-medium-spacing: 3px;
            --rs-large-spacing: 4px;
            --rs-small-width: 2px;
            --rs-medium-width: 3px;
            --rs-large-width: 4px;
            --rs-avatar-shape: 50%;
            --rs-online-color: #43b581;
            --rs-idle-color: #faa61a;
            --rs-dnd-color: #f04747;
            --rs-offline-color: #636b75;
            --rs-streaming-color: #643da7;
            --rs-invisible-color: #747f8d;
            --rs-self-speaking-color: #57d39b;
            --rs-phone-color: var(--rs-online-color);
            --rs-phone-visible: block;
          }
        '';
      };
    };
  };
}
