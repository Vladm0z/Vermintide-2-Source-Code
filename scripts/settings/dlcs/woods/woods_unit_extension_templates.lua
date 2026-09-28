-- chunkname: @scripts/settings/dlcs/woods/woods_unit_extension_templates.lua

local str

if _G.GameSettingsDevelopment and GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
	str = "AILocomotionExtensionC"

	goto label_0_0
end

str = "AILocomotionExtension"

local ai_locomotion_name = str

::label_0_0::

local unit_extension_templates = {
	thornsister_thorn_wall_unit = {
		go_type = "thornsister_thorn_wall_unit",
		self_owned_extensions = {
			"AreaDamageExtension",
			"ThornSisterWallExtension",
			"BuffExtension",
			"AIUnitFadeExtension",
			"DoorExtension",
			"DynamicUnitSmartObjectExtension",
			"ThornWallHealthExtension",
			"GenericDeathExtension"
		},
		husk_extensions = {
			"AreaDamageExtension",
			"ThornSisterWallExtension",
			"BuffExtension",
			"AIUnitFadeExtension",
			"ThornWallHealthExtension",
			"GenericDeathExtension"
		}
	},
	vortex_unit = {
		go_type = "vortex_unit",
		self_owned_extensions = {
			"SummonedVortexExtension"
		},
		husk_extensions = {
			"SummonedVortexHuskExtension"
		}
	}
}

return unit_extension_templates
