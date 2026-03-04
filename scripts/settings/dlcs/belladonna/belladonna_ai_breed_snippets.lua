-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_ai_breed_snippets.lua

AiBreedSnippets = AiBreedSnippets or {}

function AiBreedSnippets.on_beastmen_bestigor_spawn(arg_1_0, arg_1_1)
	arg_1_1.charge_astar_timer = Managers.time:time("game")
	arg_1_1.num_charges_targeting_target = 0
	arg_1_1.target_is_charged = false
	arg_1_1.aggro_list = {}

	local var_1_0 = {
		planks = 1,
		bot_ratling_gun_fire = 1,
		doors = 1,
		bot_poison_wind = 1,
		fire_grenade = 1
	}
	local var_1_1 = arg_1_1.navigation_extension
	local var_1_2 = var_1_1:get_navtag_layer_cost_table("charge")

	table.merge(var_1_0, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(var_1_2, var_1_0)

	local var_1_3 = var_1_1:nav_cost_map_cost_table("charge")

	AiUtils.initialize_nav_cost_map_cost_table(var_1_3)

	local var_1_4 = var_1_1:get_reusable_traverse_logic("charge", var_1_3)

	GwNavTraverseLogic.set_navtag_layer_cost_table(var_1_4, var_1_2)
end

function AiBreedSnippets.on_beastmen_bestigor_update(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0
	local var_2_1 = arg_2_1.navigation_extension:nav_cost_map_cost_table("charge")
	local var_2_2 = arg_2_1.navigation_extension:get_reusable_traverse_logic("charge", var_2_1)

	if var_2_2 and arg_2_1.charge_astar_timer and not arg_2_1.charge_state and Unit.alive(arg_2_1.target_unit) then
		local var_2_3 = arg_2_1.navigation_extension:get_reusable_astar("charge", true)

		if var_2_3 then
			if GwNavAStar.processing_finished(var_2_3) then
				if GwNavAStar.path_found(var_2_3) then
					arg_2_1.has_valid_astar_path = true
				else
					arg_2_1.has_valid_astar_path = false
				end

				arg_2_1.navigation_extension:destroy_reusable_astar("charge")

				arg_2_1.charge_astar_timer = arg_2_2 + 1
			end
		elseif arg_2_2 > arg_2_1.charge_astar_timer then
			local var_2_4 = arg_2_1.nav_world
			local var_2_5 = Unit.local_position(arg_2_1.target_unit, 0)
			local var_2_6, var_2_7 = GwNavQueries.triangle_from_position(var_2_4, var_2_5, 1, 1)

			if var_2_6 then
				local var_2_8 = Vector3(var_2_5[1], var_2_5[2], var_2_7)
				local var_2_9 = 7
				local var_2_10 = arg_2_1.navigation_extension:get_reusable_astar("charge")

				GwNavAStar.start_with_propagation_box(var_2_10, var_2_4, Unit.local_position(arg_2_0, 0), var_2_8, var_2_9, var_2_2)

				arg_2_1.charge_astar_timer = arg_2_2 + 1
			else
				arg_2_1.charge_astar_timer = arg_2_2 + 0.1
			end
		end
	end

	if Unit.alive(arg_2_1.target_unit) then
		local var_2_11 = ScriptUnit.has_extension(arg_2_1.target_unit, "status_system")

		if var_2_11 then
			arg_2_1.num_charges_targeting_target = var_2_11.num_charges_targeting_player or 0
			arg_2_1.target_is_charged = var_2_11:is_charged()
		end
	end
end

function AiBreedSnippets.on_beastmen_standard_bearer_spawn(arg_3_0, arg_3_1)
	arg_3_1.switching_weapons = 1
	arg_3_1.buff_extension = ScriptUnit.extension(arg_3_0, "buff_system")

	if arg_3_1.spawn_category ~= "patrol" then
		WwiseUtils.trigger_unit_event(arg_3_1.world, "Play_enemy_beastmen_standar_chanting_loop", arg_3_0, 0)

		arg_3_1.triggered_standard_chanting_sound = true
	end

	if arg_3_1.spawn_type ~= "terror_event" and arg_3_1.spawn_category ~= "patrol" then
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_0, true)

		local var_3_0 = 3
		local var_3_1 = Unit.local_rotation(arg_3_0, 0)
		local var_3_2 = Managers.state.conflict
		local var_3_3 = var_3_2.nav_world
		local var_3_4 = Unit.world_position(arg_3_0, 0)
		local var_3_5 = BreedTweaks.standard_bearer_spawn_list
		local var_3_6 = Managers.state.difficulty:get_difficulty_value_from_table(var_3_5)
		local var_3_7 = Managers.level_transition_handler.enemy_package_loader:get_startup_breeds()
		local var_3_8 = BreedTweaks.standard_bearer_spawn_list_replacements
		local var_3_9 = {}

		for iter_3_0 = 1, #var_3_6 do
			local var_3_10 = var_3_6[iter_3_0]

			if not var_3_7[var_3_10] then
				local var_3_11
				local var_3_12 = false

				for iter_3_1 = 1, #var_3_8 do
					local var_3_13 = var_3_8[iter_3_1]

					if var_3_12 and var_3_7[var_3_13] then
						var_3_11 = var_3_13

						break
					elseif var_3_13 == var_3_10 then
						var_3_12 = true
					end
				end

				if var_3_11 then
					var_3_9[#var_3_9 + 1] = var_3_11
				end
			else
				var_3_9[#var_3_9 + 1] = var_3_10
			end
		end

		local var_3_14 = #var_3_9
		local var_3_15 = 1
		local var_3_16 = 1

		for iter_3_2 = 1, var_3_14 do
			local var_3_17 = var_3_4 + Vector3(-var_3_0 / 2 + iter_3_2 % var_3_0, -var_3_0 / 2 + math.floor(iter_3_2 / var_3_0), 0) * 2
			local var_3_18 = LocomotionUtils.pos_on_mesh(var_3_3, var_3_17, var_3_15, var_3_16)
			local var_3_19 = Breeds[var_3_9[iter_3_2]]
			local var_3_20

			if var_3_18 then
				var_3_2:spawn_queued_unit(var_3_19, Vector3Box(var_3_18), QuaternionBox(var_3_1), "hidden_spawn", nil, "horde_hidden", var_3_20)
			else
				local var_3_21 = 1
				local var_3_22 = 0.1
				local var_3_23 = GwNavQueries.inside_position_from_outside_position(var_3_3, var_3_17, var_3_15, var_3_16, var_3_21, var_3_22) or POSITION_LOOKUP[arg_3_0]

				var_3_2:spawn_queued_unit(var_3_19, Vector3Box(var_3_23), QuaternionBox(var_3_1), "hidden_spawn", nil, "horde_hidden", var_3_20)
			end
		end
	end

	if arg_3_1.spawn_type == "terror_event" then
		arg_3_1.ignore_passive_on_patrol = true
	end

	arg_3_1.plant_standard_astar_timer = Managers.time:time("game")

	local var_3_24 = {
		planks = 1,
		bot_ratling_gun_fire = 1,
		doors = 1,
		bot_poison_wind = 1,
		fire_grenade = 1
	}
	local var_3_25 = arg_3_1.navigation_extension
	local var_3_26 = var_3_25:get_navtag_layer_cost_table("plant_standard")

	table.merge(var_3_24, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(var_3_26, var_3_24)

	local var_3_27 = var_3_25:nav_cost_map_cost_table("plant_standard")

	AiUtils.initialize_nav_cost_map_cost_table(var_3_27)

	local var_3_28 = var_3_25:get_reusable_traverse_logic("plant_standard", var_3_27)

	GwNavTraverseLogic.set_navtag_layer_cost_table(var_3_28, var_3_26)
end

function AiBreedSnippets.on_beastmen_standard_bearer_husk_spawn(arg_4_0)
	local var_4_0 = Managers.world:world("level_world")

	WwiseUtils.trigger_unit_event(var_4_0, "Play_enemy_beastmen_standar_chanting_loop", arg_4_0, 0)
end

function AiBreedSnippets.on_beastmen_standard_bearer_update(arg_5_0, arg_5_1, arg_5_2)
	if HEALTH_ALIVE[arg_5_1.standard_unit] then
		local var_5_0 = Unit.local_position(arg_5_0, 0)
		local var_5_1 = Unit.local_position(arg_5_1.standard_unit, 0)

		arg_5_1.distance_to_standard = Vector3.distance(var_5_0, var_5_1)

		if HEALTH_ALIVE[arg_5_1.target_unit] then
			local var_5_2 = Unit.local_position(arg_5_1.target_unit, 0)

			arg_5_1.target_distance_to_standard = Vector3.distance(var_5_2, var_5_1)
		end
	else
		arg_5_1.distance_to_standard = nil
		arg_5_1.target_distance_to_standard = nil
	end

	if arg_5_1.climb_state then
		arg_5_1.has_valid_astar_path = false
	end

	if arg_5_1.plant_standard_astar_timer and Unit.alive(arg_5_1.target_unit) then
		local var_5_3 = arg_5_1.navigation_extension
		local var_5_4 = var_5_3:nav_cost_map_cost_table("plant_standard")
		local var_5_5 = var_5_3:get_reusable_traverse_logic("plant_standard", var_5_4)
		local var_5_6 = var_5_3:get_reusable_astar("plant_standard", true)

		if var_5_6 then
			if GwNavAStar.processing_finished(var_5_6) then
				if GwNavAStar.path_found(var_5_6) then
					arg_5_1.has_valid_astar_path = true
				else
					arg_5_1.has_valid_astar_path = false
				end

				var_5_3:destroy_reusable_astar("plant_standard")

				arg_5_1.plant_standard_astar_timer = arg_5_2 + 1
			end
		elseif arg_5_2 > arg_5_1.plant_standard_astar_timer then
			local var_5_7 = arg_5_1.nav_world
			local var_5_8 = Unit.local_position(arg_5_1.target_unit, 0)
			local var_5_9, var_5_10 = GwNavQueries.triangle_from_position(var_5_7, var_5_8, 1, 1)

			if var_5_9 then
				local var_5_11 = Vector3(var_5_8[1], var_5_8[2], var_5_10)
				local var_5_12 = var_5_3:get_reusable_astar("plant_standard")

				GwNavAStar.start(var_5_12, var_5_7, Unit.local_position(arg_5_0, 0), var_5_11, var_5_5)

				arg_5_1.plant_standard_astar_timer = arg_5_2 + 1
			else
				arg_5_1.plant_standard_astar_timer = arg_5_2 + 0.1
			end
		end
	end
end

function AiBreedSnippets.on_beastmen_standard_bearer_death(arg_6_0, arg_6_1)
	if arg_6_1.triggered_standard_chanting_sound then
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Stop_enemy_beastmen_standar_chanting_loop", arg_6_0)
	end
end

function AiBreedSnippets.on_beastmen_ungor_archer_spawn(arg_7_0, arg_7_1)
	arg_7_1.archer_broadphase_results = {}
	arg_7_1.physics_world = World.get_data(arg_7_1.world, "physics_world")
	arg_7_1.pause_line_of_sight_t = Managers.time:time("game") + Math.random_range(4, 8)
end

function AiBreedSnippets.on_beastmen_ungor_archer_death(arg_8_0, arg_8_1)
	if arg_8_1.is_volley_leader then
		local var_8_0 = arg_8_1.nearby_archers
		local var_8_1 = #var_8_0

		for iter_8_0 = 1, var_8_1 do
			local var_8_2 = var_8_0[iter_8_0]

			if var_8_2 then
				var_8_2.volley_target_unit = nil
				var_8_2.has_volley_target = nil
				var_8_2.fire_volley_at_t = nil
			end
		end

		arg_8_1.is_volley_leader = nil
	end
end
