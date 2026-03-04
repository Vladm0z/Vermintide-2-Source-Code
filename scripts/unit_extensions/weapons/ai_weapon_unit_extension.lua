-- chunkname: @scripts/unit_extensions/weapons/ai_weapon_unit_extension.lua

require("scripts/unit_extensions/weapons/ai_weapon_unit_templates")

AiWeaponUnitExtension = class(AiWeaponUnitExtension)

AiWeaponUnitExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0.weapon_template = arg_1_3.weapon_template
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.data = {}
end

AiWeaponUnitExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	return
end

AiWeaponUnitExtension.destroy = function (arg_3_0)
	AiWeaponUnitTemplates.get_template(arg_3_0.weapon_template).destroy(arg_3_0.world, arg_3_0.unit, arg_3_0.data)
end

AiWeaponUnitExtension.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	AiWeaponUnitTemplates.get_template(arg_4_0.weapon_template).update(arg_4_0.world, arg_4_0.unit, arg_4_0.data, arg_4_5, arg_4_3)
end

AiWeaponUnitExtension.shoot_start = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.data.unit_owner = arg_5_1

	AiWeaponUnitTemplates.get_template(arg_5_0.weapon_template).shoot_start(arg_5_0.world, arg_5_0.unit, arg_5_0.data, arg_5_2)
end

AiWeaponUnitExtension.shoot = function (arg_6_0, arg_6_1)
	arg_6_0.data.unit_owner = arg_6_1

	AiWeaponUnitTemplates.get_template(arg_6_0.weapon_template).shoot(arg_6_0.world, arg_6_0.unit, arg_6_0.data)
end

AiWeaponUnitExtension.shoot_end = function (arg_7_0, arg_7_1)
	arg_7_0.data.unit_owner = arg_7_1

	AiWeaponUnitTemplates.get_template(arg_7_0.weapon_template).shoot_end(arg_7_0.world, arg_7_0.unit, arg_7_0.data)
end

AiWeaponUnitExtension.windup_start = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.data.unit_owner = arg_8_1

	AiWeaponUnitTemplates.get_template(arg_8_0.weapon_template).windup_start(arg_8_0.world, arg_8_0.unit, arg_8_0.data, arg_8_2)
end

AiWeaponUnitExtension.windup_end = function (arg_9_0, arg_9_1)
	arg_9_0.data.unit_owner = arg_9_1

	AiWeaponUnitTemplates.get_template(arg_9_0.weapon_template).windup_end(arg_9_0.world, arg_9_0.unit, arg_9_0.data)
end
