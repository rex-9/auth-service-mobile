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
	./scripts/test.sh all

## Run auth E2E tests only
test-e2e-auth:
	./scripts/test.sh all

## Run specific auth flows
test-e2e-signin:
	./scripts/test.sh sign-in

test-e2e-signup:
	./scripts/test.sh sign-up

test-e2e-password:
	./scripts/test.sh password

test-e2e-reset:
	./scripts/test.sh password-reset

test-e2e-signout:
	./scripts/test.sh sign-out

## Run E2E on iOS simulator
test-e2e-ios:
	./scripts/test.sh all -d "iPhone 16 Pro"
