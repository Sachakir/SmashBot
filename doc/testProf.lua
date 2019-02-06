dark = require("dark")
quentin = require("quentin")

print(quentin.ok())

--print(dark.version)
--[[
]]--

function have_tag(seq, tag)
    return #seq[tag] ~= 0
end

function string_tag(seq, tag)
    if not have_tag(seq, tag) then
        return
    end
    local pos = seq[tag][1]
    local deb, fin = pos[1], pos[2]
    
    local res = {}
    for i = deb,fin do
        res[#res+1] = seq[i].token
    end
    
    return table.concat(res, " ")
end

local P = dark.pipeline()

P:basic()
P:lexicon("#unit", { "centimètres", "mètres", "mètres carrés", "kilomètres" })
local regle_1 = dark.pattern([[
    [#mesure
        #d #unit
    ]
]])

local regle_2 = dark.pattern([[
    [#monument
       /L[ae]/ /[pP]etite?/? ( tour | pont ) #W
    ]
]])

local regle_3 = dark.pattern([[
    [#hauteur
       #monument
       .{0,3} "hauteur" .{0,3}
       #mesure
    ]
]])

--[[
^ début du mot
$ fin du mot
? = 0..1
* = 0..inf
+ = 1..inf
{n,m} = n..m
si avec un ? devient match le + court sinon reste sur maxi
]]--

local line = "La tour Eiffel a pour hauteur 324 mètres ."

local seq = dark.sequence(line)
P(seq)
regle_1(seq)
regle_2(seq)
regle_3(seq)

print(seq)
print(serialize(seq[3]))
for k,v in pairs(seq[3]) do
    print(k, v)
end

local taps = {
    ["#mesure"] = "yellow",
    ["#monument"] = "blue",
    ["#hauteur"] = "green"
}

print(seq:tostring(taps))
print(serialize(seq["#monument"]))
print(have_tag(seq, "#monument"))
print(string_tag(seq, "#monument"))

