{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "datalogtool";

  name = "DataLogTool";

  artifactHashes = {
    linuxarm32 = "sha256-se2V9+d3HIiKIohbj8s7ilK1+kFH3kQvaaEP372h8b0=";
    linuxarm64 = "sha256-gmYPmFafS2KETpxz4UWsX+h506dU4dkkatYT/OrQ5Zk=";
    linuxx86-64 = "sha256-0dim48CQ7iYYuaNA4efKJOH1VDlgFoyeefDI2TxNMZ4=";
    osxuniversal = "sha256-ZIgu4bdLBqQhtu4R1GGVV8BW9TWPV2o2F0//5F3kp7A=";
  };

  iconPng = "${allwpilibSources}/datalogtool/src/main/native/resources/dlt-512.png";

  meta = {
    description = "A tool for downloading logs from FRC robots";
  };
}
