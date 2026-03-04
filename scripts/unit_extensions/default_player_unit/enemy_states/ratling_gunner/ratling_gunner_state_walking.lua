-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/ratling_gunner/ratling_gunner_state_walking.lua

RatlingGunnerStateWalking = class(RatlingGunnerStateWalking, EnemyCharacterStateWalking)

RatlingGunnerStateWalking.init = function (arg_1_0, arg_1_1)
	RatlingGunnerStateWalking.super.init(arg_1_0, arg_1_1)

	arg_1_0._fire_ability_id = arg_1_0._career_extension:ability_id("fire")
	arg_1_0._reload_ability_id = arg_1_0._career_extension:ability_id("reload")
end

RatlingGunnerStateWalking.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	RatlingGunnerStateWalking.super.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)

	arg_2_0._left_wpn_particle_node_name = "g_ratlinggun"
	arg_2_0._left_wpn_particle_name = "fx/wpnfx_gunner_enemy_in_range_1p"
end

RatlingGunnerStateWalking.debug_display_ammo = function (arg_3_0)
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
