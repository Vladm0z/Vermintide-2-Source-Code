-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/warpfire_thrower/warpfire_thrower_state_jumping.lua

WarpfireThrowerStateJumping = class(WarpfireThrowerStateJumping, EnemyCharacterStateJumping)

WarpfireThrowerStateJumping.init = function (arg_1_0, arg_1_1)
	WarpfireThrowerStateJumping.super.init(arg_1_0, arg_1_1)

	arg_1_0._fire_ability_id = arg_1_0._career_extension:ability_id("fire")
end

WarpfireThrowerStateJumping.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0:common_state_changes() then
		return
	end

	local var_2_0 = arg_2_0._ghost_mode_extension:is_in_ghost_mode()

	if not arg_2_0:common_movement(var_2_0, arg_2_3, arg_2_1) then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, arg_2_0._input_extension, arg_2_0._inventory_extension, arg_2_0._health_extension)
	end
end
