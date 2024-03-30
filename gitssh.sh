# Check for existing SSH keys
echo "Checking for existing SSH keys..."
if ls ~/.ssh/id_rsa ~/.ssh/id_ed25519 1> /dev/null 2>&1; then
    echo "SSH keys already exist. Moving to ensure ssh-agent is running."
else
    # Confirm with the user before generating a new SSH key
    read -p "No SSH keys found. Generate a new SSH key? (y/n) " -n 1 -r
    echo    # Move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Generate a new SSH key, replace your_email@example.com with your email
        echo "Generating a new SSH key..."
        ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    else
        echo "SSH key generation aborted."
        exit 1
    fi
fi

# Start the ssh-agent in the background
echo "Ensuring ssh-agent is running..."
eval "$(ssh-agent -s)"

# Add your SSH private key to the ssh-agent
echo "Adding SSH key to ssh-agent..."
ssh-add ~/.ssh/id_rsa || ssh-add ~/.ssh/id_ed25519

echo "SSH key has been added to ssh-agent."

# Instructions for adding SSH key to GitHub
echo "To add your SSH key to GitHub, follow these steps:"
echo "1. Copy your SSH key to the clipboard:"
echo "   For RSA: cat ~/.ssh/id_rsa.pub | pbcopy"
echo "   For ED25519: cat ~/.ssh/id_ed25519.pub | pbcopy"
echo "   (On Linux, use xclip or manually copy the output of the cat command)"
echo "2. Go to GitHub -> Settings -> SSH and GPG keys -> New SSH key."
echo "3. Paste your SSH key, give it a meaningful title, and click Add SSH key."
echo "4. Test your SSH connection: ssh -T git@github.com"

echo "Script execution completed."

# Make the script executable by running chmod +x setup_github_ssh.sh in your terminal.
# Execute the script by running ./setup_github_ssh.sh from the terminal.
