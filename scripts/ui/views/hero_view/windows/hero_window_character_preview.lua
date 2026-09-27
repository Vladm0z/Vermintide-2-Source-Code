-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_character_preview.lua

require("scripts/ui/views/menu_world_previewer")
require("scripts/settings/hero_statistics_template")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_character_preview_definitions")
local widgets = var_0_0.widgets
local viewport_widget = var_0_0.viewport_widget
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local camera_position_by_character = var_0_0.camera_position_by_character
local loading_overlay_widgets = var_0_0.loading_overlay_widgets
local flag = false

HeroWindowCharacterPreview = class(HeroWindowCharacterPreview)
HeroWindowCharacterPreview.NAME = "HeroWindowCharacterPreview"

HeroWindowCharacterPreview.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCharacterPreview")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.skin_sync_id = self.parent.skin_sync_id
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
	self:_show_weapon_disclaimer(false)

	if not Managers.mechanism:mechanism_setting("should_display_weapon_disclaimer") then
		self:_show_weapon_disclaimer(true)
	end
end

HeroWindowCharacterPreview.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

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

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(loading_overlay_widgets) do
		local var_2_5 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_2_5
		tbl_4[k_2] = var_2_5
	end

	self._loading_overlay_widgets = tbl_3
	self._loading_overlay_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end

	self._level_package_name = viewport_widget.style.viewport.level_package_name

	local var_2_7
	local flag = true

	Managers.package:load(self._level_package_name, "HeroWindowCharacterPreview", var_2_7, flag)

	self._show_loading_overlay = true

	if not Development.parameter("hero_statistics") then
		tbl_2.detailed.content.visible = false
	end
end

HeroWindowCharacterPreview.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate HeroWindowCharacterPreview")

	self.ui_animator = nil

	if not self.world_previewer then
		self.world_previewer:prepare_exit()
		self.world_previewer:on_exit()
		self.world_previewer:destroy()
	end

	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	Managers.package:unload(self._level_package_name, "HeroWindowCharacterPreview")

	self._level_package_name = nil
end

HeroWindowCharacterPreview.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	if not self.world_previewer and not self.hero_unit_spawned then
		self:_handle_input(arg_4_1, arg_4_2)

		local window_input_service = self.parent:window_input_service()

		self:_update_statistics_widget(window_input_service, arg_4_1)
	end

	self:_update_animations(arg_4_1)
	self:draw(arg_4_1)

	if not self.world_previewer then
		local _statistics_activate = self:_statistics_activate()

		self.world_previewer:update(arg_4_1, arg_4_2, _statistics_activate)
	end
end

HeroWindowCharacterPreview.post_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if self._viewport_widget or not Managers.package:has_loaded(self._level_package_name, "HeroWindowCharacterPreview") then
		self._viewport_widget = UIWidget.init(viewport_widget)
		self._fadeout_loading_overlay = true
	end

	self:_update_loading_overlay_fadeout_animation(arg_5_1)

	if self.initialized or not self._viewport_widget then
		local var_5_0 = MenuWorldPreviewer:new(self.ingame_ui_context, camera_position_by_character, "HeroWindowCharacterPreview")

		local function fn()
			-- function 6
			self.hero_unit_spawned = true
		end

		self.hero_unit_spawned = false

		var_5_0:on_enter(self._viewport_widget, self.hero_name)
		var_5_0:request_spawn_hero_unit(self.hero_name, self.career_index, false, fn)

		self.world_previewer = var_5_0
		self.initialized = true
	end

	if not self.world_previewer then
		if not self.hero_unit_spawned then
			self:_update_skin_sync()
			self:_update_loadout_sync()
			self:_update_wielded_slot()
		end

		self.world_previewer:post_update(arg_5_1, arg_5_2)
	end
end

local num = -1

HeroWindowCharacterPreview.respawn_hero = function (self)
	-- function 7
	local world_previewer = self.world_previewer

	if not world_previewer then
		return
	end

	self.hero_unit_spawned = false

	local function fn()
		-- function 8
		self.hero_unit_spawned = true
		self._loadout_sync_id = num

		self:_update_loadout_sync()

		self._selected_loadout_slot_index = num

		self:_update_wielded_slot()
	end

	world_previewer:respawn_hero_unit(self.hero_name, self.career_index, false, fn)
end

HeroWindowCharacterPreview._update_animations = function (self, arg_9_1)
	-- function 9
	self.ui_animator:update(arg_9_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name
end

HeroWindowCharacterPreview._update_loadout_sync = function (self)
	-- function 10
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self:_populate_loadout()

		self._loadout_sync_id = loadout_sync_id

		self:_sync_statistics()
	end
end

HeroWindowCharacterPreview._update_skin_sync = function (self)
	-- function 11
	local skin_sync_id = self.parent.skin_sync_id

	if skin_sync_id ~= self.skin_sync_id then
		self:respawn_hero()

		self.skin_sync_id = skin_sync_id
	end
end

HeroWindowCharacterPreview._update_wielded_slot = function (self)
	-- function 12
	local get_selected_loadout_slot_index = self.parent:get_selected_loadout_slot_index()

	if get_selected_loadout_slot_index ~= self._selected_loadout_slot_index then
		local slots_by_slot_index = InventorySettings.slots_by_slot_index

		for k, v in pairs(slots_by_slot_index) do
			if v.slot_index == get_selected_loadout_slot_index then
				local type = v.type

				if not (type == "melee" or type ~= "ranged") then
					self.world_previewer:wield_weapon_slot(type)

					break
				end
			end
		end

		if not self.world_previewer:wielded_slot_type() then
			self.world_previewer:wield_weapon_slot("melee")
		end

		self._selected_loadout_slot_index = get_selected_loadout_slot_index
	end
end

HeroWindowCharacterPreview._populate_loadout = function (self)
	-- function 13
	local world_previewer = self.world_previewer
	local hero_name = self.hero_name
	local slots_by_slot_index = InventorySettings.slots_by_slot_index
	local career_index = self.career_index
	local var_13_4 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_13_4].careers[career_index].name

	for k, v in pairs(slots_by_slot_index) do
		local name_2 = v.name
		local get_loadout_item = BackendUtils.get_loadout_item(name, name_2)

		if not get_loadout_item then
			local name_3 = get_loadout_item.data.name
			local type = v.type
			local item_name_by_slot_type = world_previewer:item_name_by_slot_type(type)

			if not (not name_3 and name_3 ~= item_name_by_slot_type and type == "melee" or type ~= "ranged") then
				local backend_id = get_loadout_item.backend_id

				world_previewer:equip_item(name_3, v, backend_id)
			end
		end
	end
end

HeroWindowCharacterPreview._is_button_pressed = function (arg_14_0, arg_14_1)
	-- function 14
	local button_hotspot = arg_14_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCharacterPreview._is_stepper_button_pressed = function (arg_15_0, arg_15_1)
	-- function 15
	local content = arg_15_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = false

		return true, -1
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = false

		return true, 1
	end
end

HeroWindowCharacterPreview._handle_input = function (self, arg_16_1, arg_16_2)
	-- function 16
	local detailed = self._widgets_by_name.detailed

	if not self:_is_button_pressed(detailed) then
		self:_handle_statistics_pressed()
	end
end

HeroWindowCharacterPreview._exit = function (self, arg_17_1)
	-- function 17
	self.exit = true
	self.exit_level_id = arg_17_1
end

HeroWindowCharacterPreview.draw = function (self, arg_18_1)
	-- function 18
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_18_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	if not self._show_loading_overlay then
		for i_2, v_2 in ipairs(self._loading_overlay_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_2)
		end
	end

	UIRenderer.end_pass(ui_top_renderer)

	if not self._viewport_widget then
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_18_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_renderer, self._viewport_widget)
		UIRenderer.end_pass(ui_renderer)
	end
end

HeroWindowCharacterPreview._play_sound = function (self, arg_19_1)
	-- function 19
	self.parent:play_sound(arg_19_1)
end

HeroWindowCharacterPreview._update_loading_overlay_fadeout_animation = function (self, arg_20_1)
	-- function 20
	if not self._fadeout_loading_overlay then
		return
	end

	local _loading_overlay_widgets_by_name = self._loading_overlay_widgets_by_name
	local num = 255
	local num_2 = 0
	local num_3 = 9
	local min = math.min
	local num_4 = 1
	local _fadeout_progress = self._fadeout_progress

	_fadeout_progress = _fadeout_progress or 0

	local var_20_7 = min(num_4, _fadeout_progress + num_3 * arg_20_1)
	local lerp = math.lerp(num, num_2, math.easeInCubic(var_20_7))
	local loading_overlay = _loading_overlay_widgets_by_name.loading_overlay
	local loading_overlay_loading_glow = _loading_overlay_widgets_by_name.loading_overlay_loading_glow
	local loading_overlay_loading_frame = _loading_overlay_widgets_by_name.loading_overlay_loading_frame

	loading_overlay.style.rect.color[1] = lerp
	loading_overlay_loading_glow.style.texture_id.color[1] = lerp
	loading_overlay_loading_frame.style.texture_id.color[1] = lerp
	self._fadeout_progress = var_20_7

	if var_20_7 == 1 then
		self._fadeout_loading_overlay = nil
		self._fadeout_progress = nil
		self._show_loading_overlay = false
	end
end

HeroWindowCharacterPreview._handle_statistics_pressed = function (self)
	-- function 21
	local detailed = self._widgets_by_name.detailed

	if not detailed.content.active then
		self:_deactivate_statistics()
	else
		self:_activate_statistics(detailed)
	end
end

HeroWindowCharacterPreview._statistics_activate = function (self)
	-- function 22
	return self._widgets_by_name.detailed.content.active
end

HeroWindowCharacterPreview._activate_statistics = function (self)
	-- function 23
	local detailed = self._widgets_by_name.detailed

	detailed.content.active = true
	detailed.content.list_content.active = true

	if detailed.content.scrollbar.percentage < 1 then
		detailed.content.scrollbar.active = true
	else
		detailed.content.scrollbar.active = false
	end

	detailed.style.drop_down_arrow.angle = math.pi

	self:_sync_statistics()
end

HeroWindowCharacterPreview._sync_statistics = function (self)
	-- function 24
	if not self:_statistics_activate() then
		return
	end

	local HeroStatisticsTemplate = HeroStatisticsTemplate
	local get_hero_statistics_by_template = UIUtils.get_hero_statistics_by_template(HeroStatisticsTemplate)

	self:_populate_statistics(get_hero_statistics_by_template)
end

HeroWindowCharacterPreview._deactivate_statistics = function (self)
	-- function 25
	local detailed = self._widgets_by_name.detailed

	detailed.content.active = false
	detailed.content.list_content.active = false
	detailed.content.scrollbar.active = false
	detailed.style.drop_down_arrow.angle = 0
end

HeroWindowCharacterPreview._update_statistics_widget = function (self, arg_26_1, arg_26_2)
	-- function 26
	local detailed = self._widgets_by_name.detailed

	if not detailed.content.active then
		return
	end

	local size = scenegraph_definition.detailed_button.size
	local size_2 = scenegraph_definition.detailed_list.size
	local list_style = detailed.style.list_style
	local var_26_4 = list_style.list_member_offset[2]
	local num_draws = list_style.num_draws
	local var_26_6

	if num_draws == 0 then
		var_26_6 = math.abs(var_26_4)
	else
		var_26_6 = math.abs(var_26_4 * num_draws)
	end

	local max = math.max(var_26_6 - size_2[2], 0)
	local scenegraph_id = list_style.scenegraph_id
	local local_position = self.ui_scenegraph[scenegraph_id].local_position
	local num = 1 - detailed.content.scrollbar.scroll_value

	local_position[2] = -size[2] + max * num
end

HeroWindowCharacterPreview._populate_statistics = function (self, arg_27_1)
	-- function 27
	local detailed = self._widgets_by_name.detailed
	local content = detailed.content
	local list_style = detailed.style.list_style
	local list_content = content.list_content
	local item_styles = list_style.item_styles
	local count = #arg_27_1

	for i = 1, count do
		local var_27_6 = arg_27_1[i]
		local str = ""
		local str_2 = ""
		local str_3 = ""
		local str_4 = ""
		local str_5 = ""
		local type = var_27_6.type

		if type == "title" then
			str = var_27_6.display_name
		elseif type == "entry" then
			str_2 = var_27_6.display_name
			str_3 = var_27_6.value
			str_4 = var_27_6.display_name
			str_5 = var_27_6.description_name
		end

		local var_27_13 = list_content[i]

		var_27_13.name = UIRenderer.crop_text_width(self.ui_renderer, str_2, 300, item_styles[i].name)
		var_27_13.title = UIRenderer.crop_text_width(self.ui_renderer, str, 300, item_styles[i].title)
		var_27_13.value = str_3
		var_27_13.tooltip.title = str_4
		var_27_13.tooltip.description = str_5
	end

	list_style.num_draws = count

	self:_setup_tab_scrollbar(detailed)
end

HeroWindowCharacterPreview._setup_tab_scrollbar = function (arg_28_0, arg_28_1)
	-- function 28
	local size = scenegraph_definition.detailed_button.size
	local size_2 = scenegraph_definition.detailed_list.size
	local list_style = arg_28_1.style.list_style
	local var_28_3 = list_style.list_member_offset[2]
	local num_draws = list_style.num_draws
	local var_28_5

	if num_draws == 0 then
		var_28_5 = math.abs(var_28_3)
	else
		var_28_5 = math.abs(var_28_3 * num_draws)
	end

	local min = math.min(size_2[2] / var_28_5, 1)
	local scrollbar = arg_28_1.content.scrollbar

	if min < 1 then
		scrollbar.percentage = min
		scrollbar.scroll_value = 1

		local num = 2

		scrollbar.scroll_amount = var_28_3 / (var_28_5 - size_2[2]) * num
	else
		scrollbar.percentage = 1
		scrollbar.scroll_value = 1
	end
end

HeroWindowCharacterPreview._show_weapon_disclaimer = function (self, arg_29_1)
	-- function 29
	local content = self._widgets_by_name.disclaimer_text.content

	self._widgets_by_name.disclaimer_text_background.content.visible = arg_29_1
	content.visible = arg_29_1
end
