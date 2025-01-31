{ ... }:
{
  imports = [
    ./grafana.nix
    ./prometheus.nix
    ./prometheus-exporters.nix
  ];
}
