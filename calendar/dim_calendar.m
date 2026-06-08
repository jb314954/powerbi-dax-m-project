let
    StartDate = #date(2010, 1, 1),
    EndDate = #date(2035, 12, 31),
    Today = Date.From(DateTime.LocalNow()),

    Dates = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1,0,0,0)),
    Source = Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}),
    #"Changed Type" = Table.TransformColumnTypes(Source, {{"Date", type date}}),

    // ===== PODSTAWY =====
    AddYear = Table.AddColumn(#"Changed Type", "Year", each Date.Year([Date])),
    AddMonth = Table.AddColumn(AddYear, "Month Number", each Date.Month([Date])),
    AddDay = Table.AddColumn(AddMonth, "Day Number", each Date.Day([Date])),
    AddQuarter = Table.AddColumn(AddDay, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date]))),

    // ===== ISO =====
    AddISOWeek = Table.AddColumn(AddQuarter, "ISO Week", each Date.WeekOfYear([Date], Day.Monday)),
    AddISOYear = Table.AddColumn(AddISOWeek, "ISO Year", each Date.Year(Date.AddDays([Date], 4 - Date.DayOfWeek([Date], Day.Monday)))),

    // ===== TYGODNIE =====
    AddWeek = Table.AddColumn(AddISOYear, "Week Number", each Date.WeekOfYear([Date], Day.Monday)),
    AddDayOfWeek = Table.AddColumn(AddWeek, "Day of Week Number", each Date.DayOfWeek([Date], Day.Monday) + 1),

    // ===== SORT =====
    AddYearMonth = Table.AddColumn(AddDayOfWeek, "YearMonth Number", each Date.Year([Date]) * 100 + Date.Month([Date])),

    // ===== NAZWY =====
    AddMonthEN = Table.AddColumn(AddYearMonth, "Month Name EN", each Date.ToText([Date], "MMMM")),
    AddMonthPL = Table.AddColumn(AddMonthEN, "Month Name PL", each 
        {"Styczeń","Luty","Marzec","Kwiecień","Maj","Czerwiec","Lipiec","Sierpień","Wrzesień","Październik","Listopad","Grudzień"}{Date.Month([Date])-1}
    ),

    AddDayEN = Table.AddColumn(AddMonthPL, "Day Name EN", each Date.ToText([Date], "dddd")),
    AddDayPL = Table.AddColumn(AddDayEN, "Day Name PL", each 
        {"Poniedziałek","Wtorek","Środa","Czwartek","Piątek","Sobota","Niedziela"}{Date.DayOfWeek([Date], Day.Monday)}
    ),

    // ===== FLAGI =====
    AddIsWeekend = Table.AddColumn(AddDayPL, "Is Weekend", each Date.DayOfWeek([Date], Day.Monday) >= 5),
    AddIsToday = Table.AddColumn(AddIsWeekend, "Is Today", each [Date] = Today),

    // ===== ŚWIĘTA (pełna wersja) =====
    AddHoliday = Table.AddColumn(AddIsToday, "Is Holiday", each
        let
            y = Date.Year([Date]),

            a = Number.Mod(y,19),
            b = Number.IntegerDivide(y,100),
            c = Number.Mod(y,100),
            d = Number.IntegerDivide(b,4),
            e = Number.Mod(b,4),
            f = Number.IntegerDivide(b+8,25),
            g = Number.IntegerDivide(b-f+1,3),
            h = Number.Mod(19*a + b - d - g + 15, 30),
            i = Number.IntegerDivide(c,4),
            k = Number.Mod(c,4),
            l = Number.Mod(32 + 2*e + 2*i - h - k, 7),
            m = Number.IntegerDivide(a + 11*h + 22*l,451),

            EasterMonth = Number.IntegerDivide(h + l - 7*m + 114,31),
            EasterDay = Number.Mod(h + l - 7*m + 114,31) + 1,

            Easter = #date(y, EasterMonth, EasterDay),
            EasterMonday = Date.AddDays(Easter,1),
            CorpusChristi = Date.AddDays(Easter,60)

        in
            List.Contains({
                #date(y,1,1),
                #date(y,1,6),
                #date(y,5,1),
                #date(y,5,3),
                #date(y,8,15),
                #date(y,11,1),
                #date(y,11,11),
                #date(y,12,25),
                #date(y,12,26),
                EasterMonday,
                CorpusChristi
            }, [Date])
    ),

    // ===== BUSINESS DAY =====
    AddBusinessDay = Table.AddColumn(AddHoliday, "Is Business Day", each 
        Date.DayOfWeek([Date], Day.Monday) < 5 and not [Is Holiday]
    ),

    // ===== FISCAL =====
    AddFiscal = Table.AddColumn(AddBusinessDay, "Fiscal Year", each 
        if Date.Month([Date]) >= 7 then Date.Year([Date]) + 1 else Date.Year([Date])
    ),

    // ===== SLICERY =====
    AddMonthYearPL = Table.AddColumn(AddFiscal, "Month Year PL", each 
        {"Sty","Lut","Mar","Kwi","Maj","Cze","Lip","Sie","Wrz","Paź","Lis","Gru"}{Date.Month([Date])-1}
        & " " & Text.From(Date.Year([Date]))
    ),

    // ===== TIME =====
    AddMTD = Table.AddColumn(AddMonthYearPL, "MTD", each 
        Date.Year([Date]) = Date.Year(Today) and Date.Month([Date]) = Date.Month(Today) and [Date] <= Today
    ),

    AddYTD = Table.AddColumn(AddMTD, "YTD", each 
        Date.Year([Date]) = Date.Year(Today) and [Date] <= Today
    ),

    AddLast30 = Table.AddColumn(AddYTD, "Last 30 Days", each 
        [Date] >= Date.AddDays(Today,-29) and [Date] <= Today
    ),

    AddRolling12 = Table.AddColumn(AddLast30, "Rolling 12M", each 
        [Date] >= Date.AddMonths(Today,-12) and [Date] <= Today
    ),

    // ===== WORK =====
    AddShift = Table.AddColumn(AddRolling12, "Shift", each 
        if Date.DayOfWeek([Date], Day.Monday) >= 5 then "Weekend" else "Standard"
    ),

    AddWorkHours = Table.AddColumn(AddShift, "Work Hours", each 
        if Date.DayOfWeek([Date], Day.Monday) >= 5 then 0 else 8
    )

in
    AddWorkHours
