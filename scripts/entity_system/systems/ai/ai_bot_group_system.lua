-- chunkname: @scripts/entity_system/systems/ai/ai_bot_group_system.lua

require("scripts/settings/player_bots_settings")

AIBotGroupSystem = class(AIBotGroupSystem, ExtensionSystemBase)

local tbl = {
	"AIBotGroupExtension",
	"BotBreakableExtension"
}
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 5
local num_6 = 6
local num_7 = 1.25
local num_8 = 1.8

AIBotGroupExtension = class(AIBotGroupExtension)

AIBotGroupExtension.init = function (arg_1_0)
	-- function 1
	return
end

AIBotGroupExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

local num_9 = 0.05

AIBotGroupExtension.set_hold_position = function (self, arg_3_1, arg_3_2)
	-- function 3
	local data = self.data

	if not arg_3_1 then
		data.hold_position_max_distance_sq, data.hold_position = math.max(arg_3_2, num_9)^2, Vector3Box(arg_3_1)
	else
		data.hold_position = nil
		data.hold_position_max_distance_sq = nil
	end
end

AIBotGroupExtension.get_hold_position = function (self)
	-- function 4
	local data = self.data

	if not data.hold_position then
		local unbox = data.hold_position:unbox()
		local hold_position_max_distance_sq = data.hold_position_max_distance_sq

		return unbox, hold_position_max_distance_sq
	else
		return nil, nil
	end
end

local num_10 = -0.2
local BLACKBOARDS = BLACKBOARDS

AIBotGroupSystem.init = function (self, arg_5_1, arg_5_2)
	-- function 5
	arg_5_1.entity_manager:register_system(self, arg_5_2, tbl)

	local world = arg_5_1.world

	self._is_server = arg_5_1.is_server
	self._world = world
	self._physics_world = World.physics_world(world)
	self._unit_storage = arg_5_1.unit_storage
	self._network_transmit = arg_5_1.network_transmit
	self._total_num_bots = 0
	self._bot_breakables_broadphase = Broadphase(2, 60)

	if not self._is_server then
		local count = #Managers.state.side:sides()

		self._last_move_target_unit = Script.new_array(count)
		self._last_move_target_rotations = {}
		self._bot_threat_queue = {}

		local tbl_2 = {}

		for k, v in pairs(AllPickups) do
			if not v.bots_mule_pickup then
				local slot_name = v.slot_name
				local var_5_4 = tbl_2[slot_name]

				var_5_4 = var_5_4 or {}
				tbl_2[slot_name] = var_5_4
			end
		end

		self._bot_ai_data = Script.new_array(count)
		self._bot_ai_data_lookup = {}
		self._old_priority_targets = Script.new_array(count)
		self._available_mule_pickups = Script.new_array(count)
		self._available_health_pickups = Script.new_array(count)
		self._num_bots = Script.new_array(count)

		for k_2 = 1, count do
			self._bot_ai_data[k_2] = {}
			self._old_priority_targets[k_2] = {}
			self._available_mule_pickups[k_2] = table.clone(tbl_2)
			self._available_health_pickups[k_2] = {}
			self._num_bots[k_2] = 0
		end

		self._existing_bot_threats = {}
		self._urgent_targets = {}
		self._ally_needs_aid_priority = {}
		self._timestamped_positions = {}
		self._disallowed_tag_layers = {
			bot_poison_wind = true,
			barrel_explosion = true
		}
		self._t = 0
		self._in_carry_event = Script.new_array(count)

		local up = Vector3.up()

		self._left_vectors_outside_volume = {
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 1 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 4 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 7 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 0 / 8)))
		}
		self._right_vectors_outside_volume = {
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 1 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 4 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 7 / 8)))
		}
		self._left_vectors = {
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 0.5))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 7 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 1 / 8)))
		}
		self._right_vectors = {
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 0.5))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 7 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 1 / 8)))
		}
		self._last_key_in_available_pickups = nil
		self._update_pickups_at = -math.huge
		self._used_covers = {}
		self._pathing_points = {}

		local tbl_3 = {
			"rpc_bot_create_threat_oobb"
		}

		for k_3, v_2 in pairs(AIBotGroupSystem.bot_orders) do
			tbl_3[#tbl_3 + 1] = v_2.rpc_type
		end

		local network_event_delegate = arg_5_1.network_event_delegate

		self.network_event_delegate = network_event_delegate

		network_event_delegate:register(self, unpack(tbl_3))
	end
end

AIBotGroupSystem.destroy = function (self)
	-- function 6
	if not self._is_server then
		self.network_event_delegate:unregister(self)
	end
end

AIBotGroupSystem.on_add_extension = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if arg_7_3 == "BotBreakableExtension" then
		local str = "rp_center"
		local node

		if not Unit.has_node(arg_7_2, str) then
			node = Unit.node(arg_7_2, str)

			if not node then
				-- Nothing
			end
		end

		node = 0

		::label_7_0::

		local world_position = Unit.world_position(arg_7_2, node)

		Broadphase.add(self._bot_breakables_broadphase, arg_7_2, world_position, 1)
		ScriptUnit.add_extension(nil, arg_7_2, "AIBotGroupExtension", self.NAME)

		return {}
	else
		local initial_inventory = arg_7_4.initial_inventory
		local side = arg_7_4.side
		local tbl = {
			priority_target_distance = math.huge,
			priority_targets = {},
			nav_point_utility = {},
			blackboard = BLACKBOARDS[arg_7_2],
			aoe_threat = {
				expires = -math.huge,
				escape_to = Vector3Box()
			},
			previous_bot_breakables = {},
			current_bot_breakables = {},
			pickup_orders = {},
			side = side
		}
		local str_2 = "slot_potion"
		local var_7_7 = initial_inventory[str_2]
		local var_7_8 = rawget(ItemMasterList, var_7_7)

		if not var_7_8 then
			local template = var_7_8.template

			template = template or var_7_8.temporary_template

			if not WeaponUtils.get_weapon_template(template).is_grimoire then
				local str_3 = "grimoire"

				tbl.pickup_orders[str_2] = {
					pickup_name = str_3
				}
			end
		end

		local side_id = side.side_id

		self._bot_ai_data_lookup[arg_7_2] = tbl
		self._bot_ai_data[side_id][arg_7_2] = tbl

		local add_extension = ScriptUnit.add_extension(nil, arg_7_2, "AIBotGroupExtension", self.NAME)

		add_extension.data = tbl
		self._num_bots[side_id] = self._num_bots[side_id] + 1
		self._total_num_bots = self._total_num_bots + 1

		return add_extension
	end
end

local function fn(self, arg_8_1, arg_8_2)
	-- function 8
	for i = 1, #self do
		local var_8_0 = self[i]
		local unbox = var_8_0.pos:unbox()
		local rot = var_8_0.rot

		rot = not rot and var_8_0.rot:unbox()

		local shape = var_8_0.shape
		local var_8_4
		local var_8_5

		if shape == "sphere" then
			var_8_4 = var_8_0.size
			var_8_5 = var_8_4 + arg_8_2
		elseif shape == "cylinder" then
			var_8_4 = var_8_0.size:unbox()
			var_8_5 = Vector3(math.max(var_8_4[1] - arg_8_2, 0), var_8_4[2] + arg_8_2, var_8_4[3] + arg_8_2)
		else
			var_8_4 = var_8_0.size:unbox()
			var_8_5 = var_8_4 + Vector3(arg_8_2, arg_8_2, arg_8_2)
		end

		local var_8_6

		if shape == "oobb" then
			local from_quaternion_position = Matrix4x4.from_quaternion_position(rot, unbox)

			var_8_6 = math.point_is_inside_oobb(arg_8_1, from_quaternion_position, var_8_5)
		elseif shape == "cylinder" then
			var_8_6 = math.point_is_inside_cylinder(arg_8_1, unbox, var_8_4[1], var_8_4[2], var_8_4[3])
		elseif shape == "sphere" then
			var_8_6 = Vector3.distance_squared(arg_8_1, unbox) < var_8_4^2
		end

		if not var_8_6 then
			return true
		end
	end

	return false
end

AIBotGroupSystem.is_inside_aoe_threat = function (self, arg_9_1)
	-- function 9
	return fn(self._existing_bot_threats, arg_9_1, num_7)
end

AIBotGroupSystem.extensions_ready = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if arg_10_3 ~= "BotBreakableExtension" then
		arg_10_0._bot_ai_data_lookup[arg_10_2].status_extension = ScriptUnit.extension(arg_10_2, "status_system")
	end
end

AIBotGroupSystem.on_remove_extension = function (self, arg_11_1, arg_11_2)
	-- function 11
	if arg_11_2 == "AIBotGroupExtension" then
		local side_id = self._bot_ai_data_lookup[arg_11_1].side.side_id

		self._bot_ai_data_lookup[arg_11_1] = nil
		self._bot_ai_data[side_id][arg_11_1] = nil
		self._num_bots[side_id] = self._num_bots[side_id] - 1
		self._total_num_bots = self._total_num_bots - 1
	end

	ScriptUnit.remove_extension(arg_11_1, self.NAME)
end

AIBotGroupSystem.hot_join_sync = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	return
end

AIBotGroupSystem.set_in_carry_event = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local side_id = arg_13_2.side_id

	arg_13_0._in_carry_event[side_id] = arg_13_1
end

AIBotGroupSystem.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not (not self._is_server and self._total_num_bots ~= 0) then
		return
	end

	self._t = arg_14_2

	local dt = arg_14_1.dt
	local _existing_bot_threats = self._existing_bot_threats

	for i = #_existing_bot_threats, 1, -1 do
		if arg_14_2 > _existing_bot_threats[i].expires then
			self:remove_threat(_existing_bot_threats[i])
		end
	end

	local _bot_threat_queue = self._bot_threat_queue

	for j = 1, #_bot_threat_queue do
		local var_14_3 = _bot_threat_queue[j]
		local unbox = var_14_3[num]:unbox()
		local var_14_5 = var_14_3[num_2]
		local unbox_2 = var_14_3[num_3]:unbox()
		local unbox_3 = var_14_3[num_4]:unbox()
		local var_14_8 = var_14_3[num_5]
		local var_14_9 = var_14_3[num_6]

		self:aoe_threat_created(unbox, var_14_5, unbox_2, unbox_3, var_14_8, var_14_9)

		_bot_threat_queue[j] = nil
	end

	self:_update_proximity_bot_breakables(arg_14_2)
	self:_update_urgent_targets(dt, arg_14_2)
	self:_update_opportunity_targets(dt, arg_14_2)
	self:_update_existence_checks(dt, arg_14_2)
	self:_update_move_targets(dt, arg_14_2)
	self:_update_priority_targets(dt, arg_14_2)
	self:_update_pickups(dt, arg_14_2)
	self:_update_ally_needs_aid_priority()
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

AIBotGroupSystem.order = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local var_15_0 = AIBotGroupSystem.bot_orders[arg_15_1]

	if not self._is_server then
		self[var_15_0.function_name](self, arg_15_2, arg_15_3, arg_15_4)
	else
		local rpc_type = var_15_0.rpc_type
		local var_15_2

		if rpc_type == "rpc_bot_unit_order" then
			var_15_2 = self._unit_storage:go_id(arg_15_3)
		elseif rpc_type == "rpc_bot_lookup_order" then
			var_15_2 = NetworkLookup[var_15_0.lookup][arg_15_3]
		else
			ferror("Incorrect rpc_type %q.", rpc_type)
		end

		if not Managers.state.network:game() then
			local var_15_3 = NetworkLookup.bot_orders[arg_15_1]
			local go_id = self._unit_storage:go_id(arg_15_2)

			self._network_transmit:send_rpc_server(rpc_type, var_15_3, go_id, var_15_2, arg_15_4:network_id(), arg_15_4:local_player_id())
		end
	end
end

AIBotGroupSystem.get_pickup_order = function (self, arg_16_1, arg_16_2)
	-- function 16
	return self._bot_ai_data_lookup[arg_16_1].pickup_orders[arg_16_2]
end

AIBotGroupSystem.get_ammo_pickup_order_unit = function (self, arg_17_1)
	-- function 17
	return self._bot_ai_data_lookup[arg_17_1].ammo_pickup_order_unit
end

AIBotGroupSystem.has_pending_pickup_order = function (self, arg_18_1)
	-- function 18
	local pickup_orders = self._bot_ai_data_lookup[arg_18_1].pickup_orders

	for k, v in pairs(pickup_orders) do
		if not v.unit then
			return true
		end
	end

	return false
end

AIBotGroupSystem.rpc_bot_unit_order = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	-- function 19
	local var_19_0 = NetworkLookup.bot_orders[arg_19_2]
	local unit = self._unit_storage:unit(arg_19_3)
	local unit_2 = self._unit_storage:unit(arg_19_4)
	local player = Managers.player:player(arg_19_5, arg_19_6)

	if not Unit.alive(unit) and not Unit.alive(unit_2) and not player then
		self:order(var_19_0, unit, unit_2, player)
	end
end

AIBotGroupSystem.rpc_bot_lookup_order = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	-- function 20
	local var_20_0 = NetworkLookup.bot_orders[arg_20_2]
	local unit = self._unit_storage:unit(arg_20_3)
	local var_20_2 = NetworkLookup[AIBotGroupSystem.bot_orders[var_20_0].lookup][arg_20_4]
	local player = Managers.player:player(arg_20_5, arg_20_6)

	if not Unit.alive(unit) and not player then
		self:order(var_20_0, unit, var_20_2, player)
	end
end

AIBotGroupSystem.queue_aoe_threat = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	-- function 21
	if not arg_21_1 and not arg_21_2 and not arg_21_3 and not arg_21_4 and not arg_21_5 then
		local _bot_threat_queue = self._bot_threat_queue
		local tbl = {
			Vector3Box(arg_21_1),
			arg_21_2,
			Vector3Box(arg_21_3),
			QuaternionBox(arg_21_4),
			arg_21_5,
			arg_21_6
		}

		_bot_threat_queue[#_bot_threat_queue + 1] = tbl
	end
end

AIBotGroupSystem.rpc_bot_create_threat_oobb = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	self:queue_aoe_threat(arg_22_2, "oobb", arg_22_4, arg_22_3, arg_22_5, "RPC")
end

AIBotGroupSystem._order_ammo_pickup = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local var_23_0 = self._bot_ai_data_lookup[arg_23_1]

	if not var_23_0 then
		local blackboard = var_23_0.blackboard

		if not blackboard.inventory_extension:has_full_ammo() then
			self:_chat_message(arg_23_1, arg_23_3, "has_full_ammo")
		else
			local time = Managers.time:time("game")

			blackboard.ammo_pickup = arg_23_2
			blackboard.ammo_dist = Vector3.distance(POSITION_LOOKUP[arg_23_1], POSITION_LOOKUP[arg_23_2])
			blackboard.ammo_pickup_valid_until = time + 5
			blackboard.needs_target_position_refresh = true
			var_23_0.ammo_pickup_order_unit = arg_23_2

			self:_chat_message(arg_23_1, arg_23_3, "acknowledge_ammo")
		end
	else
		local get_party_from_player_id = Managers.party:get_party_from_player_id(arg_23_3:network_id(), arg_23_3:local_player_id())
		local side_id = Managers.state.side.side_by_party[get_party_from_player_id].side_id
		local var_23_5 = self._bot_ai_data[side_id]

		for k, v in pairs(var_23_5) do
			if v.ammo_pickup_order_unit == arg_23_2 then
				local blackboard_2 = v.blackboard

				self:_chat_message(k, arg_23_3, "abort_pickup_assigned_to_other")

				v.ammo_pickup_order_unit = nil
				blackboard_2.ammo_pickup = nil
				blackboard_2.needs_target_position_refresh = true
			end
		end
	end
end

AIBotGroupSystem._order_pickup = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	if not self._is_server then
		local extension = ScriptUnit.extension(arg_24_2, "pickup_system")
		local get_pickup_settings = extension:get_pickup_settings()
		local slot_name = get_pickup_settings.slot_name

		if get_pickup_settings.type == "ammo" then
			self:_order_ammo_pickup(arg_24_1, arg_24_2, arg_24_3)
		elseif not slot_name then
			local var_24_3 = self._bot_ai_data_lookup[arg_24_1]

			if not var_24_3 then
				local extension_2 = ScriptUnit.extension(arg_24_1, "inventory_system")
				local get_slot_data = extension_2:get_slot_data(slot_name)
				local can_store_additional_item = extension_2:can_store_additional_item(slot_name)

				if not (not get_slot_data and can_store_additional_item) then
					local get_item_template = extension_2:get_item_template(get_slot_data)
					local var_24_8

					if extension.pickup_name == "grimoire" then
						var_24_8 = get_item_template.is_grimoire
					else
						var_24_8 = not get_item_template.pickup_data and get_item_template.pickup_data.pickup_name == extension.pickup_name
					end

					if not var_24_8 then
						self:_chat_message(arg_24_1, arg_24_3, "already_have_item", Unit.get_data(arg_24_2, "interaction_data", "hud_description"))

						return
					end
				end

				local side_id = var_24_3.side.side_id
				local var_24_10 = self._bot_ai_data[side_id]

				for k, v in pairs(var_24_10) do
					local var_24_11 = v.pickup_orders[slot_name]

					if not (not var_24_11 and var_24_11.unit ~= arg_24_2) then
						if k == arg_24_1 then
							self:_chat_message(arg_24_1, arg_24_3, "already_picking_up")

							return
						end

						self:_chat_message(k, arg_24_3, "abort_pickup_assigned_to_other")

						v.pickup_orders[slot_name] = nil
						v.blackboard.needs_target_position_refresh = true
					end
				end

				self:_chat_message(arg_24_1, arg_24_3, "acknowledge_pickup", Unit.get_data(arg_24_2, "interaction_data", "hud_description"))

				var_24_3.pickup_orders[slot_name] = {
					unit = arg_24_2,
					pickup_name = extension.pickup_name
				}
				var_24_3.blackboard.needs_target_position_refresh = true
			else
				local get_party_from_player_id = Managers.party:get_party_from_player_id(arg_24_3:network_id(), arg_24_3:local_player_id())
				local side_id_2 = Managers.state.side.side_by_party[get_party_from_player_id].side_id
				local var_24_14 = self._bot_ai_data[side_id_2]

				for k_2, v_2 in pairs(var_24_14) do
					local var_24_15 = v_2.pickup_orders[slot_name]

					if not (not var_24_15 and var_24_15.unit ~= arg_24_2) then
						self:_chat_message(k_2, arg_24_3, "abort_pickup_assigned_to_other")

						v_2.pickup_orders[slot_name] = nil
						v_2.blackboard.needs_target_position_refresh = true
					end
				end
			end
		end
	end
end

AIBotGroupSystem._order_drop = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	if not self._is_server then
		local var_25_0 = self._bot_ai_data_lookup[arg_25_1]

		if not var_25_0 then
			local slot_name = AllPickups[arg_25_2].slot_name
			local var_25_2 = var_25_0.pickup_orders[slot_name]

			if not (not var_25_2 and var_25_2.pickup_name ~= arg_25_2) then
				var_25_0.pickup_orders[slot_name] = nil

				self:_chat_message(arg_25_1, arg_25_3, "acknowledge_drop")
			end
		end
	end
end

local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}
local tbl_7 = {}
local num_11 = 3

AIBotGroupSystem._update_existence_checks = function (self, arg_26_1, arg_26_2)
	-- function 26
	local conflict = Managers.state.conflict
	local flag = conflict:count_units_by_breed("chaos_vortex_sorcerer") > 0
	local flag_2 = conflict:count_units_by_breed("chaos_vortex") > 0
	local _bot_ai_data = self._bot_ai_data

	for i = 1, #_bot_ai_data do
		local var_26_4 = _bot_ai_data[i]

		for k, v in pairs(var_26_4) do
			local blackboard = v.blackboard

			blackboard.ai_extension:set_stay_near_player(flag, num_11)

			blackboard.vortex_exist = flag_2
		end
	end
end

local num_12 = 1
local num_13 = 20

AIBotGroupSystem._update_player_timestamped_positions = function (self, arg_27_1, arg_27_2)
	-- function 27
	for i = 1, #arg_27_2 do
		local var_27_0 = arg_27_2[i]
		local var_27_1 = self._timestamped_positions[var_27_0]
		local var_27_2 = POSITION_LOOKUP[var_27_0]

		if not var_27_1 and not var_27_2 then
			if Vector3.distance_squared(var_27_1.position:unbox(), var_27_2) > num_12^2 then
				var_27_1.position = Vector3Box(var_27_2)
				var_27_1.timestamp = arg_27_1
				var_27_1.afk = false
			elseif arg_27_1 > var_27_1.timestamp + num_13 then
				var_27_1.afk = true
			end

			self._timestamped_positions[var_27_0] = var_27_1
		elseif not var_27_2 then
			self._timestamped_positions[var_27_0] = {
				afk = false,
				position = Vector3Box(var_27_2),
				timestamp = arg_27_1
			}
		end
	end
end

AIBotGroupSystem._update_move_targets = function (self, arg_28_1, arg_28_2)
	-- function 28
	local side = Managers.state.side
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local bot_follow_disabled = Managers.state.game_mode:game_mode().bot_follow_disabled
	local _bot_ai_data = self._bot_ai_data
	local _num_bots = self._num_bots
	local _in_carry_event = self._in_carry_event
	local _last_move_target_unit = self._last_move_target_unit

	for i = 1, #_bot_ai_data do
		repeat
			local get_side = side:get_side(i)
			local var_28_8 = _bot_ai_data[i]
			local PLAYER_UNITS = get_side.PLAYER_UNITS

			for j = 1, #PLAYER_UNITS do
				local var_28_10 = PLAYER_UNITS[j]
				local extension = ScriptUnit.extension(var_28_10, "status_system")

				if not extension.near_vortex then
					if not not extension:is_disabled() then
						tbl_4[#tbl_4 + 1] = var_28_10
					else
						tbl_5[#tbl_5 + 1] = var_28_10
					end
				end
			end

			local count = #tbl_4
			local count_2 = #tbl_5

			if not (count ~= 0 or not (count_2 > 0)) then
				tbl_5, tbl_4 = tbl_4, tbl_5
				count = count_2
			end

			self:_update_player_timestamped_positions(arg_28_2, tbl_4)

			local var_28_14
			local var_28_15 = _num_bots[i]
			local var_28_16 = _in_carry_event[i]
			local var_28_17 = _last_move_target_unit[i]

			if not (count == 0 or var_28_15 ~= 0) then
				var_28_14 = nil
			elseif count >= 3 then
				if not var_28_16 then
					local var_28_18, var_28_19 = next(var_28_8)

					var_28_14 = self:_find_most_lonely_move_target(tbl_4, var_28_18)
				else
					var_28_14 = self:_find_least_lonely_move_target(tbl_4, var_28_17)
				end
			elseif count ~= 2 or var_28_15 ~= 2 or not var_28_16 then
				local var_28_20 = tbl_7

				for k = 1, count do
					local var_28_21 = tbl_4[k]
					local var_28_22 = POSITION_LOOKUP[var_28_21]
					local _selected_unit_is_in_disallowed_nav_tag_volume, var_28_24 = self:_selected_unit_is_in_disallowed_nav_tag_volume(nav_world, var_28_22)
					local var_28_25

					if not _selected_unit_is_in_disallowed_nav_tag_volume then
						local _find_origin = self:_find_origin(nav_world, var_28_21)

						var_28_25 = self:_find_destination_points_outside_volume(nav_world, var_28_22, var_28_24, _find_origin, 1)
					else
						local _find_cluster_position, var_28_28 = self:_find_cluster_position(nav_world, var_28_21)

						var_28_25 = self:_find_destination_points(nav_world, _find_cluster_position, var_28_28, 1)
					end

					table.append(var_28_20, var_28_25)
				end

				self:_assign_destination_points(var_28_8, var_28_20, nil, tbl_4)
				table.clear(tbl_4)
				table.clear(var_28_20)

				break
			else
				local var_28_29 = Vector3(0, 0, 0)

				for k_2, v in pairs(var_28_8) do
					var_28_29 = var_28_29 + POSITION_LOOKUP[k_2]
				end

				local num = var_28_29 / var_28_15

				var_28_14 = self:_find_closest_move_target(tbl_4, var_28_17, num)
			end

			if not (not var_28_14 and script_data.bots_dont_follow or bot_follow_disabled) then
				self._last_move_target_unit[i] = var_28_14

				local var_28_31 = POSITION_LOOKUP[var_28_14]
				local _selected_unit_is_in_disallowed_nav_tag_volume_2, var_28_33 = self:_selected_unit_is_in_disallowed_nav_tag_volume(nav_world, var_28_31)
				local var_28_34

				if not _selected_unit_is_in_disallowed_nav_tag_volume_2 then
					local _find_origin_2 = self:_find_origin(nav_world, var_28_14)

					var_28_34 = self:_find_destination_points_outside_volume(nav_world, var_28_31, var_28_33, _find_origin_2, var_28_15)
				else
					local _find_cluster_position_2, var_28_37 = self:_find_cluster_position(nav_world, var_28_14)

					var_28_34 = self:_find_destination_points(nav_world, _find_cluster_position_2, var_28_37, var_28_15)
				end

				self:_assign_destination_points(var_28_8, var_28_34, var_28_14)
			else
				for k_3, v_2 in pairs(var_28_8) do
					v_2.follow_position = nil
					v_2.follow_unit = nil
				end
			end

			table.clear(tbl_4)
			table.clear(tbl_5)
		until true
	end
end

AIBotGroupSystem._selected_unit_is_in_disallowed_nav_tag_volume = function (self, arg_29_1, arg_29_2)
	-- function 29
	local tag_volumes_from_position = GwNavQueries.tag_volumes_from_position(arg_29_1, arg_29_2, 2, 2)

	if not tag_volumes_from_position then
		local navtag = GwNavTagVolume.navtag
		local nav_tag_volume = GwNavQueries.nav_tag_volume
		local system = Managers.state.entity:system("volume_system")
		local _disallowed_tag_layers = self._disallowed_tag_layers
		local nav_tag_volume_count = GwNavQueries.nav_tag_volume_count(tag_volumes_from_position)

		for i = 1, nav_tag_volume_count do
			local var_29_6 = nav_tag_volume(tag_volumes_from_position, i)
			local var_29_7, var_29_8, var_29_9, var_29_10, var_29_11 = navtag(var_29_6)
			local var_29_12 = LAYER_ID_MAPPING[var_29_9]
			local get_volume_mapping_from_lookup_id = system:get_volume_mapping_from_lookup_id(var_29_11)

			if not get_volume_mapping_from_lookup_id and not _disallowed_tag_layers[var_29_12] then
				return true, get_volume_mapping_from_lookup_id
			end
		end

		GwNavQueries.destroy_query_dynamic_output(tag_volumes_from_position)

		return false
	else
		return false
	end
end

local num_14 = 9

AIBotGroupSystem._find_closest_move_target = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local var_30_0
	local huge = math.huge
	local tbl = {}

	for i = 1, #arg_30_1 do
		local var_30_3 = arg_30_1[i]

		if not (not self._timestamped_positions[var_30_3] and self._timestamped_positions[var_30_3].afk) then
			tbl[#tbl + 1] = var_30_3
		end
	end

	if #tbl == 0 then
		tbl = arg_30_1
	end

	for j = 1, #tbl do
		local var_30_4 = tbl[j]
		local distance_squared = Vector3.distance_squared(arg_30_3, POSITION_LOOKUP[var_30_4])

		if var_30_4 == arg_30_2 then
			distance_squared = distance_squared - num_14
		end

		if distance_squared < huge then
			huge = distance_squared
			var_30_0 = j
		end
	end

	return tbl[var_30_0]
end

local num_15 = 25

AIBotGroupSystem._find_least_lonely_move_target = function (arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	local count = #arg_31_1

	for i = 1, count do
		local var_31_1 = arg_31_1[i]

		tbl_6[i] = POSITION_LOOKUP[var_31_1]
	end

	local var_31_2
	local huge = math.huge
	local count_2 = #tbl_6

	for j = 1, count_2 do
		local var_31_5 = tbl_6[j]
		local var_31_6

		if arg_31_1[j] == arg_31_2 then
			var_31_6 = -num_15
		else
			var_31_6 = 0
		end

		for k = 1, count_2 do
			local var_31_7 = tbl_6[k]

			var_31_6 = var_31_6 + Vector3.distance_squared(var_31_5, var_31_7)
		end

		if var_31_6 < huge then
			var_31_2 = j
			huge = var_31_6
		end
	end

	table.clear(tbl_6)

	return arg_31_1[var_31_2]
end

local num_16 = 3
local num_17 = 900

AIBotGroupSystem._find_most_lonely_move_target = function (arg_32_0, arg_32_1, arg_32_2)
	-- function 32
	local count = #arg_32_1

	for i = 1, count do
		local var_32_1 = arg_32_1[i]

		tbl_6[i] = POSITION_LOOKUP[var_32_1]
	end

	local var_32_2
	local num = -math.huge
	local var_32_4 = POSITION_LOOKUP[arg_32_2]
	local count_2 = #tbl_6

	for j = 1, count_2 do
		local var_32_6 = tbl_6[j]
		local var_32_7
		local distance_squared = Vector3.distance_squared(var_32_6, var_32_4)

		if distance_squared > num_17 then
			var_32_7 = -distance_squared * num_16
		else
			var_32_7 = 0
		end

		for k = 1, count_2 do
			local var_32_9 = tbl_6[k]

			var_32_7 = var_32_7 + Vector3.distance_squared(var_32_6, var_32_9)
		end

		if num < var_32_7 then
			var_32_2 = j
			num = var_32_7
		end
	end

	table.clear(tbl_6)

	return arg_32_1[var_32_2]
end

AIBotGroupSystem._find_origin = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local var_33_0 = POSITION_LOOKUP[arg_33_2]
	local triangle_from_position, var_33_2 = GwNavQueries.triangle_from_position(arg_33_1, var_33_0, 5, 5)
	local var_33_3

	if not triangle_from_position then
		var_33_3 = Vector3(var_33_0.x, var_33_0.y, var_33_2)
	else
		var_33_3 = GwNavQueries.inside_position_from_outside_position(arg_33_1, var_33_0, 5, 5, 5, 0.5)
	end

	if var_33_3 == nil then
		var_33_3 = var_33_0
	end

	return var_33_3
end

AIBotGroupSystem._find_cluster_position = function (self, arg_34_1, arg_34_2)
	-- function 34
	local extension = ScriptUnit.extension(arg_34_2, "locomotion_system")
	local current_velocity = extension:current_velocity()
	local var_34_2

	if Vector3.length_squared(current_velocity) < 0.01 then
		var_34_2 = Vector3(0, 0, 0)
	else
		var_34_2 = extension:average_velocity()
	end

	local var_34_3 = POSITION_LOOKUP[arg_34_2]
	local last_position_onground_on_navmesh = ScriptUnit.extension(arg_34_2, "whereabouts_system"):last_position_onground_on_navmesh()
	local var_34_5

	if not (not last_position_onground_on_navmesh and not (Vector3.distance_squared(var_34_3, last_position_onground_on_navmesh) < 4)) then
		var_34_5 = last_position_onground_on_navmesh
	else
		local triangle_from_position, var_34_7 = GwNavQueries.triangle_from_position(arg_34_1, var_34_3, 5, 5)

		if not triangle_from_position then
			var_34_5 = Vector3(var_34_3.x, var_34_3.y, var_34_7)
		else
			var_34_5 = GwNavQueries.inside_position_from_outside_position(arg_34_1, var_34_3, 5, 5, 5, 0.5)
		end
	end

	local var_34_8

	if not var_34_5 then
		local _raycast, var_34_10 = self:_raycast(arg_34_1, var_34_5, var_34_2, 5)

		var_34_8 = Vector3.lerp(var_34_5, var_34_10, 0.6)

		local triangle_from_position_2, var_34_12 = GwNavQueries.triangle_from_position(arg_34_1, var_34_8, 5, 5)

		if not triangle_from_position_2 then
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
		self._last_move_target_rotations[arg_34_2] = nil
	elseif not self._last_move_target_rotations[arg_34_2] then
		var_34_13 = self._last_move_target_rotations[arg_34_2]:unbox()
	else
		local game = Managers.state.network:game()

		if not (not game and LEVEL_EDITOR_TEST) then
			local go_id = self._unit_storage:go_id(arg_34_2)
			local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")

			var_34_13 = Quaternion.look(Vector3.flat(game_object_field), Vector3.up())
		else
			var_34_13 = Unit.local_rotation(arg_34_2, 0)
		end

		self._last_move_target_rotations[arg_34_2] = QuaternionBox(var_34_13)
	end

	return var_34_8, var_34_13
end

local tbl_8 = {}
local tbl_9 = {}
local tbl_10 = {}
local tbl_11 = {}

local function fn_2(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
	-- function 35
	local count = #arg_35_1

	if count < arg_35_0 then
		if arg_35_6 < arg_35_4 then
			for i = 1, count do
				arg_35_7[i] = arg_35_3[i]
			end

			return arg_35_4
		else
			return arg_35_6
		end
	else
		local var_35_1 = arg_35_1[arg_35_0]

		for j = 1, count do
			if not arg_35_2[j] then
				arg_35_3[arg_35_0] = j
				arg_35_2[j] = true

				local num = arg_35_4 + arg_35_5[var_35_1].nav_point_utility[j]

				arg_35_6 = fn_2(arg_35_0 + 1, arg_35_1, arg_35_2, arg_35_3, num, arg_35_5, arg_35_6, arg_35_7)
				arg_35_2[j] = false
			end
		end

		return arg_35_6
	end
end

AIBotGroupSystem._assign_destination_points = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	-- function 36
	local var_36_0 = tbl_8

	for k, v in pairs(arg_36_1) do
		local nav_point_utility = v.nav_point_utility

		table.clear(nav_point_utility)

		local var_36_2 = POSITION_LOOKUP[k]

		for i, v_2 in ipairs(arg_36_2) do
			nav_point_utility[i] = 1 / math.sqrt(math.max(0.001, Vector3.distance(var_36_2, v_2)))
		end

		var_36_0[#var_36_0 + 1] = k
	end

	local var_36_3 = tbl_11
	local var_36_4 = fn_2(1, var_36_0, tbl_9, tbl_10, 0, arg_36_1, -math.huge, var_36_3)

	for i4 = 1, #var_36_0 do
		local var_36_5 = arg_36_1[var_36_0[i4]]

		if not var_36_5.hold_position then
			var_36_5.follow_position = var_36_5.hold_position:unbox()
			var_36_5.follow_unit = nil
		else
			local var_36_6 = var_36_3[i4]

			var_36_5.follow_position = arg_36_2[var_36_6]

			if not arg_36_4 then
				var_36_5.follow_unit = arg_36_4[var_36_6]
			elseif not arg_36_3 then
				var_36_5.follow_unit = arg_36_3
			else
				var_36_5.follow_unit = nil
			end
		end
	end

	table.clear(tbl_8)
	table.clear(tbl_9)
	table.clear(tbl_10)
	table.clear(tbl_11)
end

AIBotGroupSystem._calculate_center_of_volume = function (arg_37_0, arg_37_1)
	-- function 37
	local var_37_0 = Vector3(0, 0, 0)

	for k, v in pairs(arg_37_1.bottom_points) do
		var_37_0 = var_37_0 + Vector3(v[1], v[2], v[3])
	end

	local num = var_37_0 / #arg_37_1.bottom_points
	local num_2 = 0

	for k_2, v_2 in pairs(arg_37_1.bottom_points) do
		num_2 = math.max(Vector3.distance_squared(num, Vector3(v_2[1], v_2[2], v_2[3])), num_2)
	end

	return num, num_2
end

AIBotGroupSystem._find_destination_points_outside_volume = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	-- function 38
	local _calculate_center_of_volume, var_38_1 = self:_calculate_center_of_volume(arg_38_3)
	local num = math.sqrt(var_38_1) + 1
	local flat = Vector3.flat(Vector3.normalize(arg_38_2 - _calculate_center_of_volume))
	local look = Quaternion.look(flat, Vector3.up())
	local num_2 = num - 1
	local _find_points = self:_find_points(arg_38_1, Vector3(_calculate_center_of_volume[1], _calculate_center_of_volume[2], arg_38_2[3]), look, self._left_vectors_outside_volume, self._right_vectors_outside_volume, num_2, num, arg_38_5)
	local count = #_find_points
	local num_3 = 1
	local var_38_9 = _find_points[num_3]

	if count < arg_38_5 then
		for i = count + 1, arg_38_5 do
			local var_38_10 = _find_points[num_3]

			var_38_10 = var_38_10 or var_38_9 or arg_38_4
			_find_points[i] = var_38_10
			var_38_9 = _find_points[num_3] or var_38_9
			num_3 = num_3 + 1
		end
	end

	return _find_points
end

AIBotGroupSystem._find_destination_points = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	-- function 39
	local num = 3
	local num_2 = 1
	local _find_points = self:_find_points(arg_39_1, arg_39_2, arg_39_3, self._left_vectors, self._right_vectors, num_2, num, arg_39_4)

	if arg_39_4 > #_find_points then
		for i = #_find_points + 1, arg_39_4 do
			_find_points[i] = arg_39_2
		end
	end

	return _find_points
end

local function fn_3(self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	if arg_40_3 == 0 then
		return
	end

	for i = 1, arg_40_3 do
		local lerp = Vector3.lerp(arg_40_1, arg_40_2, i / arg_40_3)

		self[#self + 1] = lerp
	end
end

AIBotGroupSystem._find_points = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8)
	-- function 41
	local num = 0
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local _pathing_points = self._pathing_points

	self._pathing_points = _pathing_points

	table.clear(_pathing_points)

	while not ((num_3 < #arg_41_4 or num_4 < #arg_41_5) and not (arg_41_8 > num + num_2)) do
		if num_3 + 1 > #arg_41_4 then
			num_4 = num_4 + 1

			local _raycast, var_41_6 = self:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_5[num_4]:unbox()), arg_41_7)
			local floor = math.floor(_raycast / arg_41_6)

			fn_3(_pathing_points, arg_41_2, var_41_6, floor)

			num_2 = num_2 + floor
		elseif num_4 + 1 > #arg_41_5 then
			num_3 = num_3 + 1

			local _raycast_2, var_41_9 = self:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_4[num_3]:unbox()), arg_41_7)
			local floor_2 = math.floor(_raycast_2 / arg_41_6)

			fn_3(_pathing_points, arg_41_2, var_41_9, floor_2)

			num = num + floor_2
		elseif num_2 == num then
			num_3 = num_3 + 1
			num_4 = num_4 + 1

			local _raycast_3, var_41_12 = self:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_4[num_3]:unbox()), arg_41_7)
			local _raycast_4, var_41_14 = self:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_5[num_4]:unbox()), arg_41_7)
			local floor_3 = math.floor(_raycast_3 / arg_41_6)
			local floor_4 = math.floor(_raycast_4 / arg_41_6)
			local num_5 = floor_3 + floor_4

			if arg_41_8 < num_5 then
				local num_6 = floor_3 / num_5 * arg_41_8
				local num_7 = floor_4 / num_5 * arg_41_8
				local floor_5 = math.floor(num_6)

				if num_6 - floor_5 >= 0.5 then
					num_6 = math.ceil(num_6)
					num_7 = math.floor(num_7)
				else
					num_6 = floor_5
					num_7 = math.ceil(num_7)
				end

				fn_3(_pathing_points, arg_41_2, var_41_12, num_6)
				fn_3(_pathing_points, arg_41_2, var_41_14, num_7)

				num = num + num_6
				num_2 = num_2 + num_7
			else
				fn_3(_pathing_points, arg_41_2, var_41_12, floor_3)
				fn_3(_pathing_points, arg_41_2, var_41_14, floor_4)

				num = num + floor_3
				num_2 = num_2 + floor_4
			end
		elseif num < num_2 then
			num_3 = num_3 + 1

			local _raycast_5, var_41_22 = self:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_4[num_3]:unbox()), arg_41_7)
			local floor_6 = math.floor(_raycast_5 / arg_41_6)

			fn_3(_pathing_points, arg_41_2, var_41_22, floor_6)

			num = num + floor_6
		elseif num_2 < num then
			num_4 = num_4 + 1

			local _raycast_6, var_41_25 = self:_raycast(arg_41_1, arg_41_2, Quaternion.rotate(arg_41_3, arg_41_5[num_4]:unbox()), arg_41_7)
			local floor_7 = math.floor(_raycast_6 / arg_41_6)

			fn_3(_pathing_points, arg_41_2, var_41_25, floor_7)

			num_2 = num_2 + floor_7
		end
	end

	return _pathing_points
end

local num_18 = 0.25

AIBotGroupSystem._raycast = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	-- function 42
	local num = arg_42_2 + arg_42_3 * (arg_42_4 + num_18)
	local raycast, var_42_2 = GwNavQueries.raycast(arg_42_1, arg_42_2, num)

	if not raycast then
		return arg_42_4, var_42_2 - arg_42_3 * num_18, true
	else
		local length = Vector3.length(Vector3.flat(var_42_2 - arg_42_2))

		if length < num_18 then
			return 0, arg_42_2, false
		else
			return length - num_18, var_42_2 - arg_42_3 * num_18, raycast
		end
	end
end

AIBotGroupSystem._update_priority_targets = function (self, arg_43_1, arg_43_2)
	-- function 43
	local side = Managers.state.side
	local _bot_ai_data = self._bot_ai_data
	local _old_priority_targets = self._old_priority_targets

	for i = 1, #_bot_ai_data do
		local get_side = side:get_side(i)
		local var_43_4 = _old_priority_targets[i]
		local PLAYER_AND_BOT_UNITS = get_side.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for j = 1, count do
			local var_43_7 = PLAYER_AND_BOT_UNITS[j]
			local extension = ScriptUnit.extension(var_43_7, "status_system")

			if not extension.near_vortex then
				local var_43_9

				if not extension:is_pounced_down() then
					var_43_9 = extension:get_pouncer_unit()
				elseif not extension:is_grabbed_by_pack_master() then
					var_43_9 = extension:get_pack_master_grabber()
				elseif not extension:is_overpowered() and not extension:is_overpowered_by_attacker() then
					var_43_9 = extension.overpowered_attacking_unit
				end

				if not HEALTH_ALIVE[var_43_9] then
					tbl_2[var_43_7] = var_43_9

					local var_43_10 = tbl_3
					local var_43_11 = var_43_4[var_43_9]

					var_43_11 = var_43_11 or 0
					var_43_10[var_43_9] = var_43_11 + arg_43_1
				end
			end
		end

		local var_43_12 = _bot_ai_data[i]

		for k, v in pairs(var_43_12) do
			if not ALIVE[v.current_priority_target] then
				v.current_priority_target = nil
			end

			local status_extension = v.status_extension

			table.clear(v.priority_targets)

			if tbl_2[k] or not status_extension:is_disabled() then
				v.current_priority_target_disabled_ally = nil
				v.current_priority_target = nil
				v.priority_target_distance = math.huge
			else
				local var_43_14 = POSITION_LOOKUP[k]
				local var_43_15
				local var_43_16
				local num = -math.huge
				local huge = math.huge

				for k_2, v_2 in pairs(tbl_2) do
					local _calculate_priority_target_utility, var_43_20 = self:_calculate_priority_target_utility(var_43_14, v_2, tbl_3[v_2], v.current_priority_target)

					v.priority_targets[v_2] = _calculate_priority_target_utility

					if num < _calculate_priority_target_utility then
						num = _calculate_priority_target_utility
						var_43_15 = v_2
						huge = var_43_20
						var_43_16 = k_2
					end
				end

				v.current_priority_target_disabled_ally = var_43_16
				v.current_priority_target = var_43_15
				v.priority_target_distance = huge
			end

			local blackboard = v.blackboard

			if blackboard.priority_target_disabled_ally or not v.current_priority_target_disabled_ally then
				blackboard.priority_target_disabled_ally = v.current_priority_target_disabled_ally
			end

			if blackboard.priority_target_enemy or not v.current_priority_target then
				blackboard.priority_target_enemy = v.current_priority_target
			end

			blackboard.priority_target_distance = v.priority_target_distance
		end

		table.clear(tbl_2)
		table.create_copy(var_43_4, tbl_3)
		table.clear(tbl_3)
	end
end

local num_19 = 15
local num_20 = num_19^2

AIBotGroupSystem._update_urgent_targets = function (self, arg_44_1, arg_44_2)
	-- function 44
	local alive_bosses = Managers.state.conflict:alive_bosses()
	local count = #alive_bosses
	local _bot_ai_data = self._bot_ai_data
	local _urgent_targets = self._urgent_targets

	for i = 1, #_bot_ai_data do
		local var_44_4 = _bot_ai_data[i]

		for k, v in pairs(var_44_4) do
			local num = -math.huge
			local var_44_6
			local huge = math.huge
			local blackboard = v.blackboard
			local var_44_9 = POSITION_LOOKUP[k]
			local urgent_target_enemy = blackboard.urgent_target_enemy

			for k_2, v_2 in pairs(_urgent_targets) do
				if v_2 - arg_44_2 > 0 then
					if not HEALTH_ALIVE[k_2] then
						local _calculate_opportunity_utility, var_44_12 = self:_calculate_opportunity_utility(k, blackboard, var_44_9, urgent_target_enemy, k_2, arg_44_2, false, false)

						if num < _calculate_opportunity_utility then
							num = _calculate_opportunity_utility
							var_44_6 = k_2
							huge = var_44_12
						end
					else
						_urgent_targets[k_2] = nil
					end
				else
					_urgent_targets[k_2] = nil
				end
			end

			if not var_44_6 then
				for i5 = 1, count do
					local var_44_13 = alive_bosses[i5]
					local var_44_14 = POSITION_LOOKUP[var_44_13]

					if not (not HEALTH_ALIVE[var_44_13] and AiUtils.unit_invincible(var_44_13) or not (Vector3.distance_squared(var_44_14, var_44_9) < num_20) or BLACKBOARDS[var_44_13].defensive_mode_duration) then
						local _calculate_opportunity_utility_2, var_44_16 = self:_calculate_opportunity_utility(k, blackboard, var_44_9, urgent_target_enemy, var_44_13, arg_44_2, false, false)

						if num < _calculate_opportunity_utility_2 then
							num = _calculate_opportunity_utility_2
							var_44_6 = var_44_13
							huge = var_44_16
						end
					end
				end
			end

			blackboard.revive_with_urgent_target = not var_44_6 and self:_can_revive_with_urgent_target(k, var_44_9, blackboard, var_44_6, arg_44_2)
			blackboard.urgent_target_enemy = var_44_6
			blackboard.urgent_target_distance = huge

			local hit_by_projectile = blackboard.hit_by_projectile

			for k_3, v_3 in pairs(hit_by_projectile) do
				if not HEALTH_ALIVE[k_3] then
					hit_by_projectile[k_3] = nil
				end
			end
		end
	end
end

local tbl_12 = {
	skaven_pack_master = 49,
	chaos_corruptor_sorcerer = 100,
	skaven_poison_wind_globadier = 25,
	skaven_warpfire_thrower = 100,
	skaven_ratling_gunner = 25
}

AIBotGroupSystem._can_revive_with_urgent_target = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5)
	-- function 45
	local var_45_0 = BLACKBOARDS[arg_45_4]
	local breed = var_45_0.breed
	local name = breed.name
	local var_45_3 = POSITION_LOOKUP[arg_45_4]
	local target_ally_unit = arg_45_3.target_ally_unit
	local var_45_5 = POSITION_LOOKUP[target_ally_unit]
	local distance_squared

	if not var_45_5 then
		distance_squared = Vector3.distance_squared(var_45_5, var_45_3)

		if not distance_squared then
			-- Nothing
		end
	end

	distance_squared = Vector3.distance_squared(arg_45_2, var_45_3)

	::label_45_0::

	local var_45_7 = tbl_12[name]

	var_45_7 = var_45_7 or 25

	if not breed.boss then
		return true
	elseif name == "skaven_ratling_gunner" then
		local var_45_8 = arg_45_3.hit_by_projectile[arg_45_4]

		return not var_45_8 and not (arg_45_5 > var_45_8 + 1) or var_45_7 < distance_squared
	else
		local flag

		flag = not (var_45_0.target_unit == arg_45_1) and 4 and 1

		return distance_squared > var_45_7 * flag
	end
end

local num_21 = 40
local num_22 = num_21^2
local tbl_13 = {}

AIBotGroupSystem._update_opportunity_targets = function (self, arg_46_1, arg_46_2)
	-- function 46
	local conflict = Managers.state.conflict

	table.clear(tbl_13)

	local alive_specials = conflict:alive_specials(tbl_13)
	local count = #alive_specials
	local distance_squared = Vector3.distance_squared
	local _bot_ai_data = self._bot_ai_data

	for i = 1, #_bot_ai_data do
		local var_46_5 = _bot_ai_data[i]

		for k, v in pairs(var_46_5) do
			local num = -math.huge
			local var_46_7
			local huge = math.huge
			local blackboard = v.blackboard
			local var_46_10 = POSITION_LOOKUP[k]
			local opportunity_target_enemy = blackboard.opportunity_target_enemy
			local side = blackboard.side

			for l = 1, count do
				local var_46_13 = alive_specials[l]
				local ignore_bot_opportunity = BLACKBOARDS[var_46_13].breed.ignore_bot_opportunity
				local var_46_15 = POSITION_LOOKUP[var_46_13]

				if not ((ignore_bot_opportunity or not HEALTH_ALIVE[var_46_13]) and not (distance_squared(var_46_15, var_46_10) < num_22)) then
					local _calculate_opportunity_utility, var_46_17 = self:_calculate_opportunity_utility(k, blackboard, var_46_10, opportunity_target_enemy, var_46_13, arg_46_2, false, true)

					if num < _calculate_opportunity_utility then
						num = _calculate_opportunity_utility
						var_46_7 = var_46_13
						huge = var_46_17
					end
				end
			end

			local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

			for k_2, v_2 in pairs(VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS) do
				if not v_2 then
					local has_extension = ScriptUnit.has_extension(k_2, "ghost_mode_system")

					if not (not has_extension and has_extension:is_in_ghost_mode()) then
						local var_46_20 = POSITION_LOOKUP[k_2]

						if not (not HEALTH_ALIVE[k_2] and not (distance_squared(var_46_20, var_46_10) < num_22)) then
							local _calculate_opportunity_utility_2, var_46_22 = self:_calculate_opportunity_utility(k, blackboard, var_46_10, opportunity_target_enemy, k_2, arg_46_2, false, true)

							if num < _calculate_opportunity_utility_2 then
								num = _calculate_opportunity_utility_2
								var_46_7 = k_2
								huge = var_46_22
							end
						end
					end
				end
			end

			blackboard.opportunity_target_enemy = var_46_7
			blackboard.opportunity_target_distance = huge
		end
	end
end

local num_23 = 0.2
local num_24 = 0.65
local OPPORTUNITY_TARGET_REACTION_TIMES = BotConstants.default.OPPORTUNITY_TARGET_REACTION_TIMES

AIBotGroupSystem._calculate_opportunity_utility = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6, arg_47_7, arg_47_8)
	-- function 47
	if not arg_47_2.side.enemy_units_lookup[arg_47_5] then
		return -math.huge, math.huge
	end

	local has_extension = ScriptUnit.has_extension(arg_47_5, "proximity_system")
	local max = math.max(Vector3.distance(arg_47_3, POSITION_LOOKUP[arg_47_5]), 1)

	if not (not has_extension and has_extension.has_been_seen or arg_47_7) then
		return -math.huge, math.huge
	elseif not has_extension then
		local var_47_2 = has_extension.bot_reaction_times[arg_47_1]

		if not var_47_2 then
			local var_47_3
			local var_47_4

			if not arg_47_8 then
				local get_difficulty = Managers.state.difficulty:get_difficulty()
				local var_47_6 = OPPORTUNITY_TARGET_REACTION_TIMES[get_difficulty]

				var_47_3 = var_47_6.min
				var_47_4 = var_47_6.max
			else
				var_47_3 = num_23
				var_47_4 = num_24
			end

			has_extension.bot_reaction_times[arg_47_1] = arg_47_6 + Math.random(var_47_3, var_47_4)

			return -math.huge, math.huge
		elseif arg_47_6 < var_47_2 then
			return -math.huge, math.huge
		end
	end

	local var_47_7

	if arg_47_5 == arg_47_4 then
		var_47_7 = num_10

		if not var_47_7 then
			-- Nothing
		end
	end

	var_47_7 = 0

	::label_47_0::

	return 1 / (max + var_47_7), max
end

AIBotGroupSystem._update_pickups = function (self, arg_48_1, arg_48_2)
	-- function 48
	local players = Managers.player:players()

	if arg_48_2 > self._update_pickups_at then
		self._update_pickups_at = arg_48_2 + 0.15 + Math.random() * 0.1

		local _last_key_in_available_pickups = self._last_key_in_available_pickups

		if not (_last_key_in_available_pickups == nil or players[_last_key_in_available_pickups]) then
			_last_key_in_available_pickups = nil
		end

		local var_48_2, var_48_3 = next(players, _last_key_in_available_pickups)

		if not var_48_2 then
			var_48_2, var_48_3 = next(players)
		end

		self._last_key_in_available_pickups = var_48_2

		local player_unit = var_48_3.player_unit

		if not (not HEALTH_ALIVE[player_unit] and ScriptUnit.extension(player_unit, "status_system"):is_ready_for_assisted_respawn()) then
			self:_update_pickups_near_player(player_unit, arg_48_2)
		end
	end

	self:_update_orders(arg_48_1, arg_48_2)
	self:_update_health_pickups(arg_48_1, arg_48_2)
	self:_update_mule_pickups(arg_48_1, arg_48_2)
end

local num_25 = 15
local tbl_14 = {}

AIBotGroupSystem._update_orders = function (self, arg_49_1, arg_49_2)
	-- function 49
	local _bot_ai_data = self._bot_ai_data

	for i = 1, #_bot_ai_data do
		local var_49_1 = _bot_ai_data[i]

		for k, v in pairs(var_49_1) do
			local pickup_orders = v.pickup_orders
			local extension = ScriptUnit.extension(k, "inventory_system")

			for k_2, v_2 in pairs(pickup_orders) do
				local get_slot_data = extension:get_slot_data(k_2)
				local can_store_additional_item = extension:can_store_additional_item(k_2)

				if not (not get_slot_data and can_store_additional_item) then
					local get_item_template = extension:get_item_template(get_slot_data)
					local var_49_7

					if v_2.pickup_name == "grimoire" then
						var_49_7 = get_item_template.is_grimoire
					else
						var_49_7 = not get_item_template.pickup_data and get_item_template.pickup_data.pickup_name == v_2.pickup_name
					end

					if not var_49_7 then
						v_2.unit = nil
					elseif not v.status_extension:is_disabled() then
						pickup_orders[k_2] = nil
					elseif v_2.unit == nil then
						pickup_orders[k_2] = nil
					end
				elseif v_2.unit == nil then
					pickup_orders[k_2] = nil
				end

				if not (not v_2.unit and Unit.alive(v_2.unit)) then
					pickup_orders[k_2] = nil
				end
			end
		end
	end
end

AIBotGroupSystem._update_pickups_near_player = function (self, arg_50_1, arg_50_2)
	-- function 50
	local var_50_0 = Managers.state.side.side_by_unit[arg_50_1]
	local side_id = var_50_0.side_id
	local var_50_2 = self._bot_ai_data[side_id]
	local var_50_3 = POSITION_LOOKUP[arg_50_1]
	local var_50_4 = self._available_health_pickups[side_id]
	local var_50_5 = self._available_mule_pickups[side_id]

	for k, v in pairs(var_50_2) do
		local blackboard = v.blackboard
		local ammo_pickup = blackboard.ammo_pickup

		if not Unit.alive(ammo_pickup) then
			local distance = Vector3.distance(POSITION_LOOKUP[k], POSITION_LOOKUP[ammo_pickup])

			blackboard.ammo_dist = distance
			v.ammo_dist = distance
		elseif not blackboard.ammo_pickup then
			blackboard.ammo_pickup = nil
			blackboard.ammo_dist = nil
			v.ammo_dist = nil

			if not v.ammo_pickup_order_unit then
				v.ammo_pickup_order_unit = nil
			end
		end
	end

	local flag = true
	local flag_2 = true
	local num = arg_50_2 + 5
	local num_2 = 2.5
	local num_3 = 5
	local num_4 = 15
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local get_pickups = Managers.state.entity:system("pickup_system"):get_pickups(var_50_3, num_25, tbl_14)

	for k_2 = 1, get_pickups do
		local var_50_17 = tbl_14[k_2]
		local has_extension = ScriptUnit.has_extension(var_50_17, "pickup_system")
		local has_extension_2 = ScriptUnit.has_extension(var_50_17, "surrounding_aware_system")

		if not has_extension and not has_extension_2 and has_extension_2.has_been_seen or not ScriptUnit.extension(var_50_17, "ping_system"):pinged() then
			local pickup_name = has_extension.pickup_name
			local var_50_21 = AllPickups[pickup_name]

			if not (pickup_name == "healing_draught" or pickup_name == "first_aid_kit" or pickup_name ~= "tome") then
				local get_item_template = BackendUtils.get_item_template(ItemMasterList[var_50_21.item_name])

				if not var_50_4[var_50_17] then
					var_50_4[var_50_17] = {
						template = get_item_template,
						valid_until = num
					}
				else
					var_50_4[var_50_17].valid_until = num
					var_50_4[var_50_17].template = get_item_template
				end
			elseif not var_50_21.bots_mule_pickup then
				var_50_5[var_50_21.slot_name][var_50_17] = num
			elseif var_50_21.type == "ammo" then
				if not flag then
					local PLAYER_UNITS = var_50_0.PLAYER_UNITS
					local count = #PLAYER_UNITS

					for l = 1, count do
						local var_50_25 = PLAYER_UNITS[l]

						if not (not HEALTH_ALIVE[var_50_25] and not (ScriptUnit.extension(var_50_25, "inventory_system"):ammo_percentage() < 1)) then
							flag_2 = false

							break
						end
					end

					flag = false
				end

				for k_3, v_2 in pairs(var_50_2) do
					local blackboard_2 = v_2.blackboard
					local ammo_pickup_order_unit = v_2.ammo_pickup_order_unit

					if not (not ammo_pickup_order_unit and not (arg_50_2 >= blackboard_2.ammo_pickup_valid_until)) then
						local ammo_pickup_2 = blackboard_2.ammo_pickup
						local var_50_29 = POSITION_LOOKUP[var_50_17]
						local distance_2 = Vector3.distance(POSITION_LOOKUP[k_3], var_50_29)
						local follow_position = v_2.follow_position
						local inventory_extension = blackboard_2.inventory_extension
						local current_ammo_kind = inventory_extension:current_ammo_kind("slot_ranged")
						local ammo_kind = var_50_21.ammo_kind

						ammo_kind = ammo_kind or "default"

						local flag_3 = current_ammo_kind == ammo_kind
						local var_50_36

						if game_mode_key == "survival" then
							if not var_50_21.only_once then
								local current_ammo_status, var_50_38 = inventory_extension:current_ammo_status("slot_ranged")

								var_50_36 = not current_ammo_status and current_ammo_status == 0
							else
								var_50_36 = true
							end
						else
							var_50_36 = (ammo_kind ~= "thrown" or not true or not blackboard_2.has_ammo_missing) and (not var_50_21.only_once or not blackboard_2.needs_ammo or flag_2)
						end

						local flag_4 = (distance_2 < num_3 or not follow_position or num_4 > Vector3.distance(follow_position, var_50_29) or not ammo_pickup_2) and distance_2 - (ammo_pickup_2 ~= var_50_17 or not num_2 or 0) < v_2.ammo_dist

						if not flag_3 and not var_50_36 and not flag_4 then
							blackboard_2.ammo_pickup = var_50_17
							blackboard_2.ammo_pickup_valid_until = num
							blackboard_2.ammo_dist = distance_2
							v_2.ammo_dist = distance_2

							if not ammo_pickup_order_unit then
								v_2.ammo_pickup_order_unit = nil
							end
						end
					end
				end
			end
		end
	end

	table.clear(tbl_14)
end

local tbl_15 = {}
local tbl_16 = {}
local tbl_17 = {}
local tbl_18 = {}
local tbl_19 = {}
local tbl_20 = {}
local tbl_21 = {}
local tbl_22 = {}
local tbl_23 = {}
local tbl_24 = {}
local tbl_25 = {}
local num_26 = 15
local num_27 = 225
local num_28 = 225

local function fn_4(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8)
	-- function 51
	if arg_51_8 < arg_51_0 then
		if arg_51_1 < arg_51_3 then
			for i = 1, arg_51_8 do
				arg_51_4[i] = arg_51_2[i]
			end

			return arg_51_1
		else
			return arg_51_3
		end
	else
		local var_51_0 = tbl_19[arg_51_0]
		local var_51_1 = tbl_20[arg_51_0]
		local health_pickup = var_51_0.health_pickup
		local var_51_3 = tbl_22[arg_51_0]

		var_51_3 = var_51_3 or 0

		for k, v in pairs(arg_51_7) do
			if not arg_51_6[k] then
				local var_51_4

				if health_pickup == k then
					var_51_4 = num_27

					if not var_51_4 then
						-- Nothing
					end
				end

				var_51_4 = 0

				::label_51_0::

				local num = arg_51_1 + Vector3.distance_squared(var_51_1, v) - var_51_4 - var_51_3 * num_28

				arg_51_6[k] = nil
				arg_51_2[arg_51_0] = k
				arg_51_3 = fn_4(arg_51_0 + 1, num, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8)
				arg_51_2[arg_51_0] = nil
				arg_51_6[k] = v
			end
		end

		if arg_51_5 > 0 then
			arg_51_3 = fn_4(arg_51_0 + 1, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5 - 1, arg_51_6, arg_51_7, arg_51_8)
		end

		return arg_51_3
	end
end

local tbl_26 = {}

AIBotGroupSystem._update_mule_pickups = function (self, arg_52_1, arg_52_2)
	-- function 52
	local alive = Unit.alive
	local distance_squared = Vector3.distance_squared
	local num = 400
	local side = Managers.state.side
	local _bot_ai_data = self._bot_ai_data
	local _available_mule_pickups = self._available_mule_pickups

	for i = 1, #_bot_ai_data do
		table.clear(tbl_26)

		local var_52_6 = _bot_ai_data[i]
		local var_52_7 = _available_mule_pickups[i]

		for k, v in pairs(var_52_6) do
			local huge = math.huge
			local var_52_9
			local pickup_orders = v.pickup_orders

			for k_2, v_2 in pairs(var_52_7) do
				local var_52_11 = pickup_orders[k_2]
				local flag = not var_52_11 and var_52_11.unit

				if not flag then
					v_2[flag] = nil
					tbl_26[flag] = true

					local var_52_13 = distance_squared(POSITION_LOOKUP[flag], POSITION_LOOKUP[k])

					if var_52_13 < huge then
						var_52_9 = flag
						huge = var_52_13
					end
				end
			end

			if not var_52_9 then
				local blackboard = v.blackboard

				blackboard.mule_pickup = var_52_9
				blackboard.mule_pickup_dist_squared = huge
			end
		end

		for k_3, v_3 in pairs(var_52_6) do
			local blackboard_2 = v_3.blackboard
			local mule_pickup = blackboard_2.mule_pickup

			if not mule_pickup then
				if not tbl_26[mule_pickup] then
					local slot_name = ScriptUnit.extension(mule_pickup, "pickup_system"):get_pickup_settings().slot_name
					local var_52_18 = v_3.pickup_orders[slot_name]

					if not (not var_52_18 and var_52_18.unit == mule_pickup) then
						blackboard_2.mule_pickup = nil
					end
				else
					if not alive(mule_pickup) then
						local var_52_19 = distance_squared
						local var_52_20 = POSITION_LOOKUP[mule_pickup]
						local follow_position = v_3.follow_position

						follow_position = follow_position or POSITION_LOOKUP[mule_pickup]

						if num < var_52_19(var_52_20, follow_position) then
							-- Nothing
						end
					end

					blackboard_2.mule_pickup = nil
				end
			end

			goto label_52_1

			::label_52_0::

			do
				local pickup_name = ScriptUnit.extension(mule_pickup, "pickup_system").pickup_name
				local slot_name_2 = AllPickups[pickup_name].slot_name
				local inventory_extension = blackboard_2.inventory_extension
				local get_slot_data = inventory_extension:get_slot_data(slot_name_2)
				local can_store_additional_item = inventory_extension:can_store_additional_item(slot_name_2)

				if not (not get_slot_data and can_store_additional_item) then
					blackboard_2.mule_pickup = nil
				else
					tbl_26[mule_pickup] = true
					blackboard_2.mule_pickup_dist_squared = distance_squared(POSITION_LOOKUP[k_3], POSITION_LOOKUP[mule_pickup])
				end
			end

			::label_52_1::
		end

		local PLAYER_UNITS = side:get_side(i).PLAYER_UNITS
		local count = #PLAYER_UNITS

		for k_4, v_4 in pairs(var_52_7) do
			local num_2 = 0

			for k_5, v_5 in pairs(v_4) do
				if not (not alive(k_5) and not (arg_52_2 <= v_5)) then
					num_2 = num_2 + 1
				else
					v_4[k_5] = nil
				end
			end

			local num_3 = 0

			for i11 = 1, count do
				if k_4 == "infinite_slot" then
					break
				end

				local var_52_31 = PLAYER_UNITS[i11]

				if not (not HEALTH_ALIVE[var_52_31] and ScriptUnit.extension(var_52_31, "inventory_system"):get_slot_data(k_4)) then
					local var_52_32 = POSITION_LOOKUP[var_52_31]

					for k_6, v_6 in pairs(v_4) do
						local var_52_33 = POSITION_LOOKUP[k_6]

						if num > distance_squared(var_52_33, var_52_32) then
							num_3 = num_3 + 1

							break
						end
					end
				end
			end

			if num_3 == 0 then
				for k_7, v_7 in pairs(var_52_6) do
					local blackboard_3 = v_7.blackboard
					local var_52_35 = v_7.pickup_orders[k_4]
					local inventory_extension_2 = blackboard_3.inventory_extension
					local get_slot_data_2 = inventory_extension_2:get_slot_data(k_4)
					local can_store_additional_item_2 = inventory_extension_2:can_store_additional_item(k_4)

					if not (blackboard_3.mule_pickup or not get_slot_data_2 or can_store_additional_item_2 or var_52_35) then
						local huge_2 = math.huge
						local var_52_40

						for k_8, v_8 in pairs(v_4) do
							if not tbl_26[k_8] then
								local var_52_41 = POSITION_LOOKUP[k_8]
								local var_52_42 = POSITION_LOOKUP[k_7]
								local var_52_43 = distance_squared(var_52_42, var_52_41)
								local var_52_44 = distance_squared
								local follow_position_2 = v_7.follow_position

								follow_position_2 = follow_position_2 or var_52_42

								if not (not (num > var_52_44(follow_position_2, var_52_41)) or not (var_52_43 < huge_2)) then
									var_52_40 = k_8
									huge_2 = var_52_43
								end
							end
						end

						if not var_52_40 then
							blackboard_3.mule_pickup = var_52_40
							blackboard_3.mule_pickup_dist_squared = huge_2
							tbl_26[var_52_40] = true
						end
					end
				end
			end
		end
	end
end

AIBotGroupSystem._update_health_pickups = function (self, arg_53_1, arg_53_2)
	-- function 53
	local alive = Unit.alive
	local distance = Vector3.distance
	local distance_squared = Vector3.distance_squared
	local side = Managers.state.side
	local _bot_ai_data = self._bot_ai_data
	local _available_health_pickups = self._available_health_pickups

	for i = 1, #_bot_ai_data do
		local var_53_6 = _available_health_pickups[i]
		local num = 0
		local num_2 = 0

		for k, v in pairs(var_53_6) do
			if not (not alive(k) and not (arg_53_2 > v.valid_until)) then
				var_53_6[k] = nil
			elseif not v.template.can_heal_self then
				num = num + 1
				tbl_16[k] = POSITION_LOOKUP[k]
			else
				num_2 = num_2 + 1
				tbl_18[k] = POSITION_LOOKUP[k]
			end
		end

		table.clear(tbl_15)

		local var_53_9 = _bot_ai_data[i]

		for k_2, v_2 in pairs(var_53_9) do
			local slot_healthkit = v_2.pickup_orders.slot_healthkit

			if not slot_healthkit then
				local unit = slot_healthkit.unit

				if not unit then
					-- Nothing
				elseif not tbl_16[unit] then
					num = num - 1
					tbl_16[unit] = nil
				elseif not tbl_18[unit] then
					num_2 = num_2 - 1
					tbl_18[unit] = nil
				end

				tbl_15[k_2] = slot_healthkit
			end
		end

		local huge = math.huge
		local PLAYER_UNITS = side:get_side(i).PLAYER_UNITS
		local count = #PLAYER_UNITS

		for i5 = 1, count do
			local var_53_15 = PLAYER_UNITS[i5]

			if not HEALTH_ALIVE[var_53_15] then
				if not (ScriptUnit.extension(var_53_15, "inventory_system"):get_slot_data("slot_healthkit") or tbl_15[var_53_15]) then
					local huge_2 = math.huge
					local var_53_17
					local var_53_18 = POSITION_LOOKUP[var_53_15]

					if num > 0 then
						for k_3, v_3 in pairs(tbl_16) do
							local var_53_19 = distance_squared(var_53_18, v_3)

							if var_53_19 < huge_2 then
								huge_2 = var_53_19
								var_53_17 = k_3
							end
						end

						num = num - 1
						tbl_16[var_53_17] = nil
					elseif num_2 > 0 then
						for k_4, v_4 in pairs(tbl_18) do
							local var_53_20 = distance_squared(var_53_18, v_4)

							if var_53_20 < huge_2 then
								huge_2 = var_53_20
								var_53_17 = k_4
							end
						end

						num_2 = num_2 - 1
						tbl_18[var_53_17] = nil
					end
				end

				local extension = ScriptUnit.extension(var_53_15, "status_system")

				if extension:is_knocked_down() or not extension:is_wounded() then
					huge = math.min(0, huge)
				else
					local current_health_percent = ScriptUnit.extension(var_53_15, "health_system"):current_health_percent()

					huge = math.min(current_health_percent, huge)
				end
			end
		end

		local num_3 = 0
		local huge_3 = math.huge
		local flag = false
		local var_53_26

		for k_5, v_5 in pairs(var_53_9) do
			local var_53_27 = BLACKBOARDS[k_5]

			var_53_27.allowed_to_take_health_pickup = false
			var_53_27.force_use_health_pickup = false

			local extension_2 = ScriptUnit.extension(k_5, "inventory_system")
			local status_extension = v_5.status_extension
			local get_slot_data = extension_2:get_slot_data("slot_healthkit")
			local flag_2 = not get_slot_data and extension_2:get_item_template(get_slot_data).can_heal_self

			if not (not tbl_15[k_5] and flag_2) then
				-- Nothing
			elseif not ((flag_2 or not HEALTH_ALIVE[k_5]) and status_extension:is_ready_for_assisted_respawn()) then
				num_3 = num_3 + 1
				tbl_21[num_3] = k_5
				tbl_19[num_3] = var_53_27
				tbl_20[num_3] = POSITION_LOOKUP[k_5]

				local current_health_percent_2 = ScriptUnit.extension(k_5, "health_system"):current_health_percent()

				if not status_extension:is_wounded() then
					current_health_percent_2 = current_health_percent_2 / 3
				end

				tbl_22[num_3] = current_health_percent_2

				if current_health_percent_2 < huge_3 then
					huge_3 = current_health_percent_2
					flag = false
					var_53_26 = nil
				end

				tbl_25[k_5] = num_3
			elseif not (not flag_2 and not HEALTH_ALIVE[k_5] and status_extension:is_ready_for_assisted_respawn()) then
				local current_health_percent_3 = ScriptUnit.extension(k_5, "health_system"):current_health_percent()
				local has_buff_type = ScriptUnit.extension(k_5, "buff_system"):has_buff_type("trait_necklace_no_healing_health_regen")
				local is_wounded = status_extension:is_wounded()

				if (not (current_health_percent_3 < huge_3) or not has_buff_type) and not is_wounded then
					huge_3 = current_health_percent_3
					flag = true
					var_53_26 = var_53_27
				end
			end
		end

		table.merge(tbl_17, tbl_16)

		local flag_3 = num_3 < num
		local max = math.max(0, num_3 - num)

		fn_4(1, 0, tbl_23, math.huge, tbl_24, max, tbl_17, tbl_16, num_3)
		table.clear(tbl_22)

		for k_6, v_6 in pairs(var_53_9) do
			local var_53_38 = tbl_25[k_6]

			if not var_53_38 then
				local var_53_39 = tbl_19[var_53_38]
				local var_53_40 = tbl_24[var_53_38]

				if not var_53_40 then
					var_53_39.health_pickup = var_53_40

					local var_53_41 = POSITION_LOOKUP[var_53_40]
					local var_53_42 = distance(tbl_20[var_53_38], var_53_41)

					var_53_39.health_dist = var_53_42
					var_53_39.health_pickup_valid_until = math.huge

					local follow_position = v_6.follow_position

					if not ((follow_position or not (var_53_42 < num_26)) and not follow_position and distance(follow_position, var_53_41) < num_26) then
						var_53_39.allowed_to_take_health_pickup = true
					else
						var_53_39.allowed_to_take_health_pickup = false
					end
				else
					var_53_39.allowed_to_take_health_pickup = false
					var_53_39.health_dist = nil
					var_53_39.health_pickup_valid_until = nil
				end
			elseif not tbl_15[k_6] and not tbl_15[k_6].unit then
				local var_53_44 = BLACKBOARDS[k_6]
				local unit_2 = tbl_15[k_6].unit

				var_53_44.health_pickup = unit_2
				var_53_44.health_dist = distance(POSITION_LOOKUP[k_6], POSITION_LOOKUP[unit_2])
				var_53_44.health_pickup_valid_until = math.huge
				var_53_44.allowed_to_take_health_pickup = true
			else
				local var_53_46 = BLACKBOARDS[k_6]

				if not var_53_46.health_pickup then
					var_53_46.health_pickup = nil
					var_53_46.health_dist = nil
					var_53_46.health_pickup_valid_until = nil
				end

				var_53_46.allowed_to_take_health_pickup = false
			end
		end

		local num_4 = 1

		for i14 = 1, num_3 do
			local var_53_48 = tbl_21[i14]
			local get_slot_data_2 = ScriptUnit.extension(var_53_48, "inventory_system"):get_slot_data("slot_healthkit")

			if not (tbl_24[i14] or get_slot_data_2) then
				local var_53_50 = tbl_21[i14]

				tbl_21[num_4] = var_53_50
				tbl_19[num_4] = tbl_19[i14]
				tbl_20[num_4] = tbl_20[i14]
				tbl_25[var_53_50] = num_4
				num_4 = num_4 + 1
			else
				local var_53_51 = tbl_21[i14]

				tbl_25[var_53_51] = nil
			end
		end

		for i15 = num_4, num_3 do
			tbl_21[i15] = nil
			tbl_19[i15] = nil
			tbl_20[i15] = nil
		end

		table.clear(tbl_17)
		table.clear(tbl_23)
		table.clear(tbl_24)

		local num_5 = num_4 - 1

		if num_5 > 0 then
			table.merge(tbl_17, tbl_18)

			local max_2 = math.max(0, num_5 - num_2)

			fn_4(1, 0, tbl_23, math.huge, tbl_24, max_2, tbl_17, tbl_18, num_5)

			for k_7, v_7 in pairs(var_53_9) do
				local var_53_54 = tbl_25[k_7]

				if not var_53_54 then
					local var_53_55 = tbl_19[var_53_54]
					local var_53_56 = tbl_24[var_53_54]

					if not var_53_56 then
						var_53_55.health_pickup = var_53_56

						local var_53_57 = POSITION_LOOKUP[var_53_56]
						local var_53_58 = distance(tbl_20[var_53_54], var_53_57)

						var_53_55.health_dist = var_53_58
						var_53_55.health_pickup_valid_until = math.huge

						local follow_position_2 = v_7.follow_position

						if not ((follow_position_2 or not (var_53_58 < num_26)) and not follow_position_2 and distance(follow_position_2, var_53_57) < num_26) then
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

			table.clear(tbl_17)
			table.clear(tbl_23)
			table.clear(tbl_24)
		end

		table.clear(tbl_19)
		table.clear(tbl_21)
		table.clear(tbl_20)
		table.clear(tbl_25)
		table.clear(tbl_16)
		table.clear(tbl_18)

		if not (self._in_carry_event[i] or not flag_3 and not flag and not (huge_3 > 0) or not (huge > math.min(huge_3 * 1.2, 1))) then
			var_53_26.force_use_health_pickup = true
		end
	end
end

AIBotGroupSystem._calculate_priority_target_utility = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	-- function 54
	local var_54_0

	if arg_54_2 == arg_54_4 then
		var_54_0 = num_10

		if not var_54_0 then
			-- Nothing
		end
	end

	var_54_0 = 0

	::label_54_0::

	local max = math.max(Vector3.distance(arg_54_1, POSITION_LOOKUP[arg_54_2]), 1)

	return 1 / (max + var_54_0) + arg_54_3, max
end

AIBotGroupSystem._update_first_person_debug = function (self)
	-- function 55
	if not script_data.ai_bots_debug then
		return
	end

	if not IS_WINDOWS then
		if not Keyboard.pressed(Keyboard.button_index("numpad 1")) then
			self:first_person_debug(1)
		elseif not Keyboard.pressed(Keyboard.button_index("numpad 2")) then
			self:first_person_debug(2)
		elseif not Keyboard.pressed(Keyboard.button_index("numpad 3")) then
			self:first_person_debug(3)
		elseif not Keyboard.pressed(Keyboard.button_index("numpad enter")) then
			self:first_person_debug(nil)
		end
	end
end

AIBotGroupSystem._update_weapon_debug = function (self)
	-- function 56
	if not script_data.ai_bots_weapon_debug then
		return
	end

	local player = Managers.player

	Debug.text("BOT RANGED WEAPON")

	for i = 1, #self._bot_ai_data do
		local var_56_1 = self._bot_ai_data[i]

		for k, v in pairs(var_56_1) do
			local blackboard = v.blackboard
			local inventory_extension = blackboard.inventory_extension
			local get_slot_data = inventory_extension:get_slot_data("slot_ranged")

			if not get_slot_data then
				local profile_display_name = player:owner(k):profile_display_name()
				local overcharge_extension = blackboard.overcharge_extension
				local current_ammo_status, var_56_8 = inventory_extension:current_ammo_status("slot_ranged")
				local current_overcharge_status, var_56_10, var_56_11 = overcharge_extension:current_overcharge_status()
				local name = inventory_extension:get_item_template(get_slot_data).name
				local format

				if not current_ammo_status then
					format = string.format(" %d|%d", current_ammo_status, var_56_8)

					if not format then
						-- Nothing
					end
				end

				format = ""

				do
					local format_2
				end

				::label_56_0::

				if not current_overcharge_status then
					format_2 = string.format(" %02d|%d|%d", current_overcharge_status, var_56_10, var_56_11)

					if not format_2 then
						-- Nothing
					end
				end

				format_2 = ""

				::label_56_1::

				Debug.text("%-16s:%s%s [%s]", profile_display_name, format, format_2, name)
			end
		end
	end
end

AIBotGroupSystem._update_order_debug = function (self)
	-- function 57
	if not script_data.ai_bots_order_debug then
		return
	end

	local tbl = {
		slot_healthkit = Color(255, 0, 0),
		slot_potion = Color(0, 255, 0),
		slot_level_event = Color(0, 0, 255),
		slot_grenade = Color(0, 255, 255)
	}

	for i = 1, #self._bot_ai_data do
		local var_57_1 = self._bot_ai_data[i]

		for k, v in pairs(var_57_1) do
			local pickup_orders = v.pickup_orders

			for k_2, v_2 in pairs(pickup_orders) do
				local unit = v_2.unit

				if not unit then
					local var_57_4 = POSITION_LOOKUP[unit]
					local var_57_5 = tbl[k_2]

					var_57_5 = var_57_5 or Color(Math.random() * 255, Math.random() * 255, Math.random() * 255)

					QuickDrawer:line(POSITION_LOOKUP[k], var_57_4, var_57_5)
					QuickDrawer:sphere(var_57_4, 0.25, var_57_5)
				end
			end
		end
	end

	if not Keyboard.pressed(Keyboard.button_index("t")) then
		local _physics_world = self._physics_world
		local local_player = Managers.player:local_player()
		local viewport_name = local_player.viewport_name
		local viewport = ScriptWorld.viewport(self._world, viewport_name, true)
		local camera = ScriptViewport.camera(viewport)
		local position = ScriptCamera.position(camera)
		local rotation = ScriptCamera.rotation(camera)
		local immediate_raycast, var_57_14, var_57_15, var_57_16, var_57_17 = PhysicsWorld.immediate_raycast(_physics_world, position, Quaternion.forward(rotation), 100, "closest", "collision_filter", "filter_pickups")

		if not immediate_raycast then
			local unit_2 = Actor.unit(var_57_17)
			local var_57_19

			for i5 = 1, #self._bot_ai_data do
				local var_57_20 = self._bot_ai_data[i5]

				for k_3, v_3 in pairs(var_57_20) do
					if not HEALTH_ALIVE[k_3] then
						var_57_19 = k_3

						if Math.random() < 0.3 then
							break
						end
					end
				end
			end

			if not var_57_19 then
				self:order("pickup", var_57_19, unit_2, local_player)
			end
		end
	end
end

AIBotGroupSystem._update_proximity_bot_breakables_debug = function (self)
	-- function 58
	if not script_data.ai_bots_proximity_breakables_debug then
		return
	end

	for i = 1, #self._bot_ai_data do
		local var_58_0 = self._bot_ai_data[i]

		for k, v in pairs(var_58_0) do
			if k == script_data.debug_unit then
				local previous_bot_breakables = v.previous_bot_breakables

				for k_2, v_2 in pairs(previous_bot_breakables) do
					local str = "rp_center"
					local node

					if not Unit.has_node(k_2, str) then
						node = Unit.node(k_2, str)

						if not node then
							-- Nothing
						end
					end

					node = 0

					::label_58_0::

					local world_position = Unit.world_position(k_2, node)

					QuickDrawer:sphere(world_position, 0.25, Colors.get("yellow"))
				end
			end
		end
	end
end

AIBotGroupSystem._update_ally_needs_aid_priority = function (self)
	-- function 59
	local alive = Unit.alive
	local _bot_ai_data_lookup = self._bot_ai_data_lookup

	for k, v in pairs(self._ally_needs_aid_priority) do
		local flag = true

		if not alive(v) then
			local blackboard = _bot_ai_data_lookup[v].blackboard

			flag = (blackboard.target_ally_unit ~= k or not blackboard.target_ally_needs_aid) and not HEALTH_ALIVE[v]
		end

		if not flag then
			self._ally_needs_aid_priority[k] = nil
		end
	end
end

AIBotGroupSystem.first_person_debug = function (self, arg_60_1)
	-- function 60
	if arg_60_1 == self._debugging_bot then
		return
	end

	local var_60_0
	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		if not v.remote then
			var_60_0 = v

			break
		end
	end

	local var_60_2

	if not arg_60_1 then
		var_60_2 = Managers.player:local_player(arg_60_1 + 1)
	else
		var_60_2 = var_60_0
	end

	if not var_60_2 then
		return
	end

	local player_unit = var_60_2.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local var_60_4

	if not self._debugging_bot then
		var_60_4 = Managers.player:local_player(self._debugging_bot + 1)
	else
		var_60_4 = var_60_0
	end

	local player_unit_2 = var_60_4.player_unit

	if not Unit.alive(player_unit_2) then
		return
	end

	local _world = self._world

	if not Managers.state.camera:has_viewport(var_60_2.viewport_name) then
		Managers.state.entity:system("camera_system"):local_player_created(var_60_2)
	else
		for k_2, v_2 in pairs(Managers.state.entity:system("camera_system").camera_units) do
			if k_2.viewport_name == var_60_2.viewport_name then
				if k_2 ~= var_60_2 then
					ScriptUnit.extension(v_2, "camera_system").player = var_60_2
				end

				break
			end
		end
	end

	ScriptWorld.activate_viewport(_world, ScriptWorld.viewport(_world, var_60_2.viewport_name))
	ScriptWorld.deactivate_viewport(_world, ScriptWorld.viewport(_world, var_60_4.viewport_name))
	ScriptUnit.extension(player_unit, "first_person_system"):debug_set_first_person_mode(var_60_2 ~= var_60_0, true)
	ScriptUnit.extension(player_unit_2, "first_person_system"):debug_set_first_person_mode(var_60_4 == var_60_0, false)

	self._debugging_bot = arg_60_1
end

AIBotGroupSystem.ranged_attack_started = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	if not DamageUtils.is_player_unit(arg_61_2) then
		ScriptUnit.extension(arg_61_1, "proximity_system").has_been_seen = true

		local _bot_ai_data = self._bot_ai_data

		for i = 1, #_bot_ai_data do
			local var_61_1 = _bot_ai_data[i]

			for k, v in pairs(var_61_1) do
				ScriptUnit.extension(k, "ai_system"):ranged_attack_started(arg_61_1, arg_61_2, arg_61_3)
			end
		end

		fassert(self._urgent_targets[arg_61_1] ~= math.huge, "Attacker unit %s is already attacking another victim! max one victim at a time allowed, otherwise we need to add ref counting", arg_61_1)

		self._urgent_targets[arg_61_1] = math.huge
	end
end

local num_29 = 30

AIBotGroupSystem.ranged_attack_ended = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	-- function 62
	local _bot_ai_data = self._bot_ai_data

	for i = 1, #_bot_ai_data do
		local var_62_1 = _bot_ai_data[i]

		for k, v in pairs(var_62_1) do
			ScriptUnit.extension(k, "ai_system"):ranged_attack_ended(arg_62_1, arg_62_2, arg_62_3)
		end
	end

	self._urgent_targets[arg_62_1] = self._t + (arg_62_4 or num_29)
end

local num_30 = 7
local num_31 = num_30^2

AIBotGroupSystem.enemy_teleported = function (self, arg_63_1, arg_63_2)
	-- function 63
	local extension = ScriptUnit.extension(arg_63_1, "proximity_system")

	extension.has_been_seen = false

	local _physics_world = self._physics_world
	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_63_1].ENEMY_PLAYER_AND_BOT_UNITS
	local _bot_ai_data_lookup = self._bot_ai_data_lookup

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_63_4 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not _bot_ai_data_lookup[var_63_4] then
			local var_63_5 = POSITION_LOOKUP[var_63_4]

			if not (Vector3.distance_squared(var_63_5, arg_63_2) < num_31) or not PerceptionUtils.raycast_spine_to_spine(var_63_4, arg_63_1, _physics_world) then
				extension.has_been_seen = true

				break
			end
		end
	end
end

local num_32 = 3

AIBotGroupSystem.register_ally_needs_aid_priority = function (self, arg_64_1, arg_64_2)
	-- function 64
	local var_64_0 = self._ally_needs_aid_priority[arg_64_2]
	local flag = true

	if not var_64_0 then
		local _bot_ai_data_lookup = self._bot_ai_data_lookup
		local blackboard = _bot_ai_data_lookup[var_64_0].blackboard
		local blackboard_2 = _bot_ai_data_lookup[arg_64_1].blackboard

		flag = blackboard.ally_distance > blackboard_2.ally_distance + num_32
	end

	if not flag then
		self._ally_needs_aid_priority[arg_64_2] = arg_64_1
	end
end

AIBotGroupSystem.is_prioritized_ally = function (self, arg_65_1, arg_65_2)
	-- function 65
	return self._ally_needs_aid_priority[arg_65_2] == arg_65_1
end

local tbl_27 = {}

AIBotGroupSystem._update_proximity_bot_breakables = function (self, arg_66_1)
	-- function 66
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local system = Managers.state.entity:system("nav_graph_system")
	local _bot_breakables_broadphase = self._bot_breakables_broadphase
	local _bot_ai_data = self._bot_ai_data

	for i = 1, #_bot_ai_data do
		local var_66_4 = _bot_ai_data[i]

		for k, v in pairs(var_66_4) do
			local var_66_5 = POSITION_LOOKUP[k]
			local query = Broadphase.query(_bot_breakables_broadphase, var_66_5, 2, tbl_27)
			local current_bot_breakables = v.current_bot_breakables
			local previous_bot_breakables = v.previous_bot_breakables
			local extension = ScriptUnit.extension(k, "ai_navigation_system")

			for l = 1, query do
				local var_66_10 = tbl_27[l]

				if not HEALTH_ALIVE[var_66_10] then
					current_bot_breakables[var_66_10] = var_66_10

					if not previous_bot_breakables[var_66_10] then
						previous_bot_breakables[var_66_10] = nil
					else
						local get_smart_object_id = system:get_smart_object_id(var_66_10)
						local var_66_12 = system:get_smart_objects(get_smart_object_id)[1]
						local unbox = Vector3Aux.unbox(var_66_12.pos1)
						local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, unbox, 1.5, 3)
						local unbox_2 = Vector3Aux.unbox(var_66_12.pos2)
						local pos_on_mesh_2 = LocomotionUtils.pos_on_mesh(nav_world, unbox_2, 1.5, 3)
						local smart_object_type = var_66_12.smart_object_type

						if not pos_on_mesh and not pos_on_mesh_2 then
							extension:add_transition(var_66_10, smart_object_type, pos_on_mesh, pos_on_mesh_2)
						end
					end
				end
			end

			for k_2, v_2 in pairs(previous_bot_breakables) do
				extension:remove_transition(k_2)

				previous_bot_breakables[k_2] = nil
			end

			fassert(table.is_empty(previous_bot_breakables), "Error! previous_bot_breakables table was not cleared!")

			v.current_bot_breakables = previous_bot_breakables
			v.previous_bot_breakables = current_bot_breakables
		end
	end
end

AIBotGroupSystem.set_in_cover = function (arg_67_0, arg_67_1, arg_67_2)
	-- function 67
	arg_67_0._used_covers[arg_67_1] = arg_67_2
end

AIBotGroupSystem.in_cover = function (self, arg_68_1)
	-- function 68
	for k, v in pairs(self._used_covers) do
		if v == arg_68_1 then
			return k
		end
	end

	return nil
end

local function fn_5(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	-- function 69
	local direction_length, var_69_1 = Vector3.direction_length(arg_69_2 - arg_69_1)
	local num = (var_69_1 + arg_69_3)^2
	local flag = false

	for i = 1, #arg_69_4 do
		if not Unit.alive(arg_69_4[i]) then
			local ray_circle, var_69_5, var_69_6, var_69_7 = Intersect.ray_circle(arg_69_1, direction_length, Unit.local_position(arg_69_4[i], 0), 0.75)

			if not (not var_69_6 and not (Vector3.dot(var_69_6, arg_69_2 - arg_69_1) > 0) or num > Vector3.length_squared(var_69_6) or not (num > Vector3.length_squared(var_69_7))) then
				flag = true

				break
			end
		end
	end

	return flag
end

local num_33 = 6
local num_34 = 0.01

local function fn_6(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8, arg_70_9, arg_70_10, arg_70_11)
	-- function 70
	local x = arg_70_2.x
	local y = arg_70_2.y
	local z = arg_70_2.z
	local num = x - arg_70_5
	local num_2 = y - arg_70_6
	local sqrt = math.sqrt(num * num + num_2 * num_2)
	local x_2 = arg_70_9.x
	local y_2 = arg_70_9.y
	local z_2 = arg_70_9.z

	if x_2 < arg_70_4 then
		x_2 = 0
	end

	local var_70_9
	local var_70_10

	if not (not (sqrt >= x_2 - arg_70_4) or not (sqrt <= y_2 + arg_70_4) or not (z > arg_70_7 - arg_70_3 - z_2) or not (z < arg_70_7 + z_2)) then
		local var_70_11

		if not (not (x_2 > 0) or not (sqrt < (x_2 + y_2) * 0.5)) then
			var_70_11 = x_2 - arg_70_4
		else
			var_70_11 = y_2 + arg_70_4
		end

		local var_70_12 = Vector3(arg_70_5, arg_70_6, arg_70_2[3])
		local direction_length, var_70_14 = Vector3.direction_length(arg_70_2 - var_70_12)

		if var_70_14 < num_34 then
			direction_length = Vector3(0, 1, 0)
		end

		local proximite_enemies = arg_70_10.proximite_enemies

		for i = 0, num_33 - 1 do
			local flag

			flag = i == 0 or i == num_33 - 1 or 1 or 2

			local num_3 = 1

			for j = 1, flag do
				local num_4 = math.pi * (i / (num_33 - 1)) * num_3
				local num_5 = var_70_12 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), num_4), direction_length) * var_70_11
				local distance_squared = Vector3.distance_squared(arg_70_2, num_5)
				local flag_2 = false

				if distance_squared > 1e-06 then
					local num_6 = 2
					local num_7 = 2
					local var_70_24
					local triangle_from_position, var_70_26 = GwNavQueries.triangle_from_position(arg_70_0, num_5, num_6, num_7)
					local var_70_27 = var_70_26

					if not triangle_from_position then
						num_5.z = var_70_27

						if not GwNavQueries.raycango(arg_70_0, arg_70_2, num_5, arg_70_1) then
							if not (fn_5(arg_70_10, arg_70_2, num_5, arg_70_4, proximite_enemies) or fn(arg_70_11, num_5, arg_70_4)) then
								var_70_9 = num_5
							end

							var_70_10 = num_5
						end

						num_3 = num_3 * -1
					end
				end

				if not var_70_9 then
					return var_70_9
				end
			end
		end
	end

	return var_70_10
end

local function fn_7(arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4, arg_71_5, arg_71_6, arg_71_7, arg_71_8, arg_71_9, arg_71_10, arg_71_11)
	-- function 71
	local x = arg_71_2.x
	local y = arg_71_2.y
	local z = arg_71_2.z
	local num = x - arg_71_5
	local num_2 = y - arg_71_6
	local sqrt = math.sqrt(num * num + num_2 * num_2)

	if sqrt > arg_71_9 + arg_71_4 then
		return
	elseif not (not (z < arg_71_7 + arg_71_9) or not (z > arg_71_7 - arg_71_3 - arg_71_9)) then
		local var_71_6
		local var_71_7
		local num_3 = arg_71_9 + arg_71_4
		local var_71_9

		if sqrt < num_34 then
			var_71_9 = Vector3(0, 1, 0)
		else
			var_71_9 = Vector3(num / sqrt, num_2 / sqrt, 0)
		end

		local proximite_enemies = arg_71_10.proximite_enemies

		for i = 0, num_33 - 1 do
			local flag

			flag = i == 0 or i == num_33 - 1 or 1 or 2

			local num_4 = 1

			for j = 1, flag do
				local num_5 = math.pi * (i / (num_33 - 1)) * num_4
				local rotate = Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), num_5), var_71_9)
				local num_6 = Vector3(arg_71_5, arg_71_6, z) + rotate * num_3
				local distance_squared = Vector3.distance_squared(arg_71_2, num_6)
				local flag_2 = false

				if distance_squared > 1e-06 then
					local num_7 = 2
					local num_8 = 2
					local var_71_20
					local triangle_from_position, var_71_22 = GwNavQueries.triangle_from_position(arg_71_0, num_6, num_7, num_8)
					local var_71_23 = var_71_22

					if not triangle_from_position then
						num_6.z = var_71_23

						if not GwNavQueries.raycango(arg_71_0, arg_71_2, num_6, arg_71_1) then
							if not (fn_5(arg_71_10, arg_71_2, num_6, arg_71_4, proximite_enemies) or fn(arg_71_11, num_6, arg_71_4)) then
								var_71_6 = num_6
							end

							var_71_7 = num_6
						end

						num_4 = num_4 * -1
					end
				end

				if not var_71_6 then
					return var_71_6
				end
			end
		end

		return var_71_7
	end
end

local tbl_28 = {
	0,
	-1,
	1
}

local function fn_8(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6, arg_72_7, arg_72_8, arg_72_9, arg_72_10, arg_72_11)
	-- function 72
	local num = arg_72_3 * 0.5
	local num_2 = arg_72_2 - Vector3(arg_72_5, arg_72_6, arg_72_7 - num)
	local right = Quaternion.right(arg_72_8)
	local dot = Vector3.dot(right, num_2)
	local dot_2 = Vector3.dot(Quaternion.forward(arg_72_8), num_2)
	local dot_3 = Vector3.dot(Quaternion.up(arg_72_8), num_2)
	local num_3 = arg_72_9.x + arg_72_4
	local num_4 = arg_72_9.y + arg_72_4
	local num_5 = arg_72_9.z + num

	if not (num_3 < dot or dot < -num_3 or num_4 < dot_2 or dot_2 < -num_4 or num_5 < dot_3 or not (dot_3 < -num_5)) then
		return
	end

	local system = Managers.state.entity:system("area_damage_system")
	local num_6 = 2
	local num_7 = 2
	local num_8

	if dot == 0 then
		num_8 = 1 - math.random(0, 1) * 2

		if not num_8 then
			-- Nothing
		end
	end

	num_8 = math.sign(dot)

	::label_72_0::

	local var_72_13
	local var_72_14
	local var_72_15 = num_3
	local proximite_enemies = arg_72_10.proximite_enemies

	for i = 1, 2 do
		for j = 1, #tbl_28 do
			local num_9 = tbl_28[j] * math.pi * 0.25
			local num_10 = 1 / math.cos(num_9)
			local num_11 = arg_72_2 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), num_9), right) * num_10 * (num_8 * var_72_15)

			if Vector3.distance_squared(arg_72_2, num_11) > 1e-06 then
				local triangle_from_position, var_72_21 = GwNavQueries.triangle_from_position(arg_72_0, num_11, num_6, num_7)

				if not triangle_from_position then
					num_11.z = var_72_21
				end

				if not (not triangle_from_position and GwNavQueries.raycango(arg_72_0, arg_72_2, num_11, arg_72_1)) then
					var_72_14 = num_11

					if not system:is_position_in_liquid(num_11, BotNavTransitionManager.NAV_COST_MAP_LAYERS) then
						if not (fn_5(arg_72_10, arg_72_2, num_11, arg_72_4, proximite_enemies) or fn(arg_72_11, num_11, arg_72_4)) then
							var_72_13 = num_11
						end

						var_72_14 = num_11
					end
				end
			end

			if not var_72_13 then
				break
			end
		end

		if not var_72_13 then
			break
		end

		num_8 = -num_8
	end

	return var_72_13 or var_72_14
end

AIBotGroupSystem.aoe_threat_created = function (self, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6)
	-- function 73
	local time = Managers.time:time("game")
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local traverse_logic = Managers.state.bot_nav_transition:traverse_logic()
	local var_73_3

	if arg_73_2 == "oobb" then
		var_73_3 = fn_8
	elseif arg_73_2 == "cylinder" then
		var_73_3 = fn_6
	elseif arg_73_2 == "sphere" then
		var_73_3 = fn_7
	end

	local num = time + arg_73_5
	local tbl = {
		pos = Vector3Box(arg_73_1)
	}
	local var_73_6

	if not arg_73_4 then
		var_73_6 = QuaternionBox(arg_73_4)

		if not var_73_6 then
			-- Nothing
		end
	end

	var_73_6 = nil

	::label_73_0::

	tbl.rot = var_73_6
	tbl.size = type(arg_73_3) ~= "number" or not arg_73_3 or Vector3Box(arg_73_3)
	tbl.shape = arg_73_2
	tbl.expires = num
	tbl.source = arg_73_6

	local _existing_bot_threats = self._existing_bot_threats
	local x = arg_73_1.x
	local y = arg_73_1.y
	local z = arg_73_1.z
	local _bot_ai_data = self._bot_ai_data

	for i = 1, #_bot_ai_data do
		local var_73_12 = _bot_ai_data[i]

		for k, v in pairs(var_73_12) do
			local aoe_threat = v.aoe_threat
			local var_73_14 = var_73_3(nav_world, traverse_logic, Unit.local_position(k, 0), num_8, num_7, x, y, z, arg_73_4, arg_73_3, BLACKBOARDS[k], _existing_bot_threats)

			if not var_73_14 then
				aoe_threat.expires = math.max(aoe_threat.expires, num)

				aoe_threat.escape_to:store(var_73_14)
			end
		end
	end

	table.insert(_existing_bot_threats, tbl)

	return tbl
end

AIBotGroupSystem.remove_threat = function (self, arg_74_1)
	-- function 74
	local _existing_bot_threats = self._existing_bot_threats
	local find = table.find(_existing_bot_threats, arg_74_1)

	if not find then
		table.swap_delete(_existing_bot_threats, find)
	end

	local num = 0

	for i = 1, #_existing_bot_threats do
		local expires = _existing_bot_threats[i].expires

		if expires ~= math.huge then
			num = math.max(num, expires)
		end
	end

	local _bot_ai_data = self._bot_ai_data

	for j = 1, #_bot_ai_data do
		local var_74_5 = _bot_ai_data[j]

		for k, v in pairs(var_74_5) do
			local aoe_threat = v.aoe_threat

			if aoe_threat.expires > 0 then
				aoe_threat.expires = num
			elseif not next(_existing_bot_threats) then
				aoe_threat.expires = math.huge
			end
		end
	end
end

local tbl_29 = {
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

AIBotGroupSystem._chat_message = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3, ...)
	-- function 75
	local owner = Managers.player:owner(arg_75_1)
	local display_name = SPProfiles[owner:profile_index()].display_name
	local var_75_2 = tbl_29[arg_75_3]
	local var_75_3 = var_75_2[display_name]

	var_75_3 = var_75_3 or var_75_2.default

	local var_75_4 = var_75_3[Math.random(1, #var_75_3)]
	local flag = true
	local flag_2 = true
	local alloc_table = FrameTable.alloc_table()

	table.append_varargs(alloc_table, ...)

	local num = 1
	local var_75_9
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism.get_chat_channel then
		local network_id = arg_75_2:network_id()

		num, var_75_9 = game_mechanism:get_chat_channel(network_id, false)
	end

	Managers.chat:send_chat_message(num, owner:local_player_id(), var_75_4, flag, alloc_table, flag_2, nil, var_75_9)
end
