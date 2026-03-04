-- chunkname: @scripts/unit_extensions/ai_supplementary/beastmen_standard_extension.lua

BeastmenStandardExtension = class(BeastmenStandardExtension)

BeastmenStandardExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.world = var_1_0
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server

	local var_1_1 = Unit.local_position(arg_1_2, 0)

	arg_1_0.self_position_boxed = Vector3Box(var_1_1)

	local var_1_2 = arg_1_3.standard_template_name
	local var_1_3 = BeastmenStandardTemplates[var_1_2]

	arg_1_0.standard_template = var_1_3
	arg_1_0.standard_template_name = var_1_2
	arg_1_0.standard_template_buff_name = var_1_3.buff_template_name
	arg_1_0.standard_bearer_unit = arg_1_3.standard_bearer_unit
	arg_1_0.side = Managers.state.side.side_by_unit[arg_1_0.standard_bearer_unit]
	arg_1_0.apply_buff_frequency = 0.5

	local var_1_4 = Managers.time:time("game")

	arg_1_0.next_apply_buff_t = var_1_4
	arg_1_0.affected_units_effects = {}
	arg_1_0.ai_units_broadphase_result = {}
	arg_1_0.ai_units_inside = {}
	arg_1_0.standard_data = {}
	arg_1_0.standard_data.challenge_time = var_1_4 + QuestSettings.standard_bearer_alive_seconds
	arg_1_0.standard_data.is_server = arg_1_0.is_server
	arg_1_0.standard_data.standard_bearer_unit = arg_1_0.standard_bearer_unit

	local var_1_5 = Managers.state.side
	local var_1_6 = var_1_5.side_by_unit[arg_1_0.standard_bearer_unit] or var_1_5:get_side_from_name("dark_pact")

	var_1_5:add_unit_to_side(arg_1_0.unit, var_1_6.side_id)

	if arg_1_0.is_server then
		arg_1_0.astar_check_frequency = var_1_3.astar_check_frequency or 15
		arg_1_0.nav_world = Managers.state.entity:system("ai_system"):nav_world()

		local var_1_7 = {
			ledges = 1,
			ledges_with_fence = 1,
			doors = 1,
			bot_poison_wind = 1,
			planks = 1,
			bot_ratling_gun_fire = 1,
			fire_grenade = 1
		}
		local var_1_8 = GwNavTagLayerCostTable.create()

		table.merge(var_1_7, NAV_TAG_VOLUME_LAYER_COST_AI)
		AiUtils.initialize_cost_table(var_1_8, var_1_7)

		arg_1_0.player_astar_traverse_logic, arg_1_0.player_astar_navtag_layer_cost_table = GwNavTraverseLogic.create(arg_1_0.nav_world, var_1_8), var_1_8
		arg_1_0.player_astar_data = {
			{
				next_astar_check_t = var_1_4 + arg_1_0.astar_check_frequency
			},
			{
				next_astar_check_t = var_1_4 + arg_1_0.astar_check_frequency
			},
			{
				next_astar_check_t = var_1_4 + arg_1_0.astar_check_frequency
			},
			{
				next_astar_check_t = var_1_4 + arg_1_0.astar_check_frequency
			}
		}

		Managers.state.conflict:add_unit_to_standards(arg_1_2)

		arg_1_0.next_vo_trigger_event_t = var_1_4 + 15

		LevelHelper:flow_event(arg_1_0.world, "standard_placed")
	end

	local var_1_9 = var_1_3.sfx_placed

	if var_1_9 then
		WwiseUtils.trigger_unit_event(var_1_0, var_1_9, arg_1_2, 0)
	end

	local var_1_10 = var_1_3.sfx_loop

	if var_1_10 then
		WwiseUtils.trigger_unit_event(var_1_0, var_1_10, arg_1_2, 0)
	end
end

BeastmenStandardExtension.destroy = function (arg_2_0)
	Managers.state.side:remove_unit_from_side(arg_2_0.unit)

	if not arg_2_0.dead then
		arg_2_0:on_death()
	end
end

BeastmenStandardExtension.on_death = function (arg_3_0, arg_3_1)
	if arg_3_0.is_server then
		local var_3_0 = Managers.state.entity:system("buff_system")

		for iter_3_0, iter_3_1 in pairs(arg_3_0.ai_units_inside) do
			if Unit.alive(iter_3_0) then
				local var_3_1 = ScriptUnit.extension(iter_3_0, "buff_system")

				if var_3_1:has_buff_type(arg_3_0.standard_template_buff_name) then
					var_3_1:get_non_stacking_buff(arg_3_0.standard_template_buff_name).standard_is_destroyed = true
				end

				if var_3_0:has_server_controlled_buff(iter_3_0, iter_3_1) then
					var_3_0:remove_server_controlled_buff(iter_3_0, iter_3_1)
				end
			end
		end

		for iter_3_2 = 1, #arg_3_0.player_astar_data do
			local var_3_2 = arg_3_0.player_astar_data[iter_3_2]

			if var_3_2.astar then
				local var_3_3 = var_3_2.astar

				GwNavAStar.destroy(var_3_3)
			end
		end

		Managers.state.conflict:remove_unit_from_standards(arg_3_0.unit)
		GwNavTagLayerCostTable.destroy(arg_3_0.player_astar_navtag_layer_cost_table)
		GwNavTraverseLogic.destroy(arg_3_0.player_astar_traverse_logic)
		table.clear(arg_3_0.ai_units_inside)
		table.clear(arg_3_0.ai_units_broadphase_result)
		LevelHelper:flow_event(arg_3_0.world, "standard_destroyed")
	end

	arg_3_0.dead = true

	table.clear(arg_3_0.standard_data)

	if Unit.alive(arg_3_1) and arg_3_1 ~= arg_3_0.unit then
		local var_3_4 = Unit.local_position(arg_3_0.unit, 0)
		local var_3_5 = ExplosionUtils.get_template("standard_death_explosion")
		local var_3_6 = "beastmen_standard_bearer"

		DamageUtils.create_explosion(arg_3_0.world, arg_3_1 or arg_3_0.unit, var_3_4, Quaternion.identity(), var_3_5, 1, var_3_6, arg_3_0.is_server, false, arg_3_0.unit, false)
		Unit.flow_event(arg_3_0.unit, "destroy")

		if arg_3_0.is_server then
			Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_3_0.unit, "standard_bearer_buff_deactivated", DialogueSettings.special_proximity_distance_heard)
		end
	else
		local var_3_7 = arg_3_0.standard_template.vfx_picked_up_standard

		World.create_particles(arg_3_0.world, var_3_7, arg_3_0.self_position_boxed:unbox())
		Unit.flow_event(arg_3_0.unit, "picked_up")
	end

	local var_3_8 = arg_3_0.standard_template.sfx_loop_stop

	if var_3_8 then
		WwiseUtils.trigger_unit_event(arg_3_0.world, var_3_8, arg_3_0.unit, 0)
	end

	local var_3_9 = arg_3_0.standard_template.sfx_destroyed

	if var_3_9 then
		WwiseUtils.trigger_unit_event(arg_3_0.world, var_3_9, arg_3_0.unit, 0)
	end

	arg_3_0.world = nil
	arg_3_0.self_position_boxed = nil
	arg_3_0.standard_template = nil
end

BeastmenStandardExtension.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if arg_4_0.dead then
		return
	end

	local var_4_0 = arg_4_0.standard_template

	if arg_4_0.is_server and var_4_0.apply_buff_to_ai and arg_4_5 >= arg_4_0.next_apply_buff_t then
		local var_4_1 = arg_4_0.ai_units_inside
		local var_4_2 = arg_4_0.ai_units_broadphase_result

		table.clear(var_4_2)

		local var_4_3 = Managers.state.entity:system("buff_system")
		local var_4_4 = var_4_0.buff_template_name
		local var_4_5 = var_4_0.radius
		local var_4_6 = arg_4_0.self_position_boxed:unbox()
		local var_4_7 = AiUtils.broadphase_query(var_4_6, var_4_5, var_4_2)

		for iter_4_0 = 1, var_4_7 do
			local var_4_8 = var_4_2[iter_4_0]
			local var_4_9 = ScriptUnit.has_extension(var_4_8, "buff_system")
			local var_4_10 = BLACKBOARDS[var_4_8]

			if var_4_10 and var_4_10.breed.race == "beastmen" and var_4_9 and not var_4_1[var_4_8] and not var_4_9:get_non_stacking_buff(arg_4_0.standard_template_buff_name) then
				var_4_1[var_4_8] = var_4_3:add_buff(var_4_8, var_4_4, var_4_8, true)
			end
		end

		for iter_4_1, iter_4_2 in pairs(var_4_1) do
			local var_4_11 = false

			for iter_4_3 = 1, var_4_7 do
				if iter_4_1 == var_4_2[iter_4_3] then
					var_4_11 = true

					break
				end
			end

			if not var_4_11 or not HEALTH_ALIVE[iter_4_1] then
				if Unit.alive(iter_4_1) and var_4_3:has_server_controlled_buff(iter_4_1, iter_4_2) then
					var_4_3:remove_server_controlled_buff(iter_4_1, iter_4_2)
				end

				var_4_1[iter_4_1] = nil
			end
		end

		arg_4_0.next_apply_buff_t = arg_4_5 + arg_4_0.apply_buff_frequency
	end

	if var_4_0.custom_update_func then
		var_4_0.custom_update_func(var_4_0, arg_4_0.standard_data, arg_4_5, arg_4_3, arg_4_1, arg_4_0.ai_units_inside)
	end

	if arg_4_0.is_server and arg_4_5 > arg_4_0.next_vo_trigger_event_t then
		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_4_1, "standard_bearer_buff_active", DialogueSettings.special_proximity_distance_heard)

		arg_4_0.next_vo_trigger_event_t = arg_4_5 + 15
	end

	if arg_4_0.is_server then
		arg_4_0:_update_self_destruction(arg_4_1, arg_4_3, arg_4_5)
	end
end

BeastmenStandardExtension._update_self_destruction = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0.player_astar_data
	local var_5_1 = arg_5_0.nav_world
	local var_5_2 = arg_5_0.side.ENEMY_PLAYER_UNITS
	local var_5_3 = #var_5_2

	for iter_5_0 = 1, var_5_3 do
		local var_5_4 = var_5_2[iter_5_0]

		if HEALTH_ALIVE[var_5_4] then
			local var_5_5 = var_5_0[iter_5_0]
			local var_5_6 = var_5_5.astar
			local var_5_7 = arg_5_0.player_astar_traverse_logic

			if var_5_6 then
				if GwNavAStar.processing_finished(var_5_6) then
					local var_5_8 = GwNavAStar.path_found(var_5_6)

					var_5_5.has_calculated_path = true

					if var_5_8 then
						var_5_5.path_found = true

						for iter_5_1 = 1, #var_5_0 do
							local var_5_9 = var_5_0[iter_5_1]
							local var_5_10 = var_5_9.astar

							if var_5_10 then
								GwNavAStar.destroy(var_5_10)
							end

							var_5_9.astar = nil
						end

						break
					end

					GwNavAStar.destroy(var_5_6)

					var_5_5.astar = nil
				end
			elseif arg_5_3 > var_5_5.next_astar_check_t then
				local var_5_11 = POSITION_LOOKUP[var_5_4]
				local var_5_12, var_5_13 = GwNavQueries.triangle_from_position(var_5_1, var_5_11, 1, 1)

				if var_5_12 then
					local var_5_14 = Vector3(var_5_11[1], var_5_11[2], var_5_13)
					local var_5_15 = GwNavAStar.create(var_5_1)
					local var_5_16 = Unit.local_position(arg_5_1, 0)

					GwNavAStar.start(var_5_15, var_5_1, var_5_14, var_5_16, var_5_7)

					var_5_5.astar = var_5_15
					var_5_5.next_astar_check_t = arg_5_3 + arg_5_0.astar_check_frequency
					var_5_5.has_calculated_path = nil
					var_5_5.path_found = nil
				else
					var_5_5.next_astar_check_t = arg_5_3 + 1.5
				end
			end
		else
			local var_5_17 = var_5_0[iter_5_0]

			if var_5_17 and var_5_17.astar then
				local var_5_18 = var_5_17.astar

				GwNavAStar.destroy(var_5_18)
			end
		end
	end

	local var_5_19
	local var_5_20 = 0

	for iter_5_2 = 1, #var_5_0 do
		local var_5_21 = var_5_0[iter_5_2]

		if var_5_21.path_found then
			var_5_19 = true
		elseif var_5_21.has_calculated_path then
			var_5_20 = var_5_20 + 1
		end
	end

	if not var_5_19 and var_5_3 <= var_5_20 then
		AiUtils.kill_unit(arg_5_0.unit, arg_5_0.unit, nil, nil, nil, "suicide")
	end
end
