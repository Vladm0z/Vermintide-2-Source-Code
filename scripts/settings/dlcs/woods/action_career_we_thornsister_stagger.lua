-- chunkname: @scripts/settings/dlcs/woods/action_career_we_thornsister_stagger.lua

ActionCareerWEThornsisterStagger = class(ActionCareerWEThornsisterStagger, ActionBase)

function ActionCareerWEThornsisterStagger.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerWEThornsisterStagger.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._network_transmit = Managers.state.network.network_transmit
end

function ActionCareerWEThornsisterStagger.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionCareerWEThornsisterStagger.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0:_play_vo()

	local var_2_0 = arg_2_0.career_extension

	var_2_0:start_activated_ability_cooldown()

	local var_2_1 = arg_2_3

	if var_2_1 then
		local var_2_2 = arg_2_0.is_server
		local var_2_3 = false
		local var_2_4 = "we_thornsister_career_skill_stagger_spell"
		local var_2_5 = ExplosionUtils.get_template(var_2_4)
		local var_2_6 = 1
		local var_2_7 = "career_ability"
		local var_2_8 = var_2_0:get_career_power_level()
		local var_2_9 = arg_2_0.owner_unit
		local var_2_10 = POSITION_LOOKUP[var_2_9]
		local var_2_11 = Quaternion.look(var_2_1.direction:unbox(), Vector3.up())

		DamageUtils.create_explosion(arg_2_0.world, var_2_9, var_2_10, var_2_11, var_2_5, var_2_6, var_2_7, var_2_2, var_2_3, var_2_9, var_2_8, false, var_2_9)

		local var_2_12 = Managers.state.network
		local var_2_13 = var_2_12.network_transmit
		local var_2_14 = var_2_12:unit_game_object_id(var_2_9)
		local var_2_15 = NetworkLookup.explosion_templates[var_2_4]
		local var_2_16 = NetworkLookup.damage_sources[var_2_7]

		if var_2_2 then
			var_2_13:send_rpc_clients("rpc_create_explosion", var_2_14, false, var_2_10, var_2_11, var_2_15, var_2_6, var_2_16, var_2_8, false, var_2_14)
		else
			var_2_13:send_rpc_server("rpc_create_explosion", var_2_14, false, var_2_10, var_2_11, var_2_15, var_2_6, var_2_16, var_2_8, false, var_2_14)
		end
	end
end

function ActionCareerWEThornsisterStagger.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

function ActionCareerWEThornsisterStagger.finish(arg_4_0, arg_4_1)
	arg_4_0.inventory_extension:wield_previous_non_level_slot()
end

function ActionCareerWEThornsisterStagger._play_vo(arg_5_0)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = ScriptUnit.extension_input(var_5_0, "dialogue_system")
	local var_5_2 = FrameTable.alloc_table()

	var_5_1:trigger_networked_dialogue_event("activate_ability", var_5_2)
end
