-- chunkname: @scripts/entity_system/systems/weaves/weave_essence_handler.lua

WeaveEssenceHandler = class(WeaveEssenceHandler)

WeaveEssenceHandler.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._spawn_essence_units = true
	self._essence_unit_names = {
		"units/fx/essence_unit",
		"units/fx/essence_unit"
	}
	self._essence_sound_events = {
		"Play_hud_wind_collect_essence",
		"Play_hud_wind_collect_essence_chunk"
	}
	self._essence_unit_data = {}

	for i = 1, 20 do
		self._essence_unit_data[i] = {}
	end

	self._essence_life_time = 3
end

WeaveEssenceHandler.on_objectives_activated = function (arg_2_0, arg_2_1)
	-- function 2
	if not table.is_empty(arg_2_1) then
		Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_hud_wind_objective_start")
	end
end

WeaveEssenceHandler.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_collect_dropped_essence(arg_3_1)
end

WeaveEssenceHandler.destroy_all_essence = function (self)
	-- function 4
	local _essence_unit_data = self._essence_unit_data

	for i = 1, #_essence_unit_data do
		local var_4_1 = _essence_unit_data[i]
		local unit = var_4_1.unit

		if not Unit.alive(unit) then
			Managers.state.unit_spawner:mark_for_deletion(unit)
			table.clear(var_4_1)
		end
	end
end

WeaveEssenceHandler.on_ai_killed = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not (not arg_5_3 and arg_5_3.despawned) then
		local var_5_0 = POSITION_LOOKUP[arg_5_1]

		self:spawn_essence_unit(var_5_0 + Vector3(0, 0, 0.2))
	end
end

WeaveEssenceHandler.spawn_essence_unit = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _essence_unit_data = self._essence_unit_data
	local var_6_1

	for i = 1, #_essence_unit_data do
		local unit = _essence_unit_data[i].unit

		if not Unit.alive(unit) then
			var_6_1 = i

			break
		end
	end

	if not (not self._spawn_essence_units and var_6_1) then
		return
	end

	local var_6_3 = self._essence_unit_names[arg_6_2 or 1]
	local var_6_4

	var_6_4.unit, var_6_4 = Managers.state.unit_spawner:spawn_local_unit(var_6_3, arg_6_1, Quaternion.identity()), self._essence_unit_data[var_6_1]
	var_6_4.life_time = self._essence_life_time
	var_6_4.spawn_pos = Vector3Box(arg_6_1)
	var_6_4.right_vector_multiplier = 1 - math.random() * 2
	var_6_4.forward_vector_multiplier = 1 - math.random() * 2
	var_6_4.sound_event = self._essence_sound_events[arg_6_2 or 1]
end

WeaveEssenceHandler._collect_dropped_essence = function (self, arg_7_1)
	-- function 7
	local local_player = Managers.player:local_player()

	if not (not local_player and local_player.player_unit) then
		return
	end

	local player_unit = local_player.player_unit
	local unit_spawner = Managers.state.unit_spawner
	local num = POSITION_LOOKUP[player_unit] + Vector3(0, 0, 0.5)
	local up = Vector3.up()
	local right = Vector3.right()
	local forward = Vector3.forward()
	local num_2 = 0
	local num_3 = 0.8
	local _essence_unit_data = self._essence_unit_data
	local alive = Unit.alive

	for i = 1, #_essence_unit_data do
		local var_7_11 = _essence_unit_data[i]
		local unit = var_7_11.unit

		if not alive(unit) then
			local var_7_13 = POSITION_LOOKUP[unit]
			local distance = Vector3.distance(var_7_13, num)
			local num_4 = var_7_11.life_time - arg_7_1

			if not (num_4 <= 0 or not (distance <= 1)) then
				unit_spawner:mark_for_deletion(unit)

				if not var_7_11.sound_event then
					local wwise_world = Managers.world:wwise_world(self._world)

					WwiseWorld.trigger_event(wwise_world, var_7_11.sound_event)
				end

				table.clear(var_7_11)
			else
				if num_4 <= num_3 then
					local num_5 = var_7_13 + Vector3.normalize(num - var_7_13) * arg_7_1 * math.max(30, distance / (num_3 / 2))

					Unit.set_local_position(unit, 0, num_5)
				elseif num_4 >= num_3 + num_2 then
					local num_6 = (num_4 - num_3 - num_2) / (self._essence_life_time - num_3 - num_2)
					local num_7 = 1 - math.easeInCubic(num_6)
					local unbox = var_7_11.spawn_pos:unbox()
					local num_8 = up * 2 * num_7
					local num_9 = right * var_7_11.right_vector_multiplier * (1 - num_6)
					local num_10 = forward * var_7_11.forward_vector_multiplier * (1 - num_6)
					local num_11 = unbox + (num_8 + num_9 + num_10)

					Unit.set_local_position(unit, 0, num_11)
				end

				var_7_11.life_time = num_4
			end
		end
	end
end
