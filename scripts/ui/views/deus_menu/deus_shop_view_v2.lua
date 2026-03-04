-- chunkname: @scripts/ui/views/deus_menu/deus_shop_view_v2.lua

require("scripts/network/shared_state")

local var_0_0 = local_require("scripts/ui/views/deus_menu/deus_shop_view_definitions_v2")
local var_0_1 = var_0_0.interaction_data
local var_0_2 = var_0_0.purchase_interaction
local var_0_3 = var_0_0.allow_boon_removal
local var_0_4 = 1
local var_0_5 = 2
local var_0_6 = 3
local var_0_7 = 4
local var_0_8 = 5
local var_0_9 = {
	[var_0_4] = {
		unit_package = "units/props/deus_idol/deus_sigmar_01",
		unit_name = "units/props/deus_idol/deus_sigmar_01"
	},
	[var_0_5] = {
		unit_package = "units/props/deus_idol/deus_myrmidia_01",
		unit_name = "units/props/deus_idol/deus_myrmidia_01"
	},
	[var_0_6] = {
		unit_package = "units/props/deus_idol/deus_valaya_01",
		unit_name = "units/props/deus_idol/deus_valaya_01"
	},
	[var_0_7] = {
		unit_package = "units/props/deus_idol/deus_lileath_01",
		unit_name = "units/props/deus_idol/deus_lileath_01"
	},
	[var_0_8] = {
		unit_package = "units/props/deus_idol/deus_taal_01",
		unit_name = "units/props/deus_idol/deus_taal_01"
	}
}
local var_0_10 = {
	blessing_bought = "hud_morris_map_shrine_buy_blessing",
	power_up_bought = "hud_morris_map_shrine_buy_power_up",
	button_hover = "hud_morris_hover",
	ready_pressed = "hud_morris_close"
}

require("scripts/settings/dlcs/morris/deus_cost_settings")
require("scripts/settings/dlcs/morris/deus_shop_settings")

DeusShopView = class(DeusShopView)

local var_0_11 = 1
local var_0_12 = 60
local var_0_13 = 5
local var_0_14 = 15
local var_0_15 = {
	FINISHED = 5,
	SELECTING = 3,
	INITIALIZED = 1,
	FINISHING = 4,
	STARTING = 2
}
local var_0_16 = {
	READY_TO_BUY = 1,
	DONE_BUYING = 2
}
local var_0_17 = {
	server = {
		shop_state = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		}
	},
	peer = {
		peer_state = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		}
	}
}

SharedState.validate_spec(var_0_17)

local function var_0_18(arg_1_0)
	local var_1_0 = UISettings.inventory_consumable_slot_colors.default

	return arg_1_0 and UISettings.inventory_consumable_slot_colors[arg_1_0] or var_1_0
end

function DeusShopView.init(arg_2_0, arg_2_1)
	local var_2_0 = "deus_shop_view"
	local var_2_1 = arg_2_1.input_manager

	arg_2_0._input_manager = var_2_1
	arg_2_0._world = arg_2_1.world
	arg_2_0._network_event_delegate = arg_2_1.network_event_delegate
	arg_2_0._input_service_name = var_2_0
	arg_2_0._previous_bought_blessings = {}

	var_2_1:create_input_service(var_2_0, "IngameMenuKeymaps", "IngameMenuFilters")
	var_2_1:map_device_to_service(var_2_0, "keyboard")
	var_2_1:map_device_to_service(var_2_0, "mouse")
	var_2_1:map_device_to_service(var_2_0, "gamepad")

	arg_2_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	arg_2_0.ui_renderer = arg_2_1.ui_renderer
	arg_2_0.ui_top_renderer = arg_2_1.ui_top_renderer
	arg_2_0._wwise_world = arg_2_1.wwise_world
	arg_2_0._portrait_mode = false
	arg_2_0._is_server = arg_2_1.is_server
	arg_2_0._deus_run_controller = arg_2_1.deus_run_controller

	local var_2_2 = arg_2_0._deus_run_controller:get_server_peer_id()
	local var_2_3 = arg_2_0._deus_run_controller:get_own_peer_id()

	arg_2_0._shared_state = SharedState:new("deus_shop_" .. arg_2_0._deus_run_controller:get_run_id(), var_0_17, arg_2_0._is_server, arg_2_1.network_server, var_2_2, var_2_3)

	arg_2_0._shared_state:full_sync()

	if arg_2_0._is_server then
		arg_2_0._shared_state:set_server(arg_2_0._shared_state:get_key("shop_state"), var_0_15.INITIALIZED)

		arg_2_0._human_player_vo_units = {}
	end

	local var_2_4 = Managers.state.event

	var_2_4:register(arg_2_0, "ingame_menu_opened", "on_ingame_menu_opened")
	var_2_4:register(arg_2_0, "ingame_menu_closed", "on_ingame_menu_closed")
end

function DeusShopView._set_camera_node(arg_3_0, arg_3_1)
	local var_3_0 = Managers.player:local_player().camera_follow_unit

	Unit.set_data(var_3_0, "camera", "settings_node", arg_3_1)
end

function DeusShopView.start(arg_4_0, arg_4_1)
	fassert(arg_4_1, "DeusShopView needs params to be set in order to function properly, see GameModeMapDeus")

	arg_4_0._finished = false
	arg_4_0._finish_cb = arg_4_1.finish_cb

	arg_4_0:_set_camera_node("map_deus")
	arg_4_0:_acquire_input()

	arg_4_0._render_top_widgets = true
	arg_4_0._selecting_countdown = nil
	arg_4_0._final_countdown = var_0_13

	arg_4_0._shared_state:set_own(arg_4_0._shared_state:get_key("peer_state"), var_0_16.READY_TO_BUY)

	if arg_4_0._is_server then
		arg_4_0._shared_state:set_server(arg_4_0._shared_state:get_key("shop_state"), var_0_15.STARTING)

		local var_4_0 = arg_4_0._deus_run_controller:get_peers()

		for iter_4_0, iter_4_1 in pairs(var_4_0) do
			local var_4_1 = arg_4_0._deus_run_controller:get_player_profile(iter_4_1, var_0_11)

			if var_4_1 then
				local var_4_2 = SPProfiles[var_4_1].character_vo

				if var_4_2 then
					arg_4_0._human_player_vo_units[iter_4_1] = Managers.state.unit_spawner:spawn_network_unit("units/hub_elements/empty", "dialogue_node", {
						dialogue_system = {
							faction = "player",
							dialogue_profile = var_4_2
						}
					})
				end
			end
		end
	end

	arg_4_0._shop_type = arg_4_0._deus_run_controller:get_current_node().level
	arg_4_0._shop_config = DeusShopSettings.shop_types[arg_4_0._shop_type]
	arg_4_0._available_blessings = arg_4_0._shop_config.blessings
	arg_4_0._available_power_ups = arg_4_0._deus_run_controller:generate_random_power_ups(arg_4_0._shop_config.power_up_count, DeusPowerUpAvailabilityTypes.shrine)

	local var_4_3 = arg_4_0._deus_run_controller:get_own_peer_id()
	local var_4_4, var_4_5 = arg_4_0._deus_run_controller:get_player_profile(var_4_3, var_0_11)
	local var_4_6 = var_0_9[var_4_4]

	arg_4_0:_create_ui_elements(arg_4_0._shop_config, arg_4_0._available_power_ups, arg_4_0._available_blessings, var_4_6)

	local var_4_7 = LevelHelper:find_dialogue_unit(arg_4_0._world, "ferry_lady_01")
	local var_4_8 = ScriptUnit.extension_input(var_4_7, "dialogue_system")
	local var_4_9 = FrameTable.alloc_table()

	var_4_8:trigger_dialogue_event("deus_shrine_tutorial", var_4_9)

	arg_4_0._telemetry_data = {
		store_type = arg_4_0._shop_type,
		purchased_blessings = {},
		purchased_boons = {},
		currency_when_entered = arg_4_0._deus_run_controller:get_player_soft_currency(var_4_3),
		run_id = arg_4_0._deus_run_controller:get_run_id()
	}
end

function DeusShopView.register_rpcs(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._shared_state:register_rpcs(arg_5_1)
end

function DeusShopView.unregister_rpcs(arg_6_0)
	arg_6_0._shared_state:unregister_rpcs()
end

function DeusShopView._create_ui_elements(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	arg_7_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_7_0._ui_animator = UIAnimator:new(arg_7_0.ui_scenegraph, var_0_0.animations_definitions)

	local var_7_0 = {}
	local var_7_1 = {}

	for iter_7_0, iter_7_1 in pairs(var_0_0.widgets) do
		if iter_7_1 then
			local var_7_2 = UIWidget.init(iter_7_1)

			var_7_0[#var_7_0 + 1] = var_7_2
			var_7_1[iter_7_0] = var_7_2
		end
	end

	var_7_1.bottom_text.content.text = Localize("deus_shrine_continue_info")
	var_7_1.ready_button.content.title_text = Localize("deus_ready_button")

	local var_7_3 = {}

	for iter_7_2, iter_7_3 in pairs(var_0_0.top_widgets) do
		if iter_7_3 then
			local var_7_4 = UIWidget.init(iter_7_3)

			var_7_3[#var_7_3 + 1] = var_7_4
			var_7_1[iter_7_2] = var_7_4
		end
	end

	local var_7_5 = {}

	for iter_7_4, iter_7_5 in pairs(var_0_0.player_widgets) do
		if iter_7_5 then
			local var_7_6 = UIWidget.init(iter_7_5)

			var_7_5[#var_7_5 + 1] = var_7_6
			var_7_0[#var_7_0 + 1] = var_7_6
			var_7_1[iter_7_4] = var_7_6
		end
	end

	local var_7_7 = arg_7_0._deus_run_controller:get_own_peer_id()
	local var_7_8, var_7_9 = arg_7_0._deus_run_controller:get_player_profile(var_7_7, var_0_11)
	local var_7_10 = {
		power_ups = {},
		blessings = {}
	}
	local var_7_11 = DeusPowerUpTemplates
	local var_7_12 = {}
	local var_7_13 = #arg_7_2

	for iter_7_6 = 1, var_7_13 do
		local var_7_14 = arg_7_2[iter_7_6]
		local var_7_15 = var_7_11[var_7_14.name].rectangular_icon
		local var_7_16 = var_0_0.scenegraph_definition.power_up_root.size
		local var_7_17 = var_0_0.create_power_up_shop_item("power_up_root", var_7_16, false, var_7_15)
		local var_7_18 = UIWidget.init(var_7_17)
		local var_7_19 = iter_7_6 - 1
		local var_7_20 = var_7_13 - 1
		local var_7_21 = math.rad(var_7_19 / var_7_20 * 180)
		local var_7_22 = 60
		local var_7_23 = 0
		local var_7_24 = ((var_7_16[2] + var_7_23) * var_7_13 + var_7_16[2]) / 2

		var_7_18.offset = {
			var_7_22 * math.sin(var_7_21),
			var_7_24 - (var_7_23 + var_7_16[2]) * iter_7_6,
			0
		}

		local var_7_25 = iter_7_6 <= arg_7_1.max_discounts and arg_7_1.power_up_discount
		local var_7_26
		local var_7_27 = 0

		arg_7_0:_init_power_up_widget(var_7_18, var_7_14, var_7_25, var_7_27, var_7_26, var_7_8, var_7_9)

		var_7_0[#var_7_0 + 1] = var_7_18
		var_7_12[#var_7_12 + 1] = var_7_18
		var_7_1["power_up_item_" .. iter_7_6] = var_7_18
		var_7_10.power_ups[#var_7_10.power_ups + 1] = {
			widget = var_7_18,
			power_up = var_7_14,
			discount = var_7_25
		}
	end

	local var_7_28 = {}
	local var_7_29 = #arg_7_3

	for iter_7_7 = 1, var_7_29 do
		local var_7_30 = var_0_0.scenegraph_definition.blessing_root.size
		local var_7_31 = var_0_0.create_blessing_shop_item("blessing_root", var_7_30, false)
		local var_7_32 = UIWidget.init(var_7_31)
		local var_7_33 = 15
		local var_7_34 = ((var_7_30[2] + var_7_33) * var_7_29 + var_7_30[2]) / 2

		var_7_32.offset = {
			0,
			var_7_34 - (var_7_33 + var_7_30[2]) * iter_7_7,
			0
		}

		local var_7_35 = arg_7_3[iter_7_7]
		local var_7_36 = var_7_32.offset
		local var_7_37 = {
			541,
			75,
			10
		}
		local var_7_38 = {
			var_7_36[1] + var_7_37[1],
			var_7_36[2] + var_7_37[2],
			var_7_36[3] + var_7_37[3]
		}
		local var_7_39 = var_0_0.create_blessing_portraits_frame("blessing_root", "default", "-", false, var_7_38)
		local var_7_40 = UIWidget.init(var_7_39)

		var_7_32.content.frame_index = iter_7_7
		var_7_28[#var_7_28 + 1] = var_7_40
		var_7_1[var_7_35 .. "_portrait_frame_" .. iter_7_7] = var_7_40

		arg_7_0:_init_blessing_widget(var_7_32, var_7_35)

		var_7_0[#var_7_0 + 1] = var_7_32
		var_7_12[#var_7_12 + 1] = var_7_32
		var_7_1["blessing_item_" .. iter_7_7] = var_7_32
		var_7_10.blessings[#var_7_10.blessings + 1] = {
			widget = var_7_32,
			blessing_name = var_7_35
		}
	end

	local var_7_41 = arg_7_0._deus_run_controller:get_peers()
	local var_7_42 = {}

	for iter_7_8 = 1, 4 do
		local var_7_43 = "player_portrait_frame_" .. iter_7_8
		local var_7_44
		local var_7_45

		if var_7_41[iter_7_8] then
			local var_7_46, var_7_47 = arg_7_0._deus_run_controller:get_player_profile(var_7_41[iter_7_8], var_0_11)
			local var_7_48 = arg_7_0._deus_run_controller:get_player_level(var_7_41[iter_7_8], var_7_46) or "n/a"
			local var_7_49 = arg_7_0._deus_run_controller:get_player_frame(var_7_41[iter_7_8], var_7_46, var_7_47)

			var_7_44 = UIWidgets.deus_create_player_portraits_frame("player_portrait_" .. iter_7_8, var_7_49, var_7_48, false)
		else
			var_7_44 = UIWidgets.deus_create_player_portraits_frame("player_portrait_" .. iter_7_8, "default", " ", false)
		end

		local var_7_50 = UIWidget.init(var_7_44)

		var_7_42[#var_7_42 + 1] = var_7_50
		var_7_1[var_7_43] = var_7_50
	end

	arg_7_0._blessing_frame_widgets = var_7_28
	arg_7_0._portrait_frame_widgets = var_7_42
	arg_7_0._shop_items = var_7_10
	arg_7_0._shop_item_widgets = var_7_12
	arg_7_0._widgets = var_7_0
	arg_7_0._top_widgets = var_7_3
	arg_7_0._widgets_by_name = var_7_1

	UIRenderer.clear_scenegraph_queue(arg_7_0.ui_renderer)

	if arg_7_4 then
		local var_7_51 = arg_7_0:_create_background_unit_definition()

		arg_7_0._background_unit_widget = UIWidget.init(var_7_51)

		local var_7_52 = arg_7_4.unit_name
		local var_7_53 = arg_7_4.unit_package

		arg_7_0._unit_previewer = arg_7_0:_create_unit_previewer(arg_7_0._background_unit_widget, var_7_52, var_7_53)

		arg_7_0._unit_previewer:set_zoom_fraction_unclamped(-0.2)
	end

	arg_7_0._purchased_boons = arg_7_0._purchased_boons or {}
	arg_7_0._total_num_power_ups = nil

	arg_7_0:_update_power_ups()
end

function DeusShopView.update(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._shared_state:get_server(arg_8_0._shared_state:get_key("shop_state"))

	arg_8_0:_update_countdowns(var_8_0, arg_8_1, arg_8_2)

	if arg_8_0._is_server then
		local var_8_1 = arg_8_0:_check_transition(var_8_0)

		if var_8_1 ~= var_8_0 then
			arg_8_0._shared_state:set_server(arg_8_0._shared_state:get_key("shop_state"), var_8_1)

			var_8_0 = var_8_1
		end
	end

	if var_8_0 == var_0_15.STARTING then
		arg_8_0:_update_during_starting(arg_8_1, arg_8_2)
	elseif var_8_0 == var_0_15.SELECTING then
		arg_8_0:_update_during_selecting(arg_8_1, arg_8_2)
	elseif var_8_0 == var_0_15.FINISHING then
		arg_8_0:_update_during_finishing(arg_8_1, arg_8_2)
	elseif var_8_0 == var_0_15.FINISHED and not arg_8_0._finished then
		arg_8_0:_finish()

		arg_8_0._finished = true
	end

	local var_8_2 = arg_8_0._unit_previewer

	if var_8_2 then
		var_8_2:update(arg_8_1, arg_8_2, false)
	end

	arg_8_0:_handle_mode_input(arg_8_1, arg_8_2)
	arg_8_0:_update_player_data()
	arg_8_0:_update_hold_text()
	arg_8_0:_update_input_helper_text(arg_8_1, arg_8_2)
	arg_8_0:_update_background_animations(arg_8_1)
	arg_8_0:_update_animations(arg_8_1)
	arg_8_0:_update_power_ups()
	arg_8_0:_draw(arg_8_1, arg_8_2)
end

function DeusShopView._handle_mode_input(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0:input_service():get("cycle_next_raw") then
		if not arg_9_0._ui_animator:is_animation_completed(arg_9_0._anim_id) then
			arg_9_0._ui_animator:stop_animation(arg_9_0._anim_id)
		end

		arg_9_0._anim_id = arg_9_0._ui_animator:start_animation(arg_9_0._portrait_mode and "switch_to_boons" or "switch_to_portraits", arg_9_0._widgets_by_name, var_0_0.scenegraph_definition)
		arg_9_0._portrait_mode = not arg_9_0._portrait_mode
	end
end

function DeusShopView._update_power_ups(arg_10_0)
	local var_10_0 = arg_10_0._deus_run_controller
	local var_10_1 = var_10_0:get_own_peer_id()
	local var_10_2 = var_10_0:get_player_power_ups(var_10_1, var_0_11)
	local var_10_3 = var_10_0:get_party_power_ups()
	local var_10_4, var_10_5 = var_10_0:get_player_profile(var_10_1, var_0_11)
	local var_10_6 = #var_10_2 + #var_10_3

	if var_10_6 ~= arg_10_0._total_num_power_ups then
		local var_10_7 = {}

		if var_10_6 > 0 then
			local var_10_8 = Managers.mechanism:game_mechanism():get_deus_run_controller():get_own_initial_talents()[SPProfiles[var_10_4].careers[var_10_5].name]
			local var_10_9 = {}

			for iter_10_0 = 1, #var_10_8 do
				local var_10_10 = var_10_8[iter_10_0]

				if var_10_10 ~= 0 then
					local var_10_11, var_10_12 = DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(iter_10_0, var_10_10)

					var_10_9[var_10_11.name] = true
				end
			end

			local var_10_13 = RaritySettings

			table.sort(var_10_2, function(arg_11_0, arg_11_1)
				local var_11_0 = var_10_13[arg_11_0.rarity].order
				local var_11_1 = var_10_13[arg_11_1.rarity].order

				if var_11_0 == var_11_1 then
					return arg_11_0.name < arg_11_1.name
				else
					return var_11_1 < var_11_0
				end
			end)

			local var_10_14 = DeusPowerUpTemplates
			local var_10_15 = #var_10_2 + #var_10_3
			local var_10_16 = Managers.time:time("main") * 2

			for iter_10_1 = 1, var_10_15 do
				local var_10_17
				local var_10_18 = false

				if iter_10_1 <= #var_10_2 then
					var_10_17 = var_10_2[iter_10_1]
				else
					var_10_17 = var_10_3[iter_10_1 - #var_10_2]
					var_10_18 = true
				end

				local var_10_19 = DeusPowerUps[var_10_17.rarity][var_10_17.name]
				local var_10_20, var_10_21 = DeusPowerUpUtils.get_power_up_name_text(var_10_19.name, var_10_19.talent_index, var_10_19.talent_tier, var_10_4, var_10_5)
				local var_10_22 = DeusPowerUpUtils.get_power_up_icon(var_10_19, var_10_4, var_10_5)
				local var_10_23 = Colors.get_table(var_10_19.rarity)
				local var_10_24 = var_10_14[var_10_19.name].rectangular_icon
				local var_10_25 = var_10_24 and var_0_0.rectangular_power_up_widget_data or var_0_0.round_power_up_widget_data
				local var_10_26 = true
				local var_10_27 = true
				local var_10_28 = {
					color = {
						255,
						138,
						172,
						235
					},
					offset = var_0_0.rectangular_power_up_widget_data.icon_offset,
					texture_size = var_0_0.rectangular_power_up_widget_data.icon_size
				}
				local var_10_29 = "own_power_up_anchor"
				local var_10_30 = UIWidgets.create_icon_info_box(var_10_29, var_10_22, var_10_25.icon_size, var_10_25.icon_offset, var_10_25.background_icon, var_10_25.background_icon_size, var_10_25.background_icon_offset, var_10_21, var_10_20, var_10_23, var_10_25.width, var_10_24, var_10_26, var_10_27, var_10_28)
				local var_10_31 = UIWidget.init(var_10_30)

				var_10_31.content.power_up_name = var_10_19.name
				var_10_31.content.power_up_rarity = var_10_19.rarity
				var_10_31.content.locked = var_10_18 or var_10_9[var_10_19.name] or arg_10_0._purchased_boons[var_10_19.name]
				var_10_31.content.locked_text_id = var_10_18 and "party_locked" or var_10_9[var_10_19.name] and "talent_locked" or arg_10_0._purchased_boons[var_10_19.name] and "deus_shrine_unlocked" or "search_filter_locked"

				local var_10_32 = (iter_10_1 - 1) % 2

				var_10_31.offset[1] = var_10_32 * (var_0_0.power_up_widget_size[1] + var_0_0.power_up_widget_spacing[1])
				var_10_31.offset[2] = -math.floor((iter_10_1 - 1) / 2) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2])
				var_10_7[#var_10_7 + 1] = var_10_31
				arg_10_0._widgets_by_name[var_10_29] = var_10_31
			end
		end

		arg_10_0._total_num_power_ups = var_10_6
		arg_10_0._power_up_widgets = var_10_7
		arg_10_0._power_ups = var_10_2
		arg_10_0._party_power_ups = var_10_3

		local var_10_33 = math.ceil(arg_10_0._total_num_power_ups / 2) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2]) - arg_10_0.ui_scenegraph.own_power_up_window.size[2]

		if var_10_33 > 0 then
			local var_10_34 = arg_10_0.ui_scenegraph
			local var_10_35 = "own_power_up_anchor"
			local var_10_36 = "own_power_up_window"
			local var_10_37 = var_10_33
			local var_10_38 = false
			local var_10_39
			local var_10_40
			local var_10_41 = true

			arg_10_0._scrollbar_ui = ScrollbarUI:new(var_10_34, var_10_35, var_10_36, var_10_37, var_10_38, var_10_39, var_10_40, var_10_41)
		else
			arg_10_0._scrollbar_ui = nil
		end
	end
end

function DeusShopView.post_update(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0._unit_previewer then
		arg_12_0._unit_previewer:post_update(arg_12_1, arg_12_2)
	end
end

function DeusShopView._update_animations(arg_13_0, arg_13_1)
	arg_13_0._ui_animator:update(arg_13_1)
end

function DeusShopView.destroy_idol(arg_14_0)
	if arg_14_0._background_unit_widget then
		arg_14_0._unit_previewer:destroy()

		arg_14_0._unit_previewer = nil

		UIWidget.destroy(arg_14_0.ui_renderer, arg_14_0._background_unit_widget)

		arg_14_0._background_unit_widget = nil
	end
end

function DeusShopView.destroy(arg_15_0)
	arg_15_0:destroy_idol()

	local var_15_0 = arg_15_0._shared_state:get_server(arg_15_0._shared_state:get_key("shop_state"))

	if var_15_0 ~= var_0_15.FINISHED and var_15_0 ~= var_0_15.INITIALIZED then
		arg_15_0:_release_input()
	end

	arg_15_0._shared_state:destroy()

	arg_15_0._shared_state = nil

	local var_15_1 = Managers.state.event

	var_15_1:unregister("ingame_menu_opened", arg_15_0)
	var_15_1:unregister("ingame_menu_closed", arg_15_0)
end

function DeusShopView.input_service(arg_16_0)
	return arg_16_0._input_manager:get_service(arg_16_0._input_service_name)
end

function DeusShopView._finish(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._finish_cb

	if var_17_0 then
		arg_17_0._finish_cb = nil

		var_17_0(arg_17_1)
	end

	arg_17_0:_release_input()
	arg_17_0:_set_camera_node("first_person_node")
	Managers.telemetry_events:store_node_traversed(arg_17_0._telemetry_data)
end

function DeusShopView._init_power_up_widget(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	local var_18_0 = DeusPowerUps[arg_18_2.rarity][arg_18_2.name]
	local var_18_1 = var_18_0.rarity
	local var_18_2 = arg_18_1.content

	var_18_2.title_text = DeusPowerUpUtils.get_power_up_name_text(var_18_0.name, var_18_0.talent_index, var_18_0.talent_tier, arg_18_6, arg_18_7)
	var_18_2.rarity_text = Localize(RaritySettings[var_18_1].display_name)
	var_18_2.sub_text = DeusPowerUpUtils.get_power_up_description(var_18_0, arg_18_6, arg_18_7)
	var_18_2.max_value_text = nil
	var_18_2.current_value_text = nil
	var_18_2.has_discount = arg_18_3
	var_18_2.icon = DeusPowerUpUtils.get_power_up_icon(var_18_0, arg_18_6, arg_18_7)

	local var_18_3 = DeusCostSettings.shop.power_ups[var_18_1] or 9001

	if arg_18_3 then
		var_18_3 = var_18_3 - var_18_3 * arg_18_3
	end

	var_18_2.price_text = tostring(var_18_3)

	local var_18_4 = arg_18_1.style
	local var_18_5 = Colors.get_table(var_18_1)

	var_18_4.rarity_text.text_color = var_18_5

	if arg_18_3 then
		var_18_4.price_text.text_color = var_0_0.discount_text_color
	end

	if not arg_18_5 or not arg_18_4 then
		local var_18_6 = var_0_0.single_price_offset[2]

		var_18_4.price_icon.offset[2] = var_18_4.price_icon.offset[2] + var_18_6
		var_18_4.price_text.offset[2] = var_18_4.price_text.offset[2] + var_18_6
		var_18_4.price_text_shadow.offset[2] = var_18_4.price_text_shadow.offset[2] + var_18_6
		var_18_4.price_text_disabled.offset[2] = var_18_4.price_text_disabled.offset[2] + var_18_6
	end

	local var_18_7 = DeusPowerUpSetLookup[arg_18_2.rarity] and DeusPowerUpSetLookup[arg_18_2.rarity][arg_18_2.name]
	local var_18_8 = false

	if var_18_7 then
		local var_18_9 = var_18_7[1]
		local var_18_10 = 0
		local var_18_11 = var_18_9.pieces

		for iter_18_0, iter_18_1 in ipairs(var_18_11) do
			local var_18_12 = iter_18_1.name
			local var_18_13 = iter_18_1.rarity
			local var_18_14 = arg_18_0._deus_run_controller:get_own_peer_id()

			if arg_18_0._deus_run_controller:has_power_up_by_name(var_18_14, var_18_12, var_18_13) then
				var_18_10 = var_18_10 + 1
			end
		end

		var_18_8 = true

		local var_18_15 = var_18_9.num_required_pieces or #var_18_11

		arg_18_1.content.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), var_18_10, var_18_15)

		if #var_18_11 == var_18_10 then
			arg_18_1.style.set_progression.text_color = arg_18_1.style.set_progression.progression_colors.complete
		end
	end

	arg_18_1.content.is_part_of_set = var_18_8
end

function DeusShopView._init_blessing_widget(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_1.content
	local var_19_1 = DeusBlessingSettings[arg_19_2]

	var_19_0.title_text = Localize(var_19_1.display_name)
	var_19_0.sub_text = Localize(var_19_1.description)
	var_19_0.icon = var_19_1.shop_icon
	var_19_0.price_text = DeusCostSettings.shop.blessings[arg_19_2] or 9001
end

function DeusShopView._update_countdowns(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_1 == var_0_15.FINISHING then
		arg_20_0._final_countdown = arg_20_0._final_countdown and math.max(0, arg_20_0._final_countdown - arg_20_2) or nil
	end
end

function DeusShopView._check_transition(arg_21_0, arg_21_1)
	if arg_21_1 == var_0_15.STARTING then
		if arg_21_0:_are_all_peers_ready() then
			return var_0_15.SELECTING
		end
	elseif arg_21_1 == var_0_15.SELECTING then
		if arg_21_0._selecting_countdown == 0 or arg_21_0:_are_all_peers_done() then
			arg_21_0._selecting_countdown = 0

			return var_0_15.FINISHING
		end
	elseif arg_21_1 == var_0_15.FINISHING and arg_21_0._final_countdown == 0 then
		return var_0_15.FINISHED
	end

	return arg_21_1
end

function DeusShopView._update_during_starting(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._widgets_by_name

	var_22_0.bottom_text.content.text = Localize("deus_shrine_waiting_info")
	var_22_0.ready_button.content.button_hotspot.disable_button = true

	arg_22_0:_update_shop_widgets()
end

function DeusShopView._update_during_selecting(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._widgets_by_name

	var_23_0.bottom_text.content.text = Localize("deus_shrine_continue_info")

	local var_23_1 = arg_23_0._shared_state:get_key("peer_state")
	local var_23_2 = arg_23_0._shared_state:get_own(var_23_1) == var_0_16.DONE_BUYING

	var_23_0.ready_button.content.button_hotspot.disable_button = var_23_2

	if arg_23_0._selecting_countdown then
		local var_23_3 = arg_23_0._selecting_countdown - arg_23_1
		local var_23_4 = math.max(var_23_3, 0)

		var_23_0.timer_text.content.text = math.floor(var_23_4)

		arg_23_0:_update_vote_hurry_up(var_23_4)

		arg_23_0._selecting_countdown = var_23_4
	elseif arg_23_0:_did_someone_vote() then
		arg_23_0._selecting_countdown = var_0_12
	end

	arg_23_0:_update_shop_widgets()
	arg_23_0:_handle_input(arg_23_1, arg_23_2)
end

function DeusShopView._update_vote_hurry_up(arg_24_0, arg_24_1)
	if not arg_24_0._hurry_up_vo_played and arg_24_0._deus_run_controller:is_server() and arg_24_1 < var_0_14 then
		arg_24_0._hurry_up_vo_played = true

		local var_24_0 = arg_24_0._shared_state:get_key("peer_state")
		local var_24_1 = table.select_array(arg_24_0._deus_run_controller:get_peers(), function(arg_25_0, arg_25_1)
			if arg_24_0._human_player_vo_units[arg_25_1] and arg_24_0._shared_state:get_peer(arg_25_1, var_24_0) == var_0_16.DONE_BUYING then
				return arg_25_1
			end
		end)

		table.shuffle(var_24_1)

		if var_24_1[1] then
			local var_24_2 = arg_24_0._human_player_vo_units[var_24_1[1]]

			ScriptUnit.extension_input(var_24_2, "dialogue_system"):trigger_networked_dialogue_event("deus_shrine_hurry")
		end
	end
end

function DeusShopView._update_during_finishing(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._widgets_by_name

	var_26_0.bottom_text.content.text = Localize("deus_shrine_continue_in")
	var_26_0.ready_button.content.button_hotspot.disable_button = true
	var_26_0.timer_text.content.text = nil

	arg_26_0:_update_shop_widgets()
	arg_26_0:_handle_input(arg_26_1, arg_26_2)
end

function DeusShopView._update_shop_widgets(arg_27_0)
	local var_27_0 = arg_27_0._deus_run_controller:get_own_peer_id()
	local var_27_1 = arg_27_0._deus_run_controller:get_player_soft_currency(var_27_0)

	arg_27_0._widgets_by_name.coins_text.content.text = string.format("%d", var_27_1)

	local var_27_2 = arg_27_0._shop_items

	for iter_27_0, iter_27_1 in ipairs(var_27_2.power_ups) do
		local var_27_3 = iter_27_1.widget
		local var_27_4 = iter_27_1.power_up
		local var_27_5 = iter_27_1.discount
		local var_27_6 = arg_27_0:_get_power_up_costs(var_27_4.rarity, var_27_5)
		local var_27_7 = arg_27_0._deus_run_controller:reached_max_power_ups(var_27_0, var_27_4.name)
		local var_27_8 = arg_27_0._deus_run_controller:has_power_up(var_27_0, var_27_4.client_id)
		local var_27_9 = var_27_3.content

		if var_27_7 or var_27_8 then
			var_27_9.is_bought = true
			var_27_9.button_hotspot.disable_button = true
		elseif var_27_1 < var_27_6 then
			var_27_9.button_hotspot.disable_button = true
		else
			var_27_9.is_bought = false
			var_27_9.button_hotspot.disable_button = false
		end
	end

	local var_27_10 = arg_27_0._deus_run_controller:get_blessings_with_buyer()
	local var_27_11 = DeusCostSettings.shop.blessings

	for iter_27_2, iter_27_3 in ipairs(var_27_2.blessings) do
		local var_27_12 = iter_27_3.widget
		local var_27_13 = iter_27_3.blessing_name
		local var_27_14 = var_27_11[var_27_13] or 9001
		local var_27_15 = var_27_12.content
		local var_27_16 = var_27_10[var_27_13]

		if var_27_16 then
			if not var_27_15.is_bought then
				arg_27_0:_blessing_bought_vo(var_27_16)
			end

			var_27_15.is_bought = true
			var_27_15.button_hotspot.disable_button = true

			local var_27_17, var_27_18 = arg_27_0._deus_run_controller:get_player_profile(var_27_16, var_0_11)

			if var_27_17 ~= 0 then
				local var_27_19 = SPProfiles[var_27_17].careers[var_27_18]
				local var_27_20 = arg_27_0._deus_run_controller:get_player_name(var_27_16)
				local var_27_21 = arg_27_0._deus_run_controller:get_player_level(var_27_16, var_27_17)
				local var_27_22 = arg_27_0._deus_run_controller:get_player_frame(var_27_16, var_27_17, var_27_18)
				local var_27_23 = var_27_12.offset
				local var_27_24 = {
					541,
					75,
					10
				}
				local var_27_25 = {
					var_27_23[1] + var_27_24[1],
					var_27_23[2] + var_27_24[2],
					var_27_23[3] + var_27_24[3]
				}
				local var_27_26 = arg_27_0._blessing_frame_widgets[var_27_15.frame_index]

				if var_27_26.content.frame_settings_name ~= var_27_22 or var_27_26.content.level ~= var_27_21 then
					arg_27_0:_update_blessing_portrait_frame(var_27_22, tostring(var_27_21), var_27_13, var_27_15.frame_index, var_27_25, var_27_15.is_bought)
				end

				var_27_15.player_name_text = var_27_20
				var_27_15.character_portrait = var_27_19.portrait_image
				var_27_15.level = tostring(var_27_21)
			end

			if not arg_27_0._previous_bought_blessings[var_27_13] and var_27_16 ~= var_27_0 then
				arg_27_0:_play_sound(var_0_10.blessing_bought)
			end
		elseif var_27_1 < var_27_14 then
			var_27_15.button_hotspot.disable_button = true
		else
			var_27_15.button_hotspot.disable_button = false
			var_27_15.is_bought = false
		end

		arg_27_0._previous_bought_blessings[var_27_13] = var_27_15.is_bought
	end
end

function DeusShopView._acquire_input(arg_28_0, arg_28_1)
	arg_28_0:_release_input(true)

	local var_28_0 = arg_28_0._input_manager
	local var_28_1 = arg_28_0._input_service_name

	var_28_0:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, var_28_1, "DeusShopView")

	if not arg_28_1 then
		ShowCursorStack.show("DeusShopView")
		var_28_0:enable_gamepad_cursor()
	end

	arg_28_0._acquiring_input = true
end

function DeusShopView._blessing_bought_vo(arg_29_0, arg_29_1)
	if arg_29_0._deus_run_controller:is_server() then
		local var_29_0 = arg_29_0._human_player_vo_units[arg_29_1]

		if var_29_0 then
			ScriptUnit.extension_input(var_29_0, "dialogue_system"):trigger_networked_dialogue_event("deus_purchasing_blessing")
		end
	end
end

function DeusShopView._release_input(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0._input_manager

	var_30_0:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, arg_30_0._input_service_name, "DeusShopView")

	if not arg_30_1 and arg_30_0._acquiring_input then
		ShowCursorStack.hide("DeusShopView")
		var_30_0:disable_gamepad_cursor()
	end

	arg_30_0._acquiring_input = false
end

function DeusShopView._update_button_hover_sound(arg_31_0, arg_31_1)
	if UIUtils.is_button_hover_enter(arg_31_1) then
		arg_31_0:_play_sound(var_0_10.button_hover)
	end
end

function DeusShopView._on_blessing_bought(arg_32_0, arg_32_1)
	arg_32_0._deus_run_controller:shop_buy_blessing(arg_32_1)

	local var_32_0 = DeusCostSettings.shop.blessings[arg_32_1]

	table.insert(arg_32_0._telemetry_data.purchased_blessings, {
		name = arg_32_1,
		cost = var_32_0
	})
end

function DeusShopView._on_power_up_bought(arg_33_0, arg_33_1, arg_33_2)
	arg_33_0._deus_run_controller:shop_buy_power_up(arg_33_1, arg_33_2)

	local var_33_0 = arg_33_0:_get_power_up_costs(arg_33_1.rarity, arg_33_2)

	table.insert(arg_33_0._telemetry_data.purchased_boons, {
		name = arg_33_1.name,
		cost = var_33_0
	})

	arg_33_0._purchased_boons[arg_33_1.name] = true
end

function DeusShopView._handle_input(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._shop_items

	for iter_34_0, iter_34_1 in ipairs(var_34_0.power_ups) do
		local var_34_1 = iter_34_1.widget
		local var_34_2 = false

		if UIUtils.is_button_held(var_34_1) and not var_34_1.content.is_bought then
			if not var_0_1.interaction_started then
				var_0_2.start(var_0_1, arg_34_2)

				arg_34_0._purchasing_power_up_name = iter_34_1.power_up.name
			end

			var_0_1.interaction_ongoing = true

			local var_34_3 = 255 * var_0_1.progress

			var_34_1.style.loading_frame.color[1] = var_34_3
			var_34_2 = var_0_2.update(var_0_1, arg_34_2)
		elseif arg_34_0._purchasing_power_up_name and iter_34_1.power_up.name == arg_34_0._purchasing_power_up_name then
			var_0_1.interaction_ongoing = false
			var_34_1.style.loading_frame.color[1] = 0
			arg_34_0._purchasing_power_up_name = nil

			var_0_2.abort(var_0_1)
		end

		if var_34_2 then
			local var_34_4 = iter_34_1.power_up
			local var_34_5 = iter_34_1.discount

			arg_34_0:_on_power_up_bought(var_34_4, var_34_5 or 0)
			arg_34_0:_play_sound(var_0_10.power_up_bought)
			var_0_2.successful(var_0_1)

			arg_34_0._purchasing_power_up_name = nil
		end

		arg_34_0:_update_button_hover_sound(var_34_1)
	end

	for iter_34_2, iter_34_3 in ipairs(var_34_0.blessings) do
		local var_34_6 = iter_34_3.widget
		local var_34_7 = false

		if UIUtils.is_button_held(var_34_6) and not var_34_6.content.is_bought then
			if not var_0_1.interaction_started then
				var_0_2.start(var_0_1, arg_34_2)

				arg_34_0._purchasing_blessing_name = iter_34_3.blessing_name
			end

			var_0_1.interaction_ongoing = true

			local var_34_8 = 255 * var_0_1.progress

			var_34_6.style.loading_frame.color[1] = var_34_8
			var_34_7 = var_0_2.update(var_0_1, arg_34_2)
		elseif arg_34_0._purchasing_blessing_name and iter_34_3.blessing_name == arg_34_0._purchasing_blessing_name then
			var_0_1.interaction_ongoing = false
			var_34_6.style.loading_frame.color[1] = 0
			arg_34_0._purchasing_blessing_name = nil

			var_0_2.abort(var_0_1)
		end

		if var_34_7 then
			arg_34_0:_on_blessing_bought(iter_34_3.blessing_name)
			arg_34_0:_play_sound(var_0_10.blessing_bought)
			var_0_2.successful(var_0_1)

			arg_34_0._purchasing_blessing_name = nil
		end

		arg_34_0:_update_button_hover_sound(var_34_6)
	end

	local var_34_9 = arg_34_0._widgets_by_name

	arg_34_0:_update_button_hover_sound(var_34_9.ready_button)

	if UIUtils.is_button_pressed(var_34_9.ready_button) then
		local var_34_10 = arg_34_0._shared_state:get_key("peer_state")

		arg_34_0._shared_state:set_own(var_34_10, var_0_16.DONE_BUYING)
		arg_34_0:_play_sound(var_0_10.ready_pressed)
	end

	arg_34_0:_handle_owned_power_up_input(arg_34_1, arg_34_2)
end

function DeusShopView._handle_owned_power_up_input(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0.ui_scenegraph
	local var_35_1 = arg_35_0:input_service()
	local var_35_2 = arg_35_0._power_up_widgets
	local var_35_3 = arg_35_0._widgets_by_name.power_up_description
	local var_35_4
	local var_35_5

	if arg_35_0._portrait_mode or not var_0_3 then
		var_35_3.content.visible = false
		arg_35_0._current_power_up_name = nil

		return
	end

	local var_35_6 = var_35_3.content
	local var_35_7 = var_35_3.style
	local var_35_8 = false

	for iter_35_0 = 1, #var_35_2 do
		local var_35_9 = arg_35_0._power_up_widgets[iter_35_0]

		if UIUtils.is_button_hover(var_35_9) then
			local var_35_10 = var_35_9.scenegraph_id
			local var_35_11 = UISceneGraph.get_world_position(var_35_0, var_35_10)
			local var_35_12 = var_35_9.offset

			var_35_0.power_up_description_root.local_position[1] = var_35_11[1] + var_35_12[1]
			var_35_0.power_up_description_root.local_position[2] = var_35_11[2] + var_35_12[2]
			var_35_4 = var_35_9.content.power_up_name
			var_35_5 = var_35_9.content.power_up_rarity

			local var_35_13 = var_35_9.content.locked
			local var_35_14 = var_35_9.content.locked_text_id

			var_35_6.visible = true
			var_35_6.locked = var_35_13
			var_35_6.locked_text_id = var_35_14 or var_35_6.locked_text_id
			var_35_8 = true

			if var_35_13 then
				var_35_6.end_time = nil
				var_35_6.progress = nil
				var_35_6.input_made = false
				var_35_7.remove_frame.color[1] = 0

				break
			end

			if var_35_1:get("mouse_middle_press") or var_35_1:get("special_1_press") then
				var_35_6.input_made = true
				var_35_7.remove_frame.color[1] = 0

				arg_35_0:_play_sound("Play_gui_boon_removal_start")

				break
			end

			if var_35_6.input_made and (var_35_1:get("mouse_middle_held") or var_35_1:get("special_1_hold")) then
				local var_35_15 = var_35_6.end_time or arg_35_2 + var_35_6.remove_interaction_duration
				local var_35_16 = (var_35_15 - arg_35_2) / var_35_6.remove_interaction_duration

				var_35_7.remove_frame.color[1] = 255 * (1 - var_35_16)

				if var_35_16 <= 0 then
					var_35_6.end_time = nil
					var_35_6.progress = nil
					var_35_6.input_made = false

					local var_35_17 = Managers.mechanism:game_mechanism():get_deus_run_controller()
					local var_35_18 = Managers.player:local_player():local_player_id()

					arg_35_0._force_update_power_ups = var_35_17:remove_power_ups(var_35_4, var_35_18)

					arg_35_0:_play_sound("Play_gui_boon_removal_end")

					break
				end

				var_35_6.end_time = var_35_15
				var_35_6.progress = var_35_16

				break
			end

			if var_35_6.input_made then
				arg_35_0:_play_sound("Stop_gui_boon_removal_start")
			end

			var_35_6.end_time = nil
			var_35_6.progress = nil
			var_35_6.input_made = false
			var_35_7.remove_frame.color[1] = 0

			break
		end
	end

	if not var_35_8 then
		var_35_6.end_time = nil
		var_35_6.progress = nil
		var_35_6.input_made = false
		var_35_7.remove_frame.color[1] = 0
	end

	if var_35_4 ~= arg_35_0._current_power_up_name then
		arg_35_0:_populate_power_up(var_35_4, var_35_5, var_35_3)
	end

	arg_35_0._current_power_up_name = var_35_4
end

function DeusShopView._populate_power_up(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	if not arg_36_1 then
		arg_36_3.content.visible = false

		return
	end

	local var_36_0 = DeusPowerUps[arg_36_2][arg_36_1]
	local var_36_1 = arg_36_3.content
	local var_36_2 = Managers.player:local_player()
	local var_36_3 = var_36_2:profile_index()
	local var_36_4 = var_36_2:career_index()
	local var_36_5 = var_36_0.rarity

	var_36_1.title_text = DeusPowerUpUtils.get_power_up_name_text(var_36_0.name, var_36_0.talent_index, var_36_0.talent_tier, var_36_3, var_36_4)
	var_36_1.rarity_text = Localize(RaritySettings[var_36_5].display_name)
	var_36_1.description_text = DeusPowerUpUtils.get_power_up_description(var_36_0, var_36_3, var_36_4)
	var_36_1.icon = DeusPowerUpUtils.get_power_up_icon(var_36_0, var_36_3, var_36_4)
	var_36_1.extend_left = false
	var_36_1.is_rectangular_icon = DeusPowerUpTemplates[var_36_0.name].rectangular_icon

	local var_36_6 = arg_36_3.style
	local var_36_7 = Colors.get_table(var_36_5)

	var_36_6.rarity_text.text_color = var_36_7
	arg_36_3.content.visible = true

	local var_36_8 = DeusPowerUpSetLookup[var_36_5] and DeusPowerUpSetLookup[var_36_5][var_36_0.name]
	local var_36_9 = false

	if var_36_8 then
		local var_36_10 = var_36_8[1]
		local var_36_11 = 0
		local var_36_12 = var_36_10.pieces
		local var_36_13 = Managers.mechanism:game_mechanism():get_deus_run_controller()

		for iter_36_0, iter_36_1 in ipairs(var_36_12) do
			local var_36_14 = iter_36_1.name
			local var_36_15 = iter_36_1.rarity
			local var_36_16 = var_36_13:get_own_peer_id()

			if var_36_13:has_power_up_by_name(var_36_16, var_36_14, var_36_15) then
				var_36_11 = var_36_11 + 1
			end
		end

		var_36_9 = true

		local var_36_17 = var_36_10.num_required_pieces or #var_36_12

		var_36_1.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), var_36_11, var_36_17)

		if #var_36_12 == var_36_11 then
			var_36_6.set_progression.text_color = var_36_6.set_progression.progression_colors.complete
		end
	end

	var_36_1.is_part_of_set = var_36_9
end

function DeusShopView._get_power_up_costs(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = DeusCostSettings.shop.power_ups[arg_37_1] or 9001

	if arg_37_2 then
		var_37_0 = var_37_0 - math.round(var_37_0 * arg_37_2)
	end

	return var_37_0
end

function DeusShopView._play_sound(arg_38_0, arg_38_1)
	WwiseWorld.trigger_event(arg_38_0._wwise_world, arg_38_1)
end

function DeusShopView._update_player_data(arg_39_0)
	local var_39_0 = {
		{}
	}
	local var_39_1 = Network.peer_id()
	local var_39_2 = arg_39_0._deus_run_controller:get_peers()

	for iter_39_0 = 1, #var_39_2 do
		local var_39_3 = var_39_2[iter_39_0]
		local var_39_4

		if var_39_3 == var_39_1 then
			var_39_4 = var_39_0[1]
		else
			var_39_4 = {}
			var_39_0[#var_39_0 + 1] = var_39_4
		end

		local var_39_5, var_39_6 = arg_39_0._deus_run_controller:get_player_profile(var_39_3, var_0_11)

		if var_39_5 ~= 0 and var_39_6 ~= 0 then
			var_39_4.profile_index = var_39_5
			var_39_4.career_index = var_39_6
			var_39_4.level = arg_39_0._deus_run_controller:get_player_level(var_39_3, var_39_4.profile_index)
			var_39_4.frame = arg_39_0._deus_run_controller:get_player_frame(var_39_3, var_39_4.profile_index, var_39_4.career_index)
			var_39_4.name = arg_39_0._deus_run_controller:get_player_name(var_39_3)
			var_39_4.health_percentage = arg_39_0._deus_run_controller:get_player_health_percentage(var_39_3, var_0_11) or 1
			var_39_4.healthkit_consumable = arg_39_0._deus_run_controller:get_player_consumable_healthkit_slot(var_39_3, var_0_11)
			var_39_4.potion_consumable = arg_39_0._deus_run_controller:get_player_consumable_potion_slot(var_39_3, var_0_11)
			var_39_4.grenade_consumable = arg_39_0._deus_run_controller:get_player_consumable_grenade_slot(var_39_3, var_0_11)
			var_39_4.ammo_percentage = arg_39_0._deus_run_controller:get_player_ranged_ammo(var_39_3, var_0_11)
			var_39_4.soft_currency = arg_39_0._deus_run_controller:get_player_soft_currency(var_39_3) or 0
			var_39_4.peer_state = arg_39_0._shared_state:get_peer(var_39_3, arg_39_0._shared_state:get_key("peer_state"))
		else
			var_39_4.profile_index = 0
			var_39_4.career_index = 0
			var_39_4.level = 1
			var_39_4.frame = "default"
			var_39_4.health_percentage = 1
			var_39_4.soft_currency = 0
		end
	end

	arg_39_0:_update_player_portraits(var_39_0)
end

function DeusShopView._update_portrait_frame(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = UIWidgets.deus_create_player_portraits_frame("player_portrait_" .. arg_40_3, arg_40_1, arg_40_2, false)
	local var_40_1 = UIWidget.init(var_40_0)

	arg_40_0._portrait_frame_widgets[arg_40_3] = var_40_1
	arg_40_0._widgets_by_name["player_portrait_frame_" .. arg_40_3] = var_40_1
end

function DeusShopView._update_blessing_portrait_frame(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	local var_41_0 = var_0_0.create_blessing_portraits_frame("blessing_root", arg_41_1, arg_41_2, false, arg_41_5)
	local var_41_1 = UIWidget.init(var_41_0)

	var_41_1.content.is_bought = arg_41_6
	arg_41_0._blessing_frame_widgets[arg_41_4] = var_41_1
	arg_41_0._widgets_by_name[arg_41_3 .. "_portrait_frame_" .. arg_41_4] = var_41_1
end

function DeusShopView._update_player_portraits(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._widgets_by_name
	local var_42_1 = var_42_0.ready_button_tokens

	for iter_42_0 = 1, 4 do
		local var_42_2 = arg_42_1[iter_42_0]
		local var_42_3 = var_42_0["player_portrait_" .. iter_42_0]
		local var_42_4 = var_42_0["player_texts_" .. iter_42_0]
		local var_42_5 = var_42_0["player_portrait_frame_" .. iter_42_0]
		local var_42_6 = not not var_42_2

		var_42_3.content.visible = var_42_6
		var_42_4.content.visible = var_42_6
		var_42_5.content.visible = var_42_6

		local var_42_7 = "token_icon_" .. iter_42_0

		var_42_1.content[var_42_7] = nil

		if var_42_6 then
			local var_42_8 = var_42_2.frame or "default"
			local var_42_9 = var_42_2.level or "-"

			if var_42_5.content.frame_settings_name ~= var_42_8 or var_42_5.content.level ~= var_42_9 then
				arg_42_0:_update_portrait_frame(var_42_8, var_42_9, iter_42_0)

				var_42_5.content.level = var_42_9
			end

			var_42_4.content.name_text = UIRenderer.crop_text(var_42_2.name or "", 17)
			var_42_4.content.coins_text = string.format("%d", var_42_2.soft_currency or 0)
			var_42_4.style.name_text.size[1] = 100
			var_42_4.style.name_text_shadow.size[1] = 100
			var_42_3.style.token_icon.saturated = var_42_2.peer_state == var_0_16.DONE_BUYING

			if var_42_2.profile_index and var_42_2.profile_index ~= 0 then
				local var_42_10 = SPProfiles[var_42_2.profile_index]
				local var_42_11 = var_42_10.careers[var_42_2.career_index]

				var_42_3.content.character_portrait = var_42_11.portrait_image

				local var_42_12 = var_42_10.hero_selection_image

				var_42_3.content.token_icon = var_42_10.hero_selection_image

				if var_42_2.peer_state == var_0_16.DONE_BUYING then
					var_42_1.content[var_42_7] = var_42_12
				end
			else
				var_42_3.content.character_portrait = "unit_frame_portrait_default"
				var_42_3.content.token_icon = nil
			end

			var_42_3.content.hp_bar.bar_value = var_42_2.health_percentage or 0
			var_42_3.content.ammo_percentage = var_42_2.ammo_percentage or 0

			local var_42_13 = var_42_2.healthkit_consumable

			var_42_3.content.healthkit_slot = var_42_13 and ItemMasterList[var_42_13].hud_icon
			var_42_3.style.healthkit_slot_bg.color = var_0_18(var_42_13)

			local var_42_14 = var_42_2.potion_consumable

			var_42_3.content.potion_slot = var_42_14 and ItemMasterList[var_42_14].hud_icon
			var_42_3.style.potion_slot_bg.color = var_0_18(var_42_14)

			local var_42_15 = var_42_2.grenade_consumable

			var_42_3.content.grenade_slot = var_42_15 and ItemMasterList[var_42_15].hud_icon
			var_42_3.style.grenade_slot_bg.color = var_0_18(var_42_15)
		end
	end
end

function DeusShopView._are_all_peers_ready(arg_43_0)
	local var_43_0 = arg_43_0._deus_run_controller:get_own_peer_id()

	for iter_43_0, iter_43_1 in ipairs(arg_43_0._deus_run_controller:get_peers()) do
		if var_43_0 ~= iter_43_1 then
			local var_43_1 = arg_43_0._shared_state:get_key("peer_state")

			if arg_43_0._shared_state:get_peer(iter_43_1, var_43_1) == var_0_16.READY_TO_BUY ~= true then
				return false
			end
		end
	end

	return true
end

function DeusShopView._are_all_peers_done(arg_44_0)
	for iter_44_0, iter_44_1 in ipairs(arg_44_0._deus_run_controller:get_peers()) do
		local var_44_0 = arg_44_0._shared_state:get_key("peer_state")

		if arg_44_0._shared_state:get_peer(iter_44_1, var_44_0) == var_0_16.DONE_BUYING ~= true then
			return false
		end
	end

	return true
end

function DeusShopView._did_someone_vote(arg_45_0)
	for iter_45_0, iter_45_1 in ipairs(arg_45_0._deus_run_controller:get_peers()) do
		local var_45_0 = arg_45_0._shared_state:get_key("peer_state")

		if arg_45_0._shared_state:get_peer(iter_45_1, var_45_0) == var_0_16.DONE_BUYING == true then
			return true
		end
	end

	return false
end

function DeusShopView._animate_shop_item_widget(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_2.content
	local var_46_1 = arg_46_2.style
	local var_46_2 = var_46_0.hotspot or var_46_0.button_hotspot
	local var_46_3 = var_46_2.is_hover
	local var_46_4 = var_46_0.is_bought
	local var_46_5 = var_46_2.is_held
	local var_46_6 = var_46_0.has_buying_animation_played
	local var_46_7 = var_46_2.is_selected
	local var_46_8 = var_46_2.hover_progress or 0
	local var_46_9 = var_46_2.hover_progress or 0
	local var_46_10 = var_46_2.highlight_progress or 0
	local var_46_11 = var_46_2.selection_progress or 0
	local var_46_12 = 15

	if var_46_4 then
		var_46_3 = false
	end

	if var_46_3 and not var_46_5 then
		var_46_8 = math.min(var_46_8 + arg_46_1 * var_46_12, 1)
		var_46_9 = math.max(var_46_8 - arg_46_1 * var_46_12, 1)
	elseif var_46_3 and var_46_5 then
		var_46_8 = math.max(var_46_8 - arg_46_1 * var_46_12, 0)
		var_46_9 = math.max(var_46_8 - arg_46_1 * var_46_12, 1)
	else
		var_46_8 = math.max(var_46_8 - arg_46_1 * var_46_12, 0)
		var_46_9 = math.max(var_46_8 - arg_46_1 * var_46_12, 0)
	end

	var_46_1.icon_hover_frame.color[1] = 255 * var_46_8
	var_46_1.hover.color[1] = 255 * var_46_9

	if var_46_4 then
		var_46_10 = math.min(var_46_10 + arg_46_1 * var_46_12, 1)
	else
		var_46_10 = math.max(var_46_10 - arg_46_1 * var_46_12, 0)
	end

	if var_46_7 then
		var_46_11 = math.min(var_46_11 + arg_46_1 * var_46_12, 1)
	else
		var_46_11 = math.max(var_46_11 - arg_46_1 * var_46_12, 0)
	end

	if var_46_4 and not var_46_6 then
		arg_46_0._ui_animator:start_animation("flash_icon", arg_46_2, var_0_0.scenegraph_definition)
	end

	if var_46_4 and not var_46_6 then
		arg_46_0._ui_animator:start_animation("flash_icon", arg_46_2, var_0_0.scenegraph_definition)
	end

	if var_46_4 and not var_46_6 then
		arg_46_0._ui_animator:start_animation("flash_icon", arg_46_2, var_0_0.scenegraph_definition)
	end

	if var_46_0.bought_glow_style_ids then
		for iter_46_0, iter_46_1 in ipairs(var_46_0.bought_glow_style_ids) do
			var_46_1[iter_46_1].color[1] = 255 * var_46_10
		end
	end

	local var_46_13 = var_46_2.value_progress or 0
	local var_46_14 = math.max(var_46_13 - arg_46_1 * var_46_12, 0)

	if var_46_1.icon_equipped_frame then
		var_46_1.icon_equipped_frame.color[1] = 255 * var_46_14
	end

	var_46_2.value_progress = var_46_14
	var_46_2.hover_progress = var_46_8
	var_46_2.highlight_progress = var_46_10
	var_46_2.selection_progress = var_46_11
end

function DeusShopView._draw(arg_47_0, arg_47_1, arg_47_2)
	for iter_47_0, iter_47_1 in ipairs(arg_47_0._shop_item_widgets) do
		arg_47_0:_animate_shop_item_widget(arg_47_1, iter_47_1)
	end

	local var_47_0 = arg_47_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_47_0.ready_button, arg_47_1)

	local var_47_1 = arg_47_0.ui_scenegraph
	local var_47_2 = arg_47_0._input_manager:get_service(arg_47_0._input_service_name)
	local var_47_3 = arg_47_0.render_settings

	if arg_47_0._render_top_widgets then
		local var_47_4 = arg_47_0.ui_top_renderer
		local var_47_5 = arg_47_0._top_widgets

		UIRenderer.begin_pass(var_47_4, var_47_1, var_47_2, arg_47_1, nil, var_47_3)

		for iter_47_2 = 1, #var_47_5 do
			UIRenderer.draw_widget(var_47_4, var_47_5[iter_47_2])
		end

		UIRenderer.end_pass(var_47_4)
	end

	local var_47_6 = arg_47_0.ui_renderer

	UIRenderer.begin_pass(var_47_6, var_47_1, var_47_2, arg_47_1, nil, var_47_3)

	if arg_47_0._background_unit_widget then
		UIRenderer.draw_widget(var_47_6, arg_47_0._background_unit_widget)
	end

	local var_47_7 = var_47_3.snap_pixel_positions
	local var_47_8 = arg_47_0._widgets

	for iter_47_3 = 1, #var_47_8 do
		local var_47_9 = var_47_8[iter_47_3]

		if var_47_9.snap_pixel_positions ~= nil then
			var_47_3.snap_pixel_positions = var_47_9.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_47_6, var_47_9)

		var_47_3.snap_pixel_positions = var_47_7
	end

	local var_47_10 = arg_47_0._portrait_frame_widgets

	UIRenderer.draw_all_widgets(var_47_6, var_47_10)

	local var_47_11 = arg_47_0._blessing_frame_widgets

	UIRenderer.draw_all_widgets(var_47_6, var_47_11)
	arg_47_0:_draw_boons(arg_47_1, arg_47_2)
	UIRenderer.end_pass(var_47_6)

	if arg_47_0._scrollbar_ui and not arg_47_0._portrait_mode then
		arg_47_0._scrollbar_ui:update(arg_47_1, arg_47_2, var_47_6, var_47_2, var_47_3)
	end
end

function DeusShopView._draw_boons(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0.ui_scenegraph
	local var_48_1 = arg_48_0.ui_renderer
	local var_48_2 = "own_power_up_anchor"
	local var_48_3 = "own_power_up_window"
	local var_48_4 = UISceneGraph.get_world_position(var_48_0, var_48_2)
	local var_48_5 = UISceneGraph.get_world_position(var_48_0, var_48_3)
	local var_48_6 = var_48_0[var_48_3].size[2]
	local var_48_7 = arg_48_0._power_up_widgets

	for iter_48_0 = 1, #var_48_7 do
		local var_48_8 = var_48_7[iter_48_0]
		local var_48_9 = var_48_8.offset
		local var_48_10 = var_48_4[2] + var_48_9[2]
		local var_48_11 = var_0_0.power_up_widget_size[2]

		if var_48_10 - var_48_11 > var_48_5[2] + var_48_6 then
			-- block empty
		elseif var_48_10 + var_48_11 < var_48_5[2] then
			break
		else
			UIRenderer.draw_widget(var_48_1, var_48_8)
		end
	end
end

function DeusShopView._create_unit_previewer(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = arg_49_1.element.pass_data[1]
	local var_49_1 = var_49_0.viewport
	local var_49_2 = var_49_0.world

	World.set_data(var_49_2, "avoid_blend", true)

	local var_49_3 = {
		0.15,
		2.5,
		-0.5
	}
	local var_49_4 = UIUnitPreviewer:new(arg_49_2, arg_49_3, var_49_3, var_49_2, var_49_1)

	var_49_4:activate_auto_spin()

	return var_49_4
end

function DeusShopView._create_background_unit_definition(arg_50_0)
	local var_50_0 = "environment/ui_weave_forge_preview"

	return {
		scenegraph_id = "background_unit",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 840,
				world_name = "item_preview",
				viewport_type = "default_forward",
				viewport_name = "item_preview_viewport",
				enable_sub_gui = false,
				fov = 20,
				shading_environment = var_50_0,
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

function DeusShopView._update_hold_text(arg_51_0)
	local var_51_0 = arg_51_0._widgets_by_name.hold_to_buy_text.style.text
	local var_51_1 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

	var_51_0.text_color[1] = 100 + 155 * var_51_1
end

function DeusShopView._update_input_helper_text(arg_52_0)
	local var_52_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5
	local var_52_1 = arg_52_0._widgets_by_name
	local var_52_2 = var_52_1.portrait_input_helper_text
	local var_52_3 = var_52_2.style.text
	local var_52_4 = var_52_1.boon_input_helper_text
	local var_52_5 = var_52_4.style.text

	var_52_3.text_color[1] = 100 + 155 * var_52_0
	var_52_5.text_color[1] = 100 + 155 * var_52_0
	var_52_2.content.visible = not arg_52_0._portrait_mode
	var_52_4.content.visible = arg_52_0._portrait_mode
end

function DeusShopView._update_background_animations(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0._widgets_by_name

	for iter_53_0 = 1, 3 do
		local var_53_1 = var_53_0["background_wheel_0" .. iter_53_0]
		local var_53_2 = var_53_1.style.texture_id.angle
		local var_53_3 = 0
		local var_53_4
		local var_53_5 = var_53_2 + arg_53_1 * (iter_53_0 == 1 and 0.2 or iter_53_0 == 2 and -0.1 or 0.05)

		var_53_1.style.texture_id.angle = var_53_5
	end
end

function DeusShopView.on_ingame_menu_opened(arg_54_0)
	arg_54_0._render_top_widgets = false

	Managers.input:disable_gamepad_cursor()
end

function DeusShopView.on_ingame_menu_closed(arg_55_0)
	arg_55_0._render_top_widgets = true

	Managers.input:enable_gamepad_cursor()
end
