#sudo apt-get install nginx git node -y
if [[ -e "ah-technocrats-frontend" ]]; then
	echo "Directory already exists..."
	echo "Trying to remove the directory"
	rm -rf "ah-technocrats-frontend"
	echo "Cloning the repo"
	git clone "https://github.com/andela/ah-technocrats-frontend.git"
else
	echo "Cloning the repo to the new directory"
	sleep 2
	git clone "https://github.com/andela/ah-technocrats-frontend.git"
fi

if [[ ${?} -ne 0 ]]; then
	echo "Could not clone the repo"
	exit 1
else
	cd "ah-technocrats-frontend/"
	npm install
	npm start
fi


