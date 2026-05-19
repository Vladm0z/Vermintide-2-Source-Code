-- chunkname: @scripts/unit_extensions/level/keep_decoration_trophy_extension.lua

KeepDecorationTrophyExtension = class(KeepDecorationTrophyExtension)

function KeepDecorationTrophyExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = LevelHelper:current_level(var_1_0)

	arg_1_0.keep_decoration_system = nil
	arg_1_0._decoration_settings_key = Unit.get_data(arg_1_2, "decoration_settings_key")
	arg_1_0._unit = arg_1_2
	arg_1_0._current_preview_trophy_unit = arg_1_2
	arg_1_0._world = var_1_0
	arg_1_0._level_unit_index = Level.unit_index(var_1_1, arg_1_2)
	arg_1_0._is_leader = Managers.party:is_leader(Network.peer_id())
	arg_1_0._trophies_lookup = NetworkLookup.keep_decoration_trophies or {}
	arg_1_0._currently_set_trophy = nil
	arg_1_0._is_hidden = nil
	arg_1_0._next_trophy = {}

	local var_1_2 = Unit.get_data(arg_1_2, "decoration_settings_key")
	local var_1_3 = KeepDecorationSettings[var_1_2]

	arg_1_0._settings = var_1_3
	arg_1_0._backend_key = var_1_3.backend_key
end

function KeepDecorationTrophyExtension.interacted_with(arg_2_0)
	return
end

function KeepDecorationTrophyExtension.destroy(arg_3_0)
	arg_3_0._unit = nil
	arg_3_0._world = nil
	arg_3_0._go_id = nil
end

function KeepDecorationTrophyExtension.extensions_ready(arg_4_0)
	if not arg_4_0._is_leader then
		return
	end

	local var_4_0 = arg_4_0:get_selected_decoration()

	arg_4_0._current_preview_trophy = var_4_0

	arg_4_0:_create_game_object(var_4_0)

	arg_4_0._currently_set_trophy = var_4_0

	arg_4_0:_load_trophy(var_4_0)
end

function KeepDecorationTrophyExtension.get_settings(arg_5_0)
	return arg_5_0._trophies_lookup
end

function KeepDecorationTrophyExtension.can_interact(arg_6_0)
	return arg_6_0._go_id
end

function KeepDecorationTrophyExtension.decoration_selected(arg_7_0, arg_7_1)
	arg_7_0:_load_trophy(arg_7_1)
end

function KeepDecorationTrophyExtension.reset_selection(arg_8_0)
	local var_8_0 = arg_8_0._current_preview_trophy
	local var_8_1 = arg_8_0._currently_set_trophy or "hub_trophy_empty"

	if var_8_1 ~= var_8_0 then
		arg_8_0:_load_trophy(var_8_1)
	end

	arg_8_0._current_preview_trophy = nil
end

function KeepDecorationTrophyExtension.unequip_decoration(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1 or "hub_trophy_empty"

	arg_9_0:_load_trophy(var_9_0)
	arg_9_0:sync_decoration()
end

function KeepDecorationTrophyExtension.confirm_selection(arg_10_0)
	local var_10_0 = arg_10_0._current_preview_trophy

	arg_10_0.keep_decoration_system:on_decoration_set(var_10_0, arg_10_0)
	arg_10_0:sync_decoration()
end

function KeepDecorationTrophyExtension.sync_decoration(arg_11_0)
	local var_11_0 = arg_11_0._current_preview_trophy

	arg_11_0:_set_selected_decoration(var_11_0)

	local var_11_1 = arg_11_0._go_id

	if Network.game_session() and var_11_1 then
		local var_11_2 = Managers.state.network:game()

		GameSession.set_game_object_field(var_11_2, var_11_1, "trophy_index", arg_11_0._trophies_lookup[var_11_0])
	end
end

function KeepDecorationTrophyExtension.hot_join_sync(arg_12_0, arg_12_1)
	return
end

function KeepDecorationTrophyExtension.distributed_update(arg_13_0)
	if arg_13_0._is_leader then
		if arg_13_0._waiting_for_game_session and Managers.state.network:in_game_session() then
			local var_13_0 = arg_13_0:get_selected_decoration()

			arg_13_0:_create_game_object(var_13_0)

			arg_13_0._waiting_for_game_session = false
		end
	else
		local var_13_1 = arg_13_0._go_id
		local var_13_2 = Network.game_session()

		if var_13_1 and var_13_2 then
			local var_13_3 = Managers.state.network:game()
			local var_13_4 = GameSession.game_object_field(var_13_3, var_13_1, "trophy_index")

			if var_13_4 ~= arg_13_0._go_trophy_index then
				arg_13_0._go_trophy_index = var_13_4

				local var_13_5 = arg_13_0._trophies_lookup[var_13_4]

				arg_13_0._currently_set_trophy = var_13_5

				arg_13_0:_load_trophy(var_13_5)
			end
		end
	end
end

function KeepDecorationTrophyExtension.get_selected_decoration(arg_14_0)
	if arg_14_0._is_leader then
		local var_14_0 = arg_14_0._backend_key

		return Managers.backend:get_interface("keep_decorations"):get_decoration(var_14_0) or DefaultTrophies[1]
	else
		return arg_14_0._currently_set_trophy
	end
end

function KeepDecorationTrophyExtension._set_selected_decoration(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._backend_key
	local var_15_1 = Managers.backend
	local var_15_2 = var_15_1:get_interface("keep_decorations")

	arg_15_0._currently_set_trophy = arg_15_1

	Unit.set_data(arg_15_0._current_preview_trophy_unit, "decoration_settings_key", arg_15_0._decoration_settings_key)
	var_15_2:set_decoration(var_15_0, arg_15_1)
	var_15_1:commit()
end

function KeepDecorationTrophyExtension._load_trophy(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._unit
	local var_16_1 = arg_16_0._current_preview_trophy_unit
	local var_16_2 = Unit.local_position(var_16_1, 0)
	local var_16_3 = Unit.local_rotation(var_16_1, 0)

	if var_16_1 == var_16_0 then
		Unit.set_unit_visibility(var_16_1, false)
	else
		World.destroy_unit(arg_16_0._world, var_16_1)
	end

	local var_16_4 = Trophies[arg_16_1].unit_name

	if Unit.is_a(var_16_0, var_16_4) then
		Unit.set_unit_visibility(var_16_0, true)

		arg_16_0._current_preview_trophy_unit = var_16_0
	else
		arg_16_0._current_preview_trophy_unit = World.spawn_unit(arg_16_0._world, var_16_4, var_16_2, var_16_3)
	end

	arg_16_0._current_preview_trophy = arg_16_1
end

function KeepDecorationTrophyExtension._create_game_object(arg_17_0, arg_17_1)
	local var_17_0 = {
		go_type = NetworkLookup.go_types.keep_decoration_trophy,
		level_unit_index = arg_17_0._level_unit_index,
		trophy_index = arg_17_0._trophies_lookup[arg_17_1]
	}
	local var_17_1 = callback(arg_17_0, "cb_game_session_disconnect")

	arg_17_0._go_id = Managers.state.network:create_game_object("keep_decoration_trophy", var_17_0, var_17_1)
end

function KeepDecorationTrophyExtension.cb_game_session_disconnect(arg_18_0)
	arg_18_0._go_id = nil
end

function KeepDecorationTrophyExtension.on_game_object_created(arg_19_0, arg_19_1)
	local var_19_0 = Managers.state.network:game()
	local var_19_1 = GameSession.game_object_field(var_19_0, arg_19_1, "trophy_index")
	local var_19_2 = arg_19_0._trophies_lookup[var_19_1]

	arg_19_0:_load_trophy(var_19_2, nil)

	arg_19_0._currently_set_trophy = var_19_2
	arg_19_0._go_trophy_index = var_19_1
	arg_19_0._go_id = arg_19_1
end

function KeepDecorationTrophyExtension.on_game_object_destroyed(arg_20_0)
	arg_20_0._go_id = nil
end
