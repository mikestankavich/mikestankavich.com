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

**Note**: Runs Prettier check on all files except `spec/` and `examples/` directories (see `.prettierignore`). This project uses Prettier-only for code formatting. ESLint was removed for simplicity - Astro Check provides sufficient TypeScript validation.

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
