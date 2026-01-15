{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "sysid";

  name = "SysId";

  artifactHashes = {
    linuxarm32 = "sha256-L/VETxQTybZTlVExGj6ytmCjFdqtbZQzAadxiIJgL2Q=";
    linuxarm64 = "sha256-2gA2aq1iGyk0xhIGp2+UqHg8iUfKVOgqzQsgm4Kwe3o=";
    linuxx86-64 = "sha256-w570+kJGLZSGzCACRSqArGDNXthkMhL6h3ZbL1rtTjs=";
    osxuniversal = "sha256-FRgbe2M7pzqz3gbW63RKOyQY77oNOL0HVgXUAsY7VPI=";
  };

  iconPng = "${allwpilibSources}/sysid/src/main/native/resources/sysid-512.png";

  meta = {
    description = "A tool for performing system identification on FRC robots";
  };
}
