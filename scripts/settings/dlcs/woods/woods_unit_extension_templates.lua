-- chunkname: @scripts/settings/dlcs/woods/woods_unit_extension_templates.lua

local flag

flag = not _G.GameSettingsDevelopment and not GameSettingsDevelopment.use_engine_optimized_ai_locomotion and "AILocomotionExtensionC" and "AILocomotionExtension"

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
