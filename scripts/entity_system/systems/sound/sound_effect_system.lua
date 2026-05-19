-- chunkname: @scripts/entity_system/systems/sound/sound_effect_system.lua

require("scripts/unit_extensions/default_player_unit/player_sound_effect_extension")

SoundEffectSystem = class(SoundEffectSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_aggro_unit_changed"
}
local var_0_1 = {
	"PlayerSoundEffectExtension"
}

function SoundEffectSystem.init(arg_1_0, arg_1_1, arg_1_2)
	SoundEffectSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))
end

function SoundEffectSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

function SoundEffectSystem.aggro_unit_changed(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = Managers.player:unit_owner(arg_3_1)

	if var_3_0 then
		if var_3_0.local_player then
			ScriptUnit.has_extension(arg_3_1, "sound_effect_system"):aggro_unit_changed(arg_3_2, arg_3_3)
		elseif arg_3_0.is_server and var_3_0:is_player_controlled() then
			local var_3_1 = var_3_0.peer_id
			local var_3_2 = arg_3_0.unit_storage:go_id(arg_3_1)
			local var_3_3 = arg_3_0.unit_storage:go_id(arg_3_2)

			arg_3_0.network_transmit:send_rpc("rpc_aggro_unit_changed", var_3_1, var_3_2, var_3_3, arg_3_3)
		end
	end
end

function SoundEffectSystem.rpc_aggro_unit_changed(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0.unit_storage:unit(arg_4_2)
	local var_4_1 = arg_4_0.unit_storage:unit(arg_4_3)

	arg_4_0:aggro_unit_changed(var_4_0, var_4_1, arg_4_4)
end

function SoundEffectSystem.hot_join_sync(arg_5_0)
	return
end
