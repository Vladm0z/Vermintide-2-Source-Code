-- chunkname: @scripts/ui/views/level_end/level_end_view_versus.lua

require("scripts/settings/dlcs/carousel/end_screen_award_settings")

local var_0_0 = local_require("scripts/ui/views/level_end/level_end_view_versus_definitions")
local widget_definitions = var_0_0.widget_definitions
local scenegraph_definitions = var_0_0.scenegraph_definitions
local animation_definitions = var_0_0.animation_definitions
local camera_movement_functions = var_0_0.camera_movement_functions
local tbl = {
	vs_rat_ogre = 75,
	vs_chaos_troll = 75
}
local tbl_2 = {
	vs_rat_ogre = -0.5
}

LevelEndViewVersus = class(LevelEndViewVersus, LevelEndViewBase)

LevelEndViewVersus._setup_pages_victory = function (arg_1_0, arg_1_1)
	-- function 1
	if not GameSettingsDevelopment.read_only_backend then
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

LevelEndViewVersus._setup_pages_defeat = function (arg_2_0, arg_2_1)
	-- function 2
	if not GameSettingsDevelopment.read_only_backend then
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

local tbl_3 = {}

for k, v in pairs(DLCSettings) do
	local portrait_materials = v.portrait_materials

	if not portrait_materials then
		for i, v_2 in ipairs(portrait_materials) do
			tbl_3[#tbl_3 + 1] = v_2
		end
	end
end

local num = 1
local num_2 = 4
local num_3 = 5

LevelEndViewVersus.init = function (self, arg_3_1)
	-- function 3
	self._team_heroes = {}
	self._team_previewer = nil
	self._peers_with_score = {}
	self._parading_done_timer = nil
	self._camera_movement_functions = table.clone(camera_movement_functions)

	LevelEndViewWeave.super.init(self, arg_3_1)

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, Managers.input:get_service("end_of_level"), 3, 900, var_0_0.generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)
	Managers.state.event:register(self, "set_flow_object_set_enabled", "event_show_flow_object_set")
	Managers.transition:force_fade_in()
end

LevelEndViewVersus._calculate_awards = function (self)
	-- function 4
	local tbl = {}
	local players_session_score = self.context.players_session_score

	for i = 1, #EndScreenAwardSettings do
		local var_4_2 = EndScreenAwardSettings[i]
		local evaluate, var_4_4 = var_4_2.evaluate(players_session_score)

		if not evaluate then
			local var_4_5 = tbl[evaluate]

			var_4_5 = var_4_5 or {}
			tbl[evaluate] = var_4_5

			local var_4_6 = tbl[evaluate]
			local num = #tbl[evaluate] + 1
			local tbl_2 = {
				value = 10 - var_4_2.prio,
				header = var_4_2.name,
				sound = var_4_2.sound
			}
			local sub_header = var_4_2.sub_header

			sub_header = not sub_header and string.format(var_4_2.sub_header, var_4_4)
			tbl_2.sub_header = sub_header
			tbl_2.screen_sub_header = var_4_2.screen_sub_header
			tbl_2.award_material = var_4_2.award_material
			tbl_2.award_mask_material = var_4_2.award_mask_material
			tbl_2.award_settings = var_4_2
			tbl_2.amount = var_4_4
			var_4_6[num] = tbl_2
		end
	end

	table.dump(players_session_score, "PLAYERS_SESSION_SCORES", 2)
	self:_calculate_mvp(tbl, players_session_score)

	local tbl_3 = {}

	for k, v in pairs(tbl) do
		local num_2 = 0

		for l = 1, #v do
			local value = v[l].value

			num_2 = not (num_2 < value) or not value or num_2
		end

		tbl_3[#tbl_3 + 1] = {
			stats_id = k,
			max_award_value = num_2,
			awards = v
		}
	end

	local function fn(self, arg_5_1)
		-- function 5
		return self.max_award_value > arg_5_1.max_award_value
	end

	table.sort(tbl_3, fn)

	self._sorted_awards = tbl_3

	self:_save_award_stats()
	table.dump(self._sorted_awards, "AWARDS", 3)

	local tbl_4 = {}

	for k_2, v_2 in pairs(players_session_score) do
		tbl_4[#tbl_4 + 1] = v_2
		tbl_4[#tbl_4].stats_id = k_2
	end

	local function fn_2(self, arg_6_1)
		-- function 6
		return self.stats_id > arg_6_1.stats_id
	end

	table.sort(tbl_4, fn_2)
	table.dump(tbl_4, "SCORES", 2)
end

LevelEndViewVersus._save_award_stats = function (self)
	-- function 7
	local get_interface = Managers.backend:get_interface("statistics")
	local get_stats = get_interface:get_stats()
	local var_7_2 = StatisticsDatabase:new()
	local num = 1
	local unique_player_id = PlayerUtils.unique_player_id(Network.peer_id(), num)

	var_7_2:register(unique_player_id, "player", get_stats)

	local var_7_5

	for i, v in ipairs(self._sorted_awards) do
		if v.stats_id == unique_player_id then
			var_7_5 = v.awards

			break
		end
	end

	if not var_7_5 then
		for i_2, v_2 in ipairs(var_7_5) do
			local stat_key = v_2.award_settings.stat_key

			var_7_2:increment_stat(unique_player_id, stat_key)
		end
	end

	get_interface:save_explicit(unique_player_id, var_7_2)
	Managers.backend:commit()
end

LevelEndViewVersus._calculate_mvp = function (self, arg_8_1, arg_8_2)
	-- function 8
	local tbl = {}
	local num = 1
	local num_2 = 0

	for k, v in pairs(arg_8_1) do
		tbl[k] = 0

		for i, v_2 in ipairs(v) do
			tbl[k] = tbl[k] + v_2.value
		end

		if num_2 < tbl[k] then
			num_2 = tbl[k]
		end
	end

	local tbl_2 = {}

	for k_2, v_3 in pairs(tbl) do
		if v_3 == num_2 then
			tbl_2[#tbl_2 + 1] = k_2
		end
	end

	local party_composition = self.context.party_composition
	local players_session_score = self.context.players_session_score
	local var_8_6

	if #tbl_2 > 1 then
		local peer_id = Network.peer_id()
		local var_8_8 = party_composition[PlayerUtils.unique_player_id(peer_id, num)]
		local flag

		flag = var_8_8 ~= 1 or not 2 or 1

		local game_won = self.context.game_won
		local flag_2 = not game_won and var_8_8 and game_won or not flag and nil
		local tbl_3 = {}

		for i_2, v_4 in ipairs(tbl_2) do
			if party_composition[v_4] == flag_2 then
				tbl_3[#tbl_3 + 1] = v_4
			end
		end

		local tbl_4 = {}

		if #tbl_3 == 1 then
			var_8_6 = tbl_3[1]
		elseif #tbl_3 > 1 then
			tbl_4 = tbl_3
		else
			tbl_4 = tbl_2
		end

		if not table.is_empty(tbl_4) then
			local function fn(arg_9_0, arg_9_1)
				-- function 9
				local scores = players_session_score[arg_9_0].scores
				local num = scores.damage_dealt_heroes + scores.vs_damage_dealt_to_pactsworn

				num = num or 0

				local scores_2 = players_session_score[arg_9_1].scores
				local num_2 = scores_2.damage_dealt_heroes + scores_2.vs_damage_dealt_to_pactsworn

				num_2 = num_2 or 0

				return num_2 < num
			end

			table.sort(tbl_4, fn)

			var_8_6 = tbl_4[1]
		end
	else
		var_8_6 = tbl_2[1]
	end

	if not var_8_6 then
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

		local var_8_15 = arg_8_1[var_8_6]

		var_8_15 = var_8_15 or {}
		arg_8_1[var_8_6] = var_8_15

		table.insert(arg_8_1[var_8_6], 1, {
			award_mask_material = "mvp_award_mask",
			sound = "Play_vs_hud_eom_parading_mvp",
			header = "mvp",
			value = 10,
			award_material = "mvp_award",
			award_settings = EndScreenAwardSettingsLookup.vs_award_mvp
		})
	end

	local var_8_16 = arg_8_2[var_8_6]

	var_8_16 = var_8_16 or {}

	local peer_id_2 = var_8_16.peer_id

	peer_id_2 = peer_id_2 or "DEAD"

	local num_3 = 0
	local scores = var_8_16.scores

	if not scores then
		for k_3, v_5 in pairs(scores) do
			num_3 = num_3 + v_5
		end
	end

	self._random_seed = tonumber(peer_id_2, 16) + num_3
end

LevelEndViewVersus.set_input_description = function (self, arg_10_1)
	-- function 10
	local var_10_0 = var_0_0.generic_input_actions[arg_10_1]

	self._menu_input_description:set_input_description(var_10_0)
end

LevelEndViewVersus._setup_pages_untrusted = function (arg_11_0)
	-- function 11
	return {
		EndViewStateScoreVS = 2,
		EndViewStateParadingVS = 1
	}
end

LevelEndViewVersus.start = function (self)
	-- function 12
	print("[LevelEndView] Started LevelEndViewVersus")
	LevelEndViewVersus.super.start(self)

	self._start_music_event = "menu_versus_score_screen_amb_loop_start"
	self._stop_music_event = "menu_versus_score_screen_amb_loop_stop"
	self._playing_music = nil
end

LevelEndViewVersus.create_ui_renderer = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local tbl = {
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
	local get_extra_materials = self.get_extra_materials

	if not get_extra_materials then
		for i, v in ipairs(get_extra_materials) do
			tbl[#tbl + 1] = v
		end
	end

	for i_2, v_2 in ipairs(tbl_3) do
		tbl[#tbl + 1] = "material"
		tbl[#tbl + 1] = v_2
	end

	local var_13_2 = UIRenderer.create(arg_13_2, unpack(tbl))
	local var_13_3 = UIRenderer.create(arg_13_3, unpack(tbl))

	return var_13_2, var_13_3
end

LevelEndViewVersus.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _handle_input = self:_handle_input(arg_14_1, arg_14_2)

	LevelEndViewVersus.super.update(self, _handle_input, arg_14_2)
	self:_start_music()
	self:_update_animations(_handle_input, arg_14_2)
	self:_update_team_previewer(_handle_input, arg_14_2)
	self:_update_fade(_handle_input, arg_14_2)
	self:_update_camera_zoom(_handle_input, arg_14_2)
	self:_update_award_presentation(_handle_input, arg_14_2)
	self:_draw(_handle_input, arg_14_2)
end

LevelEndViewVersus._update_fade = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._fade_out_triggered then
		return
	end

	if not (not self._team_previewer and self._team_previewer:loading_done()) then
		Managers.transition:force_fade_in()
	else
		Managers.transition:fade_out(2)

		self._fade_out_triggered = true
	end
end

LevelEndViewVersus._update_award_presentation = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not self._fade_out_triggered then
		return
	end

	if self._camera_progress < 1 then
		return
	end

	if not self._award_presentation_data then
		self:_start_award_presentation()
	end

	local _award_presentation_data = self._award_presentation_data

	if not _award_presentation_data then
		return
	end

	local unbox = _award_presentation_data.start_pos:unbox()
	local unbox_2 = _award_presentation_data.end_pos:unbox()
	local unbox_3 = _award_presentation_data.neck_pose:unbox()
	local distance = _award_presentation_data.distance
	local time = _award_presentation_data.time
	local timer = _award_presentation_data.timer
	local num = 1 - timer / time
	local easeOutCubic = math.easeOutCubic(num)
	local disable_camera_rotation = _award_presentation_data.disable_camera_rotation
	local lerp = Vector3.lerp(unbox, unbox_2, easeOutCubic)
	local translation = Matrix4x4.translation(unbox_3)
	local rotation = Matrix4x4.rotation(unbox_3)
	local forward = Quaternion.forward(rotation)

	forward[3] = 0

	local num_2 = lerp + forward * math.sin(math.pi * easeOutCubic) * distance
	local var_16_15

	if not disable_camera_rotation then
		var_16_15 = Quaternion.look(Vector3(0, -1, 0), Vector3.up())
	else
		var_16_15 = Quaternion.look(translation - num_2, Vector3.up())
	end

	local from_quaternion_position = Matrix4x4.from_quaternion_position(var_16_15, num_2)

	self:position_camera(from_quaternion_position, self._fov)

	local get_character_unit = self._hero_previewers[self._current_hero]:get_character_unit()
	local animation_find_constraint_target = Unit.animation_find_constraint_target(get_character_unit, "aim_constraint_target")

	Unit.animation_set_constraint_target(get_character_unit, animation_find_constraint_target, num_2)

	_award_presentation_data.timer = math.max(timer - arg_16_1, 0)

	if not (_award_presentation_data.fade or not (_award_presentation_data.timer <= 0.2)) then
		Managers.transition:fade_in(8)

		_award_presentation_data.fade = true
	end

	if _award_presentation_data.timer == 0 then
		for i, v in ipairs(self._screen_award_widgets) do
			v.content.visible = false
		end

		local _character_rotation = self._character_rotation

		self._hero_previewers[self._current_hero]:set_hero_rotation(_character_rotation)
		Unit.animation_set_constraint_target(get_character_unit, animation_find_constraint_target, Vector3Aux.unbox(self._character_look_target))

		self._award_presentation_data = nil
		self._current_hero = self._current_hero - 1

		if self._current_hero < 1 then
			self:_trigger_end_camera()
		end
	end
end

LevelEndViewVersus._trigger_end_camera = function (self)
	-- function 17
	local unbox = self._target_camera_pose:unbox()

	Matrix4x4.set_translation(unbox, Matrix4x4.translation(unbox) + Matrix4x4.forward(unbox) * 2)

	self._camera_pose = Matrix4x4Box(unbox)
	self._camera_progress = 0

	for i, v in ipairs(self._hero_previewers) do
		v:_set_character_visibility(true)
	end

	for i_2, v_2 in ipairs(self._award_widgets) do
		v_2.content.visible = true
	end

	Managers.transition:force_fade_in()
	Managers.transition:fade_out(2)
	self:_start_animation("animate_continue_button", self._widgets_by_name, {
		cb = callback(self, "set_input_description", "continue_available")
	})

	self._skip_camera_fade = true

	self:play_sound("Play_vs_hud_eom_parading_team")
end

LevelEndViewVersus._start_award_presentation = function (self)
	-- function 18
	local _current_hero = self._current_hero

	_current_hero = _current_hero or #self._hero_previewers
	self._current_hero = _current_hero

	local var_18_1 = self._hero_previewers[self._current_hero]

	if not var_18_1 then
		return
	end

	local get_character_unit = var_18_1:get_character_unit()

	if not Unit.alive(get_character_unit) then
		return
	end

	for i, v in ipairs(self._hero_previewers) do
		v:_set_character_visibility(false)
	end

	var_18_1:_set_character_visibility(true)

	for i_2, v_2 in ipairs(self._screen_award_widgets) do
		v_2.content.visible = false
	end

	self._character_rotation = var_18_1.character_rotation
	self._character_look_target = var_18_1.character_look_target

	local flag

	flag = not table.is_empty(self._team_heroes[self._current_hero].breed) and 55 and nil
	self._fov = flag

	local current_profile_name = var_18_1:current_profile_name()
	local var_18_5 = PROFILES_BY_NAME[current_profile_name]
	local var_18_6 = tbl[var_18_5.display_name]

	var_18_6 = var_18_6 or self._fov
	self._fov = var_18_6

	local var_18_7 = tbl_2[var_18_5.display_name]

	var_18_7 = var_18_7 or 0

	var_18_1:set_hero_rotation(0)

	local var_18_8 = self._screen_award_widgets[self._current_hero]

	var_18_8.content.visible = true

	local award_data = var_18_8.content.award_data
	local sound_event = award_data.sound_event

	if not sound_event then
		self:play_sound(sound_event)
	end

	if award_data.peer_id == Network.peer_id() then
		self:play_sound("Play_vs_hud_eom_parading_you")
	end

	self.render_settings.alpha_multiplier = 1

	local has_node = Unit.has_node(get_character_unit, "j_neck")

	has_node = not has_node and Unit.node(get_character_unit, "j_neck")

	if not has_node then
		return
	end

	local world_pose = Unit.world_pose(get_character_unit, has_node)
	local has_node_2 = Unit.has_node(get_character_unit, "j_hips")

	has_node_2 = not has_node_2 and Unit.node(get_character_unit, "j_hips")

	if not has_node_2 then
		return
	end

	local world_pose_2 = Unit.world_pose(get_character_unit, has_node_2)
	local world_pose_3 = Unit.world_pose(get_character_unit, 0)
	local num = 2
	local num_2 = 5
	local var_18_18 = Vector3(-1, 0, 0)
	local forward = Matrix4x4.forward(self._camera_pose:unbox())
	local num_3 = Matrix4x4.translation(world_pose) + forward * var_18_7
	local num_4 = Matrix4x4.translation(world_pose_2) + forward * var_18_7
	local num_5 = Matrix4x4.translation(world_pose_3) + forward * var_18_7
	local var_18_23
	local var_18_24
	local var_18_25

	self._random_seed, var_18_25 = Math.next_random(self._random_seed, 1, #self._camera_movement_functions)
	self._award_presentation_data = self._camera_movement_functions[var_18_25].func(world_pose, num_3, num_4, num_5, var_18_18, forward, num, num_2)

	table.remove(self._camera_movement_functions, var_18_25)
	Managers.transition:force_fade_in()
	Managers.transition:fade_out(2)
end

LevelEndViewVersus._handle_input = function (self, arg_19_1, arg_19_2)
	-- function 19
	local get_service = self.input_manager:get_service("end_of_level")

	if not get_service:get("confirm_hold") then
		arg_19_1 = arg_19_1 * 5
	end

	local continue_button = self._widgets_by_name.continue_button

	if not continue_button.content.visible then
		local is_device_active = Managers.input:is_device_active("gamepad")

		if UIUtils.is_button_pressed(continue_button) or not is_device_active or get_service:get("refresh") or is_device_active or not get_service:get("confirm_press") then
			self._parading_done = true

			self:play_sound("play_gui_start_menu_button_click")
		elseif not UIUtils.is_button_hover_enter(continue_button) then
			self:play_sound("Play_hud_hover")
		end
	end

	return arg_19_1
end

LevelEndViewVersus.parading_done = function (self, arg_20_1, arg_20_2)
	-- function 20
	return self._parading_done
end

LevelEndViewVersus._update_camera_zoom = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not self._fade_out_triggered then
		return
	end

	local _camera_progress = self._camera_progress

	if _camera_progress >= 1 then
		return
	end

	if not (not self._camera_delay and not (arg_21_2 < self._camera_delay)) then
		return
	end

	local easeOutCubic = math.easeOutCubic(_camera_progress)
	local lerp = Matrix4x4.lerp(self._camera_pose:unbox(), self._target_camera_pose:unbox(), easeOutCubic)

	self:position_camera(lerp)

	local num = 0.5

	self._camera_progress = math.min(_camera_progress + arg_21_1 * num, 1)

	if not (self._skip_camera_fade or not (self._camera_progress >= 0.9)) then
		Managers.transition:fade_in(5)

		self._skip_camera_fade = true
	end
end

LevelEndViewVersus._start_music = function (self)
	-- function 22
	if not self._playing_music then
		return
	end

	self:play_sound(self._start_music_event)

	self._playing_music = true
end

LevelEndViewVersus._update_animations = function (self, arg_23_1, arg_23_2)
	-- function 23
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_23_1)

	for k, v in pairs(self._ui_animations) do
		if not _ui_animator:is_animation_completed(k) then
			self._ui_animations[k] = nil
		end
	end

	local continue_button = self._widgets_by_name.continue_button

	UIWidgetUtils.animate_default_button(continue_button, arg_23_1)
end

LevelEndViewVersus._draw = function (self, arg_24_1, arg_24_2)
	-- function 24
	local ui_renderer = self.ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local is_device_active = Managers.input:is_device_active("gamepad")
	local input_service = self:input_service()
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, _ui_scenegraph, input_service, arg_24_1, nil, render_settings)
	UIRenderer.draw_all_widgets(ui_renderer, self._widgets)
	UIRenderer.draw_all_widgets(ui_renderer, self._portrait_widgets)
	UIRenderer.draw_all_widgets(ui_renderer, self._award_widgets)
	UIRenderer.draw_all_widgets(ui_renderer, self._screen_award_widgets)
	UIRenderer.end_pass(ui_renderer)

	if not is_device_active then
		self._menu_input_description:draw(ui_renderer, arg_24_1)
	end
end

LevelEndViewVersus.set_input_description = function (self, arg_25_1)
	-- function 25
	self._menu_input_description:set_input_description(var_0_0.generic_input_actions[arg_25_1])
end

LevelEndViewVersus.destroy = function (self, arg_26_1)
	-- function 26
	LevelEndViewVersus.super.destroy(self, arg_26_1)
	Managers.state.event:unregister("set_flow_object_set_enabled", self)

	self._ui_scenegraph = nil
end

LevelEndViewVersus.do_retry = function (arg_27_0)
	-- function 27
	return false
end

LevelEndViewVersus.active_input_service = function (self)
	-- function 28
	local FAKE_INPUT_SERVICE

	if not self.input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_28_0::

	return FAKE_INPUT_SERVICE
end

LevelEndViewVersus.setup_pages = function (self, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0

	if not GameSettingsDevelopment.read_only_backend then
		var_29_0 = self:_setup_pages_untrusted()
	elseif not arg_29_1 then
		var_29_0 = self:_setup_pages_victory(arg_29_2)
	else
		var_29_0 = self:_setup_pages_defeat(arg_29_2)
	end

	return var_29_0
end

LevelEndViewVersus.setup_camera = function (self)
	-- function 30
	local var_30_0 = Matrix4x4Box(Matrix4x4.identity())
	local str = "levels/carousel_podium/world"
	local unit_indices = LevelResource.unit_indices(str, "units/hub_elements/cutscene_camera/cutscene_camera")

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(str, v)
		local get = DynamicData.get(unit_data, "name")

		if not (not get and get ~= "parading_position_01") then
			local num = LevelResource.unit_position(str, v) + Vector3(0, 1, 0)
			local unit_rotation = LevelResource.unit_rotation(str, v)
			local from_quaternion_position = Matrix4x4.from_quaternion_position(unit_rotation, num)

			var_30_0 = Matrix4x4Box(from_quaternion_position)

			print("Found camera: " .. get)

			break
		end
	end

	self._camera_pose = var_30_0
	self._target_camera_pose = Matrix4x4Box(Matrix4x4.multiply(var_30_0:unbox(), Matrix4x4.from_translation(Vector3(0, -2.75, 0))))
	self._camera_progress = 0

	self:position_camera(self._target_camera_pose:unbox())
end

LevelEndViewVersus._destroy_team_previewer = function (self)
	-- function 31
	if not self._team_previewer then
		self._team_previewer:on_exit()

		self._team_previewer = nil
	end
end

LevelEndViewVersus._update_team_previewer = function (self, arg_32_1, arg_32_2)
	-- function 32
	local _team_previewer = self._team_previewer

	if not _team_previewer then
		_team_previewer:update(arg_32_1, arg_32_2)
		_team_previewer:post_update(arg_32_1, arg_32_2)
	end
end

LevelEndViewVersus.create_ui_elements = function (self)
	-- function 33
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definitions)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widget_definitions, {}, {})
	self._widgets_by_name.continue_button.content.visible = false
	self._ui_animations = {}
	self._portrait_widgets = {}
	self._award_widgets = {}
	self._screen_award_widgets = {}

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

LevelEndViewVersus.hide_team = function (self)
	-- function 34
	if not self._team_previewer then
		self:_destroy_team_previewer()
	end

	if not table.is_empty(self._ui_animations) then
		for k, v in pairs(self._ui_animations) do
			self._ui_animator:stop_animation(k)
		end

		table.clear(self._ui_animations)
	end

	self:_start_animation("hide_awards", self._award_widgets)
end

LevelEndViewVersus.show_team = function (self)
	-- function 35
	if not self._team_previewer then
		self:_destroy_team_previewer()
	end

	self:_calculate_awards()

	local _setup_team_heroes = self:_setup_team_heroes()

	self:_setup_team_previewer(_setup_team_heroes)
end

LevelEndViewVersus._start_animation = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	local tbl = {
		render_settings = self.render_settings,
		data = arg_36_3
	}
	local start_animation = self._ui_animator:start_animation(arg_36_1, arg_36_2, scenegraph_definitions, tbl)

	self._ui_animations[start_animation] = true
end

LevelEndViewVersus._setup_team_heroes = function (self)
	-- function 37
	local num = 0
	local var_37_1 = self.context.party_composition[PlayerUtils.unique_player_id(Network.peer_id(), 1)]
	local players_session_score = self.context.players_session_score
	local _team_heroes = self._team_heroes
	local _peers_with_score = self._peers_with_score

	table.clear(_team_heroes)
	table.clear(_peers_with_score)

	for i = 1, math.min(#self._sorted_awards, num_3) do
		local var_37_5 = self._sorted_awards[i]
		local stats_id = var_37_5.stats_id
		local var_37_7 = players_session_score[stats_id]
		local peer_id = var_37_7.peer_id

		if not self.context.party_composition[stats_id] then
			_team_heroes[#_team_heroes + 1] = self:get_hero_from_score(var_37_7, var_37_5)
			num = num + 1
		end

		_peers_with_score[peer_id] = true
	end

	return num
end

local tbl_4 = {}

LevelEndViewVersus.get_hero_from_score = function (self, arg_38_1, arg_38_2)
	-- function 38
	local profile_index = arg_38_1.profile_index
	local career_index = arg_38_1.career_index
	local var_38_2 = SPProfiles[profile_index].careers[career_index]
	local var_38_3
	local var_38_4
	local var_38_5
	local weapon_pose = arg_38_1.weapon_pose

	weapon_pose = not weapon_pose and arg_38_1.weapon_pose.item_name

	if not weapon_pose then
		local var_38_7 = ItemMasterList[weapon_pose]

		if not var_38_7 then
			local skin_name = arg_38_1.weapon_pose.skin_name
			local parent = var_38_7.parent
			local var_38_10 = rawget(ItemMasterList, parent)

			var_38_10 = not var_38_10 and ItemMasterList[parent]

			if not var_38_10 then
				var_38_3 = {
					item_name = parent,
					skin_name = skin_name
				}
				var_38_4 = var_38_10.slot_type
				var_38_5 = var_38_7.data.anim_event
			end
		end
	end

	local weapon = arg_38_1.weapon

	weapon = not weapon and arg_38_1.weapon.item_name

	local slot_type = ItemMasterList[weapon].slot_type
	local award_settings = arg_38_2.awards[1].award_settings

	award_settings = award_settings or tbl_4

	local breeds = award_settings.breeds

	breeds = breeds or tbl_4

	local count

	if #breeds > 0 then
		count = #breeds

		if not count then
			-- Nothing
		end
	end

	count = 1

	::label_38_0::

	local next_random, var_38_17 = Math.next_random(self._random_seed, 1, count)

	self._random_seed = next_random

	local var_38_18 = breeds[var_38_17]

	var_38_18 = var_38_18 or tbl_4

	local flag = not var_38_18 and var_38_18.name

	if not var_38_18 then
		-- Nothing
	end

	::label_38_1::

	local pactsworn_cosmetics = arg_38_1.pactsworn_cosmetics

	pactsworn_cosmetics = not pactsworn_cosmetics and arg_38_1.pactsworn_cosmetics[flag]

	::label_38_2::

	if not pactsworn_cosmetics then
		-- Nothing
	end

	::label_38_3::

	local default_gear = var_38_18.default_gear

	default_gear = default_gear or tbl_4

	::label_38_4::

	local weapon_2 = default_gear.weapon

	if not weapon_2 then
		weapon_2 = default_gear.slot_melee
		weapon_2 = weapon_2 or default_gear.slot_ranged
	end

	local tbl

	if not weapon_2 then
		tbl = {
			item_name = weapon_2
		}

		if not tbl then
			-- Nothing
		end
	end

	tbl = nil

	do
		local flag_2
	end

	::label_38_5::

	flag_2 = (not not table.is_empty(default_gear) or not default_gear.weapon_slot) and default_gear.weapon_slot == "slot_melee" and "melee" and "ranged" or not default_gear.slot_melee and "melee" and "ranged"

	local skin = default_gear.skin

	skin = skin or default_gear.slot_skin

	local tbl_2 = {
		stats_id = arg_38_1.stats_id,
		player_name = arg_38_1.name,
		peer_id = arg_38_1.peer_id,
		profile_index = profile_index,
		career_index = career_index,
		hero_name = var_38_2.profile_name,
		skin_name = skin or arg_38_1.hero_skin,
		frame_name = arg_38_1.portrait_frame,
		player_level = arg_38_1.player_level
	}
	local award_material = award_settings.award_material

	award_material = award_material or nil
	tbl_2.award_material = award_material
	tbl_2.versus_player_level = arg_38_1.versus_player_level
	tbl_2.weapon_slot = flag_2 or var_38_4 or slot_type
	tbl_2.breed = var_38_18
	tbl_2.weapon_pose_anim_event = var_38_5
	tbl_2.random_seed = self._random_seed

	local tbl_3 = {}
	local hat

	if not table.is_empty(var_38_18) then
		hat = arg_38_1.hat

		if not hat then
			-- Nothing
		end
	end

	hat = nil

	::label_38_6::

	tbl_3[1] = hat
	tbl_3[2] = tbl or var_38_3 or arg_38_1.weapon
	tbl_2.preview_items = tbl_3

	return tbl_2
end

LevelEndViewVersus._gather_hero_locations = function (arg_39_0, arg_39_1)
	-- function 39
	local tbl = {}
	local tbl_2 = {}
	local str = "levels/carousel_podium/world"
	local unit_indices = LevelResource.unit_indices(str, "units/hub_elements/versus_podium_character_spawn")

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(str, v)
		local get = DynamicData.get(unit_data, "name")

		if not get and not string.find(get, "ceremony_slot_") then
			local unit_position = LevelResource.unit_position(str, v)

			tbl[tonumber(string.gsub(get, "ceremony_slot_", ""), 10)] = {
				unit_position[1],
				unit_position[2],
				unit_position[3]
			}
		end
	end

	for k_2 = 1, arg_39_1 do
		local var_39_7 = tbl[k_2]

		var_39_7 = var_39_7 or {
			0,
			0,
			0
		}
		tbl_2[k_2] = var_39_7
	end

	return tbl_2
end

LevelEndViewVersus._setup_team_previewer = function (self, arg_40_1)
	-- function 40
	if not self._team_previewer then
		return
	end

	local get_viewport_world, var_40_1 = self:get_viewport_world()

	self._team_previewer = TeamPreviewer:new(self.context, get_viewport_world, var_40_1)

	local _team_heroes = self._team_heroes
	local _gather_hero_locations = self:_gather_hero_locations(arg_40_1)

	self._team_previewer:setup_team(_team_heroes, _gather_hero_locations)

	if not table.is_empty(self._portrait_widgets) then
		self:_create_ceremony_award_widgets(_team_heroes, _gather_hero_locations)
	end

	self._hero_previewers = {}

	for i = 1, arg_40_1 do
		self._hero_previewers[i] = self._team_previewer:get_hero_previewer(i)
	end
end

LevelEndViewVersus._create_ceremony_award_widgets = function (self, arg_41_1, arg_41_2)
	-- function 41
	local get_viewport_world, var_41_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_41_1)
	local party_composition = self.context.party_composition
	local peer_id = Network.peer_id()
	local num = 1
	local var_41_6 = party_composition[PlayerUtils.unique_player_id(peer_id, num)]

	for i = 1, #arg_41_1 do
		local var_41_7 = arg_41_1[i]
		local profile_index = var_41_7.profile_index
		local career_index = var_41_7.career_index
		local var_41_10 = arg_41_2[i]
		local world_to_screen = Camera.world_to_screen(camera, Vector3(var_41_10[1], var_41_10[2], var_41_10[3]))
		local var_41_12 = UIInverseScaleVectorToResolution(world_to_screen, true)
		local var_41_13 = party_composition[var_41_7.stats_id]
		local var_41_14 = self._sorted_awards[i].awards[1]
		local tbl = {
			camera = camera,
			world_pos = var_41_10,
			player_name = var_41_7.player_name
		}
		local versus_player_level = var_41_7.versus_player_level

		versus_player_level = versus_player_level or 0
		tbl.level = versus_player_level
		tbl.peer_id = var_41_7.peer_id
		tbl.is_mvp = var_41_14.header == "mvp"
		tbl.header = var_41_14.header
		tbl.sound_event = var_41_14.sound

		local sub_header = var_41_14.sub_header

		sub_header = sub_header or ""
		tbl.sub_header = sub_header

		local amount = var_41_14.amount

		amount = amount or ""
		tbl.amount = amount

		local award_material = var_41_14.award_material

		award_material = award_material or nil
		tbl.award_material = award_material

		local award_mask_material = var_41_14.award_mask_material

		award_mask_material = award_mask_material or nil
		tbl.award_mask_material = award_mask_material

		local screen_sub_header = var_41_14.screen_sub_header

		screen_sub_header = screen_sub_header or ""
		tbl.screen_sub_header = screen_sub_header

		local get_color_table_with_alpha

		if var_41_13 == var_41_6 then
			get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

			if not get_color_table_with_alpha then
				-- Nothing
			end
		end

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

		::label_41_0::

		tbl.team_color = get_color_table_with_alpha
		tbl.is_local = var_41_13 == var_41_6

		local str = "award_" .. i
		local create_ceremony_award = UIWidgets.create_ceremony_award(str, tbl, {
			var_41_12[1] - 145,
			200,
			0
		})
		local var_41_25 = UIWidget.init(create_ceremony_award)
		local str_2 = "screen_award"
		local create_screen_ceremony_award = UIWidgets.create_screen_ceremony_award(str_2, tbl, {
			0,
			0,
			0
		}, self.ui_renderer)
		local var_41_28 = UIWidget.init(create_screen_ceremony_award)
		local str_3 = "insignia_" .. i

		self._widgets_by_name[str_3] = var_41_25
		self._award_widgets[#self._award_widgets + 1] = var_41_25

		local str_4 = "screen_award_" .. i

		self._widgets_by_name[str_4] = var_41_28
		self._screen_award_widgets[#self._screen_award_widgets + 1] = var_41_28
		var_41_25.content.visible = false
		var_41_25.content.widget_offset = var_41_25.offset
		var_41_28.content.visible = false
	end
end

LevelEndViewVersus.create_world = function (self, arg_42_1)
	-- function 42
	local str = "end_screen"
	local str_2 = "environment/ui_store_preview"
	local num = 2
	local get_world_flags = self:get_world_flags()
	local create_world = Managers.world:create_world(str, str_2, nil, num, unpack(get_world_flags))

	World.set_data(create_world, "avoid_blend", true)

	local world = Managers.world:world("top_ingame_view")

	return create_world, world
end

LevelEndViewVersus.spawn_level = function (self, arg_43_1, arg_43_2)
	-- function 43
	local str = "levels/carousel_podium/world"
	local tbl = {}
	local var_43_2
	local var_43_3
	local var_43_4
	local var_43_5
	local flag = false
	local spawn_level = ScriptWorld.spawn_level(arg_43_2, str, tbl, var_43_2, var_43_3, var_43_4, var_43_5, flag)

	Level.spawn_background(spawn_level)
	Level.trigger_level_loaded(spawn_level)
	self:_register_object_sets(spawn_level, str)
	Level.trigger_event(spawn_level, "ceremoni_enabled")

	return spawn_level
end

LevelEndViewVersus.event_show_flow_object_set = function (self, arg_44_1, arg_44_2)
	-- function 44
	local str = "flow_" .. arg_44_1

	self:_show_object_set(str, arg_44_2)
end

LevelEndViewVersus.exit_to_game = function (self)
	-- function 45
	LevelEndViewVersus.super.exit_to_game(self)
	self:play_sound(self._stop_music_event)
end

LevelEndViewVersus.activate_back_to_keep_button = function (self)
	-- function 46
	local _machine = self._machine
	local state = self._machine:state()

	if not state.activate_back_to_keep_button then
		state:activate_back_to_keep_button()
	end

	self:set_input_description("continue_available")
end
