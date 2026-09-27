-- chunkname: @scripts/settings/mutators/mutator_metal.lua

local tbl = {
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
	server_players_left_safe_zone = function (arg_1_0, arg_1_1)
		-- function 1
		arg_1_1.has_left_safe_zone = true
	end,
	server_ai_killed_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local get_data = Unit.get_data(arg_2_2, "breed")
		local get_data_2 = Unit.get_data(arg_2_3, "breed")

		if not get_data_2 and not get_data and not tbl[get_data.name] and not get_data_2.is_hero then
			if get_data.name == "skaven_stormfiend" then
				local players = Managers.player:players()

				for k, v in pairs(players) do
					local player_unit = v.player_unit

					if not HEALTH_ALIVE[player_unit] then
						arg_2_1.buff_system:add_buff(player_unit, "mutator_metal_blade_dance", player_unit)
					end
				end
			else
				arg_2_1.buff_system:add_buff(arg_2_3, "mutator_metal_blade_dance", arg_2_3)
			end
		end
	end,
	server_start_function = function (arg_3_0, arg_3_1)
		-- function 3
		arg_3_1.wind_strength = Managers.weave:get_wind_strength()
		arg_3_1.buff_system = Managers.state.entity:system("buff_system")
	end,
	client_start_function = function (arg_4_0, arg_4_1)
		-- function 4
		arg_4_1.buff_challenge_counter = 0
		arg_4_1.buff_challenge_result = 0
		arg_4_1.player = Managers.player:local_player()
		arg_4_1.player_unit = nil
		arg_4_1.unit_buff_extension = nil

		if ScorpionSeasonalSettings.current_season_id == 1 then
			local statistics_db = Managers.player:statistics_db()
			local stats_id = arg_4_1.player:stats_id()

			arg_4_1.buff_challenge_result = statistics_db:get_persistent_stat(stats_id, "season_1", "scorpion_weaves_metal_season_1")
		end
	end,
	player_has_metal_buff = function (self, arg_5_1)
		-- function 5
		if not self.unit_buff_extension then
			self.unit_buff_extension = ScriptUnit.has_extension(arg_5_1, "buff_system")
		end

		local unit_buff_extension = self.unit_buff_extension

		unit_buff_extension = not unit_buff_extension and self.unit_buff_extension:has_buff_type("mutator_metal_blade_dance")

		return unit_buff_extension
	end,
	server_update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not arg_6_1.has_left_safe_zone then
			return
		end
	end,
	client_update_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		if arg_7_1.buff_challenge_result < 1 then
			if not arg_7_1.player_unit then
				arg_7_1.player_unit = arg_7_1.player.player_unit
			end

			if ScorpionSeasonalSettings.current_season_id == 1 then
				if not arg_7_1.template.player_has_metal_buff(arg_7_1, arg_7_1.player_unit) then
					arg_7_1.buff_challenge_counter = arg_7_1.buff_challenge_counter + arg_7_2

					if arg_7_1.buff_challenge_counter >= QuestSettings.bladestorm_duration then
						local statistics_db = Managers.player:statistics_db()
						local stats_id = arg_7_1.player:stats_id()

						statistics_db:set_stat(stats_id, "season_1", "scorpion_weaves_metal_season_1", 1)

						arg_7_1.buff_challenge_result = 1
					end
				else
					arg_7_1.buff_challenge_counter = 0
				end
			end
		end
	end
}
