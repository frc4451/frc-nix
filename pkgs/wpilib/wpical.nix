{ buildBinTool, allwpilibSources, gfortran }:

buildBinTool {
  pname = "wpical";

  name = "wpical";

  artifactHashes = {
    linuxx86-64 = "sha256-UHxIcIhl2Ng4kWHcI2nQ6OeGsnTTzr9gLpJoiH+lzF4=";
    osxuniversal = "sha256-6N7Qs/BQDnwJvPJKc3t+bA6wKDfnNDkvYGst1aqeoS4=";
  };

  extraLibs = [ gfortran.cc ];

  iconPng = "${allwpilibSources}/wpical/src/main/native/resources/wpical-512.png";

  meta = {
    description = "Field Calibration Tool";
  };
}
