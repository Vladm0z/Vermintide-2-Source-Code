-- chunkname: @scripts/managers/mod/mod_shim.lua

ModShim = class(ModShim)
ModShim.patches = {
	{
		name = "_G.UIResolution",
		mods = {
			"HideBuffs"
		},
		func = function()
			return RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h
		end
	},
	{
		name = "_G.UIResolutionScale_pow2",
		mods = {
			"item_filter",
			"VMF"
		},
		func = function()
			local var_2_0 = RESOLUTION_LOOKUP.res_w / 1920
			local var_2_1 = math
			local var_2_2, var_2_3 = var_2_1.frexp(var_2_0)

			if var_2_2 == 0.5 then
				return var_2_0
			end

			return var_2_1.ldexp(1, var_2_3)
		end
	},
	{
		name = "_G.UIResolutionWidthFragments",
		mods = {
			"loadout_manager_vt2"
		},
		func = function()
			return 1920
		end
	},
	{
		name = "_G.UIResolutionHeightFragments",
		mods = {
			"loadout_manager_vt2"
		},
		func = function()
			return 1080
		end
	},
	{
		name = "_G.AccomodateViewport",
		mods = {
			"HiDefUIScaling"
		},
		func = NOP
	},
	{
		name = "IngameUI:unavailable_hero_popup_active",
		mods = {
			"VMF"
		},
		func = function(arg_5_0)
			return arg_5_0:get_active_popup("profile_picker")
		end
	},
	{
		name = "HeroViewStateAchievements:_is_button_hover_enter",
		mods = {
			"ui_improvements"
		},
		func = function(arg_6_0, arg_6_1, arg_6_2)
			return UIUtils.is_button_hover_enter(arg_6_1, arg_6_2)
		end
	}
}
ModShim.error_handling = {
	error_state = {},
	state_bound_log = function(arg_7_0, arg_7_1, arg_7_2, ...)
		local var_7_0 = ModShim.error_handling.error_state[arg_7_1] or {
			printed = {}
		}

		ModShim.error_handling.error_state[arg_7_1] = var_7_0

		local var_7_1 = Managers.state.game_mode and Managers.state.game_mode:game_mode()

		if not var_7_1 or var_7_0.printed[var_7_1] then
			return
		end

		var_7_0.printed[var_7_1] = true

		ModShim.error_handling.log(arg_7_0, arg_7_2, ...)
	end,
	log = function(arg_8_0, arg_8_1, ...)
		arg_8_0:error(arg_8_1, ...)
	end
}
ModShim.wedges = {
	{
		date = "5/27/2024 10:15:00 PM",
		mods = {
			"loadout_manager_vt2"
		},
		override_hooks = {
			{
				name = "BackendUtils.get_loadout_item",
				func = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, ...)
					local var_9_0 = arg_9_1(arg_9_3, ...)
					local var_9_1 = Managers.mechanism:current_mechanism_name()

					if var_9_1 ~= "adventure" and not global_is_inside_inn then
						local var_9_2 = arg_9_3(...)

						if var_9_0 ~= var_9_2 then
							local var_9_3 = MechanismSettings[var_9_1] and MechanismSettings[var_9_1].display_name

							if var_9_1 == "versus" then
								ModShim.error_handling.state_bound_log(arg_9_0, "loadout_item", "Unauthorized override of inventory items. Not allowed in %s.", var_9_3 and Localize(var_9_3) or var_9_1)
							else
								ModShim.error_handling.state_bound_log(arg_9_0, "loadout_item", "Unauthorized override of bot's inventory items. Not allowed in %s. Please refer to the official loadout system for bot overrides.", var_9_3 and Localize(var_9_3) or var_9_1)
							end
						end

						return var_9_2
					end

					return var_9_0
				end
			},
			{
				name = "BackendInterfaceTalentsPlayfab:get_talents",
				func = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, ...)
					local var_10_0 = arg_10_1(arg_10_3, ...)
					local var_10_1 = Managers.mechanism:current_mechanism_name()

					if var_10_1 ~= "adventure" and not global_is_inside_inn then
						local var_10_2 = arg_10_3(...)

						if var_10_0 ~= var_10_2 then
							local var_10_3 = MechanismSettings[var_10_1] and MechanismSettings[var_10_1].display_name

							if var_10_1 == "versus" then
								ModShim.error_handling.state_bound_log(arg_10_0, "loadout_talent", "Unauthorized override of talents. Not allowed in %s.", var_10_3 and Localize(var_10_3) or var_10_1)
							else
								ModShim.error_handling.state_bound_log(arg_10_0, "loadout_talent", "Unauthorized override of bot's talents. Not allowed in %s. Please refer to the official loadout system for bot overrides.", var_10_3 and Localize(var_10_3) or var_10_1)
							end
						end

						return var_10_2
					end

					return var_10_0
				end
			}
		},
		initializer = function(arg_11_0)
			local var_11_0 = arg_11_0.restore_loadout

			if var_11_0 then
				function arg_11_0.restore_loadout(...)
					local var_12_0 = Managers.mechanism:current_mechanism_name()

					if var_12_0 == "versus" and not global_is_inside_inn then
						return
					end

					if var_12_0 ~= "adventure" and (not global_is_inside_inn or var_12_0 == "versus") then
						local var_12_1 = MechanismSettings[var_12_0] and MechanismSettings[var_12_0].display_name

						ModShim.error_handling.state_bound_log(arg_11_0, "loadout_restore", "Unauthorized override of loadout. Not allowed in %s.", var_12_1 and Localize(var_12_1) or var_12_0)

						return
					end

					var_11_0(...)
				end
			end
		end
	},
	{
		date = "5/30/2024 12:15:00 PM",
		mods = {
			"HideBuffs"
		},
		override_hooks = {
			{
				name = "UnitFrameUI.draw",
				func = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, ...)
					local var_13_0 = Managers.player:local_player()
					local var_13_1 = var_13_0 and var_13_0:get_party()

					if var_13_1 and var_13_1.name == "dark_pact" then
						return arg_13_3(arg_13_4, ...)
					else
						return arg_13_1(arg_13_3, arg_13_4, ...)
					end
				end
			},
			{
				name = "OverchargeBarUI._update_overcharge",
				func = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, ...)
					local var_14_0 = Managers.player:local_player()
					local var_14_1 = var_14_0 and var_14_0:get_party()

					if var_14_1 and var_14_1.name == "dark_pact" then
						return arg_14_3(arg_14_4, ...)
					else
						return arg_14_1(arg_14_3, arg_14_4, ...)
					end
				end
			}
		}
	},
	{
		date = "12/5/2024 12:15:00 PM",
		mods = {
			"NeuterUltEffects"
		},
		new_hooks = {
			{
				name = "MoodHandler.set_mood",
				func = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, ...)
					if not arg_15_0.SETTING_NAMES then
						return arg_15_2(arg_15_3, arg_15_4, ...)
					end

					local var_15_0 = {
						skill_shade = "SHADE",
						skill_slayer = "SLAYER",
						skill_ranger = "RANGER",
						skill_zealot = "ZEALOT"
					}

					if var_15_0[arg_15_4] and arg_15_0:get(arg_15_0.SETTING_NAMES[var_15_0[arg_15_4] .. "_VISUAL"]) then
						return
					end

					if (arg_15_4 == "skill_huntsman_surge" or arg_15_4 == "skill_huntsman_stealth") and arg_15_0:get(arg_15_0.SETTING_NAMES.HUNTSMAN_VISUAL) or (arg_15_4 == "wounded" or arg_15_4 == "bleeding_out") and arg_15_0:get(arg_15_0.SETTING_NAMES.WOUNDED) or arg_15_4 == "knocked_down" and arg_15_0:get(arg_15_0.SETTING_NAMES.KNOCKED_DOWN) or arg_15_4 == "heal_medkit" and arg_15_0:get(arg_15_0.SETTING_NAMES.HEALING) then
						return
					end

					return arg_15_2(arg_15_3, arg_15_4, ...)
				end
			}
		},
		override_hooks = {
			{
				name = "BuffFunctionTemplates.functions.apply_huntsman_activated_ability",
				func = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, ...)
					if arg_16_0:get(arg_16_0.SETTING_NAMES.HUNTSMAN_VISUAL) then
						local var_16_0 = Unit.flow_event
						local var_16_1 = PlayerUnitFirstPerson.play_remote_hud_sound_event
						local var_16_2 = PlayerBotUnitFirstPerson.play_remote_hud_sound_event

						local function var_16_3()
							return
						end

						Unit.flow_event = var_16_3
						PlayerUnitFirstPerson.play_remote_hud_sound_event = var_16_3
						PlayerBotUnitFirstPerson.play_remote_hud_sound_event = var_16_3

						local var_16_4 = {
							arg_16_3(...)
						}

						Unit.flow_event = var_16_0
						PlayerUnitFirstPerson.play_remote_hud_sound_event = var_16_1
						PlayerBotUnitFirstPerson.play_remote_hud_sound_event = var_16_2

						return unpack(var_16_4)
					else
						return arg_16_3(...)
					end
				end
			}
		}
	}
}
ModShim.warnings = ModShim.warnings or {}

local var_0_0 = ModShim.warnings

local function var_0_1(arg_18_0)
	if var_0_0[arg_18_0] then
		return
	end

	var_0_0[arg_18_0] = true

	if Managers.mod:developer_mode_enabled() then
		local var_18_0 = string.format("Function %q is deprecated!", arg_18_0)

		Managers.mod:print("warning", "%s", var_18_0)
		print("[ModShim] %s\n%s", var_18_0, Script.callstack())
	end
end

function ModShim.init(arg_19_0)
	arg_19_0._enable_wedges = not script_data["eac-untrusted"]

	if arg_19_0._enable_wedges then
		arg_19_0._wedged_mod_by_id = {}
		arg_19_0._ugc_data_by_id = {}
	end

	if script_data.debug_mod_shim then
		printf("[ModShim] Initializing ModShim. Wedges enabled: %s.", arg_19_0._enable_wedges)
	end

	local var_19_0 = ModShim.patches

	for iter_19_0 = 1, #var_19_0 do
		local var_19_1 = var_19_0[iter_19_0]
		local var_19_2 = var_19_1.name
		local var_19_3, var_19_4 = string.match(var_19_2, "^([^:.]+)[:.]([^:.]+)$")

		fassert(var_19_3 and var_19_4, "Malformed name for shim (expected `object:method` but got %q)", var_19_2)

		local var_19_5 = rawget(_G, var_19_3)

		fassert(var_19_5, "Object %q not in the global scope", var_19_3)

		local var_19_6 = rawget(var_19_5, var_19_4)

		fassert(var_19_6 == nil, "Method %q already defined in object %q", var_19_4, var_19_3)

		local var_19_7 = var_19_1.func

		rawset(var_19_5, var_19_4, function(...)
			var_0_1(var_19_2)

			return var_19_7(...)
		end)
	end
end

function ModShim._parse_timestamp(arg_21_0, arg_21_1)
	local var_21_0 = "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+) (%a+)"
	local var_21_1, var_21_2, var_21_3, var_21_4, var_21_5, var_21_6, var_21_7 = arg_21_1:match(var_21_0)
	local var_21_8 = tonumber(var_21_4)

	if var_21_7 == "PM" and var_21_8 ~= 12 then
		var_21_8 = var_21_8 + 12
	elseif var_21_7 == "AM" and var_21_8 ~= 12 then
		var_21_8 = 0
	end

	return os.time({
		month = tonumber(var_21_1),
		day = tonumber(var_21_2),
		year = tonumber(var_21_3),
		hour = var_21_8,
		minute = tonumber(var_21_5),
		second = tonumber(var_21_6)
	})
end

function ModShim._wedge_hook(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9)
	local var_22_0 = arg_22_1[arg_22_3]

	if not var_22_0 then
		printf("[ModShim] Trying to wedge non existing hook func '%s'. Ignoring.", arg_22_3)

		return
	end

	arg_22_4[arg_22_5] = arg_22_4[arg_22_5] or {}
	arg_22_4[arg_22_5][arg_22_6] = arg_22_9
	arg_22_4[arg_22_5][arg_22_8] = arg_22_9
	arg_22_4[arg_22_7] = arg_22_4[arg_22_7] or {}
	arg_22_4[arg_22_7][arg_22_6] = arg_22_9
	arg_22_4[arg_22_7][arg_22_8] = arg_22_9

	if script_data.debug_mod_shim then
		printf("[ModShim] <%s:%s> wedged %s:%s (%s:%s)", arg_22_2, arg_22_3, arg_22_7, arg_22_8, arg_22_5, arg_22_6)
	end

	arg_22_1[arg_22_3] = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, ...)
		local var_23_0 = arg_23_3
		local var_23_1 = arg_22_4[arg_23_1] and arg_22_4[arg_23_1][arg_23_2]

		if var_23_1 then
			printf("[ModShim] <%s> hooking into %s.%s with wedged function", arg_22_2, arg_23_1, arg_23_2)

			function var_23_0(arg_24_0, ...)
				if not arg_22_1:is_enabled() then
					if type(arg_24_0) == "function" then
						return arg_24_0(...)
					end

					return
				end

				local var_24_0, var_24_1 = pcall(var_23_1, arg_22_1, arg_23_3, arg_22_2, arg_24_0, ...)

				if not var_24_0 then
					printf("[ModShim] <%s> Wedge error in '%s:%s': %s. args: %s", arg_22_1:get_internal_data("name"), arg_22_7, arg_22_8, var_24_1, table.tostring({
						...
					}))
					print(Script.callstack())

					return arg_23_3(arg_24_0, ...)
				end

				return var_24_1
			end
		elseif script_data.debug_mod_shim then
			printf("[ModShim] <%s> hooking into %s:%s without wedged function", arg_22_2, arg_23_1, arg_23_2)
		end

		return var_22_0(arg_23_0, arg_23_1, arg_23_2, var_23_0, ...)
	end
end

function ModShim._add_hook(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8, arg_25_9)
	local var_25_0 = arg_25_1[arg_25_3]

	if not var_25_0 then
		printf("[ModShim] Trying to wedge non existing hook func '%s'. Ignoring.", arg_25_3)

		return
	end

	local var_25_1 = {}

	var_25_0(arg_25_1, arg_25_5 or arg_25_7, arg_25_8 or arg_25_6, function(arg_26_0, ...)
		if var_25_1.func then
			return var_25_1.func(arg_26_0, ...)
		end

		return arg_25_9(arg_25_1, arg_25_2, arg_26_0, ...)
	end)

	arg_25_4[arg_25_5] = arg_25_4[arg_25_5] or {}
	arg_25_4[arg_25_5][arg_25_6] = arg_25_9
	arg_25_4[arg_25_5][arg_25_8] = arg_25_9
	arg_25_4[arg_25_7] = arg_25_4[arg_25_7] or {}
	arg_25_4[arg_25_7][arg_25_6] = arg_25_9
	arg_25_4[arg_25_7][arg_25_8] = arg_25_9

	if script_data.debug_mod_shim then
		printf("[ModShim] <%s:%s> wedged %s:%s (%s:%s)", arg_25_2, arg_25_3, arg_25_7, arg_25_8, arg_25_5, arg_25_6)
	end

	arg_25_1[arg_25_3] = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, ...)
		local var_27_0 = arg_27_3

		if arg_25_4[arg_27_1] and arg_25_4[arg_27_1][arg_27_2] then
			printf("[ModShim] <%s> overriding wedged function %s.%s with mods own hook", arg_25_2, arg_27_1, arg_27_2)

			var_25_1.func = arg_27_3
		end

		return var_25_0(arg_27_0, arg_27_1, arg_27_2, var_27_0, ...)
	end
end

function ModShim._mod_wedges(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_2 then
		printf("[ModShim] <%s> Wedges ignored due to not being able to deduce timestamp", arg_28_1)
	end

	return (table.select_array(ModShim.wedges, function(arg_29_0, arg_29_1)
		if arg_29_1.mods and not table.contains(arg_29_1.mods, arg_28_1) then
			return
		end

		local var_29_0 = arg_28_0:_parse_timestamp(arg_29_1.date)

		if var_29_0 < arg_28_2 then
			printf("[ModShim] <%s> Wedge ignored due to being outdated. Wedge created '%s' (%s), mod updated '%s'", arg_28_1, arg_29_1.date, var_29_0, arg_28_2)

			return
		end

		return arg_29_1
	end))
end

function ModShim._mod_created(arg_30_0, arg_30_1, arg_30_2)
	if not arg_30_0._enable_wedges then
		return
	end

	if script_data.debug_mod_shim then
		printf("[ModShim] Mod created <%s>", arg_30_2)
	end

	local var_30_0 = Managers.mod:currently_loading_mod()

	arg_30_0:_handle_wedges(arg_30_1, arg_30_2, var_30_0)
end

function ModShim._handle_wedges(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_0:_mod_wedges(arg_31_2, arg_31_3.timestamp)

	if table.is_empty(var_31_0) then
		return
	end

	if script_data.debug_mod_shim then
		printf("[ModShim] \tHas wedges: %s%s", #var_31_0 > 0, #var_31_0 > 0 and "\n\t" .. table.tostring(var_31_0) or "")
	end

	local var_31_1 = arg_31_1:get_internal_data("workshop_id")

	arg_31_0._wedged_mod_by_id[var_31_1] = arg_31_1

	local var_31_2 = {}
	local var_31_3 = {}

	for iter_31_0 = 1, #var_31_0 do
		local var_31_4 = var_31_0[iter_31_0]
		local var_31_5 = var_31_4.override_hooks

		if var_31_5 then
			arg_31_0:_handle_hook_overrides(arg_31_1, arg_31_2, arg_31_3, var_31_5, var_31_2)
		end

		local var_31_6 = var_31_4.new_hooks

		if var_31_6 then
			arg_31_0:_handle_new_hooks(arg_31_1, arg_31_2, arg_31_3, var_31_6, var_31_3)
		end
	end
end

function ModShim._handle_hook_overrides(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	for iter_32_0 = 1, #arg_32_4 do
		repeat
			local var_32_0 = arg_32_4[iter_32_0]
			local var_32_1 = var_32_0.name
			local var_32_2 = _G
			local var_32_3 = ""
			local var_32_4
			local var_32_5

			for iter_32_1, iter_32_2 in string.gmatch(var_32_1, "([^:.]+)([:.]?-?)") do
				if iter_32_2 ~= "" then
					if var_32_5 then
						var_32_3 = var_32_3 .. var_32_5
					end

					var_32_3 = var_32_3 .. iter_32_1
					var_32_2 = var_32_2[iter_32_1]

					if not var_32_2 then
						break
					end
				else
					var_32_4 = iter_32_1
				end

				var_32_5 = iter_32_2
			end

			if not var_32_2 then
				Application.error("[ModShim] Attempting to wedge method '%s' (%s) for mod '%s' but the object '%s' does not exist in the global scope.", var_32_4, var_32_1, arg_32_2, var_32_3)

				break
			end

			if type(var_32_2) ~= "table" then
				Application.error("[ModShim] Attempting to wedge method '%s' (%s) for mod '%s' but the object '%s' is not a table.", var_32_4, var_32_1, arg_32_2, var_32_3)

				break
			end

			local var_32_6 = rawget(var_32_2, var_32_4)

			if not var_32_6 then
				Application.error("[ModShim] Attempting to wedge method '%s' in '%s' (%s) for mod '%s' but it doesn't exist.", var_32_4, var_32_3, var_32_1, arg_32_2)

				break
			end

			if var_32_0.func then
				arg_32_0:_wedge_hook(arg_32_1, arg_32_2, "hook", arg_32_5, var_32_2, var_32_6, var_32_3, var_32_4, var_32_0.func)
			end

			if var_32_0.func_safe then
				arg_32_0:_wedge_hook(arg_32_1, arg_32_2, "hook_safe", arg_32_5, var_32_2, var_32_6, var_32_3, var_32_4, var_32_0.func_safe)
			end

			if var_32_0.func_origin then
				arg_32_0:_wedge_hook(arg_32_1, arg_32_2, "hook_origin", arg_32_5, var_32_2, var_32_6, var_32_3, var_32_4, var_32_0.func_origin)
			end
		until true
	end
end

function ModShim._handle_new_hooks(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	for iter_33_0 = 1, #arg_33_4 do
		local var_33_0 = arg_33_4[iter_33_0]
		local var_33_1 = var_33_0.name
		local var_33_2, var_33_3 = string.match(var_33_1, "^([^:.]+)[:.]([^:.]+)$")
		local var_33_4 = rawget(_G, var_33_2)

		if not var_33_4 then
			Application.error("[ModShim] Attempting to wedge method '%s' in '%s' for mod '%s' but the object does not exist in the global scope.", var_33_3, var_33_2, arg_33_2)

			break
		end

		local var_33_5 = rawget(var_33_4, var_33_3)

		if not var_33_5 then
			Application.error("[ModShim] Attempting to wedge method '%s' in '%s' for mod '%s' but it doesn't exist.", var_33_3, var_33_2, arg_33_2)

			break
		end

		if var_33_0.func then
			arg_33_0:_add_hook(arg_33_1, arg_33_2, "hook", arg_33_5, var_33_4, var_33_5, var_33_2, var_33_3, var_33_0.func)
		end

		if var_33_0.func_safe then
			arg_33_0:_add_hook(arg_33_1, arg_33_2, "hook_safe", arg_33_5, var_33_4, var_33_5, var_33_2, var_33_3, var_33_0.func_safe)
		end

		if var_33_0.func_origin then
			arg_33_0:_add_hook(arg_33_1, arg_33_2, "hook_origin", arg_33_5, var_33_4, var_33_5, var_33_2, var_33_3, var_33_0.func_origin)
		end
	end
end

function ModShim.mod_post_create(arg_34_0, arg_34_1)
	if not arg_34_0._enable_wedges then
		return
	end

	if script_data.debug_mod_shim then
		printf("[ModShim][mod_post_create] %s %s", arg_34_1.name, table.tostring(arg_34_1, 1))
	end

	local var_34_0 = arg_34_1.id

	if arg_34_1.name == "Vermintide Mod Framework" then
		local var_34_1 = get_mod("VMF").mods

		if getmetatable(var_34_1) then
			Application.error("[ModShim] VMF's modlist's metatable is about to be overridden. Disabling ModPatches.")

			return
		end

		if script_data.debug_mod_shim then
			print("[ModShim] VFM initialized. Listening to mod creations.")
		end

		local var_34_2 = {
			__newindex = function(arg_35_0, arg_35_1, arg_35_2, ...)
				rawset(arg_35_0, arg_35_1, arg_35_2, ...)

				if script_data.debug_mod_shim then
					print("[ModShim] mod_create_hook", arg_35_0, arg_35_1, arg_35_2, ...)
				end

				local var_35_0, var_35_1 = pcall(arg_34_0._mod_created, arg_34_0, arg_35_2, arg_35_1, var_34_0)

				if not var_35_0 then
					printf("[ModShim] Error during mod_wedge: %s (%s)", var_35_1, table.tostring({
						...
					}))
					print(Script.callstack())
				end
			end
		}

		setmetatable(var_34_1, var_34_2)
	else
		local var_34_3 = arg_34_0._wedged_mod_by_id[var_34_0]

		if var_34_3 then
			local var_34_4 = var_34_3:get_internal_data("name")
			local var_34_5 = arg_34_0:_mod_wedges(var_34_4, arg_34_1.timestamp)

			for iter_34_0 = 1, #var_34_5 do
				repeat
					local var_34_6 = var_34_5[iter_34_0].initializer

					if var_34_6 then
						printf("[ModShim] <%s> Running initializer for wedge number %s", var_34_4, iter_34_0)

						local var_34_7, var_34_8 = pcall(var_34_6, var_34_3)

						if not var_34_7 then
							printf("[ModShim] <%s> Initializer error in wedge number %s. Ignoring: %s", var_34_4, iter_34_0, var_34_8)
							print(Script.callstack())
						end
					end

					break
				until true
			end
		end
	end
end
