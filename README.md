#### Testing the script
To test the script, first of all make sure you have a private key that you are to use to SSH into the machine using your AWS account.
You can head to AWS and generate a credential and download the .pem file to continue.

### Instructions 
1. Clone the repo to your machine.
2. `cd` to the folder. NB. Make sure you already have a private key.
3. Copy the private key you copied to the `.ssh` folder of your user directory i.e `~/.ssh`
4. After the above you're good to go. Proceed to the next step.
5. Run `./auto.sh <name of the key file omitting .pem example key if your key is key.pem>`
6. Sit back and relax.
7. After the process is complete, head over to your instances page on AWS dashboard to confirm you have an instance with an IP you can use to access the application in the browser.
