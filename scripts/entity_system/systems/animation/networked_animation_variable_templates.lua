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
			-- function 1
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(arg_1_0)
			local game_object_field = GameSession.game_object_field(network:game(), unit_game_object_id, "target_unit_id")

			arg_1_1.target_unit = network:game_object_or_level_unit(game_object_field)
			arg_1_1.previous_move_animation_value = nil
			arg_1_1.move_animation_variable = Unit.animation_find_variable(arg_1_0, arg_1_1.variable_name)
		end,
		update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			-- function 2
			local target_unit = arg_2_1.target_unit

			if not target_unit then
				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(arg_2_0)
				local game_object_field = GameSession.game_object_field(network:game(), unit_game_object_id, "target_unit_id")

				target_unit = network:game_object_or_level_unit(game_object_field, false)
				arg_2_1.target_unit = target_unit
			end

			if not ALIVE[target_unit] then
				return
			end

			local variable_data = arg_2_1.variable_data
			local animation_move_speed_config = variable_data.animation_move_speed_config

			if not animation_move_speed_config then
				local calculate_animation_movespeed = AiUtils.calculate_animation_movespeed(animation_move_speed_config, arg_2_0, target_unit, variable_data.estimated_attack_time)
				local move_speed_variable_lerp_speed = variable_data.move_speed_variable_lerp_speed
				local min = math.min(arg_2_2 * move_speed_variable_lerp_speed, 1)
				local lerp_clamped = math.lerp_clamped
				local previous_move_animation_value = arg_2_1.previous_move_animation_value

				previous_move_animation_value = previous_move_animation_value or 0

				local var_2_11 = lerp_clamped(previous_move_animation_value, calculate_animation_movespeed, min)

				if arg_2_1.previous_move_animation_value ~= var_2_11 then
					arg_2_1.previous_move_animation_value = var_2_11

					local move_animation_variable = arg_2_1.move_animation_variable

					if not move_animation_variable then
						Unit.animation_set_variable(arg_2_0, move_animation_variable, var_2_11)
					end
				end
			end
		end
	}
}
NetworkedAnimationVariableTemplatesLookup = {}

local NetworkedAnimationVariableTemplatesLookup = NetworkedAnimationVariableTemplatesLookup

for k, v in pairs(NetworkedAnimationVariableTemplates) do
	for i, v_2 in ipairs(v.anims) do
		local var_0_1 = NetworkedAnimationVariableTemplatesLookup[v_2]

		var_0_1 = var_0_1 or {}
		var_0_1[#var_0_1 + 1] = k
		NetworkedAnimationVariableTemplatesLookup[v_2] = var_0_1
	end
end
