-- chunkname: @scripts/ui/views/loading_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/views/subtitle_timed_gui")

local var_0_0 = local_require("scripts/ui/views/loading_view_definitions")
local tbl = {
	"dlc1_2_survival_tip_01",
	"dlc1_2_survival_tip_02",
	"dlc1_2_survival_tip_03",
	"dlc1_2_survival_tip_04",
	"dlc1_2_survival_tip_05",
	"dlc1_2_survival_tip_06"
}
local tbl_2 = {
	npcs = "loading_screen_npcs",
	kerillian = "loading_screen_kerillian",
	lore = "loading_screen_lore",
	khazalid = "loading_screen_khazalid",
	rotbloods = "loading_screen_rotbloods",
	okri = "loading_screen_okri",
	tip = "loading_screen_tip"
}
local tbl_3 = {
	npcs = 3,
	kerillian = 10,
	lore = 55,
	khazalid = 47,
	rotbloods = 9,
	okri = 1,
	tip = 89
}
local tbl_4 = {
	lore = {
		4,
		8,
		41
	}
}
local tbl_5 = {
	"tip",
	"lore",
	"rotbloods",
	"khazalid",
	"npcs",
	"kerillian",
	"okri"
}
local num = 0
local count = #tbl_5
local tbl_6 = {}

for i = 1, count do
	local var_0_9 = tbl_5[i]

	fassert(tbl_3[var_0_9], "Missing max range of tip type %s", var_0_9)

	local num_2 = num + tbl_3[var_0_9]
	local count_2

	if not tbl_4[var_0_9] then
		count_2 = #tbl_4[var_0_9]

		if not count_2 then
			-- Nothing
		end
	end

	count_2 = 0

	::label_0_0::

	num = num_2 - count_2
end

for k, v in pairs(tbl_3) do
	tbl_6[k] = v / num
end

local tbl_7 = {
	objective_sockets_name = "nfl_olesya_all_weave_objective_essence_refine_01",
	objective_kill_enemies_name = "nfl_olesya_all_weave_objective_kill_02",
	objective_capture_points_name = "nfl_olesya_all_weave_objective_essence_capture_02",
	objective_destroy_doom_wheels_name = "nfl_olesya_all_weave_objective_essence_nodes_02",
	objective_targets_name = "nfl_olesya_all_weave_objective_essence_shards_04"
}
local num_3 = 5

LoadingView = class(LoadingView)

LoadingView.init = function (self, arg_1_1)
	-- function 1
	local world = arg_1_1.world

	self.input_manager = arg_1_1.input_manager
	self.return_to_pc_menu = arg_1_1.return_to_pc_menu
	self.render_settings = {
		snap_pixel_positions = true
	}

	if not script_data.disable_news_ticker then
		self.news_ticker_speed = 100
		self.news_ticker_manager = Managers.news_ticker

		self.news_ticker_manager:refresh_loading_screen_message()
	end

	self.world = world
	self.default_loading_screen = "loading_screen_default"

	VisualAssertLog.setup(world)

	self.ui_renderer = UIRenderer.create(self.world, "material", "materials/ui/loading_screens/" .. self.default_loading_screen, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat")

	self:create_ui_elements()

	self._gamepad_active = Managers.input:is_device_active("gamepad")
	DO_RELOAD = false
	self.active = true
end

LoadingView._create_hdr_gui = function (self)
	-- function 2
	local tbl = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local num = 800
	local str = "loading_hdr_world"
	local str_2 = "loading_hdr_viewport"
	local str_3 = "environment/ui_hdr"
	local create_world = Managers.world:create_world(str, str_3, nil, num, unpack(tbl))
	local str_4 = "overlay"
	local create_viewport = ScriptWorld.create_viewport(create_world, str_2, str_4, num)

	self._ui_hdr_viewport_name = str_2
	self._ui_hdr_world_name = str
	self._ui_hdr_world = create_world
	self._ui_hdr_renderer = UIRenderer.create(create_world, "material", "materials/ui/ui_1080p_loading", "immediate")
end

LoadingView.texture_resource_loaded = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	if not self.return_to_pc_menu then
		return
	end

	UIRenderer.destroy(self.ui_renderer, self.world)

	self.level_key = arg_3_1
	self.act_progression_index = arg_3_2

	local var_3_0 = LevelSettings[arg_3_1]
	local has_multiple_loading_images = var_3_0.has_multiple_loading_images
	local flag = arg_3_4 or var_3_0.loading_ui_package_name
	local game_mode = var_3_0.game_mode

	game_mode = game_mode or "adventure"

	local str = "materials/ui/loading_screens/" .. (flag or self.default_loading_screen)

	if not IS_XB1 then
		local create_screen_gui = World.create_screen_gui(self.world, "immediate", "material", "materials/ui/loading_screens/" .. self.default_loading_screen, "material", str, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat")
		local create_screen_gui_2 = World.create_screen_gui(self.world, "material", "materials/ui/loading_screens/" .. self.default_loading_screen, "material", str, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat")

		self.ui_renderer = UIRenderer.create_ui_renderer(self.world, create_screen_gui, create_screen_gui_2)
	else
		self.ui_renderer = UIRenderer.create(self.world, "material", "materials/ui/loading_screens/" .. self.default_loading_screen, "material", str, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat")
	end

	self.bg_widget.content.bg_texture = arg_3_5 or "loading_screen"

	if not arg_3_6 then
		self:_create_hdr_gui()

		local wind_name = arg_3_6.wind_name
		local weave_display_name = arg_3_6.weave_display_name
		local location_display_name = arg_3_6.location_display_name
		local objective_name = arg_3_6.objective_name
		local var_3_11 = tbl_7[objective_name]

		self.bg_widget.content.location_name = location_display_name
		self.bg_widget.content.wind_name = wind_name
		self.bg_widget.content.mutator_name = MutatorTemplates[wind_name].display_name
		self.bg_widget.content.mutator_description = MutatorTemplates[wind_name].description
		self.bg_widget.content.objective_text = var_3_11 or self.bg_widget.content.objective_text
		self.bg_widget.content.is_weave = true
		self.bg_widget.content.is_arena = arg_3_6.is_arena

		local mutator_description = self.bg_widget.content.mutator_description
		local mutator_description_2 = self.bg_widget.style.mutator_description
		local var_3_14, var_3_15 = UIFontByResolution(mutator_description_2)
		local var_3_16 = var_3_14[1]
		local var_3_17 = var_3_14[2]
		local var_3_18 = var_3_14[3]
		local var_3_19, var_3_20, var_3_21 = UIGetFontHeight(self.ui_renderer.gui, mutator_description_2.font_type, var_3_17)
		local var_3_22 = var_3_15
		local num = #UIRenderer.word_wrap(self.ui_renderer, Localize(mutator_description), var_3_16, var_3_22, mutator_description_2.size[1]) * 30 + 30

		self.bg_widget.style.objective_icon.offset[2] = self.bg_widget.style.objective_icon.offset[2] - num
		self.bg_widget.style.objective_text.offset[2] = self.bg_widget.style.objective_text.offset[2] - num
		self.weave_loading_icon = UIWidget.init(var_0_0.weave_loading_icon)

		Managers.transition:hide_loading_icon()

		self._weave_data = arg_3_6
		self._optional_loading_screen_material_name = arg_3_5
	else
		self.bg_widget.content.is_weave = false

		if not (var_3_0.hub_level or var_3_0.level_type == "survival") then
			self:setup_act_text(arg_3_1)
			self:setup_difficulty_text(arg_3_3)
		end

		self:setup_level_text(arg_3_1)
		self:setup_tip_text(arg_3_2, game_mode)

		self.weave_loading_icon = nil
	end
end

LoadingView.deactivate = function (self)
	-- function 4
	self.active = false
end

LoadingView.activate = function (self)
	-- function 5
	self.active = true
end

LoadingView.showing_press_to_continue = function (self)
	-- function 6
	return self._show_press_to_continue
end

LoadingView.show_press_to_continue = function (self, arg_7_1)
	-- function 7
	self._show_press_to_continue = arg_7_1
end

LoadingView.create_ui_elements = function (self)
	-- function 8
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.bg_widget = UIWidget.init(var_0_0.background_image)
	self.tip_title_widget = UIWidget.init(var_0_0.tip_title_widget)
	self.tip_text_prefix_widget = UIWidget.init(var_0_0.tip_text_prefix_widget)
	self.tip_text_suffix_widget = UIWidget.init(var_0_0.tip_text_suffix_widget)
	self.gamepad_input_icon = UIWidget.init(var_0_0.gamepad_input_icon)
	self.second_gamepad_input_icon = UIWidget.init(var_0_0.second_gamepad_input_icon)
	self.second_row_tip_text_prefix_widget = UIWidget.init(var_0_0.second_row_tip_text_prefix_widget)
	self.second_row_tip_text_suffix_widget = UIWidget.init(var_0_0.second_row_tip_text_suffix_widget)
	self.second_row_gamepad_input_icon = UIWidget.init(var_0_0.second_row_gamepad_input_icon)
	self.second_row_second_gamepad_input_icon = UIWidget.init(var_0_0.second_row_second_gamepad_input_icon)
	self.act_name_widget = UIWidget.init(var_0_0.act_name_widget)
	self.act_name_bg_widget = UIWidget.init(var_0_0.act_name_bg_widget)
	self.level_name_widget = UIWidget.init(var_0_0.level_name_widget)
	self.level_name_bg_widget = UIWidget.init(var_0_0.level_name_bg_widget)
	self.game_difficulty_widget = UIWidget.init(var_0_0.game_difficulty_widget)
	self.game_difficulty_bg_widget = UIWidget.init(var_0_0.game_difficulty_bg_widget)

	if not script_data.honduras_demo then
		self._press_to_continue_widget = UIWidget.init(var_0_0.press_to_continue_widget)
	end

	self.widgets = {
		self.bg_widget,
		self.level_name_widget,
		UIWidget.init(var_0_0.dead_space_filler)
	}

	if not script_data.honduras_demo then
		self.widgets[#self.widgets + 1] = self.gamepad_input_icon
		self.widgets[#self.widgets + 1] = self.second_gamepad_input_icon
		self.widgets[#self.widgets + 1] = self.second_row_gamepad_input_icon
		self.widgets[#self.widgets + 1] = self.second_row_second_gamepad_input_icon
		self.widgets[#self.widgets + 1] = self.tip_text_prefix_widget
		self.widgets[#self.widgets + 1] = self.tip_text_suffix_widget
		self.widgets[#self.widgets + 1] = self.second_row_tip_text_prefix_widget
		self.widgets[#self.widgets + 1] = self.second_row_tip_text_suffix_widget
	end

	if not script_data.disable_news_ticker then
		self.news_ticker_text_widget = UIWidget.init(var_0_0.news_ticker_text_widget)
		self.widgets[#self.widgets + 1] = self.news_ticker_text_widget
		self.widgets[#self.widgets + 1] = UIWidget.init(var_0_0.news_ticker_mask_widget)
	end

	self.bg_widget.content.bg_texture = self.default_loading_screen

	local level_key = self.level_key

	level_key = not level_key and LevelSettings[self.level_key]

	local game_mode

	if not level_key then
		game_mode = level_key.game_mode

		if not game_mode then
			-- Nothing
		end
	end

	game_mode = "adventure"

	::label_8_0::

	self:setup_tip_text(self.act_progression_index, game_mode, self._tip_localization_key)

	if not self._weave_data then
		local _weave_data = self._weave_data
		local wind_name = _weave_data.wind_name
		local weave_display_name = _weave_data.weave_display_name
		local location_display_name = _weave_data.location_display_name
		local objective_name = _weave_data.objective_name
		local var_8_7 = tbl_7[objective_name]

		self.bg_widget.content.location_name = location_display_name
		self.bg_widget.content.wind_name = wind_name
		self.bg_widget.content.mutator_name = MutatorTemplates[wind_name].display_name
		self.bg_widget.content.mutator_description = MutatorTemplates[wind_name].description
		self.bg_widget.content.objective_text = var_8_7 or self.bg_widget.content.objective_text
		self.bg_widget.content.is_weave = true
		self.bg_widget.content.is_arena = _weave_data.is_arena

		local mutator_description = self.bg_widget.content.mutator_description
		local mutator_description_2 = self.bg_widget.style.mutator_description
		local var_8_10, var_8_11 = UIFontByResolution(mutator_description_2)
		local var_8_12 = var_8_10[1]
		local var_8_13 = var_8_10[2]
		local var_8_14 = var_8_10[3]
		local var_8_15, var_8_16, var_8_17 = UIGetFontHeight(self.ui_renderer.gui, var_8_14, var_8_13)
		local var_8_18 = var_8_11
		local num = #UIRenderer.word_wrap(self.ui_renderer, Localize(mutator_description), var_8_12, var_8_18, mutator_description_2.size[1]) * 30 + 30

		self.bg_widget.style.objective_icon.offset[2] = self.bg_widget.style.objective_icon.offset[2] - num
		self.bg_widget.style.objective_text.offset[2] = self.bg_widget.style.objective_text.offset[2] - num
		self.bg_widget.content.bg_texture = self._optional_loading_screen_material_name
		self.weave_loading_icon = UIWidget.init(var_0_0.weave_loading_icon)

		Managers.transition:hide_loading_icon()
	end

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

LoadingView.subtitle_gui = function (self)
	-- function 9
	return self.subtitle_timed_gui
end

LoadingView.trigger_subtitles = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not arg_10_1 and self.subtitle_timed_gui or not Application.user_setting("use_subtitles") then
		self.subtitle_timed_gui = SubtitleTimedGui:new(arg_10_1, num_3)
	end
end

LoadingView.trigger_weave_subtitles = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not arg_11_1 and self.subtitle_timed_gui or not Application.user_setting("use_subtitles") then
		self.subtitle_timed_gui = SubtitleTimedGui:new(arg_11_1, num_3)
	end
end

LoadingView.reset_tip_text = function (arg_12_0)
	-- function 12
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

LoadingView.fit_title = function (self)
	-- function 13
	local text = self.tip_title_widget.style.text
	local var_13_1 = Localize("loading_screen_tip_title")
	local temp_count, var_13_3, var_13_4 = Script.temp_count()
	local flag = true

	repeat
		local var_13_6, var_13_7 = UIFontByResolution(text)
		local text_size = UIRenderer.text_size(self.ui_renderer, var_13_1, var_13_6[1], var_13_7)

		Script.set_temp_count(temp_count, var_13_3, var_13_4)

		if not (text_size <= 260 or not (text.font_size <= 1)) then
			flag = false
		else
			text.font_size = text.font_size - 1
		end
	until not flag
end

local tbl_8 = {}

LoadingView._find_second_input_texture = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	table.clear(tbl_8)

	local var_14_0 = tbl_8
	local find, var_14_2 = string.find(arg_14_1, arg_14_2)
	local sub = string.sub(arg_14_1, 1, find - 1)

	var_14_0.icon_offset = UIRenderer.text_size(self.ui_renderer, sub, arg_14_4[1], arg_14_5)
	arg_14_1 = string.gsub(arg_14_1, arg_14_2, "      ")
	var_14_0.button_texture_data = UISettings.get_gamepad_input_texture_data(Managers.input:get_service("Player"), arg_14_3, true)

	return var_14_0, arg_14_1
end

local tbl_9 = {}
local tbl_10 = {
	0,
	0
}

LoadingView.setup_tip_text = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	self:fit_title()
	self:reset_tip_text()

	if not script_data.no_loading_screen_tip_texts then
		return
	end

	table.clear(tbl_9)

	if arg_15_2 == "survival" then
		local flag = arg_15_3 or tbl[math.random(1, #tbl)]

		self.tip_text_prefix_widget.content.text = Localize(flag)
		self.tip_text_prefix_widget.style.text.horizontal_alignment = "center"
		self.tip_text_prefix_widget.style.text.word_wrap = true
	else
		arg_15_3 = arg_15_3 or Managers.mechanism:get_loading_tip()

		if not arg_15_3 then
			local num = 1
			local random = math.random()
			local num_2 = 0

			for i = 1, count do
				local var_15_4 = tbl_5[i]
				local num_3 = num_2 + tbl_6[var_15_4]

				if not (not (num_2 <= random) or not (random <= num_3)) then
					num = i

					break
				end

				num_2 = num_3
			end

			local var_15_6 = tbl_5[num]
			local var_15_7 = tbl_2[var_15_6]
			local var_15_8 = tbl_3[var_15_6]
			local random_2 = math.random(1, var_15_8)
			local var_15_10 = tbl_4[var_15_6]

			if not var_15_10 then
				local num_4 = 0
				local contains = table.contains(var_15_10, random_2)

				while not (not contains and not (num_4 < var_15_8)) do
					num_4 = num_4 + 1
					random_2 = random_2 % var_15_8 + 1
					contains = table.contains(var_15_10, random_2)
				end
			end

			local str

			if random_2 < 10 then
				str = "0" .. tostring(random_2)

				if not str then
					-- Nothing
				end
			end

			str = tostring(random_2)

			::label_15_0::

			arg_15_3 = var_15_7 .. "_" .. str
		end

		self._tip_localization_key = arg_15_3

		local input_manager = self.input_manager
		local is_device_active = input_manager:is_device_active("gamepad")
		local var_15_16

		if not is_device_active then
			local get_input_action, var_15_18, var_15_19 = Managers.localizer:get_input_action(arg_15_3)

			if not get_input_action then
				local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(input_manager:get_service(var_15_19), get_input_action, is_device_active)

				if not get_gamepad_input_texture_data then
					local size = get_gamepad_input_texture_data.size
					local texture = get_gamepad_input_texture_data.texture
					local str_2 = "______"

					var_15_16 = Managers.localizer:replace_macro_in_string(arg_15_3, str_2)

					if not string.find(var_15_16, "%[") then
						var_15_16 = string.gsub(var_15_16, "%[", "")
					end

					if not string.find(var_15_16, "%]") then
						var_15_16 = string.gsub(var_15_16, "%]", "")
					end

					local find, var_15_25 = string.find(var_15_16, str_2)
					local sub = string.sub(var_15_16, 1, find - 1)
					local sub_2 = string.sub(var_15_16, var_15_25 + 1)
					local text = self.tip_text_prefix_widget.style.text
					local var_15_29, var_15_30 = UIFontByResolution(text)
					local text_size = UIRenderer.text_size(self.ui_renderer, sub, var_15_29[1], var_15_30)
					local var_15_32 = size[1]
					local var_15_33 = tbl_9

					if not var_15_18 and not var_15_18[2] then
						var_15_33, sub_2 = self:_find_second_input_texture(sub_2, str_2, var_15_18[2], var_15_29, var_15_30)
					end

					local size_2

					if not var_15_33.button_texture_data then
						size_2 = var_15_33.button_texture_data.size

						if not size_2 then
							-- Nothing
						end
					end

					size_2 = tbl_10

					::label_15_1::

					local button_texture_data = var_15_33.button_texture_data

					button_texture_data = not button_texture_data and var_15_33.button_texture_data.texture

					local icon_offset = var_15_33.icon_offset

					icon_offset = icon_offset or 0

					local text_size_2 = UIRenderer.text_size(self.ui_renderer, sub_2, var_15_29[1], var_15_30)
					local num_5 = text_size + var_15_32 + text_size_2 + size_2[1]
					local num_6 = -num_5 * 0.5 + text_size * 0.5 - var_15_32 * 0.05
					local num_7 = -num_5 * 0.5 + text_size + var_15_32 * 0.05 + var_15_32 * 0.5
					local num_8 = -num_5 * 0.5 + text_size + var_15_32 * 0.05 + var_15_32 * 0.5 + icon_offset + size_2[1] * 0.05 + size_2[1]
					local num_9 = -num_5 * 0.5 + text_size + var_15_32 * 0.5 + text_size_2 * 0.5 + var_15_32 * 0.5

					if text_size > var_0_0.MAXIMUM_TIP_WIDTH then
						local word_wrap = UIRenderer.word_wrap(self.ui_renderer, sub, var_15_29[1], var_15_30, var_0_0.MAXIMUM_TIP_WIDTH - text_size - var_15_32)

						sub = word_wrap[2]
						text_size = UIRenderer.text_size(self.ui_renderer, sub, var_15_29[1], var_15_30)

						local num_10 = text_size + var_15_32 + text_size_2

						num_6 = -num_10 * 0.5 + text_size * 0.5 - var_15_32 * 0.5
						num_7 = -num_10 * 0.5 + text_size + var_15_32 * 0.05
						num_9 = -num_10 * 0.5 + text_size + var_15_32 * 0.5 + text_size_2 * 0.5
						self.tip_text_prefix_widget.content.text = word_wrap[1]
						self.tip_text_prefix_widget.style.text.horizontal_alignment = "center"
						self.tip_text_prefix_widget.style.text.word_wrap = true
						self.second_row_tip_text_prefix_widget.style.text.offset[1] = num_6
						self.second_row_gamepad_input_icon.style.texture_id.offset[1] = num_7
						self.second_row_second_gamepad_input_icon.style.texture_id.offset[1] = num_8
						self.second_row_tip_text_suffix_widget.style.text.offset[1] = num_9
						self.tip_text_prefix_widget.style.text.offset[2] = 0
						self.second_row_tip_text_prefix_widget.style.text.offset[2] = 0
						self.second_row_gamepad_input_icon.style.texture_id.offset[2] = 0
						self.second_row_second_gamepad_input_icon.style.texture_id.offset[2] = 0
						self.second_row_tip_text_suffix_widget.style.text.offset[2] = 0
						self.second_row_tip_text_prefix_widget.content.text = sub
						self.second_row_gamepad_input_icon.content.texture_id = texture
						self.second_row_second_gamepad_input_icon.content.texture_id = button_texture_data
						self.second_row_tip_text_suffix_widget.content.text = sub_2
						self.ui_scenegraph.second_row_tip_text_prefix.size[1] = text_size
						self.ui_scenegraph.second_row_gamepad_input_icon.size = size
						self.ui_scenegraph.second_row_second_gamepad_input_icon.size = size_2
						self.ui_scenegraph.second_row_tip_text_suffix.size[1] = text_size_2
					elseif text_size_2 > var_0_0.MAXIMUM_TIP_WIDTH then
						local word_wrap_2 = UIRenderer.word_wrap(self.ui_renderer, sub_2, var_15_29[1], var_15_30, var_0_0.MAXIMUM_TIP_WIDTH - text_size - var_15_32)

						sub_2 = word_wrap_2[1]
						text_size_2 = UIRenderer.text_size(self.ui_renderer, sub_2, var_15_29[1], var_15_30)

						local num_11 = text_size + var_15_32 + text_size_2

						num_6 = -num_11 * 0.5 + text_size * 0.5 - var_15_32 * 0.5
						num_7 = -num_11 * 0.5 + text_size + var_15_32 * 0.05
						num_9 = -num_11 * 0.5 + text_size + var_15_32 * 0.5 + text_size_2 * 0.5
						self.second_row_tip_text_prefix_widget.content.text = word_wrap_2[2]
						self.second_row_tip_text_prefix_widget.style.text.horizontal_alignment = "center"
						self.second_row_tip_text_prefix_widget.style.text.word_wrap = true
						self.tip_text_prefix_widget.style.text.offset[1] = num_6
						self.gamepad_input_icon.style.texture_id.offset[1] = num_7
						self.second_gamepad_input_icon.style.texture_id.offset[1] = num_8
						self.tip_text_suffix_widget.style.text.offset[1] = num_9
						self.second_row_tip_text_prefix_widget.style.text.offset[2] = 0
						self.tip_text_prefix_widget.style.text.offset[2] = 0
						self.gamepad_input_icon.style.texture_id.offset[2] = 0
						self.second_gamepad_input_icon.style.texture_id.offset[2] = 0
						self.tip_text_suffix_widget.style.text.offset[2] = 0
						self.tip_text_prefix_widget.content.text = sub
						self.gamepad_input_icon.content.texture_id = texture
						self.second_gamepad_input_icon.content.texture_id = button_texture_data
						self.tip_text_suffix_widget.content.text = sub_2
						self.ui_scenegraph.tip_text_prefix.size[1] = text_size
						self.ui_scenegraph.gamepad_input_icon.size = size
						self.ui_scenegraph.second_gamepad_input_icon.size = size_2
						self.ui_scenegraph.tip_text_suffix.size[1] = text_size_2
					else
						self.ui_scenegraph.tip_text_prefix.size[1] = text_size
						self.ui_scenegraph.gamepad_input_icon.size = size
						self.ui_scenegraph.second_gamepad_input_icon.size = size_2
						self.ui_scenegraph.tip_text_suffix.size[1] = text_size_2
						self.tip_text_prefix_widget.style.text.offset[1] = num_6
						self.gamepad_input_icon.style.texture_id.offset[1] = num_7
						self.second_gamepad_input_icon.style.texture_id.offset[1] = num_8
						self.tip_text_suffix_widget.style.text.offset[1] = num_9
						self.tip_text_prefix_widget.style.text.offset[2] = 0
						self.gamepad_input_icon.style.texture_id.offset[2] = 0
						self.second_gamepad_input_icon.style.texture_id.offset[2] = 0
						self.tip_text_suffix_widget.style.text.offset[2] = 0
						self.tip_text_prefix_widget.content.text = sub
						self.gamepad_input_icon.content.texture_id = texture
						self.second_gamepad_input_icon.content.texture_id = button_texture_data
						self.tip_text_suffix_widget.content.text = sub_2
					end
				end
			end
		end

		if not var_15_16 then
			local var_15_47 = Localize(arg_15_3)

			self.tip_text_prefix_widget.content.text = var_15_47
			self.tip_text_prefix_widget.style.text.horizontal_alignment = "center"
			self.tip_text_prefix_widget.style.text.word_wrap = true
		end
	end
end

LoadingView.setup_act_text = function (arg_16_0, arg_16_1)
	-- function 16
	if not arg_16_1 then
		local act = LevelSettings[arg_16_1].act

		if not act then
			local str = act .. "_ls"
			local var_16_2 = Localize(str)

			arg_16_0.act_name_widget.content.text = var_16_2
			arg_16_0.act_name_bg_widget.content.text = var_16_2
		end
	end
end

LoadingView.setup_level_text = function (arg_17_0, arg_17_1)
	-- function 17
	if not arg_17_1 then
		local display_name = LevelSettings[arg_17_1].display_name

		if not display_name then
			local var_17_1 = Localize(display_name)

			arg_17_0.level_name_widget.content.text = var_17_1
			arg_17_0.level_name_bg_widget.content.text = var_17_1
		end
	end
end

LoadingView.setup_difficulty_text = function (arg_18_0, arg_18_1)
	-- function 18
	if not arg_18_1 then
		local display_name = DifficultySettings[arg_18_1].display_name
		local var_18_1 = Localize(display_name)

		arg_18_0.game_difficulty_widget.content.text = var_18_1
		arg_18_0.game_difficulty_bg_widget.content.text = var_18_1
	end
end

LoadingView.setup_news_ticker = function (self, arg_19_1)
	-- function 19
	local news_ticker_text_widget = self.news_ticker_text_widget
	local content = news_ticker_text_widget.content
	local style = news_ticker_text_widget.style

	content.text = arg_19_1

	local text = style.text
	local font_type = text.font_type
	local var_19_5, var_19_6 = UIFontByResolution(text)
	local text_size, var_19_8, var_19_9 = UIRenderer.text_size(self.ui_renderer, arg_19_1, var_19_5[1], var_19_6)

	self.news_ticker_text_width = text_size
	self.news_ticker_started = true
end

local flag = false

LoadingView.update = function (self, arg_20_1)
	-- function 20
	if not flag then
		print("reload")
		self:create_ui_elements()

		flag = false
	end

	if not self.active then
		return
	end

	VisualAssertLog.update(arg_20_1)

	local is_device_active = Managers.input:is_device_active("gamepad")

	if is_device_active ~= self._gamepad_active then
		local level_key = self.level_key

		level_key = not level_key and LevelSettings[self.level_key]

		local game_mode

		if not level_key then
			game_mode = level_key.game_mode

			if not game_mode then
				-- Nothing
			end
		end

		game_mode = "adventure"

		::label_20_0::

		self:setup_tip_text(self.act_progression_index, game_mode, self._tip_localization_key)

		self._gamepad_active = is_device_active
	end

	if not (script_data.disable_news_ticker or self.news_ticker_started) then
		local loading_screen_text = self.news_ticker_manager:loading_screen_text()

		if not loading_screen_text then
			self:setup_news_ticker(loading_screen_text)
		end
	end

	if not self.subtitle_timed_gui then
		self.subtitle_timed_gui:update(self.ui_renderer, arg_20_1)
	end

	self:draw(arg_20_1)
end

LoadingView.draw = function (self, arg_21_1)
	-- function 21
	local ui_renderer = self.ui_renderer
	local _ui_hdr_renderer = self._ui_hdr_renderer
	local ui_scenegraph = self.ui_scenegraph

	if script_data.disable_news_ticker or not self.news_ticker_started then
		local local_position = ui_scenegraph.news_ticker_text.local_position

		if local_position[1] + self.news_ticker_text_width <= 0 then
			local_position[1] = 1920
		end

		local_position[1] = local_position[1] - arg_21_1 * self.news_ticker_speed
	end

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, FAKE_INPUT_SERVICE, arg_21_1, nil, self.render_settings)

	for i = 1, #self.widgets do
		UIRenderer.draw_widget(ui_renderer, self.widgets[i])
	end

	if not self._show_press_to_continue then
		UIRenderer.draw_widget(ui_renderer, self._press_to_continue_widget)
	end

	UIRenderer.end_pass(ui_renderer)

	if not self.weave_loading_icon then
		UIRenderer.begin_pass(_ui_hdr_renderer, ui_scenegraph, FAKE_INPUT_SERVICE, arg_21_1, nil, self.render_settings)
		UIRenderer.draw_widget(_ui_hdr_renderer, self.weave_loading_icon)
		UIRenderer.end_pass(_ui_hdr_renderer)
	end
end

LoadingView.destroy = function (self)
	-- function 22
	VisualAssertLog.cleanup()
	UIRenderer.destroy(self.ui_renderer, self.world)

	if not self._ui_hdr_world then
		UIRenderer.destroy(self._ui_hdr_renderer, self._ui_hdr_world)
		Managers.world:destroy_world(self._ui_hdr_world)
	end

	Managers.transition:show_loading_icon()
end

LoadingView.is_done = function (arg_23_0)
	-- function 23
	return true
end
