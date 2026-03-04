-- chunkname: @scripts/entity_system/systems/cutscene/cutscene_system.lua

local var_0_0 = script_data.testify and require("scripts/entity_system/systems/cutscene/cutscene_system_testify")

CutsceneSystem = class(CutsceneSystem, ExtensionSystemBase)

local var_0_1 = {
	"CutsceneCamera"
}

CutsceneSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	CutsceneSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0.world = arg_1_1.world
	arg_1_0.cameras = {}
	arg_1_0.active_camera = nil
	arg_1_0.ingame_hud_enabled = nil
	arg_1_0.event_on_activate = nil
	arg_1_0.event_on_deactivate = nil
	arg_1_0.event_on_skip = nil
	arg_1_0.cutscene_started = false
	arg_1_0._should_hide_loading_icon = false
	arg_1_0.ui_event_queue = pdArray.new()
end

CutsceneSystem.destroy = function (arg_2_0)
	arg_2_0.world = nil
	arg_2_0.cameras = nil
	arg_2_0.active_camera = nil
	arg_2_0.ui_event_queue = nil

	if arg_2_0._should_hide_loading_icon then
		Managers.transition:hide_loading_icon()

		arg_2_0._should_hide_loading_icon = nil
	end
end

CutsceneSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = CutsceneSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0.cameras[arg_3_2] = var_3_0

	return var_3_0
end

CutsceneSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.cameras[arg_4_1]

	if arg_4_0.active_camera == var_4_0 then
		local var_4_1
	end

	local var_4_2

	CutsceneSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
end

CutsceneSystem.update = function (arg_5_0)
	local var_5_0 = arg_5_0.active_camera

	if var_5_0 then
		arg_5_0:set_first_person_mode(false)
		var_5_0:update()
	end

	arg_5_0:handle_loading_icon()

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_5_0)
	end
end

CutsceneSystem.unsafe_entity_update = function (arg_6_0)
	local var_6_0 = arg_6_0.active_camera

	if var_6_0 then
		var_6_0:unsafe_entity_update()
	end
end

CutsceneSystem.is_active = function (arg_7_0)
	return arg_7_0.active_camera ~= nil
end

CutsceneSystem.handle_loading_icon = function (arg_8_0)
	if arg_8_0.active_camera then
		Managers.transition:show_loading_icon()
	elseif not arg_8_0.active_camera and arg_8_0._should_hide_loading_icon then
		Managers.transition:hide_loading_icon()

		arg_8_0._should_hide_loading_icon = nil
	end
end

CutsceneSystem.skip_pressed = function (arg_9_0)
	if arg_9_0.active_camera and script_data.skippable_cutscenes then
		if arg_9_0.event_on_skip then
			local var_9_0 = LevelHelper:current_level(arg_9_0.world)

			Level.trigger_event(var_9_0, arg_9_0.event_on_skip)
		end

		arg_9_0.event_on_skip = nil

		arg_9_0:flow_cb_deactivate_cutscene_cameras()
		arg_9_0:flow_cb_deactivate_cutscene_logic()
	end
end

CutsceneSystem.set_first_person_mode = function (arg_10_0, arg_10_1)
	local var_10_0 = Managers.player:local_player().player_unit

	if Unit.alive(var_10_0) then
		local var_10_1 = ScriptUnit.extension(var_10_0, "status_system")

		if not arg_10_1 or not var_10_1:is_disabled() then
			local var_10_2 = ScriptUnit.extension(var_10_0, "first_person_system")

			if arg_10_1 ~= var_10_2.first_person_mode then
				var_10_2:set_first_person_mode(arg_10_1)
			end
		end
	end
end

CutsceneSystem.flow_cb_activate_cutscene_camera = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if not arg_11_0.active_camera then
		arg_11_0:set_first_person_mode(false)
	end

	local var_11_0 = arg_11_0.cameras[arg_11_1]

	var_11_0:activate(arg_11_2)

	arg_11_0.active_camera = var_11_0
	arg_11_0.ingame_hud_enabled = arg_11_3
	arg_11_0._should_hide_loading_icon = true

	if IS_PS4 then
		Managers.state.event:trigger("realtime_multiplay", false)
	end

	if not IS_WINDOWS and Managers.account:should_throttle() then
		Application.set_time_step_policy("throttle", 30)
	end

	pdArray.push_back2(arg_11_0.ui_event_queue, "set_letterbox_enabled", arg_11_4)
end

CutsceneSystem.flow_cb_deactivate_cutscene_cameras = function (arg_12_0)
	arg_12_0:set_first_person_mode(true)

	arg_12_0.active_camera = nil
	arg_12_0.ingame_hud_enabled = true

	if arg_12_0._should_hide_loading_icon then
		Managers.transition:hide_loading_icon()

		arg_12_0._should_hide_loading_icon = nil
	end

	if IS_PS4 then
		Managers.state.event:trigger("realtime_multiplay", true)
	end

	if not IS_WINDOWS and Managers.account:should_throttle() then
		Application.set_time_step_policy("no_throttle")
	end

	pdArray.push_back2(arg_12_0.ui_event_queue, "set_letterbox_enabled", false)
end

CutsceneSystem.flow_cb_activate_cutscene_logic = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_2 then
		local var_13_0 = LevelHelper:current_level(arg_13_0.world)

		Level.trigger_event(var_13_0, arg_13_2)
	end

	arg_13_0.event_on_skip = arg_13_3
	arg_13_0.cutscene_started = true

	pdArray.push_back2(arg_13_0.ui_event_queue, "set_player_input_enabled", arg_13_1)
end

CutsceneSystem.flow_cb_deactivate_cutscene_logic = function (arg_14_0, arg_14_1)
	if arg_14_1 then
		local var_14_0 = LevelHelper:current_level(arg_14_0.world)

		Level.trigger_event(var_14_0, arg_14_1)
	end

	arg_14_0.event_on_skip = nil

	pdArray.push_back2(arg_14_0.ui_event_queue, "set_player_input_enabled", true)
end

CutsceneSystem.flow_cb_cutscene_effect = function (arg_15_0, arg_15_1, arg_15_2)
	if arg_15_1 == "fx_fade" then
		local var_15_0 = {
			arg_15_2.fade_in_time,
			arg_15_2.hold_time,
			arg_15_2.fade_out_time,
			arg_15_2.color
		}

		pdArray.push_back2(arg_15_0.ui_event_queue, arg_15_1, var_15_0)

		return
	elseif arg_15_1 == "fx_text_popup" then
		local var_15_1 = {
			arg_15_2.fade_in_time,
			arg_15_2.hold_time,
			arg_15_2.fade_out_time,
			arg_15_2.text
		}

		pdArray.push_back2(arg_15_0.ui_event_queue, arg_15_1, var_15_1)

		return
	end

	fassert(false, "[CutsceneSystem] Tried to register unknown cutsene effect named %q from flow", arg_15_1)
end

CutsceneSystem.has_intro_cutscene_finished_playing = function (arg_16_0)
	return arg_16_0.cutscene_started and arg_16_0.ingame_hud_enabled
end

CutsceneSystem.fade_game_logo = function (arg_17_0, arg_17_1, arg_17_2)
	if arg_17_1 then
		arg_17_0.fade_in_game_logo = true
		arg_17_0.fade_in_game_logo_time = arg_17_2
		arg_17_0.fade_out_game_logo = nil
		arg_17_0.fade_out_game_logo_time = nil
	else
		arg_17_0.fade_out_game_logo = true
		arg_17_0.fade_out_game_logo_time = arg_17_2
		arg_17_0.fade_in_game_logo = nil
		arg_17_0.fade_in_game_logo_time = nil
	end
end
