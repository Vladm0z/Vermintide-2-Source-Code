-- chunkname: @scripts/unit_extensions/weapons/actions/action_staff.lua

ActionStaff = class(ActionStaff, ActionBase)

ActionStaff.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionStaff.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	if ScriptUnit.has_extension(arg_1_7, "spread_system") then
		arg_1_0.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
	end

	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
end

ActionStaff.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionStaff.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)

	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + (arg_2_1.fire_time or 0)
	arg_2_0.power_level = arg_2_4

	local var_2_2 = ScriptUnit.has_extension(var_2_0, "hud_system")

	arg_2_0:_handle_critical_strike(var_2_1, nil, var_2_2, nil, "on_critical_shot", nil)

	arg_2_0._is_critical_strike = var_2_1
end

ActionStaff.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_0.state == "waiting_to_shoot" and arg_3_2 >= arg_3_0.time_to_shoot then
		arg_3_0.state = "shooting"
	end

	if arg_3_0.state == "shooting" then
		arg_3_0:fire()

		arg_3_0.state = "shot"
	end
end

ActionStaff.finish = function (arg_4_0, arg_4_1)
	local var_4_0 = ScriptUnit.has_extension(arg_4_0.owner_unit, "hud_system")

	if var_4_0 then
		var_4_0.show_critical_indication = false
	end
end

ActionStaff.fire = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = arg_5_0.owner_unit
	local var_5_2, var_5_3 = ScriptUnit.extension(var_5_1, "first_person_system"):get_projectile_start_position_rotation()
	local var_5_4 = arg_5_0.spread_extension

	if var_5_4 then
		var_5_3 = var_5_4:get_randomised_spread(var_5_3)

		var_5_4:set_shooting()
	end

	local var_5_5 = ActionUtils.pitch_from_rotation(var_5_3)
	local var_5_6 = var_5_0.speed
	local var_5_7 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_5_3)))
	local var_5_8 = var_5_0.lookup_data

	ActionUtils.spawn_player_projectile(var_5_1, var_5_2, var_5_3, 0, var_5_5, var_5_7, var_5_6, arg_5_0.item_name, var_5_8.item_template_name, var_5_8.action_name, var_5_8.sub_action_name, arg_5_0._is_critical_strike, arg_5_0.power_level)

	if arg_5_0.ammo_extension then
		local var_5_9 = var_5_0.ammo_usage

		arg_5_0.ammo_extension:use_ammo(var_5_9)
	end

	local var_5_10 = var_5_0.overcharge_type

	if var_5_10 then
		local var_5_11 = PlayerUnitStatusSettings.overcharge_values[var_5_10]

		arg_5_0.overcharge_extension:add_charge(var_5_11)
	end

	if arg_5_0.ammo_extension and arg_5_0.ammo_extension:can_reload() then
		local var_5_12 = true

		arg_5_0.ammo_extension:start_reload(var_5_12)
	end

	local var_5_13 = var_5_0.fire_sound_event

	if var_5_13 then
		WwiseUtils.trigger_unit_event(arg_5_0.world, var_5_13, arg_5_0.weapon_unit)
	end
end
