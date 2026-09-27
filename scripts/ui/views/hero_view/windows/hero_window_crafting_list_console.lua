-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_crafting_list_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_list_console_definitions")
local var_0_1, var_0_2, var_0_3 = dofile("scripts/settings/crafting/crafting_recipes")
local widgets = var_0_0.widgets
local title_button_definitions = var_0_0.title_button_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
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
local str = "move_down_hold_continuous"
local str_2 = "move_up_hold_continuous"
local flag = false

HeroWindowCraftingListConsole = class(HeroWindowCraftingListConsole)
HeroWindowCraftingListConsole.NAME = "HeroWindowCraftingListConsole"

HeroWindowCraftingListConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCraftingListConsole")

	self._params = arg_1_1
	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._animation_settings = {
		entry_alignment_progress = 0
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.profile_index = arg_1_1.profile_index

	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_1_4 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_1_4].careers[career_index].name

	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self.conditions_params = {
		hero_name = self.hero_name,
		career_name = name,
		rarities_to_ignore = table.enum_safe("magic")
	}

	self:_populate_buttons(tbl)

	local recipe_index = arg_1_1.recipe_index

	recipe_index = recipe_index or 1

	local flag = true

	self:_on_button_selected(recipe_index, flag)
	self:_start_transition_animation("on_enter")
end

HeroWindowCraftingListConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings,
		animation_settings = self._animation_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowCraftingListConsole.create_ui_elements = function (self, arg_3_1, arg_3_2)
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

	local tbl_3 = {}

	for k_2, v_2 in pairs(title_button_definitions) do
		local var_3_4 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_3_4
	end

	self._title_button_widgets = tbl_3

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	local get_service = Managers.input:get_service("hero_view")
	local num = UILayer.default + 300

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, get_service, 4, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
end

HeroWindowCraftingListConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate HeroWindowCraftingListConsole")

	self.ui_animator = nil

	self._menu_input_description:destroy()

	self._menu_input_description = nil
end

HeroWindowCraftingListConsole._input_service = function (self)
	-- function 5
	local parent = self.parent

	if not parent:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return parent:window_input_service()
end

HeroWindowCraftingListConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_animations(arg_6_1)
	self:draw(arg_6_1)
end

HeroWindowCraftingListConsole.post_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:_handle_input(arg_7_1, arg_7_2)
end

HeroWindowCraftingListConsole._update_animations = function (self, arg_8_1)
	-- function 8
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_8_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	ui_animator:update(arg_8_1)

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	local entry_alignment_progress = self._animation_settings.entry_alignment_progress

	self:_set_alignment_progress(entry_alignment_progress)

	local _title_button_widgets = self._title_button_widgets

	for i, v_3 in ipairs(_title_button_widgets) do
		self:_animate_entry(v_3, arg_8_1)
	end
end

HeroWindowCraftingListConsole._is_button_pressed = function (arg_9_0, arg_9_1)
	-- function 9
	local content = arg_9_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.button_text

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowCraftingListConsole._is_stepper_button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	local content = arg_10_1.content
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

HeroWindowCraftingListConsole._is_button_hover_enter = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot
	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

HeroWindowCraftingListConsole._is_button_hover_exit = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot
	local on_hover_exit = button_hotspot.on_hover_exit

	on_hover_exit = not on_hover_exit and not button_hotspot.is_selected

	return on_hover_exit
end

HeroWindowCraftingListConsole._is_button_selected = function (arg_13_0, arg_13_1)
	-- function 13
	return arg_13_1.content.button_hotspot.is_selected
end

HeroWindowCraftingListConsole._handle_input = function (self, arg_14_1, arg_14_2)
	-- function 14
	local parent = self.parent
	local _widgets_by_name = self._widgets_by_name
	local _input_service = self:_input_service()
	local _selected_button_index = self:_selected_button_index()
	local flag = false
	local _title_button_widgets = self._title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		if i == _selected_button_index or not self:_is_button_hover_enter(v) then
			self:_on_button_selected(i)

			flag = true
		end

		if not self:_is_button_pressed(v) then
			flag = true

			self:_open_recipe_page(i)
		end
	end

	if not _input_service:get("confirm") then
		self:_open_recipe_page(_selected_button_index)

		flag = true
	end

	if not flag then
		if not (not _input_service:get(str_2) and not (_selected_button_index > 1)) then
			self:_on_button_selected(_selected_button_index - 1)
		elseif not (not _input_service:get(str) and not (_selected_button_index < #tbl)) then
			self:_on_button_selected(_selected_button_index + 1)
		end
	end
end

HeroWindowCraftingListConsole._open_recipe_page = function (self, arg_15_1)
	-- function 15
	self._params.recipe_index = arg_15_1

	self.parent:set_layout_by_name("crafting_recipe")
end

HeroWindowCraftingListConsole._selected_button_index = function (self)
	-- function 16
	local _title_button_widgets = self._title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		if not v.content.button_hotspot.is_selected then
			return i
		end
	end
end

HeroWindowCraftingListConsole._on_button_selected = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _title_button_widgets = self._title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		v.content.button_hotspot.is_selected = i == arg_17_1
	end

	local name = tbl[arg_17_1].name
	local var_17_2 = var_0_2[name]
	local description_text = var_17_2.description_text
	local display_name = var_17_2.display_name
	local _widgets_by_name = self._widgets_by_name
	local description_text_2 = _widgets_by_name.description_text
	local tite_text = _widgets_by_name.tite_text

	description_text_2.content.text = Localize(description_text)
	tite_text.content.text = Localize(display_name)

	if not arg_17_2 then
		self:_play_sound("play_gui_craft_hover_items")
	end
end

HeroWindowCraftingListConsole.draw = function (self, arg_18_1)
	-- function 18
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local _input_service = self:_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, _input_service, arg_18_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	for i_2, v_2 in ipairs(self._title_button_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_2)
	end

	UIRenderer.end_pass(ui_top_renderer)

	if not is_device_active and not self._menu_input_description then
		self._menu_input_description:draw(ui_top_renderer, arg_18_1)
	end
end

HeroWindowCraftingListConsole._play_sound = function (self, arg_19_1)
	-- function 19
	self.parent:play_sound(arg_19_1)
end

HeroWindowCraftingListConsole._populate_buttons = function (self, arg_20_1)
	-- function 20
	local _title_button_widgets = self._title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		local var_20_1 = arg_20_1[i]
		local content = v.content
		local style = v.style

		content.visible = var_20_1 ~= nil

		if not var_20_1 then
			local name = var_20_1.name

			content.icon = var_0_2[name].display_icon_console
		end
	end
end

HeroWindowCraftingListConsole._set_alignment_progress = function (self, arg_21_1)
	-- function 21
	local _title_button_widgets = self._title_button_widgets
	local count = #tbl
	local num = 100
	local num_2 = count * num / 2 - num / 2
	local num_3 = 1
	local num_4 = 6

	for i, v in ipairs(_title_button_widgets) do
		local var_21_6 = tbl[i]
		local content = v.content
		local style = v.style
		local offset = v.offset

		offset[2] = num_2 * arg_21_1
		offset[1] = -0.00055 * offset[2]^2

		local num_5 = 0.001 * offset[2]

		style.holder.angle = -(num_5 * arg_21_1)
		num_2 = num_2 - num
		num_3 = not (i > math.ceil(count / 2)) or not (num_3 - 1) or num_3 + 1

		if not content.button_hotspot.is_selected then
			offset[3] = (count + 1) * num_4
		else
			offset[3] = i * num_4
		end
	end
end

HeroWindowCraftingListConsole._setup_text_button_size = function (self, arg_22_1)
	-- function 22
	local scenegraph_id = arg_22_1.scenegraph_id
	local content = arg_22_1.content
	local text = arg_22_1.style.text
	local text_field = content.text_field

	text_field = text_field or content.text

	if not text.localize then
		text_field = Localize(text_field)
	end

	if not text.upper_case then
		text_field = TextToUpper(text_field)
	end

	local ui_scenegraph = self.ui_scenegraph
	local ui_top_renderer = self.ui_top_renderer
	local var_22_6, var_22_7 = UIFontByResolution(text)
	local text_size, var_22_9, var_22_10 = UIRenderer.text_size(ui_top_renderer, text_field, var_22_6[1], var_22_7)

	ui_scenegraph[scenegraph_id].size[1] = text_size

	return text_size
end

HeroWindowCraftingListConsole._set_text_button_horizontal_position = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	arg_23_0.ui_scenegraph[arg_23_1.scenegraph_id].local_position[1] = arg_23_2
end

HeroWindowCraftingListConsole._animate_entry = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local content = arg_24_1.content
	local style = arg_24_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
	local is_selected = button_hotspot.is_selected
	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_24_1

	::label_24_0::

	is_clicked = true

	::label_24_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_24_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_24_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_24_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_24_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_24_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_24_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * max

	style.selection.color[1] = num_3

	local num_4 = 100 + 155 * max

	style.icon.color[2] = num_4
	style.icon.color[3] = num_4
	style.icon.color[4] = num_4
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end
