-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_stand_targeting.lua

require("scripts/settings/profiles/career_constants")

local var_0_0 = "fx/bw_necromancer_ability_indicator"
local var_0_1 = 0.35
local var_0_2 = 11
local var_0_3 = -10
local var_0_4 = 0.55
local var_0_5 = 0.9

ActionCareerBwNecromancerCommandStandTargetingUtility = {}

ActionCareerBwNecromancerCommandStandTargetingUtility.generate_positions = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_3 or {}
	local var_1_1 = math.min(arg_1_2, CareerConstants.bw_necromancer.pets_per_rank)

	if var_1_1 == 0 then
		table.clear(var_1_0)

		return var_1_0
	end

	local var_1_2 = 2
	local var_1_3 = 2
	local var_1_4 = Quaternion.axis_angle(Vector3.up(), Quaternion.yaw(arg_1_1))
	local var_1_5 = Quaternion.forward(var_1_4)
	local var_1_6 = Quaternion.right(var_1_4)
	local var_1_7
	local var_1_8 = math.ceil(arg_1_2 / var_1_1)

	for iter_1_0 = 1, var_1_8 do
		local var_1_9 = math.min(arg_1_2 - (iter_1_0 - 1) * var_1_1, var_1_1)
		local var_1_10 = (var_0_1 + var_0_4) * var_1_9
		local var_1_11 = -var_1_6 * var_1_10
		local var_1_12 = var_1_6 * var_1_10
		local var_1_13 = Managers.state.entity:system("ai_system"):nav_world()
		local var_1_14, var_1_15 = GwNavQueries.raycast(var_1_13, arg_1_0, arg_1_0 + var_1_11)
		local var_1_16, var_1_17 = GwNavQueries.raycast(var_1_13, arg_1_0, arg_1_0 + var_1_12)
		local var_1_18 = var_1_15 - arg_1_0
		local var_1_19 = var_1_17 - arg_1_0
		local var_1_20 = var_1_11 * 0.5
		local var_1_21 = var_1_12 * 0.5
		local var_1_22 = Vector3.length_squared(var_1_19) < Vector3.length_squared(var_1_21) and var_1_19 - var_1_21 or Vector3.zero()
		local var_1_23 = Vector3.length_squared(var_1_18) < Vector3.length_squared(var_1_20) and var_1_18 - var_1_20 or Vector3.zero()
		local var_1_24 = Geometry.closest_point_on_line(arg_1_0 + var_1_21 + var_1_23, var_1_15, var_1_17)
		local var_1_25 = Geometry.closest_point_on_line(arg_1_0 + var_1_20 + var_1_22, var_1_15, var_1_24)
		local var_1_26 = Vector3.length(var_1_24 - var_1_25) / var_1_9

		for iter_1_1 = 1, var_1_9 do
			local var_1_27 = var_1_25 + var_1_6 * var_1_26 * (iter_1_1 - 0.5) - var_1_5 * var_0_5 * (iter_1_0 - 1)
			local var_1_28 = LocomotionUtils.pos_on_mesh(var_1_13, var_1_27, var_1_2, var_1_3)
			local var_1_29 = (iter_1_0 - 1) * var_1_1 + iter_1_1

			if not var_1_28 then
				local var_1_30 = 3
				local var_1_31 = 0.5

				var_1_28 = GwNavQueries.inside_position_from_outside_position(var_1_13, var_1_27, var_1_2, var_1_3, var_1_30, var_1_31)
			end

			if var_1_28 then
				var_1_0[var_1_29] = Vector3Box(var_1_28)
				var_1_7 = var_1_7 or var_1_28
			else
				var_1_0[var_1_29] = false
			end
		end
	end

	if not var_1_7 then
		table.clear(var_1_0)

		return var_1_0
	end

	for iter_1_2 = 1, arg_1_2 do
		if not var_1_0[iter_1_2] then
			var_1_0[iter_1_2] = Vector3Box(var_1_7)
		else
			var_1_7 = var_1_0[iter_1_2]:unbox()
		end
	end

	for iter_1_3 = arg_1_2 + 1, #var_1_0 do
		var_1_0[iter_1_3] = nil
	end

	return var_1_0
end

ActionCareerBwNecromancerCommandStandTargeting = class(ActionCareerBwNecromancerCommandStandTargeting, ActionBase)

ActionCareerBwNecromancerCommandStandTargeting.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	ActionCareerBwNecromancerCommandStandTargeting.super.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)

	arg_2_0._ai_navigation_system = Managers.state.entity:system("ai_navigation_system")
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_4, "first_person_system")
	arg_2_0._inventory_extension = ScriptUnit.extension(arg_2_4, "inventory_system")
	arg_2_0._weapon_extension = ScriptUnit.extension(arg_2_7, "weapon_system")
	arg_2_0._commander_extension = ScriptUnit.extension(arg_2_4, "ai_commander_system")
	arg_2_0._world = arg_2_1
	arg_2_0._owner_unit = arg_2_4
	arg_2_0._last_valid_spawn_position = Vector3Box()
	arg_2_0._fp_rotation = QuaternionBox()
	arg_2_0._decal_diameter_id = World.find_particles_variable(arg_2_0._world, var_0_0, "diameter")

	arg_2_0._nav_callback = function ()
		local var_3_0 = Managers.time:time("game")

		arg_2_0:_update_targeting(var_3_0)
	end
end

ActionCareerBwNecromancerCommandStandTargeting.client_owner_start_action = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_5 = arg_4_5 or {}

	ActionCareerBwNecromancerCommandStandTargeting.super.client_owner_start_action(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0._weapon_extension:set_mode(true)

	arg_4_0._controlled_unit_template = arg_4_1.controlled_unit_template
	arg_4_0._breed_to_spawn = arg_4_1.breed_to_spawn
	arg_4_0._spawn_decal_ids = {}

	local var_4_0 = POSITION_LOOKUP[arg_4_0._owner_unit]

	arg_4_0._last_valid_spawn_position:store(var_4_0)
	arg_4_0._ai_navigation_system:add_safe_navigation_callback(arg_4_0._nav_callback)
end

ActionCareerBwNecromancerCommandStandTargeting.client_owner_post_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0._ai_navigation_system:add_safe_navigation_callback(arg_5_0._nav_callback)
end

ActionCareerBwNecromancerCommandStandTargeting._update_targeting = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0:_update_spawn_positions()
	local var_6_1 = #var_6_0
	local var_6_2 = arg_6_0._world
	local var_6_3 = arg_6_0._spawn_decal_ids

	for iter_6_0 = 1, var_6_1 do
		local var_6_4 = var_6_0[iter_6_0]
		local var_6_5 = var_6_3[iter_6_0]
		local var_6_6 = var_6_4:unbox()

		if not var_6_5 then
			var_6_5 = World.create_particles(var_6_2, var_0_0, var_6_6)
			var_6_3[iter_6_0] = var_6_5

			World.set_particles_variable(var_6_2, var_6_5, arg_6_0._decal_diameter_id, Vector3(var_0_1 * 2, var_0_1 * 2, 1))
		end

		World.move_particles(var_6_2, var_6_5, var_6_6)
	end

	for iter_6_1 = var_6_1 + 1, #var_6_3 do
		local var_6_7 = var_6_3[iter_6_1]

		if var_6_7 then
			World.destroy_particles(var_6_2, var_6_7)
		end

		var_6_3[iter_6_1] = nil
	end
end

ActionCareerBwNecromancerCommandStandTargeting._update_spawn_positions = function (arg_7_0)
	local var_7_0 = arg_7_0._commander_extension
	local var_7_1 = table.keys(var_7_0:get_controlled_units())

	table.array_remove_if(var_7_1, function (arg_8_0)
		return Unit.get_data(arg_8_0, "breed").name == "pet_skeleton_armored" and var_7_0:command_state(arg_8_0) ~= CommandStates.Following
	end)

	local var_7_2 = #var_7_1
	local var_7_3
	local var_7_4, var_7_5 = arg_7_0:_get_projectile_position(var_0_2)

	if var_7_4 then
		var_7_3 = var_7_5

		arg_7_0._last_valid_spawn_position:store(var_7_5)
	else
		var_7_3 = arg_7_0._last_valid_spawn_position:unbox()
	end

	local var_7_6 = arg_7_0._first_person_extension:current_rotation()
	local var_7_7 = Quaternion.axis_angle(Vector3.up(), Quaternion.yaw(var_7_6))

	arg_7_0._fp_rotation:store(var_7_7)

	arg_7_0._spawn_positions = ActionCareerBwNecromancerCommandStandTargetingUtility.generate_positions(var_7_3, var_7_7, var_7_2, arg_7_0._spawn_positions)

	return arg_7_0._spawn_positions
end

ActionCareerBwNecromancerCommandStandTargeting._get_projectile_position = function (arg_9_0)
	local var_9_0 = arg_9_0._world
	local var_9_1 = World.get_data(var_9_0, "physics_world")
	local var_9_2 = "filter_adept_teleport"
	local var_9_3, var_9_4 = arg_9_0:_get_first_person_position_direction()
	local var_9_5 = var_9_4 * var_0_2
	local var_9_6 = Vector3(0, 0, var_0_3)
	local var_9_7, var_9_8 = WeaponHelper:ground_target(var_9_1, arg_9_0._owner_unit, var_9_3, var_9_5, var_9_6, var_9_2)

	if var_9_7 then
		local var_9_9 = Managers.state.entity:system("ai_system"):nav_world()
		local var_9_10 = 1
		local var_9_11 = 1
		local var_9_12 = LocomotionUtils.pos_on_mesh(var_9_9, var_9_8, var_9_10, var_9_11)

		if not var_9_12 then
			local var_9_13 = 3
			local var_9_14 = 0.5

			var_9_12 = GwNavQueries.inside_position_from_outside_position(var_9_9, var_9_8, var_9_10, var_9_11, var_9_13, var_9_14)
		end

		var_9_7 = not not var_9_12
		var_9_8 = var_9_12
	end

	return var_9_7, var_9_8
end

ActionCareerBwNecromancerCommandStandTargeting._get_first_person_position_direction = function (arg_10_0)
	local var_10_0 = arg_10_0._first_person_extension
	local var_10_1 = var_10_0:current_position()
	local var_10_2 = var_10_0:current_rotation()
	local var_10_3 = math.rad(45)
	local var_10_4 = math.rad(12.5)
	local var_10_5 = Quaternion.yaw(var_10_2)
	local var_10_6 = math.clamp(Quaternion.pitch(var_10_2), -var_10_3, var_10_4)
	local var_10_7 = Quaternion(Vector3.up(), var_10_5)
	local var_10_8 = Quaternion(Vector3.right(), var_10_6)
	local var_10_9 = Quaternion.multiply(var_10_7, var_10_8)
	local var_10_10 = Quaternion.forward(var_10_9)

	return var_10_1, var_10_10
end

ActionCareerBwNecromancerCommandStandTargeting.finish = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._world
	local var_11_1 = arg_11_0._spawn_decal_ids

	if not arg_11_0._spawn_positions then
		return nil
	end

	for iter_11_0 = 1, #var_11_1 do
		if var_11_1[iter_11_0] then
			World.destroy_particles(var_11_0, var_11_1[iter_11_0])

			var_11_1[iter_11_0] = nil
		end
	end

	if arg_11_1 == "new_interupting_action" then
		return {
			target_center = arg_11_0._last_valid_spawn_position,
			fp_rotation = arg_11_0._fp_rotation
		}
	end

	return nil
end
