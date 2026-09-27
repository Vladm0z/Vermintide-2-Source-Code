-- chunkname: @scripts/entity_system/systems/ping/ping_system.lua

require("scripts/unit_extensions/default_player_unit/ping/context_aware_ping_extension")
require("scripts/unit_extensions/default_player_unit/ping/ping_target_extension")
require("scripts/settings/ping_templates")

local num = 15
local num_2 = 5
local num_3 = 0.05
local num_4 = 5
local num_5 = 2
local num_6 = 0.7
local flag = true
local tbl = {
	"rpc_ping_unit",
	"rpc_ping_world_position",
	"rpc_remove_ping",
	"rpc_social_message"
}
local tbl_2 = {
	"ContextAwarePingExtension",
	"PingTargetExtension"
}
local tbl_3 = {
	"world_marker_response_1",
	"world_marker_response_2",
	"world_marker_response_3"
}
local tbl_4 = {
	"world_marker_icon_response_1",
	"world_marker_icon_response_2",
	"world_marker_icon_response_3"
}

PingSystem = class(PingSystem, ExtensionSystemBase)

PingSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	PingSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self._network_event_delegate = network_event_delegate
	self._unit_storage = arg_1_1.unit_storage
	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)
	self._pinged_units = {}
	self._world_markers = {}
	self._last_ping_t = {}

	local ping_mode = Managers.state.game_mode:settings().ping_mode

	if not ping_mode then
		self._outlines_enabled = ping_mode.outlines
		self._world_markers_enabled = ping_mode.world_markers
	else
		self._outlines_enabled = {
			item = true,
			unit = true
		}
		self._world_markers_enabled = false
	end

	local item = self._outlines_enabled.item

	if not item then
		item = self._outlines_enabled.unit
		item = item or self._world_markers_enabled
	end

	self._pings_enabled = item
	self._current_mechanism_name = Managers.mechanism:current_mechanism_name()
end

PingSystem.destroy = function (self)
	-- function 2
	self._network_event_delegate:unregister(self)
end

PingSystem.freeze = function (self, arg_3_1)
	-- function 3
	local var_3_0 = self._pinged_units[arg_3_1]

	if not var_3_0 then
		if not var_3_0._pinged then
			local _is_outline_enabled = self:_is_outline_enabled(arg_3_1)

			var_3_0:set_pinged(false, nil, nil, _is_outline_enabled)
		end

		self._pinged_units[arg_3_1] = nil
	end
end

PingSystem.unfreeze = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

PingSystem.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	PingSystem.super.update(self, arg_5_1, arg_5_2)

	if not self._pings_enabled then
		return
	end

	if not self.is_server then
		self:_update_server(arg_5_1, arg_5_2)
	else
		self:_update_client(arg_5_1, arg_5_2)
	end
end

PingSystem._update_server = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _pinged_units = self._pinged_units

	for k, v in pairs(_pinged_units) do
		local pinged_unit = v.pinged_unit

		if not ALIVE[pinged_unit] then
			if not ALIVE[k] then
				local start_time = v.start_time

				if not (k ~= pinged_unit or not (arg_6_2 >= start_time + num_2)) then
					self:_remove_ping(k)
				end

				if not (self._current_mechanism_name ~= "versus" or v.ping_type ~= PingTypes.ENEMY_GENERIC) then
					if arg_6_2 >= start_time + num_4 then
						self:_remove_ping(k)
					end
				elseif arg_6_2 >= start_time + num then
					self:_remove_ping(k)
				end
			else
				self:_remove_ping(k)
			end
		elseif not v.position then
			if arg_6_2 >= v.start_time + num then
				self:_remove_ping(k)
			end
		else
			self:_remove_ping(k)
		end
	end
end

PingSystem._update_client = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _pinged_units = self._pinged_units

	for k, v in pairs(_pinged_units) do
		local var_7_1 = ALIVE[k]

		if not var_7_1 then
			var_7_1 = v.position
			var_7_1 = var_7_1 or ALIVE[v.pinged_unit]
		end

		if not var_7_1 then
			self:_remove_ping(k)
		end
	end
end

PingSystem.hot_join_sync = function (self, arg_8_1)
	-- function 8
	local _pinged_units = self._pinged_units
	local network = Managers.state.network
	local var_8_2 = PEER_ID_TO_CHANNEL[arg_8_1]

	for k, v in pairs(_pinged_units) do
		repeat
			local pinged_unit = v.pinged_unit

			if not (not ALIVE[k] and not pinged_unit and ALIVE[pinged_unit]) then
				break
			end

			local unit_game_object_id = network:unit_game_object_id(k)
			local var_8_5
			local var_8_6

			if not pinged_unit then
				var_8_5, var_8_6 = network:game_object_or_level_id(pinged_unit)
			end

			local position = v.position

			if not unit_game_object_id then
				if not var_8_5 then
					RPC.rpc_ping_unit(var_8_2, unit_game_object_id, var_8_5, var_8_6, v.flash, v.ping_type, v.social_wheel_event_id)

					break
				end

				if not position then
					local flag = false

					RPC.rpc_ping_world_position(var_8_2, unit_game_object_id, Vector3(unpack(position)), v.ping_type, v.social_wheel_event_id, flag)
				end
			end
		until true
	end
end

PingSystem._handle_ping = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	if not (not arg_9_5 and Unit.alive(arg_9_5)) then
		return
	end

	if not arg_9_5 then
		local has_extension = ScriptUnit.has_extension(arg_9_5, "buff_system")

		if not has_extension and not has_extension:has_buff_type("mutator_shadow_damage_reduction") then
			return
		end
	end

	if arg_9_1 == PingTypes.CANCEL then
		self:_remove_ping(arg_9_4)

		return
	end

	if not (not arg_9_1 and arg_9_1 ~= PingTypes.CHAT_ONLY) then
		return
	end

	local get_party = arg_9_3:get_party()

	if not get_party then
		return
	end

	local flag_2 = false

	if not self._pinged_units[arg_9_4] then
		flag_2 = not arg_9_5 and arg_9_5 == self._pinged_units[arg_9_4].pinged_unit

		self:_remove_ping(arg_9_4, true)
	end

	local time = Managers.time:time("game")
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_9_4)
	local var_9_6
	local var_9_7

	if not arg_9_5 then
		var_9_6, var_9_7 = network:game_object_or_level_id(arg_9_5)
	end

	self._pinged_units[arg_9_4] = {
		start_time = time,
		pinged_unit = arg_9_5,
		flash = arg_9_7,
		party_id = get_party.party_id,
		pinger_unique_id = arg_9_3:unique_id(),
		pinger_unit_id = unit_game_object_id,
		pinged_unit_id = var_9_6,
		ping_type = arg_9_1,
		position = not arg_9_6 and {
			Vector3.to_elements(arg_9_6)
		},
		social_wheel_event_id = arg_9_2
	}

	Managers.telemetry_events:ping_used(arg_9_3, PingTypes[arg_9_1], arg_9_5, POSITION_LOOKUP[arg_9_4])

	if not self.is_server then
		if not arg_9_5 then
			self.network_transmit:send_rpc_party_clients("rpc_ping_unit", get_party, true, unit_game_object_id, var_9_6, var_9_7, arg_9_7, arg_9_1, arg_9_2)
			self:_play_ping_vo(arg_9_4, arg_9_5, arg_9_1, arg_9_2)
		elseif not arg_9_6 then
			local flag_3 = false

			self.network_transmit:send_rpc_party_clients("rpc_ping_world_position", get_party, true, unit_game_object_id, arg_9_6, arg_9_1, arg_9_2, flag_3)
			self:_play_ping_vo(arg_9_4, nil, arg_9_1, arg_9_2)
		end
	end

	if not DEDICATED_SERVER then
		return
	end

	local unique_id = Managers.player:local_player():unique_id()

	if not Managers.party:is_player_in_party(unique_id, get_party.party_id) then
		return
	end

	if not arg_9_5 then
		self:_add_unit_ping(arg_9_4, arg_9_5, arg_9_7, arg_9_1)
	end

	if not (not self._world_markers_enabled and arg_9_1 == PingTypes.VO_ONLY) then
		self:_add_world_marker(arg_9_4, arg_9_5, arg_9_6, arg_9_1, arg_9_2)
	end

	local flag_4 = false
	local var_9_11 = self._last_ping_t[arg_9_4]

	var_9_11 = var_9_11 or 0

	if not (not flag_2 and not flag and not (time < var_9_11 + num_5)) then
		flag_4 = true
	elseif not (arg_9_5 or not (time < var_9_11 + num_5)) then
		flag_4 = true
	elseif not (not arg_9_5 and flag_2 or not (time < var_9_11 + num_6)) then
		flag_4 = true
	else
		self._last_ping_t[arg_9_4] = time
	end

	if not flag_4 then
		local var_9_12 = NetworkLookup.social_wheel_events[arg_9_2]
		local var_9_13 = SocialWheelSettingsLookup[var_9_12]
		local flag_5 = not var_9_13 and var_9_13.ping_sound_effect

		if not flag_5 then
			self:_play_sound(flag_5)
		else
			local flag_6

			flag_6 = not arg_9_5 and not Unit.get_data(arg_9_5, "breed") and "hud_ping_enemy" and "hud_ping"

			self:_play_sound(flag_6)
		end
	end
end

PingSystem._handle_chat = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	if not (not arg_10_5 and arg_10_1 ~= PingTypes.ENEMY_GENERIC) then
		local get_data = Unit.get_data(arg_10_5, "breed")

		if not get_data and not get_data.is_ai then
			return
		end
	end

	local flag = not arg_10_2 and arg_10_2 ~= NetworkLookup.social_wheel_events["n/a"]
	local flag_2 = not flag and SocialWheelSettingsLookup[NetworkLookup.social_wheel_events[arg_10_2]]
	local var_10_3
	local var_10_4

	if not MechanismOverrides.get(IgnoreChatPings)[arg_10_1] then
		if not flag then
			if not (not IS_CONSOLE and arg_10_1 == PingTypes.LOCAL_ONLY) then
				local get_party = arg_10_3:get_party()
				local unit_game_object_id

				if not arg_10_5 then
					unit_game_object_id = Managers.state.network:unit_game_object_id(arg_10_5)

					if not unit_game_object_id then
						-- Nothing
					end
				end

				unit_game_object_id = 0

				::label_10_0::

				local flag_3 = true

				self.network_transmit:send_rpc_party("rpc_social_wheel_event", get_party, flag_3, arg_10_3.peer_id, arg_10_2, unit_game_object_id)
			end

			local event_text_func = flag_2.event_text_func

			var_10_3, var_10_4 = flag_2.event_text

			if not event_text_func and not arg_10_5 then
				local flag_4 = false

				var_10_3, var_10_4 = event_text_func(arg_10_5, flag_2, flag_4)
			end

			if var_10_3 or not arg_10_6 then
				var_10_3 = arg_10_6[math.random(1, #arg_10_6)]
			end
		elseif not arg_10_6 then
			var_10_3 = arg_10_6[math.random(1, #arg_10_6)]
		end

		if not var_10_3 then
			local flag_5 = true
			local flag_6 = true
			local network_id = arg_10_3:network_id()
			local num = 1
			local var_10_14
			local game_mechanism = Managers.mechanism:game_mechanism()

			if not game_mechanism.get_chat_channel then
				num, var_10_14 = game_mechanism:get_chat_channel(network_id, false)
			end

			Managers.chat:send_chat_message(num, arg_10_3:local_player_id(), var_10_3, flag_5, var_10_4, flag_6, nil, var_10_14, nil, nil, network_id)
		end
	end

	if not flag then
		local execute_func = flag_2.execute_func

		if not execute_func then
			local var_10_17 = SocialWheelSettings[flag_2.category_name]

			execute_func(flag_2.data, arg_10_5, arg_10_3, var_10_17)
		end
	end
end

PingSystem.handle_local_ping = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	-- function 11
	self:_handle_chat(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
end

PingSystem.is_ping_cancel = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not self._world_markers_enabled then
		return
	end

	if not arg_12_2 then
		local _world = self._world
		local viewport = ScriptWorld.viewport(_world, "player_1")
		local flag = not viewport and ScriptViewport.camera(viewport)

		if not flag and not Camera.inside_frustum(flag, arg_12_2) then
			local unbox = Vector3Aux.unbox(WorldMarkerTemplates.ping.position_offset)
			local world_to_screen_uv = ScriptCamera.world_to_screen_uv(flag, arg_12_2)
			local num = num_3 * num_3

			for k, v in pairs(self._pinged_units) do
				local var_12_6

				if not v.position then
					var_12_6 = Vector3(unpack(v.position))

					if not var_12_6 then
						-- Nothing
					end
				end

				var_12_6 = POSITION_LOOKUP[v.pinged_unit]

				::label_12_0::

				if not var_12_6 then
					local num_2 = var_12_6 + unbox

					if not Camera.inside_frustum(flag, num_2) then
						local world_to_screen_uv_2 = ScriptCamera.world_to_screen_uv(flag, num_2)

						if not (not (num >= Vector3.distance_squared(world_to_screen_uv_2, world_to_screen_uv)) or arg_12_1 ~= v.pinger_unique_id) then
							return PingTypes.CANCEL, num_2
						end
					end
				end
			end
		end
	end
end

PingSystem._get_unit_ping_type = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not self._world_markers_enabled then
		return arg_13_3
	end

	if not (arg_13_3 == PingTypes.ACKNOWLEDGE or arg_13_3 ~= PingTypes.DENY) then
		return nil
	end

	if arg_13_3 == PingTypes.CONTEXT then
		if not (not arg_13_1 and ALIVE[arg_13_1]) then
			return PingTypes.MOVEMENT_GENERIC
		end

		if not ScriptUnit.has_extension(arg_13_1, "pickup_system") then
			return PingTypes.PLAYER_PICK_UP
		end

		local get_party_from_unique_id = Managers.party:get_party_from_unique_id(arg_13_2)
		local side = Managers.state.side
		local var_13_2 = side.side_by_party[get_party_from_unique_id]
		local var_13_3 = side.side_by_unit[arg_13_1]

		if not side:is_enemy_by_side(var_13_2, var_13_3) then
			return PingTypes.ENEMY_GENERIC
		end

		return PingTypes.PLAYER_HELP
	end

	return arg_13_3
end

PingSystem._get_world_position_ping_type = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	if not arg_14_2 then
		return PingTypes.ENEMY_POSITION
	end

	if not (arg_14_1 == PingTypes.ACKNOWLEDGE or arg_14_1 ~= PingTypes.DENY) then
		return arg_14_1, nil
	end

	if arg_14_1 == PingTypes.CONTEXT then
		return PingTypes.MOVEMENT_GENERIC, nil
	end

	return arg_14_1, nil
end

PingSystem._add_unit_ping = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local has_extension = ScriptUnit.has_extension(arg_15_2, "ping_system")

	if not has_extension then
		return
	end

	local var_15_1
	local var_15_2
	local var_15_3
	local get = MechanismOverrides.get(PingTemplates, self._current_mechanism_name)

	for k, v in pairs(get) do
		if not v:check_func(arg_15_1, arg_15_2) then
			local var_15_5, var_15_6

			var_15_1, var_15_5, var_15_6 = v:exec_func(self, arg_15_1, arg_15_2, arg_15_4, self._current_mechanism_name)

			break
		end
	end

	if not var_15_1 then
		return
	end

	if not has_extension.set_pinged then
		local _is_outline_enabled = self:_is_outline_enabled(arg_15_2)

		has_extension:set_pinged(true, arg_15_3, arg_15_1, _is_outline_enabled)
	end

	local unit_owner = Managers.player:unit_owner(arg_15_1)

	if not unit_owner and not unit_owner.local_player then
		local get_attributes = Managers.state.entity:system("ai_system"):get_attributes(arg_15_2)
		local get_data = Unit.get_data(arg_15_2, "breed")

		if not get_data and get_data.show_health_bar and not get_attributes.grudge_marked then
			Managers.state.event:trigger("boss_health_bar_register_unit", arg_15_2, "ping")
		end
	end
end

PingSystem._add_world_marker = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	if not (arg_16_2 or arg_16_3) then
		return
	end

	if arg_16_4 == PingTypes.LOCAL_ONLY then
		return
	end

	local var_16_0
	local var_16_1
	local var_16_2
	local var_16_3
	local get = MechanismOverrides.get(PingTemplates, self._current_mechanism_name)

	for k, v in pairs(get) do
		if not v:check_func(arg_16_1, arg_16_2) then
			var_16_0, var_16_1, var_16_3 = v:exec_func(self, arg_16_1, arg_16_2, arg_16_4, arg_16_5, self._current_mechanism_name)

			break
		end
	end

	if not var_16_0 then
		return
	end

	if not ((var_16_3 or not arg_16_5) and arg_16_5 == NetworkLookup.social_wheel_events["n/a"]) then
		local var_16_5 = NetworkLookup.social_wheel_events[arg_16_5]
		local var_16_6 = SocialWheelSettingsLookup[var_16_5]

		var_16_3 = var_16_6.icon

		if not var_16_6.event_text_func and not arg_16_2 then
			local event_text_func, var_16_8 = var_16_6.event_text_func(arg_16_2, var_16_6)

			var_16_8 = not var_16_8 and LocalizeArray(var_16_8)

			if not var_16_8 then
				var_16_2 = string.format(Localize(event_text_func), unpack(var_16_8))
			else
				var_16_2 = Localize(event_text_func)
			end
		else
			var_16_2 = Localize(var_16_6.event_text)
		end
	end

	if not var_16_3 then
		return
	end

	local function fn(arg_17_0, arg_17_1)
		-- function 17
		arg_17_1.content.icon = var_16_3
		arg_17_1.content.icon_pulse = var_16_3

		local content = arg_17_1.content
		local var_17_1 = var_16_2

		if not var_17_1 then
			var_17_1 = var_16_1
			var_17_1 = not var_17_1 and var_16_1[1]
		end

		content.text = var_17_1

		local owner = Managers.player:owner(arg_16_1)
		local profile_index = owner:profile_index()
		local career_index = owner:career_index()
		local var_17_5 = SPProfiles[profile_index].careers[career_index]
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local var_17_7

		if current_mechanism_name == "versus" then
			var_17_7 = not arg_17_1.content and arg_17_1.content.text == "MOVEMENT_GENERIC" and Colors.get_color_table_with_alpha("local_player_picking", 200) and Colors.get_color_table_with_alpha("opponent_team", 200)
		else
			var_17_7 = Colors.get_color_table_with_alpha(var_17_5.display_name, 255) or Colors.color_definitions.white
		end

		arg_17_1.style.icon.color = table.clone(var_17_7)
		arg_17_1.style.icon_spawn_pulse.color = table.clone(var_17_7)
		arg_17_1.style.icon_spawn_pulse.default_color = arg_17_1.style.icon.color
		self._world_markers[arg_16_1] = {
			id = arg_17_0,
			widget = arg_17_1
		}
	end

	arg_16_3 = arg_16_3 or Unit.local_position(arg_16_2, 0)

	Managers.state.event:trigger("add_world_marker_position", "ping", arg_16_3, fn)
end

PingSystem.remove_ping_from_unit = function (self, arg_18_1)
	-- function 18
	if not self._pings_enabled then
		return
	end

	for k, v in pairs(self._pinged_units) do
		if arg_18_1 == v.pinged_unit then
			self:_remove_ping(k)
		end
	end
end

PingSystem._remove_ping = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not arg_19_1 then
		return
	end

	local var_19_0 = self._pinged_units[arg_19_1]
	local var_19_1 = self._world_markers[arg_19_1]
	local flag = not var_19_1 and var_19_1.id

	self._pinged_units[arg_19_1] = nil
	self._world_markers[arg_19_1] = nil

	if not var_19_0 then
		return
	end

	if not (not self.is_server and arg_19_2) then
		local get_party = Managers.party:get_party(var_19_0.party_id)
		local pinger_unit_id = var_19_0.pinger_unit_id

		self.network_transmit:send_rpc_party_clients("rpc_remove_ping", get_party, true, pinger_unit_id)
	end

	local pinged_unit = var_19_0.pinged_unit

	if not ALIVE[pinged_unit] then
		local has_extension = ScriptUnit.has_extension(pinged_unit, "ping_system")

		if not has_extension and not has_extension.set_pinged and not has_extension:pinged() then
			local _is_outline_enabled = self:_is_outline_enabled(pinged_unit)

			has_extension:set_pinged(false, nil, arg_19_1, _is_outline_enabled)
		end
	end

	if not self._world_markers_enabled and not flag then
		Managers.state.event:trigger("remove_world_marker", flag)
	end

	local child_pings = var_19_0.child_pings

	if not child_pings then
		for i = 1, #child_pings do
			local var_19_9 = child_pings[i]

			self:_remove_ping(var_19_9, arg_19_2)
		end
	end
end

PingSystem.get_pinged_unit = function (self, arg_20_1)
	-- function 20
	local var_20_0 = self._pinged_units[arg_20_1]

	if not var_20_0 then
		-- Nothing
	end

	::label_20_0::

	local alive = Unit.alive(var_20_0.pinged_unit)

	alive = not alive and var_20_0.pinged_unit

	::label_20_1::

	return alive
end

PingSystem._is_outline_enabled = function (self, arg_21_1)
	-- function 21
	if not self._outlines_enabled.item and not ScriptUnit.has_extension(arg_21_1, "pickup_system") and not ScriptUnit.has_extension(arg_21_1, "interactable_system") then
		return true
	end

	return self._outlines_enabled.unit
end

PingSystem._play_ping_vo = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local alloc_table = FrameTable.alloc_table()
	local extension_input = ScriptUnit.extension_input(arg_22_1, "dialogue_system")

	alloc_table.is_ping = true

	if not arg_22_2 and not Unit.alive(arg_22_2) then
		local var_22_2

		if not Managers.state.side:is_enemy(arg_22_1, arg_22_2) then
			local var_22_3 = BLACKBOARDS[arg_22_2]

			if not var_22_3 then
				local name = var_22_3.breed.name
				local var_22_5 = POSITION_LOOKUP[arg_22_2]

				var_22_5 = var_22_5 or Unit.world_position(arg_22_2, 0)

				local flat = Vector3.flat(var_22_5)
				local var_22_7 = POSITION_LOOKUP[arg_22_1]
				local flat_2 = Vector3.flat(var_22_7)

				alloc_table.enemy_tag = name
				alloc_table.enemy_unit = arg_22_2
				alloc_table.distance = Vector3.distance(flat, flat_2)

				extension_input:trigger_networked_dialogue_event("seen_enemy", alloc_table)
			end

			return
		end

		local has_extension = ScriptUnit.has_extension(arg_22_2, "status_system")

		if not has_extension then
			local disabled_vo_reason = has_extension:disabled_vo_reason()

			if not disabled_vo_reason then
				alloc_table.source_name = ScriptUnit.extension(arg_22_1, "dialogue_system").context.player_profile
				alloc_table.target_name = ScriptUnit.extension(arg_22_2, "dialogue_system").context.player_profile

				extension_input:trigger_networked_dialogue_event(disabled_vo_reason, alloc_table)
			end

			return
		end

		local get_data = Unit.get_data(arg_22_2, "lookat_tag")

		if not get_data then
			alloc_table.item_tag = get_data or Unit.debug_name(arg_22_2)

			extension_input:trigger_networked_dialogue_event("seen_item", alloc_table)

			return
		end
	else
		local var_22_12

		if not (not arg_22_4 and arg_22_4 == NetworkLookup.social_wheel_events["n/a"]) then
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

		if not var_22_12 then
			extension_input:trigger_networked_dialogue_event(var_22_12, alloc_table)
		end
	end
end

PingSystem.rpc_ping_unit = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7)
	-- function 23
	local unit = self._unit_storage:unit(arg_23_2)
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_23_3, arg_23_4)
	local unit_owner = Managers.player:unit_owner(unit)

	if not unit_owner then
		return
	end

	local unique_id = unit_owner:unique_id()

	if not self.is_server then
		arg_23_6 = self:_get_unit_ping_type(game_object_or_level_unit, unique_id, arg_23_6)

		local var_23_4
		local var_23_5
		local get = MechanismOverrides.get(PingTemplates, self._current_mechanism_name)

		for k, v in pairs(get) do
			if not v:check_func(unit, game_object_or_level_unit) then
				var_23_4, var_23_5 = v:exec_func(self, unit, game_object_or_level_unit, arg_23_6, arg_23_7, self._current_mechanism_name)

				break
			end
		end

		if not var_23_4 then
			return
		end

		self:_handle_ping(arg_23_6, arg_23_7, unit_owner, unit, game_object_or_level_unit, nil, arg_23_5)
		self:_handle_chat(arg_23_6, arg_23_7, unit_owner, unit, game_object_or_level_unit, var_23_5)
	else
		if not Managers.chat:ignoring_peer_id(unit_owner.peer_id) then
			return
		end

		self:_handle_ping(arg_23_6, arg_23_7, unit_owner, unit, game_object_or_level_unit, nil, arg_23_5)
	end
end

PingSystem.rpc_ping_world_position = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	local unit = self._unit_storage:unit(arg_24_2)
	local unit_owner = Managers.player:unit_owner(unit)

	if not unit_owner then
		return
	end

	if not self.is_server then
		local var_24_2
		local var_24_3

		arg_24_4, var_24_3 = self:_get_world_position_ping_type(arg_24_4, arg_24_6)
		arg_24_3 = not var_24_3 and var_24_3 and arg_24_3

		local var_24_4
		local get = MechanismOverrides.get(PingTemplates, self._current_mechanism_name)

		for k, v in pairs(get) do
			if not v:check_func(unit, nil) then
				k, var_24_4, k = v:exec_func(self, unit, nil, arg_24_4, arg_24_5, self._current_mechanism_name)

				break
			end
		end

		self:_handle_ping(arg_24_4, arg_24_5, unit_owner, unit, nil, arg_24_3, nil)
		self:_handle_chat(arg_24_4, arg_24_5, unit_owner, unit, nil, var_24_4)
	else
		if not Managers.chat:ignoring_peer_id(unit_owner.peer_id) then
			return
		end

		self:_handle_ping(arg_24_4, arg_24_5, unit_owner, unit, nil, arg_24_3, nil)
	end
end

PingSystem.rpc_social_message = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	fassert(self.is_server, "Only server should get this")

	local unit = self._unit_storage:unit(arg_25_2)
	local unit_2 = self._unit_storage:unit(arg_25_4)
	local unit_owner = Managers.player:unit_owner(unit)

	self:_handle_chat(nil, arg_25_3, unit_owner, unit, unit_2)
end

PingSystem.rpc_remove_ping = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not self._pings_enabled then
		return
	end

	local unit = self._unit_storage:unit(arg_26_2)

	self:_remove_ping(unit)
end

PingSystem._play_sound = function (self, arg_27_1)
	-- function 27
	WwiseWorld.trigger_event(self._wwise_world, arg_27_1)
end
