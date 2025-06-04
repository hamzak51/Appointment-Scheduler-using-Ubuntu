#!/bin/bash
# RSA Key Management Script

KEY_PATH="$HOME/.ssh/id_rsa"
PUB_KEY="$HOME/.ssh/id_rsa.pub"

# Function: Generate RSA key
generate_key() {
  if [ -f "$KEY_PATH" ]; then
    echo "SA key already exists at $KEY_PATH"
  else
    ssh-keygen -t rsa -b 2048 -f "$KEY_PATH" -N ""
    echo " RSA key pair generated."
  fi
}

# Function: Display public key
show_public_key() {
  if [ -f "$PUB_KEY" ]; then
    echo "Public Key:"
    cat "$PUB_KEY"
  else
    echo " Public key not found!"
  fi
}

# Function: Copy public key to remote server
copy_to_remote() {
  if [ ! -f "$PUB_KEY" ]; then
    echo " Public key not found. Generate it first."
    return
  fi
  read -p "Enter remote username: " username
  read -p "Enter server IP: " server_ip
  echo "Copying key to $username@$server_ip..."
  ssh-copy-id "$username@$server_ip"
  if [ $? -eq 0 ]; then
    echo " Public key copied successfully!"
  else
    echo " Failed to copy key. Check connection or credentials."
  fi
}

# Function: Delete RSA key
delete_key() {
  if [ -f "$KEY_PATH" ]; then
    read -p "re you sure you want to delete your RSA keys? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
      rm -f "$KEY_PATH" "$PUB_KEY"
      echo "RSA keys deleted."
    else
      echo " Operation cancelled."
    fi
  else
    echo " No RSA key files found to delete."
  fi
}

# Function: Menu
menu() {
  while true; do
    echo -e "\n=== RSA Key Manager ==="
    echo "1. Generate RSA Key"
    echo "2. Display Public Key"
    echo "3. Copy Public Key to Remote Server"
    echo "4. Delete RSA Keys"
    echo "5. Exit"
    read -p "Choose an option [1-5]: " choice

    case $choice in
      1) generate_key ;;
      2) show_public_key ;;
      3) copy_to_remote ;;
      4) delete_key ;;
      5) echo "Exiting..."; break ;;
      *) echo " Invalid option." ;;
    esac
  done
}

menu
