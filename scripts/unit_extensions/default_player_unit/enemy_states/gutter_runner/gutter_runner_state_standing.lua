-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_standing.lua

GutterRunnerStateStanding = class(GutterRunnerStateStanding, EnemyCharacterStateStanding)

GutterRunnerStateStanding.init = function (arg_1_0, arg_1_1)
	GutterRunnerStateStanding.super.init(arg_1_0, arg_1_1)

	arg_1_0._pounce_ability_id = arg_1_0._career_extension:ability_id("pounce")
	arg_1_0._foff_ability_id = arg_1_0._career_extension:ability_id("foff")
end

GutterRunnerStateStanding.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0:common_state_changes() then
		return
	end

	local var_2_0 = arg_2_0._csm
	local var_2_1 = arg_2_0._career_extension

	if var_2_1:ability_was_triggered(arg_2_0._pounce_ability_id) then
		var_2_0:change_state("gutter_runner_prowling")

		return
	end

	if var_2_1:ability_was_triggered(arg_2_0._foff_ability_id) then
		var_2_0:change_state("gutter_runner_foff")

		return
	end

	if not arg_2_0._status_extension:is_invisible() then
		arg_2_0:_update_taunt_dialogue(arg_2_5)
	end

	local var_2_2 = arg_2_0:common_movement(arg_2_5)
end
