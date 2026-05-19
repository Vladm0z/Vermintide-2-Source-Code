-- chunkname: @scripts/ui/hud_ui/dark_pact_climbing_ui.lua

local var_0_0 = 50
local var_0_1 = 250
local var_0_2 = 0.5
local var_0_3 = 400

DarkPactClimbingUI = class(DarkPactClimbingUI)

function DarkPactClimbingUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._local_player = arg_1_2.player
	arg_1_0._raycast_frame_counter = 0
	arg_1_0._world_markers_spawned = {}
	arg_1_0._next_distance_check_time = -math.huge
	arg_1_0._previous_position_box = Vector3Box(math.huge, math.huge, math.huge)
	arg_1_0._broadphase_results = {}
	arg_1_0._keep_marker_lookup = {}
	arg_1_0._visible = true
	arg_1_0._are_climb_units_registered = false

	arg_1_0:_initialize_broadphase()
	arg_1_0:_initialize_camera()
end

function DarkPactClimbingUI.destroy(arg_2_0)
	if not arg_2_0._markers_cleared then
		arg_2_0:_clear_world_markers()
	end
end

function DarkPactClimbingUI._register_climb_units(arg_3_0)
	local var_3_0 = Managers.state.entity
	local var_3_1 = var_3_0:system("door_system")

	arg_3_0:_add_units_to_broadphase("tunneling", var_3_1:get_crawl_space_tunnel_units())
	arg_3_0:_add_units_to_broadphase("spawning", var_3_1:get_crawl_space_spawner_units())

	local var_3_2 = var_3_0:system("nav_graph_system"):level_jump_units()

	if var_3_2 then
		arg_3_0:_add_units_to_broadphase("climbing", table.keys(var_3_2))
	end

	arg_3_0._are_climb_units_registered = true
end

function DarkPactClimbingUI._add_units_to_broadphase(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_2 then
		return
	end

	for iter_4_0, iter_4_1 in ipairs(arg_4_2) do
		if Unit.alive(iter_4_1) and not arg_4_0._broadphase_types[iter_4_1] then
			Broadphase.add(arg_4_0._broadphase, iter_4_1, Unit.world_position(iter_4_1, 0), 1)

			arg_4_0._broadphase_types[iter_4_1] = arg_4_1
		end
	end
end

function DarkPactClimbingUI._initialize_broadphase(arg_5_0)
	arg_5_0._broadphase = Broadphase(var_0_0, var_0_1)
	arg_5_0._broadphase_types = {}
end

function DarkPactClimbingUI._initialize_camera(arg_6_0)
	local var_6_0 = "player_1"
	local var_6_1 = Managers.world:world("level_world")

	if Managers.state.camera:has_viewport(var_6_0) then
		arg_6_0._camera = ScriptViewport.camera(ScriptWorld.viewport(var_6_1, var_6_0))
	end
end

function DarkPactClimbingUI._broadphase_check(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._broadphase_results

	table.clear(var_7_0)

	local var_7_1 = Broadphase.query(arg_7_0._broadphase, arg_7_1, var_0_0, var_7_0)

	return var_7_0, var_7_1
end

function DarkPactClimbingUI.update(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0._are_climb_units_registered then
		return
	end

	if not arg_8_0._visible or not Unit.alive(arg_8_0._local_player.player_unit) then
		if not arg_8_0._markers_cleared then
			arg_8_0:_clear_world_markers()
		end

		return
	end

	local var_8_0 = arg_8_0._camera

	if not var_8_0 then
		return
	end

	if arg_8_2 < arg_8_0._next_distance_check_time then
		return
	end

	arg_8_0._next_distance_check_time = arg_8_2 + var_0_2

	local var_8_1 = Camera.local_position(var_8_0)
	local var_8_2 = arg_8_0._previous_position_box

	if Vector3.distance_squared(var_8_2:unbox(), var_8_1) < var_0_3 then
		return
	end

	var_8_2:store(var_8_1)

	local var_8_3, var_8_4 = arg_8_0:_broadphase_check(var_8_1)
	local var_8_5 = Managers.state.event

	for iter_8_0 = 1, var_8_4 do
		local var_8_6 = var_8_3[iter_8_0]

		if not arg_8_0:_has_marker_for_unit(var_8_6) then
			var_8_5:trigger("add_world_marker_unit", arg_8_0._broadphase_types[var_8_6], var_8_6, callback(arg_8_0, "cb_world_marker_spawned", var_8_6))
		end

		arg_8_0._keep_marker_lookup[var_8_6] = true
	end

	arg_8_0:_clear_world_markers_except(arg_8_0._keep_marker_lookup)
	table.clear(arg_8_0._keep_marker_lookup)
end

function DarkPactClimbingUI._has_marker_for_unit(arg_9_0, arg_9_1)
	return arg_9_0._world_markers_spawned[arg_9_1]
end

function DarkPactClimbingUI._clear_world_markers(arg_10_0)
	local var_10_0 = arg_10_0._world_markers_spawned
	local var_10_1 = Managers.state.event

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		var_10_1:trigger("event_remove_world_marker", iter_10_1)

		var_10_0[iter_10_0] = nil
	end

	arg_10_0._markers_cleared = true
end

function DarkPactClimbingUI._clear_world_markers_except(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._world_markers_spawned
	local var_11_1 = Managers.state.event

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		if not arg_11_1[iter_11_0] then
			var_11_1:trigger("event_remove_world_marker", var_11_0[iter_11_0])

			var_11_0[iter_11_0] = nil
		end
	end
end

function DarkPactClimbingUI.cb_world_marker_spawned(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0._world_markers_spawned[arg_12_1] = arg_12_2
	arg_12_0._markers_cleared = false
end

function DarkPactClimbingUI.set_visible(arg_13_0, arg_13_1)
	arg_13_0._visible = arg_13_1

	if arg_13_1 then
		arg_13_0:_initialize_camera()
		arg_13_0:_initialize_broadphase()
		arg_13_0:_register_climb_units()
	end
end
