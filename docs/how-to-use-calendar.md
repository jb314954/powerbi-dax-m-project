# 📅 How to load and use Calendar in Power BI

Instrukcja jak dodać tabelę kalendarza (DAX i M), jak działa oraz gdzie jej używać.



# ✅ OPCJA 1 — DAX (najlepsza)

## 🔧 Jak załadować

1. Otwórz Power BI Desktop  
2. Kliknij: **Modelowanie → Nowa tabela**  
3. Wklej kod z pliku `dim_calendar.dax`  
4. Zatwierdź (Enter)  

✅ tabela pojawi się jako: `DimCalendar`

## 🔗 Jak podłączyć

1. Przejdź do **Model view**  
2. Połącz kolumny:

Dimcalendar[Date] -> TwojaTabela[Date]

✅ ustawienia:
- Many-to-one  
- Single direction  


## ✅ Oznaczenie tabeli

1. Kliknij `DimCalendar`  
2. **Table tools → Mark as date table**  
3. Wybierz: `Date`  



# ✅ OPCJA 2 — Power Query (M)

## 🔧 Jak załadować

1. Kliknij: **Transform Data**  
2. **New Source → Blank Query**  
3. Otwórz **Advanced Editor**  
4. Wklej kod M  
5. Kliknij: **Close & Apply**

✅ tabela zostanie załadowana do modelu



# ⚙️ Jak działa kalendarz

Tabela:
- generuje wszystkie daty w zakresie (2010–2035)  
- dodaje kolumny do analizy czasu  

### 📊 Przykłady logiki

- `Year / Month / Day` → podstawowe grupowanie  
- `Week / ISO` → analiza tygodniowa  
- `Month Name` → slicery  
- `YearMonth Number` → poprawne sortowanie  



### 🧠 Logika biznesowa

- `Is Weekend` → wykrywa weekend  
- `Is Holiday` → święta (PL)  
- `Is Business Day` → dzień roboczy  



### 📈 Time intelligence

- `MTD` → bieżący miesiąc  
- `YTD` → bieżący rok  
- `Last 30 Days` → ostatnie 30 dni  
- `Rolling 12M` → ostatnie 12 miesięcy  



# 📊 Gdzie używać

## ✅ Slicery

Używaj:
- `Month Year PL`
- `Year`
- `Month Name`



## ✅ Filtry

Używaj:
- `YTD`
- `MTD`
- `Last 30 Days`
- `Is Business Day`



## ✅ Relacje

Zawsze:
- łącz przez `Date`
- używaj kalendarza jako głównej tabeli czasu



## ✅ Miary (przykład)

DAX
Sales YTD =
CALCULATE(
    SUM(Sales[Amount]),
    DimCalendar[YTD] = TRUE()
)

⚠️ Najważniejsze zasady
✔ zawsze używaj calendar do filtrów
✔ nie używaj dat z tabel faktów
✔ jedna tabela dat w modelu
✔ relacja tylko przez Date

