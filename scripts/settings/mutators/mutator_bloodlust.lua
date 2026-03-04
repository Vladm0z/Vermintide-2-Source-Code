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
	add_buff = function (arg_1_0, arg_1_1, arg_1_2)
		arg_1_0:add_buff(arg_1_1, arg_1_2, arg_1_1)
	end,
	add_debuff = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = true
		local var_2_1 = arg_2_1:add_buff(arg_2_2, arg_2_3, arg_2_2, var_2_0)

		arg_2_0[#arg_2_0 + 1] = var_2_1
	end,
	remove_buff = function (arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = #arg_3_0
		local var_3_1 = arg_3_0[var_3_0]

		arg_3_1:remove_server_controlled_buff(arg_3_2, var_3_1)

		arg_3_0[var_3_0] = nil
	end,
	server_start_function = function (arg_4_0, arg_4_1)
		arg_4_1.player_units = {}
		arg_4_1.buff_system = Managers.state.entity:system("buff_system")
		arg_4_1.player_manager = Managers.player
		arg_4_1.buff_name = "mutator_bloodlust"
		arg_4_1.debuff_name = "mutator_bloodlust_debuff"
	end,
	server_update_function = function (arg_5_0, arg_5_1)
		local var_5_0 = Managers.time:time("game")
		local var_5_1 = arg_5_1.template
		local var_5_2 = arg_5_1.player_units

		for iter_5_0, iter_5_1 in pairs(var_5_2) do
			if not Unit.alive(iter_5_0) then
				var_5_2[iter_5_0] = nil
			elseif AiUtils.unit_knocked_down(iter_5_0) then
				local var_5_3 = iter_5_1.buffs
				local var_5_4 = #var_5_3

				for iter_5_2 = 1, var_5_4 do
					var_5_1.remove_buff(var_5_3, arg_5_1.buff_system, iter_5_0)
				end

				var_5_2[iter_5_0] = nil
			elseif var_5_0 >= iter_5_1.add_debuff_at_t and not ScriptUnit.extension(iter_5_0, "buff_system"):has_buff_type(arg_5_1.debuff_name) then
				local var_5_5 = iter_5_1.buffs

				var_5_1.add_debuff(var_5_5, arg_5_1.buff_system, iter_5_0, arg_5_1.debuff_name)
			end
		end
	end,
	server_ai_killed_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if not arg_6_1.player_manager:is_player_unit(arg_6_3) then
			return
		end

		local var_6_0 = Managers.player:owner(arg_6_3)

		if var_6_0 and not var_6_0:is_player_controlled() then
			return
		end

		local var_6_1 = ScriptUnit.extension(arg_6_3, "buff_system"):has_buff_type(arg_6_1.debuff_name)
		local var_6_2 = arg_6_1.template

		if var_6_1 then
			var_6_2.remove_buff(arg_6_1.player_units[arg_6_3].buffs, arg_6_1.buff_system, arg_6_3, arg_6_1.debuff_name)
		end

		local var_6_3 = arg_6_1.player_units

		if not var_6_3[arg_6_3] then
			var_6_3[arg_6_3] = {
				buffs = {}
			}
		end

		local var_6_4 = BLACKBOARDS[arg_6_2].breed.name
		local var_6_5 = var_6_3[arg_6_3]
		local var_6_6 = var_6_2.amount_of_stacks_per_breed[var_6_4] or 1

		for iter_6_0 = 1, var_6_6 do
			var_6_2.add_buff(arg_6_1.buff_system, arg_6_3, arg_6_1.buff_name)
		end

		var_6_5.add_debuff_at_t = Managers.time:time("game") + var_6_2.debuff_start_time
	end,
	server_stop_function = function (arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = arg_7_1.player_units

		for iter_7_0, iter_7_1 in pairs(var_7_0) do
			if Unit.alive(iter_7_0) then
				local var_7_1 = ScriptUnit.extension(iter_7_0, "buff_system"):has_buff_type(arg_7_1.debuff_name)
				local var_7_2 = arg_7_1.template

				if var_7_1 then
					var_7_2.remove_buff(iter_7_1.buffs, arg_7_1.buff_system, iter_7_0, arg_7_1.debuff_name)
				end
			end
		end
	end
}
