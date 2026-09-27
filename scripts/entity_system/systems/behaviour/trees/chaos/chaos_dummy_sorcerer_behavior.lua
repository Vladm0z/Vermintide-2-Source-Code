-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_dummy_sorcerer_behavior.lua

local chaos_dummy_sorcerer = BreedActions.chaos_dummy_sorcerer

BreedBehaviors.dummy_sorcerer = {
	"BTSelector",
	{
		"BTTentacleSpawnAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTDummyIdleAction",
		enter_hook = "sorcerer_dummy_idle",
		name = "idle",
		action_data = chaos_dummy_sorcerer.idle
	},
	name = "chaos_dummy_sorcerer"
}
