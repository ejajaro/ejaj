import { z } from "zod";

/**
 * Package version marker. The real implementation is tracked by the grove Epic
 * (see `docs/grove/requirements.md`); this placeholder exists so the workspace
 * resolves and the package builds.
 */
export const version = "0.0.0";

/**
 * Validation across `@ejaj` packages standardizes on {@link https://zod.dev | zod}.
 * `WorktreeName` is the canonical example of the convention: define a schema,
 * derive the static type from it, and parse untrusted input at the boundary.
 *
 * A worktree name must be a slug-safe identifier usable as a git branch segment
 * and a filesystem directory name.
 */
export const WorktreeName = z
  .string()
  .min(1, "worktree name must not be empty")
  .max(100, "worktree name must be at most 100 characters")
  .regex(
    /^[a-z0-9][a-z0-9._-]*$/,
    "worktree name must be lowercase alphanumeric, optionally with '.', '_' or '-'",
  );

export type WorktreeName = z.infer<typeof WorktreeName>;

/** Parse and validate a worktree name, throwing a `ZodError` on invalid input. */
export function parseWorktreeName(input: unknown): WorktreeName {
  return WorktreeName.parse(input);
}
