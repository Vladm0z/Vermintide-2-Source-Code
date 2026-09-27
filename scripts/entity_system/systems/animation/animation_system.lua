-- chunkname: @scripts/entity_system/systems/animation/animation_system.lua

require("scripts/entity_system/systems/animation/animation_callback_templates")
require("scripts/entity_system/systems/animation/networked_animation_variable_templates")

AnimationSystem = class(AnimationSystem, ExtensionSystemBase)

local POSITION_LOOKUP = POSITION_LOOKUP
local tbl = {
	"rpc_sync_anim_state_1",
	"rpc_sync_anim_state_2",
	"rpc_sync_anim_state_3",
	"rpc_sync_anim_state_4",
	"rpc_sync_anim_state_5",
	"rpc_sync_anim_state_6",
	"rpc_sync_anim_state_7",
	"rpc_sync_anim_state_8",
	"rpc_sync_anim_state_9",
	"rpc_sync_anim_state_10",
	"rpc_sync_anim_state_11",
	"rpc_sync_anim_state_12",
	"rpc_anim_event",
	"rpc_anim_event_variable_float",
	"rpc_anim_set_variable_float",
	"rpc_anim_set_variable_int",
	"rpc_link_unit",
	"rpc_anim_set_variable_by_distance",
	"rpc_anim_set_variable_by_time",
	"rpc_update_anim_variable_done"
}
local tbl_2 = {}

AnimationSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AnimationSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)
	Managers.state.event:register(self, "animation_callback", "animation_callback")

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.anim_variable_update_list = {}
	self._networked_animation_variables = {}
	self._animation_safe_callbacks_buffer_1 = {}
	self._animation_safe_callbacks_buffer_2 = {}
	self._animation_safe_callbacks = self._animation_safe_callbacks_buffer_1
end

AnimationSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

AnimationSystem.animation_callback = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0

	if not self.is_server then
		local var_3_1 = AnimationCallbackTemplates.server[arg_3_2]

		if not var_3_1 then
			var_3_1(arg_3_1, arg_3_3)
		end
	end

	local var_3_2 = AnimationCallbackTemplates.client[arg_3_2]

	if not var_3_2 then
		var_3_2(arg_3_1, arg_3_3)
	end
end

AnimationSystem.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:update_anim_variables(arg_4_2)
	self:_update_networked_anim_variables(arg_4_1.dt, arg_4_2)
end

AnimationSystem.update_anim_variables = function (self, arg_5_1)
	-- function 5
	local var_5_0 = POSITION_LOOKUP
	local length = Vector3.length
	local alive = Unit.alive
	local num = 0
	local clamp = math.clamp
	local animation_set_variable = Unit.animation_set_variable

	for k, v in pairs(self.anim_variable_update_list) do
		if not var_5_0[k] then
			local var_5_6

			if not v.goal_pos then
				local var_5_7 = var_5_0[k]
				local num_2 = v.goal_pos:unbox() - var_5_7

				if not v.flat_distance then
					num_2 = Vector3.flat(num_2)
				end

				local var_5_9 = length(num_2)
				local scale = v.scale

				var_5_6 = clamp(scale - scale * var_5_9 / v.initial_distance, 0, scale)
			else
				local num_3 = arg_5_1 - v.start_time
				local scale_2 = v.scale

				var_5_6 = clamp(scale_2 * num_3 / v.duration, 0, scale_2)
			end

			animation_set_variable(k, v.anim_variable_index, var_5_6)

			num = num + 1
		else
			self.anim_variable_update_list[k] = nil
		end
	end
end

AnimationSystem.anim_event = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if arg_6_3 or not Managers.state.network:game() then
		local go_id = self.unit_storage:go_id(arg_6_1)

		fassert(go_id, "Unit storage does not have a game object id for %q", arg_6_1)

		local var_6_1 = NetworkLookup.anims[arg_6_2]

		if not self.is_server then
			self.network_transmit:send_rpc_clients("rpc_anim_event", var_6_1, go_id)
		else
			self.network_transmit:send_rpc_server("rpc_anim_event", var_6_1, go_id)
		end
	end

	self:_init_networked_variables(arg_6_1, arg_6_2)

	return Unit.animation_event(arg_6_1, arg_6_2)
end

AnimationSystem.anim_event_with_variable_float = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	if arg_7_5 or not Managers.state.network:game() then
		local go_id = self.unit_storage:go_id(arg_7_1)

		fassert(go_id, "Unit storage does not have a game object id for %q", arg_7_1)

		local var_7_1 = NetworkLookup.anims[arg_7_2]
		local var_7_2 = NetworkLookup.anims[arg_7_3]

		if not self.is_server then
			self.network_transmit:send_rpc_clients("rpc_anim_event_variable_float", var_7_1, go_id, var_7_2, arg_7_4)
		else
			self.network_transmit:send_rpc_server("rpc_anim_event_variable_float", var_7_1, go_id, var_7_2, arg_7_4)
		end
	end

	self:_init_networked_variables(arg_7_1, arg_7_2)

	local animation_find_variable = Unit.animation_find_variable(arg_7_1, arg_7_3)

	Unit.animation_set_variable(arg_7_1, animation_find_variable, arg_7_4)
	Unit.animation_event(arg_7_1, arg_7_2)
end

if not LEVEL_EDITOR_TEST then
	AnimationSystem.anim_event = function (self, arg_8_1, arg_8_2)
		-- function 8
		self:_init_networked_variables(arg_8_1, arg_8_2)
		Unit.animation_event(arg_8_1, arg_8_2)
	end

	AnimationSystem.anim_event_with_variable_float = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		self:_init_networked_variables(arg_9_1, arg_9_2)

		local animation_find_variable = Unit.animation_find_variable(arg_9_1, arg_9_3)

		Unit.animation_set_variable(arg_9_1, animation_find_variable, arg_9_4)
		Unit.animation_event(arg_9_1, arg_9_2)
	end
end

AnimationSystem._init_networked_variables = function (self, arg_10_1, arg_10_2)
	-- function 10
	self:_remove_networked_variables(arg_10_1)

	if not NetworkedAnimationVariableTemplatesLookup[arg_10_2] then
		return
	end

	local get_data = Unit.get_data(arg_10_1, "breed")

	if not get_data then
		return
	end

	local networked_animation_variables = get_data.networked_animation_variables

	if not networked_animation_variables then
		return
	end

	local var_10_2 = networked_animation_variables[arg_10_2]

	if not var_10_2 then
		return
	end

	local _networked_animation_variables = self._networked_animation_variables

	if not _networked_animation_variables[arg_10_1] then
		table.clear(_networked_animation_variables[arg_10_1].updates)
	end

	for k, v in pairs(var_10_2) do
		local tbl = {
			variable_name = k,
			variable_index = Unit.animation_find_variable(arg_10_1, k),
			variable_data = v
		}
		local var_10_5 = NetworkedAnimationVariableTemplates[k]

		if not var_10_5.init then
			var_10_5.init(arg_10_1, tbl)
		end

		local var_10_6 = _networked_animation_variables[arg_10_1]

		var_10_6 = var_10_6 or {
			updates = {}
		}

		if not var_10_5.update then
			var_10_6.updates[#var_10_6.updates + 1] = tbl
		end

		var_10_6[#var_10_6 + 1] = tbl
		_networked_animation_variables[arg_10_1] = var_10_6
	end
end

AnimationSystem._remove_networked_variables = function (self, arg_11_1)
	-- function 11
	local var_11_0 = self._networked_animation_variables[arg_11_1]

	if not var_11_0 then
		for i = 1, #var_11_0 do
			local var_11_1 = var_11_0[i]
			local variable_name = var_11_1.variable_name
			local var_11_3 = NetworkedAnimationVariableTemplates[variable_name]

			if not var_11_3.stop then
				var_11_3.stop(arg_11_1, var_11_1)
			end

			var_11_0[i] = nil
		end
	end
end

AnimationSystem._update_networked_anim_variables = function (self, arg_12_1, arg_12_2)
	-- function 12
	for k, v in pairs(self._networked_animation_variables) do
		if not (not ALIVE[k] and Unit.has_animation_state_machine(k)) then
			self:_remove_networked_variables(k)
		else
			local updates = v.updates

			for k_2 = 1, #updates do
				local var_12_1 = updates[k_2]
				local variable_name = var_12_1.variable_name

				NetworkedAnimationVariableTemplates[variable_name].update(k, var_12_1, arg_12_1, arg_12_2)
			end
		end
	end
end

AnimationSystem.rpc_sync_anim_state = function (self, arg_13_1, arg_13_2, ...)
	-- function 13
	local unit = self.unit_storage:unit(arg_13_2)

	Unit.animation_set_state(unit, ...)
end

AnimationSystem.rpc_sync_anim_state_1 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_2 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_3 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_4 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_5 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_6 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_7 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_8 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_9 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_10 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_11 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_12 = AnimationSystem.rpc_sync_anim_state

AnimationSystem.rpc_anim_event_variable_float = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local unit = self.unit_storage:unit(arg_14_3)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	if not self.is_server then
		local var_14_1 = CHANNEL_TO_PEER_ID[arg_14_1]

		self.network_transmit:send_rpc_clients_except("rpc_anim_event_variable_float", var_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	end

	if not Unit.has_animation_state_machine(unit) then
		local var_14_2 = NetworkLookup.anims[arg_14_2]

		assert(var_14_2, "[GameNetworkManager] Lookup missing for event_id", arg_14_2)

		local var_14_3 = NetworkLookup.anims[arg_14_4]

		self:anim_event_with_variable_float(unit, var_14_2, var_14_3, arg_14_5, true)
	end
end

AnimationSystem.rpc_anim_set_variable_float = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local unit = self.unit_storage:unit(arg_15_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	if not self.is_server then
		local var_15_1 = CHANNEL_TO_PEER_ID[arg_15_1]

		self.network_transmit:send_rpc_clients_except("rpc_anim_set_variable_float", var_15_1, arg_15_2, arg_15_3, arg_15_4)
	end

	if not Unit.has_animation_state_machine(unit) then
		local var_15_2 = NetworkLookup.anims[arg_15_3]
		local animation_find_variable = Unit.animation_find_variable(unit, var_15_2)

		Unit.animation_set_variable(unit, animation_find_variable, arg_15_4)
	end
end

AnimationSystem.rpc_anim_set_variable_int = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local unit = self.unit_storage:unit(arg_16_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	if not self.is_server then
		local var_16_1 = CHANNEL_TO_PEER_ID[arg_16_1]

		self.network_transmit:send_rpc_clients_except("rpc_anim_set_variable_int", var_16_1, arg_16_2, arg_16_3, arg_16_4)
	end

	if not Unit.has_animation_state_machine(unit) then
		local var_16_2 = NetworkLookup.anims[arg_16_3]
		local animation_find_variable = Unit.animation_find_variable(unit, var_16_2)

		Unit.animation_set_variable(unit, animation_find_variable, arg_16_4)
	end
end

AnimationSystem.rpc_anim_event = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local unit = self.unit_storage:unit(arg_17_3)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	if not self.is_server then
		local var_17_1 = CHANNEL_TO_PEER_ID[arg_17_1]

		self.network_transmit:send_rpc_clients_except("rpc_anim_event", var_17_1, arg_17_2, arg_17_3)
	end

	if not Unit.has_animation_state_machine(unit) then
		local var_17_2 = NetworkLookup.anims[arg_17_2]

		assert(var_17_2, "[GameNetworkManager] Lookup missing for event_id", arg_17_2)
		self:anim_event(unit, var_17_2, true)
	end
end

AnimationSystem.rpc_link_unit = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	local unit = self.unit_storage:unit(arg_18_2)
	local unit_2 = self.unit_storage:unit(arg_18_4)
	local world = Unit.world(unit_2)

	World.link_unit(world, unit, arg_18_3, unit_2, arg_18_5)
end

AnimationSystem.rpc_anim_set_variable_by_distance = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	-- function 19
	local unit = self.unit_storage:unit(arg_19_2)

	self:_set_variable_by_distance(unit, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
end

AnimationSystem._set_variable_by_distance = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local num = arg_20_3 - POSITION_LOOKUP[arg_20_1]

	if not arg_20_5 then
		num = Vector3.flat(num)
	end

	local length = Vector3.length(num)

	if length < 0.001 then
		length = 0.001
	end

	local var_20_2 = self.anim_variable_update_list[arg_20_1]

	if not var_20_2 then
		var_20_2.goal_pos = Vector3Box(arg_20_3)
		var_20_2.initial_distance = length
		var_20_2.scale = arg_20_4
		var_20_2.anim_variable_index = arg_20_2
	else
		self.anim_variable_update_list[arg_20_1] = {
			unit = arg_20_1,
			goal_pos = Vector3Box(arg_20_3),
			anim_variable_index = arg_20_2,
			initial_distance = length,
			scale = arg_20_4,
			flat_distance = arg_20_5
		}
	end
end

AnimationSystem.rpc_anim_set_variable_by_time = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	local unit = self.unit_storage:unit(arg_21_2)
	local num = arg_21_4 * 0.00390625

	self:_set_variable_by_time(unit, arg_21_3, num, arg_21_5)
end

AnimationSystem._set_variable_by_time = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local var_22_0 = self.anim_variable_update_list[arg_22_1]
	local time = Managers.time:time("game")

	if not var_22_0 then
		var_22_0.start_time = time
		var_22_0.duration = arg_22_3
		var_22_0.scale = arg_22_4
		var_22_0.anim_variable_index = arg_22_2
	else
		self.anim_variable_update_list[arg_22_1] = {
			unit = arg_22_1,
			start_time = time,
			duration = arg_22_3,
			anim_variable_index = arg_22_2,
			scale = arg_22_4
		}
	end
end

AnimationSystem.rpc_update_anim_variable_done = function (self, arg_23_1, arg_23_2)
	-- function 23
	local unit = self.unit_storage:unit(arg_23_2)

	if not self.anim_variable_update_list[unit] then
		self.anim_variable_update_list[unit] = nil
	end
end

AnimationSystem.set_update_anim_variable_done = function (self, arg_24_1)
	-- function 24
	local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_24_1)

	self.network_transmit:send_rpc_clients("rpc_update_anim_variable_done", unit_game_object_id)

	self.anim_variable_update_list[arg_24_1] = nil
end

AnimationSystem.start_anim_variable_update_by_distance = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_25_1)

	self.network_transmit:send_rpc_clients("rpc_anim_set_variable_by_distance", unit_game_object_id, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	self:_set_variable_by_distance(arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
end

AnimationSystem.start_anim_variable_update_by_time = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local clamp = math.clamp(arg_26_3 * 256, 0, 65535)
	local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_26_1)

	self.network_transmit:send_rpc_clients("rpc_anim_set_variable_by_time", unit_game_object_id, arg_26_2, clamp, arg_26_4)
	self:_set_variable_by_time(arg_26_1, arg_26_2, arg_26_3, arg_26_4)
end

AnimationSystem.add_safe_animation_callback = function (arg_27_0, arg_27_1)
	-- function 27
	arg_27_0._animation_safe_callbacks[#arg_27_0._animation_safe_callbacks + 1] = arg_27_1
end

AnimationSystem.run_safe_animation_callbacks = function (self)
	-- function 28
	local _animation_safe_callbacks = self._animation_safe_callbacks
	local _animation_safe_callbacks_buffer_2

	if self._animation_safe_callbacks == self._animation_safe_callbacks_buffer_1 then
		_animation_safe_callbacks_buffer_2 = self._animation_safe_callbacks_buffer_2

		if not _animation_safe_callbacks_buffer_2 then
			-- Nothing
		end
	end

	_animation_safe_callbacks_buffer_2 = self._animation_safe_callbacks_buffer_1

	::label_28_0::

	self._animation_safe_callbacks = _animation_safe_callbacks_buffer_2

	for i = 1, #_animation_safe_callbacks do
		_animation_safe_callbacks[i]()

		_animation_safe_callbacks[i] = nil
	end
end
