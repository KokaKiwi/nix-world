{ ... }:
{
  services.shadowsocks-rust = {
    servers = [
      {
        server = "137.74.95.130";
        server_port = 8388;
        method = "2022-blake3-chacha20-poly1305";
        passwordFile = "$CREDENTIALS_DIRECTORY/shadowsocks-alyx-password";
      }
      {
        server = "2001:41d0:1004:3382::1";
        server_port = 8388;
        method = "2022-blake3-chacha20-poly1305";
        passwordFile = "$CREDENTIALS_DIRECTORY/shadowsocks-alyx-password";
      }
    ];

    client = {
      enable = true;
    };
  };

  systemd.services.shadowsocks-rust-client = {
    secrets = [ "shadowsocks-alyx-password" ];
  };

  secrets."shadowsocks-alyx-password" = { };
}
