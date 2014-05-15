-- unit test --

require("Bson")

t = Bson.New()

local t = {}
for i=0,10000000 do
	t[""..i] = i
end

print(t["10"])
--           --
