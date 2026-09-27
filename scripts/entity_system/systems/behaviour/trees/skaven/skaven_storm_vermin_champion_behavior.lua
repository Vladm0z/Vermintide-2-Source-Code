-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_storm_vermin_champion_behavior.lua

local skaven_storm_vermin_champion = BreedActions.skaven_storm_vermin_champion

BreedBehaviors.storm_vermin_champion = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
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
			action_data = skaven_storm_vermin_champion.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = skaven_storm_vermin_champion.stagger
	},
	{
		"BTIdleAction",
		name = "defensive_idle",
		condition = "should_defensive_idle",
		action_data = skaven_storm_vermin_champion.defensive_idle
	},
	{
		"BTSelector",
		{
			"BTUtilityNode",
			{
				"BTTargetRageAction",
				name = "turn_to_face_target",
				condition = "target_changed",
				action_data = skaven_storm_vermin_champion.turn_to_face_target
			},
			{
				"BTBossFollowAction",
				name = "follow",
				action_data = skaven_storm_vermin_champion.follow
			},
			{
				"BTChampionAttackAction",
				name = "special_running_attack",
				action_data = skaven_storm_vermin_champion.special_running_attack
			},
			{
				"BTChampionAttackAction",
				name = "special_lunge_attack",
				action_data = skaven_storm_vermin_champion.special_lunge_attack
			},
			{
				"BTRandom",
				action_data = skaven_storm_vermin_champion.special_attack_champion,
				{
					"BTChampionAttackAction",
					name = "special_attack_cleave",
					weight = 1,
					action_data = skaven_storm_vermin_champion.special_attack_cleave
				},
				{
					"BTChampionAttackAction",
					name = "special_attack_sweep_left",
					weight = 0.5,
					action_data = skaven_storm_vermin_champion.special_attack_sweep_left
				},
				{
					"BTChampionAttackAction",
					name = "special_attack_sweep_right",
					weight = 0.5,
					action_data = skaven_storm_vermin_champion.special_attack_sweep_right
				},
				name = "special_attack_champion"
			},
			{
				"BTChampionAttackAction",
				name = "special_attack_spin",
				action_data = skaven_storm_vermin_champion.special_attack_spin
			},
			{
				"BTChampionAttackAction",
				name = "defensive_mode_spin",
				action_data = skaven_storm_vermin_champion.defensive_mode_spin
			},
			{
				"BTChampionAttackAction",
				name = "special_attack_shatter",
				action_data = skaven_storm_vermin_champion.special_attack_shatter
			},
			{
				"BTChampionAttackAction",
				name = "defensive_attack_shatter",
				action_data = skaven_storm_vermin_champion.defensive_attack_shatter
			},
			name = "combat"
		},
		condition = "can_see_player",
		name = "has_target"
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "storm_vermin_champion"
}
