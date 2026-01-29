{
  fetchFromGitHub,
}:
fetchFromGitHub rec {
  passthru = {
    branch = "release";
    version = "2026.2.1";
    java.version = "2026.2.1";
    native.version = "2026.2.1";
  };

  owner = "wpilibsuite";
  repo = "allwpilib";
  rev = "v${passthru.version}";
  hash = "sha256-Zt82Rh1iB7E0Uxtf4xKbyWZW3gk7Oc9L96JO49X0Ux8=";
}
