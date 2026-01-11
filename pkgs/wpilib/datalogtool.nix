{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "datalogtool";

  name = "DataLogTool";

  artifactHashes = {
    linuxarm32 = "sha256-3JMQ+XwA/5Our6FVybsObgPWaC0Dzo9E/Y2DKDnQefU=";
    linuxarm64 = "sha256-fX3Jf0wHLCWZhgGoS7ZH03XMoUURQH6vl09E0cfhK1c=";
    linuxx86-64 = "sha256-By5cgZqZV2EUkgJomRCbQnGQ7ZtBHglVYEn22vecY9Y=";
    osxuniversal = "sha256-4+1AAZSL3yhmB/QmurybL/wej9QUsh83Xss3VD5k+Jw=";
  };

  iconPng = "${allwpilibSources}/datalogtool/src/main/native/resources/dlt-512.png";

  meta = {
    description = "A tool for downloading logs from FRC robots";
  };
}
