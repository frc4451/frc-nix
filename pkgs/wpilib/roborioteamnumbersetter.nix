{ buildBinTool, avahi, allwpilibSources }:

buildBinTool {
  pname = "roborioteamnumbersetter";

  name = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-gLJxeNn+SdzMuBfJFMlW9T3UQpAYJOzUpzcx2JPeIu0=";
    linuxarm64 = "sha256-UGJ+2NLAeNUbOs2eKhzifHusJz0RuE5vKfDM3TvOXRw=";
    linuxx86-64 = "sha256-d6IwXiKMvSxY0Irddyb65v6OkQE+M3e3R/J19HfVNDY=";
    osxuniversal = "sha256-BHio5JtMY9eomVhO/Qg1dThCko6Vr9X4IH9ZBeUDPVk=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta = {
    description = "A trajectory generation suite for FRC teams";
  };
}
