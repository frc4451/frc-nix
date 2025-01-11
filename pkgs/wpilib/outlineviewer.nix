{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  name = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-8RM/VaeRnuD9ttYEEJMnRQ9NKDa5M/7dyCUIVOwl//E=";
    linuxarm64 = "sha256-ZTh8/hzhKwyAznsQK/QhBAeMPoBupyBQcqsPcO8tfl0=";
    linuxx86-64 = "sha256-ZSLNaG+YFALYHcsSF99vXGiaBNLtwR2O6muAwUj6vrc=";
    osxuniversal = "sha256-P2jC0/27Qe9bYgj32Ce0trjsbRxvxdH642XJdsUbIh0=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta = {
    description = "A utility used to view, modify and add to the contents of NetworkTables";
  };
}
