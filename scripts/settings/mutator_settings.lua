-- chunkname: @scripts/settings/mutator_settings.lua

require("scripts/helpers/mutator_utils")

local tbl = {
	"no_ammo",
	"no_pickups",
	"player_dot",
	"instant_death",
	"whiterun",
	"no_respawn",
	"elite_run",
	"specials_frequency",
	"more_specials",
	"same_specials",
	"big_specials",
	"elite_specials",
	"gutter_runner_mayhem",
	"chaos_warriors_trickle",
	"mixed_horde",
	"multiple_bosses",
	"hordes_galore",
	"powerful_elites",
	"shared_health_pool",
	"high_intensity",
	"wave_of_plague_monks",
	"wave_of_berzerkers",
	"night_mode",
	"life",
	"metal",
	"heavens",
	"light",
	"shadow",
	"fire",
	"death",
	"beasts",
	"twitch_darkness"
}

DLCUtils.append("mutators", tbl)

local tbl_2 = {}

for i = 1, #tbl do
	local var_0_2 = tbl[i]
	local format = string.format("scripts/settings/mutators/mutator_%s", var_0_2)

	tbl_2[var_0_2] = local_require(format), fassert(tbl_2[var_0_2] == nil, "Error! Trying to add mutator settings for %s twice!", var_0_2)
end

return tbl_2
