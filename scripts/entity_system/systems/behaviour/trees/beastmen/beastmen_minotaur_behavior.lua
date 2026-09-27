-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_minotaur_behavior.lua

local beastmen_minotaur = BreedActions.beastmen_minotaur

BreedBehaviors.minotaur = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
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
			name = "climb",
			condition = "at_climb_smartobject",
			action_data = beastmen_minotaur.climb
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
			action_data = beastmen_minotaur.smash_door
		},
		condition = "ratogre_at_smartobject",
		name = "smartobject"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = beastmen_minotaur.stagger
	},
	{
		"BTSelector",
		{
			"BTUtilityNode",
			{
				"BTBossFollowAction",
				name = "follow",
				action_data = beastmen_minotaur.follow
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "headbutt_attack",
				action_data = beastmen_minotaur.headbutt_attack
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "melee_shove",
				action_data = beastmen_minotaur.melee_shove
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "combo_attack",
				action_data = beastmen_minotaur.combo_attack
			},
			{
				"BTChargeAttackAction",
				name = "charge_attack",
				action_data = beastmen_minotaur.charge_attack
			},
			condition = "ratogre_target_reachable",
			name = "in_combat"
		},
		{
			"BTTargetUnreachableAction",
			name = "target_unreachable",
			action_data = beastmen_minotaur.target_unreachable
		},
		condition = "can_see_player",
		name = "has_target"
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "minotaur"
}
