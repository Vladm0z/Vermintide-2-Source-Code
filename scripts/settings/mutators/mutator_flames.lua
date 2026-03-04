-- chunkname: @scripts/settings/mutators/mutator_flames.lua

local var_0_0 = {
	"chaos_corruptor_sorcerer",
	"chaos_vortex_sorcerer",
	"skaven_warpfire_thrower",
	"skaven_poison_wind_globadier",
	"skaven_ratling_gunner"
}

return {
	display_name = "flames_mutator_name",
	buff_duration_enemy = 3,
	description = "flames_mutator_desc",
	buff_duration_player = 3,
	icon = "mutator_icon_fire_burn",
	server_start_function = function (arg_1_0, arg_1_1)
		arg_1_1.network_manager = Managers.state.network
		arg_1_1.buff_time_player = arg_1_1.template.buff_duration_player
		arg_1_1.buff_time_enemy = arg_1_1.template.buff_duration_enemy
		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.applied_buffs = {}
		arg_1_1.buff_name_player = "mutator_fire_player_dot"
		arg_1_1.buff_name_enemy = "mutator_fire_enemy_dot"
		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.boss_spawned = {}
		arg_1_1.boss_spawned_counter = 0
	end,
	client_start_function = function (arg_2_0, arg_2_1)
		arg_2_1.buff_time_player = arg_2_1.template.buff_duration_player
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
	apply_buff = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = HEALTH_ALIVE[arg_4_1]
		local var_4_1 = arg_4_3 and arg_4_0.buff_name_enemy or arg_4_0.buff_name_player
		local var_4_2 = ScriptUnit.extension(arg_4_1, "buff_system")
		local var_4_3 = var_4_2:has_buff_type(var_4_1)

		if var_4_0 and not var_4_3 then
			if arg_4_3 then
				local var_4_4 = true
				local var_4_5 = arg_4_0.buff_system:add_buff(arg_4_1, var_4_1, arg_4_1, var_4_4)
				local var_4_6 = arg_4_0.network_manager:unit_game_object_id(arg_4_1)

				arg_4_0.applied_buffs[var_4_6] = {}
				arg_4_0.applied_buffs[var_4_6].buff_id = var_4_5
				arg_4_0.applied_buffs[var_4_6].unit = arg_4_1
				arg_4_0.applied_buffs[var_4_6].duration = 0
			else
				local var_4_7 = arg_4_0.buff_time_player
				local var_4_8 = {
					attacker_unit = arg_4_2,
					external_optional_duration = var_4_7
				}

				var_4_2:add_buff(var_4_1, var_4_8)
			end
		end
	end,
	remove_buff = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if not arg_5_3 then
			arg_5_0.buff_system:remove_server_controlled_buff(arg_5_1, arg_5_0.applied_buffs[arg_5_2].buff_id)
		end

		arg_5_0.applied_buffs[arg_5_2] = nil
	end,
	unit_has_buff = function (arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = ScriptUnit.has_extension(arg_6_1, "buff_system")

		return var_6_0 and var_6_0:has_buff_type(arg_6_2)
	end,
	check_melee = function (arg_7_0, arg_7_1)
		local var_7_0 = arg_7_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_7_1 = rawget(ItemMasterList, var_7_0)

		if var_7_1 then
			return var_7_1.slot_type == "melee"
		else
			return not table.contains(var_0_0, var_7_0)
		end
	end,
	server_ai_hit_by_player_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		if arg_8_2 ~= arg_8_3 then
			local var_8_0 = arg_8_1.template.check_melee(arg_8_1, arg_8_4)
			local var_8_1 = arg_8_4[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"
			local var_8_2 = arg_8_4[DamageDataIndex.DAMAGE_TYPE] == "push"

			if var_8_0 and not var_8_1 and not var_8_2 then
				arg_8_1.template.apply_buff(arg_8_1, arg_8_2, arg_8_3, true)
			end
		end
	end,
	client_player_hit_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		if arg_9_2 ~= arg_9_3 then
			local var_9_0 = arg_9_4[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"

			if arg_9_1.template.check_melee(arg_9_1, arg_9_4) and not var_9_0 then
				arg_9_1.template.apply_buff(arg_9_1, arg_9_2, arg_9_3, false)
			end
		end
	end,
	server_update_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		arg_10_1.template.update_buffs(arg_10_0, arg_10_1, arg_10_2)
	end,
	server_ai_spawned_function = function (arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = Managers.state.conflict:alive_bosses()

		if var_11_0 and #var_11_0 > arg_11_1.boss_spawned_counter and BLACKBOARDS[arg_11_2].breed.boss then
			arg_11_1.boss_spawned[arg_11_2] = true
			arg_11_1.boss_spawned_counter = arg_11_1.boss_spawned_counter + 1
		end
	end
}
