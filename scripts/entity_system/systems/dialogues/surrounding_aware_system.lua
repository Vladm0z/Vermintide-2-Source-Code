-- chunkname: @scripts/entity_system/systems/dialogues/surrounding_aware_system.lua

local var_0_0 = {}
local var_0_1 = {
	"GlobalObserverExtension",
	"LookatTargetExtension",
	"SurroundingObserverExtension",
	"SurroundingObserverHuskExtension"
}
local var_0_2 = {
	heard_speak = true,
	player_death = true
}

SurroundingAwareSystem = class(SurroundingAwareSystem, ExtensionSystemBase)

SurroundingAwareSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.entity_manager

	var_1_0:register_system(arg_1_0, arg_1_2, var_0_1)

	arg_1_0.entity_manager = var_1_0
	arg_1_0.world = arg_1_1.world
	arg_1_0.physics_world = World.get_data(arg_1_0.world, "physics_world")
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0.game = Managers.state.network:game()
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.unit_input_data = {}
	arg_1_0.unit_extension_data = {}
	arg_1_0.observers = {}
	arg_1_0.global_observers = {}
	arg_1_0._global_observer_by_profile = {}
	arg_1_0.broadphase = Broadphase(math.max(DialogueSettings.max_view_distance, DialogueSettings.max_hear_distance, DialogueSettings.discover_enemy_attack_distance), 256)
	arg_1_0.event_array = pdArray.new()
	arg_1_0.seen_recently = {}
	arg_1_0.seen_observers = {}
	arg_1_0.current_observer_unit = nil

	local var_1_1 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_1

	var_1_1:register(arg_1_0, unpack(var_0_0))
	GarbageLeakDetector.register_object(arg_1_0, "surrounding_aware_system")
end

SurroundingAwareSystem.populate_global_observers = function (arg_2_0)
	if arg_2_0.is_server then
		local var_2_0 = FrameTable.alloc_table()
		local var_2_1 = Managers.level_transition_handler:get_current_level_keys()
		local var_2_2 = LevelSettings[var_2_1]
		local var_2_3 = var_2_2 and var_2_2.mission_givers

		if var_2_3 then
			table.append(var_2_0, var_2_3)
		end

		local var_2_4 = Managers.state.game_mode:settings().mission_givers

		if var_2_4 then
			table.append(var_2_0, var_2_4)
		end

		for iter_2_0 = 1, #var_2_0 do
			local var_2_5 = var_2_0[iter_2_0]
			local var_2_6 = var_2_5.dialogue_profile
			local var_2_7 = var_2_5.faction
			local var_2_8 = var_2_5.side_name

			arg_2_0:request_global_listener(var_2_6, var_2_7, var_2_8)
		end
	end
end

SurroundingAwareSystem.request_global_listener = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = Managers.state.side:get_side_from_name(arg_3_3)

	for iter_3_0, iter_3_1 in pairs(arg_3_0.global_observers) do
		if iter_3_1.dialogue_profile == arg_3_1 then
			local var_3_1 = ScriptUnit.extension(iter_3_0, "dialogue_system")

			fassert(not arg_3_2 or arg_3_2 == var_3_1.faction, "[SurroundingAwareSystem] Mismatching faction when requesting duplicate global listener '%s'. Wanted '%s' while existing listener has '%s'", arg_3_1, arg_3_2, var_3_1.faction)

			local var_3_2 = arg_3_0.unit_extension_data[iter_3_0]

			fassert(not arg_3_3 or (var_3_0 and var_3_0.side_id) == var_3_2.side_id, "[SurroundingAwareSystem] Mismatching side name when requesting duplicate global listener '%s'. Wanted '%s' while existing listener has '%s'", arg_3_1, arg_3_3, var_3_0 and var_3_0:name() or nil)

			return iter_3_0
		end
	end

	local var_3_3 = {
		dialogue_system = {
			dialogue_profile = arg_3_1,
			faction = arg_3_2
		},
		surrounding_aware_system = {
			side_id = var_3_0 and var_3_0.side_id
		}
	}

	return Managers.state.unit_spawner:spawn_network_unit("units/hub_elements/empty", "dialogue_node", var_3_3)
end

SurroundingAwareSystem.query_global_listener = function (arg_4_0, arg_4_1)
	for iter_4_0, iter_4_1 in pairs(arg_4_0.global_observers) do
		if iter_4_1.dialogue_profile == arg_4_1 then
			return iter_4_0
		end
	end

	return nil
end

SurroundingAwareSystem.destroy = function (arg_5_0)
	for iter_5_0, iter_5_1 in pairs(arg_5_0.unit_extension_data) do
		Broadphase.remove(arg_5_0.broadphase, iter_5_1.broadphase_id)
	end

	arg_5_0.network_event_delegate:unregister(arg_5_0)
	table.clear(arg_5_0)
end

SurroundingAwareSystem.add_event = function (arg_6_0, arg_6_1, arg_6_2, ...)
	arg_6_2 = arg_6_2 or DialogueSettings.default_hear_distance

	local var_6_0 = ScriptUnit.extension_input(arg_6_0, "surrounding_aware_system").event_array
	local var_6_1 = select("#", ...)
	local var_6_2, var_6_3 = pdArray.data(var_6_0)

	fassert(type(arg_6_1) == "string", "First argument to add_event must be an event-name.")
	fassert(type(arg_6_2) == "number", "Second argument to add_event must be distance.")
	fassert(var_6_1 % 2 == 0, "Arguments must be set by key, value-pairs. Thus num args must be an even number.")
	pack_index[var_6_1 + 4](var_6_2, var_6_3 + 1, var_6_1, arg_6_0, arg_6_1, arg_6_2, ...)

	local var_6_4 = var_6_3 + var_6_1 + 4

	pdArray.set_size(var_6_0, var_6_4)
end

SurroundingAwareSystem.add_system_event = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, ...)
	arg_7_3 = arg_7_3 or DialogueSettings.default_hear_distance

	local var_7_0 = arg_7_0.event_array
	local var_7_1 = select("#", ...)
	local var_7_2, var_7_3 = pdArray.data(var_7_0)

	fassert(type(arg_7_2) == "string", "First argument to add_event must be an event-name.")
	fassert(type(arg_7_3) == "number", "Second argument to add_event must be distance.")
	fassert(var_7_1 % 2 == 0, "Arguments must be set by key, value-pairs. Thus num args must be an even number.")
	pack_index[var_7_1 + 4](var_7_2, var_7_3 + 1, var_7_1, arg_7_1, arg_7_2, arg_7_3, ...)

	local var_7_4 = var_7_3 + var_7_1 + 4

	pdArray.set_size(var_7_0, var_7_4)
end

local var_0_3 = {}

SurroundingAwareSystem.on_add_extension = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = {
		input = MakeTableStrict({
			event_array = arg_8_0.event_array
		})
	}

	ScriptUnit.set_extension(arg_8_2, "surrounding_aware_system", var_8_0, var_0_3)

	arg_8_0.unit_input_data[arg_8_2] = var_8_0.input
	arg_8_0.unit_extension_data[arg_8_2] = var_8_0
	var_8_0.broadphase_id = Broadphase.add(arg_8_0.broadphase, arg_8_2, Unit.world_position(arg_8_2, 0), 0.5)

	if arg_8_3 == "SurroundingObserverExtension" or arg_8_3 == "SurroundingObserverHuskExtension" then
		var_8_0.view_angle = 11.25
		var_8_0.view_angle_rad = math.degrees_to_radians(var_8_0.view_angle)
		var_8_0.last_lookat_trigger = 0
		var_8_0.view_distance = DialogueSettings.observer_view_distance
		var_8_0.view_distance_sq = var_8_0.view_distance^2
		arg_8_0.observers[arg_8_2] = var_8_0
	elseif arg_8_3 == "GlobalObserverExtension" then
		arg_8_0.global_observers[arg_8_2] = var_8_0
	else
		var_8_0.has_been_seen = false
		var_8_0.is_lookat_object = true
		var_8_0.view_distance = Unit.get_data(arg_8_2, "view_distance") or DialogueSettings.default_view_distance
		var_8_0.view_distance_sq = var_8_0.view_distance^2
	end

	if arg_8_4.side_id then
		var_8_0.side_id = arg_8_4.side_id

		Managers.state.side:add_unit_to_side(arg_8_2, arg_8_4.side_id)
	end

	return var_8_0
end

SurroundingAwareSystem.get_global_observer_unit = function (arg_9_0, arg_9_1)
	return arg_9_0._global_observer_by_profile[arg_9_1]
end

SurroundingAwareSystem.get_global_observers = function (arg_10_0)
	return arg_10_0.global_observers
end

SurroundingAwareSystem.extensions_ready = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = ScriptUnit.extension(arg_11_2, "surrounding_aware_system")

	if arg_11_3 == "SurroundingObserverExtension" or arg_11_3 == "SurroundingObserverHuskExtension" then
		-- Nothing
	elseif arg_11_3 == "GlobalObserverExtension" then
		local var_11_1 = ScriptUnit.has_extension(arg_11_2, "dialogue_system")

		if var_11_1 then
			var_11_0.dialogue_profile = var_11_1.dialogue_profile or Unit.get_data(arg_11_2, "dialogue_profile")

			assert(var_11_0.dialogue_profile, "[SurroundingAwareSystem] Global Observer is missing a dialogue profile", arg_11_2)

			arg_11_0._global_observer_by_profile[var_11_0.dialogue_profile] = arg_11_2
		end
	elseif ScriptUnit.has_extension(arg_11_2, "pickup_system") then
		var_11_0.collision_filter = "filter_lookat_pickup_object_ray"
	end
end

SurroundingAwareSystem.on_remove_extension = function (arg_12_0, arg_12_1, arg_12_2)
	Broadphase.remove(arg_12_0.broadphase, arg_12_0.unit_extension_data[arg_12_1].broadphase_id)

	local var_12_0 = arg_12_0.unit_extension_data[arg_12_1]

	arg_12_0.unit_input_data[arg_12_1] = nil
	arg_12_0.unit_extension_data[arg_12_1] = nil

	if arg_12_2 == "SurroundingObserverExtension" or arg_12_2 == "SurroundingObserverHuskExtension" then
		arg_12_0.observers[arg_12_1] = nil

		local var_12_1 = arg_12_0.seen_observers
		local var_12_2 = var_12_1[arg_12_1]
		local var_12_3 = var_12_2 and ScriptUnit.has_extension(var_12_2, "ai_system")

		if var_12_3 then
			var_12_3:set_seen_by_player(false, arg_12_1)
		end

		var_12_1[arg_12_1] = nil

		for iter_12_0, iter_12_1 in pairs(var_12_1) do
			if iter_12_1 == arg_12_1 then
				var_12_1[iter_12_0] = nil
			end
		end
	elseif arg_12_2 == "GlobalObserverExtension" then
		arg_12_0.global_observers[arg_12_1] = nil
		arg_12_0._global_observer_by_profile[var_12_0.dialogue_profile] = nil
	end

	ScriptUnit.remove_extension(arg_12_1, "surrounding_aware_system")
end

SurroundingAwareSystem.update = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:update_seen_recently(arg_13_1, arg_13_2)
	arg_13_0:update_lookat(arg_13_1, arg_13_2)
	arg_13_0:update_events(arg_13_1, arg_13_2)
end

local function var_0_4(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	if Vector3.length(arg_14_4) == 0 then
		return true
	end

	local var_14_0 = PhysicsWorld.immediate_raycast(arg_14_0, arg_14_3, arg_14_4, arg_14_5, "all", "types", "both", "collision_filter", arg_14_6 or "filter_lookat_object_ray")

	if var_14_0 then
		local var_14_1 = #var_14_0

		for iter_14_0 = 1, var_14_1 do
			local var_14_2 = var_14_0[iter_14_0]
			local var_14_3 = Actor.unit(var_14_2[4])

			if var_14_3 ~= arg_14_1 and var_14_3 ~= arg_14_2 then
				return false
			end
		end
	end

	return true
end

local function var_0_5(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_1 - arg_15_0
	local var_15_1 = Vector3.normalize(var_15_0)
	local var_15_2 = math.max(0.1, Vector3.length_squared(var_15_0))

	if arg_15_3 < var_15_2 then
		return false, var_15_0, var_15_1, nil, nil
	end

	local var_15_3 = arg_15_3 / (2 * var_15_2)
	local var_15_4 = Vector3.dot(arg_15_2, var_15_1)
	local var_15_5 = math.acos(var_15_4)
	local var_15_6 = arg_15_4 * var_15_3

	if var_15_6 <= var_15_5 then
		return false, var_15_0, var_15_1, var_15_5, var_15_6
	end

	return true, var_15_0, var_15_1, var_15_5, var_15_6
end

local var_0_6 = 10
local var_0_7 = -1
local var_0_8 = 1.5
local var_0_9 = {}

SurroundingAwareSystem.update_lookat = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.observers

	if var_16_0[arg_16_0.current_observer_unit] == nil then
		arg_16_0.current_observer_unit = nil
	end

	arg_16_0.current_observer_unit = next(var_16_0, arg_16_0.current_observer_unit)

	local var_16_1 = arg_16_0.game
	local var_16_2 = arg_16_0.current_observer_unit

	if var_16_1 == nil or var_16_2 == nil then
		return
	end

	local var_16_3 = POSITION_LOOKUP
	local var_16_4 = Broadphase
	local var_16_5 = arg_16_0.broadphase
	local var_16_6 = var_16_0[var_16_2]
	local var_16_7 = var_16_3[var_16_2]

	if not var_16_7 then
		return
	end

	var_16_4.move(var_16_5, var_16_6.broadphase_id, var_16_7)

	if arg_16_2 - var_16_6.last_lookat_trigger <= DialogueSettings.view_event_trigger_interval then
		return
	end

	local var_16_8 = Unit
	local var_16_9 = Vector3
	local var_16_10 = math
	local var_16_11 = Matrix4x4
	local var_16_12 = arg_16_0.seen_recently
	local var_16_13 = arg_16_0.physics_world
	local var_16_14 = Managers.state.entity:system("darkness_system")
	local var_16_15 = arg_16_0.is_server
	local var_16_16 = arg_16_0.seen_observers
	local var_16_17 = arg_16_0.unit_storage:go_id(var_16_2)
	local var_16_18 = GameSession.game_object_field(var_16_1, var_16_17, "aim_position")
	local var_16_19 = GameSession.game_object_field(var_16_1, var_16_17, "aim_direction")
	local var_16_20 = ScriptUnit.extension_input(var_16_2, "dialogue_system")
	local var_16_21 = DialogueSettings.max_view_distance * 0.5
	local var_16_22 = var_16_18 + var_16_19 * var_16_21
	local var_16_23 = var_16_4.query(var_16_5, var_16_22, var_16_21, var_0_9)
	local var_16_24 = var_16_16[var_16_2]
	local var_16_25 = var_16_10.huge
	local var_16_26

	for iter_16_0 = 1, var_16_23 do
		local var_16_27 = var_0_9[iter_16_0]

		var_0_9[iter_16_0] = nil

		local var_16_28 = var_16_12[var_16_27]

		if var_16_27 ~= var_16_2 and not var_16_28 then
			local var_16_29 = ScriptUnit.extension(var_16_27, "surrounding_aware_system")
			local var_16_30 = var_16_29.is_lookat_object

			if var_16_30 or var_16_15 and var_16_0[var_16_27] then
				local var_16_31

				if var_16_8.has_node(var_16_27, "j_spine") then
					local var_16_32 = var_16_8.node(var_16_27, "j_spine")

					var_16_31 = var_16_8.world_position(var_16_27, var_16_32)
				else
					local var_16_33 = var_16_8.box(var_16_27)

					var_16_31 = var_16_11.translation(var_16_33)
				end

				local var_16_34 = var_16_29.view_distance_sq
				local var_16_35 = var_16_6.view_angle_rad * (var_16_27 == var_16_24 and var_0_8 or 1)
				local var_16_36, var_16_37, var_16_38, var_16_39, var_16_40 = var_0_5(var_16_18, var_16_31, var_16_19, var_16_34, var_16_35)

				if var_16_36 and not var_16_14:is_in_darkness(var_16_31) then
					local var_16_41 = var_16_9.length(var_16_37)
					local var_16_42 = var_16_29.collision_filter
					local var_16_43 = var_0_4(var_16_13, var_16_2, var_16_27, var_16_18, var_16_38, var_16_41, var_16_42)

					if var_16_30 and var_16_43 then
						var_16_29.has_been_seen = true
						var_16_6.last_lookat_trigger = arg_16_2

						local var_16_44 = FrameTable.alloc_table()

						var_16_44.item_tag = var_16_8.get_data(var_16_27, "lookat_tag") or var_16_8.debug_name(var_16_27)
						var_16_44.distance = var_16_41

						var_16_20:trigger_dialogue_event("seen_item", var_16_44)

						var_16_12[var_16_27] = arg_16_2
					elseif var_16_43 then
						local var_16_45 = var_16_39 * (var_0_6 + (var_16_27 == var_16_24 and var_0_7 or 0)) + var_16_41

						if var_16_45 < var_16_25 then
							var_16_26 = var_16_27
							var_16_25 = var_16_45
						end
					end
				end
			end
		end
	end

	if var_16_15 and var_16_26 ~= var_16_24 then
		local var_16_46 = not Managers.player:unit_owner(var_16_2).bot_player

		if var_16_24 then
			local var_16_47 = ScriptUnit.has_extension(var_16_24, "ai_system")

			if var_16_46 and var_16_47 then
				var_16_47:set_seen_by_player(false, var_16_2)
			end
		end

		if var_16_26 then
			local var_16_48 = ScriptUnit.has_extension(var_16_26, "ai_system")

			if var_16_46 and var_16_48 then
				var_16_48:set_seen_by_player(true, var_16_2, arg_16_2)
			end
		end

		var_16_16[var_16_2] = var_16_26
	end
end

SurroundingAwareSystem.update_debug = function (arg_17_0, arg_17_1, arg_17_2)
	if not script_data.dialogue_debug_lookat then
		return
	end

	local var_17_0 = arg_17_0.game
	local var_17_1 = Managers.player:local_player()

	if not var_17_1 or not var_17_1.player_unit or not var_17_0 then
		return
	end

	local var_17_2 = Color(255, 255, 0, 0)
	local var_17_3 = Color(255, 0, 255, 0)
	local var_17_4 = Color(255, 0, 255, 255)
	local var_17_5 = FrameTable.alloc_table()
	local var_17_6 = Managers.state.debug:drawer(debug_drawer_info)
	local var_17_7 = arg_17_0.broadphase
	local var_17_8 = arg_17_0.physics_world
	local var_17_9 = Managers.state.entity:system("darkness_system")
	local var_17_10 = var_17_1.player_unit
	local var_17_11 = arg_17_0.unit_extension_data[var_17_10]
	local var_17_12 = arg_17_0.observers
	local var_17_13 = arg_17_0.is_server
	local var_17_14 = arg_17_0.seen_observers
	local var_17_15 = var_17_14[var_17_10]
	local var_17_16 = arg_17_0.unit_storage:go_id(var_17_10)
	local var_17_17 = GameSession.game_object_field(var_17_0, var_17_16, "aim_position")
	local var_17_18 = GameSession.game_object_field(var_17_0, var_17_16, "aim_direction")
	local var_17_19 = DialogueSettings.max_view_distance * 0.5
	local var_17_20 = var_17_17 + var_17_18 * var_17_19
	local var_17_21 = Broadphase.query(var_17_7, var_17_20, var_17_19, var_0_9)

	var_17_6:sphere(var_17_20, var_17_19, Colors.get("light_blue"))
	var_17_6:vector(var_17_17, var_17_18)

	for iter_17_0 = 1, var_17_21 do
		local var_17_22 = var_0_9[iter_17_0]

		var_0_9[iter_17_0] = nil

		if var_17_22 ~= var_17_10 then
			local var_17_23 = Color(255, 0, 0, 255)
			local var_17_24 = string.format("SAS: %q | ", Unit.debug_name(var_17_22))
			local var_17_25 = ScriptUnit.extension(var_17_22, "surrounding_aware_system")
			local var_17_26 = var_17_25.is_lookat_object

			if var_17_25.is_lookat_object or var_17_13 and var_17_12[var_17_22] then
				local var_17_27

				if Unit.has_node(var_17_22, "j_spine") then
					local var_17_28 = Unit.node(var_17_22, "j_spine")

					var_17_27 = Unit.world_position(var_17_22, var_17_28)
				else
					local var_17_29 = Unit.box(var_17_22)

					var_17_27 = Matrix4x4.translation(var_17_29)
				end

				local var_17_30 = var_17_25.view_distance_sq
				local var_17_31 = var_17_11.view_angle_rad * (var_17_22 == var_17_15 and var_0_8 or 1)
				local var_17_32, var_17_33, var_17_34, var_17_35, var_17_36 = var_0_5(var_17_17, var_17_27, var_17_18, var_17_30, var_17_31)
				local var_17_37 = Vector3.length(var_17_33)

				var_17_24 = string.format(var_17_24 .. "DISTANCE: %.2f/%.2f", var_17_37, var_17_25.view_distance)

				if var_17_35 then
					var_17_24 = string.format(var_17_24 .. "| ANGLE: %.2f/%.2f", math.radians_to_degrees(var_17_35), math.radians_to_degrees(var_17_36))
				end

				if var_17_32 and not var_17_9:is_in_darkness(var_17_27) then
					local var_17_38 = Vector3.length(var_17_33)
					local var_17_39 = var_17_25.collision_filter

					if var_0_4(var_17_8, var_17_10, var_17_22, var_17_17, var_17_34, var_17_38, var_17_39) then
						var_17_23 = var_17_3
					else
						var_17_23 = var_17_4
					end
				else
					var_17_23 = var_17_2
				end

				var_17_5[var_17_22] = var_17_23

				var_17_6:vector(var_17_17, var_17_34, var_17_23)
			end

			Debug.text(var_17_24)
		end
	end

	for iter_17_1, iter_17_2 in pairs(arg_17_0.unit_extension_data) do
		if iter_17_1 ~= var_17_10 then
			local var_17_40 = var_17_5[iter_17_1] or var_17_2

			var_17_6:unit(iter_17_1, var_17_40)
		end
	end

	if var_17_13 then
		local var_17_41 = var_17_14[var_17_10]

		if var_17_41 then
			local var_17_42 = Unit.node(var_17_41, "j_spine")
			local var_17_43 = Unit.world_position(var_17_41, var_17_42)
			local var_17_44 = ScriptUnit.has_extension(var_17_41, "ai_system")

			var_17_6:sphere(var_17_43, 0.25, var_17_44 and Colors.get("blue") or Colors.get("light_blue"))
		end
	end
end

local var_0_10 = {
	heard_speak = "heard_speak_self"
}

SurroundingAwareSystem.update_events = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.unit_input_data
	local var_18_1 = arg_18_0.broadphase
	local var_18_2 = arg_18_0.event_array
	local var_18_3, var_18_4 = pdArray.data(var_18_2)
	local var_18_5 = 1

	while var_18_5 <= var_18_4 do
		local var_18_6 = var_18_3[var_18_5]
		local var_18_7 = var_18_3[var_18_5 + 1]
		local var_18_8 = var_18_3[var_18_5 + 2]
		local var_18_9 = var_18_3[var_18_5 + 3]

		if Unit.alive(var_18_7) then
			local var_18_10 = POSITION_LOOKUP[var_18_7] or Unit.local_position(var_18_7, 0)
			local var_18_11 = 0

			if var_18_9 == math.huge then
				local var_18_12 = 0

				for iter_18_0, iter_18_1 in pairs(arg_18_0.observers) do
					var_18_12 = var_18_12 + 1
					var_0_9[var_18_12] = iter_18_0
				end

				var_18_11 = var_18_12
			else
				var_18_11 = Broadphase.query(var_18_1, var_18_10, var_18_9, var_0_9)
			end

			for iter_18_2 = 1, var_18_11 do
				local var_18_13 = var_0_9[iter_18_2]

				var_0_9[iter_18_2] = nil

				local var_18_14 = var_18_13 == var_18_7

				if ScriptUnit.has_extension(var_18_13, "dialogue_system") and (not var_18_14 or var_0_10[var_18_8]) then
					local var_18_15 = ScriptUnit.extension_input(var_18_13, "dialogue_system")
					local var_18_16 = FrameTable.alloc_table()
					local var_18_17 = 0

					if var_18_7 then
						local var_18_18 = POSITION_LOOKUP[var_18_13] or Unit.local_position(var_18_13, 0)

						var_18_17 = Vector3.distance(var_18_10, var_18_18)
					end

					var_18_16.distance = var_18_17

					for iter_18_3 = 1, var_18_6 / 2 do
						local var_18_19 = var_18_5 + 3 + (iter_18_3 - 1) * 2 + 1

						var_18_16[var_18_3[var_18_19]] = var_18_3[var_18_19 + 1]
					end

					var_0_9[var_18_13] = true

					if var_18_14 then
						var_18_15:trigger_dialogue_event(var_0_10[var_18_8], var_18_16)
					else
						var_18_15:trigger_dialogue_event(var_18_8, var_18_16)
					end
				end
			end

			if var_0_2[var_18_8] then
				local var_18_20 = FrameTable.alloc_table()

				for iter_18_4 = 1, var_18_6 / 2 do
					local var_18_21 = var_18_5 + 3 + (iter_18_4 - 1) * 2 + 1

					var_18_20[var_18_3[var_18_21]] = var_18_3[var_18_21 + 1]
				end

				for iter_18_5, iter_18_6 in pairs(arg_18_0.global_observers) do
					if not var_0_9[iter_18_5] then
						local var_18_22 = ScriptUnit.extension(iter_18_5, "dialogue_system").input

						if not (var_18_7 == iter_18_5) then
							var_18_22:trigger_dialogue_event(var_18_8, var_18_20)
						elseif var_0_10[var_18_8] then
							var_18_22:trigger_dialogue_event(var_0_10[var_18_8], var_18_20)
						end
					end
				end
			end

			table.clear(var_0_9)
		end

		var_18_5 = var_18_5 + 4 + var_18_6
	end

	pdArray.set_empty(var_18_2)
end

SurroundingAwareSystem.update_seen_recently = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.seen_recently
	local var_19_1 = arg_19_2 - DialogueSettings.seen_recently_threshold

	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		if iter_19_1 < var_19_1 then
			var_19_0[iter_19_0] = nil
		end
	end
end

SurroundingAwareSystem.hot_join_sync = function (arg_20_0, arg_20_1)
	return
end
