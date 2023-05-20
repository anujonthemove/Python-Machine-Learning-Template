
# 🐍 Python Machine Learning Template 🔥

The Python Machine Learning Template is designed to provide a comprehensive structure for Machine Learning projects in Python. Whether you're working on Computer Vision, Natural Language Processing, Reinforcement Learning, or traditional Machine Learning/Data Science, this template offers a simple and intuitive way to organize and manage your project.


To get started, simply click on the "Use this template" button and create your project based on this template. The following sections provide an overview of the directory structure and instructions for setting up your project workspace.



## 🏷️ Badges

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)




## 🗂️ Directory Structure

```

.
├── config/                  <- 📂 Configuration files [.ini, .json, .yaml]
├── data/                    <- 📂 Images, numpy data objects, text files
├── docs/                    <- 📂 Store .md files. Used by Mkdocs for Project Documentation
├── helpers/                 <- 📂 Utility/helper files/modules for the project
├── html/                    <- 📂 Store .html files and accompanying assets. Used by pdoc3 for API Documentation
├── logs/                    <- 📂 Log files generated by the project during execution
├── models/                  <- 📂 Model files [.h5, .pkl, .pt] like pre-trained weight files, snapshots, checkpoints
├── notebooks/               <- 📂 Jupyter Notebooks
├── references/              <- 📂 Data dictionaries, manuals, and all other explanatory materials
├── scripts/                 <- 📂 Utility scripts for various project-related tasks
├── src/                     <- 📂 Source code (.py files)
├── tests/                   <- 📂 Unit tests for the project
├── workspaces/               <- 📂 Multi-user workspace that can be used in the case of a single machine
├── .env-template            <- 🔧 Template for the .env file
├── .gitattributes           <- 🔧 Standard .gitattributes file
├── .gitignore               <- 📛 Standard .gitignore file
├── .pre-commit-config.yaml  <- 🔧 Config file for Git Hooks
├── LICENSE                  <- 🪧 License file [choose your appropriate license from GitHub]
├── mkdocs.yml               <- 🗞️ Base config file required for Mkdocs
├── Pipfile			         <- 🗃️ Most commonly used ML python packages
├── project_setup.bat        <- 📃 Virtual environment setup script for Windows OS
├── project_setup.sh         <- 📃 Virtual environment setup script for Linux/MacOS
├── README.md                <- 📝 Project readme
├── setup.py                 <- 📦️ For installing & packaging the project
└── tox.ini                  <- 🔧 General-purpose package configuration manager

```

## 🛠️ Setup

### On Linux/MacOS

To set up your project workspace on Linux or MacOS, run the following command in the terminal:

#### 📝 Note:

If you have installed Python virtual environment and virtual environment wrapper and have set up a centralized location for virtual environments, you may have added the following to your .bashrc file:

	# virtualenv and virtualenvwrapper
	export WORKON_HOME=$HOME/.virtualenvs
	export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
	source /usr/local/bin/virtualenvwrapper.sh

	

To avoid any conflicts, it is recommended to always run the project_setup.sh script to create a virtual environment for your project:

```

bash project_setup.sh

```

### On Windows OS
To set up your project workspace on Windows, run the following command in the Command Prompt:

```

project_setup.bat

```

#### 📝 Note:

For security reasons, organizations may prevent running .bat scripts. Therefore, avoid using PowerShell to execute the script.

## ❓Q&A

**1. 🤔 Why should I use this Template when there are already other available Templates?**

* ✅ Easy setup on all Windows, MacOS, and Linux systems. Refer to the setup section for detailed instructions.

* ✅ Simple, intuitive, yet comprehensive directory structure for organizing your machine learning project.

* ✅ Minimal dependencies required. You only need to have native Python installed on your machine.

* ✅ Uses Pipenv as the Python package manager, which can work behind a proxy without requiring any special configurations. Just define your proxy URL and credentials in the `.env` file.


**2. 🤔 What is the use of `workspace` folder?**

*	The `workspaces` folder is intended for scenarios where multiple people are working on the same project on the same machine. Inside the `workspaces` folder, you can create subfolders named after each developer, allowing them to clone the project and work on different branches. These subdirectories are not tracked by Git, enabling multiple people to collaborate on the same project without conflicts. To incorporate changes, developers can merge their branches with a common branch located at the root level.

**3. 🤔 What is the use of `.gitattributes`?**

*	The `.gitattributes` file is a standard Git configuration file. It allows you to specify attributes and behaviors for certain files in your repository. For example, you can define the line-ending style, binary or text attributes, and more.

**4. 🤔 Is it inspired from cookie-cutter project template?**

*	In short, no. While there may be similarities in naming conventions, the Python Machine Learning Template was created based on the specific needs of machine learning projects, such as reinforcement learning, computer vision, and natural language processing. However, we do appreciate the Jupyter Notebook naming convention used in the cookie-cutter project template and we recommend that users should follow it.

	*	Here it is:

		*Naming convention is a number (for ordering), the creator's initials, and a short `-` delimited description, e.g. `1.0-jqp-initial-data-exploration`.* i.e., it follows a format of `<number>-<initials>-<short-description>`, e.g., `1.0-jqp-initial-data-exploration.ipynb`


## 👥 Authors

- [@Anuj Khandelwal](https://www.github.com/anujonthemove)

