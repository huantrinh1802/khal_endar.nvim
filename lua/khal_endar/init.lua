local M = {}
M.ui = require("khal_endar.ui")
M.utils = require("khal_endar.utils")
local date_funcs = {
  ["week"] = M.utils.calculate_week_dates,
  ["month"] = M.utils.calculate_month_dates,
  ["quarter"] = M.utils.calculate_quarter_dates,
  ["year"] = M.utils.calculate_year_dates,
}
function M.execute_command(command, return_data, print_output)
  if not return_data or return_data == nil then
    command = command .. " 2>&1"
  end
  local handle = io.popen(command)
  local result = handle:read("*a")
  if print_output then
    print(result)
  end
  local _, status, code = handle:close()
  return code, result
end

function M.show(type, args)
  local start_date, end_date = nil, nil
  local count = 0
  if #args == 0 then
    start_date, end_date = M.utils.calculate_relative_datetime("2w")
  elseif #args % 2 == 1 then
    if M.utils.table_contains(args[#args], { "week", "month", "quarter", "year" }) then
      start_date, end_date = date_funcs[args[#args]]()
    else
      start_date, end_date = M.utils.calculate_relative_datetime(args[#args])
    end
    count = 1
  else
    if not (args[#args - 1]:match("-a") or args[#args - 1]:match("-d")) then
      start_date, end_date = args[#args - 1], args[#args]
      count = 2
    else
      start_date, end_date = M.utils.calculate_relative_datetime("2w")
    end
  end
  local options = ""
  if count < #args then
    for i = 1, #args - count do
      options = options .. " " .. args[i]
    end
  end
  print("khal --color " .. type .. " " .. options .. " " .. start_date .. " " .. end_date)
  local _, cal =
    M.execute_command("khal --color " .. type .. " " .. options .. " " .. start_date .. " " .. end_date, true)
  local contents = vim.split(cal, "\n")
  M.ui.trigger_hover(contents, "List of events")
end

function M.run(args)
  M.execute_command("khal " .. table.concat(args, " "), false, true)
end

function M.interact(args)
  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event

  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },

    position = "50%",
    size = {
      width = "80%",
      height = "60%",
    },
  })

  -- mount/open the component
  popup:mount()
  vim.cmd("term ikhal " .. table.concat(args, " "))
  vim.cmd("startinsert")
  popup:on(event.TermClose, function()
    popup:unmount()
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("KLendar", function(args)
    M.show("calendar", args.fargs)
  end, { nargs = "*" })
  vim.api.nvim_create_user_command("KList", function(args)
    M.show("list", args.fargs)
  end, { nargs = "*" })
  vim.api.nvim_create_user_command("KLInteract", function(args)
    M.interact(args)
  end, { nargs = "*" })
  vim.api.nvim_create_user_command("KLRun", function(args)
    M.run(args.fargs)
  end, { nargs = "*" })
end

return M
