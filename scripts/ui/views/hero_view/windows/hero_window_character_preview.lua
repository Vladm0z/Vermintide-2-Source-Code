-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_character_preview.lua

require("scripts/ui/views/menu_world_previewer")
require("scripts/settings/hero_statistics_template")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_character_preview_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.viewport_widget
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.camera_position_by_character
local var_0_6 = var_0_0.loading_overlay_widgets
local var_0_7 = false

HeroWindowCharacterPreview = class(HeroWindowCharacterPreview)
HeroWindowCharacterPreview.NAME = "HeroWindowCharacterPreview"

HeroWindowCharacterPreview.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCharacterPreview")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ingame_ui_context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.skin_sync_id = arg_1_0.parent.skin_sync_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_show_weapon_disclaimer(false)

	if Managers.mechanism:mechanism_setting("should_display_weapon_disclaimer") then
		arg_1_0:_show_weapon_disclaimer(true)
	end
end

HeroWindowCharacterPreview.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	if arg_2_0._viewport_widget then
		UIWidget.destroy(arg_2_0.ui_renderer, arg_2_0._viewport_widget)

		arg_2_0._viewport_widget = nil
	end

	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	local var_2_3 = {}
	local var_2_4 = {}

	for iter_2_2, iter_2_3 in pairs(var_0_6) do
		local var_2_5 = UIWidget.init(iter_2_3)

		var_2_3[#var_2_3 + 1] = var_2_5
		var_2_4[iter_2_2] = var_2_5
	end

	arg_2_0._loading_overlay_widgets = var_2_3
	arg_2_0._loading_overlay_widgets_by_name = var_2_4

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_4)

	if arg_2_2 then
		local var_2_6 = arg_2_0.ui_scenegraph.window.local_position

		var_2_6[1] = var_2_6[1] + arg_2_2[1]
		var_2_6[2] = var_2_6[2] + arg_2_2[2]
		var_2_6[3] = var_2_6[3] + arg_2_2[3]
	end

	arg_2_0._level_package_name = var_0_2.style.viewport.level_package_name

	local var_2_7
	local var_2_8 = true

	Managers.package:load(arg_2_0._level_package_name, "HeroWindowCharacterPreview", var_2_7, var_2_8)

	arg_2_0._show_loading_overlay = true

	if not Development.parameter("hero_statistics") then
		var_2_1.detailed.content.visible = false
	end
end

HeroWindowCharacterPreview.on_exit = function (arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCharacterPreview")

	arg_3_0.ui_animator = nil

	if arg_3_0.world_previewer then
		arg_3_0.world_previewer:prepare_exit()
		arg_3_0.world_previewer:on_exit()
		arg_3_0.world_previewer:destroy()
	end

	if arg_3_0._viewport_widget then
		UIWidget.destroy(arg_3_0.ui_renderer, arg_3_0._viewport_widget)

		arg_3_0._viewport_widget = nil
	end

	Managers.package:unload(arg_3_0._level_package_name, "HeroWindowCharacterPreview")

	arg_3_0._level_package_name = nil
end

HeroWindowCharacterPreview.update = function (arg_4_0, arg_4_1, arg_4_2)
	if var_0_7 then
		var_0_7 = false

		arg_4_0:create_ui_elements()
	end

	if arg_4_0.world_previewer and arg_4_0.hero_unit_spawned then
		arg_4_0:_handle_input(arg_4_1, arg_4_2)

		local var_4_0 = arg_4_0.parent:window_input_service()

		arg_4_0:_update_statistics_widget(var_4_0, arg_4_1)
	end

	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:draw(arg_4_1)

	if arg_4_0.world_previewer then
		local var_4_1 = arg_4_0:_statistics_activate()

		arg_4_0.world_previewer:update(arg_4_1, arg_4_2, var_4_1)
	end
end

HeroWindowCharacterPreview.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0._viewport_widget and Managers.package:has_loaded(arg_5_0._level_package_name, "HeroWindowCharacterPreview") then
		arg_5_0._viewport_widget = UIWidget.init(var_0_2)
		arg_5_0._fadeout_loading_overlay = true
	end

	arg_5_0:_update_loading_overlay_fadeout_animation(arg_5_1)

	if not arg_5_0.initialized and arg_5_0._viewport_widget then
		local var_5_0 = MenuWorldPreviewer:new(arg_5_0.ingame_ui_context, var_0_5, "HeroWindowCharacterPreview")

		local function var_5_1()
			arg_5_0.hero_unit_spawned = true
		end

		arg_5_0.hero_unit_spawned = false

		var_5_0:on_enter(arg_5_0._viewport_widget, arg_5_0.hero_name)
		var_5_0:request_spawn_hero_unit(arg_5_0.hero_name, arg_5_0.career_index, false, var_5_1)

		arg_5_0.world_previewer = var_5_0
		arg_5_0.initialized = true
	end

	if arg_5_0.world_previewer then
		if arg_5_0.hero_unit_spawned then
			arg_5_0:_update_skin_sync()
			arg_5_0:_update_loadout_sync()
			arg_5_0:_update_wielded_slot()
		end

		arg_5_0.world_previewer:post_update(arg_5_1, arg_5_2)
	end
end

local var_0_8 = -1

HeroWindowCharacterPreview.respawn_hero = function (arg_7_0)
	local var_7_0 = arg_7_0.world_previewer

	if not var_7_0 then
		return
	end

	arg_7_0.hero_unit_spawned = false

	local function var_7_1()
		arg_7_0.hero_unit_spawned = true
		arg_7_0._loadout_sync_id = var_0_8

		arg_7_0:_update_loadout_sync()

		arg_7_0._selected_loadout_slot_index = var_0_8

		arg_7_0:_update_wielded_slot()
	end

	var_7_0:respawn_hero_unit(arg_7_0.hero_name, arg_7_0.career_index, false, var_7_1)
end

HeroWindowCharacterPreview._update_animations = function (arg_9_0, arg_9_1)
	arg_9_0.ui_animator:update(arg_9_1)

	local var_9_0 = arg_9_0._animations
	local var_9_1 = arg_9_0.ui_animator

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if var_9_1:is_animation_completed(iter_9_1) then
			var_9_1:stop_animation(iter_9_1)

			var_9_0[iter_9_0] = nil
		end
	end

	local var_9_2 = arg_9_0._widgets_by_name
end

HeroWindowCharacterPreview._update_loadout_sync = function (arg_10_0)
	local var_10_0 = arg_10_0.parent.loadout_sync_id

	if var_10_0 ~= arg_10_0._loadout_sync_id then
		arg_10_0:_populate_loadout()

		arg_10_0._loadout_sync_id = var_10_0

		arg_10_0:_sync_statistics()
	end
end

HeroWindowCharacterPreview._update_skin_sync = function (arg_11_0)
	local var_11_0 = arg_11_0.parent.skin_sync_id

	if var_11_0 ~= arg_11_0.skin_sync_id then
		arg_11_0:respawn_hero()

		arg_11_0.skin_sync_id = var_11_0
	end
end

HeroWindowCharacterPreview._update_wielded_slot = function (arg_12_0)
	local var_12_0 = arg_12_0.parent:get_selected_loadout_slot_index()

	if var_12_0 ~= arg_12_0._selected_loadout_slot_index then
		local var_12_1 = InventorySettings.slots_by_slot_index

		for iter_12_0, iter_12_1 in pairs(var_12_1) do
			if iter_12_1.slot_index == var_12_0 then
				local var_12_2 = iter_12_1.type

				if var_12_2 == "melee" or var_12_2 == "ranged" then
					arg_12_0.world_previewer:wield_weapon_slot(var_12_2)

					break
				end
			end
		end

		if not arg_12_0.world_previewer:wielded_slot_type() then
			arg_12_0.world_previewer:wield_weapon_slot("melee")
		end

		arg_12_0._selected_loadout_slot_index = var_12_0
	end
end

HeroWindowCharacterPreview._populate_loadout = function (arg_13_0)
	local var_13_0 = arg_13_0.world_previewer
	local var_13_1 = arg_13_0.hero_name
	local var_13_2 = InventorySettings.slots_by_slot_index
	local var_13_3 = arg_13_0.career_index
	local var_13_4 = FindProfileIndex(var_13_1)
	local var_13_5 = SPProfiles[var_13_4].careers[var_13_3].name

	for iter_13_0, iter_13_1 in pairs(var_13_2) do
		local var_13_6 = iter_13_1.name
		local var_13_7 = BackendUtils.get_loadout_item(var_13_5, var_13_6)

		if var_13_7 then
			local var_13_8 = var_13_7.data.name
			local var_13_9 = iter_13_1.type
			local var_13_10 = var_13_0:item_name_by_slot_type(var_13_9)

			if var_13_8 and var_13_8 ~= var_13_10 or var_13_9 == "melee" or var_13_9 == "ranged" then
				local var_13_11 = var_13_7.backend_id

				var_13_0:equip_item(var_13_8, iter_13_1, var_13_11)
			end
		end
	end
end

HeroWindowCharacterPreview._is_button_pressed = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.content.button_hotspot

	if var_14_0.on_release then
		var_14_0.on_release = false

		return true
	end
end

HeroWindowCharacterPreview._is_stepper_button_pressed = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.content
	local var_15_1 = var_15_0.button_hotspot_left
	local var_15_2 = var_15_0.button_hotspot_right

	if var_15_1.on_release then
		var_15_1.on_release = false

		return true, -1
	elseif var_15_2.on_release then
		var_15_2.on_release = false

		return true, 1
	end
end

HeroWindowCharacterPreview._handle_input = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._widgets_by_name.detailed

	if arg_16_0:_is_button_pressed(var_16_0) then
		arg_16_0:_handle_statistics_pressed()
	end
end

HeroWindowCharacterPreview._exit = function (arg_17_0, arg_17_1)
	arg_17_0.exit = true
	arg_17_0.exit_level_id = arg_17_1
end

HeroWindowCharacterPreview.draw = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.ui_renderer
	local var_18_1 = arg_18_0.ui_top_renderer
	local var_18_2 = arg_18_0.ui_scenegraph
	local var_18_3 = arg_18_0.parent:window_input_service()

	UIRenderer.begin_pass(var_18_1, var_18_2, var_18_3, arg_18_1, nil, arg_18_0.render_settings)

	for iter_18_0, iter_18_1 in ipairs(arg_18_0._widgets) do
		UIRenderer.draw_widget(var_18_1, iter_18_1)
	end

	if arg_18_0._show_loading_overlay then
		for iter_18_2, iter_18_3 in ipairs(arg_18_0._loading_overlay_widgets) do
			UIRenderer.draw_widget(var_18_1, iter_18_3)
		end
	end

	UIRenderer.end_pass(var_18_1)

	if arg_18_0._viewport_widget then
		UIRenderer.begin_pass(var_18_0, var_18_2, var_18_3, arg_18_1, nil, arg_18_0.render_settings)
		UIRenderer.draw_widget(var_18_0, arg_18_0._viewport_widget)
		UIRenderer.end_pass(var_18_0)
	end
end

HeroWindowCharacterPreview._play_sound = function (arg_19_0, arg_19_1)
	arg_19_0.parent:play_sound(arg_19_1)
end

HeroWindowCharacterPreview._update_loading_overlay_fadeout_animation = function (arg_20_0, arg_20_1)
	if not arg_20_0._fadeout_loading_overlay then
		return
	end

	local var_20_0 = arg_20_0._loading_overlay_widgets_by_name
	local var_20_1 = 255
	local var_20_2 = 0
	local var_20_3 = 9
	local var_20_4 = math.min(1, (arg_20_0._fadeout_progress or 0) + var_20_3 * arg_20_1)
	local var_20_5 = math.lerp(var_20_1, var_20_2, math.easeInCubic(var_20_4))
	local var_20_6 = var_20_0.loading_overlay
	local var_20_7 = var_20_0.loading_overlay_loading_glow
	local var_20_8 = var_20_0.loading_overlay_loading_frame

	var_20_6.style.rect.color[1] = var_20_5
	var_20_7.style.texture_id.color[1] = var_20_5
	var_20_8.style.texture_id.color[1] = var_20_5
	arg_20_0._fadeout_progress = var_20_4

	if var_20_4 == 1 then
		arg_20_0._fadeout_loading_overlay = nil
		arg_20_0._fadeout_progress = nil
		arg_20_0._show_loading_overlay = false
	end
end

HeroWindowCharacterPreview._handle_statistics_pressed = function (arg_21_0)
	local var_21_0 = arg_21_0._widgets_by_name.detailed

	if var_21_0.content.active then
		arg_21_0:_deactivate_statistics()
	else
		arg_21_0:_activate_statistics(var_21_0)
	end
end

HeroWindowCharacterPreview._statistics_activate = function (arg_22_0)
	return arg_22_0._widgets_by_name.detailed.content.active
end

HeroWindowCharacterPreview._activate_statistics = function (arg_23_0)
	local var_23_0 = arg_23_0._widgets_by_name.detailed

	var_23_0.content.active = true
	var_23_0.content.list_content.active = true

	if var_23_0.content.scrollbar.percentage < 1 then
		var_23_0.content.scrollbar.active = true
	else
		var_23_0.content.scrollbar.active = false
	end

	var_23_0.style.drop_down_arrow.angle = math.pi

	arg_23_0:_sync_statistics()
end

HeroWindowCharacterPreview._sync_statistics = function (arg_24_0)
	if not arg_24_0:_statistics_activate() then
		return
	end

	local var_24_0 = HeroStatisticsTemplate
	local var_24_1 = UIUtils.get_hero_statistics_by_template(var_24_0)

	arg_24_0:_populate_statistics(var_24_1)
end

HeroWindowCharacterPreview._deactivate_statistics = function (arg_25_0)
	local var_25_0 = arg_25_0._widgets_by_name.detailed

	var_25_0.content.active = false
	var_25_0.content.list_content.active = false
	var_25_0.content.scrollbar.active = false
	var_25_0.style.drop_down_arrow.angle = 0
end

HeroWindowCharacterPreview._update_statistics_widget = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._widgets_by_name.detailed

	if not var_26_0.content.active then
		return
	end

	local var_26_1 = var_0_3.detailed_button.size
	local var_26_2 = var_0_3.detailed_list.size
	local var_26_3 = var_26_0.style.list_style
	local var_26_4 = var_26_3.list_member_offset[2]
	local var_26_5 = var_26_3.num_draws
	local var_26_6

	if var_26_5 == 0 then
		var_26_6 = math.abs(var_26_4)
	else
		var_26_6 = math.abs(var_26_4 * var_26_5)
	end

	local var_26_7 = math.max(var_26_6 - var_26_2[2], 0)
	local var_26_8 = var_26_3.scenegraph_id
	local var_26_9 = arg_26_0.ui_scenegraph[var_26_8].local_position
	local var_26_10 = 1 - var_26_0.content.scrollbar.scroll_value

	var_26_9[2] = -var_26_1[2] + var_26_7 * var_26_10
end

HeroWindowCharacterPreview._populate_statistics = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._widgets_by_name.detailed
	local var_27_1 = var_27_0.content
	local var_27_2 = var_27_0.style.list_style
	local var_27_3 = var_27_1.list_content
	local var_27_4 = var_27_2.item_styles
	local var_27_5 = #arg_27_1

	for iter_27_0 = 1, var_27_5 do
		local var_27_6 = arg_27_1[iter_27_0]
		local var_27_7 = ""
		local var_27_8 = ""
		local var_27_9 = ""
		local var_27_10 = ""
		local var_27_11 = ""
		local var_27_12 = var_27_6.type

		if var_27_12 == "title" then
			var_27_7 = var_27_6.display_name
		elseif var_27_12 == "entry" then
			var_27_8 = var_27_6.display_name
			var_27_9 = var_27_6.value
			var_27_10 = var_27_6.display_name
			var_27_11 = var_27_6.description_name
		end

		local var_27_13 = var_27_3[iter_27_0]

		var_27_13.name = UIRenderer.crop_text_width(arg_27_0.ui_renderer, var_27_8, 300, var_27_4[iter_27_0].name)
		var_27_13.title = UIRenderer.crop_text_width(arg_27_0.ui_renderer, var_27_7, 300, var_27_4[iter_27_0].title)
		var_27_13.value = var_27_9
		var_27_13.tooltip.title = var_27_10
		var_27_13.tooltip.description = var_27_11
	end

	var_27_2.num_draws = var_27_5

	arg_27_0:_setup_tab_scrollbar(var_27_0)
end

HeroWindowCharacterPreview._setup_tab_scrollbar = function (arg_28_0, arg_28_1)
	local var_28_0 = var_0_3.detailed_button.size
	local var_28_1 = var_0_3.detailed_list.size
	local var_28_2 = arg_28_1.style.list_style
	local var_28_3 = var_28_2.list_member_offset[2]
	local var_28_4 = var_28_2.num_draws
	local var_28_5

	if var_28_4 == 0 then
		var_28_5 = math.abs(var_28_3)
	else
		var_28_5 = math.abs(var_28_3 * var_28_4)
	end

	local var_28_6 = math.min(var_28_1[2] / var_28_5, 1)
	local var_28_7 = arg_28_1.content.scrollbar

	if var_28_6 < 1 then
		var_28_7.percentage = var_28_6
		var_28_7.scroll_value = 1

		local var_28_8 = 2

		var_28_7.scroll_amount = var_28_3 / (var_28_5 - var_28_1[2]) * var_28_8
	else
		var_28_7.percentage = 1
		var_28_7.scroll_value = 1
	end
end

HeroWindowCharacterPreview._show_weapon_disclaimer = function (arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._widgets_by_name.disclaimer_text.content

	arg_29_0._widgets_by_name.disclaimer_text_background.content.visible = arg_29_1
	var_29_0.visible = arg_29_1
end
