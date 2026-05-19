-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view.lua

local var_0_0 = local_require("scripts/ui/views/versus_menu/versus_team_parading_view_definitions")

require("scripts/ui/views/world_hero_previewer")
require("scripts/ui/views/team_previewer")

local var_0_1 = false
local var_0_2 = var_0_0.DIORAMA_SIZE

VersusTeamParadingView = class(VersusTeamParadingView, BaseView)

function VersusTeamParadingView.init(arg_1_0, arg_1_1)
	arg_1_0.normal_chat = true

	local var_1_0 = arg_1_1.player

	arg_1_0._player = var_1_0
	arg_1_0._peer_id = var_1_0:network_id()
	arg_1_0._local_player_id = var_1_0:local_player_id()
	arg_1_0._render_settings = {}
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._network_handler = arg_1_1.network_server or arg_1_1.network_client

	arg_1_0.super.init(arg_1_0, arg_1_1, var_0_0)
end

function VersusTeamParadingView.on_enter(arg_2_0, arg_2_1)
	arg_2_0.super.on_enter(arg_2_0)

	local var_2_0 = Managers.state.game_mode:game_mode()
	local var_2_1 = var_2_0:game_mode_state()

	if arg_2_0._game_mode_state ~= var_2_1 then
		local var_2_2 = Managers.player:local_player()
		local var_2_3 = Managers.party:get_party_from_unique_id(var_2_2:unique_id())

		arg_2_0:_initialize_timers()

		local var_2_4 = Managers.state.side:get_party_from_side_name("heroes")

		arg_2_0:_present_team(var_2_4.party_id)
	end

	if var_2_0:round_id() == 1 then
		arg_2_0:_set_round_text(Localize("vs_objective_round_one"))
		arg_2_0:play_sound("versus_round_start")
	else
		arg_2_0:_set_round_text(Localize("vs_objective_final_round"))
		arg_2_0:play_sound("versus_round_start_final")
	end

	local var_2_5

	arg_2_0:_start_animation("start", "start", arg_2_0._widgets_by_name, var_2_5)
	arg_2_0:play_sound("menu_versus_character_selection_round_start_team_parade")
	Managers.state.event:register(arg_2_0, "player_party_changed", "on_player_party_changed")
end

function VersusTeamParadingView._create_diorama(arg_3_0, arg_3_1)
	local var_3_0 = "left"
	local var_3_1 = "bottom"
	local var_3_2 = {
		horizontal_alignment = var_3_0,
		vertical_alignment = var_3_1,
		position = arg_3_1,
		size = var_0_2
	}

	return HeroDioramaUI:new(arg_3_0._ingame_ui_context, var_3_2)
end

function VersusTeamParadingView._set_round_text(arg_4_0, arg_4_1)
	arg_4_0._widgets_by_name.round_title.content.text = arg_4_1
end

function VersusTeamParadingView.get_loadout(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	local var_5_0 = Managers.backend:get_interface("items")
	local var_5_1
	local var_5_2
	local var_5_3
	local var_5_4
	local var_5_5 = arg_5_1.slot_melee

	if arg_5_2 or not var_5_5 then
		local var_5_6 = var_5_0:get_loadout()[arg_5_6]
		local var_5_7 = var_5_6.slot_melee
		local var_5_8 = var_5_6.slot_ranged
		local var_5_9 = var_5_6.slot_hat

		var_5_1 = var_5_7 and var_5_0:get_item_name(var_5_6.slot_melee)
		var_5_2 = var_5_8 and var_5_0:get_item_name(var_5_6.slot_ranged)
		var_5_3 = var_5_0:get_item_name(var_5_6.slot_skin)
		var_5_4 = var_5_9 and var_5_0:get_item_name(var_5_9)
	else
		var_5_1 = var_5_5
		var_5_2 = arg_5_1.slot_ranged
		var_5_3 = arg_5_1.slot_skin
		var_5_4 = arg_5_1.slot_hat
	end

	local var_5_10 = {}

	if var_5_1 ~= "n/a" then
		var_5_10[#var_5_10 + 1] = var_5_1
	end

	if var_5_2 ~= "n/a" then
		var_5_10[#var_5_10 + 1] = var_5_2
	end

	fassert(#var_5_10 > 0, "Character must have at least one weapon equipped")

	local var_5_11 = var_5_10[math.random(1, #var_5_10)]
	local var_5_12 = ItemMasterList[var_5_11]
	local var_5_13 = var_5_12.slot_type
	local var_5_14 = var_5_0:get_item_template(var_5_12).wield_anim
	local var_5_15 = {
		{
			item_name = var_5_11
		}
	}

	if var_5_4 then
		var_5_15[#var_5_15 + 1] = {
			item_name = var_5_4
		}
	end

	return {
		profile_index = arg_5_3,
		career_index = arg_5_4,
		hero_name = arg_5_5.display_name,
		skin_name = var_5_3,
		weapon_slot = var_5_13,
		preview_items = var_5_15,
		preview_animation = var_5_14,
		career_name = arg_5_6
	}
end

function VersusTeamParadingView._initialize_timers(arg_6_0)
	arg_6_0._screen_timer = Managers.state.game_mode:setting("character_picking_settings").parading_duration or 1
	arg_6_0._screen_timer_ended = nil
end

function VersusTeamParadingView._present_team(arg_7_0, arg_7_1)
	local var_7_0 = Managers.state.game_mode:setting("parade_dark_pact")
	local var_7_1 = Managers.party:get_party(arg_7_1)
	local var_7_2 = var_7_1.slots_data
	local var_7_3 = Managers.state.side.side_by_party[var_7_1]
	local var_7_4 = var_7_3.available_profiles
	local var_7_5 = var_7_0 and var_7_3:name() == "dark_pact"
	local var_7_6 = arg_7_0._widgets_by_name.team_name_text
	local var_7_7 = "Your Team"
	local var_7_8 = {}
	local var_7_9 = {}

	for iter_7_0 = 1, #var_7_2 do
		local var_7_10 = var_7_1.slots[iter_7_0]
		local var_7_11 = var_7_2[iter_7_0]
		local var_7_12 = var_7_10.career_index or 1
		local var_7_13 = var_7_10.profile_index

		var_7_13 = var_7_13 and var_7_13 > 0 and var_7_13 or 1

		local var_7_14 = SPProfiles[var_7_13]
		local var_7_15 = var_7_14.careers[var_7_12]
		local var_7_16 = arg_7_0:get_loadout(var_7_11, var_7_5, var_7_13, var_7_12, var_7_14, var_7_15.name)
		local var_7_17 = "player_" .. iter_7_0
		local var_7_18 = arg_7_0._ui_scenegraph[var_7_17].world_position
		local var_7_19 = arg_7_0:_create_diorama(var_7_18)

		var_7_19:set_hero_profile(var_7_13, var_7_12)
		var_7_19:set_viewport_active(false)
		var_7_19:fade_out(0)

		local var_7_20

		if var_7_10.peer_id then
			local var_7_21 = Managers.player:player(var_7_10.peer_id, var_7_10.local_player_id)

			var_7_20 = var_7_21 and var_7_21:name() or "Bot-" .. iter_7_0
		else
			var_7_20 = Localize(var_7_16.hero_name)
		end

		var_7_19:set_player_name(var_7_20)

		var_7_9[iter_7_0] = var_7_19
	end

	arg_7_0._diorama_list = var_7_9
	arg_7_0._animation_params = {
		wwise_world = arg_7_0._wwise_world,
		render_settings = arg_7_0._render_settings,
		diorama_list = arg_7_0._diorama_list
	}

	arg_7_0:_start_animation("start", "start", arg_7_0._widgets_by_name, arg_7_0._animation_params)
end

function VersusTeamParadingView._destroy_diorama_list(arg_8_0)
	local var_8_0 = arg_8_0._diorama_list

	if var_8_0 then
		for iter_8_0 = 1, #var_8_0 do
			var_8_0[iter_8_0]:destroy()
		end
	end

	arg_8_0._diorama_list = nil
end

function VersusTeamParadingView.on_exit(arg_9_0)
	arg_9_0.super.on_exit(arg_9_0)
	Managers.transition:fade_out(1.5)
	Managers.state.event:unregister("on_player_party_changed", arg_9_0)
end

function VersusTeamParadingView.post_update_on_exit(arg_10_0)
	arg_10_0.super.post_update_on_exit(arg_10_0)
	arg_10_0:_destroy_diorama_list()
end

function VersusTeamParadingView._draw_widgets(arg_11_0, arg_11_1, arg_11_2)
	return
end

function VersusTeamParadingView.post_update(arg_12_0, arg_12_1, arg_12_2)
	if var_0_1 then
		var_0_1 = false

		arg_12_0:_destroy_diorama_list()
		arg_12_0:_initialize_timers()
		arg_12_0:_present_team(1)
	end

	local var_12_0 = arg_12_0._diorama_list

	if var_12_0 then
		for iter_12_0 = 1, #var_12_0 do
			var_12_0[iter_12_0]:post_update(arg_12_1, arg_12_2)
		end
	end
end

function VersusTeamParadingView._update_screen_timer(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = math.clamp(arg_13_2, 0, 999999)
	local var_13_1
	local var_13_2 = var_13_0 <= 0 and "" or string.format("%.0f", var_13_0)

	arg_13_1.content.text = var_13_2
end

function VersusTeamParadingView._animate_font_size_bounce(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._widgets_by_name
	local var_14_1 = var_14_0.screen_timer_text_big
	local var_14_2 = var_14_1.content
	local var_14_3 = var_14_1.style
	local var_14_4 = var_14_2.text
	local var_14_5 = var_14_3.text
	local var_14_6 = var_14_3.text_shadow
	local var_14_7 = var_14_5.default_font_size
	local var_14_8 = var_14_5.max_font_size
	local var_14_9 = 1 - (arg_14_0._screen_timer + 0.5) % 1
	local var_14_10 = arg_14_0._screen_timer_ended
	local var_14_11 = var_14_7 + (var_14_8 - var_14_7) * var_14_9

	var_14_5.font_size = var_14_11
	var_14_6.font_size = var_14_11

	local var_14_12 = var_14_5.text_color[1]
	local var_14_13 = var_14_10 and 0 or 15 * (1 - var_14_9)

	arg_14_0:_set_text_widget_alpha(var_14_1, var_14_13)

	if var_14_10 then
		arg_14_0:_set_text_widget_alpha(var_14_0.screen_timer_text, 0)
	end
end

function VersusTeamParadingView._set_text_widget_alpha(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1.style
	local var_15_1 = var_15_0.text
	local var_15_2 = var_15_0.text_shadow

	var_15_1.text_color[1] = arg_15_2
	var_15_2.text_color[1] = arg_15_2
end

function VersusTeamParadingView.update(arg_16_0, arg_16_1, arg_16_2)
	if var_0_1 then
		arg_16_0.super.debug_set_definitions(arg_16_0, var_0_0)
	end

	local var_16_0 = arg_16_0._diorama_list

	if var_16_0 then
		for iter_16_0 = 1, #var_16_0 do
			var_16_0[iter_16_0]:update(arg_16_1, arg_16_2)
		end
	end

	arg_16_0:_handle_input(arg_16_1, arg_16_2)

	local var_16_1 = arg_16_0._screen_timer

	arg_16_0._screen_timer = arg_16_0._screen_timer - arg_16_1

	if arg_16_0._screen_timer <= 0 and not arg_16_0._screen_timer_ended then
		arg_16_0._screen_timer_ended = true
	end

	if arg_16_0._screen_timer > 0 and var_16_1 and math.round(var_16_1) ~= math.round(arg_16_0._screen_timer) then
		if arg_16_0._screen_timer < 1 then
			arg_16_0:play_sound("menu_wind_countdown_warning")
		elseif arg_16_0._screen_timer < 4 then
			arg_16_0:play_sound("menu_wind_countdown_count_big")
		elseif arg_16_0._screen_timer < 8 then
			arg_16_0:play_sound("menu_wind_countdown_count_small")
		end
	end

	arg_16_0:_animate_font_size_bounce(arg_16_1, arg_16_2)
	arg_16_0:_update_screen_timer(arg_16_0._widgets_by_name.screen_timer_text, arg_16_0._screen_timer)
	arg_16_0:_update_screen_timer(arg_16_0._widgets_by_name.screen_timer_text_big, arg_16_0._screen_timer)
	arg_16_0.super.update(arg_16_0, arg_16_1, arg_16_2)
end

function VersusTeamParadingView.destroy(arg_17_0)
	if not Managers.chat:chat_is_focused() then
		local var_17_0 = Managers.input

		var_17_0:device_unblock_all_services("keyboard")
		var_17_0:device_unblock_all_services("mouse")
		var_17_0:device_unblock_all_services("gamepad")
	end

	Managers.state.event:unregister("on_player_party_changed", arg_17_0)
end

function VersusTeamParadingView._handle_input(arg_18_0, arg_18_1, arg_18_2)
	return
end

function VersusTeamParadingView.on_player_party_changed(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	if not arg_19_2 then
		return
	end

	if Managers.mechanism:get_state() == "inn" then
		arg_19_0:_present_team(arg_19_4)
	end
end
