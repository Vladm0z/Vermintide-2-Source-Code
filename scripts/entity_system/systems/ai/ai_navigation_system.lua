-- chunkname: @scripts/entity_system/systems/ai/ai_navigation_system.lua

local var_0_0 = 5
local var_0_1 = 1
local var_0_2 = Unit.alive
local var_0_3 = {
	"AINavigationExtension",
	"PlayerBotNavigation"
}

AINavigationSystem = class(AINavigationSystem, ExtensionSystemBase)

function AINavigationSystem.init(arg_1_0, arg_1_1, arg_1_2)
	AINavigationSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_3)

	arg_1_0.unit_extension_data = {}
	arg_1_0.frozen_unit_extension_data = {}
	arg_1_0.enabled_units = {}
	arg_1_0.delayed_units = {}
	arg_1_0.navbots_to_release = {}
	arg_1_0.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._nav_safe_callbacks = {}
end

function AINavigationSystem.destroy(arg_2_0)
	AINavigationSystem.super.destroy(arg_2_0)
end

function AINavigationSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = AINavigationSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	if arg_3_3 == "AINavigationExtension" then
		arg_3_0.unit_extension_data[arg_3_2] = var_3_0
	end

	return var_3_0
end

function AINavigationSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.frozen_unit_extension_data[arg_4_1] = nil

	arg_4_0:_cleanup_extension(arg_4_1, arg_4_2)
	AINavigationSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
end

function AINavigationSystem.on_freeze_extension(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.unit_extension_data[arg_5_1] or arg_5_0.delayed_units[arg_5_1]

	fassert(var_5_0, "Unit was already frozen.")

	if var_5_0 == nil then
		return
	end

	arg_5_0.frozen_unit_extension_data[arg_5_1] = var_5_0

	arg_5_0:_cleanup_extension(arg_5_1, arg_5_2)
end

function AINavigationSystem._cleanup_extension(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.unit_extension_data[arg_6_1] = nil
	arg_6_0.enabled_units[arg_6_1] = nil

	if arg_6_0.delayed_unit == arg_6_1 then
		arg_6_0.delayed_unit = next(arg_6_0.delayed_units, arg_6_1)
	end

	arg_6_0.delayed_units[arg_6_1] = nil
end

function AINavigationSystem.freeze(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.frozen_unit_extension_data

	if var_7_0[arg_7_1] then
		return
	end

	local var_7_1 = arg_7_0.unit_extension_data[arg_7_1] or arg_7_0.delayed_units[arg_7_1]

	fassert(var_7_1, "Unit to freeze didn't have unfrozen extension")
	arg_7_0:_cleanup_extension(arg_7_1, arg_7_2)

	arg_7_0.unit_extension_data[arg_7_1] = nil
	var_7_0[arg_7_1] = var_7_1

	var_7_1:freeze()
end

function AINavigationSystem.unfreeze(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.frozen_unit_extension_data[arg_8_1]

	fassert(var_8_0, "Unit to unfreeze didn't have frozen extension")

	arg_8_0.frozen_unit_extension_data[arg_8_1] = nil
	arg_8_0.unit_extension_data[arg_8_1] = var_8_0

	var_8_0:unfreeze()
end

function AINavigationSystem.simulate_dummy_target(arg_9_0, arg_9_1)
	local var_9_0 = Managers.player:local_player().player_unit

	if not var_9_0 then
		return
	end

	local var_9_1 = POSITION_LOOKUP[var_9_0]
	local var_9_2 = ConflictUtils.simulate_dummy_target(arg_9_0.nav_world, var_9_1, arg_9_1)

	if var_9_2 then
		QuickDrawer:sphere(var_9_2, 1)

		for iter_9_0, iter_9_1 in pairs(arg_9_0.unit_extension_data) do
			iter_9_1._blackboard.goal_destination = Vector3Box(var_9_2)

			iter_9_1:move_to(var_9_2)
		end
	end
end

function AINavigationSystem.update(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.dt

	arg_10_0:update_extension("PlayerBotNavigation", var_10_0, arg_10_1, arg_10_2)
	arg_10_0:update_navbots_to_release()
	arg_10_0:update_enabled()
	arg_10_0:update_destination(arg_10_2)
	arg_10_0:update_desired_velocity(arg_10_2, var_10_0)
	arg_10_0:update_next_smart_object(arg_10_2, var_10_0)

	if not script_data.disable_crowd_dispersion then
		arg_10_0:update_dispersion()
	end

	local var_10_1 = arg_10_0._nav_safe_callbacks
	local var_10_2 = #var_10_1

	if var_10_2 > 0 then
		for iter_10_0 = 1, var_10_2 do
			var_10_1[iter_10_0]()
		end

		table.clear(var_10_1)
	end
end

function AINavigationSystem.add_safe_navigation_callback(arg_11_0, arg_11_1)
	arg_11_0._nav_safe_callbacks[#arg_11_0._nav_safe_callbacks + 1] = arg_11_1
end

function AINavigationSystem.post_update(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_1.dt

	arg_12_0:update_position()
end

function AINavigationSystem.add_navbot_to_release(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.unit_extension_data[arg_13_1] or arg_13_0.delayed_units[arg_13_1]

	arg_13_0.navbots_to_release[arg_13_1] = var_13_0
end

function AINavigationSystem.update_navbots_to_release(arg_14_0)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.navbots_to_release) do
		iter_14_1:release_bot()

		arg_14_0.navbots_to_release[iter_14_0] = nil
		arg_14_0.enabled_units[iter_14_0] = nil

		if arg_14_0.delayed_unit == iter_14_0 then
			arg_14_0.delayed_unit = next(arg_14_0.delayed_units, iter_14_0)
		end

		arg_14_0.delayed_units[iter_14_0] = nil
	end
end

function AINavigationSystem.update_enabled(arg_15_0)
	for iter_15_0, iter_15_1 in pairs(arg_15_0.unit_extension_data) do
		local var_15_0 = iter_15_1._nav_bot ~= nil and iter_15_1._enabled

		arg_15_0.enabled_units[iter_15_0] = var_15_0 and iter_15_1 or nil
	end

	for iter_15_2, iter_15_3 in pairs(arg_15_0.delayed_units) do
		local var_15_1 = iter_15_3._nav_bot ~= nil and iter_15_3._enabled

		arg_15_0.enabled_units[iter_15_2] = var_15_1 and iter_15_3 or nil
	end
end

function AINavigationSystem.update_destination(arg_16_0, arg_16_1)
	local var_16_0 = POSITION_LOOKUP
	local var_16_1 = Vector3.distance_squared
	local var_16_2 = Managers.state.conflict.navigation_group_manager

	for iter_16_0, iter_16_1 in pairs(arg_16_0.enabled_units) do
		local var_16_3 = iter_16_1._nav_bot
		local var_16_4 = false
		local var_16_5 = false

		if var_16_3 then
			var_16_5 = GwNavBot.is_following_path(var_16_3)
			var_16_4 = GwNavBot.is_computing_new_path(var_16_3)
		end

		local var_16_6 = iter_16_1._blackboard

		var_16_6.is_navbot_following_path = var_16_5
		iter_16_1._is_computing_path = var_16_4
		iter_16_1._is_navbot_following_path = var_16_5

		if var_16_3 and not var_16_4 and arg_16_1 > iter_16_1._wait_timer then
			local var_16_7 = var_16_0[iter_16_0]
			local var_16_8 = iter_16_1._destination:unbox()
			local var_16_9 = iter_16_1._wanted_destination:unbox()
			local var_16_10 = true

			if iter_16_1._has_started_pathfind then
				iter_16_1._has_started_pathfind = nil

				local var_16_11 = var_16_1(var_16_7, var_16_8) < 0.01

				if var_16_5 or var_16_11 then
					var_16_6.no_path_found = nil
					iter_16_1._failed_move_attempts = 0

					if iter_16_1._nav_channel_disabled_on_fail then
						GwNavBot.set_use_channel(var_16_3, true)

						iter_16_1._nav_channel_disabled_on_fail = false
					end
				else
					var_16_10 = false
					var_16_6.no_path_found = true
					iter_16_1._failed_move_attempts = iter_16_1._failed_move_attempts + 1
					iter_16_1._wait_timer = arg_16_1 + math.min(var_0_0, var_0_1 * iter_16_1._failed_move_attempts)

					if iter_16_1._far_pathing_allowed and not arg_16_0:setup_far_astar(var_16_7, var_16_9, iter_16_1, var_16_6, var_16_3) then
						iter_16_1._failed_move_attempts = iter_16_1._failed_move_attempts + 1

						iter_16_1._wanted_destination:store(var_16_8)

						var_16_6.target_outside_navmesh = true

						if RecycleSettings.destroy_no_path_found_time then
							arg_16_0.delayed_units[iter_16_0] = iter_16_1
							arg_16_0.unit_extension_data[iter_16_0] = nil
							iter_16_1.delayed_check_time = arg_16_1 + 1.5

							if not iter_16_1.delayed_max_time then
								iter_16_1.delayed_max_time = arg_16_1 + RecycleSettings.destroy_no_path_found_time
							end
						end
					end

					if var_16_6.breed.use_navigation_path_splines then
						GwNavBot.set_use_channel(var_16_3, false)

						iter_16_1._nav_channel_disabled_on_fail = true
					end
				end
			end

			if var_16_6.far_path and var_16_5 then
				local var_16_12 = false

				if iter_16_1:get_path_node_count() > 0 then
					local var_16_13 = iter_16_1:get_remaining_distance_from_progress_to_end_of_path()

					var_16_12 = var_16_13 and var_16_13 < 1
				end

				if var_16_12 then
					var_16_10 = false

					local var_16_14 = iter_16_1._backup_destination:unbox()
					local var_16_15 = iter_16_1._original_backup_destination:unbox()
					local var_16_16 = var_16_2:get_group_from_position(var_16_14)
					local var_16_17 = var_16_2:get_group_from_position(var_16_15)
					local var_16_18 = var_16_6.current_far_path_index
					local var_16_19 = var_16_6.num_far_path_nodes
					local var_16_20

					if var_16_16 == var_16_17 and var_16_18 < var_16_19 - 1 then
						local var_16_21 = var_16_6.far_path
						local var_16_22 = var_16_18 + 1

						var_16_20 = var_16_21[var_16_22]:get_group_center():unbox()
						var_16_6.current_far_path_index = var_16_22
					else
						var_16_6.far_path = nil
						var_16_6.current_far_path_index = nil
						var_16_6.num_far_path_nodes = nil
						var_16_20 = var_16_14
					end

					GwNavBot.compute_new_path(var_16_3, var_16_20)
					iter_16_1._wanted_destination:store(var_16_20)
					iter_16_1._destination:store(var_16_20)

					iter_16_1._is_computing_path = true
					iter_16_1._has_started_pathfind = true
					var_16_6.next_smart_object_data.next_smart_object_id = nil
				end
			end

			if var_16_10 then
				local var_16_23 = var_16_6.breed.navigation_far_away_distance_sq or 36
				local var_16_24 = var_16_1(var_16_8, var_16_9)
				local var_16_25 = var_16_1(var_16_7, var_16_9)
				local var_16_26 = var_16_23 < var_16_25
				local var_16_27 = var_16_26 and var_16_24 > 9 or not var_16_26 and var_16_24 > 0.01
				local var_16_28 = var_16_25 < 0.01

				if GwNavBot.is_path_recomputation_needed(var_16_3) or not var_16_28 and (not var_16_5 or var_16_27) then
					GwNavBot.compute_new_path(var_16_3, var_16_9)
					iter_16_1._destination:store(var_16_9)

					iter_16_1._is_computing_path = true
					iter_16_1._has_started_pathfind = true
					iter_16_1._wait_timer = 0
					var_16_6.next_smart_object_data.next_smart_object_id = nil
				end
			end
		end
	end

	arg_16_0:update_delayed_units(arg_16_1)
end

function AINavigationSystem.update_delayed_units(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.delayed_units
	local var_17_1 = arg_17_0.delayed_unit

	if var_0_2(var_17_1) then
		local var_17_2 = var_17_0[var_17_1]

		if arg_17_1 > var_17_2.delayed_check_time then
			arg_17_0.unit_extension_data[var_17_1] = var_17_2
			arg_17_0.delayed_unit = next(var_17_0, var_17_1)
			var_17_0[var_17_1] = nil

			local var_17_3 = var_17_2._nav_bot

			if var_17_3 and GwNavBot.is_following_path(var_17_3) then
				var_17_2.delayed_max_time = nil

				return
			end

			if arg_17_1 > var_17_2.delayed_max_time then
				if RecycleSettings.destroy_no_path_only_behind then
					local var_17_4 = Managers.state.conflict
					local var_17_5 = var_17_4.main_path_info

					if var_0_2(var_17_5.behind_unit) then
						local var_17_6 = var_17_4.main_path_player_info[var_17_5.behind_unit]
						local var_17_7, var_17_8, var_17_9, var_17_10, var_17_11 = MainPathUtils.closest_pos_at_main_path(nil, POSITION_LOOKUP[var_17_1])

						if var_17_11 < var_17_6.path_index then
							Managers.state.conflict:destroy_unit(var_17_1, var_17_2._blackboard, "main_path_blocked")
						end
					end
				else
					Managers.state.conflict:destroy_unit(var_17_1, var_17_2._blackboard, "no_path_found")
				end
			end
		end
	end

	if arg_17_0.delayed_unit == var_17_1 then
		arg_17_0.delayed_unit = next(var_17_0, var_17_1)
	end
end

function AINavigationSystem.setup_far_astar(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	if arg_18_4.far_path then
		arg_18_4.far_path = nil
		arg_18_4.current_far_path_index = nil
		arg_18_4.num_far_path_nodes = nil
	end

	local var_18_0, var_18_1, var_18_2, var_18_3 = arg_18_0:far_astar(arg_18_1, arg_18_2)

	if var_18_0 then
		arg_18_3:move_to(var_18_1)
		arg_18_3._backup_destination:store(arg_18_2)
		arg_18_3._original_backup_destination:store(arg_18_2)

		arg_18_4.far_path = var_18_2
		arg_18_4.current_far_path_index = 2
		arg_18_4.num_far_path_nodes = var_18_3

		GwNavBot.compute_new_path(arg_18_5, var_18_1)
		arg_18_3._destination:store(var_18_1)

		arg_18_3._is_computing_path = true
		arg_18_3._has_started_pathfind = true
		arg_18_3._wait_timer = 0
		arg_18_4.next_smart_object_data.next_smart_object_id = nil

		return true
	end
end

function AINavigationSystem.far_astar(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0, var_19_1 = Managers.state.conflict.navigation_group_manager:a_star_cached_between_positions(arg_19_1, arg_19_2)

	if not var_19_0 then
		return false
	end

	local var_19_2 = #var_19_0

	if var_19_2 <= 1 then
		return false
	end

	local var_19_3 = var_19_0[2]:get_group_center():unbox()

	return true, var_19_3, var_19_0, var_19_2
end

local var_0_4 = 0.0001

function AINavigationSystem.update_desired_velocity(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = 0
	local var_20_1 = arg_20_0.nav_world

	for iter_20_0, iter_20_1 in pairs(arg_20_0.enabled_units) do
		local var_20_2 = iter_20_1._blackboard
		local var_20_3

		if var_20_2.move_state ~= "idle" then
			var_20_3 = GwNavBot.output_velocity(iter_20_1._nav_bot)
		else
			var_20_3 = Vector3.zero()
		end

		local var_20_4 = var_20_3
		local var_20_5 = POSITION_LOOKUP[iter_20_0]
		local var_20_6 = iter_20_1._wanted_destination:unbox()
		local var_20_7 = Vector3.distance_squared(var_20_5, var_20_6)
		local var_20_8 = var_20_7 < 0.010000000000000002
		local var_20_9 = Vector3.length_squared(var_20_3)
		local var_20_10 = var_20_2.locomotion_extension

		if Vector3.length_squared(var_20_10:current_velocity()) == 0 then
			iter_20_1._interpolating = false
		end

		local var_20_11 = iter_20_1._is_computing_path
		local var_20_12 = iter_20_1._is_navbot_following_path

		if var_20_9 < var_0_4 and not var_20_8 and var_20_11 and var_20_12 or iter_20_1._interpolating then
			iter_20_1._interpolating = var_20_11

			if var_20_11 then
				local var_20_13 = Quaternion.look(Vector3.flat(var_20_6 - var_20_5), Vector3.up())
				local var_20_14 = iter_20_1._max_speed

				if var_20_0 < 1 and arg_20_1 > iter_20_1._raycast_timer then
					iter_20_1._raycast_timer = arg_20_1 + 1
					var_20_0 = var_20_0 + 1

					local var_20_15 = var_20_5 + Quaternion.forward(var_20_13) * 2

					if not GwNavQueries.raycango(var_20_1, var_20_5, var_20_15, iter_20_1._traverse_logic) then
						var_20_2.no_path_found = true
						iter_20_1._interpolating = nil
						var_20_14 = 0 or var_20_14
					end
				end

				local var_20_16 = var_20_10:get_rotation_speed() * var_20_10:get_rotation_speed_modifier() * arg_20_2

				if var_20_7 < 9 then
					var_20_16 = math.min(1, var_20_16 * 2)
					var_20_14 = var_20_14 * 0.5
				end

				local var_20_17 = Unit.world_rotation(iter_20_0, 0)
				local var_20_18 = Quaternion.lerp(var_20_17, var_20_13, var_20_16)

				var_20_10:set_wanted_rotation(var_20_18)

				var_20_4 = Quaternion.forward(var_20_18) * var_20_14
			end
		end

		var_20_4.z = 0

		local var_20_19 = Vector3.length(var_20_4)

		iter_20_1._current_speed = math.min(var_20_19, iter_20_1._max_speed, iter_20_1._current_speed + arg_20_2 * 3 * iter_20_1._max_speed)

		local var_20_20 = Vector3.normalize(var_20_4) * iter_20_1._current_speed

		var_20_10:set_wanted_velocity_flat(var_20_20)
	end
end

function AINavigationSystem.update_next_smart_object(arg_21_0, arg_21_1, arg_21_2)
	for iter_21_0, iter_21_1 in pairs(arg_21_0.enabled_units) do
		local var_21_0 = iter_21_1._blackboard.next_smart_object_data
		local var_21_1 = GwNavSmartObjectInterval
		local var_21_2 = iter_21_1._next_smartobject_interval
		local var_21_3 = 2

		if GwNavBot.current_or_next_smartobject_interval(iter_21_1._nav_bot, var_21_2, var_21_3) then
			local var_21_4, var_21_5 = var_21_1.entrance_position(var_21_2)
			local var_21_6, var_21_7 = var_21_1.exit_position(var_21_2)
			local var_21_8 = var_21_1.smartobject_id(var_21_2)
			local var_21_9 = Managers.state.entity:system("nav_graph_system")

			if var_21_8 ~= -1 and var_21_9:get_smart_object_type(var_21_8) then
				var_21_0.next_smart_object_id = var_21_8

				var_21_0.entrance_pos:store(var_21_4)
				var_21_0.exit_pos:store(var_21_6)

				var_21_0.entrance_is_at_bot_progress_on_path = var_21_5
				var_21_0.exit_is_at_the_end_of_path = var_21_7

				fassert(var_21_0.next_smart_object_id)

				var_21_0.smart_object_type = var_21_9:get_smart_object_type(var_21_0.next_smart_object_id)
				var_21_0.smart_object_data = var_21_9:get_smart_object_data(var_21_0.next_smart_object_id)

				fassert(LAYER_ID_MAPPING[var_21_0.smart_object_type] ~= nil, "Invalid smart object type %s", var_21_0.smart_object_type)
			end
		else
			var_21_0.next_smart_object_id = nil
		end

		if var_21_0.next_smart_object_id then
			local var_21_10 = Vector3.distance_squared(var_21_0.entrance_pos:unbox(), Unit.local_position(iter_21_1._unit, 0))

			iter_21_1._blackboard.is_in_smartobject_range = var_21_10 < 1
		end
	end
end

function AINavigationSystem.update_dispersion(arg_22_0, arg_22_1, arg_22_2)
	for iter_22_0, iter_22_1 in pairs(arg_22_0.enabled_units) do
		local var_22_0 = GwNavBot.update_logic_for_crowd_dispersion(iter_22_1._nav_bot)

		if var_22_0 == 1 then
			-- block empty
		elseif var_22_0 == 2 then
			-- block empty
		end
	end
end

function AINavigationSystem.update_position(arg_23_0, arg_23_1, arg_23_2)
	for iter_23_0, iter_23_1 in pairs(arg_23_0.enabled_units) do
		if iter_23_1._nav_bot then
			local var_23_0 = Unit.local_position(iter_23_1._unit, 0)

			GwNavBot.update_position(iter_23_1._nav_bot, var_23_0)
		end
	end
end

function AINavigationSystem.update_debug_draw(arg_24_0, arg_24_1)
	local var_24_0 = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AINavigationExtension"
	})
	local var_24_1 = Colors.get("pink")
	local var_24_2 = Colors.get("purple")
	local var_24_3 = Vector3(0, 0, 0.01)

	for iter_24_0, iter_24_1 in pairs(arg_24_0.unit_extension_data) do
		local var_24_4 = Unit.local_position(iter_24_0, 0)
		local var_24_5 = arg_24_0.enabled_units[iter_24_0]
		local var_24_6 = var_24_5 and var_24_1 or var_24_2
		local var_24_7 = iter_24_1._wanted_destination:unbox()
		local var_24_8 = iter_24_1._destination:unbox()

		var_24_0:sphere(var_24_4, 0.1, var_24_6)
		var_24_0:sphere(var_24_7, 0.2, var_24_6)
		var_24_0:vector(var_24_4, var_24_7 - var_24_4, var_24_6)

		if Vector3.distance_squared(var_24_7, var_24_8) > 0.1 then
			var_24_0:vector(var_24_4 + var_24_3, var_24_8 - var_24_4, Colors.get("green"))
		end

		if var_24_5 then
			local var_24_9 = GwNavBot.velocity(iter_24_1._nav_bot)

			if Vector3.length(var_24_9) > 0 then
				var_24_0:vector(var_24_4 + Vector3.up(), Vector3.normalize(var_24_9), var_24_6)
			end
		end

		local var_24_10 = iter_24_1._blackboard.next_smart_object_data

		if var_24_10.next_smart_object_id then
			local var_24_11 = var_24_10.entrance_pos:unbox()
			local var_24_12 = var_24_10.exit_pos:unbox()

			var_24_0:sphere(var_24_11, 0.3, var_24_10.entrance_is_at_bot_progress_on_path and Colors.get("pink") or Colors.get("red"))
			var_24_0:sphere(var_24_12, 0.3, var_24_10.exit_is_at_the_end_of_path and Colors.get("pink") or Colors.get("red"))
			var_24_0:vector(var_24_11, var_24_12 - var_24_11, var_24_10.next_smart_object_id and Colors.get("pink") or Colors.get("red"))
		end
	end

	local var_24_13 = script_data.debug_unit
	local var_24_14 = arg_24_0.unit_extension_data[var_24_13] or arg_24_0.delayed_units[var_24_13]

	if var_0_2(var_24_13) and var_24_14 then
		local var_24_15 = var_24_14._blackboard

		if script_data.debug_ai_movement == "text_and_graphics" then
			arg_24_0:_debug_draw_text(var_24_13, var_24_15, var_24_14, arg_24_1)
		end

		arg_24_0:_debug_draw_nav_path(var_24_0, var_24_14)
		arg_24_0:_debug_draw_far_path(var_24_0, var_24_13, var_24_15, var_24_14)
	end
end

function AINavigationSystem._debug_draw_text(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	Debug.text("AI NAVIGATION DEBUG")
	Debug.text("  enabled = %s", tostring(arg_25_0.enabled_units[arg_25_1] ~= nil))
	Debug.text("  using far-path = %s", arg_25_2.far_path and "YES" or "NO")
	Debug.text("  has_reached = %s", tostring(arg_25_3:has_reached_destination()))
	Debug.text("  remaining path distance = %.2f", arg_25_3:get_remaining_distance_from_progress_to_end_of_path() or 0)
	Debug.text("  dist to dest = %.2f", tostring(arg_25_3:distance_to_destination()))
	Debug.text("  current_speed = %.2f", arg_25_3._current_speed)
	Debug.text("  desired_velocity = %s", arg_25_3._nav_bot and tostring(GwNavBot.output_velocity(arg_25_3._nav_bot)) or "?")
	Debug.text("  failed_move_attempts = %d", arg_25_3._failed_move_attempts)
	Debug.text("  no_path_found = %s", tostring(arg_25_2.no_path_found))
	Debug.text("  is_computing_path = %s", tostring(arg_25_3._is_computing_path))
	Debug.text("  is_following_path = %s", tostring(arg_25_3:is_following_path()))
	Debug.text("  interpolating = %s", tostring(arg_25_3._interpolating))
	Debug.text("  move_state = %s", tostring(arg_25_3._blackboard.move_state or "nil"))
	Debug.text("  btnode = %s", tostring(arg_25_2.btnode_name))
	Debug.text("  wait_timer = %.1f", math.max(-1, arg_25_3._wait_timer - arg_25_4))
end

function AINavigationSystem._debug_draw_nav_path(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_2._nav_bot

	if var_26_0 == nil then
		return
	end

	if not arg_26_2._is_navbot_following_path then
		return
	end

	local var_26_1 = GwNavBot.get_path_nodes_count(var_26_0)

	if var_26_1 > 0 then
		local var_26_2
		local var_26_3 = GwNavBot.get_path_current_node_index(var_26_0)
		local var_26_4 = Vector3.up() * 0.05

		for iter_26_0 = 0, var_26_1 - 1 do
			local var_26_5 = GwNavBot.get_path_node_pos(var_26_0, iter_26_0)
			local var_26_6 = var_26_3 == iter_26_0 and Colors.get("green") or Colors.get("powder_blue")

			arg_26_1:sphere(var_26_5 + var_26_4, 0.1, var_26_6)

			if var_26_2 then
				arg_26_1:line(var_26_5 + var_26_4, var_26_2 + var_26_4, Colors.get("powder_blue"))
			end

			var_26_2 = var_26_5
		end
	end
end

function AINavigationSystem._debug_draw_far_path(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = arg_27_3.far_path

	if var_27_0 then
		local var_27_1 = POSITION_LOOKUP[arg_27_2]
		local var_27_2 = arg_27_3.num_far_path_nodes
		local var_27_3 = arg_27_3.current_far_path_index
		local var_27_4

		for iter_27_0 = 1, var_27_2 do
			local var_27_5 = var_27_0[iter_27_0]:get_group_center():unbox()
			local var_27_6 = iter_27_0 < var_27_3 and Colors.get("yellow")
			local var_27_7 = 0.1

			if iter_27_0 < var_27_3 then
				var_27_6 = Colors.get("orange")
			elseif iter_27_0 == var_27_3 then
				var_27_6 = Colors.get("green")
				var_27_7 = var_27_7 + math.random() * 0.1
			elseif iter_27_0 < var_27_2 then
				var_27_6 = Colors.get("yellow")
			else
				var_27_6 = Colors.get("black")
			end

			if var_27_4 then
				arg_27_1:line(var_27_4, var_27_5, var_27_6)
			end

			arg_27_1:sphere(var_27_5, var_27_7, var_27_6)

			var_27_4 = var_27_5
		end

		local var_27_8 = arg_27_4._backup_destination:unbox()

		arg_27_1:sphere(var_27_8, 0.1, Colors.get("yellow"))
		arg_27_1:sphere(var_27_8, 0.2, Colors.get("yellow"))
		arg_27_1:vector(var_27_1, var_27_8 - var_27_1, Colors.get("yellow"))
	end
end

NAVIGATION_RUNNING_IN_THREAD = false

function AINavigationSystem.override_nav_funcs(arg_28_0)
	local var_28_0 = {
		"GwNavWorld",
		"GwNavBot",
		"GwNavQueries",
		"GwNavSmartObjectInterval",
		"GwNavTagLayerCostTable",
		"GwNavTraverseLogic",
		"GwNavBoxObstacle",
		"GwNavAStar",
		"GwNavCylinderObstacle",
		"GwNavTagVolume"
	}

	for iter_28_0 = 1, #var_28_0 do
		local var_28_1 = var_28_0[iter_28_0]
		local var_28_2 = _G[var_28_1]

		for iter_28_1, iter_28_2 in pairs(var_28_2) do
			if iter_28_1 ~= "join_async_update" and iter_28_1 ~= "kick_async_update" then
				var_28_2[iter_28_1] = function(...)
					fassert(not NAVIGATION_RUNNING_IN_THREAD, "%s.%s() function was run during navigation running on other thread", var_28_1, iter_28_1)

					return iter_28_2(...)
				end
			end
		end
	end
end
