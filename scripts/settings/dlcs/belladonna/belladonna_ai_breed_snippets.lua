-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_ai_breed_snippets.lua

local AiBreedSnippets = AiBreedSnippets

AiBreedSnippets = AiBreedSnippets or {}
AiBreedSnippets = AiBreedSnippets

AiBreedSnippets.on_beastmen_bestigor_spawn = function (arg_1_0, arg_1_1)
	-- function 1
	arg_1_1.charge_astar_timer = Managers.time:time("game")
	arg_1_1.num_charges_targeting_target = 0
	arg_1_1.target_is_charged = false
	arg_1_1.aggro_list = {}

	local tbl = {
		planks = 1,
		bot_ratling_gun_fire = 1,
		doors = 1,
		bot_poison_wind = 1,
		fire_grenade = 1
	}
	local navigation_extension = arg_1_1.navigation_extension
	local get_navtag_layer_cost_table = navigation_extension:get_navtag_layer_cost_table("charge")

	table.merge(tbl, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(get_navtag_layer_cost_table, tbl)

	local nav_cost_map_cost_table = navigation_extension:nav_cost_map_cost_table("charge")

	AiUtils.initialize_nav_cost_map_cost_table(nav_cost_map_cost_table)

	local get_reusable_traverse_logic = navigation_extension:get_reusable_traverse_logic("charge", nav_cost_map_cost_table)

	GwNavTraverseLogic.set_navtag_layer_cost_table(get_reusable_traverse_logic, get_navtag_layer_cost_table)
end

AiBreedSnippets.on_beastmen_bestigor_update = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0
	local nav_cost_map_cost_table = arg_2_1.navigation_extension:nav_cost_map_cost_table("charge")
	local get_reusable_traverse_logic = arg_2_1.navigation_extension:get_reusable_traverse_logic("charge", nav_cost_map_cost_table)

	if not get_reusable_traverse_logic and not arg_2_1.charge_astar_timer and arg_2_1.charge_state or not Unit.alive(arg_2_1.target_unit) then
		local get_reusable_astar = arg_2_1.navigation_extension:get_reusable_astar("charge", true)

		if not get_reusable_astar then
			if not GwNavAStar.processing_finished(get_reusable_astar) then
				if not GwNavAStar.path_found(get_reusable_astar) then
					arg_2_1.has_valid_astar_path = true
				else
					arg_2_1.has_valid_astar_path = false
				end

				arg_2_1.navigation_extension:destroy_reusable_astar("charge")

				arg_2_1.charge_astar_timer = arg_2_2 + 1
			end
		elseif arg_2_2 > arg_2_1.charge_astar_timer then
			local nav_world = arg_2_1.nav_world
			local local_position = Unit.local_position(arg_2_1.target_unit, 0)
			local triangle_from_position, var_2_7 = GwNavQueries.triangle_from_position(nav_world, local_position, 1, 1)

			if not triangle_from_position then
				local var_2_8 = Vector3(local_position[1], local_position[2], var_2_7)
				local num = 7
				local get_reusable_astar_2 = arg_2_1.navigation_extension:get_reusable_astar("charge")

				GwNavAStar.start_with_propagation_box(get_reusable_astar_2, nav_world, Unit.local_position(arg_2_0, 0), var_2_8, num, get_reusable_traverse_logic)

				arg_2_1.charge_astar_timer = arg_2_2 + 1
			else
				arg_2_1.charge_astar_timer = arg_2_2 + 0.1
			end
		end
	end

	if not Unit.alive(arg_2_1.target_unit) then
		local has_extension = ScriptUnit.has_extension(arg_2_1.target_unit, "status_system")

		if not has_extension then
			local num_charges_targeting_player = has_extension.num_charges_targeting_player

			num_charges_targeting_player = num_charges_targeting_player or 0
			arg_2_1.num_charges_targeting_target = num_charges_targeting_player
			arg_2_1.target_is_charged = has_extension:is_charged()
		end
	end
end

AiBreedSnippets.on_beastmen_standard_bearer_spawn = function (arg_3_0, arg_3_1)
	-- function 3
	arg_3_1.switching_weapons = 1
	arg_3_1.buff_extension = ScriptUnit.extension(arg_3_0, "buff_system")

	if arg_3_1.spawn_category ~= "patrol" then
		WwiseUtils.trigger_unit_event(arg_3_1.world, "Play_enemy_beastmen_standar_chanting_loop", arg_3_0, 0)

		arg_3_1.triggered_standard_chanting_sound = true
	end

	if not (arg_3_1.spawn_type == "terror_event" or arg_3_1.spawn_category == "patrol") then
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_0, true)

		local num = 3
		local local_rotation = Unit.local_rotation(arg_3_0, 0)
		local conflict = Managers.state.conflict
		local nav_world = conflict.nav_world
		local world_position = Unit.world_position(arg_3_0, 0)
		local standard_bearer_spawn_list = BreedTweaks.standard_bearer_spawn_list
		local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(standard_bearer_spawn_list)
		local get_startup_breeds = Managers.level_transition_handler.enemy_package_loader:get_startup_breeds()
		local standard_bearer_spawn_list_replacements = BreedTweaks.standard_bearer_spawn_list_replacements
		local tbl = {}

		for i = 1, #get_difficulty_value_from_table do
			local var_3_10 = get_difficulty_value_from_table[i]

			if not get_startup_breeds[var_3_10] then
				local var_3_11
				local flag = false

				for j = 1, #standard_bearer_spawn_list_replacements do
					local var_3_13 = standard_bearer_spawn_list_replacements[j]

					if not flag and not get_startup_breeds[var_3_13] then
						var_3_11 = var_3_13

						break
					elseif var_3_13 == var_3_10 then
						flag = true
					end
				end

				if not var_3_11 then
					tbl[#tbl + 1] = var_3_11
				end
			else
				tbl[#tbl + 1] = var_3_10
			end
		end

		local count = #tbl
		local num_2 = 1
		local num_3 = 1

		for k = 1, count do
			local num_4 = world_position + Vector3(-num / 2 + k % num, -num / 2 + math.floor(k / num), 0) * 2
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, num_4, num_2, num_3)
			local var_3_19 = Breeds[tbl[k]]
			local var_3_20

			if not pos_on_mesh then
				conflict:spawn_queued_unit(var_3_19, Vector3Box(pos_on_mesh), QuaternionBox(local_rotation), "hidden_spawn", nil, "horde_hidden", var_3_20)
			else
				local num_5 = 1
				local num_6 = 0.1
				local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, num_4, num_2, num_3, num_5, num_6)

				inside_position_from_outside_position = inside_position_from_outside_position or POSITION_LOOKUP[arg_3_0]

				conflict:spawn_queued_unit(var_3_19, Vector3Box(inside_position_from_outside_position), QuaternionBox(local_rotation), "hidden_spawn", nil, "horde_hidden", var_3_20)
			end
		end
	end

	if arg_3_1.spawn_type == "terror_event" then
		arg_3_1.ignore_passive_on_patrol = true
	end

	arg_3_1.plant_standard_astar_timer = Managers.time:time("game")

	local tbl_2 = {
		planks = 1,
		bot_ratling_gun_fire = 1,
		doors = 1,
		bot_poison_wind = 1,
		fire_grenade = 1
	}
	local navigation_extension = arg_3_1.navigation_extension
	local get_navtag_layer_cost_table = navigation_extension:get_navtag_layer_cost_table("plant_standard")

	table.merge(tbl_2, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(get_navtag_layer_cost_table, tbl_2)

	local nav_cost_map_cost_table = navigation_extension:nav_cost_map_cost_table("plant_standard")

	AiUtils.initialize_nav_cost_map_cost_table(nav_cost_map_cost_table)

	local get_reusable_traverse_logic = navigation_extension:get_reusable_traverse_logic("plant_standard", nav_cost_map_cost_table)

	GwNavTraverseLogic.set_navtag_layer_cost_table(get_reusable_traverse_logic, get_navtag_layer_cost_table)
end

AiBreedSnippets.on_beastmen_standard_bearer_husk_spawn = function (arg_4_0)
	-- function 4
	local world = Managers.world:world("level_world")

	WwiseUtils.trigger_unit_event(world, "Play_enemy_beastmen_standar_chanting_loop", arg_4_0, 0)
end

AiBreedSnippets.on_beastmen_standard_bearer_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not HEALTH_ALIVE[arg_5_1.standard_unit] then
		local local_position = Unit.local_position(arg_5_0, 0)
		local local_position_2 = Unit.local_position(arg_5_1.standard_unit, 0)

		arg_5_1.distance_to_standard = Vector3.distance(local_position, local_position_2)

		if not HEALTH_ALIVE[arg_5_1.target_unit] then
			local local_position_3 = Unit.local_position(arg_5_1.target_unit, 0)

			arg_5_1.target_distance_to_standard = Vector3.distance(local_position_3, local_position_2)
		end
	else
		arg_5_1.distance_to_standard = nil
		arg_5_1.target_distance_to_standard = nil
	end

	if not arg_5_1.climb_state then
		arg_5_1.has_valid_astar_path = false
	end

	if not arg_5_1.plant_standard_astar_timer and not Unit.alive(arg_5_1.target_unit) then
		local navigation_extension = arg_5_1.navigation_extension
		local nav_cost_map_cost_table = navigation_extension:nav_cost_map_cost_table("plant_standard")
		local get_reusable_traverse_logic = navigation_extension:get_reusable_traverse_logic("plant_standard", nav_cost_map_cost_table)
		local get_reusable_astar = navigation_extension:get_reusable_astar("plant_standard", true)

		if not get_reusable_astar then
			if not GwNavAStar.processing_finished(get_reusable_astar) then
				if not GwNavAStar.path_found(get_reusable_astar) then
					arg_5_1.has_valid_astar_path = true
				else
					arg_5_1.has_valid_astar_path = false
				end

				navigation_extension:destroy_reusable_astar("plant_standard")

				arg_5_1.plant_standard_astar_timer = arg_5_2 + 1
			end
		elseif arg_5_2 > arg_5_1.plant_standard_astar_timer then
			local nav_world = arg_5_1.nav_world
			local local_position_4 = Unit.local_position(arg_5_1.target_unit, 0)
			local triangle_from_position, var_5_10 = GwNavQueries.triangle_from_position(nav_world, local_position_4, 1, 1)

			if not triangle_from_position then
				local var_5_11 = Vector3(local_position_4[1], local_position_4[2], var_5_10)
				local get_reusable_astar_2 = navigation_extension:get_reusable_astar("plant_standard")

				GwNavAStar.start(get_reusable_astar_2, nav_world, Unit.local_position(arg_5_0, 0), var_5_11, get_reusable_traverse_logic)

				arg_5_1.plant_standard_astar_timer = arg_5_2 + 1
			else
				arg_5_1.plant_standard_astar_timer = arg_5_2 + 0.1
			end
		end
	end
end

AiBreedSnippets.on_beastmen_standard_bearer_death = function (arg_6_0, arg_6_1)
	-- function 6
	if not arg_6_1.triggered_standard_chanting_sound then
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Stop_enemy_beastmen_standar_chanting_loop", arg_6_0)
	end
end

AiBreedSnippets.on_beastmen_ungor_archer_spawn = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_1.archer_broadphase_results = {}
	arg_7_1.physics_world = World.get_data(arg_7_1.world, "physics_world")
	arg_7_1.pause_line_of_sight_t = Managers.time:time("game") + Math.random_range(4, 8)
end

AiBreedSnippets.on_beastmen_ungor_archer_death = function (arg_8_0, arg_8_1)
	-- function 8
	if not arg_8_1.is_volley_leader then
		local nearby_archers = arg_8_1.nearby_archers
		local count = #nearby_archers

		for i = 1, count do
			local var_8_2 = nearby_archers[i]

			if not var_8_2 then
				var_8_2.volley_target_unit = nil
				var_8_2.has_volley_target = nil
				var_8_2.fire_volley_at_t = nil
			end
		end

		arg_8_1.is_volley_leader = nil
	end
end
