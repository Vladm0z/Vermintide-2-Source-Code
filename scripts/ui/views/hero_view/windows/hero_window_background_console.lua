-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_background_console.lua

require("scripts/ui/views/menu_world_previewer")
require("scripts/settings/hero_statistics_template")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_background_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.background_rect
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.camera_position_by_character
local var_0_6 = var_0_0.loading_overlay_widgets
local var_0_7 = false
local var_0_8 = {
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
local var_0_9 = {
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
local var_0_10 = {
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
local var_0_11 = {
	character_selection = UISettings.console_menu_camera_move_duration
}
local var_0_12 = {}
local var_0_13 = {
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
local var_0_14 = {
	adventure = "default",
	versus = "menu_versus"
}

HeroWindowBackgroundConsole = class(HeroWindowBackgroundConsole)
HeroWindowBackgroundConsole.NAME = "HeroWindowBackgroundConsole"

function HeroWindowBackgroundConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowBackgroundConsole")

	arg_1_0.params = arg_1_1
	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ingame_ui_context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.is_in_inn = var_1_0.is_in_inn
	arg_1_0.force_ingame_menu = arg_1_1.force_ingame_menu
	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.skin_sync_id = arg_1_0.parent.skin_sync_id
	arg_1_0._camera_move_duration = not IS_WINDOWS and UISettings.console_menu_camera_move_duration
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	Managers.state.event:register(arg_1_0, "respawn_hero", "respawn_hero")
	Managers.state.event:register(arg_1_0, "despawn_hero", "despawn_hero")
end

function HeroWindowBackgroundConsole._get_with_mechanism(arg_2_0, arg_2_1)
	return arg_2_1[Managers.mechanism:current_mechanism_name()] or arg_2_1.default
end

local var_0_15 = {
	default = "default",
	versus = "menu_versus"
}

function HeroWindowBackgroundConsole._create_viewport_definition(arg_3_0)
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

function HeroWindowBackgroundConsole.create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._viewport_widget then
		UIWidget.destroy(arg_4_0.ui_renderer, arg_4_0._viewport_widget)

		arg_4_0._viewport_widget = nil
	end

	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	local var_4_3 = {}
	local var_4_4 = {}

	for iter_4_2, iter_4_3 in pairs(var_0_6) do
		local var_4_5 = UIWidget.init(iter_4_3)

		var_4_3[#var_4_3 + 1] = var_4_5
		var_4_4[iter_4_2] = var_4_5
	end

	arg_4_0._loading_overlay_widgets = var_4_3
	arg_4_0._loading_overlay_widgets_by_name = var_4_4

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_4)

	if arg_4_2 then
		local var_4_6 = arg_4_0.ui_scenegraph.window.local_position

		var_4_6[1] = var_4_6[1] + arg_4_2[1]
		var_4_6[2] = var_4_6[2] + arg_4_2[2]
		var_4_6[3] = var_4_6[3] + arg_4_2[3]
	end

	if arg_4_0.is_in_inn and not arg_4_0.force_ingame_menu then
		arg_4_0._viewport_widget_definition = arg_4_0:_create_viewport_definition()

		arg_4_0:_setup_object_sets()
	else
		arg_4_0._background_widget = UIWidget.init(var_0_2)
	end

	if not Development.parameter("hero_statistics") then
		var_4_1.detailed.content.visible = false
	end
end

function HeroWindowBackgroundConsole._setup_object_sets(arg_5_0)
	local var_5_0 = arg_5_0._viewport_widget_definition.style.viewport.level_name
	local var_5_1 = LevelResource.object_set_names(var_5_0)

	arg_5_0._object_sets = {}

	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		arg_5_0._object_sets[iter_5_1] = LevelResource.unit_indices_in_object_set(var_5_0, iter_5_1)
	end
end

function HeroWindowBackgroundConsole.on_exit(arg_6_0, arg_6_1)
	print("[HeroViewWindow] Exit Substate HeroWindowBackgroundConsole")

	arg_6_0.ui_animator = nil

	Managers.state.event:unregister("respawn_hero", arg_6_0)
	Managers.state.event:unregister("despawn_hero", arg_6_0)

	if arg_6_0.world_previewer then
		arg_6_0.world_previewer:prepare_exit()
		arg_6_0.world_previewer:on_exit()
		arg_6_0.world_previewer:destroy()
	end

	if arg_6_0._viewport_widget then
		UIWidget.destroy(arg_6_0.ui_renderer, arg_6_0._viewport_widget)

		arg_6_0._viewport_widget = nil
	end
end

function HeroWindowBackgroundConsole.update(arg_7_0, arg_7_1, arg_7_2)
	if var_0_7 then
		var_0_7 = false

		arg_7_0:create_ui_elements()
	end

	if arg_7_0.world_previewer and arg_7_0.hero_unit_spawned then
		local var_7_0 = arg_7_0.parent:window_input_service()

		arg_7_0:_handle_input(var_7_0, arg_7_1, arg_7_2)
		arg_7_0:_update_statistics_widget(var_7_0, arg_7_1)
	end

	arg_7_0:_update_animations(arg_7_1)
	arg_7_0:draw(arg_7_1)

	if arg_7_0.world_previewer then
		local var_7_1 = arg_7_0:_statistics_activate()

		arg_7_0.world_previewer:update(arg_7_1, arg_7_2, var_7_1)
	end
end

function HeroWindowBackgroundConsole._update_character_visibility(arg_8_0, arg_8_1)
	local var_8_0 = var_0_10[arg_8_1] or false
	local var_8_1 = var_0_11[arg_8_1]
	local var_8_2 = var_0_12[arg_8_1]

	if arg_8_0._draw_character ~= var_8_0 then
		arg_8_0.world_previewer:_set_character_visibility(var_8_0, var_8_1, var_8_2)
	end

	arg_8_0._draw_character = var_8_0

	if not var_8_0 and arg_8_0.params.hero_statistics_active then
		arg_8_0:_handle_statistics_pressed()
	end

	if var_8_0 then
		local var_8_3 = var_0_13[arg_8_1] or var_0_13.default

		var_8_3 = var_8_3[arg_8_0.hero_name] or var_8_3

		arg_8_0.world_previewer:set_hero_location_lerped(var_8_3, 0.5)
	end
end

local var_0_16 = {}

function HeroWindowBackgroundConsole._update_level_events(arg_9_0, arg_9_1)
	local var_9_0 = var_0_9[arg_9_1] or var_0_16

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		arg_9_0.world_previewer:trigger_level_event(iter_9_1)
	end
end

function HeroWindowBackgroundConsole._update_object_sets(arg_10_0, arg_10_1)
	local var_10_0 = var_0_8[arg_10_1]

	if var_10_0.keep_current_object_set then
		return
	end

	for iter_10_0, iter_10_1 in pairs(arg_10_0._object_sets) do
		local var_10_1 = var_10_0 and var_10_0[iter_10_0] or false

		arg_10_0.world_previewer:show_level_units(iter_10_1, var_10_1)
	end
end

function HeroWindowBackgroundConsole.post_update(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0._viewport_widget_definition and not arg_11_0._viewport_widget then
		arg_11_0._viewport_widget = UIWidget.init(arg_11_0._viewport_widget_definition)
		arg_11_0._fadeout_loading_overlay = true
	end

	arg_11_0:_update_loading_overlay_fadeout_animation(arg_11_1)

	if not arg_11_0.initialized and arg_11_0._viewport_widget then
		local var_11_0 = MenuWorldPreviewer:new(arg_11_0.ingame_ui_context, var_0_5, "HeroWindowBackgroundConsole")

		local function var_11_1()
			arg_11_0.hero_unit_spawned = true
		end

		arg_11_0.hero_unit_spawned = false

		var_11_0:on_enter(arg_11_0._viewport_widget, arg_11_0.hero_name)
		var_11_0:request_spawn_hero_unit(arg_11_0.hero_name, arg_11_0.career_index, false, var_11_1, nil, arg_11_0._camera_move_duration)

		arg_11_0.world_previewer = var_11_0
		arg_11_0.initialized = true
	end

	if arg_11_0.world_previewer then
		local var_11_2 = arg_11_0.parent:get_layout_name()

		if var_11_2 ~= arg_11_0._current_layout_name then
			arg_11_0:_update_object_sets(var_11_2)
			arg_11_0:_update_level_events(var_11_2)
			arg_11_0:_update_character_visibility(var_11_2)

			arg_11_0._current_layout_name = var_11_2
		end

		if arg_11_0.hero_unit_spawned then
			arg_11_0:_update_skin_sync()
			arg_11_0:_update_loadout_sync()
			arg_11_0:_update_wielded_slot()
			arg_11_0:_update_temporary_loadout_sync()
			arg_11_0:_update_character_pose_animation_sync()
		end

		arg_11_0.world_previewer:post_update(arg_11_1, arg_11_2)
	end
end

local var_0_17 = -1

function HeroWindowBackgroundConsole.respawn_hero(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_1 then
		arg_13_0.hero_name = arg_13_1.hero_name
		arg_13_0.career_index = arg_13_1.career_index
	end

	local var_13_0 = arg_13_0.world_previewer

	if not var_13_0 then
		return
	end

	arg_13_0.hero_unit_spawned = false

	local function var_13_1()
		arg_13_0.hero_unit_spawned = true
		arg_13_0._loadout_sync_id = var_0_17

		arg_13_0:_update_loadout_sync()

		arg_13_0._selected_loadout_slot_index = var_0_17

		arg_13_0:_update_wielded_slot()

		local var_14_0 = FindProfileIndex(arg_13_0.hero_name)
		local var_14_1 = SPProfiles[var_14_0]

		if var_14_1.affiliation == "dark_pact" then
			local var_14_2 = var_14_1.careers[arg_13_0.career_index].preview_idle_animation

			if var_14_2 then
				arg_13_0.world_previewer:play_character_animation(var_14_2)
			end
		end
	end

	var_13_0:respawn_hero_unit(arg_13_0.hero_name, arg_13_0.career_index, false, var_13_1, arg_13_0._camera_move_duration)
end

function HeroWindowBackgroundConsole.despawn_hero(arg_15_0)
	local var_15_0 = arg_15_0.world_previewer

	if not var_15_0 then
		return
	end

	var_15_0:hide_character()
end

function HeroWindowBackgroundConsole._update_animations(arg_16_0, arg_16_1)
	arg_16_0.ui_animator:update(arg_16_1)

	local var_16_0 = arg_16_0._animations
	local var_16_1 = arg_16_0.ui_animator

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		if var_16_1:is_animation_completed(iter_16_1) then
			var_16_1:stop_animation(iter_16_1)

			var_16_0[iter_16_0] = nil
		end
	end

	local var_16_2 = arg_16_0._widgets_by_name
end

function HeroWindowBackgroundConsole._update_temporary_loadout_sync(arg_17_0)
	local var_17_0 = arg_17_0.parent.temporary_loadout_sync_id

	if var_17_0 > 0 and var_17_0 ~= arg_17_0._temporary_loadout_sync_id then
		arg_17_0:_populate_temporary_loadout()

		arg_17_0._temporary_loadout_sync_id = var_17_0
	end
end

function HeroWindowBackgroundConsole._update_character_pose_animation_sync(arg_18_0)
	local var_18_0 = arg_18_0.parent.character_pose_animation_sync_id

	if var_18_0 > 0 and var_18_0 ~= arg_18_0._character_pose_animation_sync_id then
		local var_18_1 = arg_18_0.parent:get_character_animation_event()

		if var_18_1 then
			local var_18_2 = true

			arg_18_0.world_previewer:set_pose_animation(var_18_1, var_18_2)
		else
			arg_18_0.world_previewer:reset_pose_animation()
		end

		arg_18_0._character_pose_animation_sync_id = var_18_0
	end
end

function HeroWindowBackgroundConsole._update_loadout_sync(arg_19_0)
	local var_19_0 = arg_19_0.parent.loadout_sync_id

	if var_19_0 ~= arg_19_0._loadout_sync_id then
		arg_19_0:_populate_loadout()

		arg_19_0._loadout_sync_id = var_19_0

		arg_19_0:_sync_statistics()
	end
end

function HeroWindowBackgroundConsole._update_skin_sync(arg_20_0)
	local var_20_0 = arg_20_0.parent.skin_sync_id

	if var_20_0 ~= arg_20_0.skin_sync_id then
		arg_20_0:respawn_hero()

		arg_20_0.skin_sync_id = var_20_0
	end
end

function HeroWindowBackgroundConsole._update_wielded_slot(arg_21_0)
	local var_21_0 = arg_21_0.parent:get_selected_loadout_slot_index()

	if var_21_0 ~= arg_21_0._selected_loadout_slot_index then
		local var_21_1 = InventorySettings.slots_by_slot_index

		for iter_21_0, iter_21_1 in pairs(var_21_1) do
			if iter_21_1.slot_index == var_21_0 then
				local var_21_2 = iter_21_1.type

				if var_21_2 == "melee" or var_21_2 == "ranged" then
					if arg_21_0.world_previewer:wielded_slot_type() ~= var_21_2 then
						arg_21_0.world_previewer:wield_weapon_slot(var_21_2)
					end

					break
				end
			end
		end

		if not arg_21_0.world_previewer:wielded_slot_type() then
			arg_21_0.world_previewer:wield_weapon_slot("melee")
		end

		arg_21_0._selected_loadout_slot_index = var_21_0
	end
end

function HeroWindowBackgroundConsole._hero_affiliation(arg_22_0)
	local var_22_0 = arg_22_0.hero_name
	local var_22_1 = FindProfileIndex(var_22_0)
	local var_22_2 = SPProfiles[var_22_1]

	return var_22_2 and var_22_2.affiliation
end

function HeroWindowBackgroundConsole._populate_loadout(arg_23_0)
	local var_23_0 = arg_23_0.world_previewer
	local var_23_1 = arg_23_0.hero_name
	local var_23_2 = arg_23_0.career_index
	local var_23_3 = FindProfileIndex(var_23_1)
	local var_23_4 = SPProfiles[var_23_3].careers[var_23_2]
	local var_23_5 = var_23_4.name
	local var_23_6 = arg_23_0:_hero_affiliation()
	local var_23_7 = InventorySettings.slots_per_affiliation[var_23_6]
	local var_23_8 = Managers.backend:get_interface("hero_attributes"):get(var_23_1, "experience") or 0
	local var_23_9 = ExperienceSettings.get_level(var_23_8)
	local var_23_10, var_23_11, var_23_12, var_23_13 = var_23_4:is_unlocked_function(var_23_1, var_23_9)

	if not var_23_10 and var_23_12 then
		local var_23_14 = var_23_4.preview_items
		local var_23_15 = var_23_4.preview_wield_slot
		local var_23_16 = var_23_4.preview_animation

		if var_23_14 then
			for iter_23_0, iter_23_1 in ipairs(var_23_14) do
				local var_23_17 = iter_23_1.item_name
				local var_23_18 = ItemMasterList[var_23_17].slot_type
				local var_23_19 = InventorySettings.slot_names_by_type[var_23_18][1]
				local var_23_20 = InventorySettings.slots_by_name[var_23_19]

				var_23_0:equip_item(var_23_17, var_23_20)
			end

			if var_23_15 then
				var_23_0:wield_weapon_slot(var_23_15)
			end
		end

		local var_23_21 = var_23_4.name
		local var_23_22 = BackendUtils.get_loadout_item(var_23_21, "slot_hat")

		if var_23_22 then
			local var_23_23 = var_23_22.data.name
			local var_23_24 = var_23_22.backend_id
			local var_23_25 = InventorySettings.slots_by_name.slot_hat

			var_23_0:equip_item(var_23_23, var_23_25, var_23_24)
		end

		local var_23_26 = BackendUtils.get_loadout_item(var_23_21, "slot_skin")
		local var_23_27 = var_23_26 and var_23_26.data

		var_23_16 = var_23_27 and var_23_27.career_select_preview_animation or var_23_16

		if var_23_16 then
			arg_23_0.world_previewer:play_character_animation(var_23_16)
		end
	else
		local var_23_28 = false

		for iter_23_2, iter_23_3 in pairs(var_23_7) do
			local var_23_29 = InventorySettings.slots_by_name[iter_23_3]
			local var_23_30 = var_23_29.type
			local var_23_31 = arg_23_0.parent:get_temporary_loadout_item(var_23_30) or BackendUtils.get_loadout_item(var_23_5, iter_23_3)
			local var_23_32

			if var_23_31 then
				local var_23_33 = var_23_31.data.name
				local var_23_34 = var_23_29.type

				if var_23_33 ~= var_23_0:item_name_by_slot_type(var_23_34) or var_23_34 == "melee" or var_23_34 == "ranged" then
					local var_23_35 = var_23_31.backend_id
					local var_23_36 = var_23_0:get_equipped_item_info(var_23_29)

					if not var_23_36 or var_23_36.backend_id ~= var_23_35 then
						var_23_0:equip_item(var_23_33, var_23_29, var_23_35)
					end
				end
			else
				printf("[Cosmetic] Failed to equip slot %q for career %q in hero previewer", iter_23_3, var_23_5)

				var_23_28 = true
			end
		end

		if var_23_28 then
			Crashify.print_exception("[Cosmetic]", "Failed to equip slot for career in hero previewer")
		end
	end
end

function HeroWindowBackgroundConsole._populate_temporary_loadout(arg_24_0)
	local var_24_0 = arg_24_0.world_previewer
	local var_24_1 = InventorySettings.slots_by_slot_index
	local var_24_2 = arg_24_0.parent
	local var_24_3 = false

	for iter_24_0, iter_24_1 in pairs(var_24_1) do
		local var_24_4 = iter_24_1.type
		local var_24_5, var_24_6 = var_24_2:get_temporary_loadout_item(var_24_4)

		if var_24_5 then
			local var_24_7 = var_24_5.data.name
			local var_24_8 = iter_24_1.type

			if var_24_7 ~= var_24_0:item_name_by_slot_type(var_24_8) or var_24_8 == "melee" or var_24_8 == "ranged" then
				local var_24_9 = var_24_5.backend_id
				local var_24_10 = var_24_0:get_equipped_item_info(iter_24_1)
				local var_24_11 = var_24_10.skin_name
				local var_24_12 = var_24_5.skin
				local var_24_13 = var_24_11 ~= var_24_12

				if not var_24_10 or var_24_10.backend_id ~= var_24_9 or var_24_13 then
					var_24_0:equip_item(var_24_7, iter_24_1, var_24_9, var_24_12, var_24_6)

					if not var_24_6 and (var_24_8 == "melee" or var_24_8 == "ranged") then
						var_24_0:wield_weapon_slot(var_24_8)
					end
				elseif not var_24_6 and (var_24_8 == "melee" or var_24_8 == "ranged") then
					var_24_0:wield_weapon_slot(var_24_8)
				end
			end
		end
	end
end

function HeroWindowBackgroundConsole._is_button_pressed(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1.content.button_hotspot

	if var_25_0.on_release then
		var_25_0.on_release = false

		return true
	end
end

function HeroWindowBackgroundConsole._is_stepper_button_pressed(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1.content
	local var_26_1 = var_26_0.button_hotspot_left
	local var_26_2 = var_26_0.button_hotspot_right

	if var_26_1.on_release then
		var_26_1.on_release = false

		return true, -1
	elseif var_26_2.on_release then
		var_26_2.on_release = false

		return true, 1
	end
end

function HeroWindowBackgroundConsole._handle_input(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_0._widgets_by_name.detailed

	if arg_27_0._draw_character then
		-- block empty
	end
end

function HeroWindowBackgroundConsole._exit(arg_28_0, arg_28_1)
	arg_28_0.exit = true
	arg_28_0.exit_level_id = arg_28_1
end

function HeroWindowBackgroundConsole.draw(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0.ui_renderer
	local var_29_1 = arg_29_0.ui_top_renderer
	local var_29_2 = arg_29_0.ui_scenegraph
	local var_29_3 = arg_29_0.parent:window_input_service()

	UIRenderer.begin_pass(var_29_1, var_29_2, var_29_3, arg_29_1, nil, arg_29_0.render_settings)

	for iter_29_0, iter_29_1 in ipairs(arg_29_0._widgets) do
		UIRenderer.draw_widget(var_29_1, iter_29_1)
	end

	if arg_29_0._show_loading_overlay then
		for iter_29_2, iter_29_3 in ipairs(arg_29_0._loading_overlay_widgets) do
			UIRenderer.draw_widget(var_29_1, iter_29_3)
		end
	end

	UIRenderer.end_pass(var_29_1)

	if arg_29_0._viewport_widget then
		UIRenderer.begin_pass(var_29_0, var_29_2, var_29_3, arg_29_1, nil, arg_29_0.render_settings)
		UIRenderer.draw_widget(var_29_0, arg_29_0._viewport_widget)
		UIRenderer.end_pass(var_29_0)
	elseif arg_29_0._background_widget then
		UIRenderer.begin_pass(var_29_0, var_29_2, var_29_3, arg_29_1, nil, arg_29_0.render_settings)
		UIRenderer.draw_widget(var_29_0, arg_29_0._background_widget)
		UIRenderer.end_pass(var_29_0)
	end
end

function HeroWindowBackgroundConsole._play_sound(arg_30_0, arg_30_1)
	arg_30_0.parent:play_sound(arg_30_1)
end

function HeroWindowBackgroundConsole._update_loading_overlay_fadeout_animation(arg_31_0, arg_31_1)
	if not arg_31_0._fadeout_loading_overlay then
		return
	end

	local var_31_0 = arg_31_0._loading_overlay_widgets_by_name
	local var_31_1 = 255
	local var_31_2 = 0
	local var_31_3 = 9
	local var_31_4 = math.min(1, (arg_31_0._fadeout_progress or 0) + var_31_3 * arg_31_1)
	local var_31_5 = math.lerp(var_31_1, var_31_2, math.easeInCubic(var_31_4))
	local var_31_6 = var_31_0.loading_overlay
	local var_31_7 = var_31_0.loading_overlay_loading_glow
	local var_31_8 = var_31_0.loading_overlay_loading_frame

	var_31_6.style.rect.color[1] = var_31_5
	var_31_7.style.texture_id.color[1] = var_31_5
	var_31_8.style.texture_id.color[1] = var_31_5
	arg_31_0._fadeout_progress = var_31_4

	if var_31_4 == 1 then
		arg_31_0._fadeout_loading_overlay = nil
		arg_31_0._fadeout_progress = nil
		arg_31_0._show_loading_overlay = false
	end
end

function HeroWindowBackgroundConsole._handle_statistics_pressed(arg_32_0)
	local var_32_0 = arg_32_0:_statistics_activate()

	arg_32_0.params.hero_statistics_active = not var_32_0

	if var_32_0 then
		arg_32_0:_deactivate_statistics()
	else
		arg_32_0:_activate_statistics()
	end
end

function HeroWindowBackgroundConsole._statistics_activate(arg_33_0)
	return arg_33_0._widgets_by_name.detailed.content.active
end

function HeroWindowBackgroundConsole._activate_statistics(arg_34_0)
	local var_34_0 = arg_34_0._widgets_by_name.detailed

	var_34_0.content.active = true
	var_34_0.content.list_content.active = true

	if var_34_0.content.scrollbar.percentage < 1 then
		var_34_0.content.scrollbar.active = true
	else
		var_34_0.content.scrollbar.active = false
	end

	var_34_0.style.drop_down_arrow.angle = math.pi

	arg_34_0:_sync_statistics()
end

function HeroWindowBackgroundConsole._sync_statistics(arg_35_0)
	if not arg_35_0:_statistics_activate() then
		return
	end

	local var_35_0 = HeroStatisticsTemplate
	local var_35_1 = UIUtils.get_hero_statistics_by_template(var_35_0)

	arg_35_0:_populate_statistics(var_35_1)
end

function HeroWindowBackgroundConsole._deactivate_statistics(arg_36_0)
	local var_36_0 = arg_36_0._widgets_by_name.detailed

	var_36_0.content.active = false
	var_36_0.content.list_content.active = false
	var_36_0.content.scrollbar.active = false
	var_36_0.style.drop_down_arrow.angle = 0
end

function HeroWindowBackgroundConsole._update_statistics_widget(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0._widgets_by_name.detailed

	if not var_37_0.content.active then
		return
	end

	local var_37_1 = arg_37_1:get("gamepad_right_axis")

	if var_37_1 and Vector3.length(var_37_1) > 0.01 then
		local var_37_2 = var_37_0.content.scrollbar.scroll_value

		var_37_0.content.scrollbar.scroll_value = math.clamp(var_37_2 + var_37_1.y * arg_37_2 * 5, 0, 1)
	end

	local var_37_3 = var_0_3.detailed_button.size
	local var_37_4 = var_0_3.detailed_list.size
	local var_37_5 = var_37_0.style.list_style
	local var_37_6 = var_37_5.list_member_offset[2]
	local var_37_7 = var_37_5.num_draws
	local var_37_8

	if var_37_7 == 0 then
		var_37_8 = math.abs(var_37_6)
	else
		var_37_8 = math.abs(var_37_6 * var_37_7)
	end

	local var_37_9 = math.max(var_37_8 - var_37_4[2], 0)
	local var_37_10 = var_37_5.scenegraph_id
	local var_37_11 = arg_37_0.ui_scenegraph[var_37_10].local_position
	local var_37_12 = 1 - var_37_0.content.scrollbar.scroll_value

	var_37_11[2] = -var_37_3[2] + var_37_9 * var_37_12
end

function HeroWindowBackgroundConsole._populate_statistics(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._widgets_by_name.detailed
	local var_38_1 = var_38_0.content
	local var_38_2 = var_38_0.style.list_style
	local var_38_3 = var_38_1.list_content
	local var_38_4 = var_38_2.item_styles
	local var_38_5 = #arg_38_1

	for iter_38_0 = 1, var_38_5 do
		local var_38_6 = arg_38_1[iter_38_0]
		local var_38_7 = ""
		local var_38_8 = ""
		local var_38_9 = ""
		local var_38_10 = var_38_6.type

		if var_38_10 == "title" then
			var_38_7 = var_38_6.display_name
		elseif var_38_10 == "entry" then
			var_38_8 = var_38_6.display_name
			var_38_9 = var_38_6.value
		end

		local var_38_11 = var_38_3[iter_38_0]

		var_38_11.name = UIRenderer.crop_text_width(arg_38_0.ui_renderer, var_38_8, 300, var_38_4[iter_38_0].name)
		var_38_11.title = UIRenderer.crop_text_width(arg_38_0.ui_renderer, var_38_7, 300, var_38_4[iter_38_0].title)
		var_38_11.value = var_38_9
	end

	var_38_2.num_draws = var_38_5

	arg_38_0:_setup_tab_scrollbar(var_38_0)
end

function HeroWindowBackgroundConsole._setup_tab_scrollbar(arg_39_0, arg_39_1)
	local var_39_0 = var_0_3.detailed_button.size
	local var_39_1 = var_0_3.detailed_list.size
	local var_39_2 = arg_39_1.style.list_style
	local var_39_3 = var_39_2.list_member_offset[2]
	local var_39_4 = var_39_2.num_draws
	local var_39_5

	if var_39_4 == 0 then
		var_39_5 = math.abs(var_39_3)
	else
		var_39_5 = math.abs(var_39_3 * var_39_4)
	end

	local var_39_6 = math.min(var_39_1[2] / var_39_5, 1)
	local var_39_7 = arg_39_1.content.scrollbar

	if var_39_6 < 1 then
		var_39_7.percentage = var_39_6
		var_39_7.scroll_value = 1

		local var_39_8 = 2

		var_39_7.scroll_amount = var_39_3 / (var_39_5 - var_39_1[2]) * var_39_8
	else
		var_39_7.percentage = 1
		var_39_7.scroll_value = 1
	end
end
