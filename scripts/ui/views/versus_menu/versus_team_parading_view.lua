-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view.lua

local definitions = local_require("scripts/ui/views/versus_menu/versus_team_parading_view_definitions")

require("scripts/ui/views/world_hero_previewer")
require("scripts/ui/views/team_previewer")

local DO_RELOAD = false
local DIORAMA_SIZE = definitions.DIORAMA_SIZE

VersusTeamParadingView = class(VersusTeamParadingView, BaseView)

VersusTeamParadingView.init = function (self, ingame_ui_context)
	-- function 1
	self.normal_chat = true

	local player = ingame_ui_context.player

	self._player = player
	self._peer_id = player:network_id()
	self._local_player_id = player:local_player_id()
	self._render_settings = {}
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ingame_ui = ingame_ui_context.ingame_ui
	self._is_server = ingame_ui_context.is_server
	self._ingame_ui_context = ingame_ui_context
	self._network_handler = not not ingame_ui_context.network_server

	self.super.init(self, ingame_ui_context, definitions)
end

VersusTeamParadingView.on_enter = function (self, params)
	-- function 2
	self.super.on_enter(self)

	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()
	local game_mode_state = game_mode:game_mode_state()

	if self._game_mode_state ~= game_mode_state then
		local player = Managers.player:local_player()
		local party = Managers.party:get_party_from_unique_id(player:unique_id())

		self:_initialize_timers()

		local hero_party = Managers.state.side:get_party_from_side_name("heroes")

		self:_present_team(hero_party.party_id)
	end

	local game_mode_round_id = game_mode:round_id()

	if game_mode_round_id == 1 then
		self:_set_round_text(Localize("vs_objective_round_one"))
		self:play_sound("versus_round_start")
	else
		self:_set_round_text(Localize("vs_objective_final_round"))
		self:play_sound("versus_round_start_final")
	end

	local optional_params

	self:_start_animation("start", "start", self._widgets_by_name, optional_params)
	self:play_sound("menu_versus_character_selection_round_start_team_parade")
	Managers.state.event:register(self, "player_party_changed", "on_player_party_changed")
end

VersusTeamParadingView._create_diorama = function (self, position)
	-- function 3
	local horizontal_alignment = "left"
	local vertical_alignment = "bottom"
	local settings = {
		horizontal_alignment = horizontal_alignment,
		vertical_alignment = vertical_alignment,
		position = position,
		size = DIORAMA_SIZE
	}

	return HeroDioramaUI:new(self._ingame_ui_context, settings)
end

VersusTeamParadingView._set_round_text = function (self, text)
	-- function 4
	local widget = self._widgets_by_name.round_title

	widget.content.text = text
end

VersusTeamParadingView.get_loadout = function (self, slot_data, use_dark_pact_profile, profile_index, career_index, profile, career_name)
	-- function 5
	local backend_items = Managers.backend:get_interface("items")
	local melee_name, ranged_name, skin_name, hat_name
	local slot_melee = slot_data.slot_melee

	if use_dark_pact_profile or not slot_melee then
		local loadout = backend_items:get_loadout()
		local current_loadout = loadout[career_name]
		local melee_id = current_loadout.slot_melee
		local ranged_id = current_loadout.slot_ranged
		local hat_id = current_loadout.slot_hat

		melee_name = not not melee_id and not not backend_items:get_item_name(current_loadout.slot_melee)
		ranged_name = not not ranged_id and not not backend_items:get_item_name(current_loadout.slot_ranged)
		skin_name = backend_items:get_item_name(current_loadout.slot_skin)
		hat_name = not not hat_id and not not backend_items:get_item_name(hat_id)
	else
		melee_name = slot_melee
		ranged_name = slot_data.slot_ranged
		skin_name = slot_data.slot_skin
		hat_name = slot_data.slot_hat
	end

	local weapons = {}

	if melee_name ~= "n/a" then
		weapons[#weapons + 1] = melee_name
	end

	if ranged_name ~= "n/a" then
		weapons[#weapons + 1] = ranged_name
	end

	fassert(#weapons > 0, "Character must have at least one weapon equipped")

	local weapon_name = weapons[math.random(1, #weapons)]
	local weapon_data = ItemMasterList[weapon_name]
	local weapon_slot = weapon_data.slot_type
	local preview_animation = backend_items:get_item_template(weapon_data).wield_anim
	local preview_items = {
		{
			item_name = weapon_name
		}
	}

	if hat_name then
		preview_items[#preview_items + 1] = {
			item_name = hat_name
		}
	end

	return {
		profile_index = profile_index,
		career_index = career_index,
		hero_name = profile.display_name,
		skin_name = skin_name,
		weapon_slot = weapon_slot,
		preview_items = preview_items,
		preview_animation = preview_animation,
		career_name = career_name
	}
end

VersusTeamParadingView._initialize_timers = function (self)
	-- function 6
	self._screen_timer = not not Managers.state.game_mode:setting("character_picking_settings").parading_duration
	self._screen_timer_ended = nil
end

VersusTeamParadingView._present_team = function (self, party_id)
	-- function 7
	local parade_dark_pact = Managers.state.game_mode:setting("parade_dark_pact")
	local party = Managers.party:get_party(party_id)
	local slots_data = party.slots_data
	local side = Managers.state.side.side_by_party[party]
	local available_profiles = side.available_profiles
	local use_dark_pact_profile = not not parade_dark_pact and side:name() == "dark_pact"
	local team_name_text_widget = self._widgets_by_name.team_name_text

	team_name_text_widget = "Your Team"

	local hero_data = {}
	local diorama_list = {}

	for i = 1, #slots_data do
		local status = party.slots[i]
		local slot_data = slots_data[i]
		local career_index = not not status.career_index
		local profile_index = status.profile_index

		profile_index = profile_index and (profile_index > 0 and (not not profile_index or not not 1) or not (profile_index > 0) and not not 1) or not profile_index and not not 1

		local profile = SPProfiles[profile_index]
		local career = profile.careers[career_index]
		local loadout_data = self:get_loadout(slot_data, use_dark_pact_profile, profile_index, career_index, profile, career.name)
		local player_slot_scenegraph_id = "player_" .. i
		local player_slot_scenegraph = self._ui_scenegraph[player_slot_scenegraph_id]
		local position = player_slot_scenegraph.world_position
		local diorama = self:_create_diorama(position)

		diorama:set_hero_profile(profile_index, career_index)
		diorama:set_viewport_active(false)
		diorama:fade_out(0)

		local player_name

		if status.peer_id then
			local player = Managers.player:player(status.peer_id, status.local_player_id)

			player_name = player and (not not player:name() or not not ("Bot-" .. i)) or not player and not not ("Bot-" .. i)
		else
			player_name = Localize(loadout_data.hero_name)
		end

		diorama:set_player_name(player_name)

		diorama_list[i] = diorama
	end

	self._diorama_list = diorama_list
	self._animation_params = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings,
		diorama_list = self._diorama_list
	}

	self:_start_animation("start", "start", self._widgets_by_name, self._animation_params)
end

VersusTeamParadingView._destroy_diorama_list = function (self)
	-- function 8
	local diorama_list = self._diorama_list

	if diorama_list then
		for i = 1, #diorama_list do
			local diorama = diorama_list[i]

			diorama:destroy()
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

VersusTeamParadingView._draw_widgets = function (self, ui_renderer, dt)
	-- function 11
	return
end

VersusTeamParadingView.post_update = function (self, dt, t)
	-- function 12
	if DO_RELOAD then
		DO_RELOAD = false

		self:_destroy_diorama_list()
		self:_initialize_timers()
		self:_present_team(1)
	end

	local diorama_list = self._diorama_list

	if diorama_list then
		for i = 1, #diorama_list do
			local diorama = diorama_list[i]

			diorama:post_update(dt, t)
		end
	end
end

VersusTeamParadingView._update_screen_timer = function (self, widget, screen_timer)
	-- function 13
	local value = math.clamp(screen_timer, 0, 999999)
	local time_text

	time_text = value <= 0 and (not not "" or not not string.format("%.0f", value)) or not (value <= 0) and not not string.format("%.0f", value)
	widget.content.text = time_text
end

VersusTeamParadingView._animate_font_size_bounce = function (self, dt, t)
	-- function 14
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.screen_timer_text_big
	local content = widget.content
	local style = widget.style
	local text = content.text
	local text_style = style.text
	local text_shadow_style = style.text_shadow
	local default_font_size = text_style.default_font_size
	local max_font_size = text_style.max_font_size
	local screen_timer = self._screen_timer
	local progress = 1 - (screen_timer + 0.5) % 1
	local timer_ended = self._screen_timer_ended
	local new_font_size = default_font_size + (max_font_size - default_font_size) * progress

	text_style.font_size = new_font_size
	text_shadow_style.font_size = new_font_size

	local previous_alpha = text_style.text_color[1]
	local alpha = timer_ended and not not 0 or not timer_ended and not not (15 * (1 - progress))

	self:_set_text_widget_alpha(widget, alpha)

	if timer_ended then
		self:_set_text_widget_alpha(widgets_by_name.screen_timer_text, 0)
	end
end

VersusTeamParadingView._set_text_widget_alpha = function (self, widget, alpha)
	-- function 15
	local style = widget.style
	local text_style = style.text
	local text_shadow_style = style.text_shadow

	text_style.text_color[1] = alpha
	text_shadow_style.text_color[1] = alpha
end

VersusTeamParadingView.update = function (self, dt, t)
	-- function 16
	if DO_RELOAD then
		self.super.debug_set_definitions(self, definitions)
	end

	local diorama_list = self._diorama_list

	if diorama_list then
		for i = 1, #diorama_list do
			local diorama = diorama_list[i]

			diorama:update(dt, t)
		end
	end

	self:_handle_input(dt, t)

	local previous_time = self._screen_timer

	self._screen_timer = self._screen_timer - dt

	if self._screen_timer <= 0 and not self._screen_timer_ended then
		self._screen_timer_ended = true
	end

	local play_sound = self._screen_timer > 0 and not not previous_time and math.round(previous_time) ~= math.round(self._screen_timer)

	if play_sound then
		if self._screen_timer < 1 then
			self:play_sound("menu_wind_countdown_warning")
		elseif self._screen_timer < 4 then
			self:play_sound("menu_wind_countdown_count_big")
		elseif self._screen_timer < 8 then
			self:play_sound("menu_wind_countdown_count_small")
		end
	end

	self:_animate_font_size_bounce(dt, t)
	self:_update_screen_timer(self._widgets_by_name.screen_timer_text, self._screen_timer)
	self:_update_screen_timer(self._widgets_by_name.screen_timer_text_big, self._screen_timer)
	self.super.update(self, dt, t)
end

VersusTeamParadingView.destroy = function (self)
	-- function 17
	if not Managers.chat:chat_is_focused() then
		local input_manager = Managers.input

		input_manager:device_unblock_all_services("keyboard")
		input_manager:device_unblock_all_services("mouse")
		input_manager:device_unblock_all_services("gamepad")
	end

	Managers.state.event:unregister("on_player_party_changed", self)
end

VersusTeamParadingView._handle_input = function (self, dt, t)
	-- function 18
	return
end

VersusTeamParadingView.on_player_party_changed = function (self, player, is_local_player, old_party_id, new_party_id)
	-- function 19
	if not is_local_player then
		return
	end

	if Managers.mechanism:get_state() == "inn" then
		self:_present_team(new_party_id)
	end
end
