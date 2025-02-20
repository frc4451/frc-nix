{ buildBinTool, avahi, allwpilibSources }:

buildBinTool {
  pname = "roborioteamnumbersetter";

  name = "roboRIOTeamNumberSetter";

  artifactHashes = {
    linuxarm32 = "sha256-r7AFf9BRXqLy9iNnfjUbAFzKnEvfM8bWv2KABXxb1+E=";
    linuxarm64 = "sha256-tKnFyP8cZnZSxwPkj6ekSlTYAfDPJiJW9Cm024mPhvQ=";
    linuxx86-64 = "sha256-hUw2bM5iHMtk/g/rGLDUtLUx4BuetYd0FiEjyj50RH8=";
    osxuniversal = "sha256-bbmoYqSr5+VmyrkueEPnYQgGFE9E+fLUcE4PWUZmQjo=";
  };

  extraLibs = [ avahi ];

  iconPng = "${allwpilibSources}/roborioteamnumbersetter/src/main/native/resources/rtns-512.png";

  meta = {
    description = "A trajectory generation suite for FRC teams";
  };
}
