-- chunkname: @scripts/settings/razer_chroma_settings.lua

RazerChromaSettings = {
	health_potion = {
		length = 2,
		file_path = "razer_chromas/healthpotion"
	},
	cooldown_reduction_potion = {
		length = 2,
		file_path = "razer_chromas/concentrationpotion"
	},
	cooldown_reduction_potion_increased = {
		length = 2,
		file_path = "razer_chromas/concentrationpotion"
	},
	cooldown_reduction_potion_reduced = {
		length = 2,
		file_path = "razer_chromas/concentrationpotion"
	},
	speed_boost_potion = {
		length = 2,
		file_path = "razer_chromas/speedpotion"
	},
	speed_boost_potion_increased = {
		length = 2,
		file_path = "razer_chromas/speedpotion"
	},
	speed_boost_potion_reduced = {
		length = 2,
		file_path = "razer_chromas/speedpotion"
	},
	damage_boost_potion = {
		length = 2,
		file_path = "razer_chromas/damagepotion"
	},
	damage_boost_potion_increased = {
		length = 2,
		file_path = "razer_chromas/damagepotion"
	},
	damage_boost_potion_reduced = {
		length = 2,
		file_path = "razer_chromas/damagepotion"
	},
	hit = {
		file_path = "razer_chromas/hit",
		length = 0.3,
		condition_play_func = function (self)
			-- function 1
			if self.current_animation == "hit" then
				return false
			end

			local network = Managers.state.network

			network = not network and Managers.state.network:game()

			if not network then
				return false
			end

			local local_player = Managers.player:local_player()

			if not local_player then
				return false
			end

			local player_unit = local_player.player_unit

			if not Unit.alive(player_unit) then
				return false
			end

			local extension = ScriptUnit.extension(player_unit, "health_system")
			local recently_damaged, var_1_5 = extension:recently_damaged()
			local recent_damages, var_1_7 = extension:recent_damages()

			return not recently_damaged and not table.contains(NetworkLookup.damage_sources, recently_damaged), false, RAZER_ADD_ANIMATION_TYPE.REPLACE
		end
	},
	knocked_down = {
		file_path = "razer_chromas/knockeddown",
		length = 1.2,
		condition_play_func = function (self)
			-- function 2
			if self.current_animation == "knocked_down" then
				return false
			end

			local network = Managers.state.network

			network = not network and Managers.state.network:game()

			if not network then
				return false
			end

			local local_player = Managers.player:local_player()

			if not local_player then
				return false
			end

			local player_unit = local_player.player_unit

			if not Unit.alive(player_unit) then
				return false
			end

			local player_unit_2 = local_player.player_unit

			if not Unit.alive(player_unit_2) then
				local extension = ScriptUnit.extension(player_unit_2, "status_system")

				if extension.knocked_down or not extension:is_ready_for_assisted_respawn() then
					return true, true, RAZER_ADD_ANIMATION_TYPE.REPLACE
				end
			else
				return true, true, RAZER_ADD_ANIMATION_TYPE.REPLACE
			end

			return false
		end,
		condition_stop_func = function (arg_3_0)
			-- function 3
			local network = Managers.state.network

			network = not network and Managers.state.network:game()

			if not network then
				return true
			end

			local local_player = Managers.player:local_player()

			if not local_player then
				return true
			end

			local player_unit = local_player.player_unit

			if not Unit.alive(player_unit) then
				return true
			end

			local player_unit_2 = local_player.player_unit

			if not Unit.alive(player_unit_2) then
				local extension = ScriptUnit.extension(player_unit_2, "status_system")

				if extension.knocked_down or not extension:is_ready_for_assisted_respawn() then
					return false
				end
			else
				return false
			end

			return true
		end
	}
}
