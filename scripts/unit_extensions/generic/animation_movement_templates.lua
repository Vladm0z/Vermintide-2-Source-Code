-- chunkname: @scripts/unit_extensions/generic/animation_movement_templates.lua

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
	local abs = math.abs(dot)
	local abs_2 = math.abs(dot_2)
	local flag = dot < 0
	local num = (1 - abs_2) * arg_1_5

	num = not flag and -num and num

	local clamp = math.clamp(num, -1, 1)
	local current_lean = arg_1_2.current_lean

	current_lean = current_lean or 0

	local max = math.max(math.lerp(current_lean, clamp, arg_1_4 * arg_1_1), 1e-05)
	local animation_variable_lean = arg_1_2.animation_variable_lean

	animation_set_variable(arg_1_0, animation_variable_lean, max)

	arg_1_2.current_lean = max
end

AnimationMovementTemplates.chaos_troll = {
	owner = {
		init = function (arg_2_0, arg_2_1)
			-- function 2
			arg_2_1.blackboard = BLACKBOARDS[arg_2_0]
			arg_2_1.ai_extension = ScriptUnit.extension(arg_2_0, "ai_system")
			arg_2_1.animation_variable_lean = Unit.animation_find_variable(arg_2_0, "lean")
			arg_2_1.lean_lerp_speed = 5
			arg_2_1.lean_amount = 25
		end,
		update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			local blackboard = arg_3_3.blackboard

			if not blackboard.lean_target_position_boxed then
				local unbox = blackboard.lean_target_position_boxed:unbox()
				local lean_lerp_speed = arg_3_3.lean_lerp_speed
				local lean_amount = arg_3_3.lean_amount

				fn(arg_3_0, arg_3_2, arg_3_3, unbox, lean_lerp_speed, lean_amount)

				local game = Managers.state.network:game()
				local go_id = Managers.state.unit_storage:go_id(arg_3_0)

				if not game and not go_id then
					GameSession.set_game_object_field(game, go_id, "lean_target", unbox)
				end
			end
		end,
		leave = function (arg_4_0, arg_4_1)
			-- function 4
			local animation_variable_lean = arg_4_1.animation_variable_lean

			if not animation_variable_lean then
				animation_set_variable(arg_4_0, animation_variable_lean, 0)
			end
		end
	},
	husk = {
		init = function (arg_5_0, arg_5_1)
			-- function 5
			arg_5_1.animation_variable_lean = Unit.animation_find_variable(arg_5_0, "lean")
			arg_5_1.old_lean_target_position_boxed = Vector3Box(Vector3.zero())
			arg_5_1.lean_lerp_speed = 5
			arg_5_1.lean_amount = 25
		end,
		update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_6_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "lean_target")
				local unbox = arg_6_3.old_lean_target_position_boxed:unbox()

				if not (not game_object_field and game_object_field == unbox) then
					local lean_lerp_speed = arg_6_3.lean_lerp_speed
					local lean_amount = arg_6_3.lean_amount

					fn(arg_6_0, arg_6_2, arg_6_3, game_object_field, lean_lerp_speed, lean_amount)
					arg_6_3.old_lean_target_position_boxed:store(game_object_field)
				end
			end
		end,
		leave = function (arg_7_0, arg_7_1)
			-- function 7
			local animation_variable_lean = arg_7_1.animation_variable_lean

			if not animation_variable_lean then
				animation_set_variable(arg_7_0, animation_variable_lean, 0)
			end
		end
	}
}

DLCUtils.require_list("animation_movement_templates_file_names")
