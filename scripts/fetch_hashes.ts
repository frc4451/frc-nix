#!/usr/bin/env bun

import { parseArgs } from "util";
import { execSync } from "child_process";

export interface ProgramResponse {
  repo: string;
  path: string;
  created: Date;
  createdBy: string;
  lastModified: Date;
  modifiedBy: string;
  lastUpdated: Date;
  children: File[];
  uri: string;
}

export interface File {
  uri: string;
  folder: boolean;
}

export interface FileResponse {
  repo: string;
  path: string;
  created: Date;
  createdBy: string;
  lastModified: Date;
  modifiedBy: string;
  lastUpdated: Date;
  downloadUri: string;
  mimeType: string;
  size: string;
  checksums: Checksums;
  originalChecksums: Checksums;
  uri: string;
}

export interface Checksums {
  sha1: string;
  md5: string;
  sha256: string;
}

async function fetchHash(url: string) {
  const response = await fetch(url);
  const data = await response.arrayBuffer();
  const hashArray = new Uint8Array(await crypto.subtle.digest("SHA-256", data));
  return `sha256-${btoa(String.fromCharCode(...hashArray))}`;
}

async function fetchHashes() {
  const { values } = parseArgs({
    options: {
      tool: { type: "string" },
      branch: { type: "string" },
      version: { type: "string" },
      type: { type: "string" },
    },
  });

  const { tool, branch, version, type } = values;

  const hashes: Record<string, string> = {};

  switch (type) {
    case "github": {
      switch (tool) {
        case "wpilibutility": {
          const url = `https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${version}/wpilibutility-linux.tar.gz`;
          hashes.linux = await fetchHash(url);

          break;
        }
        case "vscode-extension": {
          const url = `https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${version}/vscode-wpilib-${version}.vsix`;
          hashes.linux = await fetchHash(url);

          break;
        }
        case "Choreo": {
          const url = `https://github.com/SleipnirGroup/Choreo/releases/download/v${version}/Choreo-v${version}-Linux-x86_64-standalone.zip`;
          hashes.linux = await fetchHash(url);

          break;
        }
        case "AdvantageScope": {
          for (const platform of ["x86_64-linux", "aarch64-linux"]) {
            const url = `https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-${platform === "x86_64-linux" ? "linux-x64" : "linux-arm64"}-v${version}.AppImage`;
            hashes[platform] = await fetchHash(url);
          }

          break;
        }
        case "Elastic": {
          const url = `https://github.com/Gold872/elastic-dashboard/releases/download/v${version}/Elastic-Linux.zip`;
          hashes.linux = await fetchHash(url);

          break;
        }
        case "PathPlanner": {
          try {
            const output = execSync(
              `nix-prefetch-git https://github.com/mjansen4857/pathplanner v${version}`,
              { encoding: "utf-8", stdio: "pipe" },
            );

            // Parse the JSON output from nix-prefetch-git
            const result = JSON.parse(
              output.split("\n").slice(0, 12).join("\n"),
            );
            hashes.hash = result.hash;
          } catch (error) {
            console.error(
              `Error fetching git hash for PathPlanner ${version}:`,
              error,
            );
            throw error;
          }
          break;
        }
        case "allwpilib": {
          try {
            const output = execSync(
              `nix-prefetch-git https://github.com/wpilibsuite/allwpilib v${version}`,
              { encoding: "utf-8", stdio: "pipe" },
            );

            // Parse the JSON output from nix-prefetch-git
            const result = JSON.parse(
              output.split("\n").slice(0, 12).join("\n"),
            );
            hashes.hash = result.hash;
          } catch (error) {
            console.error(
              `Error fetching git hash for allwpilib ${version}:`,
              error,
            );
            throw error;
          }
        }
      }
      break;
    }
    default: {
      const programUrl = `https://frcmaven.wpi.edu/artifactory/api/storage/${branch}/edu/wpi/first/tools/${tool}/${version}`;
      const programResponse = (await (
        await fetch(programUrl)
      ).json()) as ProgramResponse;
      const files = programResponse.children.filter(
        (file) => !file.uri.endsWith(".pom"),
      );

      for (const file of files) {
        const fileUrl = `https://frcmaven.wpi.edu/artifactory/api/storage/${branch}/edu/wpi/first/tools/${tool}/${version}${file.uri}`;
        const response = await fetch(fileUrl);
        const data = (await response.json()) as FileResponse;

        // Extract platform name, handling windowsx86-64 case
        let platform = file.uri.slice(file.uri.lastIndexOf("-") + 1, -4);
        // Special case for windowsx86-64
        if (file.uri.includes("linuxx86-64")) platform = "linuxx86-64";
        else if (tool === "RobotBuilder") platform = "all";
        else if (file.uri.includes("windows")) continue;

        const matches = data.checksums.sha256.match(/.{1,2}/g);
        if (!matches) continue;

        const hashArray = Uint8Array.from(
          matches.map((byte) => Number.parseInt(byte, 16)),
        );
        hashes[platform] = `sha256-${btoa(String.fromCharCode(...hashArray))}`;
      }
    }
  }

  // Format output
  console.log(`${tool} (${version}):`);
  console.log("artifactHashes = {");
  for (const [platform, hash] of Object.entries(hashes)) {
    console.log(`  ${platform} = "${hash}";`);
  }
  console.log("};");
  console.log();
}

fetchHashes().catch(console.error);
