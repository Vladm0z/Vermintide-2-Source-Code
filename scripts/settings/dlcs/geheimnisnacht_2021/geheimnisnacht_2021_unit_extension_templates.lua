-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_unit_extension_templates.lua

return {
	geheimnisnacht_2021_altar = {
		go_type = "geheimnisnacht_2021_altar",
		self_owned_extensions = {
			"GenericUnitInteractableExtension",
			"GenericHealthExtension",
			"GenericHitReactionExtension",
			"GenericDeathExtension",
			"Geheimnisnacht2021AltarExtension"
		},
		husk_extensions = {
			"GenericUnitInteractableExtension",
			"GenericHealthExtension",
			"GenericHitReactionExtension",
			"GenericDeathExtension",
			"Geheimnisnacht2021AltarExtension"
		}
	}
}
