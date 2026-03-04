-- chunkname: @scripts/settings/mutators/mutator_multiple_bosses.lua

return {
	description = "description_mutator_multiple_bosses",
	icon = "mutator_icon_specials_frequency",
	display_name = "display_name_mutator_multiple_bosses",
	server_initialize_function = function (arg_1_0, arg_1_1)
		CurrentBossSettings.boss_events.event_lookup.event_boss = {
			"boss_event_dual_spawn"
		}
	end,
	update_conflict_settings = function (arg_2_0, arg_2_1)
		CurrentBossSettings.boss_events.event_lookup.event_boss = {
			"boss_event_dual_spawn"
		}
	end
}
