-- chunkname: @scripts/ui/social_wheel/social_wheel_ui_settings.lua

local function fn(arg_1_0)
	-- function 1
	local players = Managers.player:players()

	for k, v in pairs(players) do
		if v:profile_display_name() == arg_1_0 then
			return v
		end
	end
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local data = arg_2_1.data
	local var_2_1 = fn(data)

	if not var_2_1 then
		local get_pickup_settings = ScriptUnit.extension(arg_2_0, "pickup_system"):get_pickup_settings()
		local alloc_table = FrameTable.alloc_table()
		local var_2_4

		if get_pickup_settings.type == "ammo" then
			var_2_4 = "social_wheel_pickup_item_ammo_event"
		else
			var_2_4 = "social_wheel_pickup_item_event"

			local get_data = Unit.get_data(arg_2_0, "interaction_data", "hud_description")

			alloc_table[#alloc_table + 1] = get_data
		end

		local profile_index = var_2_1:profile_index()
		local ingame_short_display_name = SPProfiles[profile_index].ingame_short_display_name

		alloc_table[#alloc_table + 1] = ingame_short_display_name

		return var_2_4, alloc_table
	end
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local owner = Managers.player:owner(arg_3_0)

	if not owner then
		local str = "social_wheel_player_drop_event"
		local data = arg_3_1.data
		local hud_description = AllPickups[data].hud_description
		local profile_index = owner:profile_index()
		local ingame_short_display_name = SPProfiles[profile_index].ingame_short_display_name
		local alloc_table = FrameTable.alloc_table()

		alloc_table[1] = hud_description
		alloc_table[2] = ingame_short_display_name

		return str, alloc_table
	end
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local var_4_0 = fn(arg_4_0)

	if not var_4_0 and not arg_4_1 then
		local player_unit = var_4_0.player_unit

		Managers.state.entity:system("ai_bot_group_system"):order("pickup", player_unit, arg_4_1, arg_4_2)
	end
end

local function fn_5(self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local flag = not arg_5_2 and arg_5_2.player_unit

	if not flag then
		local has_extension = ScriptUnit.has_extension(flag, "cosmetic_system")

		if not has_extension then
			has_extension:queue_3p_emote(self.anim_event, self.hide_weapons)
		end
	end
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	Managers.state.entity:system("ai_bot_group_system"):order("drop", arg_6_1, arg_6_0, arg_6_2)
end

local function fn_7(arg_7_0, arg_7_1)
	-- function 7
	local unit = arg_7_1.unit

	if not Unit.alive(unit) then
		return false
	end

	local slot_name = AllPickups[arg_7_0].slot_name
	local has_extension = ScriptUnit.has_extension(unit, "inventory_system")
	local get_slot_data = has_extension:get_slot_data(slot_name)

	if not get_slot_data then
		local get_item_template = has_extension:get_item_template(get_slot_data)

		if arg_7_0 == "grimoire" then
			return get_item_template.is_grimoire
		else
			return get_item_template.pickup_data.pickup_name == arg_7_0
		end
	else
		return false
	end
end

local function fn_8(arg_8_0, arg_8_1)
	-- function 8
	local unit = arg_8_1.unit

	if not Unit.alive(unit) then
		return false
	end

	local local_player = Managers.player:local_player()
	local var_8_2 = fn(arg_8_0)

	if not (not var_8_2 and var_8_2 == local_player or Unit.alive(var_8_2.player_unit)) then
		return false
	end

	local extension = ScriptUnit.extension(var_8_2.player_unit, "status_system")

	if extension:is_ready_for_assisted_respawn() or not extension:is_dead() then
		return false
	end

	local flag = not var_8_2:is_player_controlled()
	local get_pickup_settings = ScriptUnit.extension(unit, "pickup_system"):get_pickup_settings()

	if not flag and get_pickup_settings.slot_name == "slot_level_event" and not get_pickup_settings.disallow_bot_pickup then
		return false
	else
		return true
	end
end

local function fn_9(self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local pose_index = self.pose_index
	local player_unit = Managers.player:local_player().player_unit

	if not ALIVE[player_unit] then
		return false
	end

	local item_data = ScriptUnit.extension(player_unit, "inventory_system"):get_wielded_slot_data().item_data
	local name = item_data.name
	local pose_name = item_data.pose_name
	local get_unlocked_weapon_poses = Managers.backend:get_interface("items"):get_unlocked_weapon_poses()
	local var_9_6 = get_unlocked_weapon_poses[name]

	var_9_6 = not var_9_6 and get_unlocked_weapon_poses[name][pose_name]

	return var_9_6
end

local function fn_10(arg_10_0, arg_10_1)
	-- function 10
	local owner = Managers.player:owner(arg_10_0)

	if not owner then
		local event_text = arg_10_1.event_text
		local profile_index = owner:profile_index()
		local alloc_table

		alloc_table[1], alloc_table = SPProfiles[profile_index].ingame_short_display_name, FrameTable.alloc_table()

		return event_text, alloc_table
	end
end

SocialWheelPriority = {
	{
		"item",
		function (arg_11_0, arg_11_1, arg_11_2)
			-- function 11
			if not arg_11_2 then
				return false
			end

			if not ScriptUnit.has_extension(arg_11_2, "pickup_system") then
				return false
			end

			local has_extension = ScriptUnit.has_extension(arg_11_2, "interactable_system")

			if not has_extension then
				return false
			end

			local game_mode = Managers.state.game_mode:game_mode()

			if not (not game_mode.allowed_interactions and game_mode:allowed_interactions(arg_11_1.player_unit, has_extension.interactable_type)) then
				return false
			end

			return true
		end
	},
	{
		"friendly_hero_player",
		function (arg_12_0, arg_12_1, arg_12_2)
			-- function 12
			local flag = not arg_12_2 and Managers.player:owner(arg_12_2)

			if not flag then
				return false
			end

			if flag.player_unit == arg_12_1.player_unit then
				return false
			end

			local var_12_1 = Managers.state.side.side_by_unit[arg_12_1.player_unit]

			if var_12_1:name() ~= "heroes" then
				return false
			end

			local var_12_2 = Managers.state.side.side_by_unit[flag.player_unit]

			return not Managers.state.side:is_enemy_by_side(var_12_1, var_12_2)
		end
	},
	{
		"enemy_hero_player",
		function (arg_13_0, arg_13_1, arg_13_2)
			-- function 13
			local flag = not arg_13_2 and Managers.player:owner(arg_13_2)

			if not flag then
				return false
			end

			local var_13_1 = Managers.state.side.side_by_unit[arg_13_1.player_unit]

			if var_13_1:name() ~= "dark_pact" then
				return false
			end

			local var_13_2 = Managers.state.side.side_by_unit[flag.player_unit]

			return Managers.state.side:is_enemy_by_side(var_13_1, var_13_2)
		end
	}
}

local tbl = {
	{
		text = "social_wheel_pose_test_01",
		name = "social_wheel_general_pose_01",
		icon = "radial_chat_icon_thank_you",
		execute_func = fn_5,
		is_valid_func = fn_9,
		data = {
			anim_event = "anim_pose_01",
			hide_weapons = false,
			pose_index = 1
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_test_02",
		name = "social_wheel_general_pose_02",
		icon = "radial_chat_icon_thank_you",
		execute_func = fn_5,
		is_valid_func = fn_9,
		data = {
			anim_event = "anim_pose_02",
			hide_weapons = false,
			pose_index = 2
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_test_03",
		name = "social_wheel_general_pose_03",
		icon = "radial_chat_icon_thank_you",
		execute_func = fn_5,
		is_valid_func = fn_9,
		data = {
			anim_event = "anim_pose_03",
			hide_weapons = false,
			pose_index = 3
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_test_04",
		name = "social_wheel_general_pose_04",
		icon = "radial_chat_icon_thank_you",
		execute_func = fn_5,
		is_valid_func = fn_9,
		data = {
			anim_event = "anim_pose_04",
			hide_weapons = false,
			pose_index = 4
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_test_05",
		name = "social_wheel_general_pose_05",
		icon = "radial_chat_icon_thank_you",
		execute_func = fn_5,
		is_valid_func = fn_9,
		data = {
			anim_event = "anim_pose_05",
			hide_weapons = false,
			pose_index = 5
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_test_06",
		name = "social_wheel_general_pose_06",
		icon = "radial_chat_icon_thank_you",
		execute_func = fn_5,
		is_valid_func = fn_9,
		data = {
			anim_event = "anim_pose_06",
			hide_weapons = false,
			pose_index = 6
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	emotes = true
}
local tbl_2 = {
	{
		text = "social_wheel_pose_unarmed_01",
		name = "social_wheel_general_pose_unarmed_01",
		icon = "radial_chat_pose_wheel_icon_unarmed",
		execute_func = fn_5,
		data = {
			anim_event = "anim_pose_unarmed_01",
			hide_weapons = true
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_unarmed_02",
		name = "social_wheel_general_pose_unarmed_02",
		icon = "radial_chat_pose_wheel_icon_unarmed",
		execute_func = fn_5,
		data = {
			anim_event = "anim_pose_unarmed_02",
			hide_weapons = true
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_unarmed_03",
		name = "social_wheel_general_pose_unarmed_03",
		icon = "radial_chat_pose_wheel_icon_unarmed",
		execute_func = fn_5,
		data = {
			anim_event = "anim_pose_unarmed_03",
			hide_weapons = true
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_unarmed_04",
		name = "social_wheel_general_pose_unarmed_04",
		icon = "radial_chat_pose_wheel_icon_unarmed",
		execute_func = fn_5,
		data = {
			anim_event = "anim_pose_unarmed_04",
			hide_weapons = true
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_unarmed_05",
		name = "social_wheel_general_pose_unarmed_05",
		icon = "radial_chat_pose_wheel_icon_unarmed",
		execute_func = fn_5,
		data = {
			anim_event = "anim_pose_unarmed_05",
			hide_weapons = true
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	{
		text = "social_wheel_pose_unarmed_06",
		name = "social_wheel_general_pose_unarmed_06",
		icon = "radial_chat_pose_wheel_icon_unarmed",
		execute_func = fn_5,
		data = {
			anim_event = "anim_pose_unarmed_06",
			hide_weapons = true
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	emotes = true
}

local function fn_11(arg_14_0, arg_14_1)
	-- function 14
	local clone = table.clone(arg_14_0)

	for i = 1, #clone do
		clone[i].name = clone[i].name .. arg_14_1
	end

	return clone
end

local var_0_13 = fn_11(tbl, "_gp")
local var_0_14 = fn_11(tbl_2, "_gp")
local var_0_15 = fn_11(tbl_2, "_gp_versus")

SocialWheelSettings = {
	general = {
		angle = 1.7 * math.pi,
		size = {
			500,
			250
		},
		{
			{
				text = "social_wheel_general_no",
				event_text = "social_wheel_general_no",
				name = "social_wheel_general_no",
				icon = "radial_chat_icon_no",
				vo_event_name = "vw_negation",
				data = {},
				ping_type = PingTypes.DENY
			},
			{
				text = "social_wheel_general_come_here",
				event_text = "social_wheel_general_come_here",
				name = "social_wheel_general_come_here",
				icon = "radial_chat_icon_come_here",
				vo_event_name = "vw_gather",
				data = {},
				ping_type = PingTypes.MOVEMENTY_COME_HERE
			},
			{
				text = "social_wheel_general_patrol",
				event_text = "social_wheel_general_patrol",
				name = "social_wheel_general_patrol",
				icon = "radial_chat_icon_patrol",
				vo_event_name = "vw_patrol",
				data = {},
				ping_type = PingTypes.ENEMY_PATROL
			},
			{
				text = "social_wheel_general_help",
				event_text = "social_wheel_general_help",
				name = "social_wheel_general_help",
				icon = "radial_chat_icon_help",
				vo_event_name = "vw_help",
				data = {},
				ping_type = PingTypes.PLAYER_HELP
			},
			{
				text = "social_wheel_general_boss",
				event_text = "social_wheel_general_boss",
				name = "social_wheel_general_boss",
				icon = "radial_chat_icon_boss",
				vo_event_name = "vw_boss",
				data = {},
				ping_type = PingTypes.ENEMY_BOSS
			},
			{
				text = "social_wheel_general_thank_you",
				event_text = "social_wheel_general_thank_you",
				name = "social_wheel_general_thank_you",
				icon = "radial_chat_icon_thank_you",
				vo_event_name = "vw_thank_you",
				data = {},
				ping_type = PingTypes.PLAYER_THANK_YOU
			},
			{
				text = "social_wheel_general_yes",
				event_text = "social_wheel_general_yes",
				name = "social_wheel_general_yes",
				icon = "radial_chat_icon_yes",
				vo_event_name = "vw_affirmative",
				data = {},
				ping_type = PingTypes.ACKNOWLEDGE
			}
		},
		tbl_2,
		wedge_adjustment = 0.85,
		has_pages = true,
		individual_bg = true
	},
	general_gamepad = {
		angle = 2 * math.pi,
		size = {
			250,
			250
		},
		{
			{
				text = "social_wheel_general_no",
				event_text = "social_wheel_general_no",
				name = "social_wheel_general_no_gp",
				icon = "radial_chat_icon_no",
				data = {}
			},
			{
				text = "social_wheel_general_come_here",
				event_text = "social_wheel_general_come_here",
				name = "social_wheel_general_come_here_gp",
				icon = "radial_chat_icon_come_here",
				data = {}
			},
			{
				text = "social_wheel_general_patrol",
				event_text = "social_wheel_general_patrol",
				name = "social_wheel_general_patrol_gp",
				icon = "radial_chat_icon_patrol",
				data = {}
			},
			{
				text = "social_wheel_general_help",
				event_text = "social_wheel_general_help",
				name = "social_wheel_general_help_gp",
				icon = "radial_chat_icon_help",
				data = {}
			},
			{
				text = "social_wheel_general_boss",
				event_text = "social_wheel_general_boss",
				name = "social_wheel_general_boss_gp",
				icon = "radial_chat_icon_boss",
				data = {}
			},
			{
				text = "social_wheel_general_thank_you",
				event_text = "social_wheel_general_thank_you",
				name = "social_wheel_general_thank_you_gp",
				icon = "radial_chat_icon_thank_you",
				data = {}
			},
			{
				text = "social_wheel_general_yes",
				event_text = "social_wheel_general_yes",
				name = "social_wheel_general_yes_gp",
				icon = "radial_chat_icon_yes",
				data = {}
			}
		},
		var_0_14,
		wedge_adjustment = 0.85,
		has_pages = true,
		individual_bg = false
	},
	item = {
		size = {
			250,
			250
		},
		angle = math.pi * 2,
		{
			text = "witch_hunter_short",
			name = "social_wheel_item_pick_up_witch_hunter",
			icon = "radial_chat_icon_saltzpyre",
			data = "witch_hunter",
			event_text_func = fn_2,
			execute_func = fn_4,
			is_valid_func = fn_8,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		{
			text = "bright_wizard_short",
			name = "social_wheel_item_pick_up_bright_wizard",
			icon = "radial_chat_icon_sienna",
			data = "bright_wizard",
			event_text_func = fn_2,
			execute_func = fn_4,
			is_valid_func = fn_8,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		{
			text = "dwarf_ranger_short",
			name = "social_wheel_item_pick_up_dwarf_ranger",
			icon = "radial_chat_icon_bardin",
			data = "dwarf_ranger",
			event_text_func = fn_2,
			execute_func = fn_4,
			is_valid_func = fn_8,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		{
			text = "wood_elf_short",
			name = "social_wheel_item_pick_up_wood_elf",
			icon = "radial_chat_icon_kerillian",
			data = "wood_elf",
			event_text_func = fn_2,
			execute_func = fn_4,
			is_valid_func = fn_8,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		{
			text = "empire_soldier_short",
			name = "social_wheel_item_pick_up_empire_soldier",
			icon = "radial_chat_icon_kruber",
			data = "empire_soldier",
			event_text_func = fn_2,
			execute_func = fn_4,
			is_valid_func = fn_8,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		wedge_adjustment = 0.9,
		ping = true
	},
	friendly_hero_player = {
		size = {
			250,
			250
		},
		angle = math.pi,
		{
			text = "social_wheel_player_drop_grimoire",
			name = "social_wheel_player_drop_grimoire",
			icon = "radial_chat_icon_drop_grimoire",
			data = "grimoire",
			event_text_func = fn_3,
			execute_func = fn_6,
			is_valid_func = fn_7,
			ping_type = PingTypes.CHAT_ONLY
		},
		wedge_adjustment = 1,
		ping = false
	},
	versus_heroes_gamepad = {
		angle = 2 * math.pi,
		size = {
			250,
			250
		},
		validation_function = function ()
			-- function 15
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				return false
			end

			local game_mode_key = Managers.state.game_mode:game_mode_key()

			return MechanismSettings[Managers.mechanism:current_mechanism_name()].gamemode_lookup.default == game_mode_key
		end,
		{
			{
				text = "social_wheel_heroes_general_help",
				event_text = "social_wheel_heroes_general_help",
				name = "social_wheel_heroes_general_help",
				ping_sound_effect = "versus_ping_marker_imminent",
				vo_event_name = "vw_cover_me",
				icon = "radial_chat_icon_help",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "social_wheel_heroes_general_need_ammunition",
				event_text = "social_wheel_heroes_general_need_ammunition",
				name = "social_wheel_heroes_general_need_ammunition",
				ping_sound_effect = "versus_ping_marker_communication",
				icon = "radial_chat_icon_need_ammo",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "social_wheel_heroes_general_come_here",
				event_text = "social_wheel_heroes_general_come_here",
				name = "social_wheel_heroes_general_come_here",
				ping_sound_effect = "versus_ping_marker_tactical",
				vo_event_name = "vw_gather",
				icon = "radial_chat_icon_come_here",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "social_wheel_heroes_general_yes",
				event_text = "social_wheel_heroes_general_yes",
				name = "social_wheel_heroes_general_yes",
				ping_sound_effect = "versus_ping_marker_communication",
				vo_event_name = "vw_affirmative",
				icon = "radial_chat_icon_yes",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "social_wheel_heroes_general_thank_you",
				event_text = "social_wheel_heroes_general_thank_you",
				name = "social_wheel_heroes_general_thank_you",
				ping_sound_effect = "versus_ping_marker_communication",
				vo_event_name = "vw_thank_you",
				icon = "radial_chat_icon_thank_you",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "social_wheel_heroes_general_no",
				event_text = "social_wheel_heroes_general_no",
				name = "social_wheel_heroes_general_no",
				ping_sound_effect = "versus_ping_marker_communication_no",
				vo_event_name = "vw_negation",
				icon = "radial_chat_icon_no",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "social_wheel_heroes_general_boss",
				event_text = "social_wheel_heroes_general_boss",
				name = "social_wheel_heroes_general_boss",
				ping_sound_effect = "versus_ping_marker_imminent",
				icon = "radial_chat_icon_boss",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "social_wheel_heroes_general_need_healing",
				event_text = "social_wheel_heroes_general_need_healing",
				name = "social_wheel_heroes_general_need_healing",
				ping_sound_effect = "versus_ping_marker_communication",
				icon = "radial_chat_icon_need_healing",
				data = {},
				ping_type = PingTypes.VO_ONLY
			}
		},
		var_0_15,
		wedge_adjustment = 0.85,
		has_pages = true,
		individual_bg = false
	},
	dark_pact_gamepad = {
		angle = 2 * math.pi,
		size = {
			250,
			250
		},
		validation_function = function ()
			-- function 16
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				return false
			end

			local game_mode_key = Managers.state.game_mode:game_mode_key()

			return MechanismSettings[Managers.mechanism:current_mechanism_name()].gamemode_lookup.default == game_mode_key
		end,
		{
			{
				text = "vs_social_wheel_dark_pact_general_attack",
				event_text = "vs_social_wheel_dark_pact_general_attack",
				name = "vs_social_wheel_dark_pact_general_attack",
				ping_sound_effect = "versus_ping_marker_imminent",
				vo_event_name = "vw_attack_now",
				icon = "radial_chat_icon_attack",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "vs_social_wheel_dark_pact_general_ready",
				event_text = "vs_social_wheel_dark_pact_general_ready",
				name = "vs_social_wheel_dark_pact_general_ready",
				ping_sound_effect = "versus_ping_marker_tactical",
				vo_event_name = "vw_affirmative",
				icon = "radial_chat_icon_ready",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "vs_social_wheel_dark_pact_general_group_up",
				event_text = "vs_social_wheel_dark_pact_general_group_up",
				name = "vs_social_wheel_dark_pact_general_group_up",
				ping_sound_effect = "versus_ping_marker_tactical",
				vo_event_name = "vw_gather",
				icon = "radial_chat_icon_gather",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "vs_social_wheel_dark_pact_general_yes",
				event_text = "vs_social_wheel_dark_pact_general_yes",
				name = "vs_social_wheel_dark_pact_general_yes",
				ping_sound_effect = "versus_ping_marker_communication",
				vo_event_name = "vw_affirmative",
				icon = "radial_chat_icon_yes",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "social_wheel_dark_pact_general_thank_you",
				event_text = "social_wheel_dark_pact_general_thank_you",
				name = "social_wheel_dark_pact_general_thank_you",
				ping_sound_effect = "versus_ping_marker_communication",
				vo_event_name = "vw_thank_you",
				icon = "radial_chat_icon_thank_you",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "vs_social_wheel_dark_pact_general_no",
				event_text = "vs_social_wheel_dark_pact_general_no",
				name = "vs_social_wheel_dark_pact_general_no",
				ping_sound_effect = "versus_ping_marker_communication",
				vo_event_name = "vw_negation",
				icon = "radial_chat_icon_no",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "vs_social_wheel_dark_pact_general_cover_me",
				event_text = "vs_social_wheel_dark_pact_general_cover_me",
				name = "vs_social_wheel_dark_pact_general_cover_me",
				ping_sound_effect = "versus_ping_marker_tactical",
				vo_event_name = "vw_cover_me",
				icon = "radial_chat_icon_cover",
				data = {},
				ping_type = PingTypes.VO_ONLY
			},
			{
				text = "vs_social_wheel_dark_pact_general_wait",
				event_text = "vs_social_wheel_dark_pact_general_wait",
				name = "vs_social_wheel_dark_pact_general_wait",
				ping_sound_effect = "versus_ping_marker_tactical",
				vo_event_name = "vw_wait",
				icon = "radial_chat_icon_wait",
				data = {},
				ping_type = PingTypes.VO_ONLY
			}
		},
		wedge_adjustment = 0.85,
		has_pages = true,
		individual_bg = false
	},
	enemy_hero_player = {
		angle = 2 * math.pi,
		size = {
			250,
			250
		},
		validation_function = function ()
			-- function 17
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				return false
			end

			local game_mode_key = Managers.state.game_mode:game_mode_key()

			return MechanismSettings[Managers.mechanism:current_mechanism_name()].gamemode_lookup.default == game_mode_key
		end,
		{
			{
				icon = "radial_chat_icon_ambush",
				vo_event_name = "vw_ambush",
				event_text = "vs_social_wheel_dark_pact_general_ambush",
				ping_sound_effect = "versus_ping_marker_imminent",
				name = "vs_social_wheel_dark_pact_player_ambush",
				text = "vs_social_wheel_dark_pact_general_ambush",
				event_text_func = fn_10,
				data = {},
				ping_type = PingTypes.ENEMY_AMBUSH
			},
			{
				icon = "radial_chat_icon_cover",
				vo_event_name = "vw_cover_me",
				event_text = "vs_social_wheel_dark_pact_player_cover_me",
				ping_sound_effect = "versus_ping_marker_tactical",
				name = "vs_social_wheel_dark_pact_player_cover_me",
				text = "vs_social_wheel_dark_pact_general_cover_me",
				event_text_func = fn_10,
				data = {},
				ping_type = PingTypes.PLAYER_COVER_ME
			},
			{
				icon = "radial_chat_icon_attack",
				vo_event_name = "vw_attack_now",
				event_text = "vs_social_wheel_dark_pact_general_attack",
				ping_sound_effect = "versus_ping_marker_imminent",
				name = "vs_social_wheel_dark_pact_player_attack",
				text = "vs_social_wheel_dark_pact_general_attack",
				event_text_func = fn_10,
				data = {},
				ping_type = PingTypes.ENEMY_ATTACK
			}
		},
		{},
		wedge_adjustment = 0.85,
		has_pages = true,
		individual_bg = false
	}
}

DLCUtils.dofile("social_wheel_settings")

for k, v in pairs(SocialWheelSettings) do
	for i, v_2 in ipairs(v) do
		v_2.index = i
		v_2.category_name = k
	end
end

if not rawget(_G, "SocialWheelSettingsLookup") then
	SocialWheelSettingsLookup = {}

	for k_2, v_3 in pairs(SocialWheelSettings) do
		if not v_3.has_pages then
			for i6 = 1, #v_3 do
				for i_2, v_4 in ipairs(v_3[i6]) do
					local name = v_4.name

					name = name or settings.category_name

					fassert(SocialWheelSettingsLookup[name] == nil, "You have a duplicate entry in SocialWheelSettings (%s), each entry must have a unique name!", name)

					SocialWheelSettingsLookup[name] = v_4
				end
			end
		else
			for i_3, v_5 in ipairs(v_3) do
				local name_2 = v_5.name

				name_2 = name_2 or v_5.category_name

				fassert(SocialWheelSettingsLookup[name_2] == nil, "You have a duplicate entry in SocialWheelSettings (%s), each entry must have a unique name!", name_2)

				SocialWheelSettingsLookup[name_2] = v_5
			end
		end
	end

	SocialWheelSettingsNetworkLookupBase = {
		"n/a"
	}

	local num = 13

	for i11 = 1, num do
		SocialWheelSettingsNetworkLookupBase[#SocialWheelSettingsNetworkLookupBase + 1] = string.format("social_wheel_weapon_pose_general_pose_%02d", i11)
	end
end

return {
	functions = {
		play_emote = fn_5,
		is_weapon_pose_available = fn_9,
		clone_wheel_settings = fn_11
	}
}
