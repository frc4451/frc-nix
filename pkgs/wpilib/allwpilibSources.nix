{
  fetchFromGitHub,
}:
fetchFromGitHub rec {
  passthru = {
    branch = "release";
    version = "2026.2.2";
    java.version = "2026.2.2";
    native.version = "2026.2.2";
  };

  owner = "wpilibsuite";
  repo = "allwpilib";
  rev = "v${passthru.version}";
  hash = "sha256-c8vy6eRxtXsROXyulzc0XB1HektXL6C4YbWUSyrB81o=";
}
