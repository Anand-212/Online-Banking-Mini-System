# EasyBank – Online Banking Mini System

A web-based Online Banking application developed as an academic student project for the **Master of Computer Applications (MCA)** program at **Noida Institute of Engineering and Technology (NIET)**.

---

## Student Details

* **Developed by:** Anand Raj
* **Course:** Master of Computer Applications (MCA)
* **Subject:** Software Engineering (CMCA0303)
* **College:** Noida Institute of Engineering and Technology (NIET), Greater Noida
* **ERP ID:** 2501330140063

---

## About the Project

**EasyBank** is an online banking web application built using Java (Servlets & JSP) and Oracle Database. The project follows the MVC (Model-View-Controller) structure and simulates everyday banking operations like checking balances, depositing money, withdrawing cash, transferring funds to other accounts, and downloading account statements in PDF format.

### Key Features

* **User Registration & Login:** Create a new account and log in securely.
* **Customer Dashboard:** Check your account details, current balance, and recent transaction history.
* **Deposit & Withdrawal:** Simple forms to deposit or withdraw cash from your account.
* **Fund Transfer with MPIN:** Transfer money to other accounts using a 4-digit security MPIN (with automatic lockout after 3 incorrect attempts).
* **Account Statements & PDF Export:** View your transaction history and download official statements as a PDF.
* **Admin Portal:** Separate admin login to view all customer accounts, freeze or unfreeze accounts, and monitor transactions.
* **Financial Calculators:** Includes built-in tools for Loan EMI calculation, compound interest, and currency conversion.

---

## Screenshots

| 1. Customer Login : [Customer Login](docs/screenshots/01_customer_login.png) 

| 2. Customer Dashboard : [Customer Dashboard](docs/screenshots/02_customer_dashboard.png) 

| 3. Fund Transfer (with MPIN) : [Fund Transfer](docs/screenshots/03_fund_transfer.png) 

| 4. Transactions & PDF Download : [Transaction Statement](docs/screenshots/04_transaction_statement.png) 

---

## Technologies Used

* **Backend:** Java 17, Jakarta Servlets 6.0, JSP, JSTL
* **Database:** Oracle Database XE (21c / 19c / 11g) with JDBC
* **Frontend:** HTML5, CSS3, JavaScript
* **Security:** BCrypt (for password and MPIN hashing)
* **PDF Generation:** OpenPDF
* **JSON:** Google Gson
* **Server:** Apache Tomcat 10.1+
* **Build Tool:** Apache Maven
* **IDE:** Apache NetBeans (or Eclipse / IntelliJ)

---

## Project Structure

```text
OnlineBankingSystem/
├── docs/
│   └── screenshots/              # Application screenshots
│       ├── 01_customer_login.png
│       ├── 02_customer_dashboard.png
│       ├── 03_fund_transfer.png
│       └── 04_transaction_statement.png
├── src/
│   └── main/
│       ├── java/com/bank/
│       │   ├── controller/       # Servlets (Login, Transfer, Deposit, Admin, etc.)
│       │   ├── dao/              # Database queries (UserDAO, TransactionDAO, etc.)
│       │   ├── filter/           # Login check and encoding filters
│       │   ├── model/            # Java classes (User, Transaction, Admin, etc.)
│       │   └── util/             # Helper classes (DBConnection, MPIN, Password, etc.)
│       ├── resources/
│       │   ├── application.properties          # Database connection settings
│       │   └── application.properties.example  # Example settings file
│       └── webapp/               # JSP pages, CSS styling, and JavaScript
├── database.sql                  # Database tables, sequences, and sample data
├── cleanup.sql                   # Script to drop database tables if needed
├── pom.xml                       # Maven project dependencies
├── LICENSE                       # MIT License
└── README.md                     # Project documentation
```

---

## How to Set Up and Run

### 1. Prerequisites
Make sure you have these installed:
* **JDK 17** or higher
* **Oracle Database XE** running on `localhost:1521` (service name `xe`)
* **Apache Tomcat 10.1+**
* **Apache NetBeans** (or your preferred Java IDE)

---

### 2. Database Setup

1. Open your Oracle SQL client (SQL*Plus, SQL Developer, or DBeaver).
2. Run the `database.sql` script:
   ```sql
   @database.sql
   ```
   *This will create the necessary tables, sequences, and insert initial demo users.*

---

### 3. Check Database Password

Open `src/main/resources/application.properties` and verify your local Oracle credentials:

```properties
db.driver=oracle.jdbc.driver.OracleDriver
db.url=jdbc:oracle:thin:@localhost:1521:xe
db.username=system
db.password=anand
```
*(If your Oracle `system` user has a different password, update `db.password` to match your local database).*

---

### 4. Open and Run in NetBeans

1. Open **Apache NetBeans**.
2. Click **File -> Open Project...** and select the `OnlineBankingSystem` folder.
3. Right-click the project in NetBeans and click **Clean and Build** to download dependencies.
4. Ensure Tomcat 10.1+ is added in **Tools -> Servers**.
5. Right-click the project and select **Run**.
6. The application will launch in your browser at:
   ```
   http://localhost:8080/OnlineBankingSystem/
   ```

---

## Demo Accounts for Testing

You can log in and test the application using these pre-created accounts:

### Customer Account 1
* **Login URL:** `http://localhost:8080/OnlineBankingSystem/login`
* **Username:** `anandraj`
* **Password:** `User@1234`
* **MPIN:** `1234`
* **Account Number:** `100010001`
* **Initial Balance:** Rs. 15,000.00

### Customer Account 2
* **Login URL:** `http://localhost:8080/OnlineBankingSystem/login`
* **Username:** `binshukumari`
* **Password:** `User@1234`
* **MPIN:** `1234`
* **Account Number:** `100010002`
* **Initial Balance:** Rs. 28,500.50

### Admin Portal
* **Login URL:** `http://localhost:8080/OnlineBankingSystem/admin/login`
* **Username:** `admin`
* **Password:** `Admin@123`
* **Access:** View customer accounts, freeze/unfreeze accounts, and view transaction history.

---

## License

This project is licensed under the [MIT License](LICENSE).
