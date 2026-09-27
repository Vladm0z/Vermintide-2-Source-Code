-- chunkname: @scripts/entity_system/systems/sound/sound_sector_system.lua

require("scripts/entity_system/systems/sound/sound_sector_event_templates")

local num = 1
local tbl = {
	"rpc_enemy_has_target"
}

SoundSectorSystem = class(SoundSectorSystem, ExtensionSystemBase)
SoundSectorSystem.system_extensions = {
	"SoundSectorExtension"
}

SoundSectorSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.unit_storage = arg_1_1.unit_storage

	local system_extensions = SoundSectorSystem.system_extensions

	arg_1_1.entity_manager:register_system(self, arg_1_2, system_extensions)

	self.world = arg_1_1.world
	self.wwise_world = Managers.world:wwise_world(self.world)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self._extensions = {}
	self._frozen_extensions = {}
	self._sectors = {}
	self._sector_sound_source_ids = {}
	self._sector_sound_source_units = {}
	self._sector_sound_source_refs = {}
	self._sector_process_index = 0

	for i = 1, num do
		self._sectors[i] = {}

		local spawn_unit = World.spawn_unit(self.world, "units/testunits/camera")

		self._sector_sound_source_units[i] = spawn_unit
	end

	self._events = {
		ai_unit_deactivated = "event_ai_unit_deactivated",
		ai_unit_activated = "event_ai_unit_activated"
	}

	local event = Managers.state.event

	for k, v in pairs(self._events) do
		event:register(self, k, v)
	end
end

SoundSectorSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)

	local event = Managers.state.event

	for k, v in pairs(self._events) do
		event:unregister(k, self)
	end

	local wwise_world = self.wwise_world

	for k_2, v_2 in pairs(self._sector_sound_source_refs) do
		WwiseWorld.destroy_manual_source(wwise_world, k_2)
	end
end

SoundSectorSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local tbl = {}

	ScriptUnit.set_extension(arg_3_2, "sound_sector_system", tbl)

	if arg_3_3 == "SoundSectorExtension" then
		self._extensions[arg_3_2] = tbl

		if not self.camera_unit then
			local local_position = Unit.local_position(self.camera_unit, 0)
			local _calc_unit_sector = self:_calc_unit_sector(local_position, arg_3_2)

			if not _calc_unit_sector then
				self._sectors[_calc_unit_sector][arg_3_2] = arg_3_2
			end

			tbl.sector_index = _calc_unit_sector
		end
	end

	return tbl
end

SoundSectorSystem.extensions_ready = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if arg_4_3 == "SoundSectorExtension" then
		local sector_index = self._extensions[arg_4_2].sector_index

		if not sector_index then
			local extension = ScriptUnit.extension(arg_4_2, "death_system")

			self._sectors[sector_index][arg_4_2] = extension
		end
	end
end

SoundSectorSystem.on_remove_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._frozen_extensions[arg_5_1] = nil

	self:_cleanup_extension(arg_5_1, arg_5_2)
	ScriptUnit.remove_extension(arg_5_1, self.NAME)
end

SoundSectorSystem.on_freeze_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = self._extensions[arg_6_1]

	fassert(var_6_0, "Unit was already frozen.")

	self._frozen_extensions[arg_6_1] = var_6_0

	self:_cleanup_extension(arg_6_1, arg_6_2)
end

SoundSectorSystem._cleanup_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self._extensions[arg_7_1]

	if var_7_0 == nil then
		return
	end

	local sector_index = var_7_0.sector_index

	if not sector_index then
		self._sectors[sector_index][arg_7_1] = nil
	end

	var_7_0.has_target = nil
	self._extensions[arg_7_1] = nil
end

SoundSectorSystem.freeze = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _frozen_extensions = self._frozen_extensions

	if not _frozen_extensions[arg_8_1] then
		return
	end

	local var_8_1 = self._extensions[arg_8_1]

	fassert(var_8_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_8_1, arg_8_2)

	self._extensions[arg_8_1] = nil
	_frozen_extensions[arg_8_1] = var_8_1
end

SoundSectorSystem.unfreeze = function (self, arg_9_1)
	-- function 9
	local var_9_0 = self._frozen_extensions[arg_9_1]

	self._frozen_extensions[arg_9_1] = nil
	self._extensions[arg_9_1] = var_9_0

	if not self.camera_unit then
		local local_position = Unit.local_position(self.camera_unit, 0)
		local _calc_unit_sector = self:_calc_unit_sector(local_position, arg_9_1)

		if not _calc_unit_sector then
			local extension = ScriptUnit.extension(arg_9_1, "death_system")

			self._sectors[_calc_unit_sector][arg_9_1] = extension
		end

		var_9_0.sector_index = _calc_unit_sector
	end
end

SoundSectorSystem.update = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not self.camera_unit then
		return
	end

	local local_position = Unit.local_position(self.camera_unit, 0)

	local_position = not Vector3.is_valid(local_position) and local_position and Vector3(0, 0, 0)

	local _sector_sound_source_ids = self._sector_sound_source_ids

	self:_update_sectors(local_position)

	local _sector_sound_source_units = self._sector_sound_source_units
	local wwise_world = self.wwise_world
	local set_local_position = Unit.set_local_position
	local set_source_parameter = WwiseWorld.set_source_parameter

	self._sector_process_index = 1

	local _sector_process_index = self._sector_process_index

	for k, v in pairs(SoundSectorEventTemplates) do
		local evaluate, var_10_8, var_10_9 = v.evaluate(self._sectors, _sector_process_index, arg_10_2, self._extensions, local_position)
		local str = v.sound_event_start .. _sector_process_index
		local var_10_11 = _sector_sound_source_ids[str]
		local flag = var_10_11 ~= nil

		if not evaluate then
			local var_10_13 = _sector_sound_source_units[_sector_process_index]

			set_local_position(var_10_13, 0, var_10_8)
			set_source_parameter(wwise_world, var_10_11, "enemy_count", var_10_9)

			if not flag then
				self:_play_sector_sound_event(_sector_process_index, str, var_10_9, var_10_8, v.sound_event_start)
			end
		elseif not flag then
			self:_stop_sector_sound_event(_sector_process_index, str, v.sound_event_stop)
		end
	end
end

SoundSectorSystem._update_sectors = function (self, arg_11_1)
	-- function 11
	for k, v in pairs(self._extensions) do
		local _calc_unit_sector = self:_calc_unit_sector(arg_11_1, k)
		local sector_index = v.sector_index

		if sector_index ~= _calc_unit_sector then
			if not sector_index then
				self._sectors[sector_index][k] = nil
			end

			if not _calc_unit_sector then
				local extension = ScriptUnit.extension(k, "death_system")

				self._sectors[_calc_unit_sector][k] = extension
			end

			v.sector_index = _calc_unit_sector
		end
	end
end

SoundSectorSystem._play_sector_sound_event = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local terrain = LevelHelper:current_level_settings().terrain

	terrain = terrain or "city"

	local var_12_1 = self._sector_sound_source_units[arg_12_1]
	local system = Managers.state.entity:system("sound_environment_system")
	local wwise_world = self.wwise_world
	local make_unit_manual_source = WwiseUtils.make_unit_manual_source(wwise_world, var_12_1)

	WwiseWorld.set_switch(wwise_world, "area", terrain, make_unit_manual_source)
	WwiseWorld.trigger_event(wwise_world, arg_12_5, make_unit_manual_source)
	system:register_source_environment_update(make_unit_manual_source, var_12_1)

	self._sector_sound_source_ids[arg_12_2] = make_unit_manual_source

	local _sector_sound_source_refs = self._sector_sound_source_refs
	local var_12_6 = self._sector_sound_source_refs[make_unit_manual_source]

	var_12_6 = var_12_6 or 0
	_sector_sound_source_refs[make_unit_manual_source] = var_12_6 + 1
	self.current_audio_event = arg_12_5
end

SoundSectorSystem._stop_sector_sound_event = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local wwise_world = self.wwise_world
	local var_13_1 = self._sector_sound_source_ids[arg_13_2]

	Managers.state.entity:system("sound_environment_system"):unregister_source_environment_update(var_13_1)
	WwiseWorld.trigger_event(wwise_world, arg_13_3, var_13_1)

	self._sector_sound_source_ids[arg_13_2] = nil

	local _sector_sound_source_refs = self._sector_sound_source_refs

	_sector_sound_source_refs[var_13_1] = _sector_sound_source_refs[var_13_1] - 1

	if _sector_sound_source_refs[var_13_1] <= 0 then
		fassert(_sector_sound_source_refs[var_13_1] == 0, "Sector sound source id [%d] ref count gone negative", var_13_1)

		_sector_sound_source_refs[var_13_1] = nil

		WwiseWorld.destroy_manual_source(wwise_world, var_13_1)
	end
end

local num_2 = 25
local num_3 = 1600

SoundSectorSystem._calc_unit_sector = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	if not Vector3.is_valid(arg_14_1) then
		return false
	end

	local var_14_0 = POSITION_LOOKUP[arg_14_2]
	local distance_squared = Vector3.distance_squared(arg_14_1, var_14_0)

	if not (distance_squared < num_2 or not (distance_squared > num_3)) then
		return false
	else
		return 1
	end
end

SoundSectorSystem.hot_join_sync = function (self, arg_15_1)
	-- function 15
	local _extensions = self._extensions
	local network_transmit = Managers.state.network.network_transmit

	for k, v in pairs(_extensions) do
		if not v.has_target then
			local go_id = self.unit_storage:go_id(k)

			network_transmit:send_rpc("rpc_enemy_has_target", arg_15_1, go_id, true)
		end
	end
end

SoundSectorSystem.local_player_created = function (self, arg_16_1)
	-- function 16
	self.camera_unit = arg_16_1.camera_follow_unit
end

SoundSectorSystem.event_ai_unit_activated = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local go_id = self.unit_storage:go_id(arg_17_1)
	local var_17_1 = self._extensions[arg_17_1]

	if not var_17_1 then
		var_17_1.has_target = true

		Managers.state.network.network_transmit:send_rpc_clients("rpc_enemy_has_target", go_id, true)
	end
end

SoundSectorSystem.event_ai_unit_deactivated = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local go_id = self.unit_storage:go_id(arg_18_1)
	local var_18_1 = self._extensions[arg_18_1]

	if not var_18_1 then
		var_18_1.has_target = false

		Managers.state.network.network_transmit:send_rpc_clients("rpc_enemy_has_target", go_id, false)
	end
end

SoundSectorSystem.rpc_enemy_has_target = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local unit = self.unit_storage:unit(arg_19_2)

	if unit == nil then
		return
	end

	local var_19_1 = self._extensions[unit]

	if not var_19_1 then
		var_19_1.has_target = arg_19_3
	end
end
