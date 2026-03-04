-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/rat_ogre/rat_ogre_state_walking.lua

RatOgreStateWalking = class(RatOgreStateWalking, EnemyCharacterStateWalking)

function RatOgreStateWalking.init(arg_1_0, arg_1_1)
	RatOgreStateWalking.super.init(arg_1_0, arg_1_1)

	arg_1_0._ogre_jump_ability_id = arg_1_0._career_extension:ability_id("ogre_jump")
end

function RatOgreStateWalking.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	RatOgreStateWalking.super.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
end

function RatOgreStateWalking.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0:common_state_changes() then
		return
	end

	local var_3_0 = arg_3_0._csm
	local var_3_1 = arg_3_0._status_extension
	local var_3_2 = arg_3_0._career_extension
	local var_3_3 = arg_3_0._ghost_mode_extension:is_in_ghost_mode()

	arg_3_0:_update_taunt_dialogue(arg_3_5)

	if not arg_3_0:common_movement(var_3_3, arg_3_3) then
		CharacterStateHelper.update_weapon_actions(arg_3_5, arg_3_1, arg_3_0._input_extension, arg_3_0._inventory_extension, arg_3_0._health_extension)
	end
end
