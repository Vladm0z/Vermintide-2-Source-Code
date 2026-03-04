-- chunkname: @foundation/scripts/util/user_setting.lua

Development = Development or {}
PATCHED_USER_SETTINGS = PATCHED_USER_SETTINGS or false

if IS_CONSOLE and not PATCHED_USER_SETTINGS then
	UserSettings = UserSettings or {}

	Application.set_user_setting = function (...)
		local var_1_0 = UserSettings
		local var_1_1 = select("#", ...)

		for iter_1_0 = 1, var_1_1 - 2 do
			local var_1_2 = select(iter_1_0, ...)

			var_1_0[var_1_2] = type(var_1_0[var_1_2]) == "table" and var_1_0[var_1_2] or {}
			var_1_0 = var_1_0[var_1_2]
		end

		var_1_0[select(var_1_1 - 1, ...)] = select(var_1_1, ...)
	end

	Application.user_setting = function (...)
		local var_2_0 = UserSettings
		local var_2_1 = select("#", ...)

		for iter_2_0 = 1, var_2_1 - 1 do
			var_2_0 = var_2_0[select(iter_2_0, ...)]

			if type(var_2_0) ~= "table" then
				return
			end
		end

		return var_2_0[select(var_2_1, ...)]
	end

	Application.save_user_settings = function ()
		return
	end

	PATCHED_USER_SETTINGS = true
end

Development.user_setting_disable = function ()
	local function var_4_0()
		return
	end

	Development.set_setting, Development.setting = var_4_0, var_4_0
end

Development.init_user_settings = function ()
	if not ({
		ps4 = true,
		win32 = true,
		macosx = true,
		xb1 = true
	})[PLATFORM] then
		Development.user_setting_disable()

		return
	end

	if BUILD == "release" then
		Development.user_setting_disable()

		return
	end

	Development.set_setting = function (...)
		Application.set_user_setting("development_settings", ...)
	end

	Development.setting = function (...)
		return Application.user_setting("development_settings", ...)
	end

	Development._patch_deprecated_development_settings()

	local var_6_0 = Application.user_setting("development_settings")

	if not var_6_0 then
		var_6_0 = {}

		Development.set_setting("dummy_field_to_spawn_development_settings_table", true)
	end

	print("VALUES:")

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if iter_6_1 ~= false then
			script_data[iter_6_0] = iter_6_1

			print(iter_6_0, script_data[iter_6_0])
		end
	end

	print("VALUES END")
end

Application.test_user_setting = function (...)
	local var_9_0 = UserSettings
	local var_9_1 = select("#", ...)

	for iter_9_0 = 1, var_9_1 - 1 do
		var_9_0 = var_9_0[select(iter_9_0, ...)]

		if type(var_9_0) ~= "table" then
			return
		end
	end

	return var_9_0[select(var_9_1, ...)]
end

Development._patch_deprecated_development_settings = function ()
	Development.set_setting("use_lan_backend", nil)
	Development.set_setting("use_local_backend", nil)
end
