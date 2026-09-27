-- chunkname: @scripts/settings/breeds/breed_skaven_dummy_clan_rat.lua

local tbl = {
	not_bot_target = true,
	horde_behavior = "SET_TO_NIL",
	target_selection = "pick_no_targets",
	behavior = "dummy_clan_rat",
	horde_target_selection = "SET_TO_NIL",
	passive_in_patrol = false,
	race = "skaven",
	no_autoaim = true,
	perception = "perception_no_seeing",
	debug_spawn_category = "Misc"
}

for k, v in pairs(Breeds.skaven_clan_rat) do
	local var_0_1 = tbl[k]

	if var_0_1 == "SET_TO_NIL" then
		tbl[k] = nil
	elseif var_0_1 ~= nil then
		tbl[k] = var_0_1
	else
		tbl[k] = v
	end
end

Breeds.skaven_dummy_clan_rat = table.create_copy(Breeds.skaven_dummy_clan_rat, tbl)
Breeds.skaven_dummy_clan_rat.is_always_spawnable = nil

local tbl_2 = {}

for k_2, v_2 in pairs(BreedActions.skaven_clan_rat) do
	local var_0_3 = tbl_2[k_2]

	if var_0_3 == "SET_TO_NIL" then
		tbl_2[k_2] = nil
	elseif var_0_3 ~= nil then
		tbl_2[k_2] = var_0_3
	else
		tbl_2[k_2] = v_2
	end
end

BreedActions.skaven_dummy_clan_rat = table.create_copy(BreedActions.skaven_dummy_clan_rat, tbl_2)
