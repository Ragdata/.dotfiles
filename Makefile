.PHONY: test test-unit test-integration test-coverage clean lint format install-test-deps

# Test commands
test: install-test-deps
    pytest tests/ -v

test-unit:
    pytest tests/test_install.py -v -m "unit"

test-integration:
    pytest tests/test_integration.py -v -m "integration"

test-edge-cases:
    pytest tests/test_edge_cases.py -v -m "edge_case"

test-coverage:
    pytest tests/ --cov=install --cov-report=html --cov-report=term-missing

# Code quality
lint:
    flake8 install.py dotware/
    black --check install.py dotware/ tests/
    isort --check-only install.py dotware/ tests/

format:
    black install.py dotware/ tests/
    isort install.py dotware/ tests/

# Setup
install-test-deps:
    pip install -r requirements-test.txt

# Cleanup
clean:
    rm -rf .pytest_cache/
    rm -rf htmlcov/
    rm -rf .coverage
    find . -type d -name __pycache__ -exec rm -rf {} +
    find . -type f -name "*.pyc" -delete
