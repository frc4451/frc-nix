{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  name = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-PeKUVXcN7khGUAfu3cuHYhFx4hRnyJ2Iyhj2cFtgzjw=";
    linuxarm64 = "sha256-lYTASVzKm2MH/qWSNYJ7UanCIuD9CdxMj69ckbUP7Jg=";
    linuxx86-64 = "sha256-ALjDyqGhH6BPCyALAgG9W1AaEiaWbnA1PmVZHlTQynE=";
    osxuniversal = "sha256-M9utQrpVLVxbULbl0EFQr6UjDhjNbQcVHv4ZSQExKEc=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta = {
    description = "A utility used to view, modify and add to the contents of NetworkTables";
  };
}
