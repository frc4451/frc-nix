{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  name = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-okTk8L+8bPF3W5KI0nDxQX8FQJgFa4H55a4m+OjFG4A=";
    linuxarm64 = "sha256-UbUmY0wdL6dpd+QtDC4PI17Wam4i6D1UjtzDLHipmkI=";
    linuxx86-64 = "sha256-SzDeZY2x4bMEcxUuedkZv8sknfzyitmDX6g+yFAlsAY=";
    osxuniversal = "sha256-4O/2edenKqInr2QLe4cr3jLdJxUjZZWHN+etNRjIxHc=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta = {
    description = "A utility used to view, modify and add to the contents of NetworkTables";
  };
}
