-- chunkname: @scripts/ui/hud_ui/wait_for_rescue_ui.lua

local tbl = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud_inventory
		},
		size = {
			1920,
			1080
		}
	},
	waiting_for_rescue_text = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			800,
			40
		}
	}
}
local tbl_2 = {
	scenegraph_id = "waiting_for_rescue_text",
	element = {
		passes = {
			{
				pass_type = "text",
				text_id = "text"
			}
		}
	},
	content = {
		text = "waiting_to_be_rescued"
	},
	style = {
		font_size = 45,
		localize = true,
		word_wrap = true,
		pixel_perfect = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font = true,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("white", 255)
	}
}
local flag = true

WaitForRescueUI = class(WaitForRescueUI)

WaitForRescueUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.local_player = Managers.player:local_player()

	self:create_ui_elements()
end

WaitForRescueUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.waiting_for_rescue_text = UIWidget.init(tbl_2)
	flag = false
end

WaitForRescueUI.destroy = function (arg_3_0)
	-- function 3
	return
end

WaitForRescueUI.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		self:create_ui_elements()
	end

	local player_unit = self.local_player.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	if not ScriptUnit.extension(player_unit, "status_system"):is_ready_for_assisted_respawn(player_unit) then
		return
	end

	local sirp = math.sirp(0, 255, arg_4_2)

	self.waiting_for_rescue_text.style.text_color[1] = sirp

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_4_1)
	UIRenderer.draw_widget(ui_renderer, self.waiting_for_rescue_text)
	UIRenderer.end_pass(ui_renderer)
end
