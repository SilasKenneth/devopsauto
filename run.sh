
REPO_URL="https://github.com/silaskenneth/eight.one.git"
DIRECTORY='eightone'
DOMAIN='problemsolved.ga'
FOUND="${1#*cert*}"

function init_vm(){
	# Update the instance and run the necessary commands to install packages
	sudo apt-get update
	# sudo rm -rf /etc/nginx
	# sudo rm -rf /etc/letsencrypt/archives
    # sudo rm -rf /etc/letsencrypt/live
    # sudo rm -rf /etc/letsencrypt/renewal
    # sudo -H apt-get purge nginx nginx-common nginx-full -y
    sudo apt-get autoremove -y
    # sudo -H apt-get install nginx -y
	sudo apt-get install git nodejs npm nginx python3 -y
	sudo service nginx start
}
function clonerepo(){
	# Run git clone to clone the project repo
	git clone $REPO_URL $DIRECTORY
}


function directory_exists(){
	# Check if the directory already exists
	if [[ -e $DIRECTORY ]]; then
		echo "Directory already exists..."
	fi
}

function remove_directories(){
	# If the directory exists then remove it first
	doe=$(directory_exists)
	if [[ $doe == *exists* ]]; then
		echo "Trying to remove the directory"
		rm -rf $DIRECTORY
	fi
}



function copy_files_to_nginx_docroot(){
	# Copy the generated distribution files to the nginx document root
	sudo mv dist/* /var/www/html
}

function build_application(){
	#Move to the just clone directory
	cd $DIRECTORY
	#Install yarn npm package on a global scope
	sudo npm install -g yarn
	# Install other npm packages required by the application
	yarn install
	# Build the application to produce a production version
	yarn build
}

function clean(){
	# Remove the project folder
	cd ..
	sudo rm -rf $DIRECTORY
}
#Install the letsencrypt certbot
function install_certbot(){
	sudo apt-get install software-properties-common -y
	sudo add-apt-repository universe -y
	# Add the cerbot repository to the sources.list
	sudo add-apt-repository ppa:certbot/certbot -y
	# Update the sources list
	sudo apt-get update
	#Install certbot and python-certbot-nginx for nginx server
	sudo apt-get install certbot python-certbot-nginx -y 
}
function modify_config(){
	#Modify the nginx configurations
	config_text='
      server {
      	if ($host = problemsolved.ga) {
           return 301 https://$host$request_uri;
        } 
        if($host = www.problemsolved.ga){
        	return 301 https://problemsolved.ga$request_uri;
        }

     listen 80 ;
     listen [::]:80 ;
     server_name problemsolved.ga;
      return 404;
    }
    server{
    	listen 80;
    	listen [::]:80;
    	server_name problemsolved.ga;
    	location / {
    		proxy_pass http://127.0.0.1:3000
    	}
    }
	'
	# Append the configuration file to the default config of sites enabled
	echo "$config_text" | sudo tee -a /etc/nginx/sites-available/problemsolved
	# Remove the symbolic link on the /etc/nginx/sites-available/default file 
	# at /etc/nginx/sites-enabled/default
	sudo unlink /etc/nginx/sites-enabled/default
	# Create a symblic link to the /etc/nginx/sites-enabled/default
	sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
}
function install_certificate(){
	#Install certbot with configurations
	# Choose whether to install the certificate or not
	if [[ "$FOUND" != "${1}" ]]; then
		echo "Installing certificate"
		sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m webmaster@problemsolved.ga --redirect
		modify_config
    fi
}



function automate(){
	init_vm
	remove_directories
	clonerepo
	install_certbot
	install_certificate
	build_application
	copy_files_to_nginx_docroot
	clean
}
function deploy(){
	# Try to deploy the application
	echo "Pulling the trigger..."
	sleep 1
	echo "Launching misiles"
	sleep 1
	echo "Working after Business hours"
	automate
	sleep 1
	echo "Finalizing everything..."
}
deploy
