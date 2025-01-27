{ config, pkgs, lib, ... }:
{
  home.activation.diff = with lib; hm.dag.entryAfter [ "installPackages" "importGpgKeys" ] ''
    if [[ -v oldGenPath && -e "$oldGenPath" ]]; then
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff "$oldGenPath" "$newGenPath"
    fi
  '';
}
