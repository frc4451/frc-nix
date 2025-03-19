{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "sysid";

  name = "SysId";

  artifactHashes = {
    linuxarm32 = "sha256-AnLC8dVy85odvm/AQGaPuZs/Z2SnQwaj7uZcJHUS93Y=";
    linuxarm64 = "sha256-f5Xq8GvimWzbcjiktaMGw79yYDpuEa0Ph6ikMZD/rJ4=";
    linuxx86-64 = "sha256-iqhC5Hrmc4GMCjfvaMNa+gPOSr3Yf81siiMFB3SDHco=";
    osxuniversal = "sha256-P0YI+UYYetJ38zVJxAH9DCCOsorpTxy/XFB6LOovbpg=";
  };

  iconPng = "${allwpilibSources}/sysid/src/main/native/resources/sysid-512.png";

  meta = {
    description = "A tool for performing system identification on FRC robots";
  };
}
