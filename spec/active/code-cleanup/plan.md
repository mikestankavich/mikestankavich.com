# Implementation Plan: Code Quality Cleanup and Linting Strategy
Generated: 2025-10-30T14:00:00Z
Specification: spec.md

## Understanding

This spec restores full linting validation and applies consistent code formatting across the codebase. During CSW bootstrap (PR #15), we implemented a temporary lint script that only validated Card.astro to allow CSW infrastructure to ship cleanly. Now we're completing the cleanup by:

1. Restoring full Prettier validation
2. Deciding on linting strategy (Prettier-only, remove ESLint)
3. Applying Prettier formatting to ~60 files (excluding examples/)
4. Updating documentation

**Decision Made**: Prettier-only approach (remove ESLint dependencies for simplicity)

**Formatting Scope**: All files except examples/ directory (user doesn't need those formatted)

## Relevant Files

**Reference Patterns**:
- `.prettierrc` - Prettier configuration already exists (tabs, single quotes, etc.)
- `.prettierignore` - Currently only excludes node_modules
- `package.json:12` - Current temporary lint script
- `spec/stack.md:15` - Documents temporary lint limitation

**Files to Modify**:
- `.prettierignore` - Add examples/ and spec/ exclusions
- `package.json` - Restore full lint script, remove ESLint deps
- `spec/stack.md` - Document final Prettier-only approach
- ~60 files - Apply Prettier formatting (code files, resume/, READMEs, config)

**Files NOT to Modify**:
- `examples/*.md` - Excluded from formatting per user preference
- `spec/**` - Already excluded, contains code examples

## Architecture Impact

- **Subsystems affected**: Tooling/linting only
- **New dependencies**: None
- **Removed dependencies**: ESLint packages (4 devDependencies)
- **Breaking changes**: None (formatting only)

## Task Breakdown

### Task 1: Update .prettierignore

**File**: `.prettierignore`
**Action**: MODIFY

**Implementation**:
Add exclusions for directories we don't want to format:
```
node_modules/**
examples/
spec/
```

**Rationale**:
- `examples/` - User doesn't need these formatted
- `spec/` - Contains intentional code examples that may be broken

**Validation**:
```bash
cat .prettierignore  # Verify exclusions added
```

### Task 2: Restore Full Lint Script

**File**: `package.json`
**Action**: MODIFY (line 12)

**Implementation**:
Replace temporary lint script with full Prettier validation:

**Current** (line 12):
```json
"lint": "echo '⚠️  Full linting deferred to code-cleanup spec (see spec/active/code-cleanup/)' && prettier --check \"src/components/Card.astro\""
```

**New**:
```json
"lint": "prettier --check \"**/*.{js,jsx,ts,tsx,md,mdx,svelte,astro}\""
```

**Note**: Prettier automatically respects `.prettierignore`, so `spec/` and `examples/` will be excluded.

**Validation**:
```bash
pnpm run lint  # Should show ~60 files with formatting issues
```

### Task 3: Remove ESLint Dependencies

**File**: `package.json`
**Action**: MODIFY (devDependencies section, lines 43-49)

**Implementation**:
Remove these 4 devDependencies:
```json
"@typescript-eslint/parser": "7.8.0",
"eslint": "8.57.0",
"eslint-plugin-astro": "0.34.0",
"eslint-plugin-jsx-a11y": "6.8.0",
```

Keep these Prettier dependencies:
```json
"prettier": "3.2.5",
"prettier-config-standard": "7.0.0",
"prettier-plugin-astro": "0.13.0",
"prettier-plugin-tailwindcss": "0.5.14"
```

**Validation**:
```bash
pnpm install  # Reinstall to remove ESLint packages
pnpm run lint  # Verify lint still works (Prettier-only)
```

### Task 4: Apply Prettier Formatting

**Files**: ~60 files across codebase
**Action**: MODIFY (formatting only, no logic changes)

**Implementation**:
Run Prettier with write flag to format all files:
```bash
prettier --write "**/*.{js,jsx,ts,tsx,md,mdx,svelte,astro}"
```

**Expected changes**:
- Resume markdown files (8 files): Line length, list formatting
- README files (3 files): Consistent spacing
- Source files (~40 files): Indentation, quotes, trailing commas per .prettierrc
- Config files (~5 files): Consistent formatting

**Note**: Prettier will automatically skip `spec/` and `examples/` per `.prettierignore`

**Validation**:
```bash
pnpm run lint  # Should pass with "All matched files use Prettier code style!"
pnpm exec astro check  # Verify no type errors introduced
pnpm run build  # Verify build still succeeds
```

### Task 5: Update spec/stack.md Documentation

**File**: `spec/stack.md`
**Action**: MODIFY (lines 9-15)

**Implementation**:

**Current** (lines 9-15):
```markdown
## Lint

```bash
pnpm run lint
```

**Note**: Currently validates only Card.astro (the file fixed in bootstrap). Full Prettier linting deferred to `spec/active/code-cleanup/` to keep bootstrap PR focused. ESLint was not configured in this project. When restored, the `spec/` directory should be excluded from linting since spec files may contain intentionally broken code examples.
```

**New**:
```markdown
## Lint

```bash
pnpm run lint
```

**Note**: Runs Prettier check on all files except `spec/` and `examples/` directories (see `.prettierignore`). This project uses Prettier-only for code formatting. ESLint was removed for simplicity - Astro Check provides sufficient TypeScript validation.
```

**Rationale**: Document final state clearly for future developers

**Validation**:
```bash
cat spec/stack.md  # Verify documentation updated
```

## Risk Assessment

**Risk**: Prettier formatting changes resume markdown in ways that break PDF generation
- **Likelihood**: Low (Prettier is conservative with markdown)
- **Impact**: Medium (PDFs might look different)
- **Mitigation**: User will do lightweight review of PR. If PDFs look wrong, can exclude `resume/*.md` in follow-up
- **Fallback**: Git revert individual resume files if needed

**Risk**: Formatting 60 files creates large PR diff
- **Likelihood**: Certain
- **Impact**: Low (formatting-only changes are easy to review)
- **Mitigation**: User comfortable with "semi-yolo" approach, will skim review
- **Note**: All changes are reversible via git

**Risk**: Removing ESLint loses static analysis capabilities
- **Likelihood**: Certain (intentional decision)
- **Impact**: Low (Astro Check provides TypeScript validation)
- **Mitigation**: Can always add ESLint back later if needed

## Integration Points

- **None** - This is purely a tooling/formatting refactor
- No runtime code changes
- No API changes
- No data model changes

## VALIDATION GATES (MANDATORY)

**CRITICAL**: After each task, run these commands from `spec/stack.md`:

```bash
pnpm run lint          # Gate 1: Prettier formatting check
pnpm exec astro check  # Gate 2: TypeScript validation
pnpm run build         # Gate 3: Build succeeds
```

**Enforcement Rules**:
- If ANY gate fails → Fix immediately
- Re-run validation after fix
- Loop until ALL gates pass
- After 3 failed attempts → Stop and ask for help

**Do not proceed to next task until current task passes all gates.**

## Validation Sequence

**After Task 1** (Update .prettierignore):
- Verify file contents with `cat .prettierignore`

**After Task 2** (Restore lint script):
- Run `pnpm run lint` - Should fail with ~60 formatting issues (expected)

**After Task 3** (Remove ESLint):
- Run `pnpm install`
- Verify ESLint packages removed: `pnpm list | grep eslint` (should be empty)
- Run `pnpm run lint` - Should still work (Prettier-only)

**After Task 4** (Apply formatting):
- Run `pnpm run lint` - Should pass (all files formatted)
- Run `pnpm exec astro check` - Should pass (0 errors, 0 warnings)
- Run `pnpm run build` - Should pass (11 pages built)

**After Task 5** (Update docs):
- Verify `spec/stack.md` documents Prettier-only approach

**Final validation** (all tasks complete):
```bash
pnpm run lint && pnpm exec astro check && pnpm run build
```
All three commands must succeed.

## Plan Quality Assessment

**Complexity Score**: 1/10 (LOW)
- File Impact: 0 files created, 3 modified (package.json, .prettierignore, spec/stack.md) + ~60 formatted
- Subsystem Coupling: 1 (tooling only)
- Task Estimate: 5 subtasks
- Dependencies: 0 new (removing 4)
- Pattern Novelty: Existing patterns (standard Prettier setup)

**Confidence Score**: 9/10 (HIGH)

**Confidence Factors**:
✅ Clear requirements from spec
✅ Prettier configuration already exists and working
✅ All clarifying questions answered (Prettier-only, format all except examples/)
✅ No logic changes - formatting only
✅ Validation gates straightforward (lint, typecheck, build)
✅ User comfortable with "semi-yolo" review approach
✅ All changes reversible via git

**Assessment**: High confidence implementation. This is a straightforward tooling refactor with clear validation gates and minimal risk. Prettier is deterministic and won't introduce logic bugs.

**Estimated one-pass success probability**: 95%

**Reasoning**:
- Prettier is well-tested and deterministic
- No complex logic changes
- Clear validation criteria
- Only risk is aesthetic (resume PDFs), which user will review
- Strong existing patterns to follow (.prettierrc already configured)
- Small chance of edge cases in ~60 files, but easily fixed if found

## Next Steps

After this plan is approved:
1. Run `/build spec/active/code-cleanup/` to execute implementation
2. Review PR with focus on resume markdown changes (lightweight review)
3. Ship PR to restore full linting validation
4. Future CSW specs can rely on working validation gates
