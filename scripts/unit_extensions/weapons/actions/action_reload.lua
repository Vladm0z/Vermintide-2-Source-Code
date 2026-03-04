-- chunkname: @scripts/unit_extensions/weapons/actions/action_reload.lua

ActionReload = class(ActionReload, ActionBase)

ActionReload.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	arg_1_0.weapon_system = arg_1_8
	arg_1_0.owner_unit = arg_1_4
	arg_1_0.first_person_unit = arg_1_6
	arg_1_0.weapon_unit = arg_1_7
	arg_1_0.world = arg_1_1
	arg_1_0.item_name = arg_1_2
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_1)
	arg_1_0.is_server = arg_1_3
end

ActionReload.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionReload.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ScriptUnit.extension(var_2_0, "inventory_system")
	local var_2_2
	local var_2_3 = var_2_1:equipment()

	if var_2_3.right_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_2_3.right_hand_wielded_unit, "ammo_system") then
		var_2_2 = ScriptUnit.extension(var_2_3.right_hand_wielded_unit, "ammo_system")
	elseif var_2_3.left_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_2_3.left_hand_wielded_unit, "ammo_system") then
		var_2_2 = ScriptUnit.extension(var_2_3.left_hand_wielded_unit, "ammo_system")
	end

	local var_2_4 = true

	var_2_2:start_reload(var_2_4)
end

ActionReload.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

ActionReload.finish = function (arg_4_0, arg_4_1)
	return
end
