{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-3unu+iMeTTo07amvmxE1gwQ7jR8fPAlNtUrDnru2sB8=";
    linuxarm64 = "sha256-L+XFLovS4OE6KVVPyK6HqGg3NdsP7CvwEwPXxizLyfA=";
    linuxx86-64 = "sha256-GC5HeN4qdQnPvXEhyXy70jNknbHkoO3Ek8+j2Xhn6E0=";
    osxuniversal = "sha256-22ePoqLDFSl/yR+bO3W6JBgMnF41BGaBr1Q8nfd/kBs=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
