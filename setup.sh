#!/bin/bash
# you can source this to your current shell to activate it
# this script is idempotent: resulting state is updated, not incremented

# ensure we use an up-to-date local python environment
declare -F deactivate && deactivate
virtualenv -p python2.7 local
. local/bin/activate
pip install -r requirements.txt

# create local test host
vagrant up

export $( # gather settings used to connect to current vagrant box
	vagrant ssh-config |
	perl -wne '
		%keys = (
			Host => "box",
			User => "user",
			Port => "port",
			HostName => "host",
			"IdentityFile" => "private_key_file"
		);
		$key_match = join "|", keys %keys;
		print "ssh_$keys{$1}=$2\n" if /^\s*($key_match) (.*)/
	'
)
echo "[local-test-hosts]
$ssh_host \
	ansible_ssh_host=$ssh_host \
	ansible_ssh_port=$ssh_port \
	ansible_ssh_user=$ssh_user \
	ansible_ssh_private_key_file=$ssh_private_key_file
" > local/hosts

ssh-keygen -R "[$ssh_host]:$ssh_port" &>/dev/null  # remove old host key
ssh-keyscan -p "$ssh_port" "$ssh_host" 2>/dev/null |  # allow new host key
	perl -wpe "s/^\S+/[$ssh_host]:$ssh_port/" >> ~/.ssh/known_hosts

