-- chunkname: @scripts/settings/dlcs/morris/deus_blessing_settings.lua

require("scripts/settings/dlcs/morris/deus_cost_settings")

local NORMAL = 2
local HARD = 3
local HARDER = 4
local HARDEST = 5
local CATACLYSM = 6
local POWER_LEVEL_BONUSES = {
	[NORMAL] = 50,
	[HARD] = 50,
	[HARDER] = 50,
	[HARDEST] = 50,
	[CATACLYSM] = 50
}

DeusBlessingSettings = DeusBlessingSettings
