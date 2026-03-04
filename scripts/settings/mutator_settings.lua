-- chunkname: @scripts/settings/mutator_settings.lua

require("scripts/helpers/mutator_utils")

local var_0_0 = {
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

DLCUtils.append("mutators", var_0_0)

local var_0_1 = {}

for iter_0_0 = 1, #var_0_0 do
	local var_0_2 = var_0_0[iter_0_0]
	local var_0_3 = string.format("scripts/settings/mutators/mutator_%s", var_0_2)

	var_0_1[var_0_2] = local_require(var_0_3), fassert(var_0_1[var_0_2] == nil, "Error! Trying to add mutator settings for %s twice!", var_0_2)
end

return var_0_1
