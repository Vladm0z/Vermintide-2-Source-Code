-- chunkname: @foundation/scripts/util/verify_plugins.lua

if false and IS_WINDOWS and BUILD == "release" then
	local var_0_0 = Application.all_plugin_names()
	local var_0_1 = {
		"fishtank",
		"navigation",
		"rule database",
		"wwise_plugin"
	}

	local function var_0_2(arg_1_0, arg_1_1)
		for iter_1_0, iter_1_1 in pairs(arg_1_0) do
			if iter_1_1 == arg_1_1 then
				return iter_1_0
			end
		end

		return false
	end

	local var_0_3 = ""
	local var_0_4 = 0

	for iter_0_0 = 1, #var_0_1 do
		local var_0_5 = var_0_1[iter_0_0]

		if var_0_2(var_0_0, var_0_5) then
			print("-> " .. var_0_5 .. " plugin has been loaded.")
		else
			var_0_3 = var_0_4 == 0 and var_0_5 or var_0_3 .. ", " .. var_0_5
			var_0_4 = var_0_4 + 1
		end
	end

	if var_0_4 > 0 then
		local var_0_6

		if var_0_4 > 1 then
			var_0_6 = string.format("Game could not load the following plugins: %s. Missing files. Please verify game integrity of game cache in steam, or delete local content and download game again.", var_0_3)
		else
			var_0_6 = string.format("Game could not load %s plugin. Missing files. Please verify game integrity of game cache in steam, or delete local content and download game again.", var_0_3)
		end

		if rawget(_G, "jit") then
			local var_0_7 = require("ffi")

			var_0_7.cdef("\t\t\t\n\t\t\tint MessageBoxA(void *w, const char *txt, const char *cap, int type);\n\t\t\t")

			local var_0_8 = 0
			local var_0_9 = var_0_7.C.MessageBoxA(nil, var_0_6, "Missing Plugin/Files Error", var_0_8)
		end

		error(var_0_6)
	end
end
