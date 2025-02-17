include .env

snapshot:
	@forge snapshot --fork-url ${RPC} --fork-block-number ${BLOCK} --gas-report --diff .gas-snapshot-main

test_all:
	@forge test --fork-url ${RPC} -vvv

test_exact:
	@forge test --fork-url ${RPC} -vvv --match-contract ${P}

test_exact_at:
	@forge test --fork-url ${RPC} --fork-block-number ${BLOCK} -vv --match-contract ${P}

coverage:
	@forge coverage --fork-url ${RPC} --fork-block-number ${BLOCK} -vvvv --contracts src --report lcov --ir-minimum
	@lcov --exclude '*.lib.sol' --remove ./lcov.info -o ./lcov.info 'script/*' 'test/*'

coverage_html:
	@make coverage
	@genhtml -o report lcov.info --branch-coverage

test_func:
	@fork_url_flag="--fork-url $(RPC)"; \
	fork_block_flag="--fork-block-number $(BLOCK)"; \
	if [ "$(RPC)" = "" ]; then \
        echo "No rpc specified, running locally"; \
        fork_url_flag=""; \
    fi; \
	if [ "$(BLOCK)" = "" ]; then \
        echo "No block specified, forking latest"; \
        fork_block_flag=""; \
    fi; \
    forge test $${fork_url_flag} $${fork_block_flag} -vvvvv --match-test ${P}

test_func_quick:
	@fork_url_flag="--fork-url $(RPC)"; \
	fork_block_flag="--fork-block-number $(BLOCK)"; \
	if [ "$(RPC)" = "" ]; then \
        echo "No rpc specified, running locally"; \
        fork_url_flag=""; \
    fi; \
	if [ "$(BLOCK)" = "" ]; then \
        echo "No block specified, forking latest"; \
        fork_block_flag=""; \
    fi; \
    forge test $${fork_url_flag} $${fork_block_flag} -vvv --match-test ${P}

slither:
	@slither . --exclude-dependencies --checklist --filter-paths "test|lib|script" --sarif slither.sarif> slither.md
