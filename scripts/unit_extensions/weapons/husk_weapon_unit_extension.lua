-- chunkname: @scripts/unit_extensions/weapons/husk_weapon_unit_extension.lua

HuskWeaponUnitExtension = class(HuskWeaponUnitExtension)

HuskWeaponUnitExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.owner_unit = arg_1_3.owner_unit

	local var_1_0 = arg_1_3.item_name
	local var_1_1 = rawget(ItemMasterList, var_1_0)
	local var_1_2 = var_1_1 and var_1_1.template

	if var_1_2 then
		local var_1_3 = WeaponUtils.get_weapon_template(var_1_2)

		arg_1_0._synced_weapon_state = nil
		arg_1_0._synced_weapon_states = var_1_3 and var_1_3.synced_states

		if arg_1_0._synced_weapon_states then
			arg_1_0._synced_weapon_state_data = {}
		end
	end
end

HuskWeaponUnitExtension.destroy = function (arg_2_0)
	if arg_2_0._synced_weapon_states then
		for iter_2_0, iter_2_1 in pairs(arg_2_0._synced_weapon_states) do
			if iter_2_1.leave then
				iter_2_1:leave(arg_2_0.owner_unit, arg_2_0.unit, arg_2_0._synced_weapon_state_data, arg_2_0:_is_local_player(), arg_2_0.world, nil, true)
			end
		end
	end
end

HuskWeaponUnitExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0._synced_weapon_state then
		local var_3_0 = arg_3_0._synced_weapon_states[arg_3_0._synced_weapon_state]

		if var_3_0.update then
			var_3_0:update(arg_3_0.owner_unit, arg_3_0.unit, arg_3_0._synced_weapon_state_data, false, arg_3_0.world, arg_3_3)
		end
	end
end

HuskWeaponUnitExtension._is_local_player = function (arg_4_0)
	return false
end

HuskWeaponUnitExtension.change_synced_state = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._synced_weapon_state then
		local var_5_0 = arg_5_0._synced_weapon_states[arg_5_0._synced_weapon_state]

		if var_5_0.leave then
			var_5_0:leave(arg_5_0.owner_unit, arg_5_0.unit, arg_5_0._synced_weapon_state_data, false, arg_5_0.world, arg_5_1, false)
		end
	end

	arg_5_0._synced_weapon_state = arg_5_1

	if arg_5_1 then
		local var_5_1 = arg_5_0._synced_weapon_states[arg_5_1]

		if var_5_1.clear_data_on_enter then
			table.clear(arg_5_0._synced_weapon_state_data)
		end

		if var_5_1.enter then
			var_5_1:enter(arg_5_0.owner_unit, arg_5_0.unit, arg_5_0._synced_weapon_state_data, false, arg_5_0.world)
		end
	end
end

HuskWeaponUnitExtension.current_synced_state = function (arg_6_0)
	return arg_6_0._synced_weapon_state
end
