# DBT-Oracle

A dbt (data build tool) project for Oracle Database transformations and analytics.

## Project Overview

This project uses dbt to manage data transformations in an Oracle database environment. It includes models for deals analysis, location-based analytics, and data quality management.

## Project Structure

```
DBT-Oracle/
├── dbt_oracle/              # Main dbt project directory
│   ├── models/              # SQL models
│   │   └── example/         # Example models and analytics
│   ├── tests/               # Data tests
│   ├── macros/              # Reusable SQL macros
│   └── dbt_project.yml      # Project configuration
├── .gitignore               # Git ignore rules
└── README.md                # This file
```

## Prerequisites

- Python 3.8+
- Oracle Database access
- dbt-oracle adapter

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Srinivs-p/DBT-Oracle.git
cd DBT-Oracle
```

2. Create and activate a virtual environment:
```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install dbt-oracle
```

## Configuration

1. Create a `.env` file in the project root (this file is gitignored):
```env
DEALS_USER=your_username
DEALS_PASSWORD=your_password
DEALS_DSN=(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = your_host)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = your_service)))
```

2. Configure your dbt profile in `~/.dbt/profiles.yml`:
```yaml
dbt_oracle:
  outputs:
    dev:
      type: oracle
      host: your_host
      port: 1521
      user: '{{ env_var("DEALS_USER") }}'
      password: '{{ env_var("DEALS_PASSWORD") }}'
      service: your_service
      database: your_database
      schema: '{{ env_var("DEALS_USER") }}'
      threads: 4
  target: dev
```

## Running dbt

### Using PowerShell (Windows)

Set environment variables and run dbt:
```powershell
$env:DEALS_USER="your_username"
$env:DEALS_PASSWORD="your_password"
$env:DEALS_DSN="your_dsn"

cd dbt_oracle
dbt run
```

### Common dbt Commands

```bash
# Navigate to dbt project
cd dbt_oracle

# Test database connection
dbt debug

# Run all models
dbt run

# Run specific model
dbt run --select model_name

# Run tests
dbt test

# Generate documentation
dbt docs generate

# Serve documentation locally
dbt docs serve
```

## Documentation

### Generate Documentation

To generate and view dbt documentation:

1. Generate documentation:
```bash
cd dbt_oracle
dbt docs generate
```

2. Serve documentation locally (opens in browser):
```bash
dbt docs serve
```

The documentation will be available at `http://localhost:8080` and includes:
- Model lineage graphs
- Column-level descriptions
- Data quality tests
- Source freshness checks
- Project overview

### Adding Model Documentation

Create a `schema.yml` file in your models directory:

```yaml
version: 2

models:
  - name: deals_vw
    description: "Aggregated view of deals by location and organization"
    columns:
      - name: deal_id
        description: "Unique identifier for the deal"
        tests:
          - not_null
          - unique
```

## Models

- **deals_vw**: Aggregated deals data with latest records per deal
- **DealsByLocations**: Location-based deals analysis
- **my_first_dbt_model**: Example model demonstrating basic dbt functionality
- **my_second_dbt_model**: Example model showing model references

## Security

- Never commit `.env` files or credentials to version control
- Use environment variables for sensitive information
- The `.gitignore` file is configured to exclude sensitive files

## Contributing

1. Create a feature branch
2. Make your changes
3. Test your models
4. Submit a pull request

## License

[Add your license here]

## Contact

[Add your contact information here]
