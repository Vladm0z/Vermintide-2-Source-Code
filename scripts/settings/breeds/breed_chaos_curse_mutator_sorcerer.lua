-- chunkname: @scripts/settings/breeds/breed_chaos_curse_mutator_sorcerer.lua

require("scripts/settings/breeds/breed_chaos_mutator_sorcerer")

local var_0_0 = table.clone(Breeds.chaos_mutator_sorcerer)

var_0_0.unit_template = "ai_unit_curse_corruptor_sorcerer"
var_0_0.behavior = "curse_mutator_sorcerer"
Breeds.curse_mutator_sorcerer = table.create_copy(Breeds.curse_mutator_sorcerer, var_0_0)

local var_0_1 = table.clone(BreedActions.chaos_mutator_sorcerer)

var_0_1.grab_attack.grab_delay = 2
var_0_1.follow.fast_move_speed = 0.5
var_0_1.follow.slow_move_speed = 3
BreedActions.curse_mutator_sorcerer = table.create_copy(BreedActions.curse_mutator_sorcerer, var_0_1)
