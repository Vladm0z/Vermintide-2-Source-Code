-- chunkname: @scripts/unit_extensions/generic/aim_templates.lua

AimTemplates = AimTemplates or {}

local var_0_0 = BLACKBOARDS
local var_0_1 = 1.9999999
local var_0_2 = -0.95
local var_0_3 = -0.8
local var_0_4 = 0.6
local var_0_5 = 3
local var_0_6 = 5

local function var_0_7(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	local var_1_0 = arg_1_1.is_using_head_constraint

	if not var_1_0 and not arg_1_6 then
		arg_1_1.is_using_head_constraint = true

		Unit.animation_event(arg_1_0, arg_1_1.look_at_on_animation or "look_at_on")
	end

	if not arg_1_3 or not Unit.alive(arg_1_3) then
		AiUtils.set_default_anim_constraint(arg_1_0, arg_1_5)

		return
	end

	local var_1_1
	local var_1_2 = ScriptUnit.has_extension(arg_1_3, "first_person_system")

	if var_1_2 ~= nil then
		var_1_1 = var_1_2:current_position()
	else
		local var_1_3 = Unit.has_node(arg_1_3, "j_head") and Unit.node(arg_1_3, "j_head") or 0

		var_1_1 = Unit.world_position(arg_1_3, var_1_3)
	end

	local var_1_4 = Unit.world_rotation(arg_1_0, 0)
	local var_1_5 = Vector3.flat(Quaternion.forward(var_1_4))
	local var_1_6 = Vector3.normalize(var_1_5)
	local var_1_7 = POSITION_LOOKUP[arg_1_0]
	local var_1_8 = Vector3.flat(var_1_1 - var_1_7)
	local var_1_9 = Vector3.normalize(var_1_8)

	if Vector3.dot(var_1_9, var_1_6) < math.inverse_sqrt_2 then
		local var_1_10 = var_1_1.z
		local var_1_11 = Vector3.flat(Quaternion.right(var_1_4))

		if Vector3.cross(var_1_6, var_1_9).z > 0 then
			var_1_1 = var_1_7 + (var_1_5 - var_1_11) * arg_1_4
		else
			var_1_1 = var_1_7 + (var_1_5 + var_1_11) * arg_1_4
		end

		var_1_1.z = var_1_10
	end

	if var_1_0 and not arg_1_1.lerp_aiming_disabled then
		local var_1_12 = arg_1_1.previous_look_target:unbox()
		local var_1_13 = math.min(arg_1_2 * 5, 1)

		var_1_1 = Vector3.lerp(var_1_12, var_1_1, var_1_13)
	end

	arg_1_1.previous_look_target:store(var_1_1)
	Unit.animation_set_constraint_target(arg_1_0, arg_1_5, var_1_1)
end

AimTemplates.player = {
	owner = {
		init = function (arg_2_0, arg_2_1)
			arg_2_1.packmaster_claw_aim_constraint = Unit.animation_find_constraint_target(arg_2_0, "packmaster_claw_target")
			arg_2_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_2_0, "aim_constraint_target")
			arg_2_1.look_direction_anim_var = Unit.animation_find_variable(arg_2_0, "aim_direction")
			arg_2_1.aim_direction_pitch_var = Unit.animation_find_variable(arg_2_0, "aim_direction_pitch")
			arg_2_1.locomotion_extension = ScriptUnit.extension(arg_2_0, "locomotion_system")
			arg_2_1.status_extension = ScriptUnit.extension(arg_2_0, "status_system")
			arg_2_1.min_head_lookat_z = -3

			local var_2_0 = Managers.player:owner(arg_2_0)

			if var_2_0 then
				local var_2_1 = var_2_0:profile_index()
				local var_2_2 = var_2_0:career_index()
				local var_2_3 = SPProfiles[var_2_1]
				local var_2_4 = var_2_3 and var_2_3.careers
				local var_2_5 = var_2_4 and var_2_4[var_2_2]

				if var_2_5 and var_2_5.min_head_lookat_z then
					arg_2_1.min_head_lookat_z = var_2_5.min_head_lookat_z
				end
			end
		end,
		update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0
			local var_3_1 = Quaternion.forward(Unit.local_rotation(arg_3_0, 0))
			local var_3_2 = arg_3_3.status_extension

			if var_3_2:is_grabbed_by_pack_master() then
				local var_3_3 = var_3_2:get_pack_master_grabber()
				local var_3_4 = Unit.node(var_3_3, "j_rightweaponcomponent10")
				local var_3_5 = Unit.world_position(var_3_3, var_3_4)

				Unit.animation_set_constraint_target(arg_3_0, arg_3_3.packmaster_claw_aim_constraint, var_3_5)

				var_3_0 = var_3_1
			elseif var_3_2:is_inspecting() then
				var_3_0 = var_3_1
			else
				local var_3_6 = arg_3_3.locomotion_extension:current_rotation()

				var_3_0 = Quaternion.forward(var_3_6)
			end

			Unit.animation_set_variable(arg_3_0, arg_3_3.aim_direction_pitch_var, math.clamp(Quaternion.pitch(Quaternion.look(var_3_0)), -1, 1))

			local var_3_7 = arg_3_3.status_extension:is_crouching() and -3 or arg_3_3.min_head_lookat_z
			local var_3_8 = var_3_0 * 3
			local var_3_9 = var_3_8.z

			var_3_8.z = math.clamp(var_3_9, var_3_7, 3)

			local var_3_10 = Unit.world_position(arg_3_0, Unit.node(arg_3_0, "camera_attach")) + var_3_8

			Unit.animation_set_constraint_target(arg_3_0, arg_3_3.aim_constraint_anim_var, var_3_10)

			local var_3_11 = Vector3.normalize(Vector3.flat(var_3_0))
			local var_3_12 = Vector3.normalize(Vector3.flat(var_3_1))
			local var_3_13 = -(((math.atan2(var_3_11.y, var_3_11.x) - math.atan2(var_3_12.y, var_3_12.x)) / math.pi + 1) % 2 - 1) * 2

			Unit.animation_set_variable(arg_3_0, arg_3_3.look_direction_anim_var, math.clamp(var_3_13, -var_0_1, var_0_1))

			local var_3_14 = Managers.state.network:game()
			local var_3_15 = Managers.state.unit_storage:go_id(arg_3_0)

			if var_3_14 and var_3_15 then
				local var_3_16 = ScriptUnit.extension(arg_3_0, "first_person_system"):current_position()
				local var_3_17 = NetworkUtils.network_clamp_position(var_3_16)

				GameSession.set_game_object_field(var_3_14, var_3_15, "aim_direction", var_3_0)
				GameSession.set_game_object_field(var_3_14, var_3_15, "aim_position", var_3_17)
			end
		end,
		leave = function (arg_4_0, arg_4_1)
			return
		end
	},
	husk = {
		init = function (arg_5_0, arg_5_1)
			arg_5_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_5_0, "aim_constraint_target")
			arg_5_1.look_direction_anim_var = Unit.animation_find_variable(arg_5_0, "aim_direction")
			arg_5_1.aim_direction_pitch_var = Unit.animation_find_variable(arg_5_0, "aim_direction_pitch")
			arg_5_1.packmaster_claw_aim_constraint = Unit.animation_find_constraint_target(arg_5_0, "packmaster_claw_target")
			arg_5_1.camera_attach_node = Unit.node(arg_5_0, "camera_attach")
			arg_5_1.status_extension = ScriptUnit.extension(arg_5_0, "status_system")
			arg_5_1.min_head_lookat_z = -3

			local var_5_0 = Managers.player:owner(arg_5_0)

			if var_5_0 then
				local var_5_1 = var_5_0:profile_index()
				local var_5_2 = var_5_0:career_index()
				local var_5_3 = SPProfiles[var_5_1]
				local var_5_4 = var_5_3 and var_5_3.careers
				local var_5_5 = var_5_4 and var_5_4[var_5_2]

				if var_5_5 and var_5_5.min_head_lookat_z then
					arg_5_1.min_head_lookat_z = var_5_5.min_head_lookat_z
				end
			end
		end,
		update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = Managers.state.network:game()
			local var_6_1 = Managers.state.unit_storage:go_id(arg_6_0)

			if not var_6_0 or not var_6_1 then
				return
			end

			local var_6_2 = GameSession.game_object_field(var_6_0, var_6_1, "aim_direction")
			local var_6_3 = Quaternion.look(var_6_2)
			local var_6_4 = Quaternion.yaw(var_6_3)
			local var_6_5 = Unit.get_data(arg_6_0, "breed").custom_husk_max_pitch or var_0_4
			local var_6_6 = math.clamp(Quaternion.pitch(var_6_3), var_0_2, var_6_5)
			local var_6_7 = Quaternion(Vector3.up(), var_6_4)
			local var_6_8 = Quaternion(Vector3.right(), var_6_6)
			local var_6_9 = Quaternion.multiply(var_6_7, var_6_8)
			local var_6_10 = Vector3.normalize(Quaternion.forward(var_6_9))
			local var_6_11 = arg_6_3.status_extension:is_crouching() and -3 or arg_6_3.min_head_lookat_z
			local var_6_12 = var_6_10 * 3
			local var_6_13 = var_6_12.z

			var_6_12.z = math.clamp(var_6_13, var_6_11, 3)

			local var_6_14 = Unit.world_position(arg_6_0, arg_6_3.camera_attach_node)

			if script_data.lerp_debug or script_data.extrapolation_debug then
				local var_6_15 = Matrix4x4.translation(Unit.animation_get_constraint_target(arg_6_0, arg_6_3.aim_constraint_anim_var))
				local var_6_16 = var_6_14 + var_6_12

				Unit.animation_set_constraint_target(arg_6_0, arg_6_3.aim_constraint_anim_var, var_6_16)
				Unit.animation_set_variable(arg_6_0, Unit.animation_find_variable(arg_6_0, "aim_direction_pitch"), math.clamp(var_6_6, -1, 1))
			else
				Unit.animation_set_constraint_target(arg_6_0, arg_6_3.aim_constraint_anim_var, var_6_14 + var_6_12)
			end

			local var_6_17 = GameSession.game_object_field(var_6_0, var_6_1, "yaw")
			local var_6_18 = GameSession.game_object_field(var_6_0, var_6_1, "pitch")
			local var_6_19 = Quaternion(Vector3.up(), var_6_17)
			local var_6_20 = Quaternion(Vector3.right(), var_6_18)
			local var_6_21 = Quaternion.multiply(var_6_19, var_6_20)
			local var_6_22 = Quaternion.forward(var_6_21)

			Vector3.set_z(var_6_22, 0)
			Vector3.set_z(var_6_12, 0)

			local var_6_23 = Vector3.normalize(var_6_22)
			local var_6_24 = Vector3.normalize(var_6_12)
			local var_6_25 = -(((math.atan2(var_6_24.y, var_6_24.x) - math.atan2(var_6_23.y, var_6_23.x)) / math.pi + 1) % 2 - 1) * 2

			Unit.animation_set_variable(arg_6_0, arg_6_3.look_direction_anim_var, math.clamp(var_6_25, -var_0_1, var_0_1))

			if arg_6_3.status_extension:is_grabbed_by_pack_master() then
				local var_6_26 = arg_6_3.status_extension:get_pack_master_grabber()
				local var_6_27 = Unit.node(var_6_26, "j_rightweaponcomponent10")
				local var_6_28 = Unit.world_position(var_6_26, var_6_27)

				Unit.animation_set_constraint_target(arg_6_0, arg_6_3.packmaster_claw_aim_constraint, var_6_28)
			end
		end,
		leave = function (arg_7_0, arg_7_1)
			return
		end
	}
}
AimTemplates.enemy_character = {
	owner = {
		init = function (arg_8_0, arg_8_1)
			arg_8_1.breed = Unit.get_data(arg_8_0, "breed")
			arg_8_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_8_0, "aim_constraint_target")
			arg_8_1.look_direction_anim_var = Unit.animation_find_variable(arg_8_0, "aim_direction")
			arg_8_1.aim_direction_pitch_var = Unit.animation_find_variable(arg_8_0, "aim_direction_pitch")
			arg_8_1.locomotion_extension = ScriptUnit.extension(arg_8_0, "locomotion_system")
			arg_8_1.status_extension = ScriptUnit.extension(arg_8_0, "status_system")
		end,
		update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			local var_9_0
			local var_9_1 = Quaternion.forward(Unit.local_rotation(arg_9_0, 0))
			local var_9_2 = arg_9_3.status_extension

			if var_9_2:is_inspecting() then
				var_9_0 = var_9_1
			elseif var_9_2:get_is_packmaster_dragging() then
				var_9_0 = var_9_1
			else
				local var_9_3 = arg_9_3.locomotion_extension:current_rotation()

				var_9_0 = Quaternion.forward(var_9_3)
			end

			Unit.animation_set_variable(arg_9_0, arg_9_3.aim_direction_pitch_var, math.clamp(Quaternion.pitch(Quaternion.look(var_9_0)), -1, 1))

			local var_9_4 = var_9_0 * var_0_5
			local var_9_5 = Unit.world_position(arg_9_0, Unit.node(arg_9_0, "camera_attach")) + var_9_4

			Unit.animation_set_constraint_target(arg_9_0, arg_9_3.aim_constraint_anim_var, var_9_5)

			local var_9_6 = Vector3.normalize(Vector3.flat(var_9_0))
			local var_9_7 = Vector3.normalize(Vector3.flat(var_9_1))
			local var_9_8 = -(((math.atan2(var_9_6.y, var_9_6.x) - math.atan2(var_9_7.y, var_9_7.x)) / math.pi + 1) % 2 - 1) * 2

			Unit.animation_set_variable(arg_9_0, arg_9_3.look_direction_anim_var, math.clamp(var_9_8, -var_0_1, var_0_1))

			local var_9_9 = Managers.state.network:game()
			local var_9_10 = Managers.state.unit_storage:go_id(arg_9_0)

			if var_9_9 and var_9_10 then
				local var_9_11 = ScriptUnit.extension(arg_9_0, "first_person_system"):current_position()
				local var_9_12 = NetworkUtils.network_clamp_position(var_9_11)

				GameSession.set_game_object_field(var_9_9, var_9_10, "aim_direction", var_9_0)
				GameSession.set_game_object_field(var_9_9, var_9_10, "aim_position", var_9_12)
			end
		end,
		leave = function (arg_10_0, arg_10_1)
			return
		end
	},
	husk = {
		init = function (arg_11_0, arg_11_1)
			local var_11_0 = Unit.get_data(arg_11_0, "breed")

			arg_11_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_11_0, "aim_constraint_target")
			arg_11_1.look_direction_anim_var = Unit.animation_find_variable(arg_11_0, "aim_direction")
			arg_11_1.aim_direction_pitch_var = Unit.animation_find_variable(arg_11_0, "aim_direction_pitch")
			arg_11_1.boss = var_11_0.boss or false
			arg_11_1.aim_constraint_forward_multiplier = var_11_0.aim_constraint_forward_multiplier or 1
			arg_11_1.camera_attach_node = Unit.node(arg_11_0, "camera_attach")
			arg_11_1.status_extension = ScriptUnit.extension(arg_11_0, "status_system")
			arg_11_1.husk_locomotion_extension = ScriptUnit.extension(arg_11_0, "locomotion_system")
		end,
		update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			local var_12_0 = Managers.state.network:game()
			local var_12_1 = Managers.state.unit_storage:go_id(arg_12_0)

			if not var_12_0 or not var_12_1 then
				return
			end

			local var_12_2 = GameSession.game_object_field(var_12_0, var_12_1, "aim_direction")
			local var_12_3 = Quaternion.look(var_12_2)
			local var_12_4 = Quaternion.yaw(var_12_3)
			local var_12_5 = Unit.get_data(arg_12_0, "breed").custom_husk_max_pitch or var_0_4
			local var_12_6

			if arg_12_3.boss then
				var_12_6 = math.clamp(Quaternion.pitch(var_12_3), var_0_3, var_12_5)
			else
				var_12_6 = math.clamp(Quaternion.pitch(var_12_3), var_0_2, var_12_5)
			end

			local var_12_7 = Quaternion(Vector3.up(), var_12_4)
			local var_12_8 = Quaternion(Vector3.right(), var_12_6)
			local var_12_9 = Quaternion.multiply(var_12_7, var_12_8)
			local var_12_10 = Vector3.normalize(Quaternion.forward(var_12_9))
			local var_12_11

			if arg_12_3.boss then
				var_12_11 = var_12_10 * var_0_6
			else
				var_12_11 = var_12_10 * var_0_5
			end

			local var_12_12 = var_12_11 * arg_12_3.aim_constraint_forward_multiplier
			local var_12_13 = Unit.world_position(arg_12_0, arg_12_3.camera_attach_node)

			if script_data.lerp_debug or script_data.extrapolation_debug then
				local var_12_14 = Matrix4x4.translation(Unit.animation_get_constraint_target(arg_12_0, arg_12_3.aim_constraint_anim_var))
				local var_12_15 = var_12_13 + var_12_12

				Unit.animation_set_constraint_target(arg_12_0, arg_12_3.aim_constraint_anim_var, var_12_15)
				Unit.animation_set_variable(arg_12_0, Unit.animation_find_variable(arg_12_0, "aim_direction_pitch"), math.clamp(var_12_6, -1, 1))
			else
				Unit.animation_set_constraint_target(arg_12_0, arg_12_3.aim_constraint_anim_var, var_12_13 + var_12_12)
			end

			local var_12_16 = GameSession.game_object_field(var_12_0, var_12_1, "yaw")
			local var_12_17 = GameSession.game_object_field(var_12_0, var_12_1, "pitch")
			local var_12_18 = Quaternion(Vector3.up(), var_12_16)
			local var_12_19 = Quaternion(Vector3.right(), var_12_17)
			local var_12_20 = Quaternion.multiply(var_12_18, var_12_19)
			local var_12_21 = Quaternion.forward(var_12_20)

			Vector3.set_z(var_12_21, 0)
			Vector3.set_z(var_12_12, 0)

			local var_12_22 = Vector3.normalize(var_12_21)
			local var_12_23 = Vector3.normalize(var_12_12)
			local var_12_24 = -(((math.atan2(var_12_23.y, var_12_23.x) - math.atan2(var_12_22.y, var_12_22.x)) / math.pi + 1) % 2 - 1) * 2

			Unit.animation_set_variable(arg_12_0, arg_12_3.look_direction_anim_var, math.clamp(var_12_24, -var_0_1, var_0_1))
		end,
		leave = function (arg_13_0, arg_13_1)
			return
		end
	}
}
AimTemplates.packmaster_claw = {
	owner = {
		init = function (arg_14_0, arg_14_1)
			arg_14_1.aim_constraint_anim_var = Unit.animation_find_constraint_target(arg_14_0, "aim_constraint_target")
		end,
		update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			return
		end,
		leave = function (arg_16_0, arg_16_1)
			return
		end
	}
}
AimTemplates.ratling_gunner = {
	owner = {
		init = function (arg_17_0, arg_17_1)
			arg_17_1.blackboard = var_0_0[arg_17_0]
			arg_17_1.constraint_target = Unit.animation_find_constraint_target(arg_17_0, "aim_target")
		end,
		update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			local var_18_0 = POSITION_LOOKUP[arg_18_0]
			local var_18_1
			local var_18_2 = arg_18_3.blackboard.attack_pattern_data

			if var_18_2 and var_18_2.shoot_direction_box then
				local var_18_3 = var_18_2.shoot_direction_box:unbox()

				var_18_1 = var_18_0 + Vector3.normalize(var_18_3) * 5
			else
				var_18_1 = var_18_0 + Quaternion.forward(Unit.local_rotation(arg_18_0, 0)) * 5
			end

			Unit.animation_set_constraint_target(arg_18_0, arg_18_3.constraint_target, var_18_1)

			local var_18_4 = Managers.state.network:game()
			local var_18_5 = Managers.state.unit_storage:go_id(arg_18_0)

			if var_18_4 and var_18_5 then
				GameSession.set_game_object_field(var_18_4, var_18_5, "aim_target", var_18_1)
			end
		end,
		leave = function (arg_19_0, arg_19_1)
			return
		end
	},
	husk = {
		init = function (arg_20_0, arg_20_1)
			arg_20_1.constraint_target = Unit.animation_find_constraint_target(arg_20_0, "aim_target")
		end,
		update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			local var_21_0 = Managers.state.network:game()
			local var_21_1 = Managers.state.unit_storage:go_id(arg_21_0)

			if var_21_0 and var_21_1 then
				local var_21_2 = GameSession.game_object_field(var_21_0, var_21_1, "aim_target")

				Unit.animation_set_constraint_target(arg_21_0, arg_21_3.constraint_target, var_21_2)
			else
				local var_21_3 = Quaternion.forward(Unit.local_rotation(arg_21_0, 0))
				local var_21_4 = POSITION_LOOKUP[arg_21_0] + var_21_3 * 5

				Unit.animation_set_constraint_target(arg_21_0, arg_21_3.constraint_target, var_21_4)
			end
		end,
		leave = function (arg_22_0, arg_22_1)
			return
		end
	}
}
AimTemplates.pack_master = {
	owner = {
		init = function (arg_23_0, arg_23_1)
			arg_23_1.blackboard = var_0_0[arg_23_0]
			arg_23_1.constraint_target = Unit.animation_find_constraint_target(arg_23_0, "aim_constraint_target")
		end,
		update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			local var_24_0 = arg_24_3.blackboard.target_unit

			if ALIVE[var_24_0] then
				local var_24_1 = Unit.node(var_24_0, "j_head")
				local var_24_2 = Unit.world_position(var_24_0, var_24_1)

				Unit.animation_set_constraint_target(arg_24_0, arg_24_3.constraint_target, var_24_2)

				local var_24_3 = Managers.state.network:game()
				local var_24_4 = Managers.state.unit_storage:go_id(arg_24_0)

				if var_24_3 and var_24_4 then
					GameSession.set_game_object_field(var_24_3, var_24_4, "aim_target", var_24_2)
				end
			end
		end,
		leave = function (arg_25_0, arg_25_1)
			return
		end
	},
	husk = {
		init = function (arg_26_0, arg_26_1)
			arg_26_1.constraint_target = Unit.animation_find_constraint_target(arg_26_0, "aim_constraint_target")
		end,
		update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			local var_27_0 = Managers.state.network:game()
			local var_27_1 = Managers.state.unit_storage:go_id(arg_27_0)

			if var_27_0 and var_27_1 then
				local var_27_2 = GameSession.game_object_field(var_27_0, var_27_1, "aim_target")

				if var_27_2 then
					Unit.animation_set_constraint_target(arg_27_0, arg_27_3.constraint_target, var_27_2)

					return
				end
			end

			local var_27_3 = Quaternion.forward(Unit.local_rotation(arg_27_0, 0))
			local var_27_4 = POSITION_LOOKUP[arg_27_0] + var_27_3 * 5

			Unit.animation_set_constraint_target(arg_27_0, arg_27_3.constraint_target, var_27_4)
		end,
		leave = function (arg_28_0, arg_28_1)
			return
		end
	}
}
AimTemplates.warpfire_thrower = {
	owner = {
		init = function (arg_29_0, arg_29_1)
			arg_29_1.blackboard = var_0_0[arg_29_0]
			arg_29_1.constraint_target = Unit.animation_find_constraint_target(arg_29_0, "aim_target")
		end,
		update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
			local var_30_0 = POSITION_LOOKUP[arg_30_0]
			local var_30_1
			local var_30_2 = arg_30_3.blackboard.attack_pattern_data

			if var_30_2 and var_30_2.shoot_direction_box then
				local var_30_3 = var_30_2.shoot_direction_box:unbox()

				var_30_1 = var_30_0 + Vector3.normalize(var_30_3) * 5
			else
				var_30_1 = var_30_0 + Quaternion.forward(Unit.local_rotation(arg_30_0, 0)) * 5
			end

			Unit.animation_set_constraint_target(arg_30_0, arg_30_3.constraint_target, var_30_1)

			local var_30_4 = Managers.state.network:game()
			local var_30_5 = Managers.state.unit_storage:go_id(arg_30_0)

			if var_30_4 and var_30_5 then
				GameSession.set_game_object_field(var_30_4, var_30_5, "aim_target", var_30_1)
			end
		end,
		leave = function (arg_31_0, arg_31_1)
			return
		end
	},
	husk = {
		init = function (arg_32_0, arg_32_1)
			arg_32_1.constraint_target = Unit.animation_find_constraint_target(arg_32_0, "aim_target")
		end,
		update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
			local var_33_0 = Managers.state.network:game()
			local var_33_1 = Managers.state.unit_storage:go_id(arg_33_0)

			if var_33_0 and var_33_1 then
				local var_33_2 = GameSession.game_object_field(var_33_0, var_33_1, "aim_target")

				Unit.animation_set_constraint_target(arg_33_0, arg_33_3.constraint_target, var_33_2)
			else
				local var_33_3 = Quaternion.forward(Unit.local_rotation(arg_33_0, 0))
				local var_33_4 = POSITION_LOOKUP[arg_33_0] + var_33_3 * 5

				Unit.animation_set_constraint_target(arg_33_0, arg_33_3.constraint_target, var_33_4)
			end
		end,
		leave = function (arg_34_0, arg_34_1)
			return
		end
	}
}
AimTemplates.chaos_warrior = {
	owner = {
		init = function (arg_35_0, arg_35_1)
			arg_35_1.blackboard = var_0_0[arg_35_0]
			arg_35_1.constraint_target = Unit.animation_find_constraint_target(arg_35_0, "aim_target")
			arg_35_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
			if not Unit.has_animation_state_machine(arg_36_0) then
				return
			end

			local var_36_0 = arg_36_3.blackboard
			local var_36_1 = var_36_0.target_unit
			local var_36_2 = arg_36_3.previous_aim_target_unit
			local var_36_3 = arg_36_3.constraint_target

			if not var_36_1 or not Unit.alive(var_36_1) then
				AiUtils.set_default_anim_constraint(arg_36_0, var_36_3)

				return
			end

			local var_36_4

			if ScriptUnit.has_extension(var_36_1, "first_person_system") then
				local var_36_5 = ScriptUnit.extension(var_36_1, "first_person_system"):current_position()
			else
				local var_36_6 = Unit.node(var_36_1, "j_head")
				local var_36_7 = Unit.world_position(var_36_1, var_36_6)
			end

			local var_36_8 = var_36_0.target_dist
			local var_36_9 = var_36_0.breed
			local var_36_10
			local var_36_11, var_36_12 = Managers.state.network:game_object_or_level_id(var_36_1)

			if not var_36_12 and var_36_8 < (var_36_9.look_at_range or 30) then
				var_36_10 = true
			end

			if not DEDICATED_SERVER and var_36_10 then
				var_0_7(arg_36_0, arg_36_3, arg_36_2, var_36_1, var_36_8, var_36_3, true)
			end

			if var_36_1 ~= var_36_2 then
				arg_36_3.previous_aim_target_unit = var_36_1
			end
		end,
		leave = function (arg_37_0, arg_37_1)
			return
		end
	},
	husk = {
		init = function (arg_38_0, arg_38_1)
			arg_38_1.constraint_target = Unit.animation_find_constraint_target(arg_38_0, "aim_target")
			arg_38_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
			if not Unit.has_animation_state_machine(arg_39_0) then
				return
			end

			local var_39_0 = Managers.state.network:game()
			local var_39_1 = Managers.state.unit_storage:go_id(arg_39_0)
			local var_39_2 = arg_39_3.constraint_target

			if var_39_0 and var_39_1 then
				local var_39_3 = GameSession.game_object_field(var_39_0, var_39_1, "target_unit_id")
				local var_39_4 = Managers.state.unit_storage:unit(var_39_3)

				if not var_39_4 or not Unit.alive(var_39_4) or var_39_3 <= 0 then
					AiUtils.set_default_anim_constraint(arg_39_0, var_39_2)

					return
				end

				local var_39_5

				if ScriptUnit.has_extension(var_39_4, "first_person_system") then
					local var_39_6 = ScriptUnit.extension(var_39_4, "first_person_system"):current_position()
				elseif Unit.has_node(var_39_4, "j_head") then
					local var_39_7 = Unit.node(var_39_4, "j_head")
					local var_39_8 = Unit.world_position(var_39_4, var_39_7)
				else
					AiUtils.set_default_anim_constraint(arg_39_0, var_39_2)

					return
				end

				local var_39_9 = Managers.state.unit_storage:unit(var_39_3)
				local var_39_10 = var_39_9 and Vector3.distance(POSITION_LOOKUP[arg_39_0], POSITION_LOOKUP[var_39_9])
				local var_39_11

				if var_39_10 < 30 then
					var_39_11 = true
				end

				if var_39_11 then
					local var_39_12 = arg_39_3.constraint_target

					arg_39_3.lerp_aiming_disabled = true

					var_0_7(arg_39_0, arg_39_3, arg_39_2, var_39_9, var_39_10, var_39_12, true)
				end
			else
				AiUtils.set_default_anim_constraint(arg_39_0, var_39_2)
			end
		end,
		leave = function (arg_40_0, arg_40_1)
			return
		end
	}
}
AimTemplates.chaos_marauder = {
	owner = {
		init = function (arg_41_0, arg_41_1)
			arg_41_1.blackboard = var_0_0[arg_41_0]
			arg_41_1.ai_extension = ScriptUnit.extension(arg_41_0, "ai_system")
			arg_41_1.head_constraint_target = Unit.animation_find_constraint_target(arg_41_0, "head_aim_target")
			arg_41_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
			local var_42_0 = arg_42_3.blackboard
			local var_42_1 = arg_42_3.ai_extension:current_action_name()
			local var_42_2 = Managers.state.network:game()
			local var_42_3 = Managers.state.unit_storage:go_id(arg_42_0)
			local var_42_4 = false
			local var_42_5 = var_42_0.target_dist
			local var_42_6 = var_42_0.breed
			local var_42_7 = var_42_0.target_unit
			local var_42_8 = arg_42_3.head_constraint_target

			if not var_42_7 or not Unit.alive(var_42_7) then
				AiUtils.set_default_anim_constraint(arg_42_0, var_42_8)

				return
			end

			local var_42_9, var_42_10 = Managers.state.network:game_object_or_level_id(var_42_7)
			local var_42_11 = var_42_1 == "follow" or var_42_1 == "combat_step"

			if not var_42_10 and var_42_11 and var_42_5 < (var_42_6.look_at_range or 30) then
				var_42_4 = true
			end

			local var_42_12 = ScriptUnit.has_extension(arg_42_0, "death_system")

			if var_42_12 and var_42_12:has_death_started() then
				var_42_4 = false
			end

			if var_42_4 then
				local var_42_13 = arg_42_3.previous_aim_target_unit

				arg_42_3.lerp_aiming_disabled = true

				if not DEDICATED_SERVER then
					var_0_7(arg_42_0, arg_42_3, arg_42_2, var_42_7, var_42_5, var_42_8)
				end

				if var_42_7 ~= var_42_13 then
					arg_42_3.previous_aim_target_unit = var_42_7
				end
			elseif arg_42_3.is_using_head_constraint then
				arg_42_3.is_using_head_constraint = false

				Unit.animation_event(arg_42_0, "look_at_off")
			end
		end,
		leave = function (arg_43_0, arg_43_1)
			if arg_43_1.is_using_head_constraint then
				arg_43_1.is_using_head_constraint = false

				Unit.animation_event(arg_43_0, "look_at_off")
			end
		end
	},
	husk = {
		init = function (arg_44_0, arg_44_1)
			arg_44_1.head_constraint_target = Unit.animation_find_constraint_target(arg_44_0, "head_aim_target")
			arg_44_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
			local var_45_0 = Managers.state.network:game()
			local var_45_1 = Managers.state.unit_storage
			local var_45_2 = var_45_1:go_id(arg_45_0)

			if var_45_0 and var_45_2 then
				local var_45_3 = GameSession.game_object_field(var_45_0, var_45_2, "bt_action_name")
				local var_45_4 = NetworkLookup.bt_action_names[var_45_3]
				local var_45_5 = false

				if var_45_4 == "follow" then
					var_45_5 = true
				end

				if var_45_5 then
					local var_45_6 = GameSession.game_object_field(var_45_0, var_45_2, "target_unit_id")

					if var_45_6 > 0 then
						local var_45_7 = var_45_1:unit(var_45_6)
						local var_45_8 = var_45_7 and Vector3.distance(POSITION_LOOKUP[arg_45_0], POSITION_LOOKUP[var_45_7] or Unit.world_position(var_45_7, 0))
						local var_45_9 = arg_45_3.head_constraint_target

						arg_45_3.lerp_aiming_disabled = true

						if var_45_7 and Unit.has_node(var_45_7, "j_head") then
							var_0_7(arg_45_0, arg_45_3, arg_45_2, var_45_7, var_45_8, var_45_9)
						end
					end
				elseif arg_45_3.is_using_head_constraint then
					arg_45_3.is_using_head_constraint = false

					Unit.animation_event(arg_45_0, "look_at_off")
				end
			end
		end,
		leave = function (arg_46_0, arg_46_1)
			if arg_46_1.is_using_head_constraint then
				arg_46_1.is_using_head_constraint = false

				Unit.animation_event(arg_46_0, "look_at_off")
			end
		end
	}
}
AimTemplates.stormfiend = {
	owner = {
		init = function (arg_47_0, arg_47_1)
			arg_47_1.blackboard = var_0_0[arg_47_0]
			arg_47_1.ai_extension = ScriptUnit.extension(arg_47_0, "ai_system")
			arg_47_1.head_constraint_target = Unit.animation_find_constraint_target(arg_47_0, "head_aim_target")
			arg_47_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
			local var_48_0 = arg_48_3.blackboard
			local var_48_1 = arg_48_3.ai_extension:current_action_name()
			local var_48_2 = Managers.state.network:game()
			local var_48_3 = Managers.state.unit_storage:go_id(arg_48_0)
			local var_48_4 = false

			if var_48_1 == "shoot" then
				var_48_4 = true

				local var_48_5 = var_48_0.shoot_data

				if var_48_5.aiming_started then
					local var_48_6 = var_48_5.aim_start_position:unbox()
					local var_48_7

					if var_48_5.firing_initiated then
						local var_48_8

						if var_48_0.weapon_setup == "ratling_gun" then
							var_48_8 = POSITION_LOOKUP[var_48_0.target_unit]
						else
							var_48_8 = var_48_5.aim_end_position:unbox()
						end

						local var_48_9 = var_48_5.stop_firing_t - var_48_5.start_firing_t
						local var_48_10 = var_48_5.stop_firing_t - arg_48_1
						local var_48_11 = math.min((var_48_9 - var_48_10) / var_48_9, 1)

						var_48_7 = Vector3.lerp(var_48_6, var_48_8, var_48_11)
					else
						var_48_7 = var_48_6
					end

					var_48_5.current_aim_position:store(var_48_7)

					local var_48_12 = var_48_5.aim_constraint_target_var

					Unit.animation_set_constraint_target(arg_48_0, var_48_12, var_48_7)

					if var_48_2 and var_48_3 then
						GameSession.set_game_object_field(var_48_2, var_48_3, "aim_target", var_48_7)
					end
				end
			elseif var_48_1 == "follow" then
				var_48_4 = true
			elseif var_48_1 == "target_unreachable" then
				var_48_4 = true
			elseif var_48_1 == "target_rage" then
				var_48_4 = true
			end

			if var_48_4 then
				local var_48_13 = var_48_0.target_unit
				local var_48_14 = arg_48_3.previous_aim_target_unit
				local var_48_15 = var_48_0.target_dist
				local var_48_16 = arg_48_3.head_constraint_target

				if var_48_15 < 50 and not DEDICATED_SERVER then
					var_0_7(arg_48_0, arg_48_3, arg_48_2, var_48_13, var_48_15, var_48_16)
				end

				if var_48_13 ~= var_48_14 then
					arg_48_3.previous_aim_target_unit = var_48_13
				end
			elseif arg_48_3.is_using_head_constraint then
				arg_48_3.is_using_head_constraint = false

				Unit.animation_event(arg_48_0, "look_at_off")
			end
		end,
		leave = function (arg_49_0, arg_49_1)
			if arg_49_1.is_using_head_constraint then
				arg_49_1.is_using_head_constraint = false

				Unit.animation_event(arg_49_0, "look_at_off")
			end
		end
	},
	husk = {
		init = function (arg_50_0, arg_50_1)
			arg_50_1.shoot_constraint_targets = BreedActions.skaven_stormfiend.shoot.aim_constraint_target
			arg_50_1.head_constraint_target = Unit.animation_find_constraint_target(arg_50_0, "head_aim_target")
			arg_50_1.previous_look_target = Vector3Box()
		end,
		update = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
			local var_51_0 = Managers.state.network:game()
			local var_51_1 = Managers.state.unit_storage
			local var_51_2 = var_51_1:go_id(arg_51_0)

			if var_51_0 and var_51_2 then
				local var_51_3 = GameSession.game_object_field(var_51_0, var_51_2, "bt_action_name")
				local var_51_4 = NetworkLookup.bt_action_names[var_51_3]
				local var_51_5 = false

				if var_51_4 == "shoot" then
					var_51_5 = true

					local var_51_6 = GameSession.game_object_field(var_51_0, var_51_2, "aim_target")
					local var_51_7 = GameSession.game_object_field(var_51_0, var_51_2, "attack_arm")
					local var_51_8 = NetworkLookup.attack_arm[var_51_7]
					local var_51_9 = arg_51_3.shoot_constraint_targets[var_51_8]
					local var_51_10 = Unit.animation_find_constraint_target(arg_51_0, var_51_9)
					local var_51_11

					if arg_51_3.prev_aim_target then
						var_51_11 = Vector3.lerp(arg_51_3.prev_aim_target:unbox(), var_51_6, 0.5)

						arg_51_3.prev_aim_target:store(var_51_11)
					else
						var_51_11 = var_51_6
						arg_51_3.prev_aim_target = Vector3Box(var_51_6)
					end

					Unit.animation_set_constraint_target(arg_51_0, var_51_10, var_51_11)
				else
					if arg_51_3.prev_aim_target ~= nil then
						arg_51_3.prev_aim_target = nil
					end

					if var_51_4 == "follow" then
						var_51_5 = true
					elseif var_51_4 == "target_unreachable" then
						var_51_5 = true
					elseif var_51_4 == "target_rage" then
						var_51_5 = true
					end
				end

				if var_51_5 then
					local var_51_12 = GameSession.game_object_field(var_51_0, var_51_2, "target_unit_id")

					if var_51_12 > 0 then
						local var_51_13 = var_51_1:unit(var_51_12)
						local var_51_14 = var_51_13 and Vector3.distance(POSITION_LOOKUP[arg_51_0], POSITION_LOOKUP[var_51_13])
						local var_51_15 = arg_51_3.head_constraint_target

						var_0_7(arg_51_0, arg_51_3, arg_51_2, var_51_13, var_51_14, var_51_15)
					end
				elseif arg_51_3.is_using_head_constraint then
					arg_51_3.is_using_head_constraint = false

					Unit.animation_event(arg_51_0, "look_at_off")
				end
			end
		end,
		leave = function (arg_52_0, arg_52_1)
			if arg_52_1.is_using_head_constraint then
				arg_52_1.is_using_head_constraint = false

				Unit.animation_event(arg_52_0, "look_at_off")
			end
		end
	}
}
AimTemplates.innkeeper = {
	owner = {
		init = function (arg_53_0, arg_53_1)
			arg_53_1.constraint_target = Unit.animation_find_constraint_target(arg_53_0, "lookat")
			arg_53_1.current_target = nil
			arg_53_1.interpolation_origin_position = Vector3Box()
			arg_53_1.last_position = Vector3Box()
			arg_53_1.interpolation_time = -math.huge
		end,
		update = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
			local var_54_0 = Unit.local_position(arg_54_0, 0)
			local var_54_1
			local var_54_2 = 9
			local var_54_3 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
			local var_54_4 = arg_54_3.current_target
			local var_54_5 = 0.9025

			for iter_54_0 = 1, #var_54_3 do
				local var_54_6 = var_54_3[iter_54_0]
				local var_54_7 = Vector3.distance_squared(POSITION_LOOKUP[var_54_6], var_54_0)

				if var_54_6 == var_54_4 then
					var_54_7 = var_54_7 * var_54_5
				end

				if var_54_7 < var_54_2 then
					var_54_2 = var_54_7
					var_54_1 = var_54_6
				end
			end

			local var_54_8 = 0.5

			if var_54_1 and not var_54_4 then
				Unit.animation_event(arg_54_0, "lookat_on")
			elseif not var_54_1 and var_54_4 then
				Unit.animation_event(arg_54_0, "lookat_off")

				arg_54_3.interpolation_time = -math.huge
			elseif var_54_1 ~= var_54_4 then
				arg_54_3.interpolation_time = arg_54_1 + var_54_8

				arg_54_3.interpolation_origin_position:store(arg_54_3.last_position:unbox())
			end

			local var_54_9 = arg_54_3.interpolation_time

			if var_54_1 then
				local var_54_10

				if ScriptUnit.has_extension(var_54_1, "first_person_system") then
					var_54_10 = ScriptUnit.extension(var_54_1, "first_person_system"):current_position()
				else
					local var_54_11 = Unit.node(var_54_1, "j_head")

					var_54_10 = Unit.world_position(var_54_1, var_54_11)
				end

				if arg_54_1 < var_54_9 then
					local var_54_12 = math.sin((1 - (var_54_9 - arg_54_1) / var_54_8) * math.pi * 0.5)
					local var_54_13 = arg_54_3.interpolation_origin_position:unbox()

					var_54_10 = Vector3.lerp(var_54_13, var_54_10, var_54_12)
				end

				arg_54_3.last_position:store(var_54_10)
				Unit.animation_set_constraint_target(arg_54_0, arg_54_3.constraint_target, var_54_10)
			end

			arg_54_3.current_target = var_54_1
		end,
		leave = function (arg_55_0, arg_55_1)
			return
		end
	}
}
AimTemplates.closest_player = {
	owner = {
		init = function (arg_56_0, arg_56_1)
			arg_56_1.constraint_target = Unit.animation_find_constraint_target(arg_56_0, "aim_constraint_target")
			arg_56_1.current_target = nil
			arg_56_1.interpolation_origin_position = Vector3Box()
			arg_56_1.last_position = Vector3Box()
			arg_56_1.interpolation_time = -math.huge
		end,
		update = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
			local var_57_0 = Managers.player:local_player().player_unit

			if var_57_0 then
				local var_57_1 = Unit.node(var_57_0, "j_head")
				local var_57_2 = Unit.world_position(var_57_0, var_57_1)

				Unit.animation_set_constraint_target(arg_57_0, arg_57_3.constraint_target, var_57_2)
			end
		end,
		leave = function (arg_58_0, arg_58_1)
			return
		end
	}
}
AimTemplates.closest_player_flat = {
	owner = {
		init = function (arg_59_0, arg_59_1)
			arg_59_1.constraint_target = Unit.animation_find_constraint_target(arg_59_0, "aim_constraint_target")
			arg_59_1.current_target = nil
			arg_59_1.interpolation_origin_position = Vector3Box()
			arg_59_1.last_position = Vector3Box()
			arg_59_1.interpolation_time = -math.huge
		end,
		update = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
			local var_60_0 = Managers.player:local_player().player_unit

			if var_60_0 then
				local var_60_1 = Unit.world_position(var_60_0, 0)
				local var_60_2 = Unit.node(arg_60_0, "j_aim") or 0

				var_60_1[3] = Unit.world_position(arg_60_0, var_60_2)[3]

				Unit.animation_set_constraint_target(arg_60_0, arg_60_3.constraint_target, var_60_1)
			end
		end,
		leave = function (arg_61_0, arg_61_1)
			return
		end
	}
}

DLCUtils.require_list("aim_templates_file_names")
