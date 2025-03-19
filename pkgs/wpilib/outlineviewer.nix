{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  name = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-nEXmDIAB5ydhM58nyGONuXqSP33ZVTLGtxEjHl5QlK4=";
    linuxarm64 = "sha256-Ik+H2vCJ2DMoX6qzjieXf1Z6toxVtBOmixTIZxDwIH4=";
    linuxx86-64 = "sha256-GOUblM1GlrNusxRptndvdzjIoz9kwE9jNjvMcOc+AOM=";
    osxuniversal = "sha256-FEE/8fa2ts5fTMhYR/GUI/cOHnnxSi/8P1WAFaYaeR4=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta = {
    description = "A utility used to view, modify and add to the contents of NetworkTables";
  };
}
