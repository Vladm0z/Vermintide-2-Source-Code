-- chunkname: @scripts/entity_system/systems/inventory/inventory_system.lua

require("scripts/unit_extensions/default_player_unit/inventory/simple_inventory_extension")
require("scripts/unit_extensions/default_player_unit/inventory/simple_husk_inventory_extension")

InventorySystem = class(InventorySystem, ExtensionSystemBase)

local var_0_0 = {
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
local var_0_1 = {
	"SimpleHuskInventoryExtension",
	"SimpleInventoryExtension"
}

InventorySystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	InventorySystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.world = arg_1_1.world
	arg_1_0.player_manager = arg_1_1.player_manager
	arg_1_0.profile_synchronizer = arg_1_1.profile_synchronizer
	arg_1_0.num_grimoires = 0
	arg_1_0.num_side_objectives = 0

	local var_1_1 = {}
	local var_1_2 = Managers.state.side:sides()
	local var_1_3 = 1

	for iter_1_0 = 1, #var_1_2 do
		local var_1_4 = var_1_2[iter_1_0]

		if var_1_4.using_grims_and_tomes then
			var_1_1[var_1_3] = var_1_4
			var_1_3 = var_1_3 + 1
		end
	end

	arg_1_0.sides_to_update = var_1_1
end

local function var_0_2()
	local var_2_0 = Managers.state.entity:system("mission_system")
	local var_2_1 = Managers.state.entity:system("buff_system")
	local var_2_2 = "grimoire_hidden_mission"

	var_2_0:request_mission(var_2_2)
	var_2_0:update_mission(var_2_2, true, nil, true)

	local var_2_3 = NetworkLookup.group_buff_templates.grimoire

	var_2_1:rpc_add_group_buff(nil, var_2_3, 1)
end

local function var_0_3()
	local var_3_0 = Managers.state.entity:system("mission_system")
	local var_3_1 = Managers.state.entity:system("buff_system")
	local var_3_2 = "grimoire_hidden_mission"

	var_3_0:update_mission(var_3_2, false, nil, true)

	local var_3_3 = NetworkLookup.group_buff_templates.grimoire

	var_3_1:rpc_remove_group_buff(nil, var_3_3, 1)
end

local function var_0_4()
	local var_4_0 = Managers.state.entity:system("mission_system")
	local var_4_1 = "tome_bonus_mission"

	var_4_0:request_mission(var_4_1)
	var_4_0:update_mission(var_4_1, true, nil, true)
end

local function var_0_5()
	local var_5_0 = Managers.state.entity:system("mission_system")
	local var_5_1 = "tome_bonus_mission"

	var_5_0:update_mission(var_5_1, false, nil, true)
end

InventorySystem.update = function (arg_6_0, arg_6_1, arg_6_2)
	InventorySystem.super.update(arg_6_0, arg_6_1, arg_6_2)

	if arg_6_0.is_server then
		local var_6_0 = arg_6_0._event_objective
		local var_6_1 = arg_6_0.sides_to_update

		for iter_6_0 = 1, #var_6_1 do
			local var_6_2 = var_6_1[iter_6_0].PLAYER_AND_BOT_UNITS

			arg_6_0.num_grimoires = arg_6_0:update_mission_inventory_item(var_6_2, "slot_potion", "wpn_grimoire_01", arg_6_0.num_grimoires, var_0_2, var_0_3)
			arg_6_0.num_side_objectives = arg_6_0:update_mission_inventory_item(var_6_2, "slot_healthkit", "wpn_side_objective_tome_01", arg_6_0.num_side_objectives, var_0_4, var_0_5)

			if var_6_0 then
				arg_6_0.num_event_objectives = arg_6_0:update_mission_inventory_item(var_6_2, "slot_potion", var_6_0, arg_6_0.num_event_objectives, arg_6_0._add_event_objective, arg_6_0._remove_event_objective)
			end
		end
	end
end

InventorySystem.update_mission_inventory_item = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = 0

	for iter_7_0 = 1, #arg_7_1 do
		local var_7_1 = arg_7_1[iter_7_0]

		if ScriptUnit.extension(var_7_1, "inventory_system"):has_inventory_item(arg_7_2, arg_7_3) then
			var_7_0 = var_7_0 + 1
		end
	end

	if arg_7_4 < var_7_0 then
		local var_7_2 = var_7_0 - arg_7_4

		for iter_7_1 = 1, var_7_2 do
			arg_7_5()
		end
	elseif var_7_0 < arg_7_4 then
		local var_7_3 = arg_7_4 - var_7_0

		for iter_7_2 = 1, var_7_3 do
			arg_7_6()
		end
	end

	return var_7_0
end

InventorySystem.destroy = function (arg_8_0)
	arg_8_0.network_event_delegate:unregister(arg_8_0)
end

InventorySystem.register_event_objective = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.num_event_objectives = 0
	arg_9_0._event_objective = arg_9_1
	arg_9_0._add_event_objective = arg_9_2
	arg_9_0._remove_event_objective = arg_9_3
end

InventorySystem.rpc_show_inventory = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0.unit_storage:unit(arg_10_2)

	if not var_10_0 or not ALIVE[var_10_0] then
		return
	end

	ScriptUnit.extension(var_10_0, "inventory_system"):show_third_person_inventory(arg_10_3)

	if arg_10_0.is_server then
		local var_10_1 = CHANNEL_TO_PEER_ID[arg_10_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_show_inventory", var_10_1, arg_10_2, arg_10_3)
	end
end

InventorySystem.rpc_play_simple_particle_with_vector_variable = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	if arg_11_0.is_server then
		arg_11_0.network_transmit:send_rpc_clients("rpc_play_simple_particle_with_vector_variable", arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	end

	local var_11_0 = arg_11_0.world
	local var_11_1 = NetworkLookup.effects[arg_11_2]
	local var_11_2 = NetworkLookup.effects[arg_11_4]
	local var_11_3 = World.create_particles(var_11_0, var_11_1, arg_11_3)
	local var_11_4 = World.find_particles_variable(var_11_0, var_11_1, var_11_2)

	World.set_particles_variable(var_11_0, var_11_3, var_11_4, arg_11_5)
end

InventorySystem.rpc_destroy_slot = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if arg_12_0.is_server then
		local var_12_0 = CHANNEL_TO_PEER_ID[arg_12_1]

		arg_12_0.network_transmit:send_rpc_clients_except("rpc_destroy_slot", var_12_0, arg_12_2, arg_12_3)
	end

	local var_12_1 = arg_12_0.unit_storage:unit(arg_12_2)
	local var_12_2 = NetworkLookup.equipment_slots[arg_12_3]

	ScriptUnit.extension(var_12_1, "inventory_system"):destroy_slot(var_12_2)
end

InventorySystem.rpc_give_equipment = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = arg_13_0.unit_storage:unit(arg_13_3)
	local var_13_1 = false

	if Unit.alive(var_13_0) and not ScriptUnit.extension(var_13_0, "status_system"):is_dead() then
		local var_13_2 = Managers.player:owner(var_13_0)

		if not var_13_2.remote then
			local var_13_3 = ScriptUnit.extension(var_13_0, "inventory_system")
			local var_13_4 = NetworkLookup.equipment_slots[arg_13_4]
			local var_13_5 = var_13_3:get_slot_data(var_13_4)
			local var_13_6 = var_13_5 and var_13_3:can_store_additional_item(var_13_4)

			if var_13_5 and not var_13_6 then
				var_13_1 = true
			else
				local var_13_7 = NetworkLookup.item_names[arg_13_5]
				local var_13_8 = ItemMasterList[var_13_7]

				if var_13_5 then
					var_13_3:store_additional_item(var_13_4, var_13_8)
				else
					var_13_3:add_equipment(var_13_4, var_13_8)

					if not LEVEL_EDITOR_TEST then
						local var_13_9 = NetworkLookup.weapon_skins["n/a"]

						if arg_13_0.is_server then
							arg_13_0.network_transmit:send_rpc_clients("rpc_add_equipment", arg_13_3, arg_13_4, arg_13_5, var_13_9)
						else
							arg_13_0.network_transmit:send_rpc_server("rpc_add_equipment", arg_13_3, arg_13_4, arg_13_5, var_13_9)
						end
					end
				end

				local var_13_10 = BackendUtils.get_item_template(var_13_8).pickup_data.pickup_name
				local var_13_11 = AllPickups[var_13_10]
				local var_13_12 = Managers.world:wwise_world(arg_13_0.world)
				local var_13_13 = var_13_11.pickup_sound_event
				local var_13_14 = arg_13_0.unit_storage:unit(arg_13_2)
				local var_13_15 = var_13_14 and Managers.player:owner(var_13_14)

				if not var_13_2.bot_player and var_13_15 and not var_13_15.local_player then
					if var_13_13 then
						WwiseWorld.trigger_event(var_13_12, var_13_13)
					end

					local var_13_16 = CHANNEL_TO_PEER_ID[arg_13_1]

					Managers.state.event:trigger("give_item_feedback", var_13_16 .. var_13_7, var_13_15, var_13_7)
				end
			end
		else
			assert(arg_13_0.is_server, "rpc_give_equipment sent to non-owner non-server, should not happen")
			arg_13_0.network_transmit:send_rpc("rpc_give_equipment", var_13_2:network_id(), arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
		end
	else
		var_13_1 = true
	end

	if var_13_1 then
		local var_13_17 = NetworkLookup.item_names[arg_13_5]
		local var_13_18 = ItemMasterList[var_13_17]
		local var_13_19 = BackendUtils.get_item_template(var_13_18).pickup_data.pickup_name
		local var_13_20 = NetworkLookup.pickup_names[var_13_19]
		local var_13_21 = NetworkLookup.pickup_spawn_types.dropped

		if arg_13_0.is_server then
			arg_13_0.entity_manager:system("pickup_system"):rpc_spawn_pickup_with_physics(Network.peer_id(), var_13_20, arg_13_6, Quaternion.identity(), var_13_21)
		else
			arg_13_0.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", var_13_20, arg_13_6, Quaternion.identity(), var_13_21)
		end
	end
end

InventorySystem.rpc_add_equipment = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	if arg_14_0.is_server then
		local var_14_0 = CHANNEL_TO_PEER_ID[arg_14_1]

		arg_14_0.network_transmit:send_rpc_clients_except("rpc_add_equipment", var_14_0, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	end

	local var_14_1 = arg_14_0.unit_storage:unit(arg_14_2)

	if var_14_1 == nil or not ALIVE[var_14_1] then
		return
	end

	local var_14_2 = ScriptUnit.has_extension(var_14_1, "inventory_system")

	if var_14_2 then
		local var_14_3 = NetworkLookup.equipment_slots[arg_14_3]
		local var_14_4 = NetworkLookup.item_names[arg_14_4]
		local var_14_5 = NetworkLookup.weapon_skins[arg_14_5]

		if var_14_5 == "n/a" then
			var_14_5 = nil
		end

		var_14_2:add_equipment(var_14_3, var_14_4, var_14_5)
	end
end

InventorySystem.rpc_add_inventory_slot_item = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = arg_15_0.unit_storage:unit(arg_15_2)

	if var_15_0 == nil or not ALIVE[var_15_0] then
		return
	end

	local var_15_1 = ScriptUnit.has_extension(var_15_0, "inventory_system")

	if var_15_1 then
		local var_15_2 = NetworkLookup.equipment_slots[arg_15_3]
		local var_15_3 = NetworkLookup.item_names[arg_15_4]
		local var_15_4 = ItemMasterList[var_15_3]

		var_15_1:destroy_slot(var_15_2)
		var_15_1:add_equipment(var_15_2, var_15_4)

		if var_15_1:get_wielded_slot_name() == var_15_2 then
			CharacterStateHelper.stop_weapon_actions(var_15_1, "picked_up_object")
			var_15_1:wield(var_15_2)
		end

		if arg_15_0.is_server then
			arg_15_0.network_transmit:send_rpc_clients("rpc_add_equipment", arg_15_2, arg_15_3, arg_15_4, arg_15_5)
		else
			arg_15_0.network_transmit:send_rpc_server("rpc_add_equipment", arg_15_2, arg_15_3, arg_15_4, arg_15_5)
		end
	end
end

InventorySystem.rpc_add_equipment_buffs = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	fassert(arg_16_0.is_server, "attempting to add buffs as a client VIA rpc_add_equipment_buffs")

	local var_16_0 = arg_16_0.unit_storage:unit(arg_16_2)
	local var_16_1 = NetworkLookup.equipment_slots[arg_16_3]
	local var_16_2 = BuffUtils.buffs_from_rpc_params(arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	local var_16_3 = ScriptUnit.extension(var_16_0, "inventory_system")
	local var_16_4 = "wield"

	var_16_3:set_buffs_to_slot(var_16_4, var_16_1, var_16_2)
end

InventorySystem.rpc_add_no_wield_required_equipment_buffs = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	fassert(arg_17_0.is_server, "attempting to add buffs as a client VIA rpc_add_no_wield_required_equipment_buffs")

	local var_17_0 = arg_17_0.unit_storage:unit(arg_17_2)
	local var_17_1 = NetworkLookup.equipment_slots[arg_17_3]
	local var_17_2 = BuffUtils.buffs_from_rpc_params(arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	local var_17_3 = ScriptUnit.extension(var_17_0, "inventory_system")
	local var_17_4 = "equip"

	var_17_3:set_buffs_to_slot(var_17_4, var_17_1, var_17_2)
end

InventorySystem.rpc_add_equipment_limited_item = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	if arg_18_0.is_server then
		local var_18_0 = CHANNEL_TO_PEER_ID[arg_18_1]

		arg_18_0.network_transmit:send_rpc_clients_except("rpc_add_equipment_limited_item", var_18_0, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	end

	local var_18_1 = arg_18_0.unit_storage:unit(arg_18_2)
	local var_18_2 = NetworkLookup.equipment_slots[arg_18_3]
	local var_18_3 = NetworkLookup.item_names[arg_18_4]
	local var_18_4 = Managers.state.network:game_object_or_level_unit(arg_18_5, true)

	ScriptUnit.extension(var_18_1, "inventory_system"):add_equipment_limited_item(var_18_2, var_18_3, var_18_4, arg_18_6)
end

InventorySystem.rpc_wield_equipment = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if arg_19_0.is_server then
		local var_19_0 = CHANNEL_TO_PEER_ID[arg_19_1]

		arg_19_0.network_transmit:send_rpc_clients_except("rpc_wield_equipment", var_19_0, arg_19_2, arg_19_3)
	end

	local var_19_1 = arg_19_0.unit_storage:unit(arg_19_2)
	local var_19_2 = NetworkLookup.equipment_slots[arg_19_3]

	ScriptUnit.extension(var_19_1, "inventory_system"):wield(var_19_2)
end

InventorySystem.rpc_start_weapon_fx = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if arg_20_0.is_server then
		local var_20_0 = CHANNEL_TO_PEER_ID[arg_20_1]

		arg_20_0.network_transmit:send_rpc_clients_except("rpc_start_weapon_fx", var_20_0, arg_20_2, arg_20_3, arg_20_4)
	end

	local var_20_1 = NetworkLookup.item_names[arg_20_3]
	local var_20_2 = arg_20_0.unit_storage:unit(arg_20_2)
	local var_20_3 = ScriptUnit.extension(var_20_2, "inventory_system")
	local var_20_4 = var_20_3:get_wielded_slot_data()
	local var_20_5 = var_20_4 and var_20_4.item_data
	local var_20_6 = var_20_5 and var_20_5.name

	if var_20_1 and var_20_1 == var_20_6 then
		local var_20_7 = ItemMasterList[var_20_1]
		local var_20_8 = BackendUtils.get_item_template(var_20_7).particle_fx_lookup[arg_20_4]

		var_20_3:start_weapon_fx(var_20_8, false)
	end
end

InventorySystem.rpc_stop_weapon_fx = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if arg_21_0.is_server then
		local var_21_0 = CHANNEL_TO_PEER_ID[arg_21_1]

		arg_21_0.network_transmit:send_rpc_clients_except("rpc_stop_weapon_fx", var_21_0, arg_21_2, arg_21_3, arg_21_4)
	end

	local var_21_1 = NetworkLookup.item_names[arg_21_3]
	local var_21_2 = arg_21_0.unit_storage:unit(arg_21_2)
	local var_21_3 = ScriptUnit.extension(var_21_2, "inventory_system")
	local var_21_4 = var_21_3:get_wielded_slot_data()
	local var_21_5 = var_21_4 and var_21_4.item_data
	local var_21_6 = var_21_5 and var_21_5.name

	if var_21_1 and var_21_1 == var_21_6 then
		local var_21_7 = ItemMasterList[var_21_1]
		local var_21_8 = BackendUtils.get_item_template(var_21_7).particle_fx_lookup[arg_21_4]

		var_21_3:stop_weapon_fx(var_21_8, false)
	end
end

InventorySystem.rpc_update_additional_slot = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	if arg_22_0.is_server then
		local var_22_0 = CHANNEL_TO_PEER_ID[arg_22_1]

		arg_22_0.network_transmit:send_rpc_clients_except("rpc_update_additional_slot", var_22_0, arg_22_2, arg_22_3, arg_22_4)
	end

	local var_22_1 = {}

	for iter_22_0 = 1, #arg_22_4 do
		local var_22_2 = arg_22_4[iter_22_0]

		var_22_1[#var_22_1 + 1] = NetworkLookup.item_names[var_22_2]
	end

	local var_22_3 = arg_22_0.unit_storage:unit(arg_22_2)
	local var_22_4 = ScriptUnit.extension(var_22_3, "inventory_system")
	local var_22_5 = NetworkLookup.equipment_slots[arg_22_3]

	var_22_4:update_additional_items(var_22_5, var_22_1)
end

InventorySystem.weapon_anim_event = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = ScriptUnit.extension(arg_23_1, "inventory_system")
	local var_23_1, var_23_2 = var_23_0:get_all_weapon_unit()

	if var_23_1 then
		Unit.animation_event(var_23_1, arg_23_2)
	end

	if var_23_2 then
		Unit.animation_event(var_23_2, arg_23_2)
	end

	if not arg_23_3 and Managers.state.network:game() then
		local var_23_3 = arg_23_0.unit_storage:go_id(arg_23_1)
		local var_23_4 = NetworkLookup.anims[arg_23_2]
		local var_23_5 = var_23_0:get_wielded_slot_name()
		local var_23_6 = NetworkLookup.equipment_slots[var_23_5]

		if arg_23_0.is_server then
			arg_23_0.network_transmit:send_rpc_clients("rpc_weapon_anim_event", var_23_3, var_23_6, var_23_4)
		else
			arg_23_0.network_transmit:send_rpc_server("rpc_weapon_anim_event", var_23_3, var_23_6, var_23_4)
		end
	end
end

InventorySystem.rpc_weapon_anim_event = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_0.unit_storage:unit(arg_24_2)
	local var_24_1 = ScriptUnit.has_extension(var_24_0, "inventory_system")

	if not var_24_1 then
		return
	end

	local var_24_2 = var_24_1:get_wielded_slot_name()

	if NetworkLookup.equipment_slots[arg_24_3] ~= var_24_2 then
		return
	end

	local var_24_3 = true
	local var_24_4 = NetworkLookup.anims[arg_24_4]

	arg_24_0:weapon_anim_event(var_24_0, var_24_4, var_24_3)
end
