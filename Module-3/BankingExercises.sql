
CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    DOB DATE,
    Balance NUMBER,
    IsVIP NUMBER(1),
    LastModified DATE
);

CREATE TABLE Accounts (
    AccountID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    AccountType VARCHAR2(20),
    Balance NUMBER,
    LastModified DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID NUMBER PRIMARY KEY,
    AccountID NUMBER,
    TransactionDate DATE,
    Amount NUMBER,
    TransactionType VARCHAR2(10),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Loans (
    LoanID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    LoanAmount NUMBER,
    InterestRate NUMBER,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Position VARCHAR2(50),
    Salary NUMBER,
    Department VARCHAR2(50),
    HireDate DATE
);

CREATE TABLE AuditLog (
    AuditID NUMBER PRIMARY KEY,
    TransactionID NUMBER,
    AccountID NUMBER,
    AuditAction VARCHAR2(20),
    AuditDate DATE,
    Amount NUMBER,
    TransactionType VARCHAR2(10)
);

-- Sample data insertion
INSERT INTO Customers (CustomerID, Name, DOB, Balance, IsVIP, LastModified)
VALUES (1, 'John Doe', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 1000, 0, SYSDATE);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, IsVIP, LastModified)
VALUES (2, 'Jane Smith', TO_DATE('1990-07-20', 'YYYY-MM-DD'), 1500, 0, SYSDATE);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, IsVIP, LastModified)
VALUES (3, 'Elder One', TO_DATE('1955-02-10', 'YYYY-MM-DD'), 20000, 0, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (1, 1, 'Savings', 1000, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (2, 2, 'Checking', 1500, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (3, 3, 'Savings', 25000, SYSDATE);

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (1, 1, SYSDATE, 200, 'Deposit');

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (2, 2, SYSDATE, 300, 'Withdrawal');

INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
VALUES (1, 1, 5000, 5, SYSDATE, ADD_MONTHS(SYSDATE, 60));

INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
VALUES (2, 3, 15000, 6, SYSDATE, ADD_MONTHS(SYSDATE, 25));

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (1, 'Alice Johnson', 'Manager', 70000, 'HR', TO_DATE('2015-06-15', 'YYYY-MM-DD'));

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (2, 'Bob Brown', 'Developer', 60000, 'IT', TO_DATE('2017-03-20', 'YYYY-MM-DD'));

-- Exercise 1: Control Structures

-- Scenario 1: Apply 1% discount to loan interest for customers above 60
BEGIN
  FOR rec IN (
    SELECT l.LoanID
    FROM Loans l
    JOIN Customers c ON l.CustomerID = c.CustomerID
    WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, c.DOB) / 12) > 60
  )
  LOOP
    UPDATE Loans
    SET InterestRate = InterestRate - 1
    WHERE LoanID = rec.LoanID;
  END LOOP;
  COMMIT;
END;
/

-- Scenario 2: Set IsVIP for customers with balance over 10,000
BEGIN
  FOR rec IN (SELECT CustomerID FROM Customers WHERE Balance > 10000)
  LOOP
    UPDATE Customers
    SET IsVIP = 1
    WHERE CustomerID = rec.CustomerID;
  END LOOP;
  COMMIT;
END;
/

-- Scenario 3: Print reminders for loans due in the next 30 days
BEGIN
  FOR rec IN (
    SELECT c.CustomerID, c.Name, l.LoanID, l.EndDate
    FROM Loans l
    JOIN Customers c ON l.CustomerID = c.CustomerID
    WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Reminder: Customer ' || rec.Name ||
      ' (ID=' || rec.CustomerID || ')' ||
      ' has loan ' || rec.LoanID ||
      ' due on ' || TO_CHAR(rec.EndDate, 'YYYY-MM-DD')
    );
  END LOOP;
END;
/

-- Exercise 2: Error Handling

CREATE OR REPLACE PROCEDURE SafeTransferFunds(
  p_fromAccount IN NUMBER,
  p_toAccount   IN NUMBER,
  p_amount      IN NUMBER)
IS
  v_balance NUMBER;
BEGIN
  SELECT Balance INTO v_balance
  FROM Accounts
  WHERE AccountID = p_fromAccount
  FOR UPDATE;

  IF v_balance < p_amount THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds in source account.');
  END IF;

  UPDATE Accounts
  SET Balance = Balance - p_amount
  WHERE AccountID = p_fromAccount;

  UPDATE Accounts
  SET Balance = Balance + p_amount
  WHERE AccountID = p_toAccount;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: Source account not found.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Transfer failed: ' || SQLERRM);
END SafeTransferFunds;
/

CREATE OR REPLACE PROCEDURE UpdateSalary(
  p_employeeID IN NUMBER,
  p_percentage IN NUMBER)
IS
  v_salary NUMBER;
BEGIN
  SELECT Salary INTO v_salary
  FROM Employees
  WHERE EmployeeID = p_employeeID;

  UPDATE Employees
  SET Salary = Salary + Salary * p_percentage / 100
  WHERE EmployeeID = p_employeeID;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: Employee ID ' || p_employeeID || ' does not exist.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('UpdateSalary failed: ' || SQLERRM);
END UpdateSalary;
/

CREATE OR REPLACE PROCEDURE AddNewCustomer(
  p_customerID IN NUMBER,
  p_name       IN VARCHAR2,
  p_dob        IN DATE,
  p_balance    IN NUMBER)
IS
BEGIN
  INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
  VALUES (p_customerID, p_name, p_dob, p_balance, SYSDATE);

  COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_customerID || ' already exists.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('AddNewCustomer failed: ' || SQLERRM);
END AddNewCustomer;
/

-- Exercise 3: Stored Procedures

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest
IS
BEGIN
  UPDATE Accounts
  SET Balance = Balance + Balance * 0.01
  WHERE AccountType = 'Savings';

  COMMIT;
END ProcessMonthlyInterest;
/

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
  p_department   IN VARCHAR2,
  p_bonusPercent IN NUMBER)
IS
BEGIN
  UPDATE Employees
  SET Salary = Salary + Salary * p_bonusPercent / 100
  WHERE Department = p_department;

  COMMIT;
END UpdateEmployeeBonus;
/

CREATE OR REPLACE PROCEDURE TransferFunds(
  p_sourceAccount IN NUMBER,
  p_destAccount   IN NUMBER,
  p_amount        IN NUMBER)
IS
  v_balance NUMBER;
BEGIN
  SELECT Balance INTO v_balance
  FROM Accounts
  WHERE AccountID = p_sourceAccount
  FOR UPDATE;

  IF v_balance < p_amount THEN
    RAISE_APPLICATION_ERROR(-20002, 'Insufficient balance for transfer.');
  END IF;

  UPDATE Accounts
  SET Balance = Balance - p_amount
  WHERE AccountID = p_sourceAccount;

  UPDATE Accounts
  SET Balance = Balance + p_amount
  WHERE AccountID = p_destAccount;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: Source account not found.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('TransferFunds failed: ' || SQLERRM);
END TransferFunds;
/

-- Exercise 4: Functions

CREATE OR REPLACE FUNCTION CalculateAge(
  p_dob IN DATE)
RETURN NUMBER
IS
  v_age NUMBER;
BEGIN
  v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);
  RETURN v_age;
END CalculateAge;
/

CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment(
  p_amount       IN NUMBER,
  p_interestRate IN NUMBER,
  p_years        IN NUMBER)
RETURN NUMBER
IS
  v_monthlyRate NUMBER := p_interestRate / 100 / 12;
  v_months      NUMBER := p_years * 12;
  v_payment     NUMBER;
BEGIN
  IF v_monthlyRate = 0 THEN
    v_payment := p_amount / v_months;
  ELSE
    v_payment := p_amount * v_monthlyRate /
                 (1 - POWER(1 + v_monthlyRate, -v_months));
  END IF;
  RETURN ROUND(v_payment, 2);
END CalculateMonthlyInstallment;
/

CREATE OR REPLACE FUNCTION HasSufficientBalance(
  p_accountID IN NUMBER,
  p_amount    IN NUMBER)
RETURN BOOLEAN
IS
  v_balance NUMBER;
BEGIN
  SELECT Balance INTO v_balance
  FROM Accounts
  WHERE AccountID = p_accountID;

  RETURN v_balance >= p_amount;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN FALSE;
END HasSufficientBalance;
/

-- Exercise 5: Triggers

CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
  :NEW.LastModified := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
  INSERT INTO AuditLog (
    AuditID,
    TransactionID,
    AccountID,
    AuditAction,
    AuditDate,
    Amount,
    TransactionType
  ) VALUES (
    AuditLog_seq.NEXTVAL,
    :NEW.TransactionID,
    :NEW.AccountID,
    'INSERT',
    SYSDATE,
    :NEW.Amount,
    :NEW.TransactionType
  );
END;
/

CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
  v_balance NUMBER;
BEGIN
  IF :NEW.TransactionType = 'Withdrawal' AND :NEW.Amount > 0 THEN
    SELECT Balance INTO v_balance
    FROM Accounts
    WHERE AccountID = :NEW.AccountID;

    IF v_balance < :NEW.Amount THEN
      RAISE_APPLICATION_ERROR(-20003, 'Withdrawal exceeds available balance.');
    END IF;
  ELSIF :NEW.TransactionType = 'Deposit' AND :NEW.Amount <= 0 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Deposit amount must be positive.');
  END IF;
END;
/

-- Exercise 6: Cursors

DECLARE
  CURSOR c_transactions IS
    SELECT c.CustomerID,
           c.Name,
           t.AccountID,
           t.TransactionDate,
           t.Amount,
           t.TransactionType
    FROM Customers c
    JOIN Accounts a ON c.CustomerID = a.CustomerID
    JOIN Transactions t ON a.AccountID = t.AccountID
    WHERE t.TransactionDate BETWEEN TRUNC(TRUNC(SYSDATE, 'MM')) AND LAST_DAY(SYSDATE);

  rec c_transactions%ROWTYPE;
BEGIN
  OPEN c_transactions;
  LOOP
    FETCH c_transactions INTO rec;
    EXIT WHEN c_transactions%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      'Statement for ' || rec.Name ||
      ' (Customer ' || rec.CustomerID || '), Account ' || rec.AccountID ||
      ', Date: ' || TO_CHAR(rec.TransactionDate, 'YYYY-MM-DD') ||
      ', Type: ' || rec.TransactionType ||
      ', Amount: ' || rec.Amount
    );
  END LOOP;
  CLOSE c_transactions;
END;
/

DECLARE
  CURSOR c_accounts IS
    SELECT AccountID, Balance
    FROM Accounts;

  v_fee CONSTANT NUMBER := 50;
  v_accountID Accounts.AccountID%TYPE;
  v_balance  Accounts.Balance%TYPE;
BEGIN
  OPEN c_accounts;
  LOOP
    FETCH c_accounts INTO v_accountID, v_balance;
    EXIT WHEN c_accounts%NOTFOUND;

    UPDATE Accounts
    SET Balance = Balance - v_fee
    WHERE AccountID = v_accountID;
  END LOOP;
  CLOSE c_accounts;

  COMMIT;
END;
/

DECLARE
  CURSOR c_loans IS
    SELECT LoanID, LoanAmount, InterestRate
    FROM Loans
    FOR UPDATE;

  v_newRate NUMBER;
BEGIN
  FOR rec IN c_loans LOOP
    IF rec.LoanAmount > 10000 THEN
      v_newRate := rec.InterestRate + 0.25;
    ELSE
      v_newRate := rec.InterestRate + 0.10;
    END IF;

    UPDATE Loans
    SET InterestRate = v_newRate
    WHERE LoanID = rec.LoanID;
  END LOOP;

  COMMIT;
END;
/

-- Exercise 7: Packages

CREATE OR REPLACE PACKAGE CustomerManagement AS
  PROCEDURE AddCustomer(
    p_customerID IN NUMBER,
    p_name       IN VARCHAR2,
    p_dob        IN DATE,
    p_balance    IN NUMBER);

  PROCEDURE UpdateCustomerDetails(
    p_customerID IN NUMBER,
    p_name       IN VARCHAR2,
    p_balance    IN NUMBER);

  FUNCTION GetCustomerBalance(
    p_customerID IN NUMBER)
    RETURN NUMBER;
END CustomerManagement;
/

CREATE OR REPLACE PACKAGE BODY CustomerManagement AS
  PROCEDURE AddCustomer(
    p_customerID IN NUMBER,
    p_name       IN VARCHAR2,
    p_dob        IN DATE,
    p_balance    IN NUMBER)
  IS
  BEGIN
    INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
    VALUES (p_customerID, p_name, p_dob, p_balance, SYSDATE);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20005, 'Customer already exists.');
  END AddCustomer;

  PROCEDURE UpdateCustomerDetails(
    p_customerID IN NUMBER,
    p_name       IN VARCHAR2,
    p_balance    IN NUMBER)
  IS
  BEGIN
    UPDATE Customers
    SET Name = p_name,
        Balance = p_balance,
        LastModified = SYSDATE
    WHERE CustomerID = p_customerID;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20006, 'Customer not found.');
    END IF;

    COMMIT;
  END UpdateCustomerDetails;

  FUNCTION GetCustomerBalance(
    p_customerID IN NUMBER)
    RETURN NUMBER
  IS
    v_balance NUMBER;
  BEGIN
    SELECT Balance
    INTO v_balance
    FROM Customers
    WHERE CustomerID = p_customerID;

    RETURN v_balance;
  END GetCustomerBalance;
END CustomerManagement;
/

CREATE OR REPLACE PACKAGE EmployeeManagement AS
  PROCEDURE HireEmployee(
    p_employeeID IN NUMBER,
    p_name       IN VARCHAR2,
    p_position   IN VARCHAR2,
    p_salary     IN NUMBER,
    p_department IN VARCHAR2,
    p_hireDate   IN DATE);

  PROCEDURE UpdateEmployeeDetails(
    p_employeeID IN NUMBER,
    p_position   IN VARCHAR2,
    p_salary     IN NUMBER,
    p_department IN VARCHAR2);

  FUNCTION CalculateAnnualSalary(
    p_employeeID IN NUMBER)
    RETURN NUMBER;
END EmployeeManagement;
/

CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS
  PROCEDURE HireEmployee(
    p_employeeID IN NUMBER,
    p_name       IN VARCHAR2,
    p_position   IN VARCHAR2,
    p_salary     IN NUMBER,
    p_department IN VARCHAR2,
    p_hireDate   IN DATE)
  IS
  BEGIN
    INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
    VALUES (p_employeeID, p_name, p_position, p_salary, p_department, p_hireDate);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20007, 'Employee already exists.');
  END HireEmployee;

  PROCEDURE UpdateEmployeeDetails(
    p_employeeID IN NUMBER,
    p_position   IN VARCHAR2,
    p_salary     IN NUMBER,
    p_department IN VARCHAR2)
  IS
  BEGIN
    UPDATE Employees
    SET Position = p_position,
        Salary = p_salary,
        Department = p_department
    WHERE EmployeeID = p_employeeID;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20008, 'Employee not found.');
    END IF;

    COMMIT;
  END UpdateEmployeeDetails;

  FUNCTION CalculateAnnualSalary(
    p_employeeID IN NUMBER)
    RETURN NUMBER
  IS
    v_salary NUMBER;
  BEGIN
    SELECT Salary INTO v_salary
    FROM Employees
    WHERE EmployeeID = p_employeeID;

    RETURN v_salary * 12;
  END CalculateAnnualSalary;
END EmployeeManagement;
/

CREATE OR REPLACE PACKAGE AccountOperations AS
  PROCEDURE OpenAccount(
    p_accountID  IN NUMBER,
    p_customerID IN NUMBER,
    p_type       IN VARCHAR2,
    p_balance    IN NUMBER);

  PROCEDURE CloseAccount(
    p_accountID IN NUMBER);

  FUNCTION GetTotalBalance(
    p_customerID IN NUMBER)
    RETURN NUMBER;
END AccountOperations;
/

CREATE OR REPLACE PACKAGE BODY AccountOperations AS
  PROCEDURE OpenAccount(
    p_accountID  IN NUMBER,
    p_customerID IN NUMBER,
    p_type       IN VARCHAR2,
    p_balance    IN NUMBER)
  IS
  BEGIN
    INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
    VALUES (p_accountID, p_customerID, p_type, p_balance, SYSDATE);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20009, 'Account already exists.');
  END OpenAccount;

  PROCEDURE CloseAccount(
    p_accountID IN NUMBER)
  IS
  BEGIN
    DELETE FROM Accounts
    WHERE AccountID = p_accountID;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20010, 'Account not found.');
    END IF;

    COMMIT;
  END CloseAccount;

  FUNCTION GetTotalBalance(
    p_customerID IN NUMBER)
    RETURN NUMBER
  IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(Balance), 0)
    INTO v_total
    FROM Accounts
    WHERE CustomerID = p_customerID;

    RETURN v_total;
  END GetTotalBalance;
END AccountOperations;
/
