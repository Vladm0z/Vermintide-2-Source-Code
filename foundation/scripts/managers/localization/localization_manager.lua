-- chunkname: @foundation/scripts/managers/localization/localization_manager.lua

local function fn(arg_1_0)
	-- function 1
	return "<" .. tostring(arg_1_0) .. ">"
end

LocalizationManager = class(LocalizationManager)

LocalizationManager.init = function (self, arg_2_1)
	-- function 2
	self:_setup_localizers()

	self._macros = {}
	self._find_macro_callback_to_self = callback(self._find_macro, self)

	local var_2_0 = rawget(_G, "Steam")

	if not arg_2_1 then
		-- Nothing
	end

	::label_2_0::

	local user_setting = Application.user_setting("language_id")

	if not user_setting then
		if not var_2_0 then
			user_setting = Steam.language()

			if not user_setting then
				-- Nothing
			end
		end

		user_setting = "en"
	end

	::label_2_1::

	self._language_id = user_setting
	self._backend_localizations = {}

	Crashify.print_property("locale", self._language_id)
	rawset(_G, "Localize", function (arg_3_0)
		-- function 3
		return self:lookup(arg_3_0)
	end)

	string.original_upper = string.upper
	string.original_lower = string.lower
	string.upper = Utf8.upper
end

LocalizationManager.destroy = function (arg_4_0)
	-- function 4
	rawset(_G, "Localize", nil)
end

LocalizationManager._setup_localizers = function (self)
	-- function 5
	fassert(not self._localizers, "LocalizationManager already initialized")

	self._localizers = {
		Localizer("localization/game")
	}

	for k, v in pairs(DLCSettings) do
		local localization = v.localization

		if not localization and not Application.can_get("strings", localization) then
			self._localizers[#self._localizers + 1] = Localizer(localization)
		end
	end
end

LocalizationManager._base_lookup = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self._backend_localizations[arg_6_1]

	if not var_6_0 then
		return var_6_0
	end

	local lookup = Localizer.lookup
	local _localizers = self._localizers

	for i = 1, #_localizers do
		local var_6_3 = lookup(_localizers[i], arg_6_1)

		if not var_6_3 then
			return var_6_3
		end
	end

	return nil
end

LocalizationManager.append_backend_localizations = function (self, arg_7_1)
	-- function 7
	local _backend_localizations = self._backend_localizations

	for k, v in pairs(arg_7_1) do
		_backend_localizations[k] = v
	end
end

LocalizationManager.add_macro = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_0._macros[arg_8_1] = arg_8_2
end

LocalizationManager.language_id = function (self)
	-- function 9
	return self._language_id
end

LocalizationManager.text_to_upper = function (arg_10_0, arg_10_1)
	-- function 10
	return Utf8.upper(arg_10_1)
end

LocalizationManager.lookup = function (self, arg_11_1)
	-- function 11
	fassert(self._localizers, "LocalizationManager not initialized")

	local _base_lookup = self:_base_lookup(arg_11_1)

	_base_lookup = _base_lookup or fn(arg_11_1)

	return (self:apply_macro(_base_lookup))
end

LocalizationManager.apply_macro = function (self, arg_12_1)
	-- function 12
	return string.gsub(arg_12_1, "%b$;[%a%d_]*:", self._find_macro_callback_to_self)
end

LocalizationManager.simple_lookup = function (self, arg_13_1)
	-- function 13
	fassert(self._localizers, "LocalizationManager not initialized")

	local _base_lookup = self:_base_lookup(arg_13_1)

	_base_lookup = _base_lookup or fn(arg_13_1)

	return _base_lookup
end

LocalizationManager._find_macro = function (self, arg_14_1)
	-- function 14
	local find = string.find(arg_14_1, ";")

	return self._macros[string.sub(arg_14_1, 2, find - 1)](string.sub(arg_14_1, find + 1, -2))
end

LocalizationManager.exists = function (self, arg_15_1)
	-- function 15
	fassert(self._localizers, "LocalizationManager not initialized")

	return self:_base_lookup(arg_15_1) ~= nil
end

LocalizationManager.plural_form = function (self, arg_16_1)
	-- function 16
	local _language_id = self._language_id

	if not (_language_id == "en" or _language_id == "es" or _language_id == "it" or _language_id ~= "br-pt") then
		local flag

		flag = arg_16_1 == 1 or not 1 or 0

		return flag
	elseif _language_id == "fr" then
		local flag_2

		flag_2 = not (arg_16_1 > 1) or not 1 or 0

		return flag_2
	elseif _language_id == "zh" then
		return 0
	elseif _language_id == "ru" then
		if not (arg_16_1 % 10 ~= 1 or arg_16_1 % 100 == 11) then
			return 0
		elseif not (not (arg_16_1 % 10 >= 2) or not (arg_16_1 % 10 <= 4) or arg_16_1 % 100 < 10 or not (arg_16_1 % 100 >= 20)) then
			return 1
		else
			return 2
		end
	elseif _language_id == "pl" then
		if arg_16_1 == 1 then
			return 0
		elseif not (not (arg_16_1 % 10 >= 2) or not (arg_16_1 % 10 <= 4) or arg_16_1 % 100 < 10 or not (arg_16_1 % 100 >= 20)) then
			return 1
		else
			return 2
		end
	end

	return 0
end

function LocalizeArray(self, arg_17_1)
	-- function 17
	arg_17_1 = arg_17_1 or {}

	local count = #self

	for i = 1, count do
		local var_17_1 = self[i]

		arg_17_1[i] = Localize(var_17_1)
	end

	return arg_17_1
end

function TextToUpper(arg_18_0)
	-- function 18
	return Managers.localizer:text_to_upper(arg_18_0)
end

local tbl = {}
local tbl_2 = {}

LocalizationManager.get_input_action = function (self, arg_19_1)
	-- function 19
	local _base_lookup = self:_base_lookup(arg_19_1)

	_base_lookup = _base_lookup or fn(arg_19_1)

	local match = string.match(_base_lookup, "%b$;[%a%d_]*:")

	table.clear(tbl)
	table.clear(tbl_2)

	while not match do
		local find, var_19_3 = string.find(_base_lookup, match)

		if not var_19_3 then
			break
		end

		_base_lookup = string.sub(_base_lookup, var_19_3 + 2)

		local find_2 = string.find(match, ";")
		local sub = string.sub(match, find_2 + 1, -2)
		local find_3, var_19_7 = string.find(sub, "__")

		if not find_3 then
			tbl_2[#tbl_2 + 1] = string.sub(sub, 1, find_3 - 1)
			tbl[#tbl + 1] = string.sub(sub, var_19_7 + 1)
		end

		match = string.match(_base_lookup, "%b$;[%a%d_]*:")
	end

	return tbl[1], tbl, tbl_2[1], tbl_2
end

LocalizationManager.replace_macro_in_string = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local var_20_0 = arg_20_1

	if not arg_20_3 then
		var_20_0 = self:_base_lookup(arg_20_1) or fn(arg_20_1)
	end

	local gsub, var_20_2 = string.gsub(var_20_0, "%b$;[%a%d_]*:", arg_20_2, arg_20_4)

	return gsub, var_20_0, self:lookup(arg_20_1), var_20_2
end

LocalizationManager._set_locale = function (self, arg_21_1, arg_21_2)
	-- function 21
	print("[LocalizationManager] Setting locale to:", arg_21_1)
	DeadlockStack.pause()

	self._language_id = arg_21_1

	self:_reload_locale_packages(arg_21_1, arg_21_2)

	if not arg_21_2 then
		Managers.backend:get_interface("cdn"):load_backend_localizations(arg_21_1, function (arg_22_0)
			-- function 22
			if not arg_22_0 then
				self:append_backend_localizations(arg_22_0)
			end
		end)
	end

	Managers.ui:reload_ingame_ui(true)
	collectgarbage()
	DeadlockStack.unpause()
end

LocalizationManager._reload_locale_packages = function (self, arg_23_1, arg_23_2)
	-- function 23
	printf("[LocalizationManager] reload_locale_packages(%q)", arg_23_1)
	Application.set_resource_property_preference_order(arg_23_1, "en")
	self:_reload_boot_package("resource_packages/strings")

	if not arg_23_2 then
		self:_reload_boot_package("resource_packages/fonts")
	end
end

LocalizationManager._reload_boot_package = function (arg_24_0, arg_24_1)
	-- function 24
	DeadlockStack.pause()

	local startup_package_handles = Boot.startup_package_handles
	local var_24_1 = startup_package_handles[arg_24_1]

	ResourcePackage.unload(var_24_1)
	Application.release_resource_package(var_24_1)

	local resource_package = Application.resource_package(arg_24_1)

	ResourcePackage.load(resource_package)
	ResourcePackage.flush(resource_package)

	startup_package_handles[arg_24_1] = resource_package

	DeadlockStack.unpause()
end

LocalizationManager.set_locale_override_setting = function (arg_25_0, arg_25_1)
	-- function 25
	Application.set_user_setting("language_id", arg_25_1)
	Application.save_user_settings()
end
