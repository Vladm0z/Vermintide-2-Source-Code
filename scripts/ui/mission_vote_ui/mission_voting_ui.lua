-- chunkname: @scripts/ui/mission_vote_ui/mission_voting_ui.lua

local var_0_0 = local_require("scripts/ui/mission_vote_ui/mission_voting_ui_definitions")
local generic_input_actions = var_0_0.generic_input_actions
local deed_game_widgets = var_0_0.deed_game_widgets
local custom_game_widgets = var_0_0.custom_game_widgets
local adventure_game_widgets = var_0_0.adventure_game_widgets
local game_mode_widgets = var_0_0.game_mode_widgets
local event_game_widgets = var_0_0.event_game_widgets
local weave_game_widgets = var_0_0.weave_game_widgets
local weave_quickplay_widgets = var_0_0.weave_quickplay_widgets
local deus_quickplay_widget = var_0_0.deus_quickplay_widget
local deus_custom_widget = var_0_0.deus_custom_widget
local twitch_mode_widget_funcs = var_0_0.twitch_mode_widget_funcs
local switch_mechanism_widgets = var_0_0.switch_mechanism_widgets
local versus_quickplay_widgets = var_0_0.versus_quickplay_widgets
local versus_custom_widgets = var_0_0.versus_custom_widgets
local deus_weekly_event_widgets = var_0_0.deus_weekly_event_widgets
local deus_weekly_event_create_header = var_0_0.deus_weekly_event_create_header
local deus_weekly_event_create_entry_widget = var_0_0.deus_weekly_event_create_entry_widget

MissionVotingUI = class(MissionVotingUI)

MissionVotingUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ui_top_renderer = arg_1_2.ui_top_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.wwise_world = arg_1_2.wwise_world
	self.input_manager = arg_1_2.input_manager
	self.voting_manager = arg_1_2.voting_manager
	self.statistics_db = arg_1_2.statistics_db
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._is_server = arg_1_2.is_server
	self._stats_id = Managers.player:local_player():stats_id()

	self:create_ui_elements()

	local input_manager = self.input_manager

	input_manager:create_input_service("mission_voting", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("mission_voting", "keyboard")
	input_manager:map_device_to_service("mission_voting", "mouse")
	input_manager:map_device_to_service("mission_voting", "gamepad")

	local get_service = input_manager:get_service("mission_voting")

	self._menu_input_description = MenuInputDescriptionUI:new(arg_1_2, self.ui_top_renderer, get_service, 3, 900, generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)
end

MissionVotingUI.create_ui_elements = function (self)
	-- function 2
	self._ui_animations = {}
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(var_0_0.widgets)
	self._widgets_deus, self._widgets_deus_by_name = UIUtils.create_widgets(var_0_0.widgets_deus)
	self._deed_widgets, self._deed_widgets_by_name = UIUtils.create_widgets(deed_game_widgets)
	self._custom_game_widgets, self._custom_game_widgets_by_name = UIUtils.create_widgets(custom_game_widgets)
	self._event_game_widgets, self._event_game_widgets_by_name = UIUtils.create_widgets(event_game_widgets)
	self._weave_game_widgets, self._weave_game_widgets_by_name = UIUtils.create_widgets(weave_game_widgets)
	self._weave_quickplay_widgets, self._weave_quickplay_widgets_by_name = UIUtils.create_widgets(weave_quickplay_widgets)
	self._deus_quickplay_widgets, self._deus_quickplay_widgets_by_name = UIUtils.create_widgets(deus_quickplay_widget)
	self._deus_custom_widgets, self._deus_custom_widgets_by_name = UIUtils.create_widgets(deus_custom_widget)
	self._adventure_game_widgets, self._adventure_game_widgets_by_name = UIUtils.create_widgets(adventure_game_widgets)
	self._game_mode_widgets, self._game_mode_widgets_by_name = UIUtils.create_widgets(game_mode_widgets)
	self._switch_mechanism_widgets, self._switch_mechanism_widgets_by_name = UIUtils.create_widgets(switch_mechanism_widgets)
	self._versus_quickplay_widgets, self._versus_quickplay_widgets_by_name = UIUtils.create_widgets(versus_quickplay_widgets)
	self._versus_custom_widgets, self._versus_custom_widgets_by_name = UIUtils.create_widgets(versus_custom_widgets)
	self._deus_weekly_event_widgets, self._deus_weekly_event_widgets_by_name = UIUtils.create_widgets(deus_weekly_event_widgets)

	local tbl = {}
	local tbl_2 = {}
	local _is_server = self._is_server

	for k, v in pairs(twitch_mode_widget_funcs) do
		local var_2_3 = UIWidget.init(v(_is_server))

		tbl[#tbl + 1] = var_2_3
		tbl_2[k] = var_2_3
	end

	self._twitch_widgets = tbl
	self._twitch_widgets_by_name = tbl_2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.scenegraph_definition = var_0_0.scenegraph_definition

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)
end

MissionVotingUI.destroy = function (self)
	-- function 3
	if not self.vote_started then
		self:on_vote_ended()
	end
end

MissionVotingUI.get_chrome_widgets = function (self)
	-- function 4
	if self._active_mechanism == "deus" then
		return self._widgets_deus_by_name, self._widgets_deus
	else
		return self._widgets_by_name, self._widgets
	end
end

MissionVotingUI.is_active = function (self)
	-- function 5
	local vote_started = self.vote_started

	vote_started = not vote_started and not self.has_voted

	return vote_started
end

MissionVotingUI.setup_option_input = function (self, arg_6_1, arg_6_2)
	-- function 6
	local text = arg_6_2.text
	local input = arg_6_2.input
	local get_service = self.input_manager:get_service("mission_voting")
	local flag = false
	local get_gamepad_input_texture_data, var_6_5 = UISettings.get_gamepad_input_texture_data(get_service, input, flag)

	if not flag then
		local var_6_6
	end

	local var_6_7 = Localize(text)

	arg_6_1.content.title_text = var_6_7
end

MissionVotingUI.start_vote = function (self, arg_7_1)
	-- function 7
	self.render_settings.alpha_multiplier = 0
	self._scrollbar_ui = nil

	local template = arg_7_1.template

	if not (not template.can_start_vote and template.can_start_vote(arg_7_1.data)) then
		local text = template.text

		text = text or "Unknown vote"

		printf("[MissionVotingUI] - Terminating vote request (%s) due to the requirements to start was not fulfilled.", text)

		return
	end

	local data = arg_7_1.data
	local matchmaking_type = data.matchmaking_type
	local mechanism = data.mechanism
	local switch_mechanism = data.switch_mechanism

	self._twitch_mode_enabled = data.twitch_enabled
	self._matchmaking_type = data.matchmaking_type
	self._active_mechanism = mechanism
	self._difficulty = data.difficulty

	if not switch_mechanism then
		self:_set_switch_mechanism_presentation(data)
	elseif mechanism == "weave" then
		if not data.quick_game then
			local difficulty = data.difficulty

			self:_set_weave_quickplay_presentation(difficulty)
		else
			local mission_id = data.mission_id
			local difficulty_2 = data.difficulty
			local private_game = data.private_game

			self:_set_weave_presentation(difficulty_2, mission_id, private_game)
		end
	elseif mechanism == "deus" then
		if not data.quick_game then
			local difficulty_3 = data.difficulty

			self:_set_deus_quickplay_presentation(difficulty_3)
		elseif matchmaking_type == "event" then
			local mission_id_2 = data.mission_id
			local difficulty_4 = data.difficulty
			local private_game_2 = data.private_game
			local always_host = data.always_host
			local strict_matchmaking = data.strict_matchmaking
			local dominant_god = data.dominant_god
			local event_data = data.event_data
			local mutators

			if not event_data then
				mutators = event_data.mutators

				if not mutators then
					-- Nothing
				end
			end

			mutators = {}

			do
				local boons
			end

			::label_7_0::

			if not event_data then
				boons = event_data.boons

				if not boons then
					-- Nothing
				end
			end

			boons = {}

			::label_7_1::

			self:_set_deus_weekly_expedition_presentation(difficulty_4, mission_id_2, private_game_2, always_host, strict_matchmaking, dominant_god, mutators, boons)
		else
			local mission_id_3 = data.mission_id
			local difficulty_5 = data.difficulty
			local private_game_3 = data.private_game
			local always_host_2 = data.always_host
			local strict_matchmaking_2 = data.strict_matchmaking
			local dominant_god_2 = data.dominant_god

			self:_set_deus_custom_game_presentation(difficulty_5, mission_id_3, private_game_3, always_host_2, strict_matchmaking_2, dominant_god_2)
		end
	elseif mechanism == "versus" then
		if not data.player_hosted then
			local difficulty_6 = data.difficulty

			self:_set_versus_quickplay_presentation(difficulty_6)
		else
			local mission_id_4 = data.mission_id

			mission_id_4 = mission_id_4 or "bell_pvp"

			local difficulty_7 = data.difficulty
			local player_hosted = data.player_hosted
			local dedicated_servers_win = data.dedicated_servers_win
			local dedicated_servers_aws = data.dedicated_servers_aws

			self:_set_versus_custom_game_presentation(difficulty_7, mission_id_4, player_hosted, dedicated_servers_win, dedicated_servers_aws)
		end
	elseif matchmaking_type == "deed" then
		local item_name = data.item_name
		local mission_id_5 = data.mission_id
		local difficulty_8 = data.difficulty

		self:_set_deed_presentation(item_name, mission_id_5, difficulty_8)
	elseif matchmaking_type == "event" then
		local event_data_2 = data.event_data
		local mission_id_6 = data.mission_id
		local difficulty_9 = data.difficulty
		local mutators_2

		if not event_data_2 then
			mutators_2 = event_data_2.mutators

			if not mutators_2 then
				-- Nothing
			end
		end

		mutators_2 = {}

		::label_7_2::

		if not (not event_data_2 and event_data_2.boons) then
			local tbl = {}
		end

		self:_set_event_game_presentation(difficulty_9, mission_id_6, mutators_2)
	elseif not data.quick_game then
		local difficulty_10 = data.difficulty

		self:_set_adventure_presentation(difficulty_10)
	elseif data.mechanism_key ~= nil then
		local mechanism_key = data.mechanism_key

		self:_set_game_mode_presentation(mechanism_key)
	else
		local mission_id_7 = data.mission_id
		local difficulty_11 = data.difficulty
		local private_game_4 = data.private_game
		local always_host_3 = data.always_host
		local strict_matchmaking_3 = data.strict_matchmaking

		self:_set_custom_game_presentation(difficulty_11, mission_id_7, private_game_4, always_host_3, strict_matchmaking_3)
	end

	local text_2 = template.text

	if not template.modify_title_text then
		text_2 = template.modify_title_text(Localize(text_2), data)
	else
		text_2 = Localize(text_2)
	end

	local get_chrome_widgets = self:get_chrome_widgets()

	get_chrome_widgets.title_text.content.text = text_2
	self.voters = {}
	self.vote_results = {
		[1] = 0,
		[2] = 0
	}
	self.vote_started = true
	self.has_voted = false

	local vote_options = template.vote_options

	self:setup_option_input(get_chrome_widgets.button_confirm, vote_options[1])
	self:setup_option_input(get_chrome_widgets.button_abort, vote_options[2])

	self.gamepad_active = self.input_manager:is_device_active("gamepad")

	self:_acquire_input()

	local world = self.ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_amount", 0.75)
		ShadingEnvironment.apply(get_data)
	end

	self:_play_sound("play_gui_mission_vote_start")

	self._ui_animations.twitch_info = UIAnimation.init(UIAnimation.function_by_time, self.ui_scenegraph.twitch_mode_info.local_position, 1, 400, 0, 0.3, math.easeOutCubic)

	self:_check_initial_votes()
	self:_setup_gamepad_input_desc(template)
end

MissionVotingUI._setup_gamepad_input_desc = function (self, arg_8_1)
	-- function 8
	local gamepad_input_desc = arg_8_1.gamepad_input_desc

	if not gamepad_input_desc then
		self._menu_input_description:set_input_description(generic_input_actions[gamepad_input_desc])
	else
		self._menu_input_description:set_input_description(nil)
	end
end

MissionVotingUI._check_initial_votes = function (self)
	-- function 9
	if not self.voting_manager:has_voted(Network.peer_id()) then
		self:on_vote_casted()
	end
end

MissionVotingUI.on_vote_casted = function (self, arg_10_1)
	-- function 10
	self.has_voted = true

	self.voting_manager:allow_vote_input(false)

	if not arg_10_1 then
		self:_play_sound("play_gui_mission_vote_button_accept")
	else
		self:_play_sound("play_gui_mission_vote_button_decline")
	end

	self:_release_input()

	local world = self.ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_enabled", 0)
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_amount", 0)
		ShadingEnvironment.apply(get_data)
	end
end

MissionVotingUI.on_vote_ended = function (self)
	-- function 11
	if not self.has_voted then
		self.voting_manager:allow_vote_input(false)
		self:_release_input()

		local world = self.ui_renderer.world
		local get_data = World.get_data(world, "shading_environment")

		if not get_data then
			ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_enabled", 0)
			ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_amount", 0)
			ShadingEnvironment.apply(get_data)
		end
	end

	local ingame_ui = self.ingame_ui

	if not ingame_ui:is_local_player_ready_for_game() then
		ingame_ui:suspend_active_view()
	end

	self.has_voted = nil
	self.vote_started = nil
end

MissionVotingUI._set_weave_quickplay_presentation = function (self, arg_12_1)
	-- function 12
	local var_12_0 = DifficultySettings[arg_12_1]
	local display_name = var_12_0.display_name
	local display_image = var_12_0.display_image
	local completed_frame_texture = var_12_0.completed_frame_texture

	completed_frame_texture = completed_frame_texture or "map_frame_00"

	local game_option_1 = self._weave_quickplay_widgets_by_name.game_option_1

	game_option_1.content.option_text = Localize(display_name)
	game_option_1.content.icon = display_image
	game_option_1.content.icon_frame = completed_frame_texture
	self._presentation_type = "weave_quickplay"
end

MissionVotingUI._set_adventure_presentation = function (self, arg_13_1)
	-- function 13
	local var_13_0 = DifficultySettings[arg_13_1]
	local display_name = var_13_0.display_name
	local display_image = var_13_0.display_image
	local completed_frame_texture = var_13_0.completed_frame_texture

	completed_frame_texture = completed_frame_texture or "map_frame_00"

	local game_option_1 = self._adventure_game_widgets_by_name.game_option_1

	game_option_1.content.option_text = Localize(display_name)
	game_option_1.content.icon = display_image
	game_option_1.content.icon_frame = completed_frame_texture
	self._presentation_type = "adventure"
end

MissionVotingUI._set_game_mode_presentation = function (self, arg_14_1)
	-- function 14
	self._game_mode_widgets_by_name.game_mode_text.content.text = Localize("vs_game_mode_title_" .. arg_14_1)
	self._presentation_type = "game_mode"
end

MissionVotingUI._set_switch_mechanism_presentation = function (self, arg_15_1)
	-- function 15
	local mechanism = arg_15_1.mechanism

	mechanism = mechanism or "adventure"

	local level_key = arg_15_1.level_key

	level_key = level_key or "inn_level"

	local var_15_2 = LevelSettings[level_key]
	local var_15_3 = MechanismSettings[mechanism]
	local vote_switch_mechanism_background = var_15_3.vote_switch_mechanism_background

	vote_switch_mechanism_background = vote_switch_mechanism_background or "icons_placeholder"

	local vote_switch_mechanism_text = var_15_3.vote_switch_mechanism_text

	vote_switch_mechanism_text = vote_switch_mechanism_text or "n/a"

	local _switch_mechanism_widgets_by_name = self._switch_mechanism_widgets_by_name

	_switch_mechanism_widgets_by_name.background.content.texture_id = vote_switch_mechanism_background
	_switch_mechanism_widgets_by_name.title.content.text = var_15_3.display_name
	_switch_mechanism_widgets_by_name.subtitle.content.text = var_15_2.display_name
	_switch_mechanism_widgets_by_name.description.content.text = vote_switch_mechanism_text

	local flag

	flag = self._active_mechanism ~= "deus" or not "morris_text_color" or "adventure_text_color"

	local text = _switch_mechanism_widgets_by_name.title.style.text

	Colors.copy_to(text.text_color, text[flag])

	local text_2 = _switch_mechanism_widgets_by_name.subtitle.style.text

	Colors.copy_to(text_2.text_color, text_2[flag])

	self._presentation_type = "switch_mechanism"
end

MissionVotingUI._set_custom_game_presentation = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	local var_16_0 = DifficultySettings[arg_16_1]
	local display_name = var_16_0.display_name
	local display_image = var_16_0.display_image
	local completed_frame_texture = var_16_0.completed_frame_texture

	completed_frame_texture = completed_frame_texture or "map_frame_00"

	local var_16_4 = LevelSettings[arg_16_2]
	local display_name_2 = var_16_4.display_name
	local level_image = var_16_4.level_image
	local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(self.statistics_db, self._stats_id, arg_16_2)

	completed_level_difficulty_index = completed_level_difficulty_index or 0

	local get_level_frame_by_difficulty_index = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_level_difficulty_index)
	local _custom_game_widgets_by_name = self._custom_game_widgets_by_name
	local game_option_1 = _custom_game_widgets_by_name.game_option_1

	game_option_1.content.option_text = Localize(display_name_2)

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(level_image)

	game_option_1.content.icon = level_image
	game_option_1.content.icon_frame = get_level_frame_by_difficulty_index

	local texture_size = game_option_1.style.icon.texture_size

	texture_size[1] = get_atlas_settings_by_texture_name.size[1]
	texture_size[2] = get_atlas_settings_by_texture_name.size[2]

	local game_option_2 = _custom_game_widgets_by_name.game_option_2

	game_option_2.content.option_text = Localize(display_name)
	game_option_2.content.icon = display_image
	game_option_2.content.icon_frame = completed_frame_texture
	_custom_game_widgets_by_name.additional_option.content.option_text = ""

	local private_button = _custom_game_widgets_by_name.private_button

	private_button.content.button_hotspot.disable_button = true
	private_button.content.button_hotspot.is_selected = arg_16_3
	private_button.style.hover_glow.color[1] = 0

	local host_button = _custom_game_widgets_by_name.host_button

	host_button.content.button_hotspot.disable_button = true
	host_button.content.button_hotspot.is_selected = arg_16_4
	host_button.style.hover_glow.color[1] = 0

	local strict_matchmaking_button = _custom_game_widgets_by_name.strict_matchmaking_button

	strict_matchmaking_button.content.button_hotspot.disable_button = true
	strict_matchmaking_button.content.button_hotspot.is_selected = arg_16_5
	strict_matchmaking_button.style.hover_glow.color[1] = 0
	self._presentation_type = "custom"
end

MissionVotingUI._set_deed_presentation = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local var_17_0 = ItemMasterList[arg_17_1]
	local tbl = {
		data = var_17_0,
		difficulty = arg_17_3,
		level_key = arg_17_2
	}

	self._deed_widgets_by_name.item_presentation.content.item = tbl
	self._presentation_type = "deed"
end

MissionVotingUI._set_event_game_presentation = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local var_18_0 = DifficultySettings[arg_18_1]
	local display_name = var_18_0.display_name
	local display_image = var_18_0.display_image
	local completed_frame_texture = var_18_0.completed_frame_texture

	completed_frame_texture = completed_frame_texture or "map_frame_00"

	local _event_game_widgets_by_name = self._event_game_widgets_by_name
	local game_option_1 = _event_game_widgets_by_name.game_option_1

	game_option_1.content.option_text = Localize(display_name)
	game_option_1.content.icon = display_image
	game_option_1.content.icon_frame = completed_frame_texture
	_event_game_widgets_by_name.event_summary.content.item = {
		level_key = arg_18_2,
		mutators = arg_18_3
	}
	self._presentation_type = "event"
end

MissionVotingUI._set_weave_presentation = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local num = 1
	local var_19_1 = arg_19_2
	local var_19_2 = WeaveSettings.templates[var_19_1]
	local level_id = var_19_2.objectives[num].level_id
	local _weave_game_widgets_by_name = self._weave_game_widgets_by_name
	local game_option_1 = _weave_game_widgets_by_name.game_option_1
	local find = table.find(WeaveSettings.templates_ordered, var_19_2)
	local wind = var_19_2.wind
	local var_19_8 = WindSettings[wind]
	local var_19_9 = LevelSettings[level_id]
	local level_image = var_19_9.level_image
	local completed_frame_texture = DifficultySettings[arg_19_1].completed_frame_texture
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(level_image)

	game_option_1.content.icon = level_image

	local texture_size = game_option_1.style.icon.texture_size

	texture_size[1] = get_atlas_settings_by_texture_name.size[1] * 0.8
	texture_size[2] = get_atlas_settings_by_texture_name.size[2] * 0.8
	game_option_1.content.title_text = find .. ". " .. Localize(var_19_2.display_name)

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(wind, 255)

	game_option_1.style.icon_frame.color = get_color_table_with_alpha

	local thumbnail_icon = var_19_8.thumbnail_icon
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(thumbnail_icon).size
	local wind_icon_glow = game_option_1.style.wind_icon_glow
	local texture_size_2 = wind_icon_glow.texture_size
	local offset = wind_icon_glow.offset
	local color = wind_icon_glow.color

	color[1] = 128
	color[2] = get_color_table_with_alpha[2]
	color[3] = get_color_table_with_alpha[3]
	color[4] = get_color_table_with_alpha[4]

	local wind_icon = game_option_1.style.wind_icon
	local texture_size_3 = wind_icon.texture_size
	local offset_2 = wind_icon.offset

	texture_size_3[1] = size[1] * 0.8
	texture_size_3[2] = size[2] * 0.8
	offset_2[1] = offset[1] - texture_size_2[1] / 2 + texture_size_3[1] / 2
	offset_2[2] = offset[2] + texture_size_2[2] / 2 - texture_size_3[2] / 2
	game_option_1.content.wind_icon = thumbnail_icon
	game_option_1.content.mission_name = Localize(var_19_9.display_name)
	game_option_1.content.wind_name = Localize(var_19_8.display_name)
	game_option_1.style.wind_name.text_color = get_color_table_with_alpha
	wind_icon.color = get_color_table_with_alpha

	local mutator = var_19_8.mutator
	local var_19_25 = MutatorTemplates[mutator]
	local mutator_icon = _weave_game_widgets_by_name.mutator_icon
	local mutator_title_text = _weave_game_widgets_by_name.mutator_title_text
	local mutator_description_text = _weave_game_widgets_by_name.mutator_description_text

	mutator_icon.content.texture_id = var_19_25.icon
	mutator_title_text.content.text = Localize(var_19_25.display_name)
	mutator_description_text.content.text = Localize(var_19_25.description)

	local objective_title = _weave_game_widgets_by_name.objective_title
	local objective_1 = _weave_game_widgets_by_name.objective_1
	local objective_2 = _weave_game_widgets_by_name.objective_2

	objective_title.content.text = "weave_objective_title"

	local objectives = var_19_2.objectives
	local num_2 = 10
	local num_3 = 0

	for i = 1, #objectives do
		local var_19_35 = objectives[i]
		local display_name = var_19_35.display_name
		local icon = var_19_35.icon

		self:_assign_objective(i, display_name, icon, num_2)
	end

	_weave_game_widgets_by_name.private_checkbox.content.button_hotspot.is_selected = arg_19_3
	self._presentation_type = "weave"
end

MissionVotingUI._assign_objective = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local var_20_0 = self._weave_game_widgets_by_name["objective_" .. arg_20_1]
	local content = var_20_0.content
	local style = var_20_0.style

	content.icon = arg_20_3 or "objective_icon_general"
	content.text = arg_20_2 or "-"
end

MissionVotingUI._set_deus_quickplay_presentation = function (self, arg_21_1)
	-- function 21
	local var_21_0 = DifficultySettings[arg_21_1]
	local display_name = var_21_0.display_name
	local display_image = var_21_0.display_image
	local completed_frame_texture = var_21_0.completed_frame_texture

	completed_frame_texture = completed_frame_texture or "map_frame_00"

	local game_option_1 = self._deus_quickplay_widgets_by_name.game_option_1

	game_option_1.content.option_text = Localize(display_name)
	game_option_1.content.icon = display_image
	game_option_1.content.icon_frame = completed_frame_texture
	self._presentation_type = "deus_quickplay"
end

MissionVotingUI._set_deus_weekly_expedition_presentation = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	-- function 22
	self._presentation_type = "deus_weekly"

	local _deus_weekly_event_widgets_by_name = self._deus_weekly_event_widgets_by_name
	local game_option_1 = _deus_weekly_event_widgets_by_name.game_option_1
	local content = game_option_1.content
	local var_22_3 = DeusJourneySettings[arg_22_2]
	local display_name = var_22_3.display_name
	local level_image = var_22_3.level_image
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(level_image)

	content.icon = level_image
	content.show_journey_border = true
	content.with_belakor = Managers.backend:get_interface("deus"):deus_journey_with_belakor(arg_22_2)

	local texture_size = game_option_1.style.icon.texture_size

	texture_size[1] = get_atlas_settings_by_texture_name.size[1]
	texture_size[2] = get_atlas_settings_by_texture_name.size[2]
	_deus_weekly_event_widgets_by_name.journey_name.content.text = display_name

	local var_22_8 = DeusThemeSettings[arg_22_6]

	content.theme_icon = var_22_8.icon

	local journey_theme = _deus_weekly_event_widgets_by_name.journey_theme

	journey_theme.content.text = var_22_8.journey_title
	journey_theme.content.icon = var_22_8.text_icon
	journey_theme.style.text.text_color = var_22_8.color
	journey_theme.style.icon.color = var_22_8.color

	local var_22_10 = DifficultySettings[arg_22_1]
	local display_name_2 = var_22_10.display_name
	local display_image = var_22_10.display_image

	game_option_1.content.difficulty_text = Localize(display_name_2)
	game_option_1.content.difficulty_icon = display_image

	local num = 10
	local num_2 = 0
	local _setup_curses = self:_setup_curses(arg_22_7, num, num_2)
	local _setup_boons = self:_setup_boons(arg_22_8, num, _setup_curses)
	local abs = math.abs(self.scenegraph_definition.game_option_deus_weekly.size[2] - math.abs(_setup_boons))

	if abs > 0 then
		local ui_scenegraph = self.ui_scenegraph
		local str = "game_option_deus_weekly_anchor"
		local str_2 = "scrollbar_window"
		local flag = true
		local var_22_22
		local var_22_23

		self._scrollbar_ui = ScrollbarUI:new(ui_scenegraph, str, str_2, abs, flag, var_22_22, var_22_23)
	end
end

local tbl = {}

MissionVotingUI._setup_curses = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local str = "curse"
	local var_23_1 = deus_weekly_event_create_header("cw_weekly_expedition_modifier_negative", arg_23_3, str)
	local var_23_2 = UIWidget.init(var_23_1)

	self._deus_weekly_event_widgets[#self._deus_weekly_event_widgets + 1] = var_23_2
	self._deus_weekly_event_widgets_by_name.curse_header = var_23_2
	arg_23_3 = arg_23_3 - 40 - arg_23_2

	local flag = arg_23_1 or tbl
	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	for i, v in ipairs(flag) do
		local var_23_5 = MutatorTemplates[v]
		local display_name = var_23_5.display_name
		local icon = var_23_5.icon
		local var_23_8 = Localize(var_23_5.description)
		local var_23_9 = deus_weekly_event_create_entry_widget(icon, display_name, var_23_8, arg_23_3, arg_23_2)
		local var_23_10 = UIWidget.init(var_23_9)

		self._deus_weekly_event_widgets[#self._deus_weekly_event_widgets + 1] = var_23_10
		self._deus_weekly_event_widgets_by_name["curse_" .. i] = var_23_10

		local desc = var_23_10.style.desc
		local var_23_12, var_23_13 = UIFontByResolution(desc)
		local var_23_14 = var_23_12[1]
		local var_23_15 = var_23_13
		local gui = self.ui_top_renderer.gui
		local var_23_17, var_23_18, var_23_19 = UIGetFontHeight(gui, desc.font_type, var_23_15)
		local num = (var_23_19 - var_23_18) * inv_scale
		local word_wrap, var_23_22 = UIRenderer.word_wrap(self.ui_top_renderer, var_23_8, var_23_14, var_23_15, desc.area_size[1])

		arg_23_3 = arg_23_3 - num * #word_wrap

		local title = var_23_10.style.title
		local var_23_24, var_23_25 = UIFontByResolution(title)
		local var_23_26 = var_23_24[1]
		local var_23_27 = var_23_25
		local var_23_28, var_23_29, var_23_30 = UIGetFontHeight(gui, title.font_type, var_23_27)
		local num_2 = (var_23_30 - var_23_29) * inv_scale
		local word_wrap_2, var_23_33 = UIRenderer.word_wrap(self.ui_top_renderer, Localize(display_name), var_23_26, var_23_27, title.area_size[1])

		arg_23_3 = arg_23_3 - num_2 * #word_wrap_2 - arg_23_2
	end

	return arg_23_3 - arg_23_2
end

MissionVotingUI._setup_boons = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local str = "boon"
	local var_24_1 = deus_weekly_event_create_header("cw_weekly_expedition_modifier_positive", arg_24_3, str)
	local var_24_2 = UIWidget.init(var_24_1)

	self._deus_weekly_event_widgets[#self._deus_weekly_event_widgets + 1] = var_24_2
	self._deus_weekly_event_widgets_by_name.boon_header = var_24_2
	arg_24_3 = arg_24_3 - 40 - arg_24_2

	local local_player = Managers.player:local_player()
	local profile_index = local_player:profile_index()
	local career_index = local_player:career_index()
	local flag = arg_24_1 or tbl
	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	for i, v in ipairs(flag) do
		local var_24_8 = DeusPowerUpsLookup[v]
		local display_name = var_24_8.display_name
		local get_power_up_icon = DeusPowerUpUtils.get_power_up_icon(var_24_8, profile_index, career_index)
		local get_power_up_description = DeusPowerUpUtils.get_power_up_description(var_24_8, profile_index, career_index)
		local var_24_12 = deus_weekly_event_create_entry_widget(get_power_up_icon, display_name, get_power_up_description, arg_24_3)
		local var_24_13 = UIWidget.init(var_24_12)

		self._deus_weekly_event_widgets[#self._deus_weekly_event_widgets + 1] = var_24_13
		self._deus_weekly_event_widgets_by_name["boon_" .. i] = var_24_13

		local desc = var_24_13.style.desc
		local var_24_15, var_24_16 = UIFontByResolution(desc)
		local var_24_17 = var_24_15[1]
		local var_24_18 = var_24_16
		local gui = self.ui_top_renderer.gui
		local var_24_20, var_24_21, var_24_22 = UIGetFontHeight(gui, desc.font_type, var_24_18)
		local num = (var_24_22 - var_24_21) * inv_scale
		local word_wrap, var_24_25 = UIRenderer.word_wrap(self.ui_top_renderer, get_power_up_description, var_24_17, var_24_18, desc.area_size[1])

		arg_24_3 = arg_24_3 - num * #word_wrap

		local title = var_24_13.style.title
		local var_24_27, var_24_28 = UIFontByResolution(title)
		local var_24_29 = var_24_27[1]
		local var_24_30 = var_24_28
		local var_24_31, var_24_32, var_24_33 = UIGetFontHeight(gui, title.font_type, var_24_30)
		local num_2 = (var_24_33 - var_24_32) * inv_scale
		local word_wrap_2, var_24_36 = UIRenderer.word_wrap(self.ui_top_renderer, Localize(display_name), var_24_29, var_24_30, title.area_size[1])

		arg_24_3 = arg_24_3 - num_2 * #word_wrap_2 - arg_24_2
	end

	return arg_24_3 - arg_24_2
end

MissionVotingUI._set_deus_custom_game_presentation = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
	-- function 25
	self._presentation_type = "deus_custom"

	local _deus_custom_widgets_by_name = self._deus_custom_widgets_by_name
	local game_option_1 = _deus_custom_widgets_by_name.game_option_1
	local content = game_option_1.content
	local var_25_3 = DeusJourneySettings[arg_25_2]
	local display_name = var_25_3.display_name
	local level_image = var_25_3.level_image

	if not LevelUnlockUtils.completed_journey_difficulty_index(self.statistics_db, self._stats_id, arg_25_2) then
		local num = 0
	end

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(level_image)

	content.icon = level_image
	content.show_journey_border = true
	content.with_belakor = Managers.backend:get_interface("deus"):deus_journey_with_belakor(arg_25_2)

	local texture_size = game_option_1.style.icon.texture_size

	texture_size[1] = get_atlas_settings_by_texture_name.size[1]
	texture_size[2] = get_atlas_settings_by_texture_name.size[2]
	_deus_custom_widgets_by_name.journey_name.content.text = display_name

	local var_25_9 = DeusThemeSettings[arg_25_6]

	content.theme_icon = var_25_9.icon

	local journey_theme = _deus_custom_widgets_by_name.journey_theme

	journey_theme.content.text = var_25_9.journey_title
	journey_theme.content.icon = var_25_9.text_icon
	journey_theme.style.text.text_color = var_25_9.color
	journey_theme.style.icon.color = var_25_9.color

	local var_25_11 = DifficultySettings[arg_25_1]
	local display_name_2 = var_25_11.display_name
	local display_image = var_25_11.display_image
	local game_option_2 = _deus_custom_widgets_by_name.game_option_2

	game_option_2.content.option_text = Localize(display_name_2)
	game_option_2.content.icon = display_image
	_deus_custom_widgets_by_name.additional_option.content.option_text = ""

	local private_button = _deus_custom_widgets_by_name.private_button

	private_button.content.button_hotspot.disable_button = true
	private_button.content.button_hotspot.is_selected = arg_25_3
	private_button.style.hover_glow.color[1] = 0

	local host_button = _deus_custom_widgets_by_name.host_button

	host_button.content.button_hotspot.disable_button = true
	host_button.content.button_hotspot.is_selected = arg_25_4
	host_button.style.hover_glow.color[1] = 0

	local strict_matchmaking_button = _deus_custom_widgets_by_name.strict_matchmaking_button

	strict_matchmaking_button.content.button_hotspot.disable_button = true
	strict_matchmaking_button.content.button_hotspot.is_selected = arg_25_5
	strict_matchmaking_button.style.hover_glow.color[1] = 0
end

MissionVotingUI._set_versus_quickplay_presentation = function (self, arg_26_1)
	-- function 26
	self._presentation_type = "versus_quickplay"
end

MissionVotingUI._set_versus_custom_game_presentation = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	-- function 27
	local _versus_custom_widgets_by_name = self._versus_custom_widgets_by_name
	local game_option_1 = _versus_custom_widgets_by_name.game_option_1
	local content = game_option_1.content
	local var_27_3
	local var_27_4
	local str_2

	if arg_27_2 == "any" then
		local str = "random_level"

		str_2 = "level_image_any"
	else
		local var_27_7 = LevelSettings[arg_27_2]
		local display_name = var_27_7.display_name

		str_2 = var_27_7.level_image
	end

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)

	content.icon = str_2

	local texture_size = game_option_1.style.icon.texture_size

	texture_size[1] = get_atlas_settings_by_texture_name.size[1]
	texture_size[2] = get_atlas_settings_by_texture_name.size[2]

	local var_27_11 = DifficultySettings[arg_27_1]
	local display_name_2 = var_27_11.display_name
	local display_image = var_27_11.display_image
	local game_option_2 = _versus_custom_widgets_by_name.game_option_2

	game_option_2.content.option_text = Localize(display_name_2)
	game_option_2.content.icon = display_image
	_versus_custom_widgets_by_name.additional_option.content.option_text = ""

	local player_hosted_button = _versus_custom_widgets_by_name.player_hosted_button

	player_hosted_button.content.button_hotspot.disable_button = true
	player_hosted_button.content.button_hotspot.is_selected = arg_27_3
	player_hosted_button.style.hover_glow.color[1] = 0

	local dedicated_server_win_button = _versus_custom_widgets_by_name.dedicated_server_win_button

	dedicated_server_win_button.content.button_hotspot.disable_button = true
	dedicated_server_win_button.content.button_hotspot.is_selected = arg_27_4
	dedicated_server_win_button.style.hover_glow.color[1] = 0

	local dedicated_server_aws_button = _versus_custom_widgets_by_name.dedicated_server_aws_button

	dedicated_server_aws_button.content.button_hotspot.disable_button = true
	dedicated_server_aws_button.content.button_hotspot.is_selected = arg_27_5
	dedicated_server_aws_button.style.hover_glow.color[1] = 0
	self._presentation_type = "versus_custom"
end

MissionVotingUI._update_vote_timer = function (self)
	-- function 28
	local voting_manager = self.voting_manager
	local duration = voting_manager:active_vote_template().duration
	local vote_time_left = voting_manager:vote_time_left()
	local max = math.max(vote_time_left / duration, 0)

	self:_set_vote_time_progress(max)
end

MissionVotingUI._set_vote_time_progress = function (self, arg_29_1)
	-- function 29
	local timer_fg = self:get_chrome_widgets().timer_fg
	local uvs = timer_fg.content.texture_id.uvs
	local scenegraph_id = timer_fg.scenegraph_id
	local size = self.scenegraph_definition[scenegraph_id].size

	self.ui_scenegraph[scenegraph_id].size[1] = size[1] * arg_29_1
	uvs[2][1] = arg_29_1
end

MissionVotingUI._update_animations = function (self, arg_30_1, arg_30_2)
	-- function 30
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_30_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end
end

MissionVotingUI.update = function (self, arg_31_1, arg_31_2)
	-- function 31
	local parent = self._parent:parent()
	local menu_active = parent.menu_active

	if not menu_active then
		menu_active = parent.current_view
		menu_active = menu_active or parent._transition_fade_data
	end

	self.menu_active = menu_active

	self:_update_animations(arg_31_1, arg_31_2)

	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()

	if not vote_in_progress then
		vote_in_progress = voting_manager:is_mission_vote()
		vote_in_progress = not vote_in_progress and not voting_manager:has_voted(Network.peer_id())
	end

	if not vote_in_progress then
		if not menu_active then
			if not self.vote_started then
				self:start_vote(voting_manager.active_voting)
			end

			self:_update_vote_timer()

			local get_chrome_widgets = self:get_chrome_widgets()

			UIWidgetUtils.animate_default_button(get_chrome_widgets.button_abort, arg_31_1)

			if not self.has_voted then
				local is_device_active = Managers.input:is_device_active("gamepad")
				local active_voting = voting_manager.active_voting
				local flag = not active_voting and active_voting.template

				if not flag then
					local get_service = self.input_manager:get_service("mission_voting")

					if not is_device_active and not flag.gamepad_support then
						local vote_options = flag.vote_options

						for i = 1, #vote_options do
							local var_31_10 = vote_options[i]

							if not get_service:get(var_31_10.gamepad_input) then
								voting_manager:vote(var_31_10.vote)
								self:on_vote_casted(vote_options.vote == 1)

								break
							end
						end
					elseif UIUtils.is_button_pressed(get_chrome_widgets.button_confirm) or not get_service:get("confirm_press") then
						voting_manager:vote(1)
						self:on_vote_casted(true)
					elseif UIUtils.is_button_pressed(get_chrome_widgets.button_abort) or not get_service:get("toggle_menu") then
						voting_manager:vote(2)
						self:on_vote_casted(false)
					elseif UIUtils.is_button_hover_enter(get_chrome_widgets.button_confirm) or not UIUtils.is_button_hover_enter(get_chrome_widgets.button_abort) then
						self:_play_sound("Play_hud_hover")
					end
				end

				if self.gamepad_active == is_device_active or not flag then
					local vote_options_2 = flag.vote_options

					self:setup_option_input(get_chrome_widgets.button_confirm, vote_options_2[1])
					self:setup_option_input(get_chrome_widgets.button_abort, vote_options_2[2])

					self.gamepad_active = is_device_active
				end
			end
		end
	elseif not self.vote_started then
		self:on_vote_ended()
	end

	if not (not self.vote_started and self.has_voted) then
		self:draw(arg_31_1, arg_31_2)
	end
end

MissionVotingUI.draw = function (self, arg_32_1, arg_32_2)
	-- function 32
	self:_update_pulse_animations(arg_32_1)

	local ui_top_renderer = self.ui_top_renderer
	local render_settings = self.render_settings
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("mission_voting")
	local num = 1

	render_settings.alpha_multiplier = num
	ui_scenegraph.window.local_position[2] = -50 + num * 50

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_32_1, nil, render_settings)

	local snap_pixel_positions = render_settings.snap_pixel_positions
	local get_chrome_widgets, var_32_7 = self:get_chrome_widgets()

	for i = 1, #var_32_7 do
		local var_32_8 = var_32_7[i]

		if var_32_8.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = var_32_8.snap_pixel_positions
		end

		UIRenderer.draw_widget(ui_top_renderer, var_32_8)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	if not ((self._twitch_mode_enabled or Managers.twitch:is_connecting() or not Managers.twitch:is_connected()) and Managers.twitch:game_mode_supported(self._matchmaking_type, self._difficulty)) then
		local twitch_disclaimer = self._twitch_widgets_by_name.twitch_disclaimer

		UIRenderer.draw_widget(ui_top_renderer, twitch_disclaimer)
	elseif not self._twitch_mode_enabled then
		local twitch_mode = self._twitch_widgets_by_name.twitch_mode

		UIRenderer.draw_widget(ui_top_renderer, twitch_mode)
	end

	local _presentation_type = self._presentation_type

	if not _presentation_type then
		if _presentation_type == "adventure" then
			local _adventure_game_widgets = self._adventure_game_widgets

			for j = 1, #_adventure_game_widgets do
				local var_32_13 = _adventure_game_widgets[j]

				if var_32_13.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_13.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_13)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "custom" then
			local _custom_game_widgets = self._custom_game_widgets

			for k = 1, #_custom_game_widgets do
				local var_32_15 = _custom_game_widgets[k]

				if var_32_15.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_15.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_15)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "deed" then
			local _deed_widgets = self._deed_widgets

			for l = 1, #_deed_widgets do
				local var_32_17 = _deed_widgets[l]

				if var_32_17.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_17.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_17)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "event" then
			local _event_game_widgets = self._event_game_widgets

			for i4 = 1, #_event_game_widgets do
				local var_32_19 = _event_game_widgets[i4]

				if var_32_19.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_19.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_19)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "weave" then
			local _weave_game_widgets = self._weave_game_widgets

			for i5 = 1, #_weave_game_widgets do
				local var_32_21 = _weave_game_widgets[i5]

				if var_32_21.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_21.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_21)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "weave_quickplay" then
			local _weave_quickplay_widgets = self._weave_quickplay_widgets

			for i6 = 1, #_weave_quickplay_widgets do
				local var_32_23 = _weave_quickplay_widgets[i6]

				if var_32_23.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_23.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_23)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "deus_quickplay" then
			local _deus_quickplay_widgets = self._deus_quickplay_widgets

			for i7 = 1, #_deus_quickplay_widgets do
				local var_32_25 = _deus_quickplay_widgets[i7]

				if var_32_25.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_25.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_25)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "deus_custom" then
			local _deus_custom_widgets = self._deus_custom_widgets

			for i8 = 1, #_deus_custom_widgets do
				local var_32_27 = _deus_custom_widgets[i8]

				if var_32_27.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_27.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_27)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "game_mode" then
			local _game_mode_widgets = self._game_mode_widgets

			for i9 = 1, #_game_mode_widgets do
				local var_32_29 = _game_mode_widgets[i9]

				if var_32_29.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_29.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_29)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "switch_mechanism" then
			local _switch_mechanism_widgets = self._switch_mechanism_widgets

			for i10 = 1, #_switch_mechanism_widgets do
				local var_32_31 = _switch_mechanism_widgets[i10]

				if var_32_31.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_31.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_31)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "versus_quickplay" then
			local _versus_quickplay_widgets = self._versus_quickplay_widgets

			for i11 = 1, #_versus_quickplay_widgets do
				local var_32_33 = _versus_quickplay_widgets[i11]

				if var_32_33.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_33.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_33)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "versus_custom" then
			local _versus_custom_widgets = self._versus_custom_widgets

			for i12 = 1, #_versus_custom_widgets do
				local var_32_35 = _versus_custom_widgets[i12]

				if var_32_35.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_35.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_35)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		elseif _presentation_type == "deus_weekly" then
			local _deus_weekly_event_widgets = self._deus_weekly_event_widgets

			for i13 = 1, #_deus_weekly_event_widgets do
				local var_32_37 = _deus_weekly_event_widgets[i13]

				if var_32_37.snap_pixel_positions ~= nil then
					render_settings.snap_pixel_positions = var_32_37.snap_pixel_positions
				end

				UIRenderer.draw_widget(ui_top_renderer, var_32_37)

				render_settings.snap_pixel_positions = snap_pixel_positions
			end
		end
	end

	UIRenderer.end_pass(ui_top_renderer)

	if not self.input_manager:is_device_active("gamepad") then
		self._menu_input_description:draw(ui_top_renderer, arg_32_1)
	end

	if not self._scrollbar_ui then
		self._scrollbar_ui:update(arg_32_1, arg_32_2, ui_top_renderer, get_service, render_settings)
	end
end

MissionVotingUI._update_pulse_animations = function (self, arg_33_1)
	-- function 33
	if not self.has_voted then
		return
	end

	local menu_active = self.menu_active

	if not menu_active then
		local flag

		flag = not menu_active and 5 and 8

		local flag_2

		flag_2 = not menu_active and 0 and 0.5 + math.sin(Managers.time:time("ui") * flag) * 0.5

		local num = 100 + flag_2 * 155
		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.timer_fg.style.texture_id.color[1] = num
		_widgets_by_name.timer_glow.style.texture_id.color[1] = num
	end
end

MissionVotingUI._acquire_input = function (self, arg_34_1)
	-- function 34
	self:_release_input(true)
	self.input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "mission_voting", "MissionVotingUI")

	if not arg_34_1 then
		ShowCursorStack.show("MissionVotingUI")
	end
end

MissionVotingUI._release_input = function (self, arg_35_1)
	-- function 35
	self.input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "mission_voting", "MissionVotingUI")

	if not arg_35_1 then
		ShowCursorStack.hide("MissionVotingUI")
	end
end

MissionVotingUI.active_input_service = function (self)
	-- function 36
	local input_manager = self.input_manager
	local str = "mission_voting"

	return (input_manager:get_service(str))
end

MissionVotingUI._play_sound = function (self, arg_37_1)
	-- function 37
	WwiseWorld.trigger_event(self.wwise_world, arg_37_1)
end
