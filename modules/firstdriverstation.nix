{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.firstdriverstation;
in
{
  options.programs.firstdriverstation = {
    enable = lib.mkEnableOption "FIRST Driver Station udev rules and configuration";
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.wpilib.firstdriverstation ];

    environment.systemPackages = [ pkgs.wpilib.firstdriverstation ];

    security.wrappers.FirstDriverStation = {
      source = "${pkgs.wpilib.firstdriverstation}/bin/FirstDriverStation";
      group = "input";
      permissions = "u+rx,g+rx,g+s";
    };
  };
}
