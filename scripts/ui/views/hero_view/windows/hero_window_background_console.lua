-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_background_console.lua

require("scripts/ui/views/menu_world_previewer")
require("scripts/settings/hero_statistics_template")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_background_console_definitions")
local widgets = var_0_0.widgets
local background_rect = var_0_0.background_rect
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local camera_position_by_character = var_0_0.camera_position_by_character
local loading_overlay_widgets = var_0_0.loading_overlay_widgets
local flag = false
local tbl = {
	equipment = {
		equipment_view = true
	},
	talents = {
		talents_view = true
	},
	forge = {
		crafting_view = true
	},
	cosmetics = {
		cosmetics_view = true
	},
	crafting_recipe = {
		crafting_view = true
	},
	equipment_selection = {
		equipment_view = true
	},
	cosmetics_selection = {
		keep_current_object_set = true
	},
	cosmetics_selection_dark_pact = {
		keep_current_object_set = true
	},
	pose_selection = {
		pose_cosmetics = true
	},
	system = {
		main_menu = true
	},
	character_selection = {
		keep_current_object_set = true
	},
	item_customization = {
		keep_current_object_set = true
	},
	pactsworn_equipment = {
		skaven_cosmetics_view = true
	}
}
local tbl_2 = {
	equipment = {
		"equipment_view"
	},
	talents = {
		"talents_view"
	},
	forge = {
		"crafting_view"
	},
	cosmetics = {
		"cosmetics_view"
	},
	crafting_recipe = {
		"crafting_view"
	},
	equipment_selection = {
		"equipment_view"
	},
	cosmetics_selection = {
		"cosmetics_view"
	},
	cosmetics_selection_dark_pact = {
		"cosmetics_view"
	},
	pose_selection = {
		"cosmetics_view"
	},
	system = {
		"main_menu"
	},
	character_selection = {
		"equipment_view",
		"main_menu",
		"cosmetics_view",
		"crafting_view"
	},
	pactsworn_equipment = {
		"cosmetics_view"
	}
}
local tbl_3 = {
	cosmetics_selection = true,
	equipment_selection = true,
	forge = false,
	cosmetics_selection_dark_pact = true,
	system = false,
	cosmetics = true,
	pose_selection = true,
	equipment = true,
	character_selection = true,
	crafting_recipe = false,
	pactsworn_equipment = true,
	talents = false
}
local tbl_4 = {
	character_selection = UISettings.console_menu_camera_move_duration
}
local tbl_5 = {}
local tbl_6 = {
	pose_selection = {
		witch_hunter = {
			-0.6,
			-1,
			0.4
		},
		bright_wizard = {
			-0.5,
			-0.8,
			0.3
		},
		dwarf_ranger = {
			-0.5,
			-0.7,
			0
		},
		wood_elf = {
			-0.5,
			-0.7,
			0.2
		},
		empire_soldier = {
			-0.5,
			-1,
			0.3
		}
	},
	default = {
		0,
		0,
		0
	}
}
local tbl_7 = {
	adventure = "default",
	versus = "menu_versus"
}

HeroWindowBackgroundConsole = class(HeroWindowBackgroundConsole)
HeroWindowBackgroundConsole.NAME = "HeroWindowBackgroundConsole"

HeroWindowBackgroundConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowBackgroundConsole")

	self.params = arg_1_1
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
	self.is_in_inn = ingame_ui_context.is_in_inn
	self.force_ingame_menu = arg_1_1.force_ingame_menu
	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.skin_sync_id = self.parent.skin_sync_id
	self._camera_move_duration = not not IS_WINDOWS or UISettings.console_menu_camera_move_duration
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
	Managers.state.event:register(self, "respawn_hero", "respawn_hero")
	Managers.state.event:register(self, "despawn_hero", "despawn_hero")
end

HeroWindowBackgroundConsole._get_with_mechanism = function (arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = arg_2_1[Managers.mechanism:current_mechanism_name()]

	var_2_0 = var_2_0 or arg_2_1.default

	return var_2_0
end

local tbl_8 = {
	default = "default",
	versus = "menu_versus"
}

HeroWindowBackgroundConsole._create_viewport_definition = function (arg_3_0)
	-- function 3
	return {
		scenegraph_id = "screen",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 960,
				viewport_name = "character_preview_viewport",
				shading_environment = "environment/ui_end_screen",
				clear_screen_on_create = true,
				mood_setting = "default",
				level_name = "levels/ui_keep_menu/world",
				enable_sub_gui = false,
				fov = 50,
				world_name = "character_preview",
				world_flags = {
					Application.DISABLE_SOUND,
					Application.DISABLE_ESRAM,
					Application.ENABLE_VOLUMETRICS
				},
				object_sets = LevelResource.object_set_names("levels/ui_keep_menu/world"),
				camera_position = {
					0,
					0,
					0
				},
				camera_lookat = {
					0,
					0,
					0
				}
			}
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		}
	}
end

HeroWindowBackgroundConsole.create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_4_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_2
		tbl_2[k] = var_4_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(loading_overlay_widgets) do
		local var_4_5 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_4_5
		tbl_4[k_2] = var_4_5
	end

	self._loading_overlay_widgets = tbl_3
	self._loading_overlay_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end

	if not (not self.is_in_inn and self.force_ingame_menu) then
		self._viewport_widget_definition = self:_create_viewport_definition()

		self:_setup_object_sets()
	else
		self._background_widget = UIWidget.init(background_rect)
	end

	if not Development.parameter("hero_statistics") then
		tbl_2.detailed.content.visible = false
	end
end

HeroWindowBackgroundConsole._setup_object_sets = function (self)
	-- function 5
	local level_name = self._viewport_widget_definition.style.viewport.level_name
	local object_set_names = LevelResource.object_set_names(level_name)

	self._object_sets = {}

	for i, v in ipairs(object_set_names) do
		self._object_sets[v] = LevelResource.unit_indices_in_object_set(level_name, v)
	end
end

HeroWindowBackgroundConsole.on_exit = function (self, arg_6_1)
	-- function 6
	print("[HeroViewWindow] Exit Substate HeroWindowBackgroundConsole")

	self.ui_animator = nil

	Managers.state.event:unregister("respawn_hero", self)
	Managers.state.event:unregister("despawn_hero", self)

	if not self.world_previewer then
		self.world_previewer:prepare_exit()
		self.world_previewer:on_exit()
		self.world_previewer:destroy()
	end

	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end
end

HeroWindowBackgroundConsole.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	if not self.world_previewer and not self.hero_unit_spawned then
		local window_input_service = self.parent:window_input_service()

		self:_handle_input(window_input_service, arg_7_1, arg_7_2)
		self:_update_statistics_widget(window_input_service, arg_7_1)
	end

	self:_update_animations(arg_7_1)
	self:draw(arg_7_1)

	if not self.world_previewer then
		local _statistics_activate = self:_statistics_activate()

		self.world_previewer:update(arg_7_1, arg_7_2, _statistics_activate)
	end
end

HeroWindowBackgroundConsole._update_character_visibility = function (self, arg_8_1)
	-- function 8
	local var_8_0 = tbl_3[arg_8_1]

	var_8_0 = var_8_0 or false

	local var_8_1 = tbl_4[arg_8_1]
	local var_8_2 = tbl_5[arg_8_1]

	if self._draw_character ~= var_8_0 then
		self.world_previewer:_set_character_visibility(var_8_0, var_8_1, var_8_2)
	end

	self._draw_character = var_8_0

	if var_8_0 or not self.params.hero_statistics_active then
		self:_handle_statistics_pressed()
	end

	if not var_8_0 then
		local var_8_3 = tbl_6[arg_8_1]

		var_8_3 = var_8_3 or tbl_6.default
		var_8_3 = var_8_3[self.hero_name] or var_8_3

		self.world_previewer:set_hero_location_lerped(var_8_3, 0.5)
	end
end

local tbl_9 = {}

HeroWindowBackgroundConsole._update_level_events = function (self, arg_9_1)
	-- function 9
	local var_9_0 = tbl_2[arg_9_1]

	var_9_0 = var_9_0 or tbl_9

	for i, v in ipairs(var_9_0) do
		self.world_previewer:trigger_level_event(v)
	end
end

HeroWindowBackgroundConsole._update_object_sets = function (self, arg_10_1)
	-- function 10
	local var_10_0 = tbl[arg_10_1]

	if not var_10_0.keep_current_object_set then
		return
	end

	for k, v in pairs(self._object_sets) do
		local var_10_1

		if not var_10_0 then
			var_10_1 = var_10_0[k]

			if not var_10_1 then
				-- Nothing
			end
		end

		var_10_1 = false

		::label_10_0::

		self.world_previewer:show_level_units(v, var_10_1)
	end
end

HeroWindowBackgroundConsole.post_update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not (not self._viewport_widget_definition and self._viewport_widget) then
		self._viewport_widget = UIWidget.init(self._viewport_widget_definition)
		self._fadeout_loading_overlay = true
	end

	self:_update_loading_overlay_fadeout_animation(arg_11_1)

	if self.initialized or not self._viewport_widget then
		local var_11_0 = MenuWorldPreviewer:new(self.ingame_ui_context, camera_position_by_character, "HeroWindowBackgroundConsole")

		local function fn()
			-- function 12
			self.hero_unit_spawned = true
		end

		self.hero_unit_spawned = false

		var_11_0:on_enter(self._viewport_widget, self.hero_name)
		var_11_0:request_spawn_hero_unit(self.hero_name, self.career_index, false, fn, nil, self._camera_move_duration)

		self.world_previewer = var_11_0
		self.initialized = true
	end

	if not self.world_previewer then
		local get_layout_name = self.parent:get_layout_name()

		if get_layout_name ~= self._current_layout_name then
			self:_update_object_sets(get_layout_name)
			self:_update_level_events(get_layout_name)
			self:_update_character_visibility(get_layout_name)

			self._current_layout_name = get_layout_name
		end

		if not self.hero_unit_spawned then
			self:_update_skin_sync()
			self:_update_loadout_sync()
			self:_update_wielded_slot()
			self:_update_temporary_loadout_sync()
			self:_update_character_pose_animation_sync()
		end

		self.world_previewer:post_update(arg_11_1, arg_11_2)
	end
end

local num = -1

HeroWindowBackgroundConsole.respawn_hero = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not arg_13_1 then
		self.hero_name = arg_13_1.hero_name
		self.career_index = arg_13_1.career_index
	end

	local world_previewer = self.world_previewer

	if not world_previewer then
		return
	end

	self.hero_unit_spawned = false

	local function fn()
		-- function 14
		self.hero_unit_spawned = true
		self._loadout_sync_id = num

		self:_update_loadout_sync()

		self._selected_loadout_slot_index = num

		self:_update_wielded_slot()

		local var_14_0 = FindProfileIndex(self.hero_name)
		local var_14_1 = SPProfiles[var_14_0]

		if var_14_1.affiliation == "dark_pact" then
			local preview_idle_animation = var_14_1.careers[self.career_index].preview_idle_animation

			if not preview_idle_animation then
				self.world_previewer:play_character_animation(preview_idle_animation)
			end
		end
	end

	world_previewer:respawn_hero_unit(self.hero_name, self.career_index, false, fn, self._camera_move_duration)
end

HeroWindowBackgroundConsole.despawn_hero = function (self)
	-- function 15
	local world_previewer = self.world_previewer

	if not world_previewer then
		return
	end

	world_previewer:hide_character()
end

HeroWindowBackgroundConsole._update_animations = function (self, arg_16_1)
	-- function 16
	self.ui_animator:update(arg_16_1)

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

HeroWindowBackgroundConsole._update_temporary_loadout_sync = function (self)
	-- function 17
	local temporary_loadout_sync_id = self.parent.temporary_loadout_sync_id

	if not (not (temporary_loadout_sync_id > 0) or temporary_loadout_sync_id == self._temporary_loadout_sync_id) then
		self:_populate_temporary_loadout()

		self._temporary_loadout_sync_id = temporary_loadout_sync_id
	end
end

HeroWindowBackgroundConsole._update_character_pose_animation_sync = function (self)
	-- function 18
	local character_pose_animation_sync_id = self.parent.character_pose_animation_sync_id

	if not (not (character_pose_animation_sync_id > 0) or character_pose_animation_sync_id == self._character_pose_animation_sync_id) then
		local get_character_animation_event = self.parent:get_character_animation_event()

		if not get_character_animation_event then
			local flag = true

			self.world_previewer:set_pose_animation(get_character_animation_event, flag)
		else
			self.world_previewer:reset_pose_animation()
		end

		self._character_pose_animation_sync_id = character_pose_animation_sync_id
	end
end

HeroWindowBackgroundConsole._update_loadout_sync = function (self)
	-- function 19
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id then
		self:_populate_loadout()

		self._loadout_sync_id = loadout_sync_id

		self:_sync_statistics()
	end
end

HeroWindowBackgroundConsole._update_skin_sync = function (self)
	-- function 20
	local skin_sync_id = self.parent.skin_sync_id

	if skin_sync_id ~= self.skin_sync_id then
		self:respawn_hero()

		self.skin_sync_id = skin_sync_id
	end
end

HeroWindowBackgroundConsole._update_wielded_slot = function (self)
	-- function 21
	local get_selected_loadout_slot_index = self.parent:get_selected_loadout_slot_index()

	if get_selected_loadout_slot_index ~= self._selected_loadout_slot_index then
		local slots_by_slot_index = InventorySettings.slots_by_slot_index

		for k, v in pairs(slots_by_slot_index) do
			if v.slot_index == get_selected_loadout_slot_index then
				local type = v.type

				if not (type == "melee" or type ~= "ranged") then
					if self.world_previewer:wielded_slot_type() ~= type then
						self.world_previewer:wield_weapon_slot(type)
					end

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

HeroWindowBackgroundConsole._hero_affiliation = function (self)
	-- function 22
	local hero_name = self.hero_name
	local var_22_1 = FindProfileIndex(hero_name)
	local var_22_2 = SPProfiles[var_22_1]

	return not var_22_2 and var_22_2.affiliation
end

HeroWindowBackgroundConsole._populate_loadout = function (self)
	-- function 23
	local world_previewer = self.world_previewer
	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_23_3 = FindProfileIndex(hero_name)
	local var_23_4 = SPProfiles[var_23_3].careers[career_index]
	local name = var_23_4.name
	local _hero_affiliation = self:_hero_affiliation()
	local var_23_7 = InventorySettings.slots_per_affiliation[_hero_affiliation]
	local get = Managers.backend:get_interface("hero_attributes"):get(hero_name, "experience")

	get = get or 0

	local get_level = ExperienceSettings.get_level(get)
	local is_unlocked_function, var_23_11, var_23_12, var_23_13 = var_23_4:is_unlocked_function(hero_name, get_level)

	if not (not not is_unlocked_function or var_23_12) then
		local preview_items = var_23_4.preview_items
		local preview_wield_slot = var_23_4.preview_wield_slot
		local preview_animation = var_23_4.preview_animation

		if not preview_items then
			for i, v in ipairs(preview_items) do
				local item_name = v.item_name
				local slot_type = ItemMasterList[item_name].slot_type
				local var_23_19 = InventorySettings.slot_names_by_type[slot_type][1]
				local var_23_20 = InventorySettings.slots_by_name[var_23_19]

				world_previewer:equip_item(item_name, var_23_20)
			end

			if not preview_wield_slot then
				world_previewer:wield_weapon_slot(preview_wield_slot)
			end
		end

		local name_2 = var_23_4.name
		local get_loadout_item = BackendUtils.get_loadout_item(name_2, "slot_hat")

		if not get_loadout_item then
			local name_3 = get_loadout_item.data.name
			local backend_id = get_loadout_item.backend_id
			local slot_hat = InventorySettings.slots_by_name.slot_hat

			world_previewer:equip_item(name_3, slot_hat, backend_id)
		end

		local get_loadout_item_2 = BackendUtils.get_loadout_item(name_2, "slot_skin")
		local flag = not get_loadout_item_2 and get_loadout_item_2.data

		preview_animation = not flag and flag.career_select_preview_animation and preview_animation

		if not preview_animation then
			self.world_previewer:play_character_animation(preview_animation)
		end
	else
		local flag_2 = false

		for k, v_2 in pairs(var_23_7) do
			local var_23_29 = InventorySettings.slots_by_name[v_2]
			local type = var_23_29.type
			local get_temporary_loadout_item = self.parent:get_temporary_loadout_item(type)

			get_temporary_loadout_item = get_temporary_loadout_item or BackendUtils.get_loadout_item(name, v_2)

			local var_23_32

			if not get_temporary_loadout_item then
				local name_4 = get_temporary_loadout_item.data.name
				local type_2 = var_23_29.type

				if not (name_4 ~= world_previewer:item_name_by_slot_type(type_2) or type_2 == "melee" or type_2 ~= "ranged") then
					local backend_id_2 = get_temporary_loadout_item.backend_id
					local get_equipped_item_info = world_previewer:get_equipped_item_info(var_23_29)

					if not (not get_equipped_item_info and get_equipped_item_info.backend_id == backend_id_2) then
						world_previewer:equip_item(name_4, var_23_29, backend_id_2)
					end
				end
			else
				printf("[Cosmetic] Failed to equip slot %q for career %q in hero previewer", v_2, name)

				flag_2 = true
			end
		end

		if not flag_2 then
			Crashify.print_exception("[Cosmetic]", "Failed to equip slot for career in hero previewer")
		end
	end
end

HeroWindowBackgroundConsole._populate_temporary_loadout = function (self)
	-- function 24
	local world_previewer = self.world_previewer
	local slots_by_slot_index = InventorySettings.slots_by_slot_index
	local parent = self.parent
	local flag = false

	for k, v in pairs(slots_by_slot_index) do
		local type = v.type
		local get_temporary_loadout_item, var_24_6 = parent:get_temporary_loadout_item(type)

		if not get_temporary_loadout_item then
			local name = get_temporary_loadout_item.data.name
			local type_2 = v.type

			if not (name ~= world_previewer:item_name_by_slot_type(type_2) or type_2 == "melee" or type_2 ~= "ranged") then
				local backend_id = get_temporary_loadout_item.backend_id
				local get_equipped_item_info = world_previewer:get_equipped_item_info(v)
				local skin_name = get_equipped_item_info.skin_name
				local skin = get_temporary_loadout_item.skin
				local flag_2 = skin_name ~= skin

				if not get_equipped_item_info and get_equipped_item_info.backend_id ~= backend_id or not flag_2 then
					world_previewer:equip_item(name, v, backend_id, skin, var_24_6)

					if not (var_24_6 or type_2 == "melee" or type_2 ~= "ranged") then
						world_previewer:wield_weapon_slot(type_2)
					end
				elseif not (var_24_6 or type_2 == "melee" or type_2 ~= "ranged") then
					world_previewer:wield_weapon_slot(type_2)
				end
			end
		end
	end
end

HeroWindowBackgroundConsole._is_button_pressed = function (arg_25_0, arg_25_1)
	-- function 25
	local button_hotspot = arg_25_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowBackgroundConsole._is_stepper_button_pressed = function (arg_26_0, arg_26_1)
	-- function 26
	local content = arg_26_1.content
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

HeroWindowBackgroundConsole._handle_input = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local detailed = self._widgets_by_name.detailed

	if not self._draw_character then
		-- Nothing
	end
end

HeroWindowBackgroundConsole._exit = function (self, arg_28_1)
	-- function 28
	self.exit = true
	self.exit_level_id = arg_28_1
end

HeroWindowBackgroundConsole.draw = function (self, arg_29_1)
	-- function 29
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_29_1, nil, self.render_settings)

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
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_29_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_renderer, self._viewport_widget)
		UIRenderer.end_pass(ui_renderer)
	elseif not self._background_widget then
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_29_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_renderer, self._background_widget)
		UIRenderer.end_pass(ui_renderer)
	end
end

HeroWindowBackgroundConsole._play_sound = function (self, arg_30_1)
	-- function 30
	self.parent:play_sound(arg_30_1)
end

HeroWindowBackgroundConsole._update_loading_overlay_fadeout_animation = function (self, arg_31_1)
	-- function 31
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

	local var_31_7 = min(num_4, _fadeout_progress + num_3 * arg_31_1)
	local lerp = math.lerp(num, num_2, math.easeInCubic(var_31_7))
	local loading_overlay = _loading_overlay_widgets_by_name.loading_overlay
	local loading_overlay_loading_glow = _loading_overlay_widgets_by_name.loading_overlay_loading_glow
	local loading_overlay_loading_frame = _loading_overlay_widgets_by_name.loading_overlay_loading_frame

	loading_overlay.style.rect.color[1] = lerp
	loading_overlay_loading_glow.style.texture_id.color[1] = lerp
	loading_overlay_loading_frame.style.texture_id.color[1] = lerp
	self._fadeout_progress = var_31_7

	if var_31_7 == 1 then
		self._fadeout_loading_overlay = nil
		self._fadeout_progress = nil
		self._show_loading_overlay = false
	end
end

HeroWindowBackgroundConsole._handle_statistics_pressed = function (self)
	-- function 32
	local _statistics_activate = self:_statistics_activate()

	self.params.hero_statistics_active = not _statistics_activate

	if not _statistics_activate then
		self:_deactivate_statistics()
	else
		self:_activate_statistics()
	end
end

HeroWindowBackgroundConsole._statistics_activate = function (self)
	-- function 33
	return self._widgets_by_name.detailed.content.active
end

HeroWindowBackgroundConsole._activate_statistics = function (self)
	-- function 34
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

HeroWindowBackgroundConsole._sync_statistics = function (self)
	-- function 35
	if not self:_statistics_activate() then
		return
	end

	local HeroStatisticsTemplate = HeroStatisticsTemplate
	local get_hero_statistics_by_template = UIUtils.get_hero_statistics_by_template(HeroStatisticsTemplate)

	self:_populate_statistics(get_hero_statistics_by_template)
end

HeroWindowBackgroundConsole._deactivate_statistics = function (self)
	-- function 36
	local detailed = self._widgets_by_name.detailed

	detailed.content.active = false
	detailed.content.list_content.active = false
	detailed.content.scrollbar.active = false
	detailed.style.drop_down_arrow.angle = 0
end

HeroWindowBackgroundConsole._update_statistics_widget = function (self, arg_37_1, arg_37_2)
	-- function 37
	local detailed = self._widgets_by_name.detailed

	if not detailed.content.active then
		return
	end

	local get = arg_37_1:get("gamepad_right_axis")

	if not (not get and not (Vector3.length(get) > 0.01)) then
		local scroll_value = detailed.content.scrollbar.scroll_value

		detailed.content.scrollbar.scroll_value = math.clamp(scroll_value + get.y * arg_37_2 * 5, 0, 1)
	end

	local size = scenegraph_definition.detailed_button.size
	local size_2 = scenegraph_definition.detailed_list.size
	local list_style = detailed.style.list_style
	local var_37_6 = list_style.list_member_offset[2]
	local num_draws = list_style.num_draws
	local var_37_8

	if num_draws == 0 then
		var_37_8 = math.abs(var_37_6)
	else
		var_37_8 = math.abs(var_37_6 * num_draws)
	end

	local max = math.max(var_37_8 - size_2[2], 0)
	local scenegraph_id = list_style.scenegraph_id
	local local_position = self.ui_scenegraph[scenegraph_id].local_position
	local num = 1 - detailed.content.scrollbar.scroll_value

	local_position[2] = -size[2] + max * num
end

HeroWindowBackgroundConsole._populate_statistics = function (self, arg_38_1)
	-- function 38
	local detailed = self._widgets_by_name.detailed
	local content = detailed.content
	local list_style = detailed.style.list_style
	local list_content = content.list_content
	local item_styles = list_style.item_styles
	local count = #arg_38_1

	for i = 1, count do
		local var_38_6 = arg_38_1[i]
		local str = ""
		local str_2 = ""
		local str_3 = ""
		local type = var_38_6.type

		if type == "title" then
			str = var_38_6.display_name
		elseif type == "entry" then
			str_2 = var_38_6.display_name
			str_3 = var_38_6.value
		end

		local var_38_11 = list_content[i]

		var_38_11.name = UIRenderer.crop_text_width(self.ui_renderer, str_2, 300, item_styles[i].name)
		var_38_11.title = UIRenderer.crop_text_width(self.ui_renderer, str, 300, item_styles[i].title)
		var_38_11.value = str_3
	end

	list_style.num_draws = count

	self:_setup_tab_scrollbar(detailed)
end

HeroWindowBackgroundConsole._setup_tab_scrollbar = function (arg_39_0, arg_39_1)
	-- function 39
	local size = scenegraph_definition.detailed_button.size
	local size_2 = scenegraph_definition.detailed_list.size
	local list_style = arg_39_1.style.list_style
	local var_39_3 = list_style.list_member_offset[2]
	local num_draws = list_style.num_draws
	local var_39_5

	if num_draws == 0 then
		var_39_5 = math.abs(var_39_3)
	else
		var_39_5 = math.abs(var_39_3 * num_draws)
	end

	local min = math.min(size_2[2] / var_39_5, 1)
	local scrollbar = arg_39_1.content.scrollbar

	if min < 1 then
		scrollbar.percentage = min
		scrollbar.scroll_value = 1

		local num = 2

		scrollbar.scroll_amount = var_39_3 / (var_39_5 - size_2[2]) * num
	else
		scrollbar.percentage = 1
		scrollbar.scroll_value = 1
	end
end
