{ buildBinTool, avahi, allwpilibSources }:

buildBinTool {
  pname = "roborioteamnumbersetter";

  name = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-Ui51kCiSTGAqxN0ncJbkYM8MRdddzBIj/ggnuVYW630=";
    linuxarm64 = "sha256-6LAp0P/tbkjd0Fd9bpwSX0X22XMZ/YgEjoUbiW85Dy0=";
    linuxx86-64 = "sha256-zzjC+w4JTLQe12MpgC4+Woakr33h9GSzCtU3MdiDbJo=";
    osxuniversal = "sha256-nJGPZPkzNt9p4G26YQIO59WwFdGEFkMw2HNz3J9vL0s=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta = {
    description = "A trajectory generation suite for FRC teams";
  };
}
