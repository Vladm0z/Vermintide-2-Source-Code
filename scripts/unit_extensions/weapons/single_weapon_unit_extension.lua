-- chunkname: @scripts/unit_extensions/weapons/single_weapon_unit_extension.lua

require("scripts/unit_extensions/weapons/single_weapon_unit_templates")

SingleWeaponUnitExtension = class(SingleWeaponUnitExtension)

SingleWeaponUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.owner_unit = arg_1_3.owner_unit

	local item_template = arg_1_3.item_template

	self.single_weapon_template_name = item_template.single_weapon_template_name
	self.weapon_template = SingleWeaponUnitTemplates.get_template(self.single_weapon_template_name)
	self.is_server = Managers.player.is_server
	self._weapon_wield = not item_template and item_template.on_wield
	self._weapon_unwield = not item_template and item_template.on_unwield
	self.data = {}
end

SingleWeaponUnitExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

SingleWeaponUnitExtension.has_current_action = function (arg_3_0)
	-- function 3
	return false
end

SingleWeaponUnitExtension.change_state = function (self, arg_4_1)
	-- function 4
	self.state = arg_4_1

	self.weapon_template[arg_4_1](self.world, self.unit, self.owner_unit, self.data)
end

SingleWeaponUnitExtension.destroy = function (self)
	-- function 5
	self.weapon_template.destroy(self.world, self.unit, self.owner_unit, self.data)
end

SingleWeaponUnitExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	self.weapon_template.update(self.world, self.unit, self.owner_unit, self.data, arg_6_5, arg_6_3)
end

SingleWeaponUnitExtension.on_wield = function (self, arg_7_1)
	-- function 7
	if not self._weapon_wield then
		self._weapon_wield(self, arg_7_1)
	end
end

SingleWeaponUnitExtension.on_unwield = function (self, arg_8_1)
	-- function 8
	if not self._weapon_unwield then
		self._weapon_unwield(self, arg_8_1)
	end
end
