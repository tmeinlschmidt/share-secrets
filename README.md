# Share secrets with your team

If you need to share some secrets with the team and you don't want to expose these publicly or keep somewhere else,
it's time to use some secure sharing.

## How it works
* SSH generated certificate is used to encrypt and decrypt data
* Existing user must reencrypt existing files for new user (or when user is removed)

## File structure
* `data/shared.json` - encrypted file containing shared secrets
* `data/.shared.json.owners` - list of isids which are able to read (and recrypt) the `data/shared.json`
* `certs` - all certificates kept here
* `certs/*.meta` - contains the info about the key used for certficate, you don't need to remember which one it was

## Add/Edit new file
* create or edit file - `./edit.sh data/sample_file.txt`
* `vim` is the default editor when `EDITOR` environment variable not set

## Adding new user
* add new user's generated certificate into `certs` directory - user must use using `scripts/generate_cert.sh` script

## Reencrypt files for the new user
* either run `./edit.sh -r file` (-r stands for recode, no edit then) or `./recode.sh` to process all the files in `data`

## Contributing
* Fork it ( https://github.com/[my-github-username]/eye-hipchat/fork )
* Create your feature branch (git checkout -b my-new-feature)
* Commit your changes (git commit -am 'Add some feature')
* Push to the branch (git push origin my-new-feature)
* Create a new Pull Request
