-- chunkname: @scripts/settings/mutators/mutator_curse_belakor_totems.lua

local tbl = {
	COOLDOWN = "COOLDOWN",
	ACTIVE = "ACTIVE",
	READY = "READY"
}

script_data.belakor_totems_debug = true

local num = 0.5
local printf = printf

local function fn(...)
	-- function 1
	local var_1_0 = sprintf(...)

	printf("[MutatorCurseBelakorTotems] %s", var_1_0)
end

local function fn_2(...)
	-- function 2
	if not script_data.belakor_totems_debug then
		local var_2_0 = sprintf(...)

		printf("[MutatorCurseBelakorTotems] %s", var_2_0)
	end
end

local num_2 = 0
local num_3 = 25
local num_4 = 35
local num_5 = 10
local num_6 = 15
local num_7 = 10
local num_8 = 5
local var_0_12 = class(Totem)

var_0_12.init = function (self, arg_3_1)
	-- function 3
	self._logging_prefix = arg_3_1

	fn_2("-%s- init", arg_3_1)

	self._active_totem_data = nil
	self._state = tbl.COOLDOWN
end

var_0_12.destroy = function (self)
	-- function 4
	fn_2("-%s- destroy", self._logging_prefix)

	if not self._active_totem_data then
		self:_clear_active_totem()
	end
end

var_0_12.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if self._state == tbl.COOLDOWN then
		if not self._cooldown_end_t then
			self._cooldown_end_t = arg_5_2 + Math.random_range(num_3, num_4)
			self._state = tbl.READY
		elseif arg_5_2 > self._cooldown_end_t then
			self._state = tbl.READY

			fn_2("-%s- new state %s", self._logging_prefix, self._state)
		end
	elseif self._state == tbl.READY then
		-- Nothing
	elseif self._state == tbl.ACTIVE then
		local unit = self._active_totem_data.unit

		if not unit then
			if not self._active_totem_data.totem_ext:is_despawned() then
				local var_5_1 = BLACKBOARDS[unit]

				Managers.state.conflict:destroy_unit(unit, var_5_1, "far_off_despawn")
			end

			if not Unit.alive(unit) then
				if not self._active_totem_data.totem_ext:is_despawned() then
					self._cooldown_end_t = arg_5_2 + num_2
				else
					self._cooldown_end_t = arg_5_2 + Math.random_range(num_3, num_4)
				end

				self._state = tbl.COOLDOWN

				fn_2("-%s- new state %s", self._logging_prefix, self._state)
				self:_clear_active_totem()
			else
				self._active_totem_data.latest_position = Unit.local_position(unit, 0)
			end
		end
	else
		local ferror = ferror
		local str = "unknown state %d"
		local _state = self._state

		_state = _state or "nil"

		ferror(str, _state)
	end
end

var_0_12.spawn = function (self, arg_6_1)
	-- function 6
	fassert(self._state == tbl.READY, "prepare_spawn can only be called when the state of the totem is READY")
	fn_2("-%s- spawn", self._logging_prefix)

	if not self._active_totem_data then
		self:_clear_active_totem()
	end

	local tbl_2 = {
		prepare_func = function (self, arg_7_1)
			-- function 7
			local flag = false

			self.modify_extension_init_data(self, flag, arg_7_1)
		end
	}
	local var_6_1 = self

	tbl_2.spawned_func = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		var_6_1._active_totem_data.unit = arg_8_0
		var_6_1._active_totem_data.queue_id = nil
		var_6_1._active_totem_data.totem_ext = ScriptUnit.has_extension(arg_8_0, "deus_belakor_totem_system")
	end

	local identity = Quaternion.identity()
	local spawn_queued_unit = Managers.state.conflict:spawn_queued_unit(Breeds.shadow_totem, Vector3Box(arg_6_1), QuaternionBox(identity), "mutator", "spawn_idle", "terror_event", tbl_2)

	self._active_totem_data = {
		queue_id = spawn_queued_unit,
		starting_position = Vector3Box(arg_6_1)
	}
	self._state = tbl.ACTIVE

	fn_2("-%s- new state %s", self._logging_prefix, self._state)
end

var_0_12.get_state = function (self)
	-- function 9
	return self._state
end

var_0_12.get_position = function (self)
	-- function 10
	local _active_totem_data = self._active_totem_data

	if not _active_totem_data then
		return nil
	end

	return _active_totem_data.starting_position:unbox()
end

var_0_12.get_unit = function (self)
	-- function 11
	local _active_totem_data = self._active_totem_data

	return not _active_totem_data and _active_totem_data.unit
end

var_0_12._clear_active_totem = function (self)
	-- function 12
	local queue_id = self._active_totem_data.queue_id

	if not queue_id then
		Managers.state.conflict:remove_queued_unit(queue_id)
	end

	self._active_totem_data = nil
end

local num_9 = 1

return {
	description = "curse_belakor_totems_desc",
	display_name = "curse_belakor_totems_name",
	icon = "deus_curse_belakor_01",
	packages = {
		"resource_packages/mutators/mutator_curse_belakor_totems"
	},
	server_start_function = function (arg_13_0, arg_13_1)
		-- function 13
		local tbl = {}

		for i = 1, num_9 do
			tbl[#tbl + 1] = var_0_12:new(i)
		end

		arg_13_1.totems = tbl
		arg_13_1.conflict_director = Managers.state.conflict
	end,
	server_players_left_safe_zone = function (arg_14_0, arg_14_1)
		-- function 14
		arg_14_1.started = true
	end,
	server_pre_update_function = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		-- function 15
		if Managers.state.unit_spawner.game_session == nil or not global_is_inside_inn then
			return
		end

		if not arg_15_1.started then
			return
		end

		local totems = arg_15_1.totems

		for i = 1, #totems do
			totems[i]:update(arg_15_2, arg_15_3)
		end

		local conflict_director = arg_15_1.conflict_director

		if not (not (conflict_director.pacing:horde_population() < 1) or conflict_director.pacing:get_state() == "pacing_frozen") then
			return
		end

		for j = 1, #totems do
			local var_15_2 = totems[j]

			if var_15_2:get_state() == tbl.READY then
				local main_path_info = Managers.state.conflict.main_path_info
				local ahead_unit = main_path_info.ahead_unit

				if not ALIVE[ahead_unit] then
					local ahead_travel_dist = main_path_info.ahead_travel_dist
					local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, ahead_travel_dist + num_8)
					local var_15_7 = POSITION_LOOKUP[ahead_unit]
					local num = var_15_7 + Vector3.normalize(point_on_mainpath - var_15_7) * num_8
					local tbl_2 = {}
					local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

					for k = 1, #PLAYER_AND_BOT_UNITS do
						local var_15_11 = PLAYER_AND_BOT_UNITS[k]

						tbl_2[#tbl_2 + 1] = POSITION_LOOKUP[var_15_11]
					end

					for l = 1, #totems do
						local var_15_12 = totems[l]

						tbl_2[#tbl_2 + 1] = var_15_12:get_position()
					end

					local nav_world = Managers.state.entity:system("ai_system"):nav_world()
					local tbl_3 = {}

					ConflictUtils.find_positions_around_position(num, tbl_3, nav_world, num_5, num_6, 1, tbl_2, num_7)

					local var_15_15 = tbl_3[1]

					if not var_15_15 then
						local traverse_logic = Managers.state.bot_nav_transition:traverse_logic()

						if not GwNavQueries.raycango(nav_world, num, var_15_15, traverse_logic) then
							var_15_2:spawn(var_15_15)
						end
					end
				end

				return
			end
		end
	end,
	server_player_hit_function = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		-- function 16
		return
	end
}
