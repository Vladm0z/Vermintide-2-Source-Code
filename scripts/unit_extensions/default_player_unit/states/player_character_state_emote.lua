-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_emote.lua

PlayerCharacterStateEmote = class(PlayerCharacterStateEmote, PlayerCharacterState)

local var_0_0 = 0.05
local var_0_1 = 0.03
local var_0_2 = 5

function PlayerCharacterStateEmote.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "emote")

	local var_1_0 = arg_1_1
end

function PlayerCharacterStateEmote.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_0 = {
		override_node_name = "camera_attach",
		camera_node = "emotes",
		force_state_change = true,
		allow_camera_movement = true,
		override_follow_unit = arg_2_1
	}

	CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person", var_2_0)
	arg_2_0.first_person_extension:set_first_person_mode(false)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "emote")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "emote")
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(arg_2_0.first_person_extension, "idle")
	arg_2_0.status_extension:set_inspecting(true)
	arg_2_0:_update_emote()

	arg_2_0._current_zoom = 0
	arg_2_0._current_zoom_target = 0.7

	Managers.state.camera:set_variable(arg_2_0.player.viewport_name, "emote_zoom", 1)

	local var_2_1 = Managers.ui:get_hud_component("EmotePhotomodeUI")

	var_2_1:set_enabled(true)

	arg_2_0._emote_ui = var_2_1
end

function PlayerCharacterStateEmote.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")
	arg_3_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	arg_3_0.status_extension:set_inspecting(false)

	if Managers.state.network:game() then
		local var_3_0 = arg_3_0.unit_storage:go_id(arg_3_0.unit)

		arg_3_0.network_transmit:send_rpc_server("rpc_server_cancel_emote", var_3_0)
	end

	Managers.state.game_mode:game_mode():set_photomode_enabled(false)
	arg_3_0._emote_ui:set_enabled(false)

	arg_3_0._emote_ui = nil
	arg_3_0.current_emote = nil
end

function PlayerCharacterStateEmote.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.input_extension
	local var_4_2 = Managers.state.camera
	local var_4_3 = arg_4_0.status_extension
	local var_4_4 = arg_4_0.first_person_extension
	local var_4_5 = arg_4_0.locomotion_extension

	var_4_1:get("action_career", true)

	if CharacterStateHelper.do_common_state_transitions(var_4_3, var_4_0) then
		return
	end

	local var_4_6 = arg_4_0.world

	if CharacterStateHelper.is_ledge_hanging(var_4_6, arg_4_1, arg_4_0.temp_params) then
		var_4_0:change_state("ledge_hanging", arg_4_0.temp_params)

		return
	end

	if CharacterStateHelper.is_overcharge_exploding(var_4_3) then
		var_4_0:change_state("overcharge_exploding")

		return
	end

	local var_4_7 = Managers.input:get_service("Player")
	local var_4_8 = Managers.input:is_device_active("gamepad")

	if var_4_8 then
		if var_4_7:get("crouch", true) then
			var_4_0:change_state("standing", arg_4_0.temp_params)

			return
		end
	else
		local var_4_9 = var_4_3:is_crouching()

		if (var_4_1:get("jump") or var_4_1:get("jump_only")) and not var_4_3:is_crouching() and (not var_4_9 or CharacterStateHelper.can_uncrouch(arg_4_1)) and var_4_5:jump_allowed() then
			if var_4_9 then
				CharacterStateHelper.uncrouch(arg_4_1, arg_4_5, var_4_4, var_4_3)
			end

			var_4_0:change_state("jumping")
			var_4_4:change_state("jumping")

			return
		end

		if CharacterStateHelper.has_move_input(var_4_1) then
			local var_4_10 = arg_4_0.temp_params

			var_4_0:change_state("walking", var_4_10)
			var_4_4:change_state("walking")

			return
		end
	end

	local var_4_11 = 0

	if var_4_8 then
		var_4_11 = var_4_7:get("emote_camera_zoom_in") - var_4_7:get("emote_camera_zoom_out")
		var_4_11 = var_4_11 * var_0_1
	else
		var_4_11 = var_4_7:get("emote_camera_zoom").y * var_0_0
	end

	local var_4_12 = Managers.mechanism:get_social_wheel_class()
	local var_4_13 = Managers.ui:get_hud_component(var_4_12)

	if not (var_4_13 and var_4_13:is_active()) and var_4_7:get("emote_toggle_hud_visibility", true) then
		local var_4_14 = Managers.state.game_mode:game_mode()

		var_4_14:set_photomode_enabled(not var_4_14:photomode_enabled())
	end

	arg_4_0._current_zoom_target = math.clamp(arg_4_0._current_zoom_target + var_4_11, 0, 1)

	if arg_4_0._current_zoom ~= arg_4_0._current_zoom_target then
		local var_4_15 = arg_4_0._current_zoom
		local var_4_16 = math.min(arg_4_3 * var_0_2, 1)
		local var_4_17 = math.lerp(var_4_15, arg_4_0._current_zoom_target, var_4_16)

		arg_4_0._current_zoom = var_4_17

		var_4_2:set_variable(arg_4_0.player.viewport_name, "emote_zoom", 1 - var_4_17)
	end

	arg_4_0:_update_emote()
	arg_4_0.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_4_1, arg_4_0.player.viewport_name, var_4_4, var_4_3, arg_4_0.inventory_extension)
end

function PlayerCharacterStateEmote._update_emote(arg_5_0)
	local var_5_0, var_5_1 = arg_5_0.cosmetic_extension:get_queued_3p_emote()

	if var_5_0 then
		local var_5_2 = arg_5_0.unit_storage:go_id(arg_5_0.unit)
		local var_5_3 = NetworkLookup.anims[var_5_0]

		arg_5_0.network_transmit:send_rpc_server("rpc_server_request_emote", var_5_2, var_5_3, var_5_1)
		arg_5_0.cosmetic_extension:consume_queued_3p_emote()

		arg_5_0.current_emote = var_5_0
	end
end
