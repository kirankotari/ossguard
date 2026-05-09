# Contributing to OSSGuard

Thank you for your interest in contributing to OSSGuard! This project follows the [OpenSSF Community Guidelines](https://openssf.org/community/).

## How to Contribute

OSSGuard is organized as a multi-repo project. Contributions to source code go to the implementation repositories:

| Implementation | Repository | Language |
|---------------|-----------|----------|
| Python (reference) | [ossguard-python](https://github.com/kirankotari/ossguard-python) | Python 3.9+ |
| Go | [ossguard-go](https://github.com/kirankotari/ossguard-go) | Go 1.22+ |
| Node.js | [ossguard-npm](https://github.com/kirankotari/ossguard-npm) | TypeScript / Node.js 18+ |

Each implementation repo has its own `CONTRIBUTING.md` with language-specific setup and testing instructions.

## This Repository

This repository (`ossguard`) contains:

- Project-wide documentation (`docs/`)
- Installation guides
- Command reference
- Architecture documentation

### Improving Documentation

1. Fork this repository
2. Create a branch: `git checkout -b docs/my-improvement`
3. Make your changes
4. Submit a Pull Request

Documentation contributions are especially welcome for:

- Fixing typos or unclear language
- Adding examples and use cases
- Improving command documentation
- Translating documentation

## Reporting Issues

- **Bugs in a specific implementation** → file in the appropriate repo ([Python](https://github.com/kirankotari/ossguard-python/issues), [Go](https://github.com/kirankotari/ossguard-go/issues), [npm](https://github.com/kirankotari/ossguard-npm/issues))
- **Documentation issues** → [file here](https://github.com/kirankotari/ossguard/issues)
- **Feature requests** → [file here](https://github.com/kirankotari/ossguard/issues) (cross-cutting features) or in the relevant implementation repo
- **Security vulnerabilities** → see [SECURITY.md](SECURITY.md)

## Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation only
- `test:` — adding or updating tests
- `refactor:` — code change that neither fixes a bug nor adds a feature
- `ci:` — CI/CD changes
- `chore:` — maintenance tasks

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold this code.

## License

By contributing, you agree that your contributions will be licensed under the [Apache License 2.0](LICENSE).
