-- chunkname: @scripts/ui/hud_ui/ingame_news_ticker_ui.lua

IngameNewsTickerUI = class(IngameNewsTickerUI)

local num = 300
local num_2 = 120
local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
	simple_rect = UIWidgets.create_simple_rect("news_ticker_bg", Colors.get_color_table_with_alpha("black", 192), -1, {
		0,
		-5,
		-1
	}),
	news_ticker_text_widget = UIWidgets.create_simple_text("", "news_ticker_text", nil, nil, tbl_2),
	news_ticker_text_shadow_widget = UIWidgets.create_simple_text("", "news_ticker_text", nil, nil, tbl_3),
	news_ticker_mask_widget = UIWidgets.create_simple_texture("mask_rect", "news_ticker_mask")
}

IngameNewsTickerUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.input_manager = arg_1_2.input_manager
	self.platform = PLATFORM
	self.ui_animations = {}

	self:create_ui_elements()

	self.news_ticker_speed = 100
	self.news_ticker_manager = Managers.news_ticker

	self:refresh_message()
end

IngameNewsTickerUI.create_ui_elements = function (self)
	-- function 2
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.news_ticker_text_widget = UIWidget.init(tbl_4.news_ticker_text_widget)
	self.news_ticker_text_shadow_widget = UIWidget.init(tbl_4.news_ticker_text_shadow_widget)
	self.news_ticker_mask_widget = UIWidget.init(tbl_4.news_ticker_mask_widget)
	self.simple_rect = UIWidget.init(tbl_4.simple_rect)

	local text = self.news_ticker_text_widget.style.text

	text.localize = false
	text.horizontal_alignment = "left"

	local text_2 = self.news_ticker_text_shadow_widget.style.text

	text_2.localize = false
	text_2.horizontal_alignment = "left"
end

IngameNewsTickerUI.destroy = function (arg_3_0)
	-- function 3
	GarbageLeakDetector.register_object(arg_3_0, "ingame_news_ticker_ui")
end

IngameNewsTickerUI.refresh_message = function (self)
	-- function 4
	self.refreshing_message = true
	self.news_ticker_started = nil

	self.news_ticker_manager:refresh_ingame_message()
end

local flag = true

IngameNewsTickerUI.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		self:create_ui_elements()

		self.news_ticker_speed = 100
		self.news_ticker_manager = Managers.news_ticker

		self:refresh_message()

		flag = false
	end

	local news_ticker_manager = self.news_ticker_manager
	local news_ticker_started = self.news_ticker_started
	local refreshing_ingame_message = news_ticker_manager:refreshing_ingame_message()

	if not (news_ticker_started or refreshing_ingame_message) then
		local ingame_text = news_ticker_manager:ingame_text()

		if not ingame_text then
			self:setup_news_ticker(ingame_text)
		end

		if not self.message_refresh_delay then
			local var_5_4

			if not ingame_text then
				var_5_4 = num

				if not var_5_4 then
					-- Nothing
				end
			end

			var_5_4 = num_2

			::label_5_0::

			self.message_refresh_delay = var_5_4
		end
	end

	local ui_scenegraph = self.ui_scenegraph
	local news_ticker_started_2 = self.news_ticker_started

	if self:handle_delay(arg_5_1) or not news_ticker_started_2 then
		local local_position = ui_scenegraph.news_ticker_text.local_position

		if local_position[1] + self.news_ticker_text_width <= 0 then
			local_position[1] = 1920
			self.delay = 5
		end

		local_position[1] = local_position[1] - arg_5_1 * self.news_ticker_speed

		self:draw(arg_5_1, arg_5_2)
	end

	if not (refreshing_ingame_message or self:handle_message_refresh_delay(arg_5_1)) then
		self:refresh_message()
	end
end

IngameNewsTickerUI.handle_delay = function (self, arg_6_1)
	-- function 6
	local delay = self.delay

	if not delay then
		local num = delay - arg_6_1

		self.delay = not (num > 0) or not num or nil

		return true
	end
end

IngameNewsTickerUI.handle_message_refresh_delay = function (self, arg_7_1)
	-- function 7
	local message_refresh_delay = self.message_refresh_delay

	if not message_refresh_delay then
		local num = message_refresh_delay - arg_7_1

		self.message_refresh_delay = not (num > 0) or not num or nil

		return true
	end
end

IngameNewsTickerUI.draw = function (self, arg_8_1, arg_8_2)
	-- function 8
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("ingame_menu")
	local is_device_active = input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_8_1)
	UIRenderer.draw_widget(ui_renderer, self.news_ticker_mask_widget)
	UIRenderer.draw_widget(ui_renderer, self.news_ticker_text_widget)
	UIRenderer.draw_widget(ui_renderer, self.news_ticker_text_shadow_widget)
	UIRenderer.draw_widget(ui_renderer, self.simple_rect)
	UIRenderer.end_pass(ui_renderer)
end

IngameNewsTickerUI.setup_news_ticker = function (self, arg_9_1)
	-- function 9
	local news_ticker_text_widget = self.news_ticker_text_widget
	local news_ticker_text_shadow_widget = self.news_ticker_text_shadow_widget
	local content = news_ticker_text_widget.content
	local content_2 = news_ticker_text_shadow_widget.content
	local style = news_ticker_text_widget.style

	content.text = arg_9_1
	content_2.text = arg_9_1

	local text = style.text
	local font_type = text.font_type
	local var_9_7, var_9_8 = UIFontByResolution(text)
	local text_size, var_9_10, var_9_11 = UIRenderer.text_size(self.ui_renderer, arg_9_1, var_9_7[1], var_9_8)

	self.news_ticker_text_width = text_size
	self.news_ticker_started = true
end
