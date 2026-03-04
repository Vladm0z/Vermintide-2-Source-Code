-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/poison_wind_globadier/poison_wind_globadier_state_standing.lua

PoisonWindGlobadierStateStanding = class(PoisonWindGlobadierStateStanding, EnemyCharacterStateStanding)

PoisonWindGlobadierStateStanding.init = function (arg_1_0, arg_1_1)
	PoisonWindGlobadierStateStanding.super.init(arg_1_0, arg_1_1)

	arg_1_0._gas_ability_id = arg_1_0._career_extension:ability_id("gas")
end

PoisonWindGlobadierStateStanding.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0:common_state_changes() then
		return
	end

	local var_2_0 = arg_2_0._csm
	local var_2_1 = arg_2_0._career_extension

	if not arg_2_0._ghost_mode_extension:is_in_ghost_mode() and var_2_1:ability_was_triggered(arg_2_0._gas_ability_id) then
		var_2_0:change_state("globadier_throwing")

		return
	end

	arg_2_0:_update_taunt_dialogue(arg_2_5)

	local var_2_2 = arg_2_0:common_movement(arg_2_5)
end
