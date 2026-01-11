{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  name = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-PX1rSGVxU22zBXp0a83GGeq83rLCWPw2evBITkJr1q8=";
    linuxarm64 = "sha256-0YI8QV+Glq1BCdbjhuif4qG0im+0yIl8pOB2FXG9EuI=";
    linuxx86-64 = "sha256-Deh3li6GSJ919l0iPAXh29B3D7bwgcQzKOkgl7hGnWo=";
    osxuniversal = "sha256-Qa7G3q/wZ4QyM0U2A4HbEuWcH+q4XaNCDYaqPJ0DEhE=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta = {
    description = "A utility used to view, modify and add to the contents of NetworkTables";
  };
}
