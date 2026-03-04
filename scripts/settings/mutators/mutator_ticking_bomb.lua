-- chunkname: @scripts/settings/mutators/mutator_ticking_bomb.lua

return {
	description = "description_mutator_ticking_bomb",
	display_name = "display_name_mutator_ticking_bomb",
	icon = "mutator_icon_ticking_bomb",
	server_start_function = function(arg_1_0, arg_1_1)
		arg_1_1.buff_name = "mutator_ticking_bomb"
		arg_1_1.movement_debuff_name = "ticking_bomb_decrease_movement"
		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.applied_buff_at_t = 0
		arg_1_1.apply_aoe_threat_after_t = 4
		arg_1_1.apply_movement_debuff_after_t = 5
		arg_1_1.player_bomb_data = {}
		arg_1_1.hero_side = Managers.state.side:get_side_from_name("heroes")

		if arg_1_1.activated_by_twitch then
			arg_1_1.template.server_players_left_safe_zone(arg_1_0, arg_1_1)
		end
	end,
	server_players_left_safe_zone = function(arg_2_0, arg_2_1)
		arg_2_1.has_left_safe_zone = true

		local var_2_0 = Managers.time:time("game")
		local var_2_1 = 20

		if Managers.twitch:is_activated() then
			var_2_1 = 5
		end

		arg_2_1.apply_bomb_buff_at_t = var_2_0 + var_2_1
	end,
	server_update_function = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if not arg_3_1.has_left_safe_zone then
			return
		end

		local var_3_0 = arg_3_1.player_bomb_data
		local var_3_1 = arg_3_1.buff_system

		if arg_3_3 > arg_3_1.apply_bomb_buff_at_t then
			table.clear(var_3_0)

			local var_3_2 = arg_3_1.hero_side.PLAYER_UNITS
			local var_3_3 = #var_3_2
			local var_3_4 = math.random(1, #var_3_2)

			for iter_3_0 = 1, var_3_4 do
				local var_3_5 = var_3_2[math.random(1, var_3_3)]

				if HEALTH_ALIVE[var_3_5] then
					var_3_1:add_buff(var_3_5, arg_3_1.buff_name, var_3_5)

					arg_3_1.applied_buff_at_t = arg_3_3

					local var_3_6 = {
						player_unit = var_3_5
					}

					arg_3_1.applied_bot_threat = nil
					arg_3_1.should_add_movement_debuff = true
					var_3_0[#var_3_0 + 1] = var_3_6
				end
			end

			local var_3_7 = math.random(24, 40) + var_3_4

			if Managers.twitch:is_activated() then
				var_3_7 = math.random(12, 20) + var_3_4
			end

			local var_3_8 = 5 * (4 - var_3_3)

			arg_3_1.apply_bomb_buff_at_t = arg_3_3 + var_3_7 + var_3_8
		end

		for iter_3_1 = 1, #var_3_0 do
			local var_3_9 = var_3_0[iter_3_1]
			local var_3_10 = var_3_9.player_unit

			if not Unit.alive(var_3_10) then
				table.remove(var_3_0, iter_3_1)

				break
			end

			if arg_3_3 > arg_3_1.applied_buff_at_t + arg_3_1.apply_aoe_threat_after_t and not var_3_9.applied_bot_threat then
				local var_3_11 = Managers.state.entity:system("ai_bot_group_system")
				local var_3_12 = POSITION_LOOKUP[var_3_10]
				local var_3_13 = 4
				local var_3_14 = 5

				var_3_11:aoe_threat_created(var_3_12, "sphere", var_3_13, nil, var_3_14, "Ticking Bomb")

				var_3_9.applied_bot_threat = true
			end

			if arg_3_3 > arg_3_1.applied_buff_at_t + arg_3_1.apply_movement_debuff_after_t and not var_3_9.applied_movement_debuff then
				var_3_1:add_buff(var_3_10, arg_3_1.movement_debuff_name, var_3_10)

				var_3_9.applied_movement_debuff = true
			end
		end
	end
}
