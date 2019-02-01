local q = require("quentin")

caca = q.extractLines("Mario")
for k,v in pairs(caca) do
  print('line[' .. k .. ']', v)
end
