-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_we_waywatcher.lua

ActionCareerWEWaywatcher = class(ActionCareerWEWaywatcher, ActionTrueFlightBow)

ActionCareerWEWaywatcher.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerWEWaywatcher.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
end

ActionCareerWEWaywatcher.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionCareerWEWaywatcher.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0:_play_vo()

	arg_2_0._cooldown_started = false

	ScriptUnit.extension(arg_2_0.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

ActionCareerWEWaywatcher.finish = function (arg_3_0, arg_3_1)
	ActionCareerWEWaywatcher.super.finish(arg_3_0, arg_3_1)

	if not arg_3_0._cooldown_started then
		arg_3_0._cooldown_started = true

		arg_3_0.career_extension:start_activated_ability_cooldown()
	end

	arg_3_0.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerWEWaywatcher._play_vo = function (arg_4_0)
	local var_4_0 = arg_4_0.owner_unit
	local var_4_1 = ScriptUnit.extension_input(var_4_0, "dialogue_system")
	local var_4_2 = FrameTable.alloc_table()

	var_4_1:trigger_networked_dialogue_event("activate_ability", var_4_2)
end

ActionCareerWEWaywatcher._restore_ammo = function (arg_5_0)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = "slot_ranged"
	local var_5_2 = ScriptUnit.extension(var_5_0, "inventory_system"):get_slot_data(var_5_1)
	local var_5_3 = var_5_2.right_unit_1p
	local var_5_4 = var_5_2.left_unit_1p
	local var_5_5 = ScriptUnit.has_extension(var_5_3, "ammo_system")
	local var_5_6 = ScriptUnit.has_extension(var_5_4, "ammo_system")
	local var_5_7 = var_5_5 or var_5_6
	local var_5_8 = 0.2
	local var_5_9 = math.max(math.round(var_5_7:max_ammo() * var_5_8), 1)

	if var_5_7 then
		var_5_7:add_ammo_to_reserve(var_5_9)
	end
end
