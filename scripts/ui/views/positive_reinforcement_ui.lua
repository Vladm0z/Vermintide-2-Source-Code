-- chunkname: @scripts/ui/views/positive_reinforcement_ui.lua

require("scripts/settings/ui_player_portrait_frame_settings")

local var_0_0 = local_require("scripts/ui/views/positive_reinforcement_ui_definitions")
local var_0_1 = var_0_0.MAX_NUMBER_OF_MESSAGES
local var_0_2 = local_require("scripts/ui/views/positive_reinforcement_ui_event_settings")
local var_0_3 = {
	fade_to = Colors.get_table("white"),
	default = Colors.get_table("cheeseburger"),
	kill = Colors.get_table("red"),
	personal = Colors.get_table("dodger_blue")
}
local var_0_4 = UISettings.breed_textures

PositiveReinforcementUI = class(PositiveReinforcementUI)

PositiveReinforcementUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.world = arg_1_2.world_manager:world("level_world")
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:create_ui_elements()

	arg_1_0._positive_enforcement_events = {}
	arg_1_0._positive_enforcement_lookup = {}
	arg_1_0._animations = {}

	local var_1_0 = Managers.state.event

	var_1_0:register(arg_1_0, "add_coop_feedback", "event_add_positive_enforcement")
	var_1_0:register(arg_1_0, "add_coop_feedback_kill", "event_add_positive_enforcement_kill")
end

PositiveReinforcementUI.destroy = function (arg_2_0)
	GarbageLeakDetector.register_object(arg_2_0, "positive_reinforcement_ui")

	local var_2_0 = Managers.state.event

	var_2_0:unregister("add_coop_feedback", arg_2_0)
	var_2_0:unregister("add_coop_feedback_kill", arg_2_0)
end

PositiveReinforcementUI.create_ui_elements = function (arg_3_0)
	local var_3_0 = Managers.state.game_mode:game_mode_key()
	local var_3_1 = GameModeSettings[var_3_0].hud_ui_settings
	local var_3_2 = var_0_0.scenegraph_definition

	if var_3_1 and var_3_1.killfeed_offset then
		var_3_2.message_animated = table.clone(var_3_2.message_animated_offset)
	else
		var_3_2.message_animated = table.clone(var_3_2.message_animated_base)
	end

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_3_2)
	arg_3_0.message_widgets = {}
	arg_3_0._unused_widgets = {}

	local var_3_3 = 0

	for iter_3_0, iter_3_1 in pairs(var_0_0.message_widgets) do
		var_3_3 = var_3_3 + 1
		arg_3_0.message_widgets[var_3_3] = UIWidget.init(iter_3_1)
		arg_3_0._unused_widgets[var_3_3] = UIWidget.init(iter_3_1)
	end
end

PositiveReinforcementUI.remove_event = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._positive_enforcement_events
	local var_4_1 = table.remove(var_4_0, arg_4_1)
	local var_4_2 = var_4_1.widget

	arg_4_0._positive_enforcement_lookup[var_4_1.full_hash] = nil

	local var_4_3 = arg_4_0._unused_widgets

	var_4_3[#var_4_3 + 1] = var_4_2
end

local function var_0_5(arg_5_0, arg_5_1)
	local var_5_0 = ScriptUnit.extension(arg_5_0, "buff_system")
	local var_5_1 = ScriptUnit.extension(arg_5_1, "health_system")
	local var_5_2, var_5_3 = var_5_0:apply_buffs_to_value(0, "shielding_player_by_assist")

	if var_5_3 then
		if Managers.player.is_server then
			DamageUtils.heal_network(arg_5_1, arg_5_0, var_5_2, "buff")
			DamageUtils.heal_network(arg_5_0, arg_5_0, var_5_2, "buff")
		else
			local var_5_4 = Managers.state.network
			local var_5_5 = var_5_4.network_transmit
			local var_5_6 = var_5_4:unit_game_object_id(arg_5_1)
			local var_5_7 = var_5_4:unit_game_object_id(arg_5_0)
			local var_5_8 = NetworkLookup.heal_types.buff

			var_5_5:send_rpc_server("rpc_request_heal", var_5_6, var_5_2, var_5_8)
			var_5_5:send_rpc_server("rpc_request_heal", var_5_7, var_5_2, var_5_8)
		end
	end
end

PositiveReinforcementUI.add_event = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, ...)
	if not script_data.disable_reinforcement_ui then
		local var_6_0 = arg_6_0._positive_enforcement_events
		local var_6_1 = arg_6_1 .. arg_6_4
		local var_6_2 = UISettings.positive_reinforcement
		local var_6_3 = Managers.time:time("ui")
		local var_6_4 = var_6_2.increment_duration
		local var_6_5 = var_0_2[arg_6_4]
		local var_6_6 = arg_6_0._positive_enforcement_lookup[var_6_1]

		if var_6_6 and var_6_2.folding_enabled then
			local var_6_7 = var_6_6.widget.content
			local var_6_8 = var_6_7.count + 1

			var_6_7.count_text = var_6_8 .. "x"
			var_6_7.count = var_6_8
			var_6_6.remove_time = nil
		else
			local var_6_9 = arg_6_0.message_widgets
			local var_6_10 = arg_6_0._unused_widgets

			if #var_6_10 == 0 then
				arg_6_0:remove_event(#var_6_0)
			end

			local var_6_11 = table.remove(var_6_10, 1)
			local var_6_12 = var_6_11.offset
			local var_6_13 = {
				text = "",
				shown_amount = 0,
				amount = 0,
				full_hash = var_6_1,
				widget = var_6_11,
				event_type = arg_6_4,
				is_local_player = arg_6_2,
				data = {
					...
				}
			}
			local var_6_14 = #var_6_0 + 1

			table.insert(var_6_0, 1, var_6_13)

			arg_6_0._positive_enforcement_lookup[var_6_1] = var_6_13

			local var_6_15 = var_6_11.content
			local var_6_16 = var_6_11.style

			var_6_15.count = 1
			var_6_15.count_text = nil

			local var_6_17, var_6_18, var_6_19 = var_6_5.icon_function(...)

			arg_6_0:_assign_portrait_texture(var_6_11, "portrait_1", var_6_17)
			arg_6_0:_assign_portrait_texture(var_6_11, "portrait_2", var_6_19)

			var_6_15.icon = var_6_18
			var_6_12[2] = 0

			local var_6_20 = var_6_15.texte_style_ids

			for iter_6_0, iter_6_1 in ipairs(var_6_20) do
				var_6_16[iter_6_1].color[1] = 255
			end
		end

		if arg_6_2 then
			local var_6_21 = var_6_5.sound_function()

			if var_6_21 then
				local var_6_22 = arg_6_0.world
				local var_6_23 = Managers.world:wwise_world(var_6_22)

				WwiseWorld.trigger_event(var_6_23, var_6_21)
			end
		end
	end
end

local var_0_6 = {
	96,
	112
}

PositiveReinforcementUI._assign_portrait_texture = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_1.style[arg_7_2]

	if not arg_7_3 then
		var_7_0.size = {
			0,
			0
		}

		return
	end

	arg_7_1.content[arg_7_2].texture_id = arg_7_3

	local var_7_1 = table.clone(var_0_6)

	if UIAtlasHelper.has_atlas_settings_by_texture_name(arg_7_3) then
		local var_7_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_7_3)

		var_7_1[1] = var_7_2.size[1]
		var_7_1[2] = var_7_2.size[2]
	end

	local var_7_3 = arg_7_1.style[arg_7_2]
	local var_7_4 = var_7_3.portrait_offset
	local var_7_5 = var_7_3.offset

	var_7_5[1] = var_7_4[1] - var_7_1[1] / 2
	var_7_5[2] = var_7_4[2] - var_7_1[2] / 2
	var_7_3.size = var_7_1
end

PositiveReinforcementUI.event_add_positive_enforcement = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	if not var_0_2[arg_8_3] then
		return
	end

	if not arg_8_4 or not arg_8_4:name() then
		local var_8_0
	end

	if not arg_8_5 or not arg_8_5:name() then
		local var_8_1
	end

	local var_8_2 = arg_8_4 and arg_8_4.player_unit
	local var_8_3 = arg_8_5 and arg_8_5.player_unit
	local var_8_4 = Unit.alive(var_8_2) and ScriptUnit.extension(var_8_2, "career_system")
	local var_8_5 = Unit.alive(var_8_3) and ScriptUnit.extension(var_8_3, "career_system")
	local var_8_6 = arg_8_4 and arg_8_4:profile_index() or nil
	local var_8_7 = arg_8_5 and arg_8_5:profile_index() or nil
	local var_8_8 = var_8_4 and var_8_4:career_index() or arg_8_4 and arg_8_4:career_index()
	local var_8_9 = var_8_5 and var_8_5:career_index() or arg_8_5 and arg_8_5:career_index()
	local var_8_10 = var_8_6 and var_8_8 and arg_8_0:_get_hero_portrait(var_8_6, var_8_8)
	local var_8_11 = var_8_7 and var_8_9 and arg_8_0:_get_hero_portrait(var_8_7, var_8_9)

	if not var_8_10 or not var_8_11 then
		return
	end

	arg_8_0:add_event(arg_8_1, arg_8_2, var_0_3.default, arg_8_3, var_8_10, var_8_11)
end

PositiveReinforcementUI.event_add_positive_enforcement_kill = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = var_0_4[arg_9_4]
	local var_9_1 = var_0_4[arg_9_5]

	if not var_0_2[arg_9_3] or not var_9_0 or not var_9_1 then
		return
	end

	arg_9_0:add_event(arg_9_1, arg_9_2, var_0_3.kill, arg_9_3, var_9_0, var_9_1)
end

PositiveReinforcementUI.event_add_positive_enforcement_player_knocked_down_or_killed = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = var_0_4[arg_10_5]

	if not var_0_2[arg_10_3] or not var_10_0 then
		return
	end

	if not arg_10_4 then
		return
	end

	local var_10_1 = arg_10_0:_get_hero_portrait(arg_10_4)

	arg_10_0:add_event(arg_10_1, arg_10_2, var_0_3.kill, arg_10_3, var_10_0, var_10_1)
end

PositiveReinforcementUI.event_add_lorebook_page_pickup = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	arg_11_0:add_event(arg_11_1, arg_11_2, var_0_3.personal, arg_11_3, arg_11_4)
end

PositiveReinforcementUI.event_add_interaction_warning = function (arg_12_0, arg_12_1, arg_12_2)
	arg_12_0:add_event(arg_12_1, true, var_0_3.kill, "interaction_warning", Localize(arg_12_2))
end

PositiveReinforcementUI._get_hero_portrait = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = RESOLUTION_LOOKUP.scale
	local var_13_1 = SPProfiles[arg_13_1]
	local var_13_2 = var_13_1.careers[arg_13_2]
	local var_13_3 = var_13_1.display_name
	local var_13_4 = var_13_2.portrait_image

	return "small_" .. var_13_4
end

local var_0_7 = {
	root_scenegraph_id = "pivot",
	label = "Kill feed",
	registry_key = "kill_feed",
	drag_scenegraph_id = "pivot_dragger"
}

PositiveReinforcementUI.update = function (arg_14_0, arg_14_1, arg_14_2)
	HudCustomizer.run(arg_14_0.ui_renderer, arg_14_0.ui_scenegraph, var_0_7)

	local var_14_0 = arg_14_0.ui_renderer
	local var_14_1 = arg_14_0.ui_scenegraph
	local var_14_2 = arg_14_0.input_manager:get_service("Player")
	local var_14_3 = arg_14_0.render_settings

	for iter_14_0, iter_14_1 in pairs(arg_14_0._animations) do
		if arg_14_0._animations[iter_14_0] then
			if not UIAnimation.completed(iter_14_1) then
				UIAnimation.update(iter_14_1, arg_14_1)
			else
				arg_14_0._animations[iter_14_0] = nil
			end
		end
	end

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_2, arg_14_1, nil, var_14_3)

	local var_14_4 = arg_14_0._positive_enforcement_events
	local var_14_5 = UISettings.positive_reinforcement.show_duration
	local var_14_6 = var_14_3.snap_pixel_positions

	for iter_14_2, iter_14_3 in ipairs(var_14_4) do
		local var_14_7 = iter_14_3.widget
		local var_14_8 = var_14_7.content
		local var_14_9 = var_14_7.style
		local var_14_10 = var_14_7.offset
		local var_14_11 = iter_14_3.event_type
		local var_14_12 = var_0_2[var_14_11]
		local var_14_13 = false

		if not iter_14_3.remove_time then
			iter_14_3.remove_time = arg_14_2 + var_14_5
		elseif arg_14_2 > iter_14_3.remove_time then
			arg_14_0:remove_event(iter_14_2)

			var_14_13 = true
		end

		if not var_14_13 then
			local var_14_14 = 80
			local var_14_15 = -((iter_14_2 - 1) * var_14_14)
			local var_14_16 = math.abs(math.abs(var_14_10[2]) - math.abs(var_14_15))

			if var_14_15 < var_14_10[2] then
				local var_14_17 = 400

				var_14_10[2] = math.max(var_14_10[2] - arg_14_1 * var_14_17, var_14_15)
			else
				var_14_10[2] = var_14_15
			end

			local var_14_18 = iter_14_3.remove_time - arg_14_2
			local var_14_19 = UISettings.positive_reinforcement.fade_duration
			local var_14_20 = 0

			if var_14_19 < var_14_18 then
				var_14_20 = math.clamp((var_14_5 - var_14_18) / var_14_19, 0, 1)
				var_14_10[1] = -(math.easeInCubic(1 - var_14_20) * 35)
			else
				var_14_20 = math.clamp(var_14_18 / var_14_19, 0, 1)
			end

			local var_14_21 = 255 * math.easeOutCubic(var_14_20)
			local var_14_22 = var_14_8.texte_style_ids

			for iter_14_4, iter_14_5 in ipairs(var_14_22) do
				var_14_9[iter_14_5].color[1] = var_14_21
			end

			var_14_3.snap_pixel_positions = var_14_18 <= var_14_19

			UIRenderer.draw_widget(var_14_0, var_14_7)

			var_14_3.snap_pixel_positions = var_14_6
		end
	end

	UIRenderer.end_pass(var_14_0)
end
