-- chunkname: @scripts/settings/terror_events/terror_events_ground_zero.lua

local var_0_0 = require("scripts/settings/terror_events/terror_event_utils")
local var_0_1 = var_0_0.count_event_breed
local var_0_2 = var_0_0.HARD
local var_0_3 = var_0_0.HARDER
local var_0_4 = {
	gz_elevator_guards = {
		"gz_elevator_guards_a",
		1
	}
}
local var_0_5 = {
	generic_disable_specials = GenericTerrorEvents.generic_disable_specials,
	generic_disable_pacing = GenericTerrorEvents.generic_disable_pacing,
	gz_chaos_boss = {
		{
			"set_master_event_running",
			name = "gz_chaos_boss"
		},
		{
			"disable_kick"
		},
		{
			"spawn_at_raw",
			spawner_id = "warcamp_chaos_boss",
			breed_name = "chaos_exalted_sorcerer"
		},
		{
			"continue_when",
			condition = function (arg_1_0)
				return var_0_1("chaos_exalted_sorcerer") == 1
			end
		},
		{
			"continue_when",
			condition = function (arg_2_0)
				return var_0_1("chaos_exalted_sorcerer") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "gz_chaos_boss_dead"
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	},
	gz_elevator_guards_a = {
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_3",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_4",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_storm_vermin_commander",
			spawner_id = "ele_guard_a_5",
			difficulty_requirement = var_0_2
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_storm_vermin_commander",
			spawner_id = "ele_guard_a_6",
			difficulty_requirement = var_0_3
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_1",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_2",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_3",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_4",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_5",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_6",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_7",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_8",
			breed_name = "skaven_clan_rat"
		},
		{
			"delay",
			duration = 5
		}
	}
}

return {
	var_0_5,
	var_0_4
}
