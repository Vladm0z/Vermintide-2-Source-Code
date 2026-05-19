-- chunkname: @scripts/ui/views/disconnect_indicator_view.lua

require("foundation/scripts/util/local_require")
require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local var_0_0 = require("scripts/ui/views/disconnect_indicator_view_definitions")
local var_0_1 = false

DisconnectIndicatorView = class(DisconnectIndicatorView)
DisconnectIndicatorView.FLASH_CYCLE = 0.5
DisconnectIndicatorView.SILENCE_THRESHOLD = GameSettingsDevelopment.network_silence_warning_delay or 3

function DisconnectIndicatorView.init(arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_loading", "material", "materials/fonts/gw_fonts")
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._flash_counter = 0
	arg_1_0._recalc_text_width = true
	arg_1_0._text_width = 0
end

function DisconnectIndicatorView.destroy(arg_2_0)
	UIRenderer.destroy(arg_2_0._ui_renderer, arg_2_0._world)

	arg_2_0._ui_renderer = nil
	DO_RELOAD = true
end

local var_0_2 = true

function DisconnectIndicatorView.update(arg_3_0, arg_3_1)
	if var_0_2 then
		var_0_2 = false
		arg_3_0._recalc_text_width = true

		arg_3_0:_create_ui_elements()
	end

	if not arg_3_0:_is_visible() then
		arg_3_0._flash_counter = 0

		return
	end

	arg_3_0._flash_counter = arg_3_0._flash_counter + arg_3_1

	while arg_3_0._flash_counter > DisconnectIndicatorView.FLASH_CYCLE do
		arg_3_0._flash_counter = arg_3_0._flash_counter - DisconnectIndicatorView.FLASH_CYCLE
	end

	local var_3_0 = Managers.level_transition_handler:get_current_mechanism()
	local var_3_1 = Managers.level_transition_handler:in_hub_level()

	if arg_3_0._current_mechanism ~= var_3_0 or arg_3_0._is_in_inn ~= var_3_1 then
		arg_3_0._current_mechanism = var_3_0
		arg_3_0._is_in_inn = var_3_1

		if var_3_0 == "versus" and not var_3_1 then
			arg_3_0._icon_text_widget.content.text = Localize("lost_contact_with_server")
		else
			arg_3_0._icon_text_widget.content.text = Localize("lost_contact_with_host")
		end
	end

	arg_3_0:_draw(arg_3_1)
end

function DisconnectIndicatorView._create_ui_elements(arg_4_0)
	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	var_0_0.icon_text.content.text = Localize("lost_contact_with_host")
	arg_4_0._icon_text_widget = UIWidget.init(var_0_0.icon_text)
end

function DisconnectIndicatorView._is_visible(arg_5_0)
	if DEDICATED_SERVER then
		return false
	end

	if var_0_1 then
		return true
	end

	local var_5_0 = Managers.state.network

	if var_5_0 == nil then
		return false
	end

	local var_5_1 = var_5_0:lobby()

	if var_5_1 == nil then
		return false
	end

	local var_5_2 = var_5_1:lobby_host()

	if var_5_2 == nil then
		return false
	end

	return Network.time_since_receive(var_5_2) > DisconnectIndicatorView.SILENCE_THRESHOLD
end

function DisconnectIndicatorView._set_transparency(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._icon_text_widget

	var_6_0.style.text.text_color[1] = 255 * arg_6_1
	var_6_0.style.texture_id.color[1] = 255 * arg_6_1
end

function DisconnectIndicatorView._draw(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._ui_renderer
	local var_7_1 = arg_7_0._ui_scenegraph

	arg_7_0._recalc_text_width = arg_7_0._recalc_text_width or RESOLUTION_LOOKUP.modified

	if arg_7_0._recalc_text_width then
		arg_7_0._recalc_text_width = false

		local var_7_2 = var_0_0.icon_text.style.text
		local var_7_3, var_7_4 = UIFontByResolution(var_7_2)
		local var_7_5 = var_0_0.icon_text.content.text
		local var_7_6 = var_0_0.max_text_width / 1920 * RESOLUTION_LOOKUP.res_w

		arg_7_0._text_width = math.min(UIRenderer.text_size(var_7_0, var_7_5, var_7_3[1], var_7_4), var_7_6)
	end

	var_7_1.indicator.local_position[1] = -((arg_7_0._text_width + var_0_0.padding) / 2)

	local var_7_7 = arg_7_0._flash_counter / DisconnectIndicatorView.FLASH_CYCLE * 2 * math.pi
	local var_7_8 = math.abs(math.sin(var_7_7))

	arg_7_0:_set_transparency(var_7_8)
	UIRenderer.begin_pass(var_7_0, var_7_1, FAKE_INPUT_SERVICE, arg_7_1, nil, arg_7_0._render_settings)
	UIRenderer.draw_widget(var_7_0, arg_7_0._icon_text_widget)
	UIRenderer.end_pass(var_7_0)
end
