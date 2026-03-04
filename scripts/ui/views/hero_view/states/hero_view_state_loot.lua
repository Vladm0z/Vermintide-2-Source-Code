-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_loot.lua

require("scripts/ui/views/hero_view/loot_item_unit_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_loot_definitions")
local var_0_1 = "trigger_cycle_next"
local var_0_2 = "trigger_cycle_previous"
local var_0_3 = "cycle_next"
local var_0_4 = "cycle_previous"
local var_0_5 = var_0_0.widgets
local var_0_6 = var_0_0.gamepad_tooltip_widgets
local var_0_7 = var_0_0.input_description_widgets
local var_0_8 = var_0_0.continue_button
local var_0_9 = var_0_0.option_widgets
local var_0_10 = var_0_0.debug_button_widgets
local var_0_11 = var_0_0.option_background_widgets
local var_0_12 = var_0_0.preview_widgets
local var_0_13 = var_0_0.viewport_widget
local var_0_14 = var_0_0.settings_by_screen
local var_0_15 = var_0_0.generic_input_actions
local var_0_16 = var_0_0.scenegraph_definition
local var_0_17 = var_0_0.animation_definitions
local var_0_18 = var_0_0.background_fade_definition
local var_0_19 = var_0_0.loot_option_positions_by_amount
local var_0_20 = var_0_0.num_loot_options
local var_0_21 = var_0_0.create_chest_indicator_func
local var_0_22 = var_0_0.arrow_widgets
local var_0_23 = var_0_0.USE_DELAYED_SPAWN
local var_0_24 = {
	persistance = 0.9,
	fade_out = 0.3,
	amplitude = 1,
	duration = 0.3,
	fade_in = 0.1,
	octaves = 5.5
}
local var_0_25 = {
	persistance = 1,
	fade_out = 0.5,
	amplitude = 0.9,
	seed = 0,
	duration = 0.5,
	fade_in = 0.1,
	octaves = 7
}
local var_0_26 = 0.7
local var_0_27 = 1.2
local var_0_28 = 0.8
local var_0_29 = 0.8
local var_0_30 = 0.9
local var_0_31 = 1
local var_0_32 = 1
local var_0_33 = 2
local var_0_34 = 1
local var_0_35 = {
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
local var_0_36 = false

HeroViewStateLoot = class(HeroViewStateLoot)
HeroViewStateLoot.NAME = "HeroViewStateLoot"

function HeroViewStateLoot.on_enter(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.parent:clear_wanted_state()
	print("[HeroViewState] Enter Substate HeroViewStateLoot")

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.settings_by_screen = arg_1_1.settings_by_screen

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ingame_ui_context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.ingame_ui = var_1_0.ingame_ui
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0.wwise_world = arg_1_1.wwise_world
	arg_1_0.platform = PLATFORM

	local var_1_1 = Managers.player
	local var_1_2 = var_1_1:local_player()

	arg_1_0._stats_id = var_1_2:stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.player = var_1_2
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.local_player_id = var_1_0.local_player_id
	arg_1_0.profile_synchronizer = var_1_0.profile_synchronizer

	local var_1_3 = arg_1_0.profile_synchronizer:profile_by_peer(arg_1_0.peer_id, arg_1_0.local_player_id)
	local var_1_4 = SPProfiles[var_1_3]
	local var_1_5 = var_1_4.display_name
	local var_1_6 = var_1_4.character_name

	arg_1_0.career_index = Managers.backend:get_interface("hero_attributes"):get(var_1_5, "career")
	arg_1_0.profile_index = var_1_3
	arg_1_0._loaded_package = nil
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._units = {}
	arg_1_0._chest_indicators = {}
	arg_1_0.waiting_for_post_update_enter = true
	arg_1_0._camera_look_up_progress = 0
	arg_1_0._continue_button_progress = 0
	arg_1_0._current_page_index = 1
	arg_1_0._viewports_dirty = false
	arg_1_0._num_chests = 1

	Managers.state.event:trigger("tutorial_trigger", "loot_menu_opened")
end

function HeroViewStateLoot.post_update_on_enter(arg_2_0)
	arg_2_0.waiting_for_post_update_enter = nil

	local var_2_0 = arg_2_0.ingame_ui_context

	arg_2_0.world_manager = var_2_0.world_manager

	local var_2_1 = arg_2_0.world_manager:create_world("loot_world", "environment/gui", nil, 980, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	World.set_data(var_2_1, "avoid_blend", true)
	ScriptWorld.deactivate(var_2_1)
	ScriptWorld.create_viewport(var_2_1, "loot_world_viewport", "overlay", 1)

	arg_2_0.loot_ui_renderer = arg_2_0.ingame_ui:create_ui_renderer(var_2_1)
	arg_2_0.loot_ui_world = var_2_1

	local var_2_2 = arg_2_0.input_manager:get_service("hero_view")
	local var_2_3 = UILayer.default + 30

	arg_2_0.menu_input_description = MenuInputDescriptionUI:new(var_2_0, arg_2_0.loot_ui_renderer, var_2_2, 6, var_2_3, var_0_15.default, true)

	arg_2_0.menu_input_description:set_input_description(var_0_15.chest_not_selected)
	arg_2_0:create_ui_elements()

	arg_2_0.viewport_widget = UIWidget.init(var_0_13)

	arg_2_0:_setup_camera()
	arg_2_0:set_chest_title_alpha_progress(0)

	arg_2_0._enter_animation_duration = 0

	arg_2_0:populate_items()
	arg_2_0:_setup_info_window()
	arg_2_0:play_sound("play_gui_chestroom_start")
	arg_2_0:disable_player_world()
	arg_2_0:_setup_input_buttons()

	arg_2_0._console_selection_index = 1
	arg_2_0._draw_input_desc_widgets = true
end

function HeroViewStateLoot._setup_input_buttons(arg_3_0)
	local var_3_0 = Managers.input:get_service("hero_view")
	local var_3_1 = UISettings.get_gamepad_input_texture_data(var_3_0, var_0_1, true)
	local var_3_2 = UISettings.get_gamepad_input_texture_data(var_3_0, var_0_2, true)
	local var_3_3 = arg_3_0._widgets_by_name
	local var_3_4 = var_3_3.input_icon_next
	local var_3_5 = var_3_3.input_icon_previous
	local var_3_6 = var_3_4.style.texture_id

	var_3_6.horizontal_alignment = "center"
	var_3_6.vertical_alignment = "center"
	var_3_6.texture_size = {
		var_3_1.size[1],
		var_3_1.size[2]
	}
	var_3_4.content.texture_id = var_3_1.texture

	local var_3_7 = var_3_5.style.texture_id

	var_3_7.horizontal_alignment = "center"
	var_3_7.vertical_alignment = "center"
	var_3_7.texture_size = {
		var_3_2.size[1],
		var_3_2.size[2]
	}
	var_3_5.content.texture_id = var_3_2.texture
end

function HeroViewStateLoot._set_gamepad_input_buttons_visibility(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._widgets_by_name
	local var_4_1 = var_4_0.input_icon_next
	local var_4_2 = var_4_0.input_icon_previous
	local var_4_3 = var_4_0.input_arrow_next
	local var_4_4 = var_4_0.input_arrow_previous

	var_4_1.content.visible = arg_4_1
	var_4_2.content.visible = arg_4_1
	var_4_3.content.visible = arg_4_1
	var_4_4.content.visible = arg_4_1
end

function HeroViewStateLoot.disable_player_world(arg_5_0)
	if not arg_5_0._player_world_disabled then
		arg_5_0._player_world_disabled = true

		local var_5_0 = "player_1"
		local var_5_1 = Managers.world:world("level_world")
		local var_5_2 = ScriptWorld.viewport(var_5_1, var_5_0)

		ScriptWorld.deactivate_viewport(var_5_1, var_5_2)
	end
end

function HeroViewStateLoot.enable_player_world(arg_6_0)
	if arg_6_0._player_world_disabled then
		arg_6_0._player_world_disabled = false

		local var_6_0 = "player_1"
		local var_6_1 = Managers.world:world("level_world")
		local var_6_2 = ScriptWorld.viewport(var_6_1, var_6_0)

		ScriptWorld.activate_viewport(var_6_1, var_6_2)
	end
end

function HeroViewStateLoot.populate_items(arg_7_0)
	local var_7_0 = arg_7_0._widgets_by_name
	local var_7_1 = arg_7_0.hero_name
	local var_7_2 = arg_7_0.career_index

	local function var_7_3(arg_8_0, arg_8_1)
		local var_8_0 = arg_8_0.data
		local var_8_1 = arg_8_1.data
		local var_8_2 = var_8_0.chest_sort_order
		local var_8_3 = var_8_1.chest_sort_order
		local var_8_4 = var_8_0.chest_tier
		local var_8_5 = var_8_1.chest_tier

		if var_8_2 == var_8_3 then
			if var_8_4 == var_8_5 then
				return arg_8_0.backend_id < arg_8_1.backend_id
			else
				return var_8_4 < var_8_5
			end
		end

		return var_8_2 < var_8_3
	end

	local var_7_4 = var_0_14[1].item_filter
	local var_7_5 = arg_7_0:_get_items_by_filter(var_7_4)
	local var_7_6 = 1

	table.sort(var_7_5, var_7_3)

	local var_7_7 = {}
	local var_7_8 = var_7_0.item_grid
	local var_7_9 = ItemGridUI:new(var_0_14, var_7_8, var_7_1, var_7_2)
	local var_7_10 = {}

	var_7_9:disable_locked_items(true)
	var_7_9:apply_item_sorting_function(var_7_3)
	var_7_9:change_category("loot")
	var_7_9:disable_item_drag()

	if arg_7_0._current_page then
		local var_7_11, var_7_12 = var_7_9:get_page_info()
		local var_7_13 = math.min(arg_7_0._current_page, var_7_12)

		var_7_9:set_item_page(var_7_13)
	end

	arg_7_0._item_grid = var_7_9

	local var_7_14
	local var_7_15 = false
	local var_7_16 = arg_7_0._last_selected_item

	if var_7_16 and var_7_9:has_item(var_7_16) then
		var_7_14 = var_7_16
	else
		var_7_14 = var_7_9:get_item_in_slot(1, 1)
		var_7_15 = true
	end

	arg_7_0:_select_grid_item(var_7_14, nil, var_7_15)
end

function HeroViewStateLoot._get_items_by_filter(arg_9_0, arg_9_1)
	return (Managers.backend:get_interface("items"):get_filtered_items(arg_9_1))
end

function HeroViewStateLoot.get_background_world(arg_10_0)
	return arg_10_0.parent:get_background_world()
end

function HeroViewStateLoot.transitioning(arg_11_0)
	if arg_11_0.exiting then
		return true
	else
		return false
	end
end

function HeroViewStateLoot.wanted_menu_state(arg_12_0)
	return arg_12_0._wanted_menu_state
end

function HeroViewStateLoot.clear_wanted_menu_state(arg_13_0)
	arg_13_0._wanted_menu_state = nil
end

function HeroViewStateLoot._wanted_state(arg_14_0)
	return (arg_14_0.parent:wanted_state())
end

function HeroViewStateLoot.create_ui_elements(arg_15_0)
	if arg_15_0._preview_loot_widgets then
		for iter_15_0, iter_15_1 in ipairs(arg_15_0._preview_loot_widgets) do
			UIWidget.destroy(arg_15_0.loot_ui_renderer, iter_15_1)
		end
	end

	var_0_36 = false
	arg_15_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_16)
	arg_15_0.background_fade_widget = UIWidget.init(var_0_18)
	arg_15_0._debug_widgets, arg_15_0._debug_widgets_by_name = UIUtils.create_widgets(var_0_10)
	arg_15_0._widgets, arg_15_0._widgets_by_name = UIUtils.create_widgets(var_0_5)
	arg_15_0._option_widgets, arg_15_0._option_widgets_by_name = UIUtils.create_widgets(var_0_9)
	arg_15_0._option_background_widgets, arg_15_0._option_background_widgets_by_name = UIUtils.create_widgets(var_0_11)
	arg_15_0._preview_loot_widgets, arg_15_0._preview_loot_widgets_by_name = UIUtils.create_widgets(var_0_12)
	arg_15_0._input_desc_widgets, arg_15_0._input_desc_widgets_by_name = UIUtils.create_widgets(var_0_7)
	arg_15_0._gamepad_tooltip_widgets, arg_15_0._gamepad_tooltip_widgets_by_name = UIUtils.create_widgets(var_0_6)
	arg_15_0._arrow_widgets, arg_15_0._arrow_widgets_by_name = UIUtils.create_widgets(var_0_22)
	arg_15_0._continue_button_widget = UIWidget.init(var_0_8)

	UIRenderer.clear_scenegraph_queue(arg_15_0.loot_ui_renderer)

	arg_15_0.ui_animator = UIAnimator:new(arg_15_0.ui_scenegraph, var_0_17)
	arg_15_0._widgets_by_name.item_cap_warning_text.content.visible = false

	arg_15_0:_setup_reward_option_widgets()
end

function HeroViewStateLoot._setup_reward_option_widgets(arg_16_0)
	local var_16_0 = var_0_20 * 3
	local var_16_1 = {}

	for iter_16_0 = 1, var_16_0 do
		local var_16_2 = "loot_option_" .. iter_16_0
		local var_16_3 = "loot_background_" .. iter_16_0

		var_16_1[iter_16_0] = {
			widget = arg_16_0._option_widgets_by_name[var_16_2],
			preview_widget = not var_0_23 and arg_16_0._preview_loot_widgets_by_name[var_16_2] or nil,
			background_widget = arg_16_0._option_background_widgets_by_name[var_16_3]
		}
	end

	arg_16_0._reward_options = var_16_1
end

function HeroViewStateLoot._setup_camera(arg_17_0)
	local var_17_0
	local var_17_1 = var_0_13.style.viewport.level_name
	local var_17_2 = LevelResource.unit_indices(var_17_1, "units/hub_elements/cutscene_camera/cutscene_camera")

	for iter_17_0, iter_17_1 in pairs(var_17_2) do
		local var_17_3 = LevelResource.unit_data(var_17_1, iter_17_1)
		local var_17_4 = DynamicData.get(var_17_3, "name")

		if var_17_4 and var_17_4 == "end_screen_camera" then
			local var_17_5 = LevelResource.unit_position(var_17_1, iter_17_1)
			local var_17_6 = LevelResource.unit_rotation(var_17_1, iter_17_1)
			local var_17_7 = Matrix4x4.from_quaternion_position(var_17_6, var_17_5)

			var_17_0 = Matrix4x4Box(var_17_7)
		end
	end

	arg_17_0._camera_pose = var_17_0

	arg_17_0:_position_camera()
end

function HeroViewStateLoot.set_camera_position(arg_18_0, arg_18_1)
	local var_18_0, var_18_1 = arg_18_0:get_viewport_world()
	local var_18_2 = ScriptViewport.camera(var_18_1)

	return ScriptCamera.set_local_position(var_18_2, arg_18_1)
end

function HeroViewStateLoot.set_camera_rotation(arg_19_0, arg_19_1)
	local var_19_0, var_19_1 = arg_19_0:get_viewport_world()
	local var_19_2 = ScriptViewport.camera(var_19_1)

	return ScriptCamera.set_local_rotation(var_19_2, arg_19_1)
end

function HeroViewStateLoot.get_camera_position(arg_20_0)
	local var_20_0, var_20_1 = arg_20_0:get_viewport_world()
	local var_20_2 = ScriptViewport.camera(var_20_1)

	return ScriptCamera.position(var_20_2)
end

function HeroViewStateLoot.get_camera_rotation(arg_21_0)
	local var_21_0, var_21_1 = arg_21_0:get_viewport_world()
	local var_21_2 = ScriptViewport.camera(var_21_1)

	return ScriptCamera.rotation(var_21_2)
end

function HeroViewStateLoot.get_viewport_world(arg_22_0)
	local var_22_0 = arg_22_0.viewport_widget.element.pass_data[1]
	local var_22_1 = var_22_0.viewport

	return var_22_0.world, var_22_1
end

function HeroViewStateLoot._position_camera(arg_23_0, arg_23_1)
	local var_23_0, var_23_1 = arg_23_0:get_viewport_world()
	local var_23_2 = ScriptViewport.camera(var_23_1)
	local var_23_3 = arg_23_1 or arg_23_0._camera_pose:unbox()

	if var_23_3 then
		local var_23_4 = 65

		Camera.set_vertical_fov(var_23_2, math.pi * var_23_4 / 180)
		ScriptCamera.set_local_pose(var_23_2, var_23_3)
		ScriptCamera.force_update(var_23_0, var_23_2)
	end
end

function HeroViewStateLoot.on_exit(arg_24_0, arg_24_1)
	print("[HeroViewState] Exit Substate HeroViewStateLoot")

	if arg_24_0.menu_input_description then
		arg_24_0.menu_input_description:destroy()

		arg_24_0.menu_input_description = nil
	end

	arg_24_0:_destroy_chest_unit()
	arg_24_0:_unload_loaded_packages()

	local var_24_0 = arg_24_0.loot_ui_renderer

	if arg_24_0.viewport_widget then
		UIWidget.destroy(var_24_0, arg_24_0.viewport_widget)

		arg_24_0.viewport_widget = nil
	end

	local var_24_1 = arg_24_0._reward_options

	if var_24_1 then
		for iter_24_0, iter_24_1 in ipairs(var_24_1) do
			local var_24_2 = iter_24_1.widget
			local var_24_3 = iter_24_1.item_previewer

			if var_24_3 then
				var_24_3:destroy()

				iter_24_1.item_previewer = nil
			end

			local var_24_4 = iter_24_1.world_previewer

			if var_24_4 then
				var_24_4:prepare_exit()
				var_24_4:on_exit()
				var_24_4:destroy()

				iter_24_1.world_previewer = nil
			end
		end
	end

	local var_24_5 = arg_24_0._preview_loot_widgets

	for iter_24_2, iter_24_3 in ipairs(var_24_5) do
		UIWidget.destroy(var_24_0, iter_24_3)
	end

	arg_24_0._item_grid:destroy()

	arg_24_0._item_grid = nil
	arg_24_0.ui_animator = nil

	arg_24_0:play_sound("play_gui_chestroom_stop")

	if arg_24_0.loot_ui_renderer then
		UIRenderer.destroy(arg_24_0.loot_ui_renderer, arg_24_0.loot_ui_world)
		arg_24_0.world_manager:destroy_world(arg_24_0.loot_ui_world)

		arg_24_0.loot_ui_world = nil
		arg_24_0.loot_ui_renderer = nil
	end

	arg_24_0:enable_player_world()
end

function HeroViewStateLoot._update_transition_timer(arg_25_0, arg_25_1)
	if not arg_25_0._transition_timer then
		return
	end

	if arg_25_0._transition_timer == 0 then
		arg_25_0._transition_timer = nil
	else
		arg_25_0._transition_timer = math.max(arg_25_0._transition_timer - arg_25_1, 0)
	end
end

function HeroViewStateLoot.update(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_0.waiting_for_post_update_enter then
		return
	end

	if var_0_36 then
		arg_26_0:create_ui_elements()
	end

	arg_26_0:_update_animations(arg_26_1)
	arg_26_0:_update_active_viewports()
	arg_26_0:_update_enter_animation_time(arg_26_1, arg_26_2)
	arg_26_0:_update_chest_zoom_in_time(arg_26_1, arg_26_2)
	arg_26_0:_update_chest_zoom_out_time(arg_26_1, arg_26_2)
	arg_26_0:_update_camera_look_up_time(arg_26_1, arg_26_2)
	arg_26_0:_update_chest_open_wait_time(arg_26_1, arg_26_2)
	arg_26_0:_update_camera_look_down_time(arg_26_1, arg_26_2)
	arg_26_0:_update_continue_button_animation_time(arg_26_1, arg_26_2)
	arg_26_0:_handle_gamepad_activity()
	arg_26_0:draw(arg_26_1)
	arg_26_0:_update_transition_timer(arg_26_1)

	local var_26_0 = arg_26_0:_wanted_state()

	if not arg_26_0._transition_timer then
		local var_26_1 = arg_26_0._active_reward_options

		if var_26_1 then
			for iter_26_0, iter_26_1 in ipairs(var_26_1) do
				local var_26_2 = iter_26_1.widget.content
				local var_26_3 = iter_26_1.item_previewer

				if var_26_3 then
					var_26_3:update(arg_26_1, arg_26_2)
				end

				local var_26_4 = iter_26_1.world_previewer

				if var_26_4 then
					var_26_4:update(arg_26_1, arg_26_2)

					if var_26_2.is_loading and var_26_4:character_visible() then
						var_26_2.is_loading = false
					end
				end
			end
		end

		return var_26_0 or arg_26_0._new_state
	end
end

function HeroViewStateLoot.post_update(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_0.waiting_for_post_update_enter then
		arg_27_0:post_update_on_enter()
	end

	arg_27_0.ui_animator:update(arg_27_1)

	local var_27_0 = arg_27_0._animations
	local var_27_1 = arg_27_0.ui_animator
	local var_27_2 = arg_27_0._open_loot_chest_id

	if var_27_2 then
		local var_27_3 = Managers.backend:get_interface("loot")

		if var_27_3:is_loot_generated(var_27_2) then
			local var_27_4 = var_27_3:get_loot(var_27_2)

			arg_27_0:loot_chest_opened(var_27_4)

			arg_27_0._open_loot_chest_id = nil
		end
	end

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		if var_27_1:is_animation_completed(iter_27_1) then
			var_27_1:stop_animation(iter_27_1)

			var_27_0[iter_27_0] = nil
		end
	end

	if not arg_27_0.parent:transitioning() and not arg_27_0._transition_timer then
		local var_27_5 = arg_27_0._item_grid

		if var_27_5 then
			var_27_5:update(arg_27_1, arg_27_2)
		end

		local var_27_6 = arg_27_0._active_camera_shakes

		if var_27_6 then
			for iter_27_2, iter_27_3 in pairs(var_27_6) do
				arg_27_0:_apply_shake_event(iter_27_2, arg_27_2)
			end
		end

		arg_27_0:_update_camera_shake_chest_spawn_time(arg_27_1, arg_27_2)
		arg_27_0:_handle_input(arg_27_1, arg_27_2)
		arg_27_0:_handle_gamepad_input(arg_27_1, arg_27_2)
		arg_27_0:_update_page_info()

		local var_27_7 = arg_27_0._active_reward_options

		if var_27_7 then
			for iter_27_4, iter_27_5 in ipairs(var_27_7) do
				local var_27_8 = iter_27_5.item_previewer

				if var_27_8 then
					var_27_8:post_update(arg_27_1, arg_27_2)
				end

				local var_27_9 = iter_27_5.world_previewer

				if var_27_9 then
					var_27_9:post_update(arg_27_1, arg_27_2)
				end
			end
		end
	end
end

function HeroViewStateLoot._update_animations(arg_28_0, arg_28_1)
	if arg_28_0._chest_presentation_active then
		local var_28_0 = Managers.input:is_device_active("mouse")

		arg_28_0:_animate_reward_options_entry(arg_28_1)

		for iter_28_0, iter_28_1 in ipairs(arg_28_0._active_reward_options) do
			local var_28_1 = iter_28_1.widget
			local var_28_2 = var_28_1.content
			local var_28_3 = var_28_2.button_hotspot

			if not var_28_3.disable_button then
				local var_28_4 = var_28_2.rarity
				local var_28_5 = 0
				local var_28_6 = var_28_2.glow_alpha_progress or 0
				local var_28_7 = arg_28_1 * 3

				if var_28_3.on_hover_enter then
					local var_28_8 = var_28_4 and "play_gui_chest_reward_hover_start_" .. tostring(var_28_4) or "play_gui_chest_reward_start"

					arg_28_0:play_sound(var_28_8)
				elseif var_28_3.on_hover_exit then
					local var_28_9 = var_28_4 and "play_gui_chest_reward_hover_stop_" .. tostring(var_28_4) or "play_gui_chest_reward_stop"

					arg_28_0:play_sound(var_28_9)
				end

				local var_28_10 = not var_28_0 and arg_28_0._console_selection_index == iter_28_0

				if var_28_3.is_hover or var_28_10 or arg_28_0._auto_open_rewards_on_complete then
					var_28_6 = math.min(var_28_6 + var_28_7, 1)
					var_28_5 = math.easeOutCubic(var_28_6)
				else
					var_28_6 = math.max(var_28_6 - var_28_7, 0)
					var_28_5 = math.easeInCubic(var_28_6)
				end

				var_28_2.glow_alpha_progress = var_28_6

				local var_28_11 = var_28_1.style

				var_28_11.lock_glow.color[1] = var_28_11.lock_glow.default_color[1] * var_28_5
				var_28_11.lock_glow_1.color[1] = var_28_11.lock_glow_1.default_color[1] * var_28_5
				var_28_11.lock_glow_2.color[1] = var_28_11.lock_glow_2.default_color[1] * var_28_5
				var_28_11.lock_bottom_glow.color[1] = var_28_11.lock_bottom_glow.default_color[1] * var_28_5
				var_28_11.lock_bottom_glow_2.color[1] = var_28_11.lock_bottom_glow_2.default_color[1] * var_28_5
			end
		end
	end

	local var_28_12 = arg_28_0._widgets_by_name
	local var_28_13 = var_28_12.page_button_next
	local var_28_14 = var_28_12.page_button_previous

	UIWidgetUtils.animate_arrow_button(var_28_13, arg_28_1)
	UIWidgetUtils.animate_arrow_button(var_28_14, arg_28_1)

	for iter_28_2 = 1, #arg_28_0._chest_indicators do
		local var_28_15 = arg_28_0._chest_indicators[iter_28_2]

		UIWidgetUtils.animate_arrow_button(var_28_15, arg_28_1)
	end

	local var_28_16 = arg_28_0._ui_animations

	for iter_28_3, iter_28_4 in pairs(var_28_16) do
		UIAnimation.update(iter_28_4, arg_28_1)

		if UIAnimation.completed(iter_28_4) then
			var_28_16[iter_28_3] = nil
		end
	end
end

function HeroViewStateLoot.draw(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0.loot_ui_renderer
	local var_29_1 = arg_29_0.ui_top_renderer
	local var_29_2 = arg_29_0.ui_scenegraph
	local var_29_3 = arg_29_0.input_manager
	local var_29_4 = arg_29_0.render_settings
	local var_29_5 = var_29_3:get_service("hero_view")
	local var_29_6 = var_29_3:is_device_active("gamepad")

	var_29_4.alpha_multiplier = 1

	UIRenderer.begin_pass(var_29_0, var_29_2, var_29_5, arg_29_1, nil, var_29_4)

	if arg_29_0._chest_presentation_active then
		for iter_29_0, iter_29_1 in ipairs(arg_29_0._option_background_widgets) do
			UIRenderer.draw_widget(var_29_0, iter_29_1)
		end
	end

	var_29_4.alpha_multiplier = arg_29_0._grid_alpha_multiplier or 1

	for iter_29_2, iter_29_3 in ipairs(arg_29_0._widgets) do
		UIRenderer.draw_widget(var_29_0, iter_29_3)
	end

	if arg_29_0._portrait_widget then
		UIRenderer.draw_widget(var_29_0, arg_29_0._portrait_widget)
	end

	var_29_4.alpha_multiplier = 1

	if arg_29_0.viewport_widget then
		UIRenderer.draw_widget(var_29_0, arg_29_0.viewport_widget)
		UIRenderer.draw_widget(var_29_0, arg_29_0.background_fade_widget)
	end

	if arg_29_0._draw_input_desc_widgets and var_29_6 then
		for iter_29_4, iter_29_5 in pairs(arg_29_0._input_desc_widgets) do
			UIRenderer.draw_widget(var_29_0, iter_29_5)
		end
	end

	local var_29_7 = arg_29_0._present_reward_options

	if var_29_6 and not var_29_7 and var_29_5:get("special_1_hold") then
		local var_29_8 = arg_29_0._gamepad_tooltip_widgets_by_name.chest_tooltip

		UIRenderer.draw_widget(var_29_0, var_29_8)
	end

	UIRenderer.end_pass(var_29_0)

	local var_29_9 = -200
	local var_29_10 = 1920
	local var_29_11 = arg_29_0._active_reward_options

	if var_29_11 then
		UIRenderer.begin_pass(var_29_1, var_29_2, var_29_5, arg_29_1, nil, var_29_4)

		for iter_29_6, iter_29_7 in ipairs(var_29_11) do
			local var_29_12 = iter_29_7.preview_widget
			local var_29_13 = iter_29_7.widget

			if var_29_7 then
				local var_29_14 = var_29_13.scenegraph_id
				local var_29_15 = -var_29_2.loot_options_root.local_position[1]
				local var_29_16 = var_29_2[var_29_14].local_position[1] + var_29_10 / 2 + var_29_9

				if var_29_15 < var_29_16 + var_29_2[var_29_14].size[1] and var_29_16 < var_29_15 + var_29_10 then
					UIRenderer.draw_widget(var_29_1, var_29_13)

					local var_29_17 = iter_29_7.frame_widget

					if var_29_17 then
						UIRenderer.draw_widget(var_29_1, var_29_17)
					end

					if var_29_12 then
						if iter_29_7.opened then
							arg_29_0:_activate_widget_viewport(var_29_12, true)
							UIRenderer.draw_widget(var_29_1, var_29_12)
						else
							arg_29_0:_activate_widget_viewport(var_29_12, false)
						end
					end
				elseif var_29_12 then
					arg_29_0:_activate_widget_viewport(var_29_12, false)
				end
			end
		end

		if var_29_7 then
			if var_29_6 and var_29_5:get("special_1_hold") then
				local var_29_18 = arg_29_0._num_chests * 3

				for iter_29_8 = 1, var_29_18 do
					local var_29_19 = arg_29_0._gamepad_tooltip_widgets_by_name["item_tooltip_" .. iter_29_8]
					local var_29_20 = var_29_19.scenegraph_id
					local var_29_21 = 0
					local var_29_22 = var_29_2[var_29_20].world_position[1]

					if var_29_21 < var_29_22 + var_29_2[var_29_20].size[1] and var_29_22 < var_29_21 + var_29_10 then
						UIRenderer.draw_widget(var_29_1, var_29_19)
					end
				end
			end

			if arg_29_0._rewards_presented then
				var_29_4.alpha_multiplier = arg_29_0._continue_button_alpha_multiplier or 1

				UIRenderer.draw_widget(var_29_1, arg_29_0._continue_button_widget)

				for iter_29_9, iter_29_10 in ipairs(arg_29_0._chest_indicators) do
					UIRenderer.draw_widget(var_29_1, iter_29_10)
				end

				if #arg_29_0._chest_indicators > 1 then
					for iter_29_11, iter_29_12 in ipairs(arg_29_0._arrow_widgets) do
						UIRenderer.draw_widget(var_29_1, iter_29_12)
					end
				end
			end
		end

		UIRenderer.end_pass(var_29_1)
	end

	if var_29_6 then
		arg_29_0.menu_input_description:draw(var_29_0, arg_29_1)
	end
end

function HeroViewStateLoot._activate_widget_viewport(arg_30_0, arg_30_1, arg_30_2)
	if not arg_30_1 then
		return
	end

	local var_30_0 = arg_30_1.content

	if var_30_0.activated ~= arg_30_2 then
		local var_30_1 = arg_30_1.element.pass_data[1]
		local var_30_2 = var_30_1.world
		local var_30_3 = var_30_1.viewport

		if arg_30_2 then
			ScriptWorld.activate_viewport(var_30_2, var_30_3)
		else
			ScriptWorld.deactivate_viewport(var_30_2, var_30_3)
		end

		var_30_0.activated = arg_30_2
	end
end

function HeroViewStateLoot._set_debug_buttons_disable_state(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._debug_widgets

	for iter_31_0, iter_31_1 in ipairs(var_31_0) do
		local var_31_1 = iter_31_1.content

		;(var_31_1.hotspot or var_31_1.button_hotspot).disable_button = arg_31_1
	end
end

function HeroViewStateLoot._is_button_pressed(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_1.content
	local var_32_1 = var_32_0.hotspot or var_32_0.button_hotspot

	if var_32_1.on_release then
		var_32_1.on_release = false

		return true
	end
end

function HeroViewStateLoot._is_button_hovered(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1.content

	if (var_33_0.hotspot or var_33_0.button_hotspot).on_hover_enter then
		return true
	end
end

function HeroViewStateLoot._is_option_tab_selected(arg_34_0)
	local var_34_0 = arg_34_0._widgets_by_name.inventory_tabs.content
	local var_34_1 = var_34_0.amount

	for iter_34_0 = 1, var_34_1 do
		local var_34_2 = "_" .. tostring(iter_34_0)

		if var_34_0["hotspot" .. var_34_2].on_pressed then
			return iter_34_0
		end
	end
end

function HeroViewStateLoot._select_option_tab_by_index(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._widgets_by_name.inventory_tabs.content
	local var_35_1 = var_35_0.amount

	for iter_35_0 = 1, var_35_1 do
		local var_35_2 = "_" .. tostring(iter_35_0)

		var_35_0["hotspot" .. var_35_2].is_selected = iter_35_0 == arg_35_1
	end
end

function HeroViewStateLoot._has_grid_item(arg_36_0, arg_36_1)
	return arg_36_0._item_grid:has_item(arg_36_1)
end

local var_0_37 = {}

function HeroViewStateLoot._select_grid_item(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = arg_37_0._widgets_by_name
	local var_37_1 = arg_37_0._item_grid
	local var_37_2 = Managers.backend:get_interface("items")

	arg_37_1 = arg_37_1 and var_37_2:get_item_from_id(arg_37_1.backend_id)

	var_37_1:set_item_selected(arg_37_1)

	local var_37_3 = 0
	local var_37_4 = 2

	if arg_37_1 then
		arg_37_0._gamepad_tooltip_widgets_by_name.chest_tooltip.content.item = arg_37_1

		local var_37_5
		local var_37_6
		local var_37_7
		local var_37_8 = arg_37_1.data

		var_0_37[1] = var_37_8.chest_category

		local var_37_9 = var_37_8.chest_categories or var_0_37
		local var_37_10 = var_37_8.chest_tier
		local var_37_11 = LootChestData.chests_by_category

		var_37_3 = arg_37_1.RemainingUses
		var_37_4 = math.clamp(var_37_3, 2, var_0_20)

		for iter_37_0 = 1, #var_37_9 do
			local var_37_12 = var_37_9[iter_37_0]
			local var_37_13 = var_37_11[var_37_12]

			if var_37_13 then
				local var_37_14 = var_37_13.chest_unit_names

				for iter_37_1, iter_37_2 in ipairs(var_37_14) do
					if iter_37_1 == var_37_10 then
						var_37_5 = iter_37_2
						var_37_6 = "play_gui_chest_appear_" .. var_37_12 .. "_" .. tostring(iter_37_1)

						break
					end
				end

				local var_37_15 = var_37_13.individual_chest_package_names

				if var_37_15 then
					for iter_37_3, iter_37_4 in ipairs(var_37_15) do
						if iter_37_3 == var_37_10 then
							var_37_7 = iter_37_4

							break
						end
					end
				end
			end

			if var_37_5 then
				break
			end
		end

		if var_37_5 then
			arg_37_0._unit_to_spawn = var_37_5
			arg_37_0._sound_event = var_37_6
			arg_37_0._package_to_spawn = var_37_7

			arg_37_0:_load_package(var_37_7)
		end

		local var_37_16, var_37_17, var_37_18 = UIUtils.get_ui_information_from_item(arg_37_1)
		local var_37_19 = var_37_8.item_type
		local var_37_20 = var_37_8.info_text_box_text_id or "loot_opening_screen_desc"

		var_37_0.info_text_box.content.text = var_37_20
		var_37_0.chest_title.content.text = Localize(var_37_17)
		var_37_0.chest_sub_title.content.text = Localize(var_37_19)

		arg_37_0:set_chest_title_alpha_progress(1)
		arg_37_0.menu_input_description:set_input_description(var_0_15.chest_selected)

		local var_37_21 = Localize("interaction_action_open") .. " " .. var_37_4

		var_37_0.open_multiple_button.content.title_text = var_37_21
		var_0_15.chest_selected.actions[3].description_text = var_37_21
	else
		arg_37_0:_destroy_chest_unit()
		arg_37_0:_unload_loaded_packages()
		arg_37_0:set_chest_title_alpha_progress(0)
		arg_37_0.menu_input_description:set_input_description(var_0_15.chest_not_selected)

		arg_37_0._num_chests = 1
	end

	arg_37_0._selected_item = arg_37_1

	local var_37_22 = var_37_2:free_inventory_slots()
	local var_37_23 = UISettings.items_per_chest
	local var_37_24 = var_37_23 <= var_37_22
	local var_37_25 = var_37_22 >= var_37_23 * var_37_4

	arg_37_0._open_chests_enabled = var_37_3 >= 1 and var_37_24
	arg_37_0._open_multiple_chests_enabled = var_37_3 >= 2 and var_37_25
	var_37_0.item_cap_warning_text.content.visible = not var_37_24 or not var_37_25
	var_37_0.open_button.content.button_hotspot.disable_button = not arg_37_0._open_chests_enabled
	var_37_0.open_multiple_button.content.button_hotspot.disable_button = not arg_37_0._open_multiple_chests_enabled

	if not arg_37_0._open_chests_enabled then
		arg_37_0.menu_input_description:set_input_description(var_0_15.chest_not_selected)
	elseif not arg_37_0._open_multiple_chests_enabled then
		arg_37_0.menu_input_description:set_input_description(var_0_15.chest_selected_single_use)
	else
		arg_37_0.menu_input_description:set_input_description(var_0_15.chest_selected)
	end
end

function HeroViewStateLoot._play_sound(arg_38_0, arg_38_1)
	WwiseWorld.trigger_event(arg_38_0.wwise_world, arg_38_1)
end

function HeroViewStateLoot._handle_gamepad_input(arg_39_0, arg_39_1, arg_39_2)
	if Managers.input:is_device_active("mouse") then
		return
	end

	local var_39_0 = arg_39_0.input_manager:get_service("hero_view")
	local var_39_1 = arg_39_0._item_grid

	if not arg_39_0._chest_presentation_active and not arg_39_0._opening_chest then
		var_39_1:handle_gamepad_selection(var_39_0)

		local var_39_2 = var_39_1:selected_item()

		if var_39_2 ~= arg_39_0._selected_item then
			local var_39_3 = true

			arg_39_0:_select_grid_item(var_39_2, arg_39_2, var_39_3)
		end

		local var_39_4 = arg_39_0._current_page
		local var_39_5 = arg_39_0._total_pages

		if var_39_4 and var_39_5 then
			if var_39_4 < var_39_5 and (var_39_0:get(var_0_1) or var_39_0:get(var_0_3)) then
				var_39_1:set_item_page(var_39_4 + 1)
				arg_39_0:_play_sound("play_gui_equipment_inventory_next_click")

				local var_39_6 = var_39_1:get_item_in_slot(1, 1)

				var_39_1:set_item_selected(var_39_6)
			elseif var_39_4 > 1 and (var_39_0:get(var_0_2) or var_39_0:get(var_0_4)) then
				var_39_1:set_item_page(var_39_4 - 1)
				arg_39_0:_play_sound("play_gui_equipment_inventory_next_click")

				local var_39_7 = var_39_1:get_item_in_slot(1, 1)

				var_39_1:set_item_selected(var_39_7)
			end
		end
	elseif arg_39_0._reward_option_animation_complete then
		if var_39_0:get(var_0_1) or var_39_0:get(var_0_3) then
			local var_39_8 = 1

			arg_39_0:_change_chest_page(var_39_8)
		elseif var_39_0:get(var_0_2) or var_39_0:get(var_0_4) then
			local var_39_9 = -1

			arg_39_0:_change_chest_page(var_39_9)
		elseif not arg_39_0._rewards_presented and not var_39_0:get("special_1_hold") and not arg_39_0._ui_animations.page_cycle then
			if var_39_0:get("move_left") then
				local var_39_10 = false

				arg_39_0._console_selection_index = arg_39_0:_find_console_selection_index(var_39_10)
			elseif var_39_0:get("move_right") then
				local var_39_11 = true

				arg_39_0._console_selection_index = arg_39_0:_find_console_selection_index(var_39_11)
			end

			if var_39_0:get("confirm_press", true) then
				arg_39_0:open_reward_option(arg_39_0._console_selection_index)
			end
		end
	end
end

function HeroViewStateLoot._find_console_selection_index(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0._active_reward_options
	local var_40_1 = #var_40_0

	if arg_40_1 then
		local var_40_2 = arg_40_0._console_selection_index
		local var_40_3 = var_40_2

		for iter_40_0 = 1, var_40_1 - 1 do
			var_40_3 = 1 + var_40_3 % var_40_1

			if not var_40_0[var_40_3].widget.content.button_hotspot.disable_button then
				var_40_2 = var_40_3

				break
			end
		end

		return var_40_2
	else
		local var_40_4 = arg_40_0._console_selection_index
		local var_40_5 = var_40_4

		for iter_40_1 = 1, var_40_1 - 1 do
			var_40_5 = var_40_5 - 1

			if var_40_5 < 1 then
				var_40_5 = var_40_1
			end

			if not var_40_0[var_40_5].widget.content.button_hotspot.disable_button then
				var_40_4 = var_40_5

				break
			end
		end

		return var_40_4
	end
end

function HeroViewStateLoot._handle_page_selection(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0._arrow_widgets_by_name.arrow_right
	local var_41_1 = arg_41_0._arrow_widgets_by_name.arrow_left
	local var_41_2 = UIUtils.is_button_hover(var_41_0) and 1 or -1
	local var_41_3 = var_41_0.style.arrow_lit
	local var_41_4 = var_41_3.progress or 0
	local var_41_5 = math.clamp(var_41_4 + arg_41_1 * 6 * var_41_2, 0, 1)

	var_41_3.color[1] = var_41_5 * 255
	var_41_3.progress = var_41_5

	local var_41_6 = UIUtils.is_button_hover(var_41_1) and 1 or -1
	local var_41_7 = var_41_1.style.arrow_lit
	local var_41_8 = var_41_7.progress or 0
	local var_41_9 = math.clamp(var_41_8 + arg_41_1 * 6 * var_41_6, 0, 1)

	var_41_7.color[1] = var_41_9 * 255
	var_41_7.progress = var_41_9

	if arg_41_0:_is_button_pressed(var_41_0) then
		local var_41_10 = 1

		arg_41_0:_change_chest_page(var_41_10)
	elseif arg_41_0:_is_button_pressed(var_41_1) then
		local var_41_11 = -1

		arg_41_0:_change_chest_page(var_41_11)
	else
		local var_41_12

		for iter_41_0 = 1, #arg_41_0._chest_indicators do
			local var_41_13 = arg_41_0._chest_indicators[iter_41_0]

			if arg_41_0:_is_button_pressed(var_41_13) then
				var_41_12 = iter_41_0

				break
			end
		end

		if var_41_12 then
			local var_41_14 = var_41_12 - arg_41_0._current_page_index

			arg_41_0:_change_chest_page(var_41_14)
		end
	end
end

function HeroViewStateLoot._change_chest_page(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._current_page_index
	local var_42_1 = #arg_42_0._active_reward_options
	local var_42_2 = math.ceil(var_42_1 / 3)
	local var_42_3 = arg_42_0.ui_scenegraph.loot_options_root.local_position

	arg_42_0._current_page_index = math.clamp(arg_42_0._current_page_index + arg_42_1, 1, var_42_2)

	if arg_42_0._current_page_index ~= var_42_0 then
		arg_42_0._ui_animations.page_cycle = UIAnimation.init(UIAnimation.function_by_time, var_42_3, 1, var_42_3[1], (arg_42_0._current_page_index - 1) * -1920, 0.5, math.easeOutCubic)

		for iter_42_0, iter_42_1 in ipairs(arg_42_0._chest_indicators) do
			local var_42_4 = iter_42_1.content

			var_42_4.selected = var_42_4.index == arg_42_0._current_page_index
		end

		arg_42_0._viewports_dirty = true
	end
end

function HeroViewStateLoot._set_last_pressed(arg_43_0, arg_43_1)
	arg_43_0._last_open_pressed = arg_43_1

	local var_43_0 = arg_43_0._widgets_by_name

	var_43_0.open_button.content.side_detail.skip_side_detail = arg_43_1 ~= "single"
	var_43_0.open_multiple_button.content.side_detail.skip_side_detail = arg_43_1 ~= "multiple"
end

function HeroViewStateLoot._handle_input(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0._widgets_by_name
	local var_44_1 = arg_44_0.input_manager:get_service("hero_view")
	local var_44_2 = Managers.input:is_device_active("gamepad")
	local var_44_3 = arg_44_0.parent
	local var_44_4 = arg_44_0._item_grid
	local var_44_5 = arg_44_0._num_chests
	local var_44_6 = var_44_0.open_button
	local var_44_7 = var_44_0.close_button
	local var_44_8 = var_44_0.open_multiple_button
	local var_44_9 = arg_44_0._arrow_widgets_by_name.arrow_right
	local var_44_10 = arg_44_0._arrow_widgets_by_name.arrow_left
	local var_44_11 = arg_44_0._continue_button_widget

	UIWidgetUtils.animate_default_button(var_44_6, arg_44_1)
	UIWidgetUtils.animate_default_button(var_44_7, arg_44_1)
	UIWidgetUtils.animate_default_button(var_44_8, arg_44_1)
	UIWidgetUtils.animate_default_button(var_44_11, arg_44_1)

	local var_44_12 = var_44_2 and var_44_1:get("back_menu")

	if arg_44_0._wait_for_backend_reload then
		arg_44_0._wait_for_backend_reload = math.max(arg_44_0._wait_for_backend_reload - arg_44_1, 0)

		if arg_44_0._wait_for_backend_reload == 0 then
			arg_44_0._wait_for_backend_reload = nil

			arg_44_0:_set_debug_buttons_disable_state(false)
			arg_44_0:populate_items()
		end

		return
	end

	if arg_44_0._chest_presentation_active then
		for iter_44_0, iter_44_1 in ipairs(arg_44_0._active_reward_options) do
			local var_44_13 = iter_44_1.widget

			if arg_44_0:_is_button_pressed(var_44_13) then
				arg_44_0:open_reward_option(iter_44_0)

				break
			end
		end

		arg_44_0:_handle_page_selection(arg_44_1)

		if not arg_44_0._rewards_presented and (var_44_1:get("skip_pressed", true) or arg_44_0._auto_open_rewards_on_complete) then
			if not arg_44_0._reward_option_animation_complete then
				arg_44_0._auto_open_rewards_on_complete = true
			else
				arg_44_0._auto_open_rewards_on_complete = false

				local var_44_14 = arg_44_0._active_reward_options
				local var_44_15 = #var_44_14

				for iter_44_2 = 1, var_44_15 do
					if not var_44_14[iter_44_2].widget.content.button_hotspot.disable_button then
						arg_44_0:open_reward_option(iter_44_2)
					end
				end
			end
		end

		local var_44_16 = arg_44_0._rewards_presented and arg_44_0._continue_button_progress >= 1 and var_44_1:get("skip_pressed", true)

		if arg_44_0._rewards_presented and (arg_44_0:_is_button_pressed(var_44_11) or var_44_1:get("toggle_menu") or var_44_16 or var_44_12) then
			arg_44_0:play_sound("play_gui_chest_opening_return")

			arg_44_0._enter_animation_duration = nil
			arg_44_0._chest_zoom_in_duration = nil
			arg_44_0._chest_open_wait_duration = nil
			arg_44_0._continue_button_animation_duration = nil
			arg_44_0._rewards_presented = false
			arg_44_0._opening_chest = nil
			arg_44_0._chest_presentation_active = nil
			arg_44_0._present_reward_options = nil
			arg_44_0._auto_open_rewards_on_complete = false
			arg_44_0._chest_zoom_out_duration = 0
			arg_44_0._camera_look_down_duration = var_0_31 * (1 - arg_44_0._camera_look_up_progress)
			arg_44_0._camera_look_up_progress = 0
			arg_44_0._current_page_index = 1
			arg_44_0._reward_option_animation_complete = nil
			arg_44_0._camera_look_up_duration = nil

			arg_44_0:set_continue_button_animation_progress(0)
			arg_44_0:_reset_gamepad_tooltips()

			arg_44_0._console_selection_index = 1
			arg_44_0.ui_scenegraph.loot_options_root.local_position[1] = 0
			arg_44_0.ui_scenegraph.chest_indicator_root.local_position[2] = 200
			arg_44_0.ui_scenegraph.arrow_root.local_position[2] = 200

			local var_44_17 = arg_44_0._animations
			local var_44_18 = arg_44_0._active_reward_options

			if var_44_18 then
				for iter_44_3, iter_44_4 in ipairs(var_44_18) do
					local var_44_19 = iter_44_4.widget
					local var_44_20 = iter_44_4.preview_widget
					local var_44_21 = iter_44_4.background_widget
					local var_44_22 = iter_44_4.animation_name
					local var_44_23 = var_44_17[var_44_22]

					if var_44_23 then
						arg_44_0.ui_animator:stop_animation(var_44_23)

						var_44_17[var_44_22] = nil
					end

					local var_44_24 = iter_44_4.item_previewer

					if var_44_24 then
						var_44_24:destroy()

						iter_44_4.item_previewer = nil
					end

					local var_44_25 = iter_44_4.world_previewer

					if var_44_25 then
						var_44_25:prepare_exit()
						var_44_25:on_exit()
						var_44_25:destroy()

						iter_44_4.world_previewer = nil
					end

					table.clear(iter_44_4)

					iter_44_4.widget = var_44_19
					iter_44_4.preview_widget = var_44_20
					iter_44_4.background_widget = var_44_21
				end
			end

			arg_44_0:populate_items()
		end
	elseif not arg_44_0._opening_chest then
		local var_44_26 = var_44_0.page_button_next
		local var_44_27 = var_44_0.page_button_previous

		if arg_44_0:_is_button_hovered(var_44_26) or arg_44_0:_is_button_hovered(var_44_27) then
			arg_44_0:play_sound("play_gui_inventory_next_hover")
		end

		if arg_44_0:_is_button_pressed(var_44_26) then
			local var_44_28 = arg_44_0._current_page + 1

			var_44_4:set_item_page(var_44_28)
			arg_44_0:play_sound("play_gui_equipment_inventory_next_click")
		elseif arg_44_0:_is_button_pressed(var_44_27) then
			local var_44_29 = arg_44_0._current_page - 1

			var_44_4:set_item_page(var_44_29)
			arg_44_0:play_sound("play_gui_equipment_inventory_next_click")
		end

		if var_44_4:is_item_hovered() then
			arg_44_0:play_sound("play_gui_inventory_item_hover")
		end

		local var_44_30 = true
		local var_44_31 = var_44_4:is_item_pressed(var_44_30)

		if var_44_31 and (not arg_44_0._selected_item or arg_44_0._selected_item.backend_id ~= var_44_31.backend_id) then
			local var_44_32 = true

			arg_44_0:_select_grid_item(var_44_31, arg_44_2, var_44_32)
		end

		local var_44_33 = arg_44_0._open_chests_enabled and (var_44_1:get("confirm_press") or var_44_1:get("skip_pressed", true))
		local var_44_34 = arg_44_0._open_multiple_chests_enabled and var_44_1:get("refresh")

		if not Managers.input:is_device_active("gamepad") and IS_WINDOWS and var_44_33 and arg_44_0._last_open_pressed == "multiple" then
			var_44_33 = false
			var_44_34 = true
		end

		local var_44_35

		if (arg_44_0:_is_button_pressed(var_44_6) or var_44_33) and arg_44_0._selected_item then
			var_44_35 = 1

			arg_44_0:_set_last_pressed("single")
		elseif arg_44_0:_is_button_pressed(var_44_7) or var_44_1:get("toggle_menu") or var_44_12 then
			var_44_3:close_menu()
			arg_44_0:play_sound("Play_hud_select")
		elseif (arg_44_0:_is_button_pressed(var_44_8) or var_44_34) and arg_44_0._selected_item then
			local var_44_36 = arg_44_0._selected_item

			var_44_35 = math.min(var_0_20, var_44_36.RemainingUses)

			arg_44_0:_set_last_pressed("multiple")
		end

		if var_44_35 then
			arg_44_0._num_chests = var_44_35

			if Managers.backend:get_interface("items"):free_inventory_slots() >= var_44_35 * UISettings.items_per_chest then
				arg_44_0._auto_open_rewards_on_complete = var_44_35 > 1

				arg_44_0:_open_chest(arg_44_0._selected_item, var_44_35)
			end
		end
	end
end

function HeroViewStateLoot._update_page_info(arg_45_0)
	local var_45_0, var_45_1 = arg_45_0._item_grid:get_page_info()

	if var_45_0 ~= arg_45_0._current_page or var_45_1 ~= arg_45_0._total_pages then
		arg_45_0._total_pages = var_45_1
		arg_45_0._current_page = var_45_0
		var_45_0 = var_45_0 or 1
		var_45_1 = var_45_1 or 1

		local var_45_2 = arg_45_0._widgets_by_name

		var_45_2.page_text_left.content.text = tostring(var_45_0)
		var_45_2.page_text_right.content.text = tostring(var_45_1)
		var_45_2.page_button_next.content.hotspot.disable_button = var_45_0 == var_45_1
		var_45_2.page_button_previous.content.hotspot.disable_button = var_45_0 == 1
	end
end

local var_0_38 = {
	common = "play_hud_rewards_tier1",
	exotic = "play_hud_rewards_tier3",
	rare = "play_hud_rewards_tier2",
	unique = "play_hud_rewards_tier4"
}

function HeroViewStateLoot.open_reward_option(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._active_reward_options
	local var_46_1 = var_46_0[arg_46_1]
	local var_46_2 = {
		wwise_world = arg_46_0.wwise_world,
		render_settings = arg_46_0.render_settings,
		reward_option = var_46_1
	}
	local var_46_3 = var_46_1.widget
	local var_46_4 = var_46_3.content

	var_46_4.button_hotspot.disable_button = true
	var_46_1.animation_name = "open_loot_widget_" .. arg_46_1

	arg_46_0:_start_animation(var_46_1.animation_name, "open_loot_widget", var_46_3, var_46_2)

	arg_46_0._num_rewards_opened = arg_46_0._num_rewards_opened + 1

	if arg_46_0._num_rewards_opened == #var_46_0 then
		arg_46_0._rewards_presented = true
		arg_46_0._continue_button_animation_duration = 0

		if math.ceil(#var_46_0 / 3) > 1 then
			arg_46_0.menu_input_description:set_input_description(var_0_15.loot_presented_pages)
		else
			arg_46_0.menu_input_description:set_input_description(var_0_15.loot_presented)
		end

		local var_46_5 = arg_46_0.ui_scenegraph.chest_indicator_root.local_position

		arg_46_0._ui_animations.chest_indicator = UIAnimation.init(UIAnimation.function_by_time, var_46_5, 2, var_46_5[2], -35, var_0_29, math.easeOutCubic)

		local var_46_6 = arg_46_0.ui_scenegraph.arrow_root.local_position

		arg_46_0._ui_animations.arrow_root = UIAnimation.init(UIAnimation.function_by_time, var_46_6, 2, var_46_6[2], -40, var_0_29, math.easeOutCubic)
	end

	local var_46_7 = var_46_4.rarity
	local var_46_8 = var_0_38[var_46_7]

	if var_46_8 then
		arg_46_0:play_sound(var_46_8)
	end

	arg_46_0:_setup_gamepad_tooltip(arg_46_1, var_46_1)

	local var_46_9 = true

	arg_46_0._console_selection_index = arg_46_0:_find_console_selection_index(var_46_9)
end

function HeroViewStateLoot._setup_gamepad_tooltip(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._gamepad_tooltip_widgets_by_name["item_tooltip_" .. arg_47_1]

	if var_47_0 then
		local var_47_1 = arg_47_2.widget.content

		var_47_0.content.item = var_47_1.item
	end
end

function HeroViewStateLoot._reset_gamepad_tooltips(arg_48_0)
	for iter_48_0, iter_48_1 in pairs(arg_48_0._gamepad_tooltip_widgets) do
		iter_48_1.content.item = nil
	end
end

function HeroViewStateLoot._setup_rewards(arg_49_0, arg_49_1)
	local var_49_0 = Managers.backend:get_interface("items")
	local var_49_1 = arg_49_0._reward_options

	table.clear(arg_49_0._chest_indicators)

	local var_49_2 = {}

	if arg_49_0._num_chests > 1 then
		local var_49_3 = RaritySettings

		local function var_49_4(arg_50_0, arg_50_1)
			local var_50_0 = var_49_0:get_item_rarity(arg_50_0)
			local var_50_1 = var_49_3[var_50_0].order
			local var_50_2 = var_49_0:get_item_rarity(arg_50_1)

			return var_50_1 > var_49_3[var_50_2].order
		end

		table.sort(arg_49_1, var_49_4)

		local var_49_5 = math.ceil(#arg_49_1 / 3)

		arg_49_0.ui_scenegraph.chest_indicator_root.local_position[1] = -(var_49_5 - 1) * 60 * 0.5
		arg_49_0._arrow_widgets_by_name.arrow_left.offset[1] = -(var_49_5 + 1) * 60 * 0.5
		arg_49_0._arrow_widgets_by_name.arrow_right.offset[1] = (var_49_5 + 1) * 60 * 0.5

		for iter_49_0 = 1, var_49_5 do
			local var_49_6 = (iter_49_0 - 1) * 3 + 1
			local var_49_7 = arg_49_1[var_49_6]
			local var_49_8 = var_49_0:get_item_rarity(var_49_7)
			local var_49_9 = arg_49_1[var_49_6 + 1]
			local var_49_10 = var_49_9 and var_49_0:get_item_rarity(var_49_9)
			local var_49_11 = arg_49_1[var_49_6 + 2]
			local var_49_12 = var_49_11 and var_49_0:get_item_rarity(var_49_11)
			local var_49_13 = var_0_21(iter_49_0, arg_49_0._current_page_index, var_49_8, var_49_10, var_49_12)

			arg_49_0._chest_indicators[#arg_49_0._chest_indicators + 1] = UIWidget.init(var_49_13)
		end
	end

	local var_49_14 = #arg_49_1
	local var_49_15 = var_0_19[math.min(var_49_14, 3)]
	local var_49_16 = arg_49_0.ui_scenegraph
	local var_49_17 = 1920

	for iter_49_1, iter_49_2 in ipairs(var_49_1) do
		local var_49_18 = iter_49_2.widget
		local var_49_19 = var_49_18.content
		local var_49_20 = var_49_18.style

		table.clear(var_49_19.item_hotspot)
		table.clear(var_49_19.item_hotspot_2)

		local var_49_21 = arg_49_1[iter_49_1]

		if var_49_21 then
			local var_49_22 = 1 + (iter_49_1 - 1) % 3
			local var_49_23 = math.ceil(iter_49_1 / 3)
			local var_49_24 = var_49_15[var_49_22]
			local var_49_25 = var_49_16[var_49_18.scenegraph_id].local_position

			var_49_25[1] = var_49_24[1] + (var_49_23 - 1) * var_49_17
			var_49_25[2] = var_49_24[2]

			local var_49_26 = var_49_0:get_item_from_id(var_49_21)
			local var_49_27 = var_49_26.data
			local var_49_28 = var_49_27.key
			local var_49_29 = var_49_0:get_item_rarity(var_49_21)
			local var_49_30 = var_49_27.item_type
			local var_49_31 = var_49_27.slot_type
			local var_49_32, var_49_33, var_49_34 = UIUtils.get_ui_information_from_item(var_49_26)

			iter_49_2.background_widget.style.background.color = Colors.get_color_table_with_alpha(var_49_29, 255)

			local var_49_35 = UISettings.item_rarity_textures[var_49_29]
			local var_49_36 = var_0_35[var_49_29]

			iter_49_2.reward_backend_id = var_49_21
			iter_49_2.reward_key = var_49_28
			iter_49_2.opened = false
			var_49_19.is_loading = false
			var_49_19.rarity = var_49_29
			var_49_19.item = var_49_26
			var_49_19.item_icon = var_49_32
			var_49_19.item_icon_rarity = var_49_35
			var_49_19.item_name = Localize(var_49_33)
			var_49_19.item_type = Localize(var_49_30)
			var_49_19.presentation_complete = nil
			var_49_19.draw_frame = nil
			var_49_19.button_hotspot.disable_button = false
			var_49_19.glow_alpha_progress = 0
			var_49_19.item_hotspot_2.allow_multi_hover = true
			var_49_20.item_name.text_color[1] = 0
			var_49_20.item_name_shadow.text_color[1] = 0
			var_49_20.item_type.text_color[1] = 0
			var_49_20.item_type_shadow.text_color[1] = 0
			var_49_20.item_icon.offset[2] = -40
			var_49_20.item_tooltip.offset[2] = -40
			var_49_20.item_type.text_color = Colors.get_color_table_with_alpha(var_49_29, 0)

			local var_49_37 = var_49_36.back
			local var_49_38 = var_49_36.front
			local var_49_39 = var_49_36.center

			arg_49_0:_apply_color_to_glow_style(var_49_20.lock_bottom_glow, var_49_37)
			arg_49_0:_apply_color_to_glow_style(var_49_20.lock_bottom_glow_2, var_49_38)
			arg_49_0:_apply_color_to_glow_style(var_49_20.lock_glow, var_49_37)
			arg_49_0:_apply_color_to_glow_style(var_49_20.lock_glow_1, var_49_39)
			arg_49_0:_apply_color_to_glow_style(var_49_20.lock_glow_2, var_49_38)
			arg_49_0:_apply_color_to_glow_style(var_49_20.final_glow, var_49_37)
			arg_49_0:_apply_color_to_glow_style(var_49_20.final_glow_1, var_49_39)
			arg_49_0:_apply_color_to_glow_style(var_49_20.final_glow_2, var_49_38)

			var_49_19.lock_glow = "loot_presentation_circle_glow_" .. var_49_29
			var_49_19.final_glow = "loot_presentation_circle_glow_" .. var_49_29 .. "_large"
			var_49_19.image = nil
			var_49_19.amount_text = nil
			var_49_19.item_icon_frame = "item_frame"

			if var_49_31 == "melee" or var_49_31 == "ranged" or var_49_31 == "weapon_skin" then
				local var_49_40
				local var_49_41

				if not var_0_23 then
					local var_49_42 = iter_49_2.preview_widget.element.pass_data[1]

					var_49_40 = var_49_42.viewport
					var_49_41 = var_49_42.world
				end

				local var_49_43 = {
					0,
					0,
					-0.2
				}

				iter_49_2.item_previewer = LootItemUnitPreviewer:new(var_49_26, var_49_43, var_49_41, var_49_40, iter_49_1, nil, nil, nil, var_0_23)
			elseif var_49_31 == "hat" then
				local var_49_44

				if var_0_23 then
					var_49_44 = MenuWorldPreviewer:new(arg_49_0.ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroViewStateLootindex" .. iter_49_1, var_0_23)
				else
					var_49_44 = MenuWorldPreviewer:new(arg_49_0.ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroViewStateLootindex" .. iter_49_1)

					var_49_44:on_enter(iter_49_2.preview_widget)
				end

				var_49_44:force_hide_character()

				local var_49_45, var_49_46, var_49_47, var_49_48 = arg_49_0:_get_hero_wield_info_by_item(var_49_26)
				local var_49_49 = CareerSettings[var_49_47].base_skin
				local var_49_50 = var_49_27.key

				arg_49_0:_spawn_hero_with_hat(var_49_44, var_49_45, var_49_48, var_49_49, var_49_50)

				iter_49_2.world_previewer = var_49_44
				var_49_19.is_loading = true
			elseif var_49_31 == "skin" then
				local var_49_51

				if var_0_23 then
					var_49_51 = MenuWorldPreviewer:new(arg_49_0.ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroViewStateLootindex" .. iter_49_1, var_0_23)
				else
					var_49_51 = MenuWorldPreviewer:new(arg_49_0.ingame_ui_context, UISettings.hero_hat_camera_position_by_character, "HeroViewStateLootindex" .. iter_49_1)

					var_49_51:on_enter(iter_49_2.preview_widget)
				end

				var_49_51:force_hide_character()

				local var_49_52 = var_49_27.name
				local var_49_53, var_49_54, var_49_55, var_49_56 = arg_49_0:_get_hero_wield_info_by_item(var_49_26)

				arg_49_0:_spawn_hero_skin(var_49_51, var_49_53, var_49_56, var_49_52)

				iter_49_2.world_previewer = var_49_51
				var_49_19.is_loading = true
			elseif var_49_31 == "weapon_pose" then
				local var_49_57

				if var_0_23 then
					var_49_57 = MenuWorldPreviewer:new(arg_49_0.ingame_ui_context, UISettings.hero_skin_camera_position_by_character, "HeroViewStateLootindex" .. iter_49_1, var_0_23)
				else
					var_49_57 = MenuWorldPreviewer:new(arg_49_0.ingame_ui_context, UISettings.hero_skin_camera_position_by_character, "HeroViewStateLootindex" .. iter_49_1)

					var_49_57:on_enter(iter_49_2.preview_widget)
				end

				var_49_57:force_hide_character()

				local var_49_58, var_49_59, var_49_60, var_49_61 = arg_49_0:_get_hero_wield_info_by_item(var_49_26)

				arg_49_0:_spawn_hero_with_weapon_pose(var_49_57, var_49_58, var_49_61, var_49_26)

				iter_49_2.world_previewer = var_49_57
				var_49_19.is_loading = true
			elseif var_49_31 == "crafting_material" or var_49_31 == "deed" or var_49_31 == "trinket" or var_49_31 == "necklace" or var_49_31 == "ring" then
				local var_49_62

				if var_49_31 == "trinket" then
					var_49_62 = "loot_image_trinket"
				elseif var_49_31 == "necklace" then
					var_49_62 = "loot_image_jewellery"
				elseif var_49_31 == "ring" then
					var_49_62 = "loot_image_charm"
				elseif var_49_31 == "deed" then
					var_49_62 = "loot_image_deed"
				end

				if var_49_31 == "crafting_material" then
					local var_49_63 = var_49_0:get_item_amount(var_49_21)

					var_49_19.amount_text = "x" .. tostring(var_49_63)
				end

				local var_49_64 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_49_62)

				var_49_19.image = var_49_62
				var_49_20.image.texture_size[1] = var_49_64.size[1]
				var_49_20.image.texture_size[2] = var_49_64.size[2]
			elseif var_49_31 == "frame" then
				local var_49_65 = SPProfiles[arg_49_0.profile_index].careers[arg_49_0.career_index].portrait_image
				local var_49_66 = ItemMasterList[var_49_28].temporary_template
				local var_49_67 = "loot_option_" .. iter_49_1 .. "_center"
				local var_49_68 = 1.5

				iter_49_2.frame_widget = arg_49_0:_create_player_portrait(var_49_67, var_49_66, var_49_65, "", var_49_68)
			end

			var_49_2[#var_49_2 + 1] = iter_49_2
		end
	end

	arg_49_0._active_reward_options = var_49_2
	arg_49_0._present_reward_options = true

	arg_49_0:_set_background_blur_progress(1)

	local var_49_69 = true

	arg_49_0:_update_active_viewports(var_49_69)
end

function HeroViewStateLoot._update_active_viewports(arg_51_0, arg_51_1)
	if not var_0_23 then
		return
	end

	if not arg_51_0._viewports_dirty and not arg_51_1 then
		return
	end

	for iter_51_0 = 1, var_0_20 * 3 do
		local var_51_0 = arg_51_0._active_reward_options[iter_51_0]
		local var_51_1 = var_51_0 and var_51_0.item_previewer
		local var_51_2 = var_51_0 and var_51_0.world_previewer

		if var_51_1 then
			var_51_1:activate(false)
		elseif var_51_2 then
			var_51_2:activate(false)
		end

		if var_51_0 then
			var_51_0.preview_widget = nil
		end
	end

	local var_51_3 = arg_51_0._preview_loot_widgets

	for iter_51_1 = 1, #var_51_3 do
		local var_51_4 = var_51_3[iter_51_1]

		arg_51_0:_activate_widget_viewport(var_51_4, false)
	end

	local var_51_5 = arg_51_0._current_page_index
	local var_51_6 = 1 + (var_51_5 - 1) * 3

	for iter_51_2 = 1, 3 do
		local var_51_7 = iter_51_2 + (var_51_5 - 1) * 3
		local var_51_8 = arg_51_0._active_reward_options[var_51_7]
		local var_51_9 = var_51_8 and var_51_8.item_previewer
		local var_51_10 = var_51_8 and var_51_8.world_previewer
		local var_51_11 = var_51_3[iter_51_2]

		var_51_11.scenegraph_id = "loot_option_" .. var_51_7

		local var_51_12 = var_51_11.element.pass_data[1]
		local var_51_13 = var_51_12.viewport
		local var_51_14 = var_51_12.world

		if var_51_9 then
			var_51_9:activate(true, var_51_14, var_51_13, not arg_51_1)

			var_51_8.preview_widget = var_51_11
		elseif var_51_10 then
			var_51_10:activate(true, var_51_11)

			var_51_8.preview_widget = var_51_11
		end
	end

	arg_51_0._viewports_dirty = false
end

function HeroViewStateLoot._get_hero_wield_info_by_item(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_1.data.can_wield[1]

	for iter_52_0, iter_52_1 in ipairs(SPProfiles) do
		local var_52_1 = iter_52_1.careers

		for iter_52_2, iter_52_3 in ipairs(var_52_1) do
			if iter_52_3.name == var_52_0 then
				local var_52_2 = iter_52_1.display_name
				local var_52_3 = FindProfileIndex(var_52_2)
				local var_52_4 = iter_52_3.sort_order

				return var_52_2, var_52_3, var_52_0, var_52_4
			end
		end
	end
end

function HeroViewStateLoot._apply_color_to_glow_style(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_1.color
	local var_53_1 = arg_53_1.default_color

	var_53_0[1] = 0
	var_53_0[2] = arg_53_2[2]
	var_53_0[3] = arg_53_2[3]
	var_53_0[4] = arg_53_2[4]
	var_53_1[1] = arg_53_2[1]
	var_53_1[2] = arg_53_2[2]
	var_53_1[3] = arg_53_2[3]
	var_53_1[4] = arg_53_2[4]
end

function HeroViewStateLoot._spawn_hero_skin(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	local var_54_0 = callback(arg_54_0, "cb_hero_unit_spawned_skin_preview", arg_54_1, arg_54_2, arg_54_3)

	arg_54_1:request_spawn_hero_unit(arg_54_2, arg_54_3, false, var_54_0, 1, nil, arg_54_4)
end

function HeroViewStateLoot._spawn_hero_with_hat(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5)
	local var_55_0 = callback(arg_55_0, "cb_hero_unit_spawned_hat_preview", arg_55_1, arg_55_2, arg_55_3, arg_55_5)

	arg_55_1:request_spawn_hero_unit(arg_55_2, arg_55_3, false, var_55_0, 1, nil, arg_55_4)
end

function HeroViewStateLoot._spawn_hero_with_weapon_pose(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	local var_56_0 = callback(arg_56_0, "cb_hero_unit_spawned_weapon_pose_preview", arg_56_1, arg_56_2, arg_56_3, arg_56_4)

	arg_56_1:request_spawn_hero_unit(arg_56_2, arg_56_3, false, var_56_0, 1)
end

function HeroViewStateLoot.cb_hero_unit_spawned_weapon_pose_preview(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	local var_57_0 = FindProfileIndex(arg_57_2)
	local var_57_1 = SPProfiles[var_57_0].careers[arg_57_3]
	local var_57_2 = var_57_1.preview_idle_animation
	local var_57_3 = var_57_1.preview_wield_slot
	local var_57_4 = var_57_1.preview_items
	local var_57_5 = arg_57_4.data
	local var_57_6 = var_57_5.data.anim_event
	local var_57_7 = var_57_5.parent
	local var_57_8 = ItemMasterList[var_57_7]
	local var_57_9 = var_57_8.name
	local var_57_10 = var_57_8.slot_type

	if var_57_4 then
		arg_57_1:set_wielded_weapon_slot(var_57_10)

		for iter_57_0, iter_57_1 in ipairs(var_57_4) do
			local var_57_11 = iter_57_1.item_name
			local var_57_12 = ItemMasterList[var_57_11].slot_type

			if var_57_12 ~= var_57_10 then
				local var_57_13 = InventorySettings.slot_names_by_type[var_57_12][1]
				local var_57_14 = InventorySettings.slots_by_name[var_57_13]

				arg_57_1:equip_item(var_57_11, var_57_14)
			end
		end

		local var_57_15 = InventorySettings.slot_names_by_type[var_57_10][1]
		local var_57_16 = InventorySettings.slots_by_name[var_57_15]

		arg_57_1:equip_item(var_57_9, var_57_16)

		local var_57_17 = true

		arg_57_1:set_pose_animation(var_57_6, var_57_17)
	end
end

function HeroViewStateLoot.cb_hero_unit_spawned_skin_preview(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = FindProfileIndex(arg_58_2)
	local var_58_1 = SPProfiles[var_58_0].careers[arg_58_3]
	local var_58_2 = var_58_1.preview_idle_animation
	local var_58_3 = var_58_1.preview_wield_slot
	local var_58_4 = var_58_1.preview_items

	if var_58_4 then
		for iter_58_0, iter_58_1 in ipairs(var_58_4) do
			local var_58_5 = iter_58_1.item_name
			local var_58_6 = ItemMasterList[var_58_5].slot_type
			local var_58_7 = InventorySettings.slot_names_by_type[var_58_6][1]
			local var_58_8 = InventorySettings.slots_by_name[var_58_7]

			arg_58_1:equip_item(var_58_5, var_58_8)
		end

		if var_58_3 then
			arg_58_1:wield_weapon_slot(var_58_3)
		end
	end

	if var_58_2 then
		arg_58_1:play_character_animation(var_58_2)
	end
end

function HeroViewStateLoot.cb_hero_unit_spawned_hat_preview(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	local var_59_0 = FindProfileIndex(arg_59_2)
	local var_59_1 = SPProfiles[var_59_0].careers[arg_59_3]
	local var_59_2 = var_59_1.preview_idle_animation
	local var_59_3 = var_59_1.preview_wield_slot
	local var_59_4 = var_59_1.preview_items
	local var_59_5 = InventorySettings.slots_by_name.slot_hat

	arg_59_1:equip_item(arg_59_4, var_59_5)

	if var_59_4 then
		for iter_59_0, iter_59_1 in ipairs(var_59_4) do
			local var_59_6 = iter_59_1.item_name
			local var_59_7 = ItemMasterList[var_59_6].slot_type

			if var_59_7 ~= "melee" and var_59_7 ~= "ranged" and var_59_7 ~= "hat" then
				local var_59_8 = InventorySettings.slot_names_by_type[var_59_7][1]
				local var_59_9 = InventorySettings.slots_by_name[var_59_8]

				arg_59_1:equip_item(var_59_6, var_59_9)
			end
		end
	end
end

function HeroViewStateLoot._create_player_portrait(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5)
	local var_60_0 = UIWidgets.create_portrait_frame(arg_60_1, arg_60_2, arg_60_4, arg_60_5 or 1, nil, arg_60_3)

	return (UIWidget.init(var_60_0, arg_60_0.ui_top_renderer))
end

function HeroViewStateLoot._set_background_blur_progress(arg_61_0, arg_61_1)
	local var_61_0, var_61_1 = arg_61_0:get_viewport_world()
	local var_61_2 = World.get_data(var_61_0, "shading_environment")

	if var_61_2 then
		ShadingEnvironment.set_scalar(var_61_2, "fullscreen_blur_enabled", arg_61_1 * 1)
		ShadingEnvironment.set_scalar(var_61_2, "fullscreen_blur_amount", arg_61_1 * 0.75)
		ShadingEnvironment.apply(var_61_2)
	end
end

function HeroViewStateLoot.play_sound(arg_62_0, arg_62_1)
	arg_62_0.parent:play_sound(arg_62_1)
end

function HeroViewStateLoot._start_transition_animation(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = {
		wwise_world = arg_63_0.wwise_world,
		render_settings = arg_63_0.render_settings
	}
	local var_63_1 = {}
	local var_63_2 = arg_63_0.ui_animator:start_animation(arg_63_2, var_63_1, var_0_16, var_63_0)

	arg_63_0._animations[arg_63_1] = var_63_2
end

function HeroViewStateLoot._start_animation(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
	local var_64_0 = arg_64_4 or {
		wwise_world = arg_64_0.wwise_world
	}
	local var_64_1 = arg_64_0.ui_animator:start_animation(arg_64_2, arg_64_3, var_0_16, var_64_0)

	arg_64_0._animations[arg_64_1] = var_64_1

	return var_64_1
end

function HeroViewStateLoot._open_chest(arg_65_0, arg_65_1, arg_65_2)
	arg_65_0:_reset_camera()
	arg_65_0:set_reward_options_height_progress(0)
	arg_65_0:set_continue_button_animation_progress(0)

	local var_65_0 = Managers.backend:get_interface("loot")
	local var_65_1 = arg_65_0.hero_name
	local var_65_2 = arg_65_1.backend_id
	local var_65_3 = Managers.state.game_mode:game_mode_key()

	arg_65_0._open_loot_chest_id = var_65_0:open_loot_chest(var_65_1, var_65_2, var_65_3, arg_65_2)

	arg_65_0.menu_input_description:set_input_description(nil)

	arg_65_0._draw_input_desc_widgets = false
	arg_65_0._chest_zoom_in_duration = 0
	arg_65_0._chest_zoom_out_duration = nil

	if arg_65_0._chest_unit then
		local var_65_4 = "loot_chest_open"

		Unit.flow_event(arg_65_0._chest_unit, var_65_4)
	end

	local var_65_5 = arg_65_1.data

	var_0_37[1] = var_65_5.chest_category

	local var_65_6 = var_65_5.chest_categories or var_0_37
	local var_65_7 = var_65_5.chest_tier
	local var_65_8 = LootChestData.chests_by_category

	arg_65_0._opening_chest = true
	arg_65_0._rewards_presented = false

	local var_65_9

	for iter_65_0 = 1, #var_65_6 do
		local var_65_10 = var_65_6[iter_65_0]
		local var_65_11 = var_65_8[var_65_10]

		if var_65_11 then
			local var_65_12 = false
			local var_65_13 = var_65_11.chest_unit_names

			for iter_65_1, iter_65_2 in ipairs(var_65_13) do
				if iter_65_1 == var_65_7 then
					local var_65_14 = "play_gui_chest_open_" .. var_65_10 .. "_" .. tostring(iter_65_1)

					arg_65_0:play_sound(var_65_14)

					var_65_12 = true
				end
			end

			if var_65_12 then
				break
			end
		end
	end
end

function HeroViewStateLoot.loot_chest_opened(arg_66_0, arg_66_1)
	local var_66_0 = arg_66_0._selected_item
	local var_66_1

	var_66_1 = arg_66_1 and #arg_66_1

	if not BackendUtils.has_loot_chest() then
		local var_66_2 = arg_66_0.world_manager:world("level_world")

		LevelHelper:flow_event(var_66_2, "local_player_opened_all_loot_chests")
	end

	arg_66_0:_start_reward_presentation(arg_66_1)
end

function HeroViewStateLoot._start_reward_presentation(arg_67_0, arg_67_1)
	local var_67_0 = arg_67_0.ui_scenegraph

	for iter_67_0 = 1, var_0_20 do
		var_67_0["loot_option_" .. (iter_67_0 - 1) * 3 + 1].size[2] = 0
		var_67_0["loot_option_" .. (iter_67_0 - 1) * 3 + 2].size[2] = 0
		var_67_0["loot_option_" .. (iter_67_0 - 1) * 3 + 3].size[2] = 0
	end

	arg_67_0._chest_loot = arg_67_1

	arg_67_0:_setup_rewards(arg_67_0._chest_loot)

	arg_67_0._chest_presentation_active = true
	arg_67_0._num_rewards_opened = 0
	arg_67_0._last_selected_item = arg_67_0._selected_item
	arg_67_0._selected_item = nil
	arg_67_0._continue_button_animation_duration = 0

	arg_67_0:set_continue_button_animation_progress(0)
	arg_67_0:set_reward_options_height_progress(0)
end

function HeroViewStateLoot._animate_reward_options_entry(arg_68_0, arg_68_1)
	local var_68_0 = arg_68_0._reward_options_entry_progress

	if not var_68_0 then
		return
	end

	local var_68_1 = math.min(var_68_0 + arg_68_1, 1)

	arg_68_0:set_reward_options_height_progress(var_68_1)

	if var_68_1 == 1 then
		local var_68_2 = arg_68_0._active_reward_options
		local var_68_3 = math.ceil(#var_68_2 / 3)
		local var_68_4
		local var_68_5 = var_68_3 > 1 and "chest_opened_pages" or "chest_opened"

		arg_68_0._reward_options_entry_progress = nil

		arg_68_0.menu_input_description:set_input_description(var_0_15[var_68_5])

		arg_68_0._draw_input_desc_widgets = true
		arg_68_0._reward_option_animation_complete = true
	else
		arg_68_0._reward_options_entry_progress = var_68_1
	end
end

function HeroViewStateLoot.set_reward_options_height_progress(arg_69_0, arg_69_1)
	local var_69_0 = RESOLUTION_LOOKUP.res_w
	local var_69_1 = RESOLUTION_LOOKUP.res_h
	local var_69_2 = math.min(arg_69_1 * 1.1, 1)
	local var_69_3 = math.min(arg_69_1 * 1.3, 1)
	local var_69_4 = arg_69_1
	local var_69_5 = arg_69_0.ui_scenegraph

	for iter_69_0 = 1, var_0_20 do
		var_69_5["loot_option_" .. (iter_69_0 - 1) * 3 + 1].local_position[2] = -var_69_1 * (1 - math.catmullrom(math.easeOutCubic(var_69_2), 0, 0, 1, -1.8))
		var_69_5["loot_option_" .. (iter_69_0 - 1) * 3 + 2].local_position[2] = -var_69_1 * (1 - math.catmullrom(math.easeOutCubic(var_69_3), 0, 0, 1, -1.8))
		var_69_5["loot_option_" .. (iter_69_0 - 1) * 3 + 3].local_position[2] = -var_69_1 * (1 - math.catmullrom(math.easeOutCubic(var_69_4), 0, 0, 1, -1.8))
	end
end

function HeroViewStateLoot._unload_loaded_packages(arg_70_0)
	if arg_70_0._loaded_package then
		arg_70_0:_unload_package(arg_70_0._loaded_package)

		arg_70_0._loaded_package = nil
	end

	if arg_70_0._package_loading then
		arg_70_0:_unload_package(arg_70_0._package_loading)

		arg_70_0._package_loading = nil
	end
end

function HeroViewStateLoot._destroy_chest_unit(arg_71_0)
	if arg_71_0._chest_unit then
		local var_71_0 = arg_71_0:get_viewport_world()

		World.destroy_unit(var_71_0, arg_71_0._chest_unit)

		arg_71_0._chest_unit = nil
	end
end

function HeroViewStateLoot._load_package(arg_72_0, arg_72_1)
	arg_72_0:_destroy_chest_unit()
	arg_72_0:_unload_loaded_packages()

	arg_72_0._package_loading = arg_72_1

	local var_72_0 = Managers.package
	local var_72_1 = callback(arg_72_0, "_on_load_complete", arg_72_1)
	local var_72_2 = "HeroViewStateLoot"

	var_72_0:load(arg_72_1, var_72_2, var_72_1, true)
end

function HeroViewStateLoot._on_load_complete(arg_73_0, arg_73_1)
	arg_73_0:play_sound(arg_73_0._sound_event)
	arg_73_0:_spawn_chest_unit(arg_73_0._unit_to_spawn, nil, nil)

	arg_73_0._loaded_package = arg_73_1
	arg_73_0._package_loading = nil
end

function HeroViewStateLoot._unload_package(arg_74_0, arg_74_1)
	local var_74_0 = "HeroViewStateLoot"

	Managers.package:unload(arg_74_1, var_74_0)
end

function HeroViewStateLoot._spawn_chest_unit(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
	local var_75_0 = arg_75_0:get_viewport_world()

	if arg_75_0._chest_unit then
		World.destroy_unit(var_75_0, arg_75_0._chest_unit)
	end

	local var_75_1 = World.spawn_unit(var_75_0, arg_75_1, Vector3(0, 0, 10))
	local var_75_2 = arg_75_0:get_world_link_unit()

	World.link_unit(var_75_0, var_75_1, 0, var_75_2, 0)

	if arg_75_2 then
		local var_75_3 = "loot_chest_init"

		Unit.flow_event(var_75_1, var_75_3)

		arg_75_0._camera_shake_chest_spawn_duration = nil
	else
		local var_75_4 = "loot_chest_enter"

		Unit.flow_event(var_75_1, var_75_4)

		arg_75_0._camera_shake_chest_spawn_duration = 0
	end

	arg_75_0._chest_unit = var_75_1
end

function HeroViewStateLoot.get_world_link_unit(arg_76_0)
	local var_76_0 = var_0_13.style.viewport.level_name
	local var_76_1 = arg_76_0.viewport_widget.element.pass_data[1].world
	local var_76_2 = ScriptWorld.level(var_76_1, var_76_0)

	if var_76_2 then
		local var_76_3 = Level.units(var_76_2)

		for iter_76_0, iter_76_1 in ipairs(var_76_3) do
			local var_76_4 = Unit.get_data(iter_76_1, "name")

			if var_76_4 and var_76_4 == "loot_chest_spawn" then
				return iter_76_1
			end
		end
	end
end

function HeroViewStateLoot.set_camera_zoom(arg_77_0, arg_77_1)
	local var_77_0 = arg_77_0._camera_pose:unbox()
	local var_77_1 = Matrix4x4.translation(var_77_0)
	local var_77_2 = Matrix4x4.rotation(var_77_0)
	local var_77_3 = 0.5 * arg_77_1
	local var_77_4 = var_77_1 + Quaternion.forward(var_77_2) * var_77_3

	arg_77_0:set_camera_position(var_77_4)
end

function HeroViewStateLoot.set_grid_animation_progress(arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0.ui_scenegraph

	var_78_0.info_root.local_position[1] = 400 * arg_78_1
	var_78_0.item_grid_root.local_position[1] = -400 * arg_78_1
	var_78_0.open_buttons_pivot.local_position[2] = 30 - 200 * arg_78_1
	var_78_0.close_button.local_position[2] = 30 - 200 * arg_78_1
	arg_78_0._grid_alpha_multiplier = 1 - arg_78_1
end

function HeroViewStateLoot.set_continue_button_animation_progress(arg_79_0, arg_79_1)
	arg_79_0.ui_scenegraph.continue_button.local_position[2] = -170 + 200 * arg_79_1
	arg_79_0._continue_button_alpha_multiplier = arg_79_1
	arg_79_0._continue_button_progress = arg_79_1
end

function HeroViewStateLoot.set_chest_title_alpha_progress(arg_80_0, arg_80_1)
	local var_80_0 = arg_80_0._widgets_by_name
	local var_80_1 = 255 * arg_80_1

	var_80_0.chest_title.style.text.text_color[1] = var_80_1
	var_80_0.chest_title.style.text_shadow.text_color[1] = var_80_1
	var_80_0.chest_sub_title.style.text.text_color[1] = var_80_1
	var_80_0.chest_sub_title.style.text_shadow.text_color[1] = var_80_1
	arg_80_0._chest_title_alpha_progress = arg_80_1
end

function HeroViewStateLoot._update_enter_animation_time(arg_81_0, arg_81_1, arg_81_2)
	local var_81_0 = arg_81_0._enter_animation_duration

	if not var_81_0 then
		return
	end

	local var_81_1 = var_81_0 + arg_81_1
	local var_81_2 = math.min(var_81_1 / var_0_29, 1)
	local var_81_3 = math.easeOutCubic(var_81_2)

	arg_81_0:set_grid_animation_progress(1 - var_81_3)

	if var_81_2 == 1 then
		arg_81_0._enter_animation_duration = nil
	else
		arg_81_0._enter_animation_duration = var_81_1
	end
end

function HeroViewStateLoot._update_continue_button_animation_time(arg_82_0, arg_82_1, arg_82_2)
	local var_82_0 = arg_82_0._continue_button_animation_duration

	if not var_82_0 then
		return
	end

	local var_82_1 = var_82_0 + arg_82_1
	local var_82_2 = math.min(var_82_1 / var_0_29, 1)
	local var_82_3 = math.easeOutCubic(var_82_2)

	arg_82_0:set_continue_button_animation_progress(var_82_3)

	if var_82_2 == 1 then
		arg_82_0._continue_button_animation_duration = nil
	else
		arg_82_0._continue_button_animation_duration = var_82_1
	end
end

function HeroViewStateLoot._update_camera_look_up_time(arg_83_0, arg_83_1, arg_83_2)
	local var_83_0 = arg_83_0._camera_look_up_duration

	if not var_83_0 then
		return
	end

	local var_83_1 = math.min(var_83_0 / var_0_30, 1)
	local var_83_2 = math.easeCubic(var_83_1)
	local var_83_3 = var_83_0 + arg_83_1
	local var_83_4 = math.min(var_83_3 / var_0_30, 1)
	local var_83_5 = math.easeCubic(var_83_4)
	local var_83_6 = 60
	local var_83_7 = math.degrees_to_radians(var_83_6 * var_83_2)
	local var_83_8 = math.degrees_to_radians(var_83_6 * var_83_5)

	arg_83_0._camera_look_up_progress = var_83_4

	local var_83_9 = Quaternion(Vector3.right(), var_83_8 - var_83_7)
	local var_83_10 = arg_83_0:get_camera_rotation()
	local var_83_11 = Quaternion.multiply(var_83_10, var_83_9)

	arg_83_0:set_camera_rotation(var_83_11)

	arg_83_0.background_fade_widget.style.rect.color[1] = var_83_5 * 200

	if var_83_4 == 1 then
		if arg_83_0._chest_unit then
			Unit.set_unit_visibility(arg_83_0._chest_unit, false)
		end

		arg_83_0._camera_look_up_duration = nil
	else
		arg_83_0._camera_look_up_duration = var_83_3
	end
end

function HeroViewStateLoot._update_camera_look_down_time(arg_84_0, arg_84_1, arg_84_2)
	local var_84_0 = arg_84_0._camera_look_down_duration

	if not var_84_0 then
		return
	end

	local var_84_1 = math.min(var_84_0 / var_0_31, 1)
	local var_84_2 = math.easeOutCubic(var_84_1)
	local var_84_3 = var_84_0 + arg_84_1
	local var_84_4 = math.min(var_84_3 / var_0_31, 1)
	local var_84_5 = math.easeOutCubic(var_84_4)
	local var_84_6 = -60
	local var_84_7 = math.degrees_to_radians(var_84_6 * var_84_2)
	local var_84_8 = math.degrees_to_radians(var_84_6 * var_84_5)
	local var_84_9 = Quaternion(Vector3.right(), var_84_8 - var_84_7)
	local var_84_10 = arg_84_0:get_camera_rotation()
	local var_84_11 = Quaternion.multiply(var_84_10, var_84_9)

	arg_84_0:set_camera_rotation(var_84_11)

	arg_84_0.background_fade_widget.style.rect.color[1] = (1 - var_84_5) * 200

	if var_84_4 == 1 then
		arg_84_0._camera_look_down_duration = nil
		arg_84_0._camera_look_up_progress = 0
	else
		arg_84_0._camera_look_down_duration = var_84_3
	end
end

function HeroViewStateLoot._reset_camera(arg_85_0)
	arg_85_0._camera_look_down_duration = nil
	arg_85_0._camera_look_up_progress = 0
	arg_85_0.background_fade_widget.style.rect.color[1] = 0

	arg_85_0:_position_camera()
end

function HeroViewStateLoot._update_chest_open_wait_time(arg_86_0, arg_86_1, arg_86_2)
	local var_86_0 = arg_86_0._chest_open_wait_duration

	if not var_86_0 then
		return
	end

	local var_86_1 = var_86_0 + arg_86_1
	local var_86_2 = math.min(var_86_1 / var_0_27, 1)
	local var_86_3 = math.easeOutCubic(var_86_2)

	if var_86_2 == 1 then
		arg_86_0._camera_look_up_duration = 0
		arg_86_0._reward_options_entry_progress = 0

		arg_86_0:play_sound("play_gui_chest_reward_enter")

		arg_86_0._chest_open_wait_duration = nil
	else
		arg_86_0._chest_open_wait_duration = var_86_1
	end
end

function HeroViewStateLoot._update_chest_zoom_in_time(arg_87_0, arg_87_1, arg_87_2)
	local var_87_0 = arg_87_0._chest_zoom_in_duration

	if not var_87_0 then
		return
	end

	local var_87_1 = var_87_0 + arg_87_1
	local var_87_2 = math.min(var_87_1 / var_0_28, 1)
	local var_87_3 = math.easeOutCubic(var_87_2)

	arg_87_0:set_camera_zoom(var_87_3)
	arg_87_0:set_grid_animation_progress(var_87_3)
	arg_87_0:set_chest_title_alpha_progress(1 - var_87_3)

	if var_87_2 == 1 then
		arg_87_0._chest_zoom_in_duration = nil
		arg_87_0._chest_open_wait_duration = 0
	else
		arg_87_0._chest_zoom_in_duration = var_87_1
	end
end

function HeroViewStateLoot._update_chest_zoom_out_time(arg_88_0, arg_88_1, arg_88_2)
	local var_88_0 = arg_88_0._chest_zoom_out_duration

	if not var_88_0 then
		return
	end

	local var_88_1 = var_88_0 + arg_88_1
	local var_88_2 = 1 - math.min(var_88_1 / var_0_29, 1)
	local var_88_3 = math.easeInCubic(var_88_2)

	arg_88_0:set_camera_zoom(var_88_3)
	arg_88_0:set_grid_animation_progress(var_88_3)

	if var_88_2 == 0 then
		arg_88_0._chest_zoom_out_duration = nil
	else
		arg_88_0._chest_zoom_out_duration = var_88_1
	end
end

function HeroViewStateLoot._update_camera_shake_chest_spawn_time(arg_89_0, arg_89_1, arg_89_2)
	local var_89_0 = arg_89_0._camera_shake_chest_spawn_duration

	if not var_89_0 then
		return
	end

	local var_89_1 = var_89_0 + arg_89_1

	if math.min(var_89_1 / var_0_26, 1) == 1 then
		arg_89_0._camera_shake_chest_spawn_duration = nil

		arg_89_0:add_camera_shake(var_0_24, arg_89_2, 1)
	else
		arg_89_0._camera_shake_chest_spawn_duration = var_89_1
	end
end

function HeroViewStateLoot.add_camera_shake(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	local var_90_0 = {}
	local var_90_1 = arg_90_0:get_camera_rotation()
	local var_90_2 = arg_90_1 or var_0_25
	local var_90_3 = var_90_2.duration
	local var_90_4 = var_90_2.fade_in
	local var_90_5 = var_90_2.fade_out
	local var_90_6 = (var_90_3 or 0) + (var_90_4 or 0) + (var_90_5 or 0)

	var_90_0.shake_settings = var_90_2
	var_90_0.start_time = arg_90_2
	var_90_0.end_time = var_90_6 and arg_90_2 + var_90_6
	var_90_0.fade_in_time = var_90_4 and arg_90_2 + var_90_4
	var_90_0.fade_out_time = var_90_5 and var_90_0.end_time - var_90_5
	var_90_0.seed = var_90_2.seed or Math.random(1, 100)
	var_90_0.scale = arg_90_3 or 1
	var_90_0.camera_rotation_boxed = QuaternionBox(var_90_1)
	arg_90_0._active_camera_shakes = {
		[var_90_0] = true
	}
end

function HeroViewStateLoot._apply_shake_event(arg_91_0, arg_91_1, arg_91_2)
	local var_91_0 = arg_91_1.start_time
	local var_91_1 = arg_91_1.end_time
	local var_91_2 = arg_91_1.fade_in_time
	local var_91_3 = arg_91_1.fade_out_time

	if var_91_2 and arg_91_2 <= var_91_2 then
		arg_91_1.fade_progress = math.clamp((arg_91_2 - var_91_0) / (var_91_2 - var_91_0), 0, 1)
	elseif var_91_3 and var_91_3 <= arg_91_2 then
		arg_91_1.fade_progress = math.clamp((var_91_1 - arg_91_2) / (var_91_1 - var_91_3), 0, 1)
	end

	local var_91_4 = arg_91_0:_calculate_perlin_value(arg_91_2 - arg_91_1.start_time, arg_91_1) * arg_91_1.scale
	local var_91_5 = arg_91_0:_calculate_perlin_value(arg_91_2 - arg_91_1.start_time + 10, arg_91_1) * arg_91_1.scale
	local var_91_6 = arg_91_1.camera_rotation_boxed:unbox()
	local var_91_7 = math.pi / 180
	local var_91_8 = Quaternion(Vector3.up(), var_91_5 * var_91_7)
	local var_91_9 = Quaternion(Vector3.right(), var_91_4 * var_91_7)
	local var_91_10 = Quaternion.multiply(var_91_8, var_91_9)
	local var_91_11 = Quaternion.multiply(var_91_6, var_91_10)

	arg_91_0:set_camera_rotation(var_91_11)

	if arg_91_1.end_time and arg_91_2 >= arg_91_1.end_time then
		arg_91_0._active_camera_shakes[arg_91_1] = nil
	end
end

function HeroViewStateLoot._calculate_perlin_value(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = 0
	local var_92_1 = arg_92_2.shake_settings
	local var_92_2 = var_92_1.persistance
	local var_92_3 = var_92_1.octaves

	for iter_92_0 = 0, var_92_3 do
		local var_92_4 = 2^iter_92_0
		local var_92_5 = var_92_2^iter_92_0

		var_92_0 = var_92_0 + arg_92_0:_interpolated_noise(arg_92_1 * var_92_4, arg_92_2) * var_92_5
	end

	local var_92_6 = var_92_1.amplitude or 1
	local var_92_7 = arg_92_2.fade_progress or 1

	return var_92_0 * var_92_6 * var_92_7
end

function HeroViewStateLoot._interpolated_noise(arg_93_0, arg_93_1, arg_93_2)
	local var_93_0 = math.floor(arg_93_1)
	local var_93_1 = arg_93_1 - var_93_0
	local var_93_2 = arg_93_0:_smoothed_noise(var_93_0, arg_93_2)
	local var_93_3 = arg_93_0:_smoothed_noise(var_93_0 + 1, arg_93_2)

	return math.lerp(var_93_2, var_93_3, var_93_1)
end

function HeroViewStateLoot._smoothed_noise(arg_94_0, arg_94_1, arg_94_2)
	return arg_94_0:_noise(arg_94_1, arg_94_2) / 2 + arg_94_0:_noise(arg_94_1 - 1, arg_94_2) / 4 + arg_94_0:_noise(arg_94_1 + 1, arg_94_2) / 4
end

function HeroViewStateLoot._noise(arg_95_0, arg_95_1, arg_95_2)
	local var_95_0, var_95_1 = Math.next_random(arg_95_1 + arg_95_2.seed)
	local var_95_2, var_95_3 = Math.next_random(var_95_0)

	return var_95_3 * 2 - 1
end

function HeroViewStateLoot._get_card_spawn_position(arg_96_0)
	local var_96_0 = arg_96_0:get_camera_position()
	local var_96_1 = arg_96_0:get_camera_rotation()
	local var_96_2 = Quaternion.forward(var_96_1)
	local var_96_3 = arg_96_0:get_world_link_unit()
	local var_96_4 = Unit.world_position(var_96_3, 0)

	var_96_4.x = var_96_0.x
	var_96_4.z = var_96_4.z - 0.12
	var_96_4.y = var_96_4.y

	return var_96_4
end

function HeroViewStateLoot._create_portrait_frame_widget(arg_97_0, arg_97_1, arg_97_2, arg_97_3)
	local var_97_0 = UIWidgets.create_portrait_frame("info_portrait_root", arg_97_1, arg_97_3, 1, nil, arg_97_2)
	local var_97_1 = UIWidget.init(var_97_0, arg_97_0.ui_top_renderer)

	var_97_1.content.frame_settings_name = arg_97_1

	return var_97_1
end

function HeroViewStateLoot._setup_info_window(arg_98_0)
	local var_98_0 = arg_98_0.hero_name
	local var_98_1 = arg_98_0.career_index
	local var_98_2 = arg_98_0.profile_index
	local var_98_3 = SPProfiles[var_98_2]
	local var_98_4 = var_98_3.character_name
	local var_98_5 = var_98_3.careers[var_98_1].portrait_image
	local var_98_6 = arg_98_0.player
	local var_98_7 = var_98_6.player_unit
	local var_98_8 = ExperienceSettings.get_player_level(var_98_6)
	local var_98_9 = var_98_8 and tostring(var_98_8) or "-"
	local var_98_10 = "default"

	arg_98_0._portrait_widget = arg_98_0:_create_portrait_frame_widget(var_98_10, var_98_5, var_98_9)
	arg_98_0._widgets_by_name.info_text_title.content.text = Localize(var_98_4)
end

function HeroViewStateLoot._handle_gamepad_activity(arg_99_0)
	local var_99_0 = Managers.input:is_device_active("gamepad")
	local var_99_1 = arg_99_0.gamepad_active_last_frame == nil

	if var_99_0 then
		if not arg_99_0.gamepad_active_last_frame or var_99_1 then
			arg_99_0.gamepad_active_last_frame = true

			arg_99_0:_set_gamepad_input_buttons_visibility(true)
		end
	elseif arg_99_0.gamepad_active_last_frame or var_99_1 then
		arg_99_0.gamepad_active_last_frame = false

		arg_99_0:_set_gamepad_input_buttons_visibility(false)
	end
end
