-- chunkname: @scripts/imgui/imgui_versus_character_picking_debug.lua

local flag = true

ImguiVersusCharacterPickingDebug = class(ImguiVersusCharacterPickingDebug)

ImguiVersusCharacterPickingDebug.init = function (self)
	-- function 1
	self._initialized = false
end

ImguiVersusCharacterPickingDebug._initialize = function (self)
	-- function 2
	local game_mechanism = Managers.mechanism:game_mechanism()

	if game_mechanism.name ~= "Versus" then
		return
	end

	self._mechanism = game_mechanism

	local game_mode = Managers.state.game_mode:game_mode()
	local party_selection_logic = game_mode.party_selection_logic

	party_selection_logic = not party_selection_logic and game_mode:party_selection_logic()
	self._party_selection_logic = party_selection_logic

	if not self._party_selection_logic then
		return
	end

	local versus = GameModeSettings.versus

	self._timer = 0
	self._timer_paused = false
	self._startup_time = versus.character_picking_settings.startup_time
	self._player_pick_time = versus.character_picking_settings.player_pick_time
	self._closing_time = versus.character_picking_settings.closing_time
	self._is_server = Managers.mechanism:is_server()
	self._pick_data_per_party = {}
	self._same_hero_allowed = not not versus.duplicate_hero_profiles_allowed
	self._same_career_allowed = not not versus.duplicate_hero_careers_allowed
	self._initialized = true
end

ImguiVersusCharacterPickingDebug.update = function (self)
	-- function 3
	if not flag then
		self:init()

		flag = false
	end

	if not self._initialized then
		self:_initialize()

		return
	end

	self._timer = self._party_selection_logic._timer
	self._pick_data_per_party = self._party_selection_logic._pick_data_per_party
end

ImguiVersusCharacterPickingDebug.is_persistent = function (arg_4_0)
	-- function 4
	return true
end

ImguiVersusCharacterPickingDebug._same_line_dummy = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	Imgui.same_line()
	Imgui.dummy(arg_5_1, arg_5_2)
	Imgui.same_line()
end

ImguiVersusCharacterPickingDebug.draw = function (self, arg_6_1)
	-- function 6
	local begin_window = Imgui.begin_window("Versus Character Picking Debug", "always_auto_resize")

	self:_draw_settings()
	Imgui.separator()
	self:_draw_timer()

	if not self._party_selection_logic._picking_started then
		Imgui.separator()
		self:_draw_party_data()
		Imgui.separator()
		self:_draw_player_data()
	end

	Imgui.end_window()

	return begin_window
end

ImguiVersusCharacterPickingDebug._draw_settings = function (self)
	-- function 7
	Imgui.text("Settings")
	Imgui.indent()
	self:_draw_selection_settings()
	Imgui.dummy(0, 4)
	self:_draw_time_settings()
	Imgui.unindent()
end

ImguiVersusCharacterPickingDebug._draw_time_settings = function (self)
	-- function 8
	local slider_float = Imgui.slider_float("Startup Time", self._startup_time, 0, 60)

	if not (not self._is_server and slider_float == self._startup_time) then
		self._startup_time = slider_float
		GameModeSettings.versus.character_picking_settings.startup_time = slider_float

		if not self._party_selection_logic._picking_started then
			self._party_selection_logic._picking_settings.startup_time = slider_float
		end
	end

	local slider_float_2 = Imgui.slider_float("Player Picking Time", self._player_pick_time, 0, 60)

	if not (not self._is_server and slider_float_2 == self._player_pick_time) then
		self._player_pick_time = slider_float_2
		GameModeSettings.versus.character_picking_settings.player_pick_time = slider_float_2

		if not self._party_selection_logic._picking_started then
			self._party_selection_logic._picking_settings.player_pick_time = slider_float_2
		end
	end

	local slider_float_3 = Imgui.slider_float("Closing Time", self._closing_time, 0, 60)

	if not (not self._is_server and slider_float_3 == self._closing_time) then
		self._closing_time = slider_float_3
		GameModeSettings.versus.character_picking_settings.closing_time = slider_float_3

		if not self._party_selection_logic._picking_started then
			self._party_selection_logic._picking_settings.closing_time = slider_float_3
		end
	end
end

ImguiVersusCharacterPickingDebug._draw_timer = function (self)
	-- function 9
	Imgui.text("Timer")
	Imgui.indent()

	local slider_float = Imgui.slider_float("Timer", self._timer, 0, 60)

	if not (not self._is_server and slider_float == self._timer) then
		self._timer = slider_float
		self._party_selection_logic._timer = slider_float
	end

	Imgui.same_line()

	local checkbox = Imgui.checkbox("Pause", self._timer_paused)

	if not (not self._is_server and checkbox == self._timer_paused) then
		self._timer_paused = checkbox
		self._party_selection_logic._timer_paused = checkbox
	end

	Imgui.unindent()
end

ImguiVersusCharacterPickingDebug._draw_selection_settings = function (self)
	-- function 10
	local checkbox = Imgui.checkbox("Same Hero Allowed", self._same_hero_allowed)

	if not (not self._is_server and checkbox == self._same_hero_allowed) then
		self._same_hero_allowed = checkbox
		GameModeSettings.versus.duplicate_hero_profiles_allowed = checkbox
	end

	local checkbox_2 = Imgui.checkbox("Same Career Allowed", self._same_career_allowed)

	if not (not self._is_server and checkbox_2 == self._same_career_allowed) then
		self._same_career_allowed = checkbox_2
		GameModeSettings.versus.duplicate_hero_careers_allowed = checkbox_2
	end
end

ImguiVersusCharacterPickingDebug._draw_party_data = function (self)
	-- function 11
	local _pick_data_per_party = self._pick_data_per_party

	Imgui.text("Party Data")

	for i, v in ipairs(_pick_data_per_party) do
		Imgui.tree_push(i)

		local get_party = Managers.party:get_party(i)

		if not Imgui.tree_node(string.format("Party %d", i)) then
			Imgui.indent()
			Imgui.text(string.format("State: %s", v.state))
			Imgui.text(string.format("Slider Timer: %s", v.slider_timer))
			Imgui.text(string.format("Timer Finish: %s", v.time_finished))
			Imgui.text(string.format("Current Picker Index: %d", v.current_picker_index))
			Imgui.text(string.format("Prev Picker Index: %s", v.prev_picker_index))
			Imgui.text(string.format("Party Size: %d", get_party.num_slots))
			Imgui.text(string.format("Number of Players: %d", get_party.num_used_slots))

			if not Imgui.tree_node("Available Characters") then
				Imgui.indent()

				local available_characters = v.available_characters

				for k, v_2 in pairs(available_characters) do
					local var_11_3 = SPProfiles[k]

					if not Imgui.tree_node(var_11_3.display_name) then
						Imgui.indent()

						for k_2, v_3 in pairs(v_2) do
							local var_11_4 = var_11_3.careers[v_3]

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

ImguiVersusCharacterPickingDebug._draw_player_data = function (self)
	-- function 12
	local _pick_data_per_party = self._pick_data_per_party

	Imgui.text("Player Data")

	for i, v in ipairs(_pick_data_per_party) do
		Imgui.tree_push(i .. "1")

		if not Imgui.tree_node(string.format("Party %d", i)) then
			Imgui.indent()

			local picker_list = v.picker_list

			for k, v_2 in pairs(picker_list) do
				local status = v_2.status
				local player = status.player
				local is_player = status.is_player
				local flag

				flag = not is_player and "True" and "False"

				local name

				if not is_player then
					name = player:name()

					if not name then
						-- Nothing
					end
				end

				name = string.format("Bot #%d", k)

				::label_12_0::

				if not Imgui.tree_node(name) then
					Imgui.indent()

					local selected_profile_index = status.selected_profile_index
					local selected_career_index = status.selected_career_index
					local var_12_9
					local var_12_10

					if not (not selected_profile_index and not (selected_profile_index > 0)) then
						local var_12_11 = SPProfiles[selected_profile_index]
						local var_12_12 = var_12_11.careers[selected_career_index]

						var_12_9 = string.format("%s (%d)", var_12_11.display_name, selected_profile_index)
						var_12_10 = string.format("%s (%d)", var_12_12.display_name, selected_career_index)
					else
						var_12_9 = "nil"
						var_12_10 = "nil"
					end

					Imgui.text(string.format("State: %s", v_2.state))
					Imgui.text(string.format("Picker Index: %d", v_2.picker_index))
					Imgui.text(string.format("Slot Index: %d", v_2.slot_id))
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

ImguiVersusCharacterPickingDebug._draw_pick_data = function (self)
	-- function 13
	local _pick_data_per_party = self._pick_data_per_party

	Imgui.unindent()

	for i, v in ipairs(_pick_data_per_party) do
		Imgui.tree_push(i)
		Imgui.dummy(360, 8)

		local slots_data = Managers.party:get_party(v.party_id).slots_data

		Imgui.text("Party " .. v.party_id)
		Imgui.text("State: " .. v.state)
		Imgui.text("Current Picker Index: " .. v.current_picker_index)

		if not Imgui.tree_node("Available Characters") then
			Imgui.unindent()

			local available_characters = v.available_characters

			for k, v_2 in pairs(available_characters) do
				Imgui.tree_push(k)

				local var_13_3 = SPProfiles[k]
				local display_name = var_13_3.display_name

				if not Imgui.tree_node(display_name) then
					for k_2, v_3 in pairs(v_2) do
						Imgui.text(var_13_3.careers[k_2].display_name)
					end

					Imgui.tree_pop()
				end

				Imgui.tree_pop()
			end

			for i_2, v_4 in ipairs(available_characters) do
				-- Nothing
			end

			Imgui.tree_pop()
			Imgui.indent()
		end

		if not Imgui.tree_node("Picker List") then
			for i_3, v_5 in ipairs(v.picker_list) do
				Imgui.tree_push(i_3)

				local status = v_5.status
				local var_13_6 = slots_data[v_5.slot_id]
				local is_player = status.is_player
				local flag

				flag = not status.is_player and "True" and "False"

				local name

				if not is_player then
					name = status.player:name()

					if not name then
						-- Nothing
					end
				end

				name = "Bot #" .. tostring(v_5.picker_index)

				::label_13_0::

				local str = "State: "
				local state = v_5.state
				local flag_2

				flag_2 = not self._is_server and " (server)" and " (client)"

				local str_2 = str .. state .. flag_2

				Imgui.text(name)
				Imgui.text("Is Player: " .. flag)
				Imgui.text("State: " .. str_2)
				Imgui.text("Picker Index: " .. tostring(v_5.picker_index))
				Imgui.text("Slot Id: " .. tostring(v_5.slot_id))

				if not Imgui.tree_node("Status Data") then
					Imgui.text("Selected Profile Index: " .. tostring(status.selected_profile_index))
					Imgui.text("Selected Career Index: " .. tostring(status.selected_career_index))
					Imgui.text("Profile Index: " .. tostring(status.profile_index))
					Imgui.text("Career Index: " .. tostring(status.career_index))
					Imgui.tree_pop()
				end

				if not Imgui.tree_node("Slot Data") then
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
