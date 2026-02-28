{
  buildBinTool,
  avahi,
  allwpilibSources,
}:

buildBinTool {
  pname = "roborioteamnumbersetter";

  humanName = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-3jpmvpo5Utgx0eZ9AyIRfN2BPSrspcKVdjpfgEZ+u8A=";
    linuxarm64 = "sha256-IxqzalBd8yaQqFCe6Fsc+78jWsnGiiEMLgNuaN+Xpa4=";
    linuxx86-64 = "sha256-r0wJV4wOV6rJy8rGAjrPGy4wnZIEE6Vs4HfMKSmNcbg=";
    osxuniversal = "sha256-BBqWzEoh0e0V0iC1EHtLIgUcFkEkU5Wzxfr0lm9smCU=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta.description = "A trajectory generation suite for FRC teams";
}
