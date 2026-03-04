-- chunkname: @scripts/ui/views/character_selection_view/states/character_selection_state_versus_loadouts.lua

local var_0_0 = local_require("scripts/ui/views/character_selection_view/states/definitions/character_selection_state_versus_loadouts_definitions")
local var_0_1 = var_0_0.widget_definitions
local var_0_2 = var_0_0.loadout_widgets_definitions
local var_0_3 = var_0_0.loadout_selection_widget_definitions
local var_0_4 = var_0_0.scenegraph_definition
local var_0_5 = var_0_0.animation_definitions
local var_0_6 = var_0_0.hero_icon_widget
local var_0_7 = var_0_0.hero_widget
local var_0_8 = var_0_0.info_window_widgets_definitions
local var_0_9 = var_0_0.weapon_slots
local var_0_10 = var_0_0.tag_scenegraph_id
local var_0_11 = var_0_0.tag_widget_func
local var_0_12 = var_0_0.loadout_button_widget_definitions
local var_0_13 = var_0_0.console_cursor_definition
local var_0_14 = var_0_0.generic_input_actions
local var_0_15 = {}

CharacterSelectionStateVersusLoadouts = class(CharacterSelectionStateVersusLoadouts, CharacterSelectionStateCharacter)
CharacterSelectionStateVersusLoadouts.NAME = "CharacterSelectionStateVersusLoadouts"

local var_0_16 = {
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

function CharacterSelectionStateVersusLoadouts.on_enter(arg_1_0, arg_1_1)
	print("[HeroViewState] Enter Substate CharacterSelectionStateVersusLoadouts")

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._parent = arg_1_1.parent
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._is_in_inn = var_1_0.is_in_inn
	arg_1_0._force_ingame_menu = arg_1_1.force_ingame_menu
	arg_1_0._world = var_1_0.world
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._profile_synchronizer = var_1_0.profile_synchronizer
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._local_player_id = var_1_0.local_player_id
	arg_1_0._profile_requester = (var_1_0.network_server or var_1_0.network_client):profile_requester()
	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0.local_player = Managers.player:local_player()
	arg_1_0._stats_id = arg_1_0.local_player:stats_id()
	arg_1_0.use_user_skins = true
	arg_1_0.use_loadout_items = true

	local var_1_1, var_1_2 = arg_1_0._profile_synchronizer:profile_by_peer(arg_1_0.peer_id, arg_1_0._local_player_id)
	local var_1_3 = arg_1_1.hero_name

	arg_1_0._career_index = var_1_2
	arg_1_0._profile_index = var_1_1
	arg_1_0._hero_name = var_1_3

	local var_1_4 = SPProfiles[arg_1_0._profile_index].careers[arg_1_0._career_index].name

	arg_1_0._career_name = var_1_4
	arg_1_0._render_settings = {
		snap_pixel_positions = false
	}
	arg_1_0._loadout_selection_render_settings = {
		snap_pixel_positions = false
	}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_store_selected_loadout_index(var_1_4)
	arg_1_0:_create_ui_elements(arg_1_1)
	arg_1_0:_setup_rarity_indices()
	arg_1_0:_start_animation("on_enter")

	if var_1_1 and var_1_2 then
		local var_1_5 = true

		arg_1_0:_select_hero(arg_1_0._profile_index, arg_1_0._career_index, true, nil, var_1_5)
		arg_1_0:_disable_unused_careers()
	end

	arg_1_0.parent:set_input_blocked(false)
	Managers.input:enable_gamepad_cursor()

	local var_1_6 = UILayer.default + 130
	local var_1_7 = arg_1_0._parent:input_service(true)

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(var_1_0, arg_1_0.ui_top_renderer, var_1_7, 6, var_1_6, var_0_14.default, true)

	arg_1_0._menu_input_description:set_input_description(nil)
end

function CharacterSelectionStateVersusLoadouts._disable_unused_careers(arg_2_0)
	for iter_2_0, iter_2_1 in ipairs(arg_2_0._hero_widgets) do
		local var_2_0 = iter_2_1.content

		var_2_0.locked = iter_2_0 ~= arg_2_0._selected_career_index
		var_2_0.button_hotspot.disable_button = iter_2_0 ~= arg_2_0._selected_career_index
	end
end

function CharacterSelectionStateVersusLoadouts.on_exit(arg_3_0, arg_3_1)
	arg_3_0.super.on_exit(arg_3_0, arg_3_1)

	if not arg_3_0._new_loadout_confirmed then
		local var_3_0 = SPProfiles[arg_3_0._profile_index].careers[arg_3_0._career_index].name
		local var_3_1 = arg_3_0._stored_selected_loadout_index
		local var_3_2 = InventorySettings.loadouts[var_3_1].loadout_type
		local var_3_3 = arg_3_0._loadout_button_widgets[var_3_1].content.loadout
		local var_3_4 = true

		arg_3_0:_set_loadout(var_3_3, var_3_2, var_3_1, var_3_0, var_3_4)
		arg_3_0:_save_loadout_index(var_3_0, var_3_1)
	end
end

function CharacterSelectionStateVersusLoadouts._store_selected_loadout_index(arg_4_0, arg_4_1)
	local var_4_0 = Managers.mechanism:current_mechanism_name()
	local var_4_1 = PlayerData.loadout_selection and PlayerData.loadout_selection[var_4_0]
	local var_4_2 = var_4_1 and var_4_1[arg_4_1] or 1
	local var_4_3 = var_4_2 and InventorySettings.loadouts[var_4_2]

	if var_4_3 and var_4_3.loadout_type == "default" then
		arg_4_0._stored_selected_loadout_index = var_4_3.loadout_index
	else
		local var_4_4 = Managers.backend:get_interface("items"):get_selected_career_loadout(arg_4_1)

		for iter_4_0, iter_4_1 in ipairs(InventorySettings.loadouts) do
			if iter_4_1.loadout_type == "custom" and iter_4_1.loadout_index == var_4_4 then
				arg_4_0._stored_selected_loadout_index = iter_4_0

				return
			end
		end
	end

	fassert(arg_4_0._stored_selected_loadout_index, "[CharacterSelectionStateVersusLoadouts] Couldn't find any stored loadout index")
end

function CharacterSelectionStateVersusLoadouts._setup_rarity_indices(arg_5_0)
	arg_5_0._rarity_indices = {}

	for iter_5_0, iter_5_1 in pairs(RaritySettings) do
		arg_5_0._rarity_indices[iter_5_0] = iter_5_1.order
	end
end

function CharacterSelectionStateVersusLoadouts._create_ui_elements(arg_6_0)
	arg_6_0:_inject_additional_scenegraph_definitions(var_0_4)

	arg_6_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_4)
	arg_6_0._ui_animator = UIAnimator:new(arg_6_0._ui_scenegraph, var_0_5)

	local var_6_0 = {}
	local var_6_1 = {}

	for iter_6_0, iter_6_1 in pairs(var_0_1) do
		local var_6_2 = UIWidget.init(iter_6_1)

		var_6_1[iter_6_0] = var_6_2
		var_6_0[#var_6_0 + 1] = var_6_2
	end

	arg_6_0._widgets = var_6_0

	local var_6_3 = {}

	for iter_6_2, iter_6_3 in pairs(var_0_2) do
		local var_6_4 = UIWidget.init(iter_6_3)

		var_6_1[iter_6_2] = var_6_4
		var_6_3[#var_6_3 + 1] = var_6_4
	end

	arg_6_0._loadout_widgets = var_6_3

	local var_6_5 = {}

	for iter_6_4, iter_6_5 in pairs(var_0_3) do
		local var_6_6 = UIWidget.init(iter_6_5)

		var_6_1[iter_6_4] = var_6_6
		var_6_5[#var_6_5 + 1] = var_6_6
	end

	arg_6_0._loadout_selection_widgets = var_6_5

	local var_6_7 = {}

	for iter_6_6, iter_6_7 in pairs(var_0_8) do
		local var_6_8 = UIWidget.init(iter_6_7)

		var_6_1[iter_6_6] = var_6_8
		var_6_7[#var_6_7 + 1] = var_6_8
	end

	arg_6_0._info_window_widgets = var_6_7

	local var_6_9 = {}

	for iter_6_8, iter_6_9 in ipairs(var_0_12) do
		local var_6_10 = UIWidget.init(iter_6_9)

		var_6_1["loadout_button_" .. iter_6_8] = var_6_10
		var_6_9[#var_6_9 + 1] = var_6_10
	end

	arg_6_0._loadout_button_widgets = var_6_9
	arg_6_0._widgets_by_name = var_6_1
	arg_6_0._console_cursor = UIWidget.init(var_0_13)
	arg_6_0._additional_widgets = {}
	arg_6_0._additional_widgets_by_name = {}

	UIRenderer.clear_scenegraph_queue(arg_6_0.ui_top_renderer)

	for iter_6_10, iter_6_11 in ipairs(InventorySettings.loadouts) do
		if iter_6_11.loadout_type == "custom" then
			arg_6_0._default_loadout_index = iter_6_10

			break
		end
	end

	fassert(arg_6_0._default_loadout_index, "[CharacterSelectionStateVersusLoadouts] There is no custom loadout slots in InventorySettings.loadouts")
	arg_6_0:_setup_item_grid()
	arg_6_0:_populate_hero_info()
	arg_6_0:_populate_career_info()
	arg_6_0:_populate_loadout()
	arg_6_0:_populate_loadout_buttons()
	arg_6_0:_setup_hero_widgets()
	arg_6_0:_populate_tags()
end

function CharacterSelectionStateVersusLoadouts._setup_item_grid(arg_7_0)
	arg_7_0:_setup_item_grid_categories()

	local var_7_0 = ItemGridUI:new(arg_7_0._categories, arg_7_0._widgets_by_name.item_grid, arg_7_0._hero_name, arg_7_0._career_index)

	var_7_0:mark_equipped_items(true)
	var_7_0:mark_locked_items(true)
	var_7_0:disable_locked_items(true)
	var_7_0:disable_unwieldable_items(true)
	var_7_0:disable_item_drag()
	var_7_0:change_category("slot_ranged")

	arg_7_0._item_grid = var_7_0
end

function CharacterSelectionStateVersusLoadouts._setup_item_grid_categories(arg_8_0)
	local var_8_0 = arg_8_0._career_index
	local var_8_1 = arg_8_0._profile_index
	local var_8_2 = SPProfiles[var_8_1].careers[var_8_0].item_slot_types_by_slot_name
	local var_8_3 = {
		slot_melee = var_8_2.slot_melee,
		slot_ranged = var_8_2.slot_ranged
	}

	arg_8_0._categories = {}

	for iter_8_0, iter_8_1 in pairs(var_8_3) do
		local var_8_4 = InventorySettings.slots_by_name[iter_8_0].ui_slot_index

		if var_8_4 then
			local var_8_5 = "( "

			for iter_8_2, iter_8_3 in ipairs(iter_8_1) do
				var_8_5 = var_8_5 .. "slot_type == " .. iter_8_3

				if iter_8_2 < #iter_8_1 then
					var_8_5 = var_8_5 .. " or "
				else
					var_8_5 = var_8_5 .. " ) and item_rarity ~= magic and can_wield_by_current_career"
				end
			end

			local var_8_6 = {
				hero_specific_filter = true,
				name = iter_8_0,
				item_types = iter_8_1,
				slot_index = var_8_4,
				slot_name = iter_8_0,
				item_filter = var_8_5
			}

			arg_8_0._categories[var_8_4] = var_8_6
		end
	end
end

function CharacterSelectionStateVersusLoadouts._setup_hero_widgets(arg_9_0)
	local var_9_0 = {}
	local var_9_1 = {}

	arg_9_0._hero_widgets = var_9_0
	arg_9_0._hero_icon_widgets = var_9_1

	local var_9_2 = SPProfiles[arg_9_0._profile_index]
	local var_9_3 = var_9_2.careers[arg_9_0._career_index]
	local var_9_4 = var_9_2.display_name
	local var_9_5 = Managers.backend:get_interface("dlcs")
	local var_9_6 = Managers.backend:get_interface("hero_attributes"):get(var_9_4, "experience") or 0
	local var_9_7 = ExperienceSettings.get_level(var_9_6)
	local var_9_8 = var_9_2.careers
	local var_9_9 = UIWidget.init(var_0_6)

	var_9_1[#var_9_1 + 1] = var_9_9

	local var_9_10 = "hero_icon_large_" .. var_9_4

	var_9_9.content.icon = var_9_10
	var_9_9.content.icon_selected = var_9_10 .. "_glow"
	var_9_9.content.selected = true

	for iter_9_0 = 1, 4 do
		local var_9_11 = var_9_8[iter_9_0]

		if var_9_11 and not var_9_5:is_unreleased_career(var_9_11.name) then
			local var_9_12 = UIWidget.init(var_0_7)

			var_9_0[#var_9_0 + 1] = var_9_12

			local var_9_13 = var_9_12.offset
			local var_9_14 = var_9_12.content

			var_9_14.career_settings = var_9_11

			local var_9_15 = var_9_11.portrait_image

			var_9_14.portrait = "medium_" .. var_9_15

			local var_9_16, var_9_17, var_9_18, var_9_19 = var_9_11:is_unlocked_function(var_9_4, var_9_7)

			var_9_14.locked = not var_9_16
			var_9_14.locked_reason = not var_9_16 and (var_9_19 and var_9_17 or Localize(var_9_17))
			var_9_14.dlc_name = var_9_18

			if var_9_17 == "dlc_not_owned" then
				var_9_14.lock_texture = var_9_14.lock_texture .. "_gold"
				var_9_14.frame = var_9_14.frame .. "_gold"
			end

			var_9_14.locked = not var_9_16
			var_9_14.button_hotspot.is_selected = arg_9_0._career_index == iter_9_0
			var_9_13[1] = (iter_9_0 - 1) * 124
		else
			local var_9_20 = (iter_9_0 - 1) * 124

			var_9_9.style.bg.offset[1] = var_9_9.style.bg.offset[1] + var_9_20
			var_9_9.style.hourglass_icon.offset[1] = var_9_9.style.hourglass_icon.offset[1] + var_9_20
			var_9_9.content.use_empty_icon = true
		end
	end
end

function CharacterSelectionStateVersusLoadouts._populate_hero_info(arg_10_0)
	local var_10_0 = SPProfiles[arg_10_0._profile_index]
	local var_10_1 = var_10_0.careers[arg_10_0._career_index]
	local var_10_2 = var_10_0.display_name
	local var_10_3 = var_10_0.character_name
	local var_10_4 = var_10_1.display_name
	local var_10_5 = Localize(var_10_3)
	local var_10_6 = Localize(var_10_4)
	local var_10_7 = Managers.backend:get_interface("hero_attributes"):get(var_10_2, "experience") or 0
	local var_10_8 = ExperienceSettings.get_level(var_10_7)

	arg_10_0._widgets_by_name.info_hero_name.content.text = var_10_5
	arg_10_0._widgets_by_name.info_career_name.content.text = var_10_6
	arg_10_0._widgets_by_name.info_hero_level.content.text = var_10_8
end

function CharacterSelectionStateVersusLoadouts._start_animation(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = {
		render_settings = arg_11_2 or arg_11_0._render_settings,
		ui_scenegraph = arg_11_0._ui_scenegraph
	}
	local var_11_1 = arg_11_0._widgets_by_name
	local var_11_2 = arg_11_0._ui_animator:start_animation(arg_11_1, var_11_1, var_0_4, var_11_0)

	arg_11_0._animations[arg_11_1] = var_11_2
end

function CharacterSelectionStateVersusLoadouts._update_animations(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._ui_animations
	local var_12_1 = arg_12_0._animations
	local var_12_2 = arg_12_0._ui_animator

	for iter_12_0, iter_12_1 in pairs(arg_12_0._ui_animations) do
		UIAnimation.update(iter_12_1, arg_12_1)

		if UIAnimation.completed(iter_12_1) then
			arg_12_0._ui_animations[iter_12_0] = nil
		end
	end

	var_12_2:update(arg_12_1)

	for iter_12_2, iter_12_3 in pairs(var_12_1) do
		if var_12_2:is_animation_completed(iter_12_3) then
			var_12_2:stop_animation(iter_12_3)

			var_12_1[iter_12_2] = nil
		end
	end

	for iter_12_4, iter_12_5 in ipairs(arg_12_0._loadout_button_widgets) do
		UIWidgetUtils.animate_default_button(iter_12_5, arg_12_1)
	end

	local var_12_3 = arg_12_0._widgets_by_name.confirm_button

	UIWidgetUtils.animate_default_button(var_12_3, arg_12_1)

	if arg_12_0._loadout_selection_active then
		local var_12_4 = arg_12_0._widgets_by_name.back_button

		arg_12_0:_animate_back_button(var_12_4, arg_12_1)
	end
end

function CharacterSelectionStateVersusLoadouts._animate_back_button(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_1.content
	local var_13_1 = arg_13_1.style
	local var_13_2 = var_13_0.button_hotspot
	local var_13_3 = var_13_2.is_hover
	local var_13_4 = var_13_2.is_selected
	local var_13_5 = not var_13_4 and var_13_2.is_clicked and var_13_2.is_clicked == 0
	local var_13_6 = var_13_2.input_progress or 0
	local var_13_7 = var_13_2.hover_progress or 0
	local var_13_8 = var_13_2.selection_progress or 0
	local var_13_9 = 8
	local var_13_10 = 20

	if var_13_5 then
		var_13_6 = math.min(var_13_6 + arg_13_2 * var_13_10, 1)
	else
		var_13_6 = math.max(var_13_6 - arg_13_2 * var_13_10, 0)
	end

	local var_13_11 = math.easeOutCubic(var_13_6)
	local var_13_12 = math.easeInCubic(var_13_6)

	if var_13_3 then
		var_13_7 = math.min(var_13_7 + arg_13_2 * var_13_9, 1)
	else
		var_13_7 = math.max(var_13_7 - arg_13_2 * var_13_9, 0)
	end

	local var_13_13 = math.easeOutCubic(var_13_7)
	local var_13_14 = math.easeInCubic(var_13_7)

	if var_13_4 then
		var_13_8 = math.min(var_13_8 + arg_13_2 * var_13_9, 1)
	else
		var_13_8 = math.max(var_13_8 - arg_13_2 * var_13_9, 0)
	end

	local var_13_15 = math.easeOutCubic(var_13_8)
	local var_13_16 = math.easeInCubic(var_13_8)
	local var_13_17 = math.max(var_13_7, var_13_8)
	local var_13_18 = math.max(var_13_15, var_13_13)
	local var_13_19 = math.max(var_13_14, var_13_16)
	local var_13_20 = 255 * var_13_17

	var_13_1.texture_id.color[1] = 255 - var_13_20
	var_13_1.texture_hover_id.color[1] = var_13_20
	var_13_1.selected_texture.color[1] = var_13_20
	var_13_2.hover_progress = var_13_7
	var_13_2.input_progress = var_13_6
	var_13_2.selection_progress = var_13_8
end

function CharacterSelectionStateVersusLoadouts.post_update(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0:_update_animations(arg_14_1, arg_14_2)
	arg_14_0:_handle_spawn(arg_14_1, arg_14_2)
end

function CharacterSelectionStateVersusLoadouts._handle_spawn(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0.parent:transitioning() and not arg_15_0._transition_timer then
		if arg_15_0._prepare_exit then
			arg_15_0._prepare_exit = false

			arg_15_0.world_previewer:prepare_exit()
		elseif arg_15_0._spawn_hero then
			arg_15_0._spawn_hero = nil

			local var_15_0 = arg_15_0._selected_hero_name or arg_15_0._hero_name

			arg_15_0:_spawn_hero_unit(var_15_0)
		end
	end

	local var_15_1 = Managers.state.network.profile_synchronizer
	local var_15_2 = Managers.player:local_player()
	local var_15_3 = var_15_2:network_id()
	local var_15_4 = var_15_2:local_player_id()

	if arg_15_0._despawning_player_unit_career_change and not Unit.alive(arg_15_0._despawning_player_unit_career_change) and var_15_1:all_ingame_synced_for_peer(var_15_3, var_15_4) then
		local var_15_5 = arg_15_0._respawn_position:unbox()
		local var_15_6 = arg_15_0._respawn_rotation:unbox()

		var_15_2:spawn(var_15_5, var_15_6)

		arg_15_0._despawning_player_unit_career_change = nil
		arg_15_0._resyncing_loadout = nil

		arg_15_0.parent:close_menu()
	end
end

function CharacterSelectionStateVersusLoadouts._close_menu(arg_16_0)
	local var_16_0 = arg_16_0._parent:get_exit_button_widget()
	local var_16_1 = false or arg_16_0._items_dirty

	var_16_1 = var_16_1 or arg_16_0._talents_dirty

	if var_16_1 or arg_16_0._loadout_selection_changed then
		if arg_16_0._loadout_selection_active then
			arg_16_0:_enable_loadout_selection(false)
		end

		arg_16_0:_confirm_loadout()

		var_16_0.content.button_hotspot.on_release = nil
	else
		arg_16_0.parent:close_menu()
	end
end

function CharacterSelectionStateVersusLoadouts.update(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:_handle_input(arg_17_1, arg_17_2)
	arg_17_0:_update_profile_request()
	arg_17_0:_update_video_player_settings()
	arg_17_0:_draw(arg_17_1, arg_17_2)

	return arg_17_0:_handle_transitions()
end

function CharacterSelectionStateVersusLoadouts._handle_input(arg_18_0, arg_18_1, arg_18_2)
	if arg_18_0._prepare_exit then
		return
	end

	local var_18_0 = arg_18_0:input_service()
	local var_18_1 = Managers.input:is_device_active("gamepad")

	arg_18_0:_handle_keyboard_selection(var_18_0)
	arg_18_0:_handle_mouse_selection(var_18_0)
	arg_18_0:_handle_gamepad_selection(var_18_0)
end

function CharacterSelectionStateVersusLoadouts._handle_keyboard_selection(arg_19_0, arg_19_1)
	if not Managers.input:is_device_active("keyboard") then
		return
	end

	if arg_19_1:get("move_up") then
		local var_19_0 = arg_19_0._selected_loadout_index
		local var_19_1 = math.max(var_19_0 - 1, 1)

		if var_19_1 ~= var_19_0 and arg_19_0._loadout_button_widgets[var_19_1].content.visible then
			arg_19_0:_change_loadout(var_19_1)
		end
	elseif arg_19_1:get("move_down") then
		local var_19_2 = arg_19_0._selected_loadout_index
		local var_19_3 = math.min(var_19_2 + 1, #arg_19_0._loadout_button_widgets)

		if var_19_3 ~= var_19_2 and arg_19_0._loadout_button_widgets[var_19_3].content.visible then
			arg_19_0:_change_loadout(var_19_3)
		end
	elseif arg_19_1:get("confirm") then
		arg_19_0:_confirm_loadout()
	elseif arg_19_1:get("toggle_menu", true) or arg_19_1:get("back", true) then
		if arg_19_0._loadout_selection_active then
			arg_19_0:_enable_loadout_selection(false)
		else
			arg_19_0:_close_menu()
		end
	end
end

function CharacterSelectionStateVersusLoadouts._handle_gamepad_selection(arg_20_0, arg_20_1)
	if not Managers.input:is_device_active("gamepad") then
		return
	end

	if arg_20_1:get("toggle_menu", true) or arg_20_1:get("back", true) then
		if arg_20_0._loadout_selection_active then
			arg_20_0:_enable_loadout_selection(false)
		else
			arg_20_0:_close_menu()
		end

		return
	end

	if arg_20_1:get("move_up_raw") then
		local var_20_0 = arg_20_0._selected_loadout_index
		local var_20_1 = math.max(var_20_0 - 1, 1)

		if var_20_1 ~= var_20_0 and arg_20_0._loadout_button_widgets[var_20_1].content.visible then
			if arg_20_0._loadout_selection_active then
				arg_20_0:_enable_loadout_selection(false)
			end

			arg_20_0:_change_loadout(var_20_1)
		end
	elseif arg_20_1:get("move_down_raw") then
		local var_20_2 = arg_20_0._selected_loadout_index
		local var_20_3 = math.min(var_20_2 + 1, #arg_20_0._loadout_button_widgets)

		if var_20_3 ~= var_20_2 and arg_20_0._loadout_button_widgets[var_20_3].content.visible then
			if arg_20_0._loadout_selection_active then
				arg_20_0:_enable_loadout_selection(false)
			end

			arg_20_0:_change_loadout(var_20_3)
		end
	elseif arg_20_1:get("refresh") then
		arg_20_0:_confirm_loadout()
	elseif arg_20_1:get("back", true) then
		arg_20_0:_close_menu()
	end
end

function CharacterSelectionStateVersusLoadouts._enable_loadout_selection(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = {
		loadout_weapons = {
			"item_grid",
			"back_button"
		},
		loadout_talents = {
			"talent_grid",
			"back_button"
		}
	}

	for iter_21_0, iter_21_1 in pairs(arg_21_0._loadout_selection_widgets) do
		iter_21_1.content.visible = false
	end

	if arg_21_1 then
		local var_21_1 = var_21_0[arg_21_2]

		for iter_21_2, iter_21_3 in ipairs(var_21_1) do
			arg_21_0._widgets_by_name[iter_21_3].content.visible = true
		end

		arg_21_0:_start_animation("open_equipment_inventory", arg_21_0._loadout_selection_render_settings)
	elseif arg_21_0._loadout_selection_active then
		arg_21_0._loadout_selection_changed = arg_21_0._loadout_selection_changed or arg_21_0._items_dirty or arg_21_0._talents_dirty

		arg_21_0:_update_talents()
		arg_21_0:_update_items()
		arg_21_0:_start_animation("show_loadout", arg_21_0._loadout_selection_render_settings)

		arg_21_0._current_weapon_slot_name = nil
	end

	arg_21_0._loadout_selection_active = arg_21_1
end

function CharacterSelectionStateVersusLoadouts._update_items(arg_22_0)
	if not arg_22_0._items_dirty then
		return
	end

	arg_22_0:_populate_loadout(arg_22_0._selected_profile_index, arg_22_0._selected_career_index, arg_22_0._selected_loadout, arg_22_0._selected_loadout_talents, arg_22_0._selected_loadout_settings)

	arg_22_0._items_dirty = false
end

function CharacterSelectionStateVersusLoadouts._update_talents(arg_23_0)
	if not arg_23_0._talents_dirty then
		return
	end

	local var_23_0, var_23_1 = arg_23_0._profile_synchronizer:profile_by_peer(arg_23_0.peer_id, arg_23_0._local_player_id)
	local var_23_2 = SPProfiles[arg_23_0._selected_profile_index].careers[arg_23_0._selected_career_index].name

	Managers.backend:get_interface("talents"):set_talents(var_23_2, arg_23_0._selected_loadout_talents)

	local var_23_3 = arg_23_0.local_player.player_unit

	if Unit.alive(var_23_3) then
		ScriptUnit.extension(var_23_3, "talent_system"):talents_changed()
		ScriptUnit.extension(var_23_3, "inventory_system"):apply_buffs_to_ammo()
	end

	arg_23_0:_populate_loadout(arg_23_0._selected_profile_index, arg_23_0._selected_career_index, arg_23_0._selected_loadout, arg_23_0._selected_loadout_talents, arg_23_0._selected_loadout_settings)

	arg_23_0._talents_dirty = false
end

function CharacterSelectionStateVersusLoadouts._handle_mouse_selection(arg_24_0, arg_24_1)
	if Managers.input:is_device_active("keyboard") then
		return
	end

	if arg_24_1:get("toggle_menu", true) or arg_24_1:get("back", true) then
		if arg_24_0._loadout_selection_active then
			arg_24_0:_enable_loadout_selection(false)
		else
			arg_24_0:_close_menu()
		end

		return
	end

	for iter_24_0, iter_24_1 in ipairs(arg_24_0._loadout_button_widgets) do
		if UIUtils.is_button_pressed(iter_24_1) then
			arg_24_0:_enable_loadout_selection(false)
			arg_24_0:_change_loadout(iter_24_0)

			break
		end
	end

	local var_24_0 = InventorySettings.loadouts[arg_24_0._selected_loadout_index]

	if arg_24_0._loadout_selection_active then
		local var_24_1 = arg_24_0._widgets_by_name.back_button

		if UIUtils.is_button_pressed(var_24_1) then
			arg_24_0:_enable_loadout_selection(false)
		end

		arg_24_0:_handle_talent_loadout_selection(arg_24_1)
		arg_24_0:_handle_item_loadout_selection(arg_24_1)
	else
		if var_24_0.loadout_type == "custom" then
			local var_24_2 = arg_24_0._widgets_by_name.loadout_weapons

			for iter_24_2, iter_24_3 in ipairs(var_0_9) do
				if UIUtils.is_button_pressed(var_24_2, iter_24_3) then
					arg_24_0._item_grid:change_category(iter_24_3)
					arg_24_0:_enable_loadout_selection(true, "loadout_weapons")

					arg_24_0._current_weapon_slot_name = iter_24_3

					break
				end
			end
		end

		if var_24_0.loadout_type == "custom" then
			local var_24_3 = arg_24_0._widgets_by_name.loadout_talents

			for iter_24_4 = 1, MaxTalentPoints do
				local var_24_4 = "talent_" .. iter_24_4

				if UIUtils.is_button_pressed(var_24_3, var_24_4) then
					arg_24_0:_populate_talent_grid()
					arg_24_0:_enable_loadout_selection(true, "loadout_talents")

					break
				end
			end
		end
	end

	local var_24_5 = arg_24_0._widgets_by_name.confirm_button

	if UIUtils.is_button_pressed(var_24_5) then
		arg_24_0:_confirm_loadout()
	end

	local var_24_6 = arg_24_0._parent:get_exit_button_widget()

	if UIUtils.is_left_button_released(var_24_6) then
		arg_24_0:_close_menu()
	end
end

function CharacterSelectionStateVersusLoadouts._handle_item_loadout_selection(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._widgets_by_name.item_grid
	local var_25_1 = arg_25_0._item_grid
	local var_25_2 = false
	local var_25_3, var_25_4 = var_25_1:is_item_pressed(var_25_2)

	if var_25_1:is_item_hovered() then
		arg_25_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_25_3 and not var_25_4 then
		local var_25_5 = Managers.player:player_from_peer_id(arg_25_0.peer_id).player_unit

		if not var_25_5 or not Unit.alive(var_25_5) then
			return
		end

		arg_25_0:_play_sound("play_gui_equipment_equip_hero")
		arg_25_0:_set_loadout_item(var_25_3, arg_25_0._current_weapon_slot_name)
		var_25_1:update_items_status()

		local var_25_6 = arg_25_0._selected_career_index
		local var_25_7 = FindProfileIndex(arg_25_0._hero_name)
		local var_25_8 = SPProfiles[var_25_7].careers[var_25_6].preview_wield_slot or "melee"

		arg_25_0._spawn_hero = InventorySettings.slot_names_by_type[var_25_8][1] == arg_25_0._current_weapon_slot_name
		arg_25_0._items_dirty = true
	end
end

function CharacterSelectionStateVersusLoadouts._set_loadout_item(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = Managers.player:player_from_peer_id(arg_26_0.peer_id).player_unit

	if not var_26_0 or not Unit.alive(var_26_0) then
		return
	end

	if not Managers.state.network:game() then
		return
	end

	if LoadoutUtils.is_item_disabled(arg_26_1.ItemId) then
		return
	end

	local var_26_1 = arg_26_1.data
	local var_26_2
	local var_26_3

	if arg_26_2 then
		var_26_2 = InventorySettings.slots_by_name[arg_26_2]

		local var_26_4 = var_26_2.type
	else
		local var_26_5 = var_26_1.slot_type

		var_26_2 = arg_26_0:_get_slot_by_type(var_26_5)
	end

	local var_26_6 = arg_26_1.backend_id
	local var_26_7 = var_26_2.name
	local var_26_8 = arg_26_0._selected_profile_index or arg_26_0._profile_index
	local var_26_9 = arg_26_0._selected_career_index or arg_26_0._career_index
	local var_26_10 = SPProfiles[var_26_8].careers[var_26_9].name

	BackendUtils.set_loadout_item(var_26_6, var_26_10, var_26_7)

	arg_26_0._selected_loadout[var_26_7] = var_26_6

	Managers.state.event:trigger("event_set_loadout_items")
end

function CharacterSelectionStateVersusLoadouts._get_slot_by_type(arg_27_0, arg_27_1)
	local var_27_0 = InventorySettings.slots_by_slot_index

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		if arg_27_1 == iter_27_1.type then
			return iter_27_1
		end
	end
end

function CharacterSelectionStateVersusLoadouts._handle_talent_loadout_selection(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._widgets_by_name.talent_grid
	local var_28_1 = var_28_0.content

	for iter_28_0 = 1, NumTalentRows do
		for iter_28_1 = 1, NumTalentColumns do
			local var_28_2 = "talent_" .. iter_28_0 .. "_" .. iter_28_1

			if UIUtils.is_button_hover_enter(var_28_0, var_28_2) then
				arg_28_0:_play_sound("play_gui_inventory_item_hover")
			end

			if not var_28_0.content[var_28_2].disabled then
				if UIUtils.is_button_pressed(var_28_0, var_28_2) then
					if arg_28_0._selected_loadout_talents[iter_28_0] ~= iter_28_1 then
						arg_28_0:_play_sound("play_gui_talents_selection_click")
					end

					arg_28_0._selected_loadout_talents[iter_28_0] = iter_28_1

					arg_28_0:_populate_talent_grid()

					arg_28_0._talents_dirty = true
				elseif UIUtils.is_right_button_pressed(var_28_0, var_28_2) then
					if arg_28_0._selected_loadout_talents[iter_28_0] ~= 0 then
						arg_28_0:_play_sound("play_gui_talents_selection_click")
					end

					arg_28_0._selected_loadout_talents[iter_28_0] = arg_28_0._selected_loadout_talents[iter_28_0] == iter_28_1 and 0 or arg_28_0._selected_loadout_talents[iter_28_0]

					arg_28_0:_populate_talent_grid()

					arg_28_0._talents_dirty = true
				end
			end
		end
	end
end

function CharacterSelectionStateVersusLoadouts._confirm_loadout(arg_29_0)
	arg_29_0:_play_sound("play_gui_start_menu_button_click")

	if arg_29_0._loadout_selection_active then
		arg_29_0:_enable_loadout_selection(false)
	end

	local var_29_0, var_29_1 = arg_29_0._profile_synchronizer:profile_by_peer(arg_29_0.peer_id, arg_29_0._local_player_id)
	local var_29_2 = SPProfiles[arg_29_0._selected_profile_index].careers[arg_29_0._selected_career_index].name
	local var_29_3 = CareerSettings[var_29_2]
	local var_29_4 = arg_29_0:_set_loadout(arg_29_0._selected_loadout, arg_29_0._selected_loadout_type, arg_29_0._selected_loadout_index, var_29_2) or arg_29_0._loadout_selection_changed

	if var_29_0 ~= arg_29_0._selected_profile_index or var_29_1 ~= arg_29_0._selected_career_index or var_29_4 then
		local var_29_5 = var_29_3.required_dlc

		if var_29_5 and Managers.unlock:dlc_requires_restart(var_29_5) then
			arg_29_0._parent:close_menu()

			return
		end

		arg_29_0._close_on_successful_profile_request = true

		arg_29_0:_change_profile(arg_29_0._selected_profile_index, arg_29_0._selected_career_index)
		arg_29_0._parent:set_input_blocked(true)

		arg_29_0._new_loadout_confirmed = true

		if arg_29_0._selected_loadout_index and InventorySettings.loadouts[arg_29_0._selected_loadout_index].loadout_type == "default" then
			Managers.telemetry_events:default_loadout_equipped()
		end
	else
		arg_29_0._parent:close_menu()
	end
end

function CharacterSelectionStateVersusLoadouts._populate_talent_grid(arg_30_0)
	local var_30_0 = arg_30_0._hero_name
	local var_30_1 = arg_30_0._career_index
	local var_30_2 = FindProfileIndex(var_30_0)
	local var_30_3 = SPProfiles[var_30_2].careers[var_30_1]
	local var_30_4 = (var_30_1 - 1) * NumTalentRows
	local var_30_5 = TalentTrees[var_30_0][var_30_3.talent_tree_index]
	local var_30_6 = arg_30_0._selected_loadout_talents
	local var_30_7 = PlayerUtils.get_talent_overrides_by_career(var_30_3.display_name) or var_0_15
	local var_30_8 = arg_30_0._widgets_by_name.talent_grid
	local var_30_9 = var_30_8.content
	local var_30_10 = var_30_8.style

	for iter_30_0 = 1, NumTalentRows do
		local var_30_11 = var_30_6[iter_30_0]
		local var_30_12 = "talent_row_" .. iter_30_0

		var_30_9[var_30_12 .. "_name"] = " "

		for iter_30_1 = 1, NumTalentColumns do
			local var_30_13 = "talent_" .. iter_30_0 .. "_" .. iter_30_1
			local var_30_14 = var_30_5[iter_30_0][iter_30_1]
			local var_30_15 = var_30_7[var_30_14] == false
			local var_30_16 = TalentIDLookup[var_30_14].talent_id
			local var_30_17 = TalentUtils.get_talent_by_id(var_30_0, var_30_16)
			local var_30_18 = iter_30_1 == var_30_11
			local var_30_19 = var_30_9[var_30_13]
			local var_30_20 = var_30_10[var_30_13]

			var_30_19.icon = var_30_17.icon
			var_30_19.talent = var_30_17
			var_30_19.is_selected = var_30_18
			var_30_19.disabled = var_30_15
			var_30_20.saturated = not var_30_18 or var_30_15
			var_30_20.color = var_30_15 and {
				255,
				60,
				60,
				60
			} or var_30_20.color
			var_30_9[var_30_12 .. "_name"] = var_30_18 and Localize(var_30_14) or var_30_9[var_30_12 .. "_name"]
		end
	end
end

function CharacterSelectionStateVersusLoadouts._set_loadout(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	if not arg_31_1 or not arg_31_2 or not arg_31_3 then
		return false
	end

	local var_31_0 = Managers.mechanism:current_mechanism_name()
	local var_31_1 = PlayerData.loadout_selection and PlayerData.loadout_selection[var_31_0]
	local var_31_2 = var_31_1 and var_31_1[arg_31_4] or arg_31_0._stored_selected_loadout_index

	if not arg_31_5 and arg_31_3 == var_31_2 then
		return var_31_2 ~= arg_31_0._stored_selected_loadout_index
	end

	local var_31_3 = Managers.player:player_from_peer_id(arg_31_0.peer_id).player_unit

	if not var_31_3 or not Unit.alive(var_31_3) then
		return false
	end

	if not Managers.state.network:game() then
		return false
	end

	local var_31_4 = InventorySettings.loadouts[arg_31_3]

	if not arg_31_5 then
		arg_31_0:_save_loadout_index(arg_31_4, arg_31_3)
	end

	local var_31_5 = Managers.backend:get_interface("talents")
	local var_31_6 = Managers.backend:get_interface("items")

	if arg_31_2 == "default" then
		var_31_6:set_default_override(arg_31_4, var_31_4.loadout_index)
	else
		var_31_6:set_loadout_index(arg_31_4, var_31_4.loadout_index)

		for iter_31_0, iter_31_1 in pairs(arg_31_1) do
			if var_0_16[iter_31_0] then
				if CosmeticUtils.is_cosmetic_slot(iter_31_0) then
					iter_31_1 = var_31_6:get_backend_id_from_cosmetic_item(iter_31_1)
				elseif iter_31_0 == "slot_pose" then
					local var_31_7 = arg_31_1[iter_31_0]

					iter_31_1 = var_31_7 and var_31_6:get_backend_id_from_unlocked_weapon_poses(var_31_7)
				end

				local var_31_8 = iter_31_1 and var_31_6:get_item_from_id(iter_31_1)

				if var_31_8 and not LoadoutUtils.is_item_disabled(var_31_8.ItemId) then
					local var_31_9 = InventorySettings.slots_by_name[iter_31_0].type
					local var_31_10 = arg_31_0._statistics_db:get_persistent_stat(arg_31_0._stats_id, "highest_equipped_rarity", var_31_9)
					local var_31_11 = arg_31_0._rarity_indices[var_31_8.rarity]

					if var_31_11 and var_31_10 < var_31_11 then
						arg_31_0._statistics_db:set_stat(arg_31_0._stats_id, "highest_equipped_rarity", var_31_9, var_31_11)
					end
				end
			end
		end
	end

	var_31_6:make_dirty()
	var_31_5:make_dirty()
	Managers.state.event:trigger("event_set_loadout_items")

	return var_31_2 ~= arg_31_0._stored_selected_loadout_index
end

function CharacterSelectionStateVersusLoadouts._save_loadout_index(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = Managers.state.game_mode:game_mode_key()

	if not InventorySettings.save_local_loadout_selection[var_32_0] then
		return
	end

	local var_32_1 = Managers.mechanism:current_mechanism_name()

	PlayerData.loadout_selection = PlayerData.loadout_selection or {}
	PlayerData.loadout_selection[var_32_1] = PlayerData.loadout_selection[var_32_1] or {}
	PlayerData.loadout_selection[var_32_1][arg_32_1] = arg_32_2

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

function CharacterSelectionStateVersusLoadouts._change_loadout(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._widgets_by_name.loadout_frame
	local var_33_1 = arg_33_0._widgets_by_name.selected_loadout_header
	local var_33_2 = arg_33_0._widgets_by_name.selected_loadout_desc
	local var_33_3 = arg_33_0._widgets_by_name.selected_loadout_icon

	if not arg_33_0._loadout_button_widgets[arg_33_1] then
		arg_33_1 = arg_33_0._default_loadout_index
	end

	local var_33_4 = arg_33_0._selected_profile_index or arg_33_0._profile_index
	local var_33_5 = arg_33_0._selected_career_index or arg_33_0._career_index
	local var_33_6 = SPProfiles[var_33_4].careers[var_33_5].name
	local var_33_7
	local var_33_8
	local var_33_9
	local var_33_10 = InventorySettings.loadouts[arg_33_1]

	if var_33_10.loadout_type == "default" then
		var_33_7 = var_33_6 .. "_default_loadout_" .. var_33_10.loadout_index .. "_title"
		var_33_8 = var_33_6 .. "_default_loadout_" .. var_33_10.loadout_index .. "_desc"
		var_33_9 = UISettings.default_loadout_settings[var_33_6][var_33_10.loadout_index].icon
	else
		var_33_7 = "custom_loadout_" .. var_33_10.loadout_index .. "_title"
		var_33_8 = "custom_loadout_desc"
		var_33_9 = var_33_10.loadout_icon or "icons_placeholder"
	end

	var_33_1.content.text = Localize(var_33_7)
	var_33_2.content.text = Localize(var_33_8)
	var_33_3.content.texture_id = var_33_9

	local var_33_11 = arg_33_0._loadout_button_widgets[arg_33_1]

	var_33_0.offset = var_33_11.offset

	local var_33_12 = var_33_11.content
	local var_33_13 = var_33_12.loadout
	local var_33_14 = var_33_12.talents

	arg_33_0._selected_loadout = var_33_13
	arg_33_0._selected_loadout_talents = var_33_14
	arg_33_0._selected_loadout_type = var_33_12.loadout_type
	arg_33_0._selected_loadout_index = var_33_12.loadout_index
	arg_33_0._selected_loadout_settings = var_33_10

	arg_33_0:_populate_tags()
	arg_33_0:_populate_loadout(arg_33_0._selected_profile_index, arg_33_0._selected_career_index, var_33_13, var_33_14, var_33_10)
	arg_33_0:_set_loadout(arg_33_0._selected_loadout, arg_33_0._selected_loadout_type, arg_33_0._selected_loadout_index, var_33_6, arg_33_2)

	arg_33_0._spawn_hero = true

	arg_33_0:_play_sound("Play_gui_loadout_select")
end

function CharacterSelectionStateVersusLoadouts._draw(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._ui_scenegraph
	local var_34_1 = arg_34_0.ui_top_renderer
	local var_34_2 = arg_34_0._render_settings
	local var_34_3 = arg_34_0:input_service()
	local var_34_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_34_1, var_34_0, var_34_3, arg_34_1, nil, var_34_2)

	for iter_34_0, iter_34_1 in ipairs(arg_34_0._widgets) do
		UIRenderer.draw_widget(var_34_1, iter_34_1)
	end

	if not arg_34_0._loadout_selection_active then
		for iter_34_2, iter_34_3 in ipairs(arg_34_0._loadout_widgets) do
			UIRenderer.draw_widget(var_34_1, iter_34_3)
		end
	end

	if arg_34_0._loadout_selection_active then
		local var_34_5 = var_34_2.alpha_multiplier

		var_34_2.alpha_multiplier = arg_34_0._loadout_selection_render_settings.alpha_multiplier

		for iter_34_4, iter_34_5 in ipairs(arg_34_0._loadout_selection_widgets) do
			UIRenderer.draw_widget(var_34_1, iter_34_5)
		end

		var_34_2.alpha_multiplier = var_34_5
	end

	for iter_34_6, iter_34_7 in ipairs(arg_34_0._hero_widgets) do
		UIRenderer.draw_widget(var_34_1, iter_34_7)
	end

	for iter_34_8, iter_34_9 in ipairs(arg_34_0._hero_icon_widgets) do
		UIRenderer.draw_widget(var_34_1, iter_34_9)
	end

	for iter_34_10, iter_34_11 in ipairs(arg_34_0._info_window_widgets) do
		UIRenderer.draw_widget(var_34_1, iter_34_11)
	end

	for iter_34_12, iter_34_13 in ipairs(arg_34_0._tag_widgets) do
		UIRenderer.draw_widget(var_34_1, iter_34_13)
	end

	for iter_34_14, iter_34_15 in ipairs(arg_34_0._additional_widgets) do
		UIRenderer.draw_widget(var_34_1, iter_34_15)
	end

	for iter_34_16, iter_34_17 in ipairs(arg_34_0._loadout_button_widgets) do
		UIRenderer.draw_widget(var_34_1, iter_34_17)
	end

	if var_34_4 then
		UIRenderer.draw_widget(var_34_1, arg_34_0._console_cursor)
	end

	arg_34_0:_draw_video(var_34_1, arg_34_1, arg_34_2)
	UIRenderer.end_pass(var_34_1)

	if var_34_4 then
		arg_34_0._menu_input_description:draw(var_34_1, arg_34_1)
	end

	if arg_34_0._scrollbar then
		var_34_2.alpha_multiplier = var_34_2.main_alpha_multiplier

		arg_34_0._scrollbar:update(arg_34_1, arg_34_2, var_34_1, var_34_3, var_34_2)
	end
end

function CharacterSelectionStateVersusLoadouts._populate_loadout_buttons(arg_35_0)
	local var_35_0 = arg_35_0._selected_profile_index or arg_35_0._profile_index
	local var_35_1 = arg_35_0._selected_career_index or arg_35_0._career_index
	local var_35_2 = SPProfiles[var_35_0].careers[var_35_1].name
	local var_35_3 = CareerSettings[var_35_2]
	local var_35_4 = Managers.backend:get_interface("items")
	local var_35_5 = Managers.backend:get_interface("talents")
	local var_35_6 = var_35_4:get_career_loadouts(var_35_2)
	local var_35_7 = var_35_4:get_default_loadouts(var_35_2)
	local var_35_8 = var_35_5:get_career_talents(var_35_2)
	local var_35_9 = var_35_5:get_default_talents(var_35_2)
	local var_35_10 = UISettings.default_loadout_settings[var_35_2]

	for iter_35_0 = 1, #arg_35_0._loadout_button_widgets do
		local var_35_11 = arg_35_0._loadout_button_widgets[iter_35_0].content
		local var_35_12 = InventorySettings.loadouts[iter_35_0]
		local var_35_13 = var_35_12.loadout_type
		local var_35_14 = var_35_12.loadout_index

		var_35_11.loadout_type = var_35_13

		if var_35_13 == "default" then
			local var_35_15 = var_35_10[var_35_14]
			local var_35_16 = var_35_7[var_35_14]
			local var_35_17 = var_35_9[var_35_14]

			var_35_11.loadout = var_35_16
			var_35_11.loadout_index = iter_35_0
			var_35_11.talents = var_35_17
			var_35_11.visible = var_35_16 ~= nil
			var_35_11.background.texture_id = var_35_15.icon
		elseif var_35_13 == "custom" then
			local var_35_18 = var_35_6[var_35_14] and table.clone(var_35_6[var_35_14])
			local var_35_19 = var_35_8[var_35_14] and table.clone(var_35_8[var_35_14])

			var_35_11.loadout_index = iter_35_0
			var_35_11.loadout = var_35_18
			var_35_11.talents = var_35_19
			var_35_11.visible = var_35_18 ~= nil
			var_35_11.background.texture_id = var_35_12.loadout_icon or "icons_placeholder"
		end
	end
end

function CharacterSelectionStateVersusLoadouts._populate_tags(arg_36_0)
	local var_36_0 = arg_36_0._selected_profile_index or arg_36_0._profile_index
	local var_36_1 = arg_36_0._selected_career_index or arg_36_0._career_index
	local var_36_2 = SPProfiles[var_36_0].careers[var_36_1].name
	local var_36_3 = arg_36_0._selected_loadout_index or arg_36_0._default_loadout_index
	local var_36_4 = InventorySettings.loadouts[var_36_3]
	local var_36_5 = {}

	if var_36_4.loadout_type == "default" then
		local var_36_6 = UISettings.default_loadout_settings[var_36_2][var_36_4.loadout_index]

		var_36_5 = string.split_deprecated(var_36_6.tags, ",")
	else
		var_36_5[#var_36_5 + 1] = "loadout_tag_custom"
	end

	local var_36_7 = {}
	local var_36_8 = #var_36_5
	local var_36_9 = 0
	local var_36_10 = 10

	local function var_36_11(arg_37_0, arg_37_1)
		return Localize(arg_37_0) < Localize(arg_37_1)
	end

	table.sort(var_36_5, var_36_11)

	for iter_36_0 = 1, var_36_8 do
		local var_36_12 = var_36_5[iter_36_0]
		local var_36_13 = var_0_11(var_0_10, Localize(var_36_12), {
			nil,
			30
		})
		local var_36_14 = UIWidget.init(var_36_13)

		var_36_9 = var_36_9 + var_36_14.content.size[1] * 0.5
		var_36_14.offset[1] = var_36_9
		var_36_7[#var_36_7 + 1] = var_36_14
		var_36_9 = var_36_9 + var_36_14.content.size[1] * 0.5 + var_36_10
	end

	arg_36_0._tag_widgets = var_36_7
end

function CharacterSelectionStateVersusLoadouts._populate_loadout(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	local var_38_0 = arg_38_0._selected_profile_index or arg_38_0._profile_index
	local var_38_1 = arg_38_0._selected_career_index or arg_38_0._career_index
	local var_38_2 = SPProfiles[var_38_0]
	local var_38_3 = var_38_2.careers[var_38_1]
	local var_38_4 = var_38_2.display_name
	local var_38_5 = var_38_3.name
	local var_38_6 = arg_38_5 or InventorySettings.loadouts[arg_38_0._stored_selected_loadout_index]
	local var_38_7 = var_0_15
	local var_38_8 = var_0_15
	local var_38_9 = Managers.backend:get_interface("talents")

	if arg_38_4 then
		var_38_7 = arg_38_4
		var_38_8 = var_38_9:get_talent_ids(var_38_5, var_38_7)
	else
		var_38_8 = var_38_9:get_talent_ids(var_38_5)
		var_38_7 = var_38_9:get_talents(var_38_5)
	end

	local var_38_10 = arg_38_0._widgets_by_name.loadout_talents.content
	local var_38_11 = 1

	for iter_38_0 = 1, MaxTalentPoints do
		local var_38_12 = var_38_10["talent_" .. iter_38_0]

		if var_38_7[iter_38_0] ~= 0 then
			local var_38_13 = var_38_8[var_38_11]
			local var_38_14 = TalentUtils.get_talent_by_id(var_38_4, var_38_13)
			local var_38_15 = var_38_14 and var_38_14.icon

			if not var_38_15 then
				var_38_14 = nil
			end

			var_38_12.icon = var_38_15
			var_38_12.talent = var_38_14
			var_38_11 = var_38_11 + 1
		else
			var_38_12.talent = nil
		end
	end

	var_38_10.locked = var_38_6 and var_38_6.loadout_type == "default"

	local var_38_16 = Managers.backend:get_interface("items")
	local var_38_17 = arg_38_0._widgets_by_name.loadout_weapons.content

	for iter_38_1, iter_38_2 in ipairs(var_0_9) do
		local var_38_18

		if arg_38_3 then
			local var_38_19 = arg_38_3[iter_38_2]

			var_38_18 = var_38_16:get_item_from_id(var_38_19)
		else
			var_38_18 = BackendUtils.get_loadout_item(var_38_5, iter_38_2)
		end

		var_38_17[iter_38_2].item = var_38_18
		var_38_17[iter_38_2].icon = var_38_18.data.inventory_icon
		var_38_17[iter_38_2].locked = var_38_6 and var_38_6.loadout_type == "default"
	end

	arg_38_0._widgets_by_name.weapons_header.content.default_loadout = var_38_6 and var_38_6.loadout_type == "default"
	arg_38_0._widgets_by_name.talents_header.content.default_loadout = var_38_6 and var_38_6.loadout_type == "default"
end

function CharacterSelectionStateVersusLoadouts._populate_career_info(arg_39_0)
	local var_39_0 = arg_39_0._selected_profile_index or arg_39_0._profile_index
	local var_39_1 = arg_39_0._selected_career_index or arg_39_0._career_index
	local var_39_2 = arg_39_0._ui_scenegraph
	local var_39_3 = arg_39_0.ui_top_renderer
	local var_39_4 = arg_39_0._widgets_by_name
	local var_39_5 = SPProfiles[var_39_0]
	local var_39_6 = var_39_5.display_name
	local var_39_7 = var_39_5.careers[var_39_1]
	local var_39_8 = var_39_7.name
	local var_39_9 = CareerUtils.get_passive_ability_by_career(var_39_7)
	local var_39_10 = CareerUtils.get_ability_data_by_career(var_39_7, 1)
	local var_39_11 = var_39_9.display_name
	local var_39_12 = var_39_9.icon
	local var_39_13 = var_39_10.display_name
	local var_39_14 = var_39_10.icon

	var_39_4.passive_title_text.content.text = Localize(var_39_11)
	var_39_4.passive_description_text.content.text = UIUtils.get_ability_description(var_39_9)
	var_39_4.passive_icon.content.texture_id = var_39_12
	var_39_4.active_title_text.content.text = Localize(var_39_13)
	var_39_4.active_description_text.content.text = UIUtils.get_ability_description(var_39_10)
	var_39_4.active_icon.content.texture_id = var_39_14

	local var_39_15 = var_39_9.perks
	local var_39_16 = 0
	local var_39_17 = 0

	for iter_39_0 = 1, 3 do
		local var_39_18 = var_39_4["career_perk_" .. iter_39_0]
		local var_39_19 = var_39_18.content
		local var_39_20 = var_39_18.style
		local var_39_21 = var_39_2[var_39_18.scenegraph_id].size

		var_39_18.offset[2] = -var_39_16

		local var_39_22 = var_39_15[iter_39_0]

		if var_39_22 then
			local var_39_23 = Localize(var_39_22.display_name)
			local var_39_24 = UIUtils.get_perk_description(var_39_22)
			local var_39_25 = var_39_20.title_text
			local var_39_26 = var_39_20.description_text
			local var_39_27 = var_39_20.description_text_shadow

			var_39_19.title_text = var_39_23
			var_39_19.description_text = var_39_24

			local var_39_28 = UIUtils.get_text_height(var_39_3, var_39_21, var_39_25, var_39_23)
			local var_39_29 = UIUtils.get_text_height(var_39_3, var_39_21, var_39_26, var_39_24)

			var_39_26.offset[2] = -var_39_29
			var_39_27.offset[2] = -(var_39_29 + 2)
			var_39_16 = var_39_16 + var_39_28 + var_39_29 + var_39_17
		end

		var_39_19.visible = var_39_22 ~= nil
	end

	local var_39_30 = 240
	local var_39_31 = math.max(var_39_16 - var_39_30, 0)

	arg_39_0:_setup_additional_career_info(var_39_7, var_39_31)

	local var_39_32 = var_39_7.video
	local var_39_33 = var_39_32.material_name
	local var_39_34 = var_39_32.resource

	arg_39_0._current_video_settings = {
		video = var_39_32,
		material_name = var_39_33,
		resource = var_39_34
	}

	arg_39_0:_destroy_video_player()
end

function CharacterSelectionStateVersusLoadouts._draw_video(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if not arg_40_0._draw_video_next_frame then
		if arg_40_0._video_widget and not arg_40_0._prepare_exit then
			if not arg_40_0._video_created then
				UIRenderer.draw_widget(arg_40_1, arg_40_0._video_widget)
			else
				arg_40_0._video_created = nil
			end
		end
	elseif arg_40_0._draw_video_next_frame then
		arg_40_0._draw_video_next_frame = nil
	end
end

function CharacterSelectionStateVersusLoadouts._select_hero(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5)
	local var_41_0 = SPProfiles[arg_41_1]
	local var_41_1 = var_41_0.careers[arg_41_2]
	local var_41_2 = var_41_0.display_name
	local var_41_3 = var_41_0.character_name
	local var_41_4 = var_41_1.display_name
	local var_41_5 = var_41_1.required_dlc

	if var_41_5 and not Managers.unlock:is_dlc_unlocked(var_41_5) then
		return
	end

	local var_41_6 = Managers.backend:get_interface("hero_attributes"):get(var_41_2, "experience") or 0
	local var_41_7 = ExperienceSettings.get_level(var_41_6)
	local var_41_8, var_41_9, var_41_10, var_41_11 = var_41_1:is_unlocked_function(var_41_2, var_41_7)
	local var_41_12 = arg_41_0._widgets_by_name.locked_info_text.content

	var_41_12.text = not var_41_8 and var_41_9 or ""
	var_41_12.visible = not var_41_8

	if not arg_41_3 then
		arg_41_0:_play_sound("play_gui_hero_select_career_click")
	end

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_41_4 == "bw_necromancer")

	arg_41_0._spawn_hero = true

	if arg_41_4 then
		arg_41_0._spawn_hero = false
	end

	arg_41_0._selected_career_index = arg_41_2
	arg_41_0._selected_profile_index = arg_41_1
	arg_41_0._selected_hero_name = var_41_2

	arg_41_0:_populate_career_info()
	arg_41_0:_populate_loadout()
	arg_41_0:_populate_tags()
	arg_41_0:_populate_loadout_buttons()

	for iter_41_0, iter_41_1 in ipairs(arg_41_0._hero_widgets) do
		iter_41_1.content.button_hotspot.is_selected = iter_41_0 == arg_41_0._selected_career_index
	end

	local var_41_13 = Managers.mechanism:current_mechanism_name()
	local var_41_14 = PlayerData.loadout_selection and PlayerData.loadout_selection[var_41_13]
	local var_41_15 = var_41_14 and var_41_14[var_41_4] or arg_41_0._stored_selected_loadout_index

	arg_41_0:_change_loadout(var_41_15, arg_41_5)
end

function CharacterSelectionStateVersusLoadouts._spawn_hero_unit(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.world_previewer
	local var_42_1 = arg_42_0._selected_career_index
	local var_42_2 = callback(arg_42_0, "cb_hero_unit_spawned", arg_42_1)
	local var_42_3 = false

	var_42_0:request_spawn_hero_unit(arg_42_1, var_42_1, var_42_3, var_42_2, nil, 0.5)
end
