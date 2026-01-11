{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-NE4BdI3VyuEBeDbnJue2YSAmHPySCiPRWIRjmSj3Eew=";
    macx64 = "sha256-12RwxsX4SJueqShoY5kQXjG+DIeZzerOJBxvJs7hWbw=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
