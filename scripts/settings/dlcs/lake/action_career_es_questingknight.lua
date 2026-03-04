-- chunkname: @scripts/settings/dlcs/lake/action_career_es_questingknight.lua

ActionCareerESQuestingKnight = class(ActionCareerESQuestingKnight, ActionSweep)

ActionCareerESQuestingKnight.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerESQuestingKnight.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
end

ActionCareerESQuestingKnight.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionCareerESQuestingKnight.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0._combo_no_wield = arg_2_1.combo_no_wield or false
	arg_2_0._hit_fx_triggered = false

	arg_2_0:_play_vo()
	arg_2_0:_play_vfx()
	arg_2_0.inventory_extension:check_and_drop_pickups("career_ability")
	arg_2_0.status_extension:set_stagger_immune(true)

	arg_2_0._cooldown_started = arg_2_3 and arg_2_3.cooldown_started or false
end

ActionCareerESQuestingKnight.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	ActionCareerESQuestingKnight.super.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	if not arg_3_0._hit_fx_triggered and arg_3_0._started_damage_window then
		arg_3_0._hit_fx_triggered = true

		local var_3_0 = ScriptUnit.extension(arg_3_0.owner_unit, "first_person_system"):current_rotation()
		local var_3_1 = Vector3.flat(Quaternion.forward(var_3_0))
		local var_3_2 = Managers.state.network
		local var_3_3 = "fx/grail_knight_active_ability"
		local var_3_4 = NetworkLookup.effects[var_3_3]
		local var_3_5 = 0
		local var_3_6 = arg_3_0.current_action.vfx_settings
		local var_3_7 = var_3_6.forward or 0
		local var_3_8 = var_3_6.up or 0
		local var_3_9 = POSITION_LOOKUP[arg_3_0.owner_unit] + var_3_1 * var_3_7 + Vector3.up() * var_3_8
		local var_3_10 = var_3_6.pitch and Quaternion.multiply(var_3_0, Quaternion(Vector3.right(), var_3_6.pitch)) or Quaternion.identity()

		var_3_2:rpc_play_particle_effect(nil, var_3_4, NetworkConstants.invalid_game_object_id, var_3_5, var_3_9, var_3_10, false)
	end
end

ActionCareerESQuestingKnight.finish = function (arg_4_0, arg_4_1, arg_4_2)
	ActionCareerESQuestingKnight.super.finish(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.inventory_extension:stop_weapon_fx("career_action", true)

	local var_4_0 = arg_4_2 and arg_4_2.new_action_settings

	if var_4_0 and var_4_0.is_ability_cancel or not arg_4_0._combo_no_wield or arg_4_1 ~= "new_interupting_action" then
		arg_4_0.status_extension:set_stagger_immune(false)
		arg_4_0.inventory_extension:wield_previous_non_level_slot()
	end

	local var_4_1 = arg_4_0.career_extension

	if not arg_4_0._cooldown_started and arg_4_0.has_been_within_damage_window then
		arg_4_0._cooldown_started = true

		var_4_1:start_activated_ability_cooldown()
	end

	return {
		cooldown_started = arg_4_0._cooldown_started
	}
end

ActionCareerESQuestingKnight._play_vo = function (arg_5_0)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = ScriptUnit.extension_input(var_5_0, "dialogue_system")
	local var_5_2 = FrameTable.alloc_table()

	var_5_1:trigger_networked_dialogue_event("activate_ability", var_5_2)
end

ActionCareerESQuestingKnight._play_vfx = function (arg_6_0)
	arg_6_0.inventory_extension:start_weapon_fx("career_action", true)
end
