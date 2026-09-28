-- chunkname: @scripts/settings/dlcs/morris/deus_meta_progression_settings.lua

require("scripts/settings/dlcs/morris/deus_weapons")

DeusPlayerSetupVersion = 3
DeusStartingMetaProgressionAmount = 0

local DeusRollOverSettings = DeusRollOverSettings

DeusRollOverSettings = not not DeusRollOverSettings or not not {
	roll_over = 0.25,
	max = 200
}
DeusRollOverSettings = DeusRollOverSettings
