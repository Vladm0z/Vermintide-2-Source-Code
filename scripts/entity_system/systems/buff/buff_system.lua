-- chunkname: @scripts/entity_system/systems/buff/buff_system.lua

require("scripts/entity_system/systems/buff/buff_sync_type")
require("scripts/unit_extensions/default_player_unit/buffs/buff_templates")
require("scripts/unit_extensions/default_player_unit/buffs/group_buff_templates")
require("scripts/unit_extensions/default_player_unit/buffs/buff_function_templates")
require("scripts/unit_extensions/default_player_unit/buffs/buff_extension")

BuffSystem = class(BuffSystem, ExtensionSystemBase)
IGNORED_ITEM_TYPES_FOR_BUFFS = {}

local var_0_0 = {
	"rpc_add_buff",
	"rpc_add_volume_buff_multiplier",
	"rpc_remove_volume_buff",
	"rpc_add_group_buff",
	"rpc_remove_group_buff",
	"rpc_buff_on_attack",
	"rpc_remove_server_controlled_buff",
	"rpc_proc_event",
	"rpc_remove_gromril_armour",
	"rpc_add_buff_synced",
	"rpc_add_buff_synced_params",
	"rpc_add_buff_synced_relay",
	"rpc_add_buff_synced_relay_params",
	"rpc_add_buff_synced_response",
	"rpc_remove_buff_synced"
}
local var_0_1 = {
	"BuffExtension"
}

function BuffSystem.init(arg_1_0, arg_1_1, arg_1_2)
	BuffSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.network_manager = arg_1_1.network_manager
	arg_1_0.unit_extension_data = {}
	arg_1_0.frozen_unit_extension_data = {}
	arg_1_0.player_group_buffs = {}
	arg_1_0.volume_buffs = {}
	arg_1_0.server_controlled_buffs = {}

	if arg_1_0.is_server then
		arg_1_0.next_server_buff_id = 1
		arg_1_0.free_server_buff_ids = {}
	end

	arg_1_0.active_buff_units = {}
	arg_1_0._activated_buff_units_during_update = {}
end

function BuffSystem.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = BuffSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.unit_extension_data[arg_2_2] = var_2_0

	return var_2_0
end

function BuffSystem.hot_join_sync(arg_3_0, arg_3_1)
	if arg_3_0.is_server then
		local var_3_0 = #arg_3_0.player_group_buffs
		local var_3_1 = arg_3_0.network_manager
		local var_3_2 = var_3_1.network_transmit

		for iter_3_0 = 1, var_3_0 do
			local var_3_3 = arg_3_0.player_group_buffs[iter_3_0].group_buff_template_name
			local var_3_4 = NetworkLookup.group_buff_templates[var_3_3]

			var_3_2:send_rpc("rpc_add_group_buff", arg_3_1, var_3_4, 1)
		end

		for iter_3_1, iter_3_2 in pairs(arg_3_0.server_controlled_buffs) do
			for iter_3_3, iter_3_4 in pairs(iter_3_2) do
				local var_3_5 = var_3_1:unit_game_object_id(iter_3_1)

				if var_3_5 then
					local var_3_6 = iter_3_4.template_name
					local var_3_7 = iter_3_4.attacker_unit
					local var_3_8 = NetworkLookup.buff_templates[var_3_6]
					local var_3_9 = var_3_1:unit_game_object_id(var_3_7) or NetworkConstants.invalid_game_object_id

					var_3_2:send_rpc("rpc_add_buff", arg_3_1, var_3_5, var_3_8, var_3_9, iter_3_3, false)
				end
			end
		end

		arg_3_0:_hot_join_sync_synced_buffs(arg_3_1)
	end
end

function BuffSystem._clean_up_server_controller_buffs(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.server_controlled_buffs[arg_4_1]

	if var_4_0 then
		for iter_4_0, iter_4_1 in pairs(var_4_0) do
			var_4_0[iter_4_0] = nil

			if arg_4_0.is_server then
				arg_4_0.free_server_buff_ids[#arg_4_0.free_server_buff_ids + 1] = iter_4_0
			end
		end

		arg_4_0.server_controlled_buffs[arg_4_1] = nil

		Managers.state.event:trigger("on_clean_up_server_controlled_buffs", arg_4_1)
	end
end

function BuffSystem.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.unit_extension_data[arg_5_1]

	if var_5_0 then
		var_5_0:clear()
	end

	arg_5_0.frozen_unit_extension_data[arg_5_1] = nil
	arg_5_0.unit_extension_data[arg_5_1] = nil
	arg_5_0.active_buff_units[arg_5_1] = nil

	arg_5_0:_clean_up_server_controller_buffs(arg_5_1)
	BuffSystem.super.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
end

function BuffSystem.on_freeze_extension(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:freeze(arg_6_1, arg_6_2)
end

function BuffSystem.freeze(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.frozen_unit_extension_data

	if var_7_0[arg_7_1] then
		return
	end

	local var_7_1 = arg_7_0.unit_extension_data[arg_7_1]

	fassert(var_7_1, "Unit to freeze didn't have unfrozen extension")

	arg_7_0.unit_extension_data[arg_7_1] = nil
	var_7_0[arg_7_1] = var_7_1

	var_7_1:freeze()
	arg_7_0:_clean_up_server_controller_buffs(arg_7_1)
	fassert(arg_7_0.active_buff_units[arg_7_1] == nil, "Unit had active buffs after freeze!")
end

function BuffSystem.unfreeze(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.frozen_unit_extension_data[arg_8_1]

	fassert(var_8_0, "Unit to unfreeze didn't have frozen extension")

	arg_8_0.frozen_unit_extension_data[arg_8_1] = nil
	arg_8_0.unit_extension_data[arg_8_1] = var_8_0

	var_8_0:unfreeze()
end

local var_0_2 = {}

function BuffSystem.update(arg_9_0, arg_9_1, arg_9_2)
	if not script_data.buff_no_opt then
		local var_9_0 = arg_9_1.dt
		local var_9_1 = arg_9_0.active_buff_units

		arg_9_0.in_update = true

		for iter_9_0, iter_9_1 in pairs(var_9_1) do
			local var_9_2 = var_9_1[iter_9_0]

			assert(#var_9_2._buffs > 0, "Unit was active but didn't have buffs")
			var_9_2:update(iter_9_0, var_0_2, var_9_0, arg_9_1, arg_9_2)
		end

		for iter_9_2, iter_9_3 in pairs(arg_9_0._activated_buff_units_during_update) do
			var_9_1[iter_9_2] = iter_9_3
		end

		table.clear(arg_9_0._activated_buff_units_during_update)

		arg_9_0.in_update = false
	else
		BuffSystem.super.update(arg_9_0, arg_9_1, arg_9_2)
	end
end

function BuffSystem.get_player_group_buffs(arg_10_0)
	return arg_10_0.player_group_buffs
end

function BuffSystem.destroy(arg_11_0)
	arg_11_0.network_event_delegate:unregister(arg_11_0)

	arg_11_0.network_event_delegate = nil
	arg_11_0.unit_extension_data = nil
	arg_11_0.active_buff_units = nil
end

function BuffSystem._next_free_server_buff_id(arg_12_0)
	local var_12_0 = arg_12_0.free_server_buff_ids
	local var_12_1 = #var_12_0
	local var_12_2

	if var_12_1 > 0 then
		var_12_2 = var_12_0[var_12_1]
		var_12_0[var_12_1] = nil
	else
		var_12_2 = arg_12_0.next_server_buff_id
		arg_12_0.next_server_buff_id = arg_12_0.next_server_buff_id + 1
	end

	if var_12_2 > NetworkConstants.server_controlled_buff_id.max then
		print("===== [BuffSystem] server controlled buffs dump =====")

		local var_12_3 = 0

		for iter_12_0, iter_12_1 in pairs(arg_12_0.server_controlled_buffs) do
			for iter_12_2, iter_12_3 in pairs(iter_12_1) do
				print(iter_12_0, iter_12_2, HEALTH_ALIVE[iter_12_0], iter_12_3.template_name, iter_12_3.attacker_unit)

				var_12_3 = var_12_3 + 1
			end
		end

		printf("Found %s buffs", var_12_3)
		ferror("[BuffSystem] ERROR! Too many server controlled buffs! (%d/%d)", var_12_2, NetworkConstants.server_controlled_buff_id.max)
	end

	return var_12_2
end

local var_0_3 = {}

function BuffSystem._add_buff_helper_function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = ScriptUnit.extension(arg_13_1, "buff_system")

	var_0_3.attacker_unit = arg_13_3
	var_0_3.power_level = arg_13_5
	var_0_3.source_attacker_unit = arg_13_6

	if arg_13_4 > 0 then
		if not arg_13_0.server_controlled_buffs[arg_13_1] then
			arg_13_0.server_controlled_buffs[arg_13_1] = {}
		end

		local var_13_1 = BuffUtils.get_buff_template(arg_13_2).buffs

		for iter_13_0 = 1, #var_13_1 do
			local var_13_2 = var_13_1[iter_13_0]

			fassert(var_13_2.duration == nil, "[BuffSystem] Error! Cannot use duration for server controlled buffs! (template = %s) Use a normal buff if it should have a duration!", arg_13_2)
		end

		if not arg_13_0.server_controlled_buffs[arg_13_1][arg_13_4] then
			local var_13_3 = var_13_0:add_buff(arg_13_2, var_0_3)

			arg_13_0.server_controlled_buffs[arg_13_1][arg_13_4] = {
				local_buff_id = var_13_3,
				template_name = arg_13_2,
				attacker_unit = arg_13_3,
				source_attacker_unit = arg_13_6
			}
		end
	else
		var_13_0:add_buff(arg_13_2, var_0_3)
	end
end

function BuffSystem.add_buff(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	if not ScriptUnit.has_extension(arg_14_1, "buff_system") then
		return
	end

	fassert(arg_14_0.is_server or not arg_14_4, "[BuffSystem]: Trying to add a server controlled buff from a client!")

	if arg_14_4 and not HEALTH_ALIVE[arg_14_1] then
		return nil
	end

	local var_14_0 = arg_14_4 and arg_14_0:_next_free_server_buff_id() or 0

	if ScriptUnit.has_extension(arg_14_1, "buff_system") then
		arg_14_0:_add_buff_helper_function(arg_14_1, arg_14_2, arg_14_3, var_14_0, arg_14_5, arg_14_6)
	end

	local var_14_1 = arg_14_0.network_manager
	local var_14_2 = var_14_1:game_object_or_level_id(arg_14_1)
	local var_14_3 = var_14_1:game_object_or_level_id(arg_14_3)

	if not var_14_2 or not var_14_3 then
		return var_14_0
	end

	local var_14_4 = NetworkLookup.buff_templates[arg_14_2]

	if arg_14_0.is_server then
		var_14_1.network_transmit:send_rpc_clients("rpc_add_buff", var_14_2, var_14_4, var_14_3, var_14_0, false)
	else
		var_14_1.network_transmit:send_rpc_server("rpc_add_buff", var_14_2, var_14_4, var_14_3, 0, false)
	end

	return var_14_0
end

function BuffSystem.remove_server_controlled_buff(arg_15_0, arg_15_1, arg_15_2)
	fassert(arg_15_0.is_server, "[BuffSystem]: Only the server can explicitly remove server controlled buffs!")

	local var_15_0 = 0

	if ALIVE[arg_15_1] and arg_15_2 then
		local var_15_1 = ScriptUnit.extension(arg_15_1, "buff_system")
		local var_15_2 = arg_15_0.server_controlled_buffs
		local var_15_3 = var_15_2 and var_15_2[arg_15_1]

		if var_15_3 then
			local var_15_4 = var_15_3[arg_15_2]

			if var_15_4 then
				var_15_3[arg_15_2] = nil

				local var_15_5 = var_15_4 and var_15_4.local_buff_id

				var_15_0 = var_15_1:remove_buff(var_15_5) or 0
				arg_15_0.free_server_buff_ids[#arg_15_0.free_server_buff_ids + 1] = arg_15_2
			end
		end

		local var_15_6 = arg_15_0.network_manager
		local var_15_7 = var_15_6:game_object_or_level_id(arg_15_1)

		if var_15_7 then
			var_15_6.network_transmit:send_rpc_clients("rpc_remove_server_controlled_buff", var_15_7, arg_15_2)
		end
	end

	return var_15_0
end

function BuffSystem.has_server_controlled_buff(arg_16_0, arg_16_1, arg_16_2)
	fassert(arg_16_0.is_server, "[BuffSystem]: Only the server can explicitly can check server controlled buffs!")

	return arg_16_0.server_controlled_buffs[arg_16_1] and arg_16_0.server_controlled_buffs[arg_16_1][arg_16_2]
end

function BuffSystem.add_volume_buff_multiplier(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	fassert(arg_17_0.is_server, "[BuffSystem] add_volume_buff_multiplier should only be called on server!")

	local var_17_0 = Managers.player:unit_owner(arg_17_1)

	if var_17_0.remote then
		local var_17_1 = Managers.state.network
		local var_17_2 = var_17_1:unit_game_object_id(arg_17_1)
		local var_17_3 = NetworkLookup.buff_templates.movement_volume_generic_slowdown

		var_17_1.network_transmit:send_rpc("rpc_add_volume_buff_multiplier", var_17_0.peer_id, var_17_2, var_17_3, arg_17_3)
	else
		arg_17_0:add_volume_buff(arg_17_1, arg_17_2, arg_17_3)
	end
end

function BuffSystem.add_volume_buff(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if not Unit.alive(arg_18_1) then
		return
	end

	local var_18_0 = ScriptUnit.extension(arg_18_1, "buff_system")
	local var_18_1 = {
		external_optional_multiplier = arg_18_3
	}

	if not arg_18_0.volume_buffs[arg_18_1] then
		arg_18_0.volume_buffs[arg_18_1] = {}
	end

	if not arg_18_0.volume_buffs[arg_18_1][arg_18_2] then
		arg_18_0.volume_buffs[arg_18_1][arg_18_2] = var_18_0:add_buff(arg_18_2, var_18_1)
	end
end

function BuffSystem.remove_volume_buff_multiplier(arg_19_0, arg_19_1, arg_19_2)
	fassert(arg_19_0.is_server, "[BuffSystem] remove_volume_buff should only be called on server!")

	local var_19_0 = Managers.player:unit_owner(arg_19_1)

	if var_19_0.remote then
		local var_19_1 = Managers.state.network
		local var_19_2 = var_19_1:unit_game_object_id(arg_19_1)
		local var_19_3 = NetworkLookup.buff_templates.movement_volume_generic_slowdown

		var_19_1.network_transmit:send_rpc("rpc_remove_volume_buff", var_19_0.peer_id, var_19_2, var_19_3)
	else
		arg_19_0:remove_volume_buff(arg_19_1, arg_19_2)
	end
end

function BuffSystem.remove_volume_buff(arg_20_0, arg_20_1, arg_20_2)
	if not Unit.alive(arg_20_1) then
		return
	end

	local var_20_0 = ScriptUnit.extension(arg_20_1, "buff_system")
	local var_20_1 = arg_20_0.volume_buffs[arg_20_1][arg_20_2]

	var_20_0:remove_buff(var_20_1)

	arg_20_0.volume_buffs[arg_20_1][arg_20_2] = nil
end

function BuffSystem.rpc_add_buff(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	if arg_21_0.is_server then
		if arg_21_6 then
			arg_21_0.network_manager.network_transmit:send_rpc_clients("rpc_add_buff", arg_21_2, arg_21_3, arg_21_4, 0, false)
		else
			local var_21_0 = CHANNEL_TO_PEER_ID[arg_21_1]

			arg_21_0.network_manager.network_transmit:send_rpc_clients_except("rpc_add_buff", var_21_0, arg_21_2, arg_21_3, arg_21_4, 0, false)
		end
	end

	local var_21_1 = arg_21_0.unit_storage:unit(arg_21_2)
	local var_21_2 = arg_21_0.unit_storage:unit(arg_21_4)
	local var_21_3 = NetworkLookup.buff_templates[arg_21_3]

	if ScriptUnit.has_extension(var_21_1, "buff_system") then
		arg_21_0:_add_buff_helper_function(var_21_1, var_21_3, var_21_2, arg_21_5)
	end
end

function BuffSystem.rpc_remove_server_controlled_buff(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0.unit_storage:unit(arg_22_2)

	if Unit.alive(var_22_0) then
		local var_22_1 = arg_22_0.server_controlled_buffs[var_22_0]
		local var_22_2 = var_22_1 and var_22_1[arg_22_3]

		if var_22_2 then
			local var_22_3 = var_22_2.local_buff_id

			if var_22_3 then
				ScriptUnit.extension(var_22_0, "buff_system"):remove_buff(var_22_3)
			end

			arg_22_0.server_controlled_buffs[var_22_0][arg_22_3] = nil
		end
	end
end

function BuffSystem.rpc_add_volume_buff_multiplier(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_0.unit_storage:unit(arg_23_2)
	local var_23_1 = NetworkLookup.buff_templates[arg_23_3]

	arg_23_0:add_volume_buff(var_23_0, var_23_1, arg_23_4)
end

function BuffSystem.rpc_remove_volume_buff(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_0.unit_storage:unit(arg_24_2)
	local var_24_1 = NetworkLookup.buff_templates[arg_24_3]

	arg_24_0:remove_volume_buff(var_24_0, var_24_1)
end

function BuffSystem.rpc_add_group_buff(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_0.is_server then
		arg_25_0.network_manager.network_transmit:send_rpc_clients("rpc_add_group_buff", arg_25_2, arg_25_3)
	end

	local var_25_0 = NetworkLookup.group_buff_templates[arg_25_2]
	local var_25_1 = GroupBuffTemplates[var_25_0]
	local var_25_2 = var_25_1.buff_per_instance
	local var_25_3 = var_25_1.side_name
	local var_25_4 = Managers.state.side:get_side_from_name(var_25_3):player_units()

	for iter_25_0 = 1, arg_25_3 do
		local var_25_5 = {
			group_buff_template_name = var_25_0,
			recipients = {}
		}

		for iter_25_1, iter_25_2 in ipairs(var_25_4) do
			if Unit.alive(iter_25_2) then
				local var_25_6 = ScriptUnit.extension(iter_25_2, "buff_system"):add_buff(var_25_2)

				var_25_5.recipients[iter_25_2] = var_25_6
			end
		end

		arg_25_0.player_group_buffs[#arg_25_0.player_group_buffs + 1] = var_25_5
	end
end

function BuffSystem.rpc_remove_group_buff(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = NetworkLookup.group_buff_templates[arg_26_2]
	local var_26_1 = arg_26_0.player_group_buffs

	for iter_26_0 = 1, arg_26_3 do
		local var_26_2 = #var_26_1
		local var_26_3
		local var_26_4

		for iter_26_1 = 1, var_26_2 do
			var_26_3 = var_26_1[iter_26_1]

			if var_26_3.group_buff_template_name == var_26_0 then
				var_26_4 = iter_26_1

				break
			end
		end

		fassert(var_26_4, "trying to remove a player group buff that isn't currently applied")
		table.remove(var_26_1, var_26_4)

		if arg_26_0.is_server then
			arg_26_0.network_manager.network_transmit:send_rpc_clients("rpc_remove_group_buff", arg_26_2, arg_26_3)
		end

		local var_26_5 = var_26_3.recipients

		for iter_26_2, iter_26_3 in pairs(var_26_5) do
			if Unit.alive(iter_26_2) then
				ScriptUnit.extension(iter_26_2, "buff_system"):remove_buff(iter_26_3)
			end
		end
	end
end

function BuffSystem.rpc_buff_on_attack(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8, arg_27_9)
	local var_27_0 = arg_27_0.unit_storage:unit(arg_27_2)

	if not Unit.alive(var_27_0) then
		return
	end

	local var_27_1 = arg_27_0.unit_storage:unit(arg_27_3)
	local var_27_2 = NetworkLookup.buff_attack_types[arg_27_4]
	local var_27_3 = NetworkLookup.hit_zones[arg_27_6]
	local var_27_4 = NetworkLookup.buff_weapon_types[arg_27_8]
	local var_27_5 = NetworkLookup.damage_sources[arg_27_9]
	local var_27_6 = false

	DamageUtils.buff_on_attack(var_27_0, var_27_1, var_27_2, arg_27_5, var_27_3, arg_27_7, var_27_6, var_27_4, nil, var_27_5)
end

function BuffSystem.rpc_proc_event(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = Managers.player:player(arg_28_2, arg_28_3)
	local var_28_1 = NetworkLookup.proc_events[arg_28_4]
	local var_28_2 = var_28_0.player_unit
	local var_28_3 = ScriptUnit.has_extension(var_28_2, "buff_system")

	if var_28_3 then
		var_28_3:trigger_procs(var_28_1)
	end
end

function BuffSystem.rpc_remove_gromril_armour(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0.unit_storage:unit(arg_29_2)

	if not Unit.alive(var_29_0) then
		return
	end

	local var_29_1 = ScriptUnit.extension(var_29_0, "buff_system")

	if var_29_1:has_buff_type("bardin_ironbreaker_gromril_armour") then
		local var_29_2 = var_29_1:get_non_stacking_buff("bardin_ironbreaker_gromril_armour").id

		var_29_1:remove_buff(var_29_2)
	end

	var_29_1:trigger_procs("on_gromril_armour_removed")
end

function BuffSystem.set_buff_ext_active(arg_30_0, arg_30_1, arg_30_2)
	if arg_30_2 then
		if arg_30_0.in_update then
			arg_30_0._activated_buff_units_during_update[arg_30_1] = arg_30_0.unit_extension_data[arg_30_1]
		else
			arg_30_0.active_buff_units[arg_30_1] = arg_30_0.unit_extension_data[arg_30_1]
		end
	else
		arg_30_0.active_buff_units[arg_30_1] = nil
	end
end

local function var_0_4(arg_31_0)
	return math.floor(arg_31_0 * 100 + 32768)
end

local function var_0_5(arg_32_0)
	return (arg_32_0 - 32768) / 100
end

local function var_0_6(arg_33_0)
	return math.floor(arg_33_0 * 10)
end

local function var_0_7(arg_34_0)
	return arg_34_0 / 10
end

local function var_0_8(arg_35_0)
	return arg_35_0
end

local function var_0_9(arg_36_0)
	return NetworkLookup.damage_sources[arg_36_0]
end

local function var_0_10(arg_37_0, arg_37_1)
	return arg_37_1.network_manager:unit_game_object_id(arg_37_0) or NetworkConstants.invalid_game_object_id
end

local function var_0_11(arg_38_0, arg_38_1)
	return arg_38_1.unit_storage:unit(arg_38_0)
end

local var_0_12 = {
	attacker_unit = {
		pack = var_0_10,
		unpack = var_0_11
	},
	source_attacker_unit = {
		pack = var_0_10,
		unpack = var_0_11
	},
	damage_source = {
		pack = var_0_9,
		unpack = var_0_9
	},
	power_level = {
		pack = var_0_8,
		unpack = var_0_8
	},
	variable_value = {
		pack = var_0_4,
		unpack = var_0_5
	},
	external_optional_bonus = {
		pack = var_0_4,
		unpack = var_0_5
	},
	external_optional_multiplier = {
		pack = var_0_4,
		unpack = var_0_5
	},
	external_optional_value = {
		pack = var_0_4,
		unpack = var_0_5
	},
	external_optional_proc_chance = {
		pack = var_0_4,
		unpack = var_0_5
	},
	external_optional_duration = {
		pack = var_0_4,
		unpack = var_0_5
	},
	external_optional_range = {
		pack = var_0_4,
		unpack = var_0_5
	},
	_hot_join_sync_buff_age = {
		pack = var_0_6,
		unpack = var_0_7
	},
	_flags = {
		pack = var_0_8,
		unpack = var_0_8
	}
}
local var_0_13 = table.keys(var_0_12)
local var_0_14 = table.mirror_array_inplace(table.keys(var_0_12))
local var_0_15 = #var_0_13
local var_0_16 = {
	"refresh_duration_only"
}

table.mirror_array_inplace(var_0_16)

local var_0_17 = #var_0_16
local var_0_18 = Script.new_map(var_0_17)

for iter_0_0 = 1, var_0_17 do
	var_0_18[var_0_16[iter_0_0]] = bit.rshift(1, iter_0_0 - 1)
end

local var_0_19 = Script.new_array(var_0_15)
local var_0_20 = Script.new_array(var_0_15)
local var_0_21 = Script.new_map(var_0_15)

function BuffSystem._pack_buff_params(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	table.clear(var_0_19)
	table.clear(var_0_20)

	local var_39_0 = 0
	local var_39_1 = 0

	for iter_39_0, iter_39_1 in pairs(arg_39_1) do
		if var_0_18[iter_39_0] then
			var_39_0 = bit.bor(var_39_0, var_0_18[iter_39_0])
		elseif var_0_14[iter_39_0] then
			var_39_1 = var_39_1 + 1
			arg_39_2[var_39_1] = var_0_14[iter_39_0]
			arg_39_3[var_39_1] = var_0_12[iter_39_0].pack(iter_39_1, arg_39_0, arg_39_4)
		end
	end

	if var_39_0 > 0 then
		local var_39_2 = var_39_1 + 1

		arg_39_2[var_39_2] = var_0_14._flags
		arg_39_3[var_39_2] = var_39_0
	end

	return arg_39_2, arg_39_3
end

function BuffSystem._unpack_buff_params(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	table.clear(arg_40_1)

	local var_40_0 = #arg_40_2
	local var_40_1 = arg_40_2[var_40_0]

	if var_0_13[var_40_1] == "_flags" then
		local var_40_2 = arg_40_3[var_40_0]

		for iter_40_0 = 1, var_0_17 do
			local var_40_3 = var_0_16[iter_40_0]
			local var_40_4 = var_0_18[var_40_3]

			if bit.band(var_40_2, var_40_4) == var_40_4 then
				arg_40_1[var_40_3] = true
			end
		end

		var_40_0 = var_40_0 - 1
	end

	for iter_40_1 = 1, var_40_0 do
		local var_40_5 = arg_40_2[iter_40_1]
		local var_40_6 = var_0_13[var_40_5]

		arg_40_1[var_40_6] = var_0_12[var_40_6].unpack(arg_40_3[iter_40_1], arg_40_0, arg_40_4)
	end

	return arg_40_1
end

local var_0_22 = 0

function BuffSystem._prepare_sync(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	local var_41_0 = Managers.state.network:unit_game_object_id(arg_41_1)
	local var_41_1 = NetworkLookup.buff_templates[arg_41_2]
	local var_41_2 = BuffSyncTypeLookup[arg_41_3]
	local var_41_3 = "rpc_add_buff_synced"
	local var_41_4
	local var_41_5

	if arg_41_4 then
		var_41_3 = "rpc_add_buff_synced_params"
		var_41_4, var_41_5 = arg_41_0:_pack_buff_params(arg_41_4, var_0_19, var_0_20, arg_41_1)
	end

	return var_41_0, var_41_1, var_41_2, var_41_3, var_41_4, var_41_5
end

local function var_0_23(...)
	if script_data.debug_synced_buffs then
		print(...)
	end
end

local var_0_24 = {
	[BuffSyncType.Local] = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
		return true
	end,
	[BuffSyncType.Client] = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6)
		if arg_44_6 == Network.peer_id() then
			return true
		end

		local var_44_0, var_44_1, var_44_2, var_44_3, var_44_4, var_44_5 = arg_44_0:_prepare_sync(arg_44_1, arg_44_2, arg_44_3, arg_44_5)

		Managers.state.network.network_transmit:send_rpc(var_44_3, arg_44_6, var_44_0, var_44_1, arg_44_4, var_44_2, var_44_4, var_44_5)
	end,
	[BuffSyncType.LocalAndServer] = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
		if arg_45_0.is_server then
			return true
		end

		local var_45_0, var_45_1, var_45_2, var_45_3, var_45_4, var_45_5 = arg_45_0:_prepare_sync(arg_45_1, arg_45_2, arg_45_3, arg_45_5)

		Managers.state.network.network_transmit:send_rpc_server(var_45_3, var_45_0, var_45_1, arg_45_4, var_45_2, var_45_4, var_45_5)
	end,
	[BuffSyncType.ClientAndServer] = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6)
		if arg_46_0.is_server and arg_46_6 == Network.peer_id() then
			return true
		end

		local var_46_0, var_46_1, var_46_2, var_46_3, var_46_4, var_46_5 = arg_46_0:_prepare_sync(arg_46_1, arg_46_2, arg_46_3, arg_46_5)
		local var_46_6 = Managers.state.network.network_transmit

		if arg_46_0.is_server then
			var_46_6:send_rpc(var_46_3, arg_46_6, var_46_0, var_46_1, arg_46_4, var_46_2, var_46_4, var_46_5)
		else
			var_46_6:send_rpc_server(var_46_3, var_46_0, var_46_1, arg_46_4, var_46_2, var_46_4, var_46_5)
		end
	end,
	[BuffSyncType.Server] = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6)
		if arg_47_0.is_server then
			return true
		end

		local var_47_0, var_47_1, var_47_2, var_47_3, var_47_4, var_47_5 = arg_47_0:_prepare_sync(arg_47_1, arg_47_2, arg_47_3, arg_47_5)

		Managers.state.network.network_transmit:send_rpc_server(var_47_3, var_47_0, var_47_1, arg_47_4, var_47_2, var_47_4, var_47_5)
	end,
	[BuffSyncType.All] = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5, arg_48_6)
		local var_48_0, var_48_1, var_48_2, var_48_3, var_48_4, var_48_5 = arg_48_0:_prepare_sync(arg_48_1, arg_48_2, arg_48_3, arg_48_5)
		local var_48_6 = Managers.state.network.network_transmit

		if arg_48_0.is_server then
			var_48_6:send_rpc_clients(var_48_3, var_48_0, var_48_1, arg_48_4, var_48_2, var_48_4, var_48_5)
		else
			var_48_6:send_rpc_server(var_48_3, var_48_0, var_48_1, arg_48_4, var_48_2, var_48_4, var_48_5)
		end
	end
}

function BuffSystem.add_buff_synced(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
	local var_49_0 = -1
	local var_49_1
	local var_49_2 = arg_49_0.unit_extension_data[arg_49_1]

	if var_49_2 then
		if arg_49_3 == BuffSyncType.Client and arg_49_5 ~= Network.peer_id() or arg_49_3 == BuffSyncType.Server and not arg_49_0.is_server then
			var_49_0 = var_49_2:claim_buff_id(arg_49_2)
			var_49_1 = 1
		else
			var_49_0, var_49_1 = var_49_2:add_buff(arg_49_2, arg_49_4)
		end

		local var_49_3 = var_0_22

		if var_49_1 > 0 then
			var_49_3 = var_49_2:generate_sync_id()

			var_49_2:set_pending_sync_id(var_49_0, var_49_3, arg_49_3)

			if arg_49_0.is_server then
				var_49_2:apply_remote_sync_id(var_49_0, var_49_3, arg_49_3, arg_49_5 or Network.peer_id())
			end
		else
			var_49_0 = -1
		end

		local var_49_4 = var_0_24[arg_49_3](arg_49_0, arg_49_1, arg_49_2, arg_49_3, var_49_3, arg_49_4, arg_49_5)
	end

	return var_49_0
end

function BuffSystem.remove_buff_synced(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0.unit_extension_data[arg_50_1]

	if var_50_0 and arg_50_2 then
		var_50_0:remove_buff(arg_50_2)
	end
end

function BuffSystem.rpc_add_buff_synced(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	local var_51_0 = arg_51_0.unit_storage:unit(arg_51_2)
	local var_51_1 = arg_51_0.unit_extension_data[var_51_0]

	if var_51_1 then
		local var_51_2 = NetworkLookup.buff_templates[arg_51_3]
		local var_51_3, var_51_4 = var_51_1:add_buff(var_51_2)
		local var_51_5 = false
		local var_51_6 = BuffSyncTypeLookup[arg_51_5]
		local var_51_7

		if var_51_4 <= 0 then
			arg_51_4 = var_0_22
			var_51_7 = var_0_22
			var_51_5 = true
		elseif arg_51_0.is_server and arg_51_4 ~= var_0_22 then
			var_51_7 = var_51_1:generate_sync_id()

			var_51_1:set_pending_sync_id(var_51_3, var_51_7, var_51_6)
		else
			var_51_7 = arg_51_4
		end

		local var_51_8 = CHANNEL_TO_PEER_ID[arg_51_1]

		if var_51_7 ~= var_0_22 then
			var_51_1:apply_remote_sync_id(var_51_3, var_51_7, var_51_6, var_51_8)
		end

		local var_51_9 = Managers.state.network

		if arg_51_0.is_server and var_51_6 == BuffSyncType.All then
			var_51_9.network_transmit:send_rpc_clients_except("rpc_add_buff_synced_relay", var_51_8, arg_51_2, arg_51_3, var_51_7, arg_51_5)
		end

		if var_51_7 == var_0_22 then
			if not var_51_5 then
				var_0_23("[BuffSystem] rpc_add_buff_synced, response consumed due to blind fire sync", var_51_8, arg_51_2, var_51_2)
			end

			return
		end

		if arg_51_0.is_server then
			var_51_9.network_transmit:send_rpc("rpc_add_buff_synced_response", var_51_8, arg_51_2, arg_51_4, var_51_7)
		end
	end
end

function BuffSystem.rpc_add_buff_synced_relay(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	local var_52_0 = arg_52_0.unit_storage:unit(arg_52_2)
	local var_52_1 = arg_52_0.unit_extension_data[var_52_0]

	if var_52_1 then
		local var_52_2 = NetworkLookup.buff_templates[arg_52_3]
		local var_52_3, var_52_4 = var_52_1:add_buff(var_52_2)

		if arg_52_4 ~= var_0_22 and var_52_4 > 0 then
			local var_52_5 = BuffSyncTypeLookup[arg_52_5]
			local var_52_6 = var_52_1:generate_sync_id()

			var_52_1:set_pending_sync_id(var_52_3, var_52_6, var_52_5)
			var_52_1:apply_remote_sync_id(var_52_3, arg_52_4, var_52_5)
		end
	end
end

function BuffSystem.rpc_add_buff_synced_params(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5, arg_53_6, arg_53_7)
	local var_53_0 = arg_53_0.unit_storage:unit(arg_53_2)
	local var_53_1 = arg_53_0.unit_extension_data[var_53_0]

	if var_53_1 then
		local var_53_2 = NetworkLookup.buff_templates[arg_53_3]
		local var_53_3 = arg_53_0:_unpack_buff_params(var_0_21, arg_53_6, arg_53_7, var_53_0)
		local var_53_4, var_53_5 = var_53_1:add_buff(var_53_2, var_53_3)
		local var_53_6 = false
		local var_53_7 = BuffSyncTypeLookup[arg_53_5]
		local var_53_8

		if var_53_5 <= 0 then
			arg_53_4 = var_0_22
			var_53_8 = var_0_22
			var_53_6 = true
		elseif arg_53_0.is_server and arg_53_4 ~= var_0_22 then
			var_53_8 = var_53_1:generate_sync_id()

			var_53_1:set_pending_sync_id(var_53_4, var_53_8, var_53_7)
		else
			var_53_8 = arg_53_4
		end

		local var_53_9 = CHANNEL_TO_PEER_ID[arg_53_1]

		if var_53_8 ~= var_0_22 then
			var_53_1:apply_remote_sync_id(var_53_4, var_53_8, var_53_7, var_53_9)
		end

		local var_53_10 = Managers.state.network

		if arg_53_0.is_server and var_53_7 == BuffSyncType.All then
			var_53_10.network_transmit:send_rpc_clients_except("rpc_add_buff_synced_relay_params", var_53_9, arg_53_2, arg_53_3, var_53_8, arg_53_5, arg_53_6, arg_53_7)
		end

		if var_53_8 == var_0_22 then
			if not var_53_6 then
				var_0_23("[BuffSystem] rpc_add_buff_synced_params, response consumed due to blind fire sync", var_53_9, arg_53_2, var_53_2)
			end

			return
		end

		if arg_53_0.is_server then
			var_53_10.network_transmit:send_rpc("rpc_add_buff_synced_response", var_53_9, arg_53_2, arg_53_4, var_53_8)
		end
	end
end

function BuffSystem.rpc_add_buff_synced_relay_params(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7)
	local var_54_0 = arg_54_0.unit_storage:unit(arg_54_2)
	local var_54_1 = arg_54_0.unit_extension_data[var_54_0]

	if var_54_1 then
		local var_54_2 = NetworkLookup.buff_templates[arg_54_3]
		local var_54_3 = arg_54_0:_unpack_buff_params(var_0_21, arg_54_6, arg_54_7, var_54_0)
		local var_54_4, var_54_5 = var_54_1:add_buff(var_54_2, var_54_3)

		if arg_54_4 ~= var_0_22 and var_54_5 > 0 then
			local var_54_6 = BuffSyncTypeLookup[arg_54_5]
			local var_54_7 = var_54_1:generate_sync_id()

			var_54_1:set_pending_sync_id(var_54_4, var_54_7, var_54_6)
			var_54_1:apply_remote_sync_id(var_54_4, arg_54_4, var_54_6)
		end
	end
end

function BuffSystem.rpc_add_buff_synced_response(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = arg_55_0.unit_storage:unit(arg_55_2)
	local var_55_1 = arg_55_0.unit_extension_data[var_55_0]

	if var_55_1 and not var_55_1:apply_sync_id(arg_55_3, arg_55_4) then
		local var_55_2 = Managers.state.network

		if arg_55_0.is_server then
			local var_55_3 = CHANNEL_TO_PEER_ID[arg_55_1]

			var_55_2.network_transmit:send_rpc("rpc_remove_buff_synced", var_55_3, arg_55_2, arg_55_4)
		else
			var_55_2.network_transmit:send_rpc_server("rpc_remove_buff_synced", arg_55_2, arg_55_4)
		end
	end
end

function BuffSystem.rpc_remove_buff_synced(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = arg_56_0.unit_storage:unit(arg_56_2)
	local var_56_1 = arg_56_0.unit_extension_data[var_56_0]

	if var_56_1 then
		local var_56_2 = var_56_1:sync_id_to_id(arg_56_3)

		if var_56_2 then
			if arg_56_0.is_server and var_56_1:buff_sync_type(var_56_2) == BuffSyncType.All then
				local var_56_3 = CHANNEL_TO_PEER_ID[arg_56_1]

				Managers.state.network.network_transmit:send_rpc_clients_except("rpc_remove_buff_synced", var_56_3, arg_56_2, arg_56_3)
			end

			var_56_1:remove_buff(var_56_2, true)
		end
	end
end

function BuffSystem._hot_join_sync_synced_buffs(arg_57_0, arg_57_1)
	local var_57_0 = Managers.time:time("game")
	local var_57_1 = Managers.state.network
	local var_57_2 = var_57_1.network_transmit
	local var_57_3 = BuffSyncTypeLookup[BuffSyncType.All]
	local var_57_4 = {}
	local var_57_5 = arg_57_0.active_buff_units

	for iter_57_0, iter_57_1 in pairs(var_57_5) do
		local var_57_6 = iter_57_1._buff_to_sync_type

		if var_57_6 then
			local var_57_7 = var_57_1:unit_game_object_id(iter_57_0)
			local var_57_8 = iter_57_1._id_to_server_sync

			for iter_57_2, iter_57_3 in pairs(var_57_6) do
				if iter_57_3 == BuffSyncType.All then
					local var_57_9 = iter_57_1:get_buff_by_id(iter_57_2)

					if var_57_9 then
						local var_57_10 = NetworkLookup.buff_templates[var_57_9.buff_template_name]
						local var_57_11 = var_57_8[iter_57_2]

						table.clear(var_57_4)

						var_57_4.external_optional_bonus = var_57_9.bonus
						var_57_4.external_optional_multiplier = var_57_9.multiplier
						var_57_4.external_optional_value = var_57_9.value
						var_57_4.external_optional_proc_chance = var_57_9.proc_chance
						var_57_4.external_optional_range = var_57_9.range
						var_57_4.damage_source = var_57_9.damage_source
						var_57_4.power_level = var_57_9.power_level
						var_57_4.attacker_unit = var_57_9.attacker_unit
						var_57_4.source_attacker_unit = var_57_9.source_attacker_unit
						var_57_4._hot_join_sync_buff_age = var_57_9.duration and math.min(var_57_0 - var_57_9.start_time, 6550)

						arg_57_0:_pack_buff_params(var_57_4, var_0_19, var_0_20, iter_57_0)
						var_57_2:send_rpc("rpc_add_buff_synced_relay_params", arg_57_1, var_57_7, var_57_10, var_57_11, var_57_3, var_0_19, var_0_20)
					else
						if iter_57_1.debug_buff_names then
							local var_57_12 = iter_57_1.debug_buff_names[iter_57_2]

							print("Server would have crashed buff name ", var_57_12)
							Crashify.print_exception("[BuffSystem]", "buff_id points to missing buff: %s", var_57_12)
						end

						var_57_6[iter_57_2] = nil
					end
				end
			end
		end
	end
end
