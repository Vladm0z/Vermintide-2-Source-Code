-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_standing.lua

PackmasterStateStanding = class(PackmasterStateStanding, EnemyCharacterStateStanding)

PackmasterStateStanding.init = function (arg_1_0, arg_1_1)
	PackmasterStateStanding.super.init(arg_1_0, arg_1_1)

	arg_1_0._grab_ability_id = arg_1_0._career_extension:ability_id("grab")
	arg_1_0._equip_ability_id = arg_1_0._career_extension:ability_id("equip")

	local var_1_0, var_1_1 = arg_1_0._inventory_extension:get_all_weapon_unit()

	arg_1_0._weapon_unit_left = var_1_0
	arg_1_0._weapon_unit_right = var_1_1
end

PackmasterStateStanding.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	PackmasterStateStanding.super.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)

	arg_2_0._right_wpn_particle_node_name = "g_skaven_packmaster_claw"
	arg_2_0._right_wpn_particle_name = "fx/wpnfx_packmaster_enemy_in_range_1p"
end

PackmasterStateStanding.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0:common_state_changes() then
		return
	end

	local var_3_0 = arg_3_0._csm
	local var_3_1 = arg_3_0._career_extension

	if var_3_1:ability_was_triggered(arg_3_0._grab_ability_id) then
		var_3_0:change_state("packmaster_grabbing")

		return
	end

	if var_3_1:ability_was_triggered(arg_3_0._equip_ability_id) then
		var_3_0:change_state("packmaster_equipping")

		return
	end

	arg_3_0:_update_taunt_dialogue(arg_3_5)

	local var_3_2 = arg_3_0:common_movement(arg_3_5)
end
