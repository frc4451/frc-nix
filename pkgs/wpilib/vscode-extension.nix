{ vscode-utils
, allwpilibSources
, fetchurl
, lib
,
}:
vscode-utils.buildVscodeExtension rec {
  inherit (allwpilibSources) version;

  pname = "${vscodeExtPublisher}-${vscodeExtName}";
  name = "${vscodeExtPublisher}-${vscodeExtName}-${version}";

  src = fetchurl {
    url = "https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${version}/vscode-wpilib-${version}.vsix";
    hash = "sha256-4+u7X9pQF2CQC8EojNluiTlryDJh2KuQKyd4T1Tmz4w=";
    # The `*.vsix` file is in the end a simple zip file. Change the extension
    # so that existing `unzip` hooks takes care of the unpacking.
    name = "${name}.zip";
  };

  # VSCode Metadata
  vscodeExtPublisher = "wpilibsuite";
  vscodeExtName = "vscode-wpilib";
  vscodeExtUniqueId = "wpilibsuite.vscode-wpilib-${version}";

  # Package metadata
  meta = with lib; {
    description = "Visual Studio Code WPILib extension";
    homepage = "https://github.com/wpilibsuite/vscode-wpilib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ max-niederman ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
  };
}
