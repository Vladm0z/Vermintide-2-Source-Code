-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_shield_user_extension.lua

AIShieldUserExtension = class(AIShieldUserExtension)

AIShieldUserExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self._unit = unit

	local is_blocking = extension_init_data.is_blocking

	is_blocking = not not is_blocking or not not true
	self.is_blocking = is_blocking

	local is_dodging = extension_init_data.is_dodging

	is_dodging = not not is_dodging or not not false
	self.is_dodging = is_dodging
	self.shield_broken = false
end

AIShieldUserExtension.destroy = function (self)
	-- function 2
	return
end

AIShieldUserExtension.extensions_ready = function (self, world, unit)
	-- function 3
	assert(Managers.state.network.is_server)

	local ai_base_extension = ScriptUnit.extension(unit, "ai_system")
	local blackboard = ai_base_extension:blackboard()
	local spawn_type = blackboard.spawn_type
	local is_blocking = spawn_type == "horde" or spawn_type == "horde_hidden"

	self.is_blocking = is_blocking
	self._blackboard = blackboard
	self.blocked_previous_attack = false
	blackboard.shield_user = true
end

AIShieldUserExtension.set_is_blocking = function (self, is_blocking)
	-- function 4
	local shield_broken = self.shield_broken

	if shield_broken then
		return
	end

	local unit = self._unit
	local game_object_id = Managers.state.unit_storage:go_id(unit)
	local game = Managers.state.network:game()

	if game and game_object_id then
		GameSession.set_game_object_field(game, game_object_id, "is_blocking", is_blocking)
	end

	self.is_blocking = is_blocking
end

AIShieldUserExtension.set_is_dodging = function (self, is_dodging)
	-- function 5
	local shield_broken = self.shield_broken

	if shield_broken then
		return
	end

	local unit = self._unit
	local game_object_id = Managers.state.unit_storage:go_id(unit)
	local game = Managers.state.network:game()

	if game and game_object_id then
		GameSession.set_game_object_field(game, game_object_id, "is_dodging", is_dodging)
	end

	self.is_dodging = is_dodging
end

AIShieldUserExtension.break_shield = function (self)
	-- function 6
	self:set_is_blocking(false)

	self.shield_broken = true

	local unit = self._unit
	local blackboard = self._blackboard

	blackboard.shield_breaking_hit = true
	blackboard.shield_user = false

	local ai_inventory_extension = ScriptUnit.extension(unit, "ai_inventory_system")
	local inventory_item_definitions = ai_inventory_extension.inventory_item_definitions
	local reason = "shield_break"
	local network_transmit = Managers.state.network.network_transmit
	local game_object_id = Managers.state.unit_storage:go_id(unit)
	local reason_id = NetworkLookup.item_drop_reasons[reason]
	local item_dropped = false

	for i = 1, #inventory_item_definitions do
		local item = inventory_item_definitions[i]
		local success, item_unit = ai_inventory_extension:drop_single_item(i, reason)

		if success then
			item_dropped = true

			network_transmit:send_rpc_clients("rpc_ai_drop_single_item", game_object_id, i, reason_id)
		end
	end

	return item_dropped
end

AIShieldUserExtension.can_block_attack = function (self, attacker_unit, trueflight_blocking, hit_direction)
	-- function 7
	assert(attacker_unit)

	local unit = self._unit
	local can_block = self.is_blocking

	if not can_block or not HEALTH_ALIVE[unit] then
		return false
	end

	local attacker_unit_pos = Unit.world_position(attacker_unit, 0)
	local hit_unit_pos = Unit.world_position(unit, 0)
	local attacker_to_hit_dir = Vector3.normalize(hit_unit_pos - attacker_unit_pos)
	local hit_unit_direction = Quaternion.forward(Unit.local_rotation(unit, 0))
	local hit_angle, behind_target

	if trueflight_blocking then
		hit_angle = Vector3.dot(hit_unit_direction, hit_direction)
		behind_target = hit_angle >= -0.75 and hit_angle <= 1
	else
		hit_angle = Vector3.dot(hit_unit_direction, attacker_to_hit_dir)
		behind_target = hit_angle >= 0.55 and hit_angle <= 1
	end

	local can_block_attack = not behind_target

	return can_block_attack
end
