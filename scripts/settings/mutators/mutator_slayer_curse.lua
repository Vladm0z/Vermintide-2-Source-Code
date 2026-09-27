-- chunkname: @scripts/settings/mutators/mutator_slayer_curse.lua

return {
	description = "description_mutator_slayer_curse",
	display_name = "display_name_mutator_slayer_curse",
	decay_tick = 1,
	icon = "mutator_icon_slayer_curse",
	decay_start = 5,
	add_buff = function (self, arg_1_1, arg_1_2)
		-- function 1
		local flag = true
		local add_buff = arg_1_1:add_buff(arg_1_2, "slayer_curse_debuff", arg_1_2, flag)

		self[#self + 1] = add_buff
	end,
	remove_buff = function (self, arg_2_1, arg_2_2)
		-- function 2
		local count = #self
		local var_2_1 = self[count]

		arg_2_1:remove_server_controlled_buff(arg_2_2, var_2_1)

		self[count] = nil
	end,
	server_start_function = function (arg_3_0, arg_3_1)
		-- function 3
		arg_3_1.player_units = {}
		arg_3_1.buff_system = Managers.state.entity:system("buff_system")
		arg_3_1.player_manager = Managers.player
	end,
	server_update_function = function (arg_4_0, arg_4_1)
		-- function 4
		local time = Managers.time:time("game")
		local template = arg_4_1.template
		local player_units = arg_4_1.player_units

		for k, v in pairs(player_units) do
			if not Unit.alive(k) then
				player_units[k] = nil
			elseif not AiUtils.unit_knocked_down(k) then
				local buffs = v.buffs
				local count = #buffs

				for k_2 = 1, count do
					template.remove_buff(buffs, arg_4_1.buff_system, k)
				end

				player_units[k] = nil
			elseif time >= v.next_decay then
				local buffs_2 = v.buffs

				template.remove_buff(buffs_2, arg_4_1.buff_system, k)

				if #buffs_2 > 0 then
					v.next_decay = time + template.decay_tick
				else
					player_units[k] = nil
				end
			end
		end
	end,
	server_ai_killed_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		if not arg_5_1.player_manager:is_player_unit(arg_5_3) then
			return
		end

		local player_units = arg_5_1.player_units

		if not player_units[arg_5_3] then
			player_units[arg_5_3] = {
				next_decay = 0,
				buffs = {}
			}
		end

		local var_5_1 = player_units[arg_5_3]

		arg_5_1.template.add_buff(var_5_1.buffs, arg_5_1.buff_system, arg_5_3)

		var_5_1.next_decay = Managers.time:time("game") + arg_5_1.template.decay_start
	end,
	server_stop_function = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		local template = arg_6_1.template
		local player_units = arg_6_1.player_units

		if not arg_6_2 then
			for k, v in pairs(player_units) do
				local buffs = v.buffs
				local count = #buffs

				for k_2 = 1, count do
					template.remove_buff(buffs, arg_6_1.buff_system, k)
				end

				player_units[k] = nil
			end
		end
	end
}
