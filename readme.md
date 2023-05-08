## Installation
  Ruby 3.2.1
  ```
    bundle install
  ```

## Caveats
Im not sure if I misread something in any case
  - When Company and user records that share the same id only the first record is processed. The second record with the same id  is logged as a warning. Normally I would reject both unless there is a reason for two different entities to have the same id.
  - The provided file `example_output.txt` does not match the output generated for 2 reasons (not sure if this was intended or perhaps my oversight)
    1. users.json contains user `Nederson` and `Jimerson` with user Id = 33, therefore `Nederson` is skipped as duplicate. This is why the total amount of top ups is off by 55 tokens in the file being generated `./output/output.txt` from the provided `./spec/example_output.txt`
    2. Two companies with Id = 1 and Id = 4 have `email_status = false` and so those companies will have 0 users emailed. This contradicts with the provided sample `./spec/example_output.txt`. I decided to follow the instruction instead
    ``` If the users company email status is true indicate in the output that the
        user was sent an email ( don't actually send any emails).
        However, if the user has an email status of false, don't send the email
        regardless of the company's email status.
    ```
### Two ways to run the code
1. Run the main file (no params), its static just runs on the 2 json files provided in the challenge
   ```
     ruby challenge.rb
   ```
2. Running using the rakefile (with CLI params) for alternate files testing.
  - #### Bash
    User relative paths for the file names (data/users.json, data/companies.json),
    if for example to run the rakefile with the originally supplied users and companies files
    ```
      rake challenge:process[<user-file-name>,<company-file-name>]
    ```
  - #### ZSH (Need to escape brackets)
    ```sh
      rake challenge:process\[data/users2.json,data/companies2.json\]
    ```
