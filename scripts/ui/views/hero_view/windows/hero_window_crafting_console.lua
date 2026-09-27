-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_crafting_console.lua

require("scripts/ui/views/hero_view/craft_pages/craft_page_salvage_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_roll_trait_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_roll_properties_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_craft_item_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_apply_skin_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_upgrade_item_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_convert_dust_console")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_console_definitions")
local var_0_1, var_0_2, var_0_3 = dofile("scripts/settings/crafting/crafting_recipes")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local input_actions = var_0_0.input_actions
local flag = false
local tbl = {
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "salvage",
		class_name = "CraftPageSalvageConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "craft_random_item",
		class_name = "CraftPageCraftItemConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "reroll_weapon_properties",
		class_name = "CraftPageRollPropertiesConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "reroll_weapon_traits",
		class_name = "CraftPageRollTraitConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "upgrade_item_rarity_common",
		class_name = "CraftPageUpgradeItemConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "apply_weapon_skin",
		class_name = "CraftPageApplySkinConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "convert_blue_dust",
		class_name = "CraftPageConvertDustConsole",
		sound_event_exit = "play_gui_equipment_close"
	}
}

HeroWindowCraftingConsole = class(HeroWindowCraftingConsole)
HeroWindowCraftingConsole.NAME = "HeroWindowCraftingConsole"

HeroWindowCraftingConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCraftingConsole")

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
	self:_set_crafting_glow_progress(0)

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

	local recipe_index = arg_1_1.recipe_index

	recipe_index = recipe_index or 1

	self:_change_recipe_page(recipe_index)
	self:_start_transition_animation("on_enter")
	self:_start_transition_animation("reset_crafting")
end

HeroWindowCraftingConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self.ui_animator:start_animation(arg_2_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowCraftingConsole.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local get_service = Managers.input:get_service("hero_view")
	local num = UILayer.default + 300

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, get_service, 7, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end
end

HeroWindowCraftingConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate HeroWindowCraftingConsole")

	self.ui_animator = nil

	if not self._active_page then
		local _page_params = self._page_params

		self._active_page:on_exit(_page_params)
	end
end

HeroWindowCraftingConsole.set_input_description = function (self, arg_5_1)
	-- function 5
	if not arg_5_1 and not input_actions[arg_5_1] then
		self._current_input_desc_name = arg_5_1

		if not self.parent:filter_selected() then
			self._menu_input_description:set_input_description(not arg_5_1 and input_actions[arg_5_1])
		end
	else
		Application.warning("[HeroWindowCraftingConsole:set_input_description] Could not set input desc: " .. tostring(arg_5_1))
	end
end

HeroWindowCraftingConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	local _current_craft_id = self._current_craft_id
	local _animations = self._animations

	if not _current_craft_id then
		local get_interface = Managers.backend:get_interface("crafting")

		if not get_interface:is_craft_complete(_current_craft_id) then
			local get_craft_result = get_interface:get_craft_result(_current_craft_id)

			self:craft_complete(get_craft_result)

			self._current_craft_id = nil
		end
	end

	if not (not self._can_start_craft_exit_animation and _animations.craft_enter) then
		self:_start_transition_animation("craft_exit")

		self._can_start_craft_exit_animation = nil

		if not self._active_page then
			self._active_page:on_craft_completed()
		end
	end

	if not self._active_page then
		self._active_page:update(arg_6_1, arg_6_2)
	end

	self:_update_animations(arg_6_1)
	self:_handle_input(arg_6_1, arg_6_2)
	self:_update_input_desc()
	self:draw(arg_6_1)
end

HeroWindowCraftingConsole._update_input_desc = function (self)
	-- function 7
	local filter_selected = self.parent:filter_selected()
	local filter_active = self.parent:filter_active()

	if not (filter_selected ~= self._filter_selected or filter_active ~= self._filter_active) then
		return
	end

	self._menu_input_description:set_input_description(nil)

	if not filter_selected then
		self._menu_input_description:change_generic_actions(generic_input_actions.filter_selected)
	elseif not filter_active then
		self._menu_input_description:change_generic_actions(generic_input_actions.filter_active)
	else
		local _current_input_desc_name = self._current_input_desc_name

		self._menu_input_description:change_generic_actions(generic_input_actions.default)
		self._menu_input_description:set_input_description(not _current_input_desc_name and input_actions[_current_input_desc_name])
	end

	self._filter_selected = filter_selected
end

HeroWindowCraftingConsole.post_update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._active_page and not self._active_page.post_update then
		self._active_page:post_update(arg_8_1, arg_8_2)
	end
end

HeroWindowCraftingConsole._update_animations = function (self, arg_9_1)
	-- function 9
	self.ui_animator:update(arg_9_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil

			if k == "craft_exit" then
				self:on_craft_ended()
			end
		end
	end
end

HeroWindowCraftingConsole._is_button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCraftingConsole._is_button_hovered = function (arg_11_0, arg_11_1)
	-- function 11
	if not arg_11_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowCraftingConsole._is_button_held = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot

	if not button_hotspot.is_clicked then
		return button_hotspot.is_clicked
	end
end

HeroWindowCraftingConsole.set_focus = function (self, arg_13_1)
	-- function 13
	self._focused = arg_13_1
end

HeroWindowCraftingConsole._handle_input = function (self, arg_14_1, arg_14_2)
	-- function 14
	local window_input_service = self.parent:window_input_service()
	local filter_active = self.parent:filter_active()

	if not (not window_input_service:get("back") and filter_active) then
		self.parent:set_layout_by_name("forge")
	end

	self:_handle_tooltip_skip_input(window_input_service)
end

HeroWindowCraftingConsole._exit = function (self, arg_15_1)
	-- function 15
	self.exit = true
	self.exit_level_id = arg_15_1
end

HeroWindowCraftingConsole.draw = function (self, arg_16_1)
	-- function 16
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_16_1, nil, self.render_settings)

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

	if not is_device_active then
		self._menu_input_description:draw(ui_top_renderer, arg_16_1)
	end
end

HeroWindowCraftingConsole._play_sound = function (self, arg_17_1)
	-- function 17
	self.parent:play_sound(arg_17_1)
end

HeroWindowCraftingConsole._change_recipe_page = function (self, arg_18_1)
	-- function 18
	local count = #tbl
	local name = tbl[arg_18_1].name
	local var_18_2 = var_0_2[name]
	local ingredients = var_18_2.ingredients
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.title_text.content.text = Localize(var_18_2.display_name)
	_widgets_by_name.description_text.content.text = Localize(var_18_2.description_text)

	if not (arg_18_1 ~= self._current_page or count == self._total_pages) then
		self._total_pages = count
		self._current_page = arg_18_1
		arg_18_1 = arg_18_1 or 1

		self:_set_page_index(arg_18_1)
	end

	self._selected_page_index = arg_18_1
end

HeroWindowCraftingConsole.window_input_service = function (arg_19_0)
	-- function 19
	return
end

HeroWindowCraftingConsole._set_page_index = function (self, arg_20_1)
	-- function 20
	local _active_page = self._active_page
	local _page_params = self._page_params
	local var_20_2 = tbl[arg_20_1]
	local name = var_20_2.name
	local class_name = var_20_2.class_name

	if not _active_page then
		if _active_page.NAME == class_name then
			return
		end

		if not _active_page.on_exit then
			_active_page:on_exit(_page_params)
		end
	end

	local var_20_5 = rawget(_G, class_name):new()

	self.parent:set_selected_craft_page(name)

	if not var_20_5.on_enter then
		var_20_5:on_enter(_page_params, var_20_2)
	end

	self._active_page = var_20_5
end

HeroWindowCraftingConsole._set_crafting_glow_progress = function (arg_21_0, arg_21_1)
	-- function 21
	arg_21_0._widgets_by_name.crafting_glow.style.texture_id.color[1] = 255 * arg_21_1
end

HeroWindowCraftingConsole.on_craft_ended = function (self)
	-- function 22
	local _active_page = self._active_page

	if not _active_page and not _active_page.present_results then
		_active_page:present_results()
	end

	self:unlock_input()
end

HeroWindowCraftingConsole.craft = function (self, arg_23_1, arg_23_2)
	-- function 23
	local craft = self.crafting_manager:craft(arg_23_1, arg_23_2)

	if not craft then
		self._waiting_for_craft = true

		self:_start_transition_animation("craft_enter")
		self:lock_input()

		self._current_craft_id = craft

		return true
	end

	return false
end

HeroWindowCraftingConsole.craft_complete = function (self, arg_24_1)
	-- function 24
	self._waiting_for_craft = false
	self._can_start_craft_exit_animation = true

	if not self._active_page then
		self._active_page:craft_result(arg_24_1)
	end
end

HeroWindowCraftingConsole.waiting_for_craft = function (self)
	-- function 25
	return self._waiting_for_craft
end

HeroWindowCraftingConsole.lock_input = function (self)
	-- function 26
	local input_manager = self.input_manager

	self:unlock_input(true)

	self.unblocked_services_n = input_manager:get_unblocked_services(nil, nil, self.unblocked_services)

	input_manager:device_block_services("keyboard", 1, self.unblocked_services, self.unblocked_services_n, "crafting")
	input_manager:device_block_services("gamepad", 1, self.unblocked_services, self.unblocked_services_n, "crafting")
	input_manager:device_block_services("mouse", 1, self.unblocked_services, self.unblocked_services_n, "crafting")
end

HeroWindowCraftingConsole.unlock_input = function (self)
	-- function 27
	local input_manager = self.input_manager

	input_manager:device_unblock_services("keyboard", 1, self.unblocked_services, self.unblocked_services_n)
	input_manager:device_unblock_services("gamepad", 1, self.unblocked_services, self.unblocked_services_n)
	input_manager:device_unblock_services("mouse", 1, self.unblocked_services, self.unblocked_services_n)
	table.clear(self.unblocked_services)

	self.unblocked_services_n = 0
end

HeroWindowCraftingConsole._set_input_progress = function (self, arg_28_1)
	-- function 28
	local num = 43
	local num_2 = 360 - num * 2
	local num_3 = 255 * math.min(arg_28_1 * 2, 1)
	local num_4 = (num + num_2 * arg_28_1) / 360
	local num_5 = -math.degrees_to_radians(num + num_2 * arg_28_1)
	local craft_bar = self._widgets_by_name.craft_bar

	craft_bar.style.texture_id.gradient_threshold = num_4
	craft_bar.style.texture_id.color[1] = 255

	if arg_28_1 == 1 then
		return true
	end
end

HeroWindowCraftingConsole.set_reward_tooltip_item = function (self, arg_29_1)
	-- function 29
	self._widgets_by_name.item_tooltip.content.item = arg_29_1
	self._tooltip_item_id = arg_29_1
end

HeroWindowCraftingConsole.has_active_reward_tooltip = function (self)
	-- function 30
	return self._tooltip_item_id
end

local tbl_2 = {
	"confirm_press",
	"refresh_press",
	"special_1_press",
	"back_menu",
	"move_up",
	"move_down",
	"move_left",
	"move_right"
}

HeroWindowCraftingConsole._handle_tooltip_skip_input = function (self, arg_31_1)
	-- function 31
	if not self:has_active_reward_tooltip() then
		local flag = false

		for i, v in ipairs(tbl_2) do
			if not arg_31_1:get(v) then
				flag = true

				break
			end
		end

		if not flag then
			self:set_reward_tooltip_item(nil)
		end
	end
end
