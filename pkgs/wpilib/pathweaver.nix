{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  name = "PathWeaver";

  artifactHashes = {
    linuxx64 = "sha256-Dv4XuW0oBEsITuy+7khQ/YZCc/Zu7utS5wIU32JZ8Qw=";
    linuxarm32 = "sha256-OmC58BByaouCVt4W9hFPjcN/DY6S6liIy0wSlDsWLbs=";
    winx64 = "sha256-rMFlvrPPCy+VYb8EnMDX2p5bvwCygs/LU95ACGbX3Cg=";
    linuxarm64 = "sha256-O4QLvvXYRysE3vz7Kl9qnkKtY7sSg3BUUqkh0ebJgLY=";
    macx64 = "sha256-O8vKuZaAJ/YgxMxZy/uSfkwhwfz74Lmcz8Iu1UlNhLg=";
    macarm64 = "sha256-T9g5VnJbsaXXsNZCJYq3hSdxK+IxCuWEIpK2oJqL+H0=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
