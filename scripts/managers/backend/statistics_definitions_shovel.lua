-- chunkname: @scripts/managers/backend/statistics_definitions_shovel.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"shovel_sac_vent",
	"shovel_sac_low",
	"shovel_fast_generate",
	"shovel_command_elite",
	"shovel_skeleton_attack_big",
	"shovel_skeleton_defend",
	"shovel_many_skeletons",
	"shovel_melee_balefire",
	"shovel_fast_staff_attack",
	"shovel_staff_balefire",
	"shovel_big_suck",
	"shovel_big_cleave",
	"shovel_headshot_scythe",
	"shovel_staff_gandalf",
	"shovel_skeleton_balefire",
	"shovel_keep_skeletons_alive"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
