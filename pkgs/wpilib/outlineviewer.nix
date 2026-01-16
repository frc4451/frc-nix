{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  name = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-mUO2wCjuYae4/cY3voRqgLpLVHq14BoDCIFYfAUHdU4=";
    linuxarm64 = "sha256-8Wcz/9Nj5M/384fyOKkTAFyiOeILc4chsRSS0docidk=";
    linuxx86-64 = "sha256-3+fanb9EJMOu4wX35H+rvkNGe8+KG6B9/YyUhexNfY0=";
    osxuniversal = "sha256-e5l18l/m/4eYjJC6Sf5lBwbtVaSDi2RaWGSAmMMsuT4=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta = {
    description = "A utility used to view, modify and add to the contents of NetworkTables";
  };
}
