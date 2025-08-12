{ lib
, writeShellApplication
, curl
, jq
, gnused
, gawk
, coreutils
, xxd
, nix-prefetch-git
}:

writeShellApplication {
  name = "frc-nix-update";

  runtimeInputs = [
    curl
    jq
    gnused
    gawk
    coreutils
    xxd
    nix-prefetch-git
  ];

  text = ''
    # Set REPO_ROOT to current working directory (where user runs the command)
    REPO_ROOT="$PWD"
    
    ${builtins.readFile ./update-packages.sh}
  '';

  meta = with lib; {
    description = "Auto-update tool for FRC Nix packages";
    longDescription = ''
      A tool similar to nix-update that automatically updates FRC packages
      to their latest versions, including fetching new hashes.
      
      Supports updating:
      - GitHub-based packages (AdvantageScope, Choreo, etc.)
      - WPILib tools from Maven
      - Automatic hash fetching and Nix file updates
    '';
    homepage = "https://github.com/frc4451/frc-nix";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "frc-nix-update";
  };
}
