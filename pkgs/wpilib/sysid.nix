{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "sysid";

  name = "SysId";

  artifactHashes = {
    linuxx86-64 = "sha256-eaaGGtWgoLupO7/SReBBK5oh9iXjitMWgons6Gai42g=";
    linuxarm64 = "sha256-zKoONnHpb3C5KM/HXOPC4FFaSrIt1NrNKXXmdD7EkBM=";
    linuxarm32 = "sha256-teDwVmX01Gox6Kaa+Moy0vsqp8Ao9BNnwPrxgeN4x4c=";
    osxuniversal = "sha256-sOUyxybn4RV19KuUqU8lwS0dybndI3SZlpXP/46padY=";
  };

  iconPng = "${allwpilibSources}/sysid/src/main/native/resources/sysid-512.png";

  meta = {
    description = "A tool for performing system identification on FRC robots";
  };
}
