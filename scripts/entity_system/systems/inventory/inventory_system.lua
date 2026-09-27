-- chunkname: @scripts/entity_system/systems/inventory/inventory_system.lua

require("scripts/unit_extensions/default_player_unit/inventory/simple_inventory_extension")
require("scripts/unit_extensions/default_player_unit/inventory/simple_husk_inventory_extension")

InventorySystem = class(InventorySystem, ExtensionSystemBase)

local tbl = {
	"rpc_show_inventory",
	"rpc_play_simple_particle_with_vector_variable",
	"rpc_add_equipment",
	"rpc_give_equipment",
	"rpc_add_equipment_limited_item",
	"rpc_wield_equipment",
	"rpc_destroy_slot",
	"rpc_add_equipment_buffs",
	"rpc_add_no_wield_required_equipment_buffs",
	"rpc_add_inventory_slot_item",
	"rpc_start_weapon_fx",
	"rpc_stop_weapon_fx",
	"rpc_update_additional_slot",
	"rpc_weapon_anim_event"
}
local tbl_2 = {
	"SimpleHuskInventoryExtension",
	"SimpleInventoryExtension"
}

InventorySystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	InventorySystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.world = arg_1_1.world
	self.player_manager = arg_1_1.player_manager
	self.profile_synchronizer = arg_1_1.profile_synchronizer
	self.num_grimoires = 0
	self.num_side_objectives = 0

	local tbl_3 = {}
	local sides = Managers.state.side:sides()
	local num = 1

	for i = 1, #sides do
		local var_1_4 = sides[i]

		if not var_1_4.using_grims_and_tomes then
			tbl_3[num] = var_1_4
			num = num + 1
		end
	end

	self.sides_to_update = tbl_3
end

local function fn()
	-- function 2
	local system = Managers.state.entity:system("mission_system")
	local system_2 = Managers.state.entity:system("buff_system")
	local str = "grimoire_hidden_mission"

	system:request_mission(str)
	system:update_mission(str, true, nil, true)

	local grimoire = NetworkLookup.group_buff_templates.grimoire

	system_2:rpc_add_group_buff(nil, grimoire, 1)
end

local function fn_2()
	-- function 3
	local system = Managers.state.entity:system("mission_system")
	local system_2 = Managers.state.entity:system("buff_system")
	local str = "grimoire_hidden_mission"

	system:update_mission(str, false, nil, true)

	local grimoire = NetworkLookup.group_buff_templates.grimoire

	system_2:rpc_remove_group_buff(nil, grimoire, 1)
end

local function fn_3()
	-- function 4
	local system = Managers.state.entity:system("mission_system")
	local str = "tome_bonus_mission"

	system:request_mission(str)
	system:update_mission(str, true, nil, true)
end

local function fn_4()
	-- function 5
	local system = Managers.state.entity:system("mission_system")
	local str = "tome_bonus_mission"

	system:update_mission(str, false, nil, true)
end

InventorySystem.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	InventorySystem.super.update(self, arg_6_1, arg_6_2)

	if not self.is_server then
		local _event_objective = self._event_objective
		local sides_to_update = self.sides_to_update

		for i = 1, #sides_to_update do
			local PLAYER_AND_BOT_UNITS = sides_to_update[i].PLAYER_AND_BOT_UNITS

			self.num_grimoires = self:update_mission_inventory_item(PLAYER_AND_BOT_UNITS, "slot_potion", "wpn_grimoire_01", self.num_grimoires, fn, fn_2)
			self.num_side_objectives = self:update_mission_inventory_item(PLAYER_AND_BOT_UNITS, "slot_healthkit", "wpn_side_objective_tome_01", self.num_side_objectives, fn_3, fn_4)

			if not _event_objective then
				self.num_event_objectives = self:update_mission_inventory_item(PLAYER_AND_BOT_UNITS, "slot_potion", _event_objective, self.num_event_objectives, self._add_event_objective, self._remove_event_objective)
			end
		end
	end
end

InventorySystem.update_mission_inventory_item = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local num = 0

	for i = 1, #arg_7_1 do
		local var_7_1 = arg_7_1[i]

		if not ScriptUnit.extension(var_7_1, "inventory_system"):has_inventory_item(arg_7_2, arg_7_3) then
			num = num + 1
		end
	end

	if arg_7_4 < num then
		local num_2 = num - arg_7_4

		for j = 1, num_2 do
			arg_7_5()
		end
	elseif num < arg_7_4 then
		local num_3 = arg_7_4 - num

		for k = 1, num_3 do
			arg_7_6()
		end
	end

	return num
end

InventorySystem.destroy = function (self)
	-- function 8
	self.network_event_delegate:unregister(self)
end

InventorySystem.register_event_objective = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	self.num_event_objectives = 0
	self._event_objective = arg_9_1
	self._add_event_objective = arg_9_2
	self._remove_event_objective = arg_9_3
end

InventorySystem.rpc_show_inventory = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local unit = self.unit_storage:unit(arg_10_2)

	if not (not unit and ALIVE[unit]) then
		return
	end

	ScriptUnit.extension(unit, "inventory_system"):show_third_person_inventory(arg_10_3)

	if not self.is_server then
		local var_10_1 = CHANNEL_TO_PEER_ID[arg_10_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_show_inventory", var_10_1, arg_10_2, arg_10_3)
	end
end

InventorySystem.rpc_play_simple_particle_with_vector_variable = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	if not self.is_server then
		self.network_transmit:send_rpc_clients("rpc_play_simple_particle_with_vector_variable", arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	end

	local world = self.world
	local var_11_1 = NetworkLookup.effects[arg_11_2]
	local var_11_2 = NetworkLookup.effects[arg_11_4]
	local create_particles = World.create_particles(world, var_11_1, arg_11_3)
	local find_particles_variable = World.find_particles_variable(world, var_11_1, var_11_2)

	World.set_particles_variable(world, create_particles, find_particles_variable, arg_11_5)
end

InventorySystem.rpc_destroy_slot = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not self.is_server then
		local var_12_0 = CHANNEL_TO_PEER_ID[arg_12_1]

		self.network_transmit:send_rpc_clients_except("rpc_destroy_slot", var_12_0, arg_12_2, arg_12_3)
	end

	local unit = self.unit_storage:unit(arg_12_2)
	local var_12_2 = NetworkLookup.equipment_slots[arg_12_3]

	ScriptUnit.extension(unit, "inventory_system"):destroy_slot(var_12_2)
end

InventorySystem.rpc_give_equipment = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local unit = self.unit_storage:unit(arg_13_3)
	local flag = false

	if not (not Unit.alive(unit) and ScriptUnit.extension(unit, "status_system"):is_dead()) then
		local owner = Managers.player:owner(unit)

		if not owner.remote then
			local extension = ScriptUnit.extension(unit, "inventory_system")
			local var_13_4 = NetworkLookup.equipment_slots[arg_13_4]
			local get_slot_data = extension:get_slot_data(var_13_4)
			local flag_2 = not get_slot_data and extension:can_store_additional_item(var_13_4)

			if not (not get_slot_data and flag_2) then
				flag = true
			else
				local var_13_7 = NetworkLookup.item_names[arg_13_5]
				local var_13_8 = ItemMasterList[var_13_7]

				if not get_slot_data then
					extension:store_additional_item(var_13_4, var_13_8)
				else
					extension:add_equipment(var_13_4, var_13_8)

					if not LEVEL_EDITOR_TEST then
						local var_13_9 = NetworkLookup.weapon_skins["n/a"]

						if not self.is_server then
							self.network_transmit:send_rpc_clients("rpc_add_equipment", arg_13_3, arg_13_4, arg_13_5, var_13_9)
						else
							self.network_transmit:send_rpc_server("rpc_add_equipment", arg_13_3, arg_13_4, arg_13_5, var_13_9)
						end
					end
				end

				local pickup_name = BackendUtils.get_item_template(var_13_8).pickup_data.pickup_name
				local var_13_11 = AllPickups[pickup_name]
				local wwise_world = Managers.world:wwise_world(self.world)
				local pickup_sound_event = var_13_11.pickup_sound_event
				local unit_2 = self.unit_storage:unit(arg_13_2)
				local flag_3 = not unit_2 and Managers.player:owner(unit_2)

				if not ((owner.bot_player or not flag_3) and flag_3.local_player) then
					if not pickup_sound_event then
						WwiseWorld.trigger_event(wwise_world, pickup_sound_event)
					end

					local var_13_16 = CHANNEL_TO_PEER_ID[arg_13_1]

					Managers.state.event:trigger("give_item_feedback", var_13_16 .. var_13_7, flag_3, var_13_7)
				end
			end
		else
			assert(self.is_server, "rpc_give_equipment sent to non-owner non-server, should not happen")
			self.network_transmit:send_rpc("rpc_give_equipment", owner:network_id(), arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
		end
	else
		flag = true
	end

	if not flag then
		local var_13_17 = NetworkLookup.item_names[arg_13_5]
		local var_13_18 = ItemMasterList[var_13_17]
		local pickup_name_2 = BackendUtils.get_item_template(var_13_18).pickup_data.pickup_name
		local var_13_20 = NetworkLookup.pickup_names[pickup_name_2]
		local dropped = NetworkLookup.pickup_spawn_types.dropped

		if not self.is_server then
			self.entity_manager:system("pickup_system"):rpc_spawn_pickup_with_physics(Network.peer_id(), var_13_20, arg_13_6, Quaternion.identity(), dropped)
		else
			self.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", var_13_20, arg_13_6, Quaternion.identity(), dropped)
		end
	end
end

InventorySystem.rpc_add_equipment = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	if not self.is_server then
		local var_14_0 = CHANNEL_TO_PEER_ID[arg_14_1]

		self.network_transmit:send_rpc_clients_except("rpc_add_equipment", var_14_0, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	end

	local unit = self.unit_storage:unit(arg_14_2)

	if not (unit == nil or ALIVE[unit]) then
		local var_14_2 = CHANNEL_TO_PEER_ID[arg_14_1]

		printf("[InventorySystem] Failed to call `rpc_add_equipment` for peer_id %s", var_14_2)

		return
	end

	local has_extension = ScriptUnit.has_extension(unit, "inventory_system")

	if not has_extension then
		local var_14_4 = NetworkLookup.equipment_slots[arg_14_3]
		local var_14_5 = NetworkLookup.item_names[arg_14_4]
		local var_14_6 = NetworkLookup.weapon_skins[arg_14_5]

		if var_14_6 == "n/a" then
			var_14_6 = nil
		end

		has_extension:add_equipment(var_14_4, var_14_5, var_14_6)
	end
end

InventorySystem.rpc_add_inventory_slot_item = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local unit = self.unit_storage:unit(arg_15_2)

	if not (unit == nil or ALIVE[unit]) then
		return
	end

	local has_extension = ScriptUnit.has_extension(unit, "inventory_system")

	if not has_extension then
		local var_15_2 = NetworkLookup.equipment_slots[arg_15_3]
		local var_15_3 = NetworkLookup.item_names[arg_15_4]
		local var_15_4 = ItemMasterList[var_15_3]

		has_extension:destroy_slot(var_15_2)
		has_extension:add_equipment(var_15_2, var_15_4)

		if has_extension:get_wielded_slot_name() == var_15_2 then
			CharacterStateHelper.stop_weapon_actions(has_extension, "picked_up_object")
			has_extension:wield(var_15_2)
		end

		if not self.is_server then
			self.network_transmit:send_rpc_clients("rpc_add_equipment", arg_15_2, arg_15_3, arg_15_4, arg_15_5)
		else
			self.network_transmit:send_rpc_server("rpc_add_equipment", arg_15_2, arg_15_3, arg_15_4, arg_15_5)
		end
	end
end

InventorySystem.rpc_add_equipment_buffs = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	-- function 16
	fassert(self.is_server, "attempting to add buffs as a client VIA rpc_add_equipment_buffs")

	local unit = self.unit_storage:unit(arg_16_2)
	local var_16_1 = NetworkLookup.equipment_slots[arg_16_3]
	local buffs_from_rpc_params = BuffUtils.buffs_from_rpc_params(arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	local extension = ScriptUnit.extension(unit, "inventory_system")
	local str = "wield"

	extension:set_buffs_to_slot(str, var_16_1, buffs_from_rpc_params)
end

InventorySystem.rpc_add_no_wield_required_equipment_buffs = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	-- function 17
	fassert(self.is_server, "attempting to add buffs as a client VIA rpc_add_no_wield_required_equipment_buffs")

	local unit = self.unit_storage:unit(arg_17_2)
	local var_17_1 = NetworkLookup.equipment_slots[arg_17_3]
	local buffs_from_rpc_params = BuffUtils.buffs_from_rpc_params(arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	local extension = ScriptUnit.extension(unit, "inventory_system")
	local str = "equip"

	extension:set_buffs_to_slot(str, var_17_1, buffs_from_rpc_params)
end

InventorySystem.rpc_add_equipment_limited_item = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	-- function 18
	if not self.is_server then
		local var_18_0 = CHANNEL_TO_PEER_ID[arg_18_1]

		self.network_transmit:send_rpc_clients_except("rpc_add_equipment_limited_item", var_18_0, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	end

	local unit = self.unit_storage:unit(arg_18_2)
	local var_18_2 = NetworkLookup.equipment_slots[arg_18_3]
	local var_18_3 = NetworkLookup.item_names[arg_18_4]
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_18_5, true)

	ScriptUnit.extension(unit, "inventory_system"):add_equipment_limited_item(var_18_2, var_18_3, game_object_or_level_unit, arg_18_6)
end

InventorySystem.rpc_wield_equipment = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not self.is_server then
		local var_19_0 = CHANNEL_TO_PEER_ID[arg_19_1]

		self.network_transmit:send_rpc_clients_except("rpc_wield_equipment", var_19_0, arg_19_2, arg_19_3)
	end

	local unit = self.unit_storage:unit(arg_19_2)
	local var_19_2 = NetworkLookup.equipment_slots[arg_19_3]

	ScriptUnit.extension(unit, "inventory_system"):wield(var_19_2)
end

InventorySystem.rpc_start_weapon_fx = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	if not self.is_server then
		local var_20_0 = CHANNEL_TO_PEER_ID[arg_20_1]

		self.network_transmit:send_rpc_clients_except("rpc_start_weapon_fx", var_20_0, arg_20_2, arg_20_3, arg_20_4)
	end

	local var_20_1 = NetworkLookup.item_names[arg_20_3]
	local unit = self.unit_storage:unit(arg_20_2)
	local extension = ScriptUnit.extension(unit, "inventory_system")
	local get_wielded_slot_data = extension:get_wielded_slot_data()
	local flag = not get_wielded_slot_data and get_wielded_slot_data.item_data
	local flag_2 = not flag and flag.name

	if not (not var_20_1 and var_20_1 ~= flag_2) then
		local var_20_7 = ItemMasterList[var_20_1]
		local var_20_8 = BackendUtils.get_item_template(var_20_7).particle_fx_lookup[arg_20_4]

		extension:start_weapon_fx(var_20_8, false)
	end
end

InventorySystem.rpc_stop_weapon_fx = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	if not self.is_server then
		local var_21_0 = CHANNEL_TO_PEER_ID[arg_21_1]

		self.network_transmit:send_rpc_clients_except("rpc_stop_weapon_fx", var_21_0, arg_21_2, arg_21_3, arg_21_4)
	end

	local var_21_1 = NetworkLookup.item_names[arg_21_3]
	local unit = self.unit_storage:unit(arg_21_2)
	local extension = ScriptUnit.extension(unit, "inventory_system")
	local get_wielded_slot_data = extension:get_wielded_slot_data()
	local flag = not get_wielded_slot_data and get_wielded_slot_data.item_data
	local flag_2 = not flag and flag.name

	if not (not var_21_1 and var_21_1 ~= flag_2) then
		local var_21_7 = ItemMasterList[var_21_1]
		local var_21_8 = BackendUtils.get_item_template(var_21_7).particle_fx_lookup[arg_21_4]

		extension:stop_weapon_fx(var_21_8, false)
	end
end

InventorySystem.rpc_update_additional_slot = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	if not self.is_server then
		local var_22_0 = CHANNEL_TO_PEER_ID[arg_22_1]

		self.network_transmit:send_rpc_clients_except("rpc_update_additional_slot", var_22_0, arg_22_2, arg_22_3, arg_22_4)
	end

	local tbl = {}

	for i = 1, #arg_22_4 do
		local var_22_2 = arg_22_4[i]

		tbl[#tbl + 1] = NetworkLookup.item_names[var_22_2]
	end

	local unit = self.unit_storage:unit(arg_22_2)
	local extension = ScriptUnit.extension(unit, "inventory_system")
	local var_22_5 = NetworkLookup.equipment_slots[arg_22_3]

	extension:update_additional_items(var_22_5, tbl)
end

InventorySystem.weapon_anim_event = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local extension = ScriptUnit.extension(arg_23_1, "inventory_system")
	local get_all_weapon_unit, var_23_2 = extension:get_all_weapon_unit()

	if not get_all_weapon_unit then
		Unit.animation_event(get_all_weapon_unit, arg_23_2)
	end

	if not var_23_2 then
		Unit.animation_event(var_23_2, arg_23_2)
	end

	if arg_23_3 or not Managers.state.network:game() then
		local go_id = self.unit_storage:go_id(arg_23_1)
		local var_23_4 = NetworkLookup.anims[arg_23_2]
		local get_wielded_slot_name = extension:get_wielded_slot_name()
		local var_23_6 = NetworkLookup.equipment_slots[get_wielded_slot_name]

		if not self.is_server then
			self.network_transmit:send_rpc_clients("rpc_weapon_anim_event", go_id, var_23_6, var_23_4)
		else
			self.network_transmit:send_rpc_server("rpc_weapon_anim_event", go_id, var_23_6, var_23_4)
		end
	end
end

InventorySystem.rpc_weapon_anim_event = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local unit = self.unit_storage:unit(arg_24_2)
	local has_extension = ScriptUnit.has_extension(unit, "inventory_system")

	if not has_extension then
		return
	end

	local get_wielded_slot_name = has_extension:get_wielded_slot_name()

	if NetworkLookup.equipment_slots[arg_24_3] ~= get_wielded_slot_name then
		return
	end

	local flag = true
	local var_24_4 = NetworkLookup.anims[arg_24_4]

	self:weapon_anim_event(unit, var_24_4, flag)
end
