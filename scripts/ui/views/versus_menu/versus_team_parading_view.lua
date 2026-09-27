-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view.lua

local var_0_0 = local_require("scripts/ui/views/versus_menu/versus_team_parading_view_definitions")

require("scripts/ui/views/world_hero_previewer")
require("scripts/ui/views/team_previewer")

local flag = false
local DIORAMA_SIZE = var_0_0.DIORAMA_SIZE

VersusTeamParadingView = class(VersusTeamParadingView, BaseView)

VersusTeamParadingView.init = function (self, arg_1_1)
	-- function 1
	self.normal_chat = true

	local player = arg_1_1.player

	self._player = player
	self._peer_id = player:network_id()
	self._local_player_id = player:local_player_id()
	self._render_settings = {}
	self._ui_renderer = arg_1_1.ui_renderer
	self._ingame_ui = arg_1_1.ingame_ui
	self._is_server = arg_1_1.is_server
	self._ingame_ui_context = arg_1_1

	local network_server = arg_1_1.network_server

	network_server = network_server or arg_1_1.network_client
	self._network_handler = network_server

	self.super.init(self, arg_1_1, var_0_0)
end

VersusTeamParadingView.on_enter = function (self, arg_2_1)
	-- function 2
	self.super.on_enter(self)

	local game_mode = Managers.state.game_mode:game_mode()
	local game_mode_state = game_mode:game_mode_state()

	if self._game_mode_state ~= game_mode_state then
		local local_player = Managers.player:local_player()
		local get_party_from_unique_id = Managers.party:get_party_from_unique_id(local_player:unique_id())

		self:_initialize_timers()

		local get_party_from_side_name = Managers.state.side:get_party_from_side_name("heroes")

		self:_present_team(get_party_from_side_name.party_id)
	end

	if game_mode:round_id() == 1 then
		self:_set_round_text(Localize("vs_objective_round_one"))
		self:play_sound("versus_round_start")
	else
		self:_set_round_text(Localize("vs_objective_final_round"))
		self:play_sound("versus_round_start_final")
	end

	local var_2_5

	self:_start_animation("start", "start", self._widgets_by_name, var_2_5)
	self:play_sound("menu_versus_character_selection_round_start_team_parade")
	Managers.state.event:register(self, "player_party_changed", "on_player_party_changed")
end

VersusTeamParadingView._create_diorama = function (self, arg_3_1)
	-- function 3
	local str = "left"
	local str_2 = "bottom"
	local tbl = {
		horizontal_alignment = str,
		vertical_alignment = str_2,
		position = arg_3_1,
		size = DIORAMA_SIZE
	}

	return HeroDioramaUI:new(self._ingame_ui_context, tbl)
end

VersusTeamParadingView._set_round_text = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0._widgets_by_name.round_title.content.text = arg_4_1
end

VersusTeamParadingView.get_loadout = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	local get_interface = Managers.backend:get_interface("items")
	local var_5_1
	local var_5_2
	local var_5_3
	local var_5_4
	local slot_melee = arg_5_1.slot_melee

	if not (arg_5_2 or slot_melee) then
		local var_5_6 = get_interface:get_loadout()[arg_5_6]
		local slot_melee_2 = var_5_6.slot_melee
		local slot_ranged = var_5_6.slot_ranged
		local slot_hat = var_5_6.slot_hat

		var_5_1 = not slot_melee_2 and get_interface:get_item_name(var_5_6.slot_melee)
		var_5_2 = not slot_ranged and get_interface:get_item_name(var_5_6.slot_ranged)
		var_5_3 = get_interface:get_item_name(var_5_6.slot_skin)
		var_5_4 = not slot_hat and get_interface:get_item_name(slot_hat)
	else
		var_5_1 = slot_melee
		var_5_2 = arg_5_1.slot_ranged
		var_5_3 = arg_5_1.slot_skin
		var_5_4 = arg_5_1.slot_hat
	end

	local tbl = {}

	if var_5_1 ~= "n/a" then
		tbl[#tbl + 1] = var_5_1
	end

	if var_5_2 ~= "n/a" then
		tbl[#tbl + 1] = var_5_2
	end

	fassert(#tbl > 0, "Character must have at least one weapon equipped")

	local var_5_11 = tbl[math.random(1, #tbl)]
	local var_5_12 = ItemMasterList[var_5_11]
	local slot_type = var_5_12.slot_type
	local wield_anim = get_interface:get_item_template(var_5_12).wield_anim
	local tbl_2 = {
		{
			item_name = var_5_11
		}
	}

	if not var_5_4 then
		tbl_2[#tbl_2 + 1] = {
			item_name = var_5_4
		}
	end

	return {
		profile_index = arg_5_3,
		career_index = arg_5_4,
		hero_name = arg_5_5.display_name,
		skin_name = var_5_3,
		weapon_slot = slot_type,
		preview_items = tbl_2,
		preview_animation = wield_anim,
		career_name = arg_5_6
	}
end

VersusTeamParadingView._initialize_timers = function (self)
	-- function 6
	local parading_duration = Managers.state.game_mode:setting("character_picking_settings").parading_duration

	parading_duration = parading_duration or 1
	self._screen_timer = parading_duration
	self._screen_timer_ended = nil
end

VersusTeamParadingView._present_team = function (self, arg_7_1)
	-- function 7
	local setting = Managers.state.game_mode:setting("parade_dark_pact")
	local get_party = Managers.party:get_party(arg_7_1)
	local slots_data = get_party.slots_data
	local var_7_3 = Managers.state.side.side_by_party[get_party]
	local available_profiles = var_7_3.available_profiles
	local flag = not setting and var_7_3:name() == "dark_pact"
	local team_name_text = self._widgets_by_name.team_name_text
	local str = "Your Team"
	local tbl = {}
	local tbl_2 = {}

	for i = 1, #slots_data do
		local var_7_10 = get_party.slots[i]
		local var_7_11 = slots_data[i]
		local career_index = var_7_10.career_index

		career_index = career_index or 1

		local profile_index = var_7_10.profile_index

		profile_index = not profile_index and profile_index > 0 and profile_index and 1

		local var_7_14 = SPProfiles[profile_index]
		local var_7_15 = var_7_14.careers[career_index]
		local get_loadout = self:get_loadout(var_7_11, flag, profile_index, career_index, var_7_14, var_7_15.name)
		local str_2 = "player_" .. i
		local world_position = self._ui_scenegraph[str_2].world_position
		local _create_diorama = self:_create_diorama(world_position)

		_create_diorama:set_hero_profile(profile_index, career_index)
		_create_diorama:set_viewport_active(false)
		_create_diorama:fade_out(0)

		local var_7_20

		if not var_7_10.peer_id then
			local player = Managers.player:player(var_7_10.peer_id, var_7_10.local_player_id)

			var_7_20 = not player and player:name() and "Bot-" .. i
		else
			var_7_20 = Localize(get_loadout.hero_name)
		end

		_create_diorama:set_player_name(var_7_20)

		tbl_2[i] = _create_diorama
	end

	self._diorama_list = tbl_2
	self._animation_params = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings,
		diorama_list = self._diorama_list
	}

	self:_start_animation("start", "start", self._widgets_by_name, self._animation_params)
end

VersusTeamParadingView._destroy_diorama_list = function (self)
	-- function 8
	local _diorama_list = self._diorama_list

	if not _diorama_list then
		for i = 1, #_diorama_list do
			_diorama_list[i]:destroy()
		end
	end

	self._diorama_list = nil
end

VersusTeamParadingView.on_exit = function (self)
	-- function 9
	self.super.on_exit(self)
	Managers.transition:fade_out(1.5)
	Managers.state.event:unregister("on_player_party_changed", self)
end

VersusTeamParadingView.post_update_on_exit = function (self)
	-- function 10
	self.super.post_update_on_exit(self)
	self:_destroy_diorama_list()
end

VersusTeamParadingView._draw_widgets = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	return
end

VersusTeamParadingView.post_update = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not flag then
		flag = false

		self:_destroy_diorama_list()
		self:_initialize_timers()
		self:_present_team(1)
	end

	local _diorama_list = self._diorama_list

	if not _diorama_list then
		for i = 1, #_diorama_list do
			_diorama_list[i]:post_update(arg_12_1, arg_12_2)
		end
	end
end

VersusTeamParadingView._update_screen_timer = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local clamp = math.clamp(arg_13_2, 0, 999999)
	local var_13_1
	local flag

	flag = not (clamp <= 0) or not "" or string.format("%.0f", clamp)
	arg_13_1.content.text = flag
end

VersusTeamParadingView._animate_font_size_bounce = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _widgets_by_name = self._widgets_by_name
	local screen_timer_text_big = _widgets_by_name.screen_timer_text_big
	local content = screen_timer_text_big.content
	local style = screen_timer_text_big.style
	local text = content.text
	local text_2 = style.text
	local text_shadow = style.text_shadow
	local default_font_size = text_2.default_font_size
	local max_font_size = text_2.max_font_size
	local num = 1 - (self._screen_timer + 0.5) % 1
	local _screen_timer_ended = self._screen_timer_ended
	local num_2 = default_font_size + (max_font_size - default_font_size) * num

	text_2.font_size = num_2
	text_shadow.font_size = num_2

	local var_14_12 = text_2.text_color[1]
	local flag

	flag = not _screen_timer_ended and 0 and 15 * (1 - num)

	self:_set_text_widget_alpha(screen_timer_text_big, flag)

	if not _screen_timer_ended then
		self:_set_text_widget_alpha(_widgets_by_name.screen_timer_text, 0)
	end
end

VersusTeamParadingView._set_text_widget_alpha = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local style = arg_15_1.style
	local text = style.text
	local text_shadow = style.text_shadow

	text.text_color[1] = arg_15_2
	text_shadow.text_color[1] = arg_15_2
end

VersusTeamParadingView.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not flag then
		self.super.debug_set_definitions(self, var_0_0)
	end

	local _diorama_list = self._diorama_list

	if not _diorama_list then
		for i = 1, #_diorama_list do
			_diorama_list[i]:update(arg_16_1, arg_16_2)
		end
	end

	self:_handle_input(arg_16_1, arg_16_2)

	local _screen_timer = self._screen_timer

	self._screen_timer = self._screen_timer - arg_16_1

	if not (not (self._screen_timer <= 0) or self._screen_timer_ended) then
		self._screen_timer_ended = true
	end

	if not ((not (self._screen_timer > 0) or not _screen_timer) and math.round(_screen_timer) ~= math.round(self._screen_timer)) then
		if self._screen_timer < 1 then
			self:play_sound("menu_wind_countdown_warning")
		elseif self._screen_timer < 4 then
			self:play_sound("menu_wind_countdown_count_big")
		elseif self._screen_timer < 8 then
			self:play_sound("menu_wind_countdown_count_small")
		end
	end

	self:_animate_font_size_bounce(arg_16_1, arg_16_2)
	self:_update_screen_timer(self._widgets_by_name.screen_timer_text, self._screen_timer)
	self:_update_screen_timer(self._widgets_by_name.screen_timer_text_big, self._screen_timer)
	self.super.update(self, arg_16_1, arg_16_2)
end

VersusTeamParadingView.destroy = function (arg_17_0)
	-- function 17
	if not Managers.chat:chat_is_focused() then
		local input = Managers.input

		input:device_unblock_all_services("keyboard")
		input:device_unblock_all_services("mouse")
		input:device_unblock_all_services("gamepad")
	end

	Managers.state.event:unregister("on_player_party_changed", arg_17_0)
end

VersusTeamParadingView._handle_input = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	return
end

VersusTeamParadingView.on_player_party_changed = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	if not arg_19_2 then
		return
	end

	if Managers.mechanism:get_state() == "inn" then
		self:_present_team(arg_19_4)
	end
end
