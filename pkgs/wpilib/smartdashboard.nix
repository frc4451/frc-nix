{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-V6iIAJtkuZVYK9wDgKD5FRoCK2ROYbsoArobPAKlzXs=";
    macx64 = "sha256-Oaam2d9X0kZxHR/oVDJG63kku8NfIBNwYFvau70O86I=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
