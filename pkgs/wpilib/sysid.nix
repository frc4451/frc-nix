{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "sysid";

  name = "SysId";

  artifactHashes = {
    linuxarm32 = "sha256-uu3woo6Y7xKKDXYvEYUMEpoSjEfDlsVltY/GPfAL6uM=";
    linuxarm64 = "sha256-9m4aNkrivImHdypPVrKkLIi0uo8jWrolbGSHL4NQQqo=";
    linuxx86-64 = "sha256-g1g8iGUaCJdEp1MOd6kR0DDwE18S8hlcbOy1aFESUR8=";
    osxuniversal = "sha256-T+gkiPHTF1DTIRAPLVLh/55/mavEyu+xQ3Y6zIBMxKU=";
  };

  iconPng = "${allwpilibSources}/sysid/src/main/native/resources/sysid-512.png";

  meta = {
    description = "A tool for performing system identification on FRC robots";
  };
}
