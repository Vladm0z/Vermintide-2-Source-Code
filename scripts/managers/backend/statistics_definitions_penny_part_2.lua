-- chunkname: @scripts/managers/backend/statistics_definitions_penny_part_2.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"penny_portals_grapes",
	"penny_portals_coop",
	"penny_portals_templerun",
	"penny_portals_careful",
	"penny_bastion_journal",
	"penny_bastion_overstay",
	"penny_bastion_sprinter",
	"penny_bastion_yorick",
	"penny_bastion_torch"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
