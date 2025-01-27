{ ... }:
{
  services.aria2 = {
    enable = true;

    settings = {
      continue = true;
      max-connection-per-server = 4;
      max-concurrent-downloads = 16;
      max-overall-download-limit = 0;
      allow-overwrite = true;
      event-poll = "epoll";
      file-allocation = "falloc";
      enable-http-pipelining = true;
      enable-mmap = true;
    };
  };
}
