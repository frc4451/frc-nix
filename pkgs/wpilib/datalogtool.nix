{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "datalogtool";

  humanName = "DataLogTool";

  artifactHashes = {
    linuxarm32 = "sha256-/J/PLU6tZHYhFczc7jszgCZUr6UxH6aQ3bshbss8/Rc=";
    linuxarm64 = "sha256-TsUQTR9cqI32lYN642GXc2ekANdZ3093wsZNpUnVCPg=";
    linuxx86-64 = "sha256-IHYy5d9wKSSmaG/eHbLDmzGPirApiQeAhgLf9cGkGWU=";
    osxuniversal = "sha256-pE2qvjrfiPtxvSmjZ1NHIeDXQtQWSWAzqDhN0rUYnTo=";
  };

  iconPng = "${allwpilibSources}/datalogtool/src/main/native/resources/dlt-512.png";

  meta.description = "A tool for downloading logs from FRC robots";
}
