-- chunkname: @scripts/unit_extensions/pickups/pickup_unit_extension.lua

PickupUnitExtension = class(PickupUnitExtension)

PickupUnitExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2

	local var_1_0 = arg_1_3.pickup_name
	local var_1_1 = arg_1_3.has_physics
	local var_1_2 = arg_1_3.spawn_type
	local var_1_3 = arg_1_3.dropped_by_breed or "n/a"
	local var_1_4 = arg_1_1.network_transmit

	arg_1_0.pickup_name = var_1_0
	arg_1_0.has_physics = var_1_1
	arg_1_0.spawn_type = var_1_2
	arg_1_0.dropped_by_breed = var_1_3
	arg_1_0.is_server = var_1_4.is_server
	arg_1_0.spawn_index = arg_1_3.spawn_index
	arg_1_0.owner_peer_id = arg_1_3.owner_peer_id
	arg_1_0.spawn_limit = arg_1_3.spawn_limit

	local var_1_5 = AllPickups[var_1_0]

	arg_1_0.material_settings_name = arg_1_3.material_settings_name ~= "n/a" and arg_1_3.material_settings_name or var_1_5.material_settings_name or nil
	arg_1_0.hide_func = var_1_5.hide_func
	arg_1_0.hidden = false

	Unit.set_data(arg_1_2, "interaction_data", "item_name", var_1_5.item_name)
	Unit.set_data(arg_1_2, "interaction_data", "hud_description", var_1_5.hud_description)
	Unit.set_data(arg_1_2, "interaction_data", "interaction_length", Unit.get_data(arg_1_2, "interaction_data", "interaction_length") or 0)
	Unit.set_data(arg_1_2, "interaction_data", "interaction_type", "pickup_object")
	Unit.set_data(arg_1_2, "interaction_data", "only_once", var_1_5.only_once)
	Unit.set_data(arg_1_2, "interaction_data", "individual_pickup", var_1_5.individual_pickup)
	Unit.set_data(arg_1_2, "pickup_name", var_1_0)

	arg_1_0._can_interact_time = Managers.time:time("game") + 1
	arg_1_0.life_time = var_1_5.life_time

	arg_1_0:set_physics_enabled(var_1_1)

	if arg_1_0.is_server then
		local var_1_6 = POSITION_LOOKUP[arg_1_2]

		Managers.telemetry_events:pickup_spawned(var_1_0, var_1_2, var_1_6)
	end

	if arg_1_0.material_settings_name then
		GearUtils.apply_material_settings(arg_1_2, arg_1_0.material_settings_name)
	end
end

PickupUnitExtension.extensions_ready = function (arg_2_0)
	local var_2_0 = AllPickups[arg_2_0.pickup_name]
	local var_2_1 = arg_2_0.unit
	local var_2_2 = ScriptUnit.has_extension(var_2_1, "outline_system")

	if var_2_2 then
		local var_2_3 = var_2_0.outline_distance
		local var_2_4 = OutlineSettings.ranges[var_2_3]

		if var_2_4 then
			var_2_2:update_outline({
				distance = var_2_4
			}, 0)
		end

		if var_2_0.outline_available_func then
			local var_2_5 = Managers.player:local_player().player_unit

			if not var_2_0.outline_available_func(var_2_5) then
				var_2_2:update_outline({
					method = "never"
				}, 0)
			end
		end
	end
end

PickupUnitExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

PickupUnitExtension.hide = function (arg_4_0)
	local var_4_0 = arg_4_0.unit

	arg_4_0.hidden = true

	Unit.set_unit_visibility(var_4_0, false)
	Unit.disable_physics(var_4_0)
	Unit.flow_event(var_4_0, "lua_hidden")
end

PickupUnitExtension.get_pickup_settings = function (arg_5_0)
	return AllPickups[arg_5_0.pickup_name]
end

PickupUnitExtension.destroy = function (arg_6_0)
	local var_6_0 = Managers.state.entity:system("pickup_system")

	if var_6_0 and arg_6_0.spawn_index then
		var_6_0:set_taken(arg_6_0.spawn_index)
	end

	if arg_6_0.is_server then
		local var_6_1 = POSITION_LOOKUP[arg_6_0.unit]

		Managers.telemetry_events:pickup_destroyed(arg_6_0.pickup_name, arg_6_0.spawn_type, var_6_1)
	end
end

PickupUnitExtension.get_dropped_by_breed = function (arg_7_0)
	return arg_7_0.dropped_by_breed
end

PickupUnitExtension.can_interact = function (arg_8_0)
	return not (Managers.time:time("game") <= arg_8_0._can_interact_time)
end

PickupUnitExtension.set_physics_enabled = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.unit

	if Unit.find_actor(var_9_0, "pickup") then
		if arg_9_1 then
			Unit.create_actor(var_9_0, "pickup")
		else
			Unit.destroy_actor(var_9_0, "pickup")
		end
	end
end
