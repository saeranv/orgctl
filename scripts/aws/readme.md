# AWS UBUNTU SERVER

## SETUP SERVER
- create and launch AWS EC2 instance
- get `.pem` key created when AWS EC2 instance is created 
- orgmode `.pem` is: `/orgmode/cred/orgmode_aws_key.pem`
- run `chmod 400 <key.pem>` for security

## SSH TO SERVER
- run `ssh -i /path/<key.pem> <user-name>@<public-dns-name>`
- config details at 'Instance'>'Connect to instance'>'SSH client'
- dns login and key saved in /orgmode/cred/ and exported so run:
  `sudo ssh -i $AWS_KEY ubuntu@$AWS_DNS`

## SET SYM-LINK SYSTEMCTL SERVICE
$ ln -s ./egn_server.service /etc/systemd/system/egn_server.service





