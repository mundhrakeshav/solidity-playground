include .env

snapshot:
	@forge snapshot --fork-url ${RPC} --fork-block-number ${BLOCK} --gas-report --diff .gas-snapshot-main

test_all:
	@forge test --fork-url ${RPC} -vvv

test_latest:
	@forge test --fork-url ${RPC} -vvv --match-contract ${P}

test_quick:
	@forge test --fork-url ${RPC} --fork-block-number ${BLOCK} -vv --match-contract ${P}

coverage:
	@forge coverage --fork-url ${RPC} --fork-block-number ${BLOCK} -vvvv --contracts src --report lcov --ir-minimum
	@lcov --exclude '*.lib.sol' --remove ./lcov.info -o ./lcov.info 'script/*' 'test/*'

coverage_html:
	@make coverage
	@genhtml -o report lcov.info --branch-coverage

test_func:
	@forge test --fork-url ${RPC} --fork-block-number ${BLOCK} -vvvv --match-test ${P}

test_func_quick:
	@forge test --fork-url ${RPC} --fork-block-number ${BLOCK} -vv --match-test ${P}

slither:
	@slither . --exclude-dependencies --checklist --filter-paths "test|lib|script" --sarif slither.sarif> slither.md
