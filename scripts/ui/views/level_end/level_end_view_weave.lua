-- chunkname: @scripts/ui/views/level_end/level_end_view_weave.lua

require("scripts/ui/views/level_end/level_end_view_base")
require("scripts/ui/views/level_end/states/end_view_state_summary")
require("scripts/ui/views/team_previewer")

local var_0_0 = local_require("scripts/ui/views/level_end/level_end_view_v2_definitions")
local widgets_definitions = var_0_0.widgets_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local animations = var_0_0.animations
local generic_input_actions = var_0_0.generic_input_actions
local flag = false
local flag_2 = false
local testify = script_data.testify

testify = not testify and require("scripts/ui/views/level_end/level_end_view_weave_testify")
LevelEndViewWeave = class(LevelEndViewWeave, LevelEndViewBase)

LevelEndViewWeave.init = function (self, arg_1_1)
	-- function 1
	self._team_heroes = {}
	self._team_previewer = nil
	self._peers_with_score = {}

	LevelEndViewWeave.super.init(self, arg_1_1)
end

LevelEndViewWeave.start = function (self)
	-- function 2
	LevelEndViewWeave.super.start(self)

	self._playing_music = nil

	local flag

	flag = not self.game_won and "Play_won_music" and "Play_lost_music"
	self._start_music_event = flag

	local flag_2

	flag_2 = not self.game_won and "Stop_won_music" and "Stop_lost_music"
	self._stop_music_event = flag_2
end

LevelEndViewWeave.destroy = function (self)
	-- function 3
	LevelEndViewWeave.super.destroy(self)
	self:_destroy_team_previewer()
	Managers.state.event:unregister("trigger_hero_pose", self)
end

LevelEndViewWeave.setup_pages = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0

	if not GameSettingsDevelopment.read_only_backend then
		var_4_0 = self:_setup_pages_untrusted()
	elseif not arg_4_1 then
		var_4_0 = self:_setup_pages_victory(arg_4_2)
	else
		var_4_0 = self:_setup_pages_defeat(arg_4_2)
	end

	return var_4_0
end

LevelEndViewWeave._setup_pages_untrusted = function (arg_5_0)
	-- function 5
	return {
		EndViewStateWeave = 1
	}
end

LevelEndViewWeave._setup_pages_victory = function (arg_6_0, arg_6_1)
	-- function 6
	return {
		EndViewStateSummary = 2,
		EndViewStateWeave = 1
	}
end

LevelEndViewWeave._setup_pages_defeat = function (arg_7_0, arg_7_1)
	-- function 7
	return {
		EndViewStateSummary = 1
	}
end

LevelEndViewWeave.create_ui_elements = function (self)
	-- function 8
	if not self._team_previewer then
		self:_destroy_team_previewer()
	end

	if not self.game_won then
		local get_num_players = Managers.weave:get_num_players()

		self:_setup_team_heroes(self.context.players_session_score, get_num_players)
		self:_setup_team_previewer(get_num_players)
	end
end

LevelEndViewWeave.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	LevelEndViewWeave.super.update(self, arg_9_1, arg_9_2)
	self:_update_team_previewer(arg_9_1, arg_9_2)
	self:_update_camera_look_up(arg_9_1, arg_9_2)

	if not self._playing_music then
		self._playing_music = true

		self:play_sound(self._start_music_event)
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

LevelEndViewWeave.event_trigger_hero_pose = function (self, arg_10_1)
	-- function 10
	self._team_previewer:trigger_hero_pose(arg_10_1)
end

LevelEndViewWeave.set_input_description = function (self, arg_11_1)
	-- function 11
	local var_11_0 = var_0_0.generic_input_actions[arg_11_1]

	self._menu_input_description:set_input_description(var_11_0)
end

LevelEndViewWeave.destroy = function (arg_12_0)
	-- function 12
	LevelEndViewWeave.super.destroy(arg_12_0)
end

LevelEndViewWeave.active_input_service = function (self)
	-- function 13
	local FAKE_INPUT_SERVICE

	if not self.input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_13_0::

	return FAKE_INPUT_SERVICE
end

LevelEndViewWeave._retry_level = function (self)
	-- function 14
	if not self.is_server then
		self:signal_done(true)
	else
		self:signal_done(true)
	end
end

LevelEndViewWeave.do_retry = function (self)
	-- function 15
	if not GameSettingsDevelopment.allow_retry_weave then
		return false
	end

	local num = 0
	local size = table.size(self._wants_reload)

	for k, v in pairs(self._wants_reload) do
		if not v then
			num = num + 1
		end
	end

	if num >= size * 0.5 then
		self:_setup_weave_data()

		return true
	end
end

LevelEndViewWeave._setup_weave_data = function (self)
	-- function 16
	local weave = Managers.weave
	local num = 1
	local get_active_weave = weave:get_active_weave()
	local var_16_3 = WeaveSettings.templates[get_active_weave]
	local level_id = var_16_3.objectives[num].level_id
	local str = "weave"
	local str_2 = "weave"

	if not self.is_server then
		Managers.mechanism:choose_next_state(str)
		Managers.mechanism:progress_state()

		local difficulty_key = var_16_3.difficulty_key
		local var_16_8
		local flag = true
		local flag_2 = false
		local is_trusted = Managers.eac:is_trusted()

		Managers.matchmaking:set_matchmaking_data(level_id, difficulty_key, var_16_8, str, flag, flag_2, is_trusted, nil, str_2)
	end

	Managers.weave:set_next_weave(get_active_weave)
	Managers.weave:set_next_objective(num)
end

local num = 0.07
local num_2 = 1.36
local num_3 = -1.9
local num_4 = 0.15
local num_5 = 0
local tbl = {
	{
		{
			num,
			num_3,
			num_5
		}
	},
	{
		{
			num + num_2 * 0.5,
			num_3 + num_4 * 0.5,
			num_5
		},
		{
			num + num_2 * -0.5,
			num_3 + num_4 * -0.5,
			num_5
		}
	},
	{
		{
			num + num_2 * 1,
			num_3 + num_4 * 1,
			num_5
		},
		{
			num + num_2 * 0,
			num_3 + num_4 * 0,
			num_5
		},
		{
			num + num_2 * -1,
			num_3 + num_4 * -1,
			num_5
		}
	},
	{
		{
			num + num_2 * 1.5,
			num_3 + num_4 * 1.5,
			num_5
		},
		{
			num + num_2 * 0.5,
			num_3 + num_4 * 0.5,
			num_5
		},
		{
			num + num_2 * -0.5,
			num_3 + num_4 * -0.5,
			num_5
		},
		{
			num + num_2 * -1.5,
			num_3 + num_4 * -1.5,
			num_5
		}
	}
}

LevelEndViewWeave._destroy_team_previewer = function (self)
	-- function 17
	if not self._team_previewer then
		self._team_previewer:on_exit()

		self._team_previewer = nil
	end
end

LevelEndViewWeave._update_team_previewer = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _team_previewer = self._team_previewer

	if not _team_previewer then
		_team_previewer:update(arg_18_1, arg_18_2)
		_team_previewer:post_update(arg_18_1, arg_18_2)
	end
end

LevelEndViewWeave._setup_team_previewer = function (self, arg_19_1)
	-- function 19
	if not self._team_previewer then
		return
	end

	local get_viewport_world, var_19_1 = self:get_viewport_world()

	self._team_previewer = TeamPreviewer:new(self.context, get_viewport_world, var_19_1)

	local _team_heroes = self._team_heroes
	local count = #_team_heroes

	self._team_previewer:setup_team(_team_heroes, tbl[arg_19_1])
end

LevelEndViewWeave._setup_team_heroes = function (self, arg_20_1, arg_20_2)
	-- function 20
	local tbl = {}

	for k in pairs(arg_20_1) do
		table.insert(tbl, k)
	end

	table.sort(tbl)

	local _team_heroes = self._team_heroes
	local _peers_with_score = self._peers_with_score

	table.clear(_team_heroes)
	table.clear(_peers_with_score)

	for j = 1, arg_20_2 do
		local var_20_3 = tbl[j]

		if not var_20_3 then
			local var_20_4 = arg_20_1[var_20_3]

			_team_heroes[#_team_heroes + 1] = self:get_hero_from_score(var_20_4)
			_peers_with_score[var_20_4.peer_id] = true
		end
	end
end

LevelEndViewWeave.get_hero_from_score = function (arg_21_0, arg_21_1)
	-- function 21
	local profile_index = arg_21_1.profile_index
	local career_index = arg_21_1.career_index
	local var_21_2 = SPProfiles[profile_index].careers[career_index]
	local var_21_3
	local var_21_4
	local var_21_5
	local weapon_pose = arg_21_1.weapon_pose

	weapon_pose = not weapon_pose and arg_21_1.weapon_pose.item_name

	if not weapon_pose then
		local var_21_7 = ItemMasterList[weapon_pose]

		if not var_21_7 then
			local skin_name = arg_21_1.weapon_pose.skin_name
			local parent = var_21_7.parent
			local var_21_10 = rawget(ItemMasterList, parent)

			if not var_21_10 then
				var_21_4 = {
					item_name = parent,
					skin_name = skin_name
				}
				var_21_5 = var_21_10.slot_type
				var_21_3 = var_21_7.data.anim_event
			end
		end
	end

	local tbl = {
		profile_index = profile_index,
		career_index = career_index,
		hero_name = var_21_2.profile_name,
		skin_name = arg_21_1.hero_skin
	}

	if not var_21_5 then
		-- Nothing
	end

	do
		local preview_wield_slot
	end

	::label_21_0::

	if not arg_21_1.weapon then
		preview_wield_slot = var_21_2.preview_wield_slot

		if not preview_wield_slot then
			-- Nothing
		end
	end

	preview_wield_slot = nil

	::label_21_1::

	tbl.weapon_slot = preview_wield_slot
	tbl.weapon_pose_anim_event = var_21_3
	tbl.preview_items = {
		arg_21_1.hat,
		var_21_4 or arg_21_1.weapon
	}

	return tbl
end

local str = "levels/end_screen_victory/world"

LevelEndViewWeave.setup_camera = function (self)
	-- function 22
	local var_22_0
	local unit_indices = LevelResource.unit_indices(str, "units/hub_elements/cutscene_camera/cutscene_camera")

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(str, v)
		local get = DynamicData.get(unit_data, "name")

		if not (not get and get ~= "end_screen_camera") then
			local unit_position = LevelResource.unit_position(str, v)
			local unit_rotation = LevelResource.unit_rotation(str, v)
			local from_quaternion_position = Matrix4x4.from_quaternion_position(unit_rotation, unit_position)

			var_22_0 = Matrix4x4Box(from_quaternion_position)

			print("Found camera: " .. get)

			self._camera_unit = Level.unit_by_index(self._level, v)
		end
	end

	self._camera_pose = var_22_0

	self:position_camera(nil, 45)
end

LevelEndViewWeave.start_camera_look_up = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	self._camera_look_up_time = -arg_23_1
	self._camera_look_up_duration = arg_23_2
	self._camera_look_up_degrees = arg_23_3

	if not self._story_id then
		if not self._storyteller:is_playing(self._story_id) then
			self._storyteller:stop(self._story_id)
		end

		self._story_id = nil
	end
end

LevelEndViewWeave._update_camera_look_up = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _camera_look_up_time = self._camera_look_up_time

	if not _camera_look_up_time then
		return
	end

	local _camera_look_up_duration = self._camera_look_up_duration
	local _camera_look_up_degrees = self._camera_look_up_degrees
	local clamp = math.clamp(_camera_look_up_time / _camera_look_up_duration, 0, 1)
	local easeCubic = math.easeCubic(clamp)
	local num = _camera_look_up_time + arg_24_1
	local clamp_2 = math.clamp(num / _camera_look_up_duration, 0, 1)
	local easeCubic_2 = math.easeCubic(clamp_2)
	local degrees_to_radians = math.degrees_to_radians(_camera_look_up_degrees * easeCubic)
	local degrees_to_radians_2 = math.degrees_to_radians(_camera_look_up_degrees * easeCubic_2)
	local var_24_10 = Quaternion(Vector3.right(), degrees_to_radians_2 - degrees_to_radians)
	local get_camera_rotation = self:get_camera_rotation()
	local multiply = Quaternion.multiply(get_camera_rotation, var_24_10)

	self:set_camera_rotation(multiply)

	if clamp_2 == 1 then
		self._camera_look_up_time = nil
	else
		self._camera_look_up_time = num
	end
end

LevelEndViewWeave.spawn_level = function (self, arg_25_1, arg_25_2)
	-- function 25
	local tbl = {}
	local var_25_1
	local var_25_2
	local var_25_3
	local var_25_4
	local flag = false
	local spawn_level = ScriptWorld.spawn_level(arg_25_2, str, tbl, var_25_1, var_25_2, var_25_3, var_25_4, flag)

	Level.spawn_background(spawn_level)
	Level.trigger_level_loaded(spawn_level)
	self:_register_object_sets(spawn_level, str)

	return spawn_level
end

LevelEndViewWeave.exit_to_game = function (self)
	-- function 26
	self:play_sound(self._stop_music_event)

	self._exit_timer = 0.5
	self._started_exit = true
end

LevelEndViewWeave.update_force_shutdown = function (self, arg_27_1)
	-- function 27
	self._force_shutdown_timer = math.max(0, self._force_shutdown_timer - arg_27_1)

	if not (self._force_shutdown_timer ~= 0 or self._signaled_done) then
		self:signal_done(false)

		self._signaled_done = true
	elseif not self._left_lobby then
		local flag = true
		local members = self._lobby:members()

		if not members then
			local get_members = members:get_members()

			for i = 1, #get_members do
				local var_27_3 = get_members[i]
				local var_27_4 = self._done_peers[var_27_3]
				local var_27_5 = self._peers_with_score[var_27_3]

				if var_27_4 or not var_27_5 then
					flag = false

					break
				end
			end
		end

		self._all_signaled_done = flag
	end

	if not self._started_exit then
		self._started_force_shutdown = false
	end
end

LevelEndViewWeave.get_all_signaled_done = function (self)
	-- function 28
	return self._all_signaled_done
end
