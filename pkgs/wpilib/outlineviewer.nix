{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  humanName = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-RsovbQk9ORIYkDohaRg8kt7UK5gy2RngmYcRJ6yAj0Q=";
    linuxarm64 = "sha256-uABScngg0PUQIBT512W8zS4VbwnHJUUCz0rCEqXErGo=";
    linuxx86-64 = "sha256-GlSi4vRJcSrP/OHsDkwuqWllkQ0Y0yu8vA4dCACUy0I=";
    osxuniversal = "sha256-v73JEeHMc2/ctnp0+93SQ6paHaFwOR1gKtE62PQEdds=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta.description = "A utility used to view, modify and add to the contents of NetworkTables";
}
