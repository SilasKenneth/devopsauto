cd ~/.ssh
file="${1}.pem"
host="${2}"
commands="ls -la && sudo rm -rf lms /var/www/html/index.html /var/www/html/bundle.js && 
sudo apt update && 
sudo apt install git && 
git clone https://github.com/silaskenneth/devopsauto.git lms && 
cd lms && 
./run.sh certificicate &&
cd .. &&
ls -la &&
rm -rf lms"
function sshMachine(){
	if [[ $# -lt 2 ]]; then
		echo "
           You never specified all the required arguments
           you must provide the name of the key file without the suffix
           .pem as the first argument and the host as the second argument
           . The host can be an IP address of your AWS instance
           NOTE
           Note that the key file must be in the directory ~/.ssh/
		"
		exit 1
	fi
   ssh -i $file $host -t $commands
}

sshMachine