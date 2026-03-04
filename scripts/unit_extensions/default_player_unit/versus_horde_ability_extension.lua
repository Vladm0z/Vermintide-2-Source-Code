-- chunkname: @scripts/unit_extensions/default_player_unit/versus_horde_ability_extension.lua

VersusHordeAbilityExtension = class(VersusHordeAbilityExtension)

local var_0_0 = 2

VersusHordeAbilityExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0._horde_ability_system = Managers.state.entity:system("versus_horde_ability_system")
	arg_1_0._settings = arg_1_0._horde_ability_system:settings()
	arg_1_0._unit = arg_1_2
	arg_1_0.network_manager = Managers.state.network
	arg_1_0._game = Managers.state.network:game()
	arg_1_0._world = arg_1_1.world

	if arg_1_0.is_server then
		arg_1_0:create_ability_game_object()

		arg_1_0._ability_charge = 0
		arg_1_0._cooldown_mod = 0
		arg_1_0._boost_mod = 0
	end

	arg_1_0._audio_system = Managers.state.entity:system("audio_system")
	arg_1_0._cooldown = arg_1_0._horde_ability_system:cooldown()
	arg_1_0._pause_sync_until = 0
	arg_1_0._own_peer_id = Network.peer_id()
end

VersusHordeAbilityExtension._activate = function (arg_2_0, arg_2_1)
	arg_2_0._horde_ability_system:activate_dark_pact_horde_ability()

	arg_2_0._pause_sync_until = arg_2_1 + var_0_0
	arg_2_0._fully_charged = false

	if arg_2_0._unit and POSITION_LOOKUP[arg_2_0._unit] then
		arg_2_0._audio_system:play_audio_position_event("Play_versus_pactsworn_horde_ability", POSITION_LOOKUP[arg_2_0._unit])
	end

	local var_2_0 = Managers.state.game_mode and Managers.state.game_mode:game_mode()
	local var_2_1 = Managers.player:local_player()

	if var_2_1 then
		var_2_0:activated_ability_telemetry("versus_horde_ability", var_2_1)
	end
end

VersusHordeAbilityExtension.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	arg_3_0._ghost_mode_extension = ScriptUnit.extension(arg_3_2, "ghost_mode_system")
end

VersusHordeAbilityExtension.update = function (arg_4_0, arg_4_1)
	if arg_4_0._owner_peer_id ~= arg_4_0._own_peer_id then
		return
	end

	if arg_4_1 < arg_4_0._pause_sync_until then
		return
	end

	local var_4_0 = arg_4_0:get_ability_charge(arg_4_1) >= arg_4_0:cooldown()

	if var_4_0 and not arg_4_0._fully_charged then
		arg_4_0._audio_system:play_sound_local("Play_versus_pactsworn_horde_ability_ready")

		arg_4_0._fully_charged = true
	end

	local var_4_1 = arg_4_0._input_extension and arg_4_0._input_extension:get("versus_horde_ability")
	local var_4_2 = arg_4_0._ghost_mode_extension:is_in_ghost_mode()
	local var_4_3 = var_4_0 and arg_4_0._horde_ability_system:is_activation_allowed(var_4_2)

	if var_4_1 then
		if var_4_3 then
			arg_4_0:_activate(arg_4_1)
		else
			local var_4_4 = Managers.world:wwise_world(arg_4_0._world)

			WwiseWorld.trigger_event(var_4_4, "versus_hud_ability_not_ready")
		end
	end
end

VersusHordeAbilityExtension.destroy = function (arg_5_0)
	if arg_5_0.network_manager:game() and arg_5_0.is_server then
		arg_5_0.network_manager:destroy_game_object(arg_5_0._ability_go_id)

		arg_5_0._ability_go_id = nil
	end
end

VersusHordeAbilityExtension.create_ability_game_object = function (arg_6_0)
	fassert(arg_6_0.is_server, "Trying to create ability game object on a client")

	local var_6_0 = arg_6_0._unit
	local var_6_1 = arg_6_0.network_manager:unit_game_object_id(var_6_0)
	local var_6_2 = {
		cooldown_mod = 0,
		ability_charge = 0,
		boost_mod = 0,
		go_type = NetworkLookup.go_types.dark_pact_horde_ability,
		unit_game_object_id = var_6_1
	}
	local var_6_3 = callback(arg_6_0, "cb_game_session_disconnect")
	local var_6_4 = arg_6_0.network_manager:create_game_object("dark_pact_horde_ability", var_6_2, var_6_3)

	arg_6_0:set_ability_game_object_id(var_6_4)
end

VersusHordeAbilityExtension.set_ability_game_object_id = function (arg_7_0, arg_7_1)
	arg_7_0._ability_go_id = arg_7_1
end

VersusHordeAbilityExtension.get_ability_charge = function (arg_8_0, arg_8_1)
	if arg_8_0.is_server then
		return arg_8_0._ability_charge
	end

	if arg_8_1 < arg_8_0._pause_sync_until then
		return 0
	end

	if arg_8_0._game and arg_8_0._ability_go_id then
		return (GameSession.game_object_field(arg_8_0._game, arg_8_0._ability_go_id, "ability_charge"))
	end

	return 0
end

VersusHordeAbilityExtension.get_charge_modifiers = function (arg_9_0)
	local var_9_0 = 0
	local var_9_1 = 0

	if arg_9_0._game and arg_9_0._ability_go_id then
		if arg_9_0.is_server then
			var_9_0 = arg_9_0._cooldown_mod
			var_9_1 = arg_9_0._boost_mod
		else
			var_9_0 = GameSession.game_object_field(arg_9_0._game, arg_9_0._ability_go_id, "cooldown_mod")
			var_9_1 = GameSession.game_object_field(arg_9_0._game, arg_9_0._ability_go_id, "boost_mod")
		end
	end

	return var_9_0, var_9_1
end

VersusHordeAbilityExtension.server_set_ability_charge = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_2 = arg_10_2 * 100
	arg_10_3 = arg_10_3 * 100

	if arg_10_0._game and arg_10_0._ability_go_id then
		GameSession.set_game_object_field(arg_10_0._game, arg_10_0._ability_go_id, "ability_charge", arg_10_1)
		GameSession.set_game_object_field(arg_10_0._game, arg_10_0._ability_go_id, "cooldown_mod", arg_10_2)
		GameSession.set_game_object_field(arg_10_0._game, arg_10_0._ability_go_id, "boost_mod", arg_10_3)
	end

	if arg_10_0.is_server then
		arg_10_0._ability_charge = arg_10_1
		arg_10_0._cooldown_mod = arg_10_2
		arg_10_0._boost_mod = arg_10_3
	end
end

VersusHordeAbilityExtension.cooldown = function (arg_11_0)
	return arg_11_0._cooldown
end

VersusHordeAbilityExtension.cb_game_session_disconnect = function (arg_12_0)
	return
end

VersusHordeAbilityExtension.unit = function (arg_13_0)
	return arg_13_0._unit
end

VersusHordeAbilityExtension.game_object_initialized = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Managers.state.network:game()

	arg_14_0._go_id = arg_14_2
	arg_14_0._owner_peer_id = GameSession.game_object_field(var_14_0, arg_14_2, "owner_peer_id")
end
