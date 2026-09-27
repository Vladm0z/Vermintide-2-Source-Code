-- chunkname: @scripts/settings/mutators/mutator_bloodlust.lua

return {
	description = "description_mutator_bloodlust",
	display_name = "display_name_mutator_bloodlust",
	debuff_start_time = 4.25,
	icon = "mutator_icon_bloodlust",
	amount_of_stacks_per_breed = {
		chaos_vortex_sorcerer = 2,
		skaven_plague_monk = 3,
		chaos_berzerker = 3,
		skaven_ratling_gunner = 2,
		skaven_poison_wind_globadier = 2,
		skaven_warpfire_thrower = 2,
		chaos_raider = 3,
		skaven_gutter_runner = 2,
		skaven_loot_rat = 2,
		skaven_pack_master = 2,
		skaven_stormfiend = 10,
		chaos_warrior = 5,
		skaven_rat_ogre = 10,
		chaos_troll = 10,
		chaos_spawn = 10,
		chaos_corruptor_sorcerer = 2,
		skaven_storm_vermin_commander = 3,
		skaven_storm_vermin = 3,
		skaven_storm_vermin_with_shield = 3
	},
	add_buff = function (self, arg_1_1, arg_1_2)
		-- function 1
		self:add_buff(arg_1_1, arg_1_2, arg_1_1)
	end,
	add_debuff = function (self, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local flag = true
		local add_buff = arg_2_1:add_buff(arg_2_2, arg_2_3, arg_2_2, flag)

		self[#self + 1] = add_buff
	end,
	remove_buff = function (self, arg_3_1, arg_3_2)
		-- function 3
		local count = #self
		local var_3_1 = self[count]

		arg_3_1:remove_server_controlled_buff(arg_3_2, var_3_1)

		self[count] = nil
	end,
	server_start_function = function (arg_4_0, arg_4_1)
		-- function 4
		arg_4_1.player_units = {}
		arg_4_1.buff_system = Managers.state.entity:system("buff_system")
		arg_4_1.player_manager = Managers.player
		arg_4_1.buff_name = "mutator_bloodlust"
		arg_4_1.debuff_name = "mutator_bloodlust_debuff"
	end,
	server_update_function = function (arg_5_0, arg_5_1)
		-- function 5
		local time = Managers.time:time("game")
		local template = arg_5_1.template
		local player_units = arg_5_1.player_units

		for k, v in pairs(player_units) do
			if not Unit.alive(k) then
				player_units[k] = nil
			elseif not AiUtils.unit_knocked_down(k) then
				local buffs = v.buffs
				local count = #buffs

				for k_2 = 1, count do
					template.remove_buff(buffs, arg_5_1.buff_system, k)
				end

				player_units[k] = nil
			elseif not (not (time >= v.add_debuff_at_t) or ScriptUnit.extension(k, "buff_system"):has_buff_type(arg_5_1.debuff_name)) then
				local buffs_2 = v.buffs

				template.add_debuff(buffs_2, arg_5_1.buff_system, k, arg_5_1.debuff_name)
			end
		end
	end,
	server_ai_killed_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not arg_6_1.player_manager:is_player_unit(arg_6_3) then
			return
		end

		local owner = Managers.player:owner(arg_6_3)

		if not (not owner and not owner:is_player_controlled()) then
			return
		end

		local has_buff_type = ScriptUnit.extension(arg_6_3, "buff_system"):has_buff_type(arg_6_1.debuff_name)
		local template = arg_6_1.template

		if not has_buff_type then
			template.remove_buff(arg_6_1.player_units[arg_6_3].buffs, arg_6_1.buff_system, arg_6_3, arg_6_1.debuff_name)
		end

		local player_units = arg_6_1.player_units

		if not player_units[arg_6_3] then
			player_units[arg_6_3] = {
				buffs = {}
			}
		end

		local name = BLACKBOARDS[arg_6_2].breed.name
		local var_6_5 = player_units[arg_6_3]
		local var_6_6 = template.amount_of_stacks_per_breed[name]

		var_6_6 = var_6_6 or 1

		for i = 1, var_6_6 do
			template.add_buff(arg_6_1.buff_system, arg_6_3, arg_6_1.buff_name)
		end

		var_6_5.add_debuff_at_t = Managers.time:time("game") + template.debuff_start_time
	end,
	server_stop_function = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		local player_units = arg_7_1.player_units

		for k, v in pairs(player_units) do
			if not Unit.alive(k) then
				local has_buff_type = ScriptUnit.extension(k, "buff_system"):has_buff_type(arg_7_1.debuff_name)
				local template = arg_7_1.template

				if not has_buff_type then
					template.remove_buff(v.buffs, arg_7_1.buff_system, k, arg_7_1.debuff_name)
				end
			end
		end
	end
}
