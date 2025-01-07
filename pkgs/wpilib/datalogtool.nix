{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "datalogtool";

  name = "DataLogTool";

  artifactHashes = {
    linuxarm32 = "sha256-O8RC5KHkkUePrMJBh69I8Ld3HPlJmPG0f+1lyQq2G4Q=";
    linuxarm64 = "sha256-NbB9OJTeP+Kw5VzDnmS4oLDY3CAU22GuTBbv8r6Kmls=";
    linuxx86-64 = "sha256-NjGD/uaak4MV3ELN8GMj67vldGTlFqfXDRIxcxJJZYA=";
    osxuniversal = "sha256-1ElpMgGdhMOeg7Ede2fQa2iGDmp+/kA2T5prQXWIjdE=";
  };

  iconPng = "${allwpilibSources}/datalogtool/src/main/native/resources/dlt-512.png";

  meta = {
    description = "A tool for downloading logs from FRC robots";
  };
}
