-- chunkname: @scripts/settings/mutators/mutator_arena_belakor_script.lua

local var_0_0 = 7
local var_0_1 = {
	tower = {
		mission_name = "arena_belakor_overload_statue",
		setup = function (arg_1_0, arg_1_1)
			if arg_1_1.is_server then
				arg_1_1.active_locus = {}

				local var_1_0 = Managers.state.entity:get_entities("DeusBelakorLocusExtension")

				for iter_1_0, iter_1_1 in pairs(var_1_0) do
					arg_1_1.active_locus[#arg_1_1.active_locus + 1] = {
						iter_1_0,
						iter_1_1
					}
				end
			end
		end,
		on_server_enter = function (arg_2_0, arg_2_1)
			return
		end,
		on_server_exit = function (arg_3_0, arg_3_1)
			return
		end,
		on_client_enter = function (arg_4_0, arg_4_1)
			Managers.state.entity:system("mission_system"):start_mission(arg_4_0.base_state.mission_name)

			local var_4_0 = Managers.state.entity:get_entities("DeusBelakorLocusExtension")

			for iter_4_0, iter_4_1 in pairs(var_4_0) do
				local var_4_1 = Unit.local_position(iter_4_0, 0)
				local var_4_2 = math.huge
				local var_4_3
				local var_4_4 = Unit.local_position(arg_4_1.big_statue, 0)

				for iter_4_2 = 1, #arg_4_1.decal_poses do
					local var_4_5 = arg_4_1.decal_poses[iter_4_2]:unbox()
					local var_4_6 = Matrix4x4.translation(var_4_5)
					local var_4_7 = Vector3.distance_squared(var_4_1, var_4_6)

					if var_4_7 < var_4_2 then
						var_4_4 = var_4_5
						var_4_2 = var_4_7
						var_4_3 = iter_4_2
					end
				end

				iter_4_1:connect_to_statue(arg_4_1.big_statue, var_4_4)

				if var_4_3 then
					table.swap_delete(arg_4_1.decal_poses, var_4_3)
				end
			end
		end,
		on_client_exit = function (arg_5_0, arg_5_1)
			Managers.state.entity:system("mission_system"):end_mission(arg_5_0.base_state.mission_name)
		end,
		server_update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = 0

			for iter_6_0, iter_6_1 in ipairs(arg_6_1.active_locus) do
				var_6_0 = var_6_0 + (iter_6_1[2]:is_complete() and 1 or 0)
			end

			if arg_6_1.shared_state:get_server(arg_6_1.shared_state:get_key("socketed_count")) ~= var_6_0 then
				arg_6_1.shared_state:set_server(arg_6_1.shared_state:get_key("socketed_count"), var_6_0)
			end
		end,
		client_update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			local var_7_0 = Level.flow_variable(arg_7_1.level, "socketed_count")
			local var_7_1 = arg_7_1.shared_state:get_server(arg_7_1.shared_state:get_key("socketed_count"))

			if var_7_0 ~= var_7_1 then
				Level.set_flow_variable(arg_7_1.level, "socketed_count", var_7_1)
				Level.trigger_event(arg_7_1.level, "update_socketed_count")
			end
		end
	}
}
local var_0_2

var_0_2 = {
	none = {
		id = 0
	},
	approaching_the_tower = {
		mission_name = "arena_belakor_go_tower",
		exit_volume_id = "trigger_approach_tower_done",
		id = 1,
		on_server_enter = function (arg_8_0, arg_8_1)
			local var_8_0 = Managers.state.entity:system("volume_system")
			local var_8_1 = arg_8_0.exit_volume_id

			var_8_0:register_volume(var_8_1, "trigger_volume", {
				sub_type = "players_inside",
				on_triggered = function ()
					arg_8_1.shared_state:set_server(arg_8_1.shared_state:get_key("state"), var_0_2.tower_phase_1.id)
				end
			})
		end,
		on_server_exit = function (arg_10_0, arg_10_1)
			local var_10_0 = Managers.state.entity:system("volume_system")
			local var_10_1 = arg_10_0.exit_volume_id

			var_10_0:unregister_volume(var_10_1)
		end,
		on_client_enter = function (arg_11_0, arg_11_1)
			Managers.state.entity:system("mission_system"):start_mission(arg_11_0.mission_name)
		end,
		on_client_exit = function (arg_12_0, arg_12_1)
			Managers.state.entity:system("mission_system"):end_mission(arg_12_0.mission_name)
		end
	},
	tower_phase_1 = {
		id = 2,
		base_state = var_0_1.tower,
		server_update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			local var_13_0 = 0

			for iter_13_0, iter_13_1 in ipairs(arg_13_1.active_locus) do
				var_13_0 = var_13_0 + (iter_13_1[2]:is_complete() and 1 or 0)
			end

			if var_13_0 > 0 and var_13_0 / #arg_13_1.active_locus >= 0.5 then
				arg_13_1.shared_state:set_server(arg_13_1.shared_state:get_key("state"), var_0_2.tower_phase_2.id)
			end
		end
	},
	tower_phase_2 = {
		id = 3,
		base_state = var_0_1.tower,
		server_update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			local var_14_0 = 0

			for iter_14_0, iter_14_1 in ipairs(arg_14_1.active_locus) do
				var_14_0 = var_14_0 + (iter_14_1[2]:is_complete() and 1 or 0)
			end

			if var_14_0 > 0 and var_14_0 / #arg_14_1.active_locus >= 1 then
				arg_14_1.shared_state:set_server(arg_14_1.shared_state:get_key("state"), var_0_2.escape.id)
			end
		end
	},
	escape = {
		mission_name = "arena_belakor_escape",
		exit_volume_id = "trigger_escape_done",
		id = 4,
		setup = function (arg_15_0, arg_15_1)
			return
		end,
		on_server_enter = function (arg_16_0, arg_16_1)
			return
		end,
		on_client_enter = function (arg_17_0, arg_17_1)
			return
		end
	}
}

local var_0_3 = {}
local var_0_4 = {}

for iter_0_0, iter_0_1 in pairs(var_0_2) do
	var_0_3[iter_0_1.id] = iter_0_1
	var_0_4[iter_0_1.id] = iter_0_0
end

local var_0_5 = {
	server = {
		state = {
			type = "number",
			default_value = var_0_2.none.id,
			composite_keys = {}
		},
		socketed_count = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		}
	},
	peer = {}
}

SharedState.validate_spec(var_0_5)

return {
	hide_from_player_ui = true,
	client_start_function = function (arg_18_0, arg_18_1)
		local var_18_0 = arg_18_0.is_server
		local var_18_1
		local var_18_2
		local var_18_3 = Network.peer_id()

		if var_18_0 then
			var_18_1 = Managers.mechanism:network_handler()
			var_18_2 = var_18_3
		else
			var_18_2 = Managers.mechanism:network_handler().server_peer_id
		end

		arg_18_1.is_server = var_18_0
		arg_18_1.world = arg_18_0.world
		arg_18_1.level = LevelHelper:current_level(arg_18_1.world)
		arg_18_1.shared_state = SharedState:new("mutator_arena_belakor_script", var_0_5, var_18_0, var_18_1, var_18_2, var_18_3)
		arg_18_1.current_state = var_0_2.none

		if var_18_0 then
			arg_18_1.shared_state:set_server(arg_18_1.shared_state:get_key("state"), var_0_2.approaching_the_tower.id)
		end

		local var_18_4 = Managers.state.entity:get_entities("DeusArenaBelakorBigStatueExtension")
		local var_18_5

		for iter_18_0, iter_18_1 in pairs(var_18_4) do
			fassert(arg_18_1.big_statue == nil, "There can only be one unit with DeusArenaBelakorBigStatueExtension", #var_18_4)

			var_18_5 = iter_18_0
		end

		fassert(var_18_5, "There has to be one unit with DeusArenaBelakorBigStatueExtension")

		arg_18_1.big_statue = var_18_5

		local var_18_6 = {}

		for iter_18_2 = 1, var_0_0 do
			local var_18_7 = "ap_decal_0" .. iter_18_2

			fassert(Unit.has_node(var_18_5, var_18_7), "There has to be a node called %s in the statue", var_18_7)

			local var_18_8 = Unit.node(var_18_5, var_18_7)
			local var_18_9 = Unit.world_pose(arg_18_1.big_statue, var_18_8)

			var_18_6[#var_18_6 + 1] = Matrix4x4Box(var_18_9)
		end

		arg_18_1.decal_poses = var_18_6
	end,
	register_rpcs = function (arg_19_0, arg_19_1, arg_19_2)
		arg_19_1.shared_state:register_rpcs(arg_19_2)
		arg_19_1.shared_state:full_sync()
	end,
	unregister_rpcs = function (arg_20_0, arg_20_1)
		arg_20_1.shared_state:unregister_rpcs()
	end,
	client_update_function = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		if Managers.party:get_party_from_player_id(Network.peer_id(), 1).name == "undecided" then
			return
		end

		if not arg_21_1.setup_done then
			for iter_21_0, iter_21_1 in pairs(var_0_1) do
				local var_21_0 = iter_21_1.setup

				if var_21_0 then
					var_21_0(iter_21_1, arg_21_1)
				end
			end

			for iter_21_2, iter_21_3 in pairs(var_0_2) do
				local var_21_1 = iter_21_3.setup

				if var_21_1 then
					var_21_1(iter_21_3, arg_21_1)
				end
			end

			arg_21_1.setup_done = true
		end

		local var_21_2 = arg_21_0.is_server
		local var_21_3 = arg_21_1.current_state

		if var_21_3 then
			if var_21_2 then
				if var_21_3.base_state and var_21_3.base_state.server_update then
					var_21_3.base_state.server_update(var_21_3, arg_21_1, arg_21_2, arg_21_3)
				end

				if var_21_3.server_update then
					var_21_3.server_update(var_21_3, arg_21_1, arg_21_2, arg_21_3)
				end
			end

			if var_21_3.base_state and var_21_3.base_state.client_update then
				var_21_3.base_state.client_update(var_21_3, arg_21_1, arg_21_2, arg_21_3)
			end

			if var_21_3.client_update then
				var_21_3.client_update(var_21_3, arg_21_1, arg_21_2, arg_21_3)
			end
		end

		local var_21_4 = arg_21_1.shared_state:get_server(arg_21_1.shared_state:get_key("state"))
		local var_21_5 = var_0_3[var_21_4]

		if var_21_3 ~= var_21_5 then
			local var_21_6 = var_21_3.base_state and var_21_3.base_state ~= var_21_5.base_state
			local var_21_7 = var_21_5.base_state and var_21_3.base_state ~= var_21_5.base_state

			if var_21_2 then
				if var_21_3.on_server_exit then
					var_21_3.on_server_exit(var_21_3, arg_21_1)
				end

				if var_21_6 and var_21_3.base_state.on_server_exit then
					var_21_3.base_state.on_server_exit(var_21_3, arg_21_1)
				end
			end

			if var_21_3.on_client_exit then
				var_21_3.on_client_exit(var_21_3, arg_21_1)
			end

			if var_21_6 and var_21_3.base_state.on_client_exit then
				var_21_3.base_state.on_client_exit(var_21_3, arg_21_1)
			end

			Level.trigger_event(arg_21_1.level, "on_exit_" .. var_0_4[var_21_3.id])

			local var_21_8 = var_21_5

			arg_21_1.current_state = var_21_8

			Level.trigger_event(arg_21_1.level, "on_enter_" .. var_0_4[var_21_8.id])

			if var_21_2 then
				if var_21_7 and var_21_5.base_state.on_server_enter then
					var_21_5.base_state.on_server_enter(var_21_8, arg_21_1)
				end

				if var_21_5.on_server_enter then
					var_21_5.on_server_enter(var_21_5, arg_21_1)
				end
			end

			if var_21_7 and var_21_5.base_state.on_client_enter then
				var_21_5.base_state.on_client_enter(var_21_5, arg_21_1)
			end

			if var_21_5.on_client_enter then
				var_21_5.on_client_enter(var_21_5, arg_21_1)
			end
		end
	end
}
