{ buildBinTool, allwpilibSources, gfortran }:

buildBinTool {
  pname = "wpical";

  name = "wpical";

  artifactHashes = {
    linuxarm32 = "sha256-mfoCIrGm8Mx32cpnARpOMZ/BkIR1F2es87iXQKNlOos=";
    linuxarm64 = "sha256-UywqegrJyj8WhtjD4WxGpRmS29Ik5bGPf08AMXwQAew=";
    linuxx86-64 = "sha256-vhkLWbS/Lz0igAjt25Gj6GTbbmDcdHwDwmVMsfOneZk=";
    osxuniversal = "sha256-zCZr/GnEHlplgI+6RcQ+owt2LKTPJNieNW68hfwIgvw=";
  };

  extraLibs = [ gfortran.cc ];

  iconPng = "${allwpilibSources}/wpical/src/main/native/resources/wpical-512.png";

  meta = {
    description = "Field Calibration Tool";
  };
}
