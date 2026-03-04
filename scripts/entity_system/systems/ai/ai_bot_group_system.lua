-- chunkname: @scripts/entity_system/systems/ai/ai_bot_group_system.lua

require("scripts/settings/player_bots_settings")

AIBotGroupSystem = class(AIBotGroupSystem, ExtensionSystemBase)

local var_0_0 = {
	"AIBotGroupExtension",
	"BotBreakableExtension"
}
local var_0_1 = 1
local var_0_2 = 2
local var_0_3 = 3
local var_0_4 = 4
local var_0_5 = 5
local var_0_6 = 6
local var_0_7 = 1.25
local var_0_8 = 1.8

AIBotGroupExtension = class(AIBotGroupExtension)

function AIBotGroupExtension.init(arg_1_0)
	return
end

function AIBotGroupExtension.destroy(arg_2_0)
	return
end

local var_0_9 = 0.05

function AIBotGroupExtension.set_hold_position(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.data

	if arg_3_1 then
		var_3_0.hold_position_max_distance_sq, var_3_0.hold_position = math.max(arg_3_2, var_0_9)^2, Vector3Box(arg_3_1)
	else
		var_3_0.hold_position = nil
		var_3_0.hold_position_max_distance_sq = nil
	end
end

function AIBotGroupExtension.get_hold_position(arg_4_0)
	local var_4_0 = arg_4_0.data

	if var_4_0.hold_position then
		local var_4_1 = var_4_0.hold_position:unbox()
		local var_4_2 = var_4_0.hold_position_max_distance_sq

		return var_4_1, var_4_2
	else
		return nil, nil
	end
end

local var_0_10 = -0.2
local var_0_11 = BLACKBOARDS

function AIBotGroupSystem.init(arg_5_0, arg_5_1, arg_5_2)
	arg_5_1.entity_manager:register_system(arg_5_0, arg_5_2, var_0_0)

	local var_5_0 = arg_5_1.world

	arg_5_0._is_server = arg_5_1.is_server
	arg_5_0._world = var_5_0
	arg_5_0._physics_world = World.physics_world(var_5_0)
	arg_5_0._unit_storage = arg_5_1.unit_storage
	arg_5_0._network_transmit = arg_5_1.network_transmit
	arg_5_0._total_num_bots = 0
	arg_5_0._bot_breakables_broadphase = Broadphase(2, 60)

	if arg_5_0._is_server then
		local var_5_1 = #Managers.state.side:sides()

		arg_5_0._last_move_target_unit = Script.new_array(var_5_1)
		arg_5_0._last_move_target_rotations = {}
		arg_5_0._bot_threat_queue = {}

		local var_5_2 = {}

		for iter_5_0, iter_5_1 in pairs(AllPickups) do
			if iter_5_1.bots_mule_pickup then
				local var_5_3 = iter_5_1.slot_name

				var_5_2[var_5_3] = var_5_2[var_5_3] or {}
			end
		end

		arg_5_0._bot_ai_data = Script.new_array(var_5_1)
		arg_5_0._bot_ai_data_lookup = {}
		arg_5_0._old_priority_targets = Script.new_array(var_5_1)
		arg_5_0._available_mule_pickups = Script.new_array(var_5_1)
		arg_5_0._available_health_pickups = Script.new_array(var_5_1)
		arg_5_0._num_bots = Script.new_array(var_5_1)

		for iter_5_2 = 1, var_5_1 do
			arg_5_0._bot_ai_data[iter_5_2] = {}
			arg_5_0._old_priority_targets[iter_5_2] = {}
			arg_5_0._available_mule_pickups[iter_5_2] = table.clone(var_5_2)
			arg_5_0._available_health_pickups[iter_5_2] = {}
			arg_5_0._num_bots[iter_5_2] = 0
		end

		arg_5_0._existing_bot_threats = {}
		arg_5_0._urgent_targets = {}
		arg_5_0._ally_needs_aid_priority = {}
		arg_5_0._timestamped_positions = {}
		arg_5_0._disallowed_tag_layers = {
			bot_poison_wind = true,
			barrel_explosion = true
		}
		arg_5_0._t = 0
		arg_5_0._in_carry_event = Script.new_array(var_5_1)

		local var_5_4 = Vector3.up()

		arg_5_0._left_vectors_outside_volume = {
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 1 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 4 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 7 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 0 / 8)))
		}
		arg_5_0._right_vectors_outside_volume = {
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 1 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 4 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 7 / 8)))
		}
		arg_5_0._left_vectors = {
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 0.5))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 7 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, math.pi * 1 / 8)))
		}
		arg_5_0._right_vectors = {
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 0.5))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 7 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(var_5_4, -math.pi * 1 / 8)))
		}
		arg_5_0._last_key_in_available_pickups = nil
		arg_5_0._update_pickups_at = -math.huge
		arg_5_0._used_covers = {}
		arg_5_0._pathing_points = {}

		local var_5_5 = {
			"rpc_bot_create_threat_oobb"
		}

		for iter_5_3, iter_5_4 in pairs(AIBotGroupSystem.bot_orders) do
			var_5_5[#var_5_5 + 1] = iter_5_4.rpc_type
		end

		local var_5_6 = arg_5_1.network_event_delegate

		arg_5_0.network_event_delegate = var_5_6

		var_5_6:register(arg_5_0, unpack(var_5_5))
	end
end

function AIBotGroupSystem.destroy(arg_6_0)
	if arg_6_0._is_server then
		arg_6_0.network_event_delegate:unregister(arg_6_0)
	end
end

function AIBotGroupSystem.on_add_extension(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_3 == "BotBreakableExtension" then
		local var_7_0 = "rp_center"
		local var_7_1 = Unit.has_node(arg_7_2, var_7_0) and Unit.node(arg_7_2, var_7_0) or 0
		local var_7_2 = Unit.world_position(arg_7_2, var_7_1)

		Broadphase.add(arg_7_0._bot_breakables_broadphase, arg_7_2, var_7_2, 1)
		ScriptUnit.add_extension(nil, arg_7_2, "AIBotGroupExtension", arg_7_0.NAME)

		return {}
	else
		local var_7_3 = arg_7_4.initial_inventory
		local var_7_4 = arg_7_4.side
		local var_7_5 = {
			priority_target_distance = math.huge,
			priority_targets = {},
			nav_point_utility = {},
			blackboard = var_0_11[arg_7_2],
			aoe_threat = {
				expires = -math.huge,
				escape_to = Vector3Box()
			},
			previous_bot_breakables = {},
			current_bot_breakables = {},
			pickup_orders = {},
			side = var_7_4
		}
		local var_7_6 = "slot_potion"
		local var_7_7 = var_7_3[var_7_6]
		local var_7_8 = rawget(ItemMasterList, var_7_7)

		if var_7_8 then
			local var_7_9 = var_7_8.template or var_7_8.temporary_template

			if WeaponUtils.get_weapon_template(var_7_9).is_grimoire then
				local var_7_10 = "grimoire"

				var_7_5.pickup_orders[var_7_6] = {
					pickup_name = var_7_10
				}
			end
		end

		local var_7_11 = var_7_4.side_id

		arg_7_0._bot_ai_data_lookup[arg_7_2] = var_7_5
		arg_7_0._bot_ai_data[var_7_11][arg_7_2] = var_7_5

		local var_7_12 = ScriptUnit.add_extension(nil, arg_7_2, "AIBotGroupExtension", arg_7_0.NAME)

		var_7_12.data = var_7_5
		arg_7_0._num_bots[var_7_11] = arg_7_0._num_bots[var_7_11] + 1
		arg_7_0._total_num_bots = arg_7_0._total_num_bots + 1

		return var_7_12
	end
end

local function var_0_12(arg_8_0, arg_8_1, arg_8_2)
	for iter_8_0 = 1, #arg_8_0 do
		local var_8_0 = arg_8_0[iter_8_0]
		local var_8_1 = var_8_0.pos:unbox()
		local var_8_2 = var_8_0.rot and var_8_0.rot:unbox()
		local var_8_3 = var_8_0.shape
		local var_8_4
		local var_8_5

		if var_8_3 == "sphere" then
			var_8_4 = var_8_0.size
			var_8_5 = var_8_4 + arg_8_2
		elseif var_8_3 == "cylinder" then
			var_8_4 = var_8_0.size:unbox()
			var_8_5 = Vector3(math.max(var_8_4[1] - arg_8_2, 0), var_8_4[2] + arg_8_2, var_8_4[3] + arg_8_2)
		else
			var_8_4 = var_8_0.size:unbox()
			var_8_5 = var_8_4 + Vector3(arg_8_2, arg_8_2, arg_8_2)
		end

		local var_8_6

		if var_8_3 == "oobb" then
			local var_8_7 = Matrix4x4.from_quaternion_position(var_8_2, var_8_1)

			var_8_6 = math.point_is_inside_oobb(arg_8_1, var_8_7, var_8_5)
		elseif var_8_3 == "cylinder" then
			var_8_6 = math.point_is_inside_cylinder(arg_8_1, var_8_1, var_8_4[1], var_8_4[2], var_8_4[3])
		elseif var_8_3 == "sphere" then
			var_8_6 = Vector3.distance_squared(arg_8_1, var_8_1) < var_8_4^2
		end

		if var_8_6 then
			return true
		end
	end

	return false
end

function AIBotGroupSystem.is_inside_aoe_threat(arg_9_0, arg_9_1)
	return var_0_12(arg_9_0._existing_bot_threats, arg_9_1, var_0_7)
end

function AIBotGroupSystem.extensions_ready(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_3 ~= "BotBreakableExtension" then
		arg_10_0._bot_ai_data_lookup[arg_10_2].status_extension = ScriptUnit.extension(arg_10_2, "status_system")
	end
end

function AIBotGroupSystem.on_remove_extension(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 == "AIBotGroupExtension" then
		local var_11_0 = arg_11_0._bot_ai_data_lookup[arg_11_1].side.side_id

		arg_11_0._bot_ai_data_lookup[arg_11_1] = nil
		arg_11_0._bot_ai_data[var_11_0][arg_11_1] = nil
		arg_11_0._num_bots[var_11_0] = arg_11_0._num_bots[var_11_0] - 1
		arg_11_0._total_num_bots = arg_11_0._total_num_bots - 1
	end

	ScriptUnit.remove_extension(arg_11_1, arg_11_0.NAME)
end

function AIBotGroupSystem.hot_join_sync(arg_12_0, arg_12_1, arg_12_2)
	return
end

function AIBotGroupSystem.set_in_carry_event(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_2.side_id

	arg_13_0._in_carry_event[var_13_0] = arg_13_1
end

function AIBotGroupSystem.update(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0._is_server or arg_14_0._total_num_bots == 0 then
		return
	end

	arg_14_0._t = arg_14_2

	local var_14_0 = arg_14_1.dt
	local var_14_1 = arg_14_0._existing_bot_threats

	for iter_14_0 = #var_14_1, 1, -1 do
		if arg_14_2 > var_14_1[iter_14_0].expires then
			arg_14_0:remove_threat(var_14_1[iter_14_0])
		end
	end

	local var_14_2 = arg_14_0._bot_threat_queue

	for iter_14_1 = 1, #var_14_2 do
		local var_14_3 = var_14_2[iter_14_1]
		local var_14_4 = var_14_3[var_0_1]:unbox()
		local var_14_5 = var_14_3[var_0_2]
		local var_14_6 = var_14_3[var_0_3]:unbox()
		local var_14_7 = var_14_3[var_0_4]:unbox()
		local var_14_8 = var_14_3[var_0_5]
		local var_14_9 = var_14_3[var_0_6]

		arg_14_0:aoe_threat_created(var_14_4, var_14_5, var_14_6, var_14_7, var_14_8, var_14_9)

		var_14_2[iter_14_1] = nil
	end

	arg_14_0:_update_proximity_bot_breakables(arg_14_2)
	arg_14_0:_update_urgent_targets(var_14_0, arg_14_2)
	arg_14_0:_update_opportunity_targets(var_14_0, arg_14_2)
	arg_14_0:_update_existence_checks(var_14_0, arg_14_2)
	arg_14_0:_update_move_targets(var_14_0, arg_14_2)
	arg_14_0:_update_priority_targets(var_14_0, arg_14_2)
	arg_14_0:_update_pickups(var_14_0, arg_14_2)
	arg_14_0:_update_ally_needs_aid_priority()
end

AIBotGroupSystem.bot_orders = {
	pickup = {
		rpc_type = "rpc_bot_unit_order",
		function_name = "_order_pickup"
	},
	drop = {
		rpc_type = "rpc_bot_lookup_order",
		lookup = "pickup_names",
		function_name = "_order_drop"
	}
}

function AIBotGroupSystem.order(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = AIBotGroupSystem.bot_orders[arg_15_1]

	if arg_15_0._is_server then
		arg_15_0[var_15_0.function_name](arg_15_0, arg_15_2, arg_15_3, arg_15_4)
	else
		local var_15_1 = var_15_0.rpc_type
		local var_15_2

		if var_15_1 == "rpc_bot_unit_order" then
			var_15_2 = arg_15_0._unit_storage:go_id(arg_15_3)
		elseif var_15_1 == "rpc_bot_lookup_order" then
			var_15_2 = NetworkLookup[var_15_0.lookup][arg_15_3]
		else
			ferror("Incorrect rpc_type %q.", var_15_1)
		end

		if Managers.state.network:game() then
			local var_15_3 = NetworkLookup.bot_orders[arg_15_1]
			local var_15_4 = arg_15_0._unit_storage:go_id(arg_15_2)

			arg_15_0._network_transmit:send_rpc_server(var_15_1, var_15_3, var_15_4, var_15_2, arg_15_4:network_id(), arg_15_4:local_player_id())
		end
	end
end

function AIBotGroupSystem.get_pickup_order(arg_16_0, arg_16_1, arg_16_2)
	return arg_16_0._bot_ai_data_lookup[arg_16_1].pickup_orders[arg_16_2]
end

function AIBotGroupSystem.get_ammo_pickup_order_unit(arg_17_0, arg_17_1)
	return arg_17_0._bot_ai_data_lookup[arg_17_1].ammo_pickup_order_unit
end

function AIBotGroupSystem.has_pending_pickup_order(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._bot_ai_data_lookup[arg_18_1].pickup_orders

	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		if iter_18_1.unit then
			return true
		end
	end

	return false
end

function AIBotGroupSystem.rpc_bot_unit_order(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	local var_19_0 = NetworkLookup.bot_orders[arg_19_2]
	local var_19_1 = arg_19_0._unit_storage:unit(arg_19_3)
	local var_19_2 = arg_19_0._unit_storage:unit(arg_19_4)
	local var_19_3 = Managers.player:player(arg_19_5, arg_19_6)

	if Unit.alive(var_19_1) and Unit.alive(var_19_2) and var_19_3 then
		arg_19_0:order(var_19_0, var_19_1, var_19_2, var_19_3)
	end
end

function AIBotGroupSystem.rpc_bot_lookup_order(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	local var_20_0 = NetworkLookup.bot_orders[arg_20_2]
	local var_20_1 = arg_20_0._unit_storage:unit(arg_20_3)
	local var_20_2 = NetworkLookup[AIBotGroupSystem.bot_orders[var_20_0].lookup][arg_20_4]
	local var_20_3 = Managers.player:player(arg_20_5, arg_20_6)

	if Unit.alive(var_20_1) and var_20_3 then
		arg_20_0:order(var_20_0, var_20_1, var_20_2, var_20_3)
	end
end

function AIBotGroupSystem.queue_aoe_threat(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	if arg_21_1 and arg_21_2 and arg_21_3 and arg_21_4 and arg_21_5 then
		local var_21_0 = arg_21_0._bot_threat_queue
		local var_21_1 = {
			Vector3Box(arg_21_1),
			arg_21_2,
			Vector3Box(arg_21_3),
			QuaternionBox(arg_21_4),
			arg_21_5,
			arg_21_6
		}

		var_21_0[#var_21_0 + 1] = var_21_1
	end
end

function AIBotGroupSystem.rpc_bot_create_threat_oobb(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	arg_22_0:queue_aoe_threat(arg_22_2, "oobb", arg_22_4, arg_22_3, arg_22_5, "RPC")
end

function AIBotGroupSystem._order_ammo_pickup(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0._bot_ai_data_lookup[arg_23_1]

	if var_23_0 then
		local var_23_1 = var_23_0.blackboard

		if var_23_1.inventory_extension:has_full_ammo() then
			arg_23_0:_chat_message(arg_23_1, arg_23_3, "has_full_ammo")
		else
			local var_23_2 = Managers.time:time("game")

			var_23_1.ammo_pickup = arg_23_2
			var_23_1.ammo_dist = Vector3.distance(POSITION_LOOKUP[arg_23_1], POSITION_LOOKUP[arg_23_2])
			var_23_1.ammo_pickup_valid_until = var_23_2 + 5
			var_23_1.needs_target_position_refresh = true
			var_23_0.ammo_pickup_order_unit = arg_23_2

			arg_23_0:_chat_message(arg_23_1, arg_23_3, "acknowledge_ammo")
		end
	else
		local var_23_3 = Managers.party:get_party_from_player_id(arg_23_3:network_id(), arg_23_3:local_player_id())
		local var_23_4 = Managers.state.side.side_by_party[var_23_3].side_id
		local var_23_5 = arg_23_0._bot_ai_data[var_23_4]

		for iter_23_0, iter_23_1 in pairs(var_23_5) do
			if iter_23_1.ammo_pickup_order_unit == arg_23_2 then
				local var_23_6 = iter_23_1.blackboard

				arg_23_0:_chat_message(iter_23_0, arg_23_3, "abort_pickup_assigned_to_other")

				iter_23_1.ammo_pickup_order_unit = nil
				var_23_6.ammo_pickup = nil
				var_23_6.needs_target_position_refresh = true
			end
		end
	end
end

function AIBotGroupSystem._order_pickup(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if arg_24_0._is_server then
		local var_24_0 = ScriptUnit.extension(arg_24_2, "pickup_system")
		local var_24_1 = var_24_0:get_pickup_settings()
		local var_24_2 = var_24_1.slot_name

		if var_24_1.type == "ammo" then
			arg_24_0:_order_ammo_pickup(arg_24_1, arg_24_2, arg_24_3)
		elseif var_24_2 then
			local var_24_3 = arg_24_0._bot_ai_data_lookup[arg_24_1]

			if var_24_3 then
				local var_24_4 = ScriptUnit.extension(arg_24_1, "inventory_system")
				local var_24_5 = var_24_4:get_slot_data(var_24_2)
				local var_24_6 = var_24_4:can_store_additional_item(var_24_2)

				if var_24_5 and not var_24_6 then
					local var_24_7 = var_24_4:get_item_template(var_24_5)
					local var_24_8

					if var_24_0.pickup_name == "grimoire" then
						var_24_8 = var_24_7.is_grimoire
					else
						var_24_8 = var_24_7.pickup_data and var_24_7.pickup_data.pickup_name == var_24_0.pickup_name
					end

					if var_24_8 then
						arg_24_0:_chat_message(arg_24_1, arg_24_3, "already_have_item", Unit.get_data(arg_24_2, "interaction_data", "hud_description"))

						return
					end
				end

				local var_24_9 = var_24_3.side.side_id
				local var_24_10 = arg_24_0._bot_ai_data[var_24_9]

				for iter_24_0, iter_24_1 in pairs(var_24_10) do
					local var_24_11 = iter_24_1.pickup_orders[var_24_2]

					if var_24_11 and var_24_11.unit == arg_24_2 then
						if iter_24_0 == arg_24_1 then
							arg_24_0:_chat_message(arg_24_1, arg_24_3, "already_picking_up")

							return
						end

						arg_24_0:_chat_message(iter_24_0, arg_24_3, "abort_pickup_assigned_to_other")

						iter_24_1.pickup_orders[var_24_2] = nil
						iter_24_1.blackboard.needs_target_position_refresh = true
					end
				end

				arg_24_0:_chat_message(arg_24_1, arg_24_3, "acknowledge_pickup", Unit.get_data(arg_24_2, "interaction_data", "hud_description"))

				var_24_3.pickup_orders[var_24_2] = {
					unit = arg_24_2,
					pickup_name = var_24_0.pickup_name
				}
				var_24_3.blackboard.needs_target_position_refresh = true
			else
				local var_24_12 = Managers.party:get_party_from_player_id(arg_24_3:network_id(), arg_24_3:local_player_id())
				local var_24_13 = Managers.state.side.side_by_party[var_24_12].side_id
				local var_24_14 = arg_24_0._bot_ai_data[var_24_13]

				for iter_24_2, iter_24_3 in pairs(var_24_14) do
					local var_24_15 = iter_24_3.pickup_orders[var_24_2]

					if var_24_15 and var_24_15.unit == arg_24_2 then
						arg_24_0:_chat_message(iter_24_2, arg_24_3, "abort_pickup_assigned_to_other")

						iter_24_3.pickup_orders[var_24_2] = nil
						iter_24_3.blackboard.needs_target_position_refresh = true
					end
				end
			end
		end
	end
end

function AIBotGroupSystem._order_drop(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_0._is_server then
		local var_25_0 = arg_25_0._bot_ai_data_lookup[arg_25_1]

		if var_25_0 then
			local var_25_1 = AllPickups[arg_25_2].slot_name
			local var_25_2 = var_25_0.pickup_orders[var_25_1]

			if var_25_2 and var_25_2.pickup_name == arg_25_2 then
				var_25_0.pickup_orders[var_25_1] = nil

				arg_25_0:_chat_message(arg_25_1, arg_25_3, "acknowledge_drop")
			end
		end
	end
end

local var_0_13 = {}
local var_0_14 = {}
local var_0_15 = {}
local var_0_16 = {}
local var_0_17 = {}
local var_0_18 = {}
local var_0_19 = 3

function AIBotGroupSystem._update_existence_checks(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = Managers.state.conflict
	local var_26_1 = var_26_0:count_units_by_breed("chaos_vortex_sorcerer") > 0
	local var_26_2 = var_26_0:count_units_by_breed("chaos_vortex") > 0
	local var_26_3 = arg_26_0._bot_ai_data

	for iter_26_0 = 1, #var_26_3 do
		local var_26_4 = var_26_3[iter_26_0]

		for iter_26_1, iter_26_2 in pairs(var_26_4) do
			local var_26_5 = iter_26_2.blackboard

			var_26_5.ai_extension:set_stay_near_player(var_26_1, var_0_19)

			var_26_5.vortex_exist = var_26_2
		end
	end
end

local var_0_20 = 1
local var_0_21 = 20

function AIBotGroupSystem._update_player_timestamped_positions(arg_27_0, arg_27_1, arg_27_2)
	for iter_27_0 = 1, #arg_27_2 do
		local var_27_0 = arg_27_2[iter_27_0]
		local var_27_1 = arg_27_0._timestamped_positions[var_27_0]
		local var_27_2 = POSITION_LOOKUP[var_27_0]

		if var_27_1 and var_27_2 then
			if Vector3.distance_squared(var_27_1.position:unbox(), var_27_2) > var_0_20^2 then
				var_27_1.position = Vector3Box(var_27_2)
				var_27_1.timestamp = arg_27_1
				var_27_1.afk = false
			elseif arg_27_1 > var_27_1.timestamp + var_0_21 then
				var_27_1.afk = true
			end

			arg_27_0._timestamped_positions[var_27_0] = var_27_1
		elseif var_27_2 then
			arg_27_0._timestamped_positions[var_27_0] = {
				afk = false,
				position = Vector3Box(var_27_2),
				timestamp = arg_27_1
			}
		end
	end
end

function AIBotGroupSystem._update_move_targets(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = Managers.state.side
	local var_28_1 = Managers.state.entity:system("ai_system"):nav_world()
	local var_28_2 = Managers.state.game_mode:game_mode().bot_follow_disabled
	local var_28_3 = arg_28_0._bot_ai_data
	local var_28_4 = arg_28_0._num_bots
	local var_28_5 = arg_28_0._in_carry_event
	local var_28_6 = arg_28_0._last_move_target_unit

	for iter_28_0 = 1, #var_28_3 do
		repeat
			local var_28_7 = var_28_0:get_side(iter_28_0)
			local var_28_8 = var_28_3[iter_28_0]
			local var_28_9 = var_28_7.PLAYER_UNITS

			for iter_28_1 = 1, #var_28_9 do
				local var_28_10 = var_28_9[iter_28_1]
				local var_28_11 = ScriptUnit.extension(var_28_10, "status_system")

				if not var_28_11.near_vortex then
					if not var_28_11:is_disabled() then
						var_0_15[#var_0_15 + 1] = var_28_10
					else
						var_0_16[#var_0_16 + 1] = var_28_10
					end
				end
			end

			local var_28_12 = #var_0_15
			local var_28_13 = #var_0_16

			if var_28_12 == 0 and var_28_13 > 0 then
				var_0_16, var_0_15 = var_0_15, var_0_16
				var_28_12 = var_28_13
			end

			arg_28_0:_update_player_timestamped_positions(arg_28_2, var_0_15)

			local var_28_14
			local var_28_15 = var_28_4[iter_28_0]
			local var_28_16 = var_28_5[iter_28_0]
			local var_28_17 = var_28_6[iter_28_0]

			if var_28_12 == 0 or var_28_15 == 0 then
				var_28_14 = nil
			elseif var_28_12 >= 3 then
				if var_28_16 then
					local var_28_18, var_28_19 = next(var_28_8)

					var_28_14 = arg_28_0:_find_most_lonely_move_target(var_0_15, var_28_18)
				else
					var_28_14 = arg_28_0:_find_least_lonely_move_target(var_0_15, var_28_17)
				end
			elseif var_28_12 == 2 and var_28_15 == 2 and var_28_16 then
				local var_28_20 = var_0_18

				for iter_28_2 = 1, var_28_12 do
					local var_28_21 = var_0_15[iter_28_2]
					local var_28_22 = POSITION_LOOKUP[var_28_21]
					local var_28_23, var_28_24 = arg_28_0:_selected_unit_is_in_disallowed_nav_tag_volume(var_28_1, var_28_22)
					local var_28_25

					if var_28_23 then
						local var_28_26 = arg_28_0:_find_origin(var_28_1, var_28_21)

						var_28_25 = arg_28_0:_find_destination_points_outside_volume(var_28_1, var_28_22, var_28_24, var_28_26, 1)
					else
						local var_28_27, var_28_28 = arg_28_0:_find_cluster_position(var_28_1, var_28_21)

						var_28_25 = arg_28_0:_find_destination_points(var_28_1, var_28_27, var_28_28, 1)
					end

					table.append(var_28_20, var_28_25)
				end

				arg_28_0:_assign_destination_points(var_28_8, var_28_20, nil, var_0_15)
				table.clear(var_0_15)
				table.clear(var_28_20)

				break
			else
				local var_28_29 = Vector3(0, 0, 0)

				for iter_28_3, iter_28_4 in pairs(var_28_8) do
					var_28_29 = var_28_29 + POSITION_LOOKUP[iter_28_3]
				end

				local var_28_30 = var_28_29 / var_28_15

				var_28_14 = arg_28_0:_find_closest_move_target(var_0_15, var_28_17, var_28_30)
			end

			if var_28_14 and not script_data.bots_dont_follow and not var_28_2 then
				arg_28_0._last_move_target_unit[iter_28_0] = var_28_14

				local var_28_31 = POSITION_LOOKUP[var_28_14]
				local var_28_32, var_28_33 = arg_28_0:_selected_unit_is_in_disallowed_nav_tag_volume(var_28_1, var_28_31)
				local var_28_34

				if var_28_32 then
					local var_28_35 = arg_28_0:_find_origin(var_28_1, var_28_14)

					var_28_34 = arg_28_0:_find_destination_points_outside_volume(var_28_1, var_28_31, var_28_33, var_28_35, var_28_15)
				else
					local var_28_36, var_28_37 = arg_28_0:_find_cluster_position(var_28_1, var_28_14)

					var_28_34 = arg_28_0:_find_destination_points(var_28_1, var_28_36, var_28_37, var_28_15)
				end

				arg_28_0:_assign_destination_points(var_28_8, var_28_34, var_28_14)
			else
				for iter_28_5, iter_28_6 in pairs(var_28_8) do
					iter_28_6.follow_position = nil
					iter_28_6.follow_unit = nil
				end
			end

			table.clear(var_0_15)
			table.clear(var_0_16)
		until true
	end
end

function AIBotGroupSystem._selected_unit_is_in_disallowed_nav_tag_volume(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = GwNavQueries.tag_volumes_from_position(arg_29_1, arg_29_2, 2, 2)

	if var_29_0 then
		local var_29_1 = GwNavTagVolume.navtag
		local var_29_2 = GwNavQueries.nav_tag_volume
		local var_29_3 = Managers.state.entity:system("volume_system")
		local var_29_4 = arg_29_0._disallowed_tag_layers
		local var_29_5 = GwNavQueries.nav_tag_volume_count(var_29_0)

		for iter_29_0 = 1, var_29_5 do
			local var_29_6 = var_29_2(var_29_0, iter_29_0)
			local var_29_7, var_29_8, var_29_9, var_29_10, var_29_11 = var_29_1(var_29_6)
			local var_29_12 = LAYER_ID_MAPPING[var_29_9]
			local var_29_13 = var_29_3:get_volume_mapping_from_lookup_id(var_29_11)

			if var_29_13 and var_29_4[var_29_12] then
				return true, var_29_13
			end
		end

		GwNavQueries.destroy_query_dynamic_output(var_29_0)

		return false
	else
		return false
	end
end

local var_0_22 = 9

function AIBotGroupSystem._find_closest_move_target(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0
	local var_30_1 = math.huge
	local var_30_2 = {}

	for iter_30_0 = 1, #arg_30_1 do
		local var_30_3 = arg_30_1[iter_30_0]

		if arg_30_0._timestamped_positions[var_30_3] and not arg_30_0._timestamped_positions[var_30_3].afk then
			var_30_2[#var_30_2 + 1] = var_30_3
		end
	end

	if #var_30_2 == 0 then
		var_30_2 = arg_30_1
	end

	for iter_30_1 = 1, #var_30_2 do
		local var_30_4 = var_30_2[iter_30_1]
		local var_30_5 = Vector3.distance_squared(arg_30_3, POSITION_LOOKUP[var_30_4])

		if var_30_4 == arg_30_2 then
			var_30_5 = var_30_5 - var_0_22
		end

		if var_30_5 < var_30_1 then
			var_30_1 = var_30_5
			var_30_0 = iter_30_1
		end
	end

	return var_30_2[var_30_0]
end

local var_0_23 = 25

function AIBotGroupSystem._find_least_lonely_move_target(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = #arg_31_1

	for iter_31_0 = 1, var_31_0 do
		local var_31_1 = arg_31_1[iter_31_0]

		var_0_17[iter_31_0] = POSITION_LOOKUP[var_31_1]
	end

	local var_31_2
	local var_31_3 = math.huge
	local var_31_4 = #var_0_17

	for iter_31_1 = 1, var_31_4 do
		local var_31_5 = var_0_17[iter_31_1]
		local var_31_6

		if arg_31_1[iter_31_1] == arg_31_2 then
			var_31_6 = -var_0_23
		else
			var_31_6 = 0
		end

		for iter_31_2 = 1, var_31_4 do
			local var_31_7 = var_0_17[iter_31_2]

			var_31_6 = var_31_6 + Vector3.distance_squared(var_31_5, var_31_7)
		end

		if var_31_6 < var_31_3 then
			var_31_2 = iter_31_1
			var_31_3 = var_31_6
		end
	end

	table.clear(var_0_17)

	return arg_31_1[var_31_2]
end

local var_0_24 = 3
local var_0_25 = 900

function AIBotGroupSystem._find_most_lonely_move_target(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = #arg_32_1

	for iter_32_0 = 1, var_32_0 do
		local var_32_1 = arg_32_1[iter_32_0]

		var_0_17[iter_32_0] = POSITION_LOOKUP[var_32_1]
	end

	local var_32_2
	local var_32_3 = -math.huge
	local var_32_4 = POSITION_LOOKUP[arg_32_2]
	local var_32_5 = #var_0_17

	for iter_32_1 = 1, var_32_5 do
		local var_32_6 = var_0_17[iter_32_1]
		local var_32_7
		local var_32_8 = Vector3.distance_squared(var_32_6, var_32_4)

		if var_32_8 > var_0_25 then
			var_32_7 = -var_32_8 * var_0_24
		else
			var_32_7 = 0
		end

		for iter_32_2 = 1, var_32_5 do
			local var_32_9 = var_0_17[iter_32_2]

			var_32_7 = var_32_7 + Vector3.distance_squared(var_32_6, var_32_9)
		end

		if var_32_3 < var_32_7 then
			var_32_2 = iter_32_1
			var_32_3 = var_32_7
		end
	end

	table.clear(var_0_17)

	return arg_32_1[var_32_2]
end

function AIBotGroupSystem._find_origin(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = POSITION_LOOKUP[arg_33_2]
	local var_33_1, var_33_2 = GwNavQueries.triangle_from_position(arg_33_1, var_33_0, 5, 5)
	local var_33_3

	if var_33_1 then
		var_33_3 = Vector3(var_33_0.x, var_33_0.y, var_33_2)
	else
		var_33_3 = GwNavQueries.inside_position_from_outside_position(arg_33_1, var_33_0, 5, 5, 5, 0.5)
	end

	if var_33_3 == nil then
		var_33_3 = var_33_0
	end

	return var_33_3
end

function AIBotGroupSystem._find_cluster_position(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = ScriptUnit.extension(arg_34_2, "locomotion_system")
	local var_34_1 = var_34_0:current_velocity()
	local var_34_2

	if Vector3.length_squared(var_34_1) < 0.01 then
		var_34_2 = Vector3(0, 0, 0)
	else
		var_34_2 = var_34_0:average_velocity()
	end

	local var_34_3 = POSITION_LOOKUP[arg_34_2]
	local var_34_4 = ScriptUnit.extension(arg_34_2, "whereabouts_system"):last_position_onground_on_navmesh()
	local var_34_5

	if var_34_4 and Vector3.distance_squared(var_34_3, var_34_4) < 4 then
		var_34_5 = var_34_4
	else
		local var_34_6, var_34_7 = GwNavQueries.triangle_from_position(arg_34_1, var_34_3, 5, 5)

		if var_34_6 then
			var_34_5 = Vector3(var_34_3.x, var_34_3.y, var_34_7)
		else
			var_34_5 = GwNavQueries.inside_position_from_outside_position(arg_34_1, var_34_3, 5, 5, 5, 0.5)
		end
	end

	local var_34_8

	if var_34_5 then
		local var_34_9, var_34_10 = arg_34_0:_raycast(arg_34_1, var_34_5, var_34_2, 5)

		var_34_8 = Vector3.lerp(var_34_5, var_34_10, 0.6)

		local var_34_11, var_34_12 = GwNavQueries.triangle_from_position(arg_34_1, var_34_8, 5, 5)

		if var_34_11 then
			var_34_8.z = var_34_12
		else
			var_34_8 = var_34_10
		end
	else
		var_34_8 = var_34_3
	end

	local var_34_13

	if Vector3.length_squared(var_34_2) > 0.010000000000000002 then
		var_34_13 = Quaternion.look(var_34_2, Vector3.up())
		arg_34_0._last_move_target_rotations[arg_34_2] = nil
	elseif arg_34_0._last_move_target_rotations[arg_34_2] then
		var_34_13 = arg_34_0._last_move_target_rotations[arg_34_2]:unbox()
	else
		local var_34_14 = Managers.state.network:game()

		if var_34_14 and not LEVEL_EDITOR_TEST then
			local var_34_15 = arg_34_0._unit_storage:go_id(arg_34_2)
			local var_34_16 = GameSession.game_object_field(var_34_14, var_34_15, "aim_direction")

			var_34_13 = Quaternion.look(Vector3.flat(var_34_16), Vector3.up())
		else
			var_34_13 = Unit.local_rotation(arg_34_2, 0)
		end

		arg_34_0._last_move_target_rotations[arg_34_2] = QuaternionBox(var_34_13)
	end

	return var_34_8, var_34_13
end

local var_0_26 = {}
local var_0_27 = {}
local var_0_28 = {}
local var_0_29 = {}

local function var_0_30(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
	local var_35_0 = #arg_35_1

	if var_35_0 < arg_35_0 then
		if arg_35_6 < arg_35_4 then
			for iter_35_0 = 1, var_35_0 do
				arg_35_7[iter_35_0] = arg_35_3[iter_35_0]
			end

			return arg_35_4
		else
			return arg_35_6
		end
	else
		local var_35_1 = arg_35_1[arg_35_0]

		for iter_35_1 = 1, var_35_0 do
			if not arg_35_2[iter_35_1] then
				arg_35_3[arg_35_0] = iter_35_1
				arg_35_2[iter_35_1] = true

				local var_35_2 = arg_35_4 + arg_35_5[var_35_1].nav_point_utility[iter_35_1]

				arg_35_6 = var_0_30(arg_35_0 + 1, arg_35_1, arg_35_2, arg_35_3, var_35_2, arg_35_5, arg_35_6, arg_35_7)
				arg_35_2[iter_35_1] = false
			end
		end

		return arg_35_6
	end
end

function AIBotGroupSystem._assign_destination_points(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	local var_36_0 = var_0_26

	for iter_36_0, iter_36_1 in pairs(arg_36_1) do
		local var_36_1 = iter_36_1.nav_point_utility

		table.clear(var_36_1)

		local var_36_2 = POSITION_LOOKUP[iter_36_0]

		for iter_36_2, iter_36_3 in ipairs(arg_36_2) do
			var_36_1[iter_36_2] = 1 / math.sqrt(math.max(0.001, Vector3.distance(var_36_2, iter_36_3)))
		end

		var_36_0[#var_36_0 + 1] = iter_36_0
	end

	local var_36_3 = var_0_29
	local var_36_4 = var_0_30(1, var_36_0, var_0_27, var_0_28, 0, arg_36_1, -math.huge, var_36_3)

	for iter_36_4 = 1, #var_36_0 do
		local var_36_5 = arg_36_1[var_36_0[iter_36_4]]

		if var_36_5.hold_position then
			var_36_5.follow_position = var_36_5.hold_position:unbox()
			var_36_5.follow_unit = nil
		else
			local var_36_6 = var_36_3[iter_36_4]

			var_36_5.follow_position = arg_36_2[var_36_6]

			if arg_36_4 then
				var_36_5.follow_unit = arg_36_4[var_36_6]
			elseif arg_36_3 then
				var_36_5.follow_unit = arg_36_3
			else
				var_36_5.follow_unit = nil
			end
		end
	end

	table.clear(var_0_26)
	table.clear(var_0_27)
	table.clear(var_0_28)
	table.clear(var_0_29)
end

function AIBotGroupSystem._calculate_center_of_volume(arg_37_0, arg_37_1)
	local var_37_0 = Vector3(0, 0, 0)

	for iter_37_0, iter_37_1 in pairs(arg_37_1.bottom_points) do
		var_37_0 = var_37_0 + Vector3(iter_37_1[1], iter_37_1[2], iter_37_1[3])
	end

	local var_37_1 = var_37_0 / #arg_37_1.bottom_points
	local var_37_2 = 0

	for iter_37_2, iter_37_3 in pairs(arg_37_1.bottom_points) do
		var_37_2 = math.max(Vector3.distance_squared(var_37_1, Vector3(iter_37_3[1], iter_37_3[2], iter_37_3[3])), var_37_2)
	end

	return var_37_1, var_37_2
end

function AIBotGroupSystem._find_destination_points_outside_volume(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	local var_38_0, var_38_1 = arg_38_0:_calculate_center_of_volume(arg_38_3)
	local var_38_2 = math.sqrt(var_38_1) + 1
	local var_38_3 = Vector3.flat(Vector3.normalize(arg_38_2 - var_38_0))
	local var_38_4 = Quaternion.look(var_38_3, Vector3.up())
	local var_38_5 = var_38_2 - 1
	local var_38_6 = arg_38_0:_find_points(arg_38_1, Vector3(var_38_0[1], var_38_0[2], arg_38_2[3]), var_38_4, arg_38_0._left_vectors_outside_volume, arg_38_0._right_vectors_outside_volume, var_38_5, var_38_2, arg_38_5)
	local var_38_7 = #var_38_6
	local var_38_8 = 1
	local var_38_9 = var_38_6[var_38_8]

	if var_38_7 < arg_38_5 then
		for iter_38_0 = var_38_7 + 1, arg_38_5 do
			var_38_6[iter_38_0] = var_38_6[var_38_8] or var_38_9 or arg_38_4
			var_38_9 = var_38_6[var_38_8] or var_38_9
			var_38_8 = var_38_8 + 1
		end
	end

	return var_38_6
end

function AIBotGroupSystem._find_destination_points(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	local var_39_0 = 3
	local var_39_1 = 1
	local var_39_2 = arg_39_0:_find_points(arg_39_1, arg_39_2, arg_39_3, arg_39_0._left_vectors, arg_39_0._right_vectors, var_39_1, var_39_0, arg_39_4)

	if arg_39_4 > #var_39_2 then
		for iter_39_0 = #var_39_2 + 1, arg_39_4 do
			var_39_2[iter_39_0] = arg_39_2
		end
	end

	return var_39_2
end

local function var_0_31(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if arg_40_3 == 0 then
		return
	end

	for iter_40_0 = 1, arg_40_3 do
		local var_40_0 = Vector3.lerp(arg_40_1, arg_40_2, iter_40_0 / arg_40_3)

		arg_40_0[#arg_40_0 + 1] = var_40_0
	end
end

function AIBotGroupSystem._find_points(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8)
	local var_41_0 = 0
	local var_41_1 = 0
	local var_41_2 = 0
	local var_41_3 = 0
	local var_41_4 = arg_41_0._pathing_points

	arg_41_0._pathing_points = var_41_4

	table.clear(var_41_4)

	while (var_41_2 < #arg_41_4 or var_41_3 < #arg_41_5) and arg_41_8 > var_41_0 + var_41_1 do
		if var_41_2 + 1 > #arg_41_4 then
			var_41_3 = var_41_3 + 1

			local var_41_5, var_41_6 = arg_41_0:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_5[var_41_3]:unbox()), arg_41_7)
			local var_41_7 = math.floor(var_41_5 / arg_41_6)

			var_0_31(var_41_4, arg_41_2, var_41_6, var_41_7)

			var_41_1 = var_41_1 + var_41_7
		elseif var_41_3 + 1 > #arg_41_5 then
			var_41_2 = var_41_2 + 1

			local var_41_8, var_41_9 = arg_41_0:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_4[var_41_2]:unbox()), arg_41_7)
			local var_41_10 = math.floor(var_41_8 / arg_41_6)

			var_0_31(var_41_4, arg_41_2, var_41_9, var_41_10)

			var_41_0 = var_41_0 + var_41_10
		elseif var_41_1 == var_41_0 then
			var_41_2 = var_41_2 + 1
			var_41_3 = var_41_3 + 1

			local var_41_11, var_41_12 = arg_41_0:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_4[var_41_2]:unbox()), arg_41_7)
			local var_41_13, var_41_14 = arg_41_0:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_5[var_41_3]:unbox()), arg_41_7)
			local var_41_15 = math.floor(var_41_11 / arg_41_6)
			local var_41_16 = math.floor(var_41_13 / arg_41_6)
			local var_41_17 = var_41_15 + var_41_16

			if arg_41_8 < var_41_17 then
				local var_41_18 = var_41_15 / var_41_17 * arg_41_8
				local var_41_19 = var_41_16 / var_41_17 * arg_41_8
				local var_41_20 = math.floor(var_41_18)

				if var_41_18 - var_41_20 >= 0.5 then
					var_41_18 = math.ceil(var_41_18)
					var_41_19 = math.floor(var_41_19)
				else
					var_41_18 = var_41_20
					var_41_19 = math.ceil(var_41_19)
				end

				var_0_31(var_41_4, arg_41_2, var_41_12, var_41_18)
				var_0_31(var_41_4, arg_41_2, var_41_14, var_41_19)

				var_41_0 = var_41_0 + var_41_18
				var_41_1 = var_41_1 + var_41_19
			else
				var_0_31(var_41_4, arg_41_2, var_41_12, var_41_15)
				var_0_31(var_41_4, arg_41_2, var_41_14, var_41_16)

				var_41_0 = var_41_0 + var_41_15
				var_41_1 = var_41_1 + var_41_16
			end
		elseif var_41_0 < var_41_1 then
			var_41_2 = var_41_2 + 1

			local var_41_21, var_41_22 = arg_41_0:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_4[var_41_2]:unbox()), arg_41_7)
			local var_41_23 = math.floor(var_41_21 / arg_41_6)

			var_0_31(var_41_4, arg_41_2, var_41_22, var_41_23)

			var_41_0 = var_41_0 + var_41_23
		elseif var_41_1 < var_41_0 then
			var_41_3 = var_41_3 + 1

			local var_41_24, var_41_25 = arg_41_0:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_5[var_41_3]:unbox()), arg_41_7)
			local var_41_26 = math.floor(var_41_24 / arg_41_6)

			var_0_31(var_41_4, arg_41_2, var_41_25, var_41_26)

			var_41_1 = var_41_1 + var_41_26
		end
	end

	return var_41_4
end

local var_0_32 = 0.25

function AIBotGroupSystem._raycast(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	local var_42_0 = arg_42_2 + arg_42_3 * (arg_42_4 + var_0_32)
	local var_42_1, var_42_2 = GwNavQueries.raycast(arg_42_1, arg_42_2, var_42_0)

	if var_42_1 then
		return arg_42_4, var_42_2 - arg_42_3 * var_0_32, true
	else
		local var_42_3 = Vector3.length(Vector3.flat(var_42_2 - arg_42_2))

		if var_42_3 < var_0_32 then
			return 0, arg_42_2, false
		else
			return var_42_3 - var_0_32, var_42_2 - arg_42_3 * var_0_32, var_42_1
		end
	end
end

function AIBotGroupSystem._update_priority_targets(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = Managers.state.side
	local var_43_1 = arg_43_0._bot_ai_data
	local var_43_2 = arg_43_0._old_priority_targets

	for iter_43_0 = 1, #var_43_1 do
		local var_43_3 = var_43_0:get_side(iter_43_0)
		local var_43_4 = var_43_2[iter_43_0]
		local var_43_5 = var_43_3.PLAYER_AND_BOT_UNITS
		local var_43_6 = #var_43_5

		for iter_43_1 = 1, var_43_6 do
			local var_43_7 = var_43_5[iter_43_1]
			local var_43_8 = ScriptUnit.extension(var_43_7, "status_system")

			if not var_43_8.near_vortex then
				local var_43_9

				if var_43_8:is_pounced_down() then
					var_43_9 = var_43_8:get_pouncer_unit()
				elseif var_43_8:is_grabbed_by_pack_master() then
					var_43_9 = var_43_8:get_pack_master_grabber()
				elseif var_43_8:is_overpowered() and var_43_8:is_overpowered_by_attacker() then
					var_43_9 = var_43_8.overpowered_attacking_unit
				end

				if HEALTH_ALIVE[var_43_9] then
					var_0_13[var_43_7] = var_43_9
					var_0_14[var_43_9] = (var_43_4[var_43_9] or 0) + arg_43_1
				end
			end
		end

		local var_43_10 = var_43_1[iter_43_0]

		for iter_43_2, iter_43_3 in pairs(var_43_10) do
			if not ALIVE[iter_43_3.current_priority_target] then
				iter_43_3.current_priority_target = nil
			end

			local var_43_11 = iter_43_3.status_extension

			table.clear(iter_43_3.priority_targets)

			if var_0_13[iter_43_2] or var_43_11:is_disabled() then
				iter_43_3.current_priority_target_disabled_ally = nil
				iter_43_3.current_priority_target = nil
				iter_43_3.priority_target_distance = math.huge
			else
				local var_43_12 = POSITION_LOOKUP[iter_43_2]
				local var_43_13
				local var_43_14
				local var_43_15 = -math.huge
				local var_43_16 = math.huge

				for iter_43_4, iter_43_5 in pairs(var_0_13) do
					local var_43_17, var_43_18 = arg_43_0:_calculate_priority_target_utility(var_43_12, iter_43_5, var_0_14[iter_43_5], iter_43_3.current_priority_target)

					iter_43_3.priority_targets[iter_43_5] = var_43_17

					if var_43_15 < var_43_17 then
						var_43_15 = var_43_17
						var_43_13 = iter_43_5
						var_43_16 = var_43_18
						var_43_14 = iter_43_4
					end
				end

				iter_43_3.current_priority_target_disabled_ally = var_43_14
				iter_43_3.current_priority_target = var_43_13
				iter_43_3.priority_target_distance = var_43_16
			end

			local var_43_19 = iter_43_3.blackboard

			if var_43_19.priority_target_disabled_ally or iter_43_3.current_priority_target_disabled_ally then
				var_43_19.priority_target_disabled_ally = iter_43_3.current_priority_target_disabled_ally
			end

			if var_43_19.priority_target_enemy or iter_43_3.current_priority_target then
				var_43_19.priority_target_enemy = iter_43_3.current_priority_target
			end

			var_43_19.priority_target_distance = iter_43_3.priority_target_distance
		end

		table.clear(var_0_13)
		table.create_copy(var_43_4, var_0_14)
		table.clear(var_0_14)
	end
end

local var_0_33 = 15
local var_0_34 = var_0_33^2

function AIBotGroupSystem._update_urgent_targets(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = Managers.state.conflict:alive_bosses()
	local var_44_1 = #var_44_0
	local var_44_2 = arg_44_0._bot_ai_data
	local var_44_3 = arg_44_0._urgent_targets

	for iter_44_0 = 1, #var_44_2 do
		local var_44_4 = var_44_2[iter_44_0]

		for iter_44_1, iter_44_2 in pairs(var_44_4) do
			local var_44_5 = -math.huge
			local var_44_6
			local var_44_7 = math.huge
			local var_44_8 = iter_44_2.blackboard
			local var_44_9 = POSITION_LOOKUP[iter_44_1]
			local var_44_10 = var_44_8.urgent_target_enemy

			for iter_44_3, iter_44_4 in pairs(var_44_3) do
				if iter_44_4 - arg_44_2 > 0 then
					if HEALTH_ALIVE[iter_44_3] then
						local var_44_11, var_44_12 = arg_44_0:_calculate_opportunity_utility(iter_44_1, var_44_8, var_44_9, var_44_10, iter_44_3, arg_44_2, false, false)

						if var_44_5 < var_44_11 then
							var_44_5 = var_44_11
							var_44_6 = iter_44_3
							var_44_7 = var_44_12
						end
					else
						var_44_3[iter_44_3] = nil
					end
				else
					var_44_3[iter_44_3] = nil
				end
			end

			if not var_44_6 then
				for iter_44_5 = 1, var_44_1 do
					local var_44_13 = var_44_0[iter_44_5]
					local var_44_14 = POSITION_LOOKUP[var_44_13]

					if HEALTH_ALIVE[var_44_13] and not AiUtils.unit_invincible(var_44_13) and Vector3.distance_squared(var_44_14, var_44_9) < var_0_34 and not var_0_11[var_44_13].defensive_mode_duration then
						local var_44_15, var_44_16 = arg_44_0:_calculate_opportunity_utility(iter_44_1, var_44_8, var_44_9, var_44_10, var_44_13, arg_44_2, false, false)

						if var_44_5 < var_44_15 then
							var_44_5 = var_44_15
							var_44_6 = var_44_13
							var_44_7 = var_44_16
						end
					end
				end
			end

			var_44_8.revive_with_urgent_target = var_44_6 and arg_44_0:_can_revive_with_urgent_target(iter_44_1, var_44_9, var_44_8, var_44_6, arg_44_2)
			var_44_8.urgent_target_enemy = var_44_6
			var_44_8.urgent_target_distance = var_44_7

			local var_44_17 = var_44_8.hit_by_projectile

			for iter_44_6, iter_44_7 in pairs(var_44_17) do
				if not HEALTH_ALIVE[iter_44_6] then
					var_44_17[iter_44_6] = nil
				end
			end
		end
	end
end

local var_0_35 = {
	skaven_pack_master = 49,
	chaos_corruptor_sorcerer = 100,
	skaven_poison_wind_globadier = 25,
	skaven_warpfire_thrower = 100,
	skaven_ratling_gunner = 25
}

function AIBotGroupSystem._can_revive_with_urgent_target(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5)
	local var_45_0 = var_0_11[arg_45_4]
	local var_45_1 = var_45_0.breed
	local var_45_2 = var_45_1.name
	local var_45_3 = POSITION_LOOKUP[arg_45_4]
	local var_45_4 = arg_45_3.target_ally_unit
	local var_45_5 = POSITION_LOOKUP[var_45_4]
	local var_45_6 = var_45_5 and Vector3.distance_squared(var_45_5, var_45_3) or Vector3.distance_squared(arg_45_2, var_45_3)
	local var_45_7 = var_0_35[var_45_2] or 25

	if var_45_1.boss then
		return true
	elseif var_45_2 == "skaven_ratling_gunner" then
		local var_45_8 = arg_45_3.hit_by_projectile[arg_45_4]

		return (not var_45_8 or arg_45_5 > var_45_8 + 1) and var_45_7 < var_45_6
	else
		return var_45_6 > var_45_7 * (var_45_0.target_unit == arg_45_1 and 4 or 1)
	end
end

local var_0_36 = 40
local var_0_37 = var_0_36^2
local var_0_38 = {}

function AIBotGroupSystem._update_opportunity_targets(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = Managers.state.conflict

	table.clear(var_0_38)

	local var_46_1 = var_46_0:alive_specials(var_0_38)
	local var_46_2 = #var_46_1
	local var_46_3 = Vector3.distance_squared
	local var_46_4 = arg_46_0._bot_ai_data

	for iter_46_0 = 1, #var_46_4 do
		local var_46_5 = var_46_4[iter_46_0]

		for iter_46_1, iter_46_2 in pairs(var_46_5) do
			local var_46_6 = -math.huge
			local var_46_7
			local var_46_8 = math.huge
			local var_46_9 = iter_46_2.blackboard
			local var_46_10 = POSITION_LOOKUP[iter_46_1]
			local var_46_11 = var_46_9.opportunity_target_enemy
			local var_46_12 = var_46_9.side

			for iter_46_3 = 1, var_46_2 do
				local var_46_13 = var_46_1[iter_46_3]
				local var_46_14 = var_0_11[var_46_13].breed.ignore_bot_opportunity
				local var_46_15 = POSITION_LOOKUP[var_46_13]

				if not var_46_14 and HEALTH_ALIVE[var_46_13] and var_46_3(var_46_15, var_46_10) < var_0_37 then
					local var_46_16, var_46_17 = arg_46_0:_calculate_opportunity_utility(iter_46_1, var_46_9, var_46_10, var_46_11, var_46_13, arg_46_2, false, true)

					if var_46_6 < var_46_16 then
						var_46_6 = var_46_16
						var_46_7 = var_46_13
						var_46_8 = var_46_17
					end
				end
			end

			local var_46_18 = var_46_12.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

			for iter_46_4, iter_46_5 in pairs(var_46_18) do
				if iter_46_5 then
					local var_46_19 = ScriptUnit.has_extension(iter_46_4, "ghost_mode_system")

					if not var_46_19 or not var_46_19:is_in_ghost_mode() then
						local var_46_20 = POSITION_LOOKUP[iter_46_4]

						if HEALTH_ALIVE[iter_46_4] and var_46_3(var_46_20, var_46_10) < var_0_37 then
							local var_46_21, var_46_22 = arg_46_0:_calculate_opportunity_utility(iter_46_1, var_46_9, var_46_10, var_46_11, iter_46_4, arg_46_2, false, true)

							if var_46_6 < var_46_21 then
								var_46_6 = var_46_21
								var_46_7 = iter_46_4
								var_46_8 = var_46_22
							end
						end
					end
				end
			end

			var_46_9.opportunity_target_enemy = var_46_7
			var_46_9.opportunity_target_distance = var_46_8
		end
	end
end

local var_0_39 = 0.2
local var_0_40 = 0.65
local var_0_41 = BotConstants.default.OPPORTUNITY_TARGET_REACTION_TIMES

function AIBotGroupSystem._calculate_opportunity_utility(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6, arg_47_7, arg_47_8)
	if not arg_47_2.side.enemy_units_lookup[arg_47_5] then
		return -math.huge, math.huge
	end

	local var_47_0 = ScriptUnit.has_extension(arg_47_5, "proximity_system")
	local var_47_1 = math.max(Vector3.distance(arg_47_3, POSITION_LOOKUP[arg_47_5]), 1)

	if var_47_0 and not var_47_0.has_been_seen and not arg_47_7 then
		return -math.huge, math.huge
	elseif var_47_0 then
		local var_47_2 = var_47_0.bot_reaction_times[arg_47_1]

		if not var_47_2 then
			local var_47_3
			local var_47_4

			if arg_47_8 then
				local var_47_5 = Managers.state.difficulty:get_difficulty()
				local var_47_6 = var_0_41[var_47_5]

				var_47_3 = var_47_6.min
				var_47_4 = var_47_6.max
			else
				var_47_3 = var_0_39
				var_47_4 = var_0_40
			end

			var_47_0.bot_reaction_times[arg_47_1] = arg_47_6 + Math.random(var_47_3, var_47_4)

			return -math.huge, math.huge
		elseif arg_47_6 < var_47_2 then
			return -math.huge, math.huge
		end
	end

	return 1 / (var_47_1 + (arg_47_5 == arg_47_4 and var_0_10 or 0)), var_47_1
end

function AIBotGroupSystem._update_pickups(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = Managers.player:players()

	if arg_48_2 > arg_48_0._update_pickups_at then
		arg_48_0._update_pickups_at = arg_48_2 + 0.15 + Math.random() * 0.1

		local var_48_1 = arg_48_0._last_key_in_available_pickups

		if var_48_1 ~= nil and not var_48_0[var_48_1] then
			var_48_1 = nil
		end

		local var_48_2, var_48_3 = next(var_48_0, var_48_1)

		if not var_48_2 then
			var_48_2, var_48_3 = next(var_48_0)
		end

		arg_48_0._last_key_in_available_pickups = var_48_2

		local var_48_4 = var_48_3.player_unit

		if HEALTH_ALIVE[var_48_4] and not ScriptUnit.extension(var_48_4, "status_system"):is_ready_for_assisted_respawn() then
			arg_48_0:_update_pickups_near_player(var_48_4, arg_48_2)
		end
	end

	arg_48_0:_update_orders(arg_48_1, arg_48_2)
	arg_48_0:_update_health_pickups(arg_48_1, arg_48_2)
	arg_48_0:_update_mule_pickups(arg_48_1, arg_48_2)
end

local var_0_42 = 15
local var_0_43 = {}

function AIBotGroupSystem._update_orders(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0._bot_ai_data

	for iter_49_0 = 1, #var_49_0 do
		local var_49_1 = var_49_0[iter_49_0]

		for iter_49_1, iter_49_2 in pairs(var_49_1) do
			local var_49_2 = iter_49_2.pickup_orders
			local var_49_3 = ScriptUnit.extension(iter_49_1, "inventory_system")

			for iter_49_3, iter_49_4 in pairs(var_49_2) do
				local var_49_4 = var_49_3:get_slot_data(iter_49_3)
				local var_49_5 = var_49_3:can_store_additional_item(iter_49_3)

				if var_49_4 and not var_49_5 then
					local var_49_6 = var_49_3:get_item_template(var_49_4)
					local var_49_7

					if iter_49_4.pickup_name == "grimoire" then
						var_49_7 = var_49_6.is_grimoire
					else
						var_49_7 = var_49_6.pickup_data and var_49_6.pickup_data.pickup_name == iter_49_4.pickup_name
					end

					if var_49_7 then
						iter_49_4.unit = nil
					elseif iter_49_2.status_extension:is_disabled() then
						var_49_2[iter_49_3] = nil
					elseif iter_49_4.unit == nil then
						var_49_2[iter_49_3] = nil
					end
				elseif iter_49_4.unit == nil then
					var_49_2[iter_49_3] = nil
				end

				if iter_49_4.unit and not Unit.alive(iter_49_4.unit) then
					var_49_2[iter_49_3] = nil
				end
			end
		end
	end
end

function AIBotGroupSystem._update_pickups_near_player(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = Managers.state.side.side_by_unit[arg_50_1]
	local var_50_1 = var_50_0.side_id
	local var_50_2 = arg_50_0._bot_ai_data[var_50_1]
	local var_50_3 = POSITION_LOOKUP[arg_50_1]
	local var_50_4 = arg_50_0._available_health_pickups[var_50_1]
	local var_50_5 = arg_50_0._available_mule_pickups[var_50_1]

	for iter_50_0, iter_50_1 in pairs(var_50_2) do
		local var_50_6 = iter_50_1.blackboard
		local var_50_7 = var_50_6.ammo_pickup

		if Unit.alive(var_50_7) then
			local var_50_8 = Vector3.distance(POSITION_LOOKUP[iter_50_0], POSITION_LOOKUP[var_50_7])

			var_50_6.ammo_dist = var_50_8
			iter_50_1.ammo_dist = var_50_8
		elseif var_50_6.ammo_pickup then
			var_50_6.ammo_pickup = nil
			var_50_6.ammo_dist = nil
			iter_50_1.ammo_dist = nil

			if iter_50_1.ammo_pickup_order_unit then
				iter_50_1.ammo_pickup_order_unit = nil
			end
		end
	end

	local var_50_9 = true
	local var_50_10 = true
	local var_50_11 = arg_50_2 + 5
	local var_50_12 = 2.5
	local var_50_13 = 5
	local var_50_14 = 15
	local var_50_15 = Managers.state.game_mode:game_mode_key()
	local var_50_16 = Managers.state.entity:system("pickup_system"):get_pickups(var_50_3, var_0_42, var_0_43)

	for iter_50_2 = 1, var_50_16 do
		local var_50_17 = var_0_43[iter_50_2]
		local var_50_18 = ScriptUnit.has_extension(var_50_17, "pickup_system")
		local var_50_19 = ScriptUnit.has_extension(var_50_17, "surrounding_aware_system")

		if var_50_18 and (not var_50_19 or var_50_19.has_been_seen or ScriptUnit.extension(var_50_17, "ping_system"):pinged()) then
			local var_50_20 = var_50_18.pickup_name
			local var_50_21 = AllPickups[var_50_20]

			if var_50_20 == "healing_draught" or var_50_20 == "first_aid_kit" or var_50_20 == "tome" then
				local var_50_22 = BackendUtils.get_item_template(ItemMasterList[var_50_21.item_name])

				if not var_50_4[var_50_17] then
					var_50_4[var_50_17] = {
						template = var_50_22,
						valid_until = var_50_11
					}
				else
					var_50_4[var_50_17].valid_until = var_50_11
					var_50_4[var_50_17].template = var_50_22
				end
			elseif var_50_21.bots_mule_pickup then
				var_50_5[var_50_21.slot_name][var_50_17] = var_50_11
			elseif var_50_21.type == "ammo" then
				if var_50_9 then
					local var_50_23 = var_50_0.PLAYER_UNITS
					local var_50_24 = #var_50_23

					for iter_50_3 = 1, var_50_24 do
						local var_50_25 = var_50_23[iter_50_3]

						if HEALTH_ALIVE[var_50_25] and ScriptUnit.extension(var_50_25, "inventory_system"):ammo_percentage() < 1 then
							var_50_10 = false

							break
						end
					end

					var_50_9 = false
				end

				for iter_50_4, iter_50_5 in pairs(var_50_2) do
					local var_50_26 = iter_50_5.blackboard
					local var_50_27 = iter_50_5.ammo_pickup_order_unit

					if not var_50_27 or arg_50_2 >= var_50_26.ammo_pickup_valid_until then
						local var_50_28 = var_50_26.ammo_pickup
						local var_50_29 = POSITION_LOOKUP[var_50_17]
						local var_50_30 = Vector3.distance(POSITION_LOOKUP[iter_50_4], var_50_29)
						local var_50_31 = iter_50_5.follow_position
						local var_50_32 = var_50_26.inventory_extension
						local var_50_33 = var_50_32:current_ammo_kind("slot_ranged")
						local var_50_34 = var_50_21.ammo_kind or "default"
						local var_50_35 = var_50_33 == var_50_34
						local var_50_36

						if var_50_15 == "survival" then
							if var_50_21.only_once then
								local var_50_37, var_50_38 = var_50_32:current_ammo_status("slot_ranged")

								var_50_36 = var_50_37 and var_50_37 == 0
							else
								var_50_36 = true
							end
						else
							var_50_36 = var_50_34 == "thrown" and true or var_50_26.has_ammo_missing and (not var_50_21.only_once or var_50_26.needs_ammo and var_50_10)
						end

						local var_50_39 = (var_50_30 < var_50_13 or var_50_31 and var_50_14 > Vector3.distance(var_50_31, var_50_29)) and (not var_50_28 or var_50_30 - (var_50_28 == var_50_17 and var_50_12 or 0) < iter_50_5.ammo_dist)

						if var_50_35 and var_50_36 and var_50_39 then
							var_50_26.ammo_pickup = var_50_17
							var_50_26.ammo_pickup_valid_until = var_50_11
							var_50_26.ammo_dist = var_50_30
							iter_50_5.ammo_dist = var_50_30

							if var_50_27 then
								iter_50_5.ammo_pickup_order_unit = nil
							end
						end
					end
				end
			end
		end
	end

	table.clear(var_0_43)
end

local var_0_44 = {}
local var_0_45 = {}
local var_0_46 = {}
local var_0_47 = {}
local var_0_48 = {}
local var_0_49 = {}
local var_0_50 = {}
local var_0_51 = {}
local var_0_52 = {}
local var_0_53 = {}
local var_0_54 = {}
local var_0_55 = 15
local var_0_56 = 225
local var_0_57 = 225

local function var_0_58(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8)
	if arg_51_8 < arg_51_0 then
		if arg_51_1 < arg_51_3 then
			for iter_51_0 = 1, arg_51_8 do
				arg_51_4[iter_51_0] = arg_51_2[iter_51_0]
			end

			return arg_51_1
		else
			return arg_51_3
		end
	else
		local var_51_0 = var_0_48[arg_51_0]
		local var_51_1 = var_0_49[arg_51_0]
		local var_51_2 = var_51_0.health_pickup
		local var_51_3 = var_0_51[arg_51_0] or 0

		for iter_51_1, iter_51_2 in pairs(arg_51_7) do
			if arg_51_6[iter_51_1] then
				local var_51_4 = var_51_2 == iter_51_1 and var_0_56 or 0
				local var_51_5 = arg_51_1 + Vector3.distance_squared(var_51_1, iter_51_2) - var_51_4 - var_51_3 * var_0_57

				arg_51_6[iter_51_1] = nil
				arg_51_2[arg_51_0] = iter_51_1
				arg_51_3 = var_0_58(arg_51_0 + 1, var_51_5, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8)
				arg_51_2[arg_51_0] = nil
				arg_51_6[iter_51_1] = iter_51_2
			end
		end

		if arg_51_5 > 0 then
			arg_51_3 = var_0_58(arg_51_0 + 1, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5 - 1, arg_51_6, arg_51_7, arg_51_8)
		end

		return arg_51_3
	end
end

local var_0_59 = {}

function AIBotGroupSystem._update_mule_pickups(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = Unit.alive
	local var_52_1 = Vector3.distance_squared
	local var_52_2 = 400
	local var_52_3 = Managers.state.side
	local var_52_4 = arg_52_0._bot_ai_data
	local var_52_5 = arg_52_0._available_mule_pickups

	for iter_52_0 = 1, #var_52_4 do
		table.clear(var_0_59)

		local var_52_6 = var_52_4[iter_52_0]
		local var_52_7 = var_52_5[iter_52_0]

		for iter_52_1, iter_52_2 in pairs(var_52_6) do
			local var_52_8 = math.huge
			local var_52_9
			local var_52_10 = iter_52_2.pickup_orders

			for iter_52_3, iter_52_4 in pairs(var_52_7) do
				local var_52_11 = var_52_10[iter_52_3]
				local var_52_12 = var_52_11 and var_52_11.unit

				if var_52_12 then
					iter_52_4[var_52_12] = nil
					var_0_59[var_52_12] = true

					local var_52_13 = var_52_1(POSITION_LOOKUP[var_52_12], POSITION_LOOKUP[iter_52_1])

					if var_52_13 < var_52_8 then
						var_52_9 = var_52_12
						var_52_8 = var_52_13
					end
				end
			end

			if var_52_9 then
				local var_52_14 = iter_52_2.blackboard

				var_52_14.mule_pickup = var_52_9
				var_52_14.mule_pickup_dist_squared = var_52_8
			end
		end

		for iter_52_5, iter_52_6 in pairs(var_52_6) do
			local var_52_15 = iter_52_6.blackboard
			local var_52_16 = var_52_15.mule_pickup

			if var_52_16 then
				if var_0_59[var_52_16] then
					local var_52_17 = ScriptUnit.extension(var_52_16, "pickup_system"):get_pickup_settings().slot_name
					local var_52_18 = iter_52_6.pickup_orders[var_52_17]

					if not var_52_18 or var_52_18.unit ~= var_52_16 then
						var_52_15.mule_pickup = nil
					end
				elseif not var_52_0(var_52_16) or var_52_2 < var_52_1(POSITION_LOOKUP[var_52_16], iter_52_6.follow_position or POSITION_LOOKUP[var_52_16]) then
					var_52_15.mule_pickup = nil
				else
					local var_52_19 = ScriptUnit.extension(var_52_16, "pickup_system").pickup_name
					local var_52_20 = AllPickups[var_52_19].slot_name
					local var_52_21 = var_52_15.inventory_extension
					local var_52_22 = var_52_21:get_slot_data(var_52_20)
					local var_52_23 = var_52_21:can_store_additional_item(var_52_20)

					if var_52_22 and not var_52_23 then
						var_52_15.mule_pickup = nil
					else
						var_0_59[var_52_16] = true
						var_52_15.mule_pickup_dist_squared = var_52_1(POSITION_LOOKUP[iter_52_5], POSITION_LOOKUP[var_52_16])
					end
				end
			end
		end

		local var_52_24 = var_52_3:get_side(iter_52_0).PLAYER_UNITS
		local var_52_25 = #var_52_24

		for iter_52_7, iter_52_8 in pairs(var_52_7) do
			local var_52_26 = 0

			for iter_52_9, iter_52_10 in pairs(iter_52_8) do
				if var_52_0(iter_52_9) and arg_52_2 <= iter_52_10 then
					var_52_26 = var_52_26 + 1
				else
					iter_52_8[iter_52_9] = nil
				end
			end

			local var_52_27 = 0

			for iter_52_11 = 1, var_52_25 do
				if iter_52_7 == "infinite_slot" then
					break
				end

				local var_52_28 = var_52_24[iter_52_11]

				if HEALTH_ALIVE[var_52_28] and not ScriptUnit.extension(var_52_28, "inventory_system"):get_slot_data(iter_52_7) then
					local var_52_29 = POSITION_LOOKUP[var_52_28]

					for iter_52_12, iter_52_13 in pairs(iter_52_8) do
						local var_52_30 = POSITION_LOOKUP[iter_52_12]

						if var_52_2 > var_52_1(var_52_30, var_52_29) then
							var_52_27 = var_52_27 + 1

							break
						end
					end
				end
			end

			if var_52_27 == 0 then
				for iter_52_14, iter_52_15 in pairs(var_52_6) do
					local var_52_31 = iter_52_15.blackboard
					local var_52_32 = iter_52_15.pickup_orders[iter_52_7]
					local var_52_33 = var_52_31.inventory_extension
					local var_52_34 = var_52_33:get_slot_data(iter_52_7)
					local var_52_35 = var_52_33:can_store_additional_item(iter_52_7)

					if not var_52_31.mule_pickup and (not var_52_34 or var_52_35) and not var_52_32 then
						local var_52_36 = math.huge
						local var_52_37

						for iter_52_16, iter_52_17 in pairs(iter_52_8) do
							if not var_0_59[iter_52_16] then
								local var_52_38 = POSITION_LOOKUP[iter_52_16]
								local var_52_39 = POSITION_LOOKUP[iter_52_14]
								local var_52_40 = var_52_1(var_52_39, var_52_38)

								if var_52_2 > var_52_1(iter_52_15.follow_position or var_52_39, var_52_38) and var_52_40 < var_52_36 then
									var_52_37 = iter_52_16
									var_52_36 = var_52_40
								end
							end
						end

						if var_52_37 then
							var_52_31.mule_pickup = var_52_37
							var_52_31.mule_pickup_dist_squared = var_52_36
							var_0_59[var_52_37] = true
						end
					end
				end
			end
		end
	end
end

function AIBotGroupSystem._update_health_pickups(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = Unit.alive
	local var_53_1 = Vector3.distance
	local var_53_2 = Vector3.distance_squared
	local var_53_3 = Managers.state.side
	local var_53_4 = arg_53_0._bot_ai_data
	local var_53_5 = arg_53_0._available_health_pickups

	for iter_53_0 = 1, #var_53_4 do
		local var_53_6 = var_53_5[iter_53_0]
		local var_53_7 = 0
		local var_53_8 = 0

		for iter_53_1, iter_53_2 in pairs(var_53_6) do
			if not var_53_0(iter_53_1) or arg_53_2 > iter_53_2.valid_until then
				var_53_6[iter_53_1] = nil
			elseif iter_53_2.template.can_heal_self then
				var_53_7 = var_53_7 + 1
				var_0_45[iter_53_1] = POSITION_LOOKUP[iter_53_1]
			else
				var_53_8 = var_53_8 + 1
				var_0_47[iter_53_1] = POSITION_LOOKUP[iter_53_1]
			end
		end

		table.clear(var_0_44)

		local var_53_9 = var_53_4[iter_53_0]

		for iter_53_3, iter_53_4 in pairs(var_53_9) do
			local var_53_10 = iter_53_4.pickup_orders.slot_healthkit

			if var_53_10 then
				local var_53_11 = var_53_10.unit

				if not var_53_11 then
					-- block empty
				elseif var_0_45[var_53_11] then
					var_53_7 = var_53_7 - 1
					var_0_45[var_53_11] = nil
				elseif var_0_47[var_53_11] then
					var_53_8 = var_53_8 - 1
					var_0_47[var_53_11] = nil
				end

				var_0_44[iter_53_3] = var_53_10
			end
		end

		local var_53_12 = math.huge
		local var_53_13 = var_53_3:get_side(iter_53_0).PLAYER_UNITS
		local var_53_14 = #var_53_13

		for iter_53_5 = 1, var_53_14 do
			local var_53_15 = var_53_13[iter_53_5]

			if HEALTH_ALIVE[var_53_15] then
				if not ScriptUnit.extension(var_53_15, "inventory_system"):get_slot_data("slot_healthkit") and not var_0_44[var_53_15] then
					local var_53_16 = math.huge
					local var_53_17
					local var_53_18 = POSITION_LOOKUP[var_53_15]

					if var_53_7 > 0 then
						for iter_53_6, iter_53_7 in pairs(var_0_45) do
							local var_53_19 = var_53_2(var_53_18, iter_53_7)

							if var_53_19 < var_53_16 then
								var_53_16 = var_53_19
								var_53_17 = iter_53_6
							end
						end

						var_53_7 = var_53_7 - 1
						var_0_45[var_53_17] = nil
					elseif var_53_8 > 0 then
						for iter_53_8, iter_53_9 in pairs(var_0_47) do
							local var_53_20 = var_53_2(var_53_18, iter_53_9)

							if var_53_20 < var_53_16 then
								var_53_16 = var_53_20
								var_53_17 = iter_53_8
							end
						end

						var_53_8 = var_53_8 - 1
						var_0_47[var_53_17] = nil
					end
				end

				local var_53_21 = ScriptUnit.extension(var_53_15, "status_system")

				if var_53_21:is_knocked_down() or var_53_21:is_wounded() then
					var_53_12 = math.min(0, var_53_12)
				else
					local var_53_22 = ScriptUnit.extension(var_53_15, "health_system"):current_health_percent()

					var_53_12 = math.min(var_53_22, var_53_12)
				end
			end
		end

		local var_53_23 = 0
		local var_53_24 = math.huge
		local var_53_25 = false
		local var_53_26

		for iter_53_10, iter_53_11 in pairs(var_53_9) do
			local var_53_27 = var_0_11[iter_53_10]

			var_53_27.allowed_to_take_health_pickup = false
			var_53_27.force_use_health_pickup = false

			local var_53_28 = ScriptUnit.extension(iter_53_10, "inventory_system")
			local var_53_29 = iter_53_11.status_extension
			local var_53_30 = var_53_28:get_slot_data("slot_healthkit")
			local var_53_31 = var_53_30 and var_53_28:get_item_template(var_53_30).can_heal_self

			if var_0_44[iter_53_10] and not var_53_31 then
				-- block empty
			elseif not var_53_31 and HEALTH_ALIVE[iter_53_10] and not var_53_29:is_ready_for_assisted_respawn() then
				var_53_23 = var_53_23 + 1
				var_0_50[var_53_23] = iter_53_10
				var_0_48[var_53_23] = var_53_27
				var_0_49[var_53_23] = POSITION_LOOKUP[iter_53_10]

				local var_53_32 = ScriptUnit.extension(iter_53_10, "health_system"):current_health_percent()

				if var_53_29:is_wounded() then
					var_53_32 = var_53_32 / 3
				end

				var_0_51[var_53_23] = var_53_32

				if var_53_32 < var_53_24 then
					var_53_24 = var_53_32
					var_53_25 = false
					var_53_26 = nil
				end

				var_0_54[iter_53_10] = var_53_23
			elseif var_53_31 and HEALTH_ALIVE[iter_53_10] and not var_53_29:is_ready_for_assisted_respawn() then
				local var_53_33 = ScriptUnit.extension(iter_53_10, "health_system"):current_health_percent()
				local var_53_34 = ScriptUnit.extension(iter_53_10, "buff_system"):has_buff_type("trait_necklace_no_healing_health_regen")
				local var_53_35 = var_53_29:is_wounded()

				if var_53_33 < var_53_24 and (not var_53_34 or var_53_35) then
					var_53_24 = var_53_33
					var_53_25 = true
					var_53_26 = var_53_27
				end
			end
		end

		table.merge(var_0_46, var_0_45)

		local var_53_36 = var_53_23 < var_53_7
		local var_53_37 = math.max(0, var_53_23 - var_53_7)

		var_0_58(1, 0, var_0_52, math.huge, var_0_53, var_53_37, var_0_46, var_0_45, var_53_23)
		table.clear(var_0_51)

		for iter_53_12, iter_53_13 in pairs(var_53_9) do
			local var_53_38 = var_0_54[iter_53_12]

			if var_53_38 then
				local var_53_39 = var_0_48[var_53_38]
				local var_53_40 = var_0_53[var_53_38]

				if var_53_40 then
					var_53_39.health_pickup = var_53_40

					local var_53_41 = POSITION_LOOKUP[var_53_40]
					local var_53_42 = var_53_1(var_0_49[var_53_38], var_53_41)

					var_53_39.health_dist = var_53_42
					var_53_39.health_pickup_valid_until = math.huge

					local var_53_43 = iter_53_13.follow_position

					if not var_53_43 and var_53_42 < var_0_55 or var_53_43 and var_53_1(var_53_43, var_53_41) < var_0_55 then
						var_53_39.allowed_to_take_health_pickup = true
					else
						var_53_39.allowed_to_take_health_pickup = false
					end
				else
					var_53_39.allowed_to_take_health_pickup = false
					var_53_39.health_dist = nil
					var_53_39.health_pickup_valid_until = nil
				end
			elseif var_0_44[iter_53_12] and var_0_44[iter_53_12].unit then
				local var_53_44 = var_0_11[iter_53_12]
				local var_53_45 = var_0_44[iter_53_12].unit

				var_53_44.health_pickup = var_53_45
				var_53_44.health_dist = var_53_1(POSITION_LOOKUP[iter_53_12], POSITION_LOOKUP[var_53_45])
				var_53_44.health_pickup_valid_until = math.huge
				var_53_44.allowed_to_take_health_pickup = true
			else
				local var_53_46 = var_0_11[iter_53_12]

				if var_53_46.health_pickup then
					var_53_46.health_pickup = nil
					var_53_46.health_dist = nil
					var_53_46.health_pickup_valid_until = nil
				end

				var_53_46.allowed_to_take_health_pickup = false
			end
		end

		local var_53_47 = 1

		for iter_53_14 = 1, var_53_23 do
			local var_53_48 = var_0_50[iter_53_14]
			local var_53_49 = ScriptUnit.extension(var_53_48, "inventory_system"):get_slot_data("slot_healthkit")

			if not var_0_53[iter_53_14] and not var_53_49 then
				local var_53_50 = var_0_50[iter_53_14]

				var_0_50[var_53_47] = var_53_50
				var_0_48[var_53_47] = var_0_48[iter_53_14]
				var_0_49[var_53_47] = var_0_49[iter_53_14]
				var_0_54[var_53_50] = var_53_47
				var_53_47 = var_53_47 + 1
			else
				local var_53_51 = var_0_50[iter_53_14]

				var_0_54[var_53_51] = nil
			end
		end

		for iter_53_15 = var_53_47, var_53_23 do
			var_0_50[iter_53_15] = nil
			var_0_48[iter_53_15] = nil
			var_0_49[iter_53_15] = nil
		end

		table.clear(var_0_46)
		table.clear(var_0_52)
		table.clear(var_0_53)

		local var_53_52 = var_53_47 - 1

		if var_53_52 > 0 then
			table.merge(var_0_46, var_0_47)

			local var_53_53 = math.max(0, var_53_52 - var_53_8)

			var_0_58(1, 0, var_0_52, math.huge, var_0_53, var_53_53, var_0_46, var_0_47, var_53_52)

			for iter_53_16, iter_53_17 in pairs(var_53_9) do
				local var_53_54 = var_0_54[iter_53_16]

				if var_53_54 then
					local var_53_55 = var_0_48[var_53_54]
					local var_53_56 = var_0_53[var_53_54]

					if var_53_56 then
						var_53_55.health_pickup = var_53_56

						local var_53_57 = POSITION_LOOKUP[var_53_56]
						local var_53_58 = var_53_1(var_0_49[var_53_54], var_53_57)

						var_53_55.health_dist = var_53_58
						var_53_55.health_pickup_valid_until = math.huge

						local var_53_59 = iter_53_17.follow_position

						if not var_53_59 and var_53_58 < var_0_55 or var_53_59 and var_53_1(var_53_59, var_53_57) < var_0_55 then
							var_53_55.allowed_to_take_health_pickup = true
						else
							var_53_55.allowed_to_take_health_pickup = false
						end
					else
						var_53_55.allowed_to_take_health_pickup = false
						var_53_55.health_dist = nil
						var_53_55.health_pickup_valid_until = nil
					end
				end
			end

			table.clear(var_0_46)
			table.clear(var_0_52)
			table.clear(var_0_53)
		end

		table.clear(var_0_48)
		table.clear(var_0_50)
		table.clear(var_0_49)
		table.clear(var_0_54)
		table.clear(var_0_45)
		table.clear(var_0_47)

		if not arg_53_0._in_carry_event[iter_53_0] and var_53_36 and var_53_25 and var_53_24 > 0 and var_53_12 > math.min(var_53_24 * 1.2, 1) then
			var_53_26.force_use_health_pickup = true
		end
	end
end

function AIBotGroupSystem._calculate_priority_target_utility(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	local var_54_0 = arg_54_2 == arg_54_4 and var_0_10 or 0
	local var_54_1 = math.max(Vector3.distance(arg_54_1, POSITION_LOOKUP[arg_54_2]), 1)

	return 1 / (var_54_1 + var_54_0) + arg_54_3, var_54_1
end

function AIBotGroupSystem._update_first_person_debug(arg_55_0)
	if not script_data.ai_bots_debug then
		return
	end

	if IS_WINDOWS then
		if Keyboard.pressed(Keyboard.button_index("numpad 1")) then
			arg_55_0:first_person_debug(1)
		elseif Keyboard.pressed(Keyboard.button_index("numpad 2")) then
			arg_55_0:first_person_debug(2)
		elseif Keyboard.pressed(Keyboard.button_index("numpad 3")) then
			arg_55_0:first_person_debug(3)
		elseif Keyboard.pressed(Keyboard.button_index("numpad enter")) then
			arg_55_0:first_person_debug(nil)
		end
	end
end

function AIBotGroupSystem._update_weapon_debug(arg_56_0)
	if not script_data.ai_bots_weapon_debug then
		return
	end

	local var_56_0 = Managers.player

	Debug.text("BOT RANGED WEAPON")

	for iter_56_0 = 1, #arg_56_0._bot_ai_data do
		local var_56_1 = arg_56_0._bot_ai_data[iter_56_0]

		for iter_56_1, iter_56_2 in pairs(var_56_1) do
			local var_56_2 = iter_56_2.blackboard
			local var_56_3 = var_56_2.inventory_extension
			local var_56_4 = var_56_3:get_slot_data("slot_ranged")

			if var_56_4 then
				local var_56_5 = var_56_0:owner(iter_56_1):profile_display_name()
				local var_56_6 = var_56_2.overcharge_extension
				local var_56_7, var_56_8 = var_56_3:current_ammo_status("slot_ranged")
				local var_56_9, var_56_10, var_56_11 = var_56_6:current_overcharge_status()
				local var_56_12 = var_56_3:get_item_template(var_56_4).name
				local var_56_13 = var_56_7 and string.format(" %d|%d", var_56_7, var_56_8) or ""
				local var_56_14 = var_56_9 and string.format(" %02d|%d|%d", var_56_9, var_56_10, var_56_11) or ""

				Debug.text("%-16s:%s%s [%s]", var_56_5, var_56_13, var_56_14, var_56_12)
			end
		end
	end
end

function AIBotGroupSystem._update_order_debug(arg_57_0)
	if not script_data.ai_bots_order_debug then
		return
	end

	local var_57_0 = {
		slot_healthkit = Color(255, 0, 0),
		slot_potion = Color(0, 255, 0),
		slot_level_event = Color(0, 0, 255),
		slot_grenade = Color(0, 255, 255)
	}

	for iter_57_0 = 1, #arg_57_0._bot_ai_data do
		local var_57_1 = arg_57_0._bot_ai_data[iter_57_0]

		for iter_57_1, iter_57_2 in pairs(var_57_1) do
			local var_57_2 = iter_57_2.pickup_orders

			for iter_57_3, iter_57_4 in pairs(var_57_2) do
				local var_57_3 = iter_57_4.unit

				if var_57_3 then
					local var_57_4 = POSITION_LOOKUP[var_57_3]
					local var_57_5 = var_57_0[iter_57_3] or Color(Math.random() * 255, Math.random() * 255, Math.random() * 255)

					QuickDrawer:line(POSITION_LOOKUP[iter_57_1], var_57_4, var_57_5)
					QuickDrawer:sphere(var_57_4, 0.25, var_57_5)
				end
			end
		end
	end

	if Keyboard.pressed(Keyboard.button_index("t")) then
		local var_57_6 = arg_57_0._physics_world
		local var_57_7 = Managers.player:local_player()
		local var_57_8 = var_57_7.viewport_name
		local var_57_9 = ScriptWorld.viewport(arg_57_0._world, var_57_8, true)
		local var_57_10 = ScriptViewport.camera(var_57_9)
		local var_57_11 = ScriptCamera.position(var_57_10)
		local var_57_12 = ScriptCamera.rotation(var_57_10)
		local var_57_13, var_57_14, var_57_15, var_57_16, var_57_17 = PhysicsWorld.immediate_raycast(var_57_6, var_57_11, Quaternion.forward(var_57_12), 100, "closest", "collision_filter", "filter_pickups")

		if var_57_13 then
			local var_57_18 = Actor.unit(var_57_17)
			local var_57_19

			for iter_57_5 = 1, #arg_57_0._bot_ai_data do
				local var_57_20 = arg_57_0._bot_ai_data[iter_57_5]

				for iter_57_6, iter_57_7 in pairs(var_57_20) do
					if HEALTH_ALIVE[iter_57_6] then
						var_57_19 = iter_57_6

						if Math.random() < 0.3 then
							break
						end
					end
				end
			end

			if var_57_19 then
				arg_57_0:order("pickup", var_57_19, var_57_18, var_57_7)
			end
		end
	end
end

function AIBotGroupSystem._update_proximity_bot_breakables_debug(arg_58_0)
	if not script_data.ai_bots_proximity_breakables_debug then
		return
	end

	for iter_58_0 = 1, #arg_58_0._bot_ai_data do
		local var_58_0 = arg_58_0._bot_ai_data[iter_58_0]

		for iter_58_1, iter_58_2 in pairs(var_58_0) do
			if iter_58_1 == script_data.debug_unit then
				local var_58_1 = iter_58_2.previous_bot_breakables

				for iter_58_3, iter_58_4 in pairs(var_58_1) do
					local var_58_2 = "rp_center"
					local var_58_3 = Unit.has_node(iter_58_3, var_58_2) and Unit.node(iter_58_3, var_58_2) or 0
					local var_58_4 = Unit.world_position(iter_58_3, var_58_3)

					QuickDrawer:sphere(var_58_4, 0.25, Colors.get("yellow"))
				end
			end
		end
	end
end

function AIBotGroupSystem._update_ally_needs_aid_priority(arg_59_0)
	local var_59_0 = Unit.alive
	local var_59_1 = arg_59_0._bot_ai_data_lookup

	for iter_59_0, iter_59_1 in pairs(arg_59_0._ally_needs_aid_priority) do
		local var_59_2 = true

		if var_59_0(iter_59_1) then
			local var_59_3 = var_59_1[iter_59_1].blackboard

			var_59_2 = var_59_3.target_ally_unit ~= iter_59_0 or not var_59_3.target_ally_needs_aid or not HEALTH_ALIVE[iter_59_1]
		end

		if var_59_2 then
			arg_59_0._ally_needs_aid_priority[iter_59_0] = nil
		end
	end
end

function AIBotGroupSystem.first_person_debug(arg_60_0, arg_60_1)
	if arg_60_1 == arg_60_0._debugging_bot then
		return
	end

	local var_60_0
	local var_60_1 = Managers.player:human_players()

	for iter_60_0, iter_60_1 in pairs(var_60_1) do
		if not iter_60_1.remote then
			var_60_0 = iter_60_1

			break
		end
	end

	local var_60_2

	if arg_60_1 then
		var_60_2 = Managers.player:local_player(arg_60_1 + 1)
	else
		var_60_2 = var_60_0
	end

	if not var_60_2 then
		return
	end

	local var_60_3 = var_60_2.player_unit

	if not Unit.alive(var_60_3) then
		return
	end

	local var_60_4

	if arg_60_0._debugging_bot then
		var_60_4 = Managers.player:local_player(arg_60_0._debugging_bot + 1)
	else
		var_60_4 = var_60_0
	end

	local var_60_5 = var_60_4.player_unit

	if not Unit.alive(var_60_5) then
		return
	end

	local var_60_6 = arg_60_0._world

	if not Managers.state.camera:has_viewport(var_60_2.viewport_name) then
		Managers.state.entity:system("camera_system"):local_player_created(var_60_2)
	else
		for iter_60_2, iter_60_3 in pairs(Managers.state.entity:system("camera_system").camera_units) do
			if iter_60_2.viewport_name == var_60_2.viewport_name then
				if iter_60_2 ~= var_60_2 then
					ScriptUnit.extension(iter_60_3, "camera_system").player = var_60_2
				end

				break
			end
		end
	end

	ScriptWorld.activate_viewport(var_60_6, ScriptWorld.viewport(var_60_6, var_60_2.viewport_name))
	ScriptWorld.deactivate_viewport(var_60_6, ScriptWorld.viewport(var_60_6, var_60_4.viewport_name))
	ScriptUnit.extension(var_60_3, "first_person_system"):debug_set_first_person_mode(var_60_2 ~= var_60_0, true)
	ScriptUnit.extension(var_60_5, "first_person_system"):debug_set_first_person_mode(var_60_4 == var_60_0, false)

	arg_60_0._debugging_bot = arg_60_1
end

function AIBotGroupSystem.ranged_attack_started(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	if DamageUtils.is_player_unit(arg_61_2) then
		ScriptUnit.extension(arg_61_1, "proximity_system").has_been_seen = true

		local var_61_0 = arg_61_0._bot_ai_data

		for iter_61_0 = 1, #var_61_0 do
			local var_61_1 = var_61_0[iter_61_0]

			for iter_61_1, iter_61_2 in pairs(var_61_1) do
				ScriptUnit.extension(iter_61_1, "ai_system"):ranged_attack_started(arg_61_1, arg_61_2, arg_61_3)
			end
		end

		fassert(arg_61_0._urgent_targets[arg_61_1] ~= math.huge, "Attacker unit %s is already attacking another victim! max one victim at a time allowed, otherwise we need to add ref counting", arg_61_1)

		arg_61_0._urgent_targets[arg_61_1] = math.huge
	end
end

local var_0_60 = 30

function AIBotGroupSystem.ranged_attack_ended(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	local var_62_0 = arg_62_0._bot_ai_data

	for iter_62_0 = 1, #var_62_0 do
		local var_62_1 = var_62_0[iter_62_0]

		for iter_62_1, iter_62_2 in pairs(var_62_1) do
			ScriptUnit.extension(iter_62_1, "ai_system"):ranged_attack_ended(arg_62_1, arg_62_2, arg_62_3)
		end
	end

	arg_62_0._urgent_targets[arg_62_1] = arg_62_0._t + (arg_62_4 or var_0_60)
end

local var_0_61 = 7
local var_0_62 = var_0_61^2

function AIBotGroupSystem.enemy_teleported(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = ScriptUnit.extension(arg_63_1, "proximity_system")

	var_63_0.has_been_seen = false

	local var_63_1 = arg_63_0._physics_world
	local var_63_2 = Managers.state.side.side_by_unit[arg_63_1].ENEMY_PLAYER_AND_BOT_UNITS
	local var_63_3 = arg_63_0._bot_ai_data_lookup

	for iter_63_0 = 1, #var_63_2 do
		local var_63_4 = var_63_2[iter_63_0]

		if var_63_3[var_63_4] then
			local var_63_5 = POSITION_LOOKUP[var_63_4]

			if Vector3.distance_squared(var_63_5, arg_63_2) < var_0_62 and PerceptionUtils.raycast_spine_to_spine(var_63_4, arg_63_1, var_63_1) then
				var_63_0.has_been_seen = true

				break
			end
		end
	end
end

local var_0_63 = 3

function AIBotGroupSystem.register_ally_needs_aid_priority(arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = arg_64_0._ally_needs_aid_priority[arg_64_2]
	local var_64_1 = true

	if var_64_0 then
		local var_64_2 = arg_64_0._bot_ai_data_lookup
		local var_64_3 = var_64_2[var_64_0].blackboard
		local var_64_4 = var_64_2[arg_64_1].blackboard

		var_64_1 = var_64_3.ally_distance > var_64_4.ally_distance + var_0_63
	end

	if var_64_1 then
		arg_64_0._ally_needs_aid_priority[arg_64_2] = arg_64_1
	end
end

function AIBotGroupSystem.is_prioritized_ally(arg_65_0, arg_65_1, arg_65_2)
	return arg_65_0._ally_needs_aid_priority[arg_65_2] == arg_65_1
end

local var_0_64 = {}

function AIBotGroupSystem._update_proximity_bot_breakables(arg_66_0, arg_66_1)
	local var_66_0 = Managers.state.entity:system("ai_system"):nav_world()
	local var_66_1 = Managers.state.entity:system("nav_graph_system")
	local var_66_2 = arg_66_0._bot_breakables_broadphase
	local var_66_3 = arg_66_0._bot_ai_data

	for iter_66_0 = 1, #var_66_3 do
		local var_66_4 = var_66_3[iter_66_0]

		for iter_66_1, iter_66_2 in pairs(var_66_4) do
			local var_66_5 = POSITION_LOOKUP[iter_66_1]
			local var_66_6 = Broadphase.query(var_66_2, var_66_5, 2, var_0_64)
			local var_66_7 = iter_66_2.current_bot_breakables
			local var_66_8 = iter_66_2.previous_bot_breakables
			local var_66_9 = ScriptUnit.extension(iter_66_1, "ai_navigation_system")

			for iter_66_3 = 1, var_66_6 do
				local var_66_10 = var_0_64[iter_66_3]

				if HEALTH_ALIVE[var_66_10] then
					var_66_7[var_66_10] = var_66_10

					if var_66_8[var_66_10] then
						var_66_8[var_66_10] = nil
					else
						local var_66_11 = var_66_1:get_smart_object_id(var_66_10)
						local var_66_12 = var_66_1:get_smart_objects(var_66_11)[1]
						local var_66_13 = Vector3Aux.unbox(var_66_12.pos1)
						local var_66_14 = LocomotionUtils.pos_on_mesh(var_66_0, var_66_13, 1.5, 3)
						local var_66_15 = Vector3Aux.unbox(var_66_12.pos2)
						local var_66_16 = LocomotionUtils.pos_on_mesh(var_66_0, var_66_15, 1.5, 3)
						local var_66_17 = var_66_12.smart_object_type

						if var_66_14 and var_66_16 then
							var_66_9:add_transition(var_66_10, var_66_17, var_66_14, var_66_16)
						end
					end
				end
			end

			for iter_66_4, iter_66_5 in pairs(var_66_8) do
				var_66_9:remove_transition(iter_66_4)

				var_66_8[iter_66_4] = nil
			end

			fassert(table.is_empty(var_66_8), "Error! previous_bot_breakables table was not cleared!")

			iter_66_2.current_bot_breakables = var_66_8
			iter_66_2.previous_bot_breakables = var_66_7
		end
	end
end

function AIBotGroupSystem.set_in_cover(arg_67_0, arg_67_1, arg_67_2)
	arg_67_0._used_covers[arg_67_1] = arg_67_2
end

function AIBotGroupSystem.in_cover(arg_68_0, arg_68_1)
	for iter_68_0, iter_68_1 in pairs(arg_68_0._used_covers) do
		if iter_68_1 == arg_68_1 then
			return iter_68_0
		end
	end

	return nil
end

local function var_0_65(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	local var_69_0, var_69_1 = Vector3.direction_length(arg_69_2 - arg_69_1)
	local var_69_2 = (var_69_1 + arg_69_3)^2
	local var_69_3 = false

	for iter_69_0 = 1, #arg_69_4 do
		if Unit.alive(arg_69_4[iter_69_0]) then
			local var_69_4, var_69_5, var_69_6, var_69_7 = Intersect.ray_circle(arg_69_1, var_69_0, Unit.local_position(arg_69_4[iter_69_0], 0), 0.75)

			if var_69_6 and Vector3.dot(var_69_6, arg_69_2 - arg_69_1) > 0 and (var_69_2 > Vector3.length_squared(var_69_6) or var_69_2 > Vector3.length_squared(var_69_7)) then
				var_69_3 = true

				break
			end
		end
	end

	return var_69_3
end

local var_0_66 = 6
local var_0_67 = 0.01

local function var_0_68(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8, arg_70_9, arg_70_10, arg_70_11)
	local var_70_0 = arg_70_2.x
	local var_70_1 = arg_70_2.y
	local var_70_2 = arg_70_2.z
	local var_70_3 = var_70_0 - arg_70_5
	local var_70_4 = var_70_1 - arg_70_6
	local var_70_5 = math.sqrt(var_70_3 * var_70_3 + var_70_4 * var_70_4)
	local var_70_6 = arg_70_9.x
	local var_70_7 = arg_70_9.y
	local var_70_8 = arg_70_9.z

	if var_70_6 < arg_70_4 then
		var_70_6 = 0
	end

	local var_70_9
	local var_70_10

	if var_70_5 >= var_70_6 - arg_70_4 and var_70_5 <= var_70_7 + arg_70_4 and var_70_2 > arg_70_7 - arg_70_3 - var_70_8 and var_70_2 < arg_70_7 + var_70_8 then
		local var_70_11

		if var_70_6 > 0 and var_70_5 < (var_70_6 + var_70_7) * 0.5 then
			var_70_11 = var_70_6 - arg_70_4
		else
			var_70_11 = var_70_7 + arg_70_4
		end

		local var_70_12 = Vector3(arg_70_5, arg_70_6, arg_70_2[3])
		local var_70_13, var_70_14 = Vector3.direction_length(arg_70_2 - var_70_12)

		if var_70_14 < var_0_67 then
			var_70_13 = Vector3(0, 1, 0)
		end

		local var_70_15 = arg_70_10.proximite_enemies

		for iter_70_0 = 0, var_0_66 - 1 do
			local var_70_16 = (iter_70_0 == 0 or iter_70_0 == var_0_66 - 1) and 1 or 2
			local var_70_17 = 1

			for iter_70_1 = 1, var_70_16 do
				local var_70_18 = math.pi * (iter_70_0 / (var_0_66 - 1)) * var_70_17
				local var_70_19 = var_70_12 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), var_70_18), var_70_13) * var_70_11
				local var_70_20 = 2
				local var_70_21 = 2
				local var_70_22, var_70_23 = GwNavQueries.triangle_from_position(arg_70_0, var_70_19, var_70_20, var_70_21)

				if var_70_22 then
					var_70_19.z = var_70_23

					if GwNavQueries.raycango(arg_70_0, arg_70_2, var_70_19, arg_70_1) then
						if not var_0_65(arg_70_10, arg_70_2, var_70_19, arg_70_4, var_70_15) and not var_0_12(arg_70_11, var_70_19, arg_70_4) then
							var_70_9 = var_70_19
						end

						var_70_10 = var_70_19
					end

					var_70_17 = var_70_17 * -1
				end

				if var_70_9 then
					return var_70_9
				end
			end
		end
	end

	return var_70_10
end

local function var_0_69(arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4, arg_71_5, arg_71_6, arg_71_7, arg_71_8, arg_71_9, arg_71_10, arg_71_11)
	local var_71_0 = arg_71_2.x
	local var_71_1 = arg_71_2.y
	local var_71_2 = arg_71_2.z
	local var_71_3 = var_71_0 - arg_71_5
	local var_71_4 = var_71_1 - arg_71_6
	local var_71_5 = math.sqrt(var_71_3 * var_71_3 + var_71_4 * var_71_4)

	if var_71_5 > arg_71_9 + arg_71_4 then
		return
	elseif var_71_2 < arg_71_7 + arg_71_9 and var_71_2 > arg_71_7 - arg_71_3 - arg_71_9 then
		local var_71_6
		local var_71_7
		local var_71_8 = arg_71_9 + arg_71_4
		local var_71_9

		if var_71_5 < var_0_67 then
			var_71_9 = Vector3(0, 1, 0)
		else
			var_71_9 = Vector3(var_71_3 / var_71_5, var_71_4 / var_71_5, 0)
		end

		local var_71_10 = arg_71_10.proximite_enemies

		for iter_71_0 = 0, var_0_66 - 1 do
			local var_71_11 = (iter_71_0 == 0 or iter_71_0 == var_0_66 - 1) and 1 or 2
			local var_71_12 = 1

			for iter_71_1 = 1, var_71_11 do
				local var_71_13 = math.pi * (iter_71_0 / (var_0_66 - 1)) * var_71_12
				local var_71_14 = Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), var_71_13), var_71_9)
				local var_71_15 = Vector3(arg_71_5, arg_71_6, var_71_2) + var_71_14 * var_71_8
				local var_71_16 = 2
				local var_71_17 = 2
				local var_71_18, var_71_19 = GwNavQueries.triangle_from_position(arg_71_0, var_71_15, var_71_16, var_71_17)

				if var_71_18 then
					var_71_15.z = var_71_19

					if GwNavQueries.raycango(arg_71_0, arg_71_2, var_71_15, arg_71_1) then
						if not var_0_65(arg_71_10, arg_71_2, var_71_15, arg_71_4, var_71_10) and not var_0_12(arg_71_11, var_71_15, arg_71_4) then
							var_71_6 = var_71_15
						end

						var_71_7 = var_71_15
					end

					var_71_12 = var_71_12 * -1
				end

				if var_71_6 then
					return var_71_6
				end
			end
		end

		return var_71_7
	end
end

local var_0_70 = {
	0,
	-1,
	1
}

local function var_0_71(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6, arg_72_7, arg_72_8, arg_72_9, arg_72_10, arg_72_11)
	local var_72_0 = arg_72_3 * 0.5
	local var_72_1 = arg_72_2 - Vector3(arg_72_5, arg_72_6, arg_72_7 - var_72_0)
	local var_72_2 = Quaternion.right(arg_72_8)
	local var_72_3 = Vector3.dot(var_72_2, var_72_1)
	local var_72_4 = Vector3.dot(Quaternion.forward(arg_72_8), var_72_1)
	local var_72_5 = Vector3.dot(Quaternion.up(arg_72_8), var_72_1)
	local var_72_6 = arg_72_9.x + arg_72_4
	local var_72_7 = arg_72_9.y + arg_72_4
	local var_72_8 = arg_72_9.z + var_72_0

	if var_72_6 < var_72_3 or var_72_3 < -var_72_6 or var_72_7 < var_72_4 or var_72_4 < -var_72_7 or var_72_8 < var_72_5 or var_72_5 < -var_72_8 then
		return
	end

	local var_72_9 = Managers.state.entity:system("area_damage_system")
	local var_72_10 = 2
	local var_72_11 = 2
	local var_72_12 = var_72_3 == 0 and 1 - math.random(0, 1) * 2 or math.sign(var_72_3)
	local var_72_13
	local var_72_14
	local var_72_15 = var_72_6
	local var_72_16 = arg_72_10.proximite_enemies

	for iter_72_0 = 1, 2 do
		for iter_72_1 = 1, #var_0_70 do
			local var_72_17 = var_0_70[iter_72_1] * math.pi * 0.25
			local var_72_18 = 1 / math.cos(var_72_17)
			local var_72_19 = arg_72_2 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), var_72_17), var_72_2) * var_72_18 * (var_72_12 * var_72_15)
			local var_72_20, var_72_21 = GwNavQueries.triangle_from_position(arg_72_0, var_72_19, var_72_10, var_72_11)

			if var_72_20 then
				var_72_19.z = var_72_21
			end

			if var_72_20 and GwNavQueries.raycango(arg_72_0, arg_72_2, var_72_19, arg_72_1) then
				var_72_14 = var_72_19

				if not var_72_9:is_position_in_liquid(var_72_19, BotNavTransitionManager.NAV_COST_MAP_LAYERS) then
					if not var_0_65(arg_72_10, arg_72_2, var_72_19, arg_72_4, var_72_16) and not var_0_12(arg_72_11, var_72_19, arg_72_4) then
						var_72_13 = var_72_19
					end

					var_72_14 = var_72_19
				end
			end

			if var_72_13 then
				break
			end
		end

		if var_72_13 then
			break
		end

		var_72_12 = -var_72_12
	end

	return var_72_13 or var_72_14
end

function AIBotGroupSystem.aoe_threat_created(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6)
	local var_73_0 = Managers.time:time("game")
	local var_73_1 = Managers.state.entity:system("ai_system"):nav_world()
	local var_73_2 = Managers.state.bot_nav_transition:traverse_logic()
	local var_73_3

	if arg_73_2 == "oobb" then
		var_73_3 = var_0_71
	elseif arg_73_2 == "cylinder" then
		var_73_3 = var_0_68
	elseif arg_73_2 == "sphere" then
		var_73_3 = var_0_69
	end

	local var_73_4 = var_73_0 + arg_73_5
	local var_73_5 = {
		pos = Vector3Box(arg_73_1),
		rot = arg_73_4 and QuaternionBox(arg_73_4) or nil,
		size = type(arg_73_3) == "number" and arg_73_3 or Vector3Box(arg_73_3),
		shape = arg_73_2,
		expires = var_73_4,
		source = arg_73_6
	}
	local var_73_6 = arg_73_0._existing_bot_threats
	local var_73_7 = arg_73_1.x
	local var_73_8 = arg_73_1.y
	local var_73_9 = arg_73_1.z
	local var_73_10 = arg_73_0._bot_ai_data

	for iter_73_0 = 1, #var_73_10 do
		local var_73_11 = var_73_10[iter_73_0]

		for iter_73_1, iter_73_2 in pairs(var_73_11) do
			local var_73_12 = iter_73_2.aoe_threat
			local var_73_13 = var_73_3(var_73_1, var_73_2, Unit.local_position(iter_73_1, 0), var_0_8, var_0_7, var_73_7, var_73_8, var_73_9, arg_73_4, arg_73_3, var_0_11[iter_73_1], var_73_6)

			if var_73_13 then
				var_73_12.expires = math.max(var_73_12.expires, var_73_4)

				var_73_12.escape_to:store(var_73_13)
			end
		end
	end

	table.insert(var_73_6, var_73_5)

	return var_73_5
end

function AIBotGroupSystem.remove_threat(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0._existing_bot_threats
	local var_74_1 = table.find(var_74_0, arg_74_1)

	if var_74_1 then
		table.swap_delete(var_74_0, var_74_1)
	end

	local var_74_2 = 0

	for iter_74_0 = 1, #var_74_0 do
		local var_74_3 = var_74_0[iter_74_0].expires

		if var_74_3 ~= math.huge then
			var_74_2 = math.max(var_74_2, var_74_3)
		end
	end

	local var_74_4 = arg_74_0._bot_ai_data

	for iter_74_1 = 1, #var_74_4 do
		local var_74_5 = var_74_4[iter_74_1]

		for iter_74_2, iter_74_3 in pairs(var_74_5) do
			local var_74_6 = iter_74_3.aoe_threat

			if var_74_6.expires > 0 then
				var_74_6.expires = var_74_2
			elseif next(var_74_0) then
				var_74_6.expires = math.huge
			end
		end
	end
end

local var_0_72 = {
	abort_pickup_assigned_to_other = {
		default = {
			"bot_command_generic_abort_pickup_assigned_to_other_01"
		}
	},
	acknowledge_pickup = {
		default = {
			"bot_command_generic_acknowledge_pickup_01"
		}
	},
	acknowledge_ammo = {
		default = {
			"bot_command_generic_acknowledge_ammo_01"
		}
	},
	has_full_ammo = {
		default = {
			"bot_command_generic_has_full_ammo_01"
		}
	},
	already_picking_up = {
		default = {
			"bot_command_generic_already_picking_up_01"
		}
	},
	already_have_item = {
		default = {
			"bot_command_generic_already_have_item_01"
		}
	},
	acknowledge_drop = {
		default = {
			"bot_command_generic_acknowledge_drop_01"
		}
	}
}

function AIBotGroupSystem._chat_message(arg_75_0, arg_75_1, arg_75_2, arg_75_3, ...)
	local var_75_0 = Managers.player:owner(arg_75_1)
	local var_75_1 = SPProfiles[var_75_0:profile_index()].display_name
	local var_75_2 = var_0_72[arg_75_3]
	local var_75_3 = var_75_2[var_75_1] or var_75_2.default
	local var_75_4 = var_75_3[Math.random(1, #var_75_3)]
	local var_75_5 = true
	local var_75_6 = true
	local var_75_7 = FrameTable.alloc_table()

	table.append_varargs(var_75_7, ...)

	local var_75_8 = 1
	local var_75_9
	local var_75_10 = Managers.mechanism:game_mechanism()

	if var_75_10.get_chat_channel then
		local var_75_11 = arg_75_2:network_id()

		var_75_8, var_75_9 = var_75_10:get_chat_channel(var_75_11, false)
	end

	Managers.chat:send_chat_message(var_75_8, var_75_0:local_player_id(), var_75_4, var_75_5, var_75_7, var_75_6, nil, var_75_9)
end
