-- chunkname: @scripts/settings/dlcs/woods/woods_unit_extension_templates.lua

local var_0_0

var_0_0 = _G.GameSettingsDevelopment and GameSettingsDevelopment.use_engine_optimized_ai_locomotion and "AILocomotionExtensionC" or "AILocomotionExtension"

return {
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
