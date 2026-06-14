#!/usr/bin/env node
import { version } from "./index.js";

/**
 * Placeholder CLI entrypoint. The command surface (`grove create|open|close`)
 * is specified in `docs/grove/requirements.md` and tracked by the grove Epic.
 */
function main(): void {
  process.stdout.write(
    `grove v${version} — not yet implemented.\n` +
      "See docs/grove/requirements.md for the planned command surface.\n",
  );
}

main();
