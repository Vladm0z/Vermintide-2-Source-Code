-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_dummy_behavior.lua

local beastmen_gor = BreedActions.beastmen_gor

BreedBehaviors.beastmen_dummy = {
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
		"BTIdleAction",
		name = "idle",
		condition = "no_target",
		action_data = beastmen_gor.dummy_idle
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "beastmen_dummy"
}
