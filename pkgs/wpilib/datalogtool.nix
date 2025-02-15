{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "datalogtool";

  name = "DataLogTool";

  artifactHashes = {
    linuxarm64 = "sha256-dzKMrAXlWf/XVoqr/lKql97hjQ7P6XNb1kEKweLGUWg=";
    linuxarm32 = "sha256-s0OvTPH1AcJdjBmPfln5pfJOmlNA0WtrdLkj0zT7a2g=";
    linux86-64 = "sha256-ZsqwQobpNjGt0x1XHAD10T7ZRhyMU2xvrr+kKwY2IH4=";
    osxuniversal = "sha256-wK5ACryYDANGqMGgweQ2ygfi/3ZsdiTH0PmNTkrkB4Q=";
  };

  iconPng = "${allwpilibSources}/datalogtool/src/main/native/resources/dlt-512.png";

  meta = {
    description = "A tool for downloading logs from FRC robots";
  };
}
