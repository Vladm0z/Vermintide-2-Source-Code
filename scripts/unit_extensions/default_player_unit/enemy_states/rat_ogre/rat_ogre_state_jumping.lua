-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/rat_ogre/rat_ogre_state_jumping.lua

RatOgreStateJumping = class(RatOgreStateJumping, EnemyCharacterStateJumping)

RatOgreStateJumping.init = function (arg_1_0, arg_1_1)
	RatOgreStateJumping.super.init(arg_1_0, arg_1_1)
end

RatOgreStateJumping.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0:common_state_changes() then
		return
	end

	local var_2_0 = arg_2_0._ghost_mode_extension:is_in_ghost_mode()

	if not arg_2_0:common_movement(var_2_0, arg_2_3, arg_2_1) then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, arg_2_0._input_extension, arg_2_0._inventory_extension, arg_2_0._health_extension)
	end
end
