-- chunkname: @scripts/settings/mutators/mutator_base_curse_marked_enemies.lua

local function var_0_0(arg_1_0, arg_1_1)
	if HEALTH_ALIVE[arg_1_1] and Managers.player:is_player_unit(arg_1_1) then
		local var_1_0 = ScriptUnit.extension_input(arg_1_1, "dialogue_system")
		local var_1_1 = FrameTable.alloc_table()

		var_1_0:trigger_dialogue_event(arg_1_0, var_1_1)
	end
end

return function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	return {
		marked_enemy_killed_dialogue_event = "curse_killed_marked_enemy",
		display_name = arg_2_0,
		description = arg_2_1,
		icon = arg_2_2,
		server_start_function = function(arg_3_0, arg_3_1)
			local var_3_0 = Managers.state.difficulty:get_difficulty()

			arg_3_1.max_marked_enemies = arg_2_4[var_3_0].max_marked_enemies
			arg_3_1.mark_chance = arg_2_4[var_3_0].mark_chance
			arg_3_1.enemies_to_be_marked = {}
			arg_3_1.marked_enemies = {}
			arg_3_1.seed = Managers.mechanism:get_level_seed("mutator")
		end,
		can_enemy_be_marked = function(arg_4_0, arg_4_1, arg_4_2)
			if #arg_4_1.marked_enemies < arg_4_1.max_marked_enemies then
				local var_4_0 = Unit.get_data(arg_4_2, "breed").name

				if arg_2_5[var_4_0] then
					local var_4_1
					local var_4_2

					arg_4_1.seed, var_4_2 = Math.next_random(arg_4_1.seed)

					if var_4_2 <= arg_4_1.mark_chance then
						if arg_2_6 then
							return arg_2_6()
						else
							return true
						end
					end
				end
			end

			return false
		end,
		mark_enemy = function(arg_5_0, arg_5_1, arg_5_2)
			local var_5_0 = Managers.state.entity:system("buff_system")

			if var_5_0 then
				var_5_0:add_buff(arg_5_2, arg_2_3, arg_5_2)

				arg_5_1.marked_enemies[#arg_5_1.marked_enemies + 1] = arg_5_2
			end
		end,
		update_marked_enemies = function(arg_6_0, arg_6_1)
			local var_6_0 = arg_6_1.marked_enemies

			if #var_6_0 == 0 then
				return
			end

			for iter_6_0 = #var_6_0, 1, -1 do
				local var_6_1 = var_6_0[iter_6_0]

				if not HEALTH_ALIVE[var_6_1] then
					table.swap_delete(var_6_0, iter_6_0)
				end
			end
		end,
		update_spawned_enemies = function(arg_7_0, arg_7_1)
			local var_7_0 = arg_7_1.enemies_to_be_marked

			if table.size(var_7_0) == 0 then
				return
			end

			local var_7_1 = Managers.state.network

			for iter_7_0 = #var_7_0, 1, -1 do
				local var_7_2 = var_7_0[iter_7_0]

				if var_7_1:unit_game_object_id(var_7_2) then
					arg_7_1.template.mark_enemy(arg_7_0, arg_7_1, var_7_2)
					table.swap_delete(var_7_0, iter_7_0)
				end
			end
		end,
		server_update_function = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			arg_8_1.template.update_marked_enemies(arg_8_0, arg_8_1)
			arg_8_1.template.update_spawned_enemies(arg_8_0, arg_8_1)
		end,
		server_ai_spawned_function = function(arg_9_0, arg_9_1, arg_9_2)
			if arg_9_1.template.can_enemy_be_marked(arg_9_0, arg_9_1, arg_9_2) then
				arg_9_1.enemies_to_be_marked[#arg_9_1.enemies_to_be_marked + 1] = arg_9_2
			end
		end,
		server_ai_killed_function = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
			local var_10_0 = table.index_of(arg_10_1.marked_enemies, arg_10_2)

			if var_10_0 ~= -1 then
				var_0_0(arg_10_1.template.marked_enemy_killed_dialogue_event, arg_10_3)
				table.swap_delete(arg_10_1.marked_enemies, var_10_0)
			end
		end
	}
end
