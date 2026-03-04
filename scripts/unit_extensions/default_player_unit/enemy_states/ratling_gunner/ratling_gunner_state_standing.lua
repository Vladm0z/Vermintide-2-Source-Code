-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/ratling_gunner/ratling_gunner_state_standing.lua

RatlingGunnerStateStanding = class(RatlingGunnerStateStanding, EnemyCharacterStateStanding)

function RatlingGunnerStateStanding.init(arg_1_0, arg_1_1)
	RatlingGunnerStateStanding.super.init(arg_1_0, arg_1_1)

	arg_1_0._fire_ability_id = arg_1_0._career_extension:ability_id("fire")
	arg_1_0._reload_ability_id = arg_1_0._career_extension:ability_id("reload")
end

function RatlingGunnerStateStanding.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	RatlingGunnerStateStanding.super.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)

	arg_2_0._left_wpn_particle_node_name = "g_ratlinggun"
	arg_2_0._left_wpn_particle_name = "fx/wpnfx_gunner_enemy_in_range_1p"
end

function RatlingGunnerStateStanding.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0:common_state_changes()

	if var_3_0 then
		return
	end

	local var_3_1 = arg_3_0._csm
	local var_3_2 = arg_3_0._career_extension

	if not var_3_0 then
		CharacterStateHelper.update_weapon_actions(arg_3_5, arg_3_1, arg_3_0._input_extension, arg_3_0._inventory_extension, arg_3_0._health_extension)
	end

	arg_3_0:_update_taunt_dialogue(arg_3_5)

	local var_3_3 = arg_3_0:common_movement(arg_3_5)
end

function RatlingGunnerStateStanding.debug_display_ammo(arg_4_0)
	local var_4_0 = arg_4_0._unit
	local var_4_1 = (BLACKBOARDS[var_4_0].attack_pattern_data or {}).current_ammo or arg_4_0._breed.max_ammo
	local var_4_2 = RESOLUTION_LOOKUP.res_w
	local var_4_3 = RESOLUTION_LOOKUP.res_h * 0.85
	local var_4_4 = var_4_2 * 0.87
	local var_4_5 = Color(100, 255, 0)
	local var_4_6 = Vector3(var_4_4, var_4_3, 10)
	local var_4_7 = 40
	local var_4_8 = string.format("Ammo: %2d", var_4_1)

	Debug.draw_text(var_4_8, var_4_6, var_4_7, var_4_5)
end
