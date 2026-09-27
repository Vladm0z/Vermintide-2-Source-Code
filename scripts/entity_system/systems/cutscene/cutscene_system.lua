-- chunkname: @scripts/entity_system/systems/cutscene/cutscene_system.lua

local testify = script_data.testify

testify = not testify and require("scripts/entity_system/systems/cutscene/cutscene_system_testify")
CutsceneSystem = class(CutsceneSystem, ExtensionSystemBase)

local tbl = {
	"CutsceneCamera"
}

CutsceneSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	CutsceneSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self.world = arg_1_1.world
	self.cameras = {}
	self.active_camera = nil
	self.ingame_hud_enabled = nil
	self.event_on_activate = nil
	self.event_on_deactivate = nil
	self.event_on_skip = nil
	self.cutscene_started = false
	self._should_hide_loading_icon = false
	self.ui_event_queue = pdArray.new()
end

CutsceneSystem.destroy = function (self)
	-- function 2
	self.world = nil
	self.cameras = nil
	self.active_camera = nil
	self.ui_event_queue = nil

	if not self._should_hide_loading_icon then
		Managers.transition:hide_loading_icon()

		self._should_hide_loading_icon = nil
	end
end

CutsceneSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local on_add_extension = CutsceneSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0.cameras[arg_3_2] = on_add_extension

	return on_add_extension
end

CutsceneSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = self.cameras[arg_4_1]

	if self.active_camera == var_4_0 then
		local var_4_1
	end

	local var_4_2

	CutsceneSystem.super.on_remove_extension(self, arg_4_1, arg_4_2)
end

CutsceneSystem.update = function (self)
	-- function 5
	local active_camera = self.active_camera

	if not active_camera then
		self:set_first_person_mode(false)
		active_camera:update()
	end

	self:handle_loading_icon()

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

CutsceneSystem.unsafe_entity_update = function (self)
	-- function 6
	local active_camera = self.active_camera

	if not active_camera then
		active_camera:unsafe_entity_update()
	end
end

CutsceneSystem.is_active = function (self)
	-- function 7
	return self.active_camera ~= nil
end

CutsceneSystem.handle_loading_icon = function (self)
	-- function 8
	if not self.active_camera then
		Managers.transition:show_loading_icon()
	elseif self.active_camera or not self._should_hide_loading_icon then
		Managers.transition:hide_loading_icon()

		self._should_hide_loading_icon = nil
	end
end

CutsceneSystem.skip_pressed = function (self)
	-- function 9
	if not self.active_camera and not script_data.skippable_cutscenes then
		if not self.event_on_skip then
			local current_level = LevelHelper:current_level(self.world)

			Level.trigger_event(current_level, self.event_on_skip)
		end

		self.event_on_skip = nil

		self:flow_cb_deactivate_cutscene_cameras()
		self:flow_cb_deactivate_cutscene_logic()
	end
end

CutsceneSystem.set_first_person_mode = function (arg_10_0, arg_10_1)
	-- function 10
	local player_unit = Managers.player:local_player().player_unit

	if not Unit.alive(player_unit) then
		local extension = ScriptUnit.extension(player_unit, "status_system")

		if not (not arg_10_1 and extension:is_disabled()) then
			local extension_2 = ScriptUnit.extension(player_unit, "first_person_system")

			if arg_10_1 ~= extension_2.first_person_mode then
				extension_2:set_first_person_mode(arg_10_1)
			end
		end
	end
end

CutsceneSystem.flow_cb_activate_cutscene_camera = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	if not self.active_camera then
		self:set_first_person_mode(false)
	end

	local var_11_0 = self.cameras[arg_11_1]

	var_11_0:activate(arg_11_2)

	self.active_camera = var_11_0
	self.ingame_hud_enabled = arg_11_3
	self._should_hide_loading_icon = true

	if not IS_PS4 then
		Managers.state.event:trigger("realtime_multiplay", false)
	end

	if IS_WINDOWS or not Managers.account:should_throttle() then
		Application.set_time_step_policy("throttle", 30)
	end

	pdArray.push_back2(self.ui_event_queue, "set_letterbox_enabled", arg_11_4)
end

CutsceneSystem.flow_cb_deactivate_cutscene_cameras = function (self)
	-- function 12
	self:set_first_person_mode(true)

	self.active_camera = nil
	self.ingame_hud_enabled = true

	if not self._should_hide_loading_icon then
		Managers.transition:hide_loading_icon()

		self._should_hide_loading_icon = nil
	end

	if not IS_PS4 then
		Managers.state.event:trigger("realtime_multiplay", true)
	end

	if IS_WINDOWS or not Managers.account:should_throttle() then
		Application.set_time_step_policy("no_throttle")
	end

	pdArray.push_back2(self.ui_event_queue, "set_letterbox_enabled", false)
end

CutsceneSystem.flow_cb_activate_cutscene_logic = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not arg_13_2 then
		local current_level = LevelHelper:current_level(self.world)

		Level.trigger_event(current_level, arg_13_2)
	end

	self.event_on_skip = arg_13_3
	self.cutscene_started = true

	pdArray.push_back2(self.ui_event_queue, "set_player_input_enabled", arg_13_1)
end

CutsceneSystem.flow_cb_deactivate_cutscene_logic = function (self, arg_14_1)
	-- function 14
	if not arg_14_1 then
		local current_level = LevelHelper:current_level(self.world)

		Level.trigger_event(current_level, arg_14_1)
	end

	self.event_on_skip = nil

	pdArray.push_back2(self.ui_event_queue, "set_player_input_enabled", true)
end

CutsceneSystem.flow_cb_cutscene_effect = function (self, arg_15_1, arg_15_2)
	-- function 15
	if arg_15_1 == "fx_fade" then
		local tbl = {
			arg_15_2.fade_in_time,
			arg_15_2.hold_time,
			arg_15_2.fade_out_time,
			arg_15_2.color
		}

		pdArray.push_back2(self.ui_event_queue, arg_15_1, tbl)

		return
	elseif arg_15_1 == "fx_text_popup" then
		local tbl_2 = {
			arg_15_2.fade_in_time,
			arg_15_2.hold_time,
			arg_15_2.fade_out_time,
			arg_15_2.text
		}

		pdArray.push_back2(self.ui_event_queue, arg_15_1, tbl_2)

		return
	end

	fassert(false, "[CutsceneSystem] Tried to register unknown cutsene effect named %q from flow", arg_15_1)
end

CutsceneSystem.has_intro_cutscene_finished_playing = function (self)
	-- function 16
	local cutscene_started = self.cutscene_started

	cutscene_started = not cutscene_started and self.ingame_hud_enabled

	return cutscene_started
end

CutsceneSystem.fade_game_logo = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not arg_17_1 then
		self.fade_in_game_logo = true
		self.fade_in_game_logo_time = arg_17_2
		self.fade_out_game_logo = nil
		self.fade_out_game_logo_time = nil
	else
		self.fade_out_game_logo = true
		self.fade_out_game_logo_time = arg_17_2
		self.fade_in_game_logo = nil
		self.fade_in_game_logo_time = nil
	end
end
