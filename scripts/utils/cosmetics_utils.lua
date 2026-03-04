-- chunkname: @scripts/utils/cosmetics_utils.lua

CosmeticsUtils = {}

CosmeticsUtils.retrieve_skin_packages = function (arg_1_0, arg_1_1)
	local var_1_0 = Cosmetics[arg_1_0]

	if not var_1_0 then
		return {}
	end

	local var_1_1

	if arg_1_1 then
		var_1_1 = {
			var_1_0.first_person,
			var_1_0.first_person_bot,
			var_1_0.third_person,
			var_1_0.third_person_bot,
			var_1_0.first_person_attachment.unit,
			var_1_0.third_person_attachment.unit
		}
	else
		var_1_1 = {
			var_1_0.third_person_husk,
			var_1_0.third_person_attachment.unit
		}
	end

	local var_1_2 = var_1_0.material_changes

	if var_1_2 then
		var_1_1[#var_1_1 + 1] = var_1_2.package_name
	end

	return var_1_1
end

CosmeticsUtils.retrieve_skin_packages_for_preview = function (arg_2_0)
	local var_2_0 = Cosmetics[arg_2_0]

	if not var_2_0 then
		return {}
	end

	local var_2_1 = {
		var_2_0.third_person,
		var_2_0.third_person_bot,
		var_2_0.third_person_attachment.unit
	}
	local var_2_2 = var_2_0.material_changes

	if var_2_2 then
		var_2_1[#var_2_1 + 1] = var_2_2.package_name
	end

	return var_2_1
end

CosmeticsUtils.get_third_person_mesh_unit = function (arg_3_0)
	if not ALIVE[arg_3_0] then
		return nil
	end

	local var_3_0 = ScriptUnit.has_extension(arg_3_0, "cosmetic_system")

	return var_3_0 and var_3_0:get_third_person_mesh_unit()
end

local var_0_0 = Unit.flow_event

CosmeticsUtils.flow_event_mesh_3p = function (arg_4_0, arg_4_1)
	local var_4_0 = CosmeticsUtils.get_third_person_mesh_unit(arg_4_0)

	if var_4_0 then
		var_0_0(var_4_0, arg_4_1)
	end
end
