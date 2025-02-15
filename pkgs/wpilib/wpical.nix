{ buildBinTool, allwpilibSources, gfortran }:

buildBinTool {
  pname = "wpical";

  name = "wpical";

  artifactHashes = {
    linuxx86-64 = "sha256-YZC/Hm9FrdQdq17QjOwuvhJP1ZQz74x6x2P8OeQwvxA=";
    osxuniversal = "sha256-WrMbkEyCtjmjUN7h/uG/mMG33uIKtAEcPr1u3luKiJg=";
  };

  extraLibs = [ gfortran.cc ];

  iconPng = "${allwpilibSources}/wpical/src/main/native/resources/wpical-512.png";

  meta = {
    description = "Field Calibration Tool";
  };
}
