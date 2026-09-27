-- chunkname: @scripts/settings/dlcs/wizards/wizards_interactions.lua

local clone = table.clone(InteractionDefinitions.smartobject)

clone.config = {
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
InteractionDefinitions.trail_light_urn = clone

clone.server.start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local get_data = Unit.get_data(arg_1_2, "interaction_data", "interaction_length")

	arg_1_3.done_time = arg_1_5 + get_data
	arg_1_3.duration = get_data
end

clone.client.start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ScriptUnit.extension(arg_2_2, "trail_urn_alignment_system"):on_client_start_interaction(arg_2_1, arg_2_5)

	arg_2_3.start_time = arg_2_5

	local get_data = Unit.get_data(arg_2_2, "interaction_data", "interaction_length")

	arg_2_3.duration = get_data

	local get_data_2 = Unit.get_data(arg_2_2, "interaction_data", "interactor_animation")
	local get_data_3 = Unit.get_data(arg_2_2, "interaction_data", "interactor_animation_time_variable")
	local extension = ScriptUnit.extension(arg_2_1, "inventory_system")
	local extension_2 = ScriptUnit.extension(arg_2_1, "career_system")

	CharacterStateHelper.stop_weapon_actions(extension, "interacting")
	CharacterStateHelper.stop_career_abilities(extension_2, "interacting")

	if not get_data_2 then
		local animation_find_variable = Unit.animation_find_variable(arg_2_1, get_data_3)

		Unit.animation_set_variable(arg_2_1, animation_find_variable, get_data)

		local get_data_4 = Unit.get_data(arg_2_2, "interaction_data", "interactor_animation")

		Unit.animation_event(arg_2_1, get_data_4)
	end

	Unit.set_data(arg_2_2, "interaction_data", "being_used", true)
end

clone.server.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	if not (ScriptUnit.extension(arg_3_1, "status_system"):is_knocked_down() or HEALTH_ALIVE[arg_3_1]) then
		return InteractionResult.FAILURE
	end

	local extension = ScriptUnit.extension(arg_3_2, "trail_urn_alignment_system")

	if not extension:is_state_aligned() and not extension:is_unit_pushed_out_off_range(arg_3_1, arg_3_2) then
		return InteractionResult.FAILURE
	end

	if arg_3_6 > arg_3_3.done_time then
		return InteractionResult.SUCCESS
	end

	return InteractionResult.ONGOING
end

clone.client.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	ScriptUnit.extension(arg_4_2, "trail_urn_alignment_system"):on_client_move_to_node(arg_4_1, arg_4_2, arg_4_3.is_husk, arg_4_6)
end

clone.server.stop = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	if arg_5_6 == InteractionResult.SUCCESS then
		local extension = ScriptUnit.extension(arg_5_2, "interactable_system")

		extension.num_times_successfully_completed = extension.num_times_successfully_completed + 1

		if not Unit.get_data(arg_5_2, "interaction_data", "only_once") then
			Unit.set_data(arg_5_2, "interaction_data", "used", true)
		end
	end

	Unit.set_data(arg_5_2, "interaction_data", "being_used", false)
end

local function fn(arg_6_0)
	-- function 6
	local extension = ScriptUnit.extension(arg_6_0, "inventory_system")

	extension:destroy_slot("slot_level_event")
	extension:wield_previous_weapon()
end

clone.client.stop = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	Unit.animation_event(arg_7_1, "interaction_end")

	if arg_7_6 == InteractionResult.SUCCESS then
		if not Unit.get_data(arg_7_2, "interaction_data", "only_once") then
			Unit.set_data(arg_7_2, "interaction_data", "used", true)
		end

		if not arg_7_3.is_husk then
			fn(arg_7_1)
		end
	end

	if arg_7_3.is_husk or not arg_7_4.rotate_toward_interactable then
		local extension = ScriptUnit.extension(arg_7_1, "locomotion_system")

		extension:enable_script_driven_movement()
		extension:enable_rotation_towards_velocity(true)
	end

	ScriptUnit.extension(arg_7_2, "trail_urn_alignment_system"):on_client_stop(arg_7_6)
	Unit.set_data(arg_7_2, "interaction_data", "being_used", false)
end

clone.server.can_interact = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local get_data = Unit.get_data(arg_8_1, "interaction_data", "used")
	local get_data_2 = Unit.get_data(arg_8_1, "interaction_data", "being_used")

	if get_data or not get_data_2 then
		return not not get_data or not get_data_2
	end

	if not ScriptUnit.extension(arg_8_1, "trail_urn_alignment_system"):can_interact() then
		return false
	end

	local get_data_3 = Unit.get_data(arg_8_1, "interaction_data", "wanted_item")

	get_data_3 = get_data_3 or "shadow_torch"

	local has_extension = ScriptUnit.has_extension(arg_8_0, "inventory_system")

	if not (has_extension or has_extension:has_inventory_item("slot_level_event", get_data_3)) then
		return false
	end

	local get_data_4 = Unit.get_data(arg_8_1, "interaction_data", "custom_interaction_check_name")

	if not (not get_data_4 and not InteractionCustomChecks[get_data_4] and InteractionCustomChecks[get_data_4](arg_8_0, arg_8_1)) then
		return false
	end

	return not not get_data or not get_data_2
end

clone.client.can_interact = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if not ScriptUnit.extension(arg_9_1, "trail_urn_alignment_system"):can_interact() then
		return false
	end

	local get_data = Unit.get_data(arg_9_1, "interaction_data", "wanted_item")

	get_data = get_data or "shadow_torch"

	local has_extension = ScriptUnit.has_extension(arg_9_0, "inventory_system")

	if not (has_extension == nil or has_extension:has_inventory_item("slot_level_event", get_data)) then
		return false
	end

	local get_data_2 = Unit.get_data(arg_9_1, "interaction_data", "used")
	local get_data_3 = Unit.get_data(arg_9_1, "interaction_data", "being_used")

	if get_data_2 or not get_data_3 then
		return not not get_data_2 or not get_data_3
	end

	local get_data_4 = Unit.get_data(arg_9_1, "interaction_data", "custom_interaction_check_name")

	if not (not get_data_4 and not InteractionCustomChecks[get_data_4] and InteractionCustomChecks[get_data_4](arg_9_0, arg_9_1)) then
		return false
	end

	return not not get_data_2 or not get_data_3
end
