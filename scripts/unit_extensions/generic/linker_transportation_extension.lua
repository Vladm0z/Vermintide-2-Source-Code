-- chunkname: @scripts/unit_extensions/generic/linker_transportation_extension.lua

require("scripts/helpers/navigation_utils")

LinkerTransportationExtension = class(LinkerTransportationExtension)

local var_0_0 = 1
local var_0_1 = 0.05
local var_0_2 = table.set({
	"moving_forward",
	"moving_backward"
})
local var_0_3 = {
	"stopped_beginning",
	"moving_forward",
	"moving_backward",
	"stopped_end"
}

for iter_0_0, iter_0_1 in ipairs(var_0_3) do
	var_0_3[iter_0_1] = iter_0_0
end

local var_0_4 = Unit.alive

LinkerTransportationExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0._transportation_system = arg_1_1.owning_system

	local var_1_0 = Unit.get_data(arg_1_2, "transportation_data", "story_name")
	local var_1_1 = World.storyteller(arg_1_0.world)
	local var_1_2 = LevelHelper:current_level(arg_1_0.world)

	arg_1_0._bot_slots_offset = {
		0,
		1,
		-1
	}
	arg_1_0._bot_slots = {}
	arg_1_0.story_teller = var_1_1

	local var_1_3 = var_1_1:play_level_story(var_1_2, var_1_0)

	arg_1_0.story_id = var_1_3

	var_1_1:set_speed(var_1_3, 0)

	arg_1_0.story_state = "stopped_beginning"
	arg_1_0.current_story_time = 0
	arg_1_0.auto_exit = Unit.get_data(arg_1_2, "transportation_data", "auto_exit")
	arg_1_0.teleport_on_enter = Unit.get_data(arg_1_2, "transportation_data", "teleport_on_enter")
	arg_1_0.teleport_on_exit = Unit.get_data(arg_1_2, "transportation_data", "teleport_on_exit")
	arg_1_0.takes_party = Unit.get_data(arg_1_2, "transportation_data", "takes_party")
	arg_1_0.return_to_start = Unit.get_data(arg_1_2, "transportation_data", "return_to_start")
	arg_1_0.transported_units = {}
	arg_1_0._transported_ai_units = {}
	arg_1_0._transported_ai_unit_freelist = {}
	arg_1_0._transported_generic_units = {}
	arg_1_0.has_nav_obstacles = false

	local var_1_4 = Unit.get_data(arg_1_2, "transportation_data", "bounding_box_mesh")

	if var_1_4 ~= "" then
		local var_1_5 = Unit.mesh(arg_1_2, var_1_4)
		local var_1_6, var_1_7 = Mesh.box(var_1_5)

		arg_1_0.oobb_mesh_max_extent = math.max(var_1_7.x, var_1_7.y, var_1_7.z)
		arg_1_0.oobb_mesh = var_1_5
		arg_1_0.oobb_next_update = 0
		arg_1_0.units_inside_oobb = {
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

	arg_1_0._movement_delta = Vector3Box(0, 0, 0)
	arg_1_0._visual_movement_diff = Vector3Box(0, 0, 0)
	arg_1_0._rotation_delta = QuaternionBox(Quaternion.identity())
	arg_1_0._old_position = Vector3Box(Unit.local_position(arg_1_2, 0))
	arg_1_0._old_rotation = QuaternionBox(Unit.local_rotation(arg_1_2, 0))
	arg_1_0._original_visual_delta = Vector3Box(arg_1_0:visual_delta(true))
	arg_1_0._old_visual_delta = Vector3Box(arg_1_0._original_visual_delta:unbox())
	arg_1_0._unlink_after_update = false
	arg_1_0._side = Managers.state.side:get_side_from_name("heroes")

	Managers.state.event:register(arg_1_0, "new_player_unit", "on_player_unit_spawned")
	Managers.state.event:register(arg_1_0, "pickup_spawned", "on_pickup_spawned")
	Managers.state.event:register(arg_1_0, "sister_wall_spawned", "on_sister_wall_spawned")

	arg_1_0._queued_ai_units_to_remove = {}
	arg_1_0._nearby_pickup_cache = {}
end

LinkerTransportationExtension.extensions_ready = function (arg_2_0)
	return
end

LinkerTransportationExtension.movement_delta = function (arg_3_0)
	return arg_3_0._movement_delta:unbox(), arg_3_0._rotation_delta:unbox()
end

LinkerTransportationExtension.visual_delta = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.unit
	local var_4_1 = arg_4_0:_reference_node()
	local var_4_2 = Unit.world_position(var_4_0, var_4_1) - Unit.world_position(var_4_0, 0)
	local var_4_3 = Quaternion.rotate(Quaternion.inverse(Unit.world_rotation(var_4_0, 0)), var_4_2)

	if arg_4_1 then
		return var_4_3
	end

	return var_4_3 - arg_4_0._original_visual_delta:unbox()
end

LinkerTransportationExtension.visual_diff_delta = function (arg_5_0)
	return arg_5_0._visual_movement_diff:unbox()
end

LinkerTransportationExtension.register_navmesh_units = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = GLOBAL_AI_NAVWORLD
	local var_6_1, var_6_2 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(var_6_0, arg_6_1)

	GwNavBoxObstacle.add_to_world(var_6_1)
	GwNavBoxObstacle.set_transform(var_6_1, var_6_2)

	local var_6_3, var_6_4 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(var_6_0, arg_6_2)

	GwNavBoxObstacle.add_to_world(var_6_3)
	GwNavBoxObstacle.set_transform(var_6_3, var_6_4)

	arg_6_0.nav_obstacle_start = var_6_1
	arg_6_0.nav_obstacle_end = var_6_3
	arg_6_0.has_nav_obstacles = true

	arg_6_0:update_nav_obstacles()
end

LinkerTransportationExtension.interacted_with = function (arg_7_0, arg_7_1)
	arg_7_0:_link_all_transported_units(arg_7_1)

	if arg_7_0.story_state == "stopped_beginning" then
		arg_7_0.story_state = "moving_forward"

		Unit.flow_event(arg_7_0.unit, "lua_transportation_story_started")
	end

	arg_7_0:update_nav_obstacles()
end

LinkerTransportationExtension.hot_join_sync = function (arg_8_0, arg_8_1)
	local var_8_0 = Managers.state.network
	local var_8_1 = Level.unit_index(LevelHelper:current_level(arg_8_0.world), arg_8_0.unit)
	local var_8_2 = arg_8_0.story_state
	local var_8_3 = arg_8_0.current_story_time
	local var_8_4 = PEER_ID_TO_CHANNEL[arg_8_1]

	if arg_8_0:transporting() then
		local var_8_5

		for iter_8_0, iter_8_1 in ipairs(arg_8_0.transported_units) do
			if Unit.alive(iter_8_1) then
				var_8_5 = iter_8_1

				break
			end
		end

		if var_8_5 then
			local var_8_6 = var_8_0:unit_game_object_id(var_8_5)

			RPC.rpc_hot_join_sync_linker_transporting(var_8_4, var_8_1, var_8_6)
		end
	end

	RPC.rpc_hot_join_sync_linker_transport_state(var_8_4, var_8_1, var_0_3[var_8_2], var_8_3)

	local var_8_7 = arg_8_0._transported_generic_units

	if not table.is_empty(var_8_7) then
		local var_8_8 = {}
		local var_8_9 = {}
		local var_8_10 = {}
		local var_8_11 = 0

		for iter_8_2, iter_8_3 in pairs(var_8_7) do
			local var_8_12, var_8_13 = var_8_0:game_object_or_level_id(iter_8_2)

			if var_8_12 then
				var_8_11 = var_8_11 + 1
				var_8_8[var_8_11] = var_8_12
				var_8_9[var_8_11] = iter_8_3:unbox()
				var_8_10[var_8_11] = var_8_13
			end
		end

		local var_8_14 = table.min({
			Network.type_info("game_object_id_array").max_size,
			Network.type_info("position_array").max_size,
			Network.type_info("rotation_array").max_size,
			Network.type_info("bool_array").max_size
		})
		local var_8_15 = math.ceil(var_8_11 / var_8_14)

		for iter_8_4 = 1, var_8_15 do
			local var_8_16 = {}
			local var_8_17 = {}
			local var_8_18 = {}
			local var_8_19 = {}
			local var_8_20 = (iter_8_4 - 1) * var_8_14 + 1
			local var_8_21 = math.min(iter_8_4 * var_8_14, var_8_11)
			local var_8_22 = 0

			for iter_8_5 = var_8_20, var_8_21 do
				local var_8_23 = var_8_8[iter_8_5]
				local var_8_24 = var_8_10[iter_8_5]
				local var_8_25 = var_8_9[iter_8_5]

				var_8_22 = var_8_22 + 1
				var_8_16[var_8_22] = var_8_23
				var_8_19[var_8_22] = var_8_24
				var_8_17[var_8_22] = Matrix4x4.translation(var_8_25)
				var_8_18[var_8_22] = Matrix4x4.rotation(var_8_25)
			end

			RPC.rpc_hot_join_sync_linker_transport_generic_units(var_8_4, var_8_1, var_8_16, var_8_19, var_8_17, var_8_18)
		end
	end
end

LinkerTransportationExtension.rpc_hot_join_sync_linker_transporting = function (arg_9_0, arg_9_1)
	local var_9_0 = Managers.state.network.unit_storage:unit(arg_9_1)

	arg_9_0:interacted_with(var_9_0)
end

LinkerTransportationExtension.rpc_hot_join_sync_linker_transport_state = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.story_state = var_0_3[arg_10_1]
	arg_10_0.current_story_time = arg_10_2

	arg_10_0:update_nav_obstacles()
end

LinkerTransportationExtension._link_all_transported_units = function (arg_11_0, arg_11_1)
	assert(not arg_11_0:transporting(), "Trying to link units before unlinking.")

	if arg_11_0.is_server then
		Managers.state.event:trigger("event_delay_pacing", true)
	end

	if Unit.alive(arg_11_1) then
		local var_11_0 = false
		local var_11_1 = false

		arg_11_0:_link_player_unit(arg_11_1, var_11_1, var_11_0)
	end

	if arg_11_0.takes_party then
		local var_11_2 = arg_11_0._side.PLAYER_AND_BOT_UNITS
		local var_11_3 = arg_11_0._transported_ai_units

		for iter_11_0 = 1, #var_11_2 do
			local var_11_4 = var_11_2[iter_11_0]

			if var_0_4(var_11_4) then
				if var_11_4 ~= arg_11_1 then
					local var_11_5 = false
					local var_11_6 = false

					arg_11_0:_try_link_player(var_11_4, var_11_6, var_11_5)
				end

				if arg_11_0.is_server then
					local var_11_7 = ScriptUnit.extension(var_11_4, "ai_commander_system")

					if var_11_7 then
						local var_11_8 = var_11_7:get_controlled_units()

						for iter_11_1 in pairs(var_11_8) do
							if not var_11_3[iter_11_1] then
								arg_11_0:add_transporting_ai_unit(iter_11_1)
							end
						end
					end
				end
			end
		end

		local var_11_9 = #var_11_3

		if arg_11_0.is_server and var_11_9 > 0 then
			local var_11_10 = Managers.state.network.unit_storage
			local var_11_11 = Script.new_array(var_11_9)
			local var_11_12 = Script.new_array(var_11_9)

			for iter_11_2 = 1, var_11_9 do
				local var_11_13 = var_11_3[iter_11_2]
				local var_11_14 = var_11_13.unit

				var_11_12[iter_11_2], var_11_11[iter_11_2] = var_11_13.slot_id, var_11_10:go_id(var_11_14)
			end

			local var_11_15 = Level.unit_index(LevelHelper:current_level(arg_11_0.world), arg_11_0.unit)

			Managers.state.network.network_transmit:send_rpc_clients("rpc_add_transporting_ai_units", var_11_15, var_11_11, var_11_12)
		end
	end

	local var_11_16, var_11_17 = arg_11_0:_get_inside_generic_units()

	for iter_11_3 = 1, var_11_17 do
		arg_11_0:add_transporting_generic_unit(var_11_16[iter_11_3], nil, true)
	end

	Unit.flow_event(arg_11_0.unit, "activate_collision")
end

LinkerTransportationExtension._try_link_player = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = ScriptUnit.extension(arg_12_1, "status_system")
	local var_12_1 = Managers.player:owner(arg_12_1)
	local var_12_2 = var_12_0:is_dead()
	local var_12_3 = arg_12_0:_is_inside_transportation_unit(arg_12_1)
	local var_12_4 = var_12_0:is_disabled()

	if not var_12_2 and (var_12_3 or arg_12_2) then
		arg_12_0:_link_player_unit(arg_12_1, arg_12_0:_is_bot(var_12_1) and not arg_12_3, arg_12_3)
	elseif arg_12_0:_is_bot(var_12_1) and not var_12_4 then
		arg_12_0:_link_player_unit(var_12_1.player_unit, not arg_12_3, arg_12_3)
	elseif var_12_1.local_player and not var_12_2 and not var_12_4 and not var_12_3 then
		arg_12_0:_link_player_unit(var_12_1.player_unit, false, arg_12_3)
	end
end

LinkerTransportationExtension._is_inside_transportation_unit = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.oobb_mesh
	local var_13_1, var_13_2 = Mesh.box(var_13_0)
	local var_13_3 = Unit.world_position(arg_13_1, 0)
	local var_13_4 = Vector3.distance(Unit.world_position(arg_13_0.unit, 0), Unit.local_position(arg_13_0.unit, 0))

	arg_13_2 = (arg_13_2 or 0) + var_13_4
	var_13_2[1] = var_13_2[1] + arg_13_2
	var_13_2[2] = var_13_2[2] + arg_13_2
	var_13_2[3] = var_13_2[3] + arg_13_2

	return math.point_is_inside_oobb(var_13_3, var_13_1, var_13_2)
end

LinkerTransportationExtension._is_bot = function (arg_14_0, arg_14_1)
	if arg_14_0.is_server then
		return arg_14_1.bot_player
	elseif arg_14_1._player_controlled or arg_14_1.local_player then
		return false
	else
		return true
	end
end

LinkerTransportationExtension.update_units_inside_oobb = function (arg_15_0)
	local var_15_0 = arg_15_0.unit
	local var_15_1 = arg_15_0.oobb_mesh
	local var_15_2, var_15_3 = Mesh.box(var_15_1)
	local var_15_4 = arg_15_0.units_inside_oobb

	for iter_15_0, iter_15_1 in pairs(var_15_4) do
		for iter_15_2, iter_15_3 in pairs(iter_15_1.units) do
			if not HEALTH_ALIVE[iter_15_2] then
				iter_15_1.units[iter_15_2] = nil
				iter_15_1.count = iter_15_1.count - 1
			end
		end
	end

	local var_15_5 = FrameTable.alloc_table()

	var_15_5.human = {}
	var_15_5.ai = {}

	local var_15_6 = Managers.player:players()

	for iter_15_4, iter_15_5 in pairs(var_15_6) do
		if not arg_15_0:_is_bot(iter_15_5) then
			local var_15_7 = iter_15_5.player_unit

			if HEALTH_ALIVE[var_15_7] then
				local var_15_8 = Unit.world_position(var_15_7, 0)
				local var_15_9 = math.point_is_inside_oobb(var_15_8, var_15_2, var_15_3)

				var_15_5.human[var_15_7] = var_15_9
			end
		end
	end

	local var_15_10 = Managers.state.entity:system("ai_system").broadphase
	local var_15_11 = Unit.world_position(var_15_0, 0)
	local var_15_12 = FrameTable.alloc_table()
	local var_15_13 = Broadphase.query(var_15_10, var_15_11, arg_15_0.oobb_mesh_max_extent + 1, var_15_12)

	for iter_15_6 = 1, var_15_13 do
		local var_15_14 = var_15_12[iter_15_6]

		if HEALTH_ALIVE[var_15_14] then
			local var_15_15 = Unit.world_position(var_15_14, 0)
			local var_15_16 = math.point_is_inside_oobb(var_15_15, var_15_2, var_15_3)

			var_15_5.ai[var_15_14] = var_15_16
		end
	end

	for iter_15_7, iter_15_8 in pairs(var_15_5) do
		for iter_15_9, iter_15_10 in pairs(iter_15_8) do
			local var_15_17 = var_15_4[iter_15_7]

			if iter_15_10 and not var_15_17.units[iter_15_9] then
				var_15_17.units[iter_15_9] = true
				var_15_17.count = var_15_17.count + 1
			elseif not iter_15_10 and var_15_17.units[iter_15_9] then
				var_15_17.units[iter_15_9] = nil
				var_15_17.count = var_15_17.count - 1
			end
		end
	end

	for iter_15_11, iter_15_12 in pairs(var_15_5.human) do
		local var_15_18 = ScriptUnit.extension(iter_15_11, "status_system")
		local var_15_19 = iter_15_12 and var_15_0 or nil

		var_15_18:set_inside_transport_unit(var_15_19)
	end
end

LinkerTransportationExtension.update_nav_obstacles = function (arg_16_0)
	if not arg_16_0.has_nav_obstacles then
		return
	end

	local var_16_0 = arg_16_0.story_state
	local var_16_1 = arg_16_0.nav_obstacle_start
	local var_16_2 = arg_16_0.nav_obstacle_end

	if var_16_0 == "stopped_beginning" then
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_16_1, false)
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_16_2, true)
	elseif var_16_0 == "moving_forward" then
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_16_1, true)
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_16_2, true)
	elseif var_16_0 == "stopped_end" then
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_16_1, true)
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_16_2, false)
	elseif var_16_0 == "moving_backward" then
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_16_1, true)
		GwNavBoxObstacle.set_does_trigger_tagvolume(var_16_2, true)
	end
end

LinkerTransportationExtension.update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	local var_17_0 = arg_17_0.story_teller
	local var_17_1 = arg_17_0.story_id
	local var_17_2 = var_17_0:length(var_17_1)
	local var_17_3 = arg_17_0.current_story_time
	local var_17_4 = var_17_3

	if arg_17_0.story_state == "moving_forward" then
		var_17_4 = var_17_3 + arg_17_3

		arg_17_0:_update_local_player_position()

		if var_17_2 <= var_17_4 then
			var_17_4 = var_17_2
			arg_17_0.story_state = "stopped_end"

			if arg_17_0.auto_exit then
				arg_17_0:update_nav_obstacles()
			end

			Unit.flow_event(arg_17_0.unit, "lua_transportation_story_stopped")
		end
	elseif arg_17_0.story_state == "stopped_end" then
		local var_17_5 = arg_17_0.units_inside_oobb

		if arg_17_0.return_to_start and var_17_5 and var_17_5.human.count == 0 and var_17_5.bot.count == 0 then
			arg_17_0.story_state = "moving_backward"

			arg_17_0:update_nav_obstacles()
			Unit.flow_event(arg_17_0.unit, "lua_transportation_story_started")
		end
	elseif arg_17_0.story_state == "moving_backward" then
		var_17_4 = var_17_3 - arg_17_3

		if var_17_4 <= 0 then
			var_17_4 = 0
			arg_17_0.story_state = "stopped_beginning"

			arg_17_0:update_nav_obstacles()
			Unit.flow_event(arg_17_0.unit, "lua_transportation_story_stopped")
		end
	end

	var_17_0:set_time(var_17_1, var_17_4)

	arg_17_0.current_story_time = var_17_4

	local var_17_6 = arg_17_0.units_inside_oobb

	if var_17_6 and arg_17_5 >= arg_17_0.oobb_next_update then
		arg_17_0:update_units_inside_oobb()

		arg_17_0.oobb_next_update = arg_17_5 + (var_17_6.human.count > 0 and var_0_1 or var_0_0)
	end

	arg_17_0:_update_queued_removals(arg_17_5)
end

LinkerTransportationExtension.world_updated = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0.unit
	local var_18_1 = arg_18_0._old_position:unbox()
	local var_18_2 = Unit.world_position(var_18_0, 0)
	local var_18_3 = Unit.local_position(var_18_0, 0)
	local var_18_4 = Vector3(var_18_3[1], var_18_3[2], var_18_2[3])
	local var_18_5 = var_18_4 - var_18_1

	arg_18_0._movement_delta:store(var_18_5)

	local var_18_6 = Unit.world_rotation(var_18_0, 0)
	local var_18_7 = arg_18_0._old_rotation:unbox()
	local var_18_8 = Quaternion.multiply(var_18_6, Quaternion.inverse(var_18_7))

	arg_18_0._rotation_delta:store(var_18_8)

	local var_18_9 = arg_18_0._old_visual_delta:unbox()
	local var_18_10 = Quaternion.rotate(Quaternion.inverse(Unit.world_rotation(var_18_0, 0)), arg_18_0:visual_delta())

	arg_18_0._visual_movement_diff:store(var_18_10 - var_18_9)
	arg_18_0._old_position:store(var_18_4)
	arg_18_0._old_rotation:store(var_18_6)
	arg_18_0._old_visual_delta:store(var_18_10)
	arg_18_0:_update_player_positions(arg_18_2)
	arg_18_0:_update_transported_ai_positions()
	arg_18_0:_update_transported_generic_unit_positions()
end

LinkerTransportationExtension.post_update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	if not Managers.state.network:game() then
		return
	end

	if arg_19_0.story_state ~= "moving_forward" then
		arg_19_0:_update_passive_linking()
	end

	if arg_19_0.story_state == "stopped_end" and arg_19_0.story_state ~= arg_19_0._last_story_state then
		if arg_19_0.is_server then
			Managers.state.event:trigger("event_delay_pacing", false)
		end

		Unit.flow_event(arg_19_0.unit, "deactivate_collision")
	end

	arg_19_0._last_story_state = arg_19_0.story_state
end

LinkerTransportationExtension._update_local_player_position = function (arg_20_0)
	local var_20_0 = Managers.player
	local var_20_1 = arg_20_0.transported_units
	local var_20_2 = #var_20_1

	for iter_20_0 = 1, var_20_2 do
		repeat
			local var_20_3 = var_20_1[iter_20_0]

			if not Unit.alive(var_20_3) then
				break
			end

			local var_20_4 = var_20_0:owner(var_20_3)

			if not var_20_4 or not var_20_4.local_player then
				break
			end

			local var_20_5 = ScriptUnit.extension(var_20_3, "locomotion_system")

			if var_20_5:get_moving_platform() ~= arg_20_0.unit then
				break
			end

			if not arg_20_0:_is_inside_transportation_unit(var_20_3, 1) then
				local var_20_6 = table.find(arg_20_0._bot_slots, var_20_3)

				if var_20_6 == nil then
					var_20_6 = math.random(1, 4)
				end

				local var_20_7 = arg_20_0:_get_position_from_index(var_20_6)
				local var_20_8 = var_20_5:current_rotation()

				var_20_5:teleport_to(var_20_7, var_20_8)
			end
		until true
	end
end

LinkerTransportationExtension.is_stationary = function (arg_21_0)
	return arg_21_0.story_state == "stopped_beginning" or arg_21_0.story_state == "stopped_end"
end

LinkerTransportationExtension.can_interact = function (arg_22_0, arg_22_1)
	return arg_22_0.story_state == "stopped_beginning" or arg_22_0.story_state == "stopped_end" and not arg_22_0.auto_exit and arg_22_0.transported_units[arg_22_1]
end

LinkerTransportationExtension.destroy = function (arg_23_0)
	if Managers.state.event then
		Managers.state.event:unregister("new_player_unit", arg_23_0)
		Managers.state.event:unregister("pickup_spawned", arg_23_0)
	end

	if arg_23_0:transporting() and arg_23_0.is_server then
		Managers.state.event:trigger("event_delay_pacing", false)
	end

	if arg_23_0.has_nav_obstacles then
		GwNavBoxObstacle.destroy(arg_23_0.nav_obstacle_start)

		arg_23_0.nav_obstacle_start = nil

		GwNavBoxObstacle.destroy(arg_23_0.nav_obstacle_end)

		arg_23_0.nav_obstacle_end = nil
	end

	if arg_23_0.units_inside_oobb then
		local var_23_0 = arg_23_0.units_inside_oobb.human.units

		for iter_23_0, iter_23_1 in pairs(var_23_0) do
			if var_0_4(iter_23_0) then
				ScriptUnit.extension(iter_23_0, "status_system"):set_inside_transport_unit(nil)
			end
		end

		arg_23_0.units_inside_oobb = nil
	end

	arg_23_0.transported_units = nil
	arg_23_0.oobb_mesh = nil
end

LinkerTransportationExtension._update_passive_linking = function (arg_24_0)
	local var_24_0 = arg_24_0.transported_units

	for iter_24_0 = #var_24_0, 1, -1 do
		local var_24_1 = var_24_0[iter_24_0]

		if not var_0_4(var_24_1) then
			arg_24_0:_unlink_player_unit(var_24_1)
		elseif not var_0_2[arg_24_0.story_state] then
			local var_24_2 = ScriptUnit.has_extension(var_24_1, "locomotion_system")

			if var_24_2 then
				local var_24_3, var_24_4, var_24_5 = var_24_2:get_moving_platform()

				if not var_24_5 then
					arg_24_0:_link_player_unit(var_24_1, false, true)
				end
			end
		end
	end

	local var_24_6 = true
	local var_24_7 = false
	local var_24_8 = Managers.player:players()

	for iter_24_1, iter_24_2 in pairs(var_24_8) do
		local var_24_9 = iter_24_2.player_unit

		if var_0_4(var_24_9) then
			if arg_24_0:_is_inside_transportation_unit(var_24_9, var_24_0[var_24_9] and 1 or nil) then
				if not var_24_0[var_24_9] then
					arg_24_0:_try_link_player(var_24_9, var_24_7, var_24_6)
				end
			elseif var_24_0[var_24_9] then
				arg_24_0:_unlink_player_unit(var_24_9)
			end
		end
	end

	local var_24_10 = arg_24_0._transported_ai_units

	for iter_24_3 = #var_24_10, 1, -1 do
		local var_24_11 = var_24_10[iter_24_3].unit

		arg_24_0:queue_ai_transport_unit_for_removal(var_24_11, false)
	end

	local var_24_12 = arg_24_0._transported_generic_units

	for iter_24_4, iter_24_5 in pairs(var_24_12) do
		if not var_0_4(iter_24_4) or not arg_24_0:_is_inside_transportation_unit(iter_24_4, var_24_12[iter_24_4] and 1 or nil) then
			var_24_12[iter_24_4] = nil
		end
	end
end

LinkerTransportationExtension._unlink_player_unit = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.transported_units

	if not var_25_0[arg_25_1] then
		return
	end

	arg_25_0._transportation_system:clear_transporter_by_linked_unit(arg_25_1)

	var_25_0[arg_25_1] = nil

	table.swap_delete(var_25_0, table.index_of(var_25_0, arg_25_1))

	local var_25_1 = arg_25_0.unit
	local var_25_2 = Managers.player:owner(arg_25_1)
	local var_25_3 = table.find(arg_25_0._bot_slots, arg_25_1)

	if var_25_3 then
		table.remove(arg_25_0._bot_slots, var_25_3)
	end

	local var_25_4 = ScriptUnit.has_extension(arg_25_1, "status_system")

	if var_25_4 then
		var_25_4:set_using_transport(false)
	end

	if var_25_2 and (var_25_2.local_player or arg_25_0.is_server and var_25_2.bot_player) then
		local var_25_5 = ScriptUnit.has_extension(arg_25_1, "locomotion_system")

		if var_25_5 then
			var_25_5:set_on_moving_platform(nil)

			if arg_25_0.teleport_on_exit then
				local var_25_6 = Unit.world_position(var_25_1, Unit.node(var_25_1, "g_end"))
				local var_25_7 = var_25_5:current_rotation()

				var_25_5:teleport_to(var_25_6, var_25_7)
			end
		end
	end
end

LinkerTransportationExtension._get_position_from_index = function (arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.unit
	local var_26_1

	if Unit.has_node(var_26_0, "elevator_slot_0" .. arg_26_1) then
		local var_26_2 = Unit.node(var_26_0, "elevator_slot_0" .. arg_26_1)

		var_26_1 = Unit.world_position(var_26_0, var_26_2)
	end

	return var_26_1
end

LinkerTransportationExtension._teleport_bot = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	if arg_27_1 or arg_27_0.teleport_on_enter then
		local var_27_0 = #arg_27_0._bot_slots + 1

		arg_27_0._bot_slots[var_27_0] = arg_27_3

		local var_27_1 = arg_27_0:_get_position_from_index(var_27_0)

		if not arg_27_2.remote then
			local var_27_2 = arg_27_4:current_rotation()

			arg_27_4:teleport_to(var_27_1, var_27_2)
		end
	end
end

LinkerTransportationExtension._link_player_unit = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = ScriptUnit.extension(arg_28_1, "locomotion_system")
	local var_28_1 = Managers.player:owner(arg_28_1)
	local var_28_2 = arg_28_0.transported_units

	if var_28_2[arg_28_1] then
		if not var_28_1.remote then
			local var_28_3, var_28_4, var_28_5 = var_28_0:get_moving_platform()

			if var_28_5 ~= arg_28_3 then
				var_28_0:set_on_moving_platform(arg_28_0.unit, arg_28_3)
				arg_28_0:_teleport_bot(arg_28_2, var_28_1, arg_28_1, var_28_0)
			end
		end

		return
	end

	local var_28_6 = not arg_28_3

	if not arg_28_0._transportation_system:try_claim_unit(arg_28_1, arg_28_0, var_28_6) then
		return
	end

	var_28_2[#var_28_2 + 1] = arg_28_1
	var_28_2[arg_28_1] = true

	local var_28_7 = arg_28_0.unit

	arg_28_0:_teleport_bot(arg_28_2, var_28_1, arg_28_1, var_28_0)

	if Managers.state.side.side_by_unit[arg_28_1].side_id ~= arg_28_0._side.side_id then
		ScriptUnit.extension(arg_28_1, "status_system"):set_using_transport(true)
	end

	if not var_28_1.remote then
		var_28_0:set_on_moving_platform(var_28_7, arg_28_3)
	end
end

LinkerTransportationExtension.assign_position_to_bot = function (arg_29_0)
	return Unit.world_position(arg_29_0.unit, 0)
end

local var_0_5 = 0.5

LinkerTransportationExtension.get_ai_slot = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.unit

	if not arg_30_0._ai_slot_offsets then
		local var_30_1 = {}
		local var_30_2 = 100
		local var_30_3 = 0.1
		local var_30_4 = 1

		while Unit.has_node(var_30_0, "elevator_slot_0" .. var_30_4) do
			local var_30_5 = Unit.node(var_30_0, "elevator_slot_0" .. var_30_4)
			local var_30_6 = Unit.local_position(var_30_0, var_30_5)
			local var_30_7

			for iter_30_0 = 1, #var_30_1 do
				local var_30_8 = var_30_1[iter_30_0].center:unbox()

				if var_30_3 > math.abs(var_30_8[3] - var_30_6[3]) and var_30_2 > Vector3.distance_squared(Vector3.flat(var_30_8), Vector3.flat(var_30_6)) then
					var_30_7 = iter_30_0

					break
				end
			end

			var_30_7 = var_30_7 or #var_30_1 + 1

			local var_30_9 = var_30_1[var_30_7]

			if var_30_9 then
				table.insert(var_30_9.positions, Vector3Box(var_30_6))

				local var_30_10 = Vector3.zero()

				for iter_30_1 = 1, #var_30_9.positions do
					var_30_10 = var_30_10 + var_30_9.positions[iter_30_1]:unbox()
				end

				var_30_9.center:store(var_30_10 / #var_30_9.positions)
				var_30_9.min:store(Vector3.min(var_30_9.min:unbox(), var_30_6))
				var_30_9.max:store(Vector3.max(var_30_9.max:unbox(), var_30_6))
			else
				var_30_1[var_30_7] = {
					positions = {
						Vector3Box(var_30_6)
					},
					center = Vector3Box(var_30_6),
					min = Vector3Box(var_30_6),
					max = Vector3Box(var_30_6)
				}
			end

			var_30_4 = var_30_4 + 1
		end

		arg_30_0._ai_slot_offsets = var_30_1

		for iter_30_2 = 1, #var_30_1 do
			local var_30_11 = var_30_1[iter_30_2]
			local var_30_12 = var_30_11.min:unbox()
			local var_30_13 = var_30_11.max:unbox()
			local var_30_14 = 0.7
			local var_30_15 = Vector3.lerp(var_30_12, var_30_13, 0.5)
			local var_30_16 = Vector3.normalize(var_30_13 - var_30_15) * var_30_14
			local var_30_17 = var_30_12 + var_30_16
			local var_30_18 = var_30_13 - var_30_16 - var_30_17
			local var_30_19 = var_30_18.x > 0 and math.ceil(var_30_18.x / var_0_5) or 1

			var_30_11.num_slots_y, var_30_11.num_slots_x = var_30_18.y > 0 and math.ceil(var_30_18.y / var_0_5) or 1, var_30_19
			var_30_11.offset_start = Vector3Box(var_30_17)
		end
	end

	local var_30_20 = arg_30_0._ai_slot_offsets[math.index_wrapper(arg_30_1, #arg_30_0._ai_slot_offsets)]
	local var_30_21 = var_30_20.offset_start:unbox()
	local var_30_22 = math.ceil(arg_30_1 / #arg_30_0._ai_slot_offsets) % var_30_20.num_slots_x
	local var_30_23 = math.floor(arg_30_1 / var_30_20.num_slots_x) % var_30_20.num_slots_y
	local var_30_24 = arg_30_0:_pose()

	return (Matrix4x4.transform(var_30_24, var_30_21 + Vector3(var_30_22 * var_0_5, var_30_23 * var_0_5, 0)))
end

LinkerTransportationExtension.add_transporting_ai_unit = function (arg_31_0, arg_31_1)
	if not arg_31_0._transportation_system:try_claim_unit(arg_31_1, arg_31_0) then
		return
	end

	local var_31_0 = arg_31_0._transported_ai_units
	local var_31_1 = arg_31_0._transported_ai_unit_freelist
	local var_31_2 = #var_31_0 + 1
	local var_31_3 = #var_31_1
	local var_31_4 = var_31_1[var_31_3] or {
		slot_id = var_31_2
	}

	var_31_1[var_31_3] = nil
	var_31_4.unit = arg_31_1
	var_31_0[var_31_2] = var_31_4
	var_31_0[arg_31_1] = var_31_2

	if arg_31_0.is_server then
		local var_31_5 = BLACKBOARDS[arg_31_1]

		if var_31_5 then
			var_31_5.is_transported = arg_31_0
			var_31_5.transport_slot_id = var_31_4.slot_id
		end
	end

	arg_31_0._queued_ai_units_to_remove[arg_31_1] = nil
end

LinkerTransportationExtension.add_transporting_generic_unit = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_0._transported_generic_units[arg_32_1] then
		return
	end

	if not arg_32_0._transportation_system:try_claim_unit(arg_32_1, arg_32_0) then
		return
	end

	local var_32_0 = arg_32_2 or Matrix4x4.multiply(Unit.world_pose(arg_32_1, 0), Matrix4x4.inverse(arg_32_0:_pose()))

	arg_32_0._transported_generic_units[arg_32_1] = Matrix4x4Box(var_32_0)

	if arg_32_0.is_server then
		local var_32_1 = Level.unit_index(LevelHelper:current_level(arg_32_0.world), arg_32_0.unit)
		local var_32_2, var_32_3 = Managers.state.network:game_object_or_level_id(arg_32_1)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_add_transporting_generic_unit", var_32_1, var_32_2, var_32_3, Matrix4x4.translation(var_32_0), Matrix4x4.rotation(var_32_0))
	end
end

LinkerTransportationExtension._remove_transporting_generic_unit = function (arg_33_0, arg_33_1)
	if not arg_33_0._transported_generic_units[arg_33_1] then
		return
	end

	arg_33_0._transported_generic_units[arg_33_1] = nil

	arg_33_0._transportation_system:clear_transporter_by_linked_unit(arg_33_1)
end

LinkerTransportationExtension.force_unlink_unit = function (arg_34_0, arg_34_1)
	arg_34_0:_unlink_player_unit(arg_34_1)
	arg_34_0:_remove_transporting_generic_unit(arg_34_1)
	arg_34_0:remove_transporting_ai_unit(arg_34_1)
end

LinkerTransportationExtension.queue_ai_transport_unit_for_removal = function (arg_35_0, arg_35_1, arg_35_2)
	if arg_35_0.is_server then
		arg_35_0._queued_ai_units_to_remove[arg_35_1] = arg_35_2 and "soft" or "hard"
	elseif arg_35_2 then
		arg_35_0:_transporting_ai_unit_soft_removal(arg_35_1)
	else
		arg_35_0:remove_transporting_ai_unit(arg_35_1)
	end
end

LinkerTransportationExtension._update_queued_removals = function (arg_36_0, arg_36_1)
	local var_36_0 = next(arg_36_0._queued_ai_units_to_remove, arg_36_0._last_checked_queued_removal)

	arg_36_0._last_checked_queued_removal = var_36_0

	if var_36_0 then
		if not ALIVE[var_36_0] then
			arg_36_0:remove_transporting_ai_unit(var_36_0)

			arg_36_0._queued_ai_units_to_remove[var_36_0] = nil

			return
		end

		local var_36_1 = POSITION_LOOKUP[var_36_0]

		if GwNavQueries.triangle_from_position(GLOBAL_AI_NAVWORLD, var_36_1, 1, 1) then
			if arg_36_0._queued_ai_units_to_remove[var_36_0] == "soft" then
				arg_36_0:_transporting_ai_unit_soft_removal(var_36_0)
			else
				arg_36_0:remove_transporting_ai_unit(var_36_0)

				arg_36_0._queued_ai_units_to_remove[var_36_0] = nil
			end

			return
		end
	end
end

LinkerTransportationExtension._transporting_ai_unit_soft_removal = function (arg_37_0, arg_37_1)
	if arg_37_0.is_server then
		local var_37_0 = BLACKBOARDS[arg_37_1]

		if var_37_0 and var_37_0.is_transported == arg_37_0 then
			var_37_0.is_transported = nil
			var_37_0.transport_slot_id = nil
		end
	end
end

LinkerTransportationExtension.remove_transporting_ai_unit = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._transported_ai_units
	local var_38_1 = var_38_0[arg_38_1]

	if not var_38_1 then
		return
	end

	arg_38_0:_transporting_ai_unit_soft_removal(arg_38_1)
	arg_38_0._transportation_system:clear_transporter_by_linked_unit(arg_38_1)
	table.insert(arg_38_0._transported_ai_unit_freelist, table.swap_delete(var_38_0, var_38_1))

	var_38_0[arg_38_1] = nil

	arg_38_0._transportation_system:clear_transporter_by_linked_unit(arg_38_1)

	local var_38_2 = var_38_0[var_38_1]

	if var_38_2 then
		var_38_0[var_38_2.unit] = var_38_1
	end
end

LinkerTransportationExtension._update_player_positions = function (arg_39_0, arg_39_1)
	local var_39_0 = Unit.world_position(arg_39_0.unit, 0)
	local var_39_1 = arg_39_0:visual_diff_delta()
	local var_39_2 = arg_39_0._movement_delta:unbox() + var_39_1
	local var_39_3 = arg_39_0._rotation_delta:unbox()
	local var_39_4 = arg_39_0.transported_units

	for iter_39_0 = #var_39_4, 1, -1 do
		local var_39_5 = var_39_4[iter_39_0]

		if ALIVE[var_39_5] then
			local var_39_6 = Unit.mover(var_39_5)
			local var_39_7 = Mover.position(var_39_6)
			local var_39_8 = var_39_7 + var_39_2
			local var_39_9 = var_39_7 + (var_39_8 - var_39_7) * 0.5 - var_39_0
			local var_39_10 = var_39_8 + (Quaternion.rotate(var_39_3, var_39_9) - var_39_9)

			Mover.set_position(var_39_6, var_39_10)
			Unit.set_local_position(var_39_5, 0, var_39_10)

			local var_39_11 = var_39_10 - var_39_7
			local var_39_12 = Unit.get_data(var_39_5, "accumulated_movement") or Vector3.zero()

			Unit.set_data(var_39_5, "accumulated_movement", var_39_12 + var_39_11)

			local var_39_13 = ScriptUnit.has_extension(var_39_5, "first_person_system")

			if var_39_13 then
				local var_39_14 = var_39_13:get_first_person_unit()
				local var_39_15 = Unit.local_position(var_39_14, 0) + var_39_2

				Unit.set_local_position(var_39_14, 0, var_39_15)
			end
		end
	end
end

LinkerTransportationExtension._update_transported_ai_positions = function (arg_40_0)
	local var_40_0 = not var_0_2[arg_40_0.story_state]
	local var_40_1 = var_40_0 and arg_40_0._movement_delta:unbox()
	local var_40_2 = arg_40_0._transported_ai_units

	for iter_40_0 = #var_40_2, 1, -1 do
		local var_40_3 = var_40_2[iter_40_0]
		local var_40_4 = var_40_3.unit
		local var_40_5 = var_40_3.slot_id

		if ALIVE[var_40_4] then
			local var_40_6 = POSITION_LOOKUP[var_40_4]
			local var_40_7 = var_40_0 and var_40_6 + var_40_1 or arg_40_0:get_ai_slot(var_40_5)
			local var_40_8 = ScriptUnit.has_extension(var_40_4, "locomotion_system")

			if var_40_8 then
				local var_40_9 = Unit.world_rotation(var_40_4, 0)
				local var_40_10 = var_40_7 - POSITION_LOOKUP[var_40_4]

				var_40_8:teleport_to(var_40_7, var_40_9, var_40_10, true)
			else
				Unit.set_local_position(var_40_4, 0, var_40_7)
			end
		else
			arg_40_0:remove_transporting_ai_unit(var_40_4)
		end
	end
end

LinkerTransportationExtension._update_transported_generic_unit_positions = function (arg_41_0)
	local var_41_0 = arg_41_0:visual_diff_delta()
	local var_41_1 = arg_41_0._movement_delta:unbox() + var_41_0
	local var_41_2 = arg_41_0:_pose()

	for iter_41_0, iter_41_1 in pairs(arg_41_0._transported_generic_units) do
		if Unit.alive(iter_41_0) then
			local var_41_3 = false

			for iter_41_2 = 1, Unit.num_actors(iter_41_0) do
				local var_41_4 = Unit.actor(iter_41_0, iter_41_2 - 1)

				if var_41_4 and Actor.is_physical(var_41_4) then
					var_41_3 = true

					Actor.set_update_enabled(var_41_4, false)
					Actor.put_to_sleep(var_41_4)
				end
			end

			local var_41_5

			if ScriptUnit.has_extension(iter_41_0, "projectile_locomotion_system") or ScriptUnit.has_extension(iter_41_0, "locomotion_system") then
				var_41_5 = Matrix4x4.multiply(Matrix4x4.from_translation(var_41_1), Unit.local_pose(iter_41_0, 0))
			else
				var_41_5 = Matrix4x4.multiply(iter_41_1:unbox(), var_41_2)
			end

			arg_41_0:_move_generic_unit(iter_41_0, var_41_5)

			if not var_41_3 then
				World.update_unit(arg_41_0.world, iter_41_0)
			end
		else
			arg_41_0._transported_generic_units[iter_41_0] = nil
		end
	end
end

LinkerTransportationExtension._move_generic_unit = function (arg_42_0, arg_42_1, arg_42_2)
	if ScriptUnit.has_extension(arg_42_1, "pickup_system") then
		Managers.state.entity:system("pickup_system"):move_pickup_local_pose(arg_42_1, arg_42_2)

		return
	end

	local var_42_0 = ScriptUnit.has_extension(arg_42_1, "props_system")

	if var_42_0 then
		if var_42_0.move_prop then
			var_42_0:move_prop(arg_42_2)
		end

		return
	end

	local var_42_1 = Matrix4x4.translation(arg_42_2)
	local var_42_2 = Matrix4x4.rotation(arg_42_2)

	Unit.set_local_position(arg_42_1, 0, var_42_1)
	Unit.set_local_rotation(arg_42_1, 0, var_42_2)
end

LinkerTransportationExtension.on_player_unit_spawned = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if Managers.state.side.side_by_unit[arg_43_2] ~= arg_43_0._side then
		return
	end

	if arg_43_0:transporting() then
		local var_43_0 = arg_43_1.remote

		arg_43_0:_try_link_player(arg_43_2, var_43_0)
	end
end

LinkerTransportationExtension.on_pickup_spawned = function (arg_44_0, arg_44_1)
	if arg_44_0._reference_teleport_unit then
		arg_44_0:teleport_non_character_elevator_units(arg_44_0._reference_teleport_unit)

		return
	end

	if arg_44_0:_is_inside_transportation_unit(arg_44_1) then
		if arg_44_0.is_server then
			arg_44_0:add_transporting_generic_unit(arg_44_1, nil, false)
		else
			arg_44_0:add_transporting_generic_unit(arg_44_1, nil, true)
		end
	end
end

LinkerTransportationExtension.on_sister_wall_spawned = function (arg_45_0, arg_45_1)
	if arg_45_0._reference_teleport_unit then
		arg_45_0:teleport_non_character_elevator_units(arg_45_0._reference_teleport_unit)

		return
	end

	if arg_45_0:_is_inside_transportation_unit(arg_45_1) then
		if arg_45_0.is_server then
			arg_45_0:add_transporting_generic_unit(arg_45_1, nil, false)
		else
			arg_45_0:add_transporting_generic_unit(arg_45_1, nil, true)
		end
	end
end

local var_0_6 = {}

LinkerTransportationExtension._get_inside_generic_units = function (arg_46_0)
	table.clear(var_0_6)

	local var_46_0 = 0
	local var_46_1 = Managers.state.entity:system("pickup_system")
	local var_46_2 = Unit.world_position(arg_46_0.unit, 0)
	local var_46_3 = arg_46_0._nearby_pickup_cache
	local var_46_4 = var_46_1:get_pickups(var_46_2, arg_46_0.oobb_mesh_max_extent + 1, var_46_3)

	for iter_46_0 = 1, var_46_4 do
		local var_46_5 = var_46_3[iter_46_0]

		if arg_46_0:_is_inside_transportation_unit(var_46_5) then
			var_46_0 = var_46_0 + 1
			var_0_6[var_46_0] = var_46_5
		end
	end

	local var_46_6 = Managers.state.entity:get_entities("ThornSisterWallExtension")

	for iter_46_1, iter_46_2 in pairs(var_46_6) do
		if arg_46_0:_is_inside_transportation_unit(iter_46_1) then
			var_46_0 = var_46_0 + 1
			var_0_6[var_46_0] = iter_46_1
		end
	end

	local var_46_7 = Managers.state.game_mode:game_mode():get_available_and_active_respawn_units()

	for iter_46_3 = 1, #var_46_7 do
		local var_46_8 = var_46_7[iter_46_3].unit

		if arg_46_0:_is_inside_transportation_unit(var_46_8) then
			var_46_0 = var_46_0 + 1
			var_0_6[var_46_0] = var_46_8
		end
	end

	return var_0_6, var_46_0
end

LinkerTransportationExtension.teleport_non_character_elevator_units = function (arg_47_0, arg_47_1)
	arg_47_0._reference_teleport_unit = arg_47_1
	arg_47_0._reference_teleport_seed = arg_47_0._reference_teleport_seed or Managers.mechanism:get_level_seed()

	local function var_47_0()
		local var_48_0 = Unit.local_position(arg_47_1, 0)
		local var_48_1 = 3
		local var_48_2 = 3

		local function var_48_3(arg_49_0, arg_49_1)
			local var_49_0
			local var_49_1 = 1

			while var_49_1 <= var_48_2 do
				local var_49_2, var_49_3, var_49_4 = math.get_uniformly_random_point_inside_sector_seeded(arg_47_0._reference_teleport_seed, 0, var_48_1, 0, math.tau)

				arg_47_0._reference_teleport_seed = var_49_2
				var_49_0 = var_48_0 + Vector3(var_49_3, var_49_4, 0)

				local var_49_5, var_49_6 = GwNavQueries.triangle_from_position(GLOBAL_AI_NAVWORLD, var_49_0, 1, 1)

				if var_49_5 then
					var_49_0 = Vector3(var_49_0.x, var_49_0.y, var_49_6)

					break
				end

				var_49_1 = var_49_1 + 1
			end

			var_49_0 = var_49_0 or var_48_0

			if arg_49_1 then
				arg_49_1:teleport_to(var_49_0)
			else
				local var_49_7 = Matrix4x4.from_quaternion_position_scale(Unit.local_rotation(arg_49_0, 0), var_49_0, Unit.local_scale(arg_49_0, 0))

				arg_47_0:_move_generic_unit(arg_49_0, var_49_7)

				arg_47_0._transported_generic_units[arg_49_0] = nil
			end
		end

		local var_48_4, var_48_5 = arg_47_0:_get_inside_generic_units()

		table.sort(var_48_4, function (arg_50_0, arg_50_1)
			return (Managers.state.unit_storage:go_id(arg_50_0) or HashUtils.fnv32_hash(tostring(arg_50_0))) < (Managers.state.unit_storage:go_id(arg_50_1) or HashUtils.fnv32_hash(tostring(arg_50_1)))
		end)

		for iter_48_0 = 1, var_48_5 do
			local var_48_6 = var_48_4[iter_48_0]

			var_48_3(var_48_6)
		end

		for iter_48_1, iter_48_2 in pairs(Managers.player:players()) do
			local var_48_7 = iter_48_2.player_unit

			if Unit.alive(var_48_7) and arg_47_0:_is_inside_transportation_unit(var_48_7) then
				local var_48_8 = ScriptUnit.extension(var_48_7, "locomotion_system")

				var_48_3(var_48_7, var_48_8)
			end
		end
	end

	Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_47_0)
end

LinkerTransportationExtension.transporting = function (arg_51_0)
	return var_0_2[arg_51_0.story_state]
end

LinkerTransportationExtension.beginning = function (arg_52_0)
	return arg_52_0.story_state == "stopped_beginning"
end

LinkerTransportationExtension._reference_node = function (arg_53_0)
	local var_53_0 = arg_53_0.unit

	if var_0_4(var_53_0) then
		if Unit.has_node(var_53_0, "rp_g_trade") then
			return Unit.node(var_53_0, "rp_g_trade")
		end

		if Unit.has_node(var_53_0, "rp_transport") then
			return Unit.node(var_53_0, "rp_transport")
		end
	end

	return 0
end

LinkerTransportationExtension._pose = function (arg_54_0)
	local var_54_0 = arg_54_0.unit

	return Unit.world_pose(var_54_0, arg_54_0:_reference_node())
end
