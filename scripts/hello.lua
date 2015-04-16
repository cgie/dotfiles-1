print("hello Lua")

local handle = io.popen("ps aux | grep wicd-client")
local result = handle:read("*a")
print(result)
handle:close()

local handle = io.popen("ps aux | grep wicd-client | sed \\$d | wc -l")
local result = handle:read("*a")
print(result)

if tonumber(result) > 0 then
	print("Wicd-client is running")
else
	print("Launching Wicd-client")
end

handle:close()
print("done")
