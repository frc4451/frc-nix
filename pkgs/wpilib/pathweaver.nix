{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  humanName = "PathWeaver";

  artifactHashes = {
    linuxarm32 = "sha256-M/TRyIVldtVpbDvyCUZT+rOhSGfS9uqo/rRwntRAFcQ=";
    linuxarm64 = "sha256-fhu1V1/qBAksKy6pjsI5NDdmAnsegKGya0zlifkkt6A=";
    linuxx64 = "sha256-lhS47tn6eQcY2oygVQyhLvEGOgWXMqxlDpytixUJ6HA=";
    macarm64 = "sha256-HJqSYA9sWdnFtfxGrX5rE27cyol/h2JhWVetVSLkp/Y=";
    macx64 = "sha256-zgSW1zzMSSL2c6JtQPAObEAe/UQRyygtqrv/qCvJT7k=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
