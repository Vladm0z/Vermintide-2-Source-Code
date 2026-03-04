-- chunkname: @scripts/entity_system/systems/animation/networked_animation_variable_templates.lua

NetworkedAnimationVariableTemplates = {
	moving_attack_fwd_speed = {
		anims = {
			"attack_run",
			"attack_run_2",
			"attack_run_3",
			"attack_move",
			"attack_move_2",
			"attack_move_3",
			"attack_move_4",
			"attack_cleave_moving_01"
		},
		init = function (arg_1_0, arg_1_1)
			local var_1_0 = Managers.state.network
			local var_1_1 = var_1_0:unit_game_object_id(arg_1_0)
			local var_1_2 = GameSession.game_object_field(var_1_0:game(), var_1_1, "target_unit_id")

			arg_1_1.target_unit = var_1_0:game_object_or_level_unit(var_1_2)
			arg_1_1.previous_move_animation_value = nil
			arg_1_1.move_animation_variable = Unit.animation_find_variable(arg_1_0, arg_1_1.variable_name)
		end,
		update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			local var_2_0 = arg_2_1.target_unit

			if not var_2_0 then
				local var_2_1 = Managers.state.network
				local var_2_2 = var_2_1:unit_game_object_id(arg_2_0)
				local var_2_3 = GameSession.game_object_field(var_2_1:game(), var_2_2, "target_unit_id")

				var_2_0 = var_2_1:game_object_or_level_unit(var_2_3, false)
				arg_2_1.target_unit = var_2_0
			end

			if not ALIVE[var_2_0] then
				return
			end

			local var_2_4 = arg_2_1.variable_data
			local var_2_5 = var_2_4.animation_move_speed_config

			if var_2_5 then
				local var_2_6 = AiUtils.calculate_animation_movespeed(var_2_5, arg_2_0, var_2_0, var_2_4.estimated_attack_time)
				local var_2_7 = var_2_4.move_speed_variable_lerp_speed
				local var_2_8 = math.min(arg_2_2 * var_2_7, 1)
				local var_2_9 = math.lerp_clamped(arg_2_1.previous_move_animation_value or 0, var_2_6, var_2_8)

				if arg_2_1.previous_move_animation_value ~= var_2_9 then
					arg_2_1.previous_move_animation_value = var_2_9

					local var_2_10 = arg_2_1.move_animation_variable

					if var_2_10 then
						Unit.animation_set_variable(arg_2_0, var_2_10, var_2_9)
					end
				end
			end
		end
	}
}
NetworkedAnimationVariableTemplatesLookup = {}

local var_0_0 = NetworkedAnimationVariableTemplatesLookup

for iter_0_0, iter_0_1 in pairs(NetworkedAnimationVariableTemplates) do
	for iter_0_2, iter_0_3 in ipairs(iter_0_1.anims) do
		local var_0_1 = var_0_0[iter_0_3] or {}

		var_0_1[#var_0_1 + 1] = iter_0_0
		var_0_0[iter_0_3] = var_0_1
	end
end
