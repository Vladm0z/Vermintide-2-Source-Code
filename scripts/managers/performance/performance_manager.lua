-- chunkname: @scripts/managers/performance/performance_manager.lua

PerformanceManager = class(PerformanceManager)

PerformanceManager.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._gui = arg_1_1
	self._is_server = arg_1_2
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
		local resolution, var_1_1 = Gui.resolution()

		for k, v in pairs(self._settings) do
			local text_extents, var_1_3 = Gui.text_extents(arg_1_1, self._num_ai_string, v.font, v.size, v.material)
			local floor = math.floor((resolution + text_extents.x - var_1_3.x) * 0.5)
			local num = var_1_1 - v.distance_from_top
			local num_2 = 999

			v.position:store(floor, num, num_2)
		end
	end

	self._events = {
		ai_unit_activated = "event_ai_unit_activated",
		ai_unit_despawned = "event_ai_unit_despawned",
		ai_unit_deactivated = "event_ai_unit_deactivated",
		ai_unit_spawned = "event_ai_unit_spawned"
	}

	local event = Managers.state.event

	for k_2, v_2 in pairs(self._events) do
		event:register(self, k_2, v_2)
	end

	local var_1_8 = LevelSettings[arg_1_3]
	local flag = not var_1_8 and var_1_8.performance
	local allowed_active

	if not flag then
		allowed_active = flag.allowed_active

		if not allowed_active then
			-- Nothing
		end
	end

	allowed_active = 40

	::label_1_0::

	self._allowed_active = allowed_active

	local allowed_spawned

	if not flag then
		allowed_spawned = flag.allowed_spawned

		if not allowed_spawned then
			-- Nothing
		end
	end

	allowed_spawned = 75

	::label_1_1::

	self._allowed_spawned = allowed_spawned
	self._activated_per_breed = {}

	for k_3, v_3 in pairs(Breeds) do
		self._activated_per_breed[k_3] = 0
	end
end

PerformanceManager.update = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

PerformanceManager.event_ai_unit_spawned = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not self._tracked_ai_breeds[arg_3_2] then
		return
	end

	if arg_3_3 ~= Managers.state.conflict.default_enemy_side_id then
		return
	end

	self._num_ai_spawned = self._num_ai_spawned + 1

	if not arg_3_4 then
		self._num_event_ai_spawned = self._num_event_ai_spawned + 1
	end
end

PerformanceManager.event_ai_unit_activated = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	self._activated_per_breed[arg_4_2] = self._activated_per_breed[arg_4_2] + 1

	if not self._tracked_ai_breeds[arg_4_2] then
		return
	end

	self._num_ai_active = self._num_ai_active + 1

	if not arg_4_3 then
		self._num_event_ai_active = self._num_event_ai_active + 1
	end
end

PerformanceManager.event_ai_unit_deactivated = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	self._activated_per_breed[arg_5_2] = self._activated_per_breed[arg_5_2] - 1

	if not self._tracked_ai_breeds[arg_5_2] then
		return
	end

	self._num_ai_active = self._num_ai_active - 1

	if not arg_5_3 then
		self._num_event_ai_active = self._num_event_ai_active - 1
	end
end

PerformanceManager.event_ai_unit_despawned = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not self._tracked_ai_breeds[arg_6_2] then
		return
	end

	if arg_6_3 ~= Managers.state.conflict.default_enemy_side_id then
		return
	end

	self._num_ai_spawned = self._num_ai_spawned - 1

	if not arg_6_4 then
		self._num_event_ai_spawned = self._num_event_ai_spawned - 1
	end
end

PerformanceManager.num_active_enemies = function (self)
	-- function 7
	return self._num_ai_active
end

PerformanceManager.num_active_enemies_of_breed = function (self, arg_8_1)
	-- function 8
	return self._activated_per_breed[arg_8_1]
end

PerformanceManager.activated_per_breed = function (self)
	-- function 9
	return self._activated_per_breed
end

PerformanceManager.destroy = function (self)
	-- function 10
	local event = Managers.state.event

	for k, v in pairs(self._events) do
		event:unregister(k, self)
	end
end
