-- chunkname: @scripts/settings/mutators/mutator_arena_belakor_script.lua

local num = 7
local tbl = {
	tower = {
		mission_name = "arena_belakor_overload_statue",
		setup = function (arg_1_0, arg_1_1)
			-- function 1
			if not arg_1_1.is_server then
				arg_1_1.active_locus = {}

				local get_entities = Managers.state.entity:get_entities("DeusBelakorLocusExtension")

				for k, v in pairs(get_entities) do
					arg_1_1.active_locus[#arg_1_1.active_locus + 1] = {
						k,
						v
					}
				end
			end
		end,
		on_server_enter = function (arg_2_0, arg_2_1)
			-- function 2
			return
		end,
		on_server_exit = function (arg_3_0, arg_3_1)
			-- function 3
			return
		end,
		on_client_enter = function (self, arg_4_1)
			-- function 4
			Managers.state.entity:system("mission_system"):start_mission(self.base_state.mission_name)

			local get_entities = Managers.state.entity:get_entities("DeusBelakorLocusExtension")

			for k, v in pairs(get_entities) do
				local local_position = Unit.local_position(k, 0)
				local huge = math.huge
				local var_4_3
				local local_position_2 = Unit.local_position(arg_4_1.big_statue, 0)

				for k_2 = 1, #arg_4_1.decal_poses do
					local unbox = arg_4_1.decal_poses[k_2]:unbox()
					local translation = Matrix4x4.translation(unbox)
					local distance_squared = Vector3.distance_squared(local_position, translation)

					if distance_squared < huge then
						local_position_2 = unbox
						huge = distance_squared
						var_4_3 = k_2
					end
				end

				v:connect_to_statue(arg_4_1.big_statue, local_position_2)

				if not var_4_3 then
					table.swap_delete(arg_4_1.decal_poses, var_4_3)
				end
			end
		end,
		on_client_exit = function (self, arg_5_1)
			-- function 5
			Managers.state.entity:system("mission_system"):end_mission(self.base_state.mission_name)
		end,
		server_update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local num = 0

			for i, v in ipairs(arg_6_1.active_locus) do
				local flag

				flag = not v[2]:is_complete() and 1 and 0
				num = num + flag
			end

			if arg_6_1.shared_state:get_server(arg_6_1.shared_state:get_key("socketed_count")) ~= num then
				arg_6_1.shared_state:set_server(arg_6_1.shared_state:get_key("socketed_count"), num)
			end
		end,
		client_update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			-- function 7
			local flow_variable = Level.flow_variable(arg_7_1.level, "socketed_count")
			local get_server = arg_7_1.shared_state:get_server(arg_7_1.shared_state:get_key("socketed_count"))

			if flow_variable ~= get_server then
				Level.set_flow_variable(arg_7_1.level, "socketed_count", get_server)
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
		on_server_enter = function (self, arg_8_1)
			-- function 8
			local system = Managers.state.entity:system("volume_system")
			local exit_volume_id = self.exit_volume_id

			system:register_volume(exit_volume_id, "trigger_volume", {
				sub_type = "players_inside",
				on_triggered = function ()
					-- function 9
					arg_8_1.shared_state:set_server(arg_8_1.shared_state:get_key("state"), var_0_2.tower_phase_1.id)
				end
			})
		end,
		on_server_exit = function (self, arg_10_1)
			-- function 10
			local system = Managers.state.entity:system("volume_system")
			local exit_volume_id = self.exit_volume_id

			system:unregister_volume(exit_volume_id)
		end,
		on_client_enter = function (self, arg_11_1)
			-- function 11
			Managers.state.entity:system("mission_system"):start_mission(self.mission_name)
		end,
		on_client_exit = function (self, arg_12_1)
			-- function 12
			Managers.state.entity:system("mission_system"):end_mission(self.mission_name)
		end
	},
	tower_phase_1 = {
		id = 2,
		base_state = tbl.tower,
		server_update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			-- function 13
			local num = 0

			for i, v in ipairs(arg_13_1.active_locus) do
				local flag

				flag = not v[2]:is_complete() and 1 and 0
				num = num + flag
			end

			if not (not (num > 0) or not (num / #arg_13_1.active_locus >= 0.5)) then
				arg_13_1.shared_state:set_server(arg_13_1.shared_state:get_key("state"), var_0_2.tower_phase_2.id)
			end
		end
	},
	tower_phase_2 = {
		id = 3,
		base_state = tbl.tower,
		server_update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			-- function 14
			local num = 0

			for i, v in ipairs(arg_14_1.active_locus) do
				local flag

				flag = not v[2]:is_complete() and 1 and 0
				num = num + flag
			end

			if not (not (num > 0) or not (num / #arg_14_1.active_locus >= 1)) then
				arg_14_1.shared_state:set_server(arg_14_1.shared_state:get_key("state"), var_0_2.escape.id)
			end
		end
	},
	escape = {
		mission_name = "arena_belakor_escape",
		exit_volume_id = "trigger_escape_done",
		id = 4,
		setup = function (arg_15_0, arg_15_1)
			-- function 15
			return
		end,
		on_server_enter = function (arg_16_0, arg_16_1)
			-- function 16
			return
		end,
		on_client_enter = function (arg_17_0, arg_17_1)
			-- function 17
			return
		end
	}
}

local tbl_2 = {}
local tbl_3 = {}

for k, v in pairs(var_0_2) do
	tbl_2[v.id] = v
	tbl_3[v.id] = k
end

local tbl_4 = {
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

SharedState.validate_spec(tbl_4)

return {
	hide_from_player_ui = true,
	client_start_function = function (self, arg_18_1)
		-- function 18
		local is_server = self.is_server
		local var_18_1
		local var_18_2
		local peer_id = Network.peer_id()

		if not is_server then
			var_18_1 = Managers.mechanism:network_handler()
			var_18_2 = peer_id
		else
			var_18_2 = Managers.mechanism:network_handler().server_peer_id
		end

		arg_18_1.is_server = is_server
		arg_18_1.world = self.world
		arg_18_1.level = LevelHelper:current_level(arg_18_1.world)
		arg_18_1.shared_state = SharedState:new("mutator_arena_belakor_script", tbl_4, is_server, var_18_1, var_18_2, peer_id)
		arg_18_1.current_state = var_0_2.none

		if not is_server then
			arg_18_1.shared_state:set_server(arg_18_1.shared_state:get_key("state"), var_0_2.approaching_the_tower.id)
		end

		local get_entities = Managers.state.entity:get_entities("DeusArenaBelakorBigStatueExtension")
		local var_18_5

		for k, v in pairs(get_entities) do
			fassert(arg_18_1.big_statue == nil, "There can only be one unit with DeusArenaBelakorBigStatueExtension", #get_entities)

			var_18_5 = k
		end

		fassert(var_18_5, "There has to be one unit with DeusArenaBelakorBigStatueExtension")

		arg_18_1.big_statue = var_18_5

		local tbl = {}

		for k_2 = 1, num do
			local str = "ap_decal_0" .. k_2

			fassert(Unit.has_node(var_18_5, str), "There has to be a node called %s in the statue", str)

			local node = Unit.node(var_18_5, str)
			local world_pose = Unit.world_pose(arg_18_1.big_statue, node)

			tbl[#tbl + 1] = Matrix4x4Box(world_pose)
		end

		arg_18_1.decal_poses = tbl
	end,
	register_rpcs = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		arg_19_1.shared_state:register_rpcs(arg_19_2)
		arg_19_1.shared_state:full_sync()
	end,
	unregister_rpcs = function (arg_20_0, arg_20_1)
		-- function 20
		arg_20_1.shared_state:unregister_rpcs()
	end,
	client_update_function = function (self, arg_21_1, arg_21_2, arg_21_3)
		-- function 21
		if Managers.party:get_party_from_player_id(Network.peer_id(), 1).name == "undecided" then
			return
		end

		if not arg_21_1.setup_done then
			for k, v in pairs(tbl) do
				local setup = v.setup

				if not setup then
					setup(v, arg_21_1)
				end
			end

			for k_2, v_2 in pairs(var_0_2) do
				local setup_2 = v_2.setup

				if not setup_2 then
					setup_2(v_2, arg_21_1)
				end
			end

			arg_21_1.setup_done = true
		end

		local is_server = self.is_server
		local current_state = arg_21_1.current_state

		if not current_state then
			if not is_server then
				if not current_state.base_state and not current_state.base_state.server_update then
					current_state.base_state.server_update(current_state, arg_21_1, arg_21_2, arg_21_3)
				end

				if not current_state.server_update then
					current_state.server_update(current_state, arg_21_1, arg_21_2, arg_21_3)
				end
			end

			if not current_state.base_state and not current_state.base_state.client_update then
				current_state.base_state.client_update(current_state, arg_21_1, arg_21_2, arg_21_3)
			end

			if not current_state.client_update then
				current_state.client_update(current_state, arg_21_1, arg_21_2, arg_21_3)
			end
		end

		local get_server = arg_21_1.shared_state:get_server(arg_21_1.shared_state:get_key("state"))
		local var_21_5 = tbl_2[get_server]

		if current_state ~= var_21_5 then
			local base_state = current_state.base_state

			base_state = not base_state and current_state.base_state ~= var_21_5.base_state

			local base_state_2 = var_21_5.base_state

			base_state_2 = not base_state_2 and current_state.base_state ~= var_21_5.base_state

			if not is_server then
				if not current_state.on_server_exit then
					current_state.on_server_exit(current_state, arg_21_1)
				end

				if not base_state and not current_state.base_state.on_server_exit then
					current_state.base_state.on_server_exit(current_state, arg_21_1)
				end
			end

			if not current_state.on_client_exit then
				current_state.on_client_exit(current_state, arg_21_1)
			end

			if not base_state and not current_state.base_state.on_client_exit then
				current_state.base_state.on_client_exit(current_state, arg_21_1)
			end

			Level.trigger_event(arg_21_1.level, "on_exit_" .. tbl_3[current_state.id])

			local var_21_8 = var_21_5

			arg_21_1.current_state = var_21_8

			Level.trigger_event(arg_21_1.level, "on_enter_" .. tbl_3[var_21_8.id])

			if not is_server then
				if not base_state_2 and not var_21_5.base_state.on_server_enter then
					var_21_5.base_state.on_server_enter(var_21_8, arg_21_1)
				end

				if not var_21_5.on_server_enter then
					var_21_5.on_server_enter(var_21_5, arg_21_1)
				end
			end

			if not base_state_2 and not var_21_5.base_state.on_client_enter then
				var_21_5.base_state.on_client_enter(var_21_5, arg_21_1)
			end

			if not var_21_5.on_client_enter then
				var_21_5.on_client_enter(var_21_5, arg_21_1)
			end
		end
	end
}
