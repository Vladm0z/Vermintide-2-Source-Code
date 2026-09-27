-- chunkname: @scripts/ui/views/disconnect_indicator_view.lua

require("foundation/scripts/util/local_require")
require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local scripts_ui_views_disconnect_indicator_view_definitions = require("scripts/ui/views/disconnect_indicator_view_definitions")
local flag = false

DisconnectIndicatorView = class(DisconnectIndicatorView)
DisconnectIndicatorView.FLASH_CYCLE = 0.5

local DisconnectIndicatorView = DisconnectIndicatorView
local network_silence_warning_delay = GameSettingsDevelopment.network_silence_warning_delay

network_silence_warning_delay = network_silence_warning_delay or 3
DisconnectIndicatorView.SILENCE_THRESHOLD = network_silence_warning_delay

DisconnectIndicatorView.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_loading", "material", "materials/fonts/gw_fonts")
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._flash_counter = 0
	self._recalc_text_width = true
	self._text_width = 0
end

DisconnectIndicatorView.destroy = function (self)
	-- function 2
	UIRenderer.destroy(self._ui_renderer, self._world)

	self._ui_renderer = nil
	DO_RELOAD = true
end

local flag_2 = true

DisconnectIndicatorView.update = function (self, arg_3_1)
	-- function 3
	if not flag_2 then
		flag_2 = false
		self._recalc_text_width = true

		self:_create_ui_elements()
	end

	if not self:_is_visible() then
		self._flash_counter = 0

		return
	end

	self._flash_counter = self._flash_counter + arg_3_1

	while self._flash_counter > DisconnectIndicatorView.FLASH_CYCLE do
		self._flash_counter = self._flash_counter - DisconnectIndicatorView.FLASH_CYCLE
	end

	local get_current_mechanism = Managers.level_transition_handler:get_current_mechanism()
	local in_hub_level = Managers.level_transition_handler:in_hub_level()

	if not (self._current_mechanism ~= get_current_mechanism or self._is_in_inn == in_hub_level) then
		self._current_mechanism = get_current_mechanism
		self._is_in_inn = in_hub_level

		if not (get_current_mechanism ~= "versus" or in_hub_level) then
			self._icon_text_widget.content.text = Localize("lost_contact_with_server")
		else
			self._icon_text_widget.content.text = Localize("lost_contact_with_host")
		end
	end

	self:_draw(arg_3_1)
end

DisconnectIndicatorView._create_ui_elements = function (self)
	-- function 4
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scripts_ui_views_disconnect_indicator_view_definitions.scenegraph_definition)
	scripts_ui_views_disconnect_indicator_view_definitions.icon_text.content.text = Localize("lost_contact_with_host")
	self._icon_text_widget = UIWidget.init(scripts_ui_views_disconnect_indicator_view_definitions.icon_text)
end

DisconnectIndicatorView._is_visible = function (arg_5_0)
	-- function 5
	if not DEDICATED_SERVER then
		return false
	end

	if not flag then
		return true
	end

	local network = Managers.state.network

	if network == nil then
		return false
	end

	local lobby = network:lobby()

	if lobby == nil then
		return false
	end

	local lobby_host = lobby:lobby_host()

	if lobby_host == nil then
		return false
	end

	return Network.time_since_receive(lobby_host) > DisconnectIndicatorView.SILENCE_THRESHOLD
end

DisconnectIndicatorView._set_transparency = function (self, arg_6_1)
	-- function 6
	local _icon_text_widget = self._icon_text_widget

	_icon_text_widget.style.text.text_color[1] = 255 * arg_6_1
	_icon_text_widget.style.texture_id.color[1] = 255 * arg_6_1
end

DisconnectIndicatorView._draw = function (self, arg_7_1)
	-- function 7
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _recalc_text_width = self._recalc_text_width

	_recalc_text_width = _recalc_text_width or RESOLUTION_LOOKUP.modified
	self._recalc_text_width = _recalc_text_width

	if not self._recalc_text_width then
		self._recalc_text_width = false

		local text = scripts_ui_views_disconnect_indicator_view_definitions.icon_text.style.text
		local var_7_4, var_7_5 = UIFontByResolution(text)
		local text_2 = scripts_ui_views_disconnect_indicator_view_definitions.icon_text.content.text
		local num = scripts_ui_views_disconnect_indicator_view_definitions.max_text_width / 1920 * RESOLUTION_LOOKUP.res_w

		self._text_width = math.min(UIRenderer.text_size(_ui_renderer, text_2, var_7_4[1], var_7_5), num)
	end

	_ui_scenegraph.indicator.local_position[1] = -((self._text_width + scripts_ui_views_disconnect_indicator_view_definitions.padding) / 2)

	local num_2 = self._flash_counter / DisconnectIndicatorView.FLASH_CYCLE * 2 * math.pi
	local abs = math.abs(math.sin(num_2))

	self:_set_transparency(abs)
	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_7_1, nil, self._render_settings)
	UIRenderer.draw_widget(_ui_renderer, self._icon_text_widget)
	UIRenderer.end_pass(_ui_renderer)
end
