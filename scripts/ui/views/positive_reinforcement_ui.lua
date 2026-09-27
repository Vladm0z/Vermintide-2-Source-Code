-- chunkname: @scripts/ui/views/positive_reinforcement_ui.lua

require("scripts/settings/ui_player_portrait_frame_settings")

local var_0_0 = local_require("scripts/ui/views/positive_reinforcement_ui_definitions")
local MAX_NUMBER_OF_MESSAGES = var_0_0.MAX_NUMBER_OF_MESSAGES
local var_0_2 = local_require("scripts/ui/views/positive_reinforcement_ui_event_settings")
local tbl = {
	fade_to = Colors.get_table("white"),
	default = Colors.get_table("cheeseburger"),
	kill = Colors.get_table("red"),
	personal = Colors.get_table("dodger_blue")
}
local breed_textures = UISettings.breed_textures

PositiveReinforcementUI = class(PositiveReinforcementUI)

PositiveReinforcementUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.input_manager = arg_1_2.input_manager
	self.player_manager = arg_1_2.player_manager
	self.peer_id = arg_1_2.peer_id
	self.world = arg_1_2.world_manager:world("level_world")
	self.render_settings = {
		snap_pixel_positions = true
	}

	self:create_ui_elements()

	self._positive_enforcement_events = {}
	self._positive_enforcement_lookup = {}
	self._animations = {}

	local event = Managers.state.event

	event:register(self, "add_coop_feedback", "event_add_positive_enforcement")
	event:register(self, "add_coop_feedback_kill", "event_add_positive_enforcement_kill")
end

PositiveReinforcementUI.destroy = function (arg_2_0)
	-- function 2
	GarbageLeakDetector.register_object(arg_2_0, "positive_reinforcement_ui")

	local event = Managers.state.event

	event:unregister("add_coop_feedback", arg_2_0)
	event:unregister("add_coop_feedback_kill", arg_2_0)
end

PositiveReinforcementUI.create_ui_elements = function (self)
	-- function 3
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local hud_ui_settings = GameModeSettings[game_mode_key].hud_ui_settings
	local scenegraph_definition = var_0_0.scenegraph_definition

	if not hud_ui_settings and not hud_ui_settings.killfeed_offset then
		scenegraph_definition.message_animated = table.clone(scenegraph_definition.message_animated_offset)
	else
		scenegraph_definition.message_animated = table.clone(scenegraph_definition.message_animated_base)
	end

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.message_widgets = {}
	self._unused_widgets = {}

	local num = 0

	for k, v in pairs(var_0_0.message_widgets) do
		num = num + 1
		self.message_widgets[num] = UIWidget.init(v)
		self._unused_widgets[num] = UIWidget.init(v)
	end
end

PositiveReinforcementUI.remove_event = function (self, arg_4_1)
	-- function 4
	local _positive_enforcement_events = self._positive_enforcement_events
	local remove = table.remove(_positive_enforcement_events, arg_4_1)
	local widget = remove.widget

	self._positive_enforcement_lookup[remove.full_hash] = nil

	local _unused_widgets = self._unused_widgets

	_unused_widgets[#_unused_widgets + 1] = widget
end

local function fn(arg_5_0, arg_5_1)
	-- function 5
	local extension = ScriptUnit.extension(arg_5_0, "buff_system")
	local extension_2 = ScriptUnit.extension(arg_5_1, "health_system")
	local apply_buffs_to_value, var_5_3 = extension:apply_buffs_to_value(0, "shielding_player_by_assist")

	if not var_5_3 then
		if not Managers.player.is_server then
			DamageUtils.heal_network(arg_5_1, arg_5_0, apply_buffs_to_value, "buff")
			DamageUtils.heal_network(arg_5_0, arg_5_0, apply_buffs_to_value, "buff")
		else
			local network = Managers.state.network
			local network_transmit = network.network_transmit
			local unit_game_object_id = network:unit_game_object_id(arg_5_1)
			local unit_game_object_id_2 = network:unit_game_object_id(arg_5_0)
			local buff = NetworkLookup.heal_types.buff

			network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, apply_buffs_to_value, buff)
			network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id_2, apply_buffs_to_value, buff)
		end
	end
end

PositiveReinforcementUI.add_event = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, ...)
	-- function 6
	if not script_data.disable_reinforcement_ui then
		local _positive_enforcement_events = self._positive_enforcement_events
		local str = arg_6_1 .. arg_6_4
		local positive_reinforcement = UISettings.positive_reinforcement
		local time = Managers.time:time("ui")
		local increment_duration = positive_reinforcement.increment_duration
		local var_6_5 = var_0_2[arg_6_4]
		local var_6_6 = self._positive_enforcement_lookup[str]

		if not var_6_6 and not positive_reinforcement.folding_enabled then
			local content = var_6_6.widget.content
			local num = content.count + 1

			content.count_text = num .. "x"
			content.count = num
			var_6_6.remove_time = nil
		else
			local message_widgets = self.message_widgets
			local _unused_widgets = self._unused_widgets

			if #_unused_widgets == 0 then
				self:remove_event(#_positive_enforcement_events)
			end

			local remove = table.remove(_unused_widgets, 1)
			local offset = remove.offset
			local tbl = {
				text = "",
				shown_amount = 0,
				amount = 0,
				full_hash = str,
				widget = remove,
				event_type = arg_6_4,
				is_local_player = arg_6_2,
				data = {
					...
				}
			}
			local num_2 = #_positive_enforcement_events + 1

			table.insert(_positive_enforcement_events, 1, tbl)

			self._positive_enforcement_lookup[str] = tbl

			local content_2 = remove.content
			local style = remove.style

			content_2.count = 1
			content_2.count_text = nil

			local icon_function, var_6_18, var_6_19 = var_6_5.icon_function(...)

			self:_assign_portrait_texture(remove, "portrait_1", icon_function)
			self:_assign_portrait_texture(remove, "portrait_2", var_6_19)

			content_2.icon = var_6_18
			offset[2] = 0

			local texte_style_ids = content_2.texte_style_ids

			for i, v in ipairs(texte_style_ids) do
				style[v].color[1] = 255
			end
		end

		if not arg_6_2 then
			local sound_function = var_6_5.sound_function()

			if not sound_function then
				local world = self.world
				local wwise_world = Managers.world:wwise_world(world)

				WwiseWorld.trigger_event(wwise_world, sound_function)
			end
		end
	end
end

local tbl_2 = {
	96,
	112
}

PositiveReinforcementUI._assign_portrait_texture = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local var_7_0 = arg_7_1.style[arg_7_2]

	if not arg_7_3 then
		var_7_0.size = {
			0,
			0
		}

		return
	end

	arg_7_1.content[arg_7_2].texture_id = arg_7_3

	local clone = table.clone(tbl_2)

	if not UIAtlasHelper.has_atlas_settings_by_texture_name(arg_7_3) then
		local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_7_3)

		clone[1] = get_atlas_settings_by_texture_name.size[1]
		clone[2] = get_atlas_settings_by_texture_name.size[2]
	end

	local var_7_3 = arg_7_1.style[arg_7_2]
	local portrait_offset = var_7_3.portrait_offset
	local offset = var_7_3.offset

	offset[1] = portrait_offset[1] - clone[1] / 2
	offset[2] = portrait_offset[2] - clone[2] / 2
	var_7_3.size = clone
end

PositiveReinforcementUI.event_add_positive_enforcement = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	if not var_0_2[arg_8_3] then
		return
	end

	if not (not arg_8_4 and arg_8_4:name()) then
		local var_8_0
	end

	if not (not arg_8_5 and arg_8_5:name()) then
		local var_8_1
	end

	local flag = not arg_8_4 and arg_8_4.player_unit
	local flag_2 = not arg_8_5 and arg_8_5.player_unit
	local alive = Unit.alive(flag)

	alive = not alive and ScriptUnit.extension(flag, "career_system")

	local alive_2 = Unit.alive(flag_2)

	alive_2 = not alive_2 and ScriptUnit.extension(flag_2, "career_system")

	local profile_index

	if not arg_8_4 then
		profile_index = arg_8_4:profile_index()

		if not profile_index then
			-- Nothing
		end
	end

	profile_index = nil

	do
		local profile_index_2
	end

	::label_8_0::

	if not arg_8_5 then
		profile_index_2 = arg_8_5:profile_index()

		if not profile_index_2 then
			-- Nothing
		end
	end

	profile_index_2 = nil

	do
		local career_index
	end

	::label_8_1::

	if not alive then
		career_index = alive:career_index()

		if not career_index then
			-- Nothing
		end
	end

	career_index = not arg_8_4 and arg_8_4:career_index()

	do
		local career_index_2
	end

	::label_8_2::

	if not alive_2 then
		career_index_2 = alive_2:career_index()

		if not career_index_2 then
			-- Nothing
		end
	end

	career_index_2 = not arg_8_5 and arg_8_5:career_index()

	::label_8_3::

	local flag_3 = not profile_index and not career_index and self:_get_hero_portrait(profile_index, career_index)
	local flag_4 = not profile_index_2 and not career_index_2 and self:_get_hero_portrait(profile_index_2, career_index_2)

	if not (not flag_3 and flag_4) then
		return
	end

	self:add_event(arg_8_1, arg_8_2, tbl.default, arg_8_3, flag_3, flag_4)
end

PositiveReinforcementUI.event_add_positive_enforcement_kill = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local var_9_0 = breed_textures[arg_9_4]
	local var_9_1 = breed_textures[arg_9_5]

	if not (not var_0_2[arg_9_3] and not var_9_0 and var_9_1) then
		return
	end

	self:add_event(arg_9_1, arg_9_2, tbl.kill, arg_9_3, var_9_0, var_9_1)
end

PositiveReinforcementUI.event_add_positive_enforcement_player_knocked_down_or_killed = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local var_10_0 = breed_textures[arg_10_5]

	if not (not var_0_2[arg_10_3] and var_10_0) then
		return
	end

	if not arg_10_4 then
		return
	end

	local _get_hero_portrait = self:_get_hero_portrait(arg_10_4)

	self:add_event(arg_10_1, arg_10_2, tbl.kill, arg_10_3, var_10_0, _get_hero_portrait)
end

PositiveReinforcementUI.event_add_lorebook_page_pickup = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	self:add_event(arg_11_1, arg_11_2, tbl.personal, arg_11_3, arg_11_4)
end

PositiveReinforcementUI.event_add_interaction_warning = function (self, arg_12_1, arg_12_2)
	-- function 12
	self:add_event(arg_12_1, true, tbl.kill, "interaction_warning", Localize(arg_12_2))
end

PositiveReinforcementUI._get_hero_portrait = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local scale = RESOLUTION_LOOKUP.scale
	local var_13_1 = SPProfiles[arg_13_1]
	local var_13_2 = var_13_1.careers[arg_13_2]
	local display_name = var_13_1.display_name
	local portrait_image = var_13_2.portrait_image

	return "small_" .. portrait_image
end

local tbl_3 = {
	root_scenegraph_id = "pivot",
	label = "Kill feed",
	registry_key = "kill_feed",
	drag_scenegraph_id = "pivot_dragger"
}

PositiveReinforcementUI.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl_3)

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")
	local render_settings = self.render_settings

	for k, v in pairs(self._animations) do
		if not self._animations[k] then
			if not UIAnimation.completed(v) then
				UIAnimation.update(v, arg_14_1)
			else
				self._animations[k] = nil
			end
		end
	end

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_14_1, nil, render_settings)

	local _positive_enforcement_events = self._positive_enforcement_events
	local show_duration = UISettings.positive_reinforcement.show_duration
	local snap_pixel_positions = render_settings.snap_pixel_positions

	for i, v_2 in ipairs(_positive_enforcement_events) do
		local widget = v_2.widget
		local content = widget.content
		local style = widget.style
		local offset = widget.offset
		local event_type = v_2.event_type
		local var_14_12 = var_0_2[event_type]
		local flag = false

		if not v_2.remove_time then
			v_2.remove_time = arg_14_2 + show_duration
		elseif arg_14_2 > v_2.remove_time then
			self:remove_event(i)

			flag = true
		end

		if not flag then
			local num = 80
			local num_2 = -((i - 1) * num)
			local abs = math.abs(math.abs(offset[2]) - math.abs(num_2))

			if num_2 < offset[2] then
				local num_3 = 400

				offset[2] = math.max(offset[2] - arg_14_1 * num_3, num_2)
			else
				offset[2] = num_2
			end

			local num_4 = v_2.remove_time - arg_14_2
			local fade_duration = UISettings.positive_reinforcement.fade_duration
			local num_5 = 0

			if fade_duration < num_4 then
				num_5 = math.clamp((show_duration - num_4) / fade_duration, 0, 1)
				offset[1] = -(math.easeInCubic(1 - num_5) * 35)
			else
				num_5 = math.clamp(num_4 / fade_duration, 0, 1)
			end

			local num_6 = 255 * math.easeOutCubic(num_5)
			local texte_style_ids = content.texte_style_ids

			for i_2, v_3 in ipairs(texte_style_ids) do
				style[v_3].color[1] = num_6
			end

			render_settings.snap_pixel_positions = num_4 <= fade_duration

			UIRenderer.draw_widget(ui_renderer, widget)

			render_settings.snap_pixel_positions = snap_pixel_positions
		end
	end

	UIRenderer.end_pass(ui_renderer)
end
