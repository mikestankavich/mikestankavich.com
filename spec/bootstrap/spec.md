# Feature: Claude Spec Workflow Setup

## Metadata

**Type**: infrastructure

## Outcome

Validate CSW installation and commit workflow infrastructure to repository via CSW's own workflow.

## User Story

As a developer
I want CSW infrastructure validated and committed
So that the team can use specification-driven development

## Context

**Installed**: Claude Spec Workflow from https://github.com/trakrf/claude-spec-workflow
**Stack**: TypeScript + Astro + Tailwind
**Preset**: Custom (adapted from typescript-react-vite)
**Date**: 2025-10-30

**CLAUDE.md Update Options**:

- **Minimal** (default): Simple awareness - "This project uses CSW, see spec/README.md"
- **Proactive**: Adds suggestion to use CSW for complex/multi-file changes

During `/plan`, the user should be asked which style they prefer.

## Technical Requirements

- `spec/` directory structure is complete and correct
- `spec/stack.md` validation commands work for our stack
- Slash commands (/plan, /build, /check, /ship) are accessible in Claude Code
- Templates are ready for use
- `CLAUDE.md` is updated to inform Claude Code about CSW workflow (user preference: minimal vs proactive)

## Validation Criteria

- [x] spec/README.md exists and describes the workflow
- [x] spec/template.md exists and is ready for copying
- [x] spec/stack.md contains validation commands for TypeScript + Astro + Tailwind
- [x] spec/ directory structure matches documentation
- [x] Slash commands installed in Claude Code (verify with: /help)
- [x] CLAUDE.md updated with CSW workflow section

## Success Metrics

- [x] Directory structure matches spec/README.md documentation
- [x] Template can be copied to create new specs
- [ ] This bootstrap spec creates a merged PR (visible in `gh pr list --state merged`)
- [x] First hands-on experience with CSW workflow completed successfully

## References

- CSW Source: https://github.com/trakrf/claude-spec-workflow
- Stack: TypeScript + Astro + Tailwind (custom preset)
- Installation Date: 2025-10-30
