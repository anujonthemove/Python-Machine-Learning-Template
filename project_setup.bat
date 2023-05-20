@echo --------------------------------------------------------------------------------
@echo           Setting up Python Virtual Environment                        
@echo --------------------------------------------------------------------------------

@IF EXIST .env-template (
    IF NOT EXIST .env (
        COPY .env-template .env
    )
)

@IF NOT EXIST .venv (
    python -m venv .venv
)

CALL .venv\Scripts\activate

python -m pip install --upgrade pip
pip install --no-cache-dir pipenv

@IF "%1" == "--dev" (
    pipenv install --dev

    @REM uncomment to use detect-secrets pre-commit hook
    @REM @IF NOT EXIST .secrets.baseline (
    @REM     detect-secrets scan >.secrets.baseline
    @REM )
    @REM pre-commit install

) 

ELSE (
    pipenv install
)