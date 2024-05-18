{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "datalogtool";

  name = "DataLogTool";

  artifactHashes = {
    linuxarm32 = "sha256-WvcdQNey68WLZnU4w8qivdwjuVAcATbBat9z2eRPWPE=";
    linuxarm64 = "sha256-rEIFi3pYXvp4bUIyrRg2akx0ypp4xG5TDuMvtYNGMbg=";
    linuxx86-64 = "sha256-ykWX4+j3jOb8d5UnRU2VxghQJPWn1GmqO4n3VsvcHic=";
    osxuniversal = "sha256-QXJC/FNdRsspWKHyBBuE+oLj37Vvb6O0GH1yG1PkJKA=";
  };

  iconPng = "${allwpilibSources}/datalogtool/src/main/native/resources/dlt-512.png";

  meta = {
    description = "A tool for downloading logs from FRC robots";
  };
}
