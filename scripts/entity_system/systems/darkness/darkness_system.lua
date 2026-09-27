-- chunkname: @scripts/entity_system/systems/darkness/darkness_system.lua

require("scripts/settings/level_settings")

DarknessSystem = class(DarknessSystem, ExtensionSystemBase)

local tbl = {
	"LightSourceExtension",
	"PlayerUnitDarknessExtension",
	"ShadowFlareExtension"
}
local tbl_2 = {
	"rpc_shadow_flare_done"
}

DarknessSystem.DARKNESS_THRESHOLD = 0.025
DarknessSystem.TOTAL_DARKNESS_TRESHOLD = 0.0125

DarknessSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	DarknessSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self._light_source_data = {}
	self._player_unit_darkness_data = {}
	self._screen_fx_name = "fx/screenspace_darkness_flash"

	local darkness_settings = LevelHelper:current_level_settings().darkness_settings

	if not darkness_settings then
		local volumes = darkness_settings.volumes

		fassert(volumes, "Missing volumes table in darkness settings.")

		self._darkness_volumes = volumes
		self._num_volumes = #volumes

		local player_light_intensity = darkness_settings.player_light_intensity

		if not player_light_intensity then
			self:set_player_light_intensity(player_light_intensity)
		end

		if not darkness_settings.disable_screen_fx then
			self._screen_fx_name = nil
		end
	else
		self._num_volumes = 0
	end

	self._in_darkness = false
	self._global_darkness = false
	self._network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl_2))
end

DarknessSystem.set_global_darkness = function (self, arg_2_1)
	-- function 2
	self._global_darkness = arg_2_1
end

DarknessSystem.set_player_light_intensity = function (self, arg_3_1)
	-- function 3
	self._player_light_intensity = arg_3_1
end

DarknessSystem.set_level = function (self, arg_4_1)
	-- function 4
	self._level = arg_4_1
end

DarknessSystem.destroy = function (self)
	-- function 5
	self._environment_handler = nil

	self._network_event_delegate:unregister(self)
end

DarknessSystem.on_add_extension = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if arg_6_3 == "ShadowFlareExtension" then
		return DarknessSystem.super.on_add_extension(self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	end

	local get_data = Unit.get_data(arg_6_2, "light_intensity")
	local tbl = {}
	local intensity

	if not arg_6_4 then
		intensity = arg_6_4.intensity

		if not intensity then
			-- Nothing
		end
	end

	intensity = get_data or 1

	::label_6_0::

	tbl.intensity = intensity

	ScriptUnit.set_extension(arg_6_2, self.name, tbl)

	if arg_6_3 == "LightSourceExtension" then
		self._light_source_data[arg_6_2] = tbl
		POSITION_LOOKUP[arg_6_2] = Unit.world_position(arg_6_2, 0)
	elseif arg_6_3 == "PlayerUnitDarknessExtension" then
		self._player_unit_darkness_data[arg_6_2] = tbl
	end

	return tbl
end

DarknessSystem.on_remove_extension = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	DarknessSystem.super.on_remove_extension(arg_7_0, arg_7_1, arg_7_2)

	if arg_7_2 == "LightSourceExtension" then
		arg_7_0._light_source_data[arg_7_1] = nil
		POSITION_LOOKUP[arg_7_1] = nil
	elseif arg_7_2 == "PlayerUnitDarknessExtension" then
		arg_7_0._player_unit_darkness_data[arg_7_1] = nil
	end
end

DarknessSystem.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local dt = arg_8_1.dt

	if self._darkness_volumes or not self._global_darkness then
		self:_update_light_sources(dt, arg_8_2)
		self:_update_player_unit_darkness(dt, arg_8_2)
		self:_update_darkness_fx(dt, arg_8_2)
	end

	self:_update_shadow_flare_extensions(dt, arg_8_2)
end

DarknessSystem._update_light_sources = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

local var_0_2

LIGHT_LIGHT_VALUE = 0.05

local num = 0.015
local num_2 = 0.15

local function fn(arg_10_0)
	-- function 10
	return (1 - arg_10_0 / num)^2 / 15
end

DarknessSystem._update_player_unit_darkness = function (self, arg_11_1, arg_11_2)
	-- function 11
	for k, v in pairs(self._player_unit_darkness_data) do
		local var_11_0 = POSITION_LOOKUP[k]

		var_11_0 = var_11_0 or Unit.world_position(k, 0)

		local num_3 = var_11_0 + Vector3(0, 0, 1)
		local is_in_darkness_volume = self:is_in_darkness_volume(num_3)
		local var_11_3

		if not is_in_darkness_volume then
			local var_11_4 = Managers.state.side.side_by_unit[k]

			if not var_11_4 then
				local calculate_light_value = self:calculate_light_value(num_3, var_11_4.PLAYER_UNITS)

				if calculate_light_value > LIGHT_LIGHT_VALUE then
					v.intensity = 0
					v.in_darkness = false
				elseif calculate_light_value > num then
					v.intensity = math.auto_lerp(LIGHT_LIGHT_VALUE, num, 0, num_2, calculate_light_value)
					v.in_darkness = true
				else
					v.intensity = math.min(math.max(v.intensity, num_2) + arg_11_1 * fn(calculate_light_value), 1)
					v.in_darkness = true
				end
			end
		else
			v.in_darkness = false
			v.intensity = 0
		end
	end
end

local num_3 = 0

DarknessSystem._update_darkness_fx = function (self, arg_12_1, arg_12_2)
	-- function 12
	local local_player = Managers.player:local_player(1)

	if not local_player then
		local world = self.world
		local observed_unit = local_player:observed_unit()

		if not ALIVE[observed_unit] then
			observed_unit = local_player.player_unit
		end

		local var_12_3 = self._player_unit_darkness_data[observed_unit]
		local flag = not var_12_3 and var_12_3.in_darkness
		local intensity

		if not var_12_3 then
			intensity = var_12_3.intensity

			if not intensity then
				-- Nothing
			end
		end

		intensity = 0

		::label_12_0::

		local wwise_world = Managers.world:wwise_world(world)

		if flag or not self._in_darkness then
			WwiseWorld.trigger_event(wwise_world, "Stop_music_darkness_will_take_you", num_3)

			self._in_darkness = false

			WwiseWorld.set_source_parameter(wwise_world, num_3, "darkness_intensity", 0)

			local _screen_fx_id = self._screen_fx_id

			if not _screen_fx_id then
				World.destroy_particles(world, _screen_fx_id)
			end
		elseif not (not flag and self._in_darkness) then
			WwiseWorld.trigger_event(wwise_world, "Play_music_darkness_will_take_you", num_3)

			self._in_darkness = true

			WwiseWorld.set_source_parameter(wwise_world, num_3, "darkness_intensity", intensity * 100)

			local _screen_fx_name = self._screen_fx_name

			if not _screen_fx_name then
				local create_particles = World.create_particles(world, _screen_fx_name, Vector3.zero())
				local str = "overlay"
				local str_2 = "intensity"

				World.set_particles_material_scalar(world, create_particles, str, str_2, intensity)

				self._screen_fx_id = create_particles
			end
		elseif not flag then
			WwiseWorld.set_source_parameter(wwise_world, num_3, "darkness_intensity", intensity * 100)

			local _screen_fx_id_2 = self._screen_fx_id

			if not _screen_fx_id_2 then
				local str_3 = "overlay"
				local str_4 = "intensity"

				World.set_particles_material_scalar(world, _screen_fx_id_2, str_3, str_4, intensity)
			end
		end
	end
end

DarknessSystem.is_in_darkness_volume = function (self, arg_13_1)
	-- function 13
	if not self._global_darkness then
		return true
	end

	local _darkness_volumes = self._darkness_volumes

	if not _darkness_volumes then
		local is_point_inside_volume = Level.is_point_inside_volume
		local _level = self._level

		for i = 1, self._num_volumes do
			local var_13_3 = _darkness_volumes[i]

			if not is_point_inside_volume(_level, var_13_3, arg_13_1) then
				return true
			end
		end
	end

	return false
end

DarknessSystem.calculate_light_value = function (self, arg_14_1, arg_14_2)
	-- function 14
	local num = 0

	for k, v in pairs(self._light_source_data) do
		local var_14_1 = POSITION_LOOKUP[k]
		local max = math.max(Vector3.distance_squared(arg_14_1, var_14_1), 1)

		num = num + v.intensity * (1 / max)
	end

	local _player_light_intensity = self._player_light_intensity

	if not self._player_light_intensity then
		local huge = math.huge

		for k_2 = 1, #arg_14_2 do
			local var_14_5 = arg_14_2[k_2]
			local var_14_6 = POSITION_LOOKUP[var_14_5]
			local max_2 = math.max(Vector3.distance_squared(var_14_6, arg_14_1), 1)

			if max_2 < huge then
				huge = max_2
			end
		end

		num = num + _player_light_intensity * (1 / huge)
	end

	return num
end

DarknessSystem.is_in_darkness = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self:is_in_darkness_volume(arg_15_1) then
		return false
	end

	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	return self:calculate_light_value(arg_15_1, get_side_from_name.PLAYER_UNITS) < (arg_15_2 or DarknessSystem.DARKNESS_THRESHOLD)
end

DarknessSystem._update_shadow_flare_extensions = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local get_entities = Managers.state.entity:get_entities("ShadowFlareExtension")

	for k, v in pairs(get_entities) do
		v:update(k, arg_16_1)
	end
end

DarknessSystem.remove_mutator_torches = function (self)
	-- function 17
	local player_unit = Managers.player:local_player().player_unit
	local _light_source_data = self._light_source_data

	if not Managers.player.is_server then
		Managers.state.entity:system("pickup_system"):disable_teleporting_pickups()

		for k, v in pairs(_light_source_data) do
			local has_extension = ScriptUnit.has_extension(k, "pickup_system")

			if not (not has_extension and has_extension.pickup_name ~= "mutator_torch") then
				Managers.state.unit_spawner:mark_for_deletion(k)
			end
		end
	end

	if not Unit.alive(player_unit) then
		local has_extension_2 = ScriptUnit.has_extension(player_unit, "inventory_system")

		if not has_extension_2 then
			local get_wielded_slot_name = has_extension_2:get_wielded_slot_name()
			local get_slot_data = has_extension_2:get_slot_data(get_wielded_slot_name)

			if not get_slot_data then
				local item_data = get_slot_data.item_data

				if (not item_data and item_data.name) == "mutator_torch" then
					CharacterStateHelper.stop_weapon_actions(has_extension_2, "wield")
					has_extension_2:destroy_slot("slot_level_event", true)
					has_extension_2:wield("slot_melee")
				end
			end
		end
	end
end

DarknessSystem.shadow_flares_on_ground = function (arg_18_0)
	-- function 18
	return Managers.state.entity:get_entities("ShadowFlareExtension")
end

DarknessSystem.rpc_shadow_flare_done = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not self.is_server then
		local network = Managers.state.network
		local var_19_1 = CHANNEL_TO_PEER_ID[arg_19_1]

		network.network_transmit:send_rpc_clients_except("rpc_shadow_flare_done", var_19_1, arg_19_2)
	end

	local unit = Managers.state.unit_storage:unit(arg_19_2)
	local extension = ScriptUnit.extension(unit, "darkness_system")

	if not extension then
		extension:set_flare_done()
	end
end
