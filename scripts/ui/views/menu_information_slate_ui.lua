-- chunkname: @scripts/ui/views/menu_information_slate_ui.lua

local var_0_0 = local_require("scripts/ui/views/menu_information_slate_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widget_definitions = var_0_0.widget_definitions
local animation_definitions = var_0_0.animation_definitions
local body_parsing_data = var_0_0.body_parsing_data
local create_switch_panel_func = var_0_0.create_switch_panel_func

MenuInformationSlateUI = class(MenuInformationSlateUI)

local str = "gui/1080p/single_textures/generic/transparent_placeholder_texture"
local str_2 = "cdn.fatsharkgames.se"
local str_3 = "vermintide2"
local str_4 = "information.json"

if not IS_CONSOLE then
	str_4 = "information_" .. PLATFORM .. ".json"
end

MenuInformationSlateUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._ui_renderer = arg_1_1
	self._input_service = arg_1_2
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._cloned_materials_by_reference = {}
	self._material_references_to_unload = {}
	self._scrollbar_alpha = 0
	self._current_information_data_index = 1
	self._information_data = {}
	self._animations = {}
	self._ui_animations = {}

	self:_fetch_backend_information()
end

MenuInformationSlateUI._start_animation = function (self, arg_2_1)
	-- function 2
	if not self._information_available then
		return
	end

	local tbl = {
		render_settings = self._render_settings,
		ui_scenegraph = self._ui_scenegraph
	}
	local _widgets_by_name = self._widgets_by_name
	local var_2_2 = self._animations[arg_2_1]

	if not var_2_2 then
		self._ui_animator:stop_animation(var_2_2)
	end

	local start_animation = self._ui_animator:start_animation(arg_2_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

MenuInformationSlateUI.show = function (self)
	-- function 3
	if not (not self._information_data and not (#self._information_data > 1)) then
		self:_start_animation("animate_switch_panel_in")
	end

	self:_start_animation("animate_in")
end

MenuInformationSlateUI.hide = function (self)
	-- function 4
	if not (not self._information_data and not (#self._information_data > 1)) then
		self:_start_animation("animate_switch_panel_out")
	end

	self:_start_animation("animate_out")

	self._expanded = false
end

MenuInformationSlateUI._create_ui_elements = function (self)
	-- function 5
	self:_reset()

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	self._expanded = false
end

MenuInformationSlateUI._reset = function (self)
	-- function 6
	for k, v in pairs(self._animations) do
		self._ui_animator:stop_animation(v)
	end

	table.clear(self._animations)
	table.clear(self._ui_animations)

	local tbl = {}
	local tbl_2 = {}

	for k_2, v_2 in pairs(widget_definitions) do
		local var_6_2 = UIWidget.init(v_2)

		tbl_2[k_2] = var_6_2
		tbl[#tbl + 1] = var_6_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._body_widgets = {}
end

MenuInformationSlateUI._fetch_backend_information = function (self)
	-- function 7
	if not IS_CONSOLE then
		self:_fetch_cdn_data(str_3 .. "/" .. str_4, callback(self, "_parse_cdn_data"))
	else
		local get_title_data = Managers.backend:get_title_data("information")
		local flag = not get_title_data and cjson.decode(get_title_data)

		if not (not flag and table.is_empty(flag)) then
			self._information_data = flag

			local var_7_2 = flag[1]

			var_7_2 = var_7_2 or flag

			self:_create_ui_elements()
			self:_parse_information_data(var_7_2)

			if #self._information_data > 1 then
				self:_create_switch_panel()
				self:_start_animation("animate_switch_panel_in")
			end

			self:_start_animation("animate_in")
		end
	end
end

local function fn(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local tbl = {
		done = false
	}

	if not (not arg_8_0 and not (arg_8_1 >= 200) or not (arg_8_1 < 300)) then
		tbl.done = true
		tbl.data = arg_8_3
	end

	arg_8_4(tbl)
end

MenuInformationSlateUI._fetch_cdn_data = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	if not rawget(_G, "Http") then
		local get_uri = Http.get_uri(str_2, 80, arg_9_1)

		if not get_uri then
			local find = string.find(get_uri, "HTTP/1.1 200 OK")

			find = find or string.find(get_uri, "HTTP/1.0 200 OK")

			if not find then
				local find_2, var_9_3 = string.find(get_uri, "\r\n\r\n")
				local str = ""

				if not var_9_3 then
					str = string.sub(get_uri, var_9_3 + 1)
				end

				local tbl = {
					success = true,
					done = true,
					message = str
				}

				arg_9_2(tbl)
			else
				local tbl_2 = {
					done = true,
					message = "CDN data fetch failed",
					success = false
				}

				arg_9_2(tbl_2)
			end
		else
			local tbl_3 = {
				done = true,
				message = "CDN data not available",
				success = false
			}

			arg_9_2(tbl_3)
		end
	else
		local tbl_4 = {
			done = true,
			message = "This executable is built without Http. Menu Slate UI will be unavailable.",
			success = false
		}

		arg_9_2(tbl_4)
	end
end

MenuInformationSlateUI._parse_cdn_data = function (self, arg_10_1)
	-- function 10
	if not arg_10_1.success then
		Application.warning("[MenuInformationSlateUI] " .. arg_10_1.message)

		return
	end

	local message = arg_10_1.message
	local flag = not message and cjson.decode(message)

	if not (not flag and table.is_empty(flag)) then
		self._information_data = flag

		local var_10_2 = flag[1]

		var_10_2 = var_10_2 or flag

		self:_create_ui_elements()
		self:_parse_information_data(var_10_2)

		if #self._information_data > 1 then
			self:_create_switch_panel()
			self:_start_animation("animate_switch_panel_in")
		end

		self:_start_animation("animate_in")
	end
end

MenuInformationSlateUI._create_switch_panel = function (self)
	-- function 11
	self._ui_scenegraph.panel.local_position[2] = scenegraph_definition.panel.position[2] - 50

	local var_11_0 = create_switch_panel_func(self._information_data)
	local var_11_1 = UIWidget.init(var_11_0)

	var_11_1.content.current_index = self._current_information_data_index
	self._switch_widget = var_11_1
	self._widgets_by_name.switch_panel = var_11_1
end

MenuInformationSlateUI._parse_information_data = function (self, arg_12_1)
	-- function 12
	local alert_name = arg_12_1.alert_name
	local alert_color = arg_12_1.alert_color
	local header = arg_12_1.header
	local sub_header = arg_12_1.sub_header

	self._widgets_by_name.alert_name.content.text = alert_name
	self._widgets_by_name.dot.style.texture_id.color = alert_color
	self._widgets_by_name.dot_glow.style.texture_id.color = alert_color
	self._widgets_by_name.top_banner.style.rect.color = alert_color
	self._widgets_by_name.header.content.text = header
	self._widgets_by_name.sub_header.content.text = sub_header

	local body = arg_12_1.body
	local num = 0

	if not body then
		for i, v in ipairs(body) do
			local type = v.type
			local var_12_7 = self["_parse_" .. type .. "_data"]

			if not var_12_7 then
				num = var_12_7(self, v, i, num)
			else
				fassert(false, "[MenuInformationSlateUi] There is no parse function for type %q", type)
			end
		end
	end

	local num_2 = math.abs(num) - 590

	if num_2 > 0 then
		local _ui_scenegraph = self._ui_scenegraph
		local str = "body_anchor"
		local str_2 = "scrolbar_window"
		local var_12_12 = num_2
		local flag = false
		local var_12_14
		local var_12_15

		self._scrollbar_ui = ScrollbarUI:new(_ui_scenegraph, str, str_2, var_12_12, flag, var_12_14, var_12_15)
	else
		self._scrollbar_ui = nil

		local str_3 = "body_anchor"

		self._ui_scenegraph[str_3].local_position[2] = 0
	end

	self._information_available = true
end

MenuInformationSlateUI._parse_text_data = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local text = body_parsing_data.text
	local spacing = text.spacing
	local clone = table.clone(text.default_text_style)
	local font_size = arg_13_1.font_size

	font_size = font_size or clone.font_size
	clone.font_size = font_size

	local font_type = arg_13_1.font_type

	font_type = font_type or clone.font_type
	clone.font_type = font_type

	local color = arg_13_1.color

	color = color or clone.text_color
	clone.text_color = color

	local text_2 = arg_13_1.text
	local hint = arg_13_1.hint
	local var_13_8, var_13_9 = UIFontByResolution(clone)
	local var_13_10 = var_13_8[1]
	local var_13_11 = var_13_9
	local gui = self._ui_renderer.gui
	local var_13_13, var_13_14, var_13_15 = UIGetFontHeight(gui, clone.font_type, var_13_11)
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local num = (var_13_15 - var_13_14) * inv_scale

	if hint == "bullet_points" then
		clone.offset[1] = 20
		arg_13_3 = arg_13_3 + spacing

		local num_2 = 1
		local split_deprecated = string.split_deprecated(text_2, "|")

		for i, v in ipairs(split_deprecated) do
			local match = string.match(v, "%$INDENT;[%a%d_]*:")

			if not match then
				local find = string.find(match, ";")

				num_2 = tonumber(string.sub(match, find + 1, -2))
			end

			local clone_2 = table.clone(clone)

			clone_2.offset[1] = clone_2.offset[1] + (num_2 - 1) * 30
			clone_2.area_size = {
				405 - 30 * (num_2 - 1),
				50
			}
			v = string.gsub(v, "%$INDENT;[%a%d_]*:", "")

			local create_simple_text = UIWidgets.create_simple_text(v, "body_anchor", nil, nil, clone_2)
			local var_13_24 = UIWidget.init(create_simple_text)

			self._body_widgets[#self._body_widgets + 1] = var_13_24
			self._widgets_by_name["text_" .. arg_13_2 .. "_bullet_point_" .. i] = var_13_24
			var_13_24.offset[2] = arg_13_3

			local var_13_25
			local var_13_26
			local var_13_27
			local flag = true

			if num_2 > 2 then
				local create_simple_texture = UIWidgets.create_simple_texture("rect_masked", "body_anchor", flag, nil, {
					255,
					192,
					192,
					192
				}, {
					clone_2.offset[1] - 30 + 10,
					arg_13_3 - 3 - 8,
					1
				}, {
					5,
					5
				})

				create_simple_texture.style.texture_id.horizontal_alignment = "left"
				create_simple_texture.style.texture_id.vertical_alignment = "top"
				var_13_27 = UIWidget.init(create_simple_texture)
				self._body_widgets[#self._body_widgets + 1] = var_13_27
				self._widgets_by_name["text_" .. arg_13_2 .. "_bullet_point_dash_" .. i] = var_13_27
			else
				local create_simple_texture_2 = UIWidgets.create_simple_texture("dot", "body_anchor", flag, nil, {
					255,
					192,
					192,
					192
				}, {
					clone_2.offset[1] - 30,
					arg_13_3 - 3,
					1
				}, {
					20,
					20
				})

				create_simple_texture_2.style.texture_id.horizontal_alignment = "left"
				create_simple_texture_2.style.texture_id.vertical_alignment = "top"
				var_13_25 = UIWidget.init(create_simple_texture_2)
				self._body_widgets[#self._body_widgets + 1] = var_13_25
				self._widgets_by_name["text_" .. arg_13_2 .. "_bullet_point_dot_" .. i] = var_13_25

				if num_2 == 2 then
					local flag_2 = true
					local create_simple_texture_3 = UIWidgets.create_simple_texture("dot", "body_anchor", flag_2, nil, {
						255,
						0,
						0,
						0
					}, {
						clone_2.offset[1] - 30 + 3,
						arg_13_3 - 3 - 3,
						2
					}, {
						14,
						14
					})

					create_simple_texture_3.style.texture_id.horizontal_alignment = "left"
					create_simple_texture_3.style.texture_id.vertical_alignment = "top"
					var_13_26 = UIWidget.init(create_simple_texture_3)
					self._body_widgets[#self._body_widgets + 1] = var_13_26
					self._widgets_by_name["text_" .. arg_13_2 .. "_bullet_point_inner_dot_" .. i] = var_13_26
				end
			end

			local word_wrap, var_13_34 = UIRenderer.word_wrap(self._ui_renderer, v, var_13_10, var_13_11, clone_2.area_size[1])

			var_13_24.widget_height = num * #word_wrap

			if not var_13_25 then
				var_13_25.widget_height = var_13_24.widget_height
			end

			if not var_13_26 then
				var_13_26.widget_height = var_13_24.widget_height
			end

			if not var_13_27 then
				var_13_27.widget_height = var_13_24.widget_height
			end

			local num_3 = arg_13_3 - var_13_24.widget_height
			local num_4

			if #word_wrap > 1 then
				num_4 = spacing * 0.5

				if not num_4 then
					-- Nothing
				end
			end

			num_4 = 0

			::label_13_0::

			arg_13_3 = num_3 - num_4
		end

		arg_13_3 = arg_13_3 - spacing
	else
		local create_simple_text_2 = UIWidgets.create_simple_text(text_2, "body_anchor", nil, nil, clone)
		local var_13_38 = UIWidget.init(create_simple_text_2)

		self._body_widgets[#self._body_widgets + 1] = var_13_38
		self._widgets_by_name["text_" .. arg_13_2] = var_13_38
		var_13_38.offset[2] = arg_13_3

		local word_wrap_2, var_13_40 = UIRenderer.word_wrap(self._ui_renderer, text_2, var_13_10, var_13_11, self._ui_scenegraph.body_anchor.size[1])

		var_13_38.widget_height = num * #word_wrap_2
		arg_13_3 = arg_13_3 - var_13_38.widget_height - spacing
	end

	return arg_13_3
end

MenuInformationSlateUI._parse_image_data = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local image = body_parsing_data.image
	local image_name = arg_14_1.image_name
	local image_size = arg_14_1.image_size
	local flag = true
	local str = "image_" .. arg_14_2
	local var_14_5 = image_size[2]

	local function fn()
		-- function 15
		local var_15_0 = self._cloned_materials_by_reference[str]
		local create_simple_texture = UIWidgets.create_simple_texture(var_15_0, "body_anchor")

		create_simple_texture.style.texture_id.horizontal_alignment = "left"
		create_simple_texture.style.texture_id.vertical_alignment = "top"

		local var_15_2 = UIWidget.init(create_simple_texture)

		var_15_2.offset[2] = arg_14_3
		var_15_2.style.texture_id.texture_size = image_size
		self._body_widgets[#self._body_widgets + 1] = var_15_2
		self._widgets_by_name[str] = var_15_2
		var_15_2.widget_height = var_14_5
		var_15_2.is_image = true
	end

	self:_setup_backend_image_material(image_name, flag, str, fn)

	return arg_14_3 - var_14_5 - image.spacing
end

MenuInformationSlateUI._setup_backend_image_material = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local flag = arg_16_3 or arg_16_1
	local str = "MenuInformationSlateUI_" .. flag
	local flag_2

	flag_2 = not arg_16_2 and "template_diffuse_masked" and "template_diffuse"

	self:_create_material_instance(str, flag_2, flag)

	if not IS_CONSOLE then
		self._material_references_to_unload[flag] = true

		local flag_3 = false
		local var_16_4 = callback(self, "_cb_on_backend_image_loaded", str, flag, arg_16_4, arg_16_1, flag_3)

		Managers.url_loader:load_resource(flag, "http://" .. str_2 .. "/" .. str_3 .. "/" .. arg_16_1 .. ".dds", var_16_4, Application.guid())
	else
		local get_interface = Managers.backend:get_interface("cdn")
		local var_16_6 = callback(self, "_cb_on_backend_url_loaded", arg_16_1, flag, str, arg_16_4)

		get_interface:get_resource_urls({
			arg_16_1
		}, var_16_6)
	end
end

MenuInformationSlateUI._create_material_instance = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	self._cloned_materials_by_reference[arg_17_3] = arg_17_1

	return Gui.clone_material_from_template(self._ui_renderer.gui, arg_17_1, arg_17_2)
end

MenuInformationSlateUI._cb_on_backend_url_loaded = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	local var_18_0 = arg_18_5[arg_18_1]

	if not var_18_0 then
		local flag = false

		arg_18_0._material_references_to_unload[arg_18_2] = true

		local var_18_2 = callback(arg_18_0, "_cb_on_backend_image_loaded", arg_18_3, arg_18_2, arg_18_4, arg_18_1, flag)

		Managers.url_loader:load_resource(arg_18_2, "http://" .. str_2 .. "/" .. str_3 .. "/" .. arg_18_1 .. ".dds", var_18_2, Application.guid())

		return
	end

	arg_18_0._material_references_to_unload[arg_18_2] = true

	local flag_2 = true
	local var_18_4 = callback(arg_18_0, "_cb_on_backend_image_loaded", arg_18_3, arg_18_2, arg_18_4, arg_18_1, flag_2)

	Managers.url_loader:load_resource(arg_18_2, var_18_0, var_18_4, arg_18_1)
end

MenuInformationSlateUI._cb_on_backend_image_loaded = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	-- function 19
	if not self._cloned_materials_by_reference[arg_19_2] then
		return
	end

	if not arg_19_6 then
		self:_set_material_diffuse_by_resource(arg_19_1, arg_19_6)
		arg_19_3()
	elseif not arg_19_5 then
		local flag = false

		self._material_references_to_unload[arg_19_2] = true

		local var_19_1 = callback(self, "_cb_on_backend_image_loaded", arg_19_1, arg_19_2, arg_19_3, arg_19_4, flag)

		Managers.url_loader:load_resource(arg_19_2, "http://" .. str_2 .. "/" .. str_3 .. "/" .. arg_19_4 .. ".dds", var_19_1, Application.guid())
	else
		self._material_references_to_unload[arg_19_2] = nil

		Application.warning(string.format("[StoreWindowFeatured] - Failed loading image for reference name: (%s)", arg_19_2))
	end
end

MenuInformationSlateUI._set_material_diffuse_by_resource = function (self, arg_20_1, arg_20_2)
	-- function 20
	local material = Gui.material(self._ui_renderer.gui, arg_20_1)

	if not material then
		Material.set_resource(material, "diffuse_map", arg_20_2)
	end
end

MenuInformationSlateUI._update_input = function (self, arg_21_1, arg_21_2)
	-- function 21
	local get

	if not IS_CONSOLE then
		get = self._input_service:get("start_press")

		if not get then
			-- Nothing
		end
	end

	get = self._input_service:get("special_1_press")

	::label_21_0::

	get = get or UIUtils.is_button_pressed(self._widgets_by_name.more_information, "hotspot")
	get = get or UIUtils.is_button_pressed(self._widgets_by_name.less_information, "hotspot")

	local expand = self._animations.expand

	expand = expand or self._animations.collapse

	if not (not get and expand) then
		if not self._expanded then
			self._expanded = true

			self:_start_animation("expand")
			self:_play_sound("play_gui_info_slate_more_information_open")
		else
			self._expanded = false

			self:_start_animation("collapse")
			self:_play_sound("play_gui_info_slate_more_information_close")
		end

		return
	elseif UIUtils.is_button_hover_enter(self._widgets_by_name.more_information, "hotspot") or not UIUtils.is_button_hover_enter(self._widgets_by_name.less_information, "hotspot") then
		self:_play_sound("play_gui_info_slate_more_information_hover")
	end

	if #self._information_data > 1 then
		local _current_information_data_index = self._current_information_data_index
		local switch_panel = self._widgets_by_name.switch_panel

		for i = 1, #self._information_data do
			local str = "slate_" .. i

			if not UIUtils.is_button_pressed(switch_panel, str .. "_hotspot") then
				self:_play_sound("play_gui_info_slate_tab_clicked")

				if i ~= self._current_information_data_index then
					self._current_information_data_index = i

					break
				end
			elseif not UIUtils.is_button_hover_enter(switch_panel, str .. "_hotspot") then
				self:_play_sound("play_gui_info_slate_tab_hover")

				break
			end
		end

		if UIUtils.is_button_pressed(switch_panel, "left_arrow_hotspot") or self._input_service:get("previous") or not IS_WINDOWS or not self._input_service:get("left") then
			self._current_information_data_index = math.max(self._current_information_data_index - 1, 1)

			self:_play_sound("play_gui_info_slate_tab_arrow_clicked")
		elseif UIUtils.is_button_pressed(switch_panel, "right_arrow_hotspot") or self._input_service:get("next") or not IS_WINDOWS or not self._input_service:get("right") then
			self._current_information_data_index = math.min(self._current_information_data_index + 1, #self._information_data)

			self:_play_sound("play_gui_info_slate_tab_arrow_clicked")
		elseif UIUtils.is_button_hover_enter(switch_panel, "left_arrow_hotspot") or not UIUtils.is_button_hover_enter(switch_panel, "right_arrow_hotspot") then
			self:_play_sound("play_gui_info_slate_tab_arrow_hover")
		end

		if _current_information_data_index ~= self._current_information_data_index then
			self:_populate_info_slate()
		end
	end
end

MenuInformationSlateUI._populate_info_slate = function (self)
	-- function 22
	local var_22_0 = self._information_data[self._current_information_data_index]

	self:_reset()
	self:_parse_information_data(var_22_0)
	self:_create_switch_panel()

	if not self._expanded then
		self:_start_animation("expand_instantly")
	else
		self:_start_animation("collapse_instantly")
	end

	self:_start_animation("animate_in")
	self:_play_sound("play_gui_info_slate_tab_changed")
end

MenuInformationSlateUI._update_animations = function (self, arg_23_1, arg_23_2)
	-- function 23
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_23_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_23_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

MenuInformationSlateUI.update = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not self._information_available then
		return
	end

	self:_update_animations(arg_24_1, arg_24_2)
	self:_update_input(arg_24_1, arg_24_2)
	self:_draw(arg_24_1, arg_24_2)
end

MenuInformationSlateUI._draw = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_service = self._input_service
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, _input_service, arg_25_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	if not (self._expanded or table.is_empty(self._animations)) then
		local var_25_4 = self._ui_scenegraph.body_anchor.local_position[2]
		local num = 0
		local num_2 = -var_0_0.panel_scroll_area

		for i_2, v_2 in ipairs(self._body_widgets) do
			local num_3 = v_2.offset[2] + var_25_4

			if not (not (num > num_3 - v_2.widget_height) or not (num_2 < num_3)) then
				UIRenderer.draw_widget(_ui_renderer, v_2)
			end
		end
	end

	if not self._switch_widget then
		local alpha_multiplier = _render_settings.alpha_multiplier

		_render_settings.alpha_multiplier = self._switch_widget.content.alpha_value

		UIRenderer.draw_widget(_ui_renderer, self._switch_widget)

		_render_settings.alpha_multiplier = alpha_multiplier
	end

	UIRenderer.end_pass(_ui_renderer)

	if not self._expanded then
		local alpha_multiplier_2 = _render_settings.alpha_multiplier

		_render_settings.alpha_multiplier = _render_settings.scrollbar_alpha

		if not self._scrollbar_ui then
			self._scrollbar_ui:update(arg_25_1, arg_25_2, _ui_renderer, _input_service, _render_settings)
		end

		_render_settings.alpha_multiplier = alpha_multiplier_2
	end
end

MenuInformationSlateUI.destroy = function (self)
	-- function 26
	self:_reset_cloned_materials()
end

MenuInformationSlateUI._is_unique_reference_to_material = function (self, arg_27_1)
	-- function 27
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local var_27_1 = _cloned_materials_by_reference[arg_27_1]

	fassert(var_27_1, "[MenuInformationSlateUI] - Could not find a used material for reference name: (%s)", arg_27_1)

	for k, v in pairs(_cloned_materials_by_reference) do
		if not (var_27_1 ~= v or arg_27_1 == k) then
			return false
		end
	end

	return true
end

MenuInformationSlateUI._set_material_diffuse_by_path = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local material = Gui.material(arg_28_1, arg_28_2)

	if not material then
		Material.set_texture(material, "diffuse_map", arg_28_3)
	end
end

MenuInformationSlateUI._reset_cloned_materials = function (self)
	-- function 29
	local gui = self._ui_renderer.gui
	local _material_references_to_unload = self._material_references_to_unload
	local _cloned_materials_by_reference = self._cloned_materials_by_reference

	for k, v in pairs(_cloned_materials_by_reference) do
		if not _material_references_to_unload[k] then
			_material_references_to_unload[k] = nil

			Managers.url_loader:unload_resource(k)
		end

		if not self:_is_unique_reference_to_material(k) then
			self:_set_material_diffuse_by_path(gui, v, str)
		end

		_cloned_materials_by_reference[k] = nil
	end
end

MenuInformationSlateUI._play_sound = function (arg_30_0, arg_30_1)
	-- function 30
	return Managers.music:trigger_event(arg_30_1)
end
