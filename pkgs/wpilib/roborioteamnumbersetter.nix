{ buildBinTool, avahi, allwpilibSources }:

buildBinTool {
  pname = "roborioteamnumbersetter";

  name = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-H56xH6iBLRLYWqOrPeR6uvomfDWNcHAPTN9wjhJqHBk=";
    linuxarm64 = "sha256-70YpZPVLVWa+xpQWTX7nnV4e6gjdzcxHfpgOsw8py6c=";
    linuxx86-64 = "sha256-bv5yyB3CgZHFjNO45u6CDc+TatyvX1tv4zcA89WQyGg=";
    osxuniversal = "sha256-nIMT+MZ/RykxXZLngN/TgVSe+d6ukMrMP9L1iFXn1Bg=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta = {
    description = "A trajectory generation suite for FRC teams";
  };
}
