{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  name = "Shuffleboard";

  artifactHashes = {
    linuxarm32 = "sha256-NkWwRcn9n8OYAdq8nyDl7KYZsFe3ICb69rwdqkIRNdw=";
    linuxarm64 = "sha256-rkceuqMLo+m9pQJ8352pNEP6JNwFyQ2dE3Qo0QQIWqQ=";
    linuxx64 = "sha256-gQr6UoO1C5MLV3dSms0dRRAE0gfBi7pyz8h6RN0z/dA=";
    macarm64 = "sha256-tkRnWQxWKg4ZUXlykS2VeXfPDGnJIOlM4FNjKYiUUCY=";
    macx64 = "sha256-z97XKZMoEOwa4OPzrRP3VOOeyTETtGrR8HAVKYyr/PE=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
