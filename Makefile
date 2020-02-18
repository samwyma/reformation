test:
	aws-assume-role --account sandbox > /dev/null
	bats assets/