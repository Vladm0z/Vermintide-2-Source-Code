-- chunkname: @scripts/settings/breeds/breed_skaven_dummy_slave.lua

local var_0_0 = {
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

for iter_0_0, iter_0_1 in pairs(Breeds.skaven_slave) do
	local var_0_1 = var_0_0[iter_0_0]

	if var_0_1 == "SET_TO_NIL" then
		var_0_0[iter_0_0] = nil
	elseif var_0_1 ~= nil then
		var_0_0[iter_0_0] = var_0_1
	else
		var_0_0[iter_0_0] = iter_0_1
	end
end

Breeds.skaven_dummy_slave = table.create_copy(Breeds.skaven_dummy_slave, var_0_0)
Breeds.skaven_dummy_slave.is_always_spawnable = nil

local var_0_2 = {}

for iter_0_2, iter_0_3 in pairs(BreedActions.skaven_dummy_clan_rat) do
	local var_0_3 = var_0_2[iter_0_2]

	if var_0_3 == "SET_TO_NIL" then
		var_0_2[iter_0_2] = nil
	elseif var_0_3 ~= nil then
		var_0_2[iter_0_2] = var_0_3
	else
		var_0_2[iter_0_2] = iter_0_3
	end
end

BreedActions.skaven_dummy_slave = table.create_copy(BreedActions.skaven_dummy_slave, var_0_2)
