-- chunkname: @scripts/settings/mutators/mutator_base_curse_marked_enemies.lua

local function fn(arg_1_0, arg_1_1)
	-- function 1
	if not HEALTH_ALIVE[arg_1_1] and not Managers.player:is_player_unit(arg_1_1) then
		local extension_input = ScriptUnit.extension_input(arg_1_1, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event(arg_1_0, alloc_table)
	end
end

return function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	return {
		marked_enemy_killed_dialogue_event = "curse_killed_marked_enemy",
		display_name = arg_2_0,
		description = arg_2_1,
		icon = arg_2_2,
		server_start_function = function (arg_3_0, arg_3_1)
			-- function 3
			local get_difficulty = Managers.state.difficulty:get_difficulty()

			arg_3_1.max_marked_enemies = arg_2_4[get_difficulty].max_marked_enemies
			arg_3_1.mark_chance = arg_2_4[get_difficulty].mark_chance
			arg_3_1.enemies_to_be_marked = {}
			arg_3_1.marked_enemies = {}
			arg_3_1.seed = Managers.mechanism:get_level_seed("mutator")
		end,
		can_enemy_be_marked = function (arg_4_0, arg_4_1, arg_4_2)
			-- function 4
			if #arg_4_1.marked_enemies < arg_4_1.max_marked_enemies then
				local name = Unit.get_data(arg_4_2, "breed").name

				if not arg_2_5[name] then
					local var_4_1
					local var_4_2

					arg_4_1.seed, var_4_2 = Math.next_random(arg_4_1.seed)

					if var_4_2 <= arg_4_1.mark_chance then
						if not arg_2_6 then
							return arg_2_6()
						else
							return true
						end
					end
				end
			end

			return false
		end,
		mark_enemy = function (arg_5_0, arg_5_1, arg_5_2)
			-- function 5
			local system = Managers.state.entity:system("buff_system")

			if not system then
				system:add_buff(arg_5_2, arg_2_3, arg_5_2)

				arg_5_1.marked_enemies[#arg_5_1.marked_enemies + 1] = arg_5_2
			end
		end,
		update_marked_enemies = function (arg_6_0, arg_6_1)
			-- function 6
			local marked_enemies = arg_6_1.marked_enemies

			if #marked_enemies == 0 then
				return
			end

			for i = #marked_enemies, 1, -1 do
				local var_6_1 = marked_enemies[i]

				if not not HEALTH_ALIVE[var_6_1] then
					table.swap_delete(marked_enemies, i)
				end
			end
		end,
		update_spawned_enemies = function (arg_7_0, arg_7_1)
			-- function 7
			local enemies_to_be_marked = arg_7_1.enemies_to_be_marked

			if table.size(enemies_to_be_marked) == 0 then
				return
			end

			local network = Managers.state.network

			for i = #enemies_to_be_marked, 1, -1 do
				local var_7_2 = enemies_to_be_marked[i]

				if not network:unit_game_object_id(var_7_2) then
					arg_7_1.template.mark_enemy(arg_7_0, arg_7_1, var_7_2)
					table.swap_delete(enemies_to_be_marked, i)
				end
			end
		end,
		server_update_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			-- function 8
			arg_8_1.template.update_marked_enemies(arg_8_0, arg_8_1)
			arg_8_1.template.update_spawned_enemies(arg_8_0, arg_8_1)
		end,
		server_ai_spawned_function = function (arg_9_0, arg_9_1, arg_9_2)
			-- function 9
			if not arg_9_1.template.can_enemy_be_marked(arg_9_0, arg_9_1, arg_9_2) then
				arg_9_1.enemies_to_be_marked[#arg_9_1.enemies_to_be_marked + 1] = arg_9_2
			end
		end,
		server_ai_killed_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
			-- function 10
			local index_of = table.index_of(arg_10_1.marked_enemies, arg_10_2)

			if not (index_of ~= -1) then
				fn(arg_10_1.template.marked_enemy_killed_dialogue_event, arg_10_3)
				table.swap_delete(arg_10_1.marked_enemies, index_of)
			end
		end
	}
end
