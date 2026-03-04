-- chunkname: @scripts/unit_extensions/generic/animation_movement_templates.lua

AnimationMovementTemplates = AnimationMovementTemplates or {}

local var_0_0 = BLACKBOARDS
local var_0_1 = Unit.animation_set_variable

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = Unit.local_position(arg_1_0, 0)
	local var_1_1 = Vector3.normalize(arg_1_3 - var_1_0)
	local var_1_2 = Unit.world_rotation(arg_1_0, 0)
	local var_1_3 = Quaternion.forward(var_1_2)
	local var_1_4 = Quaternion.right(var_1_2)
	local var_1_5 = Vector3.dot(var_1_4, var_1_1)
	local var_1_6 = Vector3.dot(var_1_3, var_1_1)
	local var_1_7 = math.abs(var_1_5)
	local var_1_8 = math.abs(var_1_6)
	local var_1_9 = var_1_5 < 0
	local var_1_10 = (1 - var_1_8) * arg_1_5

	var_1_10 = var_1_9 and -var_1_10 or var_1_10

	local var_1_11 = math.clamp(var_1_10, -1, 1)
	local var_1_12 = arg_1_2.current_lean or 0
	local var_1_13 = math.max(math.lerp(var_1_12, var_1_11, arg_1_4 * arg_1_1), 1e-05)
	local var_1_14 = arg_1_2.animation_variable_lean

	var_0_1(arg_1_0, var_1_14, var_1_13)

	arg_1_2.current_lean = var_1_13
end

AnimationMovementTemplates.chaos_troll = {
	owner = {
		init = function (arg_2_0, arg_2_1)
			arg_2_1.blackboard = var_0_0[arg_2_0]
			arg_2_1.ai_extension = ScriptUnit.extension(arg_2_0, "ai_system")
			arg_2_1.animation_variable_lean = Unit.animation_find_variable(arg_2_0, "lean")
			arg_2_1.lean_lerp_speed = 5
			arg_2_1.lean_amount = 25
		end,
		update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0 = arg_3_3.blackboard

			if var_3_0.lean_target_position_boxed then
				local var_3_1 = var_3_0.lean_target_position_boxed:unbox()
				local var_3_2 = arg_3_3.lean_lerp_speed
				local var_3_3 = arg_3_3.lean_amount

				var_0_2(arg_3_0, arg_3_2, arg_3_3, var_3_1, var_3_2, var_3_3)

				local var_3_4 = Managers.state.network:game()
				local var_3_5 = Managers.state.unit_storage:go_id(arg_3_0)

				if var_3_4 and var_3_5 then
					GameSession.set_game_object_field(var_3_4, var_3_5, "lean_target", var_3_1)
				end
			end
		end,
		leave = function (arg_4_0, arg_4_1)
			local var_4_0 = arg_4_1.animation_variable_lean

			if var_4_0 then
				var_0_1(arg_4_0, var_4_0, 0)
			end
		end
	},
	husk = {
		init = function (arg_5_0, arg_5_1)
			arg_5_1.animation_variable_lean = Unit.animation_find_variable(arg_5_0, "lean")
			arg_5_1.old_lean_target_position_boxed = Vector3Box(Vector3.zero())
			arg_5_1.lean_lerp_speed = 5
			arg_5_1.lean_amount = 25
		end,
		update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = Managers.state.network:game()
			local var_6_1 = Managers.state.unit_storage:go_id(arg_6_0)

			if var_6_0 and var_6_1 then
				local var_6_2 = GameSession.game_object_field(var_6_0, var_6_1, "lean_target")
				local var_6_3 = arg_6_3.old_lean_target_position_boxed:unbox()

				if var_6_2 and var_6_2 ~= var_6_3 then
					local var_6_4 = arg_6_3.lean_lerp_speed
					local var_6_5 = arg_6_3.lean_amount

					var_0_2(arg_6_0, arg_6_2, arg_6_3, var_6_2, var_6_4, var_6_5)
					arg_6_3.old_lean_target_position_boxed:store(var_6_2)
				end
			end
		end,
		leave = function (arg_7_0, arg_7_1)
			local var_7_0 = arg_7_1.animation_variable_lean

			if var_7_0 then
				var_0_1(arg_7_0, var_7_0, 0)
			end
		end
	}
}

DLCUtils.require_list("animation_movement_templates_file_names")
