-- chunkname: @scripts/unit_extensions/pickups/pickup_unit_extension.lua

PickupUnitExtension = class(PickupUnitExtension)

PickupUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2

	local pickup_name = arg_1_3.pickup_name
	local has_physics = arg_1_3.has_physics
	local spawn_type = arg_1_3.spawn_type
	local dropped_by_breed = arg_1_3.dropped_by_breed

	dropped_by_breed = dropped_by_breed or "n/a"

	local network_transmit = arg_1_1.network_transmit

	self.pickup_name = pickup_name
	self.has_physics = has_physics
	self.spawn_type = spawn_type
	self.dropped_by_breed = dropped_by_breed
	self.is_server = network_transmit.is_server
	self.spawn_index = arg_1_3.spawn_index
	self.owner_peer_id = arg_1_3.owner_peer_id
	self.spawn_limit = arg_1_3.spawn_limit

	local var_1_5 = AllPickups[pickup_name]
	local material_settings_name

	if arg_1_3.material_settings_name ~= "n/a" then
		material_settings_name = arg_1_3.material_settings_name

		if not material_settings_name then
			-- Nothing
		end
	end

	material_settings_name = var_1_5.material_settings_name
	material_settings_name = material_settings_name or nil

	::label_1_0::

	self.material_settings_name = material_settings_name
	self.hide_func = var_1_5.hide_func
	self.hidden = false

	Unit.set_data(arg_1_2, "interaction_data", "item_name", var_1_5.item_name)
	Unit.set_data(arg_1_2, "interaction_data", "hud_description", var_1_5.hud_description)

	local set_data = Unit.set_data
	local var_1_8 = arg_1_2
	local str = "interaction_data"
	local str_2 = "interaction_length"
	local get_data = Unit.get_data(arg_1_2, "interaction_data", "interaction_length")

	get_data = get_data or 0

	set_data(var_1_8, str, str_2, get_data)
	Unit.set_data(arg_1_2, "interaction_data", "interaction_type", "pickup_object")
	Unit.set_data(arg_1_2, "interaction_data", "only_once", var_1_5.only_once)
	Unit.set_data(arg_1_2, "interaction_data", "individual_pickup", var_1_5.individual_pickup)
	Unit.set_data(arg_1_2, "pickup_name", pickup_name)

	self._can_interact_time = Managers.time:time("game") + 1
	self.life_time = var_1_5.life_time

	self:set_physics_enabled(has_physics)

	if not self.is_server then
		local var_1_12 = POSITION_LOOKUP[arg_1_2]

		Managers.telemetry_events:pickup_spawned(pickup_name, spawn_type, var_1_12)
	end

	if not self.material_settings_name then
		GearUtils.apply_material_settings(arg_1_2, self.material_settings_name)
	end
end

PickupUnitExtension.extensions_ready = function (self)
	-- function 2
	local var_2_0 = AllPickups[self.pickup_name]
	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "outline_system")

	if not has_extension then
		local outline_distance = var_2_0.outline_distance
		local var_2_4 = OutlineSettings.ranges[outline_distance]

		if not var_2_4 then
			has_extension:update_outline({
				distance = var_2_4
			}, 0)
		end

		if not var_2_0.outline_available_func then
			local player_unit = Managers.player:local_player().player_unit

			if not var_2_0.outline_available_func(player_unit) then
				has_extension:update_outline({
					method = "never"
				}, 0)
			end
		end
	end
end

PickupUnitExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

PickupUnitExtension.hide = function (self)
	-- function 4
	local unit = self.unit

	self.hidden = true

	Unit.set_unit_visibility(unit, false)
	Unit.disable_physics(unit)
	Unit.flow_event(unit, "lua_hidden")
end

PickupUnitExtension.get_pickup_settings = function (self)
	-- function 5
	return AllPickups[self.pickup_name]
end

PickupUnitExtension.destroy = function (self)
	-- function 6
	local system = Managers.state.entity:system("pickup_system")

	if not system and not self.spawn_index then
		system:set_taken(self.spawn_index)
	end

	if not self.is_server then
		local var_6_1 = POSITION_LOOKUP[self.unit]

		Managers.telemetry_events:pickup_destroyed(self.pickup_name, self.spawn_type, var_6_1)
	end
end

PickupUnitExtension.get_dropped_by_breed = function (self)
	-- function 7
	return self.dropped_by_breed
end

PickupUnitExtension.can_interact = function (self)
	-- function 8
	return not (Managers.time:time("game") <= self._can_interact_time)
end

PickupUnitExtension.set_physics_enabled = function (self, arg_9_1)
	-- function 9
	local unit = self.unit

	if not Unit.find_actor(unit, "pickup") then
		if not arg_9_1 then
			Unit.create_actor(unit, "pickup")
		else
			Unit.destroy_actor(unit, "pickup")
		end
	end
end
