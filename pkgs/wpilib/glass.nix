{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-9p0tkthqu7ALndrTTlnL3/7STOfmqAm7ib14ulRxvK0=";
    linuxarm64 = "sha256-7Y/iWzSZioL4olOHrXrq1vVc5ylGNcV/Sqlg5rNB5ME=";
    linuxx86-64 = "sha256-fQ6oXr4+iMopDE36kWxcEXajjm1hj6OihAwedKqI33g=";
    osxuniversal = "sha256-p3z9Jfom1f4/JI1NiFDT55c3xnCCQ+FrNBFl53AD4KE=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
