-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_shield_user_extension.lua

AIShieldUserExtension = class(AIShieldUserExtension)

AIShieldUserExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2

	local is_blocking = arg_1_3.is_blocking

	is_blocking = is_blocking or true
	self.is_blocking = is_blocking

	local is_dodging = arg_1_3.is_dodging

	is_dodging = is_dodging or false
	self.is_dodging = is_dodging
	self.shield_broken = false
end

AIShieldUserExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

AIShieldUserExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	assert(Managers.state.network.is_server)

	local blackboard = ScriptUnit.extension(arg_3_2, "ai_system"):blackboard()
	local spawn_type = blackboard.spawn_type

	self.is_blocking = spawn_type == "horde" or spawn_type == "horde_hidden"
	self._blackboard = blackboard
	self.blocked_previous_attack = false
	blackboard.shield_user = true
end

AIShieldUserExtension.set_is_blocking = function (self, arg_4_1)
	-- function 4
	if not self.shield_broken then
		return
	end

	local _unit = self._unit
	local go_id = Managers.state.unit_storage:go_id(_unit)
	local game = Managers.state.network:game()

	if not game and not go_id then
		GameSession.set_game_object_field(game, go_id, "is_blocking", arg_4_1)
	end

	self.is_blocking = arg_4_1
end

AIShieldUserExtension.set_is_dodging = function (self, arg_5_1)
	-- function 5
	if not self.shield_broken then
		return
	end

	local _unit = self._unit
	local go_id = Managers.state.unit_storage:go_id(_unit)
	local game = Managers.state.network:game()

	if not game and not go_id then
		GameSession.set_game_object_field(game, go_id, "is_dodging", arg_5_1)
	end

	self.is_dodging = arg_5_1
end

AIShieldUserExtension.break_shield = function (self)
	-- function 6
	self:set_is_blocking(false)

	self.shield_broken = true

	local _unit = self._unit
	local _blackboard = self._blackboard

	_blackboard.shield_breaking_hit = true
	_blackboard.shield_user = false

	local extension = ScriptUnit.extension(_unit, "ai_inventory_system")
	local inventory_item_definitions = extension.inventory_item_definitions
	local str = "shield_break"
	local network_transmit = Managers.state.network.network_transmit
	local go_id = Managers.state.unit_storage:go_id(_unit)
	local var_6_7 = NetworkLookup.item_drop_reasons[str]
	local flag = false

	for i = 1, #inventory_item_definitions do
		local var_6_9 = inventory_item_definitions[i]
		local drop_single_item, var_6_11 = extension:drop_single_item(i, str)

		if not drop_single_item then
			flag = true

			network_transmit:send_rpc_clients("rpc_ai_drop_single_item", go_id, i, var_6_7)
		end
	end

	return flag
end

AIShieldUserExtension.can_block_attack = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	assert(arg_7_1)

	local _unit = self._unit

	if not (not self.is_blocking and HEALTH_ALIVE[_unit]) then
		return false
	end

	local world_position = Unit.world_position(arg_7_1, 0)
	local world_position_2 = Unit.world_position(_unit, 0)
	local normalize = Vector3.normalize(world_position_2 - world_position)
	local forward = Quaternion.forward(Unit.local_rotation(_unit, 0))
	local var_7_5
	local var_7_6

	if not arg_7_2 then
		local dot = Vector3.dot(forward, arg_7_3)

		var_7_6 = not (dot >= -0.75) or dot <= 1
	else
		local dot_2 = Vector3.dot(forward, normalize)

		var_7_6 = not (dot_2 >= 0.55) or dot_2 <= 1
	end

	return not var_7_6
end
