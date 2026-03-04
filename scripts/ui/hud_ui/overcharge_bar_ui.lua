-- chunkname: @scripts/ui/hud_ui/overcharge_bar_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/overcharge_bar_ui_definitions")

OverchargeBarUI = class(OverchargeBarUI)

local var_0_1 = {
	slot_ranged = true,
	slot_melee = true
}
local var_0_2 = {
	material = "overcharge_bar",
	color_normal = {
		255,
		255,
		255,
		255
	},
	color_medium = {
		255,
		255,
		165,
		0
	},
	color_high = {
		255,
		255,
		0,
		0
	}
}
local var_0_3 = 0.5

OverchargeBarUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.platform = PLATFORM
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.slot_equip_animations = {}
	arg_1_0.slot_animations = {}
	arg_1_0.ui_animations = {}

	arg_1_0:create_ui_elements()

	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._previous_overcharge_fraction = 0
	arg_1_0._keep_at_0_t = 0
	arg_1_0._is_spectator = false
	arg_1_0._spectated_player = nil
	arg_1_0._spectated_player_unit = nil

	Managers.state.event:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
end

local function var_0_4(arg_2_0)
	local var_2_0 = ScriptUnit.extension(arg_2_0, "overcharge_system")
	local var_2_1 = var_2_0:lerped_overcharge_fraction()
	local var_2_2 = var_2_0:threshold_fraction()
	local var_2_3 = var_2_0:get_anim_blend_overcharge()

	return var_2_1, var_2_2, 0.8, var_2_3
end

OverchargeBarUI.on_spectator_target_changed = function (arg_3_0, arg_3_1)
	arg_3_0._spectated_player_unit = arg_3_1
	arg_3_0._spectated_player = Managers.player:owner(arg_3_1)
	arg_3_0._is_spectator = true
end

OverchargeBarUI._set_player_extensions = function (arg_4_0, arg_4_1)
	arg_4_0.inventory_extension = ScriptUnit.extension(arg_4_1, "inventory_system")
	arg_4_0.initialize_charge_bar = true
end

OverchargeBarUI._update_overcharge = function (arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_1 then
		return
	end

	local var_5_0 = arg_5_1.player_unit

	if not Unit.alive(var_5_0) then
		return
	end

	if not ScriptUnit.has_extension(var_5_0, "overcharge_system") then
		return
	end

	local var_5_1 = ScriptUnit.extension(var_5_0, "inventory_system"):equipment()

	if not var_5_1 then
		return
	end

	local var_5_2 = var_5_1.wielded
	local var_5_3 = InventorySettings.slots

	for iter_5_0, iter_5_1 in ipairs(var_5_3) do
		local var_5_4 = iter_5_1.name

		if var_0_1[var_5_4] then
			local var_5_5 = var_5_1.slots[var_5_4]

			if var_5_5 then
				local var_5_6 = var_5_5.item_data
				local var_5_7 = var_5_6.name
				local var_5_8

				var_5_8 = var_5_2 == var_5_6

				local var_5_9, var_5_10, var_5_11, var_5_12 = var_0_4(var_5_0)
				local var_5_13 = var_5_9 and var_5_9 > 0

				if var_5_13 or arg_5_2 < arg_5_0._keep_at_0_t then
					if not arg_5_0.wielded_item_name or arg_5_0.wielded_item_name ~= var_5_7 then
						arg_5_0.wielded_item_name = var_5_7
					end

					local var_5_14 = ScriptUnit.extension(var_5_0, "overcharge_system"):get_max_value()

					arg_5_0:update_bar_size(var_5_14, var_5_10, var_5_11)
					arg_5_0:set_charge_bar_fraction(arg_5_1, var_5_9, var_5_10, var_5_11, var_5_12)

					if var_5_13 then
						arg_5_0._keep_at_0_t = arg_5_2 + var_0_3
					end

					return true
				end
			end
		end
	end
end

OverchargeBarUI.create_ui_elements = function (arg_6_0)
	UIRenderer.clear_scenegraph_queue(arg_6_0.ui_renderer)

	arg_6_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_6_0

	arg_6_0._party = Managers.party:get_local_player_party()
	arg_6_0._side = Managers.state.side.side_by_party[arg_6_0._party]

	if arg_6_0._side and arg_6_0._side:name() == "dark_pact" then
		var_6_0 = UIWidgets.create_dark_pact_overcharge_bar_widget("charge_bar_dark_pact", nil, nil, nil, nil, var_0_0.DEFAULT_DARK_PACT_BAR_SIZE)
	else
		var_6_0 = UIWidgets.create_overcharge_bar_widget("charge_bar", nil, nil, nil, nil, var_0_0.DEFAULT_BAR_SIZE)
	end

	arg_6_0.charge_bar = UIWidget.init(var_6_0)
end

local var_0_5 = {
	root_scenegraph_id = "screen_bottom_pivot_parent",
	label = "Overcharge",
	registry_key = "overcharge",
	drag_scenegraph_id = "charge_bar"
}

OverchargeBarUI.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0.input_manager
	local var_7_3 = var_7_2:get_service("ingame_menu")
	local var_7_4 = var_7_2:is_device_active("gamepad")
	local var_7_5 = arg_7_0._is_spectator and arg_7_0._spectated_player or arg_7_3

	if HudCustomizer.run(var_7_0, var_7_1, var_0_5) then
		UISceneGraph.update_scenegraph(var_7_1)
	end

	local var_7_6 = arg_7_0:_update_overcharge(var_7_5, arg_7_2)
	local var_7_7 = Managers.twitch:is_activated()

	if var_7_7 ~= arg_7_0._has_twitch then
		arg_7_0.charge_bar.offset[2] = var_7_7 and 140 or 0
		arg_7_0._has_twitch = var_7_7
		var_7_6 = true
	end

	if var_7_6 then
		local var_7_8, var_7_9 = arg_7_0._parent:get_crosshair_position()

		arg_7_0:_apply_crosshair_position(var_7_8, var_7_9)
		UIRenderer.begin_pass(var_7_0, var_7_1, var_7_3, arg_7_1, nil, arg_7_0.render_settings)
		UIRenderer.draw_widget(var_7_0, arg_7_0.charge_bar)
		UIRenderer.end_pass(var_7_0)
	end
end

OverchargeBarUI.update_bar_size = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._side:name() == "dark_pact" and var_0_0.DEFAULT_DARK_PACT_BAR_SIZE[1] or var_0_0.DEFAULT_BAR_SIZE[1]
	local var_8_1 = math.remap(0, 40, 0, var_8_0, arg_8_1)
	local var_8_2 = arg_8_0.charge_bar

	var_8_2.content.size[1] = var_8_1 - 6

	local var_8_3 = var_8_2.style

	if var_8_3.frame then
		var_8_3.frame.size[1] = var_8_1
	end

	var_8_3.bar_1.size[1] = var_8_1 - 6
	var_8_3.icon.offset[1] = var_8_1
	var_8_3.icon_shadow.offset[1] = var_8_1 + 2

	if var_8_3.bar_bg then
		var_8_3.bar_bg.size[1] = var_8_1 - 6
	end

	var_8_3.bar_fg.size[1] = var_8_1

	if var_8_3.min_threshold or var_8_3.max_threshold then
		var_8_3.min_threshold.offset[1] = 3 + arg_8_2 * var_8_1
		var_8_3.max_threshold.offset[1] = 3 + arg_8_3 * var_8_1
	end

	arg_8_0.ui_scenegraph.charge_bar.size[1] = var_8_1
end

OverchargeBarUI.set_charge_bar_fraction = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_0.charge_bar
	local var_9_1 = var_9_0.style
	local var_9_2 = var_9_0.content

	arg_9_2 = math.lerp(var_9_2.internal_gradient_threshold or 0, math.min(arg_9_2, 1), 0.3)
	var_9_2.internal_gradient_threshold = arg_9_2
	var_9_1.bar_1.gradient_threshold = arg_9_2

	local var_9_3 = 1
	local var_9_4
	local var_9_5 = var_9_1.icon.color
	local var_9_6 = var_9_1.bar_1.color
	local var_9_7 = arg_9_1:career_name()
	local var_9_8 = OverchargeData[var_9_7]
	local var_9_9 = var_9_8 and var_9_8.overcharge_ui or var_0_2

	var_9_2.bar_1 = var_9_9.material

	if arg_9_2 <= arg_9_3 then
		var_9_4 = var_9_9.color_normal
		var_9_3 = 0.6
	elseif arg_9_2 <= arg_9_4 then
		var_9_3 = 0.8
		var_9_4 = var_9_9.color_medium
	else
		var_9_4 = var_9_9.color_high
	end

	var_9_6[1] = var_9_4[1] * var_9_3
	var_9_6[2] = var_9_4[2]
	var_9_6[3] = var_9_4[3]
	var_9_6[4] = var_9_4[4]

	local var_9_10 = 10
	local var_9_11 = math.min(math.max(arg_9_2 - arg_9_4, 0) / (1 - arg_9_4) * 1.3, 1)
	local var_9_12 = (100 + (0.5 + math.sin(Managers.time:time("ui") * var_9_10) * 0.5) * 155) * var_9_11

	if var_9_1.frame then
		var_9_1.frame.color[1] = var_9_12
	end

	var_9_5[1] = var_9_12
	var_9_5[2] = var_9_4[2]
	var_9_5[3] = var_9_4[3]
	var_9_5[4] = var_9_4[4]
end

OverchargeBarUI.destroy = function (arg_10_0)
	Managers.state.event:unregister("on_spectator_target_changed", arg_10_0)
end

OverchargeBarUI.set_alpha = function (arg_11_0, arg_11_1)
	arg_11_0.render_settings.alpha_multiplier = arg_11_1
end

OverchargeBarUI._apply_crosshair_position = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = "screen_bottom_pivot"
	local var_12_1 = arg_12_0.ui_scenegraph[var_12_0].local_position

	var_12_1[1] = arg_12_1
	var_12_1[2] = arg_12_2
end
