-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_ratling_gunner_behavior.lua

local skaven_ratling_gunner = BreedActions.skaven_ratling_gunner

BreedBehaviors.skaven_ratling_gunner = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTInVortexAction",
		condition = "in_vortex",
		name = "in_vortex"
	},
	{
		"BTFallAction",
		condition = "is_falling",
		name = "falling"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = skaven_ratling_gunner.stagger
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
			action_data = skaven_ratling_gunner.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTSequence",
		{
			"BTSelector",
			{
				"BTMoveToPlayersAction",
				name = "move_to_players",
				condition = "ratling_gunner_skulked_for_too_long",
				action_data = skaven_ratling_gunner.move_to_players
			},
			{
				"BTSequence",
				{
					"BTRatlingGunnerApproachAction",
					name = "lurk",
					action_data = skaven_ratling_gunner.lurk
				},
				{
					"BTRatlingGunnerApproachAction",
					name = "engage",
					action_data = skaven_ratling_gunner.engage
				},
				name = "skulk_movement"
			},
			name = "movement_method"
		},
		{
			"BTRatlingGunnerWindUpAction",
			name = "wind_up_ratling_gun",
			action_data = skaven_ratling_gunner.wind_up_ratling_gun
		},
		{
			"BTRatlingGunnerShootAction",
			name = "shoot_ratling_gun",
			action_data = skaven_ratling_gunner.shoot_ratling_gun
		},
		{
			"BTRatlingGunnerMoveToShootAction",
			name = "move_to_shoot_position",
			action_data = skaven_ratling_gunner.move_to_shoot_position
		},
		name = "attack_pattern"
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "skaven_ratling_gunner"
}
