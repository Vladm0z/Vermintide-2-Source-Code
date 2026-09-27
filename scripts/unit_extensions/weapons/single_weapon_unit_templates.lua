-- chunkname: @scripts/unit_extensions/weapons/single_weapon_unit_templates.lua

SingleWeaponUnitTemplates = {}
SingleWeaponUnitTemplates.templates = {}

DLCUtils.require("single_weapon_templates")

SingleWeaponUnitTemplates.get_template = function (arg_1_0, arg_1_1)
	-- function 1
	local templates = SingleWeaponUnitTemplates.templates
	local flag

	flag = (arg_1_1 ~= true or not "husk" or arg_1_1 ~= false) and (not "unit" or nil)

	local var_1_2

	if not flag then
		var_1_2 = templates[arg_1_0][flag]

		if not var_1_2 then
			-- Nothing
		end
	end

	var_1_2 = templates[arg_1_0]

	::label_1_0::

	return var_1_2
end
