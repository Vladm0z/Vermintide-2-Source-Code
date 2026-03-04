-- chunkname: @scripts/settings/dlcs/wizards/wizards_interactions.lua

local var_0_0 = table.clone(InteractionDefinitions.smartobject)

var_0_0.config = {
	allow_rotation_update = false,
	hud_verb = "player_interaction",
	block_other_interactions = true,
	activate_block = true,
	hold = true,
	swap_to_3p = true,
	animation = "interaction_torch",
	rotate_toward_interactable = true,
	show_weapons = true
}
InteractionDefinitions.trail_light_urn = var_0_0

var_0_0.server.start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = Unit.get_data(arg_1_2, "interaction_data", "interaction_length")

	arg_1_3.done_time = arg_1_5 + var_1_0
	arg_1_3.duration = var_1_0
end

var_0_0.client.start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ScriptUnit.extension(arg_2_2, "trail_urn_alignment_system"):on_client_start_interaction(arg_2_1, arg_2_5)

	arg_2_3.start_time = arg_2_5

	local var_2_0 = Unit.get_data(arg_2_2, "interaction_data", "interaction_length")

	arg_2_3.duration = var_2_0

	local var_2_1 = Unit.get_data(arg_2_2, "interaction_data", "interactor_animation")
	local var_2_2 = Unit.get_data(arg_2_2, "interaction_data", "interactor_animation_time_variable")
	local var_2_3 = ScriptUnit.extension(arg_2_1, "inventory_system")
	local var_2_4 = ScriptUnit.extension(arg_2_1, "career_system")

	CharacterStateHelper.stop_weapon_actions(var_2_3, "interacting")
	CharacterStateHelper.stop_career_abilities(var_2_4, "interacting")

	if var_2_1 then
		local var_2_5 = Unit.animation_find_variable(arg_2_1, var_2_2)

		Unit.animation_set_variable(arg_2_1, var_2_5, var_2_0)

		local var_2_6 = Unit.get_data(arg_2_2, "interaction_data", "interactor_animation")

		Unit.animation_event(arg_2_1, var_2_6)
	end

	Unit.set_data(arg_2_2, "interaction_data", "being_used", true)
end

var_0_0.server.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	if ScriptUnit.extension(arg_3_1, "status_system"):is_knocked_down() or not HEALTH_ALIVE[arg_3_1] then
		return InteractionResult.FAILURE
	end

	local var_3_0 = ScriptUnit.extension(arg_3_2, "trail_urn_alignment_system")

	if var_3_0:is_state_aligned() and var_3_0:is_unit_pushed_out_off_range(arg_3_1, arg_3_2) then
		return InteractionResult.FAILURE
	end

	if arg_3_6 > arg_3_3.done_time then
		return InteractionResult.SUCCESS
	end

	return InteractionResult.ONGOING
end

var_0_0.client.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	ScriptUnit.extension(arg_4_2, "trail_urn_alignment_system"):on_client_move_to_node(arg_4_1, arg_4_2, arg_4_3.is_husk, arg_4_6)
end

var_0_0.server.stop = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	if arg_5_6 == InteractionResult.SUCCESS then
		local var_5_0 = ScriptUnit.extension(arg_5_2, "interactable_system")

		var_5_0.num_times_successfully_completed = var_5_0.num_times_successfully_completed + 1

		if Unit.get_data(arg_5_2, "interaction_data", "only_once") then
			Unit.set_data(arg_5_2, "interaction_data", "used", true)
		end
	end

	Unit.set_data(arg_5_2, "interaction_data", "being_used", false)
end

local function var_0_1(arg_6_0)
	local var_6_0 = ScriptUnit.extension(arg_6_0, "inventory_system")

	var_6_0:destroy_slot("slot_level_event")
	var_6_0:wield_previous_weapon()
end

var_0_0.client.stop = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	Unit.animation_event(arg_7_1, "interaction_end")

	if arg_7_6 == InteractionResult.SUCCESS then
		if Unit.get_data(arg_7_2, "interaction_data", "only_once") then
			Unit.set_data(arg_7_2, "interaction_data", "used", true)
		end

		if not arg_7_3.is_husk then
			var_0_1(arg_7_1)
		end
	end

	if not arg_7_3.is_husk and arg_7_4.rotate_toward_interactable then
		local var_7_0 = ScriptUnit.extension(arg_7_1, "locomotion_system")

		var_7_0:enable_script_driven_movement()
		var_7_0:enable_rotation_towards_velocity(true)
	end

	ScriptUnit.extension(arg_7_2, "trail_urn_alignment_system"):on_client_stop(arg_7_6)
	Unit.set_data(arg_7_2, "interaction_data", "being_used", false)
end

var_0_0.server.can_interact = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = Unit.get_data(arg_8_1, "interaction_data", "used")
	local var_8_1 = Unit.get_data(arg_8_1, "interaction_data", "being_used")

	if var_8_0 or var_8_1 then
		return not var_8_0 and not var_8_1
	end

	if not ScriptUnit.extension(arg_8_1, "trail_urn_alignment_system"):can_interact() then
		return false
	end

	local var_8_2 = Unit.get_data(arg_8_1, "interaction_data", "wanted_item") or "shadow_torch"
	local var_8_3 = ScriptUnit.has_extension(arg_8_0, "inventory_system")

	if not var_8_3 and not var_8_3:has_inventory_item("slot_level_event", var_8_2) then
		return false
	end

	local var_8_4 = Unit.get_data(arg_8_1, "interaction_data", "custom_interaction_check_name")

	if var_8_4 and InteractionCustomChecks[var_8_4] and not InteractionCustomChecks[var_8_4](arg_8_0, arg_8_1) then
		return false
	end

	return not var_8_0 and not var_8_1
end

var_0_0.client.can_interact = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not ScriptUnit.extension(arg_9_1, "trail_urn_alignment_system"):can_interact() then
		return false
	end

	local var_9_0 = Unit.get_data(arg_9_1, "interaction_data", "wanted_item") or "shadow_torch"
	local var_9_1 = ScriptUnit.has_extension(arg_9_0, "inventory_system")

	if var_9_1 == nil or not var_9_1:has_inventory_item("slot_level_event", var_9_0) then
		return false
	end

	local var_9_2 = Unit.get_data(arg_9_1, "interaction_data", "used")
	local var_9_3 = Unit.get_data(arg_9_1, "interaction_data", "being_used")

	if var_9_2 or var_9_3 then
		return not var_9_2 and not var_9_3
	end

	local var_9_4 = Unit.get_data(arg_9_1, "interaction_data", "custom_interaction_check_name")

	if var_9_4 and InteractionCustomChecks[var_9_4] and not InteractionCustomChecks[var_9_4](arg_9_0, arg_9_1) then
		return false
	end

	return not var_9_2 and not var_9_3
end
