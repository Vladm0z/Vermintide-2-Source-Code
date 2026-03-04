-- chunkname: @scripts/ui/views/level_end/level_end_view_weave.lua

require("scripts/ui/views/level_end/level_end_view_base")
require("scripts/ui/views/level_end/states/end_view_state_summary")
require("scripts/ui/views/team_previewer")

local var_0_0 = local_require("scripts/ui/views/level_end/level_end_view_v2_definitions")
local var_0_1 = var_0_0.widgets_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animations
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = false
local var_0_6 = false
local var_0_7 = script_data.testify and require("scripts/ui/views/level_end/level_end_view_weave_testify")

LevelEndViewWeave = class(LevelEndViewWeave, LevelEndViewBase)

function LevelEndViewWeave.init(arg_1_0, arg_1_1)
	arg_1_0._team_heroes = {}
	arg_1_0._team_previewer = nil
	arg_1_0._peers_with_score = {}

	LevelEndViewWeave.super.init(arg_1_0, arg_1_1)
end

function LevelEndViewWeave.start(arg_2_0)
	LevelEndViewWeave.super.start(arg_2_0)

	arg_2_0._playing_music = nil
	arg_2_0._start_music_event = arg_2_0.game_won and "Play_won_music" or "Play_lost_music"
	arg_2_0._stop_music_event = arg_2_0.game_won and "Stop_won_music" or "Stop_lost_music"
end

function LevelEndViewWeave.destroy(arg_3_0)
	LevelEndViewWeave.super.destroy(arg_3_0)
	arg_3_0:_destroy_team_previewer()
	Managers.state.event:unregister("trigger_hero_pose", arg_3_0)
end

function LevelEndViewWeave.setup_pages(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0

	if arg_4_0._is_untrusted then
		var_4_0 = arg_4_0:_setup_pages_untrusted()
	elseif arg_4_1 then
		var_4_0 = arg_4_0:_setup_pages_victory(arg_4_2)
	else
		var_4_0 = arg_4_0:_setup_pages_defeat(arg_4_2)
	end

	return var_4_0
end

function LevelEndViewWeave._setup_pages_untrusted(arg_5_0)
	return {
		EndViewStateWeave = 1
	}
end

function LevelEndViewWeave._setup_pages_victory(arg_6_0, arg_6_1)
	return {
		EndViewStateSummary = 2,
		EndViewStateWeave = 1
	}
end

function LevelEndViewWeave._setup_pages_defeat(arg_7_0, arg_7_1)
	return {
		EndViewStateSummary = 1
	}
end

function LevelEndViewWeave.create_ui_elements(arg_8_0)
	if arg_8_0._team_previewer then
		arg_8_0:_destroy_team_previewer()
	end

	if arg_8_0.game_won then
		local var_8_0 = Managers.weave:get_num_players()

		arg_8_0:_setup_team_heroes(arg_8_0.context.players_session_score, var_8_0)
		arg_8_0:_setup_team_previewer(var_8_0)
	end
end

function LevelEndViewWeave.update(arg_9_0, arg_9_1, arg_9_2)
	LevelEndViewWeave.super.update(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:_update_team_previewer(arg_9_1, arg_9_2)
	arg_9_0:_update_camera_look_up(arg_9_1, arg_9_2)

	if not arg_9_0._playing_music then
		arg_9_0._playing_music = true

		arg_9_0:play_sound(arg_9_0._start_music_event)
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_7, arg_9_0)
	end
end

function LevelEndViewWeave.event_trigger_hero_pose(arg_10_0, arg_10_1)
	arg_10_0._team_previewer:trigger_hero_pose(arg_10_1)
end

function LevelEndViewWeave.set_input_description(arg_11_0, arg_11_1)
	local var_11_0 = var_0_0.generic_input_actions[arg_11_1]

	arg_11_0._menu_input_description:set_input_description(var_11_0)
end

function LevelEndViewWeave.destroy(arg_12_0)
	LevelEndViewWeave.super.destroy(arg_12_0)
end

function LevelEndViewWeave.active_input_service(arg_13_0)
	return arg_13_0.input_blocked and FAKE_INPUT_SERVICE or arg_13_0:input_service()
end

function LevelEndViewWeave._retry_level(arg_14_0)
	if arg_14_0.is_server then
		arg_14_0:signal_done(true)
	else
		arg_14_0:signal_done(true)
	end
end

function LevelEndViewWeave.do_retry(arg_15_0)
	if not GameSettingsDevelopment.allow_retry_weave then
		return false
	end

	local var_15_0 = 0
	local var_15_1 = table.size(arg_15_0._wants_reload)

	for iter_15_0, iter_15_1 in pairs(arg_15_0._wants_reload) do
		if iter_15_1 then
			var_15_0 = var_15_0 + 1
		end
	end

	if var_15_0 >= var_15_1 * 0.5 then
		arg_15_0:_setup_weave_data()

		return true
	end
end

function LevelEndViewWeave._setup_weave_data(arg_16_0)
	local var_16_0 = Managers.weave
	local var_16_1 = 1
	local var_16_2 = var_16_0:get_active_weave()
	local var_16_3 = WeaveSettings.templates[var_16_2]
	local var_16_4 = var_16_3.objectives[var_16_1].level_id
	local var_16_5 = "weave"
	local var_16_6 = "weave"

	if arg_16_0.is_server then
		Managers.mechanism:choose_next_state(var_16_5)
		Managers.mechanism:progress_state()

		local var_16_7 = var_16_3.difficulty_key
		local var_16_8
		local var_16_9 = true
		local var_16_10 = false
		local var_16_11 = Managers.eac:is_trusted()

		Managers.matchmaking:set_matchmaking_data(var_16_4, var_16_7, var_16_8, var_16_5, var_16_9, var_16_10, var_16_11, nil, var_16_6)
	end

	Managers.weave:set_next_weave(var_16_2)
	Managers.weave:set_next_objective(var_16_1)
end

local var_0_8 = 0.07
local var_0_9 = 1.36
local var_0_10 = -1.9
local var_0_11 = 0.15
local var_0_12 = 0
local var_0_13 = {
	{
		{
			var_0_8,
			var_0_10,
			var_0_12
		}
	},
	{
		{
			var_0_8 + var_0_9 * 0.5,
			var_0_10 + var_0_11 * 0.5,
			var_0_12
		},
		{
			var_0_8 + var_0_9 * -0.5,
			var_0_10 + var_0_11 * -0.5,
			var_0_12
		}
	},
	{
		{
			var_0_8 + var_0_9 * 1,
			var_0_10 + var_0_11 * 1,
			var_0_12
		},
		{
			var_0_8 + var_0_9 * 0,
			var_0_10 + var_0_11 * 0,
			var_0_12
		},
		{
			var_0_8 + var_0_9 * -1,
			var_0_10 + var_0_11 * -1,
			var_0_12
		}
	},
	{
		{
			var_0_8 + var_0_9 * 1.5,
			var_0_10 + var_0_11 * 1.5,
			var_0_12
		},
		{
			var_0_8 + var_0_9 * 0.5,
			var_0_10 + var_0_11 * 0.5,
			var_0_12
		},
		{
			var_0_8 + var_0_9 * -0.5,
			var_0_10 + var_0_11 * -0.5,
			var_0_12
		},
		{
			var_0_8 + var_0_9 * -1.5,
			var_0_10 + var_0_11 * -1.5,
			var_0_12
		}
	}
}

function LevelEndViewWeave._destroy_team_previewer(arg_17_0)
	if arg_17_0._team_previewer then
		arg_17_0._team_previewer:on_exit()

		arg_17_0._team_previewer = nil
	end
end

function LevelEndViewWeave._update_team_previewer(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._team_previewer

	if var_18_0 then
		var_18_0:update(arg_18_1, arg_18_2)
		var_18_0:post_update(arg_18_1, arg_18_2)
	end
end

function LevelEndViewWeave._setup_team_previewer(arg_19_0, arg_19_1)
	if arg_19_0._team_previewer then
		return
	end

	local var_19_0, var_19_1 = arg_19_0:get_viewport_world()

	arg_19_0._team_previewer = TeamPreviewer:new(arg_19_0.context, var_19_0, var_19_1)

	local var_19_2 = arg_19_0._team_heroes
	local var_19_3 = #var_19_2

	arg_19_0._team_previewer:setup_team(var_19_2, var_0_13[arg_19_1])
end

function LevelEndViewWeave._setup_team_heroes(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = {}

	for iter_20_0 in pairs(arg_20_1) do
		table.insert(var_20_0, iter_20_0)
	end

	table.sort(var_20_0)

	local var_20_1 = arg_20_0._team_heroes
	local var_20_2 = arg_20_0._peers_with_score

	table.clear(var_20_1)
	table.clear(var_20_2)

	for iter_20_1 = 1, arg_20_2 do
		local var_20_3 = var_20_0[iter_20_1]

		if var_20_3 then
			local var_20_4 = arg_20_1[var_20_3]

			var_20_1[#var_20_1 + 1] = arg_20_0:get_hero_from_score(var_20_4)
			var_20_2[var_20_4.peer_id] = true
		end
	end
end

function LevelEndViewWeave.get_hero_from_score(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.profile_index
	local var_21_1 = arg_21_1.career_index
	local var_21_2 = SPProfiles[var_21_0].careers[var_21_1]
	local var_21_3
	local var_21_4
	local var_21_5
	local var_21_6 = arg_21_1.weapon_pose and arg_21_1.weapon_pose.item_name

	if var_21_6 then
		local var_21_7 = ItemMasterList[var_21_6]

		if var_21_7 then
			local var_21_8 = arg_21_1.weapon_pose.skin_name
			local var_21_9 = var_21_7.parent
			local var_21_10 = rawget(ItemMasterList, var_21_9)

			if var_21_10 then
				var_21_4 = {
					item_name = var_21_9,
					skin_name = var_21_8
				}
				var_21_5 = var_21_10.slot_type
				var_21_3 = var_21_7.data.anim_event
			end
		end
	end

	return {
		profile_index = var_21_0,
		career_index = var_21_1,
		hero_name = var_21_2.profile_name,
		skin_name = arg_21_1.hero_skin,
		weapon_slot = var_21_5 or arg_21_1.weapon and var_21_2.preview_wield_slot or nil,
		weapon_pose_anim_event = var_21_3,
		preview_items = {
			arg_21_1.hat,
			var_21_4 or arg_21_1.weapon
		}
	}
end

local var_0_14 = "levels/end_screen_victory/world"

function LevelEndViewWeave.setup_camera(arg_22_0)
	local var_22_0
	local var_22_1 = LevelResource.unit_indices(var_0_14, "units/hub_elements/cutscene_camera/cutscene_camera")

	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		local var_22_2 = LevelResource.unit_data(var_0_14, iter_22_1)
		local var_22_3 = DynamicData.get(var_22_2, "name")

		if var_22_3 and var_22_3 == "end_screen_camera" then
			local var_22_4 = LevelResource.unit_position(var_0_14, iter_22_1)
			local var_22_5 = LevelResource.unit_rotation(var_0_14, iter_22_1)
			local var_22_6 = Matrix4x4.from_quaternion_position(var_22_5, var_22_4)

			var_22_0 = Matrix4x4Box(var_22_6)

			print("Found camera: " .. var_22_3)

			arg_22_0._camera_unit = Level.unit_by_index(arg_22_0._level, iter_22_1)
		end
	end

	arg_22_0._camera_pose = var_22_0

	arg_22_0:position_camera(nil, 45)
end

function LevelEndViewWeave.start_camera_look_up(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_0._camera_look_up_time = -arg_23_1
	arg_23_0._camera_look_up_duration = arg_23_2
	arg_23_0._camera_look_up_degrees = arg_23_3

	if arg_23_0._story_id then
		if arg_23_0._storyteller:is_playing(arg_23_0._story_id) then
			arg_23_0._storyteller:stop(arg_23_0._story_id)
		end

		arg_23_0._story_id = nil
	end
end

function LevelEndViewWeave._update_camera_look_up(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._camera_look_up_time

	if not var_24_0 then
		return
	end

	local var_24_1 = arg_24_0._camera_look_up_duration
	local var_24_2 = arg_24_0._camera_look_up_degrees
	local var_24_3 = math.clamp(var_24_0 / var_24_1, 0, 1)
	local var_24_4 = math.easeCubic(var_24_3)
	local var_24_5 = var_24_0 + arg_24_1
	local var_24_6 = math.clamp(var_24_5 / var_24_1, 0, 1)
	local var_24_7 = math.easeCubic(var_24_6)
	local var_24_8 = math.degrees_to_radians(var_24_2 * var_24_4)
	local var_24_9 = math.degrees_to_radians(var_24_2 * var_24_7)
	local var_24_10 = Quaternion(Vector3.right(), var_24_9 - var_24_8)
	local var_24_11 = arg_24_0:get_camera_rotation()
	local var_24_12 = Quaternion.multiply(var_24_11, var_24_10)

	arg_24_0:set_camera_rotation(var_24_12)

	if var_24_6 == 1 then
		arg_24_0._camera_look_up_time = nil
	else
		arg_24_0._camera_look_up_time = var_24_5
	end
end

function LevelEndViewWeave.spawn_level(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = {}
	local var_25_1
	local var_25_2
	local var_25_3
	local var_25_4
	local var_25_5 = false
	local var_25_6 = ScriptWorld.spawn_level(arg_25_2, var_0_14, var_25_0, var_25_1, var_25_2, var_25_3, var_25_4, var_25_5)

	Level.spawn_background(var_25_6)
	Level.trigger_level_loaded(var_25_6)
	arg_25_0:_register_object_sets(var_25_6, var_0_14)

	return var_25_6
end

function LevelEndViewWeave.exit_to_game(arg_26_0)
	arg_26_0:play_sound(arg_26_0._stop_music_event)

	arg_26_0._exit_timer = 0.5
	arg_26_0._started_exit = true
end

function LevelEndViewWeave.update_force_shutdown(arg_27_0, arg_27_1)
	arg_27_0._force_shutdown_timer = math.max(0, arg_27_0._force_shutdown_timer - arg_27_1)

	if arg_27_0._force_shutdown_timer == 0 and not arg_27_0._signaled_done then
		arg_27_0:signal_done(false)

		arg_27_0._signaled_done = true
	elseif not arg_27_0._left_lobby then
		local var_27_0 = true
		local var_27_1 = arg_27_0._lobby:members()

		if var_27_1 then
			local var_27_2 = var_27_1:get_members()

			for iter_27_0 = 1, #var_27_2 do
				local var_27_3 = var_27_2[iter_27_0]
				local var_27_4 = arg_27_0._done_peers[var_27_3]
				local var_27_5 = arg_27_0._peers_with_score[var_27_3]

				if not var_27_4 and var_27_5 then
					var_27_0 = false

					break
				end
			end
		end

		arg_27_0._all_signaled_done = var_27_0
	end

	if arg_27_0._started_exit then
		arg_27_0._started_force_shutdown = false
	end
end

function LevelEndViewWeave.get_all_signaled_done(arg_28_0)
	return arg_28_0._all_signaled_done
end
