{
  buildBinTool,
  avahi,
  allwpilibSources,
}:

buildBinTool {
  pname = "roborioteamnumbersetter";

  name = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-ujotjEYmSObuhg/5ULJyZkwfzNdgeKjY+TPLaynAA7U=";
    linuxarm64 = "sha256-GmuxrirKrXHL9CHPJEjDKxnUartH/9V4bjIR+iiqzWo=";
    linuxx86-64 = "sha256-vufFRnebgiQi2RlFppxhSPzsaHZ+xiYsnvOUDzFM7fs=";
    osxuniversal = "sha256-pTfasbEZtIqmZ7rc6hvcDmVNt7K8Bgnib+m/B/QsOQk=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta = {
    description = "A trajectory generation suite for FRC teams";
  };
}
