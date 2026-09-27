-- chunkname: @scripts/settings/mutators/mutator_fire.lua

local tbl = {
	"chaos_corruptor_sorcerer",
	"chaos_vortex_sorcerer",
	"skaven_warpfire_thrower",
	"skaven_poison_wind_globadier",
	"skaven_ratling_gunner"
}

return {
	description = "weaves_fire_mutator_desc",
	display_name = "weaves_fire_mutator_name",
	icon = "mutator_icon_fire_burn",
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		arg_1_1.network_manager = Managers.state.network

		local fire = WindSettings.fire
		local get_wind_strength = Managers.weave:get_wind_strength()
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_1_1.buff_time_player = fire.buff_time_player[get_difficulty][get_wind_strength]
		arg_1_1.buff_time_enemy = fire.buff_time_enemy[get_difficulty][get_wind_strength]
		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.applied_buffs = {}
		arg_1_1.buff_name_player = "mutator_fire_player_dot"
		arg_1_1.buff_name_enemy = "mutator_fire_enemy_dot"
		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.boss_spawned = {}
		arg_1_1.boss_spawned_counter = 0
	end,
	client_start_function = function (arg_2_0, arg_2_1)
		-- function 2
		local weave = Managers.weave
		local get_active_wind_settings = weave:get_active_wind_settings()
		local get_wind_strength = weave:get_wind_strength()
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_2_1.buff_time_player = get_active_wind_settings.buff_time_player[get_difficulty][get_wind_strength]
		arg_2_1.buff_name_player = "mutator_fire_player_dot"
		arg_2_1.buff_name_enemy = "mutator_fire_enemy_dot"
	end,
	update_buffs = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		for k, v in pairs(arg_3_1.applied_buffs) do
			v.duration = v.duration + arg_3_2

			local unit = v.unit
			local flag = not HEALTH_ALIVE[unit]

			if v.duration > arg_3_1.buff_time_enemy or not flag then
				arg_3_1.template.remove_buff(arg_3_1, unit, k, flag)
			end
		end
	end,
	server_ai_killed_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
		-- function 4
		if not (arg_4_1.boss_spawned_counter > 0) or not arg_4_1.boss_spawned[arg_4_2] then
			arg_4_1.boss_spawned_counter = arg_4_1.boss_spawned_counter - 1
			arg_4_1.boss_spawned[arg_4_2] = nil

			if ScorpionSeasonalSettings.current_season_id == 1 then
				local buff_name_enemy = arg_4_1.buff_name_enemy
				local has_buff_type = ScriptUnit.extension(arg_4_2, "buff_system"):has_buff_type(buff_name_enemy)
				local flag = arg_4_5[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"

				if not has_buff_type and not flag then
					local str = "season_1"
					local str_2 = "scorpion_weaves_fire_season_1"
					local var_4_5 = NetworkLookup.statistics_group_name[str]
					local var_4_6 = NetworkLookup.statistics[str_2]
					local statistics_db = Managers.player:statistics_db()
					local stats_id = Managers.player:local_player():stats_id()

					statistics_db:increment_stat(stats_id, str, str_2)
					Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat_group", var_4_5, var_4_6)
				end
			end
		end
	end,
	apply_buff = function (self, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		local var_5_0 = HEALTH_ALIVE[arg_5_1]
		local buff_name_enemy

		if not arg_5_3 then
			buff_name_enemy = self.buff_name_enemy

			if not buff_name_enemy then
				-- Nothing
			end
		end

		buff_name_enemy = self.buff_name_player

		::label_5_0::

		local extension = ScriptUnit.extension(arg_5_1, "buff_system")
		local has_buff_type = extension:has_buff_type(buff_name_enemy)

		if not (not var_5_0 and has_buff_type) then
			if not arg_5_3 then
				local flag = true
				local add_buff = self.buff_system:add_buff(arg_5_1, buff_name_enemy, arg_5_1, flag)
				local unit_game_object_id = self.network_manager:unit_game_object_id(arg_5_1)

				self.applied_buffs[unit_game_object_id] = {}
				self.applied_buffs[unit_game_object_id].buff_id = add_buff
				self.applied_buffs[unit_game_object_id].unit = arg_5_1
				self.applied_buffs[unit_game_object_id].duration = 0
			else
				local buff_time_player = self.buff_time_player
				local tbl = {
					attacker_unit = arg_5_2,
					external_optional_duration = buff_time_player
				}

				extension:add_buff(buff_name_enemy, tbl)
			end
		end
	end,
	remove_buff = function (self, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not arg_6_3 then
			self.buff_system:remove_server_controlled_buff(arg_6_1, self.applied_buffs[arg_6_2].buff_id)
		end

		self.applied_buffs[arg_6_2] = nil
	end,
	unit_has_buff = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		local has_extension = ScriptUnit.has_extension(arg_7_1, "buff_system")

		return not has_extension and has_extension:has_buff_type(arg_7_2)
	end,
	check_melee = function (arg_8_0, arg_8_1)
		-- function 8
		local var_8_0 = arg_8_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_8_1 = rawget(ItemMasterList, var_8_0)

		if not var_8_1 then
			return var_8_1.slot_type == "melee"
		else
			return not table.contains(tbl, var_8_0)
		end
	end,
	server_ai_hit_by_player_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		if not (arg_9_2 == arg_9_3 or not (arg_9_4[DamageDataIndex.DAMAGE_AMOUNT] > 0)) then
			local check_melee = arg_9_1.template.check_melee(arg_9_1, arg_9_4)
			local flag = arg_9_4[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"
			local flag_2 = arg_9_4[DamageDataIndex.DAMAGE_TYPE] == "push"

			if not (not check_melee and flag or flag_2) then
				arg_9_1.template.apply_buff(arg_9_1, arg_9_2, arg_9_3, true)
			end
		end
	end,
	client_player_hit_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		if not (arg_10_2 == arg_10_3 or not (arg_10_4[DamageDataIndex.DAMAGE_AMOUNT] > 0)) then
			local flag = arg_10_4[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"

			if not (not arg_10_1.template.check_melee(arg_10_1, arg_10_4) and flag) then
				arg_10_1.template.apply_buff(arg_10_1, arg_10_2, arg_10_3, false)
			end
		end
	end,
	server_update_function = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		-- function 11
		arg_11_1.template.update_buffs(arg_11_0, arg_11_1, arg_11_2)
	end,
	server_ai_spawned_function = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		local alive_bosses = Managers.state.conflict:alive_bosses()

		if not alive_bosses and not (#alive_bosses > arg_12_1.boss_spawned_counter) or not BLACKBOARDS[arg_12_2].breed.boss then
			arg_12_1.boss_spawned[arg_12_2] = true
			arg_12_1.boss_spawned_counter = arg_12_1.boss_spawned_counter + 1
		end
	end
}
