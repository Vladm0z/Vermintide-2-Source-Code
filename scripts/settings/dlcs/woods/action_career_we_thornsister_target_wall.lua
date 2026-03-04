-- chunkname: @scripts/settings/dlcs/woods/action_career_we_thornsister_target_wall.lua

ActionCareerWEThornsisterTargetWall = class(ActionCareerWEThornsisterTargetWall, ActionBase)

local var_0_0 = 10
local var_0_1 = 1.5
local var_0_2 = "filter_geiser_check"
local var_0_3 = "units/decals/decal_thorn_sister_wall_target"
local var_0_4 = 0.15
local var_0_5 = 0.15
local var_0_6 = 0.3
local var_0_7 = 0.5
local var_0_8 = 0.9 + var_0_6
local var_0_9 = table.enum("linear", "radial")

function ActionCareerWEThornsisterTargetWall.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerWEThornsisterTargetWall.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0._decal_unit = nil
	arg_1_0._unit_spawner = Managers.state.unit_spawner
	arg_1_0._target_pos = Vector3Box()
	arg_1_0._target_rot = QuaternionBox()
	arg_1_0._segment_positions = {
		{
			num_segments = 0
		},
		{
			num_segments = 0
		}
	}
	arg_1_0._valid_segment_positions_idx = 0
	arg_1_0._current_segment_positions_idx = 1
	arg_1_0._num_segments = 0
	arg_1_0._max_segments = 0
	arg_1_0._wall_left_offset = 0
	arg_1_0._wall_right_offset = 0
	arg_1_0._wall_shape = var_0_9.linear
end

function ActionCareerWEThornsisterTargetWall.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionCareerWEThornsisterTargetWall.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0._valid_segment_positions_idx = 0
	arg_2_0._current_segment_positions_idx = 1

	arg_2_0._weapon_extension:set_mode(false)

	arg_2_0._target_sim_gravity = arg_2_1.target_sim_gravity
	arg_2_0._target_sim_speed = arg_2_1.target_sim_speed
	arg_2_0._target_width = arg_2_1.target_width
	arg_2_0._target_thickness = arg_2_1.target_thickness
	arg_2_0._vertical_rotation = arg_2_1.vertical_rotation
	arg_2_0._wall_shape = var_0_9.linear

	if arg_2_0.talent_extension:has_talent("kerillian_thorn_sister_debuff_wall") then
		arg_2_0._target_thickness = 5
		arg_2_0._target_width = 5
		arg_2_0._wall_shape = var_0_9.radial
		arg_2_0._num_segmetns_to_check = 3
		arg_2_0._radial_center_offset = 0.5
		arg_2_0._bot_target_unit = true
	elseif arg_2_0.talent_extension:has_talent("kerillian_thorn_sister_tanky_wall") then
		arg_2_0._target_width = 8

		local var_2_0 = arg_2_0._target_thickness / 2

		arg_2_0._num_segmetns_to_check = math.floor(arg_2_0._target_width / var_2_0)
		arg_2_0._bot_target_unit = false
	else
		local var_2_1 = arg_2_0._target_thickness / 2

		arg_2_0._num_segmetns_to_check = math.floor(arg_2_0._target_width / var_2_1)
		arg_2_0._bot_target_unit = false
	end

	local var_2_2 = arg_2_0._max_segments
	local var_2_3 = arg_2_0._num_segmetns_to_check

	if var_2_2 < var_2_3 then
		local var_2_4 = arg_2_0._segment_positions

		for iter_2_0 = var_2_2, var_2_3 do
			for iter_2_1 = 1, 2 do
				var_2_4[iter_2_1][iter_2_0 + 1] = Vector3Box()
			end
		end

		arg_2_0._max_segments = var_2_3
	end

	arg_2_0:_update_targeting()
end

function ActionCareerWEThornsisterTargetWall.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0:_update_targeting()
end

function ActionCareerWEThornsisterTargetWall._update_targeting(arg_4_0)
	local var_4_0, var_4_1 = arg_4_0._first_person_extension:get_projectile_start_position_rotation()
	local var_4_2 = arg_4_0._vertical_rotation and Quaternion.right or Quaternion.forward
	local var_4_3 = Vector3.flat(var_4_2(var_4_1))
	local var_4_4 = Quaternion.look(var_4_3, Vector3.up())
	local var_4_5 = Quaternion.forward(var_4_1) * arg_4_0._target_sim_speed
	local var_4_6 = Vector3(0, 0, arg_4_0._target_sim_gravity)
	local var_4_7
	local var_4_8

	if arg_4_0.is_bot then
		var_4_7 = true

		local var_4_9 = BLACKBOARDS[arg_4_0.owner_unit]
		local var_4_10 = var_4_9.target_unit

		if arg_4_0._bot_target_unit and ALIVE[var_4_10] then
			var_4_8 = POSITION_LOOKUP[var_4_10]
		else
			var_4_8 = var_4_9.activate_ability_data.aim_position:unbox()
		end
	else
		var_4_7, var_4_8 = WeaponHelper:ballistic_raycast(arg_4_0.physics_world, var_0_0, var_0_1, var_4_0, var_4_5, var_4_6, var_0_2)
	end

	if var_4_7 then
		local var_4_11
		local var_4_12
		local var_4_13

		if arg_4_0._wall_shape == var_0_9.radial then
			var_4_11, var_4_12, var_4_13 = arg_4_0:_check_wall_radial(var_4_8, var_4_4, arg_4_0._target_width, arg_4_0._target_thickness)
		else
			var_4_11, var_4_12, var_4_13 = arg_4_0:_check_wall_linear(var_4_8, var_4_4, arg_4_0._target_width, arg_4_0._target_thickness)
		end

		if var_4_11 then
			arg_4_0._target_pos:store(var_4_8)
			arg_4_0._target_rot:store(var_4_4)

			arg_4_0._valid_segment_positions_idx = arg_4_0._current_segment_positions_idx
			arg_4_0._current_segment_positions_idx = arg_4_0._current_segment_positions_idx % 2 + 1
			arg_4_0._wall_right_offset = var_4_12
			arg_4_0._wall_left_offset = var_4_13

			arg_4_0._weapon_extension:set_mode(true)
		end
	end

	if not arg_4_0._decal_unit and arg_4_0._valid_segment_positions_idx > 0 and not arg_4_0.is_bot then
		arg_4_0._decal_unit = arg_4_0._unit_spawner:spawn_local_unit(var_0_3)
	end

	if arg_4_0._decal_unit then
		local var_4_14 = arg_4_0._target_thickness * 0.5
		local var_4_15 = arg_4_0._wall_left_offset * 0.5
		local var_4_16 = arg_4_0._wall_right_offset * 0.5
		local var_4_17 = Quaternion.right(var_4_4) * ((var_4_16 - var_4_15) * 0.5)
		local var_4_18 = arg_4_0._target_pos:unbox() + var_4_17
		local var_4_19 = arg_4_0._target_rot:unbox()

		Unit.set_local_position(arg_4_0._decal_unit, 0, var_4_18)
		Unit.set_local_rotation(arg_4_0._decal_unit, 0, var_4_19)

		local var_4_20

		if arg_4_0._wall_shape == var_0_9.radial then
			var_4_20 = arg_4_0._target_width * 0.5
		else
			var_4_20 = arg_4_0._target_width * 0.5 + var_4_14 * (var_4_15 + var_4_16 + 1)
		end

		Unit.set_local_scale(arg_4_0._decal_unit, 0, Vector3(var_4_20, var_4_14, 3))
	end
end

function ActionCareerWEThornsisterTargetWall.finish(arg_5_0, arg_5_1)
	if arg_5_0._decal_unit then
		arg_5_0._unit_spawner:mark_for_deletion(arg_5_0._decal_unit)

		arg_5_0._decal_unit = nil
	end

	if arg_5_1 == "new_interupting_action" then
		if arg_5_0._valid_segment_positions_idx > 0 then
			arg_5_0._weapon_extension:set_mode(true)

			return {
				position = arg_5_0._target_pos,
				rotation = arg_5_0._target_rot,
				segments = arg_5_0._segment_positions[arg_5_0._valid_segment_positions_idx],
				num_segments = arg_5_0._segment_positions[arg_5_0._valid_segment_positions_idx].num_segments
			}
		end
	else
		arg_5_0._inventory_extension:wield_previous_non_level_slot()
	end

	return nil
end

function ActionCareerWEThornsisterTargetWall._check_wall_linear(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if Network.game_session() then
		local var_6_0 = arg_6_3 / 2
		local var_6_1 = arg_6_4 / 2
		local var_6_2 = arg_6_0._num_segmetns_to_check
		local var_6_3 = math.floor(var_6_2 / 2)
		local var_6_4 = arg_6_0._segment_positions[arg_6_0._current_segment_positions_idx]
		local var_6_5 = Quaternion.forward(arg_6_2)
		local var_6_6 = Quaternion.right(arg_6_2)
		local var_6_7 = var_6_6 * var_6_1
		local var_6_8 = arg_6_1 - var_6_6 * (var_6_0 - var_6_1) - var_6_7 * 0.5
		local var_6_9 = 0
		local var_6_10
		local var_6_11 = 0

		for iter_6_0 = var_6_3, var_6_2 - 1 do
			local var_6_12 = var_6_8 + var_6_7 * iter_6_0

			var_6_10 = arg_6_0:_check_segment(var_6_10, var_6_12, var_6_5)

			if var_6_10 then
				var_6_9 = var_6_9 + 1

				var_6_4[var_6_9]:store(var_6_10)
			else
				var_6_11 = iter_6_0 - var_6_2

				break
			end
		end

		local var_6_13
		local var_6_14 = 0

		for iter_6_1 = var_6_3 - 1, 0, -1 do
			local var_6_15 = var_6_8 + var_6_7 * iter_6_1

			var_6_13 = arg_6_0:_check_segment(var_6_13, var_6_15, var_6_5)

			if var_6_13 then
				var_6_9 = var_6_9 + 1

				var_6_4[var_6_9]:store(var_6_13)
			else
				var_6_14 = -iter_6_1 - 1

				break
			end
		end

		var_6_4.num_segments = var_6_9

		return var_6_9 > 0, var_6_11, var_6_14
	end

	return nil
end

function ActionCareerWEThornsisterTargetWall._check_wall_radial(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if Network.game_session() then
		local var_7_0 = arg_7_3 / 2
		local var_7_1 = arg_7_4 / 2
		local var_7_2 = arg_7_0._num_segmetns_to_check
		local var_7_3 = math.floor(var_7_2 / 2)
		local var_7_4 = arg_7_0._segment_positions[arg_7_0._current_segment_positions_idx]
		local var_7_5 = Quaternion.forward(arg_7_2)
		local var_7_6 = 2 * math.pi / var_7_2
		local var_7_7 = var_7_5 * arg_7_0._radial_center_offset
		local var_7_8 = 0

		for iter_7_0 = 1, var_7_2 do
			local var_7_9 = arg_7_1 + Quaternion.rotate(Quaternion(Vector3.up(), var_7_6 * iter_7_0), var_7_7)
			local var_7_10 = arg_7_0:_check_segment(arg_7_1, var_7_9, var_7_5)

			if var_7_10 then
				var_7_8 = var_7_8 + 1

				var_7_4[var_7_8]:store(var_7_10)
			end
		end

		var_7_4.num_segments = var_7_8

		return var_7_8 > 0, 0, 0
	end

	return nil
end

function ActionCareerWEThornsisterTargetWall._check_segment(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_2 then
		local var_8_0 = arg_8_0.physics_world
		local var_8_1 = arg_8_2

		if arg_8_1 then
			var_8_1.z = arg_8_1.z + var_0_7
		else
			var_8_1.z = arg_8_2.z + var_0_7
		end

		local var_8_2 = Vector3.down()
		local var_8_3 = 2 * var_0_7
		local var_8_4, var_8_5, var_8_6 = PhysicsWorld.immediate_raycast(var_8_0, var_8_1, var_8_2, var_8_3, "closest", "collision_filter", "filter_player_mover")

		if var_8_4 then
			if arg_8_1 and math.abs(var_8_5.z - arg_8_1.z) > var_0_7 then
				return false
			end

			local var_8_7 = 0
			local var_8_8 = var_8_5 + Vector3.up() * var_0_8
			local var_8_9 = Vector3(var_0_5, var_0_4, var_0_6)
			local var_8_10 = Quaternion.look(arg_8_3, Vector3.up())

			if arg_8_1 then
				local var_8_11 = arg_8_1 + Vector3.up() * var_0_8
				local var_8_12 = PhysicsWorld.linear_obb_sweep(var_8_0, var_8_11, var_8_8, var_8_9, var_8_10, 5, "collision_filter", "filter_player_mover", "report_initial_overlap")

				var_8_7 = var_8_12 and #var_8_12 or 0
			else
				local var_8_13
				local var_8_14

				var_8_14, var_8_7 = PhysicsWorld.immediate_overlap(var_8_0, "position", var_8_8, "rotation", var_8_10, "size", var_8_9, "shape", "oobb", "collision_filter", "filter_player_mover")
			end

			if var_8_7 > 0 then
				return false
			end

			return var_8_5
		end
	end

	return false
end
