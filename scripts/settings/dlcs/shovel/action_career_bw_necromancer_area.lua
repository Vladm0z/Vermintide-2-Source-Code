-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_area.lua

ActionCareerBWNecromancerArea = class(ActionCareerBWNecromancerArea, ActionBase)

function ActionCareerBWNecromancerArea.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerBWNecromancerArea.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
end

function ActionCareerBWNecromancerArea.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionCareerBWNecromancerArea.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	if arg_2_3 then
		arg_2_0:_play_vo()
		arg_2_0._first_person_extension:play_hud_sound_event("Play_career_necro_ability_withering_wave_start", nil, true)
		arg_2_0:_create_damage_area(arg_2_3.position:unbox())
		arg_2_0:_add_buffs()
		arg_2_0._career_extension:start_activated_ability_cooldown()
	end
end

function ActionCareerBWNecromancerArea._create_damage_area(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.owner_unit
	local var_3_1 = Managers.state.network
	local var_3_2 = var_3_1.network_transmit
	local var_3_3 = var_3_1:unit_game_object_id(arg_3_0.owner_unit)

	var_3_2:send_rpc_server("rpc_necromancer_create_curse_area", var_3_3, arg_3_1)
end

function ActionCareerBWNecromancerArea._add_buffs(arg_4_0)
	local var_4_0 = "sienna_necromancer_cursed_area"
	local var_4_1 = arg_4_0.owner_unit

	arg_4_0._buff_extension:add_buff(var_4_0, {
		attacker_unit = var_4_1
	})
end

function ActionCareerBWNecromancerArea.client_owner_post_update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	return
end

function ActionCareerBWNecromancerArea._play_vo(arg_6_0)
	local var_6_0 = arg_6_0.owner_unit
	local var_6_1 = ScriptUnit.extension_input(var_6_0, "dialogue_system")
	local var_6_2 = FrameTable.alloc_table()

	var_6_1:trigger_networked_dialogue_event("activate_ability", var_6_2)
end

function ActionCareerBWNecromancerArea.finish(arg_7_0, arg_7_1)
	arg_7_0._inventory_extension:wield_previous_non_level_slot()
end
