-- chunkname: @foundation/scripts/util/user_setting.lua

local Development = Development

Development = Development or {}
Development = Development

local PATCHED_USER_SETTINGS = PATCHED_USER_SETTINGS

PATCHED_USER_SETTINGS = PATCHED_USER_SETTINGS or false
PATCHED_USER_SETTINGS = PATCHED_USER_SETTINGS

if not (not IS_CONSOLE and PATCHED_USER_SETTINGS) then
	local UserSettings = UserSettings

	UserSettings = UserSettings or {}
	UserSettings = UserSettings

	Application.set_user_setting = function (...)
		-- function 1
		local UserSettings = UserSettings
		local var_1_1 = select("#", ...)

		for i = 1, var_1_1 - 2 do
			local var_1_2 = select(i, ...)
			local var_1_3

			if type(UserSettings[var_1_2]) == "table" then
				var_1_3 = UserSettings[var_1_2]

				if not var_1_3 then
					-- Nothing
				end
			end

			var_1_3 = {}

			::label_1_0::

			UserSettings[var_1_2] = var_1_3
			UserSettings = UserSettings[var_1_2]
		end

		UserSettings[select(var_1_1 - 1, ...)] = select(var_1_1, ...)
	end

	Application.user_setting = function (...)
		-- function 2
		local UserSettings = UserSettings
		local var_2_1 = select("#", ...)

		for i = 1, var_2_1 - 1 do
			UserSettings = UserSettings[select(i, ...)]

			if type(UserSettings) ~= "table" then
				return
			end
		end

		return UserSettings[select(var_2_1, ...)]
	end

	Application.save_user_settings = function ()
		-- function 3
		return
	end

	PATCHED_USER_SETTINGS = true
end

Development.user_setting_disable = function ()
	-- function 4
	local function fn()
		-- function 5
		return
	end

	Development.set_setting, Development.setting = fn, fn
end

Development.init_user_settings = function ()
	-- function 6
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
		-- function 7
		Application.set_user_setting("development_settings", ...)
	end

	Development.setting = function (...)
		-- function 8
		return Application.user_setting("development_settings", ...)
	end

	Development._patch_deprecated_development_settings()

	local user_setting = Application.user_setting("development_settings")

	if not user_setting then
		user_setting = {}

		Development.set_setting("dummy_field_to_spawn_development_settings_table", true)
	end

	print("VALUES:")

	for k, v in pairs(user_setting) do
		if v ~= false then
			script_data[k] = v

			print(k, script_data[k])
		end
	end

	print("VALUES END")
end

Application.test_user_setting = function (...)
	-- function 9
	local UserSettings = UserSettings
	local var_9_1 = select("#", ...)

	for i = 1, var_9_1 - 1 do
		UserSettings = UserSettings[select(i, ...)]

		if type(UserSettings) ~= "table" then
			return
		end
	end

	return UserSettings[select(var_9_1, ...)]
end

Development._patch_deprecated_development_settings = function ()
	-- function 10
	Development.set_setting("use_lan_backend", nil)
	Development.set_setting("use_local_backend", nil)
end
