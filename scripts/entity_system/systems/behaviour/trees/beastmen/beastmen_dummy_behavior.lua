-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_dummy_behavior.lua

local var_0_0 = BreedActions.beastmen_gor

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
		action_data = var_0_0.dummy_idle
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "beastmen_dummy"
}
