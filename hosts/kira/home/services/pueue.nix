{ config, ... }:
let
  inherit (config) xdg;
in {
  services.pueue = {
    enable = true;

    settings = {
      client = {
        dark_mode = true;
      };
      daemon = {
        default_parallel_tasks = 4;
      };
      shared = {
        pueue_directory = "${xdg.dataHome}/pueue";
        use_unix_socket = true;
        unix_socket_path = "${xdg.stateHome}/pueue.socket";
        host = "127.0.0.1";
        port = "6924";
      };
    };
  };
}
