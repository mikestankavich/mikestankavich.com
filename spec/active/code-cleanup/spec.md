# Feature: Code Quality Cleanup

## Metadata

**Type**: refactor

## Outcome

Fix validation errors and establish consistent code formatting across the codebase.

## User Story

As a developer
I want all validation gates to pass cleanly
So that the codebase maintains high quality standards and CSW workflow can function properly

## Context

During CSW bootstrap validation (PR #15), we ran the stack validation commands and discovered several code quality issues that were deferred to keep the CSW infrastructure PR focused and reviewable.

**Issues Found:**

1. **Card.astro Syntax Error**: Malformed JSX structure causing lint failures
   - Location: `src/components/Card.astro:24-27`
   - Error: `SyntaxError: Unexpected token, expected ":"`
   - Root cause: Opening `<div>` immediately followed by closing `</div>` before content

2. **ESLint Configuration**: ESLint is referenced in package.json but not configured
   - Current: `package.json` has `eslint` in lint script but no config file
   - Multiple configuration attempts failed during bootstrap
   - Decision needed: Add ESLint config or remove from lint script

3. **Code Formatting**: Prettier formatting inconsistencies across ~65 files
   - Running `pnpm run lint --write` would reformat many files
   - Includes markdown files, TypeScript, Astro components, etc.

**Current Stack:**
- TypeScript + Astro + Tailwind
- Prettier (working)
- ESLint (not configured, causing failures)
- Validation commands: `pnpm run lint`, `pnpm exec astro check`, `pnpm run build`

## Technical Requirements

1. Fix Card.astro syntax error to resolve lint failures
2. Make ESLint configuration decision:
   - Option A: Keep Prettier-only (remove ESLint from lint script)
   - Option B: Add minimal ESLint config for Astro + TypeScript
3. Apply consistent Prettier formatting across codebase
4. Verify all validation gates pass: lint, typecheck, build

## Validation Criteria

- [ ] `pnpm run lint` completes without errors
- [ ] `pnpm exec astro check` shows 0 errors, 0 warnings
- [ ] `pnpm run build` succeeds
- [ ] Card.astro syntax error is fixed (src/components/Card.astro:24-27)
- [ ] ESLint configuration decision is implemented consistently

## Success Metrics

- [ ] All validation commands pass cleanly
- [ ] No syntax errors in codebase
- [ ] Code formatting is consistent across all files
- [ ] Future CSW specs can rely on working validation gates

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
