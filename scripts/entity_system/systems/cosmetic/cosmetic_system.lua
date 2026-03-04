-- chunkname: @scripts/entity_system/systems/cosmetic/cosmetic_system.lua

require("scripts/unit_extensions/default_player_unit/cosmetic/player_unit_cosmetic_extension")

CosmeticSystem = class(CosmeticSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_set_equipped_frame",
	"rpc_server_request_emote",
	"rpc_server_cancel_emote"
}
local var_0_1 = {
	"PlayerUnitCosmeticExtension"
}

CosmeticSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	table.dump(arg_1_1, "entity_system_creation_context")
	CosmeticSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0.profile_synchronizer = arg_1_1.profile_synchronizer
	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_0))

	arg_1_0._emote_states = {}
end

CosmeticSystem.destroy = function (arg_2_0)
	arg_2_0._network_event_delegate:unregister(arg_2_0)

	arg_2_0._network_event_delegate = nil
end

CosmeticSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_4.is_server = arg_3_0.is_server

	return CosmeticSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

CosmeticSystem.get_equipped_frame = function (arg_4_0, arg_4_1)
	local var_4_0 = "default"

	if Unit.alive(arg_4_1) then
		var_4_0 = ScriptUnit.extension(arg_4_1, "cosmetic_system"):get_equipped_frame_name()
	end

	return var_4_0
end

CosmeticSystem.set_equipped_frame = function (arg_5_0, arg_5_1, arg_5_2)
	ScriptUnit.extension(arg_5_1, "cosmetic_system"):set_equipped_frame(arg_5_2)

	local var_5_0 = arg_5_0.unit_storage:go_id(arg_5_1)
	local var_5_1 = NetworkLookup.cosmetics[arg_5_2]

	if arg_5_0.is_server then
		arg_5_0.network_transmit:send_rpc_clients("rpc_set_equipped_frame", var_5_0, var_5_1)
	else
		arg_5_0.network_transmit:send_rpc_server("rpc_set_equipped_frame", var_5_0, var_5_1)
	end
end

CosmeticSystem.rpc_set_equipped_frame = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0.is_server then
		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		arg_6_0.network_transmit:send_rpc_clients_except("rpc_set_equipped_frame", var_6_0, arg_6_2, arg_6_3)
	end

	local var_6_1 = arg_6_0.unit_storage:unit(arg_6_2)
	local var_6_2 = NetworkLookup.cosmetics[arg_6_3]

	if Unit.alive(var_6_1) then
		ScriptUnit.extension(var_6_1, "cosmetic_system"):set_equipped_frame(var_6_2)
	end
end

CosmeticSystem.rpc_server_request_emote = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	fassert(arg_7_0.is_server, "Error! Only the server should process emote requests.")

	local var_7_0 = arg_7_0.unit_storage:unit(arg_7_2)

	if var_7_0 and ALIVE[var_7_0] then
		local var_7_1 = NetworkLookup.anims[arg_7_3]

		arg_7_0._emote_states[arg_7_2] = {
			anim_event = var_7_1,
			hide_weapons = arg_7_4
		}

		CharacterStateHelper.play_animation_event(var_7_0, var_7_1)

		local var_7_2 = ScriptUnit.has_extension(var_7_0, "inventory_system")

		CharacterStateHelper.show_inventory_3p(var_7_0, not arg_7_4, true, true, var_7_2)
	end
end

CosmeticSystem.rpc_server_cancel_emote = function (arg_8_0, arg_8_1, arg_8_2)
	fassert(arg_8_0.is_server, "Error! Only the server should cancel emotes.")

	local var_8_0 = arg_8_0.unit_storage:unit(arg_8_2)

	if var_8_0 and ALIVE[var_8_0] then
		CharacterStateHelper.play_animation_event(var_8_0, "anim_pose_cancel")

		local var_8_1 = ScriptUnit.has_extension(var_8_0, "inventory_system")

		CharacterStateHelper.show_inventory_3p(var_8_0, true, true, true, var_8_1)
	end

	arg_8_0._emote_states[arg_8_2] = nil
end

CosmeticSystem.hot_join_sync = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.network_transmit
	local var_9_1 = arg_9_0.unit_storage

	for iter_9_0, iter_9_1 in pairs(arg_9_0._emote_states) do
		local var_9_2 = NetworkLookup.anims[iter_9_1.anim_event]

		var_9_0:send_rpc("rpc_anim_event", arg_9_1, var_9_2, iter_9_0)
		var_9_0:send_rpc("rpc_show_inventory", arg_9_1, iter_9_0, not iter_9_1.hide_weapons)
	end
end
