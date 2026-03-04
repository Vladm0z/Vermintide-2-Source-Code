-- chunkname: @scripts/settings/dlcs/steak/steak_ai_breed_snippets.lua

AiBreedSnippets = AiBreedSnippets or {}

function AiBreedSnippets.on_beastmen_minotaur_spawn(arg_1_0, arg_1_1)
	arg_1_1.charge_astar_timer = Managers.time:time("game")
	arg_1_1.num_charges_targeting_target = 0
	arg_1_1.target_is_charged = false
	arg_1_1.aggro_list = {}

	local var_1_0 = arg_1_1.breed
	local var_1_1 = {
		planks = 1,
		bot_ratling_gun_fire = 1,
		doors = 1,
		destructible_wall = 0,
		bot_poison_wind = 1,
		temporary_wall = 0,
		fire_grenade = 1
	}
	local var_1_2 = arg_1_1.navigation_extension
	local var_1_3 = var_1_2:get_navtag_layer_cost_table("charge")

	table.merge(var_1_1, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(var_1_3, var_1_1)

	local var_1_4 = var_1_2:nav_cost_map_cost_table("charge")

	AiUtils.initialize_nav_cost_map_cost_table(var_1_4)

	local var_1_5 = var_1_2:get_reusable_traverse_logic("charge", var_1_4)

	GwNavTraverseLogic.set_navtag_layer_cost_table(var_1_5, var_1_3)

	arg_1_1.aggro_list = {}
	arg_1_1.fling_skaven_timer = 0
	arg_1_1.next_move_check = 0
	arg_1_1.is_valid_target_func = GenericStatusExtension.is_ogre_target

	local var_1_6 = Managers.state.conflict

	ScriptUnit.extension(arg_1_0, "ai_system"):set_perception(var_1_0.perception, var_1_0.target_selection_angry)
	var_1_6:add_angry_boss(1, arg_1_1)

	arg_1_1.is_angry = true

	local var_1_7 = Managers.state.side.side_by_unit[arg_1_0].ENEMY_PLAYER_AND_BOT_UNITS
	local var_1_8 = var_1_0.perception_weights
	local var_1_9 = 0
	local var_1_10

	for iter_1_0 = 1, #var_1_7 do
		local var_1_11 = var_1_7[iter_1_0]
		local var_1_12 = POSITION_LOOKUP[var_1_11]
		local var_1_13 = POSITION_LOOKUP[arg_1_0]
		local var_1_14 = Vector3.distance(var_1_13, var_1_12)

		if var_1_14 < var_1_0.detection_radius then
			local var_1_15 = math.clamp(1 - var_1_14 / var_1_8.max_distance, 0, 1)
			local var_1_16 = var_1_15 * var_1_15 * var_1_8.distance_weight

			if var_1_9 < var_1_16 then
				var_1_9 = var_1_16
				var_1_10 = var_1_11
			end
		end
	end

	if var_1_10 then
		arg_1_1.aggro_list[var_1_10] = 50
	end

	var_1_6:freeze_intensity_decay(10)
	var_1_6:add_unit_to_bosses(arg_1_0)
end

function AiBreedSnippets.on_beastmen_minotaur_update(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_1.navigation_extension:nav_cost_map_cost_table("charge")
	local var_2_1 = arg_2_1.navigation_extension:get_reusable_traverse_logic("charge", var_2_0)

	if var_2_1 and arg_2_1.charge_astar_timer and not arg_2_1.charge_state and Unit.alive(arg_2_1.target_unit) then
		local var_2_2 = arg_2_1.navigation_extension:get_reusable_astar("charge", true)

		if var_2_2 then
			if GwNavAStar.processing_finished(var_2_2) then
				if GwNavAStar.path_found(var_2_2) then
					arg_2_1.has_valid_astar_path = true
				else
					arg_2_1.has_valid_astar_path = false
				end

				arg_2_1.navigation_extension:destroy_reusable_astar("charge")

				arg_2_1.charge_astar_timer = arg_2_2 + 1
			end
		elseif arg_2_2 > arg_2_1.charge_astar_timer then
			local var_2_3 = arg_2_1.nav_world
			local var_2_4 = Unit.local_position(arg_2_1.target_unit, 0)
			local var_2_5, var_2_6 = GwNavQueries.triangle_from_position(var_2_3, var_2_4, 1, 1)

			if var_2_5 then
				local var_2_7 = Vector3(var_2_4[1], var_2_4[2], var_2_6)
				local var_2_8 = 7
				local var_2_9 = arg_2_1.navigation_extension:get_reusable_astar("charge")

				GwNavAStar.start_with_propagation_box(var_2_9, var_2_3, Unit.local_position(arg_2_0, 0), var_2_7, var_2_8, var_2_1)

				arg_2_1.charge_astar_timer = arg_2_2 + 1
			else
				arg_2_1.charge_astar_timer = arg_2_2 + 0.1
			end
		end
	end
end

function AiBreedSnippets.on_beastmen_minotaur_death(arg_3_0, arg_3_1, arg_3_2)
	print("minotaur died!")

	if not arg_3_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_3_0, arg_3_1)
	end

	local var_3_0 = Managers.state.conflict

	if arg_3_1.is_angry then
		var_3_0:add_angry_boss(-1)
	end

	var_3_0:freeze_intensity_decay(1)
	var_3_0:remove_unit_from_bosses(arg_3_0)
end
