{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  humanName = "Shuffleboard";

  artifactHashes = {
    linuxarm32 = "sha256-ru+gleOLTC8wi1BzpDMcISEMDL/FwiHkyXGRW35toQQ=";
    linuxarm64 = "sha256-1Axlo/zMx6Dqt7u2oImtCvxpfZ3W9Xv6ZSr9NmK1tZk=";
    linuxx64 = "sha256-d+IwNryg2hZIAJP2b6cxMNyFkFkQWFspVNYsdNiKOmQ=";
    macarm64 = "sha256-emeSNxVC9NGsqoXicQMcZEBUZttflqv5GBeBUc4jMk8=";
    macx64 = "sha256-/uSwrmbvafvqwnd3VV9RVBxlZWI6RjO0/qAF0/xoiRo=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
