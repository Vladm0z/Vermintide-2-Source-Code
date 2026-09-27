-- chunkname: @scripts/entity_system/systems/sound_environment/sound_environment_system.lua

require("scripts/helpers/wwise_utils")

SoundEnvironmentSystem = class(SoundEnvironmentSystem, ExtensionSystemBase)

local tbl = {}
local tbl_2 = {}
local num = 0.5
local num_2 = 1 - num
local num_3 = 1

SoundEnvironmentSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	SoundEnvironmentSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self._highest_prio_system = EngineOptimized.highest_prio_environment_init()

	local world = self.world

	self.wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.reset_aux_environment(self.wwise_world)

	self._environments = {}
	self._fade_environments = {}
	self._current_environment = nil

	local level_key = arg_1_1.startup_data.level_key
	local var_1_2 = LevelSettings[level_key]
	local ambient_sound_event = var_1_2.ambient_sound_event
	local global_environment_fade_time = var_1_2.global_environment_fade_time
	local player_aux_bus_name = var_1_2.player_aux_bus_name
	local environment_state = var_1_2.environment_state

	self:register_sound_environment("global", -1, ambient_sound_event, global_environment_fade_time, player_aux_bus_name, environment_state)
	self:enter_environment(0, "global")

	self._updated_sources = {}
	self._num_sources = 0
	self._current_source_index = 0
	self._check_timer = 0
end

SoundEnvironmentSystem.destroy = function (self)
	-- function 2
	EngineOptimized.highest_prio_environment_destroy(self._highest_prio_system)
end

local tbl_3 = {
	aux_bus_name = "",
	prio = 0,
	fade_time = 0,
	volume_name = "",
	ambient_sound_event_stop = "",
	ambient_sound_event_start = "",
	fade_info = {
		current_value = 0
	}
}

SoundEnvironmentSystem.register_sound_environment = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	fassert(self._environments[arg_3_1] == nil, "Already registered sound environment with name %q", arg_3_1)

	local var_3_0 = self._environments[arg_3_1]

	var_3_0 = var_3_0 or table.clone(tbl_3)
	var_3_0.prio = arg_3_2

	if arg_3_3 ~= "" then
		var_3_0.ambient_sound_event_start = "Play_" .. arg_3_3
		var_3_0.ambient_sound_event_stop = "Stop_" .. arg_3_3
	end

	var_3_0.fade_time = arg_3_4 or 1

	assert(arg_3_5, "Sound environment lacks auxiliary bus")

	var_3_0.player_aux_bus_name = arg_3_5
	var_3_0.source_aux_bus_name = arg_3_5 .. "_source"

	assert(arg_3_6, "Have to set environment state")

	var_3_0.environment_state = arg_3_6
	self._environments[arg_3_1] = var_3_0

	local tbl = {}
	local num = 1

	for k, v in pairs(self._environments) do
		local prio = v.prio

		tbl[num] = {
			p = prio,
			n = k
		}
		num = num + 1
	end

	table.sort(tbl, function (self, arg_4_1)
		-- function 4
		return self.p > arg_4_1.p
	end)

	local tbl_2 = {}
	local num_2 = num - 1

	for k_2 = 1, num_2 do
		tbl_2[k_2] = tbl[k_2].n
	end

	EngineOptimized.highest_prio_environment_reorder(self._highest_prio_system, unpack(tbl_2))
end

SoundEnvironmentSystem._highest_prio_environment_at_position = function (self, arg_5_1)
	-- function 5
	local var_5_0
	local current_level = LevelHelper:current_level(self.world)

	return (EngineOptimized.highest_prio_environment_at_position(self._highest_prio_system, current_level, arg_5_1))
end

SoundEnvironmentSystem.set_source_environment = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not GameSettingsDevelopment.fade_environments then
		return
	end

	if not Vector3.is_valid(arg_6_2) then
		return
	end

	local _highest_prio_environment_at_position = self:_highest_prio_environment_at_position(arg_6_2)
	local _environments = self._environments
	local wwise_world = self.wwise_world
	local source_aux_bus_name = _environments[_highest_prio_environment_at_position or "global"].source_aux_bus_name

	assert(source_aux_bus_name, "No source aux environment in %s", _highest_prio_environment_at_position or "global")
	WwiseWorld.reset_environment_for_source(wwise_world, arg_6_1)
	WwiseWorld.set_environment_for_source(wwise_world, arg_6_1, source_aux_bus_name, num)

	local _fade_environments = self._fade_environments
	local flag = false
	local _current_environment = self._current_environment

	for k, v in pairs(_fade_environments) do
		local var_6_7 = _environments[k]
		local fade_info = var_6_7.fade_info

		WwiseWorld.set_environment(wwise_world, var_6_7.player_aux_bus_name, fade_info.current_value * num_2)

		flag = flag or k == _current_environment
	end

	if not flag then
		local var_6_9 = self._environments[_current_environment]

		WwiseWorld.set_environment(wwise_world, var_6_9.player_aux_bus_name, num_2)
	end

	return source_aux_bus_name
end

SoundEnvironmentSystem.register_source_environment_update = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local _updated_sources = self._updated_sources
	local num = #self._updated_sources + 1
	local tbl = {
		unit = arg_7_2,
		source = arg_7_1
	}
	local node

	if not arg_7_3 then
		node = Unit.node(arg_7_2, arg_7_3)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_7_0::

	tbl.node = node
	_updated_sources[num] = tbl
	self._num_sources = self._num_sources + 1
end

SoundEnvironmentSystem.unregister_source_environment_update = function (self, arg_8_1)
	-- function 8
	local _num_sources = self._num_sources

	for i = 1, _num_sources do
		if self._updated_sources[i].source == arg_8_1 then
			table.remove(self._updated_sources, i)

			local _current_source_index = self._current_source_index

			if i < _current_source_index then
				self._current_source_index = _current_source_index - 1
			end

			self._num_sources = _num_sources - 1

			return
		end
	end
end

local num_4 = 3
local tbl_4 = {}

SoundEnvironmentSystem._update_source_environments = function (self)
	-- function 9
	local _num_sources = self._num_sources
	local min = math.min(_num_sources, num_4)
	local min_2 = math.min(self._current_source_index, _num_sources)
	local _updated_sources = self._updated_sources
	local has_source = WwiseWorld.has_source
	local num = 0

	for i = 1, min do
		min_2 = min_2 % _num_sources + 1

		local var_9_6 = _updated_sources[min_2]
		local source = var_9_6.source

		if not has_source(self.wwise_world, source) then
			local world_position = Unit.world_position(var_9_6.unit, var_9_6.node)
			local set_source_environment = self:set_source_environment(source, world_position)
		else
			tbl_4[#tbl_4 + 1] = source
			num = num + 1
		end
	end

	self._current_source_index = min_2

	for j = 1, num do
		local var_9_10 = tbl_4[j]

		self:unregister_source_environment_update(var_9_10)

		tbl_4[j] = nil
	end
end

SoundEnvironmentSystem.local_player_created = function (self, arg_10_1)
	-- function 10
	self.player = arg_10_1
end

SoundEnvironmentSystem.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if arg_11_2 > self._check_timer then
		self._check_timer = arg_11_2 + 1

		if not self.player then
			return
		end

		local viewport_name = self.player.viewport_name
		local listener_pose = Managers.state.camera:listener_pose(viewport_name)
		local translation = Matrix4x4.translation(listener_pose)
		local _highest_prio_environment_at_position = self:_highest_prio_environment_at_position(translation)

		if not _highest_prio_environment_at_position then
			if _highest_prio_environment_at_position ~= self._current_environment then
				self:enter_environment(arg_11_2, _highest_prio_environment_at_position, self._current_environment)
			end
		elseif self._current_environment ~= "global" then
			self:enter_environment(arg_11_2, "global", self._current_environment)
		end
	end

	if not GameSettingsDevelopment.fade_environments then
		self:_update_fade(arg_11_2)
		self:_update_source_environments()
	end
end

SoundEnvironmentSystem._update_fade = function (self, arg_12_1)
	-- function 12
	local wwise_world = self.wwise_world
	local _environments = self._environments
	local _fade_environments = self._fade_environments

	for k, v in pairs(_fade_environments) do
		local var_12_3 = _environments[k]
		local fade_info = var_12_3.fade_info
		local fade_start = fade_info.fade_start
		local fade_time = fade_info.fade_time
		local num = arg_12_1 - fade_start
		local clamp = math.clamp(num / fade_time, 0, 1)
		local start_value = fade_info.start_value
		local target_value = fade_info.target_value
		local lerp = math.lerp(start_value, target_value, clamp)

		fade_info.current_value = lerp

		WwiseWorld.set_environment(wwise_world, var_12_3.player_aux_bus_name, lerp * num_2)

		if lerp == target_value then
			_fade_environments[k] = nil
		end
	end
end

SoundEnvironmentSystem._add_fade_environment = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local fade_info = self._environments[arg_13_2].fade_info

	fade_info.fade_start = arg_13_1
	fade_info.fade_time = arg_13_3
	fade_info.start_value = fade_info.current_value
	fade_info.target_value = arg_13_4
	self._fade_environments[arg_13_2] = true
end

local num_5 = 3

SoundEnvironmentSystem._clamp_num_fade_environments = function (self)
	-- function 14
	local num = 0
	local var_14_1
	local huge = math.huge

	for k, v in pairs(self._fade_environments) do
		num = num + 1

		local fade_info = self._environments[k].fade_info
		local current_value = fade_info.current_value

		if not (fade_info.target_value ~= 0 or not (current_value < huge)) then
			huge = current_value
			var_14_1 = k
		end
	end

	assert(num <= num_5 + 1, "Too many environments, cleanup failed.")

	if num > num_5 then
		local var_14_5 = self._environments[var_14_1]

		var_14_5.fade_info.current_value = 0
		self._fade_environments[var_14_1] = nil

		WwiseWorld.set_environment(self.wwise_world, var_14_5.player_aux_bus_name, 0)
	end
end

SoundEnvironmentSystem.enter_environment = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local var_15_0 = self._environments[arg_15_2]

	if not GameSettingsDevelopment.fade_environments then
		local fade_time = var_15_0.fade_time
		local fade_info = var_15_0.fade_info

		if fade_info.current_value > 0 then
			fade_time = fade_time * (1 - fade_info.current_value)

			if fade_time < 0.001 then
				fade_time = 0.001
			end
		end

		self:_add_fade_environment(arg_15_1, arg_15_2, fade_time, 1)

		if not arg_15_3 then
			self:_add_fade_environment(arg_15_1, arg_15_3, fade_time, 0)
		end

		self:_clamp_num_fade_environments()
	else
		self:_set_environment(arg_15_2)
	end

	Wwise.set_state("interior_exterior", var_15_0.environment_state)

	local wwise_world = self.wwise_world

	if not arg_15_3 then
		local ambient_sound_event_stop = self._environments[arg_15_3].ambient_sound_event_stop

		if not ambient_sound_event_stop then
			WwiseWorld.trigger_event(wwise_world, ambient_sound_event_stop)
		end
	end

	local ambient_sound_event_start = var_15_0.ambient_sound_event_start

	if not ambient_sound_event_start then
		WwiseWorld.trigger_event(wwise_world, ambient_sound_event_start)
	end

	self._current_environment = arg_15_2
end

SoundEnvironmentSystem._set_environment = function (self, arg_16_1)
	-- function 16
	local wwise_world = self.wwise_world
	local var_16_1 = self._environments[arg_16_1]

	WwiseWorld.reset_aux_environment(wwise_world)
	WwiseWorld.set_environment(wwise_world, var_16_1.player_aux_bus_name, num_3)
end
