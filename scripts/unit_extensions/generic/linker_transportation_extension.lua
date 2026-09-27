-- chunkname: @scripts/unit_extensions/generic/linker_transportation_extension.lua

require("scripts/helpers/navigation_utils")

LinkerTransportationExtension = class(LinkerTransportationExtension)

local num = 1
local num_2 = 0.05
local set = table.set({
	"moving_forward",
	"moving_backward"
})
local tbl = {
	"stopped_beginning",
	"moving_forward",
	"moving_backward",
	"stopped_end"
}

for i, v in ipairs(tbl) do
	tbl[v] = i
end

local alive = Unit.alive

LinkerTransportationExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.world = arg_1_1.world
	self.is_server = Managers.player.is_server
	self._transportation_system = arg_1_1.owning_system

	local get_data = Unit.get_data(arg_1_2, "transportation_data", "story_name")
	local storyteller = World.storyteller(self.world)
	local current_level = LevelHelper:current_level(self.world)

	self._bot_slots_offset = {
		0,
		1,
		-1
	}
	self._bot_slots = {}
	self.story_teller = storyteller

	local play_level_story = storyteller:play_level_story(current_level, get_data)

	self.story_id = play_level_story

	storyteller:set_speed(play_level_story, 0)

	self.story_state = "stopped_beginning"
	self.current_story_time = 0
	self.auto_exit = Unit.get_data(arg_1_2, "transportation_data", "auto_exit")
	self.teleport_on_enter = Unit.get_data(arg_1_2, "transportation_data", "teleport_on_enter")
	self.teleport_on_exit = Unit.get_data(arg_1_2, "transportation_data", "teleport_on_exit")
	self.takes_party = Unit.get_data(arg_1_2, "transportation_data", "takes_party")
	self.return_to_start = Unit.get_data(arg_1_2, "transportation_data", "return_to_start")
	self.transported_units = {}
	self._transported_ai_units = {}
	self._transported_ai_unit_freelist = {}
	self._transported_generic_units = {}
	self.has_nav_obstacles = false

	local get_data_2 = Unit.get_data(arg_1_2, "transportation_data", "bounding_box_mesh")

	if get_data_2 ~= "" then
		local mesh = Unit.mesh(arg_1_2, get_data_2)
		local box, var_1_7 = Mesh.box(mesh)

		self.oobb_mesh_max_extent = math.max(var_1_7.x, var_1_7.y, var_1_7.z)
		self.oobb_mesh = mesh
		self.oobb_next_update = 0
		self.units_inside_oobb = {
			human = {
				count = 0,
				units = {}
			},
			bot = {
				count = 0,
				units = {}
			},
			ai = {
				count = 0,
				units = {}
			}
		}
	end

	self._movement_delta = Vector3Box(0, 0, 0)
	self._visual_movement_diff = Vector3Box(0, 0, 0)
	self._rotation_delta = QuaternionBox(Quaternion.identity())
	self._old_position = Vector3Box(Unit.local_position(arg_1_2, 0))
	self._old_rotation = QuaternionBox(Unit.local_rotation(arg_1_2, 0))
	self._original_visual_delta = Vector3Box(self:visual_delta(true))
	self._old_visual_delta = Vector3Box(self._original_visual_delta:unbox())
	self._unlink_after_update = false
	self._side = Managers.state.side:get_side_from_name("heroes")

	Managers.state.event:register(self, "new_player_unit", "on_player_unit_spawned")
	Managers.state.event:register(self, "pickup_spawned", "on_pickup_spawned")
	Managers.state.event:register(self, "sister_wall_spawned", "on_sister_wall_spawned")

	self._queued_ai_units_to_remove = {}
	self._nearby_pickup_cache = {}
end

LinkerTransportationExtension.extensions_ready = function (arg_2_0)
	-- function 2
	return
end

LinkerTransportationExtension.movement_delta = function (self)
	-- function 3
	return self._movement_delta:unbox(), self._rotation_delta:unbox()
end

LinkerTransportationExtension.visual_delta = function (self, arg_4_1)
	-- function 4
	local unit = self.unit
	local _reference_node = self:_reference_node()
	local num = Unit.world_position(unit, _reference_node) - Unit.world_position(unit, 0)
	local rotate = Quaternion.rotate(Quaternion.inverse(Unit.world_rotation(unit, 0)), num)

	if not arg_4_1 then
		return rotate
	end

	return rotate - self._original_visual_delta:unbox()
end

LinkerTransportationExtension.visual_diff_delta = function (self)
	-- function 5
	return self._visual_movement_diff:unbox()
end

LinkerTransportationExtension.register_navmesh_units = function (self, arg_6_1, arg_6_2)
	-- function 6
	local GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD
	local create_exclusive_box_obstacle_from_unit_data, var_6_2 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(GLOBAL_AI_NAVWORLD, arg_6_1)

	GwNavBoxObstacle.add_to_world(create_exclusive_box_obstacle_from_unit_data)
	GwNavBoxObstacle.set_transform(create_exclusive_box_obstacle_from_unit_data, var_6_2)

	local create_exclusive_box_obstacle_from_unit_data_2, var_6_4 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(GLOBAL_AI_NAVWORLD, arg_6_2)

	GwNavBoxObstacle.add_to_world(create_exclusive_box_obstacle_from_unit_data_2)
	GwNavBoxObstacle.set_transform(create_exclusive_box_obstacle_from_unit_data_2, var_6_4)

	self.nav_obstacle_start = create_exclusive_box_obstacle_from_unit_data
	self.nav_obstacle_end = create_exclusive_box_obstacle_from_unit_data_2
	self.has_nav_obstacles = true

	self:update_nav_obstacles()
end

LinkerTransportationExtension.interacted_with = function (self, arg_7_1)
	-- function 7
	self:_link_all_transported_units(arg_7_1)

	if self.story_state == "stopped_beginning" then
		self.story_state = "moving_forward"

		Unit.flow_event(self.unit, "lua_transportation_story_started")
	end

	self:update_nav_obstacles()
end

LinkerTransportationExtension.hot_join_sync = function (self, arg_8_1)
	-- function 8
	local network = Managers.state.network
	local unit_index = Level.unit_index(LevelHelper:current_level(self.world), self.unit)
	local story_state = self.story_state
	local current_story_time = self.current_story_time
	local var_8_4 = PEER_ID_TO_CHANNEL[arg_8_1]

	if not self:transporting() then
		local var_8_5

		for i, v in ipairs(self.transported_units) do
			if not Unit.alive(v) then
				var_8_5 = v

				break
			end
		end

		if not var_8_5 then
			local unit_game_object_id = network:unit_game_object_id(var_8_5)

			RPC.rpc_hot_join_sync_linker_transporting(var_8_4, unit_index, unit_game_object_id)
		end
	end

	RPC.rpc_hot_join_sync_linker_transport_state(var_8_4, unit_index, tbl[story_state], current_story_time)

	local _transported_generic_units = self._transported_generic_units

	if not table.is_empty(_transported_generic_units) then
		local tbl_2 = {}
		local tbl_3 = {}
		local tbl_4 = {}
		local num = 0

		for k, v_2 in pairs(_transported_generic_units) do
			local game_object_or_level_id, var_8_13 = network:game_object_or_level_id(k)

			if not game_object_or_level_id then
				num = num + 1
				tbl_2[num] = game_object_or_level_id
				tbl_3[num] = v_2:unbox()
				tbl_4[num] = var_8_13
			end
		end

		local min = table.min({
			Network.type_info("game_object_id_array").max_size,
			Network.type_info("position_array").max_size,
			Network.type_info("rotation_array").max_size,
			Network.type_info("bool_array").max_size
		})
		local ceil = math.ceil(num / min)

		for i4 = 1, ceil do
			local tbl_5 = {}
			local tbl_6 = {}
			local tbl_7 = {}
			local tbl_8 = {}
			local num_2 = (i4 - 1) * min + 1
			local min_2 = math.min(i4 * min, num)
			local num_3 = 0

			for i5 = num_2, min_2 do
				local var_8_23 = tbl_2[i5]
				local var_8_24 = tbl_4[i5]
				local var_8_25 = tbl_3[i5]

				num_3 = num_3 + 1
				tbl_5[num_3] = var_8_23
				tbl_8[num_3] = var_8_24
				tbl_6[num_3] = Matrix4x4.translation(var_8_25)
				tbl_7[num_3] = Matrix4x4.rotation(var_8_25)
			end

			RPC.rpc_hot_join_sync_linker_transport_generic_units(var_8_4, unit_index, tbl_5, tbl_8, tbl_6, tbl_7)
		end
	end
end

LinkerTransportationExtension.rpc_hot_join_sync_linker_transporting = function (self, arg_9_1)
	-- function 9
	local unit = Managers.state.network.unit_storage:unit(arg_9_1)

	self:interacted_with(unit)
end

LinkerTransportationExtension.rpc_hot_join_sync_linker_transport_state = function (self, arg_10_1, arg_10_2)
	-- function 10
	self.story_state = tbl[arg_10_1]
	self.current_story_time = arg_10_2

	self:update_nav_obstacles()
end

LinkerTransportationExtension._link_all_transported_units = function (self, arg_11_1)
	-- function 11
	assert(not self:transporting(), "Trying to link units before unlinking.")

	if not self.is_server then
		Managers.state.event:trigger("event_delay_pacing", true)
	end

	if not Unit.alive(arg_11_1) then
		local flag = false
		local flag_2 = false

		self:_link_player_unit(arg_11_1, flag_2, flag)
	end

	if not self.takes_party then
		local PLAYER_AND_BOT_UNITS = self._side.PLAYER_AND_BOT_UNITS
		local _transported_ai_units = self._transported_ai_units

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_11_4 = PLAYER_AND_BOT_UNITS[i]

			if not alive(var_11_4) then
				if var_11_4 ~= arg_11_1 then
					local flag_3 = false
					local flag_4 = false

					self:_try_link_player(var_11_4, flag_4, flag_3)
				end

				if not self.is_server then
					local extension = ScriptUnit.extension(var_11_4, "ai_commander_system")

					if not extension then
						local get_controlled_units = extension:get_controlled_units()

						for k in pairs(get_controlled_units) do
							if not _transported_ai_units[k] then
								self:add_transporting_ai_unit(k)
							end
						end
					end
				end
			end
		end

		local count = #_transported_ai_units

		if not (not self.is_server and not (count > 0)) then
			local unit_storage = Managers.state.network.unit_storage
			local new_array = Script.new_array(count)
			local new_array_2 = Script.new_array(count)

			for k_2 = 1, count do
				local var_11_13 = _transported_ai_units[k_2]
				local unit = var_11_13.unit

				new_array_2[k_2], new_array[k_2] = var_11_13.slot_id, unit_storage:go_id(unit)
			end

			local unit_index = Level.unit_index(LevelHelper:current_level(self.world), self.unit)

			Managers.state.network.network_transmit:send_rpc_clients("rpc_add_transporting_ai_units", unit_index, new_array, new_array_2)
		end
	end

	local _get_inside_generic_units, var_11_17 = self:_get_inside_generic_units()

	for l = 1, var_11_17 do
		self:add_transporting_generic_unit(_get_inside_generic_units[l], nil, true)
	end

	Unit.flow_event(self.unit, "activate_collision")
end

LinkerTransportationExtension._try_link_player = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local extension = ScriptUnit.extension(arg_12_1, "status_system")
	local owner = Managers.player:owner(arg_12_1)
	local is_dead = extension:is_dead()
	local _is_inside_transportation_unit = self:_is_inside_transportation_unit(arg_12_1)
	local is_disabled = extension:is_disabled()

	if is_dead or _is_inside_transportation_unit or not arg_12_2 then
		local var_12_5 = self
		local _link_player_unit = self._link_player_unit
		local var_12_7 = arg_12_1
		local _is_bot = self:_is_bot(owner)

		_is_bot = not _is_bot and not arg_12_3

		_link_player_unit(var_12_5, var_12_7, _is_bot, arg_12_3)
	elseif not (not self:_is_bot(owner) and is_disabled) then
		self:_link_player_unit(owner.player_unit, not arg_12_3, arg_12_3)
	elseif not (not owner.local_player and is_dead or is_disabled or _is_inside_transportation_unit) then
		self:_link_player_unit(owner.player_unit, false, arg_12_3)
	end
end

LinkerTransportationExtension._is_inside_transportation_unit = function (self, arg_13_1, arg_13_2)
	-- function 13
	local oobb_mesh = self.oobb_mesh
	local box, var_13_2 = Mesh.box(oobb_mesh)
	local world_position = Unit.world_position(arg_13_1, 0)
	local distance = Vector3.distance(Unit.world_position(self.unit, 0), Unit.local_position(self.unit, 0))

	arg_13_2 = (arg_13_2 or 0) + distance
	var_13_2[1] = var_13_2[1] + arg_13_2
	var_13_2[2] = var_13_2[2] + arg_13_2
	var_13_2[3] = var_13_2[3] + arg_13_2

	return math.point_is_inside_oobb(world_position, box, var_13_2)
end

LinkerTransportationExtension._is_bot = function (self, arg_14_1)
	-- function 14
	if not self.is_server then
		return arg_14_1.bot_player
	elseif arg_14_1._player_controlled or not arg_14_1.local_player then
		return false
	else
		return true
	end
end

LinkerTransportationExtension.update_units_inside_oobb = function (self)
	-- function 15
	local unit = self.unit
	local oobb_mesh = self.oobb_mesh
	local box, var_15_3 = Mesh.box(oobb_mesh)
	local units_inside_oobb = self.units_inside_oobb

	for k, v in pairs(units_inside_oobb) do
		for k_2, v_2 in pairs(v.units) do
			if not HEALTH_ALIVE[k_2] then
				v.units[k_2] = nil
				v.count = v.count - 1
			end
		end
	end

	local alloc_table = FrameTable.alloc_table()

	alloc_table.human = {}
	alloc_table.ai = {}

	local players = Managers.player:players()

	for k_3, v_3 in pairs(players) do
		if not self:_is_bot(v_3) then
			local player_unit = v_3.player_unit

			if not HEALTH_ALIVE[player_unit] then
				local world_position = Unit.world_position(player_unit, 0)
				local point_is_inside_oobb = math.point_is_inside_oobb(world_position, box, var_15_3)

				alloc_table.human[player_unit] = point_is_inside_oobb
			end
		end
	end

	local broadphase = Managers.state.entity:system("ai_system").broadphase
	local world_position_2 = Unit.world_position(unit, 0)
	local alloc_table_2 = FrameTable.alloc_table()
	local query = Broadphase.query(broadphase, world_position_2, self.oobb_mesh_max_extent + 1, alloc_table_2)

	for i6 = 1, query do
		local var_15_14 = alloc_table_2[i6]

		if not HEALTH_ALIVE[var_15_14] then
			local world_position_3 = Unit.world_position(var_15_14, 0)
			local point_is_inside_oobb_2 = math.point_is_inside_oobb(world_position_3, box, var_15_3)

			alloc_table.ai[var_15_14] = point_is_inside_oobb_2
		end
	end

	for k_4, v_4 in pairs(alloc_table) do
		for k_5, v_5 in pairs(v_4) do
			local var_15_17 = units_inside_oobb[k_4]

			if not (not v_5 and var_15_17.units[k_5]) then
				var_15_17.units[k_5] = true
				var_15_17.count = var_15_17.count + 1
			elseif v_5 or not var_15_17.units[k_5] then
				var_15_17.units[k_5] = nil
				var_15_17.count = var_15_17.count - 1
			end
		end
	end

	for k_6, v_6 in pairs(alloc_table.human) do
		local extension = ScriptUnit.extension(k_6, "status_system")
		local flag = not v_6 and unit and nil

		extension:set_inside_transport_unit(flag)
	end
end

LinkerTransportationExtension.update_nav_obstacles = function (self)
	-- function 16
	if not self.has_nav_obstacles then
		return
	end

	local story_state = self.story_state
	local nav_obstacle_start = self.nav_obstacle_start
	local nav_obstacle_end = self.nav_obstacle_end

	if story_state == "stopped_beginning" then
		GwNavBoxObstacle.set_does_trigger_tagvolume(nav_obstacle_start, false)
		GwNavBoxObstacle.set_does_trigger_tagvolume(nav_obstacle_end, true)
	elseif story_state == "moving_forward" then
		GwNavBoxObstacle.set_does_trigger_tagvolume(nav_obstacle_start, true)
		GwNavBoxObstacle.set_does_trigger_tagvolume(nav_obstacle_end, true)
	elseif story_state == "stopped_end" then
		GwNavBoxObstacle.set_does_trigger_tagvolume(nav_obstacle_start, true)
		GwNavBoxObstacle.set_does_trigger_tagvolume(nav_obstacle_end, false)
	elseif story_state == "moving_backward" then
		GwNavBoxObstacle.set_does_trigger_tagvolume(nav_obstacle_start, true)
		GwNavBoxObstacle.set_does_trigger_tagvolume(nav_obstacle_end, true)
	end
end

LinkerTransportationExtension.update = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	local story_teller = self.story_teller
	local story_id = self.story_id
	local length = story_teller:length(story_id)
	local current_story_time = self.current_story_time
	local var_17_4 = current_story_time

	if self.story_state == "moving_forward" then
		var_17_4 = current_story_time + arg_17_3

		self:_update_local_player_position()

		if length <= var_17_4 then
			var_17_4 = length
			self.story_state = "stopped_end"

			if not self.auto_exit then
				self:update_nav_obstacles()
			end

			Unit.flow_event(self.unit, "lua_transportation_story_stopped")
		end
	elseif self.story_state == "stopped_end" then
		local units_inside_oobb = self.units_inside_oobb

		if not (not self.return_to_start and not units_inside_oobb and units_inside_oobb.human.count ~= 0 or units_inside_oobb.bot.count ~= 0) then
			self.story_state = "moving_backward"

			self:update_nav_obstacles()
			Unit.flow_event(self.unit, "lua_transportation_story_started")
		end
	elseif self.story_state == "moving_backward" then
		var_17_4 = current_story_time - arg_17_3

		if var_17_4 <= 0 then
			var_17_4 = 0
			self.story_state = "stopped_beginning"

			self:update_nav_obstacles()
			Unit.flow_event(self.unit, "lua_transportation_story_stopped")
		end
	end

	story_teller:set_time(story_id, var_17_4)

	self.current_story_time = var_17_4

	local units_inside_oobb_2 = self.units_inside_oobb

	if not (not units_inside_oobb_2 and not (arg_17_5 >= self.oobb_next_update)) then
		self:update_units_inside_oobb()

		local var_17_7

		if units_inside_oobb_2.human.count > 0 then
			var_17_7 = num_2

			if not var_17_7 then
				-- Nothing
			end
		end

		var_17_7 = num

		::label_17_0::

		self.oobb_next_update = arg_17_5 + var_17_7
	end

	self:_update_queued_removals(arg_17_5)
end

LinkerTransportationExtension.world_updated = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local unit = self.unit
	local unbox = self._old_position:unbox()
	local world_position = Unit.world_position(unit, 0)
	local local_position = Unit.local_position(unit, 0)
	local var_18_4 = Vector3(local_position[1], local_position[2], world_position[3])
	local num = var_18_4 - unbox

	self._movement_delta:store(num)

	local world_rotation = Unit.world_rotation(unit, 0)
	local unbox_2 = self._old_rotation:unbox()
	local multiply = Quaternion.multiply(world_rotation, Quaternion.inverse(unbox_2))

	self._rotation_delta:store(multiply)

	local unbox_3 = self._old_visual_delta:unbox()
	local rotate = Quaternion.rotate(Quaternion.inverse(Unit.world_rotation(unit, 0)), self:visual_delta())

	self._visual_movement_diff:store(rotate - unbox_3)
	self._old_position:store(var_18_4)
	self._old_rotation:store(world_rotation)
	self._old_visual_delta:store(rotate)
	self:_update_player_positions(arg_18_2)
	self:_update_transported_ai_positions()
	self:_update_transported_generic_unit_positions()
end

LinkerTransportationExtension.post_update = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	if not Managers.state.network:game() then
		return
	end

	if self.story_state ~= "moving_forward" then
		self:_update_passive_linking()
	end

	if not (self.story_state ~= "stopped_end" or self.story_state == self._last_story_state) then
		if not self.is_server then
			Managers.state.event:trigger("event_delay_pacing", false)
		end

		Unit.flow_event(self.unit, "deactivate_collision")
	end

	self._last_story_state = self.story_state
end

LinkerTransportationExtension._update_local_player_position = function (self)
	-- function 20
	local player = Managers.player
	local transported_units = self.transported_units
	local count = #transported_units

	for i = 1, count do
		repeat
			local var_20_3 = transported_units[i]

			if not Unit.alive(var_20_3) then
				break
			end

			local owner = player:owner(var_20_3)

			if not (not owner and owner.local_player) then
				break
			end

			local extension = ScriptUnit.extension(var_20_3, "locomotion_system")

			if extension:get_moving_platform() ~= self.unit then
				break
			end

			if not self:_is_inside_transportation_unit(var_20_3, 1) then
				local find = table.find(self._bot_slots, var_20_3)

				if find == nil then
					find = math.random(1, 4)
				end

				local _get_position_from_index = self:_get_position_from_index(find)
				local current_rotation = extension:current_rotation()

				extension:teleport_to(_get_position_from_index, current_rotation)
			end
		until true
	end
end

LinkerTransportationExtension.is_stationary = function (self)
	-- function 21
	return self.story_state == "stopped_beginning" or self.story_state == "stopped_end"
end

LinkerTransportationExtension.can_interact = function (self, arg_22_1)
	-- function 22
	return self.story_state == "stopped_beginning" or self.story_state ~= "stopped_end" or not not self.auto_exit or self.transported_units[arg_22_1]
end

LinkerTransportationExtension.destroy = function (self)
	-- function 23
	if not Managers.state.event then
		Managers.state.event:unregister("new_player_unit", self)
		Managers.state.event:unregister("pickup_spawned", self)
	end

	if not self:transporting() and not self.is_server then
		Managers.state.event:trigger("event_delay_pacing", false)
	end

	if not self.has_nav_obstacles then
		GwNavBoxObstacle.destroy(self.nav_obstacle_start)

		self.nav_obstacle_start = nil

		GwNavBoxObstacle.destroy(self.nav_obstacle_end)

		self.nav_obstacle_end = nil
	end

	if not self.units_inside_oobb then
		local units = self.units_inside_oobb.human.units

		for k, v in pairs(units) do
			if not alive(k) then
				ScriptUnit.extension(k, "status_system"):set_inside_transport_unit(nil)
			end
		end

		self.units_inside_oobb = nil
	end

	self.transported_units = nil
	self.oobb_mesh = nil
end

LinkerTransportationExtension._update_passive_linking = function (self)
	-- function 24
	local transported_units = self.transported_units

	for i = #transported_units, 1, -1 do
		local var_24_1 = transported_units[i]

		if not alive(var_24_1) then
			self:_unlink_player_unit(var_24_1)
		elseif not set[self.story_state] then
			local has_extension = ScriptUnit.has_extension(var_24_1, "locomotion_system")

			if not has_extension then
				local get_moving_platform, var_24_4, var_24_5 = has_extension:get_moving_platform()

				if not var_24_5 then
					self:_link_player_unit(var_24_1, false, true)
				end
			end
		end
	end

	local flag = true
	local flag_2 = false
	local players = Managers.player:players()

	for k, v in pairs(players) do
		local player_unit = v.player_unit

		if not alive(player_unit) then
			local var_24_10 = self
			local _is_inside_transportation_unit = self._is_inside_transportation_unit
			local var_24_12 = player_unit
			local flag_3

			flag_3 = not transported_units[player_unit] and 1 and nil

			if not _is_inside_transportation_unit(var_24_10, var_24_12, flag_3) then
				if not transported_units[player_unit] then
					self:_try_link_player(player_unit, flag_2, flag)
				end
			elseif not transported_units[player_unit] then
				self:_unlink_player_unit(player_unit)
			end
		end
	end

	local _transported_ai_units = self._transported_ai_units

	for l = #_transported_ai_units, 1, -1 do
		local unit = _transported_ai_units[l].unit

		self:queue_ai_transport_unit_for_removal(unit, false)
	end

	local _transported_generic_units = self._transported_generic_units

	for k_2, v_2 in pairs(_transported_generic_units) do
		if not alive(k_2) then
			local var_24_17 = self
			local _is_inside_transportation_unit_2 = self._is_inside_transportation_unit
			local var_24_19 = k_2
			local flag_4

			flag_4 = not _transported_generic_units[k_2] and 1 and nil

			if not _is_inside_transportation_unit_2(var_24_17, var_24_19, flag_4) then
				-- Nothing
			end
		end

		_transported_generic_units[k_2] = nil

		::label_24_0::
	end
end

LinkerTransportationExtension._unlink_player_unit = function (self, arg_25_1)
	-- function 25
	local transported_units = self.transported_units

	if not transported_units[arg_25_1] then
		return
	end

	self._transportation_system:clear_transporter_by_linked_unit(arg_25_1)

	transported_units[arg_25_1] = nil

	table.swap_delete(transported_units, table.index_of(transported_units, arg_25_1))

	local unit = self.unit
	local owner = Managers.player:owner(arg_25_1)
	local find = table.find(self._bot_slots, arg_25_1)

	if not find then
		table.remove(self._bot_slots, find)
	end

	local has_extension = ScriptUnit.has_extension(arg_25_1, "status_system")

	if not has_extension then
		has_extension:set_using_transport(false)
	end

	if not owner and (owner.local_player or not self.is_server or not owner.bot_player) then
		local has_extension_2 = ScriptUnit.has_extension(arg_25_1, "locomotion_system")

		if not has_extension_2 then
			has_extension_2:set_on_moving_platform(nil)

			if not self.teleport_on_exit then
				local world_position = Unit.world_position(unit, Unit.node(unit, "g_end"))
				local current_rotation = has_extension_2:current_rotation()

				has_extension_2:teleport_to(world_position, current_rotation)
			end
		end
	end
end

LinkerTransportationExtension._get_position_from_index = function (self, arg_26_1)
	-- function 26
	local unit = self.unit
	local var_26_1

	if not Unit.has_node(unit, "elevator_slot_0" .. arg_26_1) then
		local node = Unit.node(unit, "elevator_slot_0" .. arg_26_1)

		var_26_1 = Unit.world_position(unit, node)
	end

	return var_26_1
end

LinkerTransportationExtension._teleport_bot = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	if arg_27_1 or not self.teleport_on_enter then
		local num = #self._bot_slots + 1

		self._bot_slots[num] = arg_27_3

		local _get_position_from_index = self:_get_position_from_index(num)

		if not arg_27_2.remote then
			local current_rotation = arg_27_4:current_rotation()

			arg_27_4:teleport_to(_get_position_from_index, current_rotation)
		end
	end
end

LinkerTransportationExtension._link_player_unit = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local extension = ScriptUnit.extension(arg_28_1, "locomotion_system")
	local owner = Managers.player:owner(arg_28_1)
	local transported_units = self.transported_units

	if not transported_units[arg_28_1] then
		if not owner.remote then
			local get_moving_platform, var_28_4, var_28_5 = extension:get_moving_platform()

			if var_28_5 ~= arg_28_3 then
				extension:set_on_moving_platform(self.unit, arg_28_3)
				self:_teleport_bot(arg_28_2, owner, arg_28_1, extension)
			end
		end

		return
	end

	local flag = not arg_28_3

	if not self._transportation_system:try_claim_unit(arg_28_1, self, flag) then
		return
	end

	transported_units[#transported_units + 1] = arg_28_1
	transported_units[arg_28_1] = true

	local unit = self.unit

	self:_teleport_bot(arg_28_2, owner, arg_28_1, extension)

	if Managers.state.side.side_by_unit[arg_28_1].side_id ~= self._side.side_id then
		ScriptUnit.extension(arg_28_1, "status_system"):set_using_transport(true)
	end

	if not owner.remote then
		extension:set_on_moving_platform(unit, arg_28_3)
	end
end

LinkerTransportationExtension.assign_position_to_bot = function (self)
	-- function 29
	return Unit.world_position(self.unit, 0)
end

local num_3 = 0.5

LinkerTransportationExtension.get_ai_slot = function (self, arg_30_1)
	-- function 30
	local unit = self.unit

	if not self._ai_slot_offsets then
		local tbl = {}
		local num = 100
		local num_2 = 0.1
		local num_4 = 1

		while not Unit.has_node(unit, "elevator_slot_0" .. num_4) do
			local node = Unit.node(unit, "elevator_slot_0" .. num_4)
			local local_position = Unit.local_position(unit, node)
			local var_30_7

			for i = 1, #tbl do
				local unbox = tbl[i].center:unbox()

				if not (not (num_2 > math.abs(unbox[3] - local_position[3])) or not (num > Vector3.distance_squared(Vector3.flat(unbox), Vector3.flat(local_position)))) then
					var_30_7 = i

					break
				end
			end

			var_30_7 = var_30_7 or #tbl + 1

			local var_30_9 = tbl[var_30_7]

			if not var_30_9 then
				table.insert(var_30_9.positions, Vector3Box(local_position))

				local zero = Vector3.zero()

				for j = 1, #var_30_9.positions do
					zero = zero + var_30_9.positions[j]:unbox()
				end

				var_30_9.center:store(zero / #var_30_9.positions)
				var_30_9.min:store(Vector3.min(var_30_9.min:unbox(), local_position))
				var_30_9.max:store(Vector3.max(var_30_9.max:unbox(), local_position))
			else
				tbl[var_30_7] = {
					positions = {
						Vector3Box(local_position)
					},
					center = Vector3Box(local_position),
					min = Vector3Box(local_position),
					max = Vector3Box(local_position)
				}
			end

			num_4 = num_4 + 1
		end

		self._ai_slot_offsets = tbl

		for k = 1, #tbl do
			local var_30_11 = tbl[k]
			local unbox_2 = var_30_11.min:unbox()
			local unbox_3 = var_30_11.max:unbox()
			local num_5 = 0.7
			local lerp = Vector3.lerp(unbox_2, unbox_3, 0.5)
			local num_6 = Vector3.normalize(unbox_3 - lerp) * num_5
			local num_7 = unbox_2 + num_6
			local num_8 = unbox_3 - num_6 - num_7
			local ceil

			if num_8.x > 0 then
				ceil = math.ceil(num_8.x / num_3)

				if not ceil then
					-- Nothing
				end
			end

			ceil = 1

			do
				local ceil_2
			end

			::label_30_0::

			if num_8.y > 0 then
				ceil_2 = math.ceil(num_8.y / num_3)

				if not ceil_2 then
					-- Nothing
				end
			end

			ceil_2 = 1

			::label_30_1::

			var_30_11.num_slots_x = ceil
			var_30_11.num_slots_y = ceil_2
			var_30_11.offset_start = Vector3Box(num_7)
		end
	end

	local var_30_21 = self._ai_slot_offsets[math.index_wrapper(arg_30_1, #self._ai_slot_offsets)]
	local unbox_4 = var_30_21.offset_start:unbox()
	local num_9 = math.ceil(arg_30_1 / #self._ai_slot_offsets) % var_30_21.num_slots_x
	local num_10 = math.floor(arg_30_1 / var_30_21.num_slots_x) % var_30_21.num_slots_y
	local _pose = self:_pose()

	return (Matrix4x4.transform(_pose, unbox_4 + Vector3(num_9 * num_3, num_10 * num_3, 0)))
end

LinkerTransportationExtension.add_transporting_ai_unit = function (self, arg_31_1)
	-- function 31
	if not self._transportation_system:try_claim_unit(arg_31_1, self) then
		return
	end

	local _transported_ai_units = self._transported_ai_units
	local _transported_ai_unit_freelist = self._transported_ai_unit_freelist
	local num = #_transported_ai_units + 1
	local count = #_transported_ai_unit_freelist
	local var_31_4 = _transported_ai_unit_freelist[count]

	var_31_4 = var_31_4 or {
		slot_id = num
	}
	_transported_ai_unit_freelist[count] = nil
	var_31_4.unit = arg_31_1
	_transported_ai_units[num] = var_31_4
	_transported_ai_units[arg_31_1] = num

	if not self.is_server then
		local var_31_5 = BLACKBOARDS[arg_31_1]

		if not var_31_5 then
			var_31_5.is_transported = self
			var_31_5.transport_slot_id = var_31_4.slot_id
		end
	end

	self._queued_ai_units_to_remove[arg_31_1] = nil
end

LinkerTransportationExtension.add_transporting_generic_unit = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	if not self._transported_generic_units[arg_32_1] then
		return
	end

	if not self._transportation_system:try_claim_unit(arg_32_1, self) then
		return
	end

	local flag = arg_32_2 or Matrix4x4.multiply(Unit.world_pose(arg_32_1, 0), Matrix4x4.inverse(self:_pose()))

	self._transported_generic_units[arg_32_1] = Matrix4x4Box(flag)

	if not self.is_server then
		local unit_index = Level.unit_index(LevelHelper:current_level(self.world), self.unit)
		local game_object_or_level_id, var_32_3 = Managers.state.network:game_object_or_level_id(arg_32_1)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_add_transporting_generic_unit", unit_index, game_object_or_level_id, var_32_3, Matrix4x4.translation(flag), Matrix4x4.rotation(flag))
	end
end

LinkerTransportationExtension._remove_transporting_generic_unit = function (self, arg_33_1)
	-- function 33
	if not self._transported_generic_units[arg_33_1] then
		return
	end

	self._transported_generic_units[arg_33_1] = nil

	self._transportation_system:clear_transporter_by_linked_unit(arg_33_1)
end

LinkerTransportationExtension.force_unlink_unit = function (self, arg_34_1)
	-- function 34
	self:_unlink_player_unit(arg_34_1)
	self:_remove_transporting_generic_unit(arg_34_1)
	self:remove_transporting_ai_unit(arg_34_1)
end

LinkerTransportationExtension.queue_ai_transport_unit_for_removal = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not self.is_server then
		local _queued_ai_units_to_remove = self._queued_ai_units_to_remove
		local flag

		flag = not arg_35_2 and "soft" and "hard"
		_queued_ai_units_to_remove[arg_35_1] = flag
	elseif not arg_35_2 then
		self:_transporting_ai_unit_soft_removal(arg_35_1)
	else
		self:remove_transporting_ai_unit(arg_35_1)
	end
end

LinkerTransportationExtension._update_queued_removals = function (self, arg_36_1)
	-- function 36
	local var_36_0 = next(self._queued_ai_units_to_remove, self._last_checked_queued_removal)

	self._last_checked_queued_removal = var_36_0

	if not var_36_0 then
		if not ALIVE[var_36_0] then
			self:remove_transporting_ai_unit(var_36_0)

			self._queued_ai_units_to_remove[var_36_0] = nil

			return
		end

		local var_36_1 = POSITION_LOOKUP[var_36_0]

		if not GwNavQueries.triangle_from_position(GLOBAL_AI_NAVWORLD, var_36_1, 1, 1) then
			if self._queued_ai_units_to_remove[var_36_0] == "soft" then
				self:_transporting_ai_unit_soft_removal(var_36_0)
			else
				self:remove_transporting_ai_unit(var_36_0)

				self._queued_ai_units_to_remove[var_36_0] = nil
			end

			return
		end
	end
end

LinkerTransportationExtension._transporting_ai_unit_soft_removal = function (self, arg_37_1)
	-- function 37
	if not self.is_server then
		local var_37_0 = BLACKBOARDS[arg_37_1]

		if not (not var_37_0 and var_37_0.is_transported ~= self) then
			var_37_0.is_transported = nil
			var_37_0.transport_slot_id = nil
		end
	end
end

LinkerTransportationExtension.remove_transporting_ai_unit = function (self, arg_38_1)
	-- function 38
	local _transported_ai_units = self._transported_ai_units
	local var_38_1 = _transported_ai_units[arg_38_1]

	if not var_38_1 then
		return
	end

	self:_transporting_ai_unit_soft_removal(arg_38_1)
	self._transportation_system:clear_transporter_by_linked_unit(arg_38_1)
	table.insert(self._transported_ai_unit_freelist, table.swap_delete(_transported_ai_units, var_38_1))

	_transported_ai_units[arg_38_1] = nil

	self._transportation_system:clear_transporter_by_linked_unit(arg_38_1)

	local var_38_2 = _transported_ai_units[var_38_1]

	if not var_38_2 then
		_transported_ai_units[var_38_2.unit] = var_38_1
	end
end

LinkerTransportationExtension._update_player_positions = function (self, arg_39_1)
	-- function 39
	local world_position = Unit.world_position(self.unit, 0)
	local visual_diff_delta = self:visual_diff_delta()
	local num = self._movement_delta:unbox() + visual_diff_delta
	local unbox = self._rotation_delta:unbox()
	local transported_units = self.transported_units

	for i = #transported_units, 1, -1 do
		local var_39_5 = transported_units[i]

		if not ALIVE[var_39_5] then
			local mover = Unit.mover(var_39_5)
			local position = Mover.position(mover)
			local num_2 = position + num
			local num_3 = position + (num_2 - position) * 0.5 - world_position
			local num_4 = num_2 + (Quaternion.rotate(unbox, num_3) - num_3)

			Mover.set_position(mover, num_4)
			Unit.set_local_position(var_39_5, 0, num_4)

			local num_5 = num_4 - position
			local get_data = Unit.get_data(var_39_5, "accumulated_movement")

			get_data = get_data or Vector3.zero()

			Unit.set_data(var_39_5, "accumulated_movement", get_data + num_5)

			local has_extension = ScriptUnit.has_extension(var_39_5, "first_person_system")

			if not has_extension then
				local get_first_person_unit = has_extension:get_first_person_unit()
				local num_6 = Unit.local_position(get_first_person_unit, 0) + num

				Unit.set_local_position(get_first_person_unit, 0, num_6)
			end
		end
	end
end

LinkerTransportationExtension._update_transported_ai_positions = function (self)
	-- function 40
	local flag = not set[self.story_state]
	local flag_2 = not flag and self._movement_delta:unbox()
	local _transported_ai_units = self._transported_ai_units

	for i = #_transported_ai_units, 1, -1 do
		local var_40_3 = _transported_ai_units[i]
		local unit = var_40_3.unit
		local slot_id = var_40_3.slot_id

		if not ALIVE[unit] then
			local var_40_6 = POSITION_LOOKUP[unit]
			local num

			if not flag then
				num = var_40_6 + flag_2

				if not num then
					-- Nothing
				end
			end

			num = self:get_ai_slot(slot_id)

			::label_40_0::

			local has_extension = ScriptUnit.has_extension(unit, "locomotion_system")

			if not has_extension then
				local world_rotation = Unit.world_rotation(unit, 0)
				local num_2 = num - POSITION_LOOKUP[unit]

				has_extension:teleport_to(num, world_rotation, num_2, true)
			else
				Unit.set_local_position(unit, 0, num)
			end
		else
			self:remove_transporting_ai_unit(unit)
		end
	end
end

LinkerTransportationExtension._update_transported_generic_unit_positions = function (self)
	-- function 41
	local visual_diff_delta = self:visual_diff_delta()
	local num = self._movement_delta:unbox() + visual_diff_delta
	local _pose = self:_pose()

	for k, v in pairs(self._transported_generic_units) do
		if not Unit.alive(k) then
			local flag = false

			for k_2 = 1, Unit.num_actors(k) do
				local actor = Unit.actor(k, k_2 - 1)

				if not actor and not Actor.is_physical(actor) then
					flag = true

					Actor.set_update_enabled(actor, false)
					Actor.put_to_sleep(actor)
				end
			end

			local var_41_5

			if ScriptUnit.has_extension(k, "projectile_locomotion_system") or not ScriptUnit.has_extension(k, "locomotion_system") then
				var_41_5 = Matrix4x4.multiply(Matrix4x4.from_translation(num), Unit.local_pose(k, 0))
			else
				var_41_5 = Matrix4x4.multiply(v:unbox(), _pose)
			end

			self:_move_generic_unit(k, var_41_5)

			if not flag then
				World.update_unit(self.world, k)
			end
		else
			self._transported_generic_units[k] = nil
		end
	end
end

LinkerTransportationExtension._move_generic_unit = function (arg_42_0, arg_42_1, arg_42_2)
	-- function 42
	if not ScriptUnit.has_extension(arg_42_1, "pickup_system") then
		Managers.state.entity:system("pickup_system"):move_pickup_local_pose(arg_42_1, arg_42_2)

		return
	end

	local has_extension = ScriptUnit.has_extension(arg_42_1, "props_system")

	if not has_extension then
		if not has_extension.move_prop then
			has_extension:move_prop(arg_42_2)
		end

		return
	end

	local translation = Matrix4x4.translation(arg_42_2)
	local rotation = Matrix4x4.rotation(arg_42_2)

	Unit.set_local_position(arg_42_1, 0, translation)
	Unit.set_local_rotation(arg_42_1, 0, rotation)
end

LinkerTransportationExtension.on_player_unit_spawned = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	if Managers.state.side.side_by_unit[arg_43_2] ~= self._side then
		return
	end

	if not self:transporting() then
		local remote = arg_43_1.remote

		self:_try_link_player(arg_43_2, remote)
	end
end

LinkerTransportationExtension.on_pickup_spawned = function (self, arg_44_1)
	-- function 44
	if not self._reference_teleport_unit then
		self:teleport_non_character_elevator_units(self._reference_teleport_unit)

		return
	end

	if not self:_is_inside_transportation_unit(arg_44_1) then
		if not self.is_server then
			self:add_transporting_generic_unit(arg_44_1, nil, false)
		else
			self:add_transporting_generic_unit(arg_44_1, nil, true)
		end
	end
end

LinkerTransportationExtension.on_sister_wall_spawned = function (self, arg_45_1)
	-- function 45
	if not self._reference_teleport_unit then
		self:teleport_non_character_elevator_units(self._reference_teleport_unit)

		return
	end

	if not self:_is_inside_transportation_unit(arg_45_1) then
		if not self.is_server then
			self:add_transporting_generic_unit(arg_45_1, nil, false)
		else
			self:add_transporting_generic_unit(arg_45_1, nil, true)
		end
	end
end

local tbl_2 = {}

LinkerTransportationExtension._get_inside_generic_units = function (self)
	-- function 46
	table.clear(tbl_2)

	local num = 0
	local system = Managers.state.entity:system("pickup_system")
	local world_position = Unit.world_position(self.unit, 0)
	local _nearby_pickup_cache = self._nearby_pickup_cache
	local get_pickups = system:get_pickups(world_position, self.oobb_mesh_max_extent + 1, _nearby_pickup_cache)

	for i = 1, get_pickups do
		local var_46_5 = _nearby_pickup_cache[i]

		if not self:_is_inside_transportation_unit(var_46_5) then
			num = num + 1
			tbl_2[num] = var_46_5
		end
	end

	local get_entities = Managers.state.entity:get_entities("ThornSisterWallExtension")

	for k, v in pairs(get_entities) do
		if not self:_is_inside_transportation_unit(k) then
			num = num + 1
			tbl_2[num] = k
		end
	end

	local get_available_and_active_respawn_units = Managers.state.game_mode:game_mode():get_available_and_active_respawn_units()

	for l = 1, #get_available_and_active_respawn_units do
		local unit = get_available_and_active_respawn_units[l].unit

		if not self:_is_inside_transportation_unit(unit) then
			num = num + 1
			tbl_2[num] = unit
		end
	end

	return tbl_2, num
end

LinkerTransportationExtension.teleport_non_character_elevator_units = function (self, arg_47_1)
	-- function 47
	self._reference_teleport_unit = arg_47_1

	local _reference_teleport_seed = self._reference_teleport_seed

	_reference_teleport_seed = _reference_teleport_seed or Managers.mechanism:get_level_seed()
	self._reference_teleport_seed = _reference_teleport_seed

	local function fn()
		-- function 48
		local local_position = Unit.local_position(arg_47_1, 0)
		local num = 3
		local num_2 = 3

		local function fn(arg_49_0, arg_49_1)
			-- function 49
			local var_49_0
			local num_3 = 1

			while num_3 <= num_2 do
				local get_uniformly_random_point_inside_sector_seeded, var_49_3, var_49_4 = math.get_uniformly_random_point_inside_sector_seeded(self._reference_teleport_seed, 0, num, 0, math.tau)

				self._reference_teleport_seed = get_uniformly_random_point_inside_sector_seeded
				var_49_0 = local_position + Vector3(var_49_3, var_49_4, 0)

				local triangle_from_position, var_49_6 = GwNavQueries.triangle_from_position(GLOBAL_AI_NAVWORLD, var_49_0, 1, 1)

				if not triangle_from_position then
					var_49_0 = Vector3(var_49_0.x, var_49_0.y, var_49_6)

					break
				end

				num_3 = num_3 + 1
			end

			var_49_0 = var_49_0 or local_position

			if not arg_49_1 then
				arg_49_1:teleport_to(var_49_0)
			else
				local from_quaternion_position_scale = Matrix4x4.from_quaternion_position_scale(Unit.local_rotation(arg_49_0, 0), var_49_0, Unit.local_scale(arg_49_0, 0))

				self:_move_generic_unit(arg_49_0, from_quaternion_position_scale)

				self._transported_generic_units[arg_49_0] = nil
			end
		end

		local _get_inside_generic_units, var_48_5 = self:_get_inside_generic_units()

		table.sort(_get_inside_generic_units, function (arg_50_0, arg_50_1)
			-- function 50
			local go_id = Managers.state.unit_storage:go_id(arg_50_0)

			go_id = go_id or HashUtils.fnv32_hash(tostring(arg_50_0))

			local go_id_2 = Managers.state.unit_storage:go_id(arg_50_1)

			go_id_2 = go_id_2 or HashUtils.fnv32_hash(tostring(arg_50_1))

			return go_id < go_id_2
		end)

		for i = 1, var_48_5 do
			local var_48_6 = _get_inside_generic_units[i]

			fn(var_48_6)
		end

		for k, v in pairs(Managers.player:players()) do
			local player_unit = v.player_unit

			if not Unit.alive(player_unit) and not self:_is_inside_transportation_unit(player_unit) then
				local extension = ScriptUnit.extension(player_unit, "locomotion_system")

				fn(player_unit, extension)
			end
		end
	end

	Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)
end

LinkerTransportationExtension.transporting = function (self)
	-- function 51
	return set[self.story_state]
end

LinkerTransportationExtension.beginning = function (self)
	-- function 52
	return self.story_state == "stopped_beginning"
end

LinkerTransportationExtension._reference_node = function (self)
	-- function 53
	local unit = self.unit

	if not alive(unit) then
		if not Unit.has_node(unit, "rp_g_trade") then
			return Unit.node(unit, "rp_g_trade")
		end

		if not Unit.has_node(unit, "rp_transport") then
			return Unit.node(unit, "rp_transport")
		end
	end

	return 0
end

LinkerTransportationExtension._pose = function (self)
	-- function 54
	local unit = self.unit

	return Unit.world_pose(unit, self:_reference_node())
end
