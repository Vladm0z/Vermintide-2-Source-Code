-- chunkname: @scripts/ui/views/menu_information_slate_ui.lua

local var_0_0 = local_require("scripts/ui/views/menu_information_slate_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.body_parsing_data
local var_0_5 = var_0_0.create_switch_panel_func

MenuInformationSlateUI = class(MenuInformationSlateUI)

local var_0_6 = "gui/1080p/single_textures/generic/transparent_placeholder_texture"
local var_0_7 = "cdn.fatsharkgames.se"
local var_0_8 = "vermintide2"
local var_0_9 = "information.json"

if IS_CONSOLE then
	var_0_9 = "information_" .. PLATFORM .. ".json"
end

MenuInformationSlateUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._ui_renderer = arg_1_1
	arg_1_0._input_service = arg_1_2
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._cloned_materials_by_reference = {}
	arg_1_0._material_references_to_unload = {}
	arg_1_0._scrollbar_alpha = 0
	arg_1_0._current_information_data_index = 1
	arg_1_0._information_data = {}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_fetch_backend_information()
end

MenuInformationSlateUI._start_animation = function (arg_2_0, arg_2_1)
	if not arg_2_0._information_available then
		return
	end

	local var_2_0 = {
		render_settings = arg_2_0._render_settings,
		ui_scenegraph = arg_2_0._ui_scenegraph
	}
	local var_2_1 = arg_2_0._widgets_by_name
	local var_2_2 = arg_2_0._animations[arg_2_1]

	if var_2_2 then
		arg_2_0._ui_animator:stop_animation(var_2_2)
	end

	local var_2_3 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_3
end

MenuInformationSlateUI.show = function (arg_3_0)
	if arg_3_0._information_data and #arg_3_0._information_data > 1 then
		arg_3_0:_start_animation("animate_switch_panel_in")
	end

	arg_3_0:_start_animation("animate_in")
end

MenuInformationSlateUI.hide = function (arg_4_0)
	if arg_4_0._information_data and #arg_4_0._information_data > 1 then
		arg_4_0:_start_animation("animate_switch_panel_out")
	end

	arg_4_0:_start_animation("animate_out")

	arg_4_0._expanded = false
end

MenuInformationSlateUI._create_ui_elements = function (arg_5_0)
	arg_5_0:_reset()

	arg_5_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	UIRenderer.clear_scenegraph_queue(arg_5_0._ui_renderer)

	arg_5_0._ui_animator = UIAnimator:new(arg_5_0._ui_scenegraph, var_0_3)
	arg_5_0._expanded = false
end

MenuInformationSlateUI._reset = function (arg_6_0)
	for iter_6_0, iter_6_1 in pairs(arg_6_0._animations) do
		arg_6_0._ui_animator:stop_animation(iter_6_1)
	end

	table.clear(arg_6_0._animations)
	table.clear(arg_6_0._ui_animations)

	local var_6_0 = {}
	local var_6_1 = {}

	for iter_6_2, iter_6_3 in pairs(var_0_2) do
		local var_6_2 = UIWidget.init(iter_6_3)

		var_6_1[iter_6_2] = var_6_2
		var_6_0[#var_6_0 + 1] = var_6_2
	end

	arg_6_0._widgets = var_6_0
	arg_6_0._widgets_by_name = var_6_1
	arg_6_0._body_widgets = {}
end

MenuInformationSlateUI._fetch_backend_information = function (arg_7_0)
	if IS_CONSOLE then
		arg_7_0:_fetch_cdn_data(var_0_8 .. "/" .. var_0_9, callback(arg_7_0, "_parse_cdn_data"))
	else
		local var_7_0 = Managers.backend:get_title_data("information")
		local var_7_1 = var_7_0 and cjson.decode(var_7_0)

		if var_7_1 and not table.is_empty(var_7_1) then
			arg_7_0._information_data = var_7_1

			local var_7_2 = var_7_1[1] or var_7_1

			arg_7_0:_create_ui_elements()
			arg_7_0:_parse_information_data(var_7_2)

			if #arg_7_0._information_data > 1 then
				arg_7_0:_create_switch_panel()
				arg_7_0:_start_animation("animate_switch_panel_in")
			end

			arg_7_0:_start_animation("animate_in")
		end
	end
end

local function var_0_10(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = {
		done = false
	}

	if arg_8_0 and arg_8_1 >= 200 and arg_8_1 < 300 then
		var_8_0.done = true
		var_8_0.data = arg_8_3
	end

	arg_8_4(var_8_0)
end

MenuInformationSlateUI._fetch_cdn_data = function (arg_9_0, arg_9_1, arg_9_2)
	if rawget(_G, "Http") then
		local var_9_0 = Http.get_uri(var_0_7, 80, arg_9_1)

		if var_9_0 then
			if string.find(var_9_0, "HTTP/1.1 200 OK") or string.find(var_9_0, "HTTP/1.0 200 OK") then
				local var_9_1, var_9_2 = string.find(var_9_0, "\r\n\r\n")
				local var_9_3 = ""

				if var_9_2 then
					var_9_3 = string.sub(var_9_0, var_9_2 + 1)
				end

				local var_9_4 = {
					success = true,
					done = true,
					message = var_9_3
				}

				arg_9_2(var_9_4)
			else
				local var_9_5 = {
					done = true,
					message = "CDN data fetch failed",
					success = false
				}

				arg_9_2(var_9_5)
			end
		else
			local var_9_6 = {
				done = true,
				message = "CDN data not available",
				success = false
			}

			arg_9_2(var_9_6)
		end
	else
		local var_9_7 = {
			done = true,
			message = "This executable is built without Http. Menu Slate UI will be unavailable.",
			success = false
		}

		arg_9_2(var_9_7)
	end
end

MenuInformationSlateUI._parse_cdn_data = function (arg_10_0, arg_10_1)
	if not arg_10_1.success then
		Application.warning("[MenuInformationSlateUI] " .. arg_10_1.message)

		return
	end

	local var_10_0 = arg_10_1.message
	local var_10_1 = var_10_0 and cjson.decode(var_10_0)

	if var_10_1 and not table.is_empty(var_10_1) then
		arg_10_0._information_data = var_10_1

		local var_10_2 = var_10_1[1] or var_10_1

		arg_10_0:_create_ui_elements()
		arg_10_0:_parse_information_data(var_10_2)

		if #arg_10_0._information_data > 1 then
			arg_10_0:_create_switch_panel()
			arg_10_0:_start_animation("animate_switch_panel_in")
		end

		arg_10_0:_start_animation("animate_in")
	end
end

MenuInformationSlateUI._create_switch_panel = function (arg_11_0)
	arg_11_0._ui_scenegraph.panel.local_position[2] = var_0_1.panel.position[2] - 50

	local var_11_0 = var_0_5(arg_11_0._information_data)
	local var_11_1 = UIWidget.init(var_11_0)

	var_11_1.content.current_index = arg_11_0._current_information_data_index
	arg_11_0._switch_widget = var_11_1
	arg_11_0._widgets_by_name.switch_panel = var_11_1
end

MenuInformationSlateUI._parse_information_data = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.alert_name
	local var_12_1 = arg_12_1.alert_color
	local var_12_2 = arg_12_1.header
	local var_12_3 = arg_12_1.sub_header

	arg_12_0._widgets_by_name.alert_name.content.text = var_12_0
	arg_12_0._widgets_by_name.dot.style.texture_id.color = var_12_1
	arg_12_0._widgets_by_name.dot_glow.style.texture_id.color = var_12_1
	arg_12_0._widgets_by_name.top_banner.style.rect.color = var_12_1
	arg_12_0._widgets_by_name.header.content.text = var_12_2
	arg_12_0._widgets_by_name.sub_header.content.text = var_12_3

	local var_12_4 = arg_12_1.body
	local var_12_5 = 0

	for iter_12_0, iter_12_1 in ipairs(var_12_4) do
		local var_12_6 = iter_12_1.type
		local var_12_7 = arg_12_0["_parse_" .. var_12_6 .. "_data"]

		if var_12_7 then
			var_12_5 = var_12_7(arg_12_0, iter_12_1, iter_12_0, var_12_5)
		else
			fassert(false, "[MenuInformationSlateUi] There is no parse function for type %q", var_12_6)
		end
	end

	local var_12_8 = math.abs(var_12_5) - 590

	if var_12_8 > 0 then
		local var_12_9 = arg_12_0._ui_scenegraph
		local var_12_10 = "body_anchor"
		local var_12_11 = "scrolbar_window"
		local var_12_12 = var_12_8
		local var_12_13 = false
		local var_12_14
		local var_12_15

		arg_12_0._scrollbar_ui = ScrollbarUI:new(var_12_9, var_12_10, var_12_11, var_12_12, var_12_13, var_12_14, var_12_15)
	else
		arg_12_0._scrollbar_ui = nil

		local var_12_16 = "body_anchor"

		arg_12_0._ui_scenegraph[var_12_16].local_position[2] = 0
	end

	arg_12_0._information_available = true
end

MenuInformationSlateUI._parse_text_data = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = var_0_4.text
	local var_13_1 = var_13_0.spacing
	local var_13_2 = table.clone(var_13_0.default_text_style)

	var_13_2.font_size = arg_13_1.font_size or var_13_2.font_size
	var_13_2.font_type = arg_13_1.font_type or var_13_2.font_type
	var_13_2.text_color = arg_13_1.color or var_13_2.text_color

	local var_13_3 = arg_13_1.text
	local var_13_4 = arg_13_1.hint
	local var_13_5, var_13_6 = UIFontByResolution(var_13_2)
	local var_13_7 = var_13_5[1]
	local var_13_8 = var_13_6
	local var_13_9 = arg_13_0._ui_renderer.gui
	local var_13_10, var_13_11, var_13_12 = UIGetFontHeight(var_13_9, var_13_2.font_type, var_13_8)
	local var_13_13 = RESOLUTION_LOOKUP.inv_scale
	local var_13_14 = (var_13_12 - var_13_11) * var_13_13

	if var_13_4 == "bullet_points" then
		var_13_2.offset[1] = 20
		arg_13_3 = arg_13_3 + var_13_1

		local var_13_15 = 1
		local var_13_16 = string.split_deprecated(var_13_3, "|")

		for iter_13_0, iter_13_1 in ipairs(var_13_16) do
			local var_13_17 = string.match(iter_13_1, "%$INDENT;[%a%d_]*:")

			if var_13_17 then
				local var_13_18 = string.find(var_13_17, ";")

				var_13_15 = tonumber(string.sub(var_13_17, var_13_18 + 1, -2))
			end

			local var_13_19 = table.clone(var_13_2)

			var_13_19.offset[1] = var_13_19.offset[1] + (var_13_15 - 1) * 30
			var_13_19.area_size = {
				405 - 30 * (var_13_15 - 1),
				50
			}
			iter_13_1 = string.gsub(iter_13_1, "%$INDENT;[%a%d_]*:", "")

			local var_13_20 = UIWidgets.create_simple_text(iter_13_1, "body_anchor", nil, nil, var_13_19)
			local var_13_21 = UIWidget.init(var_13_20)

			arg_13_0._body_widgets[#arg_13_0._body_widgets + 1] = var_13_21
			arg_13_0._widgets_by_name["text_" .. arg_13_2 .. "_bullet_point_" .. iter_13_0] = var_13_21
			var_13_21.offset[2] = arg_13_3

			local var_13_22
			local var_13_23
			local var_13_24
			local var_13_25 = true

			if var_13_15 > 2 then
				local var_13_26 = UIWidgets.create_simple_texture("rect_masked", "body_anchor", var_13_25, nil, {
					255,
					192,
					192,
					192
				}, {
					var_13_19.offset[1] - 30 + 10,
					arg_13_3 - 3 - 8,
					1
				}, {
					5,
					5
				})

				var_13_26.style.texture_id.horizontal_alignment = "left"
				var_13_26.style.texture_id.vertical_alignment = "top"
				var_13_24 = UIWidget.init(var_13_26)
				arg_13_0._body_widgets[#arg_13_0._body_widgets + 1] = var_13_24
				arg_13_0._widgets_by_name["text_" .. arg_13_2 .. "_bullet_point_dash_" .. iter_13_0] = var_13_24
			else
				local var_13_27 = UIWidgets.create_simple_texture("dot", "body_anchor", var_13_25, nil, {
					255,
					192,
					192,
					192
				}, {
					var_13_19.offset[1] - 30,
					arg_13_3 - 3,
					1
				}, {
					20,
					20
				})

				var_13_27.style.texture_id.horizontal_alignment = "left"
				var_13_27.style.texture_id.vertical_alignment = "top"
				var_13_22 = UIWidget.init(var_13_27)
				arg_13_0._body_widgets[#arg_13_0._body_widgets + 1] = var_13_22
				arg_13_0._widgets_by_name["text_" .. arg_13_2 .. "_bullet_point_dot_" .. iter_13_0] = var_13_22

				if var_13_15 == 2 then
					local var_13_28 = true
					local var_13_29 = UIWidgets.create_simple_texture("dot", "body_anchor", var_13_28, nil, {
						255,
						0,
						0,
						0
					}, {
						var_13_19.offset[1] - 30 + 3,
						arg_13_3 - 3 - 3,
						2
					}, {
						14,
						14
					})

					var_13_29.style.texture_id.horizontal_alignment = "left"
					var_13_29.style.texture_id.vertical_alignment = "top"
					var_13_23 = UIWidget.init(var_13_29)
					arg_13_0._body_widgets[#arg_13_0._body_widgets + 1] = var_13_23
					arg_13_0._widgets_by_name["text_" .. arg_13_2 .. "_bullet_point_inner_dot_" .. iter_13_0] = var_13_23
				end
			end

			local var_13_30, var_13_31 = UIRenderer.word_wrap(arg_13_0._ui_renderer, iter_13_1, var_13_7, var_13_8, var_13_19.area_size[1])

			var_13_21.widget_height = var_13_14 * #var_13_30

			if var_13_22 then
				var_13_22.widget_height = var_13_21.widget_height
			end

			if var_13_23 then
				var_13_23.widget_height = var_13_21.widget_height
			end

			if var_13_24 then
				var_13_24.widget_height = var_13_21.widget_height
			end

			arg_13_3 = arg_13_3 - var_13_21.widget_height - (#var_13_30 > 1 and var_13_1 * 0.5 or 0)
		end

		arg_13_3 = arg_13_3 - var_13_1
	else
		local var_13_32 = UIWidgets.create_simple_text(var_13_3, "body_anchor", nil, nil, var_13_2)
		local var_13_33 = UIWidget.init(var_13_32)

		arg_13_0._body_widgets[#arg_13_0._body_widgets + 1] = var_13_33
		arg_13_0._widgets_by_name["text_" .. arg_13_2] = var_13_33
		var_13_33.offset[2] = arg_13_3

		local var_13_34, var_13_35 = UIRenderer.word_wrap(arg_13_0._ui_renderer, var_13_3, var_13_7, var_13_8, arg_13_0._ui_scenegraph.body_anchor.size[1])

		var_13_33.widget_height = var_13_14 * #var_13_34
		arg_13_3 = arg_13_3 - var_13_33.widget_height - var_13_1
	end

	return arg_13_3
end

MenuInformationSlateUI._parse_image_data = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = var_0_4.image
	local var_14_1 = arg_14_1.image_name
	local var_14_2 = arg_14_1.image_size
	local var_14_3 = true
	local var_14_4 = "image_" .. arg_14_2
	local var_14_5 = var_14_2[2]

	local function var_14_6()
		local var_15_0 = arg_14_0._cloned_materials_by_reference[var_14_4]
		local var_15_1 = UIWidgets.create_simple_texture(var_15_0, "body_anchor")

		var_15_1.style.texture_id.horizontal_alignment = "left"
		var_15_1.style.texture_id.vertical_alignment = "top"

		local var_15_2 = UIWidget.init(var_15_1)

		var_15_2.offset[2] = arg_14_3
		var_15_2.style.texture_id.texture_size = var_14_2
		arg_14_0._body_widgets[#arg_14_0._body_widgets + 1] = var_15_2
		arg_14_0._widgets_by_name[var_14_4] = var_15_2
		var_15_2.widget_height = var_14_5
		var_15_2.is_image = true
	end

	arg_14_0:_setup_backend_image_material(var_14_1, var_14_3, var_14_4, var_14_6)

	return arg_14_3 - var_14_5 - var_14_0.spacing
end

MenuInformationSlateUI._setup_backend_image_material = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_3 or arg_16_1
	local var_16_1 = "MenuInformationSlateUI_" .. var_16_0
	local var_16_2 = arg_16_2 and "template_diffuse_masked" or "template_diffuse"

	arg_16_0:_create_material_instance(var_16_1, var_16_2, var_16_0)

	if IS_CONSOLE then
		arg_16_0._material_references_to_unload[var_16_0] = true

		local var_16_3 = false
		local var_16_4 = callback(arg_16_0, "_cb_on_backend_image_loaded", var_16_1, var_16_0, arg_16_4, arg_16_1, var_16_3)

		Managers.url_loader:load_resource(var_16_0, "http://" .. var_0_7 .. "/" .. var_0_8 .. "/" .. arg_16_1 .. ".dds", var_16_4, Application.guid())
	else
		local var_16_5 = Managers.backend:get_interface("cdn")
		local var_16_6 = callback(arg_16_0, "_cb_on_backend_url_loaded", arg_16_1, var_16_0, var_16_1, arg_16_4)

		var_16_5:get_resource_urls({
			arg_16_1
		}, var_16_6)
	end
end

MenuInformationSlateUI._create_material_instance = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0._cloned_materials_by_reference[arg_17_3] = arg_17_1

	return Gui.clone_material_from_template(arg_17_0._ui_renderer.gui, arg_17_1, arg_17_2)
end

MenuInformationSlateUI._cb_on_backend_url_loaded = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	local var_18_0 = arg_18_5[arg_18_1]

	if not var_18_0 then
		local var_18_1 = false

		arg_18_0._material_references_to_unload[arg_18_2] = true

		local var_18_2 = callback(arg_18_0, "_cb_on_backend_image_loaded", arg_18_3, arg_18_2, arg_18_4, arg_18_1, var_18_1)

		Managers.url_loader:load_resource(arg_18_2, "http://" .. var_0_7 .. "/" .. var_0_8 .. "/" .. arg_18_1 .. ".dds", var_18_2, Application.guid())

		return
	end

	arg_18_0._material_references_to_unload[arg_18_2] = true

	local var_18_3 = true
	local var_18_4 = callback(arg_18_0, "_cb_on_backend_image_loaded", arg_18_3, arg_18_2, arg_18_4, arg_18_1, var_18_3)

	Managers.url_loader:load_resource(arg_18_2, var_18_0, var_18_4, arg_18_1)
end

MenuInformationSlateUI._cb_on_backend_image_loaded = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	if not arg_19_0._cloned_materials_by_reference[arg_19_2] then
		return
	end

	if arg_19_6 then
		arg_19_0:_set_material_diffuse_by_resource(arg_19_1, arg_19_6)
		arg_19_3()
	elseif arg_19_5 then
		local var_19_0 = false

		arg_19_0._material_references_to_unload[arg_19_2] = true

		local var_19_1 = callback(arg_19_0, "_cb_on_backend_image_loaded", arg_19_1, arg_19_2, arg_19_3, arg_19_4, var_19_0)

		Managers.url_loader:load_resource(arg_19_2, "http://" .. var_0_7 .. "/" .. var_0_8 .. "/" .. arg_19_4 .. ".dds", var_19_1, Application.guid())
	else
		arg_19_0._material_references_to_unload[arg_19_2] = nil

		Application.warning(string.format("[StoreWindowFeatured] - Failed loading image for reference name: (%s)", arg_19_2))
	end
end

MenuInformationSlateUI._set_material_diffuse_by_resource = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = Gui.material(arg_20_0._ui_renderer.gui, arg_20_1)

	if var_20_0 then
		Material.set_resource(var_20_0, "diffuse_map", arg_20_2)
	end
end

MenuInformationSlateUI._update_input = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = IS_CONSOLE and arg_21_0._input_service:get("start_press") or arg_21_0._input_service:get("special_1_press")

	var_21_0 = var_21_0 or UIUtils.is_button_pressed(arg_21_0._widgets_by_name.more_information, "hotspot")
	var_21_0 = var_21_0 or UIUtils.is_button_pressed(arg_21_0._widgets_by_name.less_information, "hotspot")

	local var_21_1 = arg_21_0._animations.expand or arg_21_0._animations.collapse

	if var_21_0 and not var_21_1 then
		if not arg_21_0._expanded then
			arg_21_0._expanded = true

			arg_21_0:_start_animation("expand")
			arg_21_0:_play_sound("play_gui_info_slate_more_information_open")
		else
			arg_21_0._expanded = false

			arg_21_0:_start_animation("collapse")
			arg_21_0:_play_sound("play_gui_info_slate_more_information_close")
		end

		return
	elseif UIUtils.is_button_hover_enter(arg_21_0._widgets_by_name.more_information, "hotspot") or UIUtils.is_button_hover_enter(arg_21_0._widgets_by_name.less_information, "hotspot") then
		arg_21_0:_play_sound("play_gui_info_slate_more_information_hover")
	end

	if #arg_21_0._information_data > 1 then
		local var_21_2 = arg_21_0._current_information_data_index
		local var_21_3 = arg_21_0._widgets_by_name.switch_panel

		for iter_21_0 = 1, #arg_21_0._information_data do
			local var_21_4 = "slate_" .. iter_21_0

			if UIUtils.is_button_pressed(var_21_3, var_21_4 .. "_hotspot") then
				arg_21_0:_play_sound("play_gui_info_slate_tab_clicked")

				if iter_21_0 ~= arg_21_0._current_information_data_index then
					arg_21_0._current_information_data_index = iter_21_0

					break
				end
			elseif UIUtils.is_button_hover_enter(var_21_3, var_21_4 .. "_hotspot") then
				arg_21_0:_play_sound("play_gui_info_slate_tab_hover")

				break
			end
		end

		if UIUtils.is_button_pressed(var_21_3, "left_arrow_hotspot") or arg_21_0._input_service:get("previous") or IS_WINDOWS and arg_21_0._input_service:get("left") then
			arg_21_0._current_information_data_index = math.max(arg_21_0._current_information_data_index - 1, 1)

			arg_21_0:_play_sound("play_gui_info_slate_tab_arrow_clicked")
		elseif UIUtils.is_button_pressed(var_21_3, "right_arrow_hotspot") or arg_21_0._input_service:get("next") or IS_WINDOWS and arg_21_0._input_service:get("right") then
			arg_21_0._current_information_data_index = math.min(arg_21_0._current_information_data_index + 1, #arg_21_0._information_data)

			arg_21_0:_play_sound("play_gui_info_slate_tab_arrow_clicked")
		elseif UIUtils.is_button_hover_enter(var_21_3, "left_arrow_hotspot") or UIUtils.is_button_hover_enter(var_21_3, "right_arrow_hotspot") then
			arg_21_0:_play_sound("play_gui_info_slate_tab_arrow_hover")
		end

		if var_21_2 ~= arg_21_0._current_information_data_index then
			arg_21_0:_populate_info_slate()
		end
	end
end

MenuInformationSlateUI._populate_info_slate = function (arg_22_0)
	local var_22_0 = arg_22_0._information_data[arg_22_0._current_information_data_index]

	arg_22_0:_reset()
	arg_22_0:_parse_information_data(var_22_0)
	arg_22_0:_create_switch_panel()

	if arg_22_0._expanded then
		arg_22_0:_start_animation("expand_instantly")
	else
		arg_22_0:_start_animation("collapse_instantly")
	end

	arg_22_0:_start_animation("animate_in")
	arg_22_0:_play_sound("play_gui_info_slate_tab_changed")
end

MenuInformationSlateUI._update_animations = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._ui_animations
	local var_23_1 = arg_23_0._animations
	local var_23_2 = arg_23_0._ui_animator

	for iter_23_0, iter_23_1 in pairs(arg_23_0._ui_animations) do
		UIAnimation.update(iter_23_1, arg_23_1)

		if UIAnimation.completed(iter_23_1) then
			arg_23_0._ui_animations[iter_23_0] = nil
		end
	end

	var_23_2:update(arg_23_1)

	for iter_23_2, iter_23_3 in pairs(var_23_1) do
		if var_23_2:is_animation_completed(iter_23_3) then
			var_23_2:stop_animation(iter_23_3)

			var_23_1[iter_23_2] = nil
		end
	end
end

MenuInformationSlateUI.update = function (arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0._information_available then
		return
	end

	arg_24_0:_update_animations(arg_24_1, arg_24_2)
	arg_24_0:_update_input(arg_24_1, arg_24_2)
	arg_24_0:_draw(arg_24_1, arg_24_2)
end

MenuInformationSlateUI._draw = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._ui_renderer
	local var_25_1 = arg_25_0._ui_scenegraph
	local var_25_2 = arg_25_0._input_service
	local var_25_3 = arg_25_0._render_settings

	UIRenderer.begin_pass(var_25_0, var_25_1, var_25_2, arg_25_1, nil, var_25_3)

	for iter_25_0, iter_25_1 in ipairs(arg_25_0._widgets) do
		UIRenderer.draw_widget(var_25_0, iter_25_1)
	end

	if arg_25_0._expanded or not table.is_empty(arg_25_0._animations) then
		local var_25_4 = arg_25_0._ui_scenegraph.body_anchor.local_position[2]
		local var_25_5 = 0
		local var_25_6 = -var_0_0.panel_scroll_area

		for iter_25_2, iter_25_3 in ipairs(arg_25_0._body_widgets) do
			local var_25_7 = iter_25_3.offset[2] + var_25_4

			if var_25_5 > var_25_7 - iter_25_3.widget_height and var_25_6 < var_25_7 then
				UIRenderer.draw_widget(var_25_0, iter_25_3)
			end
		end
	end

	if arg_25_0._switch_widget then
		local var_25_8 = var_25_3.alpha_multiplier

		var_25_3.alpha_multiplier = arg_25_0._switch_widget.content.alpha_value

		UIRenderer.draw_widget(var_25_0, arg_25_0._switch_widget)

		var_25_3.alpha_multiplier = var_25_8
	end

	UIRenderer.end_pass(var_25_0)

	if arg_25_0._expanded then
		local var_25_9 = var_25_3.alpha_multiplier

		var_25_3.alpha_multiplier = var_25_3.scrollbar_alpha

		if arg_25_0._scrollbar_ui then
			arg_25_0._scrollbar_ui:update(arg_25_1, arg_25_2, var_25_0, var_25_2, var_25_3)
		end

		var_25_3.alpha_multiplier = var_25_9
	end
end

MenuInformationSlateUI.destroy = function (arg_26_0)
	arg_26_0:_reset_cloned_materials()
end

MenuInformationSlateUI._is_unique_reference_to_material = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._cloned_materials_by_reference
	local var_27_1 = var_27_0[arg_27_1]

	fassert(var_27_1, "[MenuInformationSlateUI] - Could not find a used material for reference name: (%s)", arg_27_1)

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		if var_27_1 == iter_27_1 and arg_27_1 ~= iter_27_0 then
			return false
		end
	end

	return true
end

MenuInformationSlateUI._set_material_diffuse_by_path = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = Gui.material(arg_28_1, arg_28_2)

	if var_28_0 then
		Material.set_texture(var_28_0, "diffuse_map", arg_28_3)
	end
end

MenuInformationSlateUI._reset_cloned_materials = function (arg_29_0)
	local var_29_0 = arg_29_0._ui_renderer.gui
	local var_29_1 = arg_29_0._material_references_to_unload
	local var_29_2 = arg_29_0._cloned_materials_by_reference

	for iter_29_0, iter_29_1 in pairs(var_29_2) do
		if var_29_1[iter_29_0] then
			var_29_1[iter_29_0] = nil

			Managers.url_loader:unload_resource(iter_29_0)
		end

		if arg_29_0:_is_unique_reference_to_material(iter_29_0) then
			arg_29_0:_set_material_diffuse_by_path(var_29_0, iter_29_1, var_0_6)
		end

		var_29_2[iter_29_0] = nil
	end
end

MenuInformationSlateUI._play_sound = function (arg_30_0, arg_30_1)
	return Managers.music:trigger_event(arg_30_1)
end
