-- chunkname: @scripts/ui/views/positive_reinforcement_ui_event_settings.lua

return {
	save = {
		text_function = function (amount, player_1_name, player_2_name)
			-- function 1
			if amount > 1 then
				return string.format(Localize("positive_reinforcement_player_saved_player_multiple"), player_1_name, player_2_name, amount)
			else
				return string.format(Localize("positive_reinforcement_player_saved_player"), player_1_name, player_2_name)
			end
		end,
		sound_function = function ()
			-- function 2
			local reinforcement_ui_local_sound = script_data.reinforcement_ui_local_sound

			if not reinforcement_ui_local_sound then
				reinforcement_ui_local_sound = "hud_achievement_unlock_02"
			end

			if false then
				reinforcement_ui_local_sound = script_data.enable_reinforcement_ui_remote_sound
				reinforcement_ui_local_sound = not not reinforcement_ui_local_sound and not not "hud_info"
			end

			return reinforcement_ui_local_sound
		end,
		icon_function = function (image_1, image_2)
			-- function 3
			return image_1, "reinforcement_saved", image_2
		end
	},
	revive = {
		text_function = function (amount, player_1_name, player_2_name)
			-- function 4
			if amount > 1 then
				return string.format(Localize("positive_reinforcement_player_revived_player_multiple"), player_1_name, player_2_name, amount)
			else
				return string.format(Localize("positive_reinforcement_player_revived_player"), player_1_name, player_2_name)
			end
		end,
		sound_function = function ()
			-- function 5
			local reinforcement_ui_local_sound = script_data.reinforcement_ui_local_sound

			if not reinforcement_ui_local_sound then
				reinforcement_ui_local_sound = "hud_achievement_unlock_02"
			end

			if false then
				reinforcement_ui_local_sound = script_data.enable_reinforcement_ui_remote_sound
				reinforcement_ui_local_sound = not not reinforcement_ui_local_sound and not not "hud_info"
			end

			return reinforcement_ui_local_sound
		end,
		icon_function = function (image_1, image_2)
			-- function 6
			return image_1, "reinforcement_revive", image_2
		end
	},
	assisted_respawn = {
		text_function = function (amount, player_1_name, player_2_name)
			-- function 7
			if amount > 1 then
				return string.format(Localize("positive_reinforcement_player_rescued_player_multiple"), player_1_name, player_2_name, amount)
			else
				return string.format(Localize("positive_reinforcement_player_rescued_player"), player_1_name, player_2_name)
			end
		end,
		sound_function = function ()
			-- function 8
			local reinforcement_ui_local_sound = script_data.reinforcement_ui_local_sound

			if not reinforcement_ui_local_sound then
				reinforcement_ui_local_sound = "hud_achievement_unlock_02"
			end

			if false then
				reinforcement_ui_local_sound = script_data.enable_reinforcement_ui_remote_sound
				reinforcement_ui_local_sound = not not reinforcement_ui_local_sound and not not "hud_info"
			end

			return reinforcement_ui_local_sound
		end,
		icon_function = function (image_1, image_2)
			-- function 9
			return image_1, "reinforcement_assisted_respawn", image_2
		end
	},
	killed_special = {
		text_function = function (amount, player_name, breed_name)
			-- function 10
			if amount > 1 then
				return string.format(Localize("positive_reinforcement_player_killed_special_multiple"), player_name, Localize(breed_name), amount)
			else
				return string.format(Localize("positive_reinforcement_player_killed_special"), player_name, Localize(breed_name))
			end
		end,
		sound_function = function ()
			-- function 11
			return nil
		end,
		icon_function = function (image_1, image_2)
			-- function 12
			return image_1, "reinforcement_kill", image_2
		end
	},
	player_killed = {
		text_function = function (amount, player_name, breed_name)
			-- function 13
			if amount > 1 then
				return string.format(Localize("positive_reinforcement_player_killed_special_multiple"), player_name, Localize(breed_name), amount)
			else
				return string.format(Localize("positive_reinforcement_player_killed_special"), player_name, Localize(breed_name))
			end
		end,
		sound_function = function ()
			-- function 14
			return nil
		end,
		icon_function = function (image_1, image_2)
			-- function 15
			return image_1, "reinforcement_kill", image_2
		end
	},
	player_knocked_down = {
		text_function = function (amount, player_name, breed_name)
			-- function 16
			if amount > 1 then
				return string.format(Localize("positive_reinforcement_player_killed_special_multiple"), player_name, Localize(breed_name), amount)
			else
				return string.format(Localize("positive_reinforcement_player_killed_special"), player_name, Localize(breed_name))
			end
		end,
		sound_function = function ()
			-- function 17
			return nil
		end,
		icon_function = function (image_1, image_2)
			-- function 18
			return image_1, "killfeed_icon_12", image_2
		end
	},
	dealing_damage = {
		text_function = function (amount, player_name, breed_name)
			-- function 19
			if amount > 5 then
				return string.format(Localize("positive_reinforcement_player_killed_special_multiple"), player_name, Localize(breed_name), amount)
			else
				return string.format(Localize("positive_reinforcement_player_killed_special"), player_name, Localize(breed_name))
			end
		end,
		sound_function = function ()
			-- function 20
			return "hud_achievement_unlock_02"
		end,
		icon_function = function (image_1, image_2)
			-- function 21
			return image_1, "reinforcement_kill", image_2
		end
	},
	collected_isha_reward = {
		sound_function = function ()
			-- function 22
			local reinforcement_ui_local_sound = script_data.reinforcement_ui_local_sound

			if not reinforcement_ui_local_sound then
				reinforcement_ui_local_sound = "hud_achievement_unlock_02"
			end

			if false then
				reinforcement_ui_local_sound = script_data.enable_reinforcement_ui_remote_sound
				reinforcement_ui_local_sound = not not reinforcement_ui_local_sound and not not "hud_info"
			end

			return reinforcement_ui_local_sound
		end,
		icon_function = function (image_1, image_2)
			-- function 23
			return nil, "killfeed_icon_isha", image_2
		end
	},
	collected_grimnir_reward = {
		sound_function = function ()
			-- function 24
			local reinforcement_ui_local_sound = script_data.reinforcement_ui_local_sound

			if not reinforcement_ui_local_sound then
				reinforcement_ui_local_sound = "hud_achievement_unlock_02"
			end

			if false then
				reinforcement_ui_local_sound = script_data.enable_reinforcement_ui_remote_sound
				reinforcement_ui_local_sound = not not reinforcement_ui_local_sound and not not "hud_info"
			end

			return reinforcement_ui_local_sound
		end,
		icon_function = function (image_1, image_2)
			-- function 25
			return nil, "killfeed_icon_grimnir", image_2
		end
	}
}
