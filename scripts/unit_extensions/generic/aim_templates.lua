-- chunkname: @scripts/unit_extensions/generic/aim_templates.lua

local AimTemplates = AimTemplates

AimTemplates = AimTemplates or {}
AimTemplates = AimTemplates

local BLACKBOARDS = BLACKBOARDS
local num = 1.9999999
local num_2 = -0.95
local num_3 = -0.8
local num_4 = 0.6
local num_5 = 3
local num_6 = 5

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	local is_using_head_constraint = arg_1_1.is_using_head_constraint

	if not (is_using_head_constraint or arg_1_6) then
		arg_1_1.is_using_head_constraint = true

		local animation_event = Unit.animation_event
		local var_1_2 = arg_1_0
		local look_at_on_animation = arg_1_1.look_at_on_animation

		look_at_on_animation = look_at_on_animation or "look_at_on"

		animation_event(var_1_2, look_at_on_animation)
	end

	if not (not arg_1_3 and Unit.alive(arg_1_3)) then
		AiUtils.set_default_anim_constraint(arg_1_0, arg_1_5)

		return
	end

	local var_1_4
	local has_extension = ScriptUnit.has_extension(arg_1_3, "first_person_system")

	if has_extension ~= nil then
		var_1_4 = has_extension:current_position()
	else
		local node

		if not Unit.has_node(arg_1_3, "j_head") then
			node = Unit.node(arg_1_3, "j_head")

			if not node then
				-- Nothing
			end
		end

		node = 0

		::label_1_0::

		var_1_4 = Unit.world_position(arg_1_3, node)
	end

	local world_rotation = Unit.world_rotation(arg_1_0, 0)
	local flat = Vector3.flat(Quaternion.forward(world_rotation))
	local normalize = Vector3.normalize(flat)
	local var_1_10 = POSITION_LOOKUP[arg_1_0]
	local flat_2 = Vector3.flat(var_1_4 - var_1_10)
	local normalize_2 = Vector3.normalize(flat_2)

	if Vector3.dot(normalize_2, normalize) < math.inverse_sqrt_2 then
		local z = var_1_4.z
		local flat_3 = Vector3.flat(Quaternion.right(world_rotation))

		if Vector3.cross(normalize, normalize_2).z > 0 then
			var_1_4 = var_1_10 + (flat - flat_3) * arg_1_4
		else
			var_1_4 = var_1_10 + (flat + flat_3) * arg_1_4
		end

		var_1_4.z = z
	end

	if not (not is_using_head_constraint and arg_1_1.lerp_aiming_disabled) then
		local unbox = arg_1_1.previous_look_target:unbox()
		local min = math.min(arg_1_2 * 5, 1)

		var_1_4 = Vector3.lerp(unbox, var_1_4, min)
	end

	arg_1_1.previous_look_target:store(var_1_4)
	Unit.animation_set_constraint_target(arg_1_0, arg_1_5, var_1_4)
end

AimTemplates.player = {
	owner = {
		init = function (arg_2_0, arg_2_1)
			-- function 2
			arg_2_1.packmaster_claw_aim_constraint = Unit.animation_find_constraint_target(arg_2_0, "packmaster_claw_target")
			arg_2_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_2_0, "aim_constraint_target")
			arg_2_1.look_direction_anim_var = Unit.animation_find_variable(arg_2_0, "aim_direction")
			arg_2_1.aim_direction_pitch_var = Unit.animation_find_variable(arg_2_0, "aim_direction_pitch")
			arg_2_1.locomotion_extension = ScriptUnit.extension(arg_2_0, "locomotion_system")
			arg_2_1.status_extension = ScriptUnit.extension(arg_2_0, "status_system")
			arg_2_1.min_head_lookat_z = -3

			local owner = Managers.player:owner(arg_2_0)

			if not owner then
				local profile_index = owner:profile_index()
				local career_index = owner:career_index()
				local var_2_3 = SPProfiles[profile_index]
				local flag = not var_2_3 and var_2_3.careers
				local flag_2 = not flag and flag[career_index]

				if not flag_2 and not flag_2.min_head_lookat_z then
					arg_2_1.min_head_lookat_z = flag_2.min_head_lookat_z
				end
			end
		end,
		update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			local var_3_0
			local forward = Quaternion.forward(Unit.local_rotation(arg_3_0, 0))
			local status_extension = arg_3_3.status_extension

			if not status_extension:is_grabbed_by_pack_master() then
				local get_pack_master_grabber = status_extension:get_pack_master_grabber()
				local node = Unit.node(get_pack_master_grabber, "j_rightweaponcomponent10")
				local world_position = Unit.world_position(get_pack_master_grabber, node)

				Unit.animation_set_constraint_target(arg_3_0, arg_3_3.packmaster_claw_aim_constraint, world_position)

				var_3_0 = forward
			elseif not status_extension:is_inspecting() then
				var_3_0 = forward
			else
				local current_rotation = arg_3_3.locomotion_extension:current_rotation()

				var_3_0 = Quaternion.forward(current_rotation)
			end

			Unit.animation_set_variable(arg_3_0, arg_3_3.aim_direction_pitch_var, math.clamp(Quaternion.pitch(Quaternion.look(var_3_0)), -1, 1))

			local flag

			flag = not arg_3_3.status_extension:is_crouching() and -3 and arg_3_3.min_head_lookat_z

			local num_2 = var_3_0 * 3
			local z = num_2.z

			num_2.z = math.clamp(z, flag, 3)

			local num_3 = Unit.world_position(arg_3_0, Unit.node(arg_3_0, "camera_attach")) + num_2

			Unit.animation_set_constraint_target(arg_3_0, arg_3_3.aim_constraint_anim_var, num_3)

			local normalize = Vector3.normalize(Vector3.flat(var_3_0))
			local normalize_2 = Vector3.normalize(Vector3.flat(forward))
			local num_4 = -(((math.atan2(normalize.y, normalize.x) - math.atan2(normalize_2.y, normalize_2.x)) / math.pi + 1) % 2 - 1) * 2

			Unit.animation_set_variable(arg_3_0, arg_3_3.look_direction_anim_var, math.clamp(num_4, -num, num))

			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_3_0)

			if not game and not go_id then
				local current_position = ScriptUnit.extension(arg_3_0, "first_person_system"):current_position()
				local network_clamp_position = NetworkUtils.network_clamp_position(current_position)

				GameSession.set_game_object_field(game, go_id, "aim_direction", var_3_0)
				GameSession.set_game_object_field(game, go_id, "aim_position", network_clamp_position)
			end
		end,
		leave = function (arg_4_0, arg_4_1)
			-- function 4
			return
		end
	},
	husk = {
		init = function (arg_5_0, arg_5_1)
			-- function 5
			arg_5_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_5_0, "aim_constraint_target")
			arg_5_1.look_direction_anim_var = Unit.animation_find_variable(arg_5_0, "aim_direction")
			arg_5_1.aim_direction_pitch_var = Unit.animation_find_variable(arg_5_0, "aim_direction_pitch")
			arg_5_1.packmaster_claw_aim_constraint = Unit.animation_find_constraint_target(arg_5_0, "packmaster_claw_target")
			arg_5_1.camera_attach_node = Unit.node(arg_5_0, "camera_attach")
			arg_5_1.status_extension = ScriptUnit.extension(arg_5_0, "status_system")
			arg_5_1.min_head_lookat_z = -3

			local owner = Managers.player:owner(arg_5_0)

			if not owner then
				local profile_index = owner:profile_index()
				local career_index = owner:career_index()
				local var_5_3 = SPProfiles[profile_index]
				local flag = not var_5_3 and var_5_3.careers
				local flag_2 = not flag and flag[career_index]

				if not flag_2 and not flag_2.min_head_lookat_z then
					arg_5_1.min_head_lookat_z = flag_2.min_head_lookat_z
				end
			end
		end,
		update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_6_0)

			if not (not game and go_id) then
				return
			end

			local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")
			local look = Quaternion.look(game_object_field)
			local yaw = Quaternion.yaw(look)
			local custom_husk_max_pitch = Unit.get_data(arg_6_0, "breed").custom_husk_max_pitch

			custom_husk_max_pitch = custom_husk_max_pitch or num_4

			local clamp = math.clamp(Quaternion.pitch(look), num_2, custom_husk_max_pitch)
			local var_6_7 = Quaternion(Vector3.up(), yaw)
			local var_6_8 = Quaternion(Vector3.right(), clamp)
			local multiply = Quaternion.multiply(var_6_7, var_6_8)
			local normalize = Vector3.normalize(Quaternion.forward(multiply))
			local flag

			flag = not arg_6_3.status_extension:is_crouching() and -3 and arg_6_3.min_head_lookat_z

			local num_3 = normalize * 3
			local z = num_3.z

			num_3.z = math.clamp(z, flag, 3)

			local world_position = Unit.world_position(arg_6_0, arg_6_3.camera_attach_node)

			if script_data.lerp_debug or not script_data.extrapolation_debug then
				local translation = Matrix4x4.translation(Unit.animation_get_constraint_target(arg_6_0, arg_6_3.aim_constraint_anim_var))
				local num_5 = world_position + num_3

				Unit.animation_set_constraint_target(arg_6_0, arg_6_3.aim_constraint_anim_var, num_5)
				Unit.animation_set_variable(arg_6_0, Unit.animation_find_variable(arg_6_0, "aim_direction_pitch"), math.clamp(clamp, -1, 1))
			else
				Unit.animation_set_constraint_target(arg_6_0, arg_6_3.aim_constraint_anim_var, world_position + num_3)
			end

			local game_object_field_2 = GameSession.game_object_field(game, go_id, "yaw")
			local game_object_field_3 = GameSession.game_object_field(game, go_id, "pitch")
			local var_6_19 = Quaternion(Vector3.up(), game_object_field_2)
			local var_6_20 = Quaternion(Vector3.right(), game_object_field_3)
			local multiply_2 = Quaternion.multiply(var_6_19, var_6_20)
			local forward = Quaternion.forward(multiply_2)

			Vector3.set_z(forward, 0)
			Vector3.set_z(num_3, 0)

			local normalize_2 = Vector3.normalize(forward)
			local normalize_3 = Vector3.normalize(num_3)
			local num_6 = -(((math.atan2(normalize_3.y, normalize_3.x) - math.atan2(normalize_2.y, normalize_2.x)) / math.pi + 1) % 2 - 1) * 2

			Unit.animation_set_variable(arg_6_0, arg_6_3.look_direction_anim_var, math.clamp(num_6, -num, num))

			if not arg_6_3.status_extension:is_grabbed_by_pack_master() then
				local get_pack_master_grabber = arg_6_3.status_extension:get_pack_master_grabber()
				local node = Unit.node(get_pack_master_grabber, "j_rightweaponcomponent10")
				local world_position_2 = Unit.world_position(get_pack_master_grabber, node)

				Unit.animation_set_constraint_target(arg_6_0, arg_6_3.packmaster_claw_aim_constraint, world_position_2)
			end
		end,
		leave = function (arg_7_0, arg_7_1)
			-- function 7
			return
		end
	}
}
AimTemplates.enemy_character = {
	owner = {
		init = function (arg_8_0, arg_8_1)
			-- function 8
			arg_8_1.breed = Unit.get_data(arg_8_0, "breed")
			arg_8_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_8_0, "aim_constraint_target")
			arg_8_1.look_direction_anim_var = Unit.animation_find_variable(arg_8_0, "aim_direction")
			arg_8_1.aim_direction_pitch_var = Unit.animation_find_variable(arg_8_0, "aim_direction_pitch")
			arg_8_1.locomotion_extension = ScriptUnit.extension(arg_8_0, "locomotion_system")
			arg_8_1.status_extension = ScriptUnit.extension(arg_8_0, "status_system")
		end,
		update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			-- function 9
			local var_9_0
			local forward = Quaternion.forward(Unit.local_rotation(arg_9_0, 0))
			local status_extension = arg_9_3.status_extension

			if not status_extension:is_inspecting() then
				var_9_0 = forward
			elseif not status_extension:get_is_packmaster_dragging() then
				var_9_0 = forward
			else
				local current_rotation = arg_9_3.locomotion_extension:current_rotation()

				var_9_0 = Quaternion.forward(current_rotation)
			end

			Unit.animation_set_variable(arg_9_0, arg_9_3.aim_direction_pitch_var, math.clamp(Quaternion.pitch(Quaternion.look(var_9_0)), -1, 1))

			local num_2 = var_9_0 * num_5
			local num_3 = Unit.world_position(arg_9_0, Unit.node(arg_9_0, "camera_attach")) + num_2

			Unit.animation_set_constraint_target(arg_9_0, arg_9_3.aim_constraint_anim_var, num_3)

			local normalize = Vector3.normalize(Vector3.flat(var_9_0))
			local normalize_2 = Vector3.normalize(Vector3.flat(forward))
			local num_4 = -(((math.atan2(normalize.y, normalize.x) - math.atan2(normalize_2.y, normalize_2.x)) / math.pi + 1) % 2 - 1) * 2

			Unit.animation_set_variable(arg_9_0, arg_9_3.look_direction_anim_var, math.clamp(num_4, -num, num))

			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_9_0)

			if not game and not go_id then
				local current_position = ScriptUnit.extension(arg_9_0, "first_person_system"):current_position()
				local network_clamp_position = NetworkUtils.network_clamp_position(current_position)

				GameSession.set_game_object_field(game, go_id, "aim_direction", var_9_0)
				GameSession.set_game_object_field(game, go_id, "aim_position", network_clamp_position)
			end
		end,
		leave = function (arg_10_0, arg_10_1)
			-- function 10
			return
		end
	},
	husk = {
		init = function (arg_11_0, arg_11_1)
			-- function 11
			local get_data = Unit.get_data(arg_11_0, "breed")

			arg_11_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_11_0, "aim_constraint_target")
			arg_11_1.look_direction_anim_var = Unit.animation_find_variable(arg_11_0, "aim_direction")
			arg_11_1.aim_direction_pitch_var = Unit.animation_find_variable(arg_11_0, "aim_direction_pitch")

			local boss = get_data.boss

			boss = boss or false
			arg_11_1.boss = boss

			local aim_constraint_forward_multiplier = get_data.aim_constraint_forward_multiplier

			aim_constraint_forward_multiplier = aim_constraint_forward_multiplier or 1
			arg_11_1.aim_constraint_forward_multiplier = aim_constraint_forward_multiplier
			arg_11_1.camera_attach_node = Unit.node(arg_11_0, "camera_attach")
			arg_11_1.status_extension = ScriptUnit.extension(arg_11_0, "status_system")
			arg_11_1.husk_locomotion_extension = ScriptUnit.extension(arg_11_0, "locomotion_system")
		end,
		update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			-- function 12
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_12_0)

			if not (not game and go_id) then
				return
			end

			local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")
			local look = Quaternion.look(game_object_field)
			local yaw = Quaternion.yaw(look)
			local custom_husk_max_pitch = Unit.get_data(arg_12_0, "breed").custom_husk_max_pitch

			custom_husk_max_pitch = custom_husk_max_pitch or num_4

			local var_12_6

			if not arg_12_3.boss then
				var_12_6 = math.clamp(Quaternion.pitch(look), num_3, custom_husk_max_pitch)
			else
				var_12_6 = math.clamp(Quaternion.pitch(look), num_2, custom_husk_max_pitch)
			end

			local var_12_7 = Quaternion(Vector3.up(), yaw)
			local var_12_8 = Quaternion(Vector3.right(), var_12_6)
			local multiply = Quaternion.multiply(var_12_7, var_12_8)
			local normalize = Vector3.normalize(Quaternion.forward(multiply))
			local var_12_11

			if not arg_12_3.boss then
				var_12_11 = normalize * num_6
			else
				var_12_11 = normalize * num_5
			end

			local num_7 = var_12_11 * arg_12_3.aim_constraint_forward_multiplier
			local world_position = Unit.world_position(arg_12_0, arg_12_3.camera_attach_node)

			if script_data.lerp_debug or not script_data.extrapolation_debug then
				local translation = Matrix4x4.translation(Unit.animation_get_constraint_target(arg_12_0, arg_12_3.aim_constraint_anim_var))
				local num_8 = world_position + num_7

				Unit.animation_set_constraint_target(arg_12_0, arg_12_3.aim_constraint_anim_var, num_8)
				Unit.animation_set_variable(arg_12_0, Unit.animation_find_variable(arg_12_0, "aim_direction_pitch"), math.clamp(var_12_6, -1, 1))
			else
				Unit.animation_set_constraint_target(arg_12_0, arg_12_3.aim_constraint_anim_var, world_position + num_7)
			end

			local game_object_field_2 = GameSession.game_object_field(game, go_id, "yaw")
			local game_object_field_3 = GameSession.game_object_field(game, go_id, "pitch")
			local var_12_18 = Quaternion(Vector3.up(), game_object_field_2)
			local var_12_19 = Quaternion(Vector3.right(), game_object_field_3)
			local multiply_2 = Quaternion.multiply(var_12_18, var_12_19)
			local forward = Quaternion.forward(multiply_2)

			Vector3.set_z(forward, 0)
			Vector3.set_z(num_7, 0)

			local normalize_2 = Vector3.normalize(forward)
			local normalize_3 = Vector3.normalize(num_7)
			local num_9 = -(((math.atan2(normalize_3.y, normalize_3.x) - math.atan2(normalize_2.y, normalize_2.x)) / math.pi + 1) % 2 - 1) * 2

			Unit.animation_set_variable(arg_12_0, arg_12_3.look_direction_anim_var, math.clamp(num_9, -num, num))
		end,
		leave = function (arg_13_0, arg_13_1)
			-- function 13
			return
		end
	}
}
AimTemplates.packmaster_claw = {
	owner = {
		init = function (arg_14_0, arg_14_1)
			-- function 14
			arg_14_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_14_0, "aim_constraint_target")
		end,
		update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			-- function 15
			return
		end,
		leave = function (arg_16_0, arg_16_1)
			-- function 16
			return
		end
	}
}
AimTemplates.ratling_gunner = {
	owner = {
		init = function (arg_17_0, arg_17_1)
			-- function 17
			arg_17_1.blackboard = BLACKBOARDS[arg_17_0]
			arg_17_1.constraint_target = Unit.animation_find_constraint_target(arg_17_0, "aim_target")
		end,
		update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			-- function 18
			local var_18_0 = POSITION_LOOKUP[arg_18_0]
			local var_18_1
			local attack_pattern_data = arg_18_3.blackboard.attack_pattern_data

			if not attack_pattern_data and not attack_pattern_data.shoot_direction_box then
				local unbox = attack_pattern_data.shoot_direction_box:unbox()

				var_18_1 = var_18_0 + Vector3.normalize(unbox) * 5
			else
				var_18_1 = var_18_0 + Quaternion.forward(Unit.local_rotation(arg_18_0, 0)) * 5
			end

			Unit.animation_set_constraint_target(arg_18_0, arg_18_3.constraint_target, var_18_1)

			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_18_0)

			if not game and not go_id then
				GameSession.set_game_object_field(game, go_id, "aim_target", var_18_1)
			end
		end,
		leave = function (arg_19_0, arg_19_1)
			-- function 19
			return
		end
	},
	husk = {
		init = function (arg_20_0, arg_20_1)
			-- function 20
			arg_20_1.constraint_target = Unit.animation_find_constraint_target(arg_20_0, "aim_target")
		end,
		update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			-- function 21
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_21_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "aim_target")

				Unit.animation_set_constraint_target(arg_21_0, arg_21_3.constraint_target, game_object_field)
			else
				local forward = Quaternion.forward(Unit.local_rotation(arg_21_0, 0))
				local num = POSITION_LOOKUP[arg_21_0] + forward * 5

				Unit.animation_set_constraint_target(arg_21_0, arg_21_3.constraint_target, num)
			end
		end,
		leave = function (arg_22_0, arg_22_1)
			-- function 22
			return
		end
	}
}
AimTemplates.pack_master = {
	owner = {
		init = function (arg_23_0, arg_23_1)
			-- function 23
			arg_23_1.blackboard = BLACKBOARDS[arg_23_0]
			arg_23_1.constraint_target = Unit.animation_find_constraint_target(arg_23_0, "aim_constraint_target")
		end,
		update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			-- function 24
			local target_unit = arg_24_3.blackboard.target_unit

			if not ALIVE[target_unit] then
				local node = Unit.node(target_unit, "j_head")
				local world_position = Unit.world_position(target_unit, node)

				Unit.animation_set_constraint_target(arg_24_0, arg_24_3.constraint_target, world_position)

				local game = Managers.state.network:game()
				local go_id = Managers.state.unit_storage:go_id(arg_24_0)

				if not game and not go_id then
					GameSession.set_game_object_field(game, go_id, "aim_target", world_position)
				end
			end
		end,
		leave = function (arg_25_0, arg_25_1)
			-- function 25
			return
		end
	},
	husk = {
		init = function (arg_26_0, arg_26_1)
			-- function 26
			arg_26_1.constraint_target = Unit.animation_find_constraint_target(arg_26_0, "aim_constraint_target")
		end,
		update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			-- function 27
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_27_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "aim_target")

				if not game_object_field then
					Unit.animation_set_constraint_target(arg_27_0, arg_27_3.constraint_target, game_object_field)

					return
				end
			end

			local forward = Quaternion.forward(Unit.local_rotation(arg_27_0, 0))
			local num = POSITION_LOOKUP[arg_27_0] + forward * 5

			Unit.animation_set_constraint_target(arg_27_0, arg_27_3.constraint_target, num)
		end,
		leave = function (arg_28_0, arg_28_1)
			-- function 28
			return
		end
	}
}
AimTemplates.warpfire_thrower = {
	owner = {
		init = function (arg_29_0, arg_29_1)
			-- function 29
			arg_29_1.blackboard = BLACKBOARDS[arg_29_0]
			arg_29_1.constraint_target = Unit.animation_find_constraint_target(arg_29_0, "aim_target")
		end,
		update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
			-- function 30
			local var_30_0 = POSITION_LOOKUP[arg_30_0]
			local var_30_1
			local attack_pattern_data = arg_30_3.blackboard.attack_pattern_data

			if not attack_pattern_data and not attack_pattern_data.shoot_direction_box then
				local unbox = attack_pattern_data.shoot_direction_box:unbox()

				var_30_1 = var_30_0 + Vector3.normalize(unbox) * 5
			else
				var_30_1 = var_30_0 + Quaternion.forward(Unit.local_rotation(arg_30_0, 0)) * 5
			end

			Unit.animation_set_constraint_target(arg_30_0, arg_30_3.constraint_target, var_30_1)

			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_30_0)

			if not game and not go_id then
				GameSession.set_game_object_field(game, go_id, "aim_target", var_30_1)
			end
		end,
		leave = function (arg_31_0, arg_31_1)
			-- function 31
			return
		end
	},
	husk = {
		init = function (arg_32_0, arg_32_1)
			-- function 32
			arg_32_1.constraint_target = Unit.animation_find_constraint_target(arg_32_0, "aim_target")
		end,
		update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
			-- function 33
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_33_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "aim_target")

				Unit.animation_set_constraint_target(arg_33_0, arg_33_3.constraint_target, game_object_field)
			else
				local forward = Quaternion.forward(Unit.local_rotation(arg_33_0, 0))
				local num = POSITION_LOOKUP[arg_33_0] + forward * 5

				Unit.animation_set_constraint_target(arg_33_0, arg_33_3.constraint_target, num)
			end
		end,
		leave = function (arg_34_0, arg_34_1)
			-- function 34
			return
		end
	}
}
AimTemplates.chaos_warrior = {
	owner = {
		init = function (arg_35_0, arg_35_1)
			-- function 35
			arg_35_1.blackboard = BLACKBOARDS[arg_35_0]
			arg_35_1.constraint_target = Unit.animation_find_constraint_target(arg_35_0, "aim_target")
			arg_35_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
			-- function 36
			if not Unit.has_animation_state_machine(arg_36_0) then
				return
			end

			local blackboard = arg_36_3.blackboard
			local target_unit = blackboard.target_unit
			local previous_aim_target_unit = arg_36_3.previous_aim_target_unit
			local constraint_target = arg_36_3.constraint_target

			if not (not target_unit and Unit.alive(target_unit)) then
				AiUtils.set_default_anim_constraint(arg_36_0, constraint_target)

				return
			end

			local var_36_4

			if not ScriptUnit.has_extension(target_unit, "first_person_system") then
				local current_position = ScriptUnit.extension(target_unit, "first_person_system"):current_position()
			else
				local node = Unit.node(target_unit, "j_head")
				local world_position = Unit.world_position(target_unit, node)
			end

			local target_dist = blackboard.target_dist
			local breed = blackboard.breed
			local var_36_10
			local game_object_or_level_id, var_36_12 = Managers.state.network:game_object_or_level_id(target_unit)

			if not var_36_12 then
				local look_at_range = breed.look_at_range

				look_at_range = look_at_range or 30

				if target_dist < look_at_range then
					var_36_10 = true
				end
			end

			if DEDICATED_SERVER or not var_36_10 then
				fn(arg_36_0, arg_36_3, arg_36_2, target_unit, target_dist, constraint_target, true)
			end

			if not (target_unit ~= previous_aim_target_unit) then
				arg_36_3.previous_aim_target_unit = target_unit
			end
		end,
		leave = function (arg_37_0, arg_37_1)
			-- function 37
			return
		end
	},
	husk = {
		init = function (arg_38_0, arg_38_1)
			-- function 38
			arg_38_1.constraint_target = Unit.animation_find_constraint_target(arg_38_0, "aim_target")
			arg_38_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
			-- function 39
			if not Unit.has_animation_state_machine(arg_39_0) then
				return
			end

			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_39_0)
			local constraint_target = arg_39_3.constraint_target

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "target_unit_id")
				local unit = Managers.state.unit_storage:unit(game_object_field)

				if not (not unit and not Unit.alive(unit) and not (game_object_field <= 0)) then
					AiUtils.set_default_anim_constraint(arg_39_0, constraint_target)

					return
				end

				local var_39_5

				if not ScriptUnit.has_extension(unit, "first_person_system") then
					local current_position = ScriptUnit.extension(unit, "first_person_system"):current_position()
				elseif not Unit.has_node(unit, "j_head") then
					local node = Unit.node(unit, "j_head")
					local world_position = Unit.world_position(unit, node)
				else
					AiUtils.set_default_anim_constraint(arg_39_0, constraint_target)

					return
				end

				local unit_2 = Managers.state.unit_storage:unit(game_object_field)
				local flag = not unit_2 and Vector3.distance(POSITION_LOOKUP[arg_39_0], POSITION_LOOKUP[unit_2])
				local var_39_11

				if flag < 30 then
					var_39_11 = true
				end

				if not var_39_11 then
					local constraint_target_2 = arg_39_3.constraint_target

					arg_39_3.lerp_aiming_disabled = true

					fn(arg_39_0, arg_39_3, arg_39_2, unit_2, flag, constraint_target_2, true)
				end
			else
				AiUtils.set_default_anim_constraint(arg_39_0, constraint_target)
			end
		end,
		leave = function (arg_40_0, arg_40_1)
			-- function 40
			return
		end
	}
}
AimTemplates.chaos_marauder = {
	owner = {
		init = function (arg_41_0, arg_41_1)
			-- function 41
			arg_41_1.blackboard = BLACKBOARDS[arg_41_0]
			arg_41_1.ai_extension = ScriptUnit.extension(arg_41_0, "ai_system")
			arg_41_1.head_constraint_target = Unit.animation_find_constraint_target(arg_41_0, "head_aim_target")
			arg_41_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
			-- function 42
			local blackboard = arg_42_3.blackboard
			local current_action_name = arg_42_3.ai_extension:current_action_name()
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_42_0)
			local flag = false
			local target_dist = blackboard.target_dist
			local breed = blackboard.breed
			local target_unit = blackboard.target_unit
			local head_constraint_target = arg_42_3.head_constraint_target

			if not (not target_unit and Unit.alive(target_unit)) then
				AiUtils.set_default_anim_constraint(arg_42_0, head_constraint_target)

				return
			end

			local game_object_or_level_id, var_42_10 = Managers.state.network:game_object_or_level_id(target_unit)
			local flag_2 = current_action_name == "follow" or current_action_name == "combat_step"

			if var_42_10 or not flag_2 then
				local look_at_range = breed.look_at_range

				look_at_range = look_at_range or 30

				if target_dist < look_at_range then
					flag = true
				end
			end

			local has_extension = ScriptUnit.has_extension(arg_42_0, "death_system")

			if not has_extension and not has_extension:has_death_started() then
				flag = false
			end

			if not flag then
				local previous_aim_target_unit = arg_42_3.previous_aim_target_unit

				arg_42_3.lerp_aiming_disabled = true

				if not DEDICATED_SERVER then
					fn(arg_42_0, arg_42_3, arg_42_2, target_unit, target_dist, head_constraint_target)
				end

				if target_unit ~= previous_aim_target_unit then
					arg_42_3.previous_aim_target_unit = target_unit
				end
			elseif not arg_42_3.is_using_head_constraint then
				arg_42_3.is_using_head_constraint = false

				Unit.animation_event(arg_42_0, "look_at_off")
			end
		end,
		leave = function (arg_43_0, arg_43_1)
			-- function 43
			if not arg_43_1.is_using_head_constraint then
				arg_43_1.is_using_head_constraint = false

				Unit.animation_event(arg_43_0, "look_at_off")
			end
		end
	},
	husk = {
		init = function (arg_44_0, arg_44_1)
			-- function 44
			arg_44_1.head_constraint_target = Unit.animation_find_constraint_target(arg_44_0, "head_aim_target")
			arg_44_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
			-- function 45
			local game = Managers.state.network:game()
			local unit_storage = Managers.state.unit_storage
			local go_id = unit_storage:go_id(arg_45_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "bt_action_name")
				local var_45_4 = NetworkLookup.bt_action_names[game_object_field]
				local flag = false

				if var_45_4 == "follow" then
					flag = true
				end

				if not flag then
					local game_object_field_2 = GameSession.game_object_field(game, go_id, "target_unit_id")

					if game_object_field_2 > 0 then
						local unit = unit_storage:unit(game_object_field_2)

						if not unit then
							-- Nothing
						end

						::label_45_0::

						do
							local distance = Vector3.distance
							local var_45_9 = POSITION_LOOKUP[arg_45_0]
							local var_45_10 = POSITION_LOOKUP[unit]

							var_45_10 = var_45_10 or Unit.world_position(unit, 0)

							local var_45_11 = distance(var_45_9, var_45_10)
						end

						::label_45_1::

						local head_constraint_target = arg_45_3.head_constraint_target

						arg_45_3.lerp_aiming_disabled = true

						if not (not unit and Unit.has_node(unit, "j_head")) then
							fn(arg_45_0, arg_45_3, arg_45_2, unit, var_45_11, head_constraint_target)
						end
					end
				elseif not arg_45_3.is_using_head_constraint then
					arg_45_3.is_using_head_constraint = false

					Unit.animation_event(arg_45_0, "look_at_off")
				end
			end
		end,
		leave = function (arg_46_0, arg_46_1)
			-- function 46
			if not arg_46_1.is_using_head_constraint then
				arg_46_1.is_using_head_constraint = false

				Unit.animation_event(arg_46_0, "look_at_off")
			end
		end
	}
}
AimTemplates.stormfiend = {
	owner = {
		init = function (arg_47_0, arg_47_1)
			-- function 47
			arg_47_1.blackboard = BLACKBOARDS[arg_47_0]
			arg_47_1.ai_extension = ScriptUnit.extension(arg_47_0, "ai_system")
			arg_47_1.head_constraint_target = Unit.animation_find_constraint_target(arg_47_0, "head_aim_target")
			arg_47_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
			-- function 48
			local blackboard = arg_48_3.blackboard
			local current_action_name = arg_48_3.ai_extension:current_action_name()
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_48_0)
			local flag = false

			if current_action_name == "shoot" then
				flag = true

				local shoot_data = blackboard.shoot_data

				if not shoot_data.aiming_started then
					local unbox = shoot_data.aim_start_position:unbox()
					local var_48_7

					if not shoot_data.firing_initiated then
						local var_48_8

						if blackboard.weapon_setup == "ratling_gun" then
							var_48_8 = POSITION_LOOKUP[blackboard.target_unit]
						else
							var_48_8 = shoot_data.aim_end_position:unbox()
						end

						local num = shoot_data.stop_firing_t - shoot_data.start_firing_t
						local num_2 = shoot_data.stop_firing_t - arg_48_1
						local min = math.min((num - num_2) / num, 1)

						var_48_7 = Vector3.lerp(unbox, var_48_8, min)
					else
						var_48_7 = unbox
					end

					shoot_data.current_aim_position:store(var_48_7)

					local aim_constraint_target_var = shoot_data.aim_constraint_target_var

					Unit.animation_set_constraint_target(arg_48_0, aim_constraint_target_var, var_48_7)

					if not game and not go_id then
						GameSession.set_game_object_field(game, go_id, "aim_target", var_48_7)
					end
				end
			elseif current_action_name == "follow" then
				flag = true
			elseif current_action_name == "target_unreachable" then
				flag = true
			elseif current_action_name == "target_rage" then
				flag = true
			end

			if not flag then
				local target_unit = blackboard.target_unit
				local previous_aim_target_unit = arg_48_3.previous_aim_target_unit
				local target_dist = blackboard.target_dist
				local head_constraint_target = arg_48_3.head_constraint_target

				if not (not (target_dist < 50) or DEDICATED_SERVER) then
					fn(arg_48_0, arg_48_3, arg_48_2, target_unit, target_dist, head_constraint_target)
				end

				if target_unit ~= previous_aim_target_unit then
					arg_48_3.previous_aim_target_unit = target_unit
				end
			elseif not arg_48_3.is_using_head_constraint then
				arg_48_3.is_using_head_constraint = false

				Unit.animation_event(arg_48_0, "look_at_off")
			end
		end,
		leave = function (arg_49_0, arg_49_1)
			-- function 49
			if not arg_49_1.is_using_head_constraint then
				arg_49_1.is_using_head_constraint = false

				Unit.animation_event(arg_49_0, "look_at_off")
			end
		end
	},
	husk = {
		init = function (arg_50_0, arg_50_1)
			-- function 50
			arg_50_1.shoot_constraint_targets = BreedActions.skaven_stormfiend.shoot.aim_constraint_target
			arg_50_1.head_constraint_target = Unit.animation_find_constraint_target(arg_50_0, "head_aim_target")
			arg_50_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
			-- function 51
			local game = Managers.state.network:game()
			local unit_storage = Managers.state.unit_storage
			local go_id = unit_storage:go_id(arg_51_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "bt_action_name")
				local var_51_4 = NetworkLookup.bt_action_names[game_object_field]
				local flag = false

				if var_51_4 == "shoot" then
					flag = true

					local game_object_field_2 = GameSession.game_object_field(game, go_id, "aim_target")
					local game_object_field_3 = GameSession.game_object_field(game, go_id, "attack_arm")
					local var_51_8 = NetworkLookup.attack_arm[game_object_field_3]
					local var_51_9 = arg_51_3.shoot_constraint_targets[var_51_8]
					local animation_find_constraint_target = Unit.animation_find_constraint_target(arg_51_0, var_51_9)
					local var_51_11

					if not arg_51_3.prev_aim_target then
						var_51_11 = Vector3.lerp(arg_51_3.prev_aim_target:unbox(), game_object_field_2, 0.5)

						arg_51_3.prev_aim_target:store(var_51_11)
					else
						var_51_11 = game_object_field_2
						arg_51_3.prev_aim_target = Vector3Box(game_object_field_2)
					end

					Unit.animation_set_constraint_target(arg_51_0, animation_find_constraint_target, var_51_11)
				else
					if arg_51_3.prev_aim_target ~= nil then
						arg_51_3.prev_aim_target = nil
					end

					if var_51_4 == "follow" then
						flag = true
					elseif var_51_4 == "target_unreachable" then
						flag = true
					elseif var_51_4 == "target_rage" then
						flag = true
					end
				end

				if not flag then
					local game_object_field_4 = GameSession.game_object_field(game, go_id, "target_unit_id")

					if game_object_field_4 > 0 then
						local unit = unit_storage:unit(game_object_field_4)
						local flag_2 = not unit and Vector3.distance(POSITION_LOOKUP[arg_51_0], POSITION_LOOKUP[unit])
						local head_constraint_target = arg_51_3.head_constraint_target

						fn(arg_51_0, arg_51_3, arg_51_2, unit, flag_2, head_constraint_target)
					end
				elseif not arg_51_3.is_using_head_constraint then
					arg_51_3.is_using_head_constraint = false

					Unit.animation_event(arg_51_0, "look_at_off")
				end
			end
		end,
		leave = function (arg_52_0, arg_52_1)
			-- function 52
			if not arg_52_1.is_using_head_constraint then
				arg_52_1.is_using_head_constraint = false

				Unit.animation_event(arg_52_0, "look_at_off")
			end
		end
	}
}
AimTemplates.innkeeper = {
	owner = {
		init = function (arg_53_0, arg_53_1)
			-- function 53
			arg_53_1.constraint_target = Unit.animation_find_constraint_target(arg_53_0, "lookat")
			arg_53_1.current_target = nil
			arg_53_1.interpolation_origin_position = Vector3Box()
			arg_53_1.last_position = Vector3Box()
			arg_53_1.interpolation_time = -math.huge
		end,
		update = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
			-- function 54
			local local_position = Unit.local_position(arg_54_0, 0)
			local var_54_1
			local num = 9
			local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
			local current_target = arg_54_3.current_target
			local num_2 = 0.9025

			for i = 1, #PLAYER_UNITS do
				local var_54_6 = PLAYER_UNITS[i]
				local distance_squared = Vector3.distance_squared(POSITION_LOOKUP[var_54_6], local_position)

				if var_54_6 == current_target then
					distance_squared = distance_squared * num_2
				end

				if distance_squared < num then
					num = distance_squared
					var_54_1 = var_54_6
				end
			end

			local num_3 = 0.5

			if not (not var_54_1 and current_target) then
				Unit.animation_event(arg_54_0, "lookat_on")
			elseif var_54_1 or not current_target then
				Unit.animation_event(arg_54_0, "lookat_off")

				arg_54_3.interpolation_time = -math.huge
			elseif var_54_1 ~= current_target then
				arg_54_3.interpolation_time = arg_54_1 + num_3

				arg_54_3.interpolation_origin_position:store(arg_54_3.last_position:unbox())
			end

			local interpolation_time = arg_54_3.interpolation_time

			if not var_54_1 then
				local var_54_10

				if not ScriptUnit.has_extension(var_54_1, "first_person_system") then
					var_54_10 = ScriptUnit.extension(var_54_1, "first_person_system"):current_position()
				else
					local node = Unit.node(var_54_1, "j_head")

					var_54_10 = Unit.world_position(var_54_1, node)
				end

				if arg_54_1 < interpolation_time then
					local sin = math.sin((1 - (interpolation_time - arg_54_1) / num_3) * math.pi * 0.5)
					local unbox = arg_54_3.interpolation_origin_position:unbox()

					var_54_10 = Vector3.lerp(unbox, var_54_10, sin)
				end

				arg_54_3.last_position:store(var_54_10)
				Unit.animation_set_constraint_target(arg_54_0, arg_54_3.constraint_target, var_54_10)
			end

			arg_54_3.current_target = var_54_1
		end,
		leave = function (arg_55_0, arg_55_1)
			-- function 55
			return
		end
	}
}
AimTemplates.closest_player = {
	owner = {
		init = function (arg_56_0, arg_56_1)
			-- function 56
			arg_56_1.constraint_target = Unit.animation_find_constraint_target(arg_56_0, "aim_constraint_target")
			arg_56_1.current_target = nil
			arg_56_1.interpolation_origin_position = Vector3Box()
			arg_56_1.last_position = Vector3Box()
			arg_56_1.interpolation_time = -math.huge
		end,
		update = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
			-- function 57
			local player_unit = Managers.player:local_player().player_unit

			if not player_unit then
				local node = Unit.node(player_unit, "j_head")
				local world_position = Unit.world_position(player_unit, node)

				Unit.animation_set_constraint_target(arg_57_0, arg_57_3.constraint_target, world_position)
			end
		end,
		leave = function (arg_58_0, arg_58_1)
			-- function 58
			return
		end
	}
}
AimTemplates.closest_player_flat = {
	owner = {
		init = function (arg_59_0, arg_59_1)
			-- function 59
			arg_59_1.constraint_target = Unit.animation_find_constraint_target(arg_59_0, "aim_constraint_target")
			arg_59_1.current_target = nil
			arg_59_1.interpolation_origin_position = Vector3Box()
			arg_59_1.last_position = Vector3Box()
			arg_59_1.interpolation_time = -math.huge
		end,
		update = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
			-- function 60
			local player_unit = Managers.player:local_player().player_unit

			if not player_unit then
				local world_position = Unit.world_position(player_unit, 0)
				local node = Unit.node(arg_60_0, "j_aim")

				node = node or 0
				world_position[3] = Unit.world_position(arg_60_0, node)[3]

				Unit.animation_set_constraint_target(arg_60_0, arg_60_3.constraint_target, world_position)
			end
		end,
		leave = function (arg_61_0, arg_61_1)
			-- function 61
			return
		end
	}
}

DLCUtils.require_list("aim_templates_file_names")
