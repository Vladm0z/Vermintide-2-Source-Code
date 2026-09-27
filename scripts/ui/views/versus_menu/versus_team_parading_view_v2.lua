-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view_v2.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/versus_menu/versus_team_parading_view_v2_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local bottom_widgets_definitions = var_0_0.bottom_widgets_definitions
local top_widgets_definitions = var_0_0.top_widgets_definitions
local team_portrait_frame_widgets = var_0_0.team_portrait_frame_widgets
local transition_widget_definitions = var_0_0.transition_widget_definitions
local animation_definitions = var_0_0.animation_definitions
local create_player_name_career_text = var_0_0.create_player_name_career_text
local view_settings = var_0_0.view_settings
local carousel = DLCSettings.carousel

VersusTeamParadingViewV2 = class(VersusTeamParadingViewV2)
VersusTeamParadingViewV2.NAME = "VersusTeamParadingViewV2"

VersusTeamParadingViewV2.init = function (self, arg_1_1)
	-- function 1
	local player = arg_1_1.player

	self._player = player
	self._peer_id = player:network_id()
	self._local_player_id = player:local_player_id()
	self._ingame_ui = arg_1_1.ingame_ui
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._input_manager = arg_1_1.input_manager
	self._ingame_ui_context = arg_1_1
	self._input_service_name = "ingame_menu"
	self._current_state = "none"
	self._team_heroes = {}

	local world = arg_1_1.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
end

VersusTeamParadingViewV2.on_enter = function (self, arg_2_1)
	-- function 2
	print("[VersusTeamParadingViewV2] Enter Versus Team Parading view")

	self._party_selection_logic = Managers.state.game_mode:game_mode():party_selection_logic()

	self._party_selection_logic:set_ingame_ui(self._ingame_ui)
	ShowCursorStack.show("VersusTeamParadingViewV2")

	local _input_manager = self._input_manager
	local _input_service_name = self._input_service_name

	_input_manager:block_device_except_service(_input_service_name, "keyboard", 1)
	_input_manager:block_device_except_service(_input_service_name, "mouse", 1)
	_input_manager:block_device_except_service(_input_service_name, "gamepad", 1)

	self._animations = {}
	self.render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements(arg_2_1)
	self:_set_transition_widgets_alpha_multiplier(0)
end

VersusTeamParadingViewV2.on_exit = function (self)
	-- function 3
	print("[VersusTeamParadingViewV2] Exit character selection view")
	ShowCursorStack.hide("VersusTeamParadingViewV2")

	local _input_manager = self._input_manager

	_input_manager:device_unblock_all_services("keyboard", 1)
	_input_manager:device_unblock_all_services("mouse", 1)
	_input_manager:device_unblock_all_services("gamepad", 1)

	if not self._team_previewer then
		self:_destroy_team_previewer()
	end

	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	self:_play_sound("vs_unmute_reset_all")
	self:_play_sound("menu_versus_character_amb_loop_stop")
end

VersusTeamParadingViewV2._create_ui_elements = function (self, arg_4_1)
	-- function 4
	self._viewport_widget_definition = self:_create_viewport_definition()

	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._bottom_widgets = {}
	self._top_widgets = {}
	self._transition_widgets = {}
	self._team_portrait_frame_widgets = {}
	self._team_insignia_widgets = {}
	self._player_name_widgets = {}
	self._widgets_by_name = {}

	UIUtils.create_widgets(bottom_widgets_definitions, self._bottom_widgets, self._widgets_by_name)
	UIUtils.create_widgets(top_widgets_definitions, self._top_widgets, self._widgets_by_name)
	UIUtils.create_widgets(transition_widget_definitions, self._transition_widgets, self._widgets_by_name)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

VersusTeamParadingViewV2.draw = function (self, arg_5_1)
	-- function 5
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local input_manager = self.input_manager
	local input_service = self:input_service()
	local render_settings = self.render_settings
	local alpha_multiplier = render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	if not self._viewport_widget then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, input_service, arg_5_1, nil, self.render_settings)
		UIRenderer.draw_widget(_ui_renderer, self._viewport_widget)
		UIRenderer.end_pass(_ui_renderer)
	end

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, input_service, arg_5_1, nil, render_settings)
	self:_draw_widgets(self._bottom_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
	self:_draw_widgets(self._top_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
	self:_draw_widgets(self._player_name_widgets, render_settings, _ui_top_renderer, alpha_multiplier)

	if self._current_state ~= "none" then
		self:_draw_widgets(self._transition_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
	end

	if not self._team_portrait_frame_widgets then
		self:_draw_widgets(self._team_portrait_frame_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
	end

	if not self._team_insignia_widgets then
		self:_draw_widgets(self._team_insignia_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	render_settings.alpha_multiplier = alpha_multiplier
end

VersusTeamParadingViewV2.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:draw(arg_6_1)
end

VersusTeamParadingViewV2.post_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not DO_RELOAD then
		self:_destroy_team_previewer()
		self:_create_ui_elements(self._params)
	end

	if not self._party_id then
		if not self:_setup_teams_party_data() then
			self:_create_team_portrait_frames(self._party_id, self._local_player_party_data)
			self:_create_player_name_widgets(self._party_id)
			self:_set_team_name_widget_colors_and_text(self._party_id)
		else
			return
		end
	end

	if not self._viewport_widget then
		self._viewport_widget = UIWidget.init(self._viewport_widget_definition)

		local _get_viewport_world = self:_get_viewport_world(self._viewport_widget)
		local _get_viewport_camera = self:_get_viewport_camera(self._viewport_widget)
		local _get_viewport_level = self:_get_viewport_level(self._viewport_widget)

		Level.trigger_level_loaded(_get_viewport_level)
		self:_setup_camera_nodes_data(_get_viewport_level)
		self:_setup_initial_camera(_get_viewport_world, _get_viewport_camera)
	end

	if not (#self._team_heroes ~= 0 or self._team_previewer) then
		self:_setup_team_heroes(self._party_id, self._local_player_party_data)
		self:_setup_team_previewer(true)
	end

	if not (not self._team_previewer and DO_RELOAD) then
		local flag = true

		self:_update_team_previewer(arg_7_1, arg_7_2)
	end

	self:_update_parading_phases(arg_7_1, arg_7_2)
	self.ui_animator:update(arg_7_1)
	self:_update_animations(arg_7_1, arg_7_2)
end

VersusTeamParadingViewV2._update_animations = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

VersusTeamParadingViewV2._set_transition_widgets_alpha_multiplier = function (self, arg_9_1)
	-- function 9
	local _transition_widgets = self._transition_widgets

	for i, v in ipairs(_transition_widgets) do
		v.alpha_multiplier = arg_9_1
	end
end

VersusTeamParadingViewV2._setup_teams_party_data = function (self)
	-- function 10
	local _peer_id = self._peer_id
	local _local_player_id = self._local_player_id
	local get_party_from_player_id, var_10_3 = Managers.party:get_party_from_player_id(_peer_id, _local_player_id)

	if var_10_3 == 0 then
		return false
	end

	self._slot_id = Managers.party:get_player_status(_peer_id, _local_player_id).slot_id
	self._party = get_party_from_player_id
	self._party_id = var_10_3
	self._is_spectator = get_party_from_player_id.name == "spectators"

	local get_party = Managers.party:get_party(var_10_3)
	local _get_opponent_party_id = self:_get_opponent_party_id()

	self._opponents_party_id = _get_opponent_party_id
	self._opponents_party_data, self._local_player_party_data = Managers.party:get_party(_get_opponent_party_id), get_party

	return true
end

VersusTeamParadingViewV2._draw_widgets = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	if not arg_11_1 then
		return
	end

	for i, v in ipairs(arg_11_1) do
		local alpha_multiplier = v.alpha_multiplier

		alpha_multiplier = alpha_multiplier or arg_11_4
		arg_11_2.alpha_multiplier = alpha_multiplier

		UIRenderer.draw_widget(arg_11_3, v)
	end
end

VersusTeamParadingViewV2._set_new_camera_pose = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	ScriptCamera.set_local_pose(arg_12_1, arg_12_2:unbox())
end

VersusTeamParadingViewV2._create_team_portrait_frames = function (self, arg_13_1, arg_13_2)
	-- function 13
	table.clear(self._team_portrait_frame_widgets)
	table.clear(self._team_insignia_widgets)

	if not arg_13_2 then
		return
	end

	local picker_list = self._party_selection_logic:get_party_data(arg_13_1).picker_list
	local slots_data = arg_13_2.slots_data

	for i, v in ipairs(picker_list) do
		local var_13_2 = slots_data[v.slot_id]
		local status = v.status

		if not status then
			local selected_profile_index = status.selected_profile_index
			local selected_career_index = status.selected_career_index
			local var_13_6 = SPProfiles[selected_profile_index]
			local str = "player_portrait_anchor_" .. i
			local str_2 = "player_insignia_anchor_" .. i

			if not var_13_6 then
				local var_13_9 = var_13_6.careers[selected_career_index]
				local is_bot = v.is_bot
				local slot_frame

				if var_13_2.slot_frame ~= "n/a" then
					slot_frame = var_13_2.slot_frame

					if not slot_frame then
						-- Nothing
					end
				end

				slot_frame = "frame_0000"

				do
					local str_3
				end

				::label_13_0::

				if not is_bot then
					str_3 = "BOT"
				else
					str_3 = status.level
					str_3 = str_3 or "-"
				end

				local portrait_image = var_13_9.portrait_image
				local create_portrait_frame = UIWidgets.create_portrait_frame(str, slot_frame, str_3, 1, nil, portrait_image)
				local var_13_15 = UIWidget.init(create_portrait_frame, self._ui_top_renderer)

				var_13_15.content.frame_settings_name = slot_frame
				var_13_15.offset = {
					0,
					0,
					20
				}
				self._team_portrait_frame_widgets[#self._team_portrait_frame_widgets + 1] = var_13_15

				local create_small_insignia = UIWidgets.create_small_insignia
				local var_13_17 = str_2
				local versus_level = status.versus_level

				versus_level = versus_level or 0

				local var_13_19 = create_small_insignia(var_13_17, versus_level)
				local var_13_20 = UIWidget.init(var_13_19, self._ui_top_renderer)

				var_13_20.offset = {
					0,
					0,
					20
				}
				self._team_insignia_widgets[#self._team_insignia_widgets + 1] = var_13_20
			end
		end
	end
end

VersusTeamParadingViewV2._create_player_name_widgets = function (self, arg_14_1)
	-- function 14
	local picker_list = self._party_selection_logic:get_party_data(arg_14_1).picker_list

	for i, v in ipairs(picker_list) do
		local status = v.status
		local var_14_2
		local var_14_3
		local selected_profile_index = status.selected_profile_index
		local selected_career_index = status.selected_career_index
		local var_14_6 = SPProfiles[selected_profile_index]
		local str = "player_portrait_anchor_" .. i

		if not var_14_6 then
			var_14_3 = var_14_6.careers[selected_career_index].display_name
		end

		local flag = not status.player and self:_set_player_name(status.player) and "BOT"

		var_14_3 = var_14_3 or "NO_CAREER"

		local var_14_9 = create_player_name_career_text(str)
		local var_14_10 = UIWidget.init(var_14_9)
		local content = var_14_10.content

		content.player_name = flag
		content.career_name = var_14_3
		self._player_name_widgets[#self._player_name_widgets + 1] = var_14_10
	end
end

VersusTeamParadingViewV2._update_parading_phases = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _current_state = self._current_state

	if _current_state == "none" then
		self:_change_state("parade_local_player_team")
	elseif _current_state == "parade_local_player_team" then
		if not self._parading_duration then
			self._parading_duration = arg_15_2 + Managers.state.game_mode:setting("parading_times").local_player

			self:_start_animation("on_enter", "on_enter_local_player")
			self:_play_parading_sfx(true)
		end

		if arg_15_2 > self._parading_duration then
			self._parading_duration = nil

			self:_change_state("team_transition")
			self:_play_sound("Play_menu_versus_parading_versus_whoosh")
		end
	elseif _current_state == "team_transition" then
		if not self._parading_duration then
			self._parading_duration = arg_15_2 + Managers.state.game_mode:setting("parading_times").team_transition

			self:_start_animation("transition", "team_transition_fade_in")
		end

		if arg_15_2 > self._parading_duration - 0.25 then
			self:_start_animation("transition", "team_transition_fade_out")
		end

		if arg_15_2 > self._parading_duration then
			self._parading_duration = nil

			self:_change_state("parade_opponent_team")
			self:_play_parading_sfx(false)
		end
	elseif _current_state == "parade_opponent_team" then
		if not self._parading_duration then
			self._parading_duration = arg_15_2 + Managers.state.game_mode:setting("parading_times").opponent_transition

			self:_start_animation("opponent_parading", "on_enter_opponent_team")
		end

		if arg_15_2 > self._parading_duration then
			self._parading_duration = nil

			self:_change_state("show_match_info")
		end
	elseif not (_current_state ~= "show_match_info" or self._parading_duration) then
		self._parading_duration = arg_15_2 + Managers.state.game_mode:setting("parading_times").show_match_info
	end
end

VersusTeamParadingViewV2._get_heroes_spawn_locations = function (self, arg_16_1)
	-- function 16
	local flag

	flag = arg_16_1 ~= self._party_id or not "character_slot_0" or "character_slot_enemy_0"

	local str = "units/hub_elements/versus_podium_character_spawn"
	local _get_viewport_level_name = self:_get_viewport_level_name()
	local unit_indices = LevelResource.unit_indices(_get_viewport_level_name, str)
	local tbl = {}

	for i = 1, 4 do
		for k, v in pairs(unit_indices) do
			local unit_data = LevelResource.unit_data(_get_viewport_level_name, v)
			local get = DynamicData.get(unit_data, "name")

			if not (not get and get ~= flag .. i) then
				local unit_position = LevelResource.unit_position(_get_viewport_level_name, v)
				local to_elements, var_16_9, var_16_10 = Vector3.to_elements(unit_position)
				local tbl_2 = {
					to_elements,
					var_16_9,
					var_16_10
				}

				tbl[#tbl + 1] = tbl_2
			end
		end
	end

	fassert(#tbl ~= 0, "[VersusTeamParadingViewV2:_get_heroes_spawn_locations], No hero locations have been found. Check if unit: %s is present in level: %s and has the script data varaible \"name\" set to the correct name.", str, _get_viewport_level_name)

	return tbl
end

VersusTeamParadingViewV2._setup_initial_camera = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not arg_17_1 then
		local parading_camera_01 = self._cameras.parading_camera_01

		self._camera = arg_17_2

		local vertical_fov = Camera.vertical_fov(parading_camera_01.camera)

		Camera.set_vertical_fov(arg_17_2, vertical_fov)
		ScriptCamera.set_local_pose(arg_17_2, parading_camera_01.camera_pose:unbox())
		ScriptCamera.force_update(arg_17_1, arg_17_2)
	end
end

VersusTeamParadingViewV2._setup_camera_nodes_data = function (self, arg_18_1)
	-- function 18
	local tbl = {}
	local flow_variable = Level.flow_variable(arg_18_1, "initial_camera")
	local flow_variable_2 = Level.flow_variable(arg_18_1, "parading_position_01")
	local flow_variable_3 = Level.flow_variable(arg_18_1, "parading_position_02")
	local var_18_4 = Matrix4x4Box(Unit.local_pose(flow_variable, 0))
	local var_18_5 = Matrix4x4Box(Unit.local_pose(flow_variable_2, 0))
	local var_18_6 = Matrix4x4Box(Unit.local_pose(flow_variable_3, 0))
	local camera = Unit.camera(flow_variable, "camera")
	local camera_2 = Unit.camera(flow_variable_2, "camera")
	local camera_3 = Unit.camera(flow_variable_3, "camera")

	tbl.initial_camera = {
		camera_unit = flow_variable,
		camera_pose = var_18_4,
		camera = camera
	}
	tbl.parading_camera_01 = {
		camera_unit = flow_variable_2,
		camera_pose = var_18_5,
		camera = camera_2
	}
	tbl.parading_camera_02 = {
		camera_unit = flow_variable_3,
		camera_pose = var_18_6,
		camera = camera_3
	}
	self._cameras = tbl
end

VersusTeamParadingViewV2._setup_team_previewer = function (self, arg_19_1)
	-- function 19
	if not self._team_previewer then
		return
	end

	local flag = arg_19_1 or false
	local _get_viewport_world = self:_get_viewport_world(self._viewport_widget)
	local _get_viewport = self:_get_viewport(self._viewport_widget)

	self._team_previewer = TeamPreviewer:new(self._ingame_ui_context, _get_viewport_world, _get_viewport)

	local _team_heroes = self._team_heroes
	local _get_heroes_spawn_locations = self:_get_heroes_spawn_locations(self._party_id)

	self._team_previewer:setup_team(_team_heroes, _get_heroes_spawn_locations, flag)
end

VersusTeamParadingViewV2._setup_team_heroes = function (self, arg_20_1, arg_20_2)
	-- function 20
	local picker_list = self._party_selection_logic:get_party_data(arg_20_1).picker_list
	local _team_heroes = self._team_heroes

	table.clear(_team_heroes)

	for i, v in ipairs(picker_list) do
		local _get_hero_previewer_data = self:_get_hero_previewer_data(v, arg_20_2)

		_team_heroes[#_team_heroes + 1] = _get_hero_previewer_data or true
	end
end

VersusTeamParadingViewV2._update_team_previewer = function (self, arg_21_1, arg_21_2)
	-- function 21
	local _team_previewer = self._team_previewer

	if not _team_previewer then
		_team_previewer:update(arg_21_1, arg_21_2)
		_team_previewer:post_update(arg_21_1, arg_21_2)
	end
end

VersusTeamParadingViewV2._destroy_team_previewer = function (self)
	-- function 22
	if not self._team_previewer and not self._viewport_widget then
		self._team_previewer:on_exit()

		self._team_previewer = nil

		table.clear(self._team_heroes)
	end
end

VersusTeamParadingViewV2._create_viewport_definition = function (arg_23_0)
	-- function 23
	return {
		scenegraph_id = "screen",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 990,
				shading_environment = "environment/ui_end_screen",
				viewport_name = "versus_parading_preview_viewport",
				clear_screen_on_create = true,
				enable_sub_gui = false,
				fov = 50,
				world_name = "versus_parading_preview",
				world_flags = {
					Application.DISABLE_SOUND,
					Application.DISABLE_ESRAM,
					Application.ENABLE_VOLUMETRICS
				},
				level_name = view_settings.level_name,
				object_sets = LevelResource.object_set_names(view_settings.level_name),
				camera_position = {
					0,
					0,
					0
				},
				camera_lookat = {
					0,
					0,
					0
				}
			}
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		}
	}
end

VersusTeamParadingViewV2._get_hero_previewer_data = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local status = arg_24_1.status
	local selected_profile_index = status.selected_profile_index
	local selected_career_index = status.selected_career_index
	local var_24_3 = SPProfiles[selected_profile_index]

	if not (not var_24_3 and var_24_3.affiliation ~= "dark_pact") then
		return nil
	end

	local slot_id = arg_24_1.slot_id
	local var_24_5 = arg_24_2.slots_data[slot_id]
	local var_24_6 = SPProfiles[selected_profile_index]

	if not var_24_6 then
		local var_24_7 = var_24_6.careers[selected_career_index]
		local versus_preview_animation = var_24_7.versus_preview_animation

		versus_preview_animation = versus_preview_animation or var_24_7.preview_animation

		local preview_wield_slot = var_24_7.preview_wield_slot
		local profile_name = var_24_7.profile_name
		local var_24_11 = var_24_5["slot_" .. preview_wield_slot]
		local slot_hat = var_24_5.slot_hat
		local tbl = {
			var_24_7.preview_items[1],
			{
				item_name = slot_hat == "n/a" or not slot_hat or var_24_7.preview_items[2].item_name
			}
		}
		local slot_skin

		if var_24_5.slot_skin ~= "n/a" then
			slot_skin = var_24_5.slot_skin

			if not slot_skin then
				-- Nothing
			end
		end

		slot_skin = var_24_7.base_skin

		::label_24_0::

		return {
			profile_index = selected_profile_index,
			career_index = selected_career_index,
			skin_name = slot_skin,
			hero_name = profile_name,
			weapon_slot = preview_wield_slot,
			preview_items = tbl,
			preview_animation = versus_preview_animation
		}
	end

	return nil
end

VersusTeamParadingViewV2._get_viewport = function (arg_25_0, arg_25_1)
	-- function 25
	return arg_25_1.element.pass_data[1].viewport
end

VersusTeamParadingViewV2._get_viewport_world = function (arg_26_0, arg_26_1)
	-- function 26
	local var_26_0 = arg_26_1.element.pass_data[1]

	return var_26_0.world, var_26_0.world_name
end

VersusTeamParadingViewV2._get_viewport_level = function (arg_27_0, arg_27_1)
	-- function 27
	return arg_27_1.element.pass_data[1].level
end

VersusTeamParadingViewV2._get_viewport_level_name = function (arg_28_0)
	-- function 28
	return view_settings.level_name
end

VersusTeamParadingViewV2._get_viewport_camera = function (arg_29_0, arg_29_1)
	-- function 29
	return arg_29_1.element.pass_data[1].camera
end

VersusTeamParadingViewV2._get_viewport_name = function (arg_30_0, arg_30_1)
	-- function 30
	return arg_30_1.element.pass_data[1].viewport_name
end

VersusTeamParadingViewV2._get_opponent_party_id = function (self)
	-- function 31
	local flag

	flag = self._party_id ~= 1 or not 2 or 1

	return flag
end

VersusTeamParadingViewV2._set_camera_pose = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	ScriptCamera.set_local_pose(arg_32_2, arg_32_3:unbox())
	ScriptCamera.force_update(arg_32_1, arg_32_2)
end

VersusTeamParadingViewV2.input_service = function (self)
	-- function 33
	return self._input_manager:get_service(self._input_service_name)
end

VersusTeamParadingViewV2._change_state = function (self, arg_34_1)
	-- function 34
	self._current_state = arg_34_1
end

VersusTeamParadingViewV2._start_animation = function (self, arg_35_1, arg_35_2)
	-- function 35
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self.render_settings,
		self = self
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_35_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_35_1] = start_animation
end

VersusTeamParadingViewV2._set_player_name = function (arg_36_0, arg_36_1)
	-- function 36
	local name = arg_36_1:name()

	if Utf8.length(name) > 18 then
		name = string.sub(name, 1, 18) .. "..."
	end

	return name
end

VersusTeamParadingViewV2._change_team_info = function (self, arg_37_1)
	-- function 37
	local _get_opponent_party_id = self:_get_opponent_party_id()

	self:_setup_team_heroes(_get_opponent_party_id, arg_37_1)

	local _get_heroes_spawn_locations = self:_get_heroes_spawn_locations(_get_opponent_party_id)

	self._team_previewer:setup_team(self._team_heroes, _get_heroes_spawn_locations, true)

	local parading_camera_02 = self._cameras.parading_camera_02
	local _get_viewport_world = self:_get_viewport_world(self._viewport_widget)
	local _camera = self._camera
	local camera_pose = parading_camera_02.camera_pose

	self:_set_camera_pose(_get_viewport_world, _camera, camera_pose)
	self:_set_opponent_team_names_and_portraits(_get_opponent_party_id, arg_37_1)
end

VersusTeamParadingViewV2._set_team_names_and_careers = function (self, arg_38_1)
	-- function 38
	local picker_list = self._party_selection_logic:get_party_data(arg_38_1).picker_list

	for i, v in ipairs(picker_list) do
		local status = v.status
		local var_38_2
		local var_38_3
		local selected_profile_index = status.selected_profile_index
		local selected_career_index = status.selected_career_index
		local var_38_6 = SPProfiles[selected_profile_index]

		if not var_38_6 then
			var_38_3 = var_38_6.careers[selected_career_index].display_name
		end

		local flag = not status.player and self:_set_player_name(status.player) and "BOT"

		var_38_3 = var_38_3 or "NO_CAREER"

		local var_38_8 = self._player_name_widgets[i]
		local style = var_38_8.style
		local content = var_38_8.content

		content.player_name = flag
		content.career_name = var_38_3
		style.player_name.text_color = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	end
end

VersusTeamParadingViewV2._set_opponent_team_names_and_portraits = function (self, arg_39_1, arg_39_2)
	-- function 39
	self:_create_team_portrait_frames(arg_39_1, arg_39_2)
	self:_set_team_names_and_careers(arg_39_1)
	self:_set_team_name_widget_colors_and_text(arg_39_1)
end

VersusTeamParadingViewV2._set_team_name_widget_colors_and_text = function (self, arg_40_1)
	-- function 40
	local var_40_0 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_40_1]
	local flag = self._party_id == arg_40_1
	local var_40_2 = carousel.teams_ui_assets[var_40_0]

	if not (not flag and Colors.get_color_table_with_alpha("local_player_team_lighter", 255)) then
		local get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	end

	local top_background_detail = self._widgets_by_name.top_background_detail
	local content = top_background_detail.content
	local flag_2

	flag_2 = not flag and "divider_horizontal_hero_end_blue" and "divider_horizontal_hero_end_red"
	content.divider_edge_left = flag_2

	local content_2 = top_background_detail.content
	local flag_3

	flag_3 = not flag and "divider_horizontal_hero_middle_blue" and "divider_horizontal_hero_middle_red"
	content_2.divider_mid = flag_3

	local divider_edge_right = top_background_detail.content.divider_edge_right
	local flag_4

	flag_4 = not flag and "divider_horizontal_hero_end_blue" and "divider_horizontal_hero_end_red"
	divider_edge_right.texture_id = flag_4

	local team_flag = self._widgets_by_name.team_flag
	local content_3 = team_flag.content
	local local_flag_long_texture

	if not flag then
		local_flag_long_texture = var_40_2.local_flag_long_texture

		if not local_flag_long_texture then
			-- Nothing
		end
	end

	local_flag_long_texture = var_40_2.opponent_flag_long_texture

	::label_40_0::

	content_3.texture_id = local_flag_long_texture

	local offset = team_flag.offset
	local flag_5

	flag_5 = not flag and 30 and 1658
	offset[1] = flag_5

	local bottom_background_detail = self._widgets_by_name.bottom_background_detail
	local content_4 = bottom_background_detail.content
	local flag_6

	flag_6 = not flag and "divider_horizontal_hero_end_blue" and "divider_horizontal_hero_end_red"
	content_4.divider_edge_left = flag_6

	local content_5 = bottom_background_detail.content
	local flag_7

	flag_7 = not flag and "divider_horizontal_hero_middle_blue" and "divider_horizontal_hero_middle_red"
	content_5.divider_mid = flag_7

	local divider_edge_right_2 = bottom_background_detail.content.divider_edge_right
	local flag_8

	flag_8 = not flag and "divider_horizontal_hero_end_blue" and "divider_horizontal_hero_end_red"
	divider_edge_right_2.texture_id = flag_8
end

VersusTeamParadingViewV2._play_sound = function (self, arg_41_1)
	-- function 41
	WwiseWorld.trigger_event(self.wwise_world, arg_41_1)
end

VersusTeamParadingViewV2._play_parading_sfx = function (self, arg_42_1)
	-- function 42
	local _party_id

	if not arg_42_1 then
		_party_id = self._party_id

		if not _party_id then
			-- Nothing
		end
	end

	_party_id = self:_get_opponent_party_id()

	::label_42_0::

	local var_42_1 = Managers.state.game_mode:setting("party_names_lookup_by_id")[_party_id]
	local str = "Play_menu_versus_parading_"
	local flag

	flag = var_42_1 ~= "team_hammers" or not "hammers" or "skulls"

	local str_2 = str .. flag

	self:_play_sound(str_2)
end
