-- chunkname: @scripts/ui/views/ingame_voting_ui.lua

local var_0_0 = local_require("scripts/ui/views/ingame_voting_ui_definitions")

IngameVotingUI = class(IngameVotingUI)

IngameVotingUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ui_top_renderer = arg_1_2.ui_top_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.voting_manager = arg_1_2.voting_manager
	self.platform = PLATFORM
	self.world_manager = arg_1_2.world_manager

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
	self.peer_id = Network.peer_id()

	self:create_ui_elements()
end

local flag = false

IngameVotingUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.scenegraph_definition = var_0_0.scenegraph_definition

	local widget_definitions = var_0_0.widget_definitions

	self.background = UIWidget.init(widget_definitions.background)
	self.option_yes = UIWidget.init(widget_definitions.option_yes)
	self.option_no = UIWidget.init(widget_definitions.option_no)
	flag = false
end

IngameVotingUI.destroy = function (self)
	-- function 3
	self.voting_manager:allow_vote_input(false)

	self.voting_manager = nil
end

IngameVotingUI.get_text_width = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = UIFontByResolution(arg_4_2)
	local font_size = arg_4_2.font_size
	local text_size, var_4_3 = UIRenderer.text_size(self.ui_top_renderer, arg_4_1, var_4_0[1], font_size)

	return text_size
end

IngameVotingUI.setup_option_input = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local num = 0
	local text = arg_5_2.text
	local input = arg_5_2.input
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("ingame_menu")
	local is_device_active = input_manager:is_device_active("gamepad")
	local get_gamepad_input_texture_data, var_5_7 = UISettings.get_gamepad_input_texture_data(get_service, input, is_device_active)

	if not is_device_active then
		get_gamepad_input_texture_data = nil
	end

	local content = arg_5_1.content
	local flag

	flag = not get_gamepad_input_texture_data and "" and sprintf("[%s]", var_5_7)
	content.input_text = flag

	local content_2 = arg_5_1.content
	local texture

	if not get_gamepad_input_texture_data then
		texture = get_gamepad_input_texture_data.texture

		if not texture then
			-- Nothing
		end
	end

	texture = nil

	::label_5_0::

	content_2.input_icon = texture

	local var_5_12 = Localize(text)

	arg_5_1.content.option_text = var_5_12

	local option_text = arg_5_1.style.option_text
	local option_text_shadow = arg_5_1.style.option_text_shadow
	local num_2 = num + self:get_text_width(var_5_12, option_text)

	if not get_gamepad_input_texture_data then
		local scenegraph_id = arg_5_1.style.input_icon.scenegraph_id
		local var_5_17 = self.ui_scenegraph[scenegraph_id]
		local size = var_5_17.size
		local local_position = var_5_17.local_position

		size[1] = get_gamepad_input_texture_data.size[1]
		size[2] = get_gamepad_input_texture_data.size[2]
		local_position[1] = -num_2 / 2
		option_text.offset[1] = size[1] / 2
		option_text_shadow.offset[1] = size[1] / 2 + 2
		num_2 = num_2 + size[1]
	else
		local input_text = arg_5_1.style.input_text
		local input_text_shadow = arg_5_1.style.input_text_shadow
		local get_text_width = self:get_text_width(arg_5_1.content.input_text, input_text)

		input_text.offset[1] = -num_2 / 2
		input_text_shadow.offset[1] = -num_2 / 2 + 2
		option_text.offset[1] = get_text_width / 2
		option_text_shadow.offset[1] = get_text_width / 2 + 2
		num_2 = num_2 + get_text_width
	end

	local left_side = arg_5_1.content.left_side
	local scenegraph_id_2 = arg_5_1.scenegraph_id
	local max = math.max(num_2 / 2 + 10, 50)
	local local_position_2 = self.ui_scenegraph[scenegraph_id_2].local_position
	local num_3

	if not left_side then
		num_3 = -max

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = max

	::label_5_1::

	local_position_2[1] = num_3
end

IngameVotingUI.align_option_inputs = function (arg_6_0)
	-- function 6
	return
end

IngameVotingUI.start_vote = function (self, arg_7_1)
	-- function 7
	self:clear_input_progress()

	local template = arg_7_1.template
	local text = template.text

	if not template.modify_title_text then
		text = template.modify_title_text(Localize(text), arg_7_1.data)
	end

	self.background.content.info_text = text
	self.voters = {}
	self.vote_results = {
		[1] = 0,
		[2] = 0
	}
	self.vote_started = true
	self.has_voted = false

	local is_device_active = self.input_manager:is_device_active("gamepad")

	if not is_device_active then
		self:on_gamepad_activated(arg_7_1)
	else
		local vote_options = template.vote_options

		self:setup_option_input(self.option_yes, vote_options[1], is_device_active)
		self:setup_option_input(self.option_no, vote_options[2], is_device_active)
	end

	self.option_yes.content.has_voted = false
	self.option_no.content.has_voted = false
	self.background.content.has_voted = false
	self.option_yes.content.result_text = tostring(0)
	self.option_no.content.result_text = tostring(0)
	self.gamepad_active = self.input_manager:is_device_active("gamepad")
	self.is_minimized = RESOLUTION_LOOKUP.minimized
	self.vote_successful = nil

	self:play_sound("play_gui_ban_popup")
	self:update_can_vote(not self.menu_active)
end

IngameVotingUI.update_vote = function (self, arg_8_1)
	-- function 8
	local result_boxes = self.result_boxes
	local voters = self.voters

	for k, v in pairs(arg_8_1) do
		if not voters[k] then
			voters[k] = k
			self.vote_results[v] = self.vote_results[v] + 1

			local flag = k == self.peer_id

			if not flag then
				self.has_voted = true
				self.option_yes.content.has_voted = true
				self.option_no.content.has_voted = true
				self.background.content.has_voted = true

				self.voting_manager:allow_vote_input(false)
			end

			local var_8_3

			if v == 1 then
				var_8_3 = self.option_yes

				self:play_sound("play_gui_ban_vote_yes")
			elseif v == 2 then
				var_8_3 = self.option_no

				self:play_sound("play_gui_ban_vote_no")
			else
				error("You done wrong.")
			end

			var_8_3.content.result_text = tostring(self.vote_results[v])
			var_8_3.content.option_text = sprintf("[%s]", tostring(self.vote_results[v]))

			if not self.has_voted and not flag then
				self:animate_option_get_vote(var_8_3)
			end
		end
	end

	local vote_time_left = self.voting_manager:vote_time_left()
	local format

	if not vote_time_left then
		format = string.format(" %02d:%02d", math.floor(vote_time_left / 60), vote_time_left % 60)

		if not format then
			-- Nothing
		end
	end

	format = "00:00"

	::label_8_0::

	self.background.content.time_text = format
end

IngameVotingUI.start_finish = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:clear_input_progress()

	self.on_finish = true
	self.finish_time = arg_9_2 + 2
	self.finish_anim_t = 0

	local var_9_0

	if arg_9_1.vote_result == 1 then
		var_9_0 = self.option_yes
		self.vote_successful = true
	elseif not (arg_9_1.vote_result == 2 or arg_9_1.vote_result ~= 0) then
		var_9_0 = self.option_no
	else
		error("Sillybillywilly")
	end

	self.finish_option = var_9_0

	self:animate_option_get_vote(self.finish_option)

	self.option_yes.content.has_voted = true
	self.option_no.content.has_voted = true
	self.background.content.has_voted = true

	self.voting_manager:allow_vote_input(false)
	self:update_can_vote(false)

	self.menu_active = nil
end

IngameVotingUI.stop_finish = function (self)
	-- function 10
	self.option_no.style.result_text.text_color[1] = 255
	self.option_yes.style.result_text.text_color[1] = 255
	self.finish_option = nil
	self.on_finish = nil

	if not self.vote_successful then
		self:play_sound("play_gui_ban_player_banned")

		self.vote_successful = nil
	end
end

IngameVotingUI.update_finish = function (self, arg_11_1, arg_11_2)
	-- function 11
	if arg_11_2 >= self.finish_time then
		self:stop_finish()
	else
		self.finish_anim_t = self.finish_anim_t + arg_11_1 * 8

		if math.sirp(0, 1, self.finish_anim_t) > 0.5 then
			self.finish_option.style.result_text.text_color[1] = 255
		else
			self.finish_option.style.result_text.text_color[1] = 180
		end
	end
end

IngameVotingUI.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local menu_active = self._parent:parent().menu_active

	if not flag then
		self:create_ui_elements()

		self.vote_started = false
	end

	local flag_2 = false
	local voting_manager = self.voting_manager
	local flag_3 = false

	if not voting_manager:vote_in_progress() and not voting_manager:is_ingame_vote() then
		if voting_manager:active_vote_data().kick_peer_id == self.peer_id then
			return
		end

		if menu_active ~= self.menu_active then
			self.menu_active = menu_active

			self:update_can_vote(not menu_active)
		end

		if not self.vote_started then
			if not self.on_finish then
				self:stop_finish()
			end

			self:start_vote(voting_manager.active_voting)
		end

		flag_3 = self:update_input_progress(voting_manager.active_voting)

		self:update_vote(voting_manager.active_voting.votes)

		if not self.has_voted then
			local flag_4 = false

			if not (not self.is_minimized and RESOLUTION_LOOKUP.minimized) then
				flag_4 = true
			end

			local is_device_active = self.input_manager:is_device_active("gamepad")

			if self.gamepad_active ~= is_device_active then
				self.gamepad_active = is_device_active
				flag_4 = true
			end

			if not flag_4 then
				local active_voting = voting_manager.active_voting
				local flag_5 = not active_voting and active_voting.template

				if not flag_5 then
					local vote_options = flag_5.vote_options

					self:setup_option_input(self.option_yes, vote_options[1])
					self:setup_option_input(self.option_no, vote_options[2])

					self.gamepad_active = is_device_active
				end
			end
		end

		flag_2 = true
	elseif not self.vote_started then
		local previous_vote_info = voting_manager:previous_vote_info()

		self:start_finish(previous_vote_info, arg_12_2)

		self.vote_started = nil
	end

	if not self.on_finish then
		self:update_finish(arg_12_1, arg_12_2)

		flag_2 = true
	end

	if not (not flag_2 and self.menu_active) then
		if not self.input_manager:is_device_active("gamepad") then
			if not self.gamepad_active_last_frame then
				self.gamepad_active_last_frame = true

				self:on_gamepad_activated(voting_manager.active_voting)
			end
		elseif not self.gamepad_active_last_frame then
			self.gamepad_active_last_frame = false

			self:on_gamepad_deactivated(voting_manager.active_voting)
		end

		self:draw(arg_12_1, flag_3)
	end
end

IngameVotingUI.on_gamepad_activated = function (self, arg_13_1)
	-- function 13
	if not self.has_voted then
		-- Nothing
	end

	local PLATFORM = PLATFORM

	if not IS_WINDOWS then
		PLATFORM = "xb1"
	end

	local texture = ButtonTextureByName("d_vertical", PLATFORM).texture

	self.background.content.gamepad_input_icon = texture
	self.background.content.gamepad_active = true

	if not arg_13_1 then
		local vote_options = arg_13_1.template.vote_options

		self:setup_option_input(self.option_yes, vote_options[1], true)
		self:setup_option_input(self.option_no, vote_options[2], true)
	end
end

IngameVotingUI.on_gamepad_deactivated = function (self, arg_14_1)
	-- function 14
	if not self.has_voted then
		-- Nothing
	end

	self.background.content.gamepad_active = false

	if not arg_14_1 then
		local vote_options = arg_14_1.template.vote_options

		self:setup_option_input(self.option_yes, vote_options[1])
		self:setup_option_input(self.option_no, vote_options[2])
	end
end

IngameVotingUI.draw = function (self, arg_15_1, arg_15_2)
	-- function 15
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	self:update_pulse_animations(arg_15_1, arg_15_2)
	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_15_1)
	UIRenderer.draw_widget(ui_top_renderer, self.background)
	UIRenderer.draw_widget(ui_top_renderer, self.option_yes)
	UIRenderer.draw_widget(ui_top_renderer, self.option_no)
	UIRenderer.end_pass(ui_top_renderer)
end

IngameVotingUI.update_pulse_animations = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not self.has_voted then
		return
	end

	local menu_active = self.menu_active
	local flag

	flag = not menu_active and 8 and 5

	local flag_2

	flag_2 = menu_active or arg_16_2 or not 0 or 0.5 + math.sin(Managers.time:time("ui") * flag) * 0.5

	if not menu_active then
		local num = 50 + flag_2 * 50
	else
		local num_2 = 100 + flag_2 * 155

		self.background.style.input_glow.color[1] = num_2
	end
end

IngameVotingUI.update_can_vote = function (self, arg_17_1)
	-- function 17
	self.background.content.can_vote = arg_17_1
	self.option_yes.content.can_vote = arg_17_1
	self.option_no.content.can_vote = arg_17_1

	self.voting_manager:allow_vote_input(arg_17_1)
end

local easeCubic = math.easeCubic

IngameVotingUI.animate_option_get_vote = function (arg_18_0, arg_18_1)
	-- function 18
	local num = 0.1
	local num_2 = 0.1
	local num_3 = num + num_2
	local num_4 = num / num_3
	local num_5 = num_2 / num_3

	local function fn(arg_19_0)
		-- function 19
		if arg_19_0 < num_4 then
			return easeCubic(arg_19_0 / num_4)
		elseif num_5 > 0 then
			return easeCubic((1 - arg_19_0) / num_5)
		else
			return 0
		end
	end

	local num_6 = 36
	local num_7 = 40
	local result_text = arg_18_1.style.result_text
	local result_text_shadow = arg_18_1.style.result_text_shadow
	local str = "font_size"
	local var_18_11 = UIAnimation.init(UIAnimation.function_by_time, result_text, str, num_6, num_7, num_3, fn)

	UIWidget.animate(arg_18_1, var_18_11)

	local var_18_12 = UIAnimation.init(UIAnimation.function_by_time, result_text_shadow, str, num_6, num_7, num_3, fn)

	UIWidget.animate(arg_18_1, var_18_12)
end

IngameVotingUI.update_input_progress = function (self, arg_20_1)
	-- function 20
	local flag = false
	local current_hold_input = arg_20_1.current_hold_input
	local var_20_2
	local var_20_3
	local var_20_4

	if current_hold_input == "ingame_vote_yes" then
		var_20_3 = self.option_yes
		var_20_4 = self.option_no
		var_20_2 = "left"
	elseif current_hold_input == "ingame_vote_no" then
		var_20_3 = self.option_no
		var_20_4 = self.option_yes
		var_20_2 = "right"
	end

	local input_hold_progress = arg_20_1.input_hold_progress

	input_hold_progress = input_hold_progress or 0

	local smoothstep = math.smoothstep(input_hold_progress, 0, 1)

	if not var_20_3 then
		local bar = var_20_3.style.bar
		local default_width = bar.default_width
		local offset = bar.offset
		local default_offset = bar.default_offset
		local size = bar.size

		if var_20_2 == "left" then
			size[1] = smoothstep * default_width
			offset[1] = default_offset[1] + (default_width - size[1])
		else
			size[1] = smoothstep * default_width
		end

		flag = true
	end

	if not var_20_4 then
		local bar_2 = var_20_4.style.bar
		local default_width_2 = bar_2.default_width
		local offset_2 = bar_2.offset
		local default_offset_2 = bar_2.default_offset
		local size_2 = bar_2.size

		if var_20_2 == "left" then
			size_2[1] = 0
		else
			size_2[1] = 0
			offset_2[1] = default_offset_2[1]
		end

		flag = true
	end

	if not current_hold_input then
		self.option_no.style.bar.size[1] = 0
		self.option_yes.style.bar.size[1] = 0
		self.option_yes.style.bar.offset[1] = self.option_yes.style.bar.default_offset[1]
	end

	return flag
end

IngameVotingUI.clear_input_progress = function (self)
	-- function 21
	if not self.option_yes then
		local bar = self.option_yes.style.bar
		local bar_bg = self.option_yes.style.bar_bg
		local default_width = bar.default_width
		local offset = bar.offset
		local default_offset = bar.default_offset

		bar.size[1] = 0
		offset[1] = default_offset[1]
	end

	if not self.option_no then
		local bar_2 = self.option_no.style.bar
		local bar_bg_2 = self.option_no.style.bar_bg
		local default_width_2 = bar_2.default_width

		bar_2.size[1] = 0
	end
end

IngameVotingUI.play_sound = function (self, arg_22_1)
	-- function 22
	WwiseWorld.trigger_event(self.wwise_world, arg_22_1)
end
