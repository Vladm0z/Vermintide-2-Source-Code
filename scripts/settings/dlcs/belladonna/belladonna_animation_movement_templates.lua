-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_animation_movement_templates.lua

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
	local var_1_7 = math.abs(var_1_6)
	local var_1_8 = var_1_5 < 0
	local var_1_9 = (1 - var_1_7) * arg_1_5

	var_1_9 = var_1_8 and -var_1_9 or var_1_9

	local var_1_10 = math.clamp(var_1_9, -1, 1)
	local var_1_11 = arg_1_2.current_lean or 0
	local var_1_12 = math.lerp(var_1_11, var_1_10, arg_1_4 * arg_1_1)
	local var_1_13 = arg_1_2.animation_variable_lean

	var_0_1(arg_1_0, var_1_13, var_1_12)

	arg_1_2.current_lean = var_1_12
	arg_1_2.current_lean_direction = var_1_8 and "left" or "right"
	arg_1_2.current_lean_value = var_1_12
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2.current_lean_value then
		local var_2_0 = arg_2_2.current_lean_value
		local var_2_1 = 7

		arg_2_2.current_lean_value = math.lerp(var_2_0, 0, var_2_1 * arg_2_1)
		arg_2_2.lean_variable = arg_2_2.current_lean_value

		local var_2_2 = arg_2_2.current_lean_value

		if arg_2_2.current_lean_direction == "left" and var_2_2 >= -0.1 or arg_2_2.current_lean_direction == "right" and var_2_2 <= 0.1 then
			arg_2_2.current_lean_value = nil
			arg_2_2.current_lean_direction = nil
			arg_2_2.lean_variable = arg_2_2.lean_downwards_min
		end
	else
		if not arg_2_2.lean_variable then
			arg_2_2.lean_variable = 0
		end

		local var_2_3 = arg_2_2.lean_downwards_max
		local var_2_4 = arg_2_2.lean_downwards_speed

		arg_2_2.lean_variable = math.lerp(arg_2_2.lean_variable, var_2_3, var_2_4 * arg_2_1)
	end

	local var_2_5 = arg_2_2.animation_variable_lean

	var_0_1(arg_2_0, var_2_5, arg_2_2.lean_variable)
end

AnimationMovementTemplates.beastmen_bestigor = {
	owner = {
		init = function(arg_3_0, arg_3_1)
			arg_3_1.blackboard = var_0_0[arg_3_0]
			arg_3_1.ai_extension = ScriptUnit.extension(arg_3_0, "ai_system")
			arg_3_1.animation_variable_lean = Unit.animation_find_variable(arg_3_0, "lean")
			arg_3_1.lean_lerp_speed = 10
			arg_3_1.lean_amount = 25
		end,
		update = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			local var_4_0 = arg_4_3.blackboard

			if var_4_0.lean_target_position_boxed then
				local var_4_1 = var_4_0.lean_target_position_boxed:unbox()
				local var_4_2 = arg_4_3.lean_lerp_speed
				local var_4_3 = arg_4_3.lean_amount

				var_0_2(arg_4_0, arg_4_2, arg_4_3, var_4_1, var_4_2, var_4_3)

				local var_4_4 = Managers.state.network:game()
				local var_4_5 = Managers.state.unit_storage:go_id(arg_4_0)

				if var_4_4 and var_4_5 then
					local var_4_6 = NetworkConstants.position
					local var_4_7 = var_4_6.min
					local var_4_8 = var_4_6.max

					GameSession.set_game_object_field(var_4_4, var_4_5, "lean_target", Vector3.clamp(var_4_1, var_4_7, var_4_8))
				end
			end
		end,
		leave = function(arg_5_0, arg_5_1)
			local var_5_0 = arg_5_1.animation_variable_lean

			if var_5_0 then
				var_0_1(arg_5_0, var_5_0, 0)
			end
		end
	},
	husk = {
		init = function(arg_6_0, arg_6_1)
			arg_6_1.animation_variable_lean = Unit.animation_find_variable(arg_6_0, "lean")
			arg_6_1.old_lean_target_position_boxed = Vector3Box(Vector3.zero())
			arg_6_1.lean_lerp_speed = 10
			arg_6_1.lean_amount = 25
		end,
		update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			local var_7_0 = Managers.state.network:game()
			local var_7_1 = Managers.state.unit_storage:go_id(arg_7_0)

			if var_7_0 and var_7_1 then
				local var_7_2 = GameSession.game_object_field(var_7_0, var_7_1, "lean_target")
				local var_7_3 = arg_7_3.old_lean_target_position_boxed:unbox()

				if var_7_2 and var_7_2 ~= var_7_3 then
					local var_7_4 = arg_7_3.lean_lerp_speed
					local var_7_5 = arg_7_3.lean_amount

					var_0_2(arg_7_0, arg_7_2, arg_7_3, var_7_2, var_7_4, var_7_5)
					arg_7_3.old_lean_target_position_boxed:store(var_7_2)
				end
			end
		end,
		leave = function(arg_8_0, arg_8_1)
			local var_8_0 = arg_8_1.animation_variable_lean

			if var_8_0 then
				var_0_1(arg_8_0, var_8_0, 0)
			end
		end
	}
}
AnimationMovementTemplates.beastmen_minotaur = {
	owner = {
		init = function(arg_9_0, arg_9_1)
			arg_9_1.blackboard = var_0_0[arg_9_0]
			arg_9_1.ai_extension = ScriptUnit.extension(arg_9_0, "ai_system")
			arg_9_1.animation_variable_lean = Unit.animation_find_variable(arg_9_0, "lean")
			arg_9_1.lean_lerp_speed = 10
			arg_9_1.lean_amount = 25
			arg_9_1.lean_downwards_speed = 2.25
			arg_9_1.lean_downwards_min = 2
			arg_9_1.lean_downwards_max = 3
			arg_9_1.sent_downwards_lean = false
		end,
		update = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			local var_10_0 = arg_10_3.blackboard

			if var_10_0.lean_downwards then
				local var_10_1 = Managers.state.network:game()
				local var_10_2 = Managers.state.unit_storage:go_id(arg_10_0)

				var_0_3(arg_10_0, arg_10_2, arg_10_3)

				if var_10_1 and var_10_2 and not arg_10_3.sent_downwards_lean then
					GameSession.set_game_object_field(var_10_1, var_10_2, "lean_downwards", true)

					arg_10_3.sent_downwards_lean = true
				end
			elseif var_10_0.lean_target_position_boxed then
				local var_10_3 = var_10_0.lean_target_position_boxed:unbox()
				local var_10_4 = arg_10_3.lean_lerp_speed
				local var_10_5 = arg_10_3.lean_amount

				var_0_2(arg_10_0, arg_10_2, arg_10_3, var_10_3, var_10_4, var_10_5)

				local var_10_6 = Managers.state.network:game()
				local var_10_7 = Managers.state.unit_storage:go_id(arg_10_0)

				if var_10_6 and var_10_7 then
					GameSession.set_game_object_field(var_10_6, var_10_7, "lean_target", var_10_3)

					if arg_10_3.sent_downwards_lean then
						GameSession.set_game_object_field(var_10_6, var_10_7, "lean_downwards", false)

						arg_10_3.sent_downwards_lean = nil
					end
				end

				var_10_0.current_lean_direction = arg_10_3.current_lean_direction
				var_10_0.current_lean_value = arg_10_3.current_lean_value
			end

			if not var_10_0.lean_downwards and arg_10_3.sent_downwards_lean then
				local var_10_8 = Managers.state.network:game()
				local var_10_9 = Managers.state.unit_storage:go_id(arg_10_0)

				if var_10_8 and var_10_9 then
					GameSession.set_game_object_field(var_10_8, var_10_9, "lean_downwards", false)

					arg_10_3.sent_downwards_lean = nil
				end
			end
		end,
		leave = function(arg_11_0, arg_11_1)
			local var_11_0 = arg_11_1.animation_variable_lean

			if var_11_0 then
				var_0_1(arg_11_0, var_11_0, 0)
			end

			local var_11_1 = Managers.state.network:game()
			local var_11_2 = Managers.state.unit_storage:go_id(arg_11_0)

			arg_11_1.current_lean_value = nil
			arg_11_1.lean_variable = nil

			if var_11_1 and var_11_2 and arg_11_1.sent_downwards_lean then
				GameSession.set_game_object_field(var_11_1, var_11_2, "lean_downwards", false)

				arg_11_1.sent_downwards_lean = nil
			end
		end
	},
	husk = {
		init = function(arg_12_0, arg_12_1)
			arg_12_1.animation_variable_lean = Unit.animation_find_variable(arg_12_0, "lean")
			arg_12_1.old_lean_target_position_boxed = Vector3Box(Vector3.zero())
			arg_12_1.lean_lerp_speed = 10
			arg_12_1.lean_amount = 25
			arg_12_1.lean_downwards_speed = 2.25
			arg_12_1.lean_downwards_min = 2
			arg_12_1.lean_downwards_max = 3
		end,
		update = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			local var_13_0 = Managers.state.network:game()
			local var_13_1 = Managers.state.unit_storage:go_id(arg_13_0)

			if var_13_0 and var_13_1 then
				local var_13_2 = GameSession.game_object_field(var_13_0, var_13_1, "lean_downwards")
				local var_13_3 = GameSession.game_object_field(var_13_0, var_13_1, "lean_target")

				if var_13_2 then
					var_0_3(arg_13_0, arg_13_2, arg_13_3)
				elseif var_13_3 and var_13_3 ~= Vector3.zero() then
					local var_13_4 = arg_13_3.lean_lerp_speed
					local var_13_5 = arg_13_3.lean_amount

					var_0_2(arg_13_0, arg_13_2, arg_13_3, var_13_3, var_13_4, var_13_5)
					arg_13_3.old_lean_target_position_boxed:store(var_13_3)
				end
			end
		end,
		leave = function(arg_14_0, arg_14_1)
			local var_14_0 = arg_14_1.animation_variable_lean

			if var_14_0 then
				var_0_1(arg_14_0, var_14_0, 0)
			end
		end
	}
}
