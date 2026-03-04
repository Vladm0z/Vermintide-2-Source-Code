-- chunkname: @scripts/settings/breeds/breed_chaos_dummy_troll.lua

local var_0_0 = {
	not_bot_target = true,
	no_autoaim = true,
	show_health_bar = false,
	boss = "SET_TO_NIL",
	target_selection = "pick_no_targets",
	passive_in_patrol = false,
	race = "chaos",
	behavior = "dummy_troll",
	perception = "perception_no_seeing",
	is_always_spawnable = "SET_TO_NIL",
	combat_music_state = "no_boss",
	debug_spawn_category = "Misc",
	run_on_spawn = AiBreedSnippets.on_chaos_dummy_troll_spawn,
	run_on_death = AiBreedSnippets.on_chaos_dummy_troll_death,
	run_on_update = AiBreedSnippets.on_chaos_dummy_troll_update,
	run_on_despawn = AiBreedSnippets.on_chaos_dummy_troll_death
}

for iter_0_0, iter_0_1 in pairs(Breeds.chaos_troll) do
	local var_0_1 = var_0_0[iter_0_0]

	if var_0_1 == "SET_TO_NIL" then
		var_0_0[iter_0_0] = nil
	elseif var_0_1 ~= nil then
		var_0_0[iter_0_0] = var_0_1
	else
		var_0_0[iter_0_0] = iter_0_1
	end
end

for iter_0_2, iter_0_3 in pairs(var_0_0) do
	if iter_0_3 == "SET_TO_NIL" then
		var_0_0[iter_0_2] = nil
	end
end

Breeds.chaos_dummy_troll = var_0_0

local var_0_2 = {}

for iter_0_4, iter_0_5 in pairs(BreedActions.chaos_troll) do
	local var_0_3 = var_0_2[iter_0_4]

	if var_0_3 == "SET_TO_NIL" then
		var_0_2[iter_0_4] = nil
	elseif var_0_3 ~= nil then
		var_0_2[iter_0_4] = var_0_3
	else
		var_0_2[iter_0_4] = iter_0_5
	end
end

BreedActions.chaos_dummy_troll = table.create_copy(BreedActions.chaos_dummy_troll, var_0_2)
