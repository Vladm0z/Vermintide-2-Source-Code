-- chunkname: @scripts/ui/hud_ui/item_received_feedback_ui.lua

require("scripts/settings/ui_player_portrait_frame_settings")

local var_0_0 = local_require("scripts/ui/hud_ui/item_received_feedback_ui_definitions")
local MAX_NUMBER_OF_MESSAGES = var_0_0.MAX_NUMBER_OF_MESSAGES
local tbl = {
	give_item = {
		text_function = function (arg_1_0, arg_1_1, arg_1_2)
			-- function 1
			if arg_1_0 > 1 then
				return string.format(Localize("positive_reinforcement_player_gave_item_player_multiple"), arg_1_1, arg_1_2, arg_1_0)
			else
				return string.format(Localize("positive_reinforcement_player_gave_item_player"), arg_1_1, arg_1_2)
			end
		end,
		sound_function = function ()
			-- function 2
			local reinforcement_ui_local_sound = script_data.reinforcement_ui_local_sound

			if not reinforcement_ui_local_sound then
				reinforcement_ui_local_sound = "hud_achievement_unlock_02"
			end

			if false then
				reinforcement_ui_local_sound = script_data.enable_reinforcement_ui_remote_sound
				reinforcement_ui_local_sound = not reinforcement_ui_local_sound and "hud_info"
			end

			return reinforcement_ui_local_sound
		end,
		icon_function = function (arg_3_0, arg_3_1)
			-- function 3
			return arg_3_0, arg_3_1
		end
	}
}
local tbl_2 = {
	fade_to = Colors.get_table("white"),
	default = Colors.get_table("cheeseburger"),
	kill = Colors.get_table("red"),
	personal = Colors.get_table("dodger_blue")
}
local tbl_3 = {
	healthkit_first_aid_kit_01 = "reinforcement_heal",
	grenade_fire_02 = "killfeed_icon_09",
	potion_healing_draught_01 = "killfeed_icon_06",
	grenade_frag_02 = "killfeed_icon_05",
	grenade_fire_01 = "killfeed_icon_09",
	grenade_frag_01 = "killfeed_icon_05",
	grenade_engineer = "killfeed_icon_05",
	potion_cooldown_reduction_01 = "killfeed_icon_13",
	potion_damage_boost_01 = "killfeed_icon_10",
	potion_speed_boost_01 = "killfeed_icon_04"
}

ItemReceivedFeedbackUI = class(ItemReceivedFeedbackUI)

ItemReceivedFeedbackUI.init = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._parent = arg_4_1
	self.ui_renderer = arg_4_2.ui_renderer
	self.input_manager = arg_4_2.input_manager
	self.player_manager = arg_4_2.player_manager
	self.peer_id = arg_4_2.peer_id
	self.world = arg_4_2.world_manager:world("level_world")
	self.render_settings = {
		snap_pixel_positions = true
	}

	self:create_ui_elements()

	self._received_events = {}
	self._hash_order = {}
	self._hash_widget_lookup = {}
	self._animations = {}

	Managers.state.event:register(self, "give_item_feedback", "event_give_item_feedback")
end

ItemReceivedFeedbackUI.destroy = function (arg_5_0)
	-- function 5
	GarbageLeakDetector.register_object(arg_5_0, "item_received_feedback_ui")
	Managers.state.event:unregister("give_item_feedback", arg_5_0)
end

ItemReceivedFeedbackUI.create_ui_elements = function (self)
	-- function 6
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.message_widgets = {}
	self._unused_widgets = {}

	local num = 0

	for k, v in pairs(var_0_0.message_widgets) do
		num = num + 1
		self.message_widgets[num] = UIWidget.init(v)
		self._unused_widgets[num] = UIWidget.init(v)
	end
end

ItemReceivedFeedbackUI.remove_event = function (self, arg_7_1)
	-- function 7
	local _received_events = self._received_events
	local widget = table.remove(_received_events, arg_7_1).widget
	local _unused_widgets = self._unused_widgets

	_unused_widgets[#_unused_widgets + 1] = widget
end

ItemReceivedFeedbackUI.add_event = function (self, arg_8_1, arg_8_2, arg_8_3, ...)
	-- function 8
	if not script_data.disable_reinforcement_ui then
		local _received_events = self._received_events
		local str = arg_8_1 .. arg_8_3
		local _hash_order = self._hash_order
		local time = Managers.time:time("game")
		local increment_duration = UISettings.positive_reinforcement.increment_duration
		local message_widgets = self.message_widgets
		local _unused_widgets = self._unused_widgets

		if #_unused_widgets == 0 then
			self:remove_event(#_received_events)
		end

		local var_8_7 = tbl[arg_8_3]
		local remove = table.remove(_unused_widgets, 1)
		local offset = remove.offset
		local tbl_2 = {
			text = "",
			shown_amount = 0,
			amount = 0,
			widget = remove,
			event_type = arg_8_3,
			next_increment = time - increment_duration,
			data = {
				...
			}
		}
		local num = #_received_events + 1

		table.insert(_received_events, 1, tbl_2)

		local content = remove.content
		local style = remove.style
		local icon_function, var_8_15 = var_8_7.icon_function(...)

		self:_assign_portrait_texture(remove, "portrait_1", icon_function)

		content.icon = var_8_15
		offset[2] = 0
		offset[1] = 0

		local text_style_ids = content.text_style_ids

		for i, v in ipairs(text_style_ids) do
			style[v].color[1] = 255
		end

		local sound_function = var_8_7.sound_function()

		if not sound_function then
			local world = self.world
			local wwise_world = Managers.world:wwise_world(world)

			WwiseWorld.trigger_event(wwise_world, sound_function)
		end
	end
end

local tbl_4 = {
	96,
	112
}

ItemReceivedFeedbackUI._assign_portrait_texture = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	arg_9_1.content[arg_9_2].texture_id = arg_9_3

	local clone = table.clone(tbl_4)

	if not UIAtlasHelper.has_atlas_settings_by_texture_name(arg_9_3) then
		local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_9_3)

		clone[1] = get_atlas_settings_by_texture_name.size[1]
		clone[2] = get_atlas_settings_by_texture_name.size[2]
	end

	local var_9_2 = arg_9_1.style[arg_9_2]
	local portrait_offset = var_9_2.portrait_offset
	local offset = var_9_2.offset

	offset[1] = portrait_offset[1] - clone[1] / 2
	offset[2] = portrait_offset[2] - clone[2] / 2
	var_9_2.size = clone
end

ItemReceivedFeedbackUI.event_give_item_feedback = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not (not arg_10_2 and arg_10_2:name()) then
		local var_10_0
	end

	local flag = not arg_10_2 and arg_10_2.player_unit
	local alive = Unit.alive(flag)

	alive = not alive and ScriptUnit.extension(flag, "career_system")

	local career_index

	if not alive then
		career_index = alive:career_index()

		if not career_index then
			-- Nothing
		end
	end

	career_index = not arg_10_2 and arg_10_2:profile_index()

	do
		local profile_index
	end

	::label_10_0::

	if not arg_10_2 then
		profile_index = arg_10_2:profile_index()

		if not profile_index then
			-- Nothing
		end
	end

	profile_index = nil

	::label_10_1::

	local flag_2 = not profile_index and not career_index and self:_get_hero_portrait(profile_index, career_index)
	local var_10_6 = ItemMasterList[arg_10_3]
	local flag_3 = not var_10_6 and var_10_6.item_received_icon
	local var_10_8 = tbl_3[arg_10_3]

	var_10_8 = var_10_8 or flag_3 or "icons_placeholder"

	self:add_event(arg_10_1, tbl_2.default, "give_item", flag_2, var_10_8)
end

ItemReceivedFeedbackUI._get_hero_portrait = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local scale = RESOLUTION_LOOKUP.scale
	local var_11_1 = SPProfiles[arg_11_1]
	local var_11_2 = var_11_1.careers[arg_11_2]
	local display_name = var_11_1.display_name
	local portrait_image = var_11_2.portrait_image

	return "small_" .. portrait_image
end

local tbl_5 = {
	root_scenegraph_id = "message_animated",
	label = "Item received",
	registry_key = "item_received",
	drag_scenegraph_id = "message_animated_dragger"
}

ItemReceivedFeedbackUI.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")
	local render_settings = self.render_settings

	if not HudCustomizer.run(ui_renderer, ui_scenegraph, tbl_5) then
		UISceneGraph.update_scenegraph(ui_scenegraph)
	end

	for k, v in pairs(self._animations) do
		if not self._animations[k] then
			if not UIAnimation.completed(v) then
				UIAnimation.update(v, arg_12_1)
			else
				self._animations[k] = nil
			end
		end
	end

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_12_1, nil, render_settings)

	local _received_events = self._received_events
	local num = 2
	local num_2 = 2.5

	for i, v_2 in ipairs(_received_events) do
		local snap_pixel_positions = render_settings.snap_pixel_positions
		local widget = v_2.widget
		local content = widget.content
		local style = widget.style
		local offset = widget.offset
		local event_type = v_2.event_type
		local var_12_13 = tbl[event_type]
		local flag = false

		if not v_2.remove_time then
			v_2.remove_time = arg_12_2 + num_2
		elseif arg_12_2 > v_2.remove_time then
			self:remove_event(i)

			flag = true
		end

		if not flag then
			local num_3 = 70
			local num_4 = (i - 1) * num_3
			local abs = math.abs(math.abs(offset[2]) - math.abs(num_4))
			local num_5 = v_2.remove_time - arg_12_2
			local num_6 = 0.3
			local num_7 = 0

			if num_6 < num_5 then
				num_7 = math.clamp((num_2 - num_5) / num_6, 0, 1)
			else
				num_7 = math.clamp(num_5 / num_6, 0, 1)
			end

			local max = math.max(num_5 - (num_2 - num), 0)
			local num_8 = 1 - math.clamp(max / num, 0, 1)

			offset[1] = 50 * math.easeOutCubic(num_8)
			style.arrow.offset[1] = 35 * math.easeOutCubic(num_8)
			style.icon.offset[1] = 80 * math.easeOutCubic(num_8)

			local num_9 = 255 * math.easeOutCubic(num_7)
			local text_style_ids = content.text_style_ids

			for i_2, v_3 in ipairs(text_style_ids) do
				style[v_3].color[1] = num_9
			end

			render_settings.snap_pixel_positions = max == 0

			UIRenderer.draw_widget(ui_renderer, widget)
		end

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(ui_renderer)
end
