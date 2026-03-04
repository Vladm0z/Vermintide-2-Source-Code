-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/chaos_troll/chaos_troll_state_walking.lua

ChaosTrollStateWalking = class(ChaosTrollStateWalking, EnemyCharacterStateWalking)

ChaosTrollStateWalking.init = function (arg_1_0, arg_1_1)
	ChaosTrollStateWalking.super.init(arg_1_0, arg_1_1)

	arg_1_0._vomit_ability_id = arg_1_0._career_extension:ability_id("vomit")
end

ChaosTrollStateWalking.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0:common_state_changes() then
		return
	end

	local var_2_0 = arg_2_0._csm

	if arg_2_0._career_extension:ability_was_triggered(arg_2_0._vomit_ability_id) then
		var_2_0:change_state("troll_vomiting")

		return
	end

	arg_2_0:_update_taunt_dialogue(arg_2_5)

	local var_2_1 = arg_2_0._ghost_mode_extension:is_in_ghost_mode()
	local var_2_2 = arg_2_0._input_extension
	local var_2_3 = arg_2_0._status_extension
	local var_2_4 = arg_2_0._first_person_extension
	local var_2_5 = var_2_3:is_crouching()
	local var_2_6 = var_2_2.toggle_crouch

	CharacterStateHelper.check_crouch(arg_2_1, var_2_2, var_2_3, var_2_6, var_2_4, arg_2_5)

	if not arg_2_0:common_movement(var_2_1, arg_2_3) then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, arg_2_0._input_extension, arg_2_0._inventory_extension, arg_2_0._health_extension)
	end
end
