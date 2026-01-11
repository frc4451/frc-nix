{ buildBinTool, allwpilibSources, gfortran }:

buildBinTool {
  pname = "wpical";

  name = "wpical";

  artifactHashes = {
    linuxarm32 = "sha256-qcMMeNudAG5hvukoLDHOoqQchGA9UWzUjhhEfW1yvek=";
    linuxarm64 = "sha256-s/EOBD758t7k3u0a5gX6PlFBq3MeqRrnlf3MCcdnHEY=";
    linuxx86-64 = "sha256-MRUA7IetLhPSeIQgAtSpdZPc/fmyHyPmaSS8k7XB+K0=";
    osxuniversal = "sha256-H60HyQ82WQ/EbSPh2YXtcWkzcH/Fvfs5peqBONgvg3c=";
  };

  extraLibs = [ gfortran.cc ];

  iconPng = "${allwpilibSources}/wpical/src/main/native/resources/wpical-512.png";

  meta = {
    description = "Field Calibration Tool";
  };
}
