-- chunkname: @scripts/ui/views/versus_menu/versus_party_char_selection_view.lua

require("scripts/ui/views/versus_menu/ui_widgets_vs")
require("scripts/ui/views/team_previewer")

local var_0_0 = local_require("scripts/ui/views/versus_menu/versus_party_char_selection_view_definitions")
local var_0_1 = DLCSettings.carousel
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.create_progress_marker
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = var_0_0.animation_definitions
local var_0_6 = var_0_0.scenegraph_definition
local var_0_7 = var_0_0.other_definitions
local var_0_8 = var_0_0.top_detail_widgets_definitions
local var_0_9 = var_0_0.create_player_name_box_widgets
local var_0_10 = {}
local var_0_11 = {
	done = "versus_hero_selection_view_done",
	waiting = "versus_hero_selection_view_waiting",
	picking = "versus_hero_selection_view_picking"
}
local var_0_12 = VersusPartySelectionLogicUtility.ClientStateLookup

VersusPartyCharSelectionView = class(VersusPartyCharSelectionView, BaseView)

function VersusPartyCharSelectionView.init(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1.player

	arg_1_0._player = var_1_0
	arg_1_0._peer_id = var_1_0:network_id()
	arg_1_0._local_player_id = var_1_0:local_player_id()
	arg_1_0._unique_id = arg_1_0._peer_id .. ":" .. arg_1_0._local_player_id
	arg_1_0._game_mode = Managers.state.game_mode:game_mode()
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._profile_synchronizer = arg_1_1.profile_synchronizer
	arg_1_0._profile_requester = (arg_1_1.network_server or arg_1_1.network_client):profile_requester()
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._cam_anim_indx = 1
	arg_1_0._camera_animations = {}
	arg_1_0._team_heroes = {}
	arg_1_0._team_previewer = nil
	arg_1_0._voip = arg_1_1.voip

	arg_1_0.super.init(arg_1_0, arg_1_1, var_0_0)
end

function VersusPartyCharSelectionView.on_enter(arg_2_0, arg_2_1)
	print("[VersusPartyCharSelectionView] Enter character selection view")
	arg_2_0.super.on_enter(arg_2_0)

	arg_2_0._party_selection_logic = Managers.state.game_mode:game_mode():party_selection_logic()

	arg_2_0._party_selection_logic:set_ingame_ui(arg_2_0._ingame_ui)

	arg_2_0._party = Managers.party:get_party_from_player_id(arg_2_0._peer_id, arg_2_0._local_player_id)
	arg_2_0._side = Managers.state.side.side_by_party[arg_2_0._party]
	arg_2_0._status = Managers.party:get_player_status(arg_2_0._peer_id, arg_2_0._local_player_id)

	arg_2_0:_setup_roster_widgets_definitions()
	arg_2_0:_setup_background_world()
	arg_2_0:_activate_viewport()

	arg_2_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_2_0._animations = {}

	local var_2_0 = UILayer.default + 100

	arg_2_0._menu_input_description = MenuInputDescriptionUI:new(arg_2_0._ingame_ui_context, arg_2_0._ui_top_renderer, arg_2_0:input_service(), 4, var_2_0, var_0_4.default, true)

	arg_2_0._menu_input_description:set_input_description(nil)
	arg_2_0:create_ui_elements(arg_2_1)

	arg_2_0._params = arg_2_1
	arg_2_0._prev_timer_value = 0

	arg_2_0:play_sound("vs_mute_all")
	arg_2_0:play_sound("menu_versus_character_amb_loop_start")

	if IS_WINDOWS and not Window.has_focus() then
		Window.flash_window(nil, "start", 3)
	end
end

function VersusPartyCharSelectionView._setup_roster_widgets_definitions(arg_3_0)
	local var_3_0, var_3_1 = var_0_0.create_hero_roster_widget_defitions()

	arg_3_0._hero_group_widgets_defs = var_3_0
	arg_3_0._hero_roster_detail_widgets_defs = var_3_1
end

function VersusPartyCharSelectionView._is_hovering_item(arg_4_0, arg_4_1, arg_4_2)
	return arg_4_0._hovered_profile_index == arg_4_1 and arg_4_0._hovered_career_index == arg_4_2
end

function VersusPartyCharSelectionView._set_item_hovered(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_3 = arg_5_3 or 0
	arg_5_4 = arg_5_4 or 0
	arg_5_0._hovered_profile_index = arg_5_3
	arg_5_0._hovered_career_index = arg_5_4

	arg_5_0._party_selection_logic:sync_hovered_item(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
end

function VersusPartyCharSelectionView.on_exit(arg_6_0)
	print("[VersusPartyCharSelectionView] Exit character selection view")

	if arg_6_0._team_previewer then
		arg_6_0:_destroy_team_previewer()
	end

	if arg_6_0._team_world_viewport then
		ScriptWorld.destroy_viewport(arg_6_0._background_world, arg_6_0._team_world_viewport_name)

		arg_6_0._team_world_viewport = nil
		arg_6_0._team_world_viewport_name = nil
	end

	if arg_6_0._background_world then
		arg_6_0:_destroy_world()
	end

	arg_6_0.super.on_exit(arg_6_0)

	if not Managers.state.game_mode:setting("display_parading_view") then
		arg_6_0:play_sound("vs_unmute_reset_all")
	end

	local var_6_0 = Managers.state.event

	if var_6_0 then
		var_6_0:unregister("party_selection_logic_state_set", arg_6_0)
	end
end

function VersusPartyCharSelectionView.post_update(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.ui_animator:update(arg_7_1)
	arg_7_0:_update_animations(arg_7_1, arg_7_2)
	arg_7_0:_update_camera(arg_7_2)
	arg_7_0:_update_player_party(arg_7_1, arg_7_2)
	arg_7_0:_handle_input(arg_7_1, arg_7_2)

	if arg_7_0._team_previewer then
		arg_7_0:_update_team_previewer(arg_7_1, arg_7_2)
	end
end

function VersusPartyCharSelectionView.update(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0._is_spectator then
		arg_8_0:draw(arg_8_1)
	end

	arg_8_0.super.update(arg_8_0, arg_8_1, arg_8_2)
end

function VersusPartyCharSelectionView._update_hero_picking_progress(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_2.picker_list
	local var_9_1 = arg_9_1.party_id

	for iter_9_0, iter_9_1 in pairs(arg_9_0._hero_group_widgets_lookup) do
		for iter_9_2, iter_9_3 in pairs(iter_9_1) do
			iter_9_3.content.taken = nil
			iter_9_3.content.taken_id = nil
		end
	end

	for iter_9_4 = 1, arg_9_3 do
		local var_9_2 = arg_9_0._picking_progress_data[iter_9_4]
		local var_9_3 = var_9_0[iter_9_4]
		local var_9_4 = var_9_3.slot_id
		local var_9_5 = var_0_12[var_9_3.state] == var_0_12.player_picking_character
		local var_9_6 = var_0_12[var_9_3.state] >= var_0_12.player_has_picked_character
		local var_9_7 = VersusPartySelectionLogicUtility.picker_index_is_bot(arg_9_2, var_9_4)
		local var_9_8
		local var_9_9

		if var_9_7 then
			if var_9_6 or var_9_5 then
				var_9_8, var_9_9 = arg_9_0._profile_synchronizer:get_bot_profile(var_9_1, var_9_4)
			end
		else
			local var_9_10 = var_9_3.status.peer_id

			if var_9_10 then
				var_9_8, var_9_9 = arg_9_0._profile_synchronizer:get_persistent_profile_index_reservation(var_9_10)
			end
		end

		local var_9_11 = arg_9_0._hero_group_widgets_lookup[var_9_8]

		if var_9_11 then
			for iter_9_5, iter_9_6 in pairs(var_9_11) do
				if var_9_5 then
					iter_9_6.content.taken = nil
				elseif var_9_6 then
					iter_9_6.content.taken = true
					iter_9_6.content.has_picked = true
				end

				if iter_9_5 == var_9_9 then
					iter_9_6.taken_id = var_9_4
				end
			end
		end

		local var_9_12

		var_9_12, var_9_9 = var_9_8 or 0, var_9_9 or 0

		if var_9_2.profile_index ~= var_9_12 or var_9_2.career_index ~= var_9_9 then
			var_9_2.profile_index = var_9_12
			var_9_2.career_index = var_9_9
		end
	end
end

function VersusPartyCharSelectionView._update_timer_progress_bar(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_1.slider_timer then
		local var_10_0 = "progress_bar"
		local var_10_1 = arg_10_0._ui_scenegraph
		local var_10_2 = var_0_6[var_10_0].size
		local var_10_3 = arg_10_1.slider_timer
		local var_10_4 = arg_10_1.time_finished
		local var_10_5 = arg_10_1.total_slider_time
		local var_10_6 = math.clamp((var_10_4 - var_10_3) / var_10_5, 0, 1) * var_10_2[1]

		for iter_10_0 = 1, arg_10_3 do
			local var_10_7 = arg_10_0._picking_progress_data[iter_10_0]
			local var_10_8 = var_10_7.bar_distance
			local var_10_9 = var_10_7.step_size > var_10_8 - var_10_6
			local var_10_10 = var_10_8 < var_10_6
			local var_10_11 = var_10_7.point_widget

			if var_10_11 then
				var_10_11.content.highlight = var_10_9
				var_10_11.content.done = var_10_10
			end

			var_10_1[var_10_0].size[1] = var_10_6
		end
	end
end

function VersusPartyCharSelectionView._update_background_music(arg_11_0, arg_11_1)
	if not arg_11_0._background_music_triggered and arg_11_1 ~= "setup" then
		arg_11_0._background_music_triggered = true

		arg_11_0:play_sound("menu_versus_character_selection_start")
	end
end

function VersusPartyCharSelectionView._update_party_state_startup(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if arg_12_1 ~= "startup" then
		return
	end

	local var_12_0 = arg_12_0._party_selection_logic:timer()

	if not arg_12_0._start_timer_value then
		arg_12_0._start_timer_value = var_12_0
	end

	if var_12_0 <= arg_12_0._start_timer_value - GameSettings.transition_fade_out_speed then
		local var_12_1 = math.ceil(var_12_0)

		arg_12_0._widgets_by_name.countdown_timer.content.text = tostring(var_12_1)

		if var_12_1 ~= arg_12_0._prev_timer_value then
			if var_12_1 > 0 then
				local var_12_2 = var_0_1.versus_character_selection_clock_tick[var_12_1]

				arg_12_0:play_sound(var_12_2)
			end

			arg_12_0._prev_timer_value = var_12_1
		end
	end
end

function VersusPartyCharSelectionView._update_party_state_player_picking_character(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_0._party_selection_logic:get_party_data(arg_13_0._party_id)

	if not var_13_0 then
		return
	end

	local var_13_1 = arg_13_0._data_by_pick_index

	for iter_13_0 = 1, #var_13_1 do
		local var_13_2 = var_13_1[iter_13_0]
		local var_13_3 = VersusPartySelectionLogicUtility.picker_index_is_bot(var_13_0, iter_13_0)

		if var_13_2.is_bot ~= var_13_3 then
			var_13_2.is_bot = var_13_3

			arg_13_0:_update_player_name_box_widget(var_13_0, iter_13_0)
		end
	end

	if arg_13_1 ~= "player_picking_character" then
		return
	end

	arg_13_0._next_character_update_idx = math.index_wrapper((arg_13_0._next_character_update_idx or 0) + 1, arg_13_3)

	local var_13_4 = arg_13_0._next_character_update_idx
	local var_13_5 = arg_13_2[var_13_4]
	local var_13_6 = arg_13_0:local_player_is_picking()

	arg_13_0._widgets_by_name.local_player_picking_frame.content.visible = var_13_6

	local var_13_7 = var_13_5.status
	local var_13_8 = var_13_7.selected_profile_index
	local var_13_9 = var_13_7.selected_career_index
	local var_13_10 = arg_13_0._data_by_pick_index[var_13_4]

	if var_13_8 and var_13_9 then
		local var_13_11 = var_13_5.slot_id

		if arg_13_4.slots_data[var_13_11].slot_skin ~= "n/a" and (var_13_8 ~= var_13_10.profile_index or var_13_9 ~= var_13_10.career_index) then
			arg_13_0:_spawn_selected_hero(var_13_4)

			var_13_10.profile_index = var_13_8
			var_13_10.career_index = var_13_9

			if var_13_4 == arg_13_3 then
				arg_13_0:_set_selected_hero_and_career_text(var_13_8, var_13_9)
				arg_13_0:_update_selcted_career_passive_and_career_skill(var_13_8, var_13_9)
			end
		end
	end

	local var_13_12 = arg_13_0._hero_group_widgets_lookup

	if var_13_12 then
		for iter_13_1 = 1, #var_13_12 do
			local var_13_13 = var_13_12[iter_13_1]

			if var_13_13 then
				for iter_13_2 = 1, #var_13_13 do
					var_13_13[iter_13_2].content.other_picking = not var_13_6
				end
			end
		end
	end
end

function VersusPartyCharSelectionView._setup_local_picker_data(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0, var_14_1 = Managers.party:get_party_from_player_id(arg_14_1, arg_14_2)

	if var_14_1 == 0 then
		return
	end

	arg_14_0._slot_id = Managers.party:get_player_status(arg_14_1, arg_14_2).slot_id
	arg_14_0._party = var_14_0
	arg_14_0._party_id = var_14_1
	arg_14_0._is_spectator = var_14_0.name == "spectators"

	local var_14_2 = arg_14_0._party_selection_logic:get_party_data(arg_14_0._party_id)

	if not var_14_2 then
		return
	end

	arg_14_0._data_by_pick_index = {}

	for iter_14_0 = 1, var_14_0.num_slots do
		arg_14_0._data_by_pick_index[iter_14_0] = {}
	end

	arg_14_0._party_data = var_14_2

	local var_14_3 = var_14_2.picker_list

	for iter_14_1 = 1, #var_14_3 do
		local var_14_4 = var_14_3[iter_14_1]

		if var_14_4.slot_id == arg_14_0._slot_id then
			arg_14_0._local_player_data = var_14_4
			arg_14_0._picker_list_id = iter_14_1

			break
		end
	end

	if not arg_14_0._is_spectator then
		arg_14_0:_setup_character_selection_widgets()
		arg_14_0:_update_all_player_name_box_widgets()
	end
end

function VersusPartyCharSelectionView._update_player_party(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0._party_id then
		local var_15_0 = arg_15_0._peer_id
		local var_15_1 = arg_15_0._local_player_id

		arg_15_0:_setup_local_picker_data(var_15_0, var_15_1)
	end

	local var_15_2 = arg_15_0._party_selection_logic:get_party_data(arg_15_0._party_id)

	if not var_15_2 then
		return
	end

	if #arg_15_0._team_heroes == 0 and not arg_15_0._team_previewer then
		arg_15_0:_setup_team_heroes()
		arg_15_0:_setup_team_previewer()
		arg_15_0:_update_all_player_name_box_widgets()
		arg_15_0:_set_your_turn_text_position()
		arg_15_0:_set_top_detail_widgets_visible(false)
		Managers.state.event:register(arg_15_0, "party_selection_logic_state_set", "on_party_selection_logic_state_set")
		arg_15_0:on_party_selection_logic_state_set(var_15_2.state, arg_15_0._party_id, var_15_2.current_picker_index)
	end

	local var_15_3 = arg_15_0._party
	local var_15_4 = var_15_2.state
	local var_15_5 = var_15_3.num_slots
	local var_15_6 = var_15_2.picker_list
	local var_15_7 = var_15_2.current_picker_index
	local var_15_8 = arg_15_0:local_player_is_picking()

	arg_15_0:_update_background_music(var_15_4)
	arg_15_0:_update_party_state_startup(var_15_4, var_15_6, var_15_3)
	arg_15_0:_update_party_state_player_picking_character(var_15_4, var_15_6, var_15_7, var_15_3)
	arg_15_0:_update_hero_picking_progress(var_15_3, var_15_2, var_15_5)
	arg_15_0:_update_timer_progress_bar(var_15_2, var_15_8, var_15_5)
end

function VersusPartyCharSelectionView._update_roster_widgets_animations(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._party_selection_logic:get_party_data(arg_16_0._party_id)

	if not var_16_0 then
		return
	end

	local var_16_1 = var_16_0.state
	local var_16_2 = var_16_0.picker_list[arg_16_0._picker_list_id]
	local var_16_3 = false
	local var_16_4 = arg_16_0._hero_group_widgets_lookup

	if var_16_4 then
		for iter_16_0 = 1, #var_16_4 do
			local var_16_5 = var_16_4[iter_16_0]

			if var_16_5 then
				for iter_16_1 = 1, #var_16_5 do
					local var_16_6 = var_16_5[iter_16_1]
					local var_16_7 = var_16_6.content
					local var_16_8 = var_16_6.style
					local var_16_9 = var_16_6.offset
					local var_16_10 = var_16_7.button_hotspot
					local var_16_11 = var_16_7.taken
					local var_16_12 = var_16_7.locked
					local var_16_13 = var_16_7.other_picking
					local var_16_14 = var_16_7.gamepad_selected
					local var_16_15 = (var_16_10.is_hover or var_16_14) and not var_16_13 and not var_16_12
					local var_16_16 = var_16_7.profile_index
					local var_16_17 = var_16_7.career_index
					local var_16_18 = arg_16_0:_is_item_selected(var_16_16, var_16_17)
					local var_16_19 = var_16_10.hover_progress or 0
					local var_16_20 = var_16_10.selection_progress or 0
					local var_16_21 = var_16_10.inactive_progress or 0
					local var_16_22 = var_16_10.taken_progress or 0

					var_16_7.party_state = var_16_1

					if var_16_1 == "startup" then
						var_16_8.local_player_selected_texture.color[1] = 0
						var_16_8.other_player_selected_texture.color[1] = 0
						var_16_3 = true
					elseif var_16_1 ~= "startup" and var_16_1 ~= "parading" then
						var_16_3 = (var_16_2.state == "player_has_picked_character" or var_16_12) and not var_16_18

						local var_16_23 = 15
						local var_16_24 = 5

						if var_16_15 then
							var_16_19 = math.min(var_16_19 + arg_16_1 * var_16_23, 1)
						else
							var_16_19 = math.max(var_16_19 - arg_16_1 * var_16_23, 0)
						end

						if var_16_3 then
							var_16_21 = math.min(var_16_21 + arg_16_1 * var_16_23, 1)
						else
							var_16_21 = math.max(var_16_21 - arg_16_1 * var_16_23, 0)
						end

						if var_16_18 then
							var_16_20 = math.min(var_16_20 + arg_16_1 * var_16_24, 1)
						else
							var_16_20 = 0
						end

						if var_16_11 then
							var_16_22 = math.min(var_16_22 + arg_16_1 * var_16_23, 1)
						else
							var_16_22 = math.max(var_16_22 - arg_16_1 * var_16_23, 0)
						end

						local var_16_25 = math.easeCubic(var_16_20)

						var_16_9[3] = var_16_19 > 0 and 10 or 0

						local var_16_26 = 55 + 200 * (1 - var_16_22)

						var_16_8.portrait.color = {
							255,
							var_16_26,
							var_16_26,
							var_16_26
						}
						var_16_8.local_player_selected_texture.color[1] = not var_16_13 and 255 * var_16_25 or 0
						var_16_8.other_player_selected_texture.color[1] = var_16_13 and 255 * var_16_25 or 0

						for iter_16_2, iter_16_3 in pairs(var_16_8) do
							local var_16_27 = iter_16_3.default_size

							if var_16_27 then
								local var_16_28 = iter_16_3.size or iter_16_3.texture_size or iter_16_3.area_size
								local var_16_29 = 0

								if iter_16_2 == "local_player_selected_texture" or iter_16_2 == "other_player_selected_texture" then
									var_16_29 = -0.5 + 0.5 * var_16_25
								end

								local var_16_30 = 0.2 + var_16_29
								local var_16_31 = math.ceil(var_16_27[1] * var_16_30)
								local var_16_32 = math.ceil(var_16_27[2] * var_16_30)
								local var_16_33 = var_16_31 * var_16_19
								local var_16_34 = var_16_32 * var_16_19

								var_16_28[1] = var_16_27[1] + var_16_33
								var_16_28[2] = var_16_27[2] + var_16_34

								local var_16_35 = iter_16_3.default_offset

								if var_16_35 then
									local var_16_36 = iter_16_3.offset

									var_16_36[1] = var_16_35[1] - var_16_33 * 0.5
									var_16_36[2] = var_16_35[2] - var_16_34 * 0.5
								end
							end
						end
					end

					var_16_8.portrait.saturated = var_16_3
					var_16_10.taken_progress = var_16_22
					var_16_10.hover_progress = var_16_19
					var_16_10.inactive_progress = var_16_21
					var_16_10.selection_progress = var_16_20
				end
			end
		end
	end
end

function VersusPartyCharSelectionView._get_player_name_by_status(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0

	if arg_17_1 then
		if arg_17_1.is_player then
			local var_17_1 = arg_17_1.peer_id
			local var_17_2 = arg_17_1.local_player_id
			local var_17_3 = Managers.player:player(var_17_1, var_17_2)

			if var_17_3 then
				var_17_0 = var_17_3:name() .. " "
			end
		elseif arg_17_1.is_bot then
			var_17_0 = "Bot " .. arg_17_1.slot_id
		end
	end

	var_17_0 = var_17_0 or "Bot " .. arg_17_2

	return var_17_0
end

function VersusPartyCharSelectionView._handle_input(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0._party_selection_logic:get_party_data(arg_18_0._party_id) then
		return
	end

	if Managers.input:is_device_active("gamepad") then
		arg_18_0:_handle_gamepad_selection()
	else
		arg_18_0:_handle_mouse_selection()
		arg_18_0:_handle_hover_sync()
	end
end

function VersusPartyCharSelectionView._handle_hover_sync(arg_19_0)
	local var_19_0 = arg_19_0._hero_group_widgets_lookup

	if var_19_0 then
		for iter_19_0 = 1, #var_19_0 do
			local var_19_1 = var_19_0[iter_19_0]

			if var_19_1 then
				for iter_19_1 = 1, #var_19_1 do
					local var_19_2 = var_19_1[iter_19_1]
					local var_19_3 = arg_19_0:_is_item_hovered_by_other(iter_19_0, iter_19_1)

					var_19_2.content.hovered_by_other = var_19_3
				end
			end
		end
	end
end

function VersusPartyCharSelectionView.draw(arg_20_0, arg_20_1)
	if not arg_20_0._party_id then
		return
	end

	local var_20_0 = arg_20_0._ui_renderer
	local var_20_1 = arg_20_0._ui_top_renderer
	local var_20_2 = arg_20_0._ui_scenegraph
	local var_20_3 = arg_20_0:input_service()
	local var_20_4 = arg_20_0.render_settings
	local var_20_5 = arg_20_0._party_selection_logic:get_party_data(arg_20_0._party_id).state
	local var_20_6 = var_20_4.alpha_multiplier or 1

	UIRenderer.begin_pass(var_20_1, var_20_2, var_20_3, arg_20_1, nil, var_20_4)
	arg_20_0:_draw_widgets(arg_20_0._other_widgets, var_20_4, var_20_1, var_20_6)

	if var_20_5 ~= "closing" then
		arg_20_0:_draw_widgets(arg_20_0._hero_group_widgets, var_20_4, var_20_1, var_20_6)
		arg_20_0:_draw_widgets(arg_20_0._hero_group_detail_widgets, var_20_4, var_20_1, var_20_6)
	end

	arg_20_0:_draw_widgets(arg_20_0._top_detail_widgets, var_20_4, var_20_1, var_20_6)
	arg_20_0:_draw_widgets(arg_20_0._player_name_box_widgets, var_20_4, var_20_1, var_20_6)
	UIRenderer.end_pass(var_20_1)

	var_20_4.alpha_multiplier = var_20_6

	local var_20_7 = Managers.input:is_device_active("gamepad")

	if arg_20_0._menu_input_description and var_20_7 then
		arg_20_0._menu_input_description:draw(var_20_1, arg_20_1)
	end
end

function VersusPartyCharSelectionView._draw_widgets(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if not arg_21_1 then
		return
	end

	for iter_21_0, iter_21_1 in ipairs(arg_21_1) do
		arg_21_2.alpha_multiplier = iter_21_1.alpha_multiplier or arg_21_4

		UIRenderer.draw_widget(arg_21_3, iter_21_1)
	end
end

function VersusPartyCharSelectionView._update_animations(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._animations
	local var_22_1 = arg_22_0.ui_animator

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if var_22_1:is_animation_completed(iter_22_1) then
			var_22_1:stop_animation(iter_22_1)

			var_22_0[iter_22_0] = nil
		end
	end

	arg_22_0:_update_roster_widgets_animations(arg_22_1, arg_22_2)
end

function VersusPartyCharSelectionView._start_transition_animation(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = {
		wwise_world = arg_23_0._wwise_world,
		render_settings = arg_23_0.render_settings
	}
	local var_23_1 = {}
	local var_23_2 = arg_23_0.ui_animator:start_animation(arg_23_2, var_23_1, var_0_6, var_23_0)

	arg_23_0._animations[arg_23_1] = var_23_2
end

function VersusPartyCharSelectionView.create_ui_elements(arg_24_0, arg_24_1)
	if arg_24_0._team_previewer then
		arg_24_0:_destroy_team_previewer()
	end

	arg_24_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_6)

	local var_24_0 = arg_24_0._widgets_by_name

	arg_24_0._other_widgets = {}
	arg_24_0._player_name_box_widgets = {}
	arg_24_0._top_detail_widgets = {}

	UIUtils.create_widgets(var_0_2, arg_24_0._other_widgets, var_24_0)
	UIUtils.create_widgets(var_0_7, arg_24_0._other_widgets, var_24_0)
	UIUtils.create_widgets(var_0_8, arg_24_0._top_detail_widgets, var_24_0)

	local var_24_1 = var_0_9()

	UIUtils.create_widgets(var_24_1, arg_24_0._player_name_box_widgets, var_24_0)
	UIRenderer.clear_scenegraph_queue(arg_24_0._ui_top_renderer)
	UIRenderer.clear_scenegraph_queue(arg_24_0._ui_renderer)

	arg_24_0.ui_animator = UIAnimator:new(arg_24_0._ui_scenegraph, var_0_5)

	arg_24_0:_setup_picking_progress_bar(4)

	var_24_0.local_player_picking_frame.content.visible = false

	arg_24_0._menu_input_description:set_input_description(var_0_4.default)
end

function VersusPartyCharSelectionView._setup_character_selection_widgets(arg_25_0, arg_25_1)
	local var_25_0 = {}

	arg_25_0._hero_group_widgets = var_25_0

	local var_25_1 = {}

	arg_25_0._hero_group_detail_widgets = var_25_1

	local var_25_2 = {}

	arg_25_0._hero_group_widgets_lookup = var_25_2

	arg_25_0:_setup_hero_party_selection_widgets(var_25_0, var_25_1, var_25_2)
end

function VersusPartyCharSelectionView._update_all_player_name_box_widgets(arg_26_0)
	local var_26_0 = arg_26_0._party_selection_logic:get_party_data(arg_26_0._party_id)

	if not var_26_0 then
		return
	end

	local var_26_1 = var_26_0.picker_list

	for iter_26_0 = 1, #var_26_1 do
		arg_26_0:_update_player_name_box_widget(var_26_0, iter_26_0)
	end
end

function VersusPartyCharSelectionView._update_player_name_box_widget(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_1.picker_list[arg_27_2]
	local var_27_1 = var_27_0.status

	if var_27_1 then
		local var_27_2 = var_27_1.player
		local var_27_3 = arg_27_0._player_name_box_widgets[arg_27_2].content
		local var_27_4 = var_27_2 and arg_27_0:_set_player_name(var_27_2) or "BOT"
		local var_27_5

		if var_27_0.state == "player_picking_character" then
			if arg_27_2 == arg_27_1.current_picker_index then
				var_27_5 = Localize(var_0_11.picking)
			end
		elseif var_27_0.state == "player_has_picked_character" then
			var_27_5 = Localize(var_0_11.done)
		else
			var_27_5 = Localize(var_0_11.waiting)
		end

		local var_27_6 = "{#color(%d,%d,%d,%d)}%s {#reset()} %s"
		local var_27_7 = arg_27_0._picker_list_id == arg_27_2
		local var_27_8 = var_27_7 and Colors.get_color_table_with_alpha("local_player_picking", 255) or Colors.get_color_table_with_alpha("other_player_picking", 255)

		var_27_3.player_name = string.format(var_27_6, var_27_8[2], var_27_8[3], var_27_8[4], var_27_8[1], var_27_4, var_27_5)
		var_27_3.is_player = var_27_2 ~= nil
		var_27_3.peer_id = var_27_1.peer_id
		var_27_3.is_local_player = var_27_7
	end
end

function VersusPartyCharSelectionView._setup_hero_party_selection_widgets(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = Managers.backend:get_interface("hero_attributes")
	local var_28_1 = {}
	local var_28_2 = {}

	for iter_28_0, iter_28_1 in ipairs(ProfilePriority) do
		var_28_1[iter_28_1] = SPProfiles[iter_28_1]
		var_28_2[#var_28_2 + 1] = iter_28_1
	end

	arg_28_0._profile_indices = var_28_2

	local var_28_3 = #var_28_2
	local var_28_4 = 0

	for iter_28_2, iter_28_3 in pairs(var_28_2) do
		local var_28_5 = var_28_1[iter_28_3]
		local var_28_6 = var_28_5.display_name
		local var_28_7 = var_28_0:get(var_28_6, "experience") or 0
		local var_28_8 = ExperienceSettings.get_level(var_28_7)
		local var_28_9 = var_28_5.careers
		local var_28_10 = 0

		arg_28_3[iter_28_3] = {}

		local var_28_11 = arg_28_0._hero_roster_detail_widgets_defs[iter_28_2]
		local var_28_12 = UIWidget.init(var_28_11)

		var_28_12.content.hero_name = Localize(var_28_5.ingame_short_display_name)
		var_28_12.content.profile_index = iter_28_3
		arg_28_2[#arg_28_2 + 1] = var_28_12

		for iter_28_4 = 1, #var_28_9 do
			local var_28_13 = var_28_9[iter_28_4]
			local var_28_14 = arg_28_0._hero_group_widgets_defs[iter_28_2][iter_28_4]
			local var_28_15 = UIWidget.init(var_28_14)

			arg_28_1[#arg_28_1 + 1] = var_28_15
			arg_28_3[iter_28_3][iter_28_4] = var_28_15

			local var_28_16 = var_28_15.content

			var_28_16.group_index = iter_28_2
			var_28_16.career_index = iter_28_4

			if var_28_13 and var_28_13:override_available_for_mechanism() then
				var_28_16.career_settings = var_28_13
				var_28_16.profile_index = iter_28_3
				var_28_16.portrait = var_28_13.picking_image
				var_28_16.locked = not var_28_13:is_unlocked_function(var_28_6, var_28_8)
				var_28_16.taken = false
			else
				var_28_16.career_settings = var_28_13
				var_28_16.profile_index = iter_28_3
				var_28_16.portrait = var_28_13.picking_image
				var_28_16.locked = true
			end

			var_28_15.style.local_player_select_frame.color = Colors.get_color_table_with_alpha("local_player_picking", 255)
			var_28_10 = var_28_10 + 1
		end

		var_28_4 = math.max(var_28_4, var_28_10)
	end

	assert(var_28_3 <= 5 and var_28_4 <= 4, "Too many rows or columns in VersusPartyCharSelectionView")

	arg_28_0._num_max_hero_rows = var_28_3
	arg_28_0._num_max_hero_columns = var_28_4
end

function VersusPartyCharSelectionView._is_item_selected(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._party_selection_logic:get_party_data(arg_29_0._party_id)

	if not var_29_0 then
		return false
	end

	local var_29_1 = var_29_0.current_picker_index

	for iter_29_0 = 1, var_29_1 do
		local var_29_2 = arg_29_0._data_by_pick_index[iter_29_0]

		if var_29_2.profile_index == arg_29_1 and var_29_2.career_index == arg_29_2 then
			return true
		end
	end

	return false
end

function VersusPartyCharSelectionView.local_player_is_picking(arg_30_0)
	return arg_30_0:_is_slot_picking(arg_30_0._picker_list_id)
end

function VersusPartyCharSelectionView._is_slot_picking(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._party_selection_logic:get_party_data(arg_31_0._party_id)

	if not var_31_0 then
		return
	end

	local var_31_1 = var_31_0.current_picker_index

	if var_31_1 <= 0 then
		return false
	end

	return var_31_1 == arg_31_1
end

function VersusPartyCharSelectionView._local_player_has_picked(arg_32_0)
	return arg_32_0:_has_slot_picked(arg_32_0:_get_local_player_picker_index())
end

function VersusPartyCharSelectionView._has_slot_picked(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._party_selection_logic:get_party_data(arg_33_0._party_id)

	if not var_33_0 then
		return false
	end

	local var_33_1 = var_33_0.current_picker_index

	if var_33_1 <= 0 then
		return false
	end

	return arg_33_1 < var_33_1
end

function VersusPartyCharSelectionView._get_local_player_picker_index(arg_34_0)
	return arg_34_0._picker_list_id
end

function VersusPartyCharSelectionView._handle_gamepad_selection(arg_35_0)
	local var_35_0 = arg_35_0:local_player_is_picking()
	local var_35_1 = arg_35_0._gamepad_selected_index or 1
	local var_35_2 = arg_35_0:input_service()

	if var_35_2:get("move_right") then
		arg_35_0:play_sound("Play_hud_hover")

		if var_35_1 < #arg_35_0._hero_group_widgets then
			var_35_1 = var_35_1 + 1
		end
	elseif var_35_2:get("move_left") then
		arg_35_0:play_sound("Play_hud_hover")

		if var_35_1 > 1 then
			var_35_1 = var_35_1 - 1
		end
	elseif var_35_2:get("cycle_next") then
		arg_35_0:play_sound("Play_hud_hover")

		if var_35_1 < #arg_35_0._hero_group_widgets - 3 then
			var_35_1 = bit.bor(var_35_1 - 1, 3) + 1 + 1
		end
	elseif var_35_2:get("cycle_previous") and var_35_1 > 4 then
		var_35_1 = math.max(0, bit.bor(var_35_1 - 1, 3) + 1 - 4) + -3
	end

	if var_35_1 ~= arg_35_0._gamepad_selected_index then
		local var_35_3 = arg_35_0._hero_group_widgets[var_35_1]
		local var_35_4 = arg_35_0._hero_group_widgets[arg_35_0._gamepad_selected_index or 1]

		var_35_3.content.gamepad_selected = true

		if arg_35_0._gamepad_selected_index then
			var_35_4.content.gamepad_selected = false
		end
	end

	if var_35_2:get("confirm") and var_35_0 then
		local var_35_5 = arg_35_0._hero_group_widgets[var_35_1].content

		if not var_35_5.taken and not var_35_5.other_picking and not var_35_5.locked then
			local var_35_6 = var_35_5.profile_index
			local var_35_7 = var_35_5.career_index

			arg_35_0._party_selection_logic:select_character(var_35_6, var_35_7)
			arg_35_0:play_sound("play_gui_hero_select_career_click")
		end
	end

	arg_35_0._gamepad_selected_index = var_35_1
end

function VersusPartyCharSelectionView._reset_selection(arg_36_0)
	if not arg_36_0._gamepad_selected_index then
		return
	end

	arg_36_0._hero_group_widgets[arg_36_0._gamepad_selected_index].content.gamepad_selected = false
end

function VersusPartyCharSelectionView._handle_mouse_selection(arg_37_0)
	arg_37_0:_reset_selection()

	local var_37_0 = arg_37_0:local_player_is_picking()
	local var_37_1 = arg_37_0._hero_group_widgets
	local var_37_2 = arg_37_0._num_max_hero_rows
	local var_37_3 = arg_37_0._num_max_hero_columns
	local var_37_4
	local var_37_5
	local var_37_6 = arg_37_0:_get_local_player_picker_index()

	if var_37_6 then
		var_37_4 = arg_37_0._data_by_pick_index[var_37_6].profile_index
		var_37_5 = arg_37_0._data_by_pick_index[var_37_6].career_index
	end

	local var_37_7 = false
	local var_37_8
	local var_37_9
	local var_37_10 = 1

	for iter_37_0 = 1, var_37_2 do
		for iter_37_1 = 1, var_37_3 do
			local var_37_11 = var_37_1[var_37_10]

			if var_37_11 then
				local var_37_12 = var_37_11.content
				local var_37_13 = var_37_12.profile_index
				local var_37_14 = var_37_12.career_index
				local var_37_15 = var_37_12.button_hotspot

				if not arg_37_0:_local_player_has_picked() then
					if var_37_15.on_hover_enter then
						var_37_8 = arg_37_0._profile_indices[iter_37_0]
						var_37_9 = iter_37_1
						var_37_7 = true
					elseif not var_37_7 and arg_37_0:_is_hovering_item(arg_37_0._profile_indices[iter_37_0], iter_37_1) and not var_37_15.is_hover then
						var_37_7 = true
					end
				end

				if (var_37_13 ~= var_37_4 or var_37_14 ~= var_37_5) and not var_37_12.taken and not var_37_12.other_picking and not var_37_12.locked then
					if var_37_15.on_hover_enter then
						arg_37_0:play_sound("Play_hud_hover")
					end

					if var_37_15.on_pressed and var_37_0 then
						local var_37_16 = arg_37_0._profile_indices[iter_37_0]
						local var_37_17 = iter_37_1

						arg_37_0._party_selection_logic:select_character(var_37_16, var_37_17)
						arg_37_0:play_sound("play_gui_hero_select_career_click")

						return
					end
				end
			end

			var_37_10 = var_37_10 + 1
		end
	end

	if var_37_7 then
		arg_37_0:_set_item_hovered(arg_37_0._peer_id, arg_37_0._local_player_id, var_37_8, var_37_9)
	end

	arg_37_0:_update_mute_buttons()
end

function VersusPartyCharSelectionView._setup_picking_progress_bar(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._other_widgets
	local var_38_1 = "progress_point"
	local var_38_2 = var_0_3(var_38_1)
	local var_38_3 = 5
	local var_38_4 = "progress_bar_rect"
	local var_38_5 = var_0_6[var_38_4].size[1]
	local var_38_6 = arg_38_1
	local var_38_7 = math.ceil(var_38_5 / var_38_6)
	local var_38_8 = -2
	local var_38_9 = {}

	for iter_38_0 = 1, var_38_6 do
		var_38_8 = var_38_8 + var_38_7 + var_38_3 / 2

		local var_38_10

		if iter_38_0 < var_38_6 then
			var_38_10 = UIWidget.init(var_38_2)
			var_38_0[#var_38_0 + 1] = var_38_10
			var_38_10.offset[1] = math.ceil(var_38_8)
		end

		var_38_9[iter_38_0] = {
			point_widget = var_38_10,
			bar_distance = var_38_8,
			step_size = var_38_7,
			bar_distance_fraction = var_38_8 / var_38_5
		}
	end

	arg_38_0._picking_progress_data = var_38_9

	local var_38_11 = arg_38_0._ui_scenegraph
	local var_38_12 = var_38_11.progress_bar.size
	local var_38_13 = var_38_11.progress_bar_passive.size

	var_38_12[1] = 0
	var_38_13[1] = 0
end

function VersusPartyCharSelectionView._start_step_transtion_animation(arg_39_0, arg_39_1)
	local var_39_0 = var_0_10
	local var_39_1 = {
		self = arg_39_0
	}
	local var_39_2 = arg_39_0.ui_animator:start_animation(arg_39_1, var_39_0, var_0_6, var_39_1)

	arg_39_0._animations[arg_39_1] = var_39_2
end

function VersusPartyCharSelectionView._start_widget_animation(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = var_0_10
	local var_40_1 = arg_40_0.ui_animator:start_animation(arg_40_1, arg_40_2, var_0_6, var_40_0)

	arg_40_0._animations[arg_40_1] = var_40_1
end

function VersusPartyCharSelectionView._set_top_detail_widgets_visible(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1 and 1 or 0

	for iter_41_0, iter_41_1 in ipairs(arg_41_0._top_detail_widgets) do
		iter_41_1.alpha_multiplier = var_41_0
	end
end

function VersusPartyCharSelectionView._is_item_hovered_by_other(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_0._party
	local var_42_1 = arg_42_0._party_selection_logic:get_party_data(arg_42_0._party_id)
	local var_42_2 = var_42_0.num_slots
	local var_42_3 = var_42_1.picker_list

	for iter_42_0 = 1, var_42_2 do
		local var_42_4 = var_42_3[iter_42_0].status
		local var_42_5 = var_42_4.hovered_profile_index or 0
		local var_42_6 = var_42_4.hovered_career_index or 0

		if var_42_5 == arg_42_1 and var_42_6 == arg_42_2 then
			if var_42_4.slot_id == arg_42_0._slot_id or arg_42_0:_has_slot_picked(iter_42_0) then
				return false, nil
			else
				return true, iter_42_0
			end
		end
	end

	return false, nil
end

function VersusPartyCharSelectionView._set_player_name(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_1:name()

	if UTF8Utils.string_length(var_43_0) > 18 then
		var_43_0 = string.sub(var_43_0, 1, 18) .. "..."
	end

	return var_43_0
end

function VersusPartyCharSelectionView._set_your_turn_text_position(arg_44_0)
	arg_44_0._widgets_by_name.your_turn_indicator_text.scenegraph_id = "player_name_box_" .. arg_44_0._picker_list_id
end

function VersusPartyCharSelectionView._set_selected_hero_and_career_text(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0._widgets_by_name.hero_career_name_text
	local var_45_1 = "%s - %s"
	local var_45_2 = SPProfiles[arg_45_1]
	local var_45_3 = Localize(var_45_2.ingame_short_display_name)
	local var_45_4 = var_45_2.careers[arg_45_2]
	local var_45_5 = Localize(var_45_4.display_name)

	var_45_0.content.text = Utf8.upper(string.format(var_45_1, var_45_3, var_45_5))
end

function VersusPartyCharSelectionView._set_current_picker_text(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._widgets_by_name.player_picking_text

	if arg_46_1 == arg_46_0._picker_list_id then
		local var_46_1 = Colors.get_color_table_with_alpha("local_player_picking", 255)

		var_46_0.content.text = string.format(Localize("versus_hero_selection_view_local_player_picking"), var_46_1[2], var_46_1[3], var_46_1[4], var_46_1[1])
	else
		local var_46_2 = arg_46_0._party_selection_logic:get_party_data(arg_46_0._party_id).picker_list[arg_46_1].status.player
		local var_46_3 = var_46_2 and var_46_2:name() or "BOT"
		local var_46_4 = Colors.get_color_table_with_alpha("other_player_picking", 255)

		var_46_0.content.text = string.format(Localize("versus_hero_selection_view_other_player_picking"), var_46_4[2], var_46_4[3], var_46_4[4], var_46_4[1], var_46_3)
	end
end

function VersusPartyCharSelectionView._update_selcted_career_passive_and_career_skill(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._widgets_by_name.passive_skill
	local var_47_1 = arg_47_0._widgets_by_name.career_skill
	local var_47_2 = arg_47_0._widgets_by_name.hero_career_name_text
	local var_47_3 = var_47_0.content
	local var_47_4 = var_47_1.content
	local var_47_5 = SPProfiles[arg_47_1].careers[arg_47_2]
	local var_47_6 = CareerUtils.get_passive_ability_by_career(var_47_5)
	local var_47_7 = CareerUtils.get_ability_data_by_career(var_47_5, 1)
	local var_47_8 = var_47_7.icon
	local var_47_9 = Localize(var_47_7.display_name)
	local var_47_10 = Localize("ability")
	local var_47_11 = var_47_6.icon
	local var_47_12 = Localize(var_47_6.display_name)
	local var_47_13 = Localize("hero_view_passive_ability")

	var_47_4.skill_icon = var_47_8
	var_47_4.skill_type = var_47_10
	var_47_4.skill_name = var_47_9
	var_47_3.skill_icon = var_47_11
	var_47_3.skill_type = var_47_13
	var_47_3.skill_name = var_47_12

	local var_47_14 = var_47_2.style.text
	local var_47_15 = var_47_2.content.text
	local var_47_16 = UIUtils.get_text_width(arg_47_0._ui_renderer, var_47_14, var_47_15)
	local var_47_17 = var_47_1.style.skill_type
	local var_47_18 = UIUtils.get_text_width(arg_47_0._ui_renderer, var_47_17, var_47_10)
	local var_47_19 = var_47_1.style.skill_name
	local var_47_20 = UIUtils.get_text_width(arg_47_0._ui_renderer, var_47_19, var_47_9)
	local var_47_21 = 85 + var_47_18 > 150 and 85 + var_47_18 or 200
	local var_47_22 = 85 + var_47_20 > 150 and 85 + var_47_20 or 200
	local var_47_23

	if var_47_22 < var_47_21 then
		var_47_23 = var_47_21
	else
		var_47_23 = var_47_22
	end

	local var_47_24 = var_47_16 + 25
	local var_47_25 = var_47_16 + 25 + var_47_23 + 25

	var_47_0.offset[1] = var_47_25
	var_47_1.offset[1] = var_47_24
end

function VersusPartyCharSelectionView._setup_world(arg_48_0)
	if arg_48_0._background_world then
		arg_48_0:_destroy_world()
	end

	local var_48_0 = "versus_char_selection"
	local var_48_1 = "environment/ui_end_screen"
	local var_48_2 = 2
	local var_48_3 = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM,
		Application.ENABLE_VOLUMETRICS
	}
	local var_48_4 = Managers.world:create_world(var_48_0, var_48_1, nil, var_48_2, unpack(var_48_3))

	World.set_data(var_48_4, "avoid_blend", true)

	local var_48_5 = Managers.world:world("top_ingame_view")

	return var_48_4, var_48_5
end

function VersusPartyCharSelectionView._create_viewport(arg_49_0, arg_49_1)
	local var_49_0 = "versus_char_selection_ui"
	local var_49_1 = "default"
	local var_49_2 = 960
	local var_49_3 = ScriptWorld.create_viewport(arg_49_1, var_49_0, var_49_1, var_49_2)

	arg_49_0._team_world_viewport_name = var_49_0

	return var_49_3
end

function VersusPartyCharSelectionView._spawn_level(arg_50_0, arg_50_1)
	local var_50_0 = "levels/carousel_podium/world"
	local var_50_1 = {}
	local var_50_2
	local var_50_3
	local var_50_4
	local var_50_5
	local var_50_6 = false
	local var_50_7 = ScriptWorld.spawn_level(arg_50_1, var_50_0, var_50_1, var_50_2, var_50_3, var_50_4, var_50_5, var_50_6)

	Level.spawn_background(var_50_7)
	Level.trigger_level_loaded(var_50_7)

	return var_50_7
end

local var_0_13 = "levels/carousel_podium/world"

function VersusPartyCharSelectionView._setup_background_world(arg_51_0)
	local var_51_0, var_51_1 = arg_51_0:_setup_world()
	local var_51_2 = arg_51_0:_spawn_level(var_51_0)
	local var_51_3 = arg_51_0:_create_viewport(var_51_0)

	arg_51_0._background_world = var_51_0
	arg_51_0._top_world = var_51_1
	arg_51_0._team_world_viewport = var_51_3
	arg_51_0._level = var_51_2

	arg_51_0:_setup_camera_nodes_data(var_51_2)
	arg_51_0:_setup_initial_camera(var_51_0, var_51_3)
	Level.trigger_event(var_51_2, "disable_character_select_lights")
end

function VersusPartyCharSelectionView._get_heroes_spawn_locations(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_1 == arg_52_0._party_id and "character_slot_0" or "character_slot_enemy_0"
	local var_52_1 = "units/hub_elements/versus_podium_character_spawn"
	local var_52_2 = LevelResource.unit_indices(var_0_13, var_52_1)
	local var_52_3 = {}

	for iter_52_0 = 1, 4 do
		for iter_52_1, iter_52_2 in pairs(var_52_2) do
			local var_52_4 = LevelResource.unit_data(var_0_13, iter_52_2)
			local var_52_5 = DynamicData.get(var_52_4, "name")

			if var_52_5 and var_52_5 == var_52_0 .. iter_52_0 then
				local var_52_6 = LevelResource.unit_position(var_0_13, iter_52_2)
				local var_52_7, var_52_8, var_52_9 = Vector3.to_elements(var_52_6)
				local var_52_10 = {
					var_52_7,
					var_52_8,
					var_52_9
				}

				var_52_3[#var_52_3 + 1] = var_52_10
			end
		end
	end

	fassert(#var_52_3 ~= 0, "[VersusPartyCharSelectionView:_get_heroes_spawn_locations], No hero locations have been found. Check if unit: %s is present in level: %s and has the script data varaible \"name\" set to the correct name.", var_52_1, var_0_13)

	return var_52_3
end

function VersusPartyCharSelectionView._activate_viewport(arg_53_0)
	ScriptWorld.activate_viewport(arg_53_0._background_world, arg_53_0._team_world_viewport)
end

function VersusPartyCharSelectionView.set_camera_position(arg_54_0, arg_54_1)
	local var_54_0 = ScriptViewport.camera(arg_54_0._team_world_viewport)

	return ScriptCamera.set_local_position(var_54_0, arg_54_1)
end

function VersusPartyCharSelectionView.set_camera_rotation(arg_55_0, arg_55_1)
	local var_55_0 = ScriptViewport.camera(arg_55_0._team_world_viewport)

	ScriptCamera.set_local_rotation(var_55_0, arg_55_1)

	local var_55_1 = arg_55_0:_get_viewport_world()

	ScriptCamera.force_update(var_55_1, var_55_0)
end

function VersusPartyCharSelectionView._setup_initial_camera(arg_56_0, arg_56_1, arg_56_2)
	local var_56_0 = arg_56_0._cameras.initial_camera
	local var_56_1 = ScriptViewport.camera(arg_56_2)

	arg_56_0._camera = var_56_1

	local var_56_2 = Camera.vertical_fov(var_56_0.camera)

	Camera.set_vertical_fov(var_56_1, var_56_2)
	ScriptCamera.set_local_pose(var_56_1, var_56_0.camera_pose:unbox())
	ScriptCamera.force_update(arg_56_1, var_56_1)
end

function VersusPartyCharSelectionView._setup_camera_nodes_data(arg_57_0, arg_57_1)
	local var_57_0 = {}
	local var_57_1 = Level.flow_variable(arg_57_1, "initial_camera")
	local var_57_2 = Level.flow_variable(arg_57_1, "parading_position_01")
	local var_57_3 = Level.flow_variable(arg_57_1, "parading_position_02")
	local var_57_4 = Matrix4x4Box(Unit.local_pose(var_57_1, 0))
	local var_57_5 = Matrix4x4Box(Unit.local_pose(var_57_2, 0))
	local var_57_6 = Matrix4x4Box(Unit.local_pose(var_57_3, 0))
	local var_57_7 = Unit.camera(var_57_1, "camera")
	local var_57_8 = Unit.camera(var_57_2, "camera")
	local var_57_9 = Unit.camera(var_57_3, "camera")

	arg_57_0._inital_camera_position = Vector3Box(Unit.local_position(var_57_1, 0))
	var_57_0.initial_camera = {
		camera_unit = var_57_1,
		camera_pose = var_57_4,
		camera = var_57_7
	}
	var_57_0.parading_camera_01 = {
		camera_unit = var_57_2,
		camera_pose = var_57_5,
		camera = var_57_8
	}
	var_57_0.parading_camera_02 = {
		camera_unit = var_57_3,
		camera_pose = var_57_6,
		camera = var_57_9
	}
	arg_57_0._cameras = var_57_0
end

function VersusPartyCharSelectionView._destroy_world(arg_58_0)
	Managers.world:destroy_world(arg_58_0._background_world)

	arg_58_0._background_world = nil
	arg_58_0._top_world = nil
end

function VersusPartyCharSelectionView._setup_team_previewer(arg_59_0, arg_59_1)
	if arg_59_0._team_previewer then
		return
	end

	arg_59_1 = arg_59_1 or false
	arg_59_0._team_previewer = TeamPreviewer:new(arg_59_0._ingame_ui_context, arg_59_0._background_world, arg_59_0._team_world_viewport)

	local var_59_0 = arg_59_0._team_heroes
	local var_59_1 = arg_59_0:_get_heroes_spawn_locations(arg_59_0._party_id)

	arg_59_0._team_previewer:setup_team(var_59_0, var_59_1, arg_59_1)

	arg_59_0._hero_locations = var_59_1
end

function VersusPartyCharSelectionView._setup_team_heroes(arg_60_0)
	local var_60_0 = arg_60_0._party_selection_logic:get_party_data(arg_60_0._party_id).picker_list
	local var_60_1 = arg_60_0._team_heroes

	table.clear(var_60_1)

	for iter_60_0, iter_60_1 in ipairs(var_60_0) do
		local var_60_2 = arg_60_0:_get_hero_previewer_data(iter_60_1, arg_60_0._party)

		var_60_1[#var_60_1 + 1] = var_60_2 or true
	end
end

function VersusPartyCharSelectionView._get_hero_previewer_data(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = arg_61_1.status
	local var_61_1 = var_61_0.selected_profile_index
	local var_61_2 = var_61_0.selected_career_index
	local var_61_3 = SPProfiles[var_61_1]

	if not var_61_3 or var_61_3.affiliation == "dark_pact" then
		return nil
	end

	local var_61_4 = arg_61_1.slot_id
	local var_61_5 = arg_61_2.slots_data[var_61_4]

	if var_61_3 then
		local var_61_6 = var_61_3.careers[var_61_2]
		local var_61_7 = var_61_6.versus_preview_animation or var_61_6.preview_animation
		local var_61_8 = var_61_6.preview_wield_slot
		local var_61_9 = var_61_6.profile_name
		local var_61_10 = var_61_5.slot_hat
		local var_61_11 = {
			var_61_6.preview_items[1],
			{
				item_name = var_61_10 ~= "n/a" and var_61_10 or var_61_6.preview_items[2].item_name
			}
		}
		local var_61_12 = var_61_5.slot_skin ~= "n/a" and var_61_5.slot_skin or var_61_6.base_skin

		return {
			profile_index = var_61_1,
			career_index = var_61_2,
			skin_name = var_61_12,
			hero_name = var_61_9,
			weapon_slot = var_61_8,
			preview_items = var_61_11,
			preview_animation = var_61_7
		}
	end

	return nil
end

function VersusPartyCharSelectionView._update_team_previewer(arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = arg_62_0._team_previewer

	if var_62_0 then
		var_62_0:update(arg_62_1, arg_62_2)
		var_62_0:post_update(arg_62_1, arg_62_2)
	end
end

function VersusPartyCharSelectionView._destroy_team_previewer(arg_63_0)
	if arg_63_0._team_previewer then
		arg_63_0._team_previewer:on_exit()

		arg_63_0._team_previewer = nil
	end
end

function VersusPartyCharSelectionView._spawn_selected_hero(arg_64_0, arg_64_1)
	local var_64_0 = arg_64_0._party_selection_logic:get_party_data(arg_64_0._party_id).picker_list[arg_64_1]
	local var_64_1 = arg_64_0:_get_hero_previewer_data(var_64_0, arg_64_0._party)

	if var_64_1 then
		local var_64_2 = arg_64_0._team_previewer:get_hero_previewer(arg_64_1)

		arg_64_0._team_previewer:_spawn_hero(var_64_2, var_64_1)

		arg_64_0._team_heroes[arg_64_1] = var_64_1
	end
end

function VersusPartyCharSelectionView._play_selected_hero_sound(arg_65_0, arg_65_1, arg_65_2)
	if arg_65_2 and arg_65_1 then
		local var_65_0 = SPProfiles[arg_65_2].careers[arg_65_1].display_name
		local var_65_1 = "menu_versus_character_selection_" .. var_65_0

		arg_65_0:play_sound(var_65_1)
	end
end

function VersusPartyCharSelectionView._level_flow_event(arg_66_0, arg_66_1)
	local var_66_0 = arg_66_0._level

	Level.trigger_event(var_66_0, arg_66_1)
end

local function var_0_14(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6)
	local var_67_0
	local var_67_1 = arg_67_5 - arg_67_4
	local var_67_2

	if var_67_1 <= 0.001 then
		var_67_2 = 1
	else
		local var_67_3 = math.clamp((arg_67_6 - arg_67_4) / var_67_1, 0, 1)

		var_67_2 = (3 - 2 * var_67_3) * var_67_3^2
	end

	local var_67_4 = Matrix4x4.lerp(arg_67_2, arg_67_3, var_67_2)

	ScriptCamera.set_local_pose(arg_67_0, var_67_4)
	Camera.set_vertical_fov(arg_67_0, arg_67_1)
end

function VersusPartyCharSelectionView._update_camera(arg_68_0, arg_68_1)
	if not arg_68_0._camera_anim_id then
		return
	end

	local var_68_0 = arg_68_0._camera
	local var_68_1 = arg_68_0._camera_animations[arg_68_0._camera_anim_id]

	if var_68_1.animation_end_time and arg_68_1 > var_68_1.animation_end_time then
		arg_68_0._camera_animations[arg_68_0._camera_anim_id] = nil
		arg_68_0._camera_anim_id = nil

		return
	end

	if not var_68_1.animation_start_time then
		var_68_1.animation_start_time = arg_68_1
		var_68_1.animation_end_time = arg_68_1 + 2
	end

	var_0_14(var_68_0, var_68_1.fov, var_68_1.source_pose:unbox(), var_68_1.target_pose:unbox(), var_68_1.animation_start_time, var_68_1.animation_end_time, arg_68_1)
	ScriptCamera.force_update(arg_68_0._background_world, var_68_0)
end

function VersusPartyCharSelectionView._set_on_selection_complete_camera_animation(arg_69_0)
	local var_69_0 = {
		fov = Camera.vertical_fov(arg_69_0._cameras.initial_camera.camera),
		source_pose = arg_69_0._cameras.initial_camera.camera_pose,
		target_pose = arg_69_0._cameras.parading_camera_01.camera_pose
	}
	local var_69_1 = arg_69_0._cam_anim_indx

	arg_69_0._camera_anim_id = var_69_1
	arg_69_0._camera_animations[var_69_1] = var_69_0
	arg_69_0._cam_anim_indx = arg_69_0._cam_anim_indx + 1
end

function VersusPartyCharSelectionView._muted_peer_id(arg_70_0, arg_70_1)
	if IS_XB1 then
		if Managers.voice_chat then
			return Managers.voice_chat:is_peer_muted(arg_70_1)
		else
			return false
		end
	else
		return arg_70_0._voip:peer_muted(arg_70_1)
	end
end

function VersusPartyCharSelectionView._ignore_voice_message_from_peer_id(arg_71_0, arg_71_1)
	if IS_XB1 then
		if Managers.voice_chat then
			Managers.voice_chat:mute_peer(arg_71_1)
		end
	else
		arg_71_0._voip:mute_member(arg_71_1)
	end
end

function VersusPartyCharSelectionView._remove_ignore_voice_message_from_peer_id(arg_72_0, arg_72_1)
	if IS_XB1 then
		if Managers.voice_chat then
			Managers.voice_chat:unmute_peer(arg_72_1)
		end
	else
		arg_72_0._voip:unmute_member(arg_72_1)
	end
end

function VersusPartyCharSelectionView._update_mute_buttons(arg_73_0)
	for iter_73_0 = 1, #arg_73_0._player_name_box_widgets do
		local var_73_0 = arg_73_0._player_name_box_widgets[iter_73_0]
		local var_73_1 = var_73_0.content
		local var_73_2 = var_73_1.peer_id

		if var_73_2 and UIUtils.is_button_pressed(var_73_0) then
			if arg_73_0:_muted_peer_id(var_73_2) then
				arg_73_0:_remove_ignore_voice_message_from_peer_id(var_73_2)

				var_73_1.muted = false
			else
				arg_73_0:_ignore_voice_message_from_peer_id(var_73_2)

				var_73_1.muted = true
			end
		end
	end
end

function VersusPartyCharSelectionView.on_party_selection_logic_state_set(arg_74_0, arg_74_1, arg_74_2, arg_74_3)
	if arg_74_0._party_id ~= arg_74_2 then
		return
	end

	if arg_74_1 == "startup" then
		-- block empty
	elseif arg_74_1 == "player_picking_character" then
		if not arg_74_0._initial_selection_transition_done then
			arg_74_0._initial_selection_transition_done = true

			arg_74_0:_start_step_transtion_animation("transition_to_selection")
		end

		arg_74_0:_start_widget_animation("name_box_fade_to_black", arg_74_0._player_name_box_widgets[arg_74_3])
		arg_74_0:_level_flow_event("chr_" .. arg_74_3 .. "_selected")
		arg_74_0:_set_current_picker_text(arg_74_3)
		arg_74_0:_update_all_player_name_box_widgets()

		if arg_74_0:local_player_is_picking() then
			arg_74_0:play_sound("menu_versus_character_selection_your_turn_indicator")
			arg_74_0:play_sound("menu_versus_character_selection_meter_start")
		end
	elseif arg_74_1 == "player_has_picked_character" then
		arg_74_0:play_sound("menu_versus_character_selection_locked")

		if arg_74_0:local_player_is_picking() then
			arg_74_0:play_sound("menu_versus_character_selection_meter_stop")
		end

		arg_74_0:_play_selected_hero_sound(arg_74_0._data_by_pick_index[arg_74_3].career_index, arg_74_0._data_by_pick_index[arg_74_3].profile_index)
		arg_74_0:_start_widget_animation("name_box_fade_to_gray", arg_74_0._player_name_box_widgets[arg_74_3])
		arg_74_0:_level_flow_event("chr_" .. arg_74_3 .. "_unselected")
	elseif arg_74_1 == "parading" then
		arg_74_0:_level_flow_event("vs_team_heroes_selected")
		arg_74_0:play_sound("menu_versus_character_selection_start_game_buildup")

		arg_74_0._prev_timer_value = 0

		arg_74_0:_set_on_selection_complete_camera_animation()
		arg_74_0:_start_step_transtion_animation("transition_to_team_parading")
		arg_74_0:play_sound("Play_menu_versus_parading_start_transition")
	end
end
