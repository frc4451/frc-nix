{ buildBinTool, avahi, allwpilibSources }:

buildBinTool {
  pname = "roborioteamnumbersetter";

  name = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-ZbXtQuUe7Kt9BDIGJbQzfTTot07xBEtn6thV01HBctU=";
    linuxarm64 = "sha256-i0WouuO2MsxgWE3TwBQ7O1n1PziByyRu9LfBfmJhWVM=";
    linuxx86-64 = "sha256-hc+NVQq16WOo0Vwi95/V9S4oWDd8Y/63gTlA5Rgqd9c=";
    osxuniversal = "sha256-wdIwrDjSlUPYaDpOer83EflmN+kVe04GqCOvTXLKdNg=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta = {
    description = "A trajectory generation suite for FRC teams";
  };
}
