{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  name = "Shuffleboard";

  artifactHashes = {
    linuxx64 = "sha256-ar6IqVeqcZKbwv0qm/8fcCapwlmpQDSrT6uT5nn4my8=";
    macx64 = "sha256-c8BlNZUDvqFx1jzeNE/u8QJbSFoM7TLlcOiYbmCTqVs=";
    winx64 = "sha256-Z1KjuNEJTlQKF90Avf83zVCAYvyFzkzk9TnEueM/W74=";
    linuxarm64 = "sha256-UrvL8Ra9BlEapqjGrhTBgxQdkY8E6WaiBqTexUhp5Aw=";
    linuxarm32 = "sha256-9j/kj1QnNu/Q56B5+tApApRygu7oTJFTdGq7s98u4XQ=";
    macarm64 = "sha256-NKD6YySg0ZYCZD2Pqvq76BrwVZ9YP+LIhb010AoBxLI=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
