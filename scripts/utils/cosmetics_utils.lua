-- chunkname: @scripts/utils/cosmetics_utils.lua

CosmeticsUtils = {}

CosmeticsUtils.retrieve_skin_packages = function (arg_1_0, arg_1_1)
	-- function 1
	local var_1_0 = Cosmetics[arg_1_0]

	if not var_1_0 then
		return {}
	end

	local var_1_1

	if not arg_1_1 then
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

	local material_changes = var_1_0.material_changes

	if not material_changes then
		var_1_1[#var_1_1 + 1] = material_changes.package_name
	end

	return var_1_1
end

CosmeticsUtils.retrieve_skin_packages_for_preview = function (arg_2_0)
	-- function 2
	local var_2_0 = Cosmetics[arg_2_0]

	if not var_2_0 then
		return {}
	end

	local tbl = {
		var_2_0.third_person,
		var_2_0.third_person_bot,
		var_2_0.third_person_attachment.unit
	}
	local material_changes = var_2_0.material_changes

	if not material_changes then
		tbl[#tbl + 1] = material_changes.package_name
	end

	return tbl
end

CosmeticsUtils.get_third_person_mesh_unit = function (arg_3_0)
	-- function 3
	if not ALIVE[arg_3_0] then
		return nil
	end

	local has_extension = ScriptUnit.has_extension(arg_3_0, "cosmetic_system")

	return not has_extension and has_extension:get_third_person_mesh_unit()
end

local flow_event = Unit.flow_event

CosmeticsUtils.flow_event_mesh_3p = function (arg_4_0, arg_4_1)
	-- function 4
	local get_third_person_mesh_unit = CosmeticsUtils.get_third_person_mesh_unit(arg_4_0)

	if not get_third_person_mesh_unit then
		flow_event(get_third_person_mesh_unit, arg_4_1)
	end
end
