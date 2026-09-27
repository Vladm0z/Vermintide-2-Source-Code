-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_crafting.lua

require("scripts/ui/views/hero_view/craft_pages/craft_page_salvage")
require("scripts/ui/views/hero_view/craft_pages/craft_page_roll_trait")
require("scripts/ui/views/hero_view/craft_pages/craft_page_roll_properties")
require("scripts/ui/views/hero_view/craft_pages/craft_page_craft_item")
require("scripts/ui/views/hero_view/craft_pages/craft_page_apply_skin")
require("scripts/ui/views/hero_view/craft_pages/craft_page_upgrade_item")
require("scripts/ui/views/hero_view/craft_pages/craft_page_convert_dust")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_definitions")
local var_0_1, var_0_2, var_0_3 = dofile("scripts/settings/crafting/crafting_recipes")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false
local tbl = {
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "salvage",
		class_name = "CraftPageSalvage",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "craft_random_item",
		class_name = "CraftPageCraftItem",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "reroll_weapon_properties",
		class_name = "CraftPageRollProperties",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "reroll_weapon_traits",
		class_name = "CraftPageRollTrait",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "upgrade_item_rarity_common",
		class_name = "CraftPageUpgradeItem",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "apply_weapon_skin",
		class_name = "CraftPageApplySkin",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "convert_blue_dust",
		class_name = "CraftPageConvertDust",
		sound_event_exit = "play_gui_equipment_close"
	}
}

HeroWindowCrafting = class(HeroWindowCrafting)
HeroWindowCrafting.NAME = "HeroWindowCrafting"

HeroWindowCrafting.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCrafting")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.crafting_manager = Managers.state.crafting
	self.wwise_world = arg_1_1.wwise_world

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
	self:_set_crafting_fg_progress(0)

	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.profile_index = arg_1_1.profile_index
	self._page_params = {
		wwise_world = self.wwise_world,
		ingame_ui_context = ingame_ui_context,
		parent = self,
		hero_name = self.hero_name,
		career_index = self.career_index,
		profile_index = self.profile_index
	}
	self.unblocked_services = {}
	self.unblocked_services_n = 0

	self:_change_recipe_page(1)
end

HeroWindowCrafting.create_ui_elements = function (self, arg_2_1, arg_2_2)
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

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end

	self._widgets_by_name.crafting_fg_glow.style.texture_id.color[1] = 0
end

HeroWindowCrafting.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate HeroWindowCrafting")

	self.ui_animator = nil

	if not self._active_page then
		local _page_params = self._page_params

		self._active_page:on_exit(_page_params)
	end

	if not self:is_crafting_anim_playing() then
		self:cancel_crafting_animation()
	end
end

HeroWindowCrafting.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	local _current_craft_id = self._current_craft_id

	if not _current_craft_id then
		local get_interface = Managers.backend:get_interface("crafting")

		if not get_interface:is_craft_complete(_current_craft_id) then
			local get_craft_result = get_interface:get_craft_result(_current_craft_id)

			self:craft_complete(get_craft_result)

			self._current_craft_id = nil
		end
	end

	if not self._active_page then
		self._active_page:update(arg_4_1, arg_4_2)
	end

	self:_update_craft_start_time(arg_4_1, arg_4_2)
	self:_update_craft_end_time(arg_4_1, arg_4_2)
	self:_update_craft_glow_wait_time(arg_4_1, arg_4_2)
	self:_update_craft_glow_in_time(arg_4_1, arg_4_2)
	self:_update_craft_glow_out_time(arg_4_1, arg_4_2)
	self:_update_animations(arg_4_1)
	self:_handle_input(arg_4_1, arg_4_2)
	self:draw(arg_4_1)
end

HeroWindowCrafting.post_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._active_page and not self._active_page.post_update then
		self._active_page:post_update(arg_5_1, arg_5_2)
	end
end

HeroWindowCrafting._update_animations = function (self, arg_6_1)
	-- function 6
	self.ui_animator:update(arg_6_1)

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

HeroWindowCrafting._is_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCrafting._is_button_hovered = function (arg_8_0, arg_8_1)
	-- function 8
	if not arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowCrafting._is_button_held = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

HeroWindowCrafting._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self:is_crafting_anim_playing() then
		return
	end

	local _widgets_by_name = self._widgets_by_name
	local page_button_next = _widgets_by_name.page_button_next
	local page_button_previous = _widgets_by_name.page_button_previous

	UIWidgetUtils.animate_default_button(page_button_next, arg_10_1)
	UIWidgetUtils.animate_default_button(page_button_previous, arg_10_1)

	if self:_is_button_hovered(page_button_next) or not self:_is_button_hovered(page_button_previous) then
		self:_play_sound("play_gui_inventory_next_hover")
	end

	local _total_pages = self._total_pages
	local _current_page = self._current_page

	if not self:_is_button_pressed(page_button_next) then
		local num = _current_page % _total_pages + 1

		self:_change_recipe_page(num)
		self:_play_sound("play_gui_craft_recipe_next")
	elseif not self:_is_button_pressed(page_button_previous) then
		local num_2

		if _current_page > 1 then
			num_2 = _current_page - 1

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = _total_pages

		::label_10_0::

		self:_change_recipe_page(num_2)
		self:_play_sound("play_gui_craft_recipe_next")
	elseif not Managers.input:is_device_active("gamepad") then
		local get_service = Managers.input:get_service("hero_view")
		local count = #tbl

		if not get_service:get("cycle_next") then
			local num_3 = _current_page % count + 1

			if num_3 <= count then
				self:_change_recipe_page(num_3)
				self:_play_sound("play_gui_craft_recipe_next")
			end
		elseif not get_service:get("cycle_previous") then
			local num_4

			if _current_page > 1 then
				num_4 = _current_page - 1

				if not num_4 then
					-- Nothing
				end
			end

			num_4 = count

			::label_10_1::

			if num_4 > 0 then
				self:_change_recipe_page(num_4)
				self:_play_sound("play_gui_craft_recipe_next")
			end
		end
	end
end

HeroWindowCrafting._exit = function (self, arg_11_1)
	-- function 11
	self.exit = true
	self.exit_level_id = arg_11_1
end

HeroWindowCrafting.draw = function (self, arg_12_1)
	-- function 12
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_12_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i_2, v_2 in ipairs(_active_node_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_2)
		end
	end

	UIRenderer.end_pass(ui_top_renderer)
end

HeroWindowCrafting._play_sound = function (self, arg_13_1)
	-- function 13
	self.parent:play_sound(arg_13_1)
end

HeroWindowCrafting._change_recipe_page = function (self, arg_14_1)
	-- function 14
	local count = #tbl
	local name = tbl[arg_14_1].name
	local var_14_2 = var_0_2[name]

	self._active_recipe = var_14_2

	local ingredients = var_14_2.ingredients
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.title_text.content.text = Localize(var_14_2.display_name)
	_widgets_by_name.description_text.content.text = Localize(var_14_2.description_text)

	if not (arg_14_1 ~= self._current_page or count == self._total_pages) then
		self._total_pages = count
		self._current_page = arg_14_1
		arg_14_1 = arg_14_1 or 1
		count = count or 1

		local _widgets_by_name_2 = self._widgets_by_name

		_widgets_by_name_2.page_text_left.content.text = tostring(arg_14_1)
		_widgets_by_name_2.page_text_right.content.text = tostring(count)

		self:_set_page_index(arg_14_1)
	end

	self._selected_page_index = arg_14_1
end

HeroWindowCrafting.window_input_service = function (arg_15_0)
	-- function 15
	return
end

HeroWindowCrafting._set_page_index = function (self, arg_16_1)
	-- function 16
	local _active_page = self._active_page
	local _page_params = self._page_params
	local var_16_2 = tbl[arg_16_1]
	local name = var_16_2.name
	local class_name = var_16_2.class_name

	if not _active_page then
		if _active_page.NAME == class_name then
			return
		end

		if not _active_page.on_exit then
			_active_page:on_exit(_page_params)
		end
	end

	if not self:is_crafting_anim_playing() then
		self:cancel_crafting_animation()
	end

	local var_16_5 = rawget(_G, class_name):new()

	self.parent:set_selected_craft_page(name)

	if not var_16_5.on_enter then
		var_16_5:on_enter(_page_params, var_16_2)
	end

	self._active_page = var_16_5
end

HeroWindowCrafting._update_craft_start_time = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _craft_start_duration = self._craft_start_duration

	if not _craft_start_duration then
		return
	end

	local num = _craft_start_duration + arg_17_1
	local crafting_animation_in_time = UISettings.crafting_animation_in_time
	local min = math.min(num / crafting_animation_in_time, 1)
	local easeInCubic = math.easeInCubic(min)

	self:_set_crafting_fg_progress(easeInCubic)

	if min == 1 then
		self._craft_start_duration = nil
		self._craft_glow_in_duration = 0

		self:_play_sound("play_gui_craft_forge_fire_begin")
	else
		self._craft_start_duration = num
	end
end

HeroWindowCrafting._update_craft_glow_in_time = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _craft_glow_in_duration = self._craft_glow_in_duration

	if not _craft_glow_in_duration then
		return
	end

	local num = _craft_glow_in_duration + arg_18_1
	local crafting_animation_in_time = UISettings.crafting_animation_in_time
	local min = math.min(num / crafting_animation_in_time, 1)
	local easeInCubic = math.easeInCubic(min)

	self._widgets_by_name.crafting_fg_glow.style.texture_id.color[1] = easeInCubic * 255

	if min == 1 then
		self._craft_glow_in_duration = nil
		self._craft_glow_wait_duration = 0
	else
		self._craft_glow_in_duration = num
	end
end

HeroWindowCrafting._update_craft_glow_wait_time = function (self, arg_19_1, arg_19_2)
	-- function 19
	local _craft_glow_wait_duration = self._craft_glow_wait_duration

	if not _craft_glow_wait_duration then
		return
	end

	local num = _craft_glow_wait_duration + arg_19_1
	local crafting_animation_wait_time = UISettings.crafting_animation_wait_time
	local min = math.min(num / crafting_animation_wait_time, 1)
	local ease_pulse = math.ease_pulse(1 - min)

	if min == 1 then
		self._craft_glow_wait_duration = nil
	else
		self._craft_glow_wait_duration = num
	end
end

HeroWindowCrafting._update_craft_glow_out_time = function (self, arg_20_1, arg_20_2)
	-- function 20
	local _craft_glow_out_duration = self._craft_glow_out_duration

	if not _craft_glow_out_duration and self._craft_glow_in_duration or self._craft_start_duration or not self._craft_glow_wait_duration then
		return
	end

	local num = _craft_glow_out_duration + arg_20_1
	local crafting_animation_out_time = UISettings.crafting_animation_out_time
	local min = math.min(num / crafting_animation_out_time, 1)
	local easeOutCubic = math.easeOutCubic(1 - min)

	self._widgets_by_name.crafting_fg_glow.style.texture_id.color[1] = easeOutCubic * 255

	if min == 1 then
		self._craft_end_duration = 0
		self._craft_glow_out_duration = nil

		self:_play_sound("play_gui_craft_forge_end")
	else
		if self._craft_glow_out_duration ~= 0 or not self._active_page then
			self._active_page:on_craft_completed()
		end

		self._craft_glow_out_duration = num
	end
end

HeroWindowCrafting._set_crafting_fg_progress = function (self, arg_21_1)
	-- function 21
	local crafting_fg = self._widgets_by_name.crafting_fg
	local uvs = crafting_fg.content.texture_id.uvs
	local scenegraph_id = crafting_fg.scenegraph_id

	self.ui_scenegraph[scenegraph_id].size[2] = scenegraph_definition[scenegraph_id].size[2] * arg_21_1
	uvs[1][2] = 1 - arg_21_1
	uvs[2][2] = 1
end

HeroWindowCrafting._update_craft_end_time = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _craft_end_duration = self._craft_end_duration

	if not _craft_end_duration then
		return
	end

	local num = _craft_end_duration + arg_22_1
	local min = math.min(num / 0.8, 1)
	local easeCubic = math.easeCubic(1 - min)

	self:_set_crafting_fg_progress(easeCubic)

	if min == 1 then
		self._craft_end_duration = nil

		if not self._active_page then
			self._active_page:reset()
		end

		self:unlock_input()
	else
		self._craft_end_duration = num
	end
end

HeroWindowCrafting.get_active_recipe = function (self)
	-- function 23
	return self._active_recipe
end

HeroWindowCrafting.craft = function (self, arg_24_1, arg_24_2)
	-- function 24
	local craft = self.crafting_manager:craft(arg_24_1, arg_24_2)

	if not craft then
		self._waiting_for_craft = true
		self._craft_start_duration = 0
		self._craft_glow_in_duration = nil
		self._craft_glow_wait_duration = nil
		self._craft_glow_out_duration = nil
		self._craft_end_duration = nil

		self:lock_input()

		self._current_craft_id = craft

		return true
	end

	return false
end

HeroWindowCrafting.craft_complete = function (self, arg_25_1)
	-- function 25
	self._waiting_for_craft = false
	self._craft_glow_out_duration = 0

	if not self._active_page then
		self._active_page:craft_result(arg_25_1)
	end
end

HeroWindowCrafting.waiting_for_craft = function (self)
	-- function 26
	return self._waiting_for_craft
end

HeroWindowCrafting.is_crafting_anim_playing = function (self)
	-- function 27
	return self._craft_start_duration ~= nil or self._craft_glow_in_duration ~= nil or self._craft_glow_wait_duration ~= nil or self._craft_glow_out_duration ~= nil or self._craft_end_duration ~= nil or self:waiting_for_craft()
end

HeroWindowCrafting.cancel_crafting_animation = function (self)
	-- function 28
	self._waiting_for_craft = nil
	self._craft_start_duration = nil
	self._craft_glow_in_duration = nil
	self._craft_glow_wait_duration = nil
	self._craft_glow_out_duration = nil
	self._craft_end_duration = nil

	self:_play_sound("play_gui_craft_forge_end")

	self._current_craft_id = nil
end

HeroWindowCrafting.lock_input = function (self)
	-- function 29
	local input_manager = self.input_manager

	self:unlock_input(true)

	self.unblocked_services_n = input_manager:get_unblocked_services(nil, nil, self.unblocked_services)

	input_manager:device_block_services("keyboard", 1, self.unblocked_services, self.unblocked_services_n, "crafting")
	input_manager:device_block_services("gamepad", 1, self.unblocked_services, self.unblocked_services_n, "crafting")
	input_manager:device_block_services("mouse", 1, self.unblocked_services, self.unblocked_services_n, "crafting")
end

HeroWindowCrafting.unlock_input = function (self)
	-- function 30
	local input_manager = self.input_manager

	input_manager:device_unblock_services("keyboard", 1, self.unblocked_services, self.unblocked_services_n)
	input_manager:device_unblock_services("gamepad", 1, self.unblocked_services, self.unblocked_services_n)
	input_manager:device_unblock_services("mouse", 1, self.unblocked_services, self.unblocked_services_n)
	table.clear(self.unblocked_services)

	self.unblocked_services_n = 0
end
