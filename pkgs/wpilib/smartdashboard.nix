{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-M6OIhWTQ6xsZ3NNrYaSFrRHp8ZPkHMEY1qa3JciZpu4=";
    macx64 = "sha256-rk7qa98BbJOgicD0gREhmHNdamOS7zITwc4V1LmIBtE=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
