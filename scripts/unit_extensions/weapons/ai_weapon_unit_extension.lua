-- chunkname: @scripts/unit_extensions/weapons/ai_weapon_unit_extension.lua

require("scripts/unit_extensions/weapons/ai_weapon_unit_templates")

AiWeaponUnitExtension = class(AiWeaponUnitExtension)

AiWeaponUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.owner_unit = arg_1_3.owner_unit
	self.weapon_template = arg_1_3.weapon_template
	self.is_server = Managers.player.is_server
	self.data = {}
end

AiWeaponUnitExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

AiWeaponUnitExtension.destroy = function (self)
	-- function 3
	AiWeaponUnitTemplates.get_template(self.weapon_template).destroy(self.world, self.unit, self.data)
end

AiWeaponUnitExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	AiWeaponUnitTemplates.get_template(self.weapon_template).update(self.world, self.unit, self.data, arg_4_5, arg_4_3)
end

AiWeaponUnitExtension.shoot_start = function (self, arg_5_1, arg_5_2)
	-- function 5
	self.data.unit_owner = arg_5_1

	AiWeaponUnitTemplates.get_template(self.weapon_template).shoot_start(self.world, self.unit, self.data, arg_5_2)
end

AiWeaponUnitExtension.shoot = function (self, arg_6_1)
	-- function 6
	self.data.unit_owner = arg_6_1

	AiWeaponUnitTemplates.get_template(self.weapon_template).shoot(self.world, self.unit, self.data)
end

AiWeaponUnitExtension.shoot_end = function (self, arg_7_1)
	-- function 7
	self.data.unit_owner = arg_7_1

	AiWeaponUnitTemplates.get_template(self.weapon_template).shoot_end(self.world, self.unit, self.data)
end

AiWeaponUnitExtension.windup_start = function (self, arg_8_1, arg_8_2)
	-- function 8
	self.data.unit_owner = arg_8_1

	AiWeaponUnitTemplates.get_template(self.weapon_template).windup_start(self.world, self.unit, self.data, arg_8_2)
end

AiWeaponUnitExtension.windup_end = function (self, arg_9_1)
	-- function 9
	self.data.unit_owner = arg_9_1

	AiWeaponUnitTemplates.get_template(self.weapon_template).windup_end(self.world, self.unit, self.data)
end
