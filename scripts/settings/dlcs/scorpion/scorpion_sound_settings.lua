-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_sound_settings.lua

local var_0_0 = DLCSettings.scorpion

var_0_0.dialogue_lookup = {
	"dialogues/generated/lookup_winds_intro_metal",
	"dialogues/generated/lookup_winds_intro_shadow",
	"dialogues/generated/lookup_winds_intro_beasts",
	"dialogues/generated/lookup_winds_intro_death",
	"dialogues/generated/lookup_winds_intro_fire",
	"dialogues/generated/lookup_winds_intro_heavens",
	"dialogues/generated/lookup_winds_intro_life",
	"dialogues/generated/lookup_winds_intro_light"
}
var_0_0.network_sound_events = {
	"Play_winds_heavens_gameplay_spawn",
	"Play_winds_heavens_gameplay_lock",
	"Play_winds_heavens_gamepay_charge",
	"Play_winds_heavens_gameplay_hit",
	"Play_winds_life_gameplay_thorn_grow",
	"Play_winds_life_gameplay_thorn_hit_player",
	"Play_wind_light_beacon_pulse",
	"Play_wind_light_beacon_cleanse_loop",
	"Stop_wind_light_beacon_cleanse_loop",
	"Play_winds_beast_totem_loop",
	"Play_winds_beast_totem_destroy",
	"Play_winds_beast_totem_hit",
	"Play_winds_shadow_reveal_enemy",
	"Play_winds_fire_gameplay_charge",
	"Play_winds_fire_gameplay_explosion",
	"Play_winds_fire_gameplay_plant",
	"Play_winds_fire_gameplay_warning",
	"Stop_winds_fire_gameplay_charge",
	"Stop_winds_fire_gameplay_warning",
	"Play_winds_death_gameplay_spirit_release",
	"Play_winds_death_gameplay_spirit_loop",
	"Play_winds_death_gameplay_spirit_explode",
	"Play_wind_metal_gameplay_mutator_wind_loop",
	"Stop_wind_metal_gameplay_mutator_wind_loop",
	"Play_wind_metal_gameplay_mutator_wind_hit",
	"Play_hud_wind_collect_essence",
	"Play_hud_wind_collect_essence_chunk",
	"Play_hud_wind_objective_start",
	"Play_winds_gameplay_capture_loop",
	"Stop_winds_gameplay_capture_loop",
	"Play_winds_gameplay_capture_success",
	"Play_hud_wind_objectives_complete",
	"emitter_rune_activate",
	"hud_text_reveal"
}

local var_0_1 = {
	"alleys",
	"canyon",
	"crater",
	"field",
	"island",
	"mine",
	"pit",
	"river",
	"rubble",
	"swamp",
	"wall",
	"woods"
}
local var_0_2 = {
	"beasts",
	"death",
	"fire",
	"heavens",
	"life",
	"light",
	"metal",
	"shadow"
}
local var_0_3 = "dlc_scorpion_"
local var_0_4 = "dialogues/generated/winds_intro_"

var_0_0.dialogue_settings = {}

for iter_0_0, iter_0_1 in ipairs(var_0_1) do
	for iter_0_2, iter_0_3 in ipairs(var_0_2) do
		local var_0_5 = string.format("%s%s_%s", var_0_3, iter_0_1, iter_0_3)
		local var_0_6 = string.format("%s%s", var_0_4, iter_0_3)

		var_0_0.dialogue_settings[var_0_5] = {
			var_0_6
		}
	end
end
