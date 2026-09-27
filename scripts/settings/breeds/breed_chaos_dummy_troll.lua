-- chunkname: @scripts/settings/breeds/breed_chaos_dummy_troll.lua

local tbl = {
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

for k, v in pairs(Breeds.chaos_troll) do
	local var_0_1 = tbl[k]

	if var_0_1 == "SET_TO_NIL" then
		tbl[k] = nil
	elseif var_0_1 ~= nil then
		tbl[k] = var_0_1
	else
		tbl[k] = v
	end
end

for k_2, v_2 in pairs(tbl) do
	if v_2 == "SET_TO_NIL" then
		tbl[k_2] = nil
	end
end

Breeds.chaos_dummy_troll = tbl

local tbl_2 = {}

for k_3, v_3 in pairs(BreedActions.chaos_troll) do
	local var_0_3 = tbl_2[k_3]

	if var_0_3 == "SET_TO_NIL" then
		tbl_2[k_3] = nil
	elseif var_0_3 ~= nil then
		tbl_2[k_3] = var_0_3
	else
		tbl_2[k_3] = v_3
	end
end

BreedActions.chaos_dummy_troll = table.create_copy(BreedActions.chaos_dummy_troll, tbl_2)
