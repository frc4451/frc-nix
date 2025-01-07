{ buildBinTool, allwpilibSources, gfortran }:

buildBinTool {
  pname = "wpical";

  name = "wpical";

  artifactHashes = {
    linuxx86-64 = "sha256-y0puhD3QI1/+iqgK69mBgEsi+vXvSO3HM1pdNtTq++8=";
    osxuniversal = "sha256-8dirw4D4vOMlbe3q9qjO66WrZKV2qPQiG3sOLAplEKk=";
  };

  extraLibs = [ gfortran.cc ];

  iconPng = "${allwpilibSources}/wpical/src/main/native/resources/wpical-512.png";

  meta = {
    description = "Field Calibration Tool";
  };
}
