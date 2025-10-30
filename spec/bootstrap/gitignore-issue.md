# Bug: Documentation incorrectly suggests gitignoring log.md files

## Problem

CSW documentation and testing files suggest adding `spec/active/*/log.md` to `.gitignore`, but this breaks the cleanup process. The log.md files need to be tracked in git for the workflow to function properly.

## Evidence in CSW Repository

**CHANGELOG.md** (line reference needed):
```
- Auto-updates `.gitignore` with spec log patterns
```

**TESTING.md** (line reference needed):
```bash
cat .gitignore | grep "spec/active/\*/log.md"
```

These references suggest that log.md files should be gitignored, which is incorrect.

## Why This is Wrong

1. **Breaks cleanup process**: The `/cleanup` command needs to access log.md to verify the feature was completed
2. **Loses build history**: log.md documents validation results and is valuable for code review
3. **Inconsistent with workflow**: Other spec files (spec.md, plan.md) are tracked, log.md should be too

## Impact

Users following CSW documentation will add log.md to gitignore, then:
- `/cleanup` will fail or behave incorrectly
- Build logs won't be visible in PRs for reviewers
- No audit trail of what was built and validated

## Expected Behavior

- **log.md should be committed** along with spec.md and plan.md
- Documentation should NOT suggest gitignoring log.md
- TESTING.md should NOT check for log.md in gitignore

## Suggested Fix

1. Remove references to gitignoring log.md from:
   - CHANGELOG.md
   - TESTING.md
   - Any init/setup scripts

2. Update documentation to clarify:
   - spec.md, plan.md, and log.md are all tracked in git
   - They provide complete audit trail for the feature
   - Only temporary files (like vim swaps) should be gitignored

3. Consider adding a check in `/ship` that warns if log.md is gitignored

## How We Discovered This

We followed CSW's bootstrap process and documentation. When pushing our PR, we noticed the gitignore addition seemed wrong. After questioning it, we realized it would break `/cleanup`. We've removed it from our PR and are reporting this bug upstream.

## Related

This may be related to an older design decision or misunderstanding about which files should be tracked. All spec files (spec.md, plan.md, log.md) should be committed as part of the feature implementation.

---

**Priority**: Medium-High - Affects all CSW users who follow documentation
**Type**: Documentation bug + potential code issue if auto-generated
