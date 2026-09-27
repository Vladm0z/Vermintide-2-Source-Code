-- chunkname: @scripts/settings/mutators/mutator_curse_blood_storm_v2.lua

local tbl = {
	harder = 60,
	hard = 45,
	normal = 30,
	hardest = 80,
	cataclysm = 100,
	cataclysm_3 = 130,
	cataclysm_2 = 110,
	easy = 20
}
local tbl_2 = {
	COOLDOWN = "COOLDOWN",
	ACTIVE = "ACTIVE",
	READY = "READY"
}

script_data.blood_storm_debug = true

local printf = printf

local function fn(...)
	-- function 1
	local var_1_0 = sprintf(...)

	printf("[MutatorCurseBloodStorm] %s", var_1_0)
end

local function fn_2(...)
	-- function 2
	if not script_data.blood_storm_debug then
		local var_2_0 = sprintf(...)

		printf("[MutatorCurseBloodStorm] %s", var_2_0)
	end
end

local var_0_5 = class(Storm)

var_0_5.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self._logging_prefix = arg_3_6

	fn_2("-%s- init", arg_3_6)

	self._vortex_template_name = arg_3_1
	self._inner_decal_unit_name = arg_3_2
	self._outer_decal_unit_name = arg_3_3
	self._max_cooldown = arg_3_5
	self._min_cooldown = arg_3_4
	self._active_storm_data = nil
	self._state = tbl_2.COOLDOWN
	self._cooldown_end_t = Math.random_range(arg_3_4, arg_3_5)
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
	if self._state == tbl_2.COOLDOWN then
		if arg_5_2 > self._cooldown_end_t then
			self._state = tbl_2.READY

			fn_2("-%s- new state %s", self._logging_prefix, self._state)
		end
	elseif self._state == tbl_2.READY then
		-- Nothing
	elseif self._state == tbl_2.ACTIVE then
		local summoned_vortex_unit = self._active_storm_data.summoned_vortex_unit

		if not summoned_vortex_unit then
			if not Unit.alive(summoned_vortex_unit) then
				local _min_cooldown = self._min_cooldown
				local _max_cooldown = self._max_cooldown

				self._cooldown_end_t = Math.random_range(_min_cooldown, _max_cooldown)
				self._state = tbl_2.COOLDOWN

				fn_2("-%s- new state %s", self._logging_prefix, self._state)
				self:_clear_active_storm()
			else
				self._active_storm_data.latest_position = Unit.local_position(summoned_vortex_unit, 0)
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
	fassert(self._state == tbl_2.READY, "prepare_spawn can only be called when the state of the storm is READY")
	fn_2("-%s- spawn", self._logging_prefix)

	if not self._active_storm_data then
		self:_clear_active_storm()
	end

	local _vortex_template_name = self._vortex_template_name
	local var_6_1 = VortexTemplates[_vortex_template_name]
	local num = 2
	local min = math.min(num / var_6_1.full_inner_radius, 1)
	local _inner_decal_unit_name = self._inner_decal_unit_name
	local var_6_5

	if not _inner_decal_unit_name then
		local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_6_1)
		local max = math.max(var_6_1.min_inner_radius, min * var_6_1.full_inner_radius)

		Matrix4x4.set_scale(from_quaternion_position, Vector3(max, max, max))

		var_6_5 = Managers.state.unit_spawner:spawn_network_unit(_inner_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position)
	end

	local _outer_decal_unit_name = self._outer_decal_unit_name
	local var_6_9

	if not _outer_decal_unit_name then
		local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_6_1)
		local max_2 = math.max(var_6_1.min_outer_radius, min * var_6_1.full_outer_radius)

		Matrix4x4.set_scale(from_quaternion_position_2, Vector3(max_2, max_2, max_2))

		var_6_9 = Managers.state.unit_spawner:spawn_network_unit(_outer_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position_2)
	end

	local var_6_12 = self
	local tbl = {
		prepare_func = function (arg_7_0, arg_7_1)
			-- function 7
			arg_7_1.ai_supplementary_system = {
				vortex_template_name = _vortex_template_name,
				inner_decal_unit = var_6_5,
				outer_decal_unit = var_6_9
			}
		end,
		spawned_func = function (arg_8_0, arg_8_1, arg_8_2)
			-- function 8
			var_6_12._active_storm_data.summoned_vortex_unit = arg_8_0
			var_6_12._active_storm_data.vortex_extension = ScriptUnit.has_extension(arg_8_0, "ai_supplementary_system")
		end
	}
	local var_6_14 = arg_6_1
	local breed_name = var_6_1.breed_name
	local var_6_16 = Breeds[breed_name]
	local str = "vortex"
	local spawn_queued_unit = Managers.state.conflict:spawn_queued_unit(var_6_16, Vector3Box(var_6_14), QuaternionBox(Quaternion.identity()), str, nil, nil, tbl)

	self._active_storm_data = {
		queue_id = spawn_queued_unit,
		starting_position = Vector3Box(arg_6_1)
	}
	self._state = tbl_2.ACTIVE

	fn_2("-%s- new state %s", self._logging_prefix, self._state)
end

var_0_5.get_state = function (self)
	-- function 9
	return self._state
end

var_0_5.get_position = function (self)
	-- function 10
	local _active_storm_data = self._active_storm_data

	if not _active_storm_data then
		return nil
	end

	local summoned_vortex_unit = _active_storm_data.summoned_vortex_unit

	if not summoned_vortex_unit then
		return nil
	end

	if not Unit.alive(summoned_vortex_unit) then
		return nil
	end

	local latest_position = _active_storm_data.latest_position

	if not latest_position then
		return _active_storm_data.starting_position:unbox()
	else
		return latest_position
	end
end

var_0_5.get_vortex_unit = function (self)
	-- function 11
	local _active_storm_data = self._active_storm_data

	return not _active_storm_data and _active_storm_data.summoned_vortex_unit
end

var_0_5.get_vortex_extension = function (self)
	-- function 12
	local _active_storm_data = self._active_storm_data

	return not _active_storm_data and _active_storm_data.vortex_extension
end

var_0_5._clear_active_storm = function (self)
	-- function 13
	local _active_storm_data = self._active_storm_data

	if not _active_storm_data.summoned_vortex_unit then
		local queue_id = _active_storm_data.queue_id

		if not queue_id then
			Managers.state.conflict:remove_queued_unit(queue_id)
		end
	end

	self._active_storm_data = nil
end

local num = 0.2
local str = "curse_blood_storm_dot"
local str_2 = "curse_blood_storm_dot_bots"
local num_2 = 3
local str_3 = "blood_storm"
local str_4 = "units/decals/deus_decal_bloodstorm_inner"
local str_5 = "units/decals/deus_decal_bloodstorm_outer"
local num_3 = 15
local num_4 = 20
local num_5 = 10
local num_6 = 30
local num_7 = 10

return {
	description = "curse_blood_storm_desc",
	display_name = "curse_blood_storm_name",
	icon = "deus_curse_khorne_01",
	packages = {
		"resource_packages/mutators/mutator_curse_blood_storm"
	},
	server_start_function = function (arg_14_0, arg_14_1)
		-- function 14
		local tbl = {}

		for i = 1, num_2 do
			tbl[#tbl + 1] = var_0_5:new(str_3, str_4, str_5, num_3, num_4, i)
		end

		arg_14_1.storms = tbl
		arg_14_1.next_bleed_time = 0
	end,
	server_pre_update_function = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		-- function 15
		if Managers.state.unit_spawner.game_session == nil or not global_is_inside_inn then
			return
		end

		local flag = false

		if arg_15_3 > arg_15_1.next_bleed_time then
			flag = true
			arg_15_1.next_bleed_time = arg_15_3 + num
		end

		local storms = arg_15_1.storms

		for i = 1, #storms do
			storms[i]:update(arg_15_2, arg_15_3)
		end

		for j = 1, #storms do
			local var_15_2 = storms[j]
			local get_state = var_15_2:get_state()

			if get_state == tbl_2.READY then
				local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

				if not get_random_alive_hero then
					local var_15_5 = POSITION_LOOKUP[get_random_alive_hero]
					local tbl_3 = {}
					local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

					for k = 1, #PLAYER_AND_BOT_UNITS do
						local var_15_8 = PLAYER_AND_BOT_UNITS[k]

						tbl_3[#tbl_3 + 1] = POSITION_LOOKUP[var_15_8]
					end

					for l = 1, #storms do
						local var_15_9 = storms[l]

						tbl_3[#tbl_3 + 1] = var_15_9:get_position()
					end

					local nav_world = Managers.state.entity:system("ai_system"):nav_world()
					local tbl_4 = {}

					ConflictUtils.find_positions_around_position(var_15_5, tbl_4, nav_world, num_5, num_6, 1, tbl_3, num_7)

					local var_15_12 = tbl_4[1]

					if not var_15_12 then
						var_15_2:spawn(var_15_12)
					end
				end
			elseif get_state ~= tbl_2.ACTIVE or not flag then
				local get_vortex_extension = var_15_2:get_vortex_extension()
				local get_vortex_unit = var_15_2:get_vortex_unit()

				if not get_vortex_extension then
					local players = Managers.player:players()

					for k_2, v in pairs(players) do
						local player_unit = v.player_unit

						if not ALIVE[player_unit] then
							local var_15_17 = POSITION_LOOKUP[player_unit]

							if not get_vortex_extension:is_position_inside(var_15_17) then
								local system = Managers.state.entity:system("buff_system")
								local get_difficulty = Managers.state.difficulty:get_difficulty()
								local var_15_20 = tbl[get_difficulty]
								local var_15_21

								if not v.bot_player then
									var_15_21 = str_2

									if not var_15_21 then
										-- Nothing
									end
								end

								var_15_21 = str

								::label_15_0::

								system:add_buff(player_unit, var_15_21, get_vortex_unit, false, var_15_20)
							end
						end
					end
				end
			end
		end
	end,
	server_player_hit_function = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		-- function 16
		if arg_16_4[2] == "blood_storm" then
			local extension_input = ScriptUnit.extension_input(arg_16_2, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_dialogue_event("curse_damage_taken", alloc_table)
		end
	end
}
