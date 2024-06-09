zip:
	@cd lambda && GOOS=linux GOARCH=amd64 go build -o bootstrap main.go
	@cd lambda && zip lambda_function_payload.zip bootstrap

	