-- chunkname: @scripts/settings/mutators/mutator_flames.lua

local tbl = {
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
		-- function 1
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
		-- function 2
		arg_2_1.buff_time_player = arg_2_1.template.buff_duration_player
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
	apply_buff = function (self, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		local var_4_0 = HEALTH_ALIVE[arg_4_1]
		local buff_name_enemy

		if not arg_4_3 then
			buff_name_enemy = self.buff_name_enemy

			if not buff_name_enemy then
				-- Nothing
			end
		end

		buff_name_enemy = self.buff_name_player

		::label_4_0::

		local extension = ScriptUnit.extension(arg_4_1, "buff_system")
		local has_buff_type = extension:has_buff_type(buff_name_enemy)

		if not (not var_4_0 and has_buff_type) then
			if not arg_4_3 then
				local flag = true
				local add_buff = self.buff_system:add_buff(arg_4_1, buff_name_enemy, arg_4_1, flag)
				local unit_game_object_id = self.network_manager:unit_game_object_id(arg_4_1)

				self.applied_buffs[unit_game_object_id] = {}
				self.applied_buffs[unit_game_object_id].buff_id = add_buff
				self.applied_buffs[unit_game_object_id].unit = arg_4_1
				self.applied_buffs[unit_game_object_id].duration = 0
			else
				local buff_time_player = self.buff_time_player
				local tbl = {
					attacker_unit = arg_4_2,
					external_optional_duration = buff_time_player
				}

				extension:add_buff(buff_name_enemy, tbl)
			end
		end
	end,
	remove_buff = function (self, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		if not arg_5_3 then
			self.buff_system:remove_server_controlled_buff(arg_5_1, self.applied_buffs[arg_5_2].buff_id)
		end

		self.applied_buffs[arg_5_2] = nil
	end,
	unit_has_buff = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		local has_extension = ScriptUnit.has_extension(arg_6_1, "buff_system")

		return not has_extension and has_extension:has_buff_type(arg_6_2)
	end,
	check_melee = function (arg_7_0, arg_7_1)
		-- function 7
		local var_7_0 = arg_7_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_7_1 = rawget(ItemMasterList, var_7_0)

		if not var_7_1 then
			return var_7_1.slot_type == "melee"
		else
			return not table.contains(tbl, var_7_0)
		end
	end,
	server_ai_hit_by_player_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		-- function 8
		if arg_8_2 ~= arg_8_3 then
			local check_melee = arg_8_1.template.check_melee(arg_8_1, arg_8_4)
			local flag = arg_8_4[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"
			local flag_2 = arg_8_4[DamageDataIndex.DAMAGE_TYPE] == "push"

			if not (not check_melee and flag or flag_2) then
				arg_8_1.template.apply_buff(arg_8_1, arg_8_2, arg_8_3, true)
			end
		end
	end,
	client_player_hit_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		if arg_9_2 ~= arg_9_3 then
			local flag = arg_9_4[DamageDataIndex.DAMAGE_TYPE] == "wounded_dot"

			if not (not arg_9_1.template.check_melee(arg_9_1, arg_9_4) and flag) then
				arg_9_1.template.apply_buff(arg_9_1, arg_9_2, arg_9_3, false)
			end
		end
	end,
	server_update_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		-- function 10
		arg_10_1.template.update_buffs(arg_10_0, arg_10_1, arg_10_2)
	end,
	server_ai_spawned_function = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		local alive_bosses = Managers.state.conflict:alive_bosses()

		if not alive_bosses and not (#alive_bosses > arg_11_1.boss_spawned_counter) or not BLACKBOARDS[arg_11_2].breed.boss then
			arg_11_1.boss_spawned[arg_11_2] = true
			arg_11_1.boss_spawned_counter = arg_11_1.boss_spawned_counter + 1
		end
	end
}
