-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/rat_ogre/rat_ogre_state_falling.lua

RatOgreStateFalling = class(RatOgreStateFalling, EnemyCharacterStateFalling)

RatOgreStateFalling.init = function (arg_1_0, arg_1_1)
	RatOgreStateFalling.super.init(arg_1_0, arg_1_1)
end

RatOgreStateFalling.on_exit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	RatOgreStateFalling.super.on_exit(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
end

RatOgreStateFalling.on_enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	RatOgreStateFalling.super.on_enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
end

RatOgreStateFalling.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._ghost_mode_extension:is_in_ghost_mode()

	if not arg_4_0:common_movement(var_4_0, arg_4_3, arg_4_1) then
		CharacterStateHelper.update_weapon_actions(arg_4_5, arg_4_1, arg_4_0._input_extension, arg_4_0._inventory_extension, arg_4_0._health_extension)
	end
end
