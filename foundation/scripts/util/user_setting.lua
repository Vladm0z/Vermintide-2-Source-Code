-- chunkname: @foundation/scripts/util/user_setting.lua

Development = not not Development
PATCHED_USER_SETTINGS = not not PATCHED_USER_SETTINGS

if IS_CONSOLE and not PATCHED_USER_SETTINGS then
	UserSettings = not not UserSettings

	Application.set_user_setting = function (...)
		-- function 1
		local t = UserSettings
		local num_args = select("#", ...)

		for i = 1, num_args - 2 do
			local key = select(i, ...)

			t[key] = type(t[key]) ~= "table" and not not {} or not (type(t[key]) ~= "table") and not not t[key]
			t = t[key]
		end

		local set_key = select(num_args - 1, ...)
		local set_value = select(num_args, ...)

		t[set_key] = set_value
	end

	Application.user_setting = function (...)
		-- function 2
		local t = UserSettings
		local num_args = select("#", ...)

		for i = 1, num_args - 1 do
			local key = select(i, ...)

			t = t[key]

			if type(t) ~= "table" then
				return
			end
		end

		return t[select(num_args, ...)]
	end

	Application.save_user_settings = function ()
		-- function 3
		return
	end

	PATCHED_USER_SETTINGS = true
end

Development.user_setting_disable = function ()
	-- function 4
	local function nop()
		-- function 5
		return
	end

	Development.set_setting, Development.setting = nop, nop
end

Development.init_user_settings = function ()
	-- function 6
	local enabled_platforms = {
		ps4 = true,
		win32 = true,
		macosx = true,
		xb1 = true
	}
	local current_platform = PLATFORM

	if not enabled_platforms[current_platform] then
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

	local development_settings = Application.user_setting("development_settings")

	if not development_settings then
		development_settings = {}

		Development.set_setting("dummy_field_to_spawn_development_settings_table", true)
	end

	print("VALUES:")

	for param, value in pairs(development_settings) do
		if value ~= false then
			script_data[param] = value

			print(param, script_data[param])
		end
	end

	print("VALUES END")
end

Application.test_user_setting = function (...)
	-- function 9
	local t = UserSettings
	local num_args = select("#", ...)

	for i = 1, num_args - 1 do
		local key = select(i, ...)

		t = t[key]

		if type(t) ~= "table" then
			return
		end
	end

	return t[select(num_args, ...)]
end

Development._patch_deprecated_development_settings = function ()
	-- function 10
	Development.set_setting("use_lan_backend", nil)
	Development.set_setting("use_local_backend", nil)
end
