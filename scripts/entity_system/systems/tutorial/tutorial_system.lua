-- chunkname: @scripts/entity_system/systems/tutorial/tutorial_system.lua

require("scripts/entity_system/systems/tutorial/tutorial_templates")
require("scripts/entity_system/systems/tutorial/tutorial_condition_evaluator")

local var_0_0 = 30
local var_0_1 = 0.3
local var_0_2 = 100
local var_0_3 = true

function tutprintf(...)
	if script_data.tutorial_debug then
		printf(...)
	end
end

local function var_0_4()
	print("Tutorial - save done")
end

local function var_0_5(arg_3_0)
	local var_3_0 = SaveData

	var_3_0.tutorial_points = arg_3_0.points
	var_3_0.completed_tutorials = arg_3_0.completed_tutorials

	Managers.save:auto_save(SaveFileName, SaveData, var_0_4)
end

local var_0_6 = {
	"PlayerTutorialExtension",
	"ObjectiveHealthTutorialExtension",
	"ObjectivePickupTutorialExtension",
	"ObjectiveSocketTutorialExtension",
	"ObjectiveUnitExtension"
}

TutorialSystem = class(TutorialSystem, ExtensionSystemBase)

function TutorialSystem.init(arg_4_0, arg_4_1, arg_4_2)
	TutorialSystem.super.init(arg_4_0, arg_4_1, arg_4_2, var_0_6)

	arg_4_0.player_units = {}
	arg_4_0.pacing = "pacing_relax"
	arg_4_0.dice_keeper = arg_4_1.dice_keeper
	arg_4_0.health_extensions = {}
	arg_4_0.raycast_units = {}
	arg_4_0._objective_tooltip_prioritized_list = nil
	arg_4_0.frozen_unit_extension_data = {}
	arg_4_0.unit_extension_data = {}
	arg_4_0.gui = World.create_screen_gui(arg_4_0.world, "material", "materials/fonts/gw_fonts", "immediate")

	local var_4_0 = arg_4_1.network_event_delegate

	arg_4_0.network_event_delegate = var_4_0

	var_4_0:register(arg_4_0, "rpc_tutorial_message", "rpc_pacing_changed", "rpc_objective_unit_set_active", "rpc_prioritize_objective_tooltip", "rpc_objective_unit_set_always_show")

	SaveData.seen_handbook_popups = SaveData.seen_handbook_popups or {}

	Managers.state.event:register(arg_4_0, "tutorial_trigger", "on_tutorial_trigger")

	arg_4_0._condition_context = TutorialConditionEvaluator:new()
	var_0_3 = false
end

function TutorialSystem.destroy(arg_5_0)
	Managers.state.event:unregister(arg_5_0, "tutorial_trigger")
	arg_5_0.network_event_delegate:unregister(arg_5_0)
	table.clear(arg_5_0)
end

local var_0_7 = {}

function TutorialSystem.on_add_extension(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = {}

	if arg_6_3 == "PlayerTutorialExtension" then
		arg_6_0.player_units[arg_6_2] = var_6_0
		var_6_0.completed_tutorials = SaveData.completed_tutorials or {}
		var_6_0.points = #var_6_0.completed_tutorials
		var_6_0.tooltip_tutorial = {
			active = false
		}
		var_6_0.objective_tooltips = {
			units_n = 0,
			active = false,
			units = {}
		}
		var_6_0.shown_times = {}
		var_6_0.data = {
			player_id = Network.peer_id(),
			statistics_db = arg_6_0.statistics_db,
			dice_keeper = arg_6_0.dice_keeper
		}

		local var_6_1 = TutorialTemplates

		for iter_6_0, iter_6_1 in pairs(var_6_1) do
			var_6_0.shown_times[iter_6_0] = -1000

			iter_6_1.init_data(var_6_0.data)
		end
	end

	if arg_6_3 == "ObjectiveHealthTutorialExtension" then
		Managers.state.event:trigger("tutorial_event_add_health_bar", arg_6_2)

		arg_6_0.health_extensions[arg_6_2] = var_6_0
	end

	if arg_6_3 == "ObjectivePickupTutorialExtension" then
		var_6_0.approach_text = Unit.get_data(arg_6_2, "approach_text") or "<approach_text not set>"
		var_6_0.disregard = Unit.get_data(arg_6_2, "disable_objective_ui") or false
	end

	if arg_6_3 == "ObjectiveSocketTutorialExtension" then
		var_6_0.approach_text = Unit.get_data(arg_6_2, "approach_text") or "<approach_text not set>"
		var_6_0.pickup_text = Unit.get_data(arg_6_2, "pickup_text") or "<pickup_text not set>"
	end

	if arg_6_3 == "ObjectiveUnitExtension" then
		local var_6_2 = Unit.get_data(arg_6_2, "objective_server_only")
		local var_6_3
		local var_6_4 = Managers.level_transition_handler:get_current_level_keys()

		if LevelSettings[var_6_4].hub_level then
			var_6_3 = Unit.get_data(arg_6_2, "network_synced")
		else
			var_6_3 = true
		end

		local var_6_5

		if Managers.player.is_server and not var_6_2 then
			function var_6_5(arg_7_0, arg_7_1)
				if arg_7_0.active == arg_7_1 then
					Application.warning("[ObjectiveUnitExtension] Trying to set active on unit %q to %q when it's already %q", tostring(arg_6_2), arg_7_1, arg_7_0.active)
				else
					arg_7_0.active = arg_7_1

					if arg_7_0.network_synced then
						local var_7_0 = Managers.state.network
						local var_7_1, var_7_2 = var_7_0:game_object_or_level_id(arg_7_0.unit)

						var_7_0.network_transmit:send_rpc_clients("rpc_objective_unit_set_active", var_7_1, var_7_2, arg_7_1)
					end
				end
			end
		elseif Managers.player.is_server or not var_6_2 then
			function var_6_5(arg_8_0, arg_8_1)
				arg_8_0.active = arg_8_1
			end
		else
			function var_6_5(arg_9_0, arg_9_1)
				arg_9_0.active = arg_9_1
			end
		end

		var_6_0.unit = arg_6_2
		var_6_0.active = false
		var_6_0.proxy_active = arg_6_4.proxy_active
		var_6_0.set_active = var_6_5
		var_6_0.server_only = var_6_2
		var_6_0.network_synced = var_6_3
		var_6_0.always_show = arg_6_4.always_show or Unit.get_data(arg_6_2, "always_show")

		function var_6_0.set_always_show(arg_10_0, arg_10_1)
			arg_10_0.always_show = arg_10_1

			if Managers.player.is_server and not var_6_2 and arg_10_0.network_synced then
				local var_10_0 = Managers.state.network
				local var_10_1, var_10_2 = var_10_0:game_object_or_level_id(arg_10_0.unit)

				var_10_0.network_transmit:send_rpc_clients("rpc_objective_unit_set_always_show", var_10_1, var_10_2, arg_10_1)
			end
		end
	end

	if not POSITION_LOOKUP[arg_6_2] then
		POSITION_LOOKUP[arg_6_2] = Unit.world_position(arg_6_2, 0)
	end

	ScriptUnit.set_extension(arg_6_2, "tutorial_system", var_6_0, var_0_7)

	arg_6_0.unit_extension_data[arg_6_2] = var_6_0

	return var_6_0
end

function TutorialSystem.on_remove_extension(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0:_cleanup_extension(arg_11_1)

	arg_11_0.frozen_unit_extension_data[arg_11_1] = nil

	ScriptUnit.remove_extension(arg_11_1, "tutorial_system")
end

function TutorialSystem.on_freeze_extension(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0:freeze(arg_12_1, arg_12_2)
end

function TutorialSystem.freeze(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0.frozen_unit_extension_data

	if var_13_0[arg_13_1] then
		return
	end

	local var_13_1 = arg_13_0.unit_extension_data[arg_13_1]

	fassert(var_13_1, "Unit to freeze didn't have unfrozen extension")
	arg_13_0:_cleanup_extension(arg_13_1)

	var_13_0[arg_13_1] = var_13_1
end

function TutorialSystem.unfreeze(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0.frozen_unit_extension_data[arg_14_1]

	fassert(var_14_0, "Unit to unfreeze didn't have frozen extension")

	arg_14_0.frozen_unit_extension_data[arg_14_1] = nil
	arg_14_0.unit_extension_data[arg_14_1] = var_14_0

	if arg_14_2 == "ObjectiveHealthTutorialExtension" then
		Managers.state.event:trigger("tutorial_event_add_health_bar", arg_14_1)

		arg_14_0.health_extensions[arg_14_1] = var_14_0
	elseif arg_14_2 == "PlayerTutorialExtension" then
		arg_14_0.player_units[arg_14_1] = var_14_0
	end

	if not POSITION_LOOKUP[arg_14_1] then
		POSITION_LOOKUP[arg_14_1] = Unit.world_position(arg_14_1, 0)
	end
end

function TutorialSystem._cleanup_extension(arg_15_0, arg_15_1)
	if arg_15_0.health_extensions[arg_15_1] then
		arg_15_0.health_extensions[arg_15_1] = nil

		Managers.state.event:trigger("tutorial_event_remove_health_bar", arg_15_1)
	end

	arg_15_0.player_units[arg_15_1] = nil

	local var_15_0 = arg_15_0.unit_extension_data[arg_15_1]

	if var_15_0 and var_15_0.active then
		var_15_0:set_active(false)
	end

	arg_15_0.unit_extension_data[arg_15_1] = nil
end

function TutorialSystem.physics_async_update(arg_16_0, arg_16_1, arg_16_2)
	if script_data.tutorial_disabled then
		return
	end

	local var_16_0 = arg_16_0.world
	local var_16_1 = arg_16_0.raycast_units

	for iter_16_0, iter_16_1 in pairs(arg_16_0.player_units) do
		local var_16_2 = var_16_1[iter_16_0]

		var_16_1[iter_16_0] = nil

		local var_16_3 = ScriptUnit.extension(iter_16_0, "interactor_system"):is_looking_at_interactable()

		if var_16_3 then
			iter_16_1.tooltip_tutorial.active = false
		end

		local var_16_4 = ScriptUnit.extension(iter_16_0, "status_system")

		if not var_16_3 and not var_16_4:is_disabled() then
			arg_16_0:iterate_tooltips(arg_16_2, iter_16_0, iter_16_1, var_16_2, var_16_0)
		end

		arg_16_0:iterate_objective_tooltips(arg_16_2, iter_16_0, iter_16_1, var_16_2, var_16_0)

		if (arg_16_0.pacing == "pacing_peak_fade" or arg_16_0.pacing == "pacing_relax") and not script_data.info_slates_disabled then
			arg_16_0:iterate_info_slates(arg_16_2, iter_16_0, iter_16_1, var_16_2, var_16_0)
		end

		if iter_16_1.tooltip_tutorial.active and arg_16_2 > iter_16_1.shown_times[iter_16_1.tooltip_tutorial.name] + var_0_1 then
			iter_16_1.tooltip_tutorial.active = false
		end

		if script_data.tutorial_debug then
			if DebugKeyHandler.key_pressed("f10", "add debug info slate", "tutorials") then
				local var_16_5 = math.random() * 5

				Managers.state.event:trigger("tutorial_event_queue_info_slate_entry", "tutorial", "DEBUG INFO SLATE, LOOK AT IT GOOOO", var_16_5 + 5)
			end

			local var_16_6 = RESOLUTION_LOOKUP.res_w
			local var_16_7 = RESOLUTION_LOOKUP.res_h

			Gui.rect(arg_16_0.gui, Vector3(0, 0, 100), Vector2(350, var_16_7), Color(100, 25, 25, 25))
			Debug.text("Tutorial points : %d", iter_16_1.points)
			Debug.text("Completed tutorials:")
			Debug.text("Shelved tutorials:")

			for iter_16_2, iter_16_3 in pairs(TutorialTemplates) do
				local var_16_8 = iter_16_1.shown_times[iter_16_2]

				if arg_16_2 < var_16_8 + var_0_0 then
					Debug.text(" * %s, %.1fs", iter_16_2, var_16_8 + var_0_0 - arg_16_2)
				end
			end

			if iter_16_1.tooltip_tutorial.active then
				Debug.text("Tooltip tutorial: " .. iter_16_1.tooltip_tutorial.name)

				if iter_16_1.tooltip_tutorial.world_position then
					QuickDrawer:sphere(iter_16_1.tooltip_tutorial.world_position:unbox(), 1, Colors.get("brown"))
				end
			else
				Debug.text("Tooltip tutorial: inactive")
			end

			if var_16_2 == nil then
				Debug.text("Raycast unit: none")
			else
				Debug.text("Raycast unit: %s", Unit.debug_name(var_16_2))
			end

			Debug.text("Extension data:")

			for iter_16_4, iter_16_5 in pairs(iter_16_1.data) do
				Debug.text(" * %s = %s", iter_16_4, tostring(iter_16_5))
			end
		end
	end

	var_0_3 = false
end

function TutorialSystem.iterate_tooltips(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	local var_17_0 = TutorialTooltipTemplates
	local var_17_1 = TutorialTooltipTemplates_n
	local var_17_2 = Managers.state.entity:system("play_go_tutorial_system"):active()
	local var_17_3 = Managers.level_transition_handler:get_current_level_keys()
	local var_17_4 = LevelSettings[var_17_3].hub_level

	for iter_17_0 = 1, var_17_1 do
		repeat
			local var_17_5 = var_17_0[iter_17_0]
			local var_17_6 = var_17_5.name

			if var_17_2 and not var_17_5.allowed_in_tutorial then
				break
			elseif not var_17_2 and var_17_5.incompatible_in_game then
				-- block empty
			elseif not var_17_4 and var_17_5.inn_only then
				break
			end

			var_17_5.update_data(arg_17_1, arg_17_2, arg_17_3.data)

			local var_17_7, var_17_8 = var_17_5.can_show(arg_17_1, arg_17_2, arg_17_3.data, arg_17_4, arg_17_5)

			if not var_17_7 then
				break
			end

			if var_17_5.get_text then
				var_17_5.text = var_17_5.get_text(arg_17_3.data)
			end

			if var_17_5.get_inputs then
				var_17_5.inputs = var_17_5.get_inputs(arg_17_3.data)
			end

			if var_17_5.get_gamepad_inputs then
				var_17_5.gamepad_inputs = var_17_5.get_gamepad_inputs(arg_17_3.data)
			end

			if var_17_5.get_force_update then
				var_17_5.force_update = var_17_5.get_force_update(arg_17_3.data)
			end

			arg_17_3.tooltip_tutorial.active = true
			arg_17_3.tooltip_tutorial.name = var_17_6

			if var_17_8 then
				arg_17_3.tooltip_tutorial.world_position = Vector3Box(var_17_8)
			else
				arg_17_3.tooltip_tutorial.world_position = nil
			end

			arg_17_3.shown_times[var_17_6] = arg_17_1

			return
		until true
	end
end

local var_0_8 = Unit.local_position
local var_0_9 = Vector3.distance_squared
local var_0_10

local function var_0_11(arg_18_0, arg_18_1)
	local var_18_0 = var_0_8(arg_18_0, 0)
	local var_18_1 = var_0_8(arg_18_1, 0)

	return var_0_9(var_0_10, var_18_0) < var_0_9(var_0_10, var_18_1)
end

function TutorialSystem.prioritize_objective_tooltip(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_2 then
		arg_19_0._objective_tooltip_prioritized_list = nil
		arg_19_0._prioritized_objective_tooltip = nil

		return
	end

	fassert(TutorialTemplates[arg_19_1], "[TutorialSystem] There is no TutorialObjectiveTooltipTemplate with the name %s", arg_19_1)
	fassert(TutorialTemplates[arg_19_1].display_type == "objective_tooltip", "[TutorialSystem] The tutorial template with the name %s is not an objective tooltip template (%s)", arg_19_1, TutorialTemplates[arg_19_1].display_type)

	local var_19_0 = TutorialObjectiveTooltipTemplates_n

	arg_19_0._objective_tooltip_prioritized_list = {}
	arg_19_0._objective_tooltip_prioritized_list[#arg_19_0._objective_tooltip_prioritized_list + 1] = TutorialTemplates[arg_19_1]

	for iter_19_0 = 1, var_19_0 do
		if TutorialObjectiveTooltipTemplates[iter_19_0].name ~= arg_19_1 then
			arg_19_0._objective_tooltip_prioritized_list[#arg_19_0._objective_tooltip_prioritized_list + 1] = TutorialObjectiveTooltipTemplates[iter_19_0]
		end
	end

	arg_19_0._prioritized_objective_tooltip = arg_19_1
end

function TutorialSystem.iterate_objective_tooltips(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_0._objective_tooltip_prioritized_list or TutorialObjectiveTooltipTemplates
	local var_20_1 = TutorialObjectiveTooltipTemplates_n
	local var_20_2 = arg_20_3.objective_tooltips

	var_20_2.units_n = 0

	for iter_20_0 = 1, var_20_1 do
		repeat
			local var_20_3 = var_20_0[iter_20_0]
			local var_20_4 = var_20_3.name

			var_20_3.update_data(arg_20_1, arg_20_2, arg_20_3.data)

			local var_20_5, var_20_6, var_20_7 = var_20_3.can_show(arg_20_1, arg_20_2, arg_20_3.data, arg_20_4, arg_20_5)

			if not var_20_5 then
				break
			end

			if var_20_3.get_text then
				var_20_3.text = var_20_3.get_text(arg_20_3.data)
			end

			if var_20_3.get_action then
				var_20_3.action = var_20_3.get_action(arg_20_3.data)
			end

			if var_20_3.get_icon then
				var_20_3.icon = var_20_3.get_icon(arg_20_3.data)
			end

			if var_20_3.get_alert then
				var_20_3.alerts_horde = var_20_3.get_alert(arg_20_3.data)
			end

			if var_20_3.get_wave then
				var_20_3.wave = var_20_3.get_wave(arg_20_3.data)
			end

			var_20_2.active = true
			var_20_2.name = var_20_4
			var_20_2.units_n = var_20_7

			local var_20_8 = var_20_2.units

			for iter_20_1 = 1, var_20_7 do
				var_20_8[iter_20_1] = var_20_6[iter_20_1]
			end

			local var_20_9 = var_20_7 + 1

			while var_20_8[var_20_9] do
				var_20_8[var_20_9] = nil
				var_20_9 = var_20_9 + 1
			end

			if var_20_7 > 1 then
				var_0_10 = Unit.local_position(arg_20_2, 0)

				local var_20_10 = var_0_11

				table.sort(var_20_8, var_20_10)

				var_0_10 = nil
			end

			return
		until true
	end
end

function TutorialSystem.verify_info_slate(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_0.player_units[arg_21_2]
	local var_21_1 = arg_21_0.world

	if arg_21_4.do_not_verify then
		return true
	end

	return arg_21_4.can_show(arg_21_1, arg_21_2, var_21_0.data, arg_21_3, var_21_1)
end

function TutorialSystem.iterate_info_slates(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	if Application.user_setting("tutorials_enabled") then
		local var_22_0 = TutorialInfoSlateTemplates
		local var_22_1 = TutorialInfoSlateTemplates_n

		for iter_22_0 = 1, var_22_1 do
			repeat
				local var_22_2 = var_22_0[iter_22_0]
				local var_22_3 = var_22_2.name
				local var_22_4 = var_22_2.cooldown and var_22_2.cooldown or var_0_2

				if arg_22_1 < arg_22_3.shown_times[var_22_3] + var_22_4 then
					break
				end

				if var_22_2.can_show(arg_22_1, arg_22_2, arg_22_3.data, arg_22_4, arg_22_5) then
					arg_22_3.shown_times[var_22_3] = arg_22_1

					local var_22_5 = var_22_2.get_text and var_22_2.get_text(arg_22_3.data, var_22_2) or var_22_2.text
					local var_22_6 = Localize(var_22_5)

					Managers.state.event:trigger("tutorial_event_queue_info_slate_entry", var_22_6, nil, nil, var_22_2, arg_22_2, arg_22_4)
				end
			until true
		end
	else
		Managers.state.event:trigger("tutorial_event_clear_tutorials")
	end
end

function TutorialSystem.on_tutorial_trigger(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._condition_context

	if var_23_0:get("has_max_level_character") then
		return
	end

	var_23_0:clear_cache()

	local var_23_1 = SaveData.seen_handbook_popups

	for iter_23_0, iter_23_1 in pairs(HandbookSettings.popups) do
		if var_23_1[iter_23_0] then
			-- block empty
		elseif not table.find(iter_23_1.triggers, arg_23_1) then
			-- block empty
		else
			local var_23_2 = iter_23_1.conditions

			if var_23_2 then
				for iter_23_2 = 1, #var_23_2 do
					local var_23_3 = var_23_2[iter_23_2]

					if not var_23_0:get(var_23_3) then
						goto label_23_0
					end
				end
			end

			local var_23_4 = iter_23_1.custom_condition

			if var_23_4 and not var_23_4(var_23_0) then
				-- block empty
			else
				Managers.state.event:trigger("ui_show_popup", iter_23_0, "handbook")

				var_23_1[iter_23_0] = true
			end
		end

		::label_23_0::
	end
end

function TutorialSystem.rpc_tutorial_message(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = NetworkLookup.tutorials[arg_24_2]

	if not var_24_0 then
		return
	end

	local var_24_1 = NetworkLookup.tutorials[arg_24_3]
	local var_24_2 = TutorialTemplates[var_24_0]

	for iter_24_0, iter_24_1 in pairs(arg_24_0.player_units) do
		local var_24_3 = iter_24_1.data

		var_24_2.on_message(var_24_3, var_24_1)
	end
end

function TutorialSystem.rpc_pacing_changed(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = NetworkLookup.pacing[arg_25_2]

	arg_25_0.pacing = var_25_0

	tutprintf("Changing pacing state to %s", var_25_0)
end

function TutorialSystem.rpc_objective_unit_set_active(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = Managers.state.network:game_object_or_level_unit(arg_26_2, arg_26_3)
	local var_26_1 = ScriptUnit.has_extension(var_26_0, "tutorial_system")

	if var_26_1 then
		var_26_1:set_active(arg_26_4)
	end
end

function TutorialSystem.rpc_prioritize_objective_tooltip(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = NetworkLookup.objective_tooltips[arg_27_2]

	arg_27_0:prioritize_objective_tooltip(var_27_0)
end

function TutorialSystem.rpc_objective_unit_set_always_show(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = Managers.state.network:game_object_or_level_unit(arg_28_2, arg_28_3)
	local var_28_1 = ScriptUnit.has_extension(var_28_0, "tutorial_system")

	if var_28_1 then
		var_28_1:set_always_show(arg_28_4)
	end
end

function TutorialSystem.flow_callback_show_health_bar(arg_29_0, arg_29_1, arg_29_2)
	Managers.state.event:trigger("tutorial_event_show_health_bar", arg_29_1, arg_29_2)
end

function TutorialSystem.flow_callback_tutorial_message(arg_30_0, arg_30_1, arg_30_2)
	if Managers.player.is_server then
		local var_30_0 = NetworkLookup.tutorials[arg_30_1]
		local var_30_1 = NetworkLookup.tutorials[arg_30_2]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_30_0, var_30_1)
	end
end

function TutorialSystem.hot_join_sync(arg_31_0, arg_31_1)
	local var_31_0 = Managers.state.network
	local var_31_1 = Managers.state.entity:get_entities("ObjectiveUnitExtension")

	for iter_31_0, iter_31_1 in pairs(var_31_1) do
		if iter_31_1.active and not iter_31_1.server_only and iter_31_1.network_synced then
			local var_31_2, var_31_3 = var_31_0:game_object_or_level_id(iter_31_0)

			var_31_0.network_transmit:send_rpc("rpc_objective_unit_set_active", arg_31_1, var_31_2, var_31_3, true)
		end
	end

	if arg_31_0._prioritized_objective_tooltip then
		local var_31_4 = NetworkLookup.objective_tooltips[arg_31_0._prioritized_objective_tooltip]

		var_31_0.network_transmit:send_rpc("rpc_prioritize_objective_tooltip", arg_31_1, var_31_4)
	end
end

function TutorialSystem.update(arg_32_0, arg_32_1, arg_32_2)
	if script_data.tutorial_disabled then
		return
	end

	local var_32_0 = arg_32_0.world
	local var_32_1 = World.get_data(arg_32_0.world, "physics_world")
	local var_32_2 = arg_32_0.raycast_units

	for iter_32_0, iter_32_1 in pairs(arg_32_0.player_units) do
		if var_0_3 or DebugKeyHandler.key_pressed("f3", "reset tutorials", "tutorials") then
			iter_32_1.completed_tutorials = {}
			iter_32_1.points = 0
			iter_32_1.tooltip_tutorial.active = false
			iter_32_1.data = {
				player_id = Network.peer_id(),
				statistics_db = arg_32_0.statistics_db,
				dice_keeper = arg_32_0.dice_keeper
			}

			for iter_32_2, iter_32_3 in pairs(TutorialTemplates) do
				iter_32_1.shown_times[iter_32_2] = -1000

				iter_32_3.init_data(iter_32_1.data)
			end
		end

		local var_32_3 = ScriptUnit.extension(iter_32_0, "first_person_system")
		local var_32_4 = var_32_3:current_position()
		local var_32_5 = var_32_3:current_rotation()
		local var_32_6 = Quaternion.forward(var_32_5)
		local var_32_7, var_32_8, var_32_9, var_32_10, var_32_11 = PhysicsWorld.immediate_raycast(var_32_1, var_32_4 + var_32_6, var_32_6, 30, "closest", "collision_filter", "filter_tutorial")
		local var_32_12

		if var_32_7 and var_32_11 then
			var_32_12 = Actor.unit(var_32_11)

			if not HEALTH_ALIVE[var_32_12] then
				var_32_12 = nil
			end
		end

		var_32_2[iter_32_0] = var_32_12
	end
end
