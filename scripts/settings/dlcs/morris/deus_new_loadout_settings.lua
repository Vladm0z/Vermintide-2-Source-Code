-- chunkname: @scripts/settings/dlcs/morris/deus_new_loadout_settings.lua

local DeusNewLoadoutSettings = DeusNewLoadoutSettings

DeusNewLoadoutSettings = not not DeusNewLoadoutSettings or not not {
	coin_formula = function (progress)
		-- function 1
		return math.round(progress * 600)
	end
}
DeusNewLoadoutSettings = DeusNewLoadoutSettings
