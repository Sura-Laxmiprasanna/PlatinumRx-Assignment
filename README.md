# 📊 PlatinumRx Data Analyst Assignment

## 📌 Overview
This project demonstrates core data analysis skills across SQL, Excel, and Python. It includes database design, data querying, spreadsheet analysis, and basic programming logic.

---

## 🛠️ Tools & Technologies
- MySQL Workbench (SQL)
- Microsoft Excel (Data Analysis)
- Python (VS Code / Jupyter)

---

## 📁 Project Structure

Data_Analyst_Assignment/

│
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql
│   ├── 02_Hotel_Queries.sql
│   ├── 03_Clinic_Schema_Setup.sql
│   └── 04_Clinic_Queries.sql
│
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx
│
├── Python/
│   ├── 01_Time_Converter.py
│   └── 02_Remove_Duplicates.py
│
└── README.md

---

## 🗄️ SQL Section

### Hotel Management System
- Designed tables: users, bookings, items, booking_commercials
- Performed:
  - Last booked room identification
  - Monthly billing calculations
  - High-value bill filtering
  - Ranking-based queries (most/least ordered items)
  - Second highest bill using window functions

### Clinic Management System
- Designed tables: clinics, customer, clinic_sales, expenses
- Performed:
  - Revenue analysis by sales channel
  - Top customers by revenue
  - Monthly profit/loss calculation
  - Most and least profitable clinics using ranking functions

---

## 📊 Excel (Spreadsheet Analysis)

- Used **INDEX-MATCH (lookup function)** to populate `ticket_created_at` using `cms_id`
- Created helper columns:
  - Same Day → using `INT()` function
  - Same Hour → using `HOUR()` function
- Calculated outlet-wise counts using `COUNTIFS`

---

## 🐍 Python Section

### 1. Time Converter
- Converts minutes into human-readable format (hours & minutes)

### 2. Remove Duplicates
- Removes duplicate characters from a string using loop logic

---

## 💡 Key Concepts Used
- SQL Joins, Aggregations, Window Functions
- Excel Lookup Functions, Logical Functions, COUNTIFS
- Python Loops and String Manipulation

---

## ✅ Conclusion
All tasks were successfully implemented and tested. The project demonstrates strong foundational skills in data analysis, problem-solving, and tool usage.
