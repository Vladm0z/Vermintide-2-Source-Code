-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_curse_mutator_sorcerer_behavior.lua

local curse_mutator_sorcerer = BreedActions.curse_mutator_sorcerer

BreedBehaviors.curse_mutator_sorcerer = {
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
		"BTQuickTeleportAction",
		leave_hook = "destroy_unit_leave_hook",
		name = "quick_teleport",
		condition = "quick_teleport",
		action_data = curse_mutator_sorcerer.quick_teleport
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = curse_mutator_sorcerer.stagger
	},
	{
		"BTSelector",
		{
			"BTTeleportAction",
			condition = "at_teleport_smartobject",
			name = "teleport"
		},
		{
			"BTVortexFlyAction",
			condition = "vortex_at_climb_or_jump",
			name = "fly"
		},
		{
			"BTSmashDoorAction",
			name = "smash_door",
			condition = "at_door_smartobject",
			action_data = curse_mutator_sorcerer.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTSequence",
		{
			"BTMutatorSorcererFollowAction",
			name = "follow",
			action_data = curse_mutator_sorcerer.follow
		},
		{
			"BTCorruptorGrabAction",
			enter_hook = "on_skulking_sorcerer_grab",
			name = "attack",
			leave_hook = "mutator_sorcerer_force_teleport",
			action_data = curse_mutator_sorcerer.grab_attack
		},
		condition = "can_see_player",
		name = "in_combat"
	},
	{
		"BTIdleAction",
		name = "idle",
		action_data = curse_mutator_sorcerer.idle
	},
	name = "curse_mutator_sorcerer"
}
