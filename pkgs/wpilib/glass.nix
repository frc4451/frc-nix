{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-O8Xw9SM91zoNUwEbTpFrvLNSlAxMjcvrGpTEXAS5iuQ=";
    linuxarm64 = "sha256-jVyuTwz0mx2iOqZgFil5pCnujo9wKq2PwqflBVr5dok=";
    linuxx86-64 = "sha256-zncOGo3gQuBIznoD0nFrIs/nUe0dxG7suwBXuOmRS8Y=";
    osxuniversal = "sha256-4ntI76PyL3gKJqZHPKTZ7So9u2xjRl3WF5YfeGvkEz4=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
