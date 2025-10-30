# Stack: TypeScript + Astro + Tailwind

> **Package Manager**: pnpm
> **Type Checker**: Astro Check
> **Build Tool**: Astro
> **Formatter**: Prettier (ESLint not configured)
> **Test Runner**: None configured

## Lint

```bash
pnpm run lint
```

**Note**: Currently validates only Card.astro (the file fixed in bootstrap). Full Prettier linting deferred to `spec/active/code-cleanup/` to keep bootstrap PR focused. ESLint was not configured in this project. When restored, the `spec/` directory should be excluded from linting since spec files may contain intentionally broken code examples.

## Typecheck

```bash
pnpm exec astro check
```

## Test

```bash
# No test runner configured yet
# When tests are added, update this section
echo "No tests configured"
```

## Build

```bash
pnpm run build
```

## Dev Server

```bash
pnpm run dev
```

## Preview Build

```bash
pnpm run preview
```
