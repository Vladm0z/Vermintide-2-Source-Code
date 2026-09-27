-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_character_info.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_character_info_definitions")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false
local num = 1

HeroWindowCharacterInfo = class(HeroWindowCharacterInfo)
HeroWindowCharacterInfo.NAME = "HeroWindowCharacterInfo"

HeroWindowCharacterInfo.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCharacterInfo")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.ingame_ui = ingame_ui_context.ingame_ui

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.profile_index = arg_1_1.profile_index
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
end

HeroWindowCharacterInfo.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_2
		tbl_2[k] = var_2_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	self:_create_insignia_widget()
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

HeroWindowCharacterInfo.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate HeroWindowCharacterInfo")

	self.ui_animator = nil
end

HeroWindowCharacterInfo.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_loadout_sync()
	self:_update_animations(arg_4_1)
	self:draw(arg_4_1)
end

HeroWindowCharacterInfo.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

HeroWindowCharacterInfo._update_animations = function (self, arg_6_1)
	-- function 6
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	ui_animator:update(arg_6_1)

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroWindowCharacterInfo.set_focus = function (self, arg_7_1)
	-- function 7
	self._focused = arg_7_1
end

HeroWindowCharacterInfo._update_loadout_sync = function (self)
	-- function 8
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id or not self:_has_hero_level_changed() then
		self:_update_experience_presentation()
		self:_update_hero_portrait_frame()

		self._loadout_sync_id = loadout_sync_id
	end
end

HeroWindowCharacterInfo._has_hero_level_changed = function (self)
	-- function 9
	local get_experience = ExperienceSettings.get_experience(self.hero_name)

	if ExperienceSettings.get_level(get_experience) ~= self._hero_level then
		return true
	end
end

HeroWindowCharacterInfo._update_experience_presentation = function (self)
	-- function 10
	local _widgets_by_name = self._widgets_by_name
	local get_experience = ExperienceSettings.get_experience(self.hero_name)
	local get_level, var_10_3 = ExperienceSettings.get_level(get_experience)
	local get_experience_pool = ExperienceSettings.get_experience_pool(self.hero_name)
	local get_extra_level, var_10_6 = ExperienceSettings.get_extra_level(get_experience_pool)
	local size = scenegraph_definition.experience_bar.size
	local size_2 = self.ui_scenegraph.experience_bar.size

	if var_10_3 > 0 then
		size_2[1] = math.ceil(size[1] * var_10_3)
	elseif var_10_6 > 0 then
		size_2[1] = math.ceil(size[1] * var_10_6)
	end

	local str = Localize("level") .. " " .. tostring(get_level)

	if not (not get_extra_level and not (get_extra_level > 0)) then
		str = str .. " (+" .. tostring(get_extra_level) .. ")"
	end

	_widgets_by_name.level_text.content.text = str
	self._hero_level = get_level
end

HeroWindowCharacterInfo._update_hero_portrait_frame = function (self)
	-- function 11
	local career_index = self.career_index
	local profile_index = self.profile_index
	local var_11_2 = SPProfiles[profile_index]
	local var_11_3 = var_11_2.careers[career_index]
	local portrait_image = var_11_3.portrait_image
	local display_name = var_11_3.display_name
	local character_name = var_11_2.character_name
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.hero_name.content.text = character_name
	_widgets_by_name.career_name.content.text = display_name

	local var_11_8

	if not self._hero_level then
		var_11_8 = tostring(self._hero_level)

		if not var_11_8 then
			-- Nothing
		end
	end

	var_11_8 = "-"

	::label_11_0::

	local _get_portrait_frame = self:_get_portrait_frame()

	self._portrait_widget = self:_create_portrait_frame_widget(_get_portrait_frame, portrait_image, var_11_8)
end

HeroWindowCharacterInfo._exit = function (self, arg_12_1)
	-- function 12
	self.exit = true
	self.exit_level_id = arg_12_1
end

HeroWindowCharacterInfo.draw = function (self, arg_13_1)
	-- function 13
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_13_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	if not self._portrait_widget then
		UIRenderer.draw_widget(ui_top_renderer, self._portrait_widget)
	end

	if not self._insignia_widget then
		UIRenderer.draw_widget(ui_top_renderer, self._insignia_widget)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

HeroWindowCharacterInfo._play_sound = function (self, arg_14_1)
	-- function 14
	self.parent:play_sound(arg_14_1)
end

HeroWindowCharacterInfo._create_portrait_frame_widget = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local create_portrait_frame = UIWidgets.create_portrait_frame("portrait_root", arg_15_1, arg_15_3, 1, nil, arg_15_2)
	local var_15_1 = UIWidget.init(create_portrait_frame, self.ui_top_renderer)

	var_15_1.content.frame_settings_name = arg_15_1

	return var_15_1
end

HeroWindowCharacterInfo._create_insignia_widget = function (self)
	-- function 16
	local local_player = Managers.player:local_player()
	local get_versus_player_level = ExperienceSettings.get_versus_player_level(local_player)
	local create_small_insignia = UIWidgets.create_small_insignia("insignia", get_versus_player_level)

	self._insignia_widget = UIWidget.init(create_small_insignia)
end

HeroWindowCharacterInfo._get_portrait_frame = function (self)
	-- function 17
	local profile_index = self.profile_index
	local career_index = self.career_index
	local hero_name = self.hero_name
	local name = SPProfiles[profile_index].careers[career_index].name
	local str = "default"
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_frame")

	str = not get_loadout_item and get_loadout_item.data.temporary_template and str

	return str
end
