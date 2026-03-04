-- chunkname: @scripts/unit_extensions/weapons/actions/action_aim_energy.lua

ActionAimEnergy = class(ActionAimEnergy, ActionAim)

ActionAimEnergy.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionAimEnergy.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionAimEnergy.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2)
	ActionAimEnergy.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
end

ActionAimEnergy.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	ActionAimEnergy.super.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:_process_energy_draining(arg_3_1, arg_3_2)
end

ActionAimEnergy._process_energy_draining = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = false
	local var_4_1 = ScriptUnit.extension(arg_4_0.owner_unit, "energy_system")

	if var_4_1:is_drainable() then
		local var_4_2 = arg_4_0.current_action.drain_rate * arg_4_1

		var_4_1:drain(var_4_2)

		var_4_0 = var_4_1:is_depleted()
	end

	if var_4_0 then
		arg_4_0:_fire_shot(arg_4_2)
	end
end

ActionAimEnergy._fire_shot = function (arg_5_0, arg_5_1)
	local var_5_0 = ScriptUnit.extension(arg_5_0.owner_unit, "inventory_system")
	local var_5_1, var_5_2, var_5_3 = CharacterStateHelper.get_item_data_and_weapon_extensions(var_5_0)
	local var_5_4 = BackendUtils.get_item_template(var_5_1)
	local var_5_5 = arg_5_0.current_action.action_on_energy_drained
	local var_5_6 = var_5_5.action_name
	local var_5_7 = var_5_5.sub_action_name
	local var_5_8 = var_5_4.actions
	local var_5_9 = Managers.player:local_player()
	local var_5_10 = var_5_9:profile_display_name()
	local var_5_11 = var_5_9:career_name()
	local var_5_12 = BackendUtils.get_total_power_level(var_5_10, var_5_11)
	local var_5_13

	ScriptUnit.extension(arg_5_0.weapon_unit, "weapon_system"):start_action(var_5_6, var_5_7, var_5_8, arg_5_1, var_5_12, var_5_13)
end
