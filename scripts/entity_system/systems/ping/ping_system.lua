-- chunkname: @scripts/entity_system/systems/ping/ping_system.lua

require("scripts/unit_extensions/default_player_unit/ping/context_aware_ping_extension")
require("scripts/unit_extensions/default_player_unit/ping/ping_target_extension")
require("scripts/settings/ping_templates")

local var_0_0 = 15
local var_0_1 = 5
local var_0_2 = 0.05
local var_0_3 = 5
local var_0_4 = 2
local var_0_5 = 0.7
local var_0_6 = true
local var_0_7 = {
	"rpc_ping_unit",
	"rpc_ping_world_position",
	"rpc_remove_ping",
	"rpc_social_message"
}
local var_0_8 = {
	"ContextAwarePingExtension",
	"PingTargetExtension"
}
local var_0_9 = {
	"world_marker_response_1",
	"world_marker_response_2",
	"world_marker_response_3"
}
local var_0_10 = {
	"world_marker_icon_response_1",
	"world_marker_icon_response_2",
	"world_marker_icon_response_3"
}

PingSystem = class(PingSystem, ExtensionSystemBase)

PingSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	PingSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_8)

	local var_1_0 = arg_1_1.network_event_delegate

	var_1_0:register(arg_1_0, unpack(var_0_7))

	arg_1_0._network_event_delegate = var_1_0
	arg_1_0._unit_storage = arg_1_1.unit_storage
	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._pinged_units = {}
	arg_1_0._world_markers = {}
	arg_1_0._last_ping_t = {}

	local var_1_1 = Managers.state.game_mode:settings().ping_mode

	if var_1_1 then
		arg_1_0._outlines_enabled = var_1_1.outlines
		arg_1_0._world_markers_enabled = var_1_1.world_markers
	else
		arg_1_0._outlines_enabled = {
			item = true,
			unit = true
		}
		arg_1_0._world_markers_enabled = false
	end

	arg_1_0._pings_enabled = arg_1_0._outlines_enabled.item or arg_1_0._outlines_enabled.unit or arg_1_0._world_markers_enabled
	arg_1_0._current_mechanism_name = Managers.mechanism:current_mechanism_name()
end

PingSystem.destroy = function (arg_2_0)
	arg_2_0._network_event_delegate:unregister(arg_2_0)
end

PingSystem.freeze = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._pinged_units[arg_3_1]

	if var_3_0 then
		if var_3_0._pinged then
			local var_3_1 = arg_3_0:_is_outline_enabled(arg_3_1)

			var_3_0:set_pinged(false, nil, nil, var_3_1)
		end

		arg_3_0._pinged_units[arg_3_1] = nil
	end
end

PingSystem.unfreeze = function (arg_4_0, arg_4_1)
	return
end

PingSystem.update = function (arg_5_0, arg_5_1, arg_5_2)
	PingSystem.super.update(arg_5_0, arg_5_1, arg_5_2)

	if not arg_5_0._pings_enabled then
		return
	end

	if arg_5_0.is_server then
		arg_5_0:_update_server(arg_5_1, arg_5_2)
	else
		arg_5_0:_update_client(arg_5_1, arg_5_2)
	end
end

PingSystem._update_server = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._pinged_units

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		local var_6_1 = iter_6_1.pinged_unit

		if ALIVE[var_6_1] then
			if ALIVE[iter_6_0] then
				local var_6_2 = iter_6_1.start_time

				if iter_6_0 == var_6_1 and arg_6_2 >= var_6_2 + var_0_1 then
					arg_6_0:_remove_ping(iter_6_0)
				end

				if arg_6_0._current_mechanism_name == "versus" and iter_6_1.ping_type == PingTypes.ENEMY_GENERIC then
					if arg_6_2 >= var_6_2 + var_0_3 then
						arg_6_0:_remove_ping(iter_6_0)
					end
				elseif arg_6_2 >= var_6_2 + var_0_0 then
					arg_6_0:_remove_ping(iter_6_0)
				end
			else
				arg_6_0:_remove_ping(iter_6_0)
			end
		elseif iter_6_1.position then
			if arg_6_2 >= iter_6_1.start_time + var_0_0 then
				arg_6_0:_remove_ping(iter_6_0)
			end
		else
			arg_6_0:_remove_ping(iter_6_0)
		end
	end
end

PingSystem._update_client = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._pinged_units

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if not (ALIVE[iter_7_0] and (iter_7_1.position or ALIVE[iter_7_1.pinged_unit])) then
			arg_7_0:_remove_ping(iter_7_0)
		end
	end
end

PingSystem.hot_join_sync = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._pinged_units
	local var_8_1 = Managers.state.network
	local var_8_2 = PEER_ID_TO_CHANNEL[arg_8_1]

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		repeat
			local var_8_3 = iter_8_1.pinged_unit

			if not ALIVE[iter_8_0] or var_8_3 and not ALIVE[var_8_3] then
				break
			end

			local var_8_4 = var_8_1:unit_game_object_id(iter_8_0)
			local var_8_5
			local var_8_6

			if var_8_3 then
				var_8_5, var_8_6 = var_8_1:game_object_or_level_id(var_8_3)
			end

			local var_8_7 = iter_8_1.position

			if var_8_4 then
				if var_8_5 then
					RPC.rpc_ping_unit(var_8_2, var_8_4, var_8_5, var_8_6, iter_8_1.flash, iter_8_1.ping_type, iter_8_1.social_wheel_event_id)

					break
				end

				if var_8_7 then
					local var_8_8 = false

					RPC.rpc_ping_world_position(var_8_2, var_8_4, Vector3(unpack(var_8_7)), iter_8_1.ping_type, iter_8_1.social_wheel_event_id, var_8_8)
				end
			end
		until true
	end
end

PingSystem._handle_ping = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	if arg_9_5 and not Unit.alive(arg_9_5) then
		return
	end

	if arg_9_5 then
		local var_9_0 = ScriptUnit.has_extension(arg_9_5, "buff_system")

		if var_9_0 and var_9_0:has_buff_type("mutator_shadow_damage_reduction") then
			return
		end
	end

	if arg_9_1 == PingTypes.CANCEL then
		arg_9_0:_remove_ping(arg_9_4)

		return
	end

	if not arg_9_1 or arg_9_1 == PingTypes.CHAT_ONLY then
		return
	end

	local var_9_1 = arg_9_3:get_party()

	if not var_9_1 then
		return
	end

	local var_9_2 = false

	if arg_9_0._pinged_units[arg_9_4] then
		var_9_2 = arg_9_5 and arg_9_5 == arg_9_0._pinged_units[arg_9_4].pinged_unit

		arg_9_0:_remove_ping(arg_9_4, true)
	end

	local var_9_3 = Managers.time:time("game")
	local var_9_4 = Managers.state.network
	local var_9_5 = var_9_4:unit_game_object_id(arg_9_4)
	local var_9_6
	local var_9_7

	if arg_9_5 then
		var_9_6, var_9_7 = var_9_4:game_object_or_level_id(arg_9_5)
	end

	arg_9_0._pinged_units[arg_9_4] = {
		start_time = var_9_3,
		pinged_unit = arg_9_5,
		flash = arg_9_7,
		party_id = var_9_1.party_id,
		pinger_unique_id = arg_9_3:unique_id(),
		pinger_unit_id = var_9_5,
		pinged_unit_id = var_9_6,
		ping_type = arg_9_1,
		position = arg_9_6 and {
			Vector3.to_elements(arg_9_6)
		},
		social_wheel_event_id = arg_9_2
	}

	Managers.telemetry_events:ping_used(arg_9_3, PingTypes[arg_9_1], arg_9_5, POSITION_LOOKUP[arg_9_4])

	if arg_9_0.is_server then
		if arg_9_5 then
			arg_9_0.network_transmit:send_rpc_party_clients("rpc_ping_unit", var_9_1, true, var_9_5, var_9_6, var_9_7, arg_9_7, arg_9_1, arg_9_2)
			arg_9_0:_play_ping_vo(arg_9_4, arg_9_5, arg_9_1, arg_9_2)
		elseif arg_9_6 then
			local var_9_8 = false

			arg_9_0.network_transmit:send_rpc_party_clients("rpc_ping_world_position", var_9_1, true, var_9_5, arg_9_6, arg_9_1, arg_9_2, var_9_8)
			arg_9_0:_play_ping_vo(arg_9_4, nil, arg_9_1, arg_9_2)
		end
	end

	if DEDICATED_SERVER then
		return
	end

	local var_9_9 = Managers.player:local_player():unique_id()

	if not Managers.party:is_player_in_party(var_9_9, var_9_1.party_id) then
		return
	end

	if arg_9_5 then
		arg_9_0:_add_unit_ping(arg_9_4, arg_9_5, arg_9_7, arg_9_1)
	end

	if arg_9_0._world_markers_enabled and arg_9_1 ~= PingTypes.VO_ONLY then
		arg_9_0:_add_world_marker(arg_9_4, arg_9_5, arg_9_6, arg_9_1, arg_9_2)
	end

	local var_9_10 = false
	local var_9_11 = arg_9_0._last_ping_t[arg_9_4] or 0

	if var_9_2 and (not var_0_6 or var_9_3 < var_9_11 + var_0_4) then
		var_9_10 = true
	elseif not arg_9_5 and var_9_3 < var_9_11 + var_0_4 then
		var_9_10 = true
	elseif arg_9_5 and not var_9_2 and var_9_3 < var_9_11 + var_0_5 then
		var_9_10 = true
	else
		arg_9_0._last_ping_t[arg_9_4] = var_9_3
	end

	if not var_9_10 then
		local var_9_12 = NetworkLookup.social_wheel_events[arg_9_2]
		local var_9_13 = SocialWheelSettingsLookup[var_9_12]
		local var_9_14 = var_9_13 and var_9_13.ping_sound_effect

		if var_9_14 then
			arg_9_0:_play_sound(var_9_14)
		else
			local var_9_15 = arg_9_5 and Unit.get_data(arg_9_5, "breed") and "hud_ping_enemy" or "hud_ping"

			arg_9_0:_play_sound(var_9_15)
		end
	end
end

PingSystem._handle_chat = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	if arg_10_5 and arg_10_1 == PingTypes.ENEMY_GENERIC then
		local var_10_0 = Unit.get_data(arg_10_5, "breed")

		if not var_10_0 or var_10_0.is_ai then
			return
		end
	end

	local var_10_1 = arg_10_2 and arg_10_2 ~= NetworkLookup.social_wheel_events["n/a"]
	local var_10_2 = var_10_1 and SocialWheelSettingsLookup[NetworkLookup.social_wheel_events[arg_10_2]]
	local var_10_3
	local var_10_4

	if not MechanismOverrides.get(IgnoreChatPings)[arg_10_1] then
		if var_10_1 then
			if IS_CONSOLE and arg_10_1 ~= PingTypes.LOCAL_ONLY then
				local var_10_5 = arg_10_3:get_party()
				local var_10_6 = arg_10_5 and Managers.state.network:unit_game_object_id(arg_10_5) or 0
				local var_10_7 = true

				arg_10_0.network_transmit:send_rpc_party("rpc_social_wheel_event", var_10_5, var_10_7, arg_10_3.peer_id, arg_10_2, var_10_6)
			end

			local var_10_8 = var_10_2.event_text_func

			var_10_3, var_10_4 = var_10_2.event_text

			if var_10_8 and arg_10_5 then
				local var_10_9 = false

				var_10_3, var_10_4 = var_10_8(arg_10_5, var_10_2, var_10_9)
			end

			if not var_10_3 and arg_10_6 then
				var_10_3 = arg_10_6[math.random(1, #arg_10_6)]
			end
		elseif arg_10_6 then
			var_10_3 = arg_10_6[math.random(1, #arg_10_6)]
		end

		if var_10_3 then
			local var_10_10 = true
			local var_10_11 = true
			local var_10_12 = arg_10_3:network_id()
			local var_10_13 = 1
			local var_10_14
			local var_10_15 = Managers.mechanism:game_mechanism()

			if var_10_15.get_chat_channel then
				var_10_13, var_10_14 = var_10_15:get_chat_channel(var_10_12, false)
			end

			Managers.chat:send_chat_message(var_10_13, arg_10_3:local_player_id(), var_10_3, var_10_10, var_10_4, var_10_11, nil, var_10_14, nil, nil, var_10_12)
		end
	end

	if var_10_1 then
		local var_10_16 = var_10_2.execute_func

		if var_10_16 then
			local var_10_17 = SocialWheelSettings[var_10_2.category_name]

			var_10_16(var_10_2.data, arg_10_5, arg_10_3, var_10_17)
		end
	end
end

PingSystem.handle_local_ping = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	arg_11_0:_handle_chat(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
end

PingSystem.is_ping_cancel = function (arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0._world_markers_enabled then
		return
	end

	if arg_12_2 then
		local var_12_0 = arg_12_0._world
		local var_12_1 = ScriptWorld.viewport(var_12_0, "player_1")
		local var_12_2 = var_12_1 and ScriptViewport.camera(var_12_1)

		if var_12_2 and Camera.inside_frustum(var_12_2, arg_12_2) then
			local var_12_3 = Vector3Aux.unbox(WorldMarkerTemplates.ping.position_offset)
			local var_12_4 = ScriptCamera.world_to_screen_uv(var_12_2, arg_12_2)
			local var_12_5 = var_0_2 * var_0_2

			for iter_12_0, iter_12_1 in pairs(arg_12_0._pinged_units) do
				local var_12_6 = iter_12_1.position and Vector3(unpack(iter_12_1.position)) or POSITION_LOOKUP[iter_12_1.pinged_unit]

				if var_12_6 then
					local var_12_7 = var_12_6 + var_12_3

					if Camera.inside_frustum(var_12_2, var_12_7) then
						local var_12_8 = ScriptCamera.world_to_screen_uv(var_12_2, var_12_7)

						if var_12_5 >= Vector3.distance_squared(var_12_8, var_12_4) and arg_12_1 == iter_12_1.pinger_unique_id then
							return PingTypes.CANCEL, var_12_7
						end
					end
				end
			end
		end
	end
end

PingSystem._get_unit_ping_type = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not arg_13_0._world_markers_enabled then
		return arg_13_3
	end

	if arg_13_3 == PingTypes.ACKNOWLEDGE or arg_13_3 == PingTypes.DENY then
		return nil
	end

	if arg_13_3 == PingTypes.CONTEXT then
		if not arg_13_1 or not ALIVE[arg_13_1] then
			return PingTypes.MOVEMENT_GENERIC
		end

		if ScriptUnit.has_extension(arg_13_1, "pickup_system") then
			return PingTypes.PLAYER_PICK_UP
		end

		local var_13_0 = Managers.party:get_party_from_unique_id(arg_13_2)
		local var_13_1 = Managers.state.side
		local var_13_2 = var_13_1.side_by_party[var_13_0]
		local var_13_3 = var_13_1.side_by_unit[arg_13_1]

		if var_13_1:is_enemy_by_side(var_13_2, var_13_3) then
			return PingTypes.ENEMY_GENERIC
		end

		return PingTypes.PLAYER_HELP
	end

	return arg_13_3
end

PingSystem._get_world_position_ping_type = function (arg_14_0, arg_14_1, arg_14_2)
	if arg_14_2 then
		return PingTypes.ENEMY_POSITION
	end

	if arg_14_1 == PingTypes.ACKNOWLEDGE or arg_14_1 == PingTypes.DENY then
		return arg_14_1, nil
	end

	if arg_14_1 == PingTypes.CONTEXT then
		return PingTypes.MOVEMENT_GENERIC, nil
	end

	return arg_14_1, nil
end

PingSystem._add_unit_ping = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = ScriptUnit.has_extension(arg_15_2, "ping_system")

	if not var_15_0 then
		return
	end

	local var_15_1
	local var_15_2
	local var_15_3
	local var_15_4 = MechanismOverrides.get(PingTemplates, arg_15_0._current_mechanism_name)

	for iter_15_0, iter_15_1 in pairs(var_15_4) do
		if iter_15_1:check_func(arg_15_1, arg_15_2) then
			local var_15_5, var_15_6

			var_15_1, var_15_5, var_15_6 = iter_15_1:exec_func(arg_15_0, arg_15_1, arg_15_2, arg_15_4, arg_15_0._current_mechanism_name)

			break
		end
	end

	if not var_15_1 then
		return
	end

	if var_15_0.set_pinged then
		local var_15_7 = arg_15_0:_is_outline_enabled(arg_15_2)

		var_15_0:set_pinged(true, arg_15_3, arg_15_1, var_15_7)
	end

	local var_15_8 = Managers.player:unit_owner(arg_15_1)

	if var_15_8 and var_15_8.local_player then
		local var_15_9 = Managers.state.entity:system("ai_system"):get_attributes(arg_15_2)
		local var_15_10 = Unit.get_data(arg_15_2, "breed")

		if var_15_10 and var_15_10.show_health_bar or var_15_9.grudge_marked then
			Managers.state.event:trigger("boss_health_bar_register_unit", arg_15_2, "ping")
		end
	end
end

PingSystem._add_world_marker = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	if not arg_16_2 and not arg_16_3 then
		return
	end

	if arg_16_4 == PingTypes.LOCAL_ONLY then
		return
	end

	local var_16_0
	local var_16_1
	local var_16_2
	local var_16_3
	local var_16_4 = MechanismOverrides.get(PingTemplates, arg_16_0._current_mechanism_name)

	for iter_16_0, iter_16_1 in pairs(var_16_4) do
		if iter_16_1:check_func(arg_16_1, arg_16_2) then
			var_16_0, var_16_1, var_16_3 = iter_16_1:exec_func(arg_16_0, arg_16_1, arg_16_2, arg_16_4, arg_16_5, arg_16_0._current_mechanism_name)

			break
		end
	end

	if not var_16_0 then
		return
	end

	if not var_16_3 and arg_16_5 and arg_16_5 ~= NetworkLookup.social_wheel_events["n/a"] then
		local var_16_5 = NetworkLookup.social_wheel_events[arg_16_5]
		local var_16_6 = SocialWheelSettingsLookup[var_16_5]

		var_16_3 = var_16_6.icon

		if var_16_6.event_text_func and arg_16_2 then
			local var_16_7, var_16_8 = var_16_6.event_text_func(arg_16_2, var_16_6)

			var_16_8 = var_16_8 and LocalizeArray(var_16_8)

			if var_16_8 then
				var_16_2 = string.format(Localize(var_16_7), unpack(var_16_8))
			else
				var_16_2 = Localize(var_16_7)
			end
		else
			var_16_2 = Localize(var_16_6.event_text)
		end
	end

	if not var_16_3 then
		return
	end

	local function var_16_9(arg_17_0, arg_17_1)
		arg_17_1.content.icon = var_16_3
		arg_17_1.content.icon_pulse = var_16_3
		arg_17_1.content.text = var_16_2 or var_16_1 and var_16_1[1]

		local var_17_0 = Managers.player:owner(arg_16_1)
		local var_17_1 = var_17_0:profile_index()
		local var_17_2 = var_17_0:career_index()
		local var_17_3 = SPProfiles[var_17_1].careers[var_17_2]
		local var_17_4 = Managers.mechanism:current_mechanism_name()
		local var_17_5

		if var_17_4 == "versus" then
			var_17_5 = arg_17_1.content and arg_17_1.content.text == "MOVEMENT_GENERIC" and Colors.get_color_table_with_alpha("local_player_picking", 200) or Colors.get_color_table_with_alpha("opponent_team", 200)
		else
			var_17_5 = Colors.get_color_table_with_alpha(var_17_3.display_name, 255) or Colors.color_definitions.white
		end

		arg_17_1.style.icon.color = table.clone(var_17_5)
		arg_17_1.style.icon_spawn_pulse.color = table.clone(var_17_5)
		arg_17_1.style.icon_spawn_pulse.default_color = arg_17_1.style.icon.color
		arg_16_0._world_markers[arg_16_1] = {
			id = arg_17_0,
			widget = arg_17_1
		}
	end

	arg_16_3 = arg_16_3 or Unit.local_position(arg_16_2, 0)

	Managers.state.event:trigger("add_world_marker_position", "ping", arg_16_3, var_16_9)
end

PingSystem.remove_ping_from_unit = function (arg_18_0, arg_18_1)
	if not arg_18_0._pings_enabled then
		return
	end

	for iter_18_0, iter_18_1 in pairs(arg_18_0._pinged_units) do
		if arg_18_1 == iter_18_1.pinged_unit then
			arg_18_0:_remove_ping(iter_18_0)
		end
	end
end

PingSystem._remove_ping = function (arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_1 then
		return
	end

	local var_19_0 = arg_19_0._pinged_units[arg_19_1]
	local var_19_1 = arg_19_0._world_markers[arg_19_1]
	local var_19_2 = var_19_1 and var_19_1.id

	arg_19_0._pinged_units[arg_19_1] = nil
	arg_19_0._world_markers[arg_19_1] = nil

	if not var_19_0 then
		return
	end

	if arg_19_0.is_server and not arg_19_2 then
		local var_19_3 = Managers.party:get_party(var_19_0.party_id)
		local var_19_4 = var_19_0.pinger_unit_id

		arg_19_0.network_transmit:send_rpc_party_clients("rpc_remove_ping", var_19_3, true, var_19_4)
	end

	local var_19_5 = var_19_0.pinged_unit

	if ALIVE[var_19_5] then
		local var_19_6 = ScriptUnit.has_extension(var_19_5, "ping_system")

		if var_19_6 and var_19_6.set_pinged and var_19_6:pinged() then
			local var_19_7 = arg_19_0:_is_outline_enabled(var_19_5)

			var_19_6:set_pinged(false, nil, arg_19_1, var_19_7)
		end
	end

	if arg_19_0._world_markers_enabled and var_19_2 then
		Managers.state.event:trigger("remove_world_marker", var_19_2)
	end

	local var_19_8 = var_19_0.child_pings

	if var_19_8 then
		for iter_19_0 = 1, #var_19_8 do
			local var_19_9 = var_19_8[iter_19_0]

			arg_19_0:_remove_ping(var_19_9, arg_19_2)
		end
	end
end

PingSystem.get_pinged_unit = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._pinged_units[arg_20_1]

	return var_20_0 and Unit.alive(var_20_0.pinged_unit) and var_20_0.pinged_unit
end

PingSystem._is_outline_enabled = function (arg_21_0, arg_21_1)
	if arg_21_0._outlines_enabled.item and ScriptUnit.has_extension(arg_21_1, "pickup_system") and ScriptUnit.has_extension(arg_21_1, "interactable_system") then
		return true
	end

	return arg_21_0._outlines_enabled.unit
end

PingSystem._play_ping_vo = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = FrameTable.alloc_table()
	local var_22_1 = ScriptUnit.extension_input(arg_22_1, "dialogue_system")

	var_22_0.is_ping = true

	if arg_22_2 and Unit.alive(arg_22_2) then
		local var_22_2

		if Managers.state.side:is_enemy(arg_22_1, arg_22_2) then
			local var_22_3 = BLACKBOARDS[arg_22_2]

			if var_22_3 then
				local var_22_4 = var_22_3.breed.name
				local var_22_5 = POSITION_LOOKUP[arg_22_2] or Unit.world_position(arg_22_2, 0)
				local var_22_6 = Vector3.flat(var_22_5)
				local var_22_7 = POSITION_LOOKUP[arg_22_1]
				local var_22_8 = Vector3.flat(var_22_7)

				var_22_0.enemy_tag = var_22_4
				var_22_0.enemy_unit = arg_22_2
				var_22_0.distance = Vector3.distance(var_22_6, var_22_8)

				var_22_1:trigger_networked_dialogue_event("seen_enemy", var_22_0)
			end

			return
		end

		local var_22_9 = ScriptUnit.has_extension(arg_22_2, "status_system")

		if var_22_9 then
			local var_22_10 = var_22_9:disabled_vo_reason()

			if var_22_10 then
				var_22_0.source_name = ScriptUnit.extension(arg_22_1, "dialogue_system").context.player_profile
				var_22_0.target_name = ScriptUnit.extension(arg_22_2, "dialogue_system").context.player_profile

				var_22_1:trigger_networked_dialogue_event(var_22_10, var_22_0)
			end

			return
		end

		local var_22_11 = Unit.get_data(arg_22_2, "lookat_tag")

		if var_22_11 then
			var_22_0.item_tag = var_22_11 or Unit.debug_name(arg_22_2)

			var_22_1:trigger_networked_dialogue_event("seen_item", var_22_0)

			return
		end
	else
		local var_22_12

		if arg_22_4 and arg_22_4 ~= NetworkLookup.social_wheel_events["n/a"] then
			local var_22_13 = NetworkLookup.social_wheel_events[arg_22_4]

			var_22_12 = SocialWheelSettingsLookup[var_22_13].vo_event_name
		end

		if not var_22_12 then
			if arg_22_3 == PingTypes.ACKNOWLEDGE then
				var_22_12 = "vw_affirmative"
			elseif arg_22_3 == PingTypes.CANCEL then
				var_22_12 = "vw_cancel"
			elseif arg_22_3 == PingTypes.DENY then
				var_22_12 = "vw_negation"
			elseif arg_22_3 == PingTypes.ENEMY_GENERIC then
				var_22_12 = "vw_attack_now"
			elseif arg_22_3 == PingTypes.MOVEMENT_GENERIC then
				var_22_12 = "vw_go_here"
			elseif arg_22_3 == PingTypes.PLAYER_PICK_UP_ACKNOWLEDGE then
				var_22_12 = "vw_answer_ping"
			else
				return
			end
		end

		if var_22_12 then
			var_22_1:trigger_networked_dialogue_event(var_22_12, var_22_0)
		end
	end
end

PingSystem.rpc_ping_unit = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7)
	local var_23_0 = arg_23_0._unit_storage:unit(arg_23_2)
	local var_23_1 = Managers.state.network:game_object_or_level_unit(arg_23_3, arg_23_4)
	local var_23_2 = Managers.player:unit_owner(var_23_0)

	if not var_23_2 then
		return
	end

	local var_23_3 = var_23_2:unique_id()

	if arg_23_0.is_server then
		arg_23_6 = arg_23_0:_get_unit_ping_type(var_23_1, var_23_3, arg_23_6)

		local var_23_4
		local var_23_5
		local var_23_6 = MechanismOverrides.get(PingTemplates, arg_23_0._current_mechanism_name)

		for iter_23_0, iter_23_1 in pairs(var_23_6) do
			if iter_23_1:check_func(var_23_0, var_23_1) then
				var_23_4, var_23_5 = iter_23_1:exec_func(arg_23_0, var_23_0, var_23_1, arg_23_6, arg_23_7, arg_23_0._current_mechanism_name)

				break
			end
		end

		if not var_23_4 then
			return
		end

		arg_23_0:_handle_ping(arg_23_6, arg_23_7, var_23_2, var_23_0, var_23_1, nil, arg_23_5)
		arg_23_0:_handle_chat(arg_23_6, arg_23_7, var_23_2, var_23_0, var_23_1, var_23_5)
	else
		if Managers.chat:ignoring_peer_id(var_23_2.peer_id) then
			return
		end

		arg_23_0:_handle_ping(arg_23_6, arg_23_7, var_23_2, var_23_0, var_23_1, nil, arg_23_5)
	end
end

PingSystem.rpc_ping_world_position = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	local var_24_0 = arg_24_0._unit_storage:unit(arg_24_2)
	local var_24_1 = Managers.player:unit_owner(var_24_0)

	if not var_24_1 then
		return
	end

	if arg_24_0.is_server then
		local var_24_2
		local var_24_3

		arg_24_4, var_24_3 = arg_24_0:_get_world_position_ping_type(arg_24_4, arg_24_6)
		arg_24_3 = var_24_3 and var_24_3 or arg_24_3

		local var_24_4
		local var_24_5 = MechanismOverrides.get(PingTemplates, arg_24_0._current_mechanism_name)

		for iter_24_0, iter_24_1 in pairs(var_24_5) do
			if iter_24_1:check_func(var_24_0, nil) then
				iter_24_0, var_24_4, iter_24_0 = iter_24_1:exec_func(arg_24_0, var_24_0, nil, arg_24_4, arg_24_5, arg_24_0._current_mechanism_name)

				break
			end
		end

		arg_24_0:_handle_ping(arg_24_4, arg_24_5, var_24_1, var_24_0, nil, arg_24_3, nil)
		arg_24_0:_handle_chat(arg_24_4, arg_24_5, var_24_1, var_24_0, nil, var_24_4)
	else
		if Managers.chat:ignoring_peer_id(var_24_1.peer_id) then
			return
		end

		arg_24_0:_handle_ping(arg_24_4, arg_24_5, var_24_1, var_24_0, nil, arg_24_3, nil)
	end
end

PingSystem.rpc_social_message = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	fassert(arg_25_0.is_server, "Only server should get this")

	local var_25_0 = arg_25_0._unit_storage:unit(arg_25_2)
	local var_25_1 = arg_25_0._unit_storage:unit(arg_25_4)
	local var_25_2 = Managers.player:unit_owner(var_25_0)

	arg_25_0:_handle_chat(nil, arg_25_3, var_25_2, var_25_0, var_25_1)
end

PingSystem.rpc_remove_ping = function (arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0._pings_enabled then
		return
	end

	local var_26_0 = arg_26_0._unit_storage:unit(arg_26_2)

	arg_26_0:_remove_ping(var_26_0)
end

PingSystem._play_sound = function (arg_27_0, arg_27_1)
	WwiseWorld.trigger_event(arg_27_0._wwise_world, arg_27_1)
end
