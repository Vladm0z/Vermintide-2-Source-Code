-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_emote.lua

PlayerCharacterStateEmote = class(PlayerCharacterStateEmote, PlayerCharacterState)

local num = 0.05
local num_2 = 0.03
local num_3 = 5

PlayerCharacterStateEmote.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "emote")

	local var_1_0 = arg_1_1
end

PlayerCharacterStateEmote.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local tbl = {
		override_node_name = "camera_attach",
		camera_node = "emotes",
		force_state_change = true,
		allow_camera_movement = true,
		override_follow_unit = arg_2_1
	}

	CharacterStateHelper.change_camera_state(self.player, "follow_third_person", tbl)
	self.first_person_extension:set_first_person_mode(false)
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "emote")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "emote")
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, "idle")
	self.status_extension:set_inspecting(true)
	self:_update_emote()

	self._current_zoom = 0
	self._current_zoom_target = 0.7

	Managers.state.camera:set_variable(self.player.viewport_name, "emote_zoom", 1)

	local get_hud_component = Managers.ui:get_hud_component("EmotePhotomodeUI")

	get_hud_component:set_enabled(true)

	self._emote_ui = get_hud_component
end

PlayerCharacterStateEmote.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	CharacterStateHelper.change_camera_state(self.player, "follow")
	self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	self.status_extension:set_inspecting(false)

	if not Managers.state.network:game() then
		local go_id = self.unit_storage:go_id(self.unit)

		self.network_transmit:send_rpc_server("rpc_server_cancel_emote", go_id)
	end

	Managers.state.game_mode:game_mode():set_photomode_enabled(false)
	self._emote_ui:set_enabled(false)

	self._emote_ui = nil
	self.current_emote = nil
end

PlayerCharacterStateEmote.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local input_extension = self.input_extension
	local camera = Managers.state.camera
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local locomotion_extension = self.locomotion_extension

	input_extension:get("action_career", true)

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	local world = self.world

	if not CharacterStateHelper.is_ledge_hanging(world, arg_4_1, self.temp_params) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	local get_service = Managers.input:get_service("Player")
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not is_device_active then
		if not get_service:get("crouch", true) then
			csm:change_state("standing", self.temp_params)

			return
		end
	else
		local is_crouching = status_extension:is_crouching()

		if (input_extension:get("jump") or not input_extension:get("jump_only") or status_extension:is_crouching()) and (not is_crouching or CharacterStateHelper.can_uncrouch(arg_4_1) or not locomotion_extension:jump_allowed()) then
			if not is_crouching then
				CharacterStateHelper.uncrouch(arg_4_1, arg_4_5, first_person_extension, status_extension)
			end

			csm:change_state("jumping")
			first_person_extension:change_state("jumping")

			return
		end

		if not CharacterStateHelper.has_move_input(input_extension) then
			local temp_params = self.temp_params

			csm:change_state("walking", temp_params)
			first_person_extension:change_state("walking")

			return
		end
	end

	local num_4 = 0

	if not is_device_active then
		num_4 = get_service:get("emote_camera_zoom_in") - get_service:get("emote_camera_zoom_out")
		num_4 = num_4 * num_2
	else
		num_4 = get_service:get("emote_camera_zoom").y * num
	end

	local get_social_wheel_class = Managers.mechanism:get_social_wheel_class()
	local get_hud_component = Managers.ui:get_hud_component(get_social_wheel_class)

	if not get_hud_component and get_hud_component:is_active() or not get_service:get("emote_toggle_hud_visibility", true) then
		local game_mode = Managers.state.game_mode:game_mode()

		game_mode:set_photomode_enabled(not game_mode:photomode_enabled())
	end

	self._current_zoom_target = math.clamp(self._current_zoom_target + num_4, 0, 1)

	if self._current_zoom ~= self._current_zoom_target then
		local _current_zoom = self._current_zoom
		local min = math.min(arg_4_3 * num_3, 1)
		local lerp = math.lerp(_current_zoom, self._current_zoom_target, min)

		self._current_zoom = lerp

		camera:set_variable(self.player.viewport_name, "emote_zoom", 1 - lerp)
	end

	self:_update_emote()
	self.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension)
end

PlayerCharacterStateEmote._update_emote = function (self)
	-- function 5
	local get_queued_3p_emote, var_5_1 = self.cosmetic_extension:get_queued_3p_emote()

	if not get_queued_3p_emote then
		local go_id = self.unit_storage:go_id(self.unit)
		local var_5_3 = NetworkLookup.anims[get_queued_3p_emote]

		self.network_transmit:send_rpc_server("rpc_server_request_emote", go_id, var_5_3, var_5_1)
		self.cosmetic_extension:consume_queued_3p_emote()

		self.current_emote = get_queued_3p_emote
	end
end
