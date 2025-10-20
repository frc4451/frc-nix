{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-jmX8FWMEKefZLabR8FcxeIiQ+W74NzZG6ttMTfOPG+Q=";
    linuxarm64 = "sha256-RUJXup8S9PfW7Nj+xDWmyJ8gXeZRwo7XjHGw+eAITQo=";
    linuxx86-64 = "sha256-zbvmRXM0d8yQbR9bRxjhkfDizlODkLl2DhynIQwzwPA=";
    osxuniversal = "sha256-yv5br6OiUnB8eNQVQNGH4XmiPGvjJKTS6kMulimChDQ=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
