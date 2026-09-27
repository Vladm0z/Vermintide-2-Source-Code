-- chunkname: @scripts/settings/dlcs/steak/steak_ai_breed_snippets.lua

local AiBreedSnippets = AiBreedSnippets

AiBreedSnippets = AiBreedSnippets or {}
AiBreedSnippets = AiBreedSnippets

AiBreedSnippets.on_beastmen_minotaur_spawn = function (arg_1_0, arg_1_1)
	-- function 1
	arg_1_1.charge_astar_timer = Managers.time:time("game")
	arg_1_1.num_charges_targeting_target = 0
	arg_1_1.target_is_charged = false
	arg_1_1.aggro_list = {}

	local breed = arg_1_1.breed
	local tbl = {
		planks = 1,
		bot_ratling_gun_fire = 1,
		doors = 1,
		destructible_wall = 0,
		bot_poison_wind = 1,
		temporary_wall = 0,
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

	arg_1_1.aggro_list = {}
	arg_1_1.fling_skaven_timer = 0
	arg_1_1.next_move_check = 0
	arg_1_1.is_valid_target_func = GenericStatusExtension.is_ogre_target

	local conflict = Managers.state.conflict

	ScriptUnit.extension(arg_1_0, "ai_system"):set_perception(breed.perception, breed.target_selection_angry)
	conflict:add_angry_boss(1, arg_1_1)

	arg_1_1.is_angry = true

	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_1_0].ENEMY_PLAYER_AND_BOT_UNITS
	local perception_weights = breed.perception_weights
	local num = 0
	local var_1_10

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_1_11 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local var_1_12 = POSITION_LOOKUP[var_1_11]
		local var_1_13 = POSITION_LOOKUP[arg_1_0]
		local distance = Vector3.distance(var_1_13, var_1_12)

		if distance < breed.detection_radius then
			local clamp = math.clamp(1 - distance / perception_weights.max_distance, 0, 1)
			local num_2 = clamp * clamp * perception_weights.distance_weight

			if num < num_2 then
				num = num_2
				var_1_10 = var_1_11
			end
		end
	end

	if not var_1_10 then
		arg_1_1.aggro_list[var_1_10] = 50
	end

	conflict:freeze_intensity_decay(10)
	conflict:add_unit_to_bosses(arg_1_0)
end

AiBreedSnippets.on_beastmen_minotaur_update = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
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
			local triangle_from_position, var_2_6 = GwNavQueries.triangle_from_position(nav_world, local_position, 1, 1)

			if not triangle_from_position then
				local var_2_7 = Vector3(local_position[1], local_position[2], var_2_6)
				local num = 7
				local get_reusable_astar_2 = arg_2_1.navigation_extension:get_reusable_astar("charge")

				GwNavAStar.start_with_propagation_box(get_reusable_astar_2, nav_world, Unit.local_position(arg_2_0, 0), var_2_7, num, get_reusable_traverse_logic)

				arg_2_1.charge_astar_timer = arg_2_2 + 1
			else
				arg_2_1.charge_astar_timer = arg_2_2 + 0.1
			end
		end
	end
end

AiBreedSnippets.on_beastmen_minotaur_death = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	print("minotaur died!")

	if not arg_3_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_3_0, arg_3_1)
	end

	local conflict = Managers.state.conflict

	if not arg_3_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_3_0)
end
