{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  humanName = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-PggtH7C4ijo3HX7wiNikOOV+Jm3siR3wSGhqvMKtFgM=";
    macx64 = "sha256-OD4QedCfYtpM3VsS6E6qD3qckmqI1odbKtSYecZmy38=";
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
