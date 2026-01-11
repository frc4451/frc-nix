{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-f4sV5RyvLrJZauRHXp3PSlqu0ii2qbNGe4ZEGPwpQH0=";
    linuxarm64 = "sha256-BRQRzuUux57ZBC/d6qa2vqKn7CzH0KrUeN13Pk5pY6M=";
    linuxx86-64 = "sha256-7bVDQQNl6R7cK1bpO+cFoQ3PJwaj5PZ9G2EQ0ouw2Ak=";
    osxuniversal = "sha256-0qZc4rMbz69C1TUeWty0rxFHe/TSmso/xFYY9aupmm8=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
