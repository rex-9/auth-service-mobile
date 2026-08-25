.PHONY: test test-auth test-coverage test-analyze test-e2e test-e2e-auth test-e2e-ios help

## Run all unit/widget tests
test:
	flutter test

## Run auth module tests only
test-auth:
	flutter test test/modules/auth/

## Run tests with coverage
test-coverage:
	flutter test --coverage

## Run static analysis
test-analyze:
	flutter analyze

## Run all Patrol E2E tests
test-e2e:
	./scripts/run_e2e.sh all

## Run auth E2E tests only
test-e2e-auth:
	./scripts/run_e2e.sh all

## Run specific auth flows
test-e2e-signin:
	./scripts/run_e2e.sh sign-in

test-e2e-signup:
	./scripts/run_e2e.sh sign-up

test-e2e-passcode:
	./scripts/run_e2e.sh passcode

test-e2e-reset:
	./scripts/run_e2e.sh password-reset

test-e2e-signout:
	./scripts/run_e2e.sh sign-out

## Run E2E on iOS simulator
test-e2e-ios:
	./scripts/run_e2e.sh all -d "iPhone 16 Pro"
