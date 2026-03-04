-- chunkname: @scripts/settings/syntax_watchdog.lua

for iter_0_0, iter_0_1 in pairs(BossSettings) do
	local var_0_0 = iter_0_1.boss_events

	if iter_0_0 ~= "disabled" then
		for iter_0_2 = 1, #var_0_0 do
			local var_0_1 = var_0_0[iter_0_2]
			local var_0_2 = TerrorEventBlueprints[var_0_1] or var_0_1 == "nothing"

			fassert(var_0_2, "BossSettings '%s'.boss_events in conflict_settings.lua, points to a non-existing terror_event '%s'. There is no such event defined in terror_event_blueprints.lua", iter_0_0, var_0_1)
		end
	end

	local var_0_3 = iter_0_1.rare_events

	if iter_0_0 ~= "disabled" then
		for iter_0_3 = 1, #var_0_3 do
			local var_0_4 = var_0_3[iter_0_3]
			local var_0_5 = TerrorEventBlueprints[var_0_4] or var_0_4 == "nothing"

			fassert(var_0_5, "BossSettings '%s'.rare_events in conflict_settings.lua, points to a non-existing terror_event '%s'. There is no such event defined in terror_event_blueprints.lua", iter_0_0, var_0_4)
		end
	end
end

for iter_0_4 = 1, #BreedPacks do
	local var_0_6 = BreedPacks[iter_0_4]

	fassert(var_0_6.pack_type, "BreedPack %d has a missing 'pack_type' field", iter_0_4)
	fassert(type(var_0_6.spawn_weight) == "number", "BreedPack %d has a missing/faulty spawn_weight. ('%s') ", iter_0_4, tostring(var_0_6.spawn_weight))

	local var_0_7 = var_0_6.members and type(var_0_6.members) == "table"

	fassert(var_0_7, "BreedPack %d is missing table filed 'member'.", iter_0_4)
end
