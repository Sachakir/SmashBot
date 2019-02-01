dark = require("dark")

local M = {}

function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function extractLines(Personnage)
  local p = io.popen('find "'..'textes'..'" -type f')
  local fichiers = {}
  for fichier in p:lines() do
      fichiers[fichier:sub(8,-5)] = fichier
  end

  local file = fichiers[Personnage]
  local lines = lines_from(file)

 -- for k,v in pairs(lines) do
   -- print('line[' .. k .. ']', v)
  --end
  return lines
end

M.extractLines = extractLines

return M