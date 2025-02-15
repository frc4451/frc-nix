#!/usr/bin/env bun

import { parseArgs } from "util";

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

async function fetchHashes() {
  const { values } = parseArgs({
    options: {
      tool: { type: "string" },
      branch: { type: "string" },
      version: { type: "string" },
      type: { type: "string" },
    },
  });

  const { tool, branch, version } = values;

  const programUrl = `https://frcmaven.wpi.edu/artifactory/api/storage/${branch}/edu/wpi/first/tools/${tool}/${version}`;
  const programResponse = (await (
    await fetch(programUrl)
  ).json()) as ProgramResponse;
  const files = programResponse.children.filter(
    (file) => !file.uri.endsWith(".pom"),
  );

  const hashes: Record<string, string> = {};

  for (const file of files) {
    const fileUrl = `https://frcmaven.wpi.edu/artifactory/api/storage/${branch}/edu/wpi/first/tools/${tool}/${version}${file.uri}`;
    const response = await fetch(fileUrl);
    const data = (await response.json()) as FileResponse;

    // Extract platform name, handling windowsx86-64 case
    let platform = file.uri.slice(file.uri.lastIndexOf("-") + 1, -4);
    // Special case for windowsx86-64
    if (file.uri.includes("linuxx86-64")) platform = "linux86-64";
    else if (tool === "RobotBuilder") platform = "all";
    else if (file.uri.includes("windows")) continue;

    hashes[platform] =
      `sha256-${Buffer.from(data.checksums.sha256, "hex").toString("base64")}`;
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
