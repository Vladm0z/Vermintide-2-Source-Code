-- chunkname: @scripts/unit_extensions/weapons/single_weapon_unit_extension.lua

require("scripts/unit_extensions/weapons/single_weapon_unit_templates")

SingleWeaponUnitExtension = class(SingleWeaponUnitExtension)

function SingleWeaponUnitExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.owner_unit = arg_1_3.owner_unit

	local var_1_0 = arg_1_3.item_template

	arg_1_0.single_weapon_template_name = var_1_0.single_weapon_template_name
	arg_1_0.weapon_template = SingleWeaponUnitTemplates.get_template(arg_1_0.single_weapon_template_name)
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0._weapon_wield = var_1_0 and var_1_0.on_wield
	arg_1_0._weapon_unwield = var_1_0 and var_1_0.on_unwield
	arg_1_0.data = {}
end

function SingleWeaponUnitExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	return
end

function SingleWeaponUnitExtension.has_current_action(arg_3_0)
	return false
end

function SingleWeaponUnitExtension.change_state(arg_4_0, arg_4_1)
	arg_4_0.state = arg_4_1

	arg_4_0.weapon_template[arg_4_1](arg_4_0.world, arg_4_0.unit, arg_4_0.owner_unit, arg_4_0.data)
end

function SingleWeaponUnitExtension.destroy(arg_5_0)
	arg_5_0.weapon_template.destroy(arg_5_0.world, arg_5_0.unit, arg_5_0.owner_unit, arg_5_0.data)
end

function SingleWeaponUnitExtension.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_0.weapon_template.update(arg_6_0.world, arg_6_0.unit, arg_6_0.owner_unit, arg_6_0.data, arg_6_5, arg_6_3)
end

function SingleWeaponUnitExtension.on_wield(arg_7_0, arg_7_1)
	if arg_7_0._weapon_wield then
		arg_7_0._weapon_wield(arg_7_0, arg_7_1)
	end
end

function SingleWeaponUnitExtension.on_unwield(arg_8_0, arg_8_1)
	if arg_8_0._weapon_unwield then
		arg_8_0._weapon_unwield(arg_8_0, arg_8_1)
	end
end
