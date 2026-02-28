{
  buildBinTool,
  allwpilibSources,
  gfortran,
}:

buildBinTool {
  pname = "wpical";

  humanName = "wpical";

  artifactHashes = {
    linuxarm32 = "sha256-uJZ1SYXIL7vMJpbFq3EKYLF0h2Z6WlqXAYWQCHbiAuQ=";
    linuxarm64 = "sha256-DMnmRb15U/OA+/9PCMigYPQxtvhOX2evDId0PRZtWwU=";
    linuxx86-64 = "sha256-SZUMfWHRiad8IopJPe/+NV1eyw6EUwD4Z0T9n9LgKTM=";
    osxuniversal = "sha256-yPiOvBfj/UuLBE/gVStRfUiIEjpsGH5UYVAvbg39miE=";
  };

  extraLibs = [ gfortran.cc ];

  iconPng = "${allwpilibSources}/wpical/src/main/native/resources/wpical-512.png";

  meta.description = "Field Calibration Tool";
}
