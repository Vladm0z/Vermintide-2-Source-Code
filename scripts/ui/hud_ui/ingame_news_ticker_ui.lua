-- chunkname: @scripts/ui/hud_ui/ingame_news_ticker_ui.lua

IngameNewsTickerUI = class(IngameNewsTickerUI)

local var_0_0 = 300
local var_0_1 = 120
local var_0_2 = {
	root = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			980
		}
	},
	screen = {
		vertical_alignment = "center",
		scale = "aspect_ratio",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			2
		}
	},
	news_ticker_text = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			20
		},
		position = {
			1960,
			-2,
			2
		}
	},
	news_ticker_mask = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			880,
			40
		},
		position = {
			6,
			0,
			3
		}
	},
	news_ticker_bg = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			40
		},
		position = {
			0,
			20,
			0
		}
	}
}
local var_0_3 = {
	vertical_alignment = "bottom",
	font_size = 18,
	localize = false,
	horizontal_alignment = "left",
	word_wrap = false,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_4 = {
	vertical_alignment = "bottom",
	font_size = 18,
	localize = false,
	horizontal_alignment = "left",
	word_wrap = false,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("black", 255),
	offset = {
		1,
		-1,
		1
	}
}
local var_0_5 = {
	simple_rect = UIWidgets.create_simple_rect("news_ticker_bg", Colors.get_color_table_with_alpha("black", 192), -1, {
		0,
		-5,
		-1
	}),
	news_ticker_text_widget = UIWidgets.create_simple_text("", "news_ticker_text", nil, nil, var_0_3),
	news_ticker_text_shadow_widget = UIWidgets.create_simple_text("", "news_ticker_text", nil, nil, var_0_4),
	news_ticker_mask_widget = UIWidgets.create_simple_texture("mask_rect", "news_ticker_mask")
}

IngameNewsTickerUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.platform = PLATFORM
	arg_1_0.ui_animations = {}

	arg_1_0:create_ui_elements()

	arg_1_0.news_ticker_speed = 100
	arg_1_0.news_ticker_manager = Managers.news_ticker

	arg_1_0:refresh_message()
end

IngameNewsTickerUI.create_ui_elements = function (arg_2_0)
	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_2_0.news_ticker_text_widget = UIWidget.init(var_0_5.news_ticker_text_widget)
	arg_2_0.news_ticker_text_shadow_widget = UIWidget.init(var_0_5.news_ticker_text_shadow_widget)
	arg_2_0.news_ticker_mask_widget = UIWidget.init(var_0_5.news_ticker_mask_widget)
	arg_2_0.simple_rect = UIWidget.init(var_0_5.simple_rect)

	local var_2_0 = arg_2_0.news_ticker_text_widget.style.text

	var_2_0.localize = false
	var_2_0.horizontal_alignment = "left"

	local var_2_1 = arg_2_0.news_ticker_text_shadow_widget.style.text

	var_2_1.localize = false
	var_2_1.horizontal_alignment = "left"
end

IngameNewsTickerUI.destroy = function (arg_3_0)
	GarbageLeakDetector.register_object(arg_3_0, "ingame_news_ticker_ui")
end

IngameNewsTickerUI.refresh_message = function (arg_4_0)
	arg_4_0.refreshing_message = true
	arg_4_0.news_ticker_started = nil

	arg_4_0.news_ticker_manager:refresh_ingame_message()
end

local var_0_6 = true

IngameNewsTickerUI.update = function (arg_5_0, arg_5_1, arg_5_2)
	if var_0_6 then
		arg_5_0:create_ui_elements()

		arg_5_0.news_ticker_speed = 100
		arg_5_0.news_ticker_manager = Managers.news_ticker

		arg_5_0:refresh_message()

		var_0_6 = false
	end

	local var_5_0 = arg_5_0.news_ticker_manager
	local var_5_1 = arg_5_0.news_ticker_started
	local var_5_2 = var_5_0:refreshing_ingame_message()

	if not var_5_1 and not var_5_2 then
		local var_5_3 = var_5_0:ingame_text()

		if var_5_3 then
			arg_5_0:setup_news_ticker(var_5_3)
		end

		if not arg_5_0.message_refresh_delay then
			arg_5_0.message_refresh_delay = var_5_3 and var_0_0 or var_0_1
		end
	end

	local var_5_4 = arg_5_0.ui_scenegraph
	local var_5_5 = arg_5_0.news_ticker_started

	if not arg_5_0:handle_delay(arg_5_1) and var_5_5 then
		local var_5_6 = var_5_4.news_ticker_text.local_position

		if var_5_6[1] + arg_5_0.news_ticker_text_width <= 0 then
			var_5_6[1] = 1920
			arg_5_0.delay = 5
		end

		var_5_6[1] = var_5_6[1] - arg_5_1 * arg_5_0.news_ticker_speed

		arg_5_0:draw(arg_5_1, arg_5_2)
	end

	if not var_5_2 and not arg_5_0:handle_message_refresh_delay(arg_5_1) then
		arg_5_0:refresh_message()
	end
end

IngameNewsTickerUI.handle_delay = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.delay

	if var_6_0 then
		local var_6_1 = var_6_0 - arg_6_1

		arg_6_0.delay = var_6_1 > 0 and var_6_1 or nil

		return true
	end
end

IngameNewsTickerUI.handle_message_refresh_delay = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.message_refresh_delay

	if var_7_0 then
		local var_7_1 = var_7_0 - arg_7_1

		arg_7_0.message_refresh_delay = var_7_1 > 0 and var_7_1 or nil

		return true
	end
end

IngameNewsTickerUI.draw = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.ui_renderer
	local var_8_1 = arg_8_0.ui_scenegraph
	local var_8_2 = arg_8_0.input_manager
	local var_8_3 = var_8_2:get_service("ingame_menu")
	local var_8_4 = var_8_2:is_device_active("gamepad")

	UIRenderer.begin_pass(var_8_0, var_8_1, var_8_3, arg_8_1)
	UIRenderer.draw_widget(var_8_0, arg_8_0.news_ticker_mask_widget)
	UIRenderer.draw_widget(var_8_0, arg_8_0.news_ticker_text_widget)
	UIRenderer.draw_widget(var_8_0, arg_8_0.news_ticker_text_shadow_widget)
	UIRenderer.draw_widget(var_8_0, arg_8_0.simple_rect)
	UIRenderer.end_pass(var_8_0)
end

IngameNewsTickerUI.setup_news_ticker = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.news_ticker_text_widget
	local var_9_1 = arg_9_0.news_ticker_text_shadow_widget
	local var_9_2 = var_9_0.content
	local var_9_3 = var_9_1.content
	local var_9_4 = var_9_0.style

	var_9_2.text = arg_9_1
	var_9_3.text = arg_9_1

	local var_9_5 = var_9_4.text
	local var_9_6 = var_9_5.font_type
	local var_9_7, var_9_8 = UIFontByResolution(var_9_5)
	local var_9_9, var_9_10, var_9_11 = UIRenderer.text_size(arg_9_0.ui_renderer, arg_9_1, var_9_7[1], var_9_8)

	arg_9_0.news_ticker_text_width = var_9_9
	arg_9_0.news_ticker_started = true
end
