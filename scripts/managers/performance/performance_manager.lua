-- chunkname: @scripts/managers/performance/performance_manager.lua

PerformanceManager = class(PerformanceManager)

PerformanceManager.init = function (self, gui, is_server, level_key)
	-- function 1
	self._gui = gui
	self._is_server = is_server
	self._tracked_ai_breeds = {
		chaos_raider = true,
		skaven_plague_monk = true,
		skaven_storm_vermin_with_shield = true,
		beastmen_bestigor = true,
		chaos_berzerker = true,
		skaven_clan_rat_with_shield = true,
		chaos_bulwark = true,
		chaos_marauder_with_shield = true,
		chaos_fanatic = true,
		skaven_slave = true,
		skaven_clan_rat = true,
		beastmen_ungor = true,
		chaos_warrior = true,
		beastmen_ungor_archer = true,
		skaven_storm_vermin_commander = true,
		skaven_storm_vermin = true,
		beastmen_gor = true,
		chaos_marauder = true
	}
	self._num_ai_spawned = 0
	self._num_ai_active = 0
	self._num_event_ai_spawned = 0
	self._num_event_ai_active = 0
	self._num_ai_string = "SPAWNED: %3i   ACTIVE: %3i   EVENT SPAWNED: %3i   EVENT SPAWNED ACTIVE: %3i"
	self._settings = {
		critical = {
			font = "materials/fonts/arial",
			distance_from_top = 60,
			size = 36,
			material = "arial",
			color = ColorBox(255, 255, 0, 0),
			color_to = ColorBox(255, 255, 255, 0),
			position = Vector3Box()
		},
		normal = {
			font = "materials/fonts/arial",
			distance_from_top = 30,
			size = 26,
			material = "arial",
			color = ColorBox(255, 0, 255, 0),
			position = Vector3Box()
		}
	}

	if not DEDICATED_SERVER then
		local w, h = Gui.resolution()

		for _, setting in pairs(self._settings) do
			local min, max = Gui.text_extents(gui, self._num_ai_string, setting.font, setting.size, setting.material)
			local x = math.floor((w + min.x - max.x) * 0.5)
			local y = h - setting.distance_from_top
			local z = 999

			setting.position:store(x, y, z)
		end
	end

	self._events = {
		ai_unit_activated = "event_ai_unit_activated",
		ai_unit_despawned = "event_ai_unit_despawned",
		ai_unit_deactivated = "event_ai_unit_deactivated",
		ai_unit_spawned = "event_ai_unit_spawned"
	}

	local event_manager = Managers.state.event

	for event_name, cb_name in pairs(self._events) do
		event_manager:register(self, event_name, cb_name)
	end

	local level_settings = LevelSettings[level_key]
	local perf = not not level_settings and not not level_settings.performance
	local allowed_active

	if perf then
		allowed_active = perf.allowed_active

		if not allowed_active then
			-- Nothing
		end
	end

	allowed_active = 40

	::label_1_0::

	self._allowed_active = allowed_active

	local allowed_spawned

	if perf then
		allowed_spawned = perf.allowed_spawned

		if not allowed_spawned then
			-- Nothing
		end
	end

	allowed_spawned = 75

	::label_1_1::

	self._allowed_spawned = allowed_spawned
	self._activated_per_breed = {}

	for breed_name, breed in pairs(Breeds) do
		self._activated_per_breed[breed_name] = 0
	end
end

PerformanceManager.update = function (self, dt, t)
	-- function 2
	return
end

PerformanceManager.event_ai_unit_spawned = function (self, unit, breed_name, side_id, event_spawned)
	-- function 3
	if not self._tracked_ai_breeds[breed_name] then
		return
	end

	if side_id ~= Managers.state.conflict.default_enemy_side_id then
		return
	end

	self._num_ai_spawned = self._num_ai_spawned + 1

	if event_spawned then
		self._num_event_ai_spawned = self._num_event_ai_spawned + 1
	end
end

PerformanceManager.event_ai_unit_activated = function (self, unit, breed_name, event_spawned)
	-- function 4
	self._activated_per_breed[breed_name] = self._activated_per_breed[breed_name] + 1

	if not self._tracked_ai_breeds[breed_name] then
		return
	end

	self._num_ai_active = self._num_ai_active + 1

	if event_spawned then
		self._num_event_ai_active = self._num_event_ai_active + 1
	end
end

PerformanceManager.event_ai_unit_deactivated = function (self, unit, breed_name, event_spawned)
	-- function 5
	self._activated_per_breed[breed_name] = self._activated_per_breed[breed_name] - 1

	if not self._tracked_ai_breeds[breed_name] then
		return
	end

	self._num_ai_active = self._num_ai_active - 1

	if event_spawned then
		self._num_event_ai_active = self._num_event_ai_active - 1
	end
end

PerformanceManager.event_ai_unit_despawned = function (self, unit, breed_name, side_id, event_spawned)
	-- function 6
	if not self._tracked_ai_breeds[breed_name] then
		return
	end

	if side_id ~= Managers.state.conflict.default_enemy_side_id then
		return
	end

	self._num_ai_spawned = self._num_ai_spawned - 1

	if event_spawned then
		self._num_event_ai_spawned = self._num_event_ai_spawned - 1
	end
end

PerformanceManager.num_active_enemies = function (self)
	-- function 7
	return self._num_ai_active
end

PerformanceManager.num_active_enemies_of_breed = function (self, breed_name)
	-- function 8
	return self._activated_per_breed[breed_name]
end

PerformanceManager.activated_per_breed = function (self)
	-- function 9
	return self._activated_per_breed
end

PerformanceManager.destroy = function (self)
	-- function 10
	local event_manager = Managers.state.event

	for event_name, cb_name in pairs(self._events) do
		event_manager:unregister(event_name, self)
	end
end
