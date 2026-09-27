-- chunkname: @foundation/scripts/util/verify_plugins.lua

if not ((true or not IS_WINDOWS) and BUILD ~= "release") then
	local all_plugin_names = Application.all_plugin_names()
	local tbl = {
		"fishtank",
		"navigation",
		"rule database",
		"wwise_plugin"
	}

	local function fn(arg_1_0, arg_1_1)
		-- function 1
		for k, v in pairs(arg_1_0) do
			if v == arg_1_1 then
				return k
			end
		end

		return false
	end

	local str = ""
	local num = 0

	for i = 1, #tbl do
		local var_0_5 = tbl[i]

		if not fn(all_plugin_names, var_0_5) then
			print("-> " .. var_0_5 .. " plugin has been loaded.")
		else
			str = num ~= 0 or not var_0_5 or str .. ", " .. var_0_5
			num = num + 1
		end
	end

	if num > 0 then
		local var_0_6

		if num > 1 then
			var_0_6 = string.format("Game could not load the following plugins: %s. Missing files. Please verify game integrity of game cache in steam, or delete local content and download game again.", str)
		else
			var_0_6 = string.format("Game could not load %s plugin. Missing files. Please verify game integrity of game cache in steam, or delete local content and download game again.", str)
		end

		if not rawget(_G, "jit") then
			local ffi = require("ffi")

			ffi.cdef("\t\t\t\n\t\t\tint MessageBoxA(void *w, const char *txt, const char *cap, int type);\n\t\t\t")

			local num_2 = 0
			local MessageBoxA = ffi.C.MessageBoxA(nil, var_0_6, "Missing Plugin/Files Error", num_2)
		end

		error(var_0_6)
	end
end
