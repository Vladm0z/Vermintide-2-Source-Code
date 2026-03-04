-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/ratling_gunner/ratling_gunner_state_jumping.lua

RatlingGunnerStateJumping = class(RatlingGunnerStateJumping, EnemyCharacterStateJumping)

RatlingGunnerStateJumping.init = function (arg_1_0, arg_1_1)
	RatlingGunnerStateJumping.super.init(arg_1_0, arg_1_1)

	arg_1_0._fire_ability_id = arg_1_0._career_extension:ability_id("fire")
	arg_1_0._reload_ability_id = arg_1_0._career_extension:ability_id("reload")
end

RatlingGunnerStateJumping.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0:common_state_changes()

	if var_2_0 then
		return
	end

	local var_2_1 = arg_2_0._csm
	local var_2_2 = arg_2_0._career_extension

	if not var_2_0 then
		CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, arg_2_0._input_extension, arg_2_0._inventory_extension, arg_2_0._health_extension)
	end

	local var_2_3 = arg_2_0._ghost_mode_extension:is_in_ghost_mode()
	local var_2_4 = arg_2_0:common_movement(var_2_3, arg_2_3, arg_2_1)
end

RatlingGunnerStateJumping.debug_display_ammo = function (arg_3_0)
	local var_3_0 = arg_3_0._unit
	local var_3_1 = (BLACKBOARDS[var_3_0].attack_pattern_data or {}).current_ammo or arg_3_0._breed.max_ammo
	local var_3_2 = RESOLUTION_LOOKUP.res_w
	local var_3_3 = RESOLUTION_LOOKUP.res_h * 0.85
	local var_3_4 = var_3_2 * 0.87
	local var_3_5 = Color(100, 255, 0)
	local var_3_6 = Vector3(var_3_4, var_3_3, 10)
	local var_3_7 = 40
	local var_3_8 = string.format("Ammo: %2d", var_3_1)

	Debug.draw_text(var_3_8, var_3_6, var_3_7, var_3_5)
end
