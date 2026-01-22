{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  humanName = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-6Eha5glKbAhXA5WbFUuWNWLeXJECV7psMrbWXOKbgZw=";
    linuxarm64 = "sha256-cODZPMbn16C7MIge1el2U1G0EFBpcKDpuvgN8mnNpWg=";
    linuxx86-64 = "sha256-9VgeQUvbn3IaWWisFTKb7OIm6O35N39tNbpES3uh/xM=";
    osxuniversal = "sha256-5vmhh50Qv51TTfVr5iOJZR/UFsBJTNxTv831EaeWwRA=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta.description = "A utility used to view, modify and add to the contents of NetworkTables";
}
