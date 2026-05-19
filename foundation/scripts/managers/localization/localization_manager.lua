-- chunkname: @foundation/scripts/managers/localization/localization_manager.lua

local function var_0_0(arg_1_0)
	return "<" .. tostring(arg_1_0) .. ">"
end

LocalizationManager = class(LocalizationManager)

function LocalizationManager.init(arg_2_0, arg_2_1)
	arg_2_0:_setup_localizers()

	arg_2_0._macros = {}
	arg_2_0._find_macro_callback_to_self = callback(arg_2_0._find_macro, arg_2_0)

	local var_2_0 = rawget(_G, "Steam")

	arg_2_0._language_id = arg_2_1 or Application.user_setting("language_id") or var_2_0 and Steam.language() or "en"
	arg_2_0._backend_localizations = {}

	Crashify.print_property("locale", arg_2_0._language_id)
	rawset(_G, "Localize", function(arg_3_0)
		return arg_2_0:lookup(arg_3_0)
	end)

	string.original_upper = string.upper
	string.original_lower = string.lower
	string.upper = Utf8.upper
end

function LocalizationManager.destroy(arg_4_0)
	rawset(_G, "Localize", nil)
end

function LocalizationManager._setup_localizers(arg_5_0)
	fassert(not arg_5_0._localizers, "LocalizationManager already initialized")

	arg_5_0._localizers = {
		Localizer("localization/game")
	}

	for iter_5_0, iter_5_1 in pairs(DLCSettings) do
		local var_5_0 = iter_5_1.localization

		if var_5_0 and Application.can_get("strings", var_5_0) then
			arg_5_0._localizers[#arg_5_0._localizers + 1] = Localizer(var_5_0)
		end
	end
end

function LocalizationManager._base_lookup(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._backend_localizations[arg_6_1]

	if var_6_0 then
		return var_6_0
	end

	local var_6_1 = Localizer.lookup
	local var_6_2 = arg_6_0._localizers

	for iter_6_0 = 1, #var_6_2 do
		local var_6_3 = var_6_1(var_6_2[iter_6_0], arg_6_1)

		if var_6_3 then
			return var_6_3
		end
	end

	return nil
end

function LocalizationManager.append_backend_localizations(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._backend_localizations

	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		var_7_0[iter_7_0] = iter_7_1
	end
end

function LocalizationManager.add_macro(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0._macros[arg_8_1] = arg_8_2
end

function LocalizationManager.language_id(arg_9_0)
	return arg_9_0._language_id
end

function LocalizationManager.text_to_upper(arg_10_0, arg_10_1)
	return Utf8.upper(arg_10_1)
end

function LocalizationManager.lookup(arg_11_0, arg_11_1)
	fassert(arg_11_0._localizers, "LocalizationManager not initialized")

	local var_11_0 = arg_11_0:_base_lookup(arg_11_1) or var_0_0(arg_11_1)

	return (arg_11_0:apply_macro(var_11_0))
end

function LocalizationManager.apply_macro(arg_12_0, arg_12_1)
	return string.gsub(arg_12_1, "%b$;[%a%d_]*:", arg_12_0._find_macro_callback_to_self)
end

function LocalizationManager.simple_lookup(arg_13_0, arg_13_1)
	fassert(arg_13_0._localizers, "LocalizationManager not initialized")

	return arg_13_0:_base_lookup(arg_13_1) or var_0_0(arg_13_1)
end

function LocalizationManager._find_macro(arg_14_0, arg_14_1)
	local var_14_0 = string.find(arg_14_1, ";")

	return arg_14_0._macros[string.sub(arg_14_1, 2, var_14_0 - 1)](string.sub(arg_14_1, var_14_0 + 1, -2))
end

function LocalizationManager.exists(arg_15_0, arg_15_1)
	fassert(arg_15_0._localizers, "LocalizationManager not initialized")

	return arg_15_0:_base_lookup(arg_15_1) ~= nil
end

function LocalizationManager.plural_form(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._language_id

	if var_16_0 == "en" or var_16_0 == "es" or var_16_0 == "it" or var_16_0 == "br-pt" then
		return arg_16_1 ~= 1 and 1 or 0
	elseif var_16_0 == "fr" then
		return arg_16_1 > 1 and 1 or 0
	elseif var_16_0 == "zh" then
		return 0
	elseif var_16_0 == "ru" then
		if arg_16_1 % 10 == 1 and arg_16_1 % 100 ~= 11 then
			return 0
		elseif arg_16_1 % 10 >= 2 and arg_16_1 % 10 <= 4 and (arg_16_1 % 100 < 10 or arg_16_1 % 100 >= 20) then
			return 1
		else
			return 2
		end
	elseif var_16_0 == "pl" then
		if arg_16_1 == 1 then
			return 0
		elseif arg_16_1 % 10 >= 2 and arg_16_1 % 10 <= 4 and (arg_16_1 % 100 < 10 or arg_16_1 % 100 >= 20) then
			return 1
		else
			return 2
		end
	end

	return 0
end

function LocalizeArray(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or {}

	local var_17_0 = #arg_17_0

	for iter_17_0 = 1, var_17_0 do
		local var_17_1 = arg_17_0[iter_17_0]

		arg_17_1[iter_17_0] = Localize(var_17_1)
	end

	return arg_17_1
end

function TextToUpper(arg_18_0)
	return Managers.localizer:text_to_upper(arg_18_0)
end

local var_0_1 = {}
local var_0_2 = {}

function LocalizationManager.get_input_action(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:_base_lookup(arg_19_1) or var_0_0(arg_19_1)
	local var_19_1 = string.match(var_19_0, "%b$;[%a%d_]*:")
	local var_19_2

	table.clear(var_0_1)
	table.clear(var_0_2)

	while var_19_1 do
		local var_19_3, var_19_4 = string.find(var_19_0, var_19_1)

		var_19_0 = string.sub(var_19_0, var_19_4 + 2)

		local var_19_5 = string.find(var_19_1, ";")
		local var_19_6 = string.sub(var_19_1, var_19_5 + 1, -2)
		local var_19_7, var_19_8 = string.find(var_19_6, "__")

		var_0_2[#var_0_2 + 1] = string.sub(var_19_6, 1, var_19_7 - 1)
		var_0_1[#var_0_1 + 1] = string.sub(var_19_6, var_19_8 + 1)
		var_19_1 = string.match(var_19_0, "%b$;[%a%d_]*:")
	end

	return var_0_1[1], var_0_1, var_0_2[1], var_0_2
end

function LocalizationManager.replace_macro_in_string(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = arg_20_1

	if not arg_20_3 then
		var_20_0 = arg_20_0:_base_lookup(arg_20_1) or var_0_0(arg_20_1)
	end

	local var_20_1, var_20_2 = string.gsub(var_20_0, "%b$;[%a%d_]*:", arg_20_2, arg_20_4)

	return var_20_1, var_20_0, arg_20_0:lookup(arg_20_1), var_20_2
end

function LocalizationManager._set_locale(arg_21_0, arg_21_1, arg_21_2)
	print("[LocalizationManager] Setting locale to:", arg_21_1)
	DeadlockStack.pause()

	arg_21_0._language_id = arg_21_1

	arg_21_0:_reload_locale_packages(arg_21_1, arg_21_2)

	if not arg_21_2 then
		Managers.backend:get_interface("cdn"):load_backend_localizations(arg_21_1, function(arg_22_0)
			if arg_22_0 then
				arg_21_0:append_backend_localizations(arg_22_0)
			end
		end)
	end

	Managers.ui:reload_ingame_ui(true)
	collectgarbage()
	DeadlockStack.unpause()
end

function LocalizationManager._reload_locale_packages(arg_23_0, arg_23_1, arg_23_2)
	printf("[LocalizationManager] reload_locale_packages(%q)", arg_23_1)
	Application.set_resource_property_preference_order(arg_23_1, "en")
	arg_23_0:_reload_boot_package("resource_packages/strings")

	if not arg_23_2 then
		arg_23_0:_reload_boot_package("resource_packages/fonts")
	end
end

function LocalizationManager._reload_boot_package(arg_24_0, arg_24_1)
	DeadlockStack.pause()

	local var_24_0 = Boot.startup_package_handles
	local var_24_1 = var_24_0[arg_24_1]

	ResourcePackage.unload(var_24_1)
	Application.release_resource_package(var_24_1)

	local var_24_2 = Application.resource_package(arg_24_1)

	ResourcePackage.load(var_24_2)
	ResourcePackage.flush(var_24_2)

	var_24_0[arg_24_1] = var_24_2

	DeadlockStack.unpause()
end

function LocalizationManager.set_locale_override_setting(arg_25_0, arg_25_1)
	Application.set_user_setting("language_id", arg_25_1)
	Application.save_user_settings()
end
