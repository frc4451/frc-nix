{ buildBinTool, allwpilibSources, gfortran }:

buildBinTool {
  pname = "wpical";

  name = "wpical";

  artifactHashes = {
    linuxx86-64 = "sha256-efdktL1NecGHQ5U6kp8x1/Vg3kJRmOyCZA/35y+EyP8=";
    osxuniversal = "sha256-L5g43PkPQCip3AFuGoZ21VktQ0rvagNKgEqxDMp6SQw=";
  };

  extraLibs = [ gfortran.cc ];

  iconPng = "${allwpilibSources}/wpical/src/main/native/resources/wpical-512.png";

  meta = {
    description = "Field Calibration Tool";
  };
}
