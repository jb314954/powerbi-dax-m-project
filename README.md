
# 📊 Power BI Toolkit (DAX & M)

This repository contains reusable components designed to speed up and standardize Power BI development.

It provides ready-to-use building blocks that are commonly required at the beginning of almost every report.


## 📦 Project Structure

calendar/   → Date dimension (DAX & Power Query)
themes/     → Power BI report themes (light & dark)
docs/       → Instructions and usage guides


## 🎯 Purpose

This repository helps:

- reduce repetitive work in Power BI
- standardize report setup
- provide reusable components
- ensure consistency across reports

It can be used as a **starting point for every new report**.


## 🚀 How to use

## ✅ Step 1 — Start a new report

Create a new Power BI report.

👉 Important: core setup (themes + calendar) should be done at the beginning.


## ✅ Step 2 — Apply theme

Go to:

**View → Themes → Browse for themes**

Select one:

- `themes/light-theme.json`
- `themes/dark-theme.json`

⚠️ Important:
Themes should be applied at the beginning.  
Power BI themes do not fully overwrite existing formatting — applying them later may cause inconsistency.


## ✅ Step 3 — Add calendar table

The calendar is a required component for proper reporting.


### 🔹 Option A — DAX (recommended)

1. Go to: **Modeling → New Table**
2. Copy code from:

calendar/dim_calendar.dax
3. Paste and confirm

✅ This version is dynamic


### 🔹 Option B — Power Query (M)

1. Go to: **Transform Data**
2. **New Source → Blank Query**
3. Open **Advanced Editor**
4. Copy code from:

calendar/dim_calendar.m
5. Paste and click **Close & Apply**

✅ This version is loaded during refresh


## 🔗 Step 4 — Create relationships

Connect the calendar to your data:


DimCalendar[Date] → YourTable[Date]

Recommended settings:
- Many-to-one
- Single direction


## 📊 Step 5 — Use calendar in report

Use `DimCalendar` as the main date table.


### ✅ Slicers

- Year  
- Month  
- Month Year  
- Day  


### ✅ Filters

- YTD  
- MTD  
- Last 30 Days  
- Rolling 12M  
- Business Day  


### ✅ Analysis

Use it for:
- time-based calculations  
- period comparisons  
- filtering data by date  


## ⚠️ Important Notes

### 📅 Calendar usage

- always use a dedicated date table  
- do not use date columns from fact tables directly  
- one calendar per model  


### ⚙️ DAX vs Power Query

**DAX version:**
- evaluated dynamically  
- updates automatically based on `TODAY()`  
- reflects current date without refresh ✅  

**Power Query (M) version:**
- evaluated during data refresh only  
- `Today` is calculated at refresh time  
- values remain static until next refresh ⚠️  

👉 Example:
If you open the report tomorrow:
- DAX → shows current date ✅  
- M → shows previous state ❌ (until refresh)


### 🎨 Themes

- should be applied before building visuals  
- changing theme later may not update existing visuals  


## 📘 Documentation

Detailed instructions are available in:

- `docs/how-to-use-calendar.md`
- `docs/how-to-use-themes.md`


## 🧠 Best Practice Workflow

1. Create new report  
2. Apply theme  
3. Add calendar table  
4. Create relationships  
5. Build visuals  


## ✨ Summary

This repository provides reusable components that help:

- start reports faster  
- avoid common modeling mistakes  
- maintain consistent design and logic  

👉 Best used as a standard starting setup for Power BI projects
