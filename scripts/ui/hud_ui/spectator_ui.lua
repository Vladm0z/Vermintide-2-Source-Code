-- chunkname: @scripts/ui/hud_ui/spectator_ui.lua

SpectatorUI = class(SpectatorUI)

function SpectatorUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ingame_ui = arg_1_2.ingame_ui
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._player_manager = arg_1_2.player_manager
	arg_1_0._ui_animations = {}
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._text = ""

	local var_1_0 = arg_1_2.world_manager:world("level_world")

	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_0)

	local var_1_1 = Managers.state.event

	var_1_1:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
	var_1_1:register(arg_1_0, "new_player_unit", "on_player_spawned")

	arg_1_0._marker_ids = {}
end

function SpectatorUI.destroy(arg_2_0)
	print("[SpectatorUI] - Destroy")

	local var_2_0 = Managers.state.event

	var_2_0:unregister("on_spectator_target_changed", arg_2_0)
	var_2_0:unregister("new_player_unit", arg_2_0)
	arg_2_0:set_visible(false)
end

function SpectatorUI.update(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_0._is_visible then
		return
	end

	arg_3_0:draw(arg_3_1, arg_3_2)
end

function SpectatorUI.draw(arg_4_0, arg_4_1, arg_4_2)
	return
end

function SpectatorUI.set_dirty(arg_5_0)
	arg_5_0._dirty = true
end

function SpectatorUI.set_visible(arg_6_0, arg_6_1)
	arg_6_0._is_visible = arg_6_1

	if arg_6_1 then
		local var_6_0 = arg_6_0:_get_actual_players()

		for iter_6_0, iter_6_1 in pairs(var_6_0) do
			local var_6_1 = iter_6_1.player_unit

			if var_6_1 then
				arg_6_0:_add_world_marker(var_6_1)
			end
		end
	else
		arg_6_0:_clear_world_markers()
	end
end

function SpectatorUI._get_actual_players(arg_7_0)
	local var_7_0 = {}
	local var_7_1 = Managers.party:parties()

	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if iter_7_1.name ~= "spectators" then
			local var_7_2 = iter_7_1.occupied_slots

			for iter_7_2, iter_7_3 in pairs(var_7_2) do
				var_7_0[#var_7_0 + 1] = iter_7_3.player
			end
		end
	end

	return var_7_0
end

function SpectatorUI._add_world_marker(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._marker_ids[arg_8_1]

	if var_8_0 then
		arg_8_0:_clear_world_marker(arg_8_1, var_8_0)
	end

	local var_8_1 = callback(arg_8_0, "cb_world_marker_spawned", arg_8_1)

	Managers.state.event:trigger("add_world_marker_unit", "versus_pactsworn_ghostmode", arg_8_1, var_8_1)
end

function SpectatorUI._clear_world_markers(arg_9_0)
	for iter_9_0, iter_9_1 in pairs(arg_9_0._marker_ids) do
		arg_9_0:_clear_world_marker(iter_9_0, iter_9_1)
	end
end

function SpectatorUI._clear_world_marker(arg_10_0, arg_10_1, arg_10_2)
	Managers.state.event:trigger("remove_world_marker", arg_10_2)

	arg_10_0._marker_ids[arg_10_1] = nil
end

function SpectatorUI.on_spectator_target_changed(arg_11_0, arg_11_1)
	arg_11_0._spectated_player_unit = arg_11_1
	arg_11_0._spectated_player = Managers.player:owner(arg_11_1)
	arg_11_0._is_spectator = true
	arg_11_0._text = "Spectating: " .. arg_11_0._spectated_player:name()
end

function SpectatorUI.on_player_spawned(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if not arg_12_0._is_visible then
		return
	end

	arg_12_0:_add_world_marker(arg_12_2)
end

function SpectatorUI.cb_world_marker_spawned(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = Managers.player:owner(arg_13_1):profile_index()
	local var_13_1 = SPProfiles[var_13_0]

	arg_13_3.content.icon = var_13_1.ui_portrait
	arg_13_0._marker_ids[arg_13_1] = arg_13_2
end
