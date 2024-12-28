function Initialize()
    local currentYear = tonumber(os.date("%Y"))
    local currentMonth = tonumber(os.date("%m"))
    local startDay = tonumber(os.date("*t", os.time{year=currentYear, month=currentMonth, day=1})["wday"])
    local totalDays = os.date("*t", os.time{year=currentYear, month=currentMonth + 1, day=0})["day"]
    GenerateDays(startDay, totalDays)
end

function GenerateDays(startDay, totalDays)
    local daysTable = {}
    local currentDay = tonumber(os.date("%d"))

    local scale = tonumber(SKIN:GetVariable("Scale", 1))
    -- Dimensions of a single day cell
    local cellWidth = (35.3 * scale)
    local cellHeight = (36.6 * scale)
    
    -- Initialize the daysTable with empty spaces
    for i = 1, 42 do
        daysTable[i] = "   "
    end

    -- Fill in the days of the month
    for day = 1, totalDays do
        -- Calculate the index for the day in the grid
        -- Calculate the index for the day in the grid
        -- `startDay` is the weekday index (1-based) and `day` is the day of the month (1-based)
        -- Subtracting 2 adjusts for both 1-based indexing and the offset of `startDay`
        local index = startDay + day - 2
        daysTable[index + 1] = string.format(" %2d ", day)

        -- Highlight the current day
        if day == currentDay then
            -- Calculate row and column for the current day
            local row = math.floor(index / 7) -- Row (0-based)
            local column = index % 7 -- Column (0-based)

            -- Calculate x and y positions
            local x
            if column >= 2 and column <= 5 then
                x = (column * cellWidth) - (0.06 * scale)
            elseif column == 6 then
                x = (column * cellWidth) - (0.6 * scale)
            else
                x = column * cellWidth
            end

            local y
            local yOffsets = { [2] = (-2.9 * scale), [3] = (-8.2 * scale), [4] = (-13.6 * scale), [5] = (-18.9 * scale) }
            y = (row * cellHeight) + (yOffsets[row] or 0)
            
            -- Set the variables for the current day position
            SKIN:Bang("!SetVariable", "MeasureCurrentDayX", x)
            SKIN:Bang("!SetVariable", "MeasureCurrentDayY", y)
        end
    end

    -- Build the days text for display
    local DaysText = ""
    for i = 1, 42 do
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