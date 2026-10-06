CREATE DATABASE Finova_Banking;

-- Enable UUID extension for PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Define Custom Enum Types (PostgreSQL requires pre-defined types for ENUMs)
CREATE TYPE user_status_enum AS ENUM ('active', 'inactive', 'suspended');
CREATE TYPE account_type_enum AS ENUM ('Current', 'Savings', 'Money Market', 'Fixed Deposit', 'Specialty Account', 'Joint Account');
CREATE TYPE account_status_enum AS ENUM ('active', 'closed', 'frozen');
CREATE TYPE transaction_type_enum AS ENUM ('Deposit', 'Withdrawal', 'Transfer');
CREATE TYPE transaction_status_enum AS ENUM ('Pending', 'Successful', 'Failed');
CREATE TYPE card_status_enum AS ENUM ('active', 'inactive', 'frozen');
CREATE TYPE loan_type_enum AS ENUM ('Personal', 'Business', 'Education', 'Vehicle', 'Home', 'Other');
CREATE TYPE loan_status_enum AS ENUM ('active', 'inactive', 'frozen');
CREATE TYPE beneficiary_status_enum AS ENUM ('active', 'inactive', 'frozen');

CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    UserName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Mobile VARCHAR(20) UNIQUE NOT NULL,
    Password_hash VARCHAR(255) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    User_Status user_status_enum DEFAULT 'active',
    First_Name VARCHAR(255),
    Last_Name VARCHAR(255)
);

CREATE TABLE Account (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id) ON DELETE CASCADE,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    Balance DECIMAL(15,2) DEFAULT 0.00,
    account_type account_type_enum NOT NULL,
    Account_status account_status_enum DEFAULT 'active',
    currency VARCHAR(3) DEFAULT 'PKR',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Transactions (
    id SERIAL PRIMARY KEY,
    Transaction_type transaction_type_enum NOT NULL,
    sender_account_id INT REFERENCES Account(id),
    reciever_Account_id INT REFERENCES Account(id),
    Transaction_status transaction_status_enum DEFAULT 'Pending',
    Amount DECIMAL(15,2) NOT NULL,
    Currency VARCHAR (3) DEFAULT 'PKR',
    Transaction_Time Timestamp DEFAULT CURRENT_TIMESTAMP,
    Transaction_Description VARCHAR (255),
    Reference_Number UUID UNIQUE,
);

CREATE TABLE Cards (
    id SERIAL PRIMARY KEY,
    account_id INT REFERENCES Account(id),
    card_number CHAR (16) UNIQUE NOT NULL,
    Card_Expiry_Date DATE,
    daily_limit INT,
    card_status card_status_enum DEFAULT 'active',
    card_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Loans (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL REFERENCES Account(id),
    Loan_amount Decimal (12,2) NOT NULL,
    Loan_currency VARCHAR (3) DEFAULT 'PKR',
    interest_rate Decimal (5,2),
    remaining_balance Decimal,
    monthly_payment Decimal,
    Loan_Start_date Date,
    Loan_End_date Date,
    loan_type loan_type_enum,
    Loan_status loan_status_enum DEFAULT 'active',
    Loan_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Loan_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Loan_description VARCHAR(255),
    Loan_reference_number UUID,
);

CREATE TABLE Beneficiaries (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id) ON DELETE CASCADE,
    Beneficiary_id INT REFERENCES Users(id) ON DELETE CASCADE, -- Assuming beneficiary is also a system user
    Beneficiary_Account_Number VARCHAR(20) NOT NULL,            -- Changed to VARCHAR to match Account
    Beneficiary_Status beneficiary_status_enum DEFAULT 'active'
);

CREATE TABLE Audit (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id),
    Action VARCHAR(255) NOT NULL,
    Action_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Action_Description VARCHAR(255)
);