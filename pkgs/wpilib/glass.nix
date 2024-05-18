{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-ch401W8oN3+Ap1Wr+nYe4NjeoQUPkBi4Ku5oAAwA7wI=";
    linuxarm64 = "sha256-N9SyqcM7TVwB122tLBvTmOPeFcN9hFJLO394zBH2YIQ=";
    linuxx86-64 = "sha256-hvh8+aMYQXEWV3/eMfMns+7c/IV4ipaB9d/31/F5A04=";
    osxuniversal = "sha256-NvlGv0wzfe2awge92JBiUrFBpU7u+XJW88xBu/Kgugk=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
