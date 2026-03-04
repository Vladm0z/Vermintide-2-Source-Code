-- chunkname: @scripts/ui/views/loading_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/views/subtitle_timed_gui")

local var_0_0 = local_require("scripts/ui/views/loading_view_definitions")
local var_0_1 = {
	"dlc1_2_survival_tip_01",
	"dlc1_2_survival_tip_02",
	"dlc1_2_survival_tip_03",
	"dlc1_2_survival_tip_04",
	"dlc1_2_survival_tip_05",
	"dlc1_2_survival_tip_06"
}
local var_0_2 = {
	npcs = "loading_screen_npcs",
	kerillian = "loading_screen_kerillian",
	lore = "loading_screen_lore",
	khazalid = "loading_screen_khazalid",
	rotbloods = "loading_screen_rotbloods",
	okri = "loading_screen_okri",
	tip = "loading_screen_tip"
}
local var_0_3 = {
	npcs = 3,
	kerillian = 10,
	lore = 55,
	khazalid = 47,
	rotbloods = 9,
	okri = 1,
	tip = 89
}
local var_0_4 = {
	lore = {
		4,
		8,
		41
	}
}
local var_0_5 = {
	"tip",
	"lore",
	"rotbloods",
	"khazalid",
	"npcs",
	"kerillian",
	"okri"
}
local var_0_6 = 0
local var_0_7 = #var_0_5
local var_0_8 = {}

for iter_0_0 = 1, var_0_7 do
	local var_0_9 = var_0_5[iter_0_0]

	fassert(var_0_3[var_0_9], "Missing max range of tip type %s", var_0_9)

	var_0_6 = var_0_6 + var_0_3[var_0_9] - (var_0_4[var_0_9] and #var_0_4[var_0_9] or 0)
end

for iter_0_1, iter_0_2 in pairs(var_0_3) do
	var_0_8[iter_0_1] = iter_0_2 / var_0_6
end

local var_0_10 = {
	objective_sockets_name = "nfl_olesya_all_weave_objective_essence_refine_01",
	objective_kill_enemies_name = "nfl_olesya_all_weave_objective_kill_02",
	objective_capture_points_name = "nfl_olesya_all_weave_objective_essence_capture_02",
	objective_destroy_doom_wheels_name = "nfl_olesya_all_weave_objective_essence_nodes_02",
	objective_targets_name = "nfl_olesya_all_weave_objective_essence_shards_04"
}
local var_0_11 = 5

LoadingView = class(LoadingView)

LoadingView.init = function (arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1.world

	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.return_to_pc_menu = arg_1_1.return_to_pc_menu
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	if not script_data.disable_news_ticker then
		arg_1_0.news_ticker_speed = 100
		arg_1_0.news_ticker_manager = Managers.news_ticker

		arg_1_0.news_ticker_manager:refresh_loading_screen_message()
	end

	arg_1_0.world = var_1_0
	arg_1_0.default_loading_screen = "loading_screen_default"

	VisualAssertLog.setup(var_1_0)

	arg_1_0.ui_renderer = UIRenderer.create(arg_1_0.world, "material", "materials/ui/loading_screens/" .. arg_1_0.default_loading_screen, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat")

	arg_1_0:create_ui_elements()

	arg_1_0._gamepad_active = Managers.input:is_device_active("gamepad")
	DO_RELOAD = false
	arg_1_0.active = true
end

LoadingView._create_hdr_gui = function (arg_2_0)
	local var_2_0 = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local var_2_1 = 800
	local var_2_2 = "loading_hdr_world"
	local var_2_3 = "loading_hdr_viewport"
	local var_2_4 = "environment/ui_hdr"
	local var_2_5 = Managers.world:create_world(var_2_2, var_2_4, nil, var_2_1, unpack(var_2_0))
	local var_2_6 = "overlay"
	local var_2_7 = ScriptWorld.create_viewport(var_2_5, var_2_3, var_2_6, var_2_1)

	arg_2_0._ui_hdr_viewport_name = var_2_3
	arg_2_0._ui_hdr_world_name = var_2_2
	arg_2_0._ui_hdr_world = var_2_5
	arg_2_0._ui_hdr_renderer = UIRenderer.create(var_2_5, "material", "materials/ui/ui_1080p_loading", "immediate")
end

LoadingView.texture_resource_loaded = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	if arg_3_0.return_to_pc_menu then
		return
	end

	UIRenderer.destroy(arg_3_0.ui_renderer, arg_3_0.world)

	arg_3_0.level_key = arg_3_1
	arg_3_0.act_progression_index = arg_3_2

	local var_3_0 = LevelSettings[arg_3_1]
	local var_3_1 = var_3_0.has_multiple_loading_images
	local var_3_2 = arg_3_4 or var_3_0.loading_ui_package_name
	local var_3_3 = var_3_0.game_mode or "adventure"
	local var_3_4 = "materials/ui/loading_screens/" .. (var_3_2 or arg_3_0.default_loading_screen)

	if IS_XB1 then
		local var_3_5 = World.create_screen_gui(arg_3_0.world, "immediate", "material", "materials/ui/loading_screens/" .. arg_3_0.default_loading_screen, "material", var_3_4, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat")
		local var_3_6 = World.create_screen_gui(arg_3_0.world, "material", "materials/ui/loading_screens/" .. arg_3_0.default_loading_screen, "material", var_3_4, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat")

		arg_3_0.ui_renderer = UIRenderer.create_ui_renderer(arg_3_0.world, var_3_5, var_3_6)
	else
		arg_3_0.ui_renderer = UIRenderer.create(arg_3_0.world, "material", "materials/ui/loading_screens/" .. arg_3_0.default_loading_screen, "material", var_3_4, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat")
	end

	arg_3_0.bg_widget.content.bg_texture = arg_3_5 or "loading_screen"

	if arg_3_6 then
		arg_3_0:_create_hdr_gui()

		local var_3_7 = arg_3_6.wind_name
		local var_3_8 = arg_3_6.weave_display_name
		local var_3_9 = arg_3_6.location_display_name
		local var_3_10 = arg_3_6.objective_name
		local var_3_11 = var_0_10[var_3_10]

		arg_3_0.bg_widget.content.location_name = var_3_9
		arg_3_0.bg_widget.content.wind_name = var_3_7
		arg_3_0.bg_widget.content.mutator_name = MutatorTemplates[var_3_7].display_name
		arg_3_0.bg_widget.content.mutator_description = MutatorTemplates[var_3_7].description
		arg_3_0.bg_widget.content.objective_text = var_3_11 or arg_3_0.bg_widget.content.objective_text
		arg_3_0.bg_widget.content.is_weave = true
		arg_3_0.bg_widget.content.is_arena = arg_3_6.is_arena

		local var_3_12 = arg_3_0.bg_widget.content.mutator_description
		local var_3_13 = arg_3_0.bg_widget.style.mutator_description
		local var_3_14, var_3_15 = UIFontByResolution(var_3_13)
		local var_3_16 = var_3_14[1]
		local var_3_17 = var_3_14[2]
		local var_3_18 = var_3_14[3]
		local var_3_19, var_3_20, var_3_21 = UIGetFontHeight(arg_3_0.ui_renderer.gui, var_3_13.font_type, var_3_17)
		local var_3_22 = var_3_15
		local var_3_23 = #UIRenderer.word_wrap(arg_3_0.ui_renderer, Localize(var_3_12), var_3_16, var_3_22, var_3_13.size[1]) * 30 + 30

		arg_3_0.bg_widget.style.objective_icon.offset[2] = arg_3_0.bg_widget.style.objective_icon.offset[2] - var_3_23
		arg_3_0.bg_widget.style.objective_text.offset[2] = arg_3_0.bg_widget.style.objective_text.offset[2] - var_3_23
		arg_3_0.weave_loading_icon = UIWidget.init(var_0_0.weave_loading_icon)

		Managers.transition:hide_loading_icon()

		arg_3_0._weave_data = arg_3_6
		arg_3_0._optional_loading_screen_material_name = arg_3_5
	else
		arg_3_0.bg_widget.content.is_weave = false

		if not var_3_0.hub_level and var_3_0.level_type ~= "survival" then
			arg_3_0:setup_act_text(arg_3_1)
			arg_3_0:setup_difficulty_text(arg_3_3)
		end

		arg_3_0:setup_level_text(arg_3_1)
		arg_3_0:setup_tip_text(arg_3_2, var_3_3)

		arg_3_0.weave_loading_icon = nil
	end
end

LoadingView.deactivate = function (arg_4_0)
	arg_4_0.active = false
end

LoadingView.activate = function (arg_5_0)
	arg_5_0.active = true
end

LoadingView.showing_press_to_continue = function (arg_6_0)
	return arg_6_0._show_press_to_continue
end

LoadingView.show_press_to_continue = function (arg_7_0, arg_7_1)
	arg_7_0._show_press_to_continue = arg_7_1
end

LoadingView.create_ui_elements = function (arg_8_0)
	arg_8_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_8_0.bg_widget = UIWidget.init(var_0_0.background_image)
	arg_8_0.tip_title_widget = UIWidget.init(var_0_0.tip_title_widget)
	arg_8_0.tip_text_prefix_widget = UIWidget.init(var_0_0.tip_text_prefix_widget)
	arg_8_0.tip_text_suffix_widget = UIWidget.init(var_0_0.tip_text_suffix_widget)
	arg_8_0.gamepad_input_icon = UIWidget.init(var_0_0.gamepad_input_icon)
	arg_8_0.second_gamepad_input_icon = UIWidget.init(var_0_0.second_gamepad_input_icon)
	arg_8_0.second_row_tip_text_prefix_widget = UIWidget.init(var_0_0.second_row_tip_text_prefix_widget)
	arg_8_0.second_row_tip_text_suffix_widget = UIWidget.init(var_0_0.second_row_tip_text_suffix_widget)
	arg_8_0.second_row_gamepad_input_icon = UIWidget.init(var_0_0.second_row_gamepad_input_icon)
	arg_8_0.second_row_second_gamepad_input_icon = UIWidget.init(var_0_0.second_row_second_gamepad_input_icon)
	arg_8_0.act_name_widget = UIWidget.init(var_0_0.act_name_widget)
	arg_8_0.act_name_bg_widget = UIWidget.init(var_0_0.act_name_bg_widget)
	arg_8_0.level_name_widget = UIWidget.init(var_0_0.level_name_widget)
	arg_8_0.level_name_bg_widget = UIWidget.init(var_0_0.level_name_bg_widget)
	arg_8_0.game_difficulty_widget = UIWidget.init(var_0_0.game_difficulty_widget)
	arg_8_0.game_difficulty_bg_widget = UIWidget.init(var_0_0.game_difficulty_bg_widget)

	if script_data.honduras_demo then
		arg_8_0._press_to_continue_widget = UIWidget.init(var_0_0.press_to_continue_widget)
	end

	arg_8_0.widgets = {
		arg_8_0.bg_widget,
		arg_8_0.level_name_widget,
		UIWidget.init(var_0_0.dead_space_filler)
	}

	if not script_data.honduras_demo then
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.gamepad_input_icon
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.second_gamepad_input_icon
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.second_row_gamepad_input_icon
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.second_row_second_gamepad_input_icon
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.tip_text_prefix_widget
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.tip_text_suffix_widget
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.second_row_tip_text_prefix_widget
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.second_row_tip_text_suffix_widget
	end

	if not script_data.disable_news_ticker then
		arg_8_0.news_ticker_text_widget = UIWidget.init(var_0_0.news_ticker_text_widget)
		arg_8_0.widgets[#arg_8_0.widgets + 1] = arg_8_0.news_ticker_text_widget
		arg_8_0.widgets[#arg_8_0.widgets + 1] = UIWidget.init(var_0_0.news_ticker_mask_widget)
	end

	arg_8_0.bg_widget.content.bg_texture = arg_8_0.default_loading_screen

	local var_8_0 = arg_8_0.level_key and LevelSettings[arg_8_0.level_key]
	local var_8_1 = var_8_0 and var_8_0.game_mode or "adventure"

	arg_8_0:setup_tip_text(arg_8_0.act_progression_index, var_8_1, arg_8_0._tip_localization_key)

	if arg_8_0._weave_data then
		local var_8_2 = arg_8_0._weave_data
		local var_8_3 = var_8_2.wind_name
		local var_8_4 = var_8_2.weave_display_name
		local var_8_5 = var_8_2.location_display_name
		local var_8_6 = var_8_2.objective_name
		local var_8_7 = var_0_10[var_8_6]

		arg_8_0.bg_widget.content.location_name = var_8_5
		arg_8_0.bg_widget.content.wind_name = var_8_3
		arg_8_0.bg_widget.content.mutator_name = MutatorTemplates[var_8_3].display_name
		arg_8_0.bg_widget.content.mutator_description = MutatorTemplates[var_8_3].description
		arg_8_0.bg_widget.content.objective_text = var_8_7 or arg_8_0.bg_widget.content.objective_text
		arg_8_0.bg_widget.content.is_weave = true
		arg_8_0.bg_widget.content.is_arena = var_8_2.is_arena

		local var_8_8 = arg_8_0.bg_widget.content.mutator_description
		local var_8_9 = arg_8_0.bg_widget.style.mutator_description
		local var_8_10, var_8_11 = UIFontByResolution(var_8_9)
		local var_8_12 = var_8_10[1]
		local var_8_13 = var_8_10[2]
		local var_8_14 = var_8_10[3]
		local var_8_15, var_8_16, var_8_17 = UIGetFontHeight(arg_8_0.ui_renderer.gui, var_8_14, var_8_13)
		local var_8_18 = var_8_11
		local var_8_19 = #UIRenderer.word_wrap(arg_8_0.ui_renderer, Localize(var_8_8), var_8_12, var_8_18, var_8_9.size[1]) * 30 + 30

		arg_8_0.bg_widget.style.objective_icon.offset[2] = arg_8_0.bg_widget.style.objective_icon.offset[2] - var_8_19
		arg_8_0.bg_widget.style.objective_text.offset[2] = arg_8_0.bg_widget.style.objective_text.offset[2] - var_8_19
		arg_8_0.bg_widget.content.bg_texture = arg_8_0._optional_loading_screen_material_name
		arg_8_0.weave_loading_icon = UIWidget.init(var_0_0.weave_loading_icon)

		Managers.transition:hide_loading_icon()
	end

	UIRenderer.clear_scenegraph_queue(arg_8_0.ui_renderer)
end

LoadingView.subtitle_gui = function (arg_9_0)
	return arg_9_0.subtitle_timed_gui
end

LoadingView.trigger_subtitles = function (arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1 and not arg_10_0.subtitle_timed_gui and Application.user_setting("use_subtitles") then
		arg_10_0.subtitle_timed_gui = SubtitleTimedGui:new(arg_10_1, var_0_11)
	end
end

LoadingView.trigger_weave_subtitles = function (arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 and not arg_11_0.subtitle_timed_gui and Application.user_setting("use_subtitles") then
		arg_11_0.subtitle_timed_gui = SubtitleTimedGui:new(arg_11_1, var_0_11)
	end
end

LoadingView.reset_tip_text = function (arg_12_0)
	arg_12_0.tip_text_prefix_widget.content.text = ""
	arg_12_0.tip_text_suffix_widget.content.text = ""
	arg_12_0.gamepad_input_icon.content.texture_id = nil
	arg_12_0.second_gamepad_input_icon.content.texture_id = nil
	arg_12_0.second_row_tip_text_prefix_widget.content.text = ""
	arg_12_0.second_row_tip_text_suffix_widget.content.text = ""
	arg_12_0.second_row_gamepad_input_icon.content.texture_id = nil
	arg_12_0.second_row_second_gamepad_input_icon.content.texture_id = nil
	arg_12_0.tip_text_prefix_widget.style.text.word_wrap = false
	arg_12_0.tip_text_suffix_widget.style.text.word_wrap = false
	arg_12_0.second_row_tip_text_prefix_widget.style.text.word_wrap = false
	arg_12_0.second_row_tip_text_suffix_widget.style.text.word_wrap = false
	arg_12_0.tip_text_prefix_widget.style.text.horizontal_alignment = "right"
	arg_12_0.tip_text_suffix_widget.style.text.horizontal_alignment = "left"
	arg_12_0.second_row_tip_text_prefix_widget.style.text.horizontal_alignment = "right"
	arg_12_0.second_row_tip_text_suffix_widget.style.text.horizontal_alignment = "left"
	arg_12_0.tip_text_prefix_widget.style.text.offset[1] = 0
	arg_12_0.tip_text_suffix_widget.style.text.offset[1] = 0
	arg_12_0.second_row_tip_text_prefix_widget.style.text.offset[1] = 0
	arg_12_0.second_row_tip_text_suffix_widget.style.text.offset[1] = 0
	arg_12_0.tip_text_prefix_widget.style.text.offset[2] = 0
	arg_12_0.tip_text_suffix_widget.style.text.offset[2] = 0
	arg_12_0.second_row_tip_text_prefix_widget.style.text.offset[2] = 0
	arg_12_0.second_row_tip_text_suffix_widget.style.text.offset[2] = 0
	arg_12_0.ui_scenegraph.tip_text_prefix.size[1] = var_0_0.MAXIMUM_TIP_WIDTH
	arg_12_0.ui_scenegraph.tip_text_suffix.size[1] = var_0_0.MAXIMUM_TIP_WIDTH
	arg_12_0.ui_scenegraph.gamepad_input_icon.size = var_0_0.ICON_SIZE
	arg_12_0.ui_scenegraph.second_gamepad_input_icon.size = var_0_0.ICON_SIZE
	arg_12_0.ui_scenegraph.second_row_tip_text_prefix.size[1] = var_0_0.MAXIMUM_TIP_WIDTH
	arg_12_0.ui_scenegraph.second_row_tip_text_suffix.size[1] = var_0_0.MAXIMUM_TIP_WIDTH
	arg_12_0.ui_scenegraph.second_row_gamepad_input_icon.size = var_0_0.ICON_SIZE
	arg_12_0.ui_scenegraph.second_row_second_gamepad_input_icon.size = var_0_0.ICON_SIZE
end

LoadingView.fit_title = function (arg_13_0)
	local var_13_0 = arg_13_0.tip_title_widget.style.text
	local var_13_1 = Localize("loading_screen_tip_title")
	local var_13_2, var_13_3, var_13_4 = Script.temp_count()
	local var_13_5 = true

	repeat
		local var_13_6, var_13_7 = UIFontByResolution(var_13_0)
		local var_13_8 = UIRenderer.text_size(arg_13_0.ui_renderer, var_13_1, var_13_6[1], var_13_7)

		Script.set_temp_count(var_13_2, var_13_3, var_13_4)

		if var_13_8 <= 260 or var_13_0.font_size <= 1 then
			var_13_5 = false
		else
			var_13_0.font_size = var_13_0.font_size - 1
		end
	until not var_13_5
end

local var_0_12 = {}

LoadingView._find_second_input_texture = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	table.clear(var_0_12)

	local var_14_0 = var_0_12
	local var_14_1, var_14_2 = string.find(arg_14_1, arg_14_2)
	local var_14_3 = string.sub(arg_14_1, 1, var_14_1 - 1)

	var_14_0.icon_offset = UIRenderer.text_size(arg_14_0.ui_renderer, var_14_3, arg_14_4[1], arg_14_5)
	arg_14_1 = string.gsub(arg_14_1, arg_14_2, "      ")
	var_14_0.button_texture_data = UISettings.get_gamepad_input_texture_data(Managers.input:get_service("Player"), arg_14_3, true)

	return var_14_0, arg_14_1
end

local var_0_13 = {}
local var_0_14 = {
	0,
	0
}

LoadingView.setup_tip_text = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0:fit_title()
	arg_15_0:reset_tip_text()

	if script_data.no_loading_screen_tip_texts then
		return
	end

	table.clear(var_0_13)

	if arg_15_2 == "survival" then
		local var_15_0 = arg_15_3 or var_0_1[math.random(1, #var_0_1)]

		arg_15_0.tip_text_prefix_widget.content.text = Localize(var_15_0)
		arg_15_0.tip_text_prefix_widget.style.text.horizontal_alignment = "center"
		arg_15_0.tip_text_prefix_widget.style.text.word_wrap = true
	else
		arg_15_3 = arg_15_3 or Managers.mechanism:get_loading_tip()

		if not arg_15_3 then
			local var_15_1 = 1
			local var_15_2 = math.random()
			local var_15_3 = 0

			for iter_15_0 = 1, var_0_7 do
				local var_15_4 = var_0_5[iter_15_0]
				local var_15_5 = var_15_3 + var_0_8[var_15_4]

				if var_15_3 <= var_15_2 and var_15_2 <= var_15_5 then
					var_15_1 = iter_15_0

					break
				end

				var_15_3 = var_15_5
			end

			local var_15_6 = var_0_5[var_15_1]
			local var_15_7 = var_0_2[var_15_6]
			local var_15_8 = var_0_3[var_15_6]
			local var_15_9 = math.random(1, var_15_8)
			local var_15_10 = var_0_4[var_15_6]

			if var_15_10 then
				local var_15_11 = 0
				local var_15_12 = table.contains(var_15_10, var_15_9)

				while var_15_12 and var_15_11 < var_15_8 do
					var_15_11 = var_15_11 + 1
					var_15_9 = var_15_9 % var_15_8 + 1
					var_15_12 = table.contains(var_15_10, var_15_9)
				end
			end

			local var_15_13 = var_15_9 < 10 and "0" .. tostring(var_15_9) or tostring(var_15_9)

			arg_15_3 = var_15_7 .. "_" .. var_15_13
		end

		arg_15_0._tip_localization_key = arg_15_3

		local var_15_14 = arg_15_0.input_manager
		local var_15_15 = var_15_14:is_device_active("gamepad")
		local var_15_16

		if var_15_15 then
			local var_15_17, var_15_18, var_15_19 = Managers.localizer:get_input_action(arg_15_3)

			if var_15_17 then
				local var_15_20 = UISettings.get_gamepad_input_texture_data(var_15_14:get_service(var_15_19), var_15_17, var_15_15)

				if var_15_20 then
					local var_15_21 = var_15_20.size
					local var_15_22 = var_15_20.texture
					local var_15_23 = "______"

					var_15_16 = Managers.localizer:replace_macro_in_string(arg_15_3, var_15_23)

					if string.find(var_15_16, "%[") then
						var_15_16 = string.gsub(var_15_16, "%[", "")
					end

					if string.find(var_15_16, "%]") then
						var_15_16 = string.gsub(var_15_16, "%]", "")
					end

					local var_15_24, var_15_25 = string.find(var_15_16, var_15_23)
					local var_15_26 = string.sub(var_15_16, 1, var_15_24 - 1)
					local var_15_27 = string.sub(var_15_16, var_15_25 + 1)
					local var_15_28 = arg_15_0.tip_text_prefix_widget.style.text
					local var_15_29, var_15_30 = UIFontByResolution(var_15_28)
					local var_15_31 = UIRenderer.text_size(arg_15_0.ui_renderer, var_15_26, var_15_29[1], var_15_30)
					local var_15_32 = var_15_21[1]
					local var_15_33 = var_0_13

					if var_15_18 and var_15_18[2] then
						var_15_33, var_15_27 = arg_15_0:_find_second_input_texture(var_15_27, var_15_23, var_15_18[2], var_15_29, var_15_30)
					end

					local var_15_34 = var_15_33.button_texture_data and var_15_33.button_texture_data.size or var_0_14
					local var_15_35 = var_15_33.button_texture_data and var_15_33.button_texture_data.texture
					local var_15_36 = var_15_33.icon_offset or 0
					local var_15_37 = UIRenderer.text_size(arg_15_0.ui_renderer, var_15_27, var_15_29[1], var_15_30)
					local var_15_38 = var_15_31 + var_15_32 + var_15_37 + var_15_34[1]
					local var_15_39 = -var_15_38 * 0.5 + var_15_31 * 0.5 - var_15_32 * 0.05
					local var_15_40 = -var_15_38 * 0.5 + var_15_31 + var_15_32 * 0.05 + var_15_32 * 0.5
					local var_15_41 = -var_15_38 * 0.5 + var_15_31 + var_15_32 * 0.05 + var_15_32 * 0.5 + var_15_36 + var_15_34[1] * 0.05 + var_15_34[1]
					local var_15_42 = -var_15_38 * 0.5 + var_15_31 + var_15_32 * 0.5 + var_15_37 * 0.5 + var_15_32 * 0.5

					if var_15_31 > var_0_0.MAXIMUM_TIP_WIDTH then
						local var_15_43 = UIRenderer.word_wrap(arg_15_0.ui_renderer, var_15_26, var_15_29[1], var_15_30, var_0_0.MAXIMUM_TIP_WIDTH - var_15_31 - var_15_32)

						var_15_26 = var_15_43[2]
						var_15_31 = UIRenderer.text_size(arg_15_0.ui_renderer, var_15_26, var_15_29[1], var_15_30)

						local var_15_44 = var_15_31 + var_15_32 + var_15_37

						var_15_39 = -var_15_44 * 0.5 + var_15_31 * 0.5 - var_15_32 * 0.5
						var_15_40 = -var_15_44 * 0.5 + var_15_31 + var_15_32 * 0.05
						var_15_42 = -var_15_44 * 0.5 + var_15_31 + var_15_32 * 0.5 + var_15_37 * 0.5
						arg_15_0.tip_text_prefix_widget.content.text = var_15_43[1]
						arg_15_0.tip_text_prefix_widget.style.text.horizontal_alignment = "center"
						arg_15_0.tip_text_prefix_widget.style.text.word_wrap = true
						arg_15_0.second_row_tip_text_prefix_widget.style.text.offset[1] = var_15_39
						arg_15_0.second_row_gamepad_input_icon.style.texture_id.offset[1] = var_15_40
						arg_15_0.second_row_second_gamepad_input_icon.style.texture_id.offset[1] = var_15_41
						arg_15_0.second_row_tip_text_suffix_widget.style.text.offset[1] = var_15_42
						arg_15_0.tip_text_prefix_widget.style.text.offset[2] = 0
						arg_15_0.second_row_tip_text_prefix_widget.style.text.offset[2] = 0
						arg_15_0.second_row_gamepad_input_icon.style.texture_id.offset[2] = 0
						arg_15_0.second_row_second_gamepad_input_icon.style.texture_id.offset[2] = 0
						arg_15_0.second_row_tip_text_suffix_widget.style.text.offset[2] = 0
						arg_15_0.second_row_tip_text_prefix_widget.content.text = var_15_26
						arg_15_0.second_row_gamepad_input_icon.content.texture_id = var_15_22
						arg_15_0.second_row_second_gamepad_input_icon.content.texture_id = var_15_35
						arg_15_0.second_row_tip_text_suffix_widget.content.text = var_15_27
						arg_15_0.ui_scenegraph.second_row_tip_text_prefix.size[1] = var_15_31
						arg_15_0.ui_scenegraph.second_row_gamepad_input_icon.size = var_15_21
						arg_15_0.ui_scenegraph.second_row_second_gamepad_input_icon.size = var_15_34
						arg_15_0.ui_scenegraph.second_row_tip_text_suffix.size[1] = var_15_37
					elseif var_15_37 > var_0_0.MAXIMUM_TIP_WIDTH then
						local var_15_45 = UIRenderer.word_wrap(arg_15_0.ui_renderer, var_15_27, var_15_29[1], var_15_30, var_0_0.MAXIMUM_TIP_WIDTH - var_15_31 - var_15_32)

						var_15_27 = var_15_45[1]
						var_15_37 = UIRenderer.text_size(arg_15_0.ui_renderer, var_15_27, var_15_29[1], var_15_30)

						local var_15_46 = var_15_31 + var_15_32 + var_15_37

						var_15_39 = -var_15_46 * 0.5 + var_15_31 * 0.5 - var_15_32 * 0.5
						var_15_40 = -var_15_46 * 0.5 + var_15_31 + var_15_32 * 0.05
						var_15_42 = -var_15_46 * 0.5 + var_15_31 + var_15_32 * 0.5 + var_15_37 * 0.5
						arg_15_0.second_row_tip_text_prefix_widget.content.text = var_15_45[2]
						arg_15_0.second_row_tip_text_prefix_widget.style.text.horizontal_alignment = "center"
						arg_15_0.second_row_tip_text_prefix_widget.style.text.word_wrap = true
						arg_15_0.tip_text_prefix_widget.style.text.offset[1] = var_15_39
						arg_15_0.gamepad_input_icon.style.texture_id.offset[1] = var_15_40
						arg_15_0.second_gamepad_input_icon.style.texture_id.offset[1] = var_15_41
						arg_15_0.tip_text_suffix_widget.style.text.offset[1] = var_15_42
						arg_15_0.second_row_tip_text_prefix_widget.style.text.offset[2] = 0
						arg_15_0.tip_text_prefix_widget.style.text.offset[2] = 0
						arg_15_0.gamepad_input_icon.style.texture_id.offset[2] = 0
						arg_15_0.second_gamepad_input_icon.style.texture_id.offset[2] = 0
						arg_15_0.tip_text_suffix_widget.style.text.offset[2] = 0
						arg_15_0.tip_text_prefix_widget.content.text = var_15_26
						arg_15_0.gamepad_input_icon.content.texture_id = var_15_22
						arg_15_0.second_gamepad_input_icon.content.texture_id = var_15_35
						arg_15_0.tip_text_suffix_widget.content.text = var_15_27
						arg_15_0.ui_scenegraph.tip_text_prefix.size[1] = var_15_31
						arg_15_0.ui_scenegraph.gamepad_input_icon.size = var_15_21
						arg_15_0.ui_scenegraph.second_gamepad_input_icon.size = var_15_34
						arg_15_0.ui_scenegraph.tip_text_suffix.size[1] = var_15_37
					else
						arg_15_0.ui_scenegraph.tip_text_prefix.size[1] = var_15_31
						arg_15_0.ui_scenegraph.gamepad_input_icon.size = var_15_21
						arg_15_0.ui_scenegraph.second_gamepad_input_icon.size = var_15_34
						arg_15_0.ui_scenegraph.tip_text_suffix.size[1] = var_15_37
						arg_15_0.tip_text_prefix_widget.style.text.offset[1] = var_15_39
						arg_15_0.gamepad_input_icon.style.texture_id.offset[1] = var_15_40
						arg_15_0.second_gamepad_input_icon.style.texture_id.offset[1] = var_15_41
						arg_15_0.tip_text_suffix_widget.style.text.offset[1] = var_15_42
						arg_15_0.tip_text_prefix_widget.style.text.offset[2] = 0
						arg_15_0.gamepad_input_icon.style.texture_id.offset[2] = 0
						arg_15_0.second_gamepad_input_icon.style.texture_id.offset[2] = 0
						arg_15_0.tip_text_suffix_widget.style.text.offset[2] = 0
						arg_15_0.tip_text_prefix_widget.content.text = var_15_26
						arg_15_0.gamepad_input_icon.content.texture_id = var_15_22
						arg_15_0.second_gamepad_input_icon.content.texture_id = var_15_35
						arg_15_0.tip_text_suffix_widget.content.text = var_15_27
					end
				end
			end
		end

		if not var_15_16 then
			local var_15_47 = Localize(arg_15_3)

			arg_15_0.tip_text_prefix_widget.content.text = var_15_47
			arg_15_0.tip_text_prefix_widget.style.text.horizontal_alignment = "center"
			arg_15_0.tip_text_prefix_widget.style.text.word_wrap = true
		end
	end
end

LoadingView.setup_act_text = function (arg_16_0, arg_16_1)
	if arg_16_1 then
		local var_16_0 = LevelSettings[arg_16_1].act

		if var_16_0 then
			local var_16_1 = var_16_0 .. "_ls"
			local var_16_2 = Localize(var_16_1)

			arg_16_0.act_name_widget.content.text = var_16_2
			arg_16_0.act_name_bg_widget.content.text = var_16_2
		end
	end
end

LoadingView.setup_level_text = function (arg_17_0, arg_17_1)
	if arg_17_1 then
		local var_17_0 = LevelSettings[arg_17_1].display_name

		if var_17_0 then
			local var_17_1 = Localize(var_17_0)

			arg_17_0.level_name_widget.content.text = var_17_1
			arg_17_0.level_name_bg_widget.content.text = var_17_1
		end
	end
end

LoadingView.setup_difficulty_text = function (arg_18_0, arg_18_1)
	if arg_18_1 then
		local var_18_0 = DifficultySettings[arg_18_1].display_name
		local var_18_1 = Localize(var_18_0)

		arg_18_0.game_difficulty_widget.content.text = var_18_1
		arg_18_0.game_difficulty_bg_widget.content.text = var_18_1
	end
end

LoadingView.setup_news_ticker = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.news_ticker_text_widget
	local var_19_1 = var_19_0.content
	local var_19_2 = var_19_0.style

	var_19_1.text = arg_19_1

	local var_19_3 = var_19_2.text
	local var_19_4 = var_19_3.font_type
	local var_19_5, var_19_6 = UIFontByResolution(var_19_3)
	local var_19_7, var_19_8, var_19_9 = UIRenderer.text_size(arg_19_0.ui_renderer, arg_19_1, var_19_5[1], var_19_6)

	arg_19_0.news_ticker_text_width = var_19_7
	arg_19_0.news_ticker_started = true
end

local var_0_15 = false

LoadingView.update = function (arg_20_0, arg_20_1)
	if var_0_15 then
		print("reload")
		arg_20_0:create_ui_elements()

		var_0_15 = false
	end

	if not arg_20_0.active then
		return
	end

	VisualAssertLog.update(arg_20_1)

	local var_20_0 = Managers.input:is_device_active("gamepad")

	if var_20_0 ~= arg_20_0._gamepad_active then
		local var_20_1 = arg_20_0.level_key and LevelSettings[arg_20_0.level_key]
		local var_20_2 = var_20_1 and var_20_1.game_mode or "adventure"

		arg_20_0:setup_tip_text(arg_20_0.act_progression_index, var_20_2, arg_20_0._tip_localization_key)

		arg_20_0._gamepad_active = var_20_0
	end

	if not script_data.disable_news_ticker and not arg_20_0.news_ticker_started then
		local var_20_3 = arg_20_0.news_ticker_manager:loading_screen_text()

		if var_20_3 then
			arg_20_0:setup_news_ticker(var_20_3)
		end
	end

	if arg_20_0.subtitle_timed_gui then
		arg_20_0.subtitle_timed_gui:update(arg_20_0.ui_renderer, arg_20_1)
	end

	arg_20_0:draw(arg_20_1)
end

LoadingView.draw = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.ui_renderer
	local var_21_1 = arg_21_0._ui_hdr_renderer
	local var_21_2 = arg_21_0.ui_scenegraph

	if not script_data.disable_news_ticker and arg_21_0.news_ticker_started then
		local var_21_3 = var_21_2.news_ticker_text.local_position

		if var_21_3[1] + arg_21_0.news_ticker_text_width <= 0 then
			var_21_3[1] = 1920
		end

		var_21_3[1] = var_21_3[1] - arg_21_1 * arg_21_0.news_ticker_speed
	end

	UIRenderer.begin_pass(var_21_0, var_21_2, FAKE_INPUT_SERVICE, arg_21_1, nil, arg_21_0.render_settings)

	for iter_21_0 = 1, #arg_21_0.widgets do
		UIRenderer.draw_widget(var_21_0, arg_21_0.widgets[iter_21_0])
	end

	if arg_21_0._show_press_to_continue then
		UIRenderer.draw_widget(var_21_0, arg_21_0._press_to_continue_widget)
	end

	UIRenderer.end_pass(var_21_0)

	if arg_21_0.weave_loading_icon then
		UIRenderer.begin_pass(var_21_1, var_21_2, FAKE_INPUT_SERVICE, arg_21_1, nil, arg_21_0.render_settings)
		UIRenderer.draw_widget(var_21_1, arg_21_0.weave_loading_icon)
		UIRenderer.end_pass(var_21_1)
	end
end

LoadingView.destroy = function (arg_22_0)
	VisualAssertLog.cleanup()
	UIRenderer.destroy(arg_22_0.ui_renderer, arg_22_0.world)

	if arg_22_0._ui_hdr_world then
		UIRenderer.destroy(arg_22_0._ui_hdr_renderer, arg_22_0._ui_hdr_world)
		Managers.world:destroy_world(arg_22_0._ui_hdr_world)
	end

	Managers.transition:show_loading_icon()
end

LoadingView.is_done = function (arg_23_0)
	return true
end
