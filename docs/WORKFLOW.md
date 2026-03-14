# Development Workflow

## Branching Strategy

- **main** - stable, production-ready code
- **develop** - integration branch for features (when used)
- **feature/\*** - new features (e.g., `feature/config-validation`)
- **fix/\*** - bug fixes (e.g., `fix/windows-path-handling`)
- **hotfix/\*** - emergency fixes for production

## Day-to-Day Development

### Starting Work

```bash
# Get latest
git checkout main
git pull origin main

# Create branch
git checkout -b feature/your-feature
```

### Making Changes

```bash
# Edit code
# Run directly to test (no build step needed)
python3 src/cleaner.py --dry-run

# Run tests
make test
# or: python -m pytest tests/ -v

# Format and lint
black src/
isort src/
flake8 src/
```

### Committing

Follow conventional commit format:

```
feat: add streaming JSON parser for large files
fix: resolve Windows path separator issue
docs: update architecture diagram
test: add backup creation integration test
refactor: simplify clean_claude_json control flow
chore: bump click dependency to 8.1.0
```

### Creating a Pull Request

1. Push your branch: `git push origin feature/your-feature`
2. Open PR against `main` (or `develop` if using gitflow)
3. Fill out the PR template (`.github/PULL_REQUEST_TEMPLATE.md`)
4. Ensure tests pass and code is formatted
5. Request review

## CI/CD

GitHub Actions workflow (`.github/workflows/ci.yml`) runs on push and PR:
- Checkout code
- Set up Python
- Install dependencies
- Run linting (flake8)
- Run tests (pytest)

## Release Process

1. Ensure all tests pass: `make test`
2. Format code: `black src/ && flake8 src/`
3. Update `CHANGELOG.md` with version and date
4. Bump version in `src/cleaner.py` (`show_version()`)
5. Commit: `git commit -m "chore: release v1.x.x"`
6. Tag: `git tag -a v1.x.x -m "Release v1.x.x"`
7. Push: `git push origin main --tags`
8. Optionally build distribution: `python -m build && twine check dist/*`

## Code Review Checklist

- [ ] Tests pass (`make test`)
- [ ] Code formatted (`black src/`)
- [ ] Linting clean (`flake8 src/`)
- [ ] No secrets or credentials committed
- [ ] CHANGELOG.md updated if behavior changed
- [ ] Documentation updated if user-facing behavior changed

## Versioning

Semantic Versioning (SemVer):
- **MAJOR** (2.0.0): Breaking changes
- **MINOR** (1.1.0): New features, backward compatible
- **PATCH** (1.0.1): Bug fixes, backward compatible
