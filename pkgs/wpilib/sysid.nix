{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "sysid";

  humanName = "SysId";

  artifactHashes = {
    linuxarm32 = "sha256-UKYAdrXLoUyUy0mWKMy/9Bh5k/SiCVQTWASpfZqO+/A=";
    linuxarm64 = "sha256-jhrH+pkB9baFXNo7IxDevqbb0HCw2piElFZT9k1fVKE=";
    linuxx86-64 = "sha256-B0tK+h4nZF/rjMCyhne1r5akznAmhQ/K5EHNqGsIk6M=";
    osxuniversal = "sha256-8IVaCeERB/FkpqQSZxUc+ReqMV75fufIyPJ+G2tJ9C4=";
  };

  iconPng = "${allwpilibSources}/sysid/src/main/native/resources/sysid-512.png";

  meta.description = "A tool for performing system identification on FRC robots";
}
