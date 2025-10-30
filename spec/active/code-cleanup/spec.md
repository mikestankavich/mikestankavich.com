# Feature: Code Quality Cleanup and Linting Strategy

## Metadata

**Type**: refactor

## Outcome

Establish consistent code formatting and full linting validation across the codebase.

## User Story

As a developer
I want full linting validation restored and code formatting consistent
So that future CSW specs can rely on working validation gates and the codebase maintains high quality standards

## Context

During CSW bootstrap validation (PR #15), we ran the stack validation commands and discovered code quality issues. To keep the bootstrap PR focused on CSW infrastructure, we made minimal fixes and deferred full cleanup to this spec.

**Fixed in PR #15:**
- ✅ Card.astro syntax error (src/components/Card.astro:24-27) - Fixed malformed JSX
- ✅ Temporary lint script - Only validates Card.astro to allow CSW bootstrap to ship
- ✅ Documented deferral strategy in spec/stack.md

**Remaining Work:**

1. **Restore Full Linting**: Replace temporary lint script with full Prettier validation
   - Current: `prettier --check "src/components/Card.astro"` (temporary)
   - Target: `prettier --check "**/*.{js,jsx,ts,tsx,md,mdx,svelte,astro}" "!spec/**"`

2. **Apply Prettier Formatting**: ~64 files need formatting
   - Markdown files (examples/, resume/, README files)
   - TypeScript/Astro components throughout src/
   - Configuration files

3. **ESLint Decision**: Decide on linting strategy
   - ESLint installed as dev dependency but not configured
   - Option A: Keep Prettier-only (simpler)
   - Option B: Add ESLint configuration (better static analysis)

**Current Stack:**
- TypeScript + Astro + Tailwind
- Prettier (working, but temporarily limited)
- ESLint (installed but not configured)
- Validation commands: `pnpm run lint`, `pnpm exec astro check`, `pnpm run build`

## Technical Requirements

1. **Restore full lint script in package.json**:
   - Replace: `prettier --check "src/components/Card.astro"` (temporary)
   - With: `prettier --check "**/*.{js,jsx,ts,tsx,md,mdx,svelte,astro}" "!spec/**"`
   - Excludes spec/ directory (contains code examples)

2. **Apply Prettier formatting to ~64 files**:
   - Run: `prettier --write "**/*.{js,jsx,ts,tsx,md,mdx,svelte,astro}" "!spec/**"`
   - Affects: examples/, resume/, src/, config files

3. **Make ESLint decision**:
   - Option A: Keep Prettier-only (remove ESLint deps, simpler)
   - Option B: Add ESLint config (better static analysis, more setup)

4. **Update spec/stack.md**:
   - Remove temporary notes about Card.astro-only validation
   - Document final linting strategy

## Validation Criteria

- [ ] Full lint script restored in package.json
- [ ] `pnpm run lint` validates all files (not just Card.astro)
- [ ] All Prettier formatting applied (~64 files formatted)
- [ ] ESLint decision implemented consistently
- [ ] spec/stack.md documents final linting approach
- [ ] All validation gates pass: lint, typecheck, build

## Success Metrics

- [ ] Full linting validation works for future specs
- [ ] Code formatting is consistent across all files
- [ ] Clear linting strategy documented for team
- [ ] No temporary workarounds remaining in validation gates

## References

- Bootstrap validation log: `spec/bootstrap/log.md`
- Card.astro error location: `src/components/Card.astro:24-27`
- Package.json lint script: line 10
- Stack validation commands: `spec/stack.md`

### Card.astro Issue Detail

**Current (broken) code at lines 24-27:**
```astro
{heading || subheading || date ? <div class='flex flex-col gap-y-0.5'>
</div><h1 class='text-lg font-medium text-secondary-foreground '>{heading}</h1>
<h2 class='text-muted-foreground'>{subheading}</h2>
<h2 class='text-sm text-accent-300'>{date}</h2></div> : null}
```

**Issue:** The conditional has an opening `<div>` immediately followed by a closing `</div>`, then the content appears after the closing tag but before the final `</div>`.

**Proposed fix:**
```astro
{
  heading || subheading || date ? (
    <div class='flex flex-col gap-y-0.5'>
      <h1 class='text-lg font-medium text-secondary-foreground '>{heading}</h1>
      <h2 class='text-muted-foreground'>{subheading}</h2>
      <h2 class='text-sm text-accent-300'>{date}</h2>
    </div>
  ) : null
}
```

### ESLint Configuration Options

**Option A: Prettier-only (Recommended for simplicity)**
- Remove `eslint` and `eslint-config-prettier` from package.json
- Update lint script to: `"lint": "prettier --check ."`
- Update spec/stack.md to note Prettier-only approach
- Pro: Simple, already working, no additional config needed
- Con: Lose static analysis capabilities

**Option B: Add ESLint configuration**
- Create `eslint.config.js` with Astro + TypeScript support
- Install required plugins: `@eslint/js`, `eslint-plugin-astro`, `@typescript-eslint/eslint-plugin`
- Configure to work with Prettier
- Pro: Better static analysis, catch potential bugs
- Con: Additional complexity, more dependencies, potential for more errors
