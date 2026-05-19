-- chunkname: @scripts/ui/views/level_end/level_end_view_versus.lua

require("scripts/settings/dlcs/carousel/end_screen_award_settings")

local var_0_0 = local_require("scripts/ui/views/level_end/level_end_view_versus_definitions")
local var_0_1 = var_0_0.widget_definitions
local var_0_2 = var_0_0.scenegraph_definitions
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.camera_movement_functions
local var_0_5 = {
	vs_rat_ogre = 75,
	vs_chaos_troll = 75
}
local var_0_6 = {
	vs_rat_ogre = -0.5
}

LevelEndViewVersus = class(LevelEndViewVersus, LevelEndViewBase)

function LevelEndViewVersus._setup_pages_victory(arg_1_0, arg_1_1)
	if not arg_1_0._is_untrusted then
		return {
			EndViewStateScoreVS = 2,
			EndViewStateParadingVS = 1
		}
	else
		return {
			EndViewStateScoreVS = 2,
			EndViewStateParadingVS = 1
		}
	end
end

function LevelEndViewVersus._setup_pages_defeat(arg_2_0, arg_2_1)
	if not arg_2_0._is_untrusted then
		return {
			EndViewStateScoreVS = 2,
			EndViewStateParadingVS = 1
		}
	else
		return {
			EndViewStateScoreVS = 2,
			EndViewStateParadingVS = 1
		}
	end
end

local var_0_7 = {}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_8 = iter_0_1.portrait_materials

	if var_0_8 then
		for iter_0_2, iter_0_3 in ipairs(var_0_8) do
			var_0_7[#var_0_7 + 1] = iter_0_3
		end
	end
end

local var_0_9 = 1
local var_0_10 = 4
local var_0_11 = 5

function LevelEndViewVersus.init(arg_3_0, arg_3_1)
	arg_3_0._team_heroes = {}
	arg_3_0._team_previewer = nil
	arg_3_0._peers_with_score = {}
	arg_3_0._parading_done_timer = nil
	arg_3_0._camera_movement_functions = table.clone(var_0_4)

	LevelEndViewWeave.super.init(arg_3_0, arg_3_1)

	arg_3_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_3_0.ui_top_renderer, Managers.input:get_service("end_of_level"), 3, 900, var_0_0.generic_input_actions.default)

	arg_3_0._menu_input_description:set_input_description(nil)
	Managers.state.event:register(arg_3_0, "set_flow_object_set_enabled", "event_show_flow_object_set")
	Managers.transition:force_fade_in()
end

function LevelEndViewVersus._calculate_awards(arg_4_0)
	local var_4_0 = {}
	local var_4_1 = arg_4_0.context.players_session_score

	for iter_4_0 = 1, #EndScreenAwardSettings do
		local var_4_2 = EndScreenAwardSettings[iter_4_0]
		local var_4_3, var_4_4 = var_4_2.evaluate(var_4_1)

		if var_4_3 then
			var_4_0[var_4_3] = var_4_0[var_4_3] or {}
			var_4_0[var_4_3][#var_4_0[var_4_3] + 1] = {
				value = 10 - var_4_2.prio,
				header = var_4_2.name,
				sound = var_4_2.sound,
				sub_header = var_4_2.sub_header and string.format(var_4_2.sub_header, var_4_4),
				screen_sub_header = var_4_2.screen_sub_header,
				award_material = var_4_2.award_material,
				award_mask_material = var_4_2.award_mask_material,
				award_settings = var_4_2,
				amount = var_4_4
			}
		end
	end

	table.dump(var_4_1, "PLAYERS_SESSION_SCORES", 2)
	arg_4_0:_calculate_mvp(var_4_0, var_4_1)

	local var_4_5 = {}

	for iter_4_1, iter_4_2 in pairs(var_4_0) do
		local var_4_6 = 0

		for iter_4_3 = 1, #iter_4_2 do
			local var_4_7 = iter_4_2[iter_4_3].value

			var_4_6 = var_4_6 < var_4_7 and var_4_7 or var_4_6
		end

		var_4_5[#var_4_5 + 1] = {
			stats_id = iter_4_1,
			max_award_value = var_4_6,
			awards = iter_4_2
		}
	end

	local function var_4_8(arg_5_0, arg_5_1)
		return arg_5_0.max_award_value > arg_5_1.max_award_value
	end

	table.sort(var_4_5, var_4_8)

	arg_4_0._sorted_awards = var_4_5

	arg_4_0:_save_award_stats()
	table.dump(arg_4_0._sorted_awards, "AWARDS", 3)

	local var_4_9 = {}

	for iter_4_4, iter_4_5 in pairs(var_4_1) do
		var_4_9[#var_4_9 + 1] = iter_4_5
		var_4_9[#var_4_9].stats_id = iter_4_4
	end

	local function var_4_10(arg_6_0, arg_6_1)
		return arg_6_0.stats_id > arg_6_1.stats_id
	end

	table.sort(var_4_9, var_4_10)
	table.dump(var_4_9, "SCORES", 2)
end

function LevelEndViewVersus._save_award_stats(arg_7_0)
	local var_7_0 = Managers.backend:get_interface("statistics")
	local var_7_1 = var_7_0:get_stats()
	local var_7_2 = StatisticsDatabase:new()
	local var_7_3 = 1
	local var_7_4 = PlayerUtils.unique_player_id(Network.peer_id(), var_7_3)

	var_7_2:register(var_7_4, "player", var_7_1)

	local var_7_5

	for iter_7_0, iter_7_1 in ipairs(arg_7_0._sorted_awards) do
		if iter_7_1.stats_id == var_7_4 then
			var_7_5 = iter_7_1.awards

			break
		end
	end

	if var_7_5 then
		for iter_7_2, iter_7_3 in ipairs(var_7_5) do
			local var_7_6 = iter_7_3.award_settings.stat_key

			var_7_2:increment_stat(var_7_4, var_7_6)
		end
	end

	var_7_0:save_explicit(var_7_4, var_7_2)
	Managers.backend:commit()
end

function LevelEndViewVersus._calculate_mvp(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = {}
	local var_8_1 = 1
	local var_8_2 = 0

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		var_8_0[iter_8_0] = 0

		for iter_8_2, iter_8_3 in ipairs(iter_8_1) do
			var_8_0[iter_8_0] = var_8_0[iter_8_0] + iter_8_3.value
		end

		if var_8_2 < var_8_0[iter_8_0] then
			var_8_2 = var_8_0[iter_8_0]
		end
	end

	local var_8_3 = {}

	for iter_8_4, iter_8_5 in pairs(var_8_0) do
		if iter_8_5 == var_8_2 then
			var_8_3[#var_8_3 + 1] = iter_8_4
		end
	end

	local var_8_4 = arg_8_0.context.party_composition
	local var_8_5 = arg_8_0.context.players_session_score
	local var_8_6

	if #var_8_3 > 1 then
		local var_8_7 = Network.peer_id()
		local var_8_8 = var_8_4[PlayerUtils.unique_player_id(var_8_7, var_8_1)]
		local var_8_9 = var_8_8 == 1 and 2 or 1
		local var_8_10 = arg_8_0.context.game_won
		local var_8_11 = var_8_10 and var_8_8 or not var_8_10 and var_8_9 or nil
		local var_8_12 = {}

		for iter_8_6, iter_8_7 in ipairs(var_8_3) do
			if var_8_4[iter_8_7] == var_8_11 then
				var_8_12[#var_8_12 + 1] = iter_8_7
			end
		end

		local var_8_13 = {}

		if #var_8_12 == 1 then
			var_8_6 = var_8_12[1]
		elseif #var_8_12 > 1 then
			var_8_13 = var_8_12
		else
			var_8_13 = var_8_3
		end

		if not table.is_empty(var_8_13) then
			local function var_8_14(arg_9_0, arg_9_1)
				local var_9_0 = var_8_5[arg_9_0].scores
				local var_9_1 = var_9_0.damage_dealt_heroes + var_9_0.vs_damage_dealt_to_pactsworn or 0
				local var_9_2 = var_8_5[arg_9_1].scores

				return var_9_1 > (var_9_2.damage_dealt_heroes + var_9_2.vs_damage_dealt_to_pactsworn or 0)
			end

			table.sort(var_8_13, var_8_14)

			var_8_6 = var_8_13[1]
		end
	else
		var_8_6 = var_8_3[1]
	end

	if var_8_6 then
		table.insert(arg_8_1[var_8_6], 1, {
			award_mask_material = "mvp_award_mask",
			sound = "Play_vs_hud_eom_parading_mvp",
			header = "mvp",
			value = 10,
			award_material = "mvp_award",
			award_settings = EndScreenAwardSettingsLookup.vs_award_mvp
		})
	else
		var_8_6 = Network.peer_id() .. ":1"
		arg_8_1[var_8_6] = arg_8_1[var_8_6] or {}

		table.insert(arg_8_1[var_8_6], 1, {
			award_mask_material = "mvp_award_mask",
			sound = "Play_vs_hud_eom_parading_mvp",
			header = "mvp",
			value = 10,
			award_material = "mvp_award",
			award_settings = EndScreenAwardSettingsLookup.vs_award_mvp
		})
	end

	local var_8_15 = arg_8_2[var_8_6] or {}
	local var_8_16 = var_8_15.peer_id or "DEAD"
	local var_8_17 = 0
	local var_8_18 = var_8_15.scores

	if var_8_18 then
		for iter_8_8, iter_8_9 in pairs(var_8_18) do
			var_8_17 = var_8_17 + iter_8_9
		end
	end

	arg_8_0._random_seed = tonumber(var_8_16, 16) + var_8_17
end

function LevelEndViewVersus.set_input_description(arg_10_0, arg_10_1)
	local var_10_0 = var_0_0.generic_input_actions[arg_10_1]

	arg_10_0._menu_input_description:set_input_description(var_10_0)
end

function LevelEndViewVersus._setup_pages_untrusted(arg_11_0)
	return {
		EndViewStateScoreVS = 2,
		EndViewStateParadingVS = 1
	}
end

function LevelEndViewVersus.start(arg_12_0)
	print("[LevelEndView] Started LevelEndViewVersus")
	LevelEndViewVersus.super.start(arg_12_0)

	arg_12_0._start_music_event = "menu_versus_score_screen_amb_loop_start"
	arg_12_0._stop_music_event = "menu_versus_score_screen_amb_loop_stop"
	arg_12_0._playing_music = nil
end

function LevelEndViewVersus.create_ui_renderer(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = {
		"material",
		"materials/ui/ui_1080p_carousel_atlas",
		"material",
		"materials/ui/ui_1080p_hud_atlas_textures",
		"material",
		"materials/ui/ui_1080p_hud_single_textures",
		"material",
		"materials/ui/ui_1080p_menu_atlas_textures",
		"material",
		"materials/ui/ui_1080p_menu_single_textures",
		"material",
		"materials/ui/ui_1080p_achievement_atlas_textures",
		"material",
		"materials/ui/ui_1080p_common",
		"material",
		"materials/ui/ui_1080p_versus_available_common",
		"material",
		"materials/ui/ui_1080p_versus_rewards_atlas",
		"material",
		"materials/fonts/gw_fonts"
	}
	local var_13_1 = arg_13_0.get_extra_materials

	if var_13_1 then
		for iter_13_0, iter_13_1 in ipairs(var_13_1) do
			var_13_0[#var_13_0 + 1] = iter_13_1
		end
	end

	for iter_13_2, iter_13_3 in ipairs(var_0_7) do
		var_13_0[#var_13_0 + 1] = "material"
		var_13_0[#var_13_0 + 1] = iter_13_3
	end

	local var_13_2 = UIRenderer.create(arg_13_2, unpack(var_13_0))
	local var_13_3 = UIRenderer.create(arg_13_3, unpack(var_13_0))

	return var_13_2, var_13_3
end

function LevelEndViewVersus.update(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0:_handle_input(arg_14_1, arg_14_2)

	LevelEndViewVersus.super.update(arg_14_0, var_14_0, arg_14_2)
	arg_14_0:_start_music()
	arg_14_0:_update_animations(var_14_0, arg_14_2)
	arg_14_0:_update_team_previewer(var_14_0, arg_14_2)
	arg_14_0:_update_fade(var_14_0, arg_14_2)
	arg_14_0:_update_camera_zoom(var_14_0, arg_14_2)
	arg_14_0:_update_award_presentation(var_14_0, arg_14_2)
	arg_14_0:_draw(var_14_0, arg_14_2)
end

function LevelEndViewVersus._update_fade(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_0._fade_out_triggered then
		return
	end

	if not arg_15_0._team_previewer or not arg_15_0._team_previewer:loading_done() then
		Managers.transition:force_fade_in()
	else
		Managers.transition:fade_out(2)

		arg_15_0._fade_out_triggered = true
	end
end

function LevelEndViewVersus._update_award_presentation(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0._fade_out_triggered then
		return
	end

	if arg_16_0._camera_progress < 1 then
		return
	end

	if not arg_16_0._award_presentation_data then
		arg_16_0:_start_award_presentation()
	end

	local var_16_0 = arg_16_0._award_presentation_data

	if not var_16_0 then
		return
	end

	local var_16_1 = var_16_0.start_pos:unbox()
	local var_16_2 = var_16_0.end_pos:unbox()
	local var_16_3 = var_16_0.neck_pose:unbox()
	local var_16_4 = var_16_0.distance
	local var_16_5 = var_16_0.time
	local var_16_6 = var_16_0.timer
	local var_16_7 = 1 - var_16_6 / var_16_5
	local var_16_8 = math.easeOutCubic(var_16_7)
	local var_16_9 = var_16_0.disable_camera_rotation
	local var_16_10 = Vector3.lerp(var_16_1, var_16_2, var_16_8)
	local var_16_11 = Matrix4x4.translation(var_16_3)
	local var_16_12 = Matrix4x4.rotation(var_16_3)
	local var_16_13 = Quaternion.forward(var_16_12)

	var_16_13[3] = 0

	local var_16_14 = var_16_10 + var_16_13 * math.sin(math.pi * var_16_8) * var_16_4
	local var_16_15

	if var_16_9 then
		var_16_15 = Quaternion.look(Vector3(0, -1, 0), Vector3.up())
	else
		var_16_15 = Quaternion.look(var_16_11 - var_16_14, Vector3.up())
	end

	local var_16_16 = Matrix4x4.from_quaternion_position(var_16_15, var_16_14)

	arg_16_0:position_camera(var_16_16, arg_16_0._fov)

	local var_16_17 = arg_16_0._hero_previewers[arg_16_0._current_hero]:get_character_unit()
	local var_16_18 = Unit.animation_find_constraint_target(var_16_17, "aim_constraint_target")

	Unit.animation_set_constraint_target(var_16_17, var_16_18, var_16_14)

	var_16_0.timer = math.max(var_16_6 - arg_16_1, 0)

	if not var_16_0.fade and var_16_0.timer <= 0.2 then
		Managers.transition:fade_in(8)

		var_16_0.fade = true
	end

	if var_16_0.timer == 0 then
		for iter_16_0, iter_16_1 in ipairs(arg_16_0._screen_award_widgets) do
			iter_16_1.content.visible = false
		end

		local var_16_19 = arg_16_0._character_rotation

		arg_16_0._hero_previewers[arg_16_0._current_hero]:set_hero_rotation(var_16_19)
		Unit.animation_set_constraint_target(var_16_17, var_16_18, Vector3Aux.unbox(arg_16_0._character_look_target))

		arg_16_0._award_presentation_data = nil
		arg_16_0._current_hero = arg_16_0._current_hero - 1

		if arg_16_0._current_hero < 1 then
			arg_16_0:_trigger_end_camera()
		end
	end
end

function LevelEndViewVersus._trigger_end_camera(arg_17_0)
	local var_17_0 = arg_17_0._target_camera_pose:unbox()

	Matrix4x4.set_translation(var_17_0, Matrix4x4.translation(var_17_0) + Matrix4x4.forward(var_17_0) * 2)

	arg_17_0._camera_pose = Matrix4x4Box(var_17_0)
	arg_17_0._camera_progress = 0

	for iter_17_0, iter_17_1 in ipairs(arg_17_0._hero_previewers) do
		iter_17_1:_set_character_visibility(true)
	end

	for iter_17_2, iter_17_3 in ipairs(arg_17_0._award_widgets) do
		iter_17_3.content.visible = true
	end

	Managers.transition:force_fade_in()
	Managers.transition:fade_out(2)
	arg_17_0:_start_animation("animate_continue_button", arg_17_0._widgets_by_name, {
		cb = callback(arg_17_0, "set_input_description", "continue_available")
	})

	arg_17_0._skip_camera_fade = true

	arg_17_0:play_sound("Play_vs_hud_eom_parading_team")
end

function LevelEndViewVersus._start_award_presentation(arg_18_0)
	arg_18_0._current_hero = arg_18_0._current_hero or #arg_18_0._hero_previewers

	local var_18_0 = arg_18_0._hero_previewers[arg_18_0._current_hero]

	if not var_18_0 then
		return
	end

	local var_18_1 = var_18_0:get_character_unit()

	if not Unit.alive(var_18_1) then
		return
	end

	for iter_18_0, iter_18_1 in ipairs(arg_18_0._hero_previewers) do
		iter_18_1:_set_character_visibility(false)
	end

	var_18_0:_set_character_visibility(true)

	for iter_18_2, iter_18_3 in ipairs(arg_18_0._screen_award_widgets) do
		iter_18_3.content.visible = false
	end

	arg_18_0._character_rotation = var_18_0.character_rotation
	arg_18_0._character_look_target = var_18_0.character_look_target
	arg_18_0._fov = table.is_empty(arg_18_0._team_heroes[arg_18_0._current_hero].breed) and 55 or nil

	local var_18_2 = var_18_0:current_profile_name()
	local var_18_3 = PROFILES_BY_NAME[var_18_2]

	arg_18_0._fov = var_0_5[var_18_3.display_name] or arg_18_0._fov

	local var_18_4 = var_0_6[var_18_3.display_name] or 0

	var_18_0:set_hero_rotation(0)

	local var_18_5 = arg_18_0._screen_award_widgets[arg_18_0._current_hero]

	var_18_5.content.visible = true

	local var_18_6 = var_18_5.content.award_data
	local var_18_7 = var_18_6.sound_event

	if var_18_7 then
		arg_18_0:play_sound(var_18_7)
	end

	if var_18_6.peer_id == Network.peer_id() then
		arg_18_0:play_sound("Play_vs_hud_eom_parading_you")
	end

	arg_18_0.render_settings.alpha_multiplier = 1

	local var_18_8 = Unit.has_node(var_18_1, "j_neck") and Unit.node(var_18_1, "j_neck")

	if not var_18_8 then
		return
	end

	local var_18_9 = Unit.world_pose(var_18_1, var_18_8)
	local var_18_10 = Unit.has_node(var_18_1, "j_hips") and Unit.node(var_18_1, "j_hips")

	if not var_18_10 then
		return
	end

	local var_18_11 = Unit.world_pose(var_18_1, var_18_10)
	local var_18_12 = Unit.world_pose(var_18_1, 0)
	local var_18_13 = 2
	local var_18_14 = 5
	local var_18_15 = Vector3(-1, 0, 0)
	local var_18_16 = Matrix4x4.forward(arg_18_0._camera_pose:unbox())
	local var_18_17 = Matrix4x4.translation(var_18_9) + var_18_16 * var_18_4
	local var_18_18 = Matrix4x4.translation(var_18_11) + var_18_16 * var_18_4
	local var_18_19 = Matrix4x4.translation(var_18_12) + var_18_16 * var_18_4
	local var_18_20
	local var_18_21
	local var_18_22

	arg_18_0._random_seed, var_18_22 = Math.next_random(arg_18_0._random_seed, 1, #arg_18_0._camera_movement_functions)
	arg_18_0._award_presentation_data = arg_18_0._camera_movement_functions[var_18_22].func(var_18_9, var_18_17, var_18_18, var_18_19, var_18_15, var_18_16, var_18_13, var_18_14)

	table.remove(arg_18_0._camera_movement_functions, var_18_22)
	Managers.transition:force_fade_in()
	Managers.transition:fade_out(2)
end

function LevelEndViewVersus._handle_input(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.input_manager:get_service("end_of_level")

	if var_19_0:get("confirm_hold") then
		arg_19_1 = arg_19_1 * 5
	end

	local var_19_1 = arg_19_0._widgets_by_name.continue_button

	if var_19_1.content.visible then
		local var_19_2 = Managers.input:is_device_active("gamepad")

		if UIUtils.is_button_pressed(var_19_1) or var_19_2 and var_19_0:get("refresh") or not var_19_2 and var_19_0:get("confirm_press") then
			arg_19_0._parading_done = true

			arg_19_0:play_sound("play_gui_start_menu_button_click")
		elseif UIUtils.is_button_hover_enter(var_19_1) then
			arg_19_0:play_sound("Play_hud_hover")
		end
	end

	return arg_19_1
end

function LevelEndViewVersus.parading_done(arg_20_0, arg_20_1, arg_20_2)
	return arg_20_0._parading_done
end

function LevelEndViewVersus._update_camera_zoom(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0._fade_out_triggered then
		return
	end

	local var_21_0 = arg_21_0._camera_progress

	if var_21_0 >= 1 then
		return
	end

	if arg_21_0._camera_delay and arg_21_2 < arg_21_0._camera_delay then
		return
	end

	local var_21_1 = math.easeOutCubic(var_21_0)
	local var_21_2 = Matrix4x4.lerp(arg_21_0._camera_pose:unbox(), arg_21_0._target_camera_pose:unbox(), var_21_1)

	arg_21_0:position_camera(var_21_2)

	local var_21_3 = 0.5

	arg_21_0._camera_progress = math.min(var_21_0 + arg_21_1 * var_21_3, 1)

	if not arg_21_0._skip_camera_fade and arg_21_0._camera_progress >= 0.9 then
		Managers.transition:fade_in(5)

		arg_21_0._skip_camera_fade = true
	end
end

function LevelEndViewVersus._start_music(arg_22_0)
	if arg_22_0._playing_music then
		return
	end

	arg_22_0:play_sound(arg_22_0._start_music_event)

	arg_22_0._playing_music = true
end

function LevelEndViewVersus._update_animations(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._ui_animator

	var_23_0:update(arg_23_1)

	for iter_23_0, iter_23_1 in pairs(arg_23_0._ui_animations) do
		if var_23_0:is_animation_completed(iter_23_0) then
			arg_23_0._ui_animations[iter_23_0] = nil
		end
	end

	local var_23_1 = arg_23_0._widgets_by_name.continue_button

	UIWidgetUtils.animate_default_button(var_23_1, arg_23_1)
end

function LevelEndViewVersus._draw(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.ui_renderer
	local var_24_1 = arg_24_0._ui_scenegraph
	local var_24_2 = Managers.input:is_device_active("gamepad")
	local var_24_3 = arg_24_0:input_service()
	local var_24_4 = arg_24_0.render_settings

	UIRenderer.begin_pass(var_24_0, var_24_1, var_24_3, arg_24_1, nil, var_24_4)
	UIRenderer.draw_all_widgets(var_24_0, arg_24_0._widgets)
	UIRenderer.draw_all_widgets(var_24_0, arg_24_0._portrait_widgets)
	UIRenderer.draw_all_widgets(var_24_0, arg_24_0._award_widgets)
	UIRenderer.draw_all_widgets(var_24_0, arg_24_0._screen_award_widgets)
	UIRenderer.end_pass(var_24_0)

	if var_24_2 then
		arg_24_0._menu_input_description:draw(var_24_0, arg_24_1)
	end
end

function LevelEndViewVersus.set_input_description(arg_25_0, arg_25_1)
	arg_25_0._menu_input_description:set_input_description(var_0_0.generic_input_actions[arg_25_1])
end

function LevelEndViewVersus.destroy(arg_26_0, arg_26_1)
	LevelEndViewVersus.super.destroy(arg_26_0, arg_26_1)
	Managers.state.event:unregister("set_flow_object_set_enabled", arg_26_0)

	arg_26_0._ui_scenegraph = nil
end

function LevelEndViewVersus.do_retry(arg_27_0)
	return false
end

function LevelEndViewVersus.active_input_service(arg_28_0)
	return arg_28_0.input_blocked and FAKE_INPUT_SERVICE or arg_28_0:input_service()
end

function LevelEndViewVersus.setup_pages(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0

	if arg_29_0._is_untrusted then
		var_29_0 = arg_29_0:_setup_pages_untrusted()
	elseif arg_29_1 then
		var_29_0 = arg_29_0:_setup_pages_victory(arg_29_2)
	else
		var_29_0 = arg_29_0:_setup_pages_defeat(arg_29_2)
	end

	return var_29_0
end

function LevelEndViewVersus.setup_camera(arg_30_0)
	local var_30_0 = Matrix4x4Box(Matrix4x4.identity())
	local var_30_1 = "levels/carousel_podium/world"
	local var_30_2 = LevelResource.unit_indices(var_30_1, "units/hub_elements/cutscene_camera/cutscene_camera")

	for iter_30_0, iter_30_1 in pairs(var_30_2) do
		local var_30_3 = LevelResource.unit_data(var_30_1, iter_30_1)
		local var_30_4 = DynamicData.get(var_30_3, "name")

		if var_30_4 and var_30_4 == "parading_position_01" then
			local var_30_5 = LevelResource.unit_position(var_30_1, iter_30_1) + Vector3(0, 1, 0)
			local var_30_6 = LevelResource.unit_rotation(var_30_1, iter_30_1)
			local var_30_7 = Matrix4x4.from_quaternion_position(var_30_6, var_30_5)

			var_30_0 = Matrix4x4Box(var_30_7)

			print("Found camera: " .. var_30_4)

			break
		end
	end

	arg_30_0._camera_pose = var_30_0
	arg_30_0._target_camera_pose = Matrix4x4Box(Matrix4x4.multiply(var_30_0:unbox(), Matrix4x4.from_translation(Vector3(0, -2.75, 0))))
	arg_30_0._camera_progress = 0

	arg_30_0:position_camera(arg_30_0._target_camera_pose:unbox())
end

function LevelEndViewVersus._destroy_team_previewer(arg_31_0)
	if arg_31_0._team_previewer then
		arg_31_0._team_previewer:on_exit()

		arg_31_0._team_previewer = nil
	end
end

function LevelEndViewVersus._update_team_previewer(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0._team_previewer

	if var_32_0 then
		var_32_0:update(arg_32_1, arg_32_2)
		var_32_0:post_update(arg_32_1, arg_32_2)
	end
end

function LevelEndViewVersus.create_ui_elements(arg_33_0)
	arg_33_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_33_0._ui_animator = UIAnimator:new(arg_33_0._ui_scenegraph, var_0_3)
	arg_33_0._widgets, arg_33_0._widgets_by_name = UIUtils.create_widgets(var_0_1, {}, {})
	arg_33_0._widgets_by_name.continue_button.content.visible = false
	arg_33_0._ui_animations = {}
	arg_33_0._portrait_widgets = {}
	arg_33_0._award_widgets = {}
	arg_33_0._screen_award_widgets = {}

	UIRenderer.clear_scenegraph_queue(arg_33_0.ui_renderer)
end

function LevelEndViewVersus.hide_team(arg_34_0)
	if arg_34_0._team_previewer then
		arg_34_0:_destroy_team_previewer()
	end

	if not table.is_empty(arg_34_0._ui_animations) then
		for iter_34_0, iter_34_1 in pairs(arg_34_0._ui_animations) do
			arg_34_0._ui_animator:stop_animation(iter_34_0)
		end

		table.clear(arg_34_0._ui_animations)
	end

	arg_34_0:_start_animation("hide_awards", arg_34_0._award_widgets)
end

function LevelEndViewVersus.show_team(arg_35_0)
	if arg_35_0._team_previewer then
		arg_35_0:_destroy_team_previewer()
	end

	arg_35_0:_calculate_awards()

	local var_35_0 = arg_35_0:_setup_team_heroes()

	arg_35_0:_setup_team_previewer(var_35_0)
end

function LevelEndViewVersus._start_animation(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = {
		render_settings = arg_36_0.render_settings,
		data = arg_36_3
	}
	local var_36_1 = arg_36_0._ui_animator:start_animation(arg_36_1, arg_36_2, var_0_2, var_36_0)

	arg_36_0._ui_animations[var_36_1] = true
end

function LevelEndViewVersus._setup_team_heroes(arg_37_0)
	local var_37_0 = 0
	local var_37_1 = arg_37_0.context.party_composition[PlayerUtils.unique_player_id(Network.peer_id(), 1)]
	local var_37_2 = arg_37_0.context.players_session_score
	local var_37_3 = arg_37_0._team_heroes
	local var_37_4 = arg_37_0._peers_with_score

	table.clear(var_37_3)
	table.clear(var_37_4)

	for iter_37_0 = 1, math.min(#arg_37_0._sorted_awards, var_0_11) do
		local var_37_5 = arg_37_0._sorted_awards[iter_37_0]
		local var_37_6 = var_37_5.stats_id
		local var_37_7 = var_37_2[var_37_6]
		local var_37_8 = var_37_7.peer_id

		if arg_37_0.context.party_composition[var_37_6] then
			var_37_3[#var_37_3 + 1] = arg_37_0:get_hero_from_score(var_37_7, var_37_5)
			var_37_0 = var_37_0 + 1
		end

		var_37_4[var_37_8] = true
	end

	return var_37_0
end

local var_0_12 = {}

function LevelEndViewVersus.get_hero_from_score(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_1.profile_index
	local var_38_1 = arg_38_1.career_index
	local var_38_2 = SPProfiles[var_38_0].careers[var_38_1]
	local var_38_3
	local var_38_4
	local var_38_5
	local var_38_6 = arg_38_1.weapon_pose and arg_38_1.weapon_pose.item_name

	if var_38_6 then
		local var_38_7 = ItemMasterList[var_38_6]

		if var_38_7 then
			local var_38_8 = arg_38_1.weapon_pose.skin_name
			local var_38_9 = var_38_7.parent
			local var_38_10 = rawget(ItemMasterList, var_38_9) and ItemMasterList[var_38_9]

			if var_38_10 then
				var_38_3 = {
					item_name = var_38_9,
					skin_name = var_38_8
				}
				var_38_4 = var_38_10.slot_type
				var_38_5 = var_38_7.data.anim_event
			end
		end
	end

	local var_38_11 = arg_38_1.weapon and arg_38_1.weapon.item_name
	local var_38_12 = ItemMasterList[var_38_11].slot_type
	local var_38_13 = arg_38_2.awards[1].award_settings or var_0_12
	local var_38_14 = var_38_13.breeds or var_0_12
	local var_38_15 = #var_38_14 > 0 and #var_38_14 or 1
	local var_38_16, var_38_17 = Math.next_random(arg_38_0._random_seed, 1, var_38_15)

	arg_38_0._random_seed = var_38_16

	local var_38_18 = var_38_14[var_38_17] or var_0_12
	local var_38_19 = var_38_18 and var_38_18.name
	local var_38_20 = var_38_18 and arg_38_1.pactsworn_cosmetics and arg_38_1.pactsworn_cosmetics[var_38_19] or var_38_18.default_gear or var_0_12
	local var_38_21 = var_38_20.weapon or var_38_20.slot_melee or var_38_20.slot_ranged
	local var_38_22 = var_38_21 and {
		item_name = var_38_21
	} or nil
	local var_38_23 = not table.is_empty(var_38_20) and (var_38_20.weapon_slot and var_38_20.weapon_slot == "slot_melee" and "melee" or "ranged" or var_38_20.slot_melee and "melee" or "ranged")
	local var_38_24 = var_38_20.skin or var_38_20.slot_skin

	return {
		stats_id = arg_38_1.stats_id,
		player_name = arg_38_1.name,
		peer_id = arg_38_1.peer_id,
		profile_index = var_38_0,
		career_index = var_38_1,
		hero_name = var_38_2.profile_name,
		skin_name = var_38_24 or arg_38_1.hero_skin,
		frame_name = arg_38_1.portrait_frame,
		player_level = arg_38_1.player_level,
		award_material = var_38_13.award_material or nil,
		versus_player_level = arg_38_1.versus_player_level,
		weapon_slot = var_38_23 or var_38_4 or var_38_12,
		breed = var_38_18,
		weapon_pose_anim_event = var_38_5,
		random_seed = arg_38_0._random_seed,
		preview_items = {
			table.is_empty(var_38_18) and arg_38_1.hat or nil,
			var_38_22 or var_38_3 or arg_38_1.weapon
		}
	}
end

function LevelEndViewVersus._gather_hero_locations(arg_39_0, arg_39_1)
	local var_39_0 = {}
	local var_39_1 = {}
	local var_39_2 = "levels/carousel_podium/world"
	local var_39_3 = LevelResource.unit_indices(var_39_2, "units/hub_elements/versus_podium_character_spawn")

	for iter_39_0, iter_39_1 in pairs(var_39_3) do
		local var_39_4 = LevelResource.unit_data(var_39_2, iter_39_1)
		local var_39_5 = DynamicData.get(var_39_4, "name")

		if var_39_5 and string.find(var_39_5, "ceremony_slot_") then
			local var_39_6 = LevelResource.unit_position(var_39_2, iter_39_1)

			var_39_0[tonumber(string.gsub(var_39_5, "ceremony_slot_", ""), 10)] = {
				var_39_6[1],
				var_39_6[2],
				var_39_6[3]
			}
		end
	end

	for iter_39_2 = 1, arg_39_1 do
		var_39_1[iter_39_2] = var_39_0[iter_39_2] or {
			0,
			0,
			0
		}
	end

	return var_39_1
end

function LevelEndViewVersus._setup_team_previewer(arg_40_0, arg_40_1)
	if arg_40_0._team_previewer then
		return
	end

	local var_40_0, var_40_1 = arg_40_0:get_viewport_world()

	arg_40_0._team_previewer = TeamPreviewer:new(arg_40_0.context, var_40_0, var_40_1)

	local var_40_2 = arg_40_0._team_heroes
	local var_40_3 = arg_40_0:_gather_hero_locations(arg_40_1)

	arg_40_0._team_previewer:setup_team(var_40_2, var_40_3)

	if table.is_empty(arg_40_0._portrait_widgets) then
		arg_40_0:_create_ceremony_award_widgets(var_40_2, var_40_3)
	end

	arg_40_0._hero_previewers = {}

	for iter_40_0 = 1, arg_40_1 do
		arg_40_0._hero_previewers[iter_40_0] = arg_40_0._team_previewer:get_hero_previewer(iter_40_0)
	end
end

function LevelEndViewVersus._create_ceremony_award_widgets(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0, var_41_1 = arg_41_0:get_viewport_world()
	local var_41_2 = ScriptViewport.camera(var_41_1)
	local var_41_3 = arg_41_0.context.party_composition
	local var_41_4 = Network.peer_id()
	local var_41_5 = 1
	local var_41_6 = var_41_3[PlayerUtils.unique_player_id(var_41_4, var_41_5)]

	for iter_41_0 = 1, #arg_41_1 do
		local var_41_7 = arg_41_1[iter_41_0]
		local var_41_8 = var_41_7.profile_index
		local var_41_9 = var_41_7.career_index
		local var_41_10 = arg_41_2[iter_41_0]
		local var_41_11 = Camera.world_to_screen(var_41_2, Vector3(var_41_10[1], var_41_10[2], var_41_10[3]))
		local var_41_12 = UIInverseScaleVectorToResolution(var_41_11, true)
		local var_41_13 = var_41_3[var_41_7.stats_id]
		local var_41_14 = arg_41_0._sorted_awards[iter_41_0].awards[1]
		local var_41_15 = {
			camera = var_41_2,
			world_pos = var_41_10,
			player_name = var_41_7.player_name,
			level = var_41_7.versus_player_level or 0,
			peer_id = var_41_7.peer_id,
			is_mvp = var_41_14.header == "mvp",
			header = var_41_14.header,
			sound_event = var_41_14.sound,
			sub_header = var_41_14.sub_header or "",
			amount = var_41_14.amount or "",
			award_material = var_41_14.award_material or nil,
			award_mask_material = var_41_14.award_mask_material or nil,
			screen_sub_header = var_41_14.screen_sub_header or "",
			team_color = var_41_13 == var_41_6 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255),
			is_local = var_41_13 == var_41_6
		}
		local var_41_16 = "award_" .. iter_41_0
		local var_41_17 = UIWidgets.create_ceremony_award(var_41_16, var_41_15, {
			var_41_12[1] - 145,
			200,
			0
		})
		local var_41_18 = UIWidget.init(var_41_17)
		local var_41_19 = "screen_award"
		local var_41_20 = UIWidgets.create_screen_ceremony_award(var_41_19, var_41_15, {
			0,
			0,
			0
		}, arg_41_0.ui_renderer)
		local var_41_21 = UIWidget.init(var_41_20)
		local var_41_22 = "insignia_" .. iter_41_0

		arg_41_0._widgets_by_name[var_41_22] = var_41_18
		arg_41_0._award_widgets[#arg_41_0._award_widgets + 1] = var_41_18

		local var_41_23 = "screen_award_" .. iter_41_0

		arg_41_0._widgets_by_name[var_41_23] = var_41_21
		arg_41_0._screen_award_widgets[#arg_41_0._screen_award_widgets + 1] = var_41_21
		var_41_18.content.visible = false
		var_41_18.content.widget_offset = var_41_18.offset
		var_41_21.content.visible = false
	end
end

function LevelEndViewVersus.create_world(arg_42_0, arg_42_1)
	local var_42_0 = "end_screen"
	local var_42_1 = "environment/ui_store_preview"
	local var_42_2 = 2
	local var_42_3 = arg_42_0:get_world_flags()
	local var_42_4 = Managers.world:create_world(var_42_0, var_42_1, nil, var_42_2, unpack(var_42_3))

	World.set_data(var_42_4, "avoid_blend", true)

	local var_42_5 = Managers.world:world("top_ingame_view")

	return var_42_4, var_42_5
end

function LevelEndViewVersus.spawn_level(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = "levels/carousel_podium/world"
	local var_43_1 = {}
	local var_43_2
	local var_43_3
	local var_43_4
	local var_43_5
	local var_43_6 = false
	local var_43_7 = ScriptWorld.spawn_level(arg_43_2, var_43_0, var_43_1, var_43_2, var_43_3, var_43_4, var_43_5, var_43_6)

	Level.spawn_background(var_43_7)
	Level.trigger_level_loaded(var_43_7)
	arg_43_0:_register_object_sets(var_43_7, var_43_0)
	Level.trigger_event(var_43_7, "ceremoni_enabled")

	return var_43_7
end

function LevelEndViewVersus.event_show_flow_object_set(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = "flow_" .. arg_44_1

	arg_44_0:_show_object_set(var_44_0, arg_44_2)
end

function LevelEndViewVersus.exit_to_game(arg_45_0)
	LevelEndViewVersus.super.exit_to_game(arg_45_0)
	arg_45_0:play_sound(arg_45_0._stop_music_event)
end

function LevelEndViewVersus.activate_back_to_keep_button(arg_46_0)
	local var_46_0 = arg_46_0._machine
	local var_46_1 = arg_46_0._machine:state()

	if var_46_1.activate_back_to_keep_button then
		var_46_1:activate_back_to_keep_button()
	end

	arg_46_0:set_input_description("continue_available")
end
