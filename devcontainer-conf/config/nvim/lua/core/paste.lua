local default_paste = vim.paste

vim.paste = function(lines, phase)
  local ok, result = pcall(default_paste, lines, phase)
  if ok then
    return result
  end

  local message = tostring(result)
  if message:match("E21") or message:match("'modifiable' is off") then
    vim.schedule(function()
      vim.notify("Current buffer is not editable", vim.log.levels.INFO, { title = "Paste" })
    end)
    return true
  end

  error(result)
end
