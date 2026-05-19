-- chunkname: @scripts/ui/hud_ui/wait_for_rescue_ui.lua

local var_0_0 = {
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
local var_0_1 = {
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
local var_0_2 = true

WaitForRescueUI = class(WaitForRescueUI)

function WaitForRescueUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.local_player = Managers.player:local_player()

	arg_1_0:create_ui_elements()
end

function WaitForRescueUI.create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)
	arg_2_0.waiting_for_rescue_text = UIWidget.init(var_0_1)
	var_0_2 = false
end

function WaitForRescueUI.destroy(arg_3_0)
	return
end

function WaitForRescueUI.update(arg_4_0, arg_4_1, arg_4_2)
	if var_0_2 then
		arg_4_0:create_ui_elements()
	end

	local var_4_0 = arg_4_0.local_player.player_unit

	if not Unit.alive(var_4_0) then
		return
	end

	if not ScriptUnit.extension(var_4_0, "status_system"):is_ready_for_assisted_respawn(var_4_0) then
		return
	end

	local var_4_1 = math.sirp(0, 255, arg_4_2)

	arg_4_0.waiting_for_rescue_text.style.text_color[1] = var_4_1

	local var_4_2 = arg_4_0.ui_renderer
	local var_4_3 = arg_4_0.ui_scenegraph
	local var_4_4 = arg_4_0.input_manager:get_service("Player")

	UIRenderer.begin_pass(var_4_2, var_4_3, var_4_4, arg_4_1)
	UIRenderer.draw_widget(var_4_2, arg_4_0.waiting_for_rescue_text)
	UIRenderer.end_pass(var_4_2)
end
