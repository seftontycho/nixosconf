{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    nvidia = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf config.nvidia.enable {
    services.xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };
  };
}
