{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "datalogtool";

  name = "DataLogTool";

  artifactHashes = {
    linuxarm32 = "sha256-MULfrpcqUj46C1onKvYufDdeBz54cdOrn+7I57ZUBL0=";
    linuxarm64 = "sha256-oKucdCHQhrCS9StWQq3kfCVNram5hZqc/iSGWOcgGyw=";
    linuxx86-64 = "sha256-gIUE4wO6xES9s3i/mxoIswurwtGrC7X5yk5Dv5x0hLQ=";
    osxuniversal = "sha256-Mi4YiWe8PEOniM67j99IeuwifUNGf4tTFZOwvxYuY1c=";
  };

  iconPng = "${allwpilibSources}/datalogtool/src/main/native/resources/dlt-512.png";

  meta = {
    description = "A tool for downloading logs from FRC robots";
  };
}
