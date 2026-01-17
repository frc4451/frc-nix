{ buildBinTool, allwpilibSources, gfortran }:

buildBinTool {
  pname = "wpical";

  name = "wpical";

  artifactHashes = {
    linuxarm32 = "sha256-aBnQBQ25ofuVJXwjz8SnFjPmEIUL+1WK1w+i1GIltLM=";
    linuxarm64 = "sha256-VeaSrH9CqIImkCbxklPFiYm5RlIzo+ImDcixtrk8GaY=";
    linuxx86-64 = "sha256-PbnxDUMLbSM0j+1WyDHSEGY62GXwyTl7NVygwlWyCFI=";
    osxuniversal = "sha256-+c/QRI8pnsp566kIzSuHyUmb0ERV59EHHQZch4tu7xw=";
  };

  extraLibs = [ gfortran.cc ];

  iconPng = "${allwpilibSources}/wpical/src/main/native/resources/wpical-512.png";

  meta = {
    description = "Field Calibration Tool";
  };
}
