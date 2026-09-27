-- chunkname: @scripts/settings/mutators/mutator_curse_shadow_daggers.lua

local tbl = {
	COOLDOWN = "COOLDOWN",
	ACTIVE = "ACTIVE",
	READY = "READY"
}

script_data.shadow_daggers_debug = true

local num = 5
local printf = printf

local function fn(...)
	-- function 1
	local var_1_0 = sprintf(...)

	printf("[MutatorCurseShadowDaggers] %s", var_1_0)
end

local function fn_2(...)
	-- function 2
	if not script_data.shadow_daggers_debug then
		local var_2_0 = sprintf(...)

		printf("[MutatorCurseShadowDaggers] %s", var_2_0)
	end
end

local var_0_5 = class(Storm)

var_0_5.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self._logging_prefix = arg_3_4

	fn_2("-%s- init", arg_3_4)

	self._unit_name = arg_3_1
	self._max_cooldown = arg_3_3
	self._min_cooldown = arg_3_2
	self._active_storm_data = nil
	self._state = tbl.COOLDOWN
	self._cooldown_end_t = Math.random_range(arg_3_2, arg_3_3)
end

var_0_5.destroy = function (self)
	-- function 4
	fn_2("-%s- destroy", self._logging_prefix)

	if not self._active_storm_data then
		self:_clear_active_storm()
	end
end

var_0_5.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if self._state == tbl.COOLDOWN then
		if arg_5_2 > self._cooldown_end_t then
			self._state = tbl.READY

			fn_2("-%s- new state %s", self._logging_prefix, self._state)
		end
	elseif self._state == tbl.READY then
		-- Nothing
	elseif self._state == tbl.ACTIVE then
		local unit = self._active_storm_data.unit

		if not unit then
			if not Unit.alive(unit) then
				local _min_cooldown = self._min_cooldown
				local _max_cooldown = self._max_cooldown

				self._cooldown_end_t = Math.random_range(_min_cooldown, _max_cooldown)
				self._state = tbl.COOLDOWN

				fn_2("-%s- new state %s", self._logging_prefix, self._state)
				self:_clear_active_storm()
			else
				self._active_storm_data.latest_position = Unit.local_position(unit, 0)
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

var_0_5.spawn = function (self, arg_6_1)
	-- function 6
	fassert(self._state == tbl.READY, "prepare_spawn can only be called when the state of the storm is READY")
	fn_2("-%s- spawn", self._logging_prefix)

	if not self._active_storm_data then
		self:_clear_active_storm()
	end

	local _unit_name = self._unit_name
	local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_6_1)
	local tbl_2 = {
		shadow_dagger_spawner_system = {
			limitted_spawner = true
		}
	}
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(_unit_name, "shadow_dagger_spawner", tbl_2, from_quaternion_position)

	self._active_storm_data = {
		unit = spawn_network_unit,
		starting_position = Vector3Box(arg_6_1)
	}
	self._state = tbl.ACTIVE

	fn_2("-%s- new state %s", self._logging_prefix, self._state)
end

var_0_5.get_state = function (self)
	-- function 7
	return self._state
end

var_0_5.get_position = function (self)
	-- function 8
	local _active_storm_data = self._active_storm_data

	if not _active_storm_data then
		return nil
	end

	return _active_storm_data.starting_position:unbox()
end

var_0_5.get_unit = function (self)
	-- function 9
	local _active_storm_data = self._active_storm_data

	return not _active_storm_data and _active_storm_data.unit
end

var_0_5._clear_active_storm = function (self)
	-- function 10
	local unit = self._active_storm_data.unit

	if not unit and not Unit.alive(unit) then
		Managers.state.unit_spawner:mark_for_deletion(unit)
	end

	self._active_storm_data = nil
end

local num_2 = 3
local str = "units/props/blk/blk_curse_shadow_dagger_spawner_01"
local num_3 = 10
local num_4 = 10
local num_5 = 10
local num_6 = 30
local num_7 = 10

return {
	description = "curse_shadow_daggers_desc",
	display_name = "curse_shadow_daggers_name",
	icon = "deus_curse_khorne_01",
	packages = {
		"resource_packages/mutators/mutator_curse_shadow_daggers"
	},
	server_start_function = function (arg_11_0, arg_11_1)
		-- function 11
		local tbl = {}

		for i = 1, num_2 do
			tbl[#tbl + 1] = var_0_5:new(str, num_3, num_4, i)
		end

		arg_11_1.storms = tbl
		arg_11_1.next_bleed_time = 0
	end,
	server_players_left_safe_zone = function (arg_12_0, arg_12_1)
		-- function 12
		arg_12_1.started = true
	end,
	server_pre_update_function = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		-- function 13
		if Managers.state.unit_spawner.game_session == nil or not global_is_inside_inn then
			return
		end

		if not arg_13_1.started then
			return
		end

		local storms = arg_13_1.storms

		for i = 1, #storms do
			storms[i]:update(arg_13_2, arg_13_3)
		end

		if not (not arg_13_1.next_spawn_t and not (arg_13_3 < arg_13_1.next_spawn_t)) then
			return
		end

		for j = 1, #storms do
			local var_13_1 = storms[j]

			if var_13_1:get_state() == tbl.READY then
				local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

				if not get_random_alive_hero then
					local var_13_3 = POSITION_LOOKUP[get_random_alive_hero]
					local tbl_2 = {}
					local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

					for k = 1, #PLAYER_AND_BOT_UNITS do
						local var_13_6 = PLAYER_AND_BOT_UNITS[k]

						tbl_2[#tbl_2 + 1] = POSITION_LOOKUP[var_13_6]
					end

					for l = 1, #storms do
						local var_13_7 = storms[l]

						tbl_2[#tbl_2 + 1] = var_13_7:get_position()
					end

					local nav_world = Managers.state.entity:system("ai_system"):nav_world()
					local tbl_3 = {}

					ConflictUtils.find_positions_around_position(var_13_3, tbl_3, nav_world, num_5, num_6, 1, tbl_2, num_7)

					local var_13_10 = tbl_3[1]

					if not var_13_10 then
						var_13_1:spawn(var_13_10)

						arg_13_1.next_spawn_t = arg_13_3 + num
					end
				end

				return
			end
		end
	end,
	server_player_hit_function = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		return
	end
}
