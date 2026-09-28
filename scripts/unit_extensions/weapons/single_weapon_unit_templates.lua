-- chunkname: @scripts/unit_extensions/weapons/single_weapon_unit_templates.lua

SingleWeaponUnitTemplates = {}
SingleWeaponUnitTemplates.templates = {}

DLCUtils.require("single_weapon_templates")

SingleWeaponUnitTemplates.get_template = function (projectile_template, is_husk)
	-- function 1
	local templates = SingleWeaponUnitTemplates.templates
	local str

	if is_husk == true then
		str = "husk"

		goto label_1_0
	end

	if is_husk == false then
		str = "unit"

		goto label_1_0
	end

	str = nil

	local husk_key = str

	do
		local var_1_1
	end

	::label_1_0::

	if husk_key then
		var_1_1 = templates[projectile_template][husk_key]

		if not var_1_1 then
			-- Nothing
		end
	end

	var_1_1 = templates[projectile_template]

	local template = var_1_1

	::label_1_1::

	return template
end
