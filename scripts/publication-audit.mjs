import { execFileSync } from "node:child_process";
import { readFileSync, existsSync, readdirSync, statSync } from "node:fs";
import { resolve, relative } from "node:path";

const patterns = [
  ["private-key", /-----BEGIN (?:OPENSSH |RSA |EC )?PRIVATE KEY-----/],
  ["google-oauth-secret", /GOCSPX-[A-Za-z0-9_-]{20,}/],
  ["telegram-bot-token", /\b\d{8,12}:[A-Za-z0-9_-]{30,}\b/],
  ["cloudflare-token", /\bcfut_[A-Za-z0-9_-]{25,}\b/],
  ["github-token", /\b(?:ghp_|github_pat_)[A-Za-z0-9_]{30,}\b/],
];
const ignored = new Set([".git", ".gradle", "node_modules", "build", "dist", "data", ".idea", ".playwright-cli", "output"]);
const textFile = /\.(?:[cm]?js|ts|json|kt|kts|swift|md|ya?ml|sh|ps1|xml|plist|properties|txt|example)$|(?:^|\/)(?:Dockerfile|LICENSE)$/;
let failed = false;
function inspect(text, label) {
  for (const [kind, pattern] of patterns) if (pattern.test(text)) {
    process.stdout.write(kind + ": " + label + "\n"); failed = true;
  }
}
function walk(root, dir = root) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (ignored.has(entry.name) || entry.name === ".env" || entry.name.startsWith(".dino-")) continue;
    const path = resolve(dir, entry.name);
    if (entry.isDirectory()) walk(root, path);
    else if (textFile.test(path.replaceAll("\\", "/")) && statSync(path).size < 2_000_000)
      inspect(readFileSync(path, "utf8"), root + ":" + relative(root, path));
  }
}
for (const input of process.argv.slice(2)) {
  const root = resolve(input);
  if (!existsSync(root)) throw new Error("Missing repository directory: " + root);
  walk(root);
  if (existsSync(resolve(root, ".git"))) {
    const tracked = execFileSync("git", ["ls-files"], { cwd: root, encoding: "utf8" });
    for (const path of tracked.split("\n")) {
      if (/(^|\/)(?:\.env(?:\..*)?|\.dino-qa-deploy(?:\.pub)?|state\.enc)$/.test(path) && !path.endsWith(".example")) {
        process.stdout.write("sensitive-tracked-file: " + root + ":" + path + "\n"); failed = true;
      }
    }
    try {
      const history = execFileSync("git", ["log", "--all", "--format=", "-p", "--", "*.ts", "*.js", "*.mjs", "*.json", "*.md", "*.yml", "*.yaml", "*.sh", "*.ps1", "*.kt", "*.swift", ".env*", "*.pem", "*.key"], { cwd: root, encoding: "utf8", maxBuffer: 128 * 1024 * 1024 });
      inspect(history, root + ":git-history (rotate and locate privately)");
    } catch { process.stdout.write("history-scan-incomplete: " + root + "\n"); failed = true; }
  }
}
process.stdout.write(failed ? "Publication audit: review required.\n" : "No matching high-confidence secrets found; manual review still required.\n");
process.exitCode = failed ? 1 : 0;
