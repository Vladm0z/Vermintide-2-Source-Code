-- chunkname: @scripts/imgui/imgui_versus_character_picking_debug.lua

local var_0_0 = true

ImguiVersusCharacterPickingDebug = class(ImguiVersusCharacterPickingDebug)

ImguiVersusCharacterPickingDebug.init = function (arg_1_0)
	arg_1_0._initialized = false
end

ImguiVersusCharacterPickingDebug._initialize = function (arg_2_0)
	local var_2_0 = Managers.mechanism:game_mechanism()

	if var_2_0.name ~= "Versus" then
		return
	end

	arg_2_0._mechanism = var_2_0

	local var_2_1 = Managers.state.game_mode:game_mode()

	arg_2_0._party_selection_logic = var_2_1.party_selection_logic and var_2_1:party_selection_logic()

	if not arg_2_0._party_selection_logic then
		return
	end

	local var_2_2 = GameModeSettings.versus

	arg_2_0._timer = 0
	arg_2_0._timer_paused = false
	arg_2_0._startup_time = var_2_2.character_picking_settings.startup_time
	arg_2_0._player_pick_time = var_2_2.character_picking_settings.player_pick_time
	arg_2_0._closing_time = var_2_2.character_picking_settings.closing_time
	arg_2_0._is_server = Managers.mechanism:is_server()
	arg_2_0._pick_data_per_party = {}
	arg_2_0._same_hero_allowed = not not var_2_2.duplicate_hero_profiles_allowed
	arg_2_0._same_career_allowed = not not var_2_2.duplicate_hero_careers_allowed
	arg_2_0._initialized = true
end

ImguiVersusCharacterPickingDebug.update = function (arg_3_0)
	if var_0_0 then
		arg_3_0:init()

		var_0_0 = false
	end

	if not arg_3_0._initialized then
		arg_3_0:_initialize()

		return
	end

	arg_3_0._timer = arg_3_0._party_selection_logic._timer
	arg_3_0._pick_data_per_party = arg_3_0._party_selection_logic._pick_data_per_party
end

ImguiVersusCharacterPickingDebug.is_persistent = function (arg_4_0)
	return true
end

ImguiVersusCharacterPickingDebug._same_line_dummy = function (arg_5_0, arg_5_1, arg_5_2)
	Imgui.same_line()
	Imgui.dummy(arg_5_1, arg_5_2)
	Imgui.same_line()
end

ImguiVersusCharacterPickingDebug.draw = function (arg_6_0, arg_6_1)
	local var_6_0 = Imgui.begin_window("Versus Character Picking Debug", "always_auto_resize")

	arg_6_0:_draw_settings()
	Imgui.separator()
	arg_6_0:_draw_timer()

	if arg_6_0._party_selection_logic._picking_started then
		Imgui.separator()
		arg_6_0:_draw_party_data()
		Imgui.separator()
		arg_6_0:_draw_player_data()
	end

	Imgui.end_window()

	return var_6_0
end

ImguiVersusCharacterPickingDebug._draw_settings = function (arg_7_0)
	Imgui.text("Settings")
	Imgui.indent()
	arg_7_0:_draw_selection_settings()
	Imgui.dummy(0, 4)
	arg_7_0:_draw_time_settings()
	Imgui.unindent()
end

ImguiVersusCharacterPickingDebug._draw_time_settings = function (arg_8_0)
	local var_8_0 = Imgui.slider_float("Startup Time", arg_8_0._startup_time, 0, 60)

	if arg_8_0._is_server and var_8_0 ~= arg_8_0._startup_time then
		arg_8_0._startup_time = var_8_0
		GameModeSettings.versus.character_picking_settings.startup_time = var_8_0

		if arg_8_0._party_selection_logic._picking_started then
			arg_8_0._party_selection_logic._picking_settings.startup_time = var_8_0
		end
	end

	local var_8_1 = Imgui.slider_float("Player Picking Time", arg_8_0._player_pick_time, 0, 60)

	if arg_8_0._is_server and var_8_1 ~= arg_8_0._player_pick_time then
		arg_8_0._player_pick_time = var_8_1
		GameModeSettings.versus.character_picking_settings.player_pick_time = var_8_1

		if arg_8_0._party_selection_logic._picking_started then
			arg_8_0._party_selection_logic._picking_settings.player_pick_time = var_8_1
		end
	end

	local var_8_2 = Imgui.slider_float("Closing Time", arg_8_0._closing_time, 0, 60)

	if arg_8_0._is_server and var_8_2 ~= arg_8_0._closing_time then
		arg_8_0._closing_time = var_8_2
		GameModeSettings.versus.character_picking_settings.closing_time = var_8_2

		if arg_8_0._party_selection_logic._picking_started then
			arg_8_0._party_selection_logic._picking_settings.closing_time = var_8_2
		end
	end
end

ImguiVersusCharacterPickingDebug._draw_timer = function (arg_9_0)
	Imgui.text("Timer")
	Imgui.indent()

	local var_9_0 = Imgui.slider_float("Timer", arg_9_0._timer, 0, 60)

	if arg_9_0._is_server and var_9_0 ~= arg_9_0._timer then
		arg_9_0._timer = var_9_0
		arg_9_0._party_selection_logic._timer = var_9_0
	end

	Imgui.same_line()

	local var_9_1 = Imgui.checkbox("Pause", arg_9_0._timer_paused)

	if arg_9_0._is_server and var_9_1 ~= arg_9_0._timer_paused then
		arg_9_0._timer_paused = var_9_1
		arg_9_0._party_selection_logic._timer_paused = var_9_1
	end

	Imgui.unindent()
end

ImguiVersusCharacterPickingDebug._draw_selection_settings = function (arg_10_0)
	local var_10_0 = Imgui.checkbox("Same Hero Allowed", arg_10_0._same_hero_allowed)

	if arg_10_0._is_server and var_10_0 ~= arg_10_0._same_hero_allowed then
		arg_10_0._same_hero_allowed = var_10_0
		GameModeSettings.versus.duplicate_hero_profiles_allowed = var_10_0
	end

	local var_10_1 = Imgui.checkbox("Same Career Allowed", arg_10_0._same_career_allowed)

	if arg_10_0._is_server and var_10_1 ~= arg_10_0._same_career_allowed then
		arg_10_0._same_career_allowed = var_10_1
		GameModeSettings.versus.duplicate_hero_careers_allowed = var_10_1
	end
end

ImguiVersusCharacterPickingDebug._draw_party_data = function (arg_11_0)
	local var_11_0 = arg_11_0._pick_data_per_party

	Imgui.text("Party Data")

	for iter_11_0, iter_11_1 in ipairs(var_11_0) do
		Imgui.tree_push(iter_11_0)

		local var_11_1 = Managers.party:get_party(iter_11_0)

		if Imgui.tree_node(string.format("Party %d", iter_11_0)) then
			Imgui.indent()
			Imgui.text(string.format("State: %s", iter_11_1.state))
			Imgui.text(string.format("Slider Timer: %s", iter_11_1.slider_timer))
			Imgui.text(string.format("Timer Finish: %s", iter_11_1.time_finished))
			Imgui.text(string.format("Current Picker Index: %d", iter_11_1.current_picker_index))
			Imgui.text(string.format("Prev Picker Index: %s", iter_11_1.prev_picker_index))
			Imgui.text(string.format("Party Size: %d", var_11_1.num_slots))
			Imgui.text(string.format("Number of Players: %d", var_11_1.num_used_slots))

			if Imgui.tree_node("Available Characters") then
				Imgui.indent()

				local var_11_2 = iter_11_1.available_characters

				for iter_11_2, iter_11_3 in pairs(var_11_2) do
					local var_11_3 = SPProfiles[iter_11_2]

					if Imgui.tree_node(var_11_3.display_name) then
						Imgui.indent()

						for iter_11_4, iter_11_5 in pairs(iter_11_3) do
							local var_11_4 = var_11_3.careers[iter_11_5]

							Imgui.text(var_11_4.display_name)
						end

						Imgui.unindent()
						Imgui.tree_pop()
					end
				end

				Imgui.unindent()
				Imgui.tree_pop()
			end

			Imgui.unindent()
			Imgui.tree_pop()
		end

		Imgui.tree_pop()
	end
end

ImguiVersusCharacterPickingDebug._draw_player_data = function (arg_12_0)
	local var_12_0 = arg_12_0._pick_data_per_party

	Imgui.text("Player Data")

	for iter_12_0, iter_12_1 in ipairs(var_12_0) do
		Imgui.tree_push(iter_12_0 .. "1")

		if Imgui.tree_node(string.format("Party %d", iter_12_0)) then
			Imgui.indent()

			local var_12_1 = iter_12_1.picker_list

			for iter_12_2, iter_12_3 in pairs(var_12_1) do
				local var_12_2 = iter_12_3.status
				local var_12_3 = var_12_2.player
				local var_12_4 = var_12_2.is_player
				local var_12_5

				var_12_5 = var_12_4 and "True" or "False"

				local var_12_6 = var_12_4 and var_12_3:name() or string.format("Bot #%d", iter_12_2)

				if Imgui.tree_node(var_12_6) then
					Imgui.indent()

					local var_12_7 = var_12_2.selected_profile_index
					local var_12_8 = var_12_2.selected_career_index
					local var_12_9
					local var_12_10

					if var_12_7 and var_12_7 > 0 then
						local var_12_11 = SPProfiles[var_12_7]
						local var_12_12 = var_12_11.careers[var_12_8]

						var_12_9 = string.format("%s (%d)", var_12_11.display_name, var_12_7)
						var_12_10 = string.format("%s (%d)", var_12_12.display_name, var_12_8)
					else
						var_12_9 = "nil"
						var_12_10 = "nil"
					end

					Imgui.text(string.format("State: %s", iter_12_3.state))
					Imgui.text(string.format("Picker Index: %d", iter_12_3.picker_index))
					Imgui.text(string.format("Slot Index: %d", iter_12_3.slot_id))
					Imgui.text(string.format("Profile Index: %s", var_12_9))
					Imgui.text(string.format("Career Index: %s", var_12_10))
					Imgui.unindent()
					Imgui.tree_pop()
				end
			end

			Imgui.unindent()
			Imgui.tree_pop()
		end

		Imgui.tree_pop()
	end
end

ImguiVersusCharacterPickingDebug._draw_pick_data = function (arg_13_0)
	local var_13_0 = arg_13_0._pick_data_per_party

	Imgui.unindent()

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		Imgui.tree_push(iter_13_0)
		Imgui.dummy(360, 8)

		local var_13_1 = Managers.party:get_party(iter_13_1.party_id).slots_data

		Imgui.text("Party " .. iter_13_1.party_id)
		Imgui.text("State: " .. iter_13_1.state)
		Imgui.text("Current Picker Index: " .. iter_13_1.current_picker_index)

		if Imgui.tree_node("Available Characters") then
			Imgui.unindent()

			local var_13_2 = iter_13_1.available_characters

			for iter_13_2, iter_13_3 in pairs(var_13_2) do
				Imgui.tree_push(iter_13_2)

				local var_13_3 = SPProfiles[iter_13_2]
				local var_13_4 = var_13_3.display_name

				if Imgui.tree_node(var_13_4) then
					for iter_13_4, iter_13_5 in pairs(iter_13_3) do
						Imgui.text(var_13_3.careers[iter_13_4].display_name)
					end

					Imgui.tree_pop()
				end

				Imgui.tree_pop()
			end

			for iter_13_6, iter_13_7 in ipairs(var_13_2) do
				-- Nothing
			end

			Imgui.tree_pop()
			Imgui.indent()
		end

		if Imgui.tree_node("Picker List") then
			for iter_13_8, iter_13_9 in ipairs(iter_13_1.picker_list) do
				Imgui.tree_push(iter_13_8)

				local var_13_5 = iter_13_9.status
				local var_13_6 = var_13_1[iter_13_9.slot_id]
				local var_13_7 = var_13_5.is_player
				local var_13_8 = var_13_5.is_player and "True" or "False"
				local var_13_9 = var_13_7 and var_13_5.player:name() or "Bot #" .. tostring(iter_13_9.picker_index)
				local var_13_10 = "State: " .. iter_13_9.state .. (arg_13_0._is_server and " (server)" or " (client)")

				Imgui.text(var_13_9)
				Imgui.text("Is Player: " .. var_13_8)
				Imgui.text("State: " .. var_13_10)
				Imgui.text("Picker Index: " .. tostring(iter_13_9.picker_index))
				Imgui.text("Slot Id: " .. tostring(iter_13_9.slot_id))

				if Imgui.tree_node("Status Data") then
					Imgui.text("Selected Profile Index: " .. tostring(var_13_5.selected_profile_index))
					Imgui.text("Selected Career Index: " .. tostring(var_13_5.selected_career_index))
					Imgui.text("Profile Index: " .. tostring(var_13_5.profile_index))
					Imgui.text("Career Index: " .. tostring(var_13_5.career_index))
					Imgui.tree_pop()
				end

				if Imgui.tree_node("Slot Data") then
					Imgui.text("Slot Melee: " .. tostring(var_13_6.slot_melee))
					Imgui.text("Slot Ranged: " .. tostring(var_13_6.slot_ranged))
					Imgui.text("Slot Skin: " .. tostring(var_13_6.slot_skin))
					Imgui.text("Slot Hat: " .. tostring(var_13_6.slot_hat))
					Imgui.tree_pop()
				end

				Imgui.tree_pop()
			end

			Imgui.tree_pop()
		end

		Imgui.tree_pop()
	end
end
