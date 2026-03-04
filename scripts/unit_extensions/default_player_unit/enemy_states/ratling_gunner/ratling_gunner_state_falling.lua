-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/ratling_gunner/ratling_gunner_state_falling.lua

RatlingGunnerStateFalling = class(RatlingGunnerStateFalling, EnemyCharacterStateFalling)

RatlingGunnerStateFalling.init = function (arg_1_0, arg_1_1)
	RatlingGunnerStateFalling.super.init(arg_1_0, arg_1_1)

	arg_1_0._fire_ability_id = arg_1_0._career_extension:ability_id("fire")
	arg_1_0._reload_ability_id = arg_1_0._career_extension:ability_id("reload")
end

RatlingGunnerStateFalling.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0._csm
	local var_2_1 = arg_2_0._career_extension

	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, arg_2_0._input_extension, arg_2_0._inventory_extension, arg_2_0._health_extension)

	local var_2_2 = arg_2_0._ghost_mode_extension:is_in_ghost_mode()
	local var_2_3 = arg_2_0:common_movement(var_2_2, arg_2_3, arg_2_1)
end
