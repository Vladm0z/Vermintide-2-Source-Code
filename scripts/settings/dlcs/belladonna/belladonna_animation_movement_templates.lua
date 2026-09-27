-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_animation_movement_templates.lua

local AnimationMovementTemplates = AnimationMovementTemplates

AnimationMovementTemplates = AnimationMovementTemplates or {}
AnimationMovementTemplates = AnimationMovementTemplates

local BLACKBOARDS = BLACKBOARDS
local animation_set_variable = Unit.animation_set_variable

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local local_position = Unit.local_position(arg_1_0, 0)
	local normalize = Vector3.normalize(arg_1_3 - local_position)
	local world_rotation = Unit.world_rotation(arg_1_0, 0)
	local forward = Quaternion.forward(world_rotation)
	local right = Quaternion.right(world_rotation)
	local dot = Vector3.dot(right, normalize)
	local dot_2 = Vector3.dot(forward, normalize)
	local abs = math.abs(dot_2)
	local flag = dot < 0
	local num = (1 - abs) * arg_1_5

	num = not flag and -num and num

	local clamp = math.clamp(num, -1, 1)
	local current_lean = arg_1_2.current_lean

	current_lean = current_lean or 0

	local lerp = math.lerp(current_lean, clamp, arg_1_4 * arg_1_1)
	local animation_variable_lean = arg_1_2.animation_variable_lean

	animation_set_variable(arg_1_0, animation_variable_lean, lerp)

	arg_1_2.current_lean = lerp

	local flag_2

	flag_2 = not flag and "left" and "right"
	arg_1_2.current_lean_direction = flag_2
	arg_1_2.current_lean_value = lerp
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not arg_2_2.current_lean_value then
		local current_lean_value = arg_2_2.current_lean_value
		local num = 7

		arg_2_2.current_lean_value = math.lerp(current_lean_value, 0, num * arg_2_1)
		arg_2_2.lean_variable = arg_2_2.current_lean_value

		local current_lean_value_2 = arg_2_2.current_lean_value

		if not ((arg_2_2.current_lean_direction ~= "left" or not (current_lean_value_2 >= -0.1) or arg_2_2.current_lean_direction ~= "right") and not (current_lean_value_2 <= 0.1)) then
			arg_2_2.current_lean_value = nil
			arg_2_2.current_lean_direction = nil
			arg_2_2.lean_variable = arg_2_2.lean_downwards_min
		end
	else
		if not arg_2_2.lean_variable then
			arg_2_2.lean_variable = 0
		end

		local lean_downwards_max = arg_2_2.lean_downwards_max
		local lean_downwards_speed = arg_2_2.lean_downwards_speed

		arg_2_2.lean_variable = math.lerp(arg_2_2.lean_variable, lean_downwards_max, lean_downwards_speed * arg_2_1)
	end

	local animation_variable_lean = arg_2_2.animation_variable_lean

	animation_set_variable(arg_2_0, animation_variable_lean, arg_2_2.lean_variable)
end

AnimationMovementTemplates.beastmen_bestigor = {
	owner = {
		init = function (arg_3_0, arg_3_1)
			-- function 3
			arg_3_1.blackboard = BLACKBOARDS[arg_3_0]
			arg_3_1.ai_extension = ScriptUnit.extension(arg_3_0, "ai_system")
			arg_3_1.animation_variable_lean = Unit.animation_find_variable(arg_3_0, "lean")
			arg_3_1.lean_lerp_speed = 10
			arg_3_1.lean_amount = 25
		end,
		update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			local blackboard = arg_4_3.blackboard

			if not blackboard.lean_target_position_boxed then
				local unbox = blackboard.lean_target_position_boxed:unbox()
				local lean_lerp_speed = arg_4_3.lean_lerp_speed
				local lean_amount = arg_4_3.lean_amount

				fn(arg_4_0, arg_4_2, arg_4_3, unbox, lean_lerp_speed, lean_amount)

				local game = Managers.state.network:game()
				local go_id = Managers.state.unit_storage:go_id(arg_4_0)

				if not game and not go_id then
					local position = NetworkConstants.position
					local min = position.min
					local max = position.max

					GameSession.set_game_object_field(game, go_id, "lean_target", Vector3.clamp(unbox, min, max))
				end
			end
		end,
		leave = function (arg_5_0, arg_5_1)
			-- function 5
			local animation_variable_lean = arg_5_1.animation_variable_lean

			if not animation_variable_lean then
				animation_set_variable(arg_5_0, animation_variable_lean, 0)
			end
		end
	},
	husk = {
		init = function (arg_6_0, arg_6_1)
			-- function 6
			arg_6_1.animation_variable_lean = Unit.animation_find_variable(arg_6_0, "lean")
			arg_6_1.old_lean_target_position_boxed = Vector3Box(Vector3.zero())
			arg_6_1.lean_lerp_speed = 10
			arg_6_1.lean_amount = 25
		end,
		update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			-- function 7
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_7_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "lean_target")
				local unbox = arg_7_3.old_lean_target_position_boxed:unbox()

				if not (not game_object_field and game_object_field == unbox) then
					local lean_lerp_speed = arg_7_3.lean_lerp_speed
					local lean_amount = arg_7_3.lean_amount

					fn(arg_7_0, arg_7_2, arg_7_3, game_object_field, lean_lerp_speed, lean_amount)
					arg_7_3.old_lean_target_position_boxed:store(game_object_field)
				end
			end
		end,
		leave = function (arg_8_0, arg_8_1)
			-- function 8
			local animation_variable_lean = arg_8_1.animation_variable_lean

			if not animation_variable_lean then
				animation_set_variable(arg_8_0, animation_variable_lean, 0)
			end
		end
	}
}
AnimationMovementTemplates.beastmen_minotaur = {
	owner = {
		init = function (arg_9_0, arg_9_1)
			-- function 9
			arg_9_1.blackboard = BLACKBOARDS[arg_9_0]
			arg_9_1.ai_extension = ScriptUnit.extension(arg_9_0, "ai_system")
			arg_9_1.animation_variable_lean = Unit.animation_find_variable(arg_9_0, "lean")
			arg_9_1.lean_lerp_speed = 10
			arg_9_1.lean_amount = 25
			arg_9_1.lean_downwards_speed = 2.25
			arg_9_1.lean_downwards_min = 2
			arg_9_1.lean_downwards_max = 3
			arg_9_1.sent_downwards_lean = false
		end,
		update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			local blackboard = arg_10_3.blackboard

			if not blackboard.lean_downwards then
				local game = Managers.state.network:game()
				local go_id = Managers.state.unit_storage:go_id(arg_10_0)

				fn_2(arg_10_0, arg_10_2, arg_10_3)

				if not (not game and not go_id and arg_10_3.sent_downwards_lean) then
					GameSession.set_game_object_field(game, go_id, "lean_downwards", true)

					arg_10_3.sent_downwards_lean = true
				end
			elseif not blackboard.lean_target_position_boxed then
				local unbox = blackboard.lean_target_position_boxed:unbox()
				local lean_lerp_speed = arg_10_3.lean_lerp_speed
				local lean_amount = arg_10_3.lean_amount

				fn(arg_10_0, arg_10_2, arg_10_3, unbox, lean_lerp_speed, lean_amount)

				local game_2 = Managers.state.network:game()
				local go_id_2 = Managers.state.unit_storage:go_id(arg_10_0)

				if not game_2 and not go_id_2 then
					GameSession.set_game_object_field(game_2, go_id_2, "lean_target", unbox)

					if not arg_10_3.sent_downwards_lean then
						GameSession.set_game_object_field(game_2, go_id_2, "lean_downwards", false)

						arg_10_3.sent_downwards_lean = nil
					end
				end

				blackboard.current_lean_direction = arg_10_3.current_lean_direction
				blackboard.current_lean_value = arg_10_3.current_lean_value
			end

			if blackboard.lean_downwards or not arg_10_3.sent_downwards_lean then
				local game_3 = Managers.state.network:game()
				local go_id_3 = Managers.state.unit_storage:go_id(arg_10_0)

				if not game_3 and not go_id_3 then
					GameSession.set_game_object_field(game_3, go_id_3, "lean_downwards", false)

					arg_10_3.sent_downwards_lean = nil
				end
			end
		end,
		leave = function (arg_11_0, arg_11_1)
			-- function 11
			local animation_variable_lean = arg_11_1.animation_variable_lean

			if not animation_variable_lean then
				animation_set_variable(arg_11_0, animation_variable_lean, 0)
			end

			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_11_0)

			arg_11_1.current_lean_value = nil
			arg_11_1.lean_variable = nil

			if not game and not go_id and not arg_11_1.sent_downwards_lean then
				GameSession.set_game_object_field(game, go_id, "lean_downwards", false)

				arg_11_1.sent_downwards_lean = nil
			end
		end
	},
	husk = {
		init = function (arg_12_0, arg_12_1)
			-- function 12
			arg_12_1.animation_variable_lean = Unit.animation_find_variable(arg_12_0, "lean")
			arg_12_1.old_lean_target_position_boxed = Vector3Box(Vector3.zero())
			arg_12_1.lean_lerp_speed = 10
			arg_12_1.lean_amount = 25
			arg_12_1.lean_downwards_speed = 2.25
			arg_12_1.lean_downwards_min = 2
			arg_12_1.lean_downwards_max = 3
		end,
		update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			-- function 13
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_13_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "lean_downwards")
				local game_object_field_2 = GameSession.game_object_field(game, go_id, "lean_target")

				if not game_object_field then
					fn_2(arg_13_0, arg_13_2, arg_13_3)
				elseif not (not game_object_field_2 and game_object_field_2 == Vector3.zero()) then
					local lean_lerp_speed = arg_13_3.lean_lerp_speed
					local lean_amount = arg_13_3.lean_amount

					fn(arg_13_0, arg_13_2, arg_13_3, game_object_field_2, lean_lerp_speed, lean_amount)
					arg_13_3.old_lean_target_position_boxed:store(game_object_field_2)
				end
			end
		end,
		leave = function (arg_14_0, arg_14_1)
			-- function 14
			local animation_variable_lean = arg_14_1.animation_variable_lean

			if not animation_variable_lean then
				animation_set_variable(arg_14_0, animation_variable_lean, 0)
			end
		end
	}
}
