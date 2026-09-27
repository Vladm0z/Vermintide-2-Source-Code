-- chunkname: @scripts/entity_system/systems/sound/sound_effect_system.lua

require("scripts/unit_extensions/default_player_unit/player_sound_effect_extension")

SoundEffectSystem = class(SoundEffectSystem, ExtensionSystemBase)

local tbl = {
	"rpc_aggro_unit_changed"
}
local tbl_2 = {
	"PlayerSoundEffectExtension"
}

SoundEffectSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	SoundEffectSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
end

SoundEffectSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

SoundEffectSystem.aggro_unit_changed = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local unit_owner = Managers.player:unit_owner(arg_3_1)

	if not unit_owner then
		if not unit_owner.local_player then
			ScriptUnit.has_extension(arg_3_1, "sound_effect_system"):aggro_unit_changed(arg_3_2, arg_3_3)
		elseif not self.is_server and not unit_owner:is_player_controlled() then
			local peer_id = unit_owner.peer_id
			local go_id = self.unit_storage:go_id(arg_3_1)
			local go_id_2 = self.unit_storage:go_id(arg_3_2)

			self.network_transmit:send_rpc("rpc_aggro_unit_changed", peer_id, go_id, go_id_2, arg_3_3)
		end
	end
end

SoundEffectSystem.rpc_aggro_unit_changed = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local unit = self.unit_storage:unit(arg_4_2)
	local unit_2 = self.unit_storage:unit(arg_4_3)

	self:aggro_unit_changed(unit, unit_2, arg_4_4)
end

SoundEffectSystem.hot_join_sync = function (arg_5_0)
	-- function 5
	return
end
