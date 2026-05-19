-- chunkname: @scripts/ui/social_wheel/social_wheel_ui_settings.lua

local function var_0_0(arg_1_0)
	local var_1_0 = Managers.player:players()

	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		if iter_1_1:profile_display_name() == arg_1_0 then
			return iter_1_1
		end
	end
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.data
	local var_2_1 = var_0_0(var_2_0)

	if var_2_1 then
		local var_2_2 = ScriptUnit.extension(arg_2_0, "pickup_system"):get_pickup_settings()
		local var_2_3 = FrameTable.alloc_table()
		local var_2_4

		if var_2_2.type == "ammo" then
			var_2_4 = "social_wheel_pickup_item_ammo_event"
		else
			var_2_4 = "social_wheel_pickup_item_event"

			local var_2_5 = Unit.get_data(arg_2_0, "interaction_data", "hud_description")

			var_2_3[#var_2_3 + 1] = var_2_5
		end

		local var_2_6 = var_2_1:profile_index()
		local var_2_7 = SPProfiles[var_2_6].ingame_short_display_name

		var_2_3[#var_2_3 + 1] = var_2_7

		return var_2_4, var_2_3
	end
end

local function var_0_2(arg_3_0, arg_3_1)
	local var_3_0 = Managers.player:owner(arg_3_0)

	if var_3_0 then
		local var_3_1 = "social_wheel_player_drop_event"
		local var_3_2 = arg_3_1.data
		local var_3_3 = AllPickups[var_3_2].hud_description
		local var_3_4 = var_3_0:profile_index()
		local var_3_5 = SPProfiles[var_3_4].ingame_short_display_name
		local var_3_6 = FrameTable.alloc_table()

		var_3_6[1] = var_3_3
		var_3_6[2] = var_3_5

		return var_3_1, var_3_6
	end
end

local function var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = var_0_0(arg_4_0)

	if var_4_0 and arg_4_1 then
		local var_4_1 = var_4_0.player_unit

		Managers.state.entity:system("ai_bot_group_system"):order("pickup", var_4_1, arg_4_1, arg_4_2)
	end
end

local function var_0_4(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_2 and arg_5_2.player_unit

	if var_5_0 then
		local var_5_1 = ScriptUnit.has_extension(var_5_0, "cosmetic_system")

		if var_5_1 then
			var_5_1:queue_3p_emote(arg_5_0.anim_event, arg_5_0.hide_weapons)
		end
	end
end

local function var_0_5(arg_6_0, arg_6_1, arg_6_2)
	Managers.state.entity:system("ai_bot_group_system"):order("drop", arg_6_1, arg_6_0, arg_6_2)
end

local function var_0_6(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.unit

	if not Unit.alive(var_7_0) then
		return false
	end

	local var_7_1 = AllPickups[arg_7_0].slot_name
	local var_7_2 = ScriptUnit.has_extension(var_7_0, "inventory_system")
	local var_7_3 = var_7_2:get_slot_data(var_7_1)

	if var_7_3 then
		local var_7_4 = var_7_2:get_item_template(var_7_3)

		if arg_7_0 == "grimoire" then
			return var_7_4.is_grimoire
		else
			return var_7_4.pickup_data.pickup_name == arg_7_0
		end
	else
		return false
	end
end

local function var_0_7(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.unit

	if not Unit.alive(var_8_0) then
		return false
	end

	local var_8_1 = Managers.player:local_player()
	local var_8_2 = var_0_0(arg_8_0)

	if not var_8_2 or var_8_2 == var_8_1 or not Unit.alive(var_8_2.player_unit) then
		return false
	end

	local var_8_3 = ScriptUnit.extension(var_8_2.player_unit, "status_system")

	if var_8_3:is_ready_for_assisted_respawn() or var_8_3:is_dead() then
		return false
	end

	local var_8_4 = not var_8_2:is_player_controlled()
	local var_8_5 = ScriptUnit.extension(var_8_0, "pickup_system"):get_pickup_settings()

	if var_8_4 and (var_8_5.slot_name == "slot_level_event" or var_8_5.disallow_bot_pickup) then
		return false
	else
		return true
	end
end

local function var_0_8(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.pose_index
	local var_9_1 = Managers.player:local_player().player_unit

	if not ALIVE[var_9_1] then
		return false
	end

	local var_9_2 = ScriptUnit.extension(var_9_1, "inventory_system"):get_wielded_slot_data().item_data
	local var_9_3 = var_9_2.name
	local var_9_4 = var_9_2.pose_name
	local var_9_5 = Managers.backend:get_interface("items"):get_unlocked_weapon_poses()

	return var_9_5[var_9_3] and var_9_5[var_9_3][var_9_4]
end

local function var_0_9(arg_10_0, arg_10_1)
	local var_10_0 = Managers.player:owner(arg_10_0)

	if var_10_0 then
		local var_10_1 = arg_10_1.event_text
		local var_10_2 = var_10_0:profile_index()
		local var_10_3

		var_10_3[1], var_10_3 = SPProfiles[var_10_2].ingame_short_display_name, FrameTable.alloc_table()

		return var_10_1, var_10_3
	end
end

SocialWheelPriority = {
	{
		"item",
		function(arg_11_0, arg_11_1, arg_11_2)
			if not arg_11_2 then
				return false
			end

			if not ScriptUnit.has_extension(arg_11_2, "pickup_system") then
				return false
			end

			local var_11_0 = ScriptUnit.has_extension(arg_11_2, "interactable_system")

			if not var_11_0 then
				return false
			end

			local var_11_1 = Managers.state.game_mode:game_mode()

			if var_11_1.allowed_interactions and not var_11_1:allowed_interactions(arg_11_1.player_unit, var_11_0.interactable_type) then
				return false
			end

			return true
		end
	},
	{
		"friendly_hero_player",
		function(arg_12_0, arg_12_1, arg_12_2)
			local var_12_0 = arg_12_2 and Managers.player:owner(arg_12_2)

			if not var_12_0 then
				return false
			end

			if var_12_0.player_unit == arg_12_1.player_unit then
				return false
			end

			local var_12_1 = Managers.state.side.side_by_unit[arg_12_1.player_unit]

			if var_12_1:name() ~= "heroes" then
				return false
			end

			local var_12_2 = Managers.state.side.side_by_unit[var_12_0.player_unit]

			return not Managers.state.side:is_enemy_by_side(var_12_1, var_12_2)
		end
	},
	{
		"enemy_hero_player",
		function(arg_13_0, arg_13_1, arg_13_2)
			local var_13_0 = arg_13_2 and Managers.player:owner(arg_13_2)

			if not var_13_0 then
				return false
			end

			local var_13_1 = Managers.state.side.side_by_unit[arg_13_1.player_unit]

			if var_13_1:name() ~= "dark_pact" then
				return false
			end

			local var_13_2 = Managers.state.side.side_by_unit[var_13_0.player_unit]

			return Managers.state.side:is_enemy_by_side(var_13_1, var_13_2)
		end
	}
}

local var_0_10 = {
	{
		text = "social_wheel_pose_test_01",
		name = "social_wheel_general_pose_01",
		icon = "radial_chat_icon_thank_you",
		execute_func = var_0_4,
		is_valid_func = var_0_8,
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
		execute_func = var_0_4,
		is_valid_func = var_0_8,
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
		execute_func = var_0_4,
		is_valid_func = var_0_8,
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
		execute_func = var_0_4,
		is_valid_func = var_0_8,
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
		execute_func = var_0_4,
		is_valid_func = var_0_8,
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
		execute_func = var_0_4,
		is_valid_func = var_0_8,
		data = {
			anim_event = "anim_pose_06",
			hide_weapons = false,
			pose_index = 6
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	emotes = true
}
local var_0_11 = {
	{
		text = "social_wheel_pose_unarmed_01",
		name = "social_wheel_general_pose_unarmed_01",
		icon = "radial_chat_pose_wheel_icon_unarmed",
		execute_func = var_0_4,
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
		execute_func = var_0_4,
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
		execute_func = var_0_4,
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
		execute_func = var_0_4,
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
		execute_func = var_0_4,
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
		execute_func = var_0_4,
		data = {
			anim_event = "anim_pose_unarmed_06",
			hide_weapons = true
		},
		ping_type = PingTypes.LOCAL_ONLY
	},
	emotes = true
}

local function var_0_12(arg_14_0, arg_14_1)
	local var_14_0 = table.clone(arg_14_0)

	for iter_14_0 = 1, #var_14_0 do
		var_14_0[iter_14_0].name = var_14_0[iter_14_0].name .. arg_14_1
	end

	return var_14_0
end

local var_0_13 = var_0_12(var_0_10, "_gp")
local var_0_14 = var_0_12(var_0_11, "_gp")
local var_0_15 = var_0_12(var_0_11, "_gp_versus")

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
		var_0_11,
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
			event_text_func = var_0_1,
			execute_func = var_0_3,
			is_valid_func = var_0_7,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		{
			text = "bright_wizard_short",
			name = "social_wheel_item_pick_up_bright_wizard",
			icon = "radial_chat_icon_sienna",
			data = "bright_wizard",
			event_text_func = var_0_1,
			execute_func = var_0_3,
			is_valid_func = var_0_7,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		{
			text = "dwarf_ranger_short",
			name = "social_wheel_item_pick_up_dwarf_ranger",
			icon = "radial_chat_icon_bardin",
			data = "dwarf_ranger",
			event_text_func = var_0_1,
			execute_func = var_0_3,
			is_valid_func = var_0_7,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		{
			text = "wood_elf_short",
			name = "social_wheel_item_pick_up_wood_elf",
			icon = "radial_chat_icon_kerillian",
			data = "wood_elf",
			event_text_func = var_0_1,
			execute_func = var_0_3,
			is_valid_func = var_0_7,
			ping_type = PingTypes.PLAYER_PICK_UP
		},
		{
			text = "empire_soldier_short",
			name = "social_wheel_item_pick_up_empire_soldier",
			icon = "radial_chat_icon_kruber",
			data = "empire_soldier",
			event_text_func = var_0_1,
			execute_func = var_0_3,
			is_valid_func = var_0_7,
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
			event_text_func = var_0_2,
			execute_func = var_0_5,
			is_valid_func = var_0_6,
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
		validation_function = function()
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				return false
			end

			local var_15_0 = Managers.state.game_mode:game_mode_key()

			return MechanismSettings[Managers.mechanism:current_mechanism_name()].gamemode_lookup.default == var_15_0
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
		validation_function = function()
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				return false
			end

			local var_16_0 = Managers.state.game_mode:game_mode_key()

			return MechanismSettings[Managers.mechanism:current_mechanism_name()].gamemode_lookup.default == var_16_0
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
		validation_function = function()
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				return false
			end

			local var_17_0 = Managers.state.game_mode:game_mode_key()

			return MechanismSettings[Managers.mechanism:current_mechanism_name()].gamemode_lookup.default == var_17_0
		end,
		{
			{
				icon = "radial_chat_icon_ambush",
				vo_event_name = "vw_ambush",
				event_text = "vs_social_wheel_dark_pact_general_ambush",
				ping_sound_effect = "versus_ping_marker_imminent",
				name = "vs_social_wheel_dark_pact_player_ambush",
				text = "vs_social_wheel_dark_pact_general_ambush",
				event_text_func = var_0_9,
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
				event_text_func = var_0_9,
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
				event_text_func = var_0_9,
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

for iter_0_0, iter_0_1 in pairs(SocialWheelSettings) do
	for iter_0_2, iter_0_3 in ipairs(iter_0_1) do
		iter_0_3.index = iter_0_2
		iter_0_3.category_name = iter_0_0
	end
end

if not rawget(_G, "SocialWheelSettingsLookup") then
	SocialWheelSettingsLookup = {}

	for iter_0_4, iter_0_5 in pairs(SocialWheelSettings) do
		if iter_0_5.has_pages then
			for iter_0_6 = 1, #iter_0_5 do
				for iter_0_7, iter_0_8 in ipairs(iter_0_5[iter_0_6]) do
					local var_0_16 = iter_0_8.name or settings.category_name

					fassert(SocialWheelSettingsLookup[var_0_16] == nil, "You have a duplicate entry in SocialWheelSettings (%s), each entry must have a unique name!", var_0_16)

					SocialWheelSettingsLookup[var_0_16] = iter_0_8
				end
			end
		else
			for iter_0_9, iter_0_10 in ipairs(iter_0_5) do
				local var_0_17 = iter_0_10.name or iter_0_10.category_name

				fassert(SocialWheelSettingsLookup[var_0_17] == nil, "You have a duplicate entry in SocialWheelSettings (%s), each entry must have a unique name!", var_0_17)

				SocialWheelSettingsLookup[var_0_17] = iter_0_10
			end
		end
	end

	SocialWheelSettingsNetworkLookupBase = {
		"n/a"
	}

	local var_0_18 = 13

	for iter_0_11 = 1, var_0_18 do
		SocialWheelSettingsNetworkLookupBase[#SocialWheelSettingsNetworkLookupBase + 1] = string.format("social_wheel_weapon_pose_general_pose_%02d", iter_0_11)
	end
end

return {
	functions = {
		play_emote = var_0_4,
		is_weapon_pose_available = var_0_8,
		clone_wheel_settings = var_0_12
	}
}
