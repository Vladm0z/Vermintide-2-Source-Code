-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/warpfire_thrower/warpfire_thrower_state_walking.lua

WarpfireThrowerStateWalking = class(WarpfireThrowerStateWalking, EnemyCharacterStateWalking)

WarpfireThrowerStateWalking.on_enter = function (self, unit, input, dt, context, t, previous_state, params)
	-- function 1
	WarpfireThrowerStateWalking.super.on_enter(self, unit, input, dt, context, t, previous_state, params)

	local breed = PlayerBreeds.vs_warpfire_thrower

	self.blackboard = BLACKBOARDS[self._unit]

	local data = not not self.blackboard.warpfire_data

	data.is_firing = false
	self._is_firing = false
	data.peer_id = not not data.peer_id
	self.blackboard.warpfire_data = data
	self._fire_ability_id = self._career_extension:ability_id("fire")
	self._left_wpn_particle_node_name = "p_fx"
	self._left_wpn_particle_name = "fx/wpnfx_gunner_enemy_in_range_1p"
end

WarpfireThrowerStateWalking.update = function (self, unit, input, dt, context, t)
	-- function 2
	local handled = self:common_state_changes()

	if handled then
		return
	end

	self:_update_taunt_dialogue(t)

	local ghost_mode_extension = self._ghost_mode_extension
	local in_ghost_mode = ghost_mode_extension:is_in_ghost_mode()

	handled = self:common_movement(in_ghost_mode, dt)

	if not handled then
		CharacterStateHelper.update_weapon_actions(t, unit, self._input_extension, self._inventory_extension, self._health_extension)
	end
end
