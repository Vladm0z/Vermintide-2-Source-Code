-- chunkname: @scripts/settings/breeds/breed_chaos_curse_mutator_sorcerer.lua

require("scripts/settings/breeds/breed_chaos_mutator_sorcerer")

local clone = table.clone(Breeds.chaos_mutator_sorcerer)

clone.unit_template = "ai_unit_curse_corruptor_sorcerer"
clone.behavior = "curse_mutator_sorcerer"
Breeds.curse_mutator_sorcerer = table.create_copy(Breeds.curse_mutator_sorcerer, clone)

local clone_2 = table.clone(BreedActions.chaos_mutator_sorcerer)

clone_2.grab_attack.grab_delay = 2
clone_2.follow.fast_move_speed = 0.5
clone_2.follow.slow_move_speed = 3
BreedActions.curse_mutator_sorcerer = table.create_copy(BreedActions.curse_mutator_sorcerer, clone_2)
