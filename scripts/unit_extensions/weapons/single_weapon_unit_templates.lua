-- chunkname: @scripts/unit_extensions/weapons/single_weapon_unit_templates.lua

SingleWeaponUnitTemplates = {}
SingleWeaponUnitTemplates.templates = {}

DLCUtils.require("single_weapon_templates")

function SingleWeaponUnitTemplates.get_template(arg_1_0, arg_1_1)
	local var_1_0 = SingleWeaponUnitTemplates.templates
	local var_1_1 = arg_1_1 == true and "husk" or arg_1_1 == false and "unit" or nil

	return var_1_1 and var_1_0[arg_1_0][var_1_1] or var_1_0[arg_1_0]
end
