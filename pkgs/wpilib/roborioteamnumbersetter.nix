{ buildBinTool, avahi, allwpilibSources }:

buildBinTool {
  pname = "roborioteamnumbersetter";

  name = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-/i2t0bUJFiA5gIEc3Xk1Mh0JM34R6Oo2vk/o2vTgxtg=";
    linuxarm64 = "sha256-EGfcYnLvJUpJMfkHBZSfKPCMtrI7nVNGrs0UDwWqLCU=";
    linuxx86-64 = "sha256-eLTkHADQZapX0Yl4YSFd7Zepd0Uiu8/QBMyMaYYd5Ms=";
    osxuniversal = "sha256-zmkjmq0ngPMKmGX1BRKbwzsi2c/UA1vCAk3brXuj8WQ=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta = {
    description = "A trajectory generation suite for FRC teams";
  };
}
