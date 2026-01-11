{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "sysid";

  name = "SysId";

  artifactHashes = {
    linuxarm32 = "sha256-3i8F5/jkSSKF+utsW4L66hv8Q1MzmJLixRH5+0jkZD8=";
    linuxarm64 = "sha256-Yvdp3roUat8rWqry9+TrwsKSeASdo1LLmuWedIXdOcQ=";
    linuxx86-64 = "sha256-dVsZ5laDRXtmxKSE+gxpCYwl/4w0gjZO3qQicynufbM=";
    osxuniversal = "sha256-/EffkQ74Hx5XObymMj/lOd/0cwx13cAeOEwUufi6j5s=";
  };

  iconPng = "${allwpilibSources}/sysid/src/main/native/resources/sysid-512.png";

  meta = {
    description = "A tool for performing system identification on FRC robots";
  };
}
