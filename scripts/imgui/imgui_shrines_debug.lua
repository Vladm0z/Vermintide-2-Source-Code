-- chunkname: @scripts/imgui/imgui_shrines_debug.lua

ImguiShrinesDebug = class(ImguiShrinesDebug)

local var_0_0 = true

ImguiShrinesDebug.init = function (arg_1_0)
	return
end

ImguiShrinesDebug.update = function (arg_2_0)
	if var_0_0 then
		arg_2_0:init()

		var_0_0 = false
	end
end

ImguiShrinesDebug.is_persistent = function (arg_3_0)
	return true
end

ImguiShrinesDebug.draw = function (arg_4_0, arg_4_1)
	if not Managers.state or not Managers.state.game_mode or Managers.state.game_mode:game_mode_key() ~= "deus" then
		local var_4_0 = Imgui.begin_window("Shrines Debug", "always_auto_resize")

		Imgui.text("This UI only works when playing a deus level.")
		Imgui.end_window()

		return var_4_0
	end

	local var_4_1 = Imgui.begin_window("Shrines Debug", "always_auto_resize")

	arg_4_0:_update_controls()
	Imgui.end_window()

	return var_4_1
end

ImguiShrinesDebug._shrine_types = function (arg_5_0)
	local var_5_0 = table.values(DEUS_CHEST_TYPES)

	table.insert(var_5_0, "deus_cursed_chest")

	return var_5_0
end

ImguiShrinesDebug._cursed_chest_challenges = function (arg_6_0)
	local var_6_0 = {
		"default"
	}

	table.append(var_6_0, table.keys_if(GenericTerrorEvents, nil, function (arg_7_0)
		return string.sub(arg_7_0, 1, string.len("cursed_chest_challenge")) == "cursed_chest_challenge"
	end))

	return var_6_0
end

ImguiShrinesDebug._update_controls = function (arg_8_0)
	local var_8_0 = arg_8_0:_shrine_types()
	local var_8_1 = table.index_of(var_8_0, arg_8_0._selected_shrine_type or next(DEUS_CHEST_TYPES))

	arg_8_0._selected_shrine_type = var_8_0[Imgui.combo("Shrine Type", var_8_1, var_8_0)]

	if arg_8_0._selected_shrine_type == "deus_cursed_chest" then
		local var_8_2 = arg_8_0:_cursed_chest_challenges()
		local var_8_3 = table.index_of(var_8_2, arg_8_0._selected_cursed_challenge or "default")

		arg_8_0._selected_cursed_challenge = var_8_2[Imgui.combo("Challenge", var_8_3, var_8_2, 20)]
	end

	if not Managers.state.network.is_server and arg_8_0._selected_shrine_type == "deus_cursed_chest" and arg_8_0._selected_cursed_challenge ~= "default" then
		Imgui.text("Clients can not spawn chests with a specific challenge. Please select 'default'.")

		return
	end

	if Imgui.button("Spawn", 100, 20) then
		local var_8_4 = Managers.player and Managers.player:local_player()

		if not var_8_4 or not var_8_4.player_unit then
			return
		end

		local var_8_5 = POSITION_LOOKUP[var_8_4.player_unit]
		local var_8_6 = Managers.state.entity:system("pickup_system")

		if arg_8_0._selected_shrine_type == "deus_cursed_chest" then
			var_8_6:debug_spawn_pickup("deus_cursed_chest", var_8_5, function (arg_9_0)
				local var_9_0 = arg_8_0._selected_cursed_challenge == "default" and "cursed_chest_prototype" or arg_8_0._selected_cursed_challenge

				Unit.set_data(arg_9_0, "debug_override_terror_event", var_9_0)
			end)
		else
			var_8_6:debug_spawn_pickup("DEBUG_deus_weapon_chest_" .. arg_8_0._selected_shrine_type, var_8_5)
		end
	end
end
