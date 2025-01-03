function Initialize()
    local currentYear = tonumber(os.date("%Y"))
    local currentMonth = tonumber(os.date("%m"))
    local startDay = tonumber(os.date("*t", os.time{year=currentYear, month=currentMonth, day=1})["wday"])
    local totalDays = os.date("*t", os.time{year=currentYear, month=currentMonth + 1, day=0})["day"]
    local prevMonthDays = os.date("*t", os.time{year=currentYear, month=currentMonth, day=0})["day"]

    GenerateDays(startDay, totalDays, prevMonthDays)
end

function GenerateDays(startDay, totalDays, prevMonthDays)
    local daysTable = {}
    local currentDay = tonumber(os.date("%d"))
    
    local scale = tonumber(SKIN:GetVariable("Scale", 1))
    -- Dimensions of a single day cell
    local cellWidth = (38.2 * scale)
    local cellHeight = (31.2 * scale)
    
    -- Fill in days from the previous month
    local prevDaysToShow = startDay - 1
    for i = 1, prevDaysToShow do
        daysTable[i] = string.format(" %2d ", prevMonthDays - prevDaysToShow + i)
    end

    -- Fill in the days of the current month
    for day = 1, totalDays do
        local index = startDay + day - 2
        daysTable[index + 1] = string.format(" %2d ", day)

        -- Highlight the current day
        if day == currentDay then
            local row = math.floor(index / 7)
            local column = index % 7
            
            -- Calculate x and y positions
            local x = column * cellWidth
            local y = row * cellHeight
            
            SKIN:Bang("!SetVariable", "MeasureCurrentDayX", x)
            SKIN:Bang("!SetVariable", "MeasureCurrentDayY", y)
        end
    end

    -- Fill in days from the next month
    local nextDaysToShow = 42 - (#daysTable)
    for i = 1, nextDaysToShow do
        table.insert(daysTable, string.format(" %2d ", i))
    end

    -- Build the days text for display
    local DaysText = ""
    for i = 1, #daysTable do
        DaysText = DaysText .. daysTable[i]
        if i % 7 == 0 then
            DaysText = DaysText .. "\n"
        end
    end

    -- Clean up the daysText
    DaysText = DaysText:gsub("\n%s+\n", "\n"):gsub("[ \n]+$", "")
    
    -- Set the final days text variable
    SKIN:Bang("!SetVariable", "DaysText", DaysText)
end
