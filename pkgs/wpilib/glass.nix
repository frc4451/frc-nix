{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-dw39MUpbDENfnzgWI54NRZcb2IO0kqscA7XBBZYQk84=";
    linuxarm64 = "sha256-QWkMugXCHPQqu3Wb7a1ex/h6BDbBR8z1Sgkfpj+TUd4=";
    linuxx86-64 = "sha256-S+kKWZWRBzVhTp0GSLBW1qC8QUDrsIBxxGxlLvmcALQ=";
    osxuniversal = "sha256-KoYyGDCNjCP07LT/SVMtFnObIfJPIYyuLZQS+9gW3V4=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
