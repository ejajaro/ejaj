import { describe, expect, it } from "vitest";
import { parseWorktreeName, version, WorktreeName } from "./index.js";

describe("@ejaj/grove placeholder", () => {
  it("exposes a version marker", () => {
    expect(version).toBe("0.0.0");
  });

  it("accepts valid worktree names", () => {
    expect(parseWorktreeName("feature-login")).toBe("feature-login");
    expect(WorktreeName.safeParse("v2.0_alpha").success).toBe(true);
  });

  it("rejects invalid worktree names", () => {
    expect(WorktreeName.safeParse("").success).toBe(false);
    expect(WorktreeName.safeParse("Has Spaces").success).toBe(false);
    expect(WorktreeName.safeParse("-leading-dash").success).toBe(false);
  });
});
