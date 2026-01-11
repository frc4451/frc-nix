{ buildBinTool, avahi, allwpilibSources }:

buildBinTool {
  pname = "roborioteamnumbersetter";

  name = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-DGzAA+bRxCBGKzNUTASzlN3JsCZ1fT/pyENkOHBY0vY=";
    linuxarm64 = "sha256-UsIf2qwFthHwlMfTNPlkRe/jnRMsROOiwIv18n7S95c=";
    linuxx86-64 = "sha256-asOGiPRuBEuNEYSEmPGAu0+DxfXkgRCfw/sa0chJF5U=";
    osxuniversal = "sha256-r8Hul0nK0BLd3B6rflIdjZLskmzgy0T676IaCqD1oxk=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta = {
    description = "A trajectory generation suite for FRC teams";
  };
}
