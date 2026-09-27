-- chunkname: @scripts/managers/mod/mod_shim.lua

ModShim = class(ModShim)
ModShim.patches = {
	{
		name = "_G.UIResolution",
		mods = {
			"HideBuffs"
		},
		func = function ()
			-- function 1
			return RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h
		end
	},
	{
		name = "_G.UIResolutionScale_pow2",
		mods = {
			"item_filter",
			"VMF"
		},
		func = function ()
			-- function 2
			local num = RESOLUTION_LOOKUP.res_w / 1920
			local math = math
			local frexp, var_2_3 = math.frexp(num)

			if frexp == 0.5 then
				return num
			end

			return math.ldexp(1, var_2_3)
		end
	},
	{
		name = "_G.UIResolutionWidthFragments",
		mods = {
			"loadout_manager_vt2"
		},
		func = function ()
			-- function 3
			return 1920
		end
	},
	{
		name = "_G.UIResolutionHeightFragments",
		mods = {
			"loadout_manager_vt2"
		},
		func = function ()
			-- function 4
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
		func = function (self)
			-- function 5
			return self:get_active_popup("profile_picker")
		end
	},
	{
		name = "HeroViewStateAchievements:_is_button_hover_enter",
		mods = {
			"ui_improvements"
		},
		func = function (arg_6_0, arg_6_1, arg_6_2)
			-- function 6
			return UIUtils.is_button_hover_enter(arg_6_1, arg_6_2)
		end
	},
	{
		name = "UTF8Utils.string_length",
		mods = {},
		func = Utf8.length
	}
}
ModShim.error_handling = {
	error_state = {},
	state_bound_log = function (arg_7_0, arg_7_1, arg_7_2, ...)
		-- function 7
		local var_7_0 = ModShim.error_handling.error_state[arg_7_1]

		var_7_0 = var_7_0 or {
			printed = {}
		}
		ModShim.error_handling.error_state[arg_7_1] = var_7_0

		local game_mode = Managers.state.game_mode

		game_mode = not game_mode and Managers.state.game_mode:game_mode()

		if not game_mode and not var_7_0.printed[game_mode] then
			return
		end

		var_7_0.printed[game_mode] = true

		ModShim.error_handling.log(arg_7_0, arg_7_2, ...)
	end,
	log = function (self, arg_8_1, ...)
		-- function 8
		self:error(arg_8_1, ...)
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
				func = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, ...)
					-- function 9
					local var_9_0 = arg_9_1(arg_9_3, ...)
					local current_mechanism_name = Managers.mechanism:current_mechanism_name()

					if not (current_mechanism_name == "adventure" or global_is_inside_inn) then
						local var_9_2 = arg_9_3(...)

						if var_9_0 ~= var_9_2 then
							local var_9_3 = MechanismSettings[current_mechanism_name]

							var_9_3 = not var_9_3 and MechanismSettings[current_mechanism_name].display_name

							if current_mechanism_name == "versus" then
								local state_bound_log = ModShim.error_handling.state_bound_log
								local var_9_5 = arg_9_0
								local str = "loadout_item"
								local str_2 = "Unauthorized override of inventory items. Not allowed in %s."
								local var_9_8

								if not var_9_3 then
									var_9_8 = Localize(var_9_3)

									if not var_9_8 then
										-- Nothing
									end
								end

								var_9_8 = current_mechanism_name

								::label_9_0::

								state_bound_log(var_9_5, str, str_2, var_9_8)
							else
								local state_bound_log_2 = ModShim.error_handling.state_bound_log
								local var_9_10 = arg_9_0
								local str_3 = "loadout_item"
								local str_4 = "Unauthorized override of bot's inventory items. Not allowed in %s. Please refer to the official loadout system for bot overrides."
								local var_9_13

								if not var_9_3 then
									var_9_13 = Localize(var_9_3)

									if not var_9_13 then
										-- Nothing
									end
								end

								var_9_13 = current_mechanism_name

								::label_9_1::

								state_bound_log_2(var_9_10, str_3, str_4, var_9_13)
							end
						end

						return var_9_2
					end

					return var_9_0
				end
			},
			{
				name = "BackendInterfaceTalentsPlayfab:get_talents",
				func = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, ...)
					-- function 10
					local var_10_0 = arg_10_1(arg_10_3, ...)
					local current_mechanism_name = Managers.mechanism:current_mechanism_name()

					if not (current_mechanism_name == "adventure" or global_is_inside_inn) then
						local var_10_2 = arg_10_3(...)

						if var_10_0 ~= var_10_2 then
							local var_10_3 = MechanismSettings[current_mechanism_name]

							var_10_3 = not var_10_3 and MechanismSettings[current_mechanism_name].display_name

							if current_mechanism_name == "versus" then
								local state_bound_log = ModShim.error_handling.state_bound_log
								local var_10_5 = arg_10_0
								local str = "loadout_talent"
								local str_2 = "Unauthorized override of talents. Not allowed in %s."
								local var_10_8

								if not var_10_3 then
									var_10_8 = Localize(var_10_3)

									if not var_10_8 then
										-- Nothing
									end
								end

								var_10_8 = current_mechanism_name

								::label_10_0::

								state_bound_log(var_10_5, str, str_2, var_10_8)
							else
								local state_bound_log_2 = ModShim.error_handling.state_bound_log
								local var_10_10 = arg_10_0
								local str_3 = "loadout_talent"
								local str_4 = "Unauthorized override of bot's talents. Not allowed in %s. Please refer to the official loadout system for bot overrides."
								local var_10_13

								if not var_10_3 then
									var_10_13 = Localize(var_10_3)

									if not var_10_13 then
										-- Nothing
									end
								end

								var_10_13 = current_mechanism_name

								::label_10_1::

								state_bound_log_2(var_10_10, str_3, str_4, var_10_13)
							end
						end

						return var_10_2
					end

					return var_10_0
				end
			}
		},
		initializer = function (self)
			-- function 11
			local restore_loadout = self.restore_loadout

			if not restore_loadout then
				self.restore_loadout = function (...)
					-- function 12
					local current_mechanism_name = Managers.mechanism:current_mechanism_name()

					if not (current_mechanism_name ~= "versus" or global_is_inside_inn) then
						return
					end

					if not (current_mechanism_name == "adventure" or not global_is_inside_inn or current_mechanism_name ~= "versus") then
						local var_12_1 = MechanismSettings[current_mechanism_name]

						var_12_1 = not var_12_1 and MechanismSettings[current_mechanism_name].display_name

						local state_bound_log = ModShim.error_handling.state_bound_log
						local var_12_3 = self
						local str = "loadout_restore"
						local str_2 = "Unauthorized override of loadout. Not allowed in %s."
						local var_12_6

						if not var_12_1 then
							var_12_6 = Localize(var_12_1)

							if not var_12_6 then
								-- Nothing
							end
						end

						var_12_6 = current_mechanism_name

						::label_12_0::

						state_bound_log(var_12_3, str, str_2, var_12_6)

						return
					end

					restore_loadout(...)
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
				func = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, ...)
					-- function 13
					local local_player = Managers.player:local_player()
					local flag = not local_player and local_player:get_party()

					if not (not flag and flag.name ~= "dark_pact") then
						return arg_13_3(arg_13_4, ...)
					else
						return arg_13_1(arg_13_3, arg_13_4, ...)
					end
				end
			},
			{
				name = "OverchargeBarUI._update_overcharge",
				func = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, ...)
					-- function 14
					local local_player = Managers.player:local_player()
					local flag = not local_player and local_player:get_party()

					if not (not flag and flag.name ~= "dark_pact") then
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
				func = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, ...)
					-- function 15
					if not self.SETTING_NAMES then
						return arg_15_2(arg_15_3, arg_15_4, ...)
					end

					local tbl = {
						skill_shade = "SHADE",
						skill_slayer = "SLAYER",
						skill_ranger = "RANGER",
						skill_zealot = "ZEALOT"
					}

					if not tbl[arg_15_4] and not self:get(self.SETTING_NAMES[tbl[arg_15_4] .. "_VISUAL"]) then
						return
					end

					if (arg_15_4 == "skill_huntsman_surge" or arg_15_4 == "skill_huntsman_stealth" or self:get(self.SETTING_NAMES.HUNTSMAN_VISUAL) or arg_15_4 == "wounded" or arg_15_4 == "bleeding_out" or self:get(self.SETTING_NAMES.WOUNDED) or arg_15_4 ~= "knocked_down" or not self:get(self.SETTING_NAMES.KNOCKED_DOWN)) and arg_15_4 ~= "heal_medkit" or not self:get(self.SETTING_NAMES.HEALING) then
						return
					end

					return arg_15_2(arg_15_3, arg_15_4, ...)
				end
			}
		},
		override_hooks = {
			{
				name = "BuffFunctionTemplates.functions.apply_huntsman_activated_ability",
				func = function (self, arg_16_1, arg_16_2, arg_16_3, ...)
					-- function 16
					if not self:get(self.SETTING_NAMES.HUNTSMAN_VISUAL) then
						local flow_event = Unit.flow_event
						local play_remote_hud_sound_event = PlayerUnitFirstPerson.play_remote_hud_sound_event
						local play_remote_hud_sound_event_2 = PlayerBotUnitFirstPerson.play_remote_hud_sound_event

						local function fn()
							-- function 17
							return
						end

						Unit.flow_event = fn
						PlayerUnitFirstPerson.play_remote_hud_sound_event = fn
						PlayerBotUnitFirstPerson.play_remote_hud_sound_event = fn

						local tbl = {
							arg_16_3(...)
						}

						Unit.flow_event = flow_event
						PlayerUnitFirstPerson.play_remote_hud_sound_event = play_remote_hud_sound_event
						PlayerBotUnitFirstPerson.play_remote_hud_sound_event = play_remote_hud_sound_event_2

						return unpack(tbl)
					else
						return arg_16_3(...)
					end
				end
			}
		}
	}
}

local ModShim = ModShim
local warnings = ModShim.warnings

warnings = warnings or {}
ModShim.warnings = warnings

local warnings_2 = ModShim.warnings

local function fn(arg_18_0)
	-- function 18
	if not warnings_2[arg_18_0] then
		return
	end

	warnings_2[arg_18_0] = true

	if not Managers.mod:developer_mode_enabled() then
		local format = string.format("Function %q is deprecated!", arg_18_0)

		Managers.mod:print("warning", "%s", format)
		print("[ModShim] %s\n%s", format, Script.callstack())
	end
end

ModShim.init = function (self)
	-- function 19
	self._enable_wedges = not MODDED_REALM

	if not self._enable_wedges then
		self._wedged_mod_by_id = {}
		self._ugc_data_by_id = {}
	end

	if not script_data.debug_mod_shim then
		printf("[ModShim] Initializing ModShim. Wedges enabled: %s.", self._enable_wedges)
	end

	local patches = ModShim.patches

	for i = 1, #patches do
		local var_19_1 = patches[i]
		local name = var_19_1.name
		local match, var_19_4 = string.match(name, "^([^:.]+)[:.]([^:.]+)$")

		fassert(not match and var_19_4, "Malformed name for shim (expected `object:method` but got %q)", name)

		local var_19_5 = rawget(_G, match)

		fassert(var_19_5, "Object %q not in the global scope", match)

		local var_19_6 = rawget(var_19_5, var_19_4)

		fassert(var_19_6 == nil, "Method %q already defined in object %q", var_19_4, match)

		local func = var_19_1.func

		rawset(var_19_5, var_19_4, function (...)
			-- function 20
			fn(name)

			return func(...)
		end)
	end
end

ModShim._parse_timestamp = function (arg_21_0, arg_21_1)
	-- function 21
	local str = "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+) (%a+)"
	local match, var_21_2, var_21_3, var_21_4, var_21_5, var_21_6, var_21_7 = arg_21_1:match(str)
	local var_21_8 = tonumber(var_21_4)

	if not (var_21_7 ~= "PM" or var_21_8 == 12) then
		var_21_8 = var_21_8 + 12
	elseif not (var_21_7 ~= "AM" or var_21_8 == 12) then
		var_21_8 = 0
	end

	return os.time({
		month = tonumber(match),
		day = tonumber(var_21_2),
		year = tonumber(var_21_3),
		hour = var_21_8,
		minute = tonumber(var_21_5),
		second = tonumber(var_21_6)
	})
end

ModShim._wedge_hook = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9)
	-- function 22
	local var_22_0 = arg_22_1[arg_22_3]

	if not var_22_0 then
		printf("[ModShim] Trying to wedge non existing hook func '%s'. Ignoring.", arg_22_3)

		return
	end

	local var_22_1 = arg_22_4[arg_22_5]

	var_22_1 = var_22_1 or {}
	arg_22_4[arg_22_5] = var_22_1
	arg_22_4[arg_22_5][arg_22_6] = arg_22_9
	arg_22_4[arg_22_5][arg_22_8] = arg_22_9

	local var_22_2 = arg_22_4[arg_22_7]

	var_22_2 = var_22_2 or {}
	arg_22_4[arg_22_7] = var_22_2
	arg_22_4[arg_22_7][arg_22_6] = arg_22_9
	arg_22_4[arg_22_7][arg_22_8] = arg_22_9

	if not script_data.debug_mod_shim then
		printf("[ModShim] <%s:%s> wedged %s:%s (%s:%s)", arg_22_2, arg_22_3, arg_22_7, arg_22_8, arg_22_5, arg_22_6)
	end

	arg_22_1[arg_22_3] = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, ...)
		-- function 23
		local var_23_0 = arg_23_3
		local var_23_1 = arg_22_4[arg_23_1]

		var_23_1 = not var_23_1 and arg_22_4[arg_23_1][arg_23_2]

		if not var_23_1 then
			printf("[ModShim] <%s> hooking into %s.%s with wedged function", arg_22_2, arg_23_1, arg_23_2)

			function var_23_0(arg_24_0, ...)
				-- function 24
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
		elseif not script_data.debug_mod_shim then
			printf("[ModShim] <%s> hooking into %s:%s without wedged function", arg_22_2, arg_23_1, arg_23_2)
		end

		return var_22_0(arg_23_0, arg_23_1, arg_23_2, var_23_0, ...)
	end
end

ModShim._add_hook = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8, arg_25_9)
	-- function 25
	local var_25_0 = arg_25_1[arg_25_3]

	if not var_25_0 then
		printf("[ModShim] Trying to wedge non existing hook func '%s'. Ignoring.", arg_25_3)

		return
	end

	local tbl = {}

	var_25_0(arg_25_1, arg_25_5 or arg_25_7, arg_25_8 or arg_25_6, function (arg_26_0, ...)
		-- function 26
		if not tbl.func then
			return tbl.func(arg_26_0, ...)
		end

		return arg_25_9(arg_25_1, arg_25_2, arg_26_0, ...)
	end)

	local var_25_2 = arg_25_4[arg_25_5]

	var_25_2 = var_25_2 or {}
	arg_25_4[arg_25_5] = var_25_2
	arg_25_4[arg_25_5][arg_25_6] = arg_25_9
	arg_25_4[arg_25_5][arg_25_8] = arg_25_9

	local var_25_3 = arg_25_4[arg_25_7]

	var_25_3 = var_25_3 or {}
	arg_25_4[arg_25_7] = var_25_3
	arg_25_4[arg_25_7][arg_25_6] = arg_25_9
	arg_25_4[arg_25_7][arg_25_8] = arg_25_9

	if not script_data.debug_mod_shim then
		printf("[ModShim] <%s:%s> wedged %s:%s (%s:%s)", arg_25_2, arg_25_3, arg_25_7, arg_25_8, arg_25_5, arg_25_6)
	end

	arg_25_1[arg_25_3] = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, ...)
		-- function 27
		local var_27_0 = arg_27_3
		local var_27_1 = arg_25_4[arg_27_1]

		var_27_1 = not var_27_1 and arg_25_4[arg_27_1][arg_27_2]

		if not var_27_1 then
			printf("[ModShim] <%s> overriding wedged function %s.%s with mods own hook", arg_25_2, arg_27_1, arg_27_2)

			tbl.func = arg_27_3
		end

		return var_25_0(arg_27_0, arg_27_1, arg_27_2, var_27_0, ...)
	end
end

ModShim._mod_wedges = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	if not arg_28_2 then
		printf("[ModShim] <%s> Wedges ignored due to not being able to deduce timestamp", arg_28_1)
	end

	return (table.select_array(ModShim.wedges, function (arg_29_0, arg_29_1)
		-- function 29
		if not (not arg_29_1.mods and table.contains(arg_29_1.mods, arg_28_1)) then
			return
		end

		local _parse_timestamp = arg_28_0:_parse_timestamp(arg_29_1.date)

		if _parse_timestamp < arg_28_2 then
			printf("[ModShim] <%s> Wedge ignored due to being outdated. Wedge created '%s' (%s), mod updated '%s'", arg_28_1, arg_29_1.date, _parse_timestamp, arg_28_2)

			return
		end

		return arg_29_1
	end))
end

ModShim._mod_created = function (self, arg_30_1, arg_30_2)
	-- function 30
	if not self._enable_wedges then
		return
	end

	if not script_data.debug_mod_shim then
		printf("[ModShim] Mod created <%s>", arg_30_2)
	end

	local currently_loading_mod = Managers.mod:currently_loading_mod()

	self:_handle_wedges(arg_30_1, arg_30_2, currently_loading_mod)
end

ModShim._handle_wedges = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local _mod_wedges = self:_mod_wedges(arg_31_2, arg_31_3.timestamp)

	if not table.is_empty(_mod_wedges) then
		return
	end

	if not script_data.debug_mod_shim then
		local printf = printf
		local str = "[ModShim] \tHas wedges: %s%s"
		local flag = #_mod_wedges > 0
		local str_2

		if #_mod_wedges > 0 then
			str_2 = "\n\t" .. table.tostring(_mod_wedges)

			if not str_2 then
				-- Nothing
			end
		end

		str_2 = ""

		::label_31_0::

		printf(str, flag, str_2)
	end

	local get_internal_data = arg_31_1:get_internal_data("workshop_id")

	self._wedged_mod_by_id[get_internal_data] = arg_31_1

	local tbl = {}
	local tbl_2 = {}

	for i = 1, #_mod_wedges do
		local var_31_8 = _mod_wedges[i]
		local override_hooks = var_31_8.override_hooks

		if not override_hooks then
			self:_handle_hook_overrides(arg_31_1, arg_31_2, arg_31_3, override_hooks, tbl)
		end

		local new_hooks = var_31_8.new_hooks

		if not new_hooks then
			self:_handle_new_hooks(arg_31_1, arg_31_2, arg_31_3, new_hooks, tbl_2)
		end
	end
end

ModShim._handle_hook_overrides = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	-- function 32
	for i = 1, #arg_32_4 do
		repeat
			local var_32_0 = arg_32_4[i]
			local name = var_32_0.name
			local _G = _G
			local str = ""
			local var_32_4
			local var_32_5

			for iter_32_1, iter_32_2 in string.gmatch(name, "([^:.]+)([:.]?-?)") do
				if iter_32_2 ~= "" then
					if not var_32_5 then
						str = str .. var_32_5
					end

					str = str .. iter_32_1
					_G = _G[iter_32_1]

					if not _G then
						break
					end
				else
					var_32_4 = iter_32_1
				end

				var_32_5 = iter_32_2
			end

			if not _G then
				Application.error("[ModShim] Attempting to wedge method '%s' (%s) for mod '%s' but the object '%s' does not exist in the global scope.", var_32_4, name, arg_32_2, str)

				break
			end

			if type(_G) ~= "table" then
				Application.error("[ModShim] Attempting to wedge method '%s' (%s) for mod '%s' but the object '%s' is not a table.", var_32_4, name, arg_32_2, str)

				break
			end

			local var_32_6 = rawget(_G, var_32_4)

			if not var_32_6 then
				Application.error("[ModShim] Attempting to wedge method '%s' in '%s' (%s) for mod '%s' but it doesn't exist.", var_32_4, str, name, arg_32_2)

				break
			end

			if not var_32_0.func then
				self:_wedge_hook(arg_32_1, arg_32_2, "hook", arg_32_5, _G, var_32_6, str, var_32_4, var_32_0.func)
			end

			if not var_32_0.func_safe then
				self:_wedge_hook(arg_32_1, arg_32_2, "hook_safe", arg_32_5, _G, var_32_6, str, var_32_4, var_32_0.func_safe)
			end

			if not var_32_0.func_origin then
				self:_wedge_hook(arg_32_1, arg_32_2, "hook_origin", arg_32_5, _G, var_32_6, str, var_32_4, var_32_0.func_origin)
			end
		until true
	end
end

ModShim._handle_new_hooks = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	-- function 33
	for i = 1, #arg_33_4 do
		local var_33_0 = arg_33_4[i]
		local name = var_33_0.name
		local match, var_33_3 = string.match(name, "^([^:.]+)[:.]([^:.]+)$")
		local var_33_4 = rawget(_G, match)

		if not var_33_4 then
			Application.error("[ModShim] Attempting to wedge method '%s' in '%s' for mod '%s' but the object does not exist in the global scope.", var_33_3, match, arg_33_2)

			break
		end

		local var_33_5 = rawget(var_33_4, var_33_3)

		if not var_33_5 then
			Application.error("[ModShim] Attempting to wedge method '%s' in '%s' for mod '%s' but it doesn't exist.", var_33_3, match, arg_33_2)

			break
		end

		if not var_33_0.func then
			self:_add_hook(arg_33_1, arg_33_2, "hook", arg_33_5, var_33_4, var_33_5, match, var_33_3, var_33_0.func)
		end

		if not var_33_0.func_safe then
			self:_add_hook(arg_33_1, arg_33_2, "hook_safe", arg_33_5, var_33_4, var_33_5, match, var_33_3, var_33_0.func_safe)
		end

		if not var_33_0.func_origin then
			self:_add_hook(arg_33_1, arg_33_2, "hook_origin", arg_33_5, var_33_4, var_33_5, match, var_33_3, var_33_0.func_origin)
		end
	end
end

ModShim.mod_post_create = function (self, arg_34_1)
	-- function 34
	if not self._enable_wedges then
		return
	end

	if not script_data.debug_mod_shim then
		printf("[ModShim][mod_post_create] %s %s", arg_34_1.name, table.tostring(arg_34_1, 1))
	end

	local id = arg_34_1.id

	if arg_34_1.name == "Vermintide Mod Framework" then
		local mods = get_mod("VMF").mods

		if not getmetatable(mods) then
			Application.error("[ModShim] VMF's modlist's metatable is about to be overridden. Disabling ModPatches.")

			return
		end

		if not script_data.debug_mod_shim then
			print("[ModShim] VFM initialized. Listening to mod creations.")
		end

		local tbl = {
			__newindex = function (arg_35_0, arg_35_1, arg_35_2, ...)
				-- function 35
				rawset(arg_35_0, arg_35_1, arg_35_2, ...)

				if not script_data.debug_mod_shim then
					print("[ModShim] mod_create_hook", arg_35_0, arg_35_1, arg_35_2, ...)
				end

				local var_35_0, var_35_1 = pcall(self._mod_created, self, arg_35_2, arg_35_1, id)

				if not var_35_0 then
					printf("[ModShim] Error during mod_wedge: %s (%s)", var_35_1, table.tostring({
						...
					}))
					print(Script.callstack())
				end
			end
		}

		setmetatable(mods, tbl)
	else
		local var_34_3 = self._wedged_mod_by_id[id]

		if not var_34_3 then
			local get_internal_data = var_34_3:get_internal_data("name")
			local _mod_wedges = self:_mod_wedges(get_internal_data, arg_34_1.timestamp)

			for i = 1, #_mod_wedges do
				repeat
					local initializer = _mod_wedges[i].initializer

					if not initializer then
						printf("[ModShim] <%s> Running initializer for wedge number %s", get_internal_data, i)

						local var_34_7, var_34_8 = pcall(initializer, var_34_3)

						if not var_34_7 then
							printf("[ModShim] <%s> Initializer error in wedge number %s. Ignoring: %s", get_internal_data, i, var_34_8)
							print(Script.callstack())
						end
					end

					break
				until true
			end
		end
	end
end
