dark = require("dark")

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


local p = io.popen('find "'..'textes'..'" -type f')
local fichiers = {}
for fichier in p:lines() do
    print(fichier)
    fichiers[fichier:sub(8,-5)] = fichier
    -- table.insert(fichiers, fichier)
end

-- tests the functions above
local file = fichiers['Mario']
local lines = lines_from(file)

-- print all line numbers and their contents
for k,v in pairs(lines) do
  print('line[' .. k .. ']', v)
end
