{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  name = "Shuffleboard";

  artifactHashes = {
    linuxarm32 = "sha256-hK97mXb9w2lawmiN/G16FRctcsu+MK9UC5c2IHfXutg=";
    linuxarm64 = "sha256-o8n/zPThkOqQ8LP9h5KZ4ko3PC754BE4RAJvcxylMXw=";
    linuxx64 = "sha256-GU8cre1ACPqUEvDnz+zYckhmvdXstYWa7D9TgC+Sx58=";
    macarm64 = "sha256-KhpAseWjoPEo5P3mOeWCgJfYR6ICldNLiIR1eJaNB+U=";
    macx64 = "sha256-lfTmPAlzf/KSgCuIX4CzStQ+dlwtgJi9L0wpXEj+EiI=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
