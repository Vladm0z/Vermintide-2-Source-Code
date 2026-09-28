-- chunkname: @scripts/settings/syntax_watchdog.lua

for name, setting in pairs(BossSettings) do
	local boss_events = setting.boss_events

	if name ~= "disabled" then
		for i = 1, #boss_events do
			local event_name = boss_events[i]
			local var_0_0 = TerrorEventBlueprints[event_name]

			if not var_0_0 then
				-- Nothing
			end

			if event_name ~= "nothing" then
				var_0_0 = false

				goto label_0_0
			end

			var_0_0 = true

			local exists = var_0_0

			::label_0_0::

			fassert(exists, "BossSettings '%s'.boss_events in conflict_settings.lua, points to a non-existing terror_event '%s'. There is no such event defined in terror_event_blueprints.lua", name, event_name)
		end
	end

	local rare_events = setting.rare_events

	if name ~= "disabled" then
		for i = 1, #rare_events do
			local event_name = rare_events[i]
			local var_0_1 = TerrorEventBlueprints[event_name]

			if not var_0_1 then
				-- Nothing
			end

			if event_name ~= "nothing" then
				var_0_1 = false

				goto label_0_1
			end

			var_0_1 = true

			local exists = var_0_1

			::label_0_1::

			fassert(exists, "BossSettings '%s'.rare_events in conflict_settings.lua, points to a non-existing terror_event '%s'. There is no such event defined in terror_event_blueprints.lua", name, event_name)
		end
	end
end

for i = 1, #BreedPacks do
	local pack_data = BreedPacks[i]

	fassert(pack_data.pack_type, "BreedPack %d has a missing 'pack_type' field", i)
	fassert(type(pack_data.spawn_weight) == "number", "BreedPack %d has a missing/faulty spawn_weight. ('%s') ", i, tostring(pack_data.spawn_weight))

	local members = pack_data.members

	if members then
		-- Nothing
	end

	if type(pack_data.members) ~= "table" then
		members = false

		goto label_0_2
	end

	members = true

	local okay = members

	::label_0_2::

	fassert(okay, "BreedPack %d is missing table filed 'member'.", i)
end
