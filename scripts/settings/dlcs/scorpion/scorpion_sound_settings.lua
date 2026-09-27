-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_sound_settings.lua

local scorpion = DLCSettings.scorpion

scorpion.dialogue_lookup = {
	"dialogues/generated/lookup_winds_intro_metal",
	"dialogues/generated/lookup_winds_intro_shadow",
	"dialogues/generated/lookup_winds_intro_beasts",
	"dialogues/generated/lookup_winds_intro_death",
	"dialogues/generated/lookup_winds_intro_fire",
	"dialogues/generated/lookup_winds_intro_heavens",
	"dialogues/generated/lookup_winds_intro_life",
	"dialogues/generated/lookup_winds_intro_light"
}
scorpion.network_sound_events = {
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

local tbl = {
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
local tbl_2 = {
	"beasts",
	"death",
	"fire",
	"heavens",
	"life",
	"light",
	"metal",
	"shadow"
}
local str = "dlc_scorpion_"
local str_2 = "dialogues/generated/winds_intro_"

scorpion.dialogue_settings = {}

for i, v in ipairs(tbl) do
	for i_2, v_2 in ipairs(tbl_2) do
		local format = string.format("%s%s_%s", str, v, v_2)
		local format_2 = string.format("%s%s", str_2, v_2)

		scorpion.dialogue_settings[format] = {
			format_2
		}
	end
end
