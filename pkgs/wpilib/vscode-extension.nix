{ vscode-utils
, allwpilibSources
, fetchurl
, unzip
, lib
}:
vscode-utils.buildVscodeExtension rec {
  version = "2026.1.1";

  pname = "${vscodeExtPublisher}-${vscodeExtName}";
  name = "${vscodeExtPublisher}-${vscodeExtName}-${version}";

  src = fetchurl {
    url = "https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${version}/vscode-wpilib-${version}.vsix";
    hash = "sha256-+wzawFLCCY9L4957XROJQzOoURDwNhVQuQwgCCBPGxY=";
    # TODO: Once the version of nixpkgs in this flake is updated we should remove
    # the custom `name` and the `unzip` nativeBuildInput
    # See: https://github.com/NixOS/nixpkgs/commit/e24a734076ea21365bb618d63f5c9a70006dd196

    # For compatibility older versions of nixpkgs
    # The `*.vsix` file is in the end a simple zip file. Change the extension
    # so that existing `unzip` hooks takes care of the unpacking.
    name = "${name}.zip";
  };

  nativeBuildInputs = [ unzip ];

  # VSCode Metadata
  vscodeExtPublisher = "wpilibsuite";
  vscodeExtName = "vscode-wpilib";
  vscodeExtUniqueId = "wpilibsuite.vscode-wpilib-${version}";

  # Package metadata
  meta = with lib; {
    description = "Visual Studio Code WPILib extension";
    homepage = "https://github.com/wpilibsuite/vscode-wpilib";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
  };
}
