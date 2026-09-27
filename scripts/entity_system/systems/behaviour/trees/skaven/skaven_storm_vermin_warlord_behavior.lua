-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_storm_vermin_warlord_behavior.lua

local skaven_storm_vermin_warlord = BreedActions.skaven_storm_vermin_warlord
local tbl = {
	"BTUtilityNode",
	{
		"BTChampionAttackAction",
		name = "defensive_mode_spin",
		condition = "can_see_player",
		action_data = skaven_storm_vermin_warlord.defensive_mode_spin
	},
	condition = "should_be_defensive",
	name = "in_defensive"
}
local tbl_2 = {
	"BTSelector",
	{
		"BTUtilityNode",
		{
			"BTBossFollowAction",
			name = "follow",
			action_data = skaven_storm_vermin_warlord.follow
		},
		{
			"BTMeleeOverlapAttackAction",
			enter_hook = "on_warlord_disable_blocking",
			name = "dual_combo_attack2",
			action_data = skaven_storm_vermin_warlord.dual_combo_attack2
		},
		{
			"BTChampionAttackAction",
			enter_hook = "on_warlord_disable_blocking",
			name = "dual_attack_cleave",
			action_data = skaven_storm_vermin_warlord.dual_attack_cleave
		},
		{
			"BTChampionAttackAction",
			enter_hook = "on_warlord_disable_blocking",
			name = "dual_lunge_attack",
			action_data = skaven_storm_vermin_warlord.dual_lunge_attack
		},
		name = "dual_wield_combat",
		condition = "warlord_dual_wielding",
		enter_hook = "on_warlord_dual_wield"
	},
	{
		"BTUtilityNode",
		{
			"BTSequence",
			action_data = skaven_storm_vermin_warlord.spawn_sequence,
			{
				"BTChampionAttackAction",
				name = "special_attack_spin_pre_spawn",
				action_data = skaven_storm_vermin_warlord.special_attack_spin
			},
			{
				"BTSpawnAllies",
				name = "spawn",
				action_data = skaven_storm_vermin_warlord.spawn_allies
			},
			enter_hook = "warlord_defensive_on_enter",
			name = "spawn_sequence"
		},
		{
			"BTTargetRageAction",
			name = "turn_to_face_target",
			condition = "target_changed",
			action_data = skaven_storm_vermin_warlord.turn_to_face_target
		},
		{
			"BTBossFollowAction",
			name = "follow",
			action_data = skaven_storm_vermin_warlord.follow
		},
		{
			"BTChampionAttackAction",
			name = "special_running_attack",
			action_data = skaven_storm_vermin_warlord.special_running_attack
		},
		{
			"BTChampionAttackAction",
			name = "special_lunge_attack",
			action_data = skaven_storm_vermin_warlord.special_lunge_attack
		},
		{
			"BTRandom",
			action_data = skaven_storm_vermin_warlord.special_attack_champion,
			{
				"BTChampionAttackAction",
				name = "special_attack_cleave",
				weight = 1,
				action_data = skaven_storm_vermin_warlord.special_attack_cleave
			},
			{
				"BTChampionAttackAction",
				name = "special_attack_sweep_left",
				weight = 0.5,
				action_data = skaven_storm_vermin_warlord.special_attack_sweep_left
			},
			{
				"BTChampionAttackAction",
				name = "special_attack_sweep_right",
				weight = 0.5,
				action_data = skaven_storm_vermin_warlord.special_attack_sweep_right
			},
			name = "special_attack_champion"
		},
		{
			"BTChampionAttackAction",
			name = "special_attack_spin",
			action_data = skaven_storm_vermin_warlord.special_attack_spin
		},
		name = "halberd_combat",
		condition = "warlord_halberding",
		enter_hook = "on_warlord_halberd"
	},
	condition = "can_see_player",
	name = "has_target"
}

BreedBehaviors.storm_vermin_warlord = {
	"BTSelector",
	{
		"BTSpawningAction",
		name = "spawn",
		condition = "spawn",
		enter_hook = "on_warlord_disable_blocking"
	},
	{
		"BTSelector",
		action_data = skaven_storm_vermin_warlord.intro_sequence,
		{
			"BTMoveToGoalAction",
			name = "move_to_goal",
			condition = "has_goal_destination",
			action_data = skaven_storm_vermin_warlord.follow
		},
		{
			"BTIdleAction",
			name = "intro_idle",
			action_data = skaven_storm_vermin_warlord.intro_idle
		},
		name = "intro_sequence",
		leave_hook = "on_lord_warlord_intro_leave",
		condition = "lord_intro",
		enter_hook = "on_skaven_warlord_intro_enter"
	},
	{
		"BTSwitchWeaponsAction",
		name = "switch_weapons",
		condition = "switching_weapons",
		action_data = skaven_storm_vermin_warlord.switch_weapons
	},
	{
		"BTJumpToPositionAction",
		name = "jump_to_position",
		condition = "warlord_jump_down",
		action_data = skaven_storm_vermin_warlord.jump_to_position
	},
	{
		"BTFallAction",
		condition = "is_falling",
		name = "falling"
	},
	{
		"BTSelector",
		{
			"BTTeleportAction",
			condition = "at_teleport_smartobject",
			name = "teleport"
		},
		{
			"BTClimbAction",
			condition = "at_climb_smartobject",
			name = "climb"
		},
		{
			"BTJumpAcrossAction",
			condition = "at_jump_smartobject",
			name = "jump_across"
		},
		{
			"BTSmashDoorAction",
			name = "smash_door",
			condition = "at_door_smartobject",
			action_data = skaven_storm_vermin_warlord.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = skaven_storm_vermin_warlord.stagger
	},
	tbl,
	tbl_2,
	{
		"BTIdleAction",
		name = "defensive_idle",
		action_data = skaven_storm_vermin_warlord.defensive_idle
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "storm_vermin_warlord"
}
