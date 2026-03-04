-- chunkname: @scripts/settings/mutators/mutator_slayer_curse.lua

return {
	description = "description_mutator_slayer_curse",
	display_name = "display_name_mutator_slayer_curse",
	decay_tick = 1,
	icon = "mutator_icon_slayer_curse",
	decay_start = 5,
	add_buff = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = true
		local var_1_1 = arg_1_1:add_buff(arg_1_2, "slayer_curse_debuff", arg_1_2, var_1_0)

		arg_1_0[#arg_1_0 + 1] = var_1_1
	end,
	remove_buff = function (arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = #arg_2_0
		local var_2_1 = arg_2_0[var_2_0]

		arg_2_1:remove_server_controlled_buff(arg_2_2, var_2_1)

		arg_2_0[var_2_0] = nil
	end,
	server_start_function = function (arg_3_0, arg_3_1)
		arg_3_1.player_units = {}
		arg_3_1.buff_system = Managers.state.entity:system("buff_system")
		arg_3_1.player_manager = Managers.player
	end,
	server_update_function = function (arg_4_0, arg_4_1)
		local var_4_0 = Managers.time:time("game")
		local var_4_1 = arg_4_1.template
		local var_4_2 = arg_4_1.player_units

		for iter_4_0, iter_4_1 in pairs(var_4_2) do
			if not Unit.alive(iter_4_0) then
				var_4_2[iter_4_0] = nil
			elseif AiUtils.unit_knocked_down(iter_4_0) then
				local var_4_3 = iter_4_1.buffs
				local var_4_4 = #var_4_3

				for iter_4_2 = 1, var_4_4 do
					var_4_1.remove_buff(var_4_3, arg_4_1.buff_system, iter_4_0)
				end

				var_4_2[iter_4_0] = nil
			elseif var_4_0 >= iter_4_1.next_decay then
				local var_4_5 = iter_4_1.buffs

				var_4_1.remove_buff(var_4_5, arg_4_1.buff_system, iter_4_0)

				if #var_4_5 > 0 then
					iter_4_1.next_decay = var_4_0 + var_4_1.decay_tick
				else
					var_4_2[iter_4_0] = nil
				end
			end
		end
	end,
	server_ai_killed_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if not arg_5_1.player_manager:is_player_unit(arg_5_3) then
			return
		end

		local var_5_0 = arg_5_1.player_units

		if not var_5_0[arg_5_3] then
			var_5_0[arg_5_3] = {
				next_decay = 0,
				buffs = {}
			}
		end

		local var_5_1 = var_5_0[arg_5_3]

		arg_5_1.template.add_buff(var_5_1.buffs, arg_5_1.buff_system, arg_5_3)

		var_5_1.next_decay = Managers.time:time("game") + arg_5_1.template.decay_start
	end,
	server_stop_function = function (arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = arg_6_1.template
		local var_6_1 = arg_6_1.player_units

		if not arg_6_2 then
			for iter_6_0, iter_6_1 in pairs(var_6_1) do
				local var_6_2 = iter_6_1.buffs
				local var_6_3 = #var_6_2

				for iter_6_2 = 1, var_6_3 do
					var_6_0.remove_buff(var_6_2, arg_6_1.buff_system, iter_6_0)
				end

				var_6_1[iter_6_0] = nil
			end
		end
	end
}
