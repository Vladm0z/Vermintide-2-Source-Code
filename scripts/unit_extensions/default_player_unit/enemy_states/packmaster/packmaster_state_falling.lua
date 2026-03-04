-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_falling.lua

PackmasterStateFalling = class(PackmasterStateFalling, EnemyCharacterStateFalling)

PackmasterStateFalling.init = function (arg_1_0, arg_1_1)
	PackmasterStateFalling.super.init(arg_1_0, arg_1_1)

	arg_1_0._grab_ability_id = arg_1_0._career_extension:ability_id("grab")
end

PackmasterStateFalling.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0._csm

	if arg_2_0._career_extension:ability_was_triggered(arg_2_0._grab_ability_id) then
		var_2_0:change_state("packmaster_grabbing")

		return
	end

	local var_2_1 = arg_2_0._ghost_mode_extension:is_in_ghost_mode()
	local var_2_2 = arg_2_0:common_movement(var_2_1, arg_2_3, arg_2_1)
end
