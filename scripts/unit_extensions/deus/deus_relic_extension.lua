-- chunkname: @scripts/unit_extensions/deus/deus_relic_extension.lua

DeusRelicExtension = class(DeusRelicExtension)

local num = 30
local num_2 = 30
local num_3 = 5
local num_4 = 5
local num_5 = 10
local num_6 = 5
local num_7 = 0.5

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local var_1_0
	local triangle_from_position, var_1_2 = GwNavQueries.triangle_from_position(arg_1_0, arg_1_1, arg_1_2, arg_1_2)

	if not triangle_from_position then
		var_1_0 = Vector3(arg_1_1.x, arg_1_1.y, var_1_2)
	else
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(arg_1_0, arg_1_1, arg_1_2, arg_1_2, arg_1_2, num_7)

		if not inside_position_from_outside_position then
			var_1_0 = inside_position_from_outside_position
		end
	end

	if not var_1_0 then
		return nil
	else
		return Vector3.length_squared(arg_1_1 - var_1_0)
	end
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local huge = math.huge

	for i, v in ipairs(arg_2_0) do
		local length_squared = Vector3.length_squared(arg_2_1 - v)

		huge = math.min(length_squared, huge)
	end

	return huge
end

local function fn_3(arg_3_0)
	-- function 3
	local conflict = Managers.state.conflict
	local get_main_paths = conflict.level_analysis:get_main_paths()
	local main_path_info = conflict.main_path_info
	local total_path_dist = MainPathUtils.total_path_dist()
	local var_3_4

	if not main_path_info.ahead_unit then
		var_3_4 = total_path_dist
	else
		var_3_4 = conflict.main_path_player_info[main_path_info.ahead_unit].travel_dist
	end

	local num = var_3_4 + num_6
	local clamp = math.clamp(num, 0, MainPathUtils.total_path_dist() - 0.1)
	local point_on_mainpath = MainPathUtils.point_on_mainpath(get_main_paths, clamp)
	local extension = ScriptUnit.extension(arg_3_0, "projectile_locomotion_system")

	Actor.teleport_position(extension.physics_actor, point_on_mainpath)
end

DeusRelicExtension.init = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	self._unit = arg_4_2
	self._is_server = Managers.player.is_server
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
end

DeusRelicExtension.game_object_initialized = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._go_id = arg_5_2
end

DeusRelicExtension.destroy = function (self)
	-- function 6
	local unit_spawner = Managers.state.unit_spawner
	local _objective_unit = self._objective_unit

	if not (not ALIVE[_objective_unit] and unit_spawner:is_marked_for_deletion(_objective_unit)) then
		unit_spawner:mark_for_deletion(_objective_unit)

		self._objective_unit = nil
	end
end

DeusRelicExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	self:_update_position_resetting(arg_7_1, arg_7_5)
	self:_update_objective_marker(arg_7_1, arg_7_5)
end

DeusRelicExtension._update_position_resetting = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = POSITION_LOOKUP[arg_8_1]
	local var_8_1 = fn(self._nav_world, var_8_0, num_3)
	local num_5 = num_3 * num_3

	if not (not var_8_1 and not (num_5 < var_8_1)) then
		if not self._out_of_bounds_since then
			self._out_of_bounds_since = arg_8_2
		end

		if arg_8_2 - self._out_of_bounds_since > num_4 then
			fn_3(arg_8_1)

			self._out_of_bounds_since = nil
		end
	else
		self._out_of_bounds_since = nil

		local PLAYER_AND_BOT_POSITIONS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_POSITIONS

		if fn_2(PLAYER_AND_BOT_POSITIONS, var_8_0) > num * num then
			if not self._far_away_since then
				self._far_away_since = arg_8_2
			end

			if arg_8_2 - self._far_away_since > num_2 then
				fn_3(arg_8_1)

				self._far_away_since = nil
			end
		else
			self._far_away_since = nil
		end
	end
end

DeusRelicExtension._update_objective_marker = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._objective_unit then
		return
	end

	if not self._alive_since then
		self._alive_since = arg_9_2
	end

	if arg_9_2 - self._alive_since > num_5 then
		local str = "units/hub_elements/objective_unit"
		local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "objective_unit", nil, POSITION_LOOKUP[arg_9_1])

		ScriptUnit.extension(spawn_network_unit, "tutorial_system"):set_active(true)
		World.link_unit(Unit.world(arg_9_1), spawn_network_unit, 0, arg_9_1, 0)

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(spawn_network_unit)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_9_1)

		network.network_transmit:send_rpc_clients("rpc_link_unit", unit_game_object_id, 0, unit_game_object_id_2, 0)

		self._objective_unit = spawn_network_unit
	end
end
