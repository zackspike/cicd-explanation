# CI/CD Explanation Project

This repository is intentionally designed to demonstrate a common software problem in CI/CD workflows: a bug can remain hidden when the code and the tests both encode the wrong behavior.

## The problem

The application is supposed to provide a simple calculator, and the key method is:

```python
Calculator.sum(a, b)
```

The expected behavior is straightforward: it should return the sum of both numbers.

```python
Calculator.sum(2, 4) == 6
```

However, in [src/main.py](src/main.py), the implementation is currently:

```python
class Calculator:
    @staticmethod
    def sum(a: int, b: int) -> int:
        return 0
```

The test in [src/tests.py](src/tests.py) also asserts the same incorrect result:

```python
def test_sums_2_numbers():
    assert Calculator.sum(2, 4) == 0
```

This means the project is effectively validating the bug instead of the real requirement.

## Why this matters

The GitHub Actions workflow in [.github/workflows/test_and_build.yaml](.github/workflows/test_and_build.yaml) runs linting and tests on every push. In its current state, the workflow passes because the implementation and the test both expect `0`.

This is a useful example of why CI alone is not enough:

- a pipeline can be green even when the application is wrong
- bad tests can protect broken logic instead of exposing it
- the business requirement must be reflected in both code and tests

## Project structure

- [src/main.py](src/main.py): application code with the faulty `Calculator.sum` implementation
- [src/tests.py](src/tests.py): test suite validating the incorrect behavior
- [.github/workflows/test_and_build.yaml](.github/workflows/test_and_build.yaml): CI workflow that runs linting and tests
- [Dockerfile](Dockerfile): container definition for the application
- [src/requirements.txt](src/requirements.txt): Python dependencies for linting and testing

## How to reproduce the issue

From the project root:

```bash
cd src
pytest -o python_files=tests.py tests.py
```

This passes because the test is written to accept the wrong result.

## What the correct fix should look like

The method should be:

```python
class Calculator:
    @staticmethod
    def sum(a: int, b: int) -> int:
        return a + b
```

And the test should assert:

```python
assert Calculator.sum(2, 4) == 6
```

This repository is a minimal example to explain how broken requirements, buggy code, and weak tests can all align in a way that hides the real problem from CI.
