-- chunkname: @scripts/settings/mutators/mutator_metal.lua

local var_0_0 = {
	skaven_ratling_gunner = true,
	skaven_stormfiend = true,
	skaven_storm_vermin_with_shield = true,
	chaos_warrior = true,
	chaos_bulwark = true,
	skaven_warpfire_thrower = true,
	beastmen_bestigor = true,
	beastmen_standard_bearer = true,
	skaven_storm_vermin_commander = true,
	skaven_storm_vermin = true,
	skaven_storm_vermin_champion = true
}

return {
	display_name = "weaves_metal_mutator_name",
	description = "weaves_metal_mutator_desc",
	icon = "icon_wind_chamon",
	primary_armor_category = 6,
	modify_primary_armor_category_breeds = {
		"skaven_storm_vermin",
		"skaven_storm_vermin_champion",
		"skaven_storm_vermin_commander",
		"skaven_storm_vermin_with_shield",
		"skaven_stormfiend",
		"skaven_ratling_gunner",
		"skaven_warpfire_thrower",
		"chaos_warrior",
		"chaos_bulwark",
		"beastmen_bestigor",
		"beastmen_standard_bearer"
	},
	server_players_left_safe_zone = function(arg_1_0, arg_1_1)
		arg_1_1.has_left_safe_zone = true
	end,
	server_ai_killed_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = Unit.get_data(arg_2_2, "breed")
		local var_2_1 = Unit.get_data(arg_2_3, "breed")

		if var_2_1 and var_2_0 and var_0_0[var_2_0.name] and var_2_1.is_hero then
			if var_2_0.name == "skaven_stormfiend" then
				local var_2_2 = Managers.player:players()

				for iter_2_0, iter_2_1 in pairs(var_2_2) do
					local var_2_3 = iter_2_1.player_unit

					if HEALTH_ALIVE[var_2_3] then
						arg_2_1.buff_system:add_buff(var_2_3, "mutator_metal_blade_dance", var_2_3)
					end
				end
			else
				arg_2_1.buff_system:add_buff(arg_2_3, "mutator_metal_blade_dance", arg_2_3)
			end
		end
	end,
	server_start_function = function(arg_3_0, arg_3_1)
		arg_3_1.wind_strength = Managers.weave:get_wind_strength()
		arg_3_1.buff_system = Managers.state.entity:system("buff_system")
	end,
	client_start_function = function(arg_4_0, arg_4_1)
		arg_4_1.buff_challenge_counter = 0
		arg_4_1.buff_challenge_result = 0
		arg_4_1.player = Managers.player:local_player()
		arg_4_1.player_unit = nil
		arg_4_1.unit_buff_extension = nil

		if ScorpionSeasonalSettings.current_season_id == 1 then
			local var_4_0 = Managers.player:statistics_db()
			local var_4_1 = arg_4_1.player:stats_id()

			arg_4_1.buff_challenge_result = var_4_0:get_persistent_stat(var_4_1, "season_1", "scorpion_weaves_metal_season_1")
		end
	end,
	player_has_metal_buff = function(arg_5_0, arg_5_1)
		if not arg_5_0.unit_buff_extension then
			arg_5_0.unit_buff_extension = ScriptUnit.has_extension(arg_5_1, "buff_system")
		end

		return arg_5_0.unit_buff_extension and arg_5_0.unit_buff_extension:has_buff_type("mutator_metal_blade_dance")
	end,
	server_update_function = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if not arg_6_1.has_left_safe_zone then
			return
		end
	end,
	client_update_function = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		if arg_7_1.buff_challenge_result < 1 then
			if not arg_7_1.player_unit then
				arg_7_1.player_unit = arg_7_1.player.player_unit
			end

			if ScorpionSeasonalSettings.current_season_id == 1 then
				if arg_7_1.template.player_has_metal_buff(arg_7_1, arg_7_1.player_unit) then
					arg_7_1.buff_challenge_counter = arg_7_1.buff_challenge_counter + arg_7_2

					if arg_7_1.buff_challenge_counter >= QuestSettings.bladestorm_duration then
						local var_7_0 = Managers.player:statistics_db()
						local var_7_1 = arg_7_1.player:stats_id()

						var_7_0:set_stat(var_7_1, "season_1", "scorpion_weaves_metal_season_1", 1)

						arg_7_1.buff_challenge_result = 1
					end
				else
					arg_7_1.buff_challenge_counter = 0
				end
			end
		end
	end
}
