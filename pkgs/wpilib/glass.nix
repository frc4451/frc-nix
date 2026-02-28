{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  humanName = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-xo2n8q1zkN1aPLtHXaDImsyxaEnWiefGIeUtVuDDyKQ=";
    linuxarm64 = "sha256-g4o/XylcjHwSnfhXqk8+3PAEk6dOPOvWGaqIqoAEdxU=";
    linuxx86-64 = "sha256-og6i2qkh5CYbKQb7hiTIoC502IQEQggfuNx5UkL5LSw=";
    osxuniversal = "sha256-C6qZAYorsMFpSh3zyIOQM+BUSBLyiSLDN46j21V9TYw=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta.description = "A dashboard and data visualization tool for FRC robots";
}
