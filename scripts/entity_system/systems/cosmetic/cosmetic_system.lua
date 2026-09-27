-- chunkname: @scripts/entity_system/systems/cosmetic/cosmetic_system.lua

require("scripts/unit_extensions/default_player_unit/cosmetic/player_unit_cosmetic_extension")

CosmeticSystem = class(CosmeticSystem, ExtensionSystemBase)

local tbl = {
	"rpc_set_equipped_frame",
	"rpc_server_request_emote",
	"rpc_server_cancel_emote"
}
local tbl_2 = {
	"PlayerUnitCosmeticExtension"
}

CosmeticSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	table.dump(arg_1_1, "entity_system_creation_context")
	CosmeticSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self.profile_synchronizer = arg_1_1.profile_synchronizer
	self._network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl))

	self._emote_states = {}
end

CosmeticSystem.destroy = function (self)
	-- function 2
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

CosmeticSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	arg_3_4.is_server = self.is_server

	return CosmeticSystem.super.on_add_extension(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

CosmeticSystem.get_equipped_frame = function (arg_4_0, arg_4_1)
	-- function 4
	local str = "default"

	if not Unit.alive(arg_4_1) then
		str = ScriptUnit.extension(arg_4_1, "cosmetic_system"):get_equipped_frame_name()
	end

	return str
end

CosmeticSystem.set_equipped_frame = function (self, arg_5_1, arg_5_2)
	-- function 5
	ScriptUnit.extension(arg_5_1, "cosmetic_system"):set_equipped_frame(arg_5_2)

	local go_id = self.unit_storage:go_id(arg_5_1)
	local var_5_1 = NetworkLookup.cosmetics[arg_5_2]

	if not self.is_server then
		self.network_transmit:send_rpc_clients("rpc_set_equipped_frame", go_id, var_5_1)
	else
		self.network_transmit:send_rpc_server("rpc_set_equipped_frame", go_id, var_5_1)
	end
end

CosmeticSystem.rpc_set_equipped_frame = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not self.is_server then
		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		self.network_transmit:send_rpc_clients_except("rpc_set_equipped_frame", var_6_0, arg_6_2, arg_6_3)
	end

	local unit = self.unit_storage:unit(arg_6_2)
	local var_6_2 = NetworkLookup.cosmetics[arg_6_3]

	if not Unit.alive(unit) then
		ScriptUnit.extension(unit, "cosmetic_system"):set_equipped_frame(var_6_2)
	end
end

CosmeticSystem.rpc_server_request_emote = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	fassert(self.is_server, "Error! Only the server should process emote requests.")

	local unit = self.unit_storage:unit(arg_7_2)

	if not unit and not ALIVE[unit] then
		local var_7_1 = NetworkLookup.anims[arg_7_3]

		self._emote_states[arg_7_2] = {
			anim_event = var_7_1,
			hide_weapons = arg_7_4
		}

		CharacterStateHelper.play_animation_event(unit, var_7_1)

		local has_extension = ScriptUnit.has_extension(unit, "inventory_system")

		CharacterStateHelper.show_inventory_3p(unit, not arg_7_4, true, true, has_extension)
	end
end

CosmeticSystem.rpc_server_cancel_emote = function (self, arg_8_1, arg_8_2)
	-- function 8
	fassert(self.is_server, "Error! Only the server should cancel emotes.")

	local unit = self.unit_storage:unit(arg_8_2)

	if not unit and not ALIVE[unit] then
		CharacterStateHelper.play_animation_event(unit, "anim_pose_cancel")

		local has_extension = ScriptUnit.has_extension(unit, "inventory_system")

		CharacterStateHelper.show_inventory_3p(unit, true, true, true, has_extension)
	end

	self._emote_states[arg_8_2] = nil
end

CosmeticSystem.hot_join_sync = function (self, arg_9_1)
	-- function 9
	local network_transmit = self.network_transmit
	local unit_storage = self.unit_storage

	for k, v in pairs(self._emote_states) do
		local var_9_2 = NetworkLookup.anims[v.anim_event]

		network_transmit:send_rpc("rpc_anim_event", arg_9_1, var_9_2, k)
		network_transmit:send_rpc("rpc_show_inventory", arg_9_1, k, not v.hide_weapons)
	end
end
