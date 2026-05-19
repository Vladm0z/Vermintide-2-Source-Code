-- chunkname: @scripts/unit_extensions/level/keep_decoration_painting_extension.lua

KeepDecorationPaintingExtension = class(KeepDecorationPaintingExtension)

function KeepDecorationPaintingExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = LevelHelper:current_level(var_1_0)

	arg_1_0.keep_decoration_system = nil
	arg_1_0._decoration_settings_key = Unit.get_data(arg_1_2, "decoration_settings_key")
	arg_1_0._unit = arg_1_2
	arg_1_0._world = var_1_0
	arg_1_0._level_unit_index = Level.unit_index(var_1_1, arg_1_2)
	arg_1_0._is_leader = Managers.party:is_leader(Network.peer_id())
	arg_1_0._paintings_lookup = NetworkLookup.keep_decoration_paintings or {}
	arg_1_0._is_client_painting = Unit.get_data(arg_1_2, "painting_data", "is_client_painting")
	arg_1_0._currently_set_painting = nil
	arg_1_0._temporarily_set_frame = nil
	arg_1_0._temporarily_set_orientation = nil
	arg_1_0._is_hidden = nil
	arg_1_0._painting_unit = nil
	arg_1_0._start_hidden = Unit.get_data(arg_1_2, "painting_data", "start_hidden")
	arg_1_0._slow_update_count = 0
	arg_1_0._slot = nil
	arg_1_0._loading_painting_material = nil
	arg_1_0._next_painting = {}

	local var_1_2 = Unit.get_data(arg_1_2, "decoration_settings_key")
	local var_1_3 = KeepDecorationSettings[var_1_2]

	arg_1_0._settings = var_1_3
	arg_1_0._backend_key = var_1_3.backend_key
end

function KeepDecorationPaintingExtension.interacted_with(arg_2_0)
	return
end

function KeepDecorationPaintingExtension.destroy(arg_3_0)
	local var_3_0 = arg_3_0._painting_unit

	if Unit.alive(var_3_0) then
		World.destroy_unit(arg_3_0._world, var_3_0)
	end

	if arg_3_0._current_package_name then
		arg_3_0:_unload_painting_material(arg_3_0._current_package_name)

		arg_3_0._current_package_name = nil
	end

	if arg_3_0._previous_package_name then
		arg_3_0:_unload_painting_material(arg_3_0._previous_package_name)

		arg_3_0._previous_package_name = nil
	end

	arg_3_0._unit = nil
	arg_3_0._world = nil
	arg_3_0._go_id = nil
end

function KeepDecorationPaintingExtension.extensions_ready(arg_4_0)
	if not DLCSettings.gecko then
		return
	end

	Unit.set_unit_visibility(arg_4_0._unit, false)

	if not arg_4_0._is_leader then
		return
	end

	local var_4_0 = arg_4_0._is_client_painting and "hidden" or arg_4_0:get_selected_decoration()

	arg_4_0._current_preview_painting = var_4_0

	local function var_4_1()
		if Managers.state.network:in_game_session() then
			arg_4_0:_create_game_object(var_4_0)

			arg_4_0._loading_painting_material = false
		else
			arg_4_0._waiting_for_game_session = true
		end
	end

	arg_4_0:_load_painting(var_4_0, var_4_1)
end

function KeepDecorationPaintingExtension.get_settings(arg_6_0)
	return arg_6_0._paintings_lookup
end

function KeepDecorationPaintingExtension.can_interact(arg_7_0)
	if not DLCSettings.gecko then
		return false
	end

	return arg_7_0._go_id
end

function KeepDecorationPaintingExtension.decoration_selected(arg_8_0, arg_8_1)
	arg_8_0:_load_painting(arg_8_1, nil)
end

function KeepDecorationPaintingExtension.reset_selection(arg_9_0)
	local var_9_0 = arg_9_0._current_preview_painting
	local var_9_1 = arg_9_0._currently_set_painting

	if var_9_1 ~= var_9_0 then
		arg_9_0:_load_painting(var_9_1, nil)
	end

	arg_9_0._current_preview_painting = nil
end

function KeepDecorationPaintingExtension.unequip_decoration(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1 or "hor_none"

	arg_10_0:_load_painting(var_10_0)
	arg_10_0:sync_decoration()
end

function KeepDecorationPaintingExtension.confirm_selection(arg_11_0)
	local var_11_0 = arg_11_0._current_preview_painting

	arg_11_0.keep_decoration_system:on_painting_set(var_11_0, arg_11_0)
	arg_11_0:sync_decoration()
end

function KeepDecorationPaintingExtension.sync_decoration(arg_12_0)
	local var_12_0 = arg_12_0._current_preview_painting

	arg_12_0:_set_selected_painting(var_12_0)

	local var_12_1 = arg_12_0._go_id

	if var_12_1 then
		local var_12_2 = Managers.state.network:game()

		GameSession.set_game_object_field(var_12_2, var_12_1, "painting_index", arg_12_0._paintings_lookup[var_12_0])
	end
end

function KeepDecorationPaintingExtension.hot_join_sync(arg_13_0, arg_13_1)
	return
end

function KeepDecorationPaintingExtension.distributed_update(arg_14_0)
	if arg_14_0._is_leader then
		if arg_14_0._waiting_for_game_session and Managers.state.network:in_game_session() then
			local var_14_0 = arg_14_0:get_selected_decoration()

			arg_14_0:_create_game_object(var_14_0)

			arg_14_0._waiting_for_game_session = false
		end
	else
		local var_14_1 = arg_14_0._go_id

		if var_14_1 then
			local var_14_2 = Managers.state.network:game()
			local var_14_3 = GameSession.game_object_field(var_14_2, var_14_1, "painting_index")

			if var_14_3 ~= arg_14_0._go_painting_index then
				arg_14_0._go_painting_index = var_14_3

				local var_14_4 = arg_14_0._paintings_lookup[var_14_3]

				arg_14_0._currently_set_painting = var_14_4

				arg_14_0:_load_painting(var_14_4)
			end
		end
	end

	local var_14_5 = arg_14_0._slow_update_count

	if var_14_5 > 25 then
		var_14_5 = 0

		if arg_14_0._start_hidden and not Unit.get_data(arg_14_0._unit, "painting_data", "start_hidden") then
			arg_14_0._start_hidden = false

			local var_14_6 = arg_14_0._currently_set_painting

			Unit.set_unit_visibility(arg_14_0._unit, false)
			arg_14_0:_load_painting(var_14_6, nil)
			arg_14_0:_show_painting()
		end
	end

	arg_14_0._slow_update_count = var_14_5 + 1

	if not arg_14_0._loading_painting_material and arg_14_0._next_painting.name then
		local var_14_7 = arg_14_0._next_painting.name
		local var_14_8 = arg_14_0._next_painting.cb_done

		table.clear(arg_14_0._next_painting)
		arg_14_0:_load_painting_material(var_14_7, var_14_8)
	end
end

function KeepDecorationPaintingExtension.set_client_painting(arg_15_0, arg_15_1)
	arg_15_0:_load_painting(arg_15_1)
	arg_15_0:_set_selected_painting(arg_15_1)

	local var_15_0 = arg_15_0._go_id

	if var_15_0 then
		local var_15_1 = Managers.state.network:game()

		GameSession.set_game_object_field(var_15_1, var_15_0, "painting_index", arg_15_0._paintings_lookup[arg_15_1])
	end
end

function KeepDecorationPaintingExtension.is_client_painting(arg_16_0)
	return arg_16_0._is_client_painting
end

function KeepDecorationPaintingExtension._hide_painting(arg_17_0)
	arg_17_0._is_hidden = true

	Unit.set_data(arg_17_0._unit, "painting_data", "not_interactable", true)
	Unit.set_unit_visibility(arg_17_0._painting_unit, false)
end

function KeepDecorationPaintingExtension._show_painting(arg_18_0)
	arg_18_0._is_hidden = false

	Unit.set_data(arg_18_0._unit, "painting_data", "not_interactable", false)
	Unit.set_unit_visibility(arg_18_0._painting_unit, true)
end

function KeepDecorationPaintingExtension.get_selected_decoration(arg_19_0)
	if arg_19_0._is_leader then
		local var_19_0 = arg_19_0._backend_key
		local var_19_1 = Managers.backend:get_interface("keep_decorations"):get_decoration(var_19_0)

		if not var_19_1 or not Paintings[var_19_1] then
			var_19_1 = DefaultPaintings[1]
		end

		arg_19_0._currently_set_painting = var_19_1

		return var_19_1
	else
		return arg_19_0._currently_set_painting
	end
end

function KeepDecorationPaintingExtension._set_selected_painting(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._backend_key
	local var_20_1 = Managers.backend
	local var_20_2 = var_20_1:get_interface("keep_decorations")

	arg_20_0._currently_set_painting = arg_20_1

	var_20_2:set_decoration(var_20_0, arg_20_1)
	var_20_1:commit()
end

function KeepDecorationPaintingExtension._load_painting(arg_21_0, arg_21_1, arg_21_2)
	arg_21_1 = arg_21_1 or "hor_none"

	local var_21_0 = Paintings[arg_21_1]
	local var_21_1 = var_21_0.orientation
	local var_21_2 = var_21_0.frame

	arg_21_0._current_preview_painting = arg_21_1

	if var_21_1 == "vertical" then
		arg_21_0._slot = "keep_painting_ver_none"
	elseif var_21_1 == "horizontal" then
		arg_21_0._slot = "keep_painting_hor_none"
	end

	if arg_21_0._temporarily_set_frame ~= var_21_2 or arg_21_0._temporarily_set_orientation ~= var_21_1 then
		arg_21_0:_load_painting_frame(var_21_0)
	end

	if arg_21_1 ~= "hidden" then
		arg_21_0:_load_painting_material(arg_21_1, arg_21_2, arg_21_0._slot)

		if arg_21_0._is_hidden then
			arg_21_0:_show_painting()
		end
	else
		arg_21_0:_load_painting_material("hor_none", arg_21_2, arg_21_0._slot)
		arg_21_0:_hide_painting()
	end

	if arg_21_0._start_hidden then
		arg_21_0:_hide_painting()
	end
end

function KeepDecorationPaintingExtension._load_painting_frame(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_1.orientation
	local var_22_1 = arg_22_1.frame
	local var_22_2
	local var_22_3 = arg_22_0._unit
	local var_22_4 = Unit.local_position(var_22_3, 0)
	local var_22_5 = Unit.local_rotation(var_22_3, 0)
	local var_22_6 = Unit.local_scale(var_22_3, 0)

	if var_22_0 == "horizontal" then
		if var_22_1 == "wood" then
			var_22_2 = World.spawn_unit(arg_22_0._world, "units/gameplay/paintings/keep_painting_wood_long", var_22_4, var_22_5)
		elseif var_22_1 == "painted" then
			var_22_2 = World.spawn_unit(arg_22_0._world, "units/gameplay/paintings/keep_painting_painted_long", var_22_4, var_22_5)
		elseif var_22_1 == "gold" then
			var_22_2 = World.spawn_unit(arg_22_0._world, "units/gameplay/paintings/keep_painting_gold_long", var_22_4, var_22_5)
		end
	elseif var_22_0 == "vertical" then
		if var_22_1 == "wood" then
			var_22_2 = World.spawn_unit(arg_22_0._world, "units/gameplay/paintings/keep_painting_wood_high", var_22_4, var_22_5)
		elseif var_22_1 == "painted" then
			var_22_2 = World.spawn_unit(arg_22_0._world, "units/gameplay/paintings/keep_painting_painted_high", var_22_4, var_22_5)
		elseif var_22_1 == "gold" then
			var_22_2 = World.spawn_unit(arg_22_0._world, "units/gameplay/paintings/keep_painting_gold_high", var_22_4, var_22_5)
		end
	end

	Unit.set_local_scale(var_22_2, 0, var_22_6)

	arg_22_0._temporarily_set_frame = var_22_1
	arg_22_0._temporarily_set_orientation = var_22_0

	local var_22_7 = arg_22_0._painting_unit

	if var_22_7 then
		World.destroy_unit(arg_22_0._world, var_22_7)
	end

	arg_22_0._painting_unit = var_22_2
end

function KeepDecorationPaintingExtension._load_painting_material(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = "keep_painting_" .. arg_23_1
	local var_23_1 = string.find(arg_23_1, "_none") ~= nil
	local var_23_2
	local var_23_3 = arg_23_0._decoration_settings_key

	if not var_23_1 then
		var_23_2 = "resource_packages/keep_paintings/" .. var_23_0
	end

	local var_23_4 = arg_23_0._current_package_name

	local function var_23_5()
		arg_23_0:_apply_material_by_sub_path(var_23_0)

		if arg_23_2 then
			arg_23_2()
		end

		arg_23_0._loading_painting_material = false

		if var_23_4 then
			arg_23_0:_unload_painting_material(var_23_4)

			arg_23_0._previous_package_name = nil
		end
	end

	if not arg_23_0._loading_painting_material then
		arg_23_0._loading_painting_material = true
		arg_23_0._previous_package_name = arg_23_0._current_package_name
		arg_23_0._current_package_name = var_23_2

		if var_23_1 then
			var_23_5()
		else
			Managers.package:load(var_23_2, var_23_3, var_23_5, true)
		end
	else
		arg_23_0._next_painting.name = arg_23_1
		arg_23_0._next_painting.cb_done = arg_23_2
	end
end

function KeepDecorationPaintingExtension._apply_material_by_sub_path(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._painting_unit

	if Unit.alive(var_25_0) then
		local var_25_1 = "units/gameplay/keep_paintings/materials/" .. arg_25_1 .. "/" .. arg_25_1
		local var_25_2 = arg_25_0._slot

		Unit.set_material(var_25_0, var_25_2, var_25_1)
	end
end

function KeepDecorationPaintingExtension._unload_painting_material(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._decoration_settings_key

	if Managers.package:reference_count(arg_26_1, var_26_0) > 0 then
		Managers.package:unload(arg_26_1, var_26_0)
	end
end

function KeepDecorationPaintingExtension._create_game_object(arg_27_0, arg_27_1)
	local var_27_0 = {
		go_type = NetworkLookup.go_types.keep_decoration_painting,
		level_unit_index = arg_27_0._level_unit_index,
		painting_index = arg_27_0._paintings_lookup[arg_27_1]
	}
	local var_27_1 = callback(arg_27_0, "cb_game_session_disconnect")

	arg_27_0._go_id = Managers.state.network:create_game_object("keep_decoration_painting", var_27_0, var_27_1)
end

function KeepDecorationPaintingExtension.cb_game_session_disconnect(arg_28_0)
	arg_28_0._go_id = nil
end

function KeepDecorationPaintingExtension.on_game_object_created(arg_29_0, arg_29_1)
	local var_29_0 = Managers.state.network:game()
	local var_29_1 = GameSession.game_object_field(var_29_0, arg_29_1, "painting_index")
	local var_29_2 = arg_29_0._paintings_lookup[var_29_1]

	arg_29_0:_load_painting(var_29_2, nil)

	arg_29_0._currently_set_painting = var_29_2
	arg_29_0._go_painting_index = var_29_1
	arg_29_0._go_id = arg_29_1
end

function KeepDecorationPaintingExtension.on_game_object_destroyed(arg_30_0)
	arg_30_0._go_id = nil
end
