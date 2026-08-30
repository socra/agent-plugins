const fs = require("node:fs");
const path = require("node:path");

const context = fs.readFileSync(path.join(__dirname, "session-start.md"), "utf8");

process.stdout.write(JSON.stringify({
  hookSpecificOutput: {
    additionalContext: context,
  },
}));
