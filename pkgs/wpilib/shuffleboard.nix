{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  name = "Shuffleboard";

  artifactHashes = {
    linuxarm32 = "sha256-yHevC+7MBXeqzLPrdRLkXe8UGj0ud+7K5Lq203NuRh8=";
    linuxarm64 = "sha256-aSbRH/5j4lYdZ15ixNn8OrrmYsDHFOx3/YjNW0l+rGA=";
    linuxx64 = "sha256-bBoOs/u3HTPde0EC4XQgmvOl0cDjqMkilv/HVRPVjwI=";
    macarm64 = "sha256-F0Z0q4JtGeYzFlBewk/LGESTTLrVEGTpzc7Jj8Zw9Bg=";
    macx64 = "sha256-rWCJso3zKTkOKyJBv+hhEhALZEq29nJgDDKugo178TM=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
