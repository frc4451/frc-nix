{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  name = "PathWeaver";

  artifactHashes = {
    linuxarm32 = "sha256-FtMHHgWJN24+bGvwoyK3BJTPvWMR5zAGBUfUBizgBEs=";
    linuxarm64 = "sha256-lgPyLSdEZPAAAX4hWRyGql17XcEK8k+SfRiWNes7zmA=";
    linuxx64 = "sha256-LtsxWM5KSAMHZHpnEnbE/t4MM4E3WhZomFxjpG7tfYo=";
    macarm64 = "sha256-8Ow3DoQzDCXyt2y/Mk/yRWtTwcAliVjybpozaFLKmnw=";
    macx64 = "sha256-qYRWjiTDENT/kYglNDZyOf1GZL1AL91OnFcT6VmEh/I=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
