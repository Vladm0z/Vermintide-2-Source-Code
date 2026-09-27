-- chunkname: @scripts/entity_system/systems/dialogues/surrounding_aware_system.lua

local tbl = {}
local tbl_2 = {
	"GlobalObserverExtension",
	"LookatTargetExtension",
	"SurroundingObserverExtension",
	"SurroundingObserverHuskExtension"
}
local tbl_3 = {
	heard_speak = true,
	player_death = true
}

SurroundingAwareSystem = class(SurroundingAwareSystem, ExtensionSystemBase)

SurroundingAwareSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local entity_manager = arg_1_1.entity_manager

	entity_manager:register_system(self, arg_1_2, tbl_2)

	self.entity_manager = entity_manager
	self.world = arg_1_1.world
	self.physics_world = World.get_data(self.world, "physics_world")
	self.unit_storage = arg_1_1.unit_storage
	self.game = Managers.state.network:game()
	self.is_server = arg_1_1.is_server
	self.unit_input_data = {}
	self.unit_extension_data = {}
	self.observers = {}
	self.global_observers = {}
	self._global_observer_by_profile = {}
	self.broadphase = Broadphase(math.max(DialogueSettings.max_view_distance, DialogueSettings.max_hear_distance, DialogueSettings.discover_enemy_attack_distance), 256)
	self.event_array = pdArray.new()
	self.seen_recently = {}
	self.seen_observers = {}
	self.current_observer_unit = nil

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
	GarbageLeakDetector.register_object(self, "surrounding_aware_system")
end

SurroundingAwareSystem.populate_global_observers = function (self)
	-- function 2
	if not self.is_server then
		local alloc_table = FrameTable.alloc_table()
		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
		local var_2_2 = LevelSettings[get_current_level_keys]
		local flag = not var_2_2 and var_2_2.mission_givers

		if not flag then
			table.append(alloc_table, flag)
		end

		local mission_givers = Managers.state.game_mode:settings().mission_givers

		if not mission_givers then
			table.append(alloc_table, mission_givers)
		end

		for i = 1, #alloc_table do
			local var_2_5 = alloc_table[i]
			local dialogue_profile = var_2_5.dialogue_profile
			local faction = var_2_5.faction
			local side_name = var_2_5.side_name

			self:request_global_listener(dialogue_profile, faction, side_name)
		end
	end
end

SurroundingAwareSystem.request_global_listener = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local get_side_from_name = Managers.state.side:get_side_from_name(arg_3_3)

	for k, v in pairs(self.global_observers) do
		if v.dialogue_profile == arg_3_1 then
			local extension = ScriptUnit.extension(k, "dialogue_system")

			fassert(not arg_3_2 and arg_3_2 == extension.faction, "[SurroundingAwareSystem] Mismatching faction when requesting duplicate global listener '%s'. Wanted '%s' while existing listener has '%s'", arg_3_1, arg_3_2, extension.faction)

			local var_3_2 = self.unit_extension_data[k]
			local fassert = fassert
			local flag = not arg_3_3 and (not get_side_from_name and get_side_from_name.side_id) == var_3_2.side_id
			local str = "[SurroundingAwareSystem] Mismatching side name when requesting duplicate global listener '%s'. Wanted '%s' while existing listener has '%s'"
			local var_3_6 = arg_3_1
			local var_3_7 = arg_3_3
			local name

			if not get_side_from_name then
				name = get_side_from_name:name()

				if not name then
					-- Nothing
				end
			end

			name = nil

			::label_3_0::

			fassert(flag, str, var_3_6, var_3_7, name)

			return k
		end
	end

	local tbl = {
		dialogue_system = {
			dialogue_profile = arg_3_1,
			faction = arg_3_2
		},
		surrounding_aware_system = {
			side_id = not get_side_from_name and get_side_from_name.side_id
		}
	}

	return Managers.state.unit_spawner:spawn_network_unit("units/hub_elements/empty", "dialogue_node", tbl)
end

SurroundingAwareSystem.query_global_listener = function (self, arg_4_1)
	-- function 4
	for k, v in pairs(self.global_observers) do
		if v.dialogue_profile == arg_4_1 then
			return k
		end
	end

	return nil
end

SurroundingAwareSystem.destroy = function (self)
	-- function 5
	for k, v in pairs(self.unit_extension_data) do
		Broadphase.remove(self.broadphase, v.broadphase_id)
	end

	self.network_event_delegate:unregister(self)
	table.clear(self)
end

SurroundingAwareSystem.add_event = function (arg_6_0, arg_6_1, arg_6_2, ...)
	-- function 6
	arg_6_2 = arg_6_2 or DialogueSettings.default_hear_distance

	local event_array = ScriptUnit.extension_input(arg_6_0, "surrounding_aware_system").event_array
	local var_6_1 = select("#", ...)
	local data, var_6_3 = pdArray.data(event_array)

	fassert(type(arg_6_1) == "string", "First argument to add_event must be an event-name.")
	fassert(type(arg_6_2) == "number", "Second argument to add_event must be distance.")
	fassert(var_6_1 % 2 == 0, "Arguments must be set by key, value-pairs. Thus num args must be an even number.")
	pack_index[var_6_1 + 4](data, var_6_3 + 1, var_6_1, arg_6_0, arg_6_1, arg_6_2, ...)

	local num = var_6_3 + var_6_1 + 4

	pdArray.set_size(event_array, num)
end

SurroundingAwareSystem.add_system_event = function (self, arg_7_1, arg_7_2, arg_7_3, ...)
	-- function 7
	arg_7_3 = arg_7_3 or DialogueSettings.default_hear_distance

	local event_array = self.event_array
	local var_7_1 = select("#", ...)
	local data, var_7_3 = pdArray.data(event_array)

	fassert(type(arg_7_2) == "string", "First argument to add_event must be an event-name.")
	fassert(type(arg_7_3) == "number", "Second argument to add_event must be distance.")
	fassert(var_7_1 % 2 == 0, "Arguments must be set by key, value-pairs. Thus num args must be an even number.")
	pack_index[var_7_1 + 4](data, var_7_3 + 1, var_7_1, arg_7_1, arg_7_2, arg_7_3, ...)

	local num = var_7_3 + var_7_1 + 4

	pdArray.set_size(event_array, num)
end

local tbl_4 = {}

SurroundingAwareSystem.on_add_extension = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local tbl = {
		input = MakeTableStrict({
			event_array = self.event_array
		})
	}

	ScriptUnit.set_extension(arg_8_2, "surrounding_aware_system", tbl, tbl_4)

	self.unit_input_data[arg_8_2] = tbl.input
	self.unit_extension_data[arg_8_2] = tbl
	tbl.broadphase_id = Broadphase.add(self.broadphase, arg_8_2, Unit.world_position(arg_8_2, 0), 0.5)

	if not (arg_8_3 == "SurroundingObserverExtension" or arg_8_3 ~= "SurroundingObserverHuskExtension") then
		tbl.view_angle = 11.25
		tbl.view_angle_rad = math.degrees_to_radians(tbl.view_angle)
		tbl.last_lookat_trigger = 0
		tbl.view_distance = DialogueSettings.observer_view_distance
		tbl.view_distance_sq = tbl.view_distance^2
		self.observers[arg_8_2] = tbl
	elseif arg_8_3 == "GlobalObserverExtension" then
		self.global_observers[arg_8_2] = tbl
	else
		tbl.has_been_seen = false
		tbl.is_lookat_object = true

		local get_data = Unit.get_data(arg_8_2, "view_distance")

		get_data = get_data or DialogueSettings.default_view_distance
		tbl.view_distance = get_data
		tbl.view_distance_sq = tbl.view_distance^2
	end

	if not arg_8_4.side_id then
		tbl.side_id = arg_8_4.side_id

		Managers.state.side:add_unit_to_side(arg_8_2, arg_8_4.side_id)
	end

	return tbl
end

SurroundingAwareSystem.get_global_observer_unit = function (self, arg_9_1)
	-- function 9
	return self._global_observer_by_profile[arg_9_1]
end

SurroundingAwareSystem.get_global_observers = function (self)
	-- function 10
	return self.global_observers
end

SurroundingAwareSystem.extensions_ready = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local extension = ScriptUnit.extension(arg_11_2, "surrounding_aware_system")

	if not (arg_11_3 == "SurroundingObserverExtension" or arg_11_3 ~= "SurroundingObserverHuskExtension") then
		-- Nothing
	elseif arg_11_3 == "GlobalObserverExtension" then
		local has_extension = ScriptUnit.has_extension(arg_11_2, "dialogue_system")

		if not has_extension then
			local dialogue_profile = has_extension.dialogue_profile

			dialogue_profile = dialogue_profile or Unit.get_data(arg_11_2, "dialogue_profile")
			extension.dialogue_profile = dialogue_profile

			assert(extension.dialogue_profile, "[SurroundingAwareSystem] Global Observer is missing a dialogue profile", arg_11_2)

			arg_11_0._global_observer_by_profile[extension.dialogue_profile] = arg_11_2
		end
	elseif not ScriptUnit.has_extension(arg_11_2, "pickup_system") then
		extension.collision_filter = "filter_lookat_pickup_object_ray"
	end
end

SurroundingAwareSystem.on_remove_extension = function (self, arg_12_1, arg_12_2)
	-- function 12
	Broadphase.remove(self.broadphase, self.unit_extension_data[arg_12_1].broadphase_id)

	local var_12_0 = self.unit_extension_data[arg_12_1]

	self.unit_input_data[arg_12_1] = nil
	self.unit_extension_data[arg_12_1] = nil

	if not (arg_12_2 == "SurroundingObserverExtension" or arg_12_2 ~= "SurroundingObserverHuskExtension") then
		self.observers[arg_12_1] = nil

		local seen_observers = self.seen_observers
		local var_12_2 = seen_observers[arg_12_1]
		local flag = not var_12_2 and ScriptUnit.has_extension(var_12_2, "ai_system")

		if not flag then
			flag:set_seen_by_player(false, arg_12_1)
		end

		seen_observers[arg_12_1] = nil

		for k, v in pairs(seen_observers) do
			if v == arg_12_1 then
				seen_observers[k] = nil
			end
		end
	elseif arg_12_2 == "GlobalObserverExtension" then
		self.global_observers[arg_12_1] = nil
		self._global_observer_by_profile[var_12_0.dialogue_profile] = nil
	end

	ScriptUnit.remove_extension(arg_12_1, "surrounding_aware_system")
end

SurroundingAwareSystem.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	self:update_seen_recently(arg_13_1, arg_13_2)
	self:update_lookat(arg_13_1, arg_13_2)
	self:update_events(arg_13_1, arg_13_2)
end

local function fn(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	if Vector3.length(arg_14_4) == 0 then
		return true
	end

	local immediate_raycast = PhysicsWorld.immediate_raycast(arg_14_0, arg_14_3, arg_14_4, arg_14_5, "all", "types", "both", "collision_filter", arg_14_6 or "filter_lookat_object_ray")

	if not immediate_raycast then
		local count = #immediate_raycast

		for i = 1, count do
			local var_14_2 = immediate_raycast[i]
			local unit = Actor.unit(var_14_2[4])

			if not (unit == arg_14_1 or unit == arg_14_2) then
				return false
			end
		end
	end

	return true
end

local function fn_2(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local num = arg_15_1 - arg_15_0
	local normalize = Vector3.normalize(num)
	local max = math.max(0.1, Vector3.length_squared(num))

	if arg_15_3 < max then
		return false, num, normalize, nil, nil
	end

	local num_2 = arg_15_3 / (2 * max)
	local dot = Vector3.dot(arg_15_2, normalize)
	local acos = math.acos(dot)
	local num_3 = arg_15_4 * num_2

	if num_3 <= acos then
		return false, num, normalize, acos, num_3
	end

	return true, num, normalize, acos, num_3
end

local num = 10
local num_2 = -1
local num_3 = 1.5
local tbl_5 = {}

SurroundingAwareSystem.update_lookat = function (self, arg_16_1, arg_16_2)
	-- function 16
	local observers = self.observers

	if observers[self.current_observer_unit] == nil then
		self.current_observer_unit = nil
	end

	self.current_observer_unit = next(observers, self.current_observer_unit)

	local game = self.game
	local current_observer_unit = self.current_observer_unit

	if not (game == nil or current_observer_unit ~= nil) then
		return
	end

	local POSITION_LOOKUP = POSITION_LOOKUP
	local Broadphase = Broadphase
	local broadphase = self.broadphase
	local var_16_6 = observers[current_observer_unit]
	local var_16_7 = POSITION_LOOKUP[current_observer_unit]

	if not var_16_7 then
		return
	end

	Broadphase.move(broadphase, var_16_6.broadphase_id, var_16_7)

	if arg_16_2 - var_16_6.last_lookat_trigger <= DialogueSettings.view_event_trigger_interval then
		return
	end

	local Unit = Unit
	local Vector3 = Vector3
	local math = math
	local Matrix4x4 = Matrix4x4
	local seen_recently = self.seen_recently
	local physics_world = self.physics_world
	local system = Managers.state.entity:system("darkness_system")
	local is_server = self.is_server
	local seen_observers = self.seen_observers
	local go_id = self.unit_storage:go_id(current_observer_unit)
	local game_object_field = GameSession.game_object_field(game, go_id, "aim_position")
	local game_object_field_2 = GameSession.game_object_field(game, go_id, "aim_direction")
	local extension_input = ScriptUnit.extension_input(current_observer_unit, "dialogue_system")
	local num_4 = DialogueSettings.max_view_distance * 0.5
	local num_5 = game_object_field + game_object_field_2 * num_4
	local query = Broadphase.query(broadphase, num_5, num_4, tbl_5)
	local var_16_24 = seen_observers[current_observer_unit]
	local huge = math.huge
	local var_16_26

	for i = 1, query do
		local var_16_27 = tbl_5[i]

		tbl_5[i] = nil

		local var_16_28 = seen_recently[var_16_27]

		if not (var_16_27 == current_observer_unit or var_16_28) then
			local extension = ScriptUnit.extension(var_16_27, "surrounding_aware_system")
			local is_lookat_object = extension.is_lookat_object

			if is_lookat_object or not is_server or not observers[var_16_27] then
				local var_16_31

				if not Unit.has_node(var_16_27, "j_spine") then
					local node = Unit.node(var_16_27, "j_spine")

					var_16_31 = Unit.world_position(var_16_27, node)
				else
					local box = Unit.box(var_16_27)

					var_16_31 = Matrix4x4.translation(box)
				end

				local view_distance_sq = extension.view_distance_sq
				local view_angle_rad = var_16_6.view_angle_rad
				local var_16_36

				if var_16_27 == var_16_24 then
					var_16_36 = num_3

					if not var_16_36 then
						-- Nothing
					end
				end

				var_16_36 = 1

				::label_16_0::

				local num_6 = view_angle_rad * var_16_36
				local var_16_38, var_16_39, var_16_40, var_16_41, var_16_42 = fn_2(game_object_field, var_16_31, game_object_field_2, view_distance_sq, num_6)

				if not (not var_16_38 and system:is_in_darkness(var_16_31)) then
					local length = Vector3.length(var_16_39)
					local collision_filter = extension.collision_filter
					local var_16_45 = fn(physics_world, current_observer_unit, var_16_27, game_object_field, var_16_40, length, collision_filter)

					if not is_lookat_object and not var_16_45 then
						extension.has_been_seen = true
						var_16_6.last_lookat_trigger = arg_16_2

						local alloc_table = FrameTable.alloc_table()
						local get_data = Unit.get_data(var_16_27, "lookat_tag")

						get_data = get_data or Unit.debug_name(var_16_27)
						alloc_table.item_tag = get_data
						alloc_table.distance = length

						extension_input:trigger_dialogue_event("seen_item", alloc_table)

						seen_recently[var_16_27] = arg_16_2
					elseif not var_16_45 then
						local var_16_48 = num
						local var_16_49

						if var_16_27 == var_16_24 then
							var_16_49 = num_2

							if not var_16_49 then
								-- Nothing
							end
						end

						var_16_49 = 0

						::label_16_1::

						local num_7 = var_16_41 * (var_16_48 + var_16_49) + length

						if num_7 < huge then
							var_16_26 = var_16_27
							huge = num_7
						end
					end
				end
			end
		end
	end

	if not (not is_server and var_16_26 == var_16_24) then
		local flag = not Managers.player:unit_owner(current_observer_unit).bot_player

		if not var_16_24 then
			local has_extension = ScriptUnit.has_extension(var_16_24, "ai_system")

			if not flag and not has_extension then
				has_extension:set_seen_by_player(false, current_observer_unit)
			end
		end

		if not var_16_26 then
			local has_extension_2 = ScriptUnit.has_extension(var_16_26, "ai_system")

			if not flag and not has_extension_2 then
				has_extension_2:set_seen_by_player(true, current_observer_unit, arg_16_2)
			end
		end

		seen_observers[current_observer_unit] = var_16_26
	end
end

SurroundingAwareSystem.update_debug = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not script_data.dialogue_debug_lookat then
		return
	end

	local game = self.game
	local local_player = Managers.player:local_player()

	if not (not local_player and not local_player.player_unit and game) then
		return
	end

	local var_17_2 = Color(255, 255, 0, 0)
	local var_17_3 = Color(255, 0, 255, 0)
	local var_17_4 = Color(255, 0, 255, 255)
	local alloc_table = FrameTable.alloc_table()
	local drawer = Managers.state.debug:drawer(debug_drawer_info)
	local broadphase = self.broadphase
	local physics_world = self.physics_world
	local system = Managers.state.entity:system("darkness_system")
	local player_unit = local_player.player_unit
	local var_17_11 = self.unit_extension_data[player_unit]
	local observers = self.observers
	local is_server = self.is_server
	local seen_observers = self.seen_observers
	local var_17_15 = seen_observers[player_unit]
	local go_id = self.unit_storage:go_id(player_unit)
	local game_object_field = GameSession.game_object_field(game, go_id, "aim_position")
	local game_object_field_2 = GameSession.game_object_field(game, go_id, "aim_direction")
	local num = DialogueSettings.max_view_distance * 0.5
	local num_2 = game_object_field + game_object_field_2 * num
	local query = Broadphase.query(broadphase, num_2, num, tbl_5)

	drawer:sphere(num_2, num, Colors.get("light_blue"))
	drawer:vector(game_object_field, game_object_field_2)

	for i = 1, query do
		local var_17_22 = tbl_5[i]

		tbl_5[i] = nil

		if var_17_22 ~= player_unit then
			local var_17_23 = Color(255, 0, 0, 255)
			local format = string.format("SAS: %q | ", Unit.debug_name(var_17_22))
			local extension = ScriptUnit.extension(var_17_22, "surrounding_aware_system")
			local is_lookat_object = extension.is_lookat_object

			if extension.is_lookat_object or not is_server or not observers[var_17_22] then
				local var_17_27

				if not Unit.has_node(var_17_22, "j_spine") then
					local node = Unit.node(var_17_22, "j_spine")

					var_17_27 = Unit.world_position(var_17_22, node)
				else
					local box = Unit.box(var_17_22)

					var_17_27 = Matrix4x4.translation(box)
				end

				local view_distance_sq = extension.view_distance_sq
				local view_angle_rad = var_17_11.view_angle_rad
				local var_17_32

				if var_17_22 == var_17_15 then
					var_17_32 = num_3

					if not var_17_32 then
						-- Nothing
					end
				end

				var_17_32 = 1

				::label_17_0::

				local num_4 = view_angle_rad * var_17_32
				local var_17_34, var_17_35, var_17_36, var_17_37, var_17_38 = fn_2(game_object_field, var_17_27, game_object_field_2, view_distance_sq, num_4)
				local length = Vector3.length(var_17_35)

				format = string.format(format .. "DISTANCE: %.2f/%.2f", length, extension.view_distance)

				if not var_17_37 then
					format = string.format(format .. "| ANGLE: %.2f/%.2f", math.radians_to_degrees(var_17_37), math.radians_to_degrees(var_17_38))
				end

				if not (not var_17_34 and system:is_in_darkness(var_17_27)) then
					local length_2 = Vector3.length(var_17_35)
					local collision_filter = extension.collision_filter

					if not fn(physics_world, player_unit, var_17_22, game_object_field, var_17_36, length_2, collision_filter) then
						var_17_23 = var_17_3
					else
						var_17_23 = var_17_4
					end
				else
					var_17_23 = var_17_2
				end

				alloc_table[var_17_22] = var_17_23

				drawer:vector(game_object_field, var_17_36, var_17_23)
			end

			Debug.text(format)
		end
	end

	for k, v in pairs(self.unit_extension_data) do
		if k ~= player_unit then
			local var_17_42 = alloc_table[k]

			var_17_42 = var_17_42 or var_17_2

			drawer:unit(k, var_17_42)
		end
	end

	if not is_server then
		local var_17_43 = seen_observers[player_unit]

		if not var_17_43 then
			local node_2 = Unit.node(var_17_43, "j_spine")
			local world_position = Unit.world_position(var_17_43, node_2)
			local has_extension = ScriptUnit.has_extension(var_17_43, "ai_system")
			local var_17_47 = drawer
			local sphere = drawer.sphere
			local var_17_49 = world_position
			local num_5 = 0.25
			local get

			if not has_extension then
				get = Colors.get("blue")

				if not get then
					-- Nothing
				end
			end

			get = Colors.get("light_blue")

			::label_17_1::

			sphere(var_17_47, var_17_49, num_5, get)
		end
	end
end

local tbl_6 = {
	heard_speak = "heard_speak_self"
}

SurroundingAwareSystem.update_events = function (self, arg_18_1, arg_18_2)
	-- function 18
	local unit_input_data = self.unit_input_data
	local broadphase = self.broadphase
	local event_array = self.event_array
	local data, var_18_4 = pdArray.data(event_array)
	local num = 1

	while num <= var_18_4 do
		local var_18_6 = data[num]
		local var_18_7 = data[num + 1]
		local var_18_8 = data[num + 2]
		local var_18_9 = data[num + 3]

		if not Unit.alive(var_18_7) then
			local var_18_10 = POSITION_LOOKUP[var_18_7]

			var_18_10 = var_18_10 or Unit.local_position(var_18_7, 0)

			local num_2 = 0

			if var_18_9 == math.huge then
				local num_3 = 0

				for k, v in pairs(self.observers) do
					num_3 = num_3 + 1
					tbl_5[num_3] = k
				end

				num_2 = num_3
			else
				num_2 = Broadphase.query(broadphase, var_18_10, var_18_9, tbl_5)
			end

			for k_2 = 1, num_2 do
				local var_18_13 = tbl_5[k_2]

				tbl_5[k_2] = nil

				local flag = var_18_13 == var_18_7

				if not ScriptUnit.has_extension(var_18_13, "dialogue_system") and not flag and not tbl_6[var_18_8] then
					local extension_input = ScriptUnit.extension_input(var_18_13, "dialogue_system")
					local alloc_table = FrameTable.alloc_table()
					local num_4 = 0

					if not var_18_7 then
						local var_18_18 = POSITION_LOOKUP[var_18_13]

						var_18_18 = var_18_18 or Unit.local_position(var_18_13, 0)
						num_4 = Vector3.distance(var_18_10, var_18_18)
					end

					alloc_table.distance = num_4

					for l = 1, var_18_6 / 2 do
						local num_5 = num + 3 + (l - 1) * 2 + 1

						alloc_table[data[num_5]] = data[num_5 + 1]
					end

					tbl_5[var_18_13] = true

					if not flag then
						extension_input:trigger_dialogue_event(tbl_6[var_18_8], alloc_table)
					else
						extension_input:trigger_dialogue_event(var_18_8, alloc_table)
					end
				end
			end

			if not tbl_3[var_18_8] then
				local alloc_table_2 = FrameTable.alloc_table()

				for i4 = 1, var_18_6 / 2 do
					local num_6 = num + 3 + (i4 - 1) * 2 + 1

					alloc_table_2[data[num_6]] = data[num_6 + 1]
				end

				for k_3, v_2 in pairs(self.global_observers) do
					if not tbl_5[k_3] then
						local input = ScriptUnit.extension(k_3, "dialogue_system").input

						if not (var_18_7 == k_3) then
							input:trigger_dialogue_event(var_18_8, alloc_table_2)
						elseif not tbl_6[var_18_8] then
							input:trigger_dialogue_event(tbl_6[var_18_8], alloc_table_2)
						end
					end
				end
			end

			table.clear(tbl_5)
		end

		num = num + 4 + var_18_6
	end

	pdArray.set_empty(event_array)
end

SurroundingAwareSystem.update_seen_recently = function (self, arg_19_1, arg_19_2)
	-- function 19
	local seen_recently = self.seen_recently
	local num = arg_19_2 - DialogueSettings.seen_recently_threshold

	for k, v in pairs(seen_recently) do
		if v < num then
			seen_recently[k] = nil
		end
	end
end

SurroundingAwareSystem.hot_join_sync = function (arg_20_0, arg_20_1)
	-- function 20
	return
end
