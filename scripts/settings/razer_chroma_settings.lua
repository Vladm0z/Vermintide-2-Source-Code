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
		condition_play_func = function (arg_1_0)
			if arg_1_0.current_animation == "hit" then
				return false
			end

			if not (Managers.state.network and Managers.state.network:game()) then
				return false
			end

			local var_1_0 = Managers.player:local_player()

			if not var_1_0 then
				return false
			end

			local var_1_1 = var_1_0.player_unit

			if not Unit.alive(var_1_1) then
				return false
			end

			local var_1_2 = ScriptUnit.extension(var_1_1, "health_system")
			local var_1_3, var_1_4 = var_1_2:recently_damaged()
			local var_1_5, var_1_6 = var_1_2:recent_damages()

			return var_1_3 and not table.contains(NetworkLookup.damage_sources, var_1_3), false, RAZER_ADD_ANIMATION_TYPE.REPLACE
		end
	},
	knocked_down = {
		file_path = "razer_chromas/knockeddown",
		length = 1.2,
		condition_play_func = function (arg_2_0)
			if arg_2_0.current_animation == "knocked_down" then
				return false
			end

			if not (Managers.state.network and Managers.state.network:game()) then
				return false
			end

			local var_2_0 = Managers.player:local_player()

			if not var_2_0 then
				return false
			end

			local var_2_1 = var_2_0.player_unit

			if not Unit.alive(var_2_1) then
				return false
			end

			local var_2_2 = var_2_0.player_unit

			if Unit.alive(var_2_2) then
				local var_2_3 = ScriptUnit.extension(var_2_2, "status_system")

				if var_2_3.knocked_down or var_2_3:is_ready_for_assisted_respawn() then
					return true, true, RAZER_ADD_ANIMATION_TYPE.REPLACE
				end
			else
				return true, true, RAZER_ADD_ANIMATION_TYPE.REPLACE
			end

			return false
		end,
		condition_stop_func = function (arg_3_0)
			if not (Managers.state.network and Managers.state.network:game()) then
				return true
			end

			local var_3_0 = Managers.player:local_player()

			if not var_3_0 then
				return true
			end

			local var_3_1 = var_3_0.player_unit

			if not Unit.alive(var_3_1) then
				return true
			end

			local var_3_2 = var_3_0.player_unit

			if Unit.alive(var_3_2) then
				local var_3_3 = ScriptUnit.extension(var_3_2, "status_system")

				if var_3_3.knocked_down or var_3_3:is_ready_for_assisted_respawn() then
					return false
				end
			else
				return false
			end

			return true
		end
	}
}
