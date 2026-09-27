-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_loot.lua

require("scripts/ui/views/hero_view/loot_item_unit_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_loot_definitions")
local str = "trigger_cycle_next"
local str_2 = "trigger_cycle_previous"
local str_3 = "cycle_next"
local str_4 = "cycle_previous"
local widgets = var_0_0.widgets
local gamepad_tooltip_widgets = var_0_0.gamepad_tooltip_widgets
local input_description_widgets = var_0_0.input_description_widgets
local continue_button = var_0_0.continue_button
local option_widgets = var_0_0.option_widgets
local debug_button_widgets = var_0_0.debug_button_widgets
local option_background_widgets = var_0_0.option_background_widgets
local preview_widgets = var_0_0.preview_widgets
local viewport_widget = var_0_0.viewport_widget
local settings_by_screen = var_0_0.settings_by_screen
local generic_input_actions = var_0_0.generic_input_actions
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local background_fade_definition = var_0_0.background_fade_definition
local loot_option_positions_by_amount = var_0_0.loot_option_positions_by_amount
local num_loot_options = var_0_0.num_loot_options
local create_chest_indicator_func = var_0_0.create_chest_indicator_func
local arrow_widgets = var_0_0.arrow_widgets
local USE_DELAYED_SPAWN = var_0_0.USE_DELAYED_SPAWN
local tbl = {
	persistance = 0.9,
	fade_out = 0.3,
	amplitude = 1,
	duration = 0.3,
	fade_in = 0.1,
	octaves = 5.5
}
local tbl_2 = {
	persistance = 1,
	fade_out = 0.5,
	amplitude = 0.9,
	seed = 0,
	duration = 0.5,
	fade_in = 0.1,
	octaves = 7
}
local num = 0.7
local num_2 = 1.2
local num_3 = 0.8
local num_4 = 0.8
local num_5 = 0.9
local num_6 = 1
local num_7 = 1
local num_8 = 2
local num_9 = 1
local tbl_3 = {
	default = {
		front = {
			255,
			173,
			155,
			99
		},
		back = {
			255,
			255,
			223,
			154
		},
		center = {
			255,
			255,
			223,
			154
		}
	},
	plentiful = {
		front = {
			255,
			255,
			255,
			255
		},
		back = {
			255,
			255,
			255,
			255
		},
		center = {
			50,
			255,
			255,
			255
		}
	},
	common = {
		front = {
			255,
			255,
			223,
			154
		},
		back = {
			255,
			38,
			254,
			18
		},
		center = {
			150,
			38,
			254,
			18
		}
	},
	rare = {
		front = {
			255,
			154,
			255,
			219
		},
		back = {
			255,
			30,
			171,
			255
		},
		center = {
			255,
			30,
			171,
			255
		}
	},
	exotic = {
		back = {
			255,
			255,
			106,
			6
		},
		front = {
			255,
			245,
			255,
			154
		},
		center = {
			255,
			255,
			106,
			6
		}
	},
	unique = {
		front = {
			255,
			255,
			210,
			179
		},
		back = {
			255,
			254,
			25,
			18
		},
		center = {
			255,
			254,
			25,
			18
		}
	},
	promo = {
		back = {
			255,
			119,
			18,
			254
		},
		front = {
			255,
			255,
			223,
			154
		},
		center = {
			255,
			119,
			18,
			254
		}
	}
}
local flag = false

HeroViewStateLoot = class(HeroViewStateLoot)
HeroViewStateLoot.NAME = "HeroViewStateLoot"

HeroViewStateLoot.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.parent:clear_wanted_state()
	print("[HeroViewState] Enter Substate HeroViewStateLoot")

	self.hero_name = arg_1_1.hero_name
	self.settings_by_screen = arg_1_1.settings_by_screen

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.ingame_ui = ingame_ui_context.ingame_ui
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.world_previewer = arg_1_1.world_previewer
	self.wwise_world = arg_1_1.wwise_world
	self.platform = PLATFORM

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.player = local_player
	self.peer_id = ingame_ui_context.peer_id
	self.local_player_id = ingame_ui_context.local_player_id
	self.profile_synchronizer = ingame_ui_context.profile_synchronizer

	local profile_by_peer = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)
	local var_1_4 = SPProfiles[profile_by_peer]
	local display_name = var_1_4.display_name
	local character_name = var_1_4.character_name

	self.career_index = Managers.backend:get_interface("hero_attributes"):get(display_name, "career")
	self.profile_index = profile_by_peer
	self._loaded_package = nil
	self._animations = {}
	self._ui_animations = {}
	self._units = {}
	self._chest_indicators = {}
	self.waiting_for_post_update_enter = true
	self._camera_look_up_progress = 0
	self._continue_button_progress = 0
	self._current_page_index = 1
	self._viewports_dirty = false
	self._num_chests = 1

	Managers.state.event:trigger("tutorial_trigger", "loot_menu_opened")
end

HeroViewStateLoot.post_update_on_enter = function (self)
	-- function 2
	self.waiting_for_post_update_enter = nil

	local ingame_ui_context = self.ingame_ui_context

	self.world_manager = ingame_ui_context.world_manager

	local create_world = self.world_manager:create_world("loot_world", "environment/gui", nil, 980, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	World.set_data(create_world, "avoid_blend", true)
	ScriptWorld.deactivate(create_world)
	ScriptWorld.create_viewport(create_world, "loot_world_viewport", "overlay", 1)

	self.loot_ui_renderer = self.ingame_ui:create_ui_renderer(create_world)
	self.loot_ui_world = create_world

	local get_service = self.input_manager:get_service("hero_view")
	local num = UILayer.default + 30

	self.menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self.loot_ui_renderer, get_service, 6, num, generic_input_actions.default, true)

	self.menu_input_description:set_input_description(generic_input_actions.chest_not_selected)
	self:create_ui_elements()

	self.viewport_widget = UIWidget.init(viewport_widget)

	self:_setup_camera()
	self:set_chest_title_alpha_progress(0)

	self._enter_animation_duration = 0

	self:populate_items()
	self:_setup_info_window()
	self:play_sound("play_gui_chestroom_start")
	self:disable_player_world()
	self:_setup_input_buttons()

	self._console_selection_index = 1
	self._draw_input_desc_widgets = true
end

HeroViewStateLoot._setup_input_buttons = function (self)
	-- function 3
	local get_service = Managers.input:get_service("hero_view")
	local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(get_service, str, true)
	local get_gamepad_input_texture_data_2 = UISettings.get_gamepad_input_texture_data(get_service, str_2, true)
	local _widgets_by_name = self._widgets_by_name
	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local texture_id = input_icon_next.style.texture_id

	texture_id.horizontal_alignment = "center"
	texture_id.vertical_alignment = "center"
	texture_id.texture_size = {
		get_gamepad_input_texture_data.size[1],
		get_gamepad_input_texture_data.size[2]
	}
	input_icon_next.content.texture_id = get_gamepad_input_texture_data.texture

	local texture_id_2 = input_icon_previous.style.texture_id

	texture_id_2.horizontal_alignment = "center"
	texture_id_2.vertical_alignment = "center"
	texture_id_2.texture_size = {
		get_gamepad_input_texture_data_2.size[1],
		get_gamepad_input_texture_data_2.size[2]
	}
	input_icon_previous.content.texture_id = get_gamepad_input_texture_data_2.texture
end

HeroViewStateLoot._set_gamepad_input_buttons_visibility = function (self, arg_4_1)
	-- function 4
	local _widgets_by_name = self._widgets_by_name
	local input_icon_next = _widgets_by_name.input_icon_next
	local input_icon_previous = _widgets_by_name.input_icon_previous
	local input_arrow_next = _widgets_by_name.input_arrow_next
	local input_arrow_previous = _widgets_by_name.input_arrow_previous

	input_icon_next.content.visible = arg_4_1
	input_icon_previous.content.visible = arg_4_1
	input_arrow_next.content.visible = arg_4_1
	input_arrow_previous.content.visible = arg_4_1
end

HeroViewStateLoot.disable_player_world = function (self)
	-- function 5
	if not self._player_world_disabled then
		self._player_world_disabled = true

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)
	end
end

HeroViewStateLoot.enable_player_world = function (self)
	-- function 6
	if not self._player_world_disabled then
		self._player_world_disabled = false

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.activate_viewport(world, viewport)
	end
end

HeroViewStateLoot.populate_items = function (self)
	-- function 7
	local _widgets_by_name = self._widgets_by_name
	local hero_name = self.hero_name
	local career_index = self.career_index

	local function fn(self, arg_8_1)
		-- function 8
		local data = self.data
		local data_2 = arg_8_1.data
		local chest_sort_order = data.chest_sort_order
		local chest_sort_order_2 = data_2.chest_sort_order
		local chest_tier = data.chest_tier
		local chest_tier_2 = data_2.chest_tier

		if chest_sort_order == chest_sort_order_2 then
			if chest_tier == chest_tier_2 then
				return self.backend_id < arg_8_1.backend_id
			else
				return chest_tier < chest_tier_2
			end
		end

		return chest_sort_order < chest_sort_order_2
	end

	local item_filter = settings_by_screen[1].item_filter
	local _get_items_by_filter = self:_get_items_by_filter(item_filter)
	local num = 1

	table.sort(_get_items_by_filter, fn)

	local tbl = {}
	local item_grid = _widgets_by_name.item_grid
	local var_7_9 = ItemGridUI:new(settings_by_screen, item_grid, hero_name, career_index)
	local tbl_2 = {}

	var_7_9:disable_locked_items(true)
	var_7_9:apply_item_sorting_function(fn)
	var_7_9:change_category("loot")
	var_7_9:disable_item_drag()

	if not self._current_page then
		local get_page_info, var_7_12 = var_7_9:get_page_info()
		local min = math.min(self._current_page, var_7_12)

		var_7_9:set_item_page(min)
	end

	self._item_grid = var_7_9

	local var_7_14
	local flag = false
	local _last_selected_item = self._last_selected_item

	if not _last_selected_item and not var_7_9:has_item(_last_selected_item) then
		var_7_14 = _last_selected_item
	else
		var_7_14 = var_7_9:get_item_in_slot(1, 1)
		flag = true
	end

	self:_select_grid_item(var_7_14, nil, flag)
end

HeroViewStateLoot._get_items_by_filter = function (arg_9_0, arg_9_1)
	-- function 9
	return (Managers.backend:get_interface("items"):get_filtered_items(arg_9_1))
end

HeroViewStateLoot.get_background_world = function (self)
	-- function 10
	return self.parent:get_background_world()
end

HeroViewStateLoot.transitioning = function (self)
	-- function 11
	if not self.exiting then
		return true
	else
		return false
	end
end

HeroViewStateLoot.wanted_menu_state = function (self)
	-- function 12
	return self._wanted_menu_state
end

HeroViewStateLoot.clear_wanted_menu_state = function (self)
	-- function 13
	self._wanted_menu_state = nil
end

HeroViewStateLoot._wanted_state = function (self)
	-- function 14
	return (self.parent:wanted_state())
end

HeroViewStateLoot.create_ui_elements = function (self)
	-- function 15
	if not self._preview_loot_widgets then
		for i, v in ipairs(self._preview_loot_widgets) do
			UIWidget.destroy(self.loot_ui_renderer, v)
		end
	end

	flag = false
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.background_fade_widget = UIWidget.init(background_fade_definition)
	self._debug_widgets, self._debug_widgets_by_name = UIUtils.create_widgets(debug_button_widgets)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._option_widgets, self._option_widgets_by_name = UIUtils.create_widgets(option_widgets)
	self._option_background_widgets, self._option_background_widgets_by_name = UIUtils.create_widgets(option_background_widgets)
	self._preview_loot_widgets, self._preview_loot_widgets_by_name = UIUtils.create_widgets(preview_widgets)
	self._input_desc_widgets, self._input_desc_widgets_by_name = UIUtils.create_widgets(input_description_widgets)
	self._gamepad_tooltip_widgets, self._gamepad_tooltip_widgets_by_name = UIUtils.create_widgets(gamepad_tooltip_widgets)
	self._arrow_widgets, self._arrow_widgets_by_name = UIUtils.create_widgets(arrow_widgets)
	self._continue_button_widget = UIWidget.init(continue_button)

	UIRenderer.clear_scenegraph_queue(self.loot_ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
	self._widgets_by_name.item_cap_warning_text.content.visible = false

	self:_setup_reward_option_widgets()
end

HeroViewStateLoot._setup_reward_option_widgets = function (self)
	-- function 16
	local num = num_loot_options * 3
	local tbl = {}

	for i = 1, num do
		local str = "loot_option_" .. i
		local str_2 = "loot_background_" .. i
		local tbl_2 = {
			widget = self._option_widgets_by_name[str]
		}
		local var_16_5

		if not USE_DELAYED_SPAWN then
			var_16_5 = self._preview_loot_widgets_by_name[str]

			if not var_16_5 then
				-- Nothing
			end
		end

		var_16_5 = nil

		::label_16_0::

		tbl_2.preview_widget = var_16_5
		tbl_2.background_widget = self._option_background_widgets_by_name[str_2]
		tbl[i] = tbl_2
	end

	self._reward_options = tbl
end

HeroViewStateLoot._setup_camera = function (self)
	-- function 17
	local var_17_0
	local level_name = viewport_widget.style.viewport.level_name
	local unit_indices = LevelResource.unit_indices(level_name, "units/hub_elements/cutscene_camera/cutscene_camera")

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(level_name, v)
		local get = DynamicData.get(unit_data, "name")

		if not (not get and get ~= "end_screen_camera") then
			local unit_position = LevelResource.unit_position(level_name, v)
			local unit_rotation = LevelResource.unit_rotation(level_name, v)
			local from_quaternion_position = Matrix4x4.from_quaternion_position(unit_rotation, unit_position)

			var_17_0 = Matrix4x4Box(from_quaternion_position)
		end
	end

	self._camera_pose = var_17_0

	self:_position_camera()
end

HeroViewStateLoot.set_camera_position = function (self, arg_18_1)
	-- function 18
	local get_viewport_world, var_18_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_18_1)

	return ScriptCamera.set_local_position(camera, arg_18_1)
end

HeroViewStateLoot.set_camera_rotation = function (self, arg_19_1)
	-- function 19
	local get_viewport_world, var_19_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_19_1)

	return ScriptCamera.set_local_rotation(camera, arg_19_1)
end

HeroViewStateLoot.get_camera_position = function (self)
	-- function 20
	local get_viewport_world, var_20_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_20_1)

	return ScriptCamera.position(camera)
end

HeroViewStateLoot.get_camera_rotation = function (self)
	-- function 21
	local get_viewport_world, var_21_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_21_1)

	return ScriptCamera.rotation(camera)
end

HeroViewStateLoot.get_viewport_world = function (self)
	-- function 22
	local var_22_0 = self.viewport_widget.element.pass_data[1]
	local viewport = var_22_0.viewport

	return var_22_0.world, viewport
end

HeroViewStateLoot._position_camera = function (self, arg_23_1)
	-- function 23
	local get_viewport_world, var_23_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_23_1)
	local flag = arg_23_1 or self._camera_pose:unbox()

	if not flag then
		local num = 65

		Camera.set_vertical_fov(camera, math.pi * num / 180)
		ScriptCamera.set_local_pose(camera, flag)
		ScriptCamera.force_update(get_viewport_world, camera)
	end
end

HeroViewStateLoot.on_exit = function (self, arg_24_1)
	-- function 24
	print("[HeroViewState] Exit Substate HeroViewStateLoot")

	if not self.menu_input_description then
		self.menu_input_description:destroy()

		self.menu_input_description = nil
	end

	self:_destroy_chest_unit()
	self:_unload_loaded_packages()

	local loot_ui_renderer = self.loot_ui_renderer

	if not self.viewport_widget then
		UIWidget.destroy(loot_ui_renderer, self.viewport_widget)

		self.viewport_widget = nil
	end

	local _reward_options = self._reward_options

	if not _reward_options then
		for i, v in ipairs(_reward_options) do
			local widget = v.widget
			local item_previewer = v.item_previewer

			if not item_previewer then
				item_previewer:destroy()

				v.item_previewer = nil
			end

			local world_previewer = v.world_previewer

			if not world_previewer then
				world_previewer:prepare_exit()
				world_previewer:on_exit()
				world_previewer:destroy()

				v.world_previewer = nil
			end
		end
	end

	local _preview_loot_widgets = self._preview_loot_widgets

	for i_2, v_2 in ipairs(_preview_loot_widgets) do
		UIWidget.destroy(loot_ui_renderer, v_2)
	end

	self._item_grid:destroy()

	self._item_grid = nil
	self.ui_animator = nil

	self:play_sound("play_gui_chestroom_stop")

	if not self.loot_ui_renderer then
		UIRenderer.destroy(self.loot_ui_renderer, self.loot_ui_world)
		self.world_manager:destroy_world(self.loot_ui_world)

		self.loot_ui_world = nil
		self.loot_ui_renderer = nil
	end

	self:enable_player_world()
end

HeroViewStateLoot._update_transition_timer = function (self, arg_25_1)
	-- function 25
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_25_1, 0)
	end
end

HeroViewStateLoot.update = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not self.waiting_for_post_update_enter then
		return
	end

	if not flag then
		self:create_ui_elements()
	end

	self:_update_animations(arg_26_1)
	self:_update_active_viewports()
	self:_update_enter_animation_time(arg_26_1, arg_26_2)
	self:_update_chest_zoom_in_time(arg_26_1, arg_26_2)
	self:_update_chest_zoom_out_time(arg_26_1, arg_26_2)
	self:_update_camera_look_up_time(arg_26_1, arg_26_2)
	self:_update_chest_open_wait_time(arg_26_1, arg_26_2)
	self:_update_camera_look_down_time(arg_26_1, arg_26_2)
	self:_update_continue_button_animation_time(arg_26_1, arg_26_2)
	self:_handle_gamepad_activity()
	self:draw(arg_26_1)
	self:_update_transition_timer(arg_26_1)

	local _wanted_state = self:_wanted_state()

	if not self._transition_timer then
		local _active_reward_options = self._active_reward_options

		if not _active_reward_options then
			for i, v in ipairs(_active_reward_options) do
				local content = v.widget.content
				local item_previewer = v.item_previewer

				if not item_previewer then
					item_previewer:update(arg_26_1, arg_26_2)
				end

				local world_previewer = v.world_previewer

				if not world_previewer then
					world_previewer:update(arg_26_1, arg_26_2)

					if not content.is_loading and not world_previewer:character_visible() then
						content.is_loading = false
					end
				end
			end
		end

		return _wanted_state or self._new_state
	end
end

HeroViewStateLoot.post_update = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not self.waiting_for_post_update_enter then
		self:post_update_on_enter()
	end

	self.ui_animator:update(arg_27_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator
	local _open_loot_chest_id = self._open_loot_chest_id

	if not _open_loot_chest_id then
		local get_interface = Managers.backend:get_interface("loot")

		if not get_interface:is_loot_generated(_open_loot_chest_id) then
			local get_loot = get_interface:get_loot(_open_loot_chest_id)

			self:loot_chest_opened(get_loot)

			self._open_loot_chest_id = nil
		end
	end

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	if not (self.parent:transitioning() or self._transition_timer) then
		local _item_grid = self._item_grid

		if not _item_grid then
			_item_grid:update(arg_27_1, arg_27_2)
		end

		local _active_camera_shakes = self._active_camera_shakes

		if not _active_camera_shakes then
			for k_2, v_2 in pairs(_active_camera_shakes) do
				self:_apply_shake_event(k_2, arg_27_2)
			end
		end

		self:_update_camera_shake_chest_spawn_time(arg_27_1, arg_27_2)
		self:_handle_input(arg_27_1, arg_27_2)
		self:_handle_gamepad_input(arg_27_1, arg_27_2)
		self:_update_page_info()

		local _active_reward_options = self._active_reward_options

		if not _active_reward_options then
			for i, v_3 in ipairs(_active_reward_options) do
				local item_previewer = v_3.item_previewer

				if not item_previewer then
					item_previewer:post_update(arg_27_1, arg_27_2)
				end

				local world_previewer = v_3.world_previewer

				if not world_previewer then
					world_previewer:post_update(arg_27_1, arg_27_2)
				end
			end
		end
	end
end

HeroViewStateLoot._update_animations = function (self, arg_28_1)
	-- function 28
	if not self._chest_presentation_active then
		local is_device_active = Managers.input:is_device_active("mouse")

		self:_animate_reward_options_entry(arg_28_1)

		for i, v in ipairs(self._active_reward_options) do
			local widget = v.widget
			local content = widget.content
			local button_hotspot = content.button_hotspot

			if not button_hotspot.disable_button then
				local rarity = content.rarity
				local num = 0
				local glow_alpha_progress = content.glow_alpha_progress

				glow_alpha_progress = glow_alpha_progress or 0

				local num_2 = arg_28_1 * 3

				if not button_hotspot.on_hover_enter then
					local str

					if not rarity then
						str = "play_gui_chest_reward_hover_start_" .. tostring(rarity)

						if not str then
							-- Nothing
						end
					end

					str = "play_gui_chest_reward_start"

					::label_28_0::

					self:play_sound(str)
				elseif not button_hotspot.on_hover_exit then
					local str_2

					if not rarity then
						str_2 = "play_gui_chest_reward_hover_stop_" .. tostring(rarity)

						if not str_2 then
							-- Nothing
						end
					end

					str_2 = "play_gui_chest_reward_stop"

					::label_28_1::

					self:play_sound(str_2)
				end

				local flag = not not is_device_active or self._console_selection_index == i

				if button_hotspot.is_hover or flag or not self._auto_open_rewards_on_complete then
					glow_alpha_progress = math.min(glow_alpha_progress + num_2, 1)
					num = math.easeOutCubic(glow_alpha_progress)
				else
					glow_alpha_progress = math.max(glow_alpha_progress - num_2, 0)
					num = math.easeInCubic(glow_alpha_progress)
				end

				content.glow_alpha_progress = glow_alpha_progress

				local style = widget.style

				style.lock_glow.color[1] = style.lock_glow.default_color[1] * num
				style.lock_glow_1.color[1] = style.lock_glow_1.default_color[1] * num
				style.lock_glow_2.color[1] = style.lock_glow_2.default_color[1] * num
				style.lock_bottom_glow.color[1] = style.lock_bottom_glow.default_color[1] * num
				style.lock_bottom_glow_2.color[1] = style.lock_bottom_glow_2.default_color[1] * num
			end
		end
	end

	local _widgets_by_name = self._widgets_by_name
	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_arrow_button(page_button_next, arg_28_1)
	UIWidgetUtils.animate_arrow_button(page_button_previous, arg_28_1)

	for k = 1, #self._chest_indicators do
		local var_28_15 = self._chest_indicators[k]

		UIWidgetUtils.animate_arrow_button(var_28_15, arg_28_1)
	end

	local _ui_animations = self._ui_animations

	for k_2, v_2 in pairs(_ui_animations) do
		UIAnimation.update(v_2, arg_28_1)

		if not UIAnimation.completed(v_2) then
			_ui_animations[k_2] = nil
		end
	end
end

HeroViewStateLoot.draw = function (self, arg_29_1)
	-- function 29
	local loot_ui_renderer = self.loot_ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self.render_settings
	local get_service = input_manager:get_service("hero_view")
	local is_device_active = input_manager:is_device_active("gamepad")

	render_settings.alpha_multiplier = 1

	UIRenderer.begin_pass(loot_ui_renderer, ui_scenegraph, get_service, arg_29_1, nil, render_settings)

	if not self._chest_presentation_active then
		for i, v in ipairs(self._option_background_widgets) do
			UIRenderer.draw_widget(loot_ui_renderer, v)
		end
	end

	local _grid_alpha_multiplier = self._grid_alpha_multiplier

	_grid_alpha_multiplier = _grid_alpha_multiplier or 1
	render_settings.alpha_multiplier = _grid_alpha_multiplier

	for i_2, v_2 in ipairs(self._widgets) do
		UIRenderer.draw_widget(loot_ui_renderer, v_2)
	end

	if not self._portrait_widget then
		UIRenderer.draw_widget(loot_ui_renderer, self._portrait_widget)
	end

	render_settings.alpha_multiplier = 1

	if not self.viewport_widget then
		UIRenderer.draw_widget(loot_ui_renderer, self.viewport_widget)
		UIRenderer.draw_widget(loot_ui_renderer, self.background_fade_widget)
	end

	if not self._draw_input_desc_widgets and not is_device_active then
		for k, v_3 in pairs(self._input_desc_widgets) do
			UIRenderer.draw_widget(loot_ui_renderer, v_3)
		end
	end

	local _present_reward_options = self._present_reward_options

	if not is_device_active and _present_reward_options or not get_service:get("special_1_hold") then
		local chest_tooltip = self._gamepad_tooltip_widgets_by_name.chest_tooltip

		UIRenderer.draw_widget(loot_ui_renderer, chest_tooltip)
	end

	UIRenderer.end_pass(loot_ui_renderer)

	local num = -200
	local num_2 = 1920
	local _active_reward_options = self._active_reward_options

	if not _active_reward_options then
		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_29_1, nil, render_settings)

		for i_3, v_4 in ipairs(_active_reward_options) do
			local preview_widget = v_4.preview_widget
			local widget = v_4.widget

			if not _present_reward_options then
				local scenegraph_id = widget.scenegraph_id
				local num_3 = -ui_scenegraph.loot_options_root.local_position[1]
				local num_4 = ui_scenegraph[scenegraph_id].local_position[1] + num_2 / 2 + num

				if not (not (num_3 < num_4 + ui_scenegraph[scenegraph_id].size[1]) or not (num_4 < num_3 + num_2)) then
					UIRenderer.draw_widget(ui_top_renderer, widget)

					local frame_widget = v_4.frame_widget

					if not frame_widget then
						UIRenderer.draw_widget(ui_top_renderer, frame_widget)
					end

					if not preview_widget then
						if not v_4.opened then
							self:_activate_widget_viewport(preview_widget, true)
							UIRenderer.draw_widget(ui_top_renderer, preview_widget)
						else
							self:_activate_widget_viewport(preview_widget, false)
						end
					end
				elseif not preview_widget then
					self:_activate_widget_viewport(preview_widget, false)
				end
			end
		end

		if not _present_reward_options then
			if not is_device_active and not get_service:get("special_1_hold") then
				local num_5 = self._num_chests * 3

				for i8 = 1, num_5 do
					local var_29_20 = self._gamepad_tooltip_widgets_by_name["item_tooltip_" .. i8]
					local scenegraph_id_2 = var_29_20.scenegraph_id
					local num_6 = 0
					local var_29_23 = ui_scenegraph[scenegraph_id_2].world_position[1]

					if not (not (num_6 < var_29_23 + ui_scenegraph[scenegraph_id_2].size[1]) or not (var_29_23 < num_6 + num_2)) then
						UIRenderer.draw_widget(ui_top_renderer, var_29_20)
					end
				end
			end

			if not self._rewards_presented then
				local _continue_button_alpha_multiplier = self._continue_button_alpha_multiplier

				_continue_button_alpha_multiplier = _continue_button_alpha_multiplier or 1
				render_settings.alpha_multiplier = _continue_button_alpha_multiplier

				UIRenderer.draw_widget(ui_top_renderer, self._continue_button_widget)

				for i_4, v_5 in ipairs(self._chest_indicators) do
					UIRenderer.draw_widget(ui_top_renderer, v_5)
				end

				if #self._chest_indicators > 1 then
					for i_5, v_6 in ipairs(self._arrow_widgets) do
						UIRenderer.draw_widget(ui_top_renderer, v_6)
					end
				end
			end
		end

		UIRenderer.end_pass(ui_top_renderer)
	end

	if not is_device_active then
		self.menu_input_description:draw(loot_ui_renderer, arg_29_1)
	end
end

HeroViewStateLoot._activate_widget_viewport = function (arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	if not arg_30_1 then
		return
	end

	local content = arg_30_1.content

	if content.activated ~= arg_30_2 then
		local var_30_1 = arg_30_1.element.pass_data[1]
		local world = var_30_1.world
		local viewport = var_30_1.viewport

		if not arg_30_2 then
			ScriptWorld.activate_viewport(world, viewport)
		else
			ScriptWorld.deactivate_viewport(world, viewport)
		end

		content.activated = arg_30_2
	end
end

HeroViewStateLoot._set_debug_buttons_disable_state = function (self, arg_31_1)
	-- function 31
	local _debug_widgets = self._debug_widgets

	for i, v in ipairs(_debug_widgets) do
		local content = v.content
		local hotspot = content.hotspot

		hotspot = hotspot or content.button_hotspot
		hotspot.disable_button = arg_31_1
	end
end

HeroViewStateLoot._is_button_pressed = function (arg_32_0, arg_32_1)
	-- function 32
	local content = arg_32_1.content
	local hotspot = content.hotspot

	hotspot = hotspot or content.button_hotspot

	if not hotspot.on_release then
		hotspot.on_release = false

		return true
	end
end

HeroViewStateLoot._is_button_hovered = function (arg_33_0, arg_33_1)
	-- function 33
	local content = arg_33_1.content
	local hotspot = content.hotspot

	hotspot = hotspot or content.button_hotspot

	if not hotspot.on_hover_enter then
		return true
	end
end

HeroViewStateLoot._is_option_tab_selected = function (self)
	-- function 34
	local content = self._widgets_by_name.inventory_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)

		if not content["hotspot" .. str].on_pressed then
			return i
		end
	end
end

HeroViewStateLoot._select_option_tab_by_index = function (self, arg_35_1)
	-- function 35
	local content = self._widgets_by_name.inventory_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)

		content["hotspot" .. str].is_selected = i == arg_35_1
	end
end

HeroViewStateLoot._has_grid_item = function (self, arg_36_1)
	-- function 36
	return self._item_grid:has_item(arg_36_1)
end

local tbl_4 = {}

HeroViewStateLoot._select_grid_item = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	local _widgets_by_name = self._widgets_by_name
	local _item_grid = self._item_grid
	local get_interface = Managers.backend:get_interface("items")

	arg_37_1 = not arg_37_1 and get_interface:get_item_from_id(arg_37_1.backend_id)

	_item_grid:set_item_selected(arg_37_1)

	local num = 0
	local num_2 = 2

	if not arg_37_1 then
		self._gamepad_tooltip_widgets_by_name.chest_tooltip.content.item = arg_37_1

		local var_37_5
		local var_37_6
		local var_37_7
		local data = arg_37_1.data

		tbl_4[1] = data.chest_category

		local chest_categories = data.chest_categories

		chest_categories = chest_categories or tbl_4

		local chest_tier = data.chest_tier
		local chests_by_category = LootChestData.chests_by_category

		num = arg_37_1.RemainingUses
		num_2 = math.clamp(num, 2, num_loot_options)

		for i = 1, #chest_categories do
			local var_37_12 = chest_categories[i]
			local var_37_13 = chests_by_category[var_37_12]

			if not var_37_13 then
				local chest_unit_names = var_37_13.chest_unit_names

				for i_2, v in ipairs(chest_unit_names) do
					if i_2 == chest_tier then
						var_37_5 = v
						var_37_6 = "play_gui_chest_appear_" .. var_37_12 .. "_" .. tostring(i_2)

						break
					end
				end

				local individual_chest_package_names = var_37_13.individual_chest_package_names

				if not individual_chest_package_names then
					for i_3, v_2 in ipairs(individual_chest_package_names) do
						if i_3 == chest_tier then
							var_37_7 = v_2

							break
						end
					end
				end
			end

			if not var_37_5 then
				break
			end
		end

		if not var_37_5 then
			self._unit_to_spawn = var_37_5
			self._sound_event = var_37_6
			self._package_to_spawn = var_37_7

			self:_load_package(var_37_7)
		end

		local get_ui_information_from_item, var_37_17, var_37_18 = UIUtils.get_ui_information_from_item(arg_37_1)
		local item_type = data.item_type
		local info_text_box_text_id = data.info_text_box_text_id

		info_text_box_text_id = info_text_box_text_id or "loot_opening_screen_desc"
		_widgets_by_name.info_text_box.content.text = info_text_box_text_id
		_widgets_by_name.chest_title.content.text = Localize(var_37_17)
		_widgets_by_name.chest_sub_title.content.text = Localize(item_type)

		self:set_chest_title_alpha_progress(1)
		self.menu_input_description:set_input_description(generic_input_actions.chest_selected)

		local str = Localize("interaction_action_open") .. " " .. num_2

		_widgets_by_name.open_multiple_button.content.title_text = str
		generic_input_actions.chest_selected.actions[3].description_text = str
	else
		self:_destroy_chest_unit()
		self:_unload_loaded_packages()
		self:set_chest_title_alpha_progress(0)
		self.menu_input_description:set_input_description(generic_input_actions.chest_not_selected)

		self._num_chests = 1
	end

	self._selected_item = arg_37_1

	local free_inventory_slots = get_interface:free_inventory_slots()
	local items_per_chest = UISettings.items_per_chest
	local flag = items_per_chest <= free_inventory_slots
	local flag_2 = free_inventory_slots >= items_per_chest * num_2

	self._open_chests_enabled = not (num >= 1) or flag
	self._open_multiple_chests_enabled = not (num >= 2) or flag_2
	_widgets_by_name.item_cap_warning_text.content.visible = not flag and not flag_2
	_widgets_by_name.open_button.content.button_hotspot.disable_button = not self._open_chests_enabled
	_widgets_by_name.open_multiple_button.content.button_hotspot.disable_button = not self._open_multiple_chests_enabled

	if not self._open_chests_enabled then
		self.menu_input_description:set_input_description(generic_input_actions.chest_not_selected)
	elseif not self._open_multiple_chests_enabled then
		self.menu_input_description:set_input_description(generic_input_actions.chest_selected_single_use)
	else
		self.menu_input_description:set_input_description(generic_input_actions.chest_selected)
	end
end

HeroViewStateLoot._play_sound = function (self, arg_38_1)
	-- function 38
	WwiseWorld.trigger_event(self.wwise_world, arg_38_1)
end

HeroViewStateLoot._handle_gamepad_input = function (self, arg_39_1, arg_39_2)
	-- function 39
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local get_service = self.input_manager:get_service("hero_view")
	local _item_grid = self._item_grid

	if not (self._chest_presentation_active or self._opening_chest) then
		_item_grid:handle_gamepad_selection(get_service)

		local selected_item = _item_grid:selected_item()

		if selected_item ~= self._selected_item then
			local flag = true

			self:_select_grid_item(selected_item, arg_39_2, flag)
		end

		local _current_page = self._current_page
		local _total_pages = self._total_pages

		if not _current_page and not _total_pages then
			if not (_current_page < _total_pages) or get_service:get(str) or not get_service:get(str_3) then
				_item_grid:set_item_page(_current_page + 1)
				self:_play_sound("play_gui_equipment_inventory_next_click")

				local get_item_in_slot = _item_grid:get_item_in_slot(1, 1)

				_item_grid:set_item_selected(get_item_in_slot)
			elseif not (_current_page > 1) or get_service:get(str_2) or not get_service:get(str_4) then
				_item_grid:set_item_page(_current_page - 1)
				self:_play_sound("play_gui_equipment_inventory_next_click")

				local get_item_in_slot_2 = _item_grid:get_item_in_slot(1, 1)

				_item_grid:set_item_selected(get_item_in_slot_2)
			end
		end
	elseif not self._reward_option_animation_complete then
		if get_service:get(str) or not get_service:get(str_3) then
			local num = 1

			self:_change_chest_page(num)
		elseif get_service:get(str_2) or not get_service:get(str_4) then
			local num_2 = -1

			self:_change_chest_page(num_2)
		elseif not (self._rewards_presented or get_service:get("special_1_hold") or self._ui_animations.page_cycle) then
			if not get_service:get("move_left") then
				local flag_2 = false

				self._console_selection_index = self:_find_console_selection_index(flag_2)
			elseif not get_service:get("move_right") then
				local flag_3 = true

				self._console_selection_index = self:_find_console_selection_index(flag_3)
			end

			if not get_service:get("confirm_press", true) then
				self:open_reward_option(self._console_selection_index)
			end
		end
	end
end

HeroViewStateLoot._find_console_selection_index = function (self, arg_40_1)
	-- function 40
	local _active_reward_options = self._active_reward_options
	local count = #_active_reward_options

	if not arg_40_1 then
		local _console_selection_index = self._console_selection_index
		local var_40_3 = _console_selection_index

		for i = 1, count - 1 do
			var_40_3 = 1 + var_40_3 % count

			if not _active_reward_options[var_40_3].widget.content.button_hotspot.disable_button then
				_console_selection_index = var_40_3

				break
			end
		end

		return _console_selection_index
	else
		local _console_selection_index_2 = self._console_selection_index
		local var_40_5 = _console_selection_index_2

		for j = 1, count - 1 do
			var_40_5 = var_40_5 - 1

			if var_40_5 < 1 then
				var_40_5 = count
			end

			if not _active_reward_options[var_40_5].widget.content.button_hotspot.disable_button then
				_console_selection_index_2 = var_40_5

				break
			end
		end

		return _console_selection_index_2
	end
end

HeroViewStateLoot._handle_page_selection = function (self, arg_41_1)
	-- function 41
	local arrow_right = self._arrow_widgets_by_name.arrow_right
	local arrow_left = self._arrow_widgets_by_name.arrow_left
	local flag

	flag = not UIUtils.is_button_hover(arrow_right) and 1 and -1

	local arrow_lit = arrow_right.style.arrow_lit
	local progress = arrow_lit.progress

	progress = progress or 0

	local clamp = math.clamp(progress + arg_41_1 * 6 * flag, 0, 1)

	arrow_lit.color[1] = clamp * 255
	arrow_lit.progress = clamp

	local flag_2

	flag_2 = not UIUtils.is_button_hover(arrow_left) and 1 and -1

	local arrow_lit_2 = arrow_left.style.arrow_lit
	local progress_2 = arrow_lit_2.progress

	progress_2 = progress_2 or 0

	local clamp_2 = math.clamp(progress_2 + arg_41_1 * 6 * flag_2, 0, 1)

	arrow_lit_2.color[1] = clamp_2 * 255
	arrow_lit_2.progress = clamp_2

	if not self:_is_button_pressed(arrow_right) then
		local num = 1

		self:_change_chest_page(num)
	elseif not self:_is_button_pressed(arrow_left) then
		local num_2 = -1

		self:_change_chest_page(num_2)
	else
		local var_41_12

		for i = 1, #self._chest_indicators do
			local var_41_13 = self._chest_indicators[i]

			if not self:_is_button_pressed(var_41_13) then
				var_41_12 = i

				break
			end
		end

		if not var_41_12 then
			local num_3 = var_41_12 - self._current_page_index

			self:_change_chest_page(num_3)
		end
	end
end

HeroViewStateLoot._change_chest_page = function (self, arg_42_1)
	-- function 42
	local _current_page_index = self._current_page_index
	local count = #self._active_reward_options
	local ceil = math.ceil(count / 3)
	local local_position = self.ui_scenegraph.loot_options_root.local_position

	self._current_page_index = math.clamp(self._current_page_index + arg_42_1, 1, ceil)

	if self._current_page_index ~= _current_page_index then
		self._ui_animations.page_cycle = UIAnimation.init(UIAnimation.function_by_time, local_position, 1, local_position[1], (self._current_page_index - 1) * -1920, 0.5, math.easeOutCubic)

		for i, v in ipairs(self._chest_indicators) do
			local content = v.content

			content.selected = content.index == self._current_page_index
		end

		self._viewports_dirty = true
	end
end

HeroViewStateLoot._set_last_pressed = function (self, arg_43_1)
	-- function 43
	self._last_open_pressed = arg_43_1

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.open_button.content.side_detail.skip_side_detail = arg_43_1 ~= "single"
	_widgets_by_name.open_multiple_button.content.side_detail.skip_side_detail = arg_43_1 ~= "multiple"
end

HeroViewStateLoot._handle_input = function (self, arg_44_1, arg_44_2)
	-- function 44
	local _widgets_by_name = self._widgets_by_name
	local get_service = self.input_manager:get_service("hero_view")
	local is_device_active = Managers.input:is_device_active("gamepad")
	local parent = self.parent
	local _item_grid = self._item_grid
	local _num_chests = self._num_chests
	local open_button = _widgets_by_name.open_button
	local close_button = _widgets_by_name.close_button
	local open_multiple_button = _widgets_by_name.open_multiple_button
	local arrow_right = self._arrow_widgets_by_name.arrow_right
	local arrow_left = self._arrow_widgets_by_name.arrow_left
	local _continue_button_widget = self._continue_button_widget

	UIWidgetUtils.animate_default_button(open_button, arg_44_1)
	UIWidgetUtils.animate_default_button(close_button, arg_44_1)
	UIWidgetUtils.animate_default_button(open_multiple_button, arg_44_1)
	UIWidgetUtils.animate_default_button(_continue_button_widget, arg_44_1)

	local flag = not is_device_active and get_service:get("back_menu")

	if not self._wait_for_backend_reload then
		self._wait_for_backend_reload = math.max(self._wait_for_backend_reload - arg_44_1, 0)

		if self._wait_for_backend_reload == 0 then
			self._wait_for_backend_reload = nil

			self:_set_debug_buttons_disable_state(false)
			self:populate_items()
		end

		return
	end

	if not self._chest_presentation_active then
		for i, v in ipairs(self._active_reward_options) do
			local widget = v.widget

			if not self:_is_button_pressed(widget) then
				self:open_reward_option(i)

				break
			end
		end

		self:_handle_page_selection(arg_44_1)

		if self._rewards_presented or get_service:get("skip_pressed", true) or not self._auto_open_rewards_on_complete then
			if not self._reward_option_animation_complete then
				self._auto_open_rewards_on_complete = true
			else
				self._auto_open_rewards_on_complete = false

				local _active_reward_options = self._active_reward_options
				local count = #_active_reward_options

				for k = 1, count do
					if not _active_reward_options[k].widget.content.button_hotspot.disable_button then
						self:open_reward_option(k)
					end
				end
			end
		end

		local _rewards_presented = self._rewards_presented

		_rewards_presented = not _rewards_presented and not (self._continue_button_progress >= 1) or get_service:get("skip_pressed", true)

		if not self._rewards_presented and self:_is_button_pressed(_continue_button_widget) and get_service:get("toggle_menu") and _rewards_presented and not flag then
			self:play_sound("play_gui_chest_opening_return")

			self._enter_animation_duration = nil
			self._chest_zoom_in_duration = nil
			self._chest_open_wait_duration = nil
			self._continue_button_animation_duration = nil
			self._rewards_presented = false
			self._opening_chest = nil
			self._chest_presentation_active = nil
			self._present_reward_options = nil
			self._auto_open_rewards_on_complete = false
			self._chest_zoom_out_duration = 0
			self._camera_look_down_duration = num_6 * (1 - self._camera_look_up_progress)
			self._camera_look_up_progress = 0
			self._current_page_index = 1
			self._reward_option_animation_complete = nil
			self._camera_look_up_duration = nil

			self:set_continue_button_animation_progress(0)
			self:_reset_gamepad_tooltips()

			self._console_selection_index = 1
			self.ui_scenegraph.loot_options_root.local_position[1] = 0
			self.ui_scenegraph.chest_indicator_root.local_position[2] = 200
			self.ui_scenegraph.arrow_root.local_position[2] = 200

			local _animations = self._animations
			local _active_reward_options_2 = self._active_reward_options

			if not _active_reward_options_2 then
				for i_2, v_2 in ipairs(_active_reward_options_2) do
					local widget_2 = v_2.widget
					local preview_widget = v_2.preview_widget
					local background_widget = v_2.background_widget
					local animation_name = v_2.animation_name
					local var_44_23 = _animations[animation_name]

					if not var_44_23 then
						self.ui_animator:stop_animation(var_44_23)

						_animations[animation_name] = nil
					end

					local item_previewer = v_2.item_previewer

					if not item_previewer then
						item_previewer:destroy()

						v_2.item_previewer = nil
					end

					local world_previewer = v_2.world_previewer

					if not world_previewer then
						world_previewer:prepare_exit()
						world_previewer:on_exit()
						world_previewer:destroy()

						v_2.world_previewer = nil
					end

					table.clear(v_2)

					v_2.widget = widget_2
					v_2.preview_widget = preview_widget
					v_2.background_widget = background_widget
				end
			end

			self:populate_items()
		end
	elseif not self._opening_chest then
		local page_button_next = _widgets_by_name.page_button_next
		local page_button_previous = _widgets_by_name.page_button_previous

		if self:_is_button_hovered(page_button_next) or not self:_is_button_hovered(page_button_previous) then
			self:play_sound("play_gui_inventory_next_hover")
		end

		if not self:_is_button_pressed(page_button_next) then
			local num = self._current_page + 1

			_item_grid:set_item_page(num)
			self:play_sound("play_gui_equipment_inventory_next_click")
		elseif not self:_is_button_pressed(page_button_previous) then
			local num_2 = self._current_page - 1

			_item_grid:set_item_page(num_2)
			self:play_sound("play_gui_equipment_inventory_next_click")
		end

		if not _item_grid:is_item_hovered() then
			self:play_sound("play_gui_inventory_item_hover")
		end

		local flag_2 = true
		local is_item_pressed = _item_grid:is_item_pressed(flag_2)

		if not (not is_item_pressed and not self._selected_item and self._selected_item.backend_id == is_item_pressed.backend_id) then
			local flag_3 = true

			self:_select_grid_item(is_item_pressed, arg_44_2, flag_3)
		end

		local _open_chests_enabled = self._open_chests_enabled

		if not _open_chests_enabled then
			_open_chests_enabled = get_service:get("confirm_press")
			_open_chests_enabled = _open_chests_enabled or get_service:get("skip_pressed", true)
		end

		local _open_multiple_chests_enabled = self._open_multiple_chests_enabled

		_open_multiple_chests_enabled = not _open_multiple_chests_enabled and get_service:get("refresh")

		if not ((Managers.input:is_device_active("gamepad") or not IS_WINDOWS or not _open_chests_enabled) and self._last_open_pressed ~= "multiple") then
			_open_chests_enabled = false
			_open_multiple_chests_enabled = true
		end

		local var_44_35

		if self:_is_button_pressed(open_button) or not _open_chests_enabled or not self._selected_item then
			var_44_35 = 1

			self:_set_last_pressed("single")
		elseif self:_is_button_pressed(close_button) or get_service:get("toggle_menu") or not flag then
			parent:close_menu()
			self:play_sound("Play_hud_select")
		elseif self:_is_button_pressed(open_multiple_button) or not _open_multiple_chests_enabled or not self._selected_item then
			local _selected_item = self._selected_item

			var_44_35 = math.min(num_loot_options, _selected_item.RemainingUses)

			self:_set_last_pressed("multiple")
		end

		if not var_44_35 then
			self._num_chests = var_44_35

			if Managers.backend:get_interface("items"):free_inventory_slots() >= var_44_35 * UISettings.items_per_chest then
				self._auto_open_rewards_on_complete = var_44_35 > 1

				self:_open_chest(self._selected_item, var_44_35)
			end
		end
	end
end

HeroViewStateLoot._update_page_info = function (self)
	-- function 45
	local get_page_info, var_45_1 = self._item_grid:get_page_info()

	if not (get_page_info ~= self._current_page or var_45_1 == self._total_pages) then
		self._total_pages = var_45_1
		self._current_page = get_page_info
		get_page_info = get_page_info or 1
		var_45_1 = var_45_1 or 1

		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.page_text_left.content.text = tostring(get_page_info)
		_widgets_by_name.page_text_right.content.text = tostring(var_45_1)
		_widgets_by_name.page_button_next.content.hotspot.disable_button = get_page_info == var_45_1
		_widgets_by_name.page_button_previous.content.hotspot.disable_button = get_page_info == 1
	end
end

local tbl_5 = {
	common = "play_hud_rewards_tier1",
	exotic = "play_hud_rewards_tier3",
	rare = "play_hud_rewards_tier2",
	unique = "play_hud_rewards_tier4"
}

HeroViewStateLoot.open_reward_option = function (self, arg_46_1)
	-- function 46
	local _active_reward_options = self._active_reward_options
	local var_46_1 = _active_reward_options[arg_46_1]
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings,
		reward_option = var_46_1
	}
	local widget = var_46_1.widget
	local content = widget.content

	content.button_hotspot.disable_button = true
	var_46_1.animation_name = "open_loot_widget_" .. arg_46_1

	self:_start_animation(var_46_1.animation_name, "open_loot_widget", widget, tbl)

	self._num_rewards_opened = self._num_rewards_opened + 1

	if self._num_rewards_opened == #_active_reward_options then
		self._rewards_presented = true
		self._continue_button_animation_duration = 0

		if math.ceil(#_active_reward_options / 3) > 1 then
			self.menu_input_description:set_input_description(generic_input_actions.loot_presented_pages)
		else
			self.menu_input_description:set_input_description(generic_input_actions.loot_presented)
		end

		local local_position = self.ui_scenegraph.chest_indicator_root.local_position

		self._ui_animations.chest_indicator = UIAnimation.init(UIAnimation.function_by_time, local_position, 2, local_position[2], -35, num_4, math.easeOutCubic)

		local local_position_2 = self.ui_scenegraph.arrow_root.local_position

		self._ui_animations.arrow_root = UIAnimation.init(UIAnimation.function_by_time, local_position_2, 2, local_position_2[2], -40, num_4, math.easeOutCubic)
	end

	local rarity = content.rarity
	local var_46_8 = tbl_5[rarity]

	if not var_46_8 then
		self:play_sound(var_46_8)
	end

	self:_setup_gamepad_tooltip(arg_46_1, var_46_1)

	local flag = true

	self._console_selection_index = self:_find_console_selection_index(flag)
end

HeroViewStateLoot._setup_gamepad_tooltip = function (self, arg_47_1, arg_47_2)
	-- function 47
	local var_47_0 = self._gamepad_tooltip_widgets_by_name["item_tooltip_" .. arg_47_1]

	if not var_47_0 then
		local content = arg_47_2.widget.content

		var_47_0.content.item = content.item
	end
end

HeroViewStateLoot._reset_gamepad_tooltips = function (self)
	-- function 48
	for k, v in pairs(self._gamepad_tooltip_widgets) do
		v.content.item = nil
	end
end

HeroViewStateLoot._setup_rewards = function (self, arg_49_1)
	-- function 49
	local get_interface = Managers.backend:get_interface("items")
	local _reward_options = self._reward_options

	table.clear(self._chest_indicators)

	local tbl = {}

	if self._num_chests > 1 then
		local RaritySettings = RaritySettings

		local function fn(arg_50_0, arg_50_1)
			-- function 50
			local get_item_rarity = get_interface:get_item_rarity(arg_50_0)
			local order = RaritySettings[get_item_rarity].order
			local get_item_rarity_2 = get_interface:get_item_rarity(arg_50_1)

			return order > RaritySettings[get_item_rarity_2].order
		end

		table.sort(arg_49_1, fn)

		local ceil = math.ceil(#arg_49_1 / 3)

		self.ui_scenegraph.chest_indicator_root.local_position[1] = -(ceil - 1) * 60 * 0.5
		self._arrow_widgets_by_name.arrow_left.offset[1] = -(ceil + 1) * 60 * 0.5
		self._arrow_widgets_by_name.arrow_right.offset[1] = (ceil + 1) * 60 * 0.5

		for i = 1, ceil do
			local num = (i - 1) * 3 + 1
			local var_49_7 = arg_49_1[num]
			local get_item_rarity = get_interface:get_item_rarity(var_49_7)
			local var_49_9 = arg_49_1[num + 1]
			local flag = not var_49_9 and get_interface:get_item_rarity(var_49_9)
			local var_49_11 = arg_49_1[num + 2]
			local flag_2 = not var_49_11 and get_interface:get_item_rarity(var_49_11)
			local var_49_13 = create_chest_indicator_func(i, self._current_page_index, get_item_rarity, flag, flag_2)

			self._chest_indicators[#self._chest_indicators + 1] = UIWidget.init(var_49_13)
		end
	end

	local count = #arg_49_1
	local var_49_15 = loot_option_positions_by_amount[math.min(count, 3)]
	local ui_scenegraph = self.ui_scenegraph
	local num_2 = 1920

	for i_2, v in ipairs(_reward_options) do
		local widget = v.widget
		local content = widget.content
		local style = widget.style

		table.clear(content.item_hotspot)
		table.clear(content.item_hotspot_2)

		local var_49_21 = arg_49_1[i_2]

		if not var_49_21 then
			local num_3 = 1 + (i_2 - 1) % 3
			local ceil_2 = math.ceil(i_2 / 3)
			local var_49_24 = var_49_15[num_3]
			local local_position = ui_scenegraph[widget.scenegraph_id].local_position

			local_position[1] = var_49_24[1] + (ceil_2 - 1) * num_2
			local_position[2] = var_49_24[2]

			local get_item_from_id = get_interface:get_item_from_id(var_49_21)
			local data = get_item_from_id.data
			local key = data.key
			local get_item_rarity_2 = get_interface:get_item_rarity(var_49_21)
			local item_type = data.item_type
			local slot_type = data.slot_type
			local get_ui_information_from_item, var_49_33, var_49_34 = UIUtils.get_ui_information_from_item(get_item_from_id)

			v.background_widget.style.background.color = Colors.get_color_table_with_alpha(get_item_rarity_2, 255)

			local var_49_35 = UISettings.item_rarity_textures[get_item_rarity_2]
			local var_49_36 = tbl_3[get_item_rarity_2]

			v.reward_backend_id = var_49_21
			v.reward_key = key
			v.opened = false
			content.is_loading = false
			content.rarity = get_item_rarity_2
			content.item = get_item_from_id
			content.item_icon = get_ui_information_from_item
			content.item_icon_rarity = var_49_35
			content.item_name = Localize(var_49_33)
			content.item_type = Localize(item_type)
			content.presentation_complete = nil
			content.draw_frame = nil
			content.button_hotspot.disable_button = false
			content.glow_alpha_progress = 0
			content.item_hotspot_2.allow_multi_hover = true
			style.item_name.text_color[1] = 0
			style.item_name_shadow.text_color[1] = 0
			style.item_type.text_color[1] = 0
			style.item_type_shadow.text_color[1] = 0
			style.item_icon.offset[2] = -40
			style.item_tooltip.offset[2] = -40
			style.item_type.text_color = Colors.get_color_table_with_alpha(get_item_rarity_2, 0)

			local back = var_49_36.back
			local front = var_49_36.front
			local center = var_49_36.center

			self:_apply_color_to_glow_style(style.lock_bottom_glow, back)
			self:_apply_color_to_glow_style(style.lock_bottom_glow_2, front)
			self:_apply_color_to_glow_style(style.lock_glow, back)
			self:_apply_color_to_glow_style(style.lock_glow_1, center)
			self:_apply_color_to_glow_style(style.lock_glow_2, front)
			self:_apply_color_to_glow_style(style.final_glow, back)
			self:_apply_color_to_glow_style(style.final_glow_1, center)
			self:_apply_color_to_glow_style(style.final_glow_2, front)

			content.lock_glow = "loot_presentation_circle_glow_" .. get_item_rarity_2
			content.final_glow = "loot_presentation_circle_glow_" .. get_item_rarity_2 .. "_large"
			content.image = nil
			content.amount_text = nil

			if not (slot_type == "melee" or slot_type == "ranged" or slot_type ~= "weapon_skin") then
				local var_49_40
				local var_49_41

				if not USE_DELAYED_SPAWN then
					local var_49_42 = v.preview_widget.element.pass_data[1]

					var_49_40 = var_49_42.viewport
					var_49_41 = var_49_42.world
				end

				local tbl_2 = {
					0,
					0,
					-0.2
				}

				v.item_previewer = LootItemUnitPreviewer:new(get_item_from_id, tbl_2, var_49_41, var_49_40, i_2, nil, nil, nil, USE_DELAYED_SPAWN)
			elseif slot_type == "hat" then
				local var_49_44

				if not USE_DELAYED_SPAWN then
					var_49_44 = MenuWorldPreviewer:new(self.ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroViewStateLootindex" .. i_2, USE_DELAYED_SPAWN)
				else
					var_49_44 = MenuWorldPreviewer:new(self.ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroViewStateLootindex" .. i_2)

					var_49_44:on_enter(v.preview_widget)
				end

				var_49_44:force_hide_character()

				local _get_hero_wield_info_by_item, var_49_46, var_49_47, var_49_48 = self:_get_hero_wield_info_by_item(get_item_from_id)
				local base_skin = CareerSettings[var_49_47].base_skin
				local key_2 = data.key

				self:_spawn_hero_with_hat(var_49_44, _get_hero_wield_info_by_item, var_49_48, base_skin, key_2)

				v.world_previewer = var_49_44
				content.is_loading = true
			elseif slot_type == "skin" then
				local var_49_51

				if not USE_DELAYED_SPAWN then
					var_49_51 = MenuWorldPreviewer:new(self.ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroViewStateLootindex" .. i_2, USE_DELAYED_SPAWN)
				else
					var_49_51 = MenuWorldPreviewer:new(self.ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroViewStateLootindex" .. i_2)

					var_49_51:on_enter(v.preview_widget)
				end

				var_49_51:force_hide_character()

				local name = data.name
				local _get_hero_wield_info_by_item_2, var_49_54, var_49_55, var_49_56 = self:_get_hero_wield_info_by_item(get_item_from_id)

				self:_spawn_hero_skin(var_49_51, _get_hero_wield_info_by_item_2, var_49_56, name)

				v.world_previewer = var_49_51
				content.is_loading = true
			elseif slot_type == "weapon_pose" then
				local var_49_57

				if not USE_DELAYED_SPAWN then
					var_49_57 = MenuWorldPreviewer:new(self.ingame_ui_context, UISettings.hero_skin_camera_position_by_character, "HeroViewStateLootindex" .. i_2, USE_DELAYED_SPAWN)
				else
					var_49_57 = MenuWorldPreviewer:new(self.ingame_ui_context, UISettings.hero_skin_camera_position_by_character, "HeroViewStateLootindex" .. i_2)

					var_49_57:on_enter(v.preview_widget)
				end

				var_49_57:force_hide_character()

				local _get_hero_wield_info_by_item_3, var_49_59, var_49_60, var_49_61 = self:_get_hero_wield_info_by_item(get_item_from_id)

				self:_spawn_hero_with_weapon_pose(var_49_57, _get_hero_wield_info_by_item_3, var_49_61, get_item_from_id)

				v.world_previewer = var_49_57
				content.is_loading = true
			elseif not (slot_type == "crafting_material" or slot_type == "deed" or slot_type == "trinket" or slot_type == "necklace" or slot_type ~= "ring") then
				local var_49_62

				if slot_type == "trinket" then
					var_49_62 = "loot_image_trinket"
				elseif slot_type == "necklace" then
					var_49_62 = "loot_image_jewellery"
				elseif slot_type == "ring" then
					var_49_62 = "loot_image_charm"
				elseif slot_type == "deed" then
					var_49_62 = "loot_image_deed"
				end

				if slot_type == "crafting_material" then
					local get_item_amount = get_interface:get_item_amount(var_49_21)

					content.amount_text = "x" .. tostring(get_item_amount)
				end

				local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(var_49_62)

				content.image = var_49_62
				style.image.texture_size[1] = get_atlas_settings_by_texture_name.size[1]
				style.image.texture_size[2] = get_atlas_settings_by_texture_name.size[2]
			elseif slot_type == "frame" then
				local portrait_image = SPProfiles[self.profile_index].careers[self.career_index].portrait_image
				local temporary_template = ItemMasterList[key].temporary_template
				local str = "loot_option_" .. i_2 .. "_center"
				local num_4 = 1.5

				v.frame_widget = self:_create_player_portrait(str, temporary_template, portrait_image, "", num_4)
			end

			tbl[#tbl + 1] = v
		end
	end

	self._active_reward_options = tbl
	self._present_reward_options = true

	self:_set_background_blur_progress(1)

	local flag_3 = true

	self:_update_active_viewports(flag_3)
end

HeroViewStateLoot._update_active_viewports = function (self, arg_51_1)
	-- function 51
	if not USE_DELAYED_SPAWN then
		return
	end

	if not (self._viewports_dirty or arg_51_1) then
		return
	end

	for i = 1, num_loot_options * 3 do
		local var_51_0 = self._active_reward_options[i]
		local flag = not var_51_0 and var_51_0.item_previewer
		local flag_2 = not var_51_0 and var_51_0.world_previewer

		if not flag then
			flag:activate(false)
		elseif not flag_2 then
			flag_2:activate(false)
		end

		if not var_51_0 then
			var_51_0.preview_widget = nil
		end
	end

	local _preview_loot_widgets = self._preview_loot_widgets

	for j = 1, #_preview_loot_widgets do
		local var_51_4 = _preview_loot_widgets[j]

		self:_activate_widget_viewport(var_51_4, false)
	end

	local _current_page_index = self._current_page_index
	local num = 1 + (_current_page_index - 1) * 3

	for k = 1, 3 do
		local num_2 = k + (_current_page_index - 1) * 3
		local var_51_8 = self._active_reward_options[num_2]
		local flag_3 = not var_51_8 and var_51_8.item_previewer
		local flag_4 = not var_51_8 and var_51_8.world_previewer
		local var_51_11 = _preview_loot_widgets[k]

		var_51_11.scenegraph_id = "loot_option_" .. num_2

		local var_51_12 = var_51_11.element.pass_data[1]
		local viewport = var_51_12.viewport
		local world = var_51_12.world

		if not flag_3 then
			flag_3:activate(true, world, viewport, not arg_51_1)

			var_51_8.preview_widget = var_51_11
		elseif not flag_4 then
			flag_4:activate(true, var_51_11)

			var_51_8.preview_widget = var_51_11
		end
	end

	self._viewports_dirty = false
end

HeroViewStateLoot._get_hero_wield_info_by_item = function (arg_52_0, arg_52_1)
	-- function 52
	local var_52_0 = arg_52_1.data.can_wield[1]

	for i, v in ipairs(SPProfiles) do
		local careers = v.careers

		for i_2, v_2 in ipairs(careers) do
			if v_2.name == var_52_0 then
				local display_name = v.display_name
				local var_52_3 = FindProfileIndex(display_name)
				local sort_order = v_2.sort_order

				return display_name, var_52_3, var_52_0, sort_order
			end
		end
	end
end

HeroViewStateLoot._apply_color_to_glow_style = function (arg_53_0, arg_53_1, arg_53_2)
	-- function 53
	local color = arg_53_1.color
	local default_color = arg_53_1.default_color

	color[1] = 0
	color[2] = arg_53_2[2]
	color[3] = arg_53_2[3]
	color[4] = arg_53_2[4]
	default_color[1] = arg_53_2[1]
	default_color[2] = arg_53_2[2]
	default_color[3] = arg_53_2[3]
	default_color[4] = arg_53_2[4]
end

HeroViewStateLoot._spawn_hero_skin = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	-- function 54
	local var_54_0 = callback(arg_54_0, "cb_hero_unit_spawned_skin_preview", arg_54_1, arg_54_2, arg_54_3)

	arg_54_1:request_spawn_hero_unit(arg_54_2, arg_54_3, false, var_54_0, 1, nil, arg_54_4)
end

HeroViewStateLoot._spawn_hero_with_hat = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5)
	-- function 55
	local var_55_0 = callback(arg_55_0, "cb_hero_unit_spawned_hat_preview", arg_55_1, arg_55_2, arg_55_3, arg_55_5)

	arg_55_1:request_spawn_hero_unit(arg_55_2, arg_55_3, false, var_55_0, 1, nil, arg_55_4)
end

HeroViewStateLoot._spawn_hero_with_weapon_pose = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	-- function 56
	local var_56_0 = callback(arg_56_0, "cb_hero_unit_spawned_weapon_pose_preview", arg_56_1, arg_56_2, arg_56_3, arg_56_4)

	arg_56_1:request_spawn_hero_unit(arg_56_2, arg_56_3, false, var_56_0, 1)
end

HeroViewStateLoot.cb_hero_unit_spawned_weapon_pose_preview = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	-- function 57
	local var_57_0 = FindProfileIndex(arg_57_2)
	local var_57_1 = SPProfiles[var_57_0].careers[arg_57_3]
	local preview_idle_animation = var_57_1.preview_idle_animation
	local preview_wield_slot = var_57_1.preview_wield_slot
	local preview_items = var_57_1.preview_items
	local data = arg_57_4.data
	local anim_event = data.data.anim_event
	local parent = data.parent
	local var_57_8 = ItemMasterList[parent]
	local name = var_57_8.name
	local slot_type = var_57_8.slot_type

	if not preview_items then
		arg_57_1:set_wielded_weapon_slot(slot_type)

		for i, v in ipairs(preview_items) do
			local item_name = v.item_name
			local slot_type_2 = ItemMasterList[item_name].slot_type

			if slot_type_2 ~= slot_type then
				local var_57_13 = InventorySettings.slot_names_by_type[slot_type_2][1]
				local var_57_14 = InventorySettings.slots_by_name[var_57_13]

				arg_57_1:equip_item(item_name, var_57_14)
			end
		end

		local var_57_15 = InventorySettings.slot_names_by_type[slot_type][1]
		local var_57_16 = InventorySettings.slots_by_name[var_57_15]

		arg_57_1:equip_item(name, var_57_16)

		local flag = true

		arg_57_1:set_pose_animation(anim_event, flag)
	end
end

HeroViewStateLoot.cb_hero_unit_spawned_skin_preview = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	local var_58_0 = FindProfileIndex(arg_58_2)
	local var_58_1 = SPProfiles[var_58_0].careers[arg_58_3]
	local preview_idle_animation = var_58_1.preview_idle_animation
	local preview_wield_slot = var_58_1.preview_wield_slot
	local preview_items = var_58_1.preview_items

	if not preview_items then
		for i, v in ipairs(preview_items) do
			local item_name = v.item_name
			local slot_type = ItemMasterList[item_name].slot_type
			local var_58_7 = InventorySettings.slot_names_by_type[slot_type][1]
			local var_58_8 = InventorySettings.slots_by_name[var_58_7]

			arg_58_1:equip_item(item_name, var_58_8)
		end

		if not preview_wield_slot then
			arg_58_1:wield_weapon_slot(preview_wield_slot)
		end
	end

	if not preview_idle_animation then
		arg_58_1:play_character_animation(preview_idle_animation)
	end
end

HeroViewStateLoot.cb_hero_unit_spawned_hat_preview = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	-- function 59
	local var_59_0 = FindProfileIndex(arg_59_2)
	local var_59_1 = SPProfiles[var_59_0].careers[arg_59_3]
	local preview_idle_animation = var_59_1.preview_idle_animation
	local preview_wield_slot = var_59_1.preview_wield_slot
	local preview_items = var_59_1.preview_items
	local slot_hat = InventorySettings.slots_by_name.slot_hat

	arg_59_1:equip_item(arg_59_4, slot_hat)

	if not preview_items then
		for i, v in ipairs(preview_items) do
			local item_name = v.item_name
			local slot_type = ItemMasterList[item_name].slot_type

			if not (slot_type == "melee" or slot_type == "ranged" or slot_type == "hat") then
				local var_59_8 = InventorySettings.slot_names_by_type[slot_type][1]
				local var_59_9 = InventorySettings.slots_by_name[var_59_8]

				arg_59_1:equip_item(item_name, var_59_9)
			end
		end
	end
end

HeroViewStateLoot._create_player_portrait = function (self, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5)
	-- function 60
	local create_portrait_frame = UIWidgets.create_portrait_frame(arg_60_1, arg_60_2, arg_60_4, arg_60_5 or 1, nil, arg_60_3)

	return (UIWidget.init(create_portrait_frame, self.ui_top_renderer))
end

HeroViewStateLoot._set_background_blur_progress = function (self, arg_61_1)
	-- function 61
	local get_viewport_world, var_61_1 = self:get_viewport_world()
	local get_data = World.get_data(get_viewport_world, "shading_environment")

	if not get_data then
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_enabled", arg_61_1 * 1)
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_amount", arg_61_1 * 0.75)
		ShadingEnvironment.apply(get_data)
	end
end

HeroViewStateLoot.play_sound = function (self, arg_62_1)
	-- function 62
	self.parent:play_sound(arg_62_1)
end

HeroViewStateLoot._start_transition_animation = function (self, arg_63_1, arg_63_2)
	-- function 63
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_63_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_63_1] = start_animation
end

HeroViewStateLoot._start_animation = function (self, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
	-- function 64
	local flag = arg_64_4 or {
		wwise_world = self.wwise_world
	}
	local start_animation = self.ui_animator:start_animation(arg_64_2, arg_64_3, scenegraph_definition, flag)

	self._animations[arg_64_1] = start_animation

	return start_animation
end

HeroViewStateLoot._open_chest = function (self, arg_65_1, arg_65_2)
	-- function 65
	self:_reset_camera()
	self:set_reward_options_height_progress(0)
	self:set_continue_button_animation_progress(0)

	local get_interface = Managers.backend:get_interface("loot")
	local hero_name = self.hero_name
	local backend_id = arg_65_1.backend_id
	local game_mode_key = Managers.state.game_mode:game_mode_key()

	self._open_loot_chest_id = get_interface:open_loot_chest(hero_name, backend_id, game_mode_key, arg_65_2)

	self.menu_input_description:set_input_description(nil)

	self._draw_input_desc_widgets = false
	self._chest_zoom_in_duration = 0
	self._chest_zoom_out_duration = nil

	if not self._chest_unit then
		local str = "loot_chest_open"

		Unit.flow_event(self._chest_unit, str)
	end

	local data = arg_65_1.data

	tbl_4[1] = data.chest_category

	local chest_categories = data.chest_categories

	chest_categories = chest_categories or tbl_4

	local chest_tier = data.chest_tier
	local chests_by_category = LootChestData.chests_by_category

	self._opening_chest = true
	self._rewards_presented = false

	local var_65_9

	for i = 1, #chest_categories do
		local var_65_10 = chest_categories[i]
		local var_65_11 = chests_by_category[var_65_10]

		if not var_65_11 then
			local flag = false
			local chest_unit_names = var_65_11.chest_unit_names

			for i_2, v in ipairs(chest_unit_names) do
				if i_2 == chest_tier then
					local str_2 = "play_gui_chest_open_" .. var_65_10 .. "_" .. tostring(i_2)

					self:play_sound(str_2)

					flag = true
				end
			end

			if not flag then
				break
			end
		end
	end
end

HeroViewStateLoot.loot_chest_opened = function (self, arg_66_1)
	-- function 66
	local _selected_item = self._selected_item
	local flag

	flag = not arg_66_1 and #arg_66_1

	if not BackendUtils.has_loot_chest() then
		local world = self.world_manager:world("level_world")

		LevelHelper:flow_event(world, "local_player_opened_all_loot_chests")
	end

	self:_start_reward_presentation(arg_66_1)
end

HeroViewStateLoot._start_reward_presentation = function (self, arg_67_1)
	-- function 67
	local ui_scenegraph = self.ui_scenegraph

	for i = 1, num_loot_options do
		ui_scenegraph["loot_option_" .. (i - 1) * 3 + 1].size[2] = 0
		ui_scenegraph["loot_option_" .. (i - 1) * 3 + 2].size[2] = 0
		ui_scenegraph["loot_option_" .. (i - 1) * 3 + 3].size[2] = 0
	end

	self._chest_loot = arg_67_1

	self:_setup_rewards(self._chest_loot)

	self._chest_presentation_active = true
	self._num_rewards_opened = 0
	self._last_selected_item = self._selected_item
	self._selected_item = nil
	self._continue_button_animation_duration = 0

	self:set_continue_button_animation_progress(0)
	self:set_reward_options_height_progress(0)
end

HeroViewStateLoot._animate_reward_options_entry = function (self, arg_68_1)
	-- function 68
	local _reward_options_entry_progress = self._reward_options_entry_progress

	if not _reward_options_entry_progress then
		return
	end

	local min = math.min(_reward_options_entry_progress + arg_68_1, 1)

	self:set_reward_options_height_progress(min)

	if min == 1 then
		local _active_reward_options = self._active_reward_options
		local ceil = math.ceil(#_active_reward_options / 3)
		local var_68_4
		local flag

		flag = not (ceil > 1) or not "chest_opened_pages" or "chest_opened"
		self._reward_options_entry_progress = nil

		self.menu_input_description:set_input_description(generic_input_actions[flag])

		self._draw_input_desc_widgets = true
		self._reward_option_animation_complete = true
	else
		self._reward_options_entry_progress = min
	end
end

HeroViewStateLoot.set_reward_options_height_progress = function (self, arg_69_1)
	-- function 69
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local min = math.min(arg_69_1 * 1.1, 1)
	local min_2 = math.min(arg_69_1 * 1.3, 1)
	local var_69_4 = arg_69_1
	local ui_scenegraph = self.ui_scenegraph

	for i = 1, num_loot_options do
		ui_scenegraph["loot_option_" .. (i - 1) * 3 + 1].local_position[2] = -res_h * (1 - math.catmullrom(math.easeOutCubic(min), 0, 0, 1, -1.8))
		ui_scenegraph["loot_option_" .. (i - 1) * 3 + 2].local_position[2] = -res_h * (1 - math.catmullrom(math.easeOutCubic(min_2), 0, 0, 1, -1.8))
		ui_scenegraph["loot_option_" .. (i - 1) * 3 + 3].local_position[2] = -res_h * (1 - math.catmullrom(math.easeOutCubic(var_69_4), 0, 0, 1, -1.8))
	end
end

HeroViewStateLoot._unload_loaded_packages = function (self)
	-- function 70
	if not self._loaded_package then
		self:_unload_package(self._loaded_package)

		self._loaded_package = nil
	end

	if not self._package_loading then
		self:_unload_package(self._package_loading)

		self._package_loading = nil
	end
end

HeroViewStateLoot._destroy_chest_unit = function (self)
	-- function 71
	if not self._chest_unit then
		local get_viewport_world = self:get_viewport_world()

		World.destroy_unit(get_viewport_world, self._chest_unit)

		self._chest_unit = nil
	end
end

HeroViewStateLoot._load_package = function (self, arg_72_1)
	-- function 72
	self:_destroy_chest_unit()
	self:_unload_loaded_packages()

	self._package_loading = arg_72_1

	local package = Managers.package
	local var_72_1 = callback(self, "_on_load_complete", arg_72_1)
	local str = "HeroViewStateLoot"

	package:load(arg_72_1, str, var_72_1, true)
end

HeroViewStateLoot._on_load_complete = function (self, arg_73_1)
	-- function 73
	self:play_sound(self._sound_event)
	self:_spawn_chest_unit(self._unit_to_spawn, nil, nil)

	self._loaded_package = arg_73_1
	self._package_loading = nil
end

HeroViewStateLoot._unload_package = function (arg_74_0, arg_74_1)
	-- function 74
	local str = "HeroViewStateLoot"

	Managers.package:unload(arg_74_1, str)
end

HeroViewStateLoot._spawn_chest_unit = function (self, arg_75_1, arg_75_2, arg_75_3)
	-- function 75
	local get_viewport_world = self:get_viewport_world()

	if not self._chest_unit then
		World.destroy_unit(get_viewport_world, self._chest_unit)
	end

	local spawn_unit = World.spawn_unit(get_viewport_world, arg_75_1, Vector3(0, 0, 10))
	local get_world_link_unit = self:get_world_link_unit()

	World.link_unit(get_viewport_world, spawn_unit, 0, get_world_link_unit, 0)

	if not arg_75_2 then
		local str = "loot_chest_init"

		Unit.flow_event(spawn_unit, str)

		self._camera_shake_chest_spawn_duration = nil
	else
		local str_2 = "loot_chest_enter"

		Unit.flow_event(spawn_unit, str_2)

		self._camera_shake_chest_spawn_duration = 0
	end

	self._chest_unit = spawn_unit
end

HeroViewStateLoot.get_world_link_unit = function (self)
	-- function 76
	local level_name = viewport_widget.style.viewport.level_name
	local world = self.viewport_widget.element.pass_data[1].world
	local level = ScriptWorld.level(world, level_name)

	if not level then
		local units = Level.units(level)

		for i, v in ipairs(units) do
			local get_data = Unit.get_data(v, "name")

			if not (not get_data and get_data ~= "loot_chest_spawn") then
				return v
			end
		end
	end
end

HeroViewStateLoot.set_camera_zoom = function (self, arg_77_1)
	-- function 77
	local unbox = self._camera_pose:unbox()
	local translation = Matrix4x4.translation(unbox)
	local rotation = Matrix4x4.rotation(unbox)
	local num = 0.5 * arg_77_1
	local num_2 = translation + Quaternion.forward(rotation) * num

	self:set_camera_position(num_2)
end

HeroViewStateLoot.set_grid_animation_progress = function (self, arg_78_1)
	-- function 78
	local ui_scenegraph = self.ui_scenegraph

	ui_scenegraph.info_root.local_position[1] = 400 * arg_78_1
	ui_scenegraph.item_grid_root.local_position[1] = -400 * arg_78_1
	ui_scenegraph.open_buttons_pivot.local_position[2] = 30 - 200 * arg_78_1
	ui_scenegraph.close_button.local_position[2] = 30 - 200 * arg_78_1
	self._grid_alpha_multiplier = 1 - arg_78_1
end

HeroViewStateLoot.set_continue_button_animation_progress = function (self, arg_79_1)
	-- function 79
	self.ui_scenegraph.continue_button.local_position[2] = -170 + 200 * arg_79_1
	self._continue_button_alpha_multiplier = arg_79_1
	self._continue_button_progress = arg_79_1
end

HeroViewStateLoot.set_chest_title_alpha_progress = function (self, arg_80_1)
	-- function 80
	local _widgets_by_name = self._widgets_by_name
	local num = 255 * arg_80_1

	_widgets_by_name.chest_title.style.text.text_color[1] = num
	_widgets_by_name.chest_title.style.text_shadow.text_color[1] = num
	_widgets_by_name.chest_sub_title.style.text.text_color[1] = num
	_widgets_by_name.chest_sub_title.style.text_shadow.text_color[1] = num
	self._chest_title_alpha_progress = arg_80_1
end

HeroViewStateLoot._update_enter_animation_time = function (self, arg_81_1, arg_81_2)
	-- function 81
	local _enter_animation_duration = self._enter_animation_duration

	if not _enter_animation_duration then
		return
	end

	local num = _enter_animation_duration + arg_81_1
	local min = math.min(num / num_4, 1)
	local easeOutCubic = math.easeOutCubic(min)

	self:set_grid_animation_progress(1 - easeOutCubic)

	if min == 1 then
		self._enter_animation_duration = nil
	else
		self._enter_animation_duration = num
	end
end

HeroViewStateLoot._update_continue_button_animation_time = function (self, arg_82_1, arg_82_2)
	-- function 82
	local _continue_button_animation_duration = self._continue_button_animation_duration

	if not _continue_button_animation_duration then
		return
	end

	local num = _continue_button_animation_duration + arg_82_1
	local min = math.min(num / num_4, 1)
	local easeOutCubic = math.easeOutCubic(min)

	self:set_continue_button_animation_progress(easeOutCubic)

	if min == 1 then
		self._continue_button_animation_duration = nil
	else
		self._continue_button_animation_duration = num
	end
end

HeroViewStateLoot._update_camera_look_up_time = function (self, arg_83_1, arg_83_2)
	-- function 83
	local _camera_look_up_duration = self._camera_look_up_duration

	if not _camera_look_up_duration then
		return
	end

	local min = math.min(_camera_look_up_duration / num_5, 1)
	local easeCubic = math.easeCubic(min)
	local num = _camera_look_up_duration + arg_83_1
	local min_2 = math.min(num / num_5, 1)
	local easeCubic_2 = math.easeCubic(min_2)
	local num_2 = 60
	local degrees_to_radians = math.degrees_to_radians(num_2 * easeCubic)
	local degrees_to_radians_2 = math.degrees_to_radians(num_2 * easeCubic_2)

	self._camera_look_up_progress = min_2

	local var_83_9 = Quaternion(Vector3.right(), degrees_to_radians_2 - degrees_to_radians)
	local get_camera_rotation = self:get_camera_rotation()
	local multiply = Quaternion.multiply(get_camera_rotation, var_83_9)

	self:set_camera_rotation(multiply)

	self.background_fade_widget.style.rect.color[1] = easeCubic_2 * 200

	if min_2 == 1 then
		if not self._chest_unit then
			Unit.set_unit_visibility(self._chest_unit, false)
		end

		self._camera_look_up_duration = nil
	else
		self._camera_look_up_duration = num
	end
end

HeroViewStateLoot._update_camera_look_down_time = function (self, arg_84_1, arg_84_2)
	-- function 84
	local _camera_look_down_duration = self._camera_look_down_duration

	if not _camera_look_down_duration then
		return
	end

	local min = math.min(_camera_look_down_duration / num_6, 1)
	local easeOutCubic = math.easeOutCubic(min)
	local num = _camera_look_down_duration + arg_84_1
	local min_2 = math.min(num / num_6, 1)
	local easeOutCubic_2 = math.easeOutCubic(min_2)
	local num_2 = -60
	local degrees_to_radians = math.degrees_to_radians(num_2 * easeOutCubic)
	local degrees_to_radians_2 = math.degrees_to_radians(num_2 * easeOutCubic_2)
	local var_84_9 = Quaternion(Vector3.right(), degrees_to_radians_2 - degrees_to_radians)
	local get_camera_rotation = self:get_camera_rotation()
	local multiply = Quaternion.multiply(get_camera_rotation, var_84_9)

	self:set_camera_rotation(multiply)

	self.background_fade_widget.style.rect.color[1] = (1 - easeOutCubic_2) * 200

	if min_2 == 1 then
		self._camera_look_down_duration = nil
		self._camera_look_up_progress = 0
	else
		self._camera_look_down_duration = num
	end
end

HeroViewStateLoot._reset_camera = function (self)
	-- function 85
	self._camera_look_down_duration = nil
	self._camera_look_up_progress = 0
	self.background_fade_widget.style.rect.color[1] = 0

	self:_position_camera()
end

HeroViewStateLoot._update_chest_open_wait_time = function (self, arg_86_1, arg_86_2)
	-- function 86
	local _chest_open_wait_duration = self._chest_open_wait_duration

	if not _chest_open_wait_duration then
		return
	end

	local num = _chest_open_wait_duration + arg_86_1
	local min = math.min(num / num_2, 1)
	local easeOutCubic = math.easeOutCubic(min)

	if min == 1 then
		self._camera_look_up_duration = 0
		self._reward_options_entry_progress = 0

		self:play_sound("play_gui_chest_reward_enter")

		self._chest_open_wait_duration = nil
	else
		self._chest_open_wait_duration = num
	end
end

HeroViewStateLoot._update_chest_zoom_in_time = function (self, arg_87_1, arg_87_2)
	-- function 87
	local _chest_zoom_in_duration = self._chest_zoom_in_duration

	if not _chest_zoom_in_duration then
		return
	end

	local num = _chest_zoom_in_duration + arg_87_1
	local min = math.min(num / num_3, 1)
	local easeOutCubic = math.easeOutCubic(min)

	self:set_camera_zoom(easeOutCubic)
	self:set_grid_animation_progress(easeOutCubic)
	self:set_chest_title_alpha_progress(1 - easeOutCubic)

	if min == 1 then
		self._chest_zoom_in_duration = nil
		self._chest_open_wait_duration = 0
	else
		self._chest_zoom_in_duration = num
	end
end

HeroViewStateLoot._update_chest_zoom_out_time = function (self, arg_88_1, arg_88_2)
	-- function 88
	local _chest_zoom_out_duration = self._chest_zoom_out_duration

	if not _chest_zoom_out_duration then
		return
	end

	local num = _chest_zoom_out_duration + arg_88_1
	local num_2 = 1 - math.min(num / num_4, 1)
	local easeInCubic = math.easeInCubic(num_2)

	self:set_camera_zoom(easeInCubic)
	self:set_grid_animation_progress(easeInCubic)

	if num_2 == 0 then
		self._chest_zoom_out_duration = nil
	else
		self._chest_zoom_out_duration = num
	end
end

HeroViewStateLoot._update_camera_shake_chest_spawn_time = function (self, arg_89_1, arg_89_2)
	-- function 89
	local _camera_shake_chest_spawn_duration = self._camera_shake_chest_spawn_duration

	if not _camera_shake_chest_spawn_duration then
		return
	end

	local num_2 = _camera_shake_chest_spawn_duration + arg_89_1

	if math.min(num_2 / num, 1) == 1 then
		self._camera_shake_chest_spawn_duration = nil

		self:add_camera_shake(tbl, arg_89_2, 1)
	else
		self._camera_shake_chest_spawn_duration = num_2
	end
end

HeroViewStateLoot.add_camera_shake = function (self, arg_90_1, arg_90_2, arg_90_3)
	-- function 90
	local tbl = {}
	local get_camera_rotation = self:get_camera_rotation()
	local flag = arg_90_1 or tbl_2
	local duration = flag.duration
	local fade_in = flag.fade_in
	local fade_out = flag.fade_out
	local num = (duration or 0) + (fade_in or 0) + (fade_out or 0)

	tbl.shake_settings = flag
	tbl.start_time = arg_90_2
	tbl.end_time = not num and arg_90_2 + num
	tbl.fade_in_time = not fade_in and arg_90_2 + fade_in
	tbl.fade_out_time = not fade_out and tbl.end_time - fade_out

	local seed = flag.seed

	seed = seed or Math.random(1, 100)
	tbl.seed = seed
	tbl.scale = arg_90_3 or 1
	tbl.camera_rotation_boxed = QuaternionBox(get_camera_rotation)
	self._active_camera_shakes = {
		[tbl] = true
	}
end

HeroViewStateLoot._apply_shake_event = function (self, arg_91_1, arg_91_2)
	-- function 91
	local start_time = arg_91_1.start_time
	local end_time = arg_91_1.end_time
	local fade_in_time = arg_91_1.fade_in_time
	local fade_out_time = arg_91_1.fade_out_time

	if not (not fade_in_time and not (arg_91_2 <= fade_in_time)) then
		arg_91_1.fade_progress = math.clamp((arg_91_2 - start_time) / (fade_in_time - start_time), 0, 1)
	elseif not (not fade_out_time and not (fade_out_time <= arg_91_2)) then
		arg_91_1.fade_progress = math.clamp((end_time - arg_91_2) / (end_time - fade_out_time), 0, 1)
	end

	local num = self:_calculate_perlin_value(arg_91_2 - arg_91_1.start_time, arg_91_1) * arg_91_1.scale
	local num_2 = self:_calculate_perlin_value(arg_91_2 - arg_91_1.start_time + 10, arg_91_1) * arg_91_1.scale
	local unbox = arg_91_1.camera_rotation_boxed:unbox()
	local num_3 = math.pi / 180
	local var_91_8 = Quaternion(Vector3.up(), num_2 * num_3)
	local var_91_9 = Quaternion(Vector3.right(), num * num_3)
	local multiply = Quaternion.multiply(var_91_8, var_91_9)
	local multiply_2 = Quaternion.multiply(unbox, multiply)

	self:set_camera_rotation(multiply_2)

	if not (not arg_91_1.end_time and not (arg_91_2 >= arg_91_1.end_time)) then
		self._active_camera_shakes[arg_91_1] = nil
	end
end

HeroViewStateLoot._calculate_perlin_value = function (self, arg_92_1, arg_92_2)
	-- function 92
	local num = 0
	local shake_settings = arg_92_2.shake_settings
	local persistance = shake_settings.persistance
	local octaves = shake_settings.octaves

	for i = 0, octaves do
		local num_2 = 2^i
		local num_3 = persistance^i

		num = num + self:_interpolated_noise(arg_92_1 * num_2, arg_92_2) * num_3
	end

	local amplitude = shake_settings.amplitude

	amplitude = amplitude or 1

	local fade_progress = arg_92_2.fade_progress

	fade_progress = fade_progress or 1

	return num * amplitude * fade_progress
end

HeroViewStateLoot._interpolated_noise = function (self, arg_93_1, arg_93_2)
	-- function 93
	local floor = math.floor(arg_93_1)
	local num = arg_93_1 - floor
	local _smoothed_noise = self:_smoothed_noise(floor, arg_93_2)
	local _smoothed_noise_2 = self:_smoothed_noise(floor + 1, arg_93_2)

	return math.lerp(_smoothed_noise, _smoothed_noise_2, num)
end

HeroViewStateLoot._smoothed_noise = function (self, arg_94_1, arg_94_2)
	-- function 94
	return self:_noise(arg_94_1, arg_94_2) / 2 + self:_noise(arg_94_1 - 1, arg_94_2) / 4 + self:_noise(arg_94_1 + 1, arg_94_2) / 4
end

HeroViewStateLoot._noise = function (arg_95_0, arg_95_1, arg_95_2)
	-- function 95
	local next_random, var_95_1 = Math.next_random(arg_95_1 + arg_95_2.seed)
	local next_random_2, var_95_3 = Math.next_random(next_random)

	return var_95_3 * 2 - 1
end

HeroViewStateLoot._get_card_spawn_position = function (self)
	-- function 96
	local get_camera_position = self:get_camera_position()
	local get_camera_rotation = self:get_camera_rotation()
	local forward = Quaternion.forward(get_camera_rotation)
	local get_world_link_unit = self:get_world_link_unit()
	local world_position = Unit.world_position(get_world_link_unit, 0)

	world_position.x = get_camera_position.x
	world_position.z = world_position.z - 0.12
	world_position.y = world_position.y

	return world_position
end

HeroViewStateLoot._create_portrait_frame_widget = function (self, arg_97_1, arg_97_2, arg_97_3)
	-- function 97
	local create_portrait_frame = UIWidgets.create_portrait_frame("info_portrait_root", arg_97_1, arg_97_3, 1, nil, arg_97_2)
	local var_97_1 = UIWidget.init(create_portrait_frame, self.ui_top_renderer)

	var_97_1.content.frame_settings_name = arg_97_1

	return var_97_1
end

HeroViewStateLoot._setup_info_window = function (self)
	-- function 98
	local hero_name = self.hero_name
	local career_index = self.career_index
	local profile_index = self.profile_index
	local var_98_3 = SPProfiles[profile_index]
	local character_name = var_98_3.character_name
	local portrait_image = var_98_3.careers[career_index].portrait_image
	local player = self.player
	local player_unit = player.player_unit
	local get_player_level = ExperienceSettings.get_player_level(player)
	local var_98_9

	if not get_player_level then
		var_98_9 = tostring(get_player_level)

		if not var_98_9 then
			-- Nothing
		end
	end

	var_98_9 = "-"

	::label_98_0::

	local str = "default"

	self._portrait_widget = self:_create_portrait_frame_widget(str, portrait_image, var_98_9)
	self._widgets_by_name.info_text_title.content.text = Localize(character_name)
end

HeroViewStateLoot._handle_gamepad_activity = function (self)
	-- function 99
	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag = self.gamepad_active_last_frame == nil

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			self:_set_gamepad_input_buttons_visibility(true)
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		self:_set_gamepad_input_buttons_visibility(false)
	end
end
