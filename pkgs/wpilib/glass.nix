{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-WMb6j8nbmYthbnhsLwP3dBT4GWnGUqAgcqRmDml2Frg=";
    linuxarm64 = "sha256-QmadCJMjMNfAR/OlV6JorP9LM+1kOdVGhZrci6HgCXM=";
    linuxx86-64 = "sha256-UewMXfLsuf3s+CncC6ECMCX9JI0dY6EEa6W5z/p3xs4=";
    osxuniversal = "sha256-QYbthmrCceR3hhDoM67SD5/NBGHymuMJf+dR9nGGWPg=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
