local M = {}

function M.table_contains(str, tbl)
    for _, value in ipairs(tbl) do
        if value == str then
            return true
        end
    end
    return false
end

-- Function to check if string_1 is a starting substring of string_2
function M.starts_with(string, substring)
    -- Get the substring from string_2 that has the same length as string_1
    local substring_from_string = string.sub(string, 1, #substring)

    -- Compare the extracted substring with string_1
    if substring_from_string == substring then
        return true
    else
        return false
    end
end

-- Function to calculate start_date and end_date of the current week
function M.calculate_week_dates()
    -- Get the current time in seconds since the epoch
    local current_time = os.time()

    -- Get the current date
    local current_date = os.date("*t", current_time)

    -- Calculate the day of the week where Monday is 1 and Sunday is 7
    local weekday = current_date.wday
    -- Calculate the number of days to subtract to get to the start of the week (Monday)
    local days_to_subtract = weekday - 2 -- We want Monday to be day 1 (subtract 2 for Sunday)
    -- Calculate the start date of the week (Monday)
    local start_date = os.date("*t", current_time - days_to_subtract * 86400)
    start_date.hour = 0
    start_date.min = 0
    start_date.sec = 0
    -- Calculate the end date of the week (Sunday)
    local end_date = os.date("*t", current_time + (7 - weekday + 1) * 86400)
    end_date.hour = 23
    end_date.min = 59
    end_date.sec = 59
    -- Return the start_date and end_date
    return os.date("%Y-%m-%d", os.time(start_date)), os.date("%Y-%m-%d", os.time(end_date))
end

function M.calculate_month_dates()
    -- Get the current time in seconds since the epoch
    local current_time = os.time()

    -- Get the current date
    local current_date = os.date("*t", current_time)

    -- Set the day of the current date to 1 to get the start of the month
    current_date.day = 1

    -- Calculate the start_date of the month
    local start_date = current_date
    start_date.hour = 0
    start_date.min = 0
    start_date.sec = 0

    -- Calculate the end_date of the month
    local next_month = start_date.month + 1
    local next_month_year = start_date.year
    if next_month > 12 then
        next_month = 1
        next_month_year = next_month_year + 1
    end
    local end_date = {
        year = next_month_year,
        month = next_month,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    }
    end_date = os.date("*t", os.time(end_date) - 1) -- Subtract 1 second to get last day of current month

    -- Return the start_date and end_date
    return os.date("%Y-%m-%d", os.time(start_date)), os.date("%Y-%m-%d", os.time(end_date))

end

function M.calculate_quarter_dates()
    -- Get the current time in seconds since the epoch
    local current_time = os.time()

    -- Get the current date
    local current_date = os.date("*t", current_time)

    -- Determine the current quarter
    local quarter = math.ceil(current_date.month / 3)

    -- Calculate the start_date of the quarter
    local start_date = {
        year = current_date.year,
        month = (quarter - 1) * 3 + 1,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    }

    -- Calculate the end_date of the quarter
    local end_date = {
        year = current_date.year,
        month = quarter * 3 + 1,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    }
    end_date = os.date("*t", os.time(end_date) - 86400) -- Subtract 1 day to get last day of previous month

    -- Return the start_date and end_date
    return os.date("%Y-%m-%d", os.time(start_date)), os.date("%Y-%m-%d", os.time(end_date))

end

-- Function to calculate start_date and end_date of the current year
function M.calculate_year_dates()
    -- Get the current time in seconds since the epoch
    local current_time = os.time()

    -- Get the current date
    local current_date = os.date("*t", current_time)

    -- Calculate the start_date of the year (January 1st of the current year)
    local start_date = {
        year = current_date.year,
        month = 1,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    }

    -- Calculate the end_date of the year (December 31st of the current year)
    local end_date = {
        year = current_date.year,
        month = 12,
        day = 31,
        hour = 23,
        min = 59,
        sec = 59
    }

    -- Return the start_date and end_date
    return os.date("%Y-%m-%d", os.time(start_date)), os.date("%Y-%m-%d", os.time(end_date))

end

function M.calculate_relative_datetime(interval)
  -- Parse the interval string to extract the numeric value and unit
  local numeric_value, unit = interval:match("(%d+)(%a+)")
  if not numeric_value or not unit then
    return nil -- Invalid interval format
  end

  -- Convert numeric value to integer
  local numeric = tonumber(numeric_value)
  if not numeric then
    return nil -- Invalid numeric value
  end

  -- Get current time in seconds since epoch
  local now = os.time()

  -- Define time units in seconds
  local unit_seconds = {
    ["secconds"] = 1,
    ["minutes"] = 60,
    ["hours"] = 3600,
    ["days"] = 86400,
    ["weeks"] = 604800, -- 7 days in seconds
    ["months"] = 2592000, -- 30 days in seconds
    ["years"] = 31536000, -- 365 days in seconds
  }
  for key, _ in pairs(unit_seconds) do
    if M.starts_with(key, unit) then
      unit = key
      break
    end
  end
  -- Calculate the relative time in seconds
  local interval_seconds = unit_seconds[unit]
  if not interval_seconds then
    return nil -- Invalid time unit
  end

  local relative_time = now + numeric * interval_seconds
  return 'today', os.date("%Y-%m-%d", relative_time)
end


return M
