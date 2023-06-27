@echo off

REM Project Setup Script
REM
REM Author: Anuj Khandelwal
REM Date: 30-05-2023
REM Last Modified: 12-06-2023
REM Contact: anujonthemove@gmail.com
REM
REM Description:
REM This script sets up a Python project by creating a virtual environment, 
REM installing dependencies, and performing other project-specific actions.
REM
REM Usage:
REM - Pass any of the following boolean arguments in any order:
REM   --install        : Required. Installs base packages
REM   --install-dev    : Works along with --install option. Installs development packages.
REM   --use-proxy      : Sets the 'use_proxy' flag to true.
REM   --clear-readme   : Sets the 'clear_readme' flag to true.
REM   --remove-cache   : Removes pip and pipenv cache files.
REM   --help           : Displays help information and exits.
REM
REM - The script executes different functions based on the arguments passed:
REM   - If '--clear-readme' is present, calls 'clear_readme_file'.
REM   - If '--install' is present, calls 'create_env_file', 'create_virtual_environment', 'activate_virtual_environment',
REM     'upgrade_pip', and optionally 'install_dev_packages' if '--install-dev' is also present.
REM   - Otherwise, displays help information.

REM Load environment variables from .env file
@REM if exist .env (
@REM     for /F "usebackq delims=" %%A in (".env") do set %%A
@REM )

REM Load environment variables from .env file
if exist .env (
    for /F "usebackq delims=" %%A in (".env") do set %%A
)



REM Initialize variables
set use_proxy=false
set install_dev=false
set clear_readme=false
set should_exit=false
set install=false
set remove_cache=false
set no_proxy=false

REM Process command line arguments
for %%x in (%*) do (
    IF "%%x"=="--use-proxy" (
        set use_proxy=true
    ) ELSE IF "%%x"=="--unset-proxy" (
        set no_proxy=true
    ) ELSE IF "%%x"=="--remove-cache" (
        set remove_cache=true
    ) ELSE IF "%%x"=="--install-dev" (
        set install_dev=true
    ) ELSE IF "%%x"=="--clear-readme" (
        set clear_readme=true
    ) ELSE IF "%%x"=="--install" (
        set install=true
    ) ELSE IF "%%x"=="--help" (
        call :display_help
        set should_exit=true
    ) ELSE (
        echo "Error: Unrecognized argument '%%x'"
        call :display_help
        set should_exit=true
    )
)

IF "%should_exit%"=="true" (
    goto :exit
)

REM Check if the script should exit
IF "%should_exit%"=="true" (
    exit /b 0
)

:main
IF "%clear_readme%"=="true" (
    call :clear_readme_file || exit /b 1
) ELSE IF "%no_proxy%" == "true" (
    call :unset_proxy || exit /b 1
) ELSE IF "%remove_cache%" == "true" (
    call :remove_cache || exit /b 1
) ELSE IF "%install%"=="true" (
    call :clean_repo || exit /b 1
    call :create_env_file || exit /b 1
    call :create_virtual_environment || exit /b 1
    call :activate_virtual_environment || exit /b 1
    call :upgrade_pip || exit /b 1
    call :install_base_packages || exit /b 1
    
    call :remove_cache || exit /b 1
    IF "%install_dev%"=="true" (
        call :install_dev_packages || exit /b 1
        call :install_precommit || exit /b 1
    )
) ELSE (
    call :display_help
)

:exit
exit /b

:display_help
echo "Displaying help..."
REM Help content here
echo script.bat [OPTIONS]
echo Options:
echo   --install           Install base packages
echo   --install-dev       Install development packages along with base packages. Pass it along with --install
echo   --use-proxy         Enable proxy for python package installation
echo   --unset-proxy       Disable proxy for python package installation
echo   --clear-readme      Clear README.md file
echo   --remove-cache      Remove pip and pipenv cache
echo   --help              Display help message

exit /b

:clear_readme_file
echo "Clearing readme file..."
REM Logic to clear the readme file here

echo  You are about to clear the README.md file for this project
echo  This should only be run when you are setting up the project for the first time
echo  This action cannot be reversed.

REM Prompt the user to confirm before executing the command
set /p "choice=Do you want to proceed? [y/N] "
if /i "%choice%"=="y" (
    for %%I in ("%~dp0.") do (
        echo # %%~nxI > README.md
    )
) else (
    echo  Skipping README.md modification
)

exit /b

:create_env_file
echo "Creating environment file..."
REM Logic to create the environment file here


if exist .env-template (
    if not exist .env (
        copy .env-template .env
    )
)

exit /b

:create_virtual_environment
echo "Creating virtual environment..."
REM Logic to create the virtual environment here

if not exist .venv (
    python -m venv .venv
)

exit /b

:activate_virtual_environment
echo "Activating virtual environment..."
REM Logic to activate the virtual environment here
call .venv\Scripts\activate
exit /b

:upgrade_pip
echo "Upgrading pip..."
REM Logic to upgrade pip here

if "%use_proxy%"=="true" (
    echo "USING PROXY"
    echo "HTTP_PROXY: %HTTP_PROXY%"
    python -m pip install --no-cache-dir --upgrade pip --proxy %HTTP_PROXY%
) else (
    echo "Not using proxy"
    set "HTTPS_PROXY="
    set "HTTP_PROXY="
    python -m pip install --upgrade pip
)

exit /b

:install_base_packages
echo "Installing base packages..."
REM Logic to install base packages here

if "%use_proxy%"=="true" (
    echo "Using proxy"
    echo "HTTP_PROXY: %HTTP_PROXY%"
    pipenv install 
) else (
    echo "Not using proxy"
    set PIPENV_DOTENV_LOCATION=.env
    set PIPENV_DONT_LOAD_ENV=1
    pipenv install 
    set PIPENV_DONT_LOAD_ENV=
)
exit /b


:install_dev_packages
echo "Installing dev packages..."
REM Logic to install dev packages here

if "%use_proxy%"=="true" (
    echo "Using proxy"
    echo "HTTP_PROXY: %HTTP_PROXY%"
    pipenv install --dev
) else (
    echo "Not using proxy"
    set PIPENV_DOTENV_LOCATION=.env
    set PIPENV_DONT_LOAD_ENV=1
    pipenv install --dev
    set PIPENV_DONT_LOAD_ENV=
)
exit /b

:clean_repo
echo "Cleaning repository..."

REM Check if the .assets directory exists before removing it
if exist ".assets" (
    rmdir /s /q ".assets"
)

REM Check if the CONTRIBUTING.md file exists before removing it
if exist "CONTRIBUTING.md" (
    del /f "CONTRIBUTING.md"
)

REM Check if the FUNDING.yml file exists before removing it
if exist "FUNDING.yml" (
    del /f "FUNDING.yml"
)

exit /b

:remove_cache

echo.
echo "Attempting to clean pipenv cache"
echo.
pipenv --clear || (
    echo "Failed to clear cache"
    exit /b 1
)
echo.
echo "Pip cache cleared"


exit /b


:install_precommit

echo.
echo "Installing pre-commit"
echo.
pre-commit install || (
    echo "Failed to install pre-commit"
    exit /b 1
)

exit /b 1


:unset_proxy

echo.
echo "Unsetting Proxy"
echo.

echo "Environment variables before unsetting: "
echo "HTTP_PROXY: %HTTP_PROXY%"
echo "HTTPS_PROXY: %HTTPS_PROXY%"

if defined HTTPS_PROXY (
    echo "The environment variable HTTPS_PROXY is set for using proxy, unsetting.."
    set "HTTPS_PROXY="
)
if defined HTTP_PROXY (
    echo "The environment variable HTTP_PROXY is set for using proxy, unsetting.."
    set "HTTP_PROXY="
)

@REM set "PIPENV_DONT_LOAD_ENV=1"
@REM set "HTTPS_PROXY="
@REM set "HTTP_PROXY="
set "PIPENV_DOTENV_LOCATION=.env"
set "PIPENV_DONT_LOAD_ENV=1"

echo "Environment variables after unsetting: "
echo "HTTP_PROXY: %HTTP_PROXY%"
echo "HTTPS_PROXY: %HTTPS_PROXY%"

exit /b
