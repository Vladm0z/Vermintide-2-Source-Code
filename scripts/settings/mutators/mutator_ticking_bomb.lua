-- chunkname: @scripts/settings/mutators/mutator_ticking_bomb.lua

return {
	description = "description_mutator_ticking_bomb",
	display_name = "display_name_mutator_ticking_bomb",
	icon = "mutator_icon_ticking_bomb",
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		arg_1_1.buff_name = "mutator_ticking_bomb"
		arg_1_1.movement_debuff_name = "ticking_bomb_decrease_movement"
		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.applied_buff_at_t = 0
		arg_1_1.apply_aoe_threat_after_t = 4
		arg_1_1.apply_movement_debuff_after_t = 5
		arg_1_1.player_bomb_data = {}
		arg_1_1.hero_side = Managers.state.side:get_side_from_name("heroes")

		if not arg_1_1.activated_by_twitch then
			arg_1_1.template.server_players_left_safe_zone(arg_1_0, arg_1_1)
		end
	end,
	server_players_left_safe_zone = function (arg_2_0, arg_2_1)
		-- function 2
		arg_2_1.has_left_safe_zone = true

		local time = Managers.time:time("game")
		local num = 20

		if not Managers.twitch:is_activated() then
			num = 5
		end

		arg_2_1.apply_bomb_buff_at_t = time + num
	end,
	server_update_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		if not arg_3_1.has_left_safe_zone then
			return
		end

		local player_bomb_data = arg_3_1.player_bomb_data
		local buff_system = arg_3_1.buff_system

		if arg_3_3 > arg_3_1.apply_bomb_buff_at_t then
			table.clear(player_bomb_data)

			local PLAYER_UNITS = arg_3_1.hero_side.PLAYER_UNITS
			local count = #PLAYER_UNITS
			local random = math.random(1, #PLAYER_UNITS)

			for i = 1, random do
				local var_3_5 = PLAYER_UNITS[math.random(1, count)]

				if not HEALTH_ALIVE[var_3_5] then
					buff_system:add_buff(var_3_5, arg_3_1.buff_name, var_3_5)

					arg_3_1.applied_buff_at_t = arg_3_3

					local tbl = {
						player_unit = var_3_5
					}

					arg_3_1.applied_bot_threat = nil
					arg_3_1.should_add_movement_debuff = true
					player_bomb_data[#player_bomb_data + 1] = tbl
				end
			end

			local num = math.random(24, 40) + random

			if not Managers.twitch:is_activated() then
				num = math.random(12, 20) + random
			end

			local num_2 = 5 * (4 - count)

			arg_3_1.apply_bomb_buff_at_t = arg_3_3 + num + num_2
		end

		for j = 1, #player_bomb_data do
			local var_3_9 = player_bomb_data[j]
			local player_unit = var_3_9.player_unit

			if not Unit.alive(player_unit) then
				table.remove(player_bomb_data, j)

				break
			end

			if not (not (arg_3_3 > arg_3_1.applied_buff_at_t + arg_3_1.apply_aoe_threat_after_t) or var_3_9.applied_bot_threat) then
				local system = Managers.state.entity:system("ai_bot_group_system")
				local var_3_12 = POSITION_LOOKUP[player_unit]
				local num_3 = 4
				local num_4 = 5

				system:aoe_threat_created(var_3_12, "sphere", num_3, nil, num_4, "Ticking Bomb")

				var_3_9.applied_bot_threat = true
			end

			if not (not (arg_3_3 > arg_3_1.applied_buff_at_t + arg_3_1.apply_movement_debuff_after_t) or var_3_9.applied_movement_debuff) then
				buff_system:add_buff(player_unit, arg_3_1.movement_debuff_name, player_unit)

				var_3_9.applied_movement_debuff = true
			end
		end
	end
}
