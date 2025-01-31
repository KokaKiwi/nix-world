{ config, lib, ... }:
let
  cfg = config.cluster.programs.htop;
in {
  options.cluster.programs.htop = with lib; {
    enable = mkEnableOption "htop";
  };

  config = lib.mkIf cfg.enable {
    programs.htop = {
      enable = true;
      settings = {
        tree_view = 1;
        hide_kernel_threads = 0;
        hide_userland_threads = 1;
        show_thread_names = 1;
        show_program_path = 1;
        highlight_base_name = 1;
        show_merged_command = 1;
        show_cpu_usage = 1;
        show_cpu_frequency = 1;
        detailed_cpu_time = 1;
        find_comm_in_cmdline = 1;
        strip_exe_from_cmdline = 1;
      };
    };
  };
}
