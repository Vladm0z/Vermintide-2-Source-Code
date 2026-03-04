-- chunkname: @scripts/ui/views/positive_reinforcement_ui_event_settings.lua

return {
	save = {
		text_function = function (arg_1_0, arg_1_1, arg_1_2)
			if arg_1_0 > 1 then
				return string.format(Localize("positive_reinforcement_player_saved_player_multiple"), arg_1_1, arg_1_2, arg_1_0)
			else
				return string.format(Localize("positive_reinforcement_player_saved_player"), arg_1_1, arg_1_2)
			end
		end,
		sound_function = function ()
			return script_data.reinforcement_ui_local_sound or "hud_achievement_unlock_02" or script_data.enable_reinforcement_ui_remote_sound and "hud_info"
		end,
		icon_function = function (arg_3_0, arg_3_1)
			return arg_3_0, "reinforcement_saved", arg_3_1
		end
	},
	revive = {
		text_function = function (arg_4_0, arg_4_1, arg_4_2)
			if arg_4_0 > 1 then
				return string.format(Localize("positive_reinforcement_player_revived_player_multiple"), arg_4_1, arg_4_2, arg_4_0)
			else
				return string.format(Localize("positive_reinforcement_player_revived_player"), arg_4_1, arg_4_2)
			end
		end,
		sound_function = function ()
			return script_data.reinforcement_ui_local_sound or "hud_achievement_unlock_02" or script_data.enable_reinforcement_ui_remote_sound and "hud_info"
		end,
		icon_function = function (arg_6_0, arg_6_1)
			return arg_6_0, "reinforcement_revive", arg_6_1
		end
	},
	assisted_respawn = {
		text_function = function (arg_7_0, arg_7_1, arg_7_2)
			if arg_7_0 > 1 then
				return string.format(Localize("positive_reinforcement_player_rescued_player_multiple"), arg_7_1, arg_7_2, arg_7_0)
			else
				return string.format(Localize("positive_reinforcement_player_rescued_player"), arg_7_1, arg_7_2)
			end
		end,
		sound_function = function ()
			return script_data.reinforcement_ui_local_sound or "hud_achievement_unlock_02" or script_data.enable_reinforcement_ui_remote_sound and "hud_info"
		end,
		icon_function = function (arg_9_0, arg_9_1)
			return arg_9_0, "reinforcement_assisted_respawn", arg_9_1
		end
	},
	killed_special = {
		text_function = function (arg_10_0, arg_10_1, arg_10_2)
			if arg_10_0 > 1 then
				return string.format(Localize("positive_reinforcement_player_killed_special_multiple"), arg_10_1, Localize(arg_10_2), arg_10_0)
			else
				return string.format(Localize("positive_reinforcement_player_killed_special"), arg_10_1, Localize(arg_10_2))
			end
		end,
		sound_function = function ()
			return nil
		end,
		icon_function = function (arg_12_0, arg_12_1)
			return arg_12_0, "reinforcement_kill", arg_12_1
		end
	},
	player_killed = {
		text_function = function (arg_13_0, arg_13_1, arg_13_2)
			if arg_13_0 > 1 then
				return string.format(Localize("positive_reinforcement_player_killed_special_multiple"), arg_13_1, Localize(arg_13_2), arg_13_0)
			else
				return string.format(Localize("positive_reinforcement_player_killed_special"), arg_13_1, Localize(arg_13_2))
			end
		end,
		sound_function = function ()
			return nil
		end,
		icon_function = function (arg_15_0, arg_15_1)
			return arg_15_0, "reinforcement_kill", arg_15_1
		end
	},
	player_knocked_down = {
		text_function = function (arg_16_0, arg_16_1, arg_16_2)
			if arg_16_0 > 1 then
				return string.format(Localize("positive_reinforcement_player_killed_special_multiple"), arg_16_1, Localize(arg_16_2), arg_16_0)
			else
				return string.format(Localize("positive_reinforcement_player_killed_special"), arg_16_1, Localize(arg_16_2))
			end
		end,
		sound_function = function ()
			return nil
		end,
		icon_function = function (arg_18_0, arg_18_1)
			return arg_18_0, "killfeed_icon_12", arg_18_1
		end
	},
	dealing_damage = {
		text_function = function (arg_19_0, arg_19_1, arg_19_2)
			if arg_19_0 > 5 then
				return string.format(Localize("positive_reinforcement_player_killed_special_multiple"), arg_19_1, Localize(arg_19_2), arg_19_0)
			else
				return string.format(Localize("positive_reinforcement_player_killed_special"), arg_19_1, Localize(arg_19_2))
			end
		end,
		sound_function = function ()
			return "hud_achievement_unlock_02"
		end,
		icon_function = function (arg_21_0, arg_21_1)
			return arg_21_0, "reinforcement_kill", arg_21_1
		end
	},
	collected_isha_reward = {
		sound_function = function ()
			return script_data.reinforcement_ui_local_sound or "hud_achievement_unlock_02" or script_data.enable_reinforcement_ui_remote_sound and "hud_info"
		end,
		icon_function = function (arg_23_0, arg_23_1)
			return nil, "killfeed_icon_isha", arg_23_1
		end
	},
	collected_grimnir_reward = {
		sound_function = function ()
			return script_data.reinforcement_ui_local_sound or "hud_achievement_unlock_02" or script_data.enable_reinforcement_ui_remote_sound and "hud_info"
		end,
		icon_function = function (arg_25_0, arg_25_1)
			return nil, "killfeed_icon_grimnir", arg_25_1
		end
	}
}
