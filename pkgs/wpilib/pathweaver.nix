{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  name = "PathWeaver";

  artifactHashes = {
    linuxarm32 = "sha256-/urmq7VA2WT875Edjgo2Iopf/P2aAzv1YD16JO8GILY=";
    linuxarm64 = "sha256-DnTc7bGRmJ0kdq504SvG5tz+i0V/55+QKGpdTLTNouY=";
    linuxx64 = "sha256-bHb2me2AnpQYVSwLU3gMeOFtKz2Zu4Hc4KxQQsckrqA=";
    macarm64 = "sha256-y6nLIsPlflO2k8h/J8bRzXxPCN/cyP5PYpuAF3KQqQA=";
    macx64 = "sha256-wV7V33cHLKkzAJlnionwjLZHSY29Kh3GoTBkthYyjvk=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
