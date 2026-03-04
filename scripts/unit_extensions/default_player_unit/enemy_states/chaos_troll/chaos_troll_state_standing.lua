-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/chaos_troll/chaos_troll_state_standing.lua

ChaosTrollStateStanding = class(ChaosTrollStateStanding, EnemyCharacterStateStanding)

ChaosTrollStateStanding.init = function (arg_1_0, arg_1_1)
	ChaosTrollStateStanding.super.init(arg_1_0, arg_1_1)

	arg_1_0._vomit_ability_id = arg_1_0._career_extension:ability_id("vomit")
end

ChaosTrollStateStanding.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	ChaosTrollStateStanding.super.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
end

ChaosTrollStateStanding.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0:common_state_changes() then
		return
	end

	local var_3_0 = arg_3_0._csm

	if arg_3_0._career_extension:ability_was_triggered(arg_3_0._vomit_ability_id) then
		var_3_0:change_state("troll_vomiting")

		return
	end

	local var_3_1 = arg_3_0._input_extension
	local var_3_2 = arg_3_0._status_extension
	local var_3_3 = arg_3_0._first_person_extension
	local var_3_4 = var_3_2:is_crouching()
	local var_3_5 = var_3_1.toggle_crouch

	CharacterStateHelper.check_crouch(arg_3_1, var_3_1, var_3_2, var_3_5, var_3_3, arg_3_5)
	arg_3_0:_update_taunt_dialogue(arg_3_5)

	if not arg_3_0:common_movement(arg_3_5) then
		CharacterStateHelper.update_weapon_actions(arg_3_5, arg_3_1, arg_3_0._input_extension, arg_3_0._inventory_extension, arg_3_0._health_extension)
	end
end
