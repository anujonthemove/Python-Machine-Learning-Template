#!/bin/bash

#######################################################
# Script Name: project_setup.sh
# Description: This script sets up a Python project by 
#              creating a virtual environment, 
#              installing dependencies, and performing 
#              other project-specific actions.
# Author: Anuj Khandelwal
# Date: 30-05-2023
# Last Modified: 10-06-2023
# Contact: anujonthemove@gmail.com
#######################################################

# Helper functions

# Function to create .env file from .env-template file
create_env_file() {
    if [ -f ".env-template" ] && [ ! -f ".env" ]; then
        echo
        echo "🚀 Creating a .env file from .env-template file"
        echo 
        cp .env-template .env || { echo "❌ Failed to create .env file from .env-template"; return 1; }
    else
        echo
        echo "👉 .env file already present. Skipping this action"
        echo
    fi
}

# Function to create a virtual environment named .venv
create_virtual_environment() {
    if [ ! -d ".venv" ]; then
        echo
        echo "🚀 Creating a virtual environment named .venv"
        echo
        python3 -m venv .venv || { echo "❌ Failed to create virtual environment .venv"; return 1; }
    else
        echo
        echo "👉 Virtual environment .venv already present. Skipping this action"
        echo
    fi
}

# Function to activate the newly created virtual environment
activate_virtual_environment() {
    echo
    echo "🚀 Activating virtual environment .venv"
    echo
    source .venv/bin/activate || { echo "❌ Failed to activate virtual environment .venv"; return 1; }
}

# Function to unset proxy settings
unset_proxy() {
    echo
    echo "⛔ Unsetting Proxy"
    echo
    if [[ -n "$HTTPS_PROXY" ]] || [[ -n "$HTTP_PROXY" ]] ; then
        echo "The environment variable HTTPS_PROXY is set for using proxy, unsetting.."
        unset HTTPS_PROXY
        unset HTTP_PROXY
    fi
    export PIPENV_DONT_LOAD_ENV=1
}

# Function to upgrade .venv python-pip
upgrade_pip() {
    if [ "$use_proxy" = true ]; then
        echo
        echo "⛔ You have chosen to install packages behind proxy ⛔"
        echo

        echo
        echo "🚀 Upgrading .venv python-pip"
        echo
        export $(grep -v '^#' .env | xargs)
        python -m pip install --no-cache-dir --upgrade pip --proxy "$HTTP_PROXY" || { echo "❌ Failed to upgrade .venv python-pip"; return 1; }

        echo
        echo "🚀 Installing pipenv"
        echo
        pip install --no-cache-dir --upgrade pipenv --proxy "$HTTP_PROXY" || { echo "❌ Failed to install pipenv"; return 1; }
    else
        unset_proxy
        echo
        echo "🟢 You are now working without proxy 🟢"
        echo
        
        echo
        echo "🚀 Upgrading .venv python-pip"
        echo
        python -m pip install --no-cache-dir --upgrade pip || { echo "❌ Failed to upgrade .venv python-pip"; return 1; }

        echo
        echo "🚀 Installing pipenv"
        echo
        pip install --no-cache-dir --upgrade pipenv || { echo "❌ Failed to install pipenv"; return 1; }
    fi
}

# Function to install base packages using pipenv
install_packages() {

    if [ "$use_proxy" = true ]; then
        echo
        echo "✅ 🔉 Installing base packages (using proxy)"
        echo
        pipenv install || { echo "❌ Failed to install base packages (using proxy)"; return 1; }
    else
        echo
        echo "✅ 🔉 Installing base packages (without using proxy)"
        echo
        PIPENV_DONT_LOAD_ENV=1 pipenv install || { echo "❌ Failed to install base packages"; return 1; }
    fi
}

# Function to install dev packages using pipenv
install_dev_packages() {
    
    if [ "$use_proxy" = true ]; then
        echo
        echo "✅ 🔊 Installing development packages (using proxy)"
        echo
        pipenv install --dev || { echo "❌ Failed to install development packages (using proxy)"; return 1; }
    else
        echo
        echo "✅ 🔊 Installing development packages"
        echo
        PIPENV_DONT_LOAD_ENV=1 pipenv install --dev || { echo "❌ Failed to install development packages"; return 1; }
    fi

}

install_precommit() {
    echo
    echo "✨ Installing pre-commit"
    echo
    pre-commit install || { echo "❌ Failed to install pre-commit"; return 1; }
    echo
}


clear_pipenv_cache() {
        echo
        echo "🧽 Attempting to clean pipenv cache"
        echo
        pipenv --clear || { echo "❌ Failed to clear cache"; return 1; }
        echo
        echo "🧹 Pip cache cleared"

}

# Function to clear README.md file
clear_readme_file() {
    if [ "$clear_readme" = true ]; then
        echo
        echo "💣 You are about to clear the README.md file for this project"
        echo "📛 This should only be run when you are setting up the project for the first time"
        echo "❌ This action cannot be reversed."
        echo -ne "🚦 Do you wish to proceed? [y/N]: "
        echo
        read -r choice
        case "$choice" in
            [Yy])
                echo "# $(basename "$(pwd)")" > README.md || { echo "❌ Failed to clear README.md file"; return 1; }
                echo
                echo "🚧 README.md has been cleared"
                echo
                ;;
            [Nn])
                echo "✅ Skipping README.md modification"
                ;;
            *)
                echo "❌ Wrong input! Please try again."
                ;;
        esac
    fi
}

# Function to clean the repository
clean_repo() {
    echo
    echo "🗑️ Cleaning the repository"
    echo

    # Remove .assets directory if it exists
    if [ -d ".assets" ]; then
        echo "📁 Removing .assets directory"
        rm -r .assets || { echo "❌ Failed to remove .assets directory"; return 1; }
    else
        echo "❌ .assets directory not found. Skipping removal"
    fi

    # Remove CONTRIBUTING.md file if it exists
    if [ -f "CONTRIBUTING.md" ]; then
        echo "📄 Removing CONTRIBUTING.md file"
        rm CONTRIBUTING.md || { echo "❌ Failed to remove CONTRIBUTING.md file"; return 1; }
    else
        echo "❌ CONTRIBUTING.md file not found. Skipping removal"
    fi

    # Remove CONTRIBUTING.md file if it exists
    if [ -f "FUNDING.yml" ]; then
        echo "📄 Removing FUNDING.yml file"
        rm FUNDING.yml || { echo "❌ Failed to remove FUNDING.yml file"; return 1; }
    else
        echo "❌ FUNDING.yml file not found. Skipping removal"
    fi



}

# Function to display help in red color
display_help() {
    echo -e "\e[1m\e[31mUsage: source your_script.sh [OPTIONS]\e[0m"
    echo -e "\e[1m\e[31mOptions:\e[0m"
    echo -e "  \e[1m\e[31m--install       ⏳ Install base packages\e[0m"
    echo -e "  \e[1m\e[31m--install-dev   ⌛ Install development packages along with base packages\e[0m"
    echo -e "  \e[1m\e[31m--use-proxy     🔐 Enable proxy for python package installation\e[0m"
    echo -e "  \e[1m\e[31m--unset-proxy   🔓 Disable proxy for python package installation\e[0m"
    echo -e "  \e[1m\e[31m--clear-readme  📜 Clear README.md file\e[0m"
    echo -e "  \e[1m\e[31m--remove-cache  💾 Remove pip and pipenv cache\e[0m"
    echo -e "  \e[1m\e[31m--help          🆘 Display help message\e[0m"
}


# Check command line arguments
use_proxy=false
install_dev=false
clear_readme=false
should_exit=false
install=false
remove_cache=false
no_proxy=false

while [ $# -gt 0 ]; do
    case "$1" in
        --unset-proxy)
            no_proxy=true
            ;;
        --remove-cache)
            remove_cache=true
            ;;
        --install)
            install=true
            ;;
        --use-proxy)
            use_proxy=true
            ;;
        --install-dev)
            install_dev=true
            ;;
        --clear-readme)
            clear_readme=true
            ;;
        --help)
            display_help
            should_exit=true
            ;;
        *)
            echo "Error: Unrecognized argument '$1'"
            display_help >&2
            should_exit=true
            ;;
    esac
    
    if [ "$should_exit" = true ]; then
        break
    fi
    
    shift
done

# Check if the script should exit
if [ "$should_exit" = true ]; then
    return 0
fi

# Main function
main() {
    if [ "$clear_readme" = true ]; then
        clear_readme_file || return 1

    elif [ "$remove_cache" = true ]; then
        clear_pipenv_cache || return 1
        
    elif [ "$no_proxy" = true ]; then
        unset_proxy || return 1
        
    elif [ "$install" = true ]; then
        echo 
        echo "---------------------------------------------"
        echo "🐍 Setting up Python Virtual Environment 🌐"
        echo "----------------------------------------------"
        echo 

        # Call the functions
        clean_repo || return 1
        create_env_file || return 1
        create_virtual_environment || return 1
        activate_virtual_environment || return 1
        upgrade_pip || return 1
        install_packages || return 1
        if [ "$install_dev" = true ]; then
            install_dev_packages || return 1
            install_precommit || return 1
        else
            echo 
            echo "❌ Not installing development packages"
            echo
        fi
        
        clear_pipenv_cache || return 1
    else
        display_help
    fi
}

main

# Check if the virtual environment is activated
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo 
    echo -e "✅ Virtual environment activated: \e[1m\e[32m$VIRTUAL_ENV\e[0m"
    echo 
else
    echo
    echo -e "❌ \e[1m\e[31mFailed to activate the virtual environment.\e[0m"
    echo 
fi