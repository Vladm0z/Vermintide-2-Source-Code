-- chunkname: @scripts/unit_extensions/weapons/husk_weapon_unit_extension.lua

HuskWeaponUnitExtension = class(HuskWeaponUnitExtension)

HuskWeaponUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.owner_unit = arg_1_3.owner_unit

	local item_name = arg_1_3.item_name
	local var_1_1 = rawget(ItemMasterList, item_name)
	local flag = not var_1_1 and var_1_1.template

	if not flag then
		local get_weapon_template = WeaponUtils.get_weapon_template(flag)

		self._synced_weapon_state = nil
		self._synced_weapon_states = not get_weapon_template and get_weapon_template.synced_states

		if not self._synced_weapon_states then
			self._synced_weapon_state_data = {}
		end
	end
end

HuskWeaponUnitExtension.destroy = function (self)
	-- function 2
	if not self._synced_weapon_states then
		for k, v in pairs(self._synced_weapon_states) do
			if not v.leave then
				v:leave(self.owner_unit, self.unit, self._synced_weapon_state_data, self:_is_local_player(), self.world, nil, true)
			end
		end
	end
end

HuskWeaponUnitExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self._synced_weapon_state then
		local var_3_0 = self._synced_weapon_states[self._synced_weapon_state]

		if not var_3_0.update then
			var_3_0:update(self.owner_unit, self.unit, self._synced_weapon_state_data, false, self.world, arg_3_3)
		end
	end
end

HuskWeaponUnitExtension._is_local_player = function (arg_4_0)
	-- function 4
	return false
end

HuskWeaponUnitExtension.change_synced_state = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._synced_weapon_state then
		local var_5_0 = self._synced_weapon_states[self._synced_weapon_state]

		if not var_5_0.leave then
			var_5_0:leave(self.owner_unit, self.unit, self._synced_weapon_state_data, false, self.world, arg_5_1, false)
		end
	end

	self._synced_weapon_state = arg_5_1

	if not arg_5_1 then
		local var_5_1 = self._synced_weapon_states[arg_5_1]

		if not var_5_1.clear_data_on_enter then
			table.clear(self._synced_weapon_state_data)
		end

		if not var_5_1.enter then
			var_5_1:enter(self.owner_unit, self.unit, self._synced_weapon_state_data, false, self.world)
		end
	end
end

HuskWeaponUnitExtension.current_synced_state = function (self)
	-- function 6
	return self._synced_weapon_state
end
