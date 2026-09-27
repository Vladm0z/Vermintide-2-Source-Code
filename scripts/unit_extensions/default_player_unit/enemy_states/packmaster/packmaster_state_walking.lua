-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_walking.lua

PackmasterStateWalking = class(PackmasterStateWalking, EnemyCharacterStateWalking)

PackmasterStateWalking.init = function (self, arg_1_1)
	-- function 1
	PackmasterStateWalking.super.init(self, arg_1_1)

	self._grab_ability_id = self._career_extension:ability_id("grab")
	self._equip_ability_id = self._career_extension:ability_id("equip")
end

PackmasterStateWalking.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	PackmasterStateWalking.super.on_enter(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)

	self._right_wpn_particle_node_name = "g_skaven_packmaster_claw"
	self._right_wpn_particle_name = "fx/wpnfx_packmaster_enemy_in_range_1p"
end

PackmasterStateWalking.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self:common_state_changes() then
		return
	end

	local _csm = self._csm
	local _career_extension = self._career_extension

	if not _career_extension:ability_was_triggered(self._grab_ability_id) then
		_csm:change_state("packmaster_grabbing")

		return
	end

	if not _career_extension:ability_was_triggered(self._equip_ability_id) then
		_csm:change_state("packmaster_equipping")

		return
	end

	self:_update_taunt_dialogue(arg_3_5)

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local common_movement = self:common_movement(is_in_ghost_mode, arg_3_3)
end
