-- chunkname: @scripts/settings/dlcs/morris/morris_sound_settings.lua

require("levels/honduras_dlcs/morris/deus_level_settings")

local morris = DLCSettings.morris

morris.blocked_auto_load_files = {
	morris_hub = true
}
morris.dialogue_lookup = {
	"dialogues/generated/lookup_hero_conversations_dlc_morris_introspect",
	"dialogues/generated/lookup_hero_conversations_dlc_morris_level_banter",
	"dialogues/generated/lookup_hero_conversations_dlc_morris_level_banter_branched",
	"dialogues/generated/lookup_hero_conversations_dlc_morris_level_banter_themed",
	"dialogues/generated/lookup_hero_conversations_dlc_morris_ingame",
	"dialogues/generated/lookup_hero_conversations_dlc_morris_map",
	"dialogues/generated/lookup_hero_conversations_dlc_morris_extras",
	"dialogues/generated/lookup_hub_conversations_morris"
}
morris.network_sound_events = {
	"Play_curse_egg_of_tzeentch_alert_low",
	"Play_curse_egg_of_tzeentch_alert_medium",
	"Play_curse_egg_of_tzeentch_alert_high",
	"Play_curse_egg_of_tzeentch_alert_egg_destroyed",
	"Play_blessing_challenge_of_grimnir_activate",
	"Play_blessing_of_isha_activate",
	"morris_bolt_of_change_laughter",
	"hud_morris_currency_added",
	"hud_morris_world_map_token_move",
	"hud_morris_world_map_level_chosen",
	"hud_morris_map_shrine_open",
	"player_combat_weapon_bw_deus_01_fireball_fire",
	"player_combat_weapon_bw_deus_01_magma_fire",
	"player_combat_weapon_bw_deus_01_charge_husk",
	"stop_player_combat_weapon_bw_deus_01_charge_husk",
	"morris_power_ups_lightning_strike",
	"morris_power_ups_clone_medkit",
	"morris_power_ups_clone_potion",
	"morris_power_ups_clone_grenade",
	"morris_power_ups_ammo_explosion",
	"morris_power_ups_extra_damage",
	"Play_potion_morris_drink_addon",
	"Play_potion_morris_effect_end",
	"morris_power_ups_drop_coins",
	"morris_power_ups_exploding_enemy",
	"hud_player_buff_regen_health",
	"Play_magic_shield_activate",
	"magic_shield_activate_fast",
	"hud_gameplay_stance_ninjafencer_buff",
	"hud_gameplay_stance_linesman_buff"
}
morris.dialogue_events = {
	"blessing_rally_flag_placed",
	"on_holy_grenade",
	"curse_positive_effect_happened",
	"curse_damage_taken"
}
morris.dialogue_event_data_lookup = {}
morris.dialogue_settings = {
	dlc_morris_map = {
		"dialogues/generated/hero_conversations_dlc_morris_map"
	},
	morris_hub = {
		"dialogues/generated/hub_conversations",
		"dialogues/generated/dlc_cog",
		"dialogues/generated/fleur_conversations",
		"dialogues/generated/hub_conversations_morris"
	}
}

local str = "dialogues/generated/lookup_hero_conversations_dlc_morris_"
local str_2 = "dialogues/generated/hero_conversations_dlc_morris_"

for k, v in pairs(DEUS_LEVEL_SETTINGS) do
	local base_level_name = v.base_level_name
	local format = string.format("%s%s", str, base_level_name)

	if not table.contains(morris.dialogue_lookup, format) then
		morris.dialogue_lookup[#morris.dialogue_lookup + 1] = format
	end

	for i, v_2 in ipairs(v.themes) do
		for i_2, v_3 in ipairs(v.paths) do
			local format_2 = string.format("%s_%s_path%s", k, v_2, v_3)
			local format_3 = string.format("%s%s", str_2, base_level_name)

			morris.dialogue_settings[format_2] = {
				"dialogues/generated/hero_conversations_dlc_morris_introspect",
				"dialogues/generated/hero_conversations_dlc_morris_level_banter",
				"dialogues/generated/hero_conversations_dlc_morris_level_banter_branched",
				"dialogues/generated/hero_conversations_dlc_morris_level_banter_themed",
				"dialogues/generated/hero_conversations_dlc_morris_ingame",
				"dialogues/generated/hero_conversations_dlc_morris_extras",
				"dialogues/generated/hero_conversations_dlc_cowbell_ingame",
				"dialogues/generated/hero_conversations_dlc_cowbell_banter",
				format_3
			}
		end
	end
end
