-- chunkname: @scripts/ui/views/character_selection_view/states/character_selection_state_versus_loadouts.lua

local var_0_0 = local_require("scripts/ui/views/character_selection_view/states/definitions/character_selection_state_versus_loadouts_definitions")
local widget_definitions = var_0_0.widget_definitions
local loadout_widgets_definitions = var_0_0.loadout_widgets_definitions
local loadout_selection_widget_definitions = var_0_0.loadout_selection_widget_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local hero_icon_widget = var_0_0.hero_icon_widget
local hero_widget = var_0_0.hero_widget
local info_window_widgets_definitions = var_0_0.info_window_widgets_definitions
local weapon_slots = var_0_0.weapon_slots
local tag_scenegraph_id = var_0_0.tag_scenegraph_id
local tag_widget_func = var_0_0.tag_widget_func
local loadout_button_widget_definitions = var_0_0.loadout_button_widget_definitions
local console_cursor_definition = var_0_0.console_cursor_definition
local generic_input_actions = var_0_0.generic_input_actions
local NUM_PERKS = var_0_0.NUM_PERKS
local tbl = {}

CharacterSelectionStateVersusLoadouts = class(CharacterSelectionStateVersusLoadouts, CharacterSelectionStateCharacter)
CharacterSelectionStateVersusLoadouts.NAME = "CharacterSelectionStateVersusLoadouts"

local tbl_2 = {
	slot_necklace = true,
	slot_hat = true,
	slot_ring = true,
	slot_frame = true,
	slot_pose = true,
	slot_ranged = true,
	slot_trinket_1 = true,
	slot_skin = true,
	slot_melee = true
}

CharacterSelectionStateVersusLoadouts.on_enter = function (self, arg_1_1)
	-- function 1
	print("[HeroViewState] Enter Substate CharacterSelectionStateVersusLoadouts")

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._parent = arg_1_1.parent
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._is_in_inn = ingame_ui_context.is_in_inn
	self._force_ingame_menu = arg_1_1.force_ingame_menu
	self._world = ingame_ui_context.world
	self._statistics_db = ingame_ui_context.statistics_db
	self._profile_synchronizer = ingame_ui_context.profile_synchronizer
	self.peer_id = ingame_ui_context.peer_id
	self._local_player_id = ingame_ui_context.local_player_id

	local network_server = ingame_ui_context.network_server

	network_server = network_server or ingame_ui_context.network_client
	self._profile_requester = network_server:profile_requester()
	self.world_previewer = arg_1_1.world_previewer
	self._wwise_world = arg_1_1.wwise_world
	self.local_player = Managers.player:local_player()
	self._stats_id = self.local_player:stats_id()
	self.use_user_skins = true
	self.use_loadout_items = true

	local profile_by_peer, var_1_3 = self._profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id)
	local hero_name = arg_1_1.hero_name

	self._career_index = var_1_3
	self._profile_index = profile_by_peer
	self._hero_name = hero_name

	local name = SPProfiles[self._profile_index].careers[self._career_index].name

	self._career_name = name
	self._render_settings = {
		snap_pixel_positions = false
	}
	self._loadout_selection_render_settings = {
		snap_pixel_positions = false
	}
	self._animations = {}
	self._ui_animations = {}

	self:_store_selected_loadout_index(name)
	self:_create_ui_elements(arg_1_1)
	self:_setup_rarity_indices()
	self:_start_animation("on_enter")

	if not profile_by_peer and not var_1_3 then
		local flag = true

		self:_select_hero(self._profile_index, self._career_index, true, nil, flag)
		self:_disable_unused_careers()
	end

	self.parent:set_input_blocked(false)
	Managers.input:enable_gamepad_cursor()

	local num = UILayer.default + 130
	local input_service = self._parent:input_service(true)

	self._menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self.ui_top_renderer, input_service, 6, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
end

CharacterSelectionStateVersusLoadouts._disable_unused_careers = function (self)
	-- function 2
	for i, v in ipairs(self._hero_widgets) do
		local content = v.content

		content.locked = i ~= self._selected_career_index
		content.button_hotspot.disable_button = i ~= self._selected_career_index
	end
end

CharacterSelectionStateVersusLoadouts.on_exit = function (self, arg_3_1)
	-- function 3
	self.super.on_exit(self, arg_3_1)

	if not self._new_loadout_confirmed then
		local name = SPProfiles[self._profile_index].careers[self._career_index].name
		local _stored_selected_loadout_index = self._stored_selected_loadout_index
		local loadout_type = InventorySettings.loadouts[_stored_selected_loadout_index].loadout_type
		local loadout = self._loadout_button_widgets[_stored_selected_loadout_index].content.loadout
		local flag = true

		self:_set_loadout(loadout, loadout_type, _stored_selected_loadout_index, name, flag)
		self:_save_loadout_index(name, _stored_selected_loadout_index)
	end
end

CharacterSelectionStateVersusLoadouts._store_selected_loadout_index = function (self, arg_4_1)
	-- function 4
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local loadout_selection = PlayerData.loadout_selection

	loadout_selection = not loadout_selection and PlayerData.loadout_selection[current_mechanism_name]

	local var_4_2

	if not loadout_selection then
		var_4_2 = loadout_selection[arg_4_1]

		if not var_4_2 then
			-- Nothing
		end
	end

	var_4_2 = 1

	::label_4_0::

	local flag = not var_4_2 and InventorySettings.loadouts[var_4_2]

	if not (not flag and flag.loadout_type ~= "default") then
		self._stored_selected_loadout_index = flag.loadout_index
	else
		local get_selected_career_loadout = Managers.backend:get_interface("items"):get_selected_career_loadout(arg_4_1)

		for i, v in ipairs(InventorySettings.loadouts) do
			if not (v.loadout_type ~= "custom" or v.loadout_index ~= get_selected_career_loadout) then
				self._stored_selected_loadout_index = i

				return
			end
		end
	end

	fassert(self._stored_selected_loadout_index, "[CharacterSelectionStateVersusLoadouts] Couldn't find any stored loadout index")
end

CharacterSelectionStateVersusLoadouts._setup_rarity_indices = function (self)
	-- function 5
	self._rarity_indices = {}

	for k, v in pairs(RaritySettings) do
		self._rarity_indices[k] = v.order
	end
end

CharacterSelectionStateVersusLoadouts._create_ui_elements = function (self)
	-- function 6
	self:_inject_additional_scenegraph_definitions(scenegraph_definition)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widget_definitions) do
		local var_6_2 = UIWidget.init(v)

		tbl_2[k] = var_6_2
		tbl[#tbl + 1] = var_6_2
	end

	self._widgets = tbl

	local tbl_3 = {}

	for k_2, v_2 in pairs(loadout_widgets_definitions) do
		local var_6_4 = UIWidget.init(v_2)

		tbl_2[k_2] = var_6_4
		tbl_3[#tbl_3 + 1] = var_6_4
	end

	self._loadout_widgets = tbl_3

	local tbl_4 = {}

	for k_3, v_3 in pairs(loadout_selection_widget_definitions) do
		local var_6_6 = UIWidget.init(v_3)

		tbl_2[k_3] = var_6_6
		tbl_4[#tbl_4 + 1] = var_6_6
	end

	self._loadout_selection_widgets = tbl_4

	local tbl_5 = {}

	for k_4, v_4 in pairs(info_window_widgets_definitions) do
		local var_6_8 = UIWidget.init(v_4)

		tbl_2[k_4] = var_6_8
		tbl_5[#tbl_5 + 1] = var_6_8
	end

	self._info_window_widgets = tbl_5

	local tbl_6 = {}

	for i, v_5 in ipairs(loadout_button_widget_definitions) do
		local var_6_10 = UIWidget.init(v_5)

		tbl_2["loadout_button_" .. i] = var_6_10
		tbl_6[#tbl_6 + 1] = var_6_10
	end

	self._loadout_button_widgets = tbl_6
	self._widgets_by_name = tbl_2
	self._console_cursor = UIWidget.init(console_cursor_definition)
	self._additional_widgets = {}
	self._additional_widgets_by_name = {}

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	for i_2, v_6 in ipairs(InventorySettings.loadouts) do
		if v_6.loadout_type == "custom" then
			self._default_loadout_index = i_2

			break
		end
	end

	fassert(self._default_loadout_index, "[CharacterSelectionStateVersusLoadouts] There is no custom loadout slots in InventorySettings.loadouts")
	self:_setup_item_grid()
	self:_populate_hero_info()
	self:_populate_career_info()
	self:_populate_loadout()
	self:_populate_loadout_buttons()
	self:_setup_hero_widgets()
	self:_populate_tags()
end

CharacterSelectionStateVersusLoadouts._setup_item_grid = function (self)
	-- function 7
	self:_setup_item_grid_categories()

	local var_7_0 = ItemGridUI:new(self._categories, self._widgets_by_name.item_grid, self._hero_name, self._career_index)

	var_7_0:mark_equipped_items(true)
	var_7_0:mark_locked_items(true)
	var_7_0:disable_locked_items(true)
	var_7_0:disable_unwieldable_items(true)
	var_7_0:disable_item_drag()
	var_7_0:change_category("slot_ranged")

	self._item_grid = var_7_0
end

CharacterSelectionStateVersusLoadouts._setup_item_grid_categories = function (self)
	-- function 8
	local _career_index = self._career_index
	local _profile_index = self._profile_index
	local item_slot_types_by_slot_name = SPProfiles[_profile_index].careers[_career_index].item_slot_types_by_slot_name
	local tbl = {
		slot_melee = item_slot_types_by_slot_name.slot_melee,
		slot_ranged = item_slot_types_by_slot_name.slot_ranged
	}

	self._categories = {}

	for k, v in pairs(tbl) do
		local ui_slot_index = InventorySettings.slots_by_name[k].ui_slot_index

		if not ui_slot_index then
			local str = "( "

			for i, v_2 in ipairs(v) do
				str = str .. "slot_type == " .. v_2

				if i < #v then
					str = str .. " or "
				else
					str = str .. " ) and item_rarity ~= magic and can_wield_by_current_career"
				end
			end

			local tbl_2 = {
				hero_specific_filter = true,
				name = k,
				item_types = v,
				slot_index = ui_slot_index,
				slot_name = k,
				item_filter = str
			}

			self._categories[ui_slot_index] = tbl_2
		end
	end
end

CharacterSelectionStateVersusLoadouts._setup_hero_widgets = function (self)
	-- function 9
	local tbl = {}
	local tbl_2 = {}

	self._hero_widgets = tbl
	self._hero_icon_widgets = tbl_2

	local var_9_2 = SPProfiles[self._profile_index]
	local var_9_3 = var_9_2.careers[self._career_index]
	local display_name = var_9_2.display_name
	local get_interface = Managers.backend:get_interface("dlcs")
	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "experience")

	get = get or 0

	local get_level = ExperienceSettings.get_level(get)
	local careers = var_9_2.careers
	local var_9_9 = UIWidget.init(hero_icon_widget)

	tbl_2[#tbl_2 + 1] = var_9_9

	local str = "hero_icon_large_" .. display_name

	var_9_9.content.icon = str
	var_9_9.content.icon_selected = str .. "_glow"
	var_9_9.content.selected = true

	for i = 1, 4 do
		local var_9_11 = careers[i]

		if not (not var_9_11 and get_interface:is_unreleased_career(var_9_11.name)) then
			local var_9_12 = UIWidget.init(hero_widget)

			tbl[#tbl + 1] = var_9_12

			local offset = var_9_12.offset
			local content = var_9_12.content

			content.career_settings = var_9_11

			local portrait_image = var_9_11.portrait_image

			content.portrait = "medium_" .. portrait_image

			local is_unlocked_function, var_9_17, var_9_18, var_9_19 = var_9_11:is_unlocked_function(display_name, get_level)

			content.locked = not is_unlocked_function
			content.locked_reason = (not not is_unlocked_function or not var_9_19) and var_9_17 and Localize(var_9_17)
			content.dlc_name = var_9_18

			if var_9_17 == "dlc_not_owned" then
				content.lock_texture = content.lock_texture .. "_gold"
				content.frame = content.frame .. "_gold"
			end

			content.locked = not is_unlocked_function
			content.button_hotspot.is_selected = self._career_index == i
			offset[1] = (i - 1) * 124
		else
			local num = (i - 1) * 124

			var_9_9.style.bg.offset[1] = var_9_9.style.bg.offset[1] + num
			var_9_9.style.hourglass_icon.offset[1] = var_9_9.style.hourglass_icon.offset[1] + num
			var_9_9.content.use_empty_icon = true
		end
	end
end

CharacterSelectionStateVersusLoadouts._populate_hero_info = function (self)
	-- function 10
	local var_10_0 = SPProfiles[self._profile_index]
	local var_10_1 = var_10_0.careers[self._career_index]
	local display_name = var_10_0.display_name
	local character_name = var_10_0.character_name
	local display_name_2 = var_10_1.display_name
	local var_10_5 = Localize(character_name)
	local var_10_6 = Localize(display_name_2)
	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "experience")

	get = get or 0

	local get_level = ExperienceSettings.get_level(get)

	self._widgets_by_name.info_hero_name.content.text = var_10_5
	self._widgets_by_name.info_career_name.content.text = var_10_6
	self._widgets_by_name.info_hero_level.content.text = get_level
end

CharacterSelectionStateVersusLoadouts._start_animation = function (self, arg_11_1, arg_11_2)
	-- function 11
	local tbl = {
		render_settings = arg_11_2 or self._render_settings,
		ui_scenegraph = self._ui_scenegraph
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_11_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_11_1] = start_animation
end

CharacterSelectionStateVersusLoadouts._update_animations = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_12_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_12_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	for i, v_3 in ipairs(self._loadout_button_widgets) do
		UIWidgetUtils.animate_default_button(v_3, arg_12_1)
	end

	local confirm_button = self._widgets_by_name.confirm_button

	UIWidgetUtils.animate_default_button(confirm_button, arg_12_1)

	if not self._loadout_selection_active then
		local back_button = self._widgets_by_name.back_button

		self:_animate_back_button(back_button, arg_12_1)
	end
end

CharacterSelectionStateVersusLoadouts._animate_back_button = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local content = arg_13_1.content
	local style = arg_13_1.style
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

	goto label_13_1

	::label_13_0::

	is_clicked = true

	::label_13_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_13_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_13_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_13_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_13_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_13_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_13_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * max

	style.texture_id.color[1] = 255 - num_3
	style.texture_hover_id.color[1] = num_3
	style.selected_texture.color[1] = num_3
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

CharacterSelectionStateVersusLoadouts.post_update = function (self, arg_14_1, arg_14_2)
	-- function 14
	self:_update_animations(arg_14_1, arg_14_2)
	self:_handle_spawn(arg_14_1, arg_14_2)
end

CharacterSelectionStateVersusLoadouts._handle_spawn = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not (self.parent:transitioning() or self._transition_timer) then
		if not self._prepare_exit then
			self._prepare_exit = false

			self.world_previewer:prepare_exit()
		elseif not self._spawn_hero then
			self._spawn_hero = nil

			local _selected_hero_name = self._selected_hero_name

			_selected_hero_name = _selected_hero_name or self._hero_name

			self:_spawn_hero_unit(_selected_hero_name)
		end
	end

	local profile_synchronizer = Managers.state.network.profile_synchronizer
	local local_player = Managers.player:local_player()
	local network_id = local_player:network_id()
	local local_player_id = local_player:local_player_id()

	if not self._despawning_player_unit_career_change and Unit.alive(self._despawning_player_unit_career_change) or not profile_synchronizer:all_ingame_synced_for_peer(network_id, local_player_id) then
		local unbox = self._respawn_position:unbox()
		local unbox_2 = self._respawn_rotation:unbox()

		local_player:spawn(unbox, unbox_2)

		self._despawning_player_unit_career_change = nil
		self._resyncing_loadout = nil

		self.parent:close_menu()
	end
end

CharacterSelectionStateVersusLoadouts._close_menu = function (self)
	-- function 16
	local get_exit_button_widget = self._parent:get_exit_button_widget()
	local flag = false

	flag = flag or self._items_dirty
	flag = flag or self._talents_dirty

	if flag or not self._loadout_selection_changed then
		if not self._loadout_selection_active then
			self:_enable_loadout_selection(false)
		end

		self:_confirm_loadout()

		get_exit_button_widget.content.button_hotspot.on_release = nil
	else
		self.parent:close_menu()
	end
end

CharacterSelectionStateVersusLoadouts.update = function (self, arg_17_1, arg_17_2)
	-- function 17
	self:_handle_input(arg_17_1, arg_17_2)
	self:_update_profile_request()
	self:_update_video_player_settings()
	self:_draw(arg_17_1, arg_17_2)

	return self:_handle_transitions()
end

CharacterSelectionStateVersusLoadouts._handle_input = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not self._prepare_exit then
		return
	end

	local input_service = self:input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	self:_handle_keyboard_selection(input_service)
	self:_handle_mouse_selection(input_service)
	self:_handle_gamepad_selection(input_service)
end

CharacterSelectionStateVersusLoadouts._handle_keyboard_selection = function (self, arg_19_1)
	-- function 19
	if not Managers.input:is_device_active("keyboard") then
		return
	end

	if not arg_19_1:get("move_up") then
		local _selected_loadout_index = self._selected_loadout_index
		local max = math.max(_selected_loadout_index - 1, 1)

		if max == _selected_loadout_index or not self._loadout_button_widgets[max].content.visible then
			self:_change_loadout(max)
		end
	elseif not arg_19_1:get("move_down") then
		local _selected_loadout_index_2 = self._selected_loadout_index
		local min = math.min(_selected_loadout_index_2 + 1, #self._loadout_button_widgets)

		if min == _selected_loadout_index_2 or not self._loadout_button_widgets[min].content.visible then
			self:_change_loadout(min)
		end
	elseif not arg_19_1:get("confirm") then
		self:_confirm_loadout()
	elseif arg_19_1:get("toggle_menu", true) or not arg_19_1:get("back", true) then
		if not self._loadout_selection_active then
			self:_enable_loadout_selection(false)
		else
			self:_close_menu()
		end
	end
end

CharacterSelectionStateVersusLoadouts._handle_gamepad_selection = function (self, arg_20_1)
	-- function 20
	if not Managers.input:is_device_active("gamepad") then
		return
	end

	if arg_20_1:get("toggle_menu", true) or not arg_20_1:get("back", true) then
		if not self._loadout_selection_active then
			self:_enable_loadout_selection(false)
		else
			self:_close_menu()
		end

		return
	end

	if not arg_20_1:get("move_up_raw") then
		local _selected_loadout_index = self._selected_loadout_index
		local max = math.max(_selected_loadout_index - 1, 1)

		if max == _selected_loadout_index or not self._loadout_button_widgets[max].content.visible then
			if not self._loadout_selection_active then
				self:_enable_loadout_selection(false)
			end

			self:_change_loadout(max)
		end
	elseif not arg_20_1:get("move_down_raw") then
		local _selected_loadout_index_2 = self._selected_loadout_index
		local min = math.min(_selected_loadout_index_2 + 1, #self._loadout_button_widgets)

		if min == _selected_loadout_index_2 or not self._loadout_button_widgets[min].content.visible then
			if not self._loadout_selection_active then
				self:_enable_loadout_selection(false)
			end

			self:_change_loadout(min)
		end
	elseif not arg_20_1:get("refresh") then
		self:_confirm_loadout()
	elseif not arg_20_1:get("back", true) then
		self:_close_menu()
	end
end

CharacterSelectionStateVersusLoadouts._enable_loadout_selection = function (self, arg_21_1, arg_21_2)
	-- function 21
	local tbl = {
		loadout_weapons = {
			"item_grid",
			"back_button"
		},
		loadout_talents = {
			"talent_grid",
			"back_button"
		}
	}

	for k, v in pairs(self._loadout_selection_widgets) do
		v.content.visible = false
	end

	if not arg_21_1 then
		local var_21_1 = tbl[arg_21_2]

		for i, v_2 in ipairs(var_21_1) do
			self._widgets_by_name[v_2].content.visible = true
		end

		self:_start_animation("open_equipment_inventory", self._loadout_selection_render_settings)
	elseif not self._loadout_selection_active then
		local _loadout_selection_changed = self._loadout_selection_changed

		if not _loadout_selection_changed then
			_loadout_selection_changed = self._items_dirty
			_loadout_selection_changed = _loadout_selection_changed or self._talents_dirty
		end

		self._loadout_selection_changed = _loadout_selection_changed

		self:_update_talents()
		self:_update_items()
		self:_start_animation("show_loadout", self._loadout_selection_render_settings)

		self._current_weapon_slot_name = nil
	end

	self._loadout_selection_active = arg_21_1
end

CharacterSelectionStateVersusLoadouts._update_items = function (self)
	-- function 22
	if not self._items_dirty then
		return
	end

	self:_populate_loadout(self._selected_profile_index, self._selected_career_index, self._selected_loadout, self._selected_loadout_talents, self._selected_loadout_settings)

	self._items_dirty = false
end

CharacterSelectionStateVersusLoadouts._update_talents = function (self)
	-- function 23
	if not self._talents_dirty then
		return
	end

	local profile_by_peer, var_23_1 = self._profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id)
	local name = SPProfiles[self._selected_profile_index].careers[self._selected_career_index].name

	Managers.backend:get_interface("talents"):set_talents(name, self._selected_loadout_talents)

	local player_unit = self.local_player.player_unit

	if not Unit.alive(player_unit) then
		ScriptUnit.extension(player_unit, "talent_system"):talents_changed()
		ScriptUnit.extension(player_unit, "inventory_system"):apply_buffs_to_ammo()
	end

	self:_populate_loadout(self._selected_profile_index, self._selected_career_index, self._selected_loadout, self._selected_loadout_talents, self._selected_loadout_settings)

	self._talents_dirty = false
end

CharacterSelectionStateVersusLoadouts._handle_mouse_selection = function (self, arg_24_1)
	-- function 24
	if not Managers.input:is_device_active("keyboard") then
		return
	end

	if arg_24_1:get("toggle_menu", true) or not arg_24_1:get("back", true) then
		if not self._loadout_selection_active then
			self:_enable_loadout_selection(false)
		else
			self:_close_menu()
		end

		return
	end

	for i, v in ipairs(self._loadout_button_widgets) do
		if not UIUtils.is_button_pressed(v) then
			self:_enable_loadout_selection(false)
			self:_change_loadout(i)

			break
		end
	end

	local var_24_0 = InventorySettings.loadouts[self._selected_loadout_index]

	if not self._loadout_selection_active then
		local back_button = self._widgets_by_name.back_button

		if not UIUtils.is_button_pressed(back_button) then
			self:_enable_loadout_selection(false)
		end

		self:_handle_talent_loadout_selection(arg_24_1)
		self:_handle_item_loadout_selection(arg_24_1)
	else
		if var_24_0.loadout_type == "custom" then
			local loadout_weapons = self._widgets_by_name.loadout_weapons

			for i_2, v_2 in ipairs(weapon_slots) do
				if not UIUtils.is_button_pressed(loadout_weapons, v_2) then
					self._item_grid:change_category(v_2)
					self:_enable_loadout_selection(true, "loadout_weapons")

					self._current_weapon_slot_name = v_2

					break
				end
			end
		end

		if var_24_0.loadout_type == "custom" then
			local loadout_talents = self._widgets_by_name.loadout_talents

			for i4 = 1, MaxTalentPoints do
				local str = "talent_" .. i4

				if not UIUtils.is_button_pressed(loadout_talents, str) then
					self:_populate_talent_grid()
					self:_enable_loadout_selection(true, "loadout_talents")

					break
				end
			end
		end
	end

	local confirm_button = self._widgets_by_name.confirm_button

	if not UIUtils.is_button_pressed(confirm_button) then
		self:_confirm_loadout()
	end

	local get_exit_button_widget = self._parent:get_exit_button_widget()

	if not UIUtils.is_left_button_released(get_exit_button_widget) then
		self:_close_menu()
	end
end

CharacterSelectionStateVersusLoadouts._handle_item_loadout_selection = function (self, arg_25_1)
	-- function 25
	local item_grid = self._widgets_by_name.item_grid
	local _item_grid = self._item_grid
	local flag = false
	local is_item_pressed, var_25_4 = _item_grid:is_item_pressed(flag)

	if not _item_grid:is_item_hovered() then
		self:_play_sound("play_gui_inventory_item_hover")
	end

	if not (not is_item_pressed and var_25_4) then
		local player_unit = Managers.player:player_from_peer_id(self.peer_id).player_unit

		if not (not player_unit and Unit.alive(player_unit)) then
			return
		end

		self:_play_sound("play_gui_equipment_equip_hero")
		self:_set_loadout_item(is_item_pressed, self._current_weapon_slot_name)
		_item_grid:update_items_status()

		local _selected_career_index = self._selected_career_index
		local var_25_7 = FindProfileIndex(self._hero_name)
		local preview_wield_slot = SPProfiles[var_25_7].careers[_selected_career_index].preview_wield_slot

		preview_wield_slot = preview_wield_slot or "melee"
		self._spawn_hero = InventorySettings.slot_names_by_type[preview_wield_slot][1] == self._current_weapon_slot_name
		self._items_dirty = true
	end
end

CharacterSelectionStateVersusLoadouts._set_loadout_item = function (self, arg_26_1, arg_26_2)
	-- function 26
	local player_unit = Managers.player:player_from_peer_id(self.peer_id).player_unit

	if not (not player_unit and Unit.alive(player_unit)) then
		return
	end

	if not Managers.state.network:game() then
		return
	end

	if not LoadoutUtils.is_item_disabled(arg_26_1.ItemId) then
		return
	end

	local data = arg_26_1.data
	local var_26_2
	local var_26_3

	if not arg_26_2 then
		var_26_2 = InventorySettings.slots_by_name[arg_26_2]

		local type = var_26_2.type
	else
		local slot_type = data.slot_type

		var_26_2 = self:_get_slot_by_type(slot_type)
	end

	local backend_id = arg_26_1.backend_id
	local name = var_26_2.name
	local _selected_profile_index = self._selected_profile_index

	_selected_profile_index = _selected_profile_index or self._profile_index

	local _selected_career_index = self._selected_career_index

	_selected_career_index = _selected_career_index or self._career_index

	local name_2 = SPProfiles[_selected_profile_index].careers[_selected_career_index].name

	BackendUtils.set_loadout_item(backend_id, name_2, name)

	self._selected_loadout[name] = backend_id

	Managers.state.event:trigger("event_set_loadout_items")
end

CharacterSelectionStateVersusLoadouts._get_slot_by_type = function (arg_27_0, arg_27_1)
	-- function 27
	local slots_by_slot_index = InventorySettings.slots_by_slot_index

	for k, v in pairs(slots_by_slot_index) do
		if arg_27_1 == v.type then
			return v
		end
	end
end

CharacterSelectionStateVersusLoadouts._handle_talent_loadout_selection = function (self, arg_28_1)
	-- function 28
	local talent_grid = self._widgets_by_name.talent_grid
	local content = talent_grid.content

	for i = 1, NumTalentRows do
		for j = 1, NumTalentColumns do
			local str = "talent_" .. i .. "_" .. j

			if not UIUtils.is_button_hover_enter(talent_grid, str) then
				self:_play_sound("play_gui_inventory_item_hover")
			end

			if not talent_grid.content[str].disabled then
				if not UIUtils.is_button_pressed(talent_grid, str) then
					if self._selected_loadout_talents[i] ~= j then
						self:_play_sound("play_gui_talents_selection_click")
					end

					self._selected_loadout_talents[i] = j

					self:_populate_talent_grid()

					self._talents_dirty = true
				elseif not UIUtils.is_right_button_pressed(talent_grid, str) then
					if self._selected_loadout_talents[i] ~= 0 then
						self:_play_sound("play_gui_talents_selection_click")
					end

					local _selected_loadout_talents = self._selected_loadout_talents
					local flag

					flag = self._selected_loadout_talents[i] ~= j or not 0 or self._selected_loadout_talents[i]
					_selected_loadout_talents[i] = flag

					self:_populate_talent_grid()

					self._talents_dirty = true
				end
			end
		end
	end
end

CharacterSelectionStateVersusLoadouts._confirm_loadout = function (self)
	-- function 29
	self:_play_sound("play_gui_start_menu_button_click")

	if not self._loadout_selection_active then
		self:_enable_loadout_selection(false)
	end

	local profile_by_peer, var_29_1 = self._profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id)
	local name = SPProfiles[self._selected_profile_index].careers[self._selected_career_index].name
	local var_29_3 = CareerSettings[name]
	local _set_loadout = self:_set_loadout(self._selected_loadout, self._selected_loadout_type, self._selected_loadout_index, name)

	_set_loadout = _set_loadout or self._loadout_selection_changed

	if profile_by_peer ~= self._selected_profile_index or var_29_1 ~= self._selected_career_index or not _set_loadout then
		local required_dlc = var_29_3.required_dlc

		if not required_dlc and not Managers.unlock:dlc_requires_restart(required_dlc) then
			self._parent:close_menu()

			return
		end

		self._close_on_successful_profile_request = true

		self:_change_profile(self._selected_profile_index, self._selected_career_index)
		self._parent:set_input_blocked(true)

		self._new_loadout_confirmed = true

		if not (not self._selected_loadout_index and InventorySettings.loadouts[self._selected_loadout_index].loadout_type ~= "default") then
			Managers.telemetry_events:default_loadout_equipped()
		end
	else
		self._parent:close_menu()
	end
end

CharacterSelectionStateVersusLoadouts._populate_talent_grid = function (self)
	-- function 30
	local _hero_name = self._hero_name
	local _career_index = self._career_index
	local var_30_2 = FindProfileIndex(_hero_name)
	local var_30_3 = SPProfiles[var_30_2].careers[_career_index]
	local num = (_career_index - 1) * NumTalentRows
	local var_30_5 = TalentTrees[_hero_name][var_30_3.talent_tree_index]
	local _selected_loadout_talents = self._selected_loadout_talents
	local get_talent_overrides_by_career = PlayerUtils.get_talent_overrides_by_career(var_30_3.display_name)

	get_talent_overrides_by_career = get_talent_overrides_by_career or tbl

	local talent_grid = self._widgets_by_name.talent_grid
	local content = talent_grid.content
	local style = talent_grid.style

	for i = 1, NumTalentRows do
		local var_30_11 = _selected_loadout_talents[i]
		local str = "talent_row_" .. i

		content[str .. "_name"] = " "

		for j = 1, NumTalentColumns do
			local str_2 = "talent_" .. i .. "_" .. j
			local var_30_14 = var_30_5[i][j]
			local flag = get_talent_overrides_by_career[var_30_14] == false
			local talent_id = TalentIDLookup[var_30_14].talent_id
			local get_talent_by_id = TalentUtils.get_talent_by_id(_hero_name, talent_id)
			local flag_2 = j == var_30_11
			local var_30_19 = content[str_2]
			local var_30_20 = style[str_2]

			var_30_19.icon = get_talent_by_id.icon
			var_30_19.talent = get_talent_by_id
			var_30_19.is_selected = flag_2
			var_30_19.disabled = flag
			var_30_20.saturated = not flag_2 and flag

			local tbl_2

			if not flag then
				tbl_2 = {
					255,
					60,
					60,
					60
				}

				if not tbl_2 then
					-- Nothing
				end
			end

			tbl_2 = var_30_20.color

			::label_30_0::

			var_30_20.color = tbl_2

			local str_3 = str .. "_name"
			local var_30_23

			if not flag_2 then
				var_30_23 = Localize(var_30_14)

				if not var_30_23 then
					-- Nothing
				end
			end

			var_30_23 = content[str .. "_name"]

			::label_30_1::

			content[str_3] = var_30_23
		end
	end
end

CharacterSelectionStateVersusLoadouts._set_loadout = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	-- function 31
	if not (not arg_31_1 and not arg_31_2 and arg_31_3) then
		return false
	end

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local loadout_selection = PlayerData.loadout_selection

	loadout_selection = not loadout_selection and PlayerData.loadout_selection[current_mechanism_name]

	local var_31_2

	if not loadout_selection then
		var_31_2 = loadout_selection[arg_31_4]

		if not var_31_2 then
			-- Nothing
		end
	end

	var_31_2 = self._stored_selected_loadout_index

	::label_31_0::

	if not (arg_31_5 or arg_31_3 ~= var_31_2) then
		return var_31_2 ~= self._stored_selected_loadout_index
	end

	local player_unit = Managers.player:player_from_peer_id(self.peer_id).player_unit

	if not (not player_unit and Unit.alive(player_unit)) then
		return false
	end

	if not Managers.state.network:game() then
		return false
	end

	local var_31_4 = InventorySettings.loadouts[arg_31_3]

	if not arg_31_5 then
		self:_save_loadout_index(arg_31_4, arg_31_3)
	end

	local get_interface = Managers.backend:get_interface("talents")
	local get_interface_2 = Managers.backend:get_interface("items")

	if arg_31_2 == "default" then
		get_interface_2:set_default_override(arg_31_4, var_31_4.loadout_index)
	else
		get_interface_2:set_loadout_index(arg_31_4, var_31_4.loadout_index)

		for k, v in pairs(arg_31_1) do
			if not tbl_2[k] then
				if not CosmeticUtils.is_cosmetic_slot(k) then
					v = get_interface_2:get_backend_id_from_cosmetic_item(v)
				elseif k == "slot_pose" then
					local var_31_7 = arg_31_1[k]

					v = not var_31_7 and get_interface_2:get_backend_id_from_unlocked_weapon_poses(var_31_7)
				end

				local flag = not v and get_interface_2:get_item_from_id(v)

				if not (not flag and LoadoutUtils.is_item_disabled(flag.ItemId)) then
					local type = InventorySettings.slots_by_name[k].type
					local get_persistent_stat = self._statistics_db:get_persistent_stat(self._stats_id, "highest_equipped_rarity", type)
					local var_31_11 = self._rarity_indices[flag.rarity]

					if not (not var_31_11 and not (get_persistent_stat < var_31_11)) then
						self._statistics_db:set_stat(self._stats_id, "highest_equipped_rarity", type, var_31_11)
					end
				end
			end
		end
	end

	get_interface_2:make_dirty()
	get_interface:make_dirty()
	Managers.state.event:trigger("event_set_loadout_items")

	return var_31_2 ~= self._stored_selected_loadout_index
end

CharacterSelectionStateVersusLoadouts._save_loadout_index = function (arg_32_0, arg_32_1, arg_32_2)
	-- function 32
	local game_mode_key = Managers.state.game_mode:game_mode_key()

	if not InventorySettings.save_local_loadout_selection[game_mode_key] then
		return
	end

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local PlayerData = PlayerData
	local loadout_selection = PlayerData.loadout_selection

	loadout_selection = loadout_selection or {}
	PlayerData.loadout_selection = loadout_selection

	local loadout_selection_2 = PlayerData.loadout_selection
	local var_32_5 = PlayerData.loadout_selection[current_mechanism_name]

	var_32_5 = var_32_5 or {}
	loadout_selection_2[current_mechanism_name] = var_32_5
	PlayerData.loadout_selection[current_mechanism_name][arg_32_1] = arg_32_2

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

CharacterSelectionStateVersusLoadouts._change_loadout = function (self, arg_33_1, arg_33_2)
	-- function 33
	local loadout_frame = self._widgets_by_name.loadout_frame
	local selected_loadout_header = self._widgets_by_name.selected_loadout_header
	local selected_loadout_desc = self._widgets_by_name.selected_loadout_desc
	local selected_loadout_icon = self._widgets_by_name.selected_loadout_icon

	if not self._loadout_button_widgets[arg_33_1] then
		arg_33_1 = self._default_loadout_index
	end

	local _selected_profile_index = self._selected_profile_index

	_selected_profile_index = _selected_profile_index or self._profile_index

	local _selected_career_index = self._selected_career_index

	_selected_career_index = _selected_career_index or self._career_index

	local name = SPProfiles[_selected_profile_index].careers[_selected_career_index].name
	local var_33_7
	local var_33_8
	local var_33_9
	local var_33_10 = InventorySettings.loadouts[arg_33_1]

	if var_33_10.loadout_type == "default" then
		var_33_7 = name .. "_default_loadout_" .. var_33_10.loadout_index .. "_title"
		var_33_8 = name .. "_default_loadout_" .. var_33_10.loadout_index .. "_desc"
		var_33_9 = UISettings.default_loadout_settings[name][var_33_10.loadout_index].icon
	else
		var_33_7 = "custom_loadout_" .. var_33_10.loadout_index .. "_title"
		var_33_8 = "custom_loadout_desc"
		var_33_9 = var_33_10.loadout_icon or "icons_placeholder"
	end

	selected_loadout_header.content.text = Localize(var_33_7)
	selected_loadout_desc.content.text = Localize(var_33_8)
	selected_loadout_icon.content.texture_id = var_33_9

	local var_33_11 = self._loadout_button_widgets[arg_33_1]

	loadout_frame.offset = var_33_11.offset

	local content = var_33_11.content
	local loadout = content.loadout
	local talents = content.talents

	self._selected_loadout = loadout
	self._selected_loadout_talents = talents
	self._selected_loadout_type = content.loadout_type
	self._selected_loadout_index = content.loadout_index
	self._selected_loadout_settings = var_33_10

	self:_populate_tags()
	self:_populate_loadout(self._selected_profile_index, self._selected_career_index, loadout, talents, var_33_10)
	self:_set_loadout(self._selected_loadout, self._selected_loadout_type, self._selected_loadout_index, name, arg_33_2)

	self._spawn_hero = true

	self:_play_sound("Play_gui_loadout_select")
end

CharacterSelectionStateVersusLoadouts._draw = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _ui_scenegraph = self._ui_scenegraph
	local ui_top_renderer = self.ui_top_renderer
	local _render_settings = self._render_settings
	local input_service = self:input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, _ui_scenegraph, input_service, arg_34_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	if not self._loadout_selection_active then
		for i_2, v_2 in ipairs(self._loadout_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_2)
		end
	end

	if not self._loadout_selection_active then
		local alpha_multiplier = _render_settings.alpha_multiplier

		_render_settings.alpha_multiplier = self._loadout_selection_render_settings.alpha_multiplier

		for i_3, v_3 in ipairs(self._loadout_selection_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_3)
		end

		_render_settings.alpha_multiplier = alpha_multiplier
	end

	for i_4, v_4 in ipairs(self._hero_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_4)
	end

	for i_5, v_5 in ipairs(self._hero_icon_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_5)
	end

	for i_6, v_6 in ipairs(self._info_window_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_6)
	end

	for i_7, v_7 in ipairs(self._tag_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_7)
	end

	for i_8, v_8 in ipairs(self._additional_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_8)
	end

	for i_9, v_9 in ipairs(self._loadout_button_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_9)
	end

	if not is_device_active then
		UIRenderer.draw_widget(ui_top_renderer, self._console_cursor)
	end

	self:_draw_video(ui_top_renderer, arg_34_1, arg_34_2)
	UIRenderer.end_pass(ui_top_renderer)

	if not is_device_active then
		self._menu_input_description:draw(ui_top_renderer, arg_34_1)
	end

	if not self._scrollbar then
		_render_settings.alpha_multiplier = _render_settings.main_alpha_multiplier

		self._scrollbar:update(arg_34_1, arg_34_2, ui_top_renderer, input_service, _render_settings)
	end
end

CharacterSelectionStateVersusLoadouts._populate_loadout_buttons = function (self)
	-- function 35
	local _selected_profile_index = self._selected_profile_index

	_selected_profile_index = _selected_profile_index or self._profile_index

	local _selected_career_index = self._selected_career_index

	_selected_career_index = _selected_career_index or self._career_index

	local name = SPProfiles[_selected_profile_index].careers[_selected_career_index].name
	local var_35_3 = CareerSettings[name]
	local get_interface = Managers.backend:get_interface("items")
	local get_interface_2 = Managers.backend:get_interface("talents")
	local get_career_loadouts = get_interface:get_career_loadouts(name)
	local get_default_loadouts = get_interface:get_default_loadouts(name)
	local get_career_talents = get_interface_2:get_career_talents(name)
	local get_default_talents = get_interface_2:get_default_talents(name)
	local var_35_10 = UISettings.default_loadout_settings[name]

	for i = 1, #self._loadout_button_widgets do
		local content = self._loadout_button_widgets[i].content
		local var_35_12 = InventorySettings.loadouts[i]
		local loadout_type = var_35_12.loadout_type
		local loadout_index = var_35_12.loadout_index

		content.loadout_type = loadout_type

		if loadout_type == "default" then
			local var_35_15 = var_35_10[loadout_index]
			local var_35_16 = get_default_loadouts[loadout_index]
			local var_35_17 = get_default_talents[loadout_index]

			content.loadout = var_35_16
			content.loadout_index = i
			content.talents = var_35_17
			content.visible = var_35_16 ~= nil
			content.background.texture_id = var_35_15.icon
		elseif loadout_type == "custom" then
			local var_35_18 = get_career_loadouts[loadout_index]

			var_35_18 = not var_35_18 and table.clone(get_career_loadouts[loadout_index])

			local var_35_19 = get_career_talents[loadout_index]

			var_35_19 = not var_35_19 and table.clone(get_career_talents[loadout_index])
			content.loadout_index = i
			content.loadout = var_35_18
			content.talents = var_35_19
			content.visible = var_35_18 ~= nil

			local background = content.background
			local loadout_icon = var_35_12.loadout_icon

			loadout_icon = loadout_icon or "icons_placeholder"
			background.texture_id = loadout_icon
		end
	end
end

CharacterSelectionStateVersusLoadouts._populate_tags = function (self)
	-- function 36
	local _selected_profile_index = self._selected_profile_index

	_selected_profile_index = _selected_profile_index or self._profile_index

	local _selected_career_index = self._selected_career_index

	_selected_career_index = _selected_career_index or self._career_index

	local name = SPProfiles[_selected_profile_index].careers[_selected_career_index].name
	local _selected_loadout_index = self._selected_loadout_index

	_selected_loadout_index = _selected_loadout_index or self._default_loadout_index

	local var_36_4 = InventorySettings.loadouts[_selected_loadout_index]
	local tbl = {}

	if var_36_4.loadout_type == "default" then
		local var_36_6 = UISettings.default_loadout_settings[name][var_36_4.loadout_index]

		tbl = string.split_deprecated(var_36_6.tags, ",")
	else
		tbl[#tbl + 1] = "loadout_tag_custom"
	end

	local tbl_2 = {}
	local count = #tbl
	local num = 0
	local num_2 = 10

	local function fn(arg_37_0, arg_37_1)
		-- function 37
		return Localize(arg_37_0) < Localize(arg_37_1)
	end

	table.sort(tbl, fn)

	for i = 1, count do
		local var_36_12 = tbl[i]
		local var_36_13 = tag_widget_func(tag_scenegraph_id, Localize(var_36_12), {
			nil,
			30
		})
		local var_36_14 = UIWidget.init(var_36_13)

		num = num + var_36_14.content.size[1] * 0.5
		var_36_14.offset[1] = num
		tbl_2[#tbl_2 + 1] = var_36_14
		num = num + var_36_14.content.size[1] * 0.5 + num_2
	end

	self._tag_widgets = tbl_2
end

CharacterSelectionStateVersusLoadouts._populate_loadout = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	-- function 38
	local _selected_profile_index = self._selected_profile_index

	_selected_profile_index = _selected_profile_index or self._profile_index

	local _selected_career_index = self._selected_career_index

	_selected_career_index = _selected_career_index or self._career_index

	local var_38_2 = SPProfiles[_selected_profile_index]
	local var_38_3 = var_38_2.careers[_selected_career_index]
	local display_name = var_38_2.display_name
	local name = var_38_3.name
	local var_38_6 = arg_38_5

	var_38_6 = var_38_6 or InventorySettings.loadouts[self._stored_selected_loadout_index]

	local var_38_7 = tbl
	local var_38_8 = tbl
	local get_interface = Managers.backend:get_interface("talents")

	if not arg_38_4 then
		var_38_7 = arg_38_4
		var_38_8 = get_interface:get_talent_ids(name, var_38_7)
	else
		var_38_8 = get_interface:get_talent_ids(name)
		var_38_7 = get_interface:get_talents(name)
	end

	local content = self._widgets_by_name.loadout_talents.content
	local num = 1

	for i = 1, MaxTalentPoints do
		local var_38_12 = content["talent_" .. i]

		if var_38_7[i] ~= 0 then
			local var_38_13 = var_38_8[num]
			local get_talent_by_id = TalentUtils.get_talent_by_id(display_name, var_38_13)
			local flag = not get_talent_by_id and get_talent_by_id.icon

			if not flag then
				get_talent_by_id = nil
			end

			var_38_12.icon = flag
			var_38_12.talent = get_talent_by_id
			num = num + 1
		else
			var_38_12.talent = nil
		end
	end

	content.locked = not var_38_6 and var_38_6.loadout_type == "default"

	local get_interface_2 = Managers.backend:get_interface("items")
	local content_2 = self._widgets_by_name.loadout_weapons.content

	for i_2, v in ipairs(weapon_slots) do
		local var_38_18

		if not arg_38_3 then
			local var_38_19 = arg_38_3[v]

			var_38_18 = get_interface_2:get_item_from_id(var_38_19)
		else
			var_38_18 = BackendUtils.get_loadout_item(name, v)
		end

		content_2[v].item = var_38_18
		content_2[v].icon = var_38_18.data.inventory_icon
		content_2[v].locked = not var_38_6 and var_38_6.loadout_type == "default"
	end

	self._widgets_by_name.weapons_header.content.default_loadout = not var_38_6 and var_38_6.loadout_type == "default"
	self._widgets_by_name.talents_header.content.default_loadout = not var_38_6 and var_38_6.loadout_type == "default"
end

CharacterSelectionStateVersusLoadouts._populate_career_info = function (self)
	-- function 39
	local _selected_profile_index = self._selected_profile_index

	_selected_profile_index = _selected_profile_index or self._profile_index

	local _selected_career_index = self._selected_career_index

	_selected_career_index = _selected_career_index or self._career_index

	local _ui_scenegraph = self._ui_scenegraph
	local ui_top_renderer = self.ui_top_renderer
	local _widgets_by_name = self._widgets_by_name
	local var_39_5 = SPProfiles[_selected_profile_index]
	local display_name = var_39_5.display_name
	local var_39_7 = var_39_5.careers[_selected_career_index]
	local name = var_39_7.name
	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(var_39_7)
	local get_ability_data_by_career = CareerUtils.get_ability_data_by_career(var_39_7, 1)
	local display_name_2 = get_passive_ability_by_career.display_name
	local icon = get_passive_ability_by_career.icon
	local display_name_3 = get_ability_data_by_career.display_name
	local icon_2 = get_ability_data_by_career.icon

	_widgets_by_name.passive_title_text.content.text = Localize(display_name_2)
	_widgets_by_name.passive_description_text.content.text = UIUtils.get_ability_description(get_passive_ability_by_career)
	_widgets_by_name.passive_icon.content.texture_id = icon
	_widgets_by_name.active_title_text.content.text = Localize(display_name_3)
	_widgets_by_name.active_description_text.content.text = UIUtils.get_ability_description(get_ability_data_by_career)
	_widgets_by_name.active_icon.content.texture_id = icon_2

	local perks = get_passive_ability_by_career.perks
	local num = 0
	local num_2 = 0

	for i = 1, NUM_PERKS do
		local var_39_18 = _widgets_by_name["career_perk_" .. i]
		local content = var_39_18.content
		local style = var_39_18.style
		local size = _ui_scenegraph[var_39_18.scenegraph_id].size

		var_39_18.offset[2] = -num

		local var_39_22 = perks[i]

		if not var_39_22 then
			local var_39_23 = Localize(var_39_22.display_name)
			local get_perk_description = UIUtils.get_perk_description(var_39_22)
			local title_text = style.title_text
			local description_text = style.description_text
			local description_text_shadow = style.description_text_shadow

			content.title_text = var_39_23
			content.description_text = get_perk_description

			local get_text_height = UIUtils.get_text_height(ui_top_renderer, size, title_text, var_39_23)
			local get_text_height_2 = UIUtils.get_text_height(ui_top_renderer, size, description_text, get_perk_description)

			description_text.offset[2] = -get_text_height_2
			description_text_shadow.offset[2] = -(get_text_height_2 + 2)
			num = num + get_text_height + get_text_height_2 + num_2
		end

		content.visible = var_39_22 ~= nil
	end

	local num_3 = 240
	local max = math.max(num - num_3, 0)

	self:_setup_additional_career_info(var_39_7, max)

	local video = var_39_7.video
	local material_name = video.material_name
	local resource = video.resource

	self._current_video_settings = {
		video = video,
		material_name = material_name,
		resource = resource
	}

	self:_destroy_video_player()
end

CharacterSelectionStateVersusLoadouts._draw_video = function (self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	if not self._draw_video_next_frame then
		if not (not self._video_widget and self._prepare_exit) then
			if not self._video_created then
				UIRenderer.draw_widget(arg_40_1, self._video_widget)
			else
				self._video_created = nil
			end
		end
	elseif not self._draw_video_next_frame then
		self._draw_video_next_frame = nil
	end
end

CharacterSelectionStateVersusLoadouts._select_hero = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5)
	-- function 41
	local var_41_0 = SPProfiles[arg_41_1]
	local var_41_1 = var_41_0.careers[arg_41_2]
	local display_name = var_41_0.display_name
	local character_name = var_41_0.character_name
	local display_name_2 = var_41_1.display_name
	local required_dlc = var_41_1.required_dlc

	if not (not required_dlc and Managers.unlock:is_dlc_unlocked(required_dlc)) then
		return
	end

	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "experience")

	get = get or 0

	local get_level = ExperienceSettings.get_level(get)
	local is_unlocked_function, var_41_9, var_41_10, var_41_11 = var_41_1:is_unlocked_function(display_name, get_level)
	local content = self._widgets_by_name.locked_info_text.content

	content.text = is_unlocked_function or not var_41_9 or ""
	content.visible = not is_unlocked_function

	if not arg_41_3 then
		self:_play_sound("play_gui_hero_select_career_click")
	end

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", display_name_2 == "bw_necromancer")

	self._spawn_hero = true

	if not arg_41_4 then
		self._spawn_hero = false
	end

	self._selected_career_index = arg_41_2
	self._selected_profile_index = arg_41_1
	self._selected_hero_name = display_name

	self:_populate_career_info()
	self:_populate_loadout()
	self:_populate_tags()
	self:_populate_loadout_buttons()

	for i, v in ipairs(self._hero_widgets) do
		v.content.button_hotspot.is_selected = i == self._selected_career_index
	end

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local loadout_selection = PlayerData.loadout_selection

	loadout_selection = not loadout_selection and PlayerData.loadout_selection[current_mechanism_name]

	local var_41_15

	if not loadout_selection then
		var_41_15 = loadout_selection[display_name_2]

		if not var_41_15 then
			-- Nothing
		end
	end

	var_41_15 = self._stored_selected_loadout_index

	::label_41_0::

	self:_change_loadout(var_41_15, arg_41_5)
end

CharacterSelectionStateVersusLoadouts._spawn_hero_unit = function (self, arg_42_1)
	-- function 42
	local world_previewer = self.world_previewer
	local _selected_career_index = self._selected_career_index
	local var_42_2 = callback(self, "cb_hero_unit_spawned", arg_42_1)
	local flag = false

	world_previewer:request_spawn_hero_unit(arg_42_1, _selected_career_index, flag, var_42_2, nil, 0.5)
end
