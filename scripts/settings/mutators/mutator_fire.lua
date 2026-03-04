-- chunkname: @scripts/settings/mutators/mutator_fire.lua

local var_0_0 = {
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
		arg_1_1.network_manager = Managers.state.network

		local var_1_0 = WindSettings.fire
		local var_1_1 = Managers.weave:get_wind_strength()
		local var_1_2 = Managers.state.difficulty:get_difficulty()

		arg_1_1.buff_time_player = var_1_0.buff_time_player[var_1_2][var_1_1]
		arg_1_1.buff_time_enemy = var_1_0.buff_time_enemy[var_1_2][var_1_1]
		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.applied_buffs = {}
		arg_1_1.buff_name_player = "mutator_fire_player_dot"
		arg_1_1.buff_name_enemy = "mutator_fire_enemy_dot"
		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.boss_spawned = {}
		arg_1_1.boss_spawned_counter = 0
	end,
	client_start_function = function (arg_2_0, arg_2_1)
		local var_2_0 = Managers.weave
		local var_2_1 = var_2_0:get_active_wind_settings()
		local var_2_2 = var_2_0:get_wind_strength()
		local var_2_3 = Managers.state.difficulty:get_difficulty()

		arg_2_1.buff_time_player = var_2_1.buff_time_player[var_2_3][var_2_2]
		arg_2_1.buff_name_player = "mutator_fire_player_dot"
		arg_2_1.buff_name_enemy = "mutator_fire_enemy_dot"
	end,
	update_buffs = function (arg_3_0, arg_3_1, arg_3_2)
		for iter_3_0, iter_3_1 in pairs(arg_3_1.applied_buffs) do
			iter_3_1.duration = iter_3_1.duration + arg_3_2

			local var_3_0 = iter_3_1.unit
			local var_3_1 = not HEALTH_ALIVE[var_3_0]

			if iter_3_1.duration > arg_3_1.buff_time_enemy or var_3_1 then
				arg_3_1.template.remove_buff(arg_3_1, var_3_0, iter_3_0, var_3_1)
			end
		end
	end,
	server_ai_killed_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
		if arg_4_1.boss_spawned_counter > 0 and arg_4_1.boss_spawned[arg_4_2] then
			arg_4_1.boss_spawned_counter = arg_4_1.boss_spawned_counter - 1
			arg_4_1.boss_spawned[arg_4_2] = nil

			if ScorpionSeasonalSettings.current_season_id == 1 then
				local var_4_0 = arg_4_1.buff_name_enemy
				local var_4_1 = ScriptUnit.extension(arg_4_2, "buff_system"):has_buff_type(var_4_0)
				local var_4_2 = arg_4_5[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"

				if var_4_1 and var_4_2 then
					local var_4_3 = "season_1"
					local var_4_4 = "scorpion_weaves_fire_season_1"
					local var_4_5 = NetworkLookup.statistics_group_name[var_4_3]
					local var_4_6 = NetworkLookup.statistics[var_4_4]
					local var_4_7 = Managers.player:statistics_db()
					local var_4_8 = Managers.player:local_player():stats_id()

					var_4_7:increment_stat(var_4_8, var_4_3, var_4_4)
					Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat_group", var_4_5, var_4_6)
				end
			end
		end
	end,
	apply_buff = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = HEALTH_ALIVE[arg_5_1]
		local var_5_1 = arg_5_3 and arg_5_0.buff_name_enemy or arg_5_0.buff_name_player
		local var_5_2 = ScriptUnit.extension(arg_5_1, "buff_system")
		local var_5_3 = var_5_2:has_buff_type(var_5_1)

		if var_5_0 and not var_5_3 then
			if arg_5_3 then
				local var_5_4 = true
				local var_5_5 = arg_5_0.buff_system:add_buff(arg_5_1, var_5_1, arg_5_1, var_5_4)
				local var_5_6 = arg_5_0.network_manager:unit_game_object_id(arg_5_1)

				arg_5_0.applied_buffs[var_5_6] = {}
				arg_5_0.applied_buffs[var_5_6].buff_id = var_5_5
				arg_5_0.applied_buffs[var_5_6].unit = arg_5_1
				arg_5_0.applied_buffs[var_5_6].duration = 0
			else
				local var_5_7 = arg_5_0.buff_time_player
				local var_5_8 = {
					attacker_unit = arg_5_2,
					external_optional_duration = var_5_7
				}

				var_5_2:add_buff(var_5_1, var_5_8)
			end
		end
	end,
	remove_buff = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if not arg_6_3 then
			arg_6_0.buff_system:remove_server_controlled_buff(arg_6_1, arg_6_0.applied_buffs[arg_6_2].buff_id)
		end

		arg_6_0.applied_buffs[arg_6_2] = nil
	end,
	unit_has_buff = function (arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = ScriptUnit.has_extension(arg_7_1, "buff_system")

		return var_7_0 and var_7_0:has_buff_type(arg_7_2)
	end,
	check_melee = function (arg_8_0, arg_8_1)
		local var_8_0 = arg_8_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_8_1 = rawget(ItemMasterList, var_8_0)

		if var_8_1 then
			return var_8_1.slot_type == "melee"
		else
			return not table.contains(var_0_0, var_8_0)
		end
	end,
	server_ai_hit_by_player_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		if arg_9_2 ~= arg_9_3 and arg_9_4[DamageDataIndex.DAMAGE_AMOUNT] > 0 then
			local var_9_0 = arg_9_1.template.check_melee(arg_9_1, arg_9_4)
			local var_9_1 = arg_9_4[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"
			local var_9_2 = arg_9_4[DamageDataIndex.DAMAGE_TYPE] == "push"

			if var_9_0 and not var_9_1 and not var_9_2 then
				arg_9_1.template.apply_buff(arg_9_1, arg_9_2, arg_9_3, true)
			end
		end
	end,
	client_player_hit_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		if arg_10_2 ~= arg_10_3 and arg_10_4[DamageDataIndex.DAMAGE_AMOUNT] > 0 then
			local var_10_0 = arg_10_4[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"

			if arg_10_1.template.check_melee(arg_10_1, arg_10_4) and not var_10_0 then
				arg_10_1.template.apply_buff(arg_10_1, arg_10_2, arg_10_3, false)
			end
		end
	end,
	server_update_function = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		arg_11_1.template.update_buffs(arg_11_0, arg_11_1, arg_11_2)
	end,
	server_ai_spawned_function = function (arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = Managers.state.conflict:alive_bosses()

		if var_12_0 and #var_12_0 > arg_12_1.boss_spawned_counter and BLACKBOARDS[arg_12_2].breed.boss then
			arg_12_1.boss_spawned[arg_12_2] = true
			arg_12_1.boss_spawned_counter = arg_12_1.boss_spawned_counter + 1
		end
	end
}
