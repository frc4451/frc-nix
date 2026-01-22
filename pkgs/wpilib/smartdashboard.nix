{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-47/7ICwj4LjndDJKpB2RuDR/XVtOMzqYLjG1aLi1LmM=";
    macx64 = "sha256-9iSkn5RgRqsXt11Z2i57HWUC+5jhz9zvrIdiHxSYKZo=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
