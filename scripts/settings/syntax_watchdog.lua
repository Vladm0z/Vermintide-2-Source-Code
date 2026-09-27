-- chunkname: @scripts/settings/syntax_watchdog.lua

for k, v in pairs(BossSettings) do
	local boss_events = v.boss_events

	if k ~= "disabled" then
		for k_2 = 1, #boss_events do
			local var_0_1 = boss_events[k_2]
			local var_0_2 = TerrorEventBlueprints[var_0_1]

			var_0_2 = var_0_2 or var_0_1 == "nothing"

			fassert(var_0_2, "BossSettings '%s'.boss_events in conflict_settings.lua, points to a non-existing terror_event '%s'. There is no such event defined in terror_event_blueprints.lua", k, var_0_1)
		end
	end

	local rare_events = v.rare_events

	if k ~= "disabled" then
		for l = 1, #rare_events do
			local var_0_4 = rare_events[l]
			local var_0_5 = TerrorEventBlueprints[var_0_4]

			var_0_5 = var_0_5 or var_0_4 == "nothing"

			fassert(var_0_5, "BossSettings '%s'.rare_events in conflict_settings.lua, points to a non-existing terror_event '%s'. There is no such event defined in terror_event_blueprints.lua", k, var_0_4)
		end
	end
end

for i4 = 1, #BreedPacks do
	local var_0_6 = BreedPacks[i4]

	fassert(var_0_6.pack_type, "BreedPack %d has a missing 'pack_type' field", i4)
	fassert(type(var_0_6.spawn_weight) == "number", "BreedPack %d has a missing/faulty spawn_weight. ('%s') ", i4, tostring(var_0_6.spawn_weight))

	local members = var_0_6.members

	members = not members and type(var_0_6.members) == "table"

	fassert(members, "BreedPack %d is missing table filed 'member'.", i4)
end
