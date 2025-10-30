# Enhancement: Bootstrap Should Update CLAUDE.md with CSW Workflow Information

## Problem

When CSW is installed in a project, Claude Code has no awareness that the project uses the CSW workflow unless the user explicitly mentions it in each session. This creates friction:

1. Users must repeatedly explain the CSW workflow to Claude
2. Claude doesn't know to look in `spec/` for feature specifications
3. New developers (or AI assistants) starting fresh sessions have no context
4. The workflow feels disconnected from the project

## Proposed Solution

The bootstrap spec should include updating `CLAUDE.md` to inform Claude Code about the CSW workflow. During `/plan`, ask the user to choose between two styles:

### Option 1: Minimal (Default)

Simple awareness - Claude knows CSW exists but doesn't proactively suggest it.

```markdown
## Development Workflow

This project uses [Claude Spec Workflow](https://github.com/trakrf/claude-spec-workflow) for structured feature development. See `spec/README.md` for details.
```

### Option 2: Proactive

Includes gentle nudging for complex changes.

```markdown
## Development Workflow

This project uses [Claude Spec Workflow](https://github.com/trakrf/claude-spec-workflow). For new features or complex changes, follow the CSW workflow (`/plan → /build → /check → /ship`). See `spec/README.md` for details.
```

## Implementation Changes

### 1. Update `templates/bootstrap-spec.md`

Add to **Context** section:

```markdown
**CLAUDE.md Update Options**:

- **Minimal** (default): Simple awareness - "This project uses CSW, see spec/README.md"
- **Proactive**: Adds suggestion to use CSW for complex/multi-file changes

During `/plan`, the user should be asked which style they prefer.
```

Add to **Technical Requirements**:

```markdown
- `CLAUDE.md` is updated to inform Claude Code about CSW workflow (user preference: minimal vs proactive)
```

Add to **Validation Criteria**:

```markdown
- [ ] CLAUDE.md updated with CSW workflow section
```

### 2. Update Planning Process

When `/plan` is run on the bootstrap spec, the AI should:

1. Ask the user which CLAUDE.md style they prefer (minimal or proactive)
2. Include the appropriate CLAUDE.md update in the implementation plan
3. During `/build`, add the chosen section to CLAUDE.md

## Benefits

1. **Automatic Context**: Every Claude Code session knows about CSW immediately
2. **Self-Documenting**: New developers understand the workflow without asking
3. **Reduced Friction**: No need to explain CSW in each session
4. **User Choice**: Flexible - users pick the level of enforcement they want
5. **Consistency**: All CSW projects follow the same pattern

## Reference Implementation

We've implemented this enhancement in a real project:

- Project: https://github.com/mikestankavich/mikestankavich.com (if public)
- Files modified:
  - `spec/bootstrap/spec.md` - Added CLAUDE.md requirement and options
  - `CLAUDE.md` - Added minimal CSW workflow section
  - Works great! Claude is now aware of CSW in every session

See our implementation for a working example of the changes proposed above.

## Design Considerations

### Why Two Options?

- **Minimal**: For teams that want flexibility, quick experiments, or prefer to use CSW selectively
- **Proactive**: For teams that want stricter workflow enforcement and more guidance

### Why Ask During `/plan`?

- Bootstrap should be interactive and customizable
- Different projects/teams have different needs
- Users opt-in to enforcement rather than having it forced
- Default (minimal) works for most cases

### Why Keep It Concise?

- CLAUDE.md can get bloated with too many instructions
- Detail lives in `spec/README.md` where it belongs
- The goal is awareness, not duplication of docs

## Alternative Considered

We considered always adding the proactive version, but decided against it because:

- Could feel naggy/pushy
- "Complex" is subjective and hard to define
- Users should maintain autonomy over when to use CSW
- Some changes legitimately don't need the full workflow (hotfixes, typos, experiments)

## Questions for Maintainer

1. Should this be a separate optional step in the bootstrap, or integrated as described?
2. Any concerns about the two-option approach vs a single standard?
3. Would you prefer different wording for the CLAUDE.md sections?
4. Should we add an example of the "proactive" version to the CSW docs?

---

**Implementation Status**: ✅ Tested and working in our project
**Breaking Changes**: None - this is purely additive
**Backward Compatibility**: Existing CSW projects unaffected
