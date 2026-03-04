-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_ratling_gunner_behavior.lua

local var_0_0 = BreedActions.skaven_ratling_gunner

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
		action_data = var_0_0.stagger
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
			action_data = var_0_0.smash_door
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
				action_data = var_0_0.move_to_players
			},
			{
				"BTSequence",
				{
					"BTRatlingGunnerApproachAction",
					name = "lurk",
					action_data = var_0_0.lurk
				},
				{
					"BTRatlingGunnerApproachAction",
					name = "engage",
					action_data = var_0_0.engage
				},
				name = "skulk_movement"
			},
			name = "movement_method"
		},
		{
			"BTRatlingGunnerWindUpAction",
			name = "wind_up_ratling_gun",
			action_data = var_0_0.wind_up_ratling_gun
		},
		{
			"BTRatlingGunnerShootAction",
			name = "shoot_ratling_gun",
			action_data = var_0_0.shoot_ratling_gun
		},
		{
			"BTRatlingGunnerMoveToShootAction",
			name = "move_to_shoot_position",
			action_data = var_0_0.move_to_shoot_position
		},
		name = "attack_pattern"
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "skaven_ratling_gunner"
}
