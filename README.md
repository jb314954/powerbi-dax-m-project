# 📅 DAX Calendar Table

This repository contains a fully featured **calendar table written in DAX**, designed for Power BI and Analysis Services.

## 🚀 Overview

The `DimCalendar` table generates a complete date dimension from **January 1, 2010 to December 31, 2035** and enriches it with a wide set of attributes used in reporting and analytics.

It supports:
- standard date hierarchies
- ISO calendar logic
- Polish and English labels
- business day logic
- holidays (including movable ones)
- time intelligence flags

---

## 🧱 Features

### ✅ Basic Date Attributes
- Year, Month, Day
- Quarter (Q1–Q4)
- Year-Month numeric key (for sorting)

---

### 📆 Calendar Logic
- ISO Week Number
- ISO Year (correctly calculated)
- Standard Week Number
- Day of Week (1 = Monday)

---

### 🌍 Localization
- Month names (English & Polish)
- Day names (English & Polish)
- Month-Year format (PL, e.g. "Sty 2024")

---

### 🏢 Business Logic
- Weekend flag
- Business Day flag
- Work hours (0 for weekend, 8 for working day)
- Shift classification (Weekend / Standard)

---

### 🇵🇱 Holidays (Poland)
Includes:
- Fixed holidays (e.g. New Year, Independence Day)
- Movable holidays calculated dynamically:
  - Easter Monday
  - Corpus Christi

---

### 📊 Time Intelligence
Predefined flags for:
- MTD (Month-to-Date)
- YTD (Year-to-Date)
- Last 30 Days
- Rolling 12 Months

---

### 💼 Fiscal Calendar
- Fiscal year starting in July

---

## ⚙️ Technical Notes

- Uses `CALENDAR()` to generate the base date table
- Adds columns via `ADDCOLUMNS()`
- Implements Easter calculation algorithm in pure DAX
- Designed for performance and usability in Power BI models

---

## 📈 Recommended Usage

Use this table as:
- a **Date dimension** connected to fact tables
- a base for slicers and filters
- a source for time-based calculations

---

## ✨ Author Notes

This calendar is designed as a reusable, production-ready date dimension with extended functionality for real-world reporting scenarios.

1. Copy the DAX script
2. Create a new table in Power BI:
  
