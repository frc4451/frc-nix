{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "datalogtool";

  name = "DataLogTool";

  artifactHashes = {
    linuxarm32 = "sha256-/YKJk/XFrQu4Px8BEUwd1+AN966C3k/60mHahxSLNkk=";
    linuxarm64 = "sha256-ovbRDZYnHL8aFebfxr3U2UEfgGpjl1mp/wn0dzgLGCk=";
    linuxx86-64 = "sha256-TAPReO+utNxqoMi14qzcKet6AG7nAHjlvHG3q/LSjIo=";
    osxuniversal = "sha256-nWCrZ8Xdzw2fzeUemkIAREpxbBVfPP6KFheowGYoL+E=";
  };

  iconPng = "${allwpilibSources}/datalogtool/src/main/native/resources/dlt-512.png";

  meta = {
    description = "A tool for downloading logs from FRC robots";
  };
}
