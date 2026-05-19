-- chunkname: @scripts/ui/hud_ui/unit_frame_ui.lua

local var_0_0 = 10

UnitFrameUI = class(UnitFrameUI)

function UnitFrameUI.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0.definitions = arg_1_2
	arg_1_0.features_list = arg_1_2.features_list
	arg_1_0.widget_name_by_feature = arg_1_2.widget_name_by_feature
	arg_1_0.inventory_consumable_icons = arg_1_2.inventory_consumable_icons
	arg_1_0.inventory_index_by_slot = arg_1_2.inventory_index_by_slot
	arg_1_0.weapon_slot_widget_settings = arg_1_2.weapon_slot_widget_settings
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.peer_id = arg_1_1.peer_id
	arg_1_0.player_manager = arg_1_1.player_manager
	arg_1_0.ui_animations = {}
	arg_1_0._damage_events = {}
	arg_1_0._dmg_part_pool = {}
	arg_1_0._hash_order = {}
	arg_1_0._hash_widget_lookup = {}
	arg_1_0.world = arg_1_1.world_manager:world("level_world")
	arg_1_0._show_respawn_ui = false
	arg_1_0.data = arg_1_3
	arg_1_0._frame_type = arg_1_6

	arg_1_0:_create_ui_elements(arg_1_4)

	arg_1_0._ammo_ui_data = {}
	arg_1_0.weapon_changed = false

	if arg_1_5.is_player_darkpact then
		Managers.state.event:register(arg_1_0, "enter_ghostmode", "on_enter_ghostmode")
	end
end

function UnitFrameUI.on_enter_ghostmode(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:show_main_healthbar(not arg_2_1)
end

function UnitFrameUI._create_ui_elements(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.definitions
	local var_3_1 = arg_3_0.definitions.scenegraph_definition

	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_3_1)

	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0.widget_definitions) do
		var_3_2[iter_3_0] = UIWidget.init(iter_3_1)
	end

	arg_3_0._widgets = var_3_2
	arg_3_0._default_widgets = {
		default_dynamic = var_3_2.default_dynamic,
		default_static = var_3_2.default_static
	}
	arg_3_0._damage_widgets = {}

	if arg_3_0.features_list.damage then
		for iter_3_2, iter_3_3 in pairs(var_3_0.damage_widget_definitions) do
			arg_3_0._damage_widgets[#arg_3_0._damage_widgets + 1] = UIWidget.init(iter_3_3)
		end
	end

	arg_3_0._portrait_widgets = {
		portrait_static = var_3_2.portrait_static,
		versus_insignia_static = var_3_2.versus_insignia_static
	}
	arg_3_0._equipment_widgets = {
		loadout_dynamic = var_3_2.loadout_dynamic,
		loadout_static = var_3_2.loadout_static
	}
	arg_3_0._health_widgets = {
		health_dynamic = var_3_2.health_dynamic
	}
	arg_3_0._ability_widgets = {
		ability_dynamic = var_3_2.ability_dynamic
	}
	arg_3_0._respawn_widgets = {
		respawn_dynamic = var_3_2.respawn_dynamic
	}

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.slot_equip_animations = {}
	arg_3_0.bar_animations = {}

	arg_3_0:reset()

	if arg_3_1 then
		arg_3_0:_widget_by_name("health_dynamic").content.hp_bar.texture_id = "teammate_hp_bar_color_tint_" .. arg_3_1
		arg_3_0:_widget_by_name("health_dynamic").content.total_health_bar.texture_id = "teammate_hp_bar_" .. arg_3_1
	end

	arg_3_0:set_visible(false)
	arg_3_0:set_dirty()
end

function UnitFrameUI._widget_by_name(arg_4_0, arg_4_1)
	return arg_4_0._widgets[arg_4_1]
end

function UnitFrameUI._widget_by_feature(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.widget_name_by_feature[arg_5_2][arg_5_1]

	return arg_5_0:_widget_by_name(var_5_0)
end

function UnitFrameUI.set_position(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.ui_scenegraph.pivot.local_position

	var_6_0[1] = arg_6_1
	var_6_0[2] = arg_6_2

	local var_6_1 = arg_6_0.ui_scenegraph.insignia_pivot.local_position

	var_6_1[1] = arg_6_1
	var_6_1[2] = arg_6_2

	for iter_6_0, iter_6_1 in pairs(arg_6_0._widgets) do
		arg_6_0:_set_widget_dirty(iter_6_1)
	end

	arg_6_0:set_dirty()
end

function UnitFrameUI.destroy(arg_7_0)
	arg_7_0:set_visible(false)
	Managers.state.event:unregister("enter_ghostmode", arg_7_0)
end

function UnitFrameUI.is_visible(arg_8_0)
	return arg_8_0._is_visible
end

function UnitFrameUI.set_visible(arg_9_0, arg_9_1)
	arg_9_0._is_visible = arg_9_1

	local var_9_0 = arg_9_0.ui_renderer

	for iter_9_0, iter_9_1 in pairs(arg_9_0._widgets) do
		UIRenderer.set_element_visible(var_9_0, iter_9_1.element, arg_9_1)
	end

	arg_9_0:set_dirty()
end

function UnitFrameUI.set_alpha(arg_10_0, arg_10_1)
	arg_10_0.render_settings.alpha_multiplier = arg_10_1

	for iter_10_0, iter_10_1 in pairs(arg_10_0._widgets) do
		arg_10_0:_set_widget_dirty(iter_10_1)
	end

	arg_10_0:set_dirty()
end

function UnitFrameUI.set_default_alpha(arg_11_0, arg_11_1)
	arg_11_0._default_alpha_multiplier = arg_11_1

	for iter_11_0, iter_11_1 in pairs(arg_11_0._default_widgets) do
		arg_11_0:_set_widget_dirty(iter_11_1)
	end

	arg_11_0:set_dirty()
end

function UnitFrameUI.set_portrait_alpha(arg_12_0, arg_12_1)
	arg_12_0._portrait_alpha_multiplier = arg_12_1

	for iter_12_0, iter_12_1 in pairs(arg_12_0._portrait_widgets) do
		arg_12_0:_set_widget_dirty(iter_12_1)
	end

	arg_12_0:set_dirty()
end

function UnitFrameUI.set_damage_alpha(arg_13_0, arg_13_1)
	arg_13_0._damage_alpha_multiplier = arg_13_1

	for iter_13_0, iter_13_1 in pairs(arg_13_0._damage_widgets) do
		arg_13_0:_set_widget_dirty(iter_13_1)
	end

	arg_13_0:set_dirty()
end

function UnitFrameUI.set_equipment_alpha(arg_14_0, arg_14_1)
	arg_14_0._equipment_alpha_multiplier = arg_14_1

	for iter_14_0, iter_14_1 in pairs(arg_14_0._equipment_widgets) do
		arg_14_0:_set_widget_dirty(iter_14_1)
	end

	arg_14_0:set_dirty()
end

function UnitFrameUI.set_health_alpha(arg_15_0, arg_15_1)
	arg_15_0._health_alpha_multiplier = arg_15_1

	for iter_15_0, iter_15_1 in pairs(arg_15_0._health_widgets) do
		arg_15_0:_set_widget_dirty(iter_15_1)
	end

	arg_15_0:set_dirty()
end

function UnitFrameUI.set_ability_alpha(arg_16_0, arg_16_1)
	arg_16_0._ability_alpha_multiplier = arg_16_1

	for iter_16_0, iter_16_1 in pairs(arg_16_0._ability_widgets) do
		arg_16_0:_set_widget_dirty(iter_16_1)
	end

	arg_16_0:set_dirty()
end

function UnitFrameUI.set_respawn_alpha(arg_17_0, arg_17_1)
	arg_17_0._respawn_alpha_multiplier = arg_17_1

	for iter_17_0, iter_17_1 in pairs(arg_17_0._respawn_widgets) do
		arg_17_0:_set_widget_dirty(iter_17_1)
	end

	arg_17_0:set_dirty()
end

function UnitFrameUI.show_main_healthbar(arg_18_0, arg_18_1)
	arg_18_0._widgets.health_dynamic.content.visible = arg_18_1
	arg_18_0._widgets.default_static.content.show_health_bar = arg_18_1

	arg_18_0:set_dirty()
end

function UnitFrameUI.update(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.features_list
	local var_19_1 = var_19_0.equipment
	local var_19_2 = var_19_0.weapons
	local var_19_3 = var_19_0.damage
	local var_19_4 = false
	local var_19_5 = arg_19_0.data
	local var_19_6 = var_19_5.is_dead
	local var_19_7 = var_19_5.is_talking
	local var_19_8 = var_19_5.is_knocked_down
	local var_19_9 = var_19_5.assisted_respawn
	local var_19_10 = var_19_5.needs_help

	arg_19_0.overlay_time = (arg_19_0.overlay_time or 0) + arg_19_1 * 1.4

	if arg_19_0:_update_portrait_opacity(var_19_6, var_19_8, var_19_10, var_19_9) then
		var_19_4 = true
	end

	if arg_19_0:_update_voice_animation(arg_19_1, arg_19_2, var_19_7) then
		var_19_4 = true
	end

	if arg_19_0:_update_bar_animations(arg_19_1, arg_19_2) then
		var_19_4 = true
	end

	if arg_19_0:_update_health_bar_animation(arg_19_1, arg_19_2) then
		var_19_4 = true
	end

	if arg_19_0:_update_total_health_bar_animation(arg_19_1, arg_19_2) then
		var_19_4 = true
	end

	if var_19_2 and arg_19_0:_update_overcharge_animation(arg_19_1, arg_19_2) then
		var_19_4 = true
	end

	if var_19_1 and arg_19_0:_update_slot_equip_animations(arg_19_1, arg_19_2) then
		var_19_4 = true
	end

	if arg_19_0:_update_connection_animation(arg_19_1, arg_19_2) then
		var_19_4 = true
	end

	if var_19_3 and arg_19_0:_update_damage_feedback(arg_19_1, arg_19_2) then
		var_19_4 = true
	end

	if var_19_4 then
		arg_19_0:set_dirty()
	end
end

function UnitFrameUI.on_resolution_modified(arg_20_0)
	arg_20_0:set_player_name(arg_20_0._player_name or "")

	for iter_20_0, iter_20_1 in pairs(arg_20_0._widgets) do
		arg_20_0:_set_widget_dirty(iter_20_1)
	end

	arg_20_0:set_dirty()
end

local var_0_1 = {
	root_scenegraph_id = "portrait_pivot",
	label = "You",
	registry_key = "player_portrait",
	drag_scenegraph_id = "portrait_pivot_dragger"
}
local var_0_2 = {
	root_scenegraph_id = "player_status",
	is_child = true,
	registry_key = "player_status"
}
local var_0_3 = {
	root_scenegraph_id = "pivot",
	label = "Team",
	registry_key = "teammate_portrait",
	drag_scenegraph_id = "pivot_dragger"
}

function UnitFrameUI.draw(arg_21_0, arg_21_1)
	if not arg_21_0._is_visible then
		return
	end

	if arg_21_0._frame_type == "player" then
		if HudCustomizer.run(arg_21_0.ui_renderer, arg_21_0.ui_scenegraph, var_0_1) then
			UIUtils.mark_dirty(arg_21_0._portrait_widgets)
			UIUtils.mark_dirty(arg_21_0._default_widgets)
			UIUtils.mark_dirty(arg_21_0._damage_widgets)

			arg_21_0._dirty = true
		elseif HudCustomizer.run(arg_21_0.ui_renderer, arg_21_0.ui_scenegraph, var_0_2) then
			UIUtils.mark_dirty(arg_21_0._health_widgets)
			UIUtils.mark_dirty(arg_21_0._ability_widgets)
			UIUtils.mark_dirty(arg_21_0._damage_widgets)

			arg_21_0._dirty = true
		end
	elseif arg_21_0._frame_type == "team" and HudCustomizer.run(arg_21_0.ui_renderer, arg_21_0.ui_scenegraph, var_0_3) then
		UIUtils.mark_dirty(arg_21_0._portrait_widgets)
		UIUtils.mark_dirty(arg_21_0._default_widgets)
		UIUtils.mark_dirty(arg_21_0._health_widgets)
		UIUtils.mark_dirty(arg_21_0._ability_widgets)
		UIUtils.mark_dirty(arg_21_0._damage_widgets)

		arg_21_0._dirty = true
	end

	if not arg_21_0._dirty then
		return
	end

	local var_21_0 = arg_21_0.ui_renderer
	local var_21_1 = arg_21_0.ui_scenegraph
	local var_21_2 = arg_21_0.input_manager:get_service("ingame_menu")
	local var_21_3 = arg_21_0.render_settings
	local var_21_4 = var_21_3.alpha_multiplier

	UIRenderer.begin_pass(var_21_0, var_21_1, var_21_2, arg_21_1, nil, arg_21_0.render_settings)

	var_21_3.alpha_multiplier = arg_21_0._default_alpha_multiplier or var_21_4

	for iter_21_0, iter_21_1 in pairs(arg_21_0._default_widgets) do
		UIRenderer.draw_widget(var_21_0, iter_21_1)
	end

	var_21_3.alpha_multiplier = arg_21_0._damage_alpha_multiplier or var_21_4

	for iter_21_2, iter_21_3 in pairs(arg_21_0._damage_widgets) do
		UIRenderer.draw_widget(var_21_0, iter_21_3)
	end

	var_21_3.alpha_multiplier = arg_21_0._portrait_alpha_multiplier or var_21_4

	for iter_21_4, iter_21_5 in pairs(arg_21_0._portrait_widgets) do
		UIRenderer.draw_widget(var_21_0, iter_21_5)
	end

	var_21_3.alpha_multiplier = arg_21_0._equipment_alpha_multiplier or var_21_4

	for iter_21_6, iter_21_7 in pairs(arg_21_0._equipment_widgets) do
		UIRenderer.draw_widget(var_21_0, iter_21_7)
	end

	var_21_3.alpha_multiplier = arg_21_0._health_alpha_multiplier or var_21_4

	for iter_21_8, iter_21_9 in pairs(arg_21_0._health_widgets) do
		UIRenderer.draw_widget(var_21_0, iter_21_9)
	end

	var_21_3.alpha_multiplier = arg_21_0._ability_alpha_multiplier or var_21_4

	for iter_21_10, iter_21_11 in pairs(arg_21_0._ability_widgets) do
		UIRenderer.draw_widget(var_21_0, iter_21_11)
	end

	var_21_3.alpha_multiplier = arg_21_0._respawn_alpha_multiplier or var_21_4

	for iter_21_12, iter_21_13 in pairs(arg_21_0._respawn_widgets) do
		UIRenderer.draw_widget(var_21_0, iter_21_13)
	end

	UIRenderer.end_pass(var_21_0)

	arg_21_0._dirty = false
end

function UnitFrameUI.set_dirty(arg_22_0)
	arg_22_0._dirty = true
end

function UnitFrameUI._set_widget_dirty(arg_23_0, arg_23_1)
	arg_23_1.element.dirty = true
end

function UnitFrameUI.reset(arg_24_0)
	arg_24_0:set_player_name("")
	arg_24_0:set_talking(false)
	arg_24_0:set_icon_visibility(false)
	arg_24_0:set_connecting_status(true)
	arg_24_0:_reset_voice_animation()

	local var_24_0 = true
	local var_24_1 = false
	local var_24_2 = false

	arg_24_0:set_health_bar_status(var_24_0, var_24_1, var_24_2)

	if arg_24_0.features_list.equipment then
		for iter_24_0, iter_24_1 in pairs(arg_24_0.inventory_index_by_slot) do
			arg_24_0:set_inventory_slot_data(iter_24_0, false)
		end
	end

	arg_24_0:set_dirty()
end

function UnitFrameUI.set_portrait_frame(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._widgets
	local var_25_1 = arg_25_0._portrait_widgets
	local var_25_2 = var_25_0.portrait_static

	if var_25_2.content.frame_settings_name == arg_25_1 and var_25_2.content.level_text == arg_25_2 then
		return
	end

	local var_25_3 = var_25_2.content.scale or 1

	UIWidget.destroy(arg_25_0.ui_renderer, var_25_2)

	local var_25_4 = true
	local var_25_5 = UIWidgets.create_portrait_frame("portrait_pivot", arg_25_1, arg_25_2, var_25_3, var_25_4)
	local var_25_6 = UIWidget.init(var_25_5, arg_25_0.ui_renderer)

	var_25_0.portrait_static = var_25_6
	var_25_1.portrait_static = var_25_0.portrait_static

	local var_25_7 = var_25_6.content

	var_25_7.frame_settings_name = arg_25_1
	var_25_7.level_text = arg_25_2

	arg_25_0:_set_widget_dirty(var_25_6)
end

function UnitFrameUI.set_portrait(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0:_widget_by_feature("default", "static")

	var_26_0.content.character_portrait = arg_26_1

	arg_26_0:_set_widget_dirty(var_26_0)
end

function UnitFrameUI.set_host_status(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0:_widget_by_feature("default", "static")

	var_27_0.content.is_host = arg_27_1

	arg_27_0:_set_widget_dirty(var_27_0)
end

function UnitFrameUI.set_versus_level(arg_28_0, arg_28_1)
	local var_28_0, var_28_1 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_28_1)
	local var_28_2 = arg_28_0:_widget_by_feature("versus_insignia", "static")

	if not var_28_2 then
		return
	end

	local var_28_3 = Managers.mechanism:current_mechanism_name()
	local var_28_4 = Application.user_setting("toggle_versus_level_in_all_game_modes")
	local var_28_5 = var_28_3 == "versus" or var_28_4
	local var_28_6 = var_28_2.content

	var_28_6.insignia_main.uvs = var_28_0
	var_28_6.insignia_addon.uvs = var_28_1
	var_28_6.level = arg_28_1
	var_28_6.visible = var_28_5 and arg_28_1 > 0

	if var_28_3 ~= "versus" then
		local var_28_7 = arg_28_0.definitions.scenegraph_definition

		arg_28_0.ui_scenegraph.player_status.position[1] = var_28_7.player_status.position[1] - (var_28_4 and 0 or UISettings.INSIGNIA_OFFSET)
		arg_28_0.ui_scenegraph.portrait_pivot_parent.position[1] = var_28_7.portrait_pivot_parent.position[1] - (var_28_4 and 0 or UISettings.INSIGNIA_OFFSET)
	end

	for iter_28_0, iter_28_1 in pairs(arg_28_0._widgets) do
		arg_28_0:_set_widget_dirty(iter_28_1)
	end

	arg_28_0:set_dirty()
end

function UnitFrameUI.set_talking(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0:_widget_by_feature("default", "dynamic")

	var_29_0.content.is_talking = arg_29_1

	arg_29_0:_set_widget_dirty(var_29_0)
end

function UnitFrameUI.set_status_icon(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0:_widget_by_feature("status_icon", "dynamic")
	local var_30_1 = var_30_0.content
	local var_30_2 = var_30_0.style

	var_30_1.portrait_icon = arg_30_1
	var_30_2.portrait_icon.color[1] = arg_30_2 or 255

	arg_30_0:_set_widget_dirty(var_30_0)
end

function UnitFrameUI.set_connecting_status(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0:_widget_by_feature("default", "dynamic")

	var_31_0.content.connecting = arg_31_1

	arg_31_0:_set_widget_dirty(var_31_0)
end

function UnitFrameUI.set_icon_visibility(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0:_widget_by_feature("status_icon", "dynamic")

	var_32_0.content.display_portrait_icon = arg_32_1

	arg_32_0:_set_widget_dirty(var_32_0)
end

function UnitFrameUI.set_portrait_status(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	local var_33_0 = arg_33_0:_widget_by_feature("default", "static")
	local var_33_1 = var_33_0.content.character_portrait
	local var_33_2 = arg_33_0.ui_renderer.gui_retained
	local var_33_3 = Gui.material(var_33_2, var_33_1)

	if arg_33_1 or arg_33_2 or arg_33_3 then
		Material.set_vector2(var_33_3, "saturate_params", Vector2(0.7, 1))
	else
		Material.set_vector2(var_33_3, "saturate_params", Vector2(0, 1))
	end

	if arg_33_2 then
		arg_33_0:set_status_icon("status_icon_needs_assist", 150)
	elseif arg_33_4 then
		arg_33_0:set_status_icon("status_icon_respawn", 150)
	elseif arg_33_3 then
		arg_33_0:set_status_icon("status_icon_dead", 255)
	end

	arg_33_0:_set_widget_dirty(var_33_0)
end

function UnitFrameUI.set_player_name(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0:_widget_by_feature("player_name", "static")

	if var_34_0 then
		local var_34_1 = var_34_0.content
		local var_34_2 = arg_34_1
		local var_34_3 = 170 * RESOLUTION_LOOKUP.scale

		if IS_PS4 then
			local var_34_4 = var_34_0.style.player_name
			local var_34_5 = var_34_0.style.player_name_shadow

			var_34_4.font_size = 18
			var_34_5.font_size = 18

			local var_34_6 = UIRenderer.scaled_font_size_by_width(arg_34_0.ui_renderer, var_34_2, var_34_3, var_34_4)

			var_34_0.style.player_name.font_size = var_34_6
			var_34_5.font_size = UIRenderer.scaled_font_size_by_width(arg_34_0.ui_renderer, var_34_2, var_34_3, var_34_5)
		else
			var_34_2 = var_34_0.style.player_name and UTF8Utils.string_length(arg_34_1) > var_0_0 and UIRenderer.crop_text_width(arg_34_0.ui_renderer, arg_34_1, var_34_3, var_34_0.style.player_name) or arg_34_1
		end

		var_34_1.player_name = var_34_2

		arg_34_0:_set_widget_dirty(var_34_0)
	end

	arg_34_0._player_name = arg_34_1
end

local var_0_4 = {
	"item_count_1",
	"item_count_2",
	"item_count_3"
}

function UnitFrameUI.set_inventory_slot_data(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	local var_35_0 = arg_35_2 and arg_35_3.name
	local var_35_1 = arg_35_2 and arg_35_3.hud_icon
	local var_35_2 = arg_35_0:_widget_by_feature("equipment", "dynamic")
	local var_35_3 = var_35_2.content
	local var_35_4 = var_35_2.style
	local var_35_5 = UISettings.inventory_consumable_slot_colors
	local var_35_6 = arg_35_0.inventory_index_by_slot[arg_35_1]

	if var_35_6 then
		local var_35_7 = "item_slot_" .. var_35_6
		local var_35_8 = "item_slot_bg_" .. var_35_6
		local var_35_9 = "item_slot_frame_" .. var_35_6

		var_35_3[var_35_7] = arg_35_2 and var_35_1 or "icons_placeholder"
		var_35_4[var_35_7].color[1] = arg_35_2 and 255 or 0
		var_35_4[var_35_8].color[1] = arg_35_2 and 255 or 100
		var_35_4[var_35_9].color[1] = arg_35_2 and 255 or 100

		local var_35_10 = var_0_4[var_35_6]

		if var_35_10 then
			if arg_35_4 and arg_35_4 > 0 then
				var_35_3[var_35_10] = arg_35_4
			else
				var_35_3[var_35_10] = nil
			end
		end

		if var_35_5 then
			local var_35_11 = var_35_5.default
			local var_35_12 = arg_35_2 and (var_35_5[var_35_0] or var_35_11) or var_35_11
			local var_35_13 = var_35_4[var_35_8].color

			var_35_13[2] = var_35_12[2]
			var_35_13[3] = var_35_12[3]
			var_35_13[4] = var_35_12[4]
		end

		if arg_35_2 then
			arg_35_0:_add_slot_equip_animation(arg_35_1 .. "_equip_anim", var_35_2, var_35_4["item_slot_highlight_" .. var_35_6])
		end
	end

	arg_35_0:_set_widget_dirty(var_35_2)
end

function UnitFrameUI.set_equipped_weapon_info(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	local var_36_0 = arg_36_0:_widget_by_feature("weapons", "dynamic")
	local var_36_1 = var_36_0.content
	local var_36_2 = var_36_0.style

	if arg_36_2 then
		var_36_1.equipped_weapon = arg_36_4
		var_36_1.equipped_weapon_slot = arg_36_1
	elseif var_36_1.equipped_weapon_slot ~= arg_36_1 and not var_36_1.equipped_weapon then
		var_36_1.equipped_weapon = arg_36_4
	end

	for iter_36_0, iter_36_1 in pairs(arg_36_0.weapon_slot_widget_settings.ammo_fields) do
		if arg_36_1 == iter_36_0 then
			local var_36_3 = arg_36_2 and 255 or 100

			var_36_2[iter_36_1].text_color[1] = var_36_3
			var_36_2[iter_36_1 .. "_2"].text_color[1] = var_36_3
			var_36_2[iter_36_1 .. "_3"].text_color[1] = var_36_3
		end
	end

	arg_36_0:_set_widget_dirty(var_36_0)
end

local var_0_5 = " "

function UnitFrameUI.set_ammo_for_slot(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	local var_37_0 = arg_37_0:_widget_by_feature("weapons", "dynamic")
	local var_37_1 = var_37_0.content
	local var_37_2 = arg_37_0.weapon_slot_widget_settings.ammo_fields[arg_37_1]

	if not arg_37_2 or not arg_37_3 then
		var_37_1[var_37_2] = " "
		var_37_1[var_37_2 .. "_2"] = " "
		var_37_1[var_37_2 .. "_3"] = " "
	else
		var_37_1[var_37_2] = var_0_5 .. tostring(arg_37_2)
		var_37_1[var_37_2 .. "_2"] = arg_37_4 and var_0_5 or "|"
		var_37_1[var_37_2 .. "_3"] = arg_37_4 and var_0_5 or tostring(arg_37_3)
	end

	arg_37_0:_set_widget_dirty(var_37_0)
end

function UnitFrameUI.set_ammo_percentage(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0:_widget_by_feature("ammo", "dynamic")

	var_38_0.content.ammo_percent = arg_38_1

	arg_38_0:_set_widget_dirty(var_38_0)
	arg_38_0:set_dirty()
end

function UnitFrameUI.set_ability_percentage(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0:_widget_by_feature("ability", "dynamic")

	var_39_0.content.actual_ability_percent = arg_39_1

	arg_39_0:_on_player_ability_changed("ability", var_39_0, arg_39_1)
	arg_39_0:_set_widget_dirty(var_39_0)
end

function UnitFrameUI.set_overcharge_percentage(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0:_widget_by_feature("weapons", "dynamic")
	local var_40_1 = var_40_0.content

	var_40_1.has_overcharge = arg_40_1
	var_40_1.overcharge_fill.has_overcharge = arg_40_1
	var_40_1.overcharge_fill.overcharge_percent = arg_40_2 or 0

	arg_40_0:_set_widget_dirty(var_40_0)
end

function UnitFrameUI.set_active_percentage(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0:_widget_by_feature("health", "dynamic")

	var_41_0.content.actual_active_percentage = arg_41_1

	arg_41_0:_set_widget_dirty(var_41_0)
end

function UnitFrameUI.set_health_percentage(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_0:_widget_by_feature("health", "dynamic")

	var_42_0.content.actual_health_percent = arg_42_1

	arg_42_0:_on_player_health_changed("health", var_42_0, arg_42_1 * arg_42_2)
	arg_42_0:_set_widget_dirty(var_42_0)
end

function UnitFrameUI.set_total_health_percentage(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0:_widget_by_feature("health", "dynamic")

	var_43_0.content.actual_total_health_percent = arg_43_1

	arg_43_0:_on_player_total_health_changed("total_health", var_43_0, arg_43_1 * arg_43_2)
	arg_43_0:_set_widget_dirty(var_43_0)
end

function UnitFrameUI.set_health_bar_status(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = arg_44_0:_widget_by_feature("health", "dynamic")
	local var_44_1 = var_44_0.style
	local var_44_2 = var_44_0.content
	local var_44_3 = var_44_2.total_health_bar
	local var_44_4 = var_44_2.hp_bar
	local var_44_5 = var_44_1.total_health_bar

	var_44_3.draw_health_bar = arg_44_1
	var_44_3.is_knocked_down = arg_44_2
	var_44_3.is_wounded = arg_44_3

	if arg_44_0.features_list.equipment then
		arg_44_0:_widget_by_feature("equipment", "dynamic").content.draw_health_bar = arg_44_1
	end

	local var_44_6 = var_44_5.color

	if arg_44_2 then
		var_44_6[2] = 255
		var_44_6[3] = 0
		var_44_6[4] = 0
		var_44_4.hide = true
	else
		var_44_6[2] = 255
		var_44_6[3] = 255
		var_44_6[4] = 255
		var_44_4.hide = false
	end

	arg_44_0:_set_widget_dirty(var_44_0)
end

function UnitFrameUI.set_health_bar_divider_amount(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0:_widget_by_feature("health", "dynamic")

	var_45_0.style.hp_bar_divider.texture_amount = arg_45_1

	arg_45_0:_set_widget_dirty(var_45_0)
end

function UnitFrameUI._update_portrait_opacity(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	local var_46_0
	local var_46_1 = arg_46_0:_widget_by_feature("default", "static")
	local var_46_2 = var_46_1.style.character_portrait.color

	if arg_46_2 or arg_46_3 or arg_46_4 then
		var_46_0 = 255 * math.sirp(0.6, 1, arg_46_0.overlay_time)
	elseif arg_46_1 then
		var_46_0 = 0
	elseif var_46_2[1] ~= 255 then
		var_46_0 = 255
	end

	if var_46_0 then
		var_46_2[1] = var_46_0

		arg_46_0:_set_widget_dirty(var_46_1)

		return true
	end
end

function UnitFrameUI._reset_voice_animation(arg_47_0)
	local var_47_0 = arg_47_0:_widget_by_feature("default", "dynamic")
	local var_47_1 = var_47_0.style
	local var_47_2 = var_47_1.talk_indicator.color
	local var_47_3 = var_47_1.talk_indicator_glow.color
	local var_47_4 = var_47_1.talk_indicator_highlight.color
	local var_47_5 = var_47_1.talk_indicator_highlight_glow.color

	var_47_2[1] = 0
	var_47_3[1] = 0
	var_47_4[1] = 0
	var_47_5[1] = 0

	arg_47_0:_set_widget_dirty(var_47_0)
end

function UnitFrameUI._update_voice_animation(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = arg_48_0:_widget_by_feature("default", "dynamic")
	local var_48_1 = var_48_0.style
	local var_48_2 = var_48_1.talk_indicator.color
	local var_48_3 = var_48_1.talk_indicator_glow.color
	local var_48_4 = var_48_0.style.talk_indicator_highlight.color
	local var_48_5 = var_48_2[1]
	local var_48_6 = var_48_5 + (arg_48_3 and 1 or -1) * 255 * arg_48_1
	local var_48_7 = var_48_4[1] + (arg_48_3 and 1 or -1) * 255 * arg_48_1

	if arg_48_3 then
		var_48_7 = var_48_7 + math.sin(arg_48_2 * 3) * 20
		var_48_7 = var_48_7 + math.cos((arg_48_2 + 1) * 13) * 20
	end

	local var_48_8 = math.clamp(var_48_7, 0, 255)
	local var_48_9 = math.clamp(var_48_6, 0, 255)

	if var_48_8 ~= var_48_4[1] or var_48_5 ~= var_48_9 then
		var_48_2[1] = var_48_9
		var_48_3[1] = var_48_9
		var_48_4[1] = var_48_8
		var_48_1.talk_indicator_highlight_glow.color[1] = var_48_8

		arg_48_0:_set_widget_dirty(var_48_0)

		return true
	end
end

function UnitFrameUI._update_health_bar_animation(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0:_widget_by_feature("health", "dynamic").content.hp_bar
	local var_49_1 = var_49_0.bar_value

	if var_49_1 ~= var_49_0.internal_bar_value then
		var_49_0.internal_bar_value = var_49_1

		return true
	end
end

function UnitFrameUI._update_total_health_bar_animation(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0:_widget_by_feature("health", "dynamic").content.total_health_bar
	local var_50_1 = var_50_0.bar_value

	if var_50_1 ~= var_50_0.internal_bar_value then
		var_50_0.internal_bar_value = var_50_1

		return true
	end
end

function UnitFrameUI.show_respawn_ui(arg_51_0)
	return arg_51_0._show_respawn_ui
end

function UnitFrameUI.show_respawn_countdown(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	arg_52_0._show_respawn_ui = true

	local var_52_0 = arg_52_0._frame_type == "player" and arg_52_0:_widget_by_name("respawn_dynamic") or arg_52_0:_widget_by_name("default_dynamic")
	local var_52_1 = var_52_0.content

	var_52_1.respawn_timer = arg_52_3
	var_52_1.total_countdown_time = arg_52_3
	var_52_1.state = "countdown"
	var_52_1.respawn_info_text = Localize("vs_respawn_in_ghostmode")

	local var_52_2 = var_52_0.style
	local var_52_3 = var_52_2.respawn_countdown_text

	if var_52_3 then
		var_52_3.text_color[1] = 255
	end

	local var_52_4 = var_52_2.respawn_info_text

	if var_52_4 then
		var_52_4.text_color[1] = 255
	end
end

function UnitFrameUI.update_respawn_countdown(arg_53_0, arg_53_1, arg_53_2)
	arg_53_2, arg_53_1 = Managers.time:time_and_delta("game")

	local var_53_0 = arg_53_0.ui_renderer
	local var_53_1 = arg_53_0.ui_scenegraph
	local var_53_2 = arg_53_0.input_manager:get_service("Player")
	local var_53_3 = arg_53_0._frame_type == "player"
	local var_53_4 = var_53_3 and arg_53_0:_widget_by_name("respawn_dynamic") or arg_53_0:_widget_by_name("default_dynamic")
	local var_53_5 = var_53_4.content
	local var_53_6 = var_53_5.state
	local var_53_7 = 0.66

	if var_53_6 == "countdown" then
		local var_53_8 = var_53_5.respawn_timer - Managers.time:time("game")
		local var_53_9 = var_53_5.total_fadeout_time or var_53_7

		if var_53_8 <= var_53_9 then
			var_53_5.fadeout_time = var_53_9
			var_53_6 = "fadeout"
		end

		var_53_5.respawn_countdown_text = tostring(math.ceil(math.abs(var_53_8)))
	elseif var_53_6 == "fadeout" then
		local var_53_10 = var_53_4.style
		local var_53_11 = (var_53_5.fadeout_time or var_53_7) - arg_53_1
		local var_53_12 = var_53_5.total_fadeout_time or var_53_7
		local var_53_13 = (var_53_12 <= 0 and 0 or math.max(var_53_11, 0) / var_53_12) * 255

		var_53_10.respawn_countdown_text.text_color[1] = var_53_13

		if var_53_3 then
			var_53_10.respawn_info_text.text_color[1] = var_53_13
		end

		var_53_5.fadeout_time = var_53_11

		if var_53_11 <= 0 then
			var_53_6 = "hidden"
			arg_53_0._show_respawn_ui = false
			var_53_5.respawn_countdown_text = ""

			if var_53_3 then
				var_53_5.respawn_info_text = ""
			end
		end
	end

	var_53_5.state = var_53_6

	Debug.text("RESPAWN GUI UPDATED")
	UIRenderer.begin_pass(var_53_0, var_53_1, var_53_2, arg_53_1)
	UIRenderer.draw_widget(var_53_0, var_53_4)
	UIRenderer.end_pass(var_53_0)
	arg_53_0:set_dirty()

	return true
end

function UnitFrameUI._update_overcharge_animation(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_0:_widget_by_feature("weapons", "dynamic")
	local var_54_1 = var_54_0.content
	local var_54_2 = var_54_0.style

	if not var_54_1.has_overcharge then
		return
	end

	local var_54_3 = var_54_2.overcharge_fill
	local var_54_4 = var_54_1.overcharge_fill
	local var_54_5 = var_54_4.overcharge_percent

	if var_54_4.internal_overcharge_percent ~= var_54_5 then
		local var_54_6 = var_54_1.bar_start_side
		local var_54_7 = var_54_3.uv_start_pixels
		local var_54_8 = var_54_3.uv_scale_pixels
		local var_54_9 = var_54_3.scale_axis
		local var_54_10 = var_54_3.offset
		local var_54_11 = var_54_3.size
		local var_54_12 = var_54_4.uvs
		local var_54_13 = var_54_8
		local var_54_14 = var_54_7 + var_54_8
		local var_54_15 = var_54_7 + var_54_8 * var_54_5

		var_54_11[var_54_9] = var_54_15

		if var_54_6 == "left" then
			var_54_12[2][var_54_9] = var_54_14 / (var_54_7 + var_54_8)

			local var_54_16 = var_54_3.start_offset

			var_54_10[var_54_9] = math.max(var_54_16 + var_54_13, var_54_16 + var_54_8 - var_54_15)
		else
			var_54_12[2][var_54_9] = var_54_14 / (var_54_7 + var_54_8)
			var_54_10[var_54_9] = var_54_3.start_offset + var_54_13 - var_54_15
		end

		var_54_4.internal_overcharge_percent = var_54_5

		return true
	end
end

function UnitFrameUI._on_num_grimoires_changed(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	if not arg_55_0.bar_animations then
		arg_55_0.bar_animations = {}
	end

	local var_55_0 = arg_55_0.bar_animations[arg_55_1] or {}

	if arg_55_3 ~= var_55_0.current_health_debuff then
		local var_55_1 = arg_55_2.content.grimoire_debuff.bar_value
		local var_55_2 = arg_55_2.style.grimoire_debuff
		local var_55_3 = arg_55_2.style.hp_bar
		local var_55_4 = UISettings.unit_frames.health_bar_lerp_time
		local var_55_5

		if var_55_1 < arg_55_3 then
			var_55_5 = (arg_55_3 - var_55_1) * var_55_4
		else
			var_55_5 = (var_55_1 - arg_55_3) * var_55_4
		end

		local var_55_6 = var_55_2.uv_scale_pixels - var_55_3.uv_scale_pixels
		local var_55_7 = (var_55_3.uv_scale_pixels * arg_55_3 + var_55_6 * 0.5) / var_55_2.uv_scale_pixels

		arg_55_3 = var_55_7
		var_55_0.animate = true
		var_55_0.new_value = var_55_7
		var_55_0.previous_value = var_55_1
		var_55_0.time = 0
		var_55_0.total_time = var_55_5
		var_55_0.widget = arg_55_2
		var_55_0.bar = arg_55_2.content.grimoire_debuff
	end

	var_55_0.current_health_debuff = arg_55_3
	arg_55_0.bar_animations[arg_55_1] = var_55_0
end

function UnitFrameUI._on_overcharge_changed(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	if not arg_56_0.bar_animations then
		arg_56_0.bar_animations = {}
	end

	local var_56_0 = arg_56_0.bar_animations[arg_56_1] or {}

	if arg_56_3 ~= var_56_0.current_overcharge_percent then
		local var_56_1 = arg_56_2.content.overcharge_fill.bar_value
		local var_56_2 = UISettings.unit_frames.health_bar_lerp_time
		local var_56_3

		if var_56_1 < arg_56_3 then
			var_56_3 = (arg_56_3 - var_56_1) * var_56_2
		else
			var_56_3 = (var_56_1 - arg_56_3) * var_56_2
		end

		var_56_0.animate = true
		var_56_0.new_value = arg_56_3
		var_56_0.previous_value = var_56_1
		var_56_0.time = 0
		var_56_0.total_time = var_56_3
		var_56_0.widget = arg_56_2
		var_56_0.bar = arg_56_2.content.overcharge_fill
	end

	var_56_0.current_overcharge_percent = arg_56_3
	arg_56_0.bar_animations[arg_56_1] = var_56_0
end

function UnitFrameUI._on_player_ammo_changed(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	local var_57_0 = arg_57_0.bar_animations[arg_57_1] or {}

	arg_57_0.bar_animations[arg_57_1] = var_57_0

	local var_57_1 = var_57_0.current_health

	var_57_0.current_health = arg_57_3

	if arg_57_3 <= 1 and arg_57_3 ~= var_57_1 then
		local var_57_2 = arg_57_2.content.ammo_bar.bar_value
		local var_57_3 = UISettings.unit_frames.health_bar_lerp_time
		local var_57_4

		if var_57_2 < arg_57_3 then
			var_57_4 = (arg_57_3 - var_57_2) * var_57_3
		else
			var_57_4 = (var_57_2 - arg_57_3) * var_57_3
		end

		var_57_0.animate = true
		var_57_0.new_value = arg_57_3
		var_57_0.previous_value = var_57_2
		var_57_0.time = 0
		var_57_0.total_time = var_57_4
		var_57_0.widget = arg_57_2
		var_57_0.content = arg_57_2.content.ammo_bar
		var_57_0.style = arg_57_2.style.ammo_bar

		return true
	end
end

function UnitFrameUI._on_player_ability_changed(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = arg_58_0.bar_animations[arg_58_1] or {}

	arg_58_0.bar_animations[arg_58_1] = var_58_0

	local var_58_1 = var_58_0.current_health

	var_58_0.current_health = arg_58_3

	if arg_58_3 <= 1 and arg_58_3 ~= var_58_1 then
		local var_58_2 = arg_58_2.content.ability_bar.bar_value
		local var_58_3 = UISettings.unit_frames.health_bar_lerp_time
		local var_58_4

		if var_58_2 < arg_58_3 then
			var_58_4 = (arg_58_3 - var_58_2) * var_58_3
		else
			var_58_4 = (var_58_2 - arg_58_3) * var_58_3
		end

		var_58_0.animate = true
		var_58_0.new_value = arg_58_3
		var_58_0.previous_value = var_58_2
		var_58_0.time = 0
		var_58_0.total_time = var_58_4
		var_58_0.widget = arg_58_2
		var_58_0.content = arg_58_2.content.ability_bar
		var_58_0.style = arg_58_2.style.ability_bar

		return true
	end
end

function UnitFrameUI._on_player_health_changed(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	local var_59_0 = arg_59_0.bar_animations[arg_59_1] or {}

	arg_59_0.bar_animations[arg_59_1] = var_59_0

	local var_59_1 = var_59_0.current_health

	var_59_0.current_health = arg_59_3

	if arg_59_3 <= 1 and arg_59_3 ~= var_59_1 then
		local var_59_2 = arg_59_2.content.hp_bar.is_knocked_down
		local var_59_3 = arg_59_2.content.hp_bar.bar_value
		local var_59_4 = UISettings.unit_frames.health_bar_lerp_time
		local var_59_5

		if var_59_3 < arg_59_3 then
			var_59_5 = (arg_59_3 - var_59_3) * var_59_4
		else
			var_59_5 = (var_59_3 - arg_59_3) * var_59_4
		end

		var_59_0.animate_damage_highlight = (not var_59_2 and arg_59_3 < (var_59_1 or 1) or false) and 0 or var_59_0.animate_damage_highlight
		var_59_0.animate = true
		var_59_0.new_value = arg_59_3
		var_59_0.previous_value = var_59_3
		var_59_0.time = 0
		var_59_0.total_time = var_59_5
		var_59_0.widget = arg_59_2
		var_59_0.content = arg_59_2.content.hp_bar
		var_59_0.style = arg_59_2.style.hp_bar

		return true
	end
end

function UnitFrameUI._on_player_total_health_changed(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	local var_60_0 = arg_60_0.bar_animations[arg_60_1] or {}

	arg_60_0.bar_animations[arg_60_1] = var_60_0

	local var_60_1 = var_60_0.current_health

	var_60_0.current_health = arg_60_3

	if arg_60_3 <= 1 and arg_60_3 ~= var_60_1 then
		local var_60_2 = arg_60_2.content.hp_bar.is_knocked_down
		local var_60_3 = arg_60_2.content.total_health_bar.bar_value
		local var_60_4 = UISettings.unit_frames.health_bar_lerp_time
		local var_60_5

		if var_60_3 < arg_60_3 then
			var_60_5 = (arg_60_3 - var_60_3) * var_60_4
		else
			var_60_5 = (var_60_3 - arg_60_3) * var_60_4
		end

		var_60_0.animate_bar_flash = (not var_60_2 and arg_60_3 < (var_60_1 or 1) or false) and 0 or var_60_0.animate_bar_flash
		var_60_0.animate = true
		var_60_0.new_value = arg_60_3
		var_60_0.previous_value = var_60_3
		var_60_0.time = 0
		var_60_0.total_time = var_60_5
		var_60_0.widget = arg_60_2
		var_60_0.content = arg_60_2.content.total_health_bar
		var_60_0.style = arg_60_2.style.total_health_bar

		return true
	end
end

function UnitFrameUI._update_bar_animations(arg_61_0, arg_61_1)
	local var_61_0 = false
	local var_61_1 = arg_61_0.bar_animations

	if var_61_1 then
		for iter_61_0, iter_61_1 in pairs(var_61_1) do
			local var_61_2 = false
			local var_61_3 = iter_61_1.widget
			local var_61_4 = iter_61_1.content
			local var_61_5 = iter_61_1.style

			if var_61_4 and var_61_4.low_health then
				UIAnimation.update(iter_61_1.low_health_animation, arg_61_1)

				var_61_0 = true
				var_61_2 = true
			end

			if iter_61_1.animate_damage_highlight then
				iter_61_1.animate_damage_highlight = arg_61_0:_update_damage_highlight(var_61_3, iter_61_1.animate_damage_highlight, arg_61_1)
				var_61_0 = true
				var_61_2 = true
			end

			if iter_61_1.animate_bar_flash then
				iter_61_1.animate_bar_flash = arg_61_0:_update_bar_flash(var_61_3, var_61_5, iter_61_1.animate_bar_flash, arg_61_1)
				var_61_0 = true
				var_61_2 = true
			end

			if iter_61_1.animate then
				local var_61_6 = iter_61_1.time
				local var_61_7 = iter_61_1.total_time
				local var_61_8 = iter_61_1.new_value
				local var_61_9 = iter_61_1.previous_value
				local var_61_10 = arg_61_0:_update_player_bar_animation(var_61_4, var_61_5, var_61_6, var_61_7, var_61_9, var_61_8, arg_61_1)

				var_61_2 = true

				if var_61_10 then
					iter_61_1.time = var_61_10
				else
					iter_61_1.animate = nil
				end

				var_61_0 = true
			end

			if var_61_2 then
				arg_61_0:_set_widget_dirty(var_61_3)
			end
		end
	end

	return var_61_0
end

function UnitFrameUI._update_bar_flash(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	local var_62_0 = 0.3

	arg_62_3 = arg_62_3 + arg_62_4

	if var_62_0 > 0 then
		local var_62_1 = math.min(arg_62_3 / var_62_0, 1)
		local var_62_2 = 155 + 100 * math.max(1 - math.ease_pulse(var_62_1), 0)

		arg_62_2.color[1] = var_62_2

		arg_62_0:_set_widget_dirty(arg_62_1)

		return var_62_1 < 1 and arg_62_3 or nil
	end

	return nil
end

function UnitFrameUI._update_damage_highlight(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	local var_63_0 = 0.2

	arg_63_2 = arg_63_2 + arg_63_3

	if var_63_0 > 0 then
		local var_63_1 = arg_63_1.style
		local var_63_2 = math.min(arg_63_2 / var_63_0, 1)
		local var_63_3 = 255 * math.catmullrom(var_63_2, -8, 0, 0, -8)

		var_63_1.hp_bar_highlight.color[1] = var_63_3

		arg_63_0:_set_widget_dirty(arg_63_1)

		return var_63_2 < 1 and arg_63_2 or nil
	end

	return nil
end

function UnitFrameUI._update_player_bar_animation(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7)
	arg_64_3 = arg_64_3 + arg_64_7

	if arg_64_4 > 0 then
		local var_64_0 = math.min(arg_64_3 / arg_64_4, 1)
		local var_64_1 = 7
		local var_64_2 = (var_64_0 * (var_64_1 - 1) + 1) / var_64_1
		local var_64_3

		if arg_64_5 < arg_64_6 then
			var_64_3 = arg_64_5 + (arg_64_6 - arg_64_5) * var_64_2
		else
			var_64_3 = arg_64_5 - (arg_64_5 - arg_64_6) * var_64_2
		end

		arg_64_1.bar_value = var_64_3

		if arg_64_2.gradient_threshold then
			arg_64_2.gradient_threshold = var_64_3
		end

		return var_64_0 < 1 and arg_64_3 or nil
	end

	arg_64_1.bar_value = arg_64_6

	if arg_64_2.gradient_threshold then
		arg_64_2.gradient_threshold = arg_64_6
	end

	return nil
end

function UnitFrameUI._add_slot_equip_animation(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	local var_65_0 = arg_65_0.slot_equip_animations
	local var_65_1 = UISettings.inventory_hud.equip_animation_duration
	local var_65_2 = var_65_0[arg_65_1]

	if var_65_2 then
		var_65_2.total_time = var_65_1
		var_65_2.time = 0
	else
		var_65_0[arg_65_1] = {
			time = 0,
			total_time = var_65_1,
			style = arg_65_3,
			widget = arg_65_2
		}
	end
end

function UnitFrameUI._animate_slot_equip(arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = arg_66_1.style
	local var_66_1 = arg_66_1.total_time
	local var_66_2 = arg_66_1.time + arg_66_2
	local var_66_3 = math.min(var_66_2 / var_66_1, 1)
	local var_66_4 = math.catmullrom(var_66_3, -10, 0, 0, -4)

	var_66_0.color[1] = 255 * var_66_4
	arg_66_1.time = var_66_2

	return var_66_3 < 1 and arg_66_1 or nil
end

function UnitFrameUI._update_slot_equip_animations(arg_67_0, arg_67_1)
	local var_67_0 = arg_67_0.slot_equip_animations
	local var_67_1 = false

	for iter_67_0, iter_67_1 in pairs(var_67_0) do
		var_67_0[iter_67_0] = arg_67_0:_animate_slot_equip(iter_67_1, arg_67_1)

		local var_67_2 = iter_67_1.widget

		arg_67_0:_set_widget_dirty(var_67_2)

		var_67_1 = true
	end

	return var_67_1
end

function UnitFrameUI._update_connection_animation(arg_68_0, arg_68_1)
	if not arg_68_0._is_visible then
		return false
	end

	local var_68_0 = arg_68_0:_widget_by_feature("default", "dynamic")

	if var_68_0.content.connecting then
		local var_68_1 = var_68_0.style.connecting_icon
		local var_68_2 = arg_68_1 * 400 % 360
		local var_68_3 = math.degrees_to_radians(var_68_2)

		var_68_1.angle = var_68_1.angle + var_68_3

		arg_68_0:_set_widget_dirty(var_68_0)

		return true
	end
end

function UnitFrameUI.update_numeric_ui_health(arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0:_widget_by_feature("health", "dynamic")
	local var_69_1 = arg_69_1.player
	local var_69_2 = var_69_1 and var_69_1.player_unit

	if not ALIVE[var_69_2] then
		var_69_0.content.numeric_health = ""

		return
	end

	local var_69_3 = arg_69_1.extensions
	local var_69_4 = var_69_3 and var_69_3.health

	if not var_69_4 then
		return
	end

	local var_69_5 = math.ceil(var_69_4:get_max_health())
	local var_69_6 = math.ceil(var_69_4:current_permanent_health())
	local var_69_7 = math.ceil(var_69_4:current_temporary_health())

	if not var_69_0.content.numeric_health then
		return
	end

	if arg_69_0._frame_type == "player" then
		var_69_0.content.numeric_health = string.format("%d(%d)/%d", var_69_6, var_69_7, var_69_5)
	else
		var_69_0.content.numeric_health = string.format("%d/%d", var_69_6, var_69_5)
	end

	arg_69_0:_set_widget_dirty(var_69_0)
end

function UnitFrameUI.update_numeric_ui_ammo(arg_70_0, arg_70_1)
	if arg_70_0._frame_type == "player" then
		return
	end

	local var_70_0 = arg_70_0._ammo_ui_data
	local var_70_1 = arg_70_0:_widget_by_name("default_dynamic")
	local var_70_2 = arg_70_1.player
	local var_70_3 = var_70_2 and var_70_2.player_unit

	if not ALIVE[var_70_3] then
		var_70_1.content.has_ranged_weapon = false

		return
	end

	local var_70_4 = arg_70_1.extensions
	local var_70_5 = var_70_4 and var_70_4.inventory

	if not var_70_5 then
		return
	end

	if arg_70_0._frame_type == "team" then
		local var_70_6 = var_70_5:equipment().slots
		local var_70_7 = InventorySettings.slots_by_name.slot_ranged.name

		if var_70_7 == "slot_ranged" then
			local var_70_8 = var_70_6[var_70_7]

			if not var_70_8 then
				var_70_1.content.has_ranged_weapon = false

				return
			end

			local var_70_9 = var_70_8.item_template

			if not var_70_9 then
				return
			end

			local var_70_10 = var_70_9.ammo_data

			if var_70_10 and var_70_10.hide_ammo_ui then
				return
			end

			local var_70_11, var_70_12 = var_70_5:ammo_status()

			if var_70_10 and var_70_11 and var_70_12 then
				var_70_1.content.has_ranged_weapon = true
				var_70_1.content.ammo_count = string.format("%d / %d", var_70_11, var_70_12)

				if var_70_0[var_70_2.peer_id] ~= var_70_9.name then
					var_70_0[var_70_2.peer_id] = var_70_9.name
					arg_70_0.weapon_changed = true
				else
					arg_70_0.weapon_changed = false
				end
			else
				var_70_1.content.has_ranged_weapon = false
			end
		end
	end

	arg_70_0:_set_widget_dirty(var_70_1)
end

function UnitFrameUI.update_numeric_ui_career_ability(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	local var_71_0 = arg_71_0:_widget_by_name("default_dynamic")
	local var_71_1 = arg_71_3.player
	local var_71_2 = var_71_1 and var_71_1.player_unit

	if not ALIVE[var_71_2] then
		var_71_0.content.ability_cooldown = ""

		return
	end

	if not var_71_0.content.ability_cooldown then
		return
	end

	local var_71_3 = arg_71_3.extensions
	local var_71_4 = var_71_3 and var_71_3.career

	if not var_71_4 then
		return
	end

	local var_71_5 = var_71_4:career_name()
	local var_71_6 = GameSession.game_object_field(arg_71_1, arg_71_2, "ability_percentage")
	local var_71_7 = var_71_6 > 0.01 and true or false

	var_71_0.content.on_cooldown = var_71_7

	if not var_71_7 then
		return
	end

	local var_71_8 = CareerSettings[var_71_5].playfab_name
	local var_71_9

	if not var_71_8 then
		_, var_71_9 = var_71_4:current_ability_cooldown()
	else
		var_71_9 = ActivatedAbilitySettings[var_71_8][1].cooldown
	end

	local var_71_10 = var_71_9 * var_71_6

	var_71_0.content.ability_cooldown = UIUtils.format_time(var_71_10)

	arg_71_0:_set_widget_dirty(var_71_0)
end

local var_0_6 = 0.01
local var_0_7 = 0.7
local var_0_8 = 2
local var_0_9 = {
	[0] = ".00",
	[75] = ".75",
	[25] = ".25",
	[50] = ".50",
	[100] = ".00"
}, {
	[0] = " ",
	[75] = "¾",
	[25] = "¼",
	[50] = "½",
	[100] = " "
}
local var_0_10 = 4

function UnitFrameUI.add_damage_feedback(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6)
	local var_72_0 = arg_72_0._damage_events
	local var_72_1 = arg_72_1 .. arg_72_3
	local var_72_2 = arg_72_0._hash_order
	local var_72_3 = arg_72_0._dmg_part_pool
	local var_72_4 = Managers.time:time("game")
	local var_72_5 = var_72_0[var_72_1]
	local var_72_6 = arg_72_5:cached_name() or arg_72_5.character_name

	if not var_72_5 then
		var_72_5 = {
			shown_amount_decimal = "",
			running_parts = 0,
			num_dmg_parts = 0,
			text_width = 0,
			first_index = 0,
			text = "",
			shown_amount = 0,
			last_index = 0,
			event_type = arg_72_3,
			dmg_parts = Script.new_array(32),
			next_increment = var_72_4 - var_0_6,
			remove_time = math.huge,
			local_player = arg_72_2,
			target_name = var_72_6
		}
		var_72_0[var_72_1] = var_72_5

		local var_72_7 = #var_72_2 + 1

		var_72_2[var_72_7] = var_72_1
		var_72_5.hash_order = var_72_7

		local var_72_8 = arg_72_0._damage_widgets[var_72_7]

		arg_72_0._hash_widget_lookup[var_72_1] = var_72_8
		var_72_8.content.visible = true
	elseif var_72_5.disabled then
		var_72_5.disabled = false

		local var_72_9 = #var_72_2 + 1

		var_72_2[var_72_9] = var_72_1
		var_72_5.hash_order = var_72_9

		local var_72_10 = arg_72_0._damage_widgets[var_72_9]

		arg_72_0._hash_widget_lookup[var_72_1] = var_72_10
		var_72_10.content.visible = true
	end

	local var_72_11 = var_72_5.dmg_parts

	var_72_5.num_dmg_parts = var_72_5.num_dmg_parts + 1

	local var_72_12 = math.floor(arg_72_6)
	local var_72_13 = arg_72_6 - var_72_12
	local var_72_14 = math.floor((var_72_13 + 0.125) * 4) * 25
	local var_72_15 = var_0_9[var_72_14] or "  "
	local var_72_16 = var_72_12 .. var_72_15

	var_72_11[var_72_5.num_dmg_parts] = {
		arg_72_6,
		0,
		"no_id_yet",
		var_72_16,
		0
	}
	var_72_5.remove_time = math.huge

	if #var_72_2 > var_0_10 then
		fassert(false)

		var_72_0[var_72_2[1]] = nil

		table.remove(var_72_2, 1)
		table.remove(arg_72_0._hash_widget_lookup, 1)
	end
end

local var_0_11 = {
	dealing_damage = {
		text_function = function(arg_73_0, arg_73_1, arg_73_2)
			return string.format("%s", arg_73_1), arg_73_0, arg_73_2
		end,
		sound_function = function()
			return
		end
	},
	other_dealing_damage = {
		text_function = function(arg_75_0, arg_75_1, arg_75_2)
			return string.format("%s  ", arg_75_1), arg_75_0, arg_75_2
		end,
		sound_function = function()
			return "versus_ui_team_damage_indicator"
		end
	}
}
local var_0_12 = {
	"text_last_dmg",
	"text_last_dmg_2",
	"text_last_dmg_3",
	"text_last_dmg_4",
	"text_last_dmg_5",
	"text_last_dmg_6",
	"text_last_dmg_7",
	"text_last_dmg_8",
	"text_last_dmg_9",
	"text_last_dmg_10"
}

function UnitFrameUI._cleanup_damage_event(arg_77_0, arg_77_1, arg_77_2)
	arg_77_1.num_dmg_parts = 0
	arg_77_1.shown_amount = 0
	arg_77_1.shown_amount_decimal = ""
	arg_77_1.last_index = 0
	arg_77_1.first_index = 0
	arg_77_1.remove_time = math.huge
	arg_77_1.text = ""
	arg_77_1.running_parts = 0
	arg_77_1.disabled = true

	local var_77_0 = arg_77_0._hash_widget_lookup[arg_77_2].style
	local var_77_1 = arg_77_1.dmg_parts

	for iter_77_0 = 1, #var_77_1 do
		local var_77_2 = var_77_1[iter_77_0]

		var_77_2[1] = 0
		var_77_2[2] = math.huge

		local var_77_3 = var_77_0[var_77_2[3]]

		if var_77_3 then
			var_77_3.text_color[1] = 0
		end
	end
end

function UnitFrameUI._update_damage_feedback(arg_78_0, arg_78_1, arg_78_2)
	local var_78_0 = arg_78_0._hash_order
	local var_78_1 = #var_78_0

	if var_78_1 <= 0 then
		return
	end

	local var_78_2 = arg_78_0.ui_renderer
	local var_78_3 = arg_78_0.ui_scenegraph
	local var_78_4 = arg_78_0.input_manager:get_service("Player")

	for iter_78_0 = var_78_1, 1, -1 do
		local var_78_5 = var_78_0[iter_78_0]
		local var_78_6 = arg_78_0._hash_widget_lookup[var_78_5]
		local var_78_7 = var_78_6.content
		local var_78_8 = var_78_6.style
		local var_78_9 = arg_78_0._damage_events[var_78_5]
		local var_78_10 = var_0_11[var_78_9.event_type]

		if arg_78_2 > var_78_9.remove_time then
			arg_78_0:_cleanup_damage_event(var_78_9, var_78_5)
			table.remove(var_78_0, iter_78_0)

			var_78_7.visible = false
		elseif arg_78_2 > var_78_9.next_increment and var_78_9.last_index < var_78_9.num_dmg_parts then
			var_78_9.last_index = var_78_9.last_index + 1

			local var_78_11 = var_78_9.dmg_parts[var_78_9.last_index]

			var_78_11[2] = arg_78_2 + var_0_8

			local var_78_12 = (var_78_9.last_index - 1) % 10 + 1

			var_78_11[3] = var_0_12[var_78_12]
			var_78_11[5] = var_78_12
			var_78_9.old_shown_amount = var_78_9.shown_amount
			var_78_9.shown_amount = var_78_9.shown_amount + var_78_11[1]
			var_78_9.old_shown_amount_decimal = var_78_9.shown_amount_decimal

			local var_78_13 = var_78_9.shown_amount - math.floor(var_78_9.shown_amount)
			local var_78_14 = math.floor((var_78_13 + 0.125) * 4) * 25

			var_78_9.shown_amount_decimal = var_0_9[var_78_14] or ".??"

			if var_78_9.running_parts == 0 then
				var_78_9.first_index = 1
			end

			var_78_9.running_parts = var_78_9.running_parts + 1
			var_78_9.next_increment = arg_78_2 + var_0_6
			var_78_9.scale_timer = arg_78_2 + var_0_7

			local var_78_15 = Managers.world:wwise_world(arg_78_0.world)
			local var_78_16 = var_78_10.sound_function()

			if var_78_16 then
				WwiseWorld.trigger_event(var_78_15, var_78_16)
			end

			var_78_9.text = var_78_9.target_name
			var_78_9.remove_time = arg_78_2 + var_0_8

			local var_78_17, var_78_18 = UIFontByResolution(var_78_8.text)

			var_78_9.text_width = UIRenderer.text_size(var_78_2, var_78_9.text, var_78_17[1], var_78_18)
		end

		local var_78_19 = var_78_9.remove_time - arg_78_2
		local var_78_20 = UISettings.damage_feedback.fade_duration
		local var_78_21 = 255 * math.clamp(var_78_19 / var_78_20, 0, 1)

		var_78_7.text = var_78_9.text
		var_78_7.icon_texture = var_78_9.icon_texture
		var_78_8.text.text_color[1] = var_78_21
		var_78_8.text.offset[1] = var_78_9.text_width * 0.5

		local var_78_22 = 0
		local var_78_23 = 0
		local var_78_24 = 0

		if var_78_9.scale_timer then
			if arg_78_2 <= var_78_9.scale_timer then
				var_78_22 = math.clamp((var_78_9.scale_timer - arg_78_2) / var_0_7, 0, 1)
				var_78_23 = var_78_22 > 0.5 and 0.7 or 0
				var_78_24 = math.ease_pulse(var_78_22)
			else
				var_78_9.scale_timer = nil
			end
		end

		var_78_9.text_total_sum = var_78_22 > 0.5 and var_78_9.old_shown_amount or var_78_9.shown_amount

		local var_78_25, var_78_26 = UIFontByResolution(var_78_6.style.text_total_sum)

		var_78_9.text_width_total_sum = UIRenderer.text_size(var_78_2, math.floor(var_78_9.text_total_sum), var_78_25[1], var_78_26)

		local var_78_27 = DamageUtils.get_color_from_damage(var_78_9.text_total_sum)
		local var_78_28 = 24

		var_78_8.text_total_sum.font_size = var_78_28 + 10 * var_78_24

		local var_78_29 = var_78_28 * #tostring("99.99") * 0.2
		local var_78_30 = var_78_8.text.offset[1] + var_78_9.text_width * 0.5 + var_78_29

		var_78_8.text_total_sum.offset[1] = var_78_30
		var_78_8.text_total_sum.text_color = var_78_27
		var_78_8.text_total_sum.text_color[1] = math.clamp(var_78_21, 1, 254)

		local var_78_31 = var_78_8.damage_icon

		var_78_31.color = var_78_27

		local var_78_32 = 24 + 10 * var_78_24 * var_78_23

		var_78_31.size[1] = var_78_32
		var_78_31.size[2] = var_78_32
		var_78_6.content.text_total_sum = math.floor(var_78_9.text_total_sum)
		var_78_9.text_total_sum_decimal_part = var_78_22 > 0.5 and var_78_9.old_shown_amount_decimal or var_78_9.shown_amount_decimal
		var_78_6.content.text_total_sum_decimal_part = var_78_9.text_total_sum_decimal_part
		var_78_8.text_total_sum_decimal_part.offset[1] = var_78_30 + var_78_9.text_width_total_sum * 0.5
		var_78_8.text_total_sum_decimal_part.text_color = var_78_8.text_total_sum.text_color

		local var_78_33 = var_78_30 + var_78_29
		local var_78_34 = var_78_9.dmg_parts
		local var_78_35 = var_78_9.first_index

		if var_78_9.running_parts > 0 then
			if arg_78_2 > var_78_34[var_78_35][2] then
				local var_78_36 = var_78_34[var_78_35]

				var_78_8[var_78_36[3]].text_color[1] = 0
				var_78_36[2] = math.huge
				var_78_35 = var_78_35 + 1
				var_78_9.first_index = var_78_35
				var_78_9.running_parts = var_78_9.running_parts - 1
			end

			local var_78_37 = var_78_35
			local var_78_38 = var_78_9.last_index
			local var_78_39 = 1

			for iter_78_1 = var_78_37, var_78_38 do
				local var_78_40 = var_78_34[iter_78_1]
				local var_78_41 = var_78_40[4]
				local var_78_42 = var_78_40[2]
				local var_78_43 = var_78_40[3]
				local var_78_44 = var_78_8[var_78_43]
				local var_78_45 = math.clamp((var_78_42 - arg_78_2) / var_0_8, 0, 1)

				var_78_44.offset[1] = var_78_33 + math.easeOutCubic(1 - var_78_45) * 200
				var_78_44.text_color[2] = var_78_27[2]
				var_78_44.text_color[3] = var_78_27[3]
				var_78_44.text_color[4] = var_78_27[4]
				var_78_44.text_color[1] = var_78_45 * var_78_45 * 255
				var_78_7[var_78_43] = var_78_41
				var_78_39 = var_78_39 + 1
			end
		end
	end

	UIRenderer.begin_pass(var_78_2, var_78_3, var_78_4, arg_78_1)

	for iter_78_2, iter_78_3 in pairs(arg_78_0._hash_widget_lookup) do
		UIRenderer.draw_widget(var_78_2, iter_78_3)
	end

	UIRenderer.end_pass(var_78_2)

	return true
end
