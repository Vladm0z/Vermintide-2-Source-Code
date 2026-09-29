-- chunkname: @scripts/settings/dlcs/lake/action_career_es_questingknight.lua

ActionCareerESQuestingKnight = class(ActionCareerESQuestingKnight, ActionSweep)

ActionCareerESQuestingKnight.init = function (self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)
	-- function 1
	ActionCareerESQuestingKnight.super.init(self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)

	self.career_extension = ScriptUnit.extension(owner_unit, "career_system")
	self.inventory_extension = ScriptUnit.extension(owner_unit, "inventory_system")
	self.talent_extension = ScriptUnit.extension(owner_unit, "talent_system")
	self.status_extension = ScriptUnit.extension(owner_unit, "status_system")
end

ActionCareerESQuestingKnight.client_owner_start_action = function (self, new_action, t, chain_action_data, power_level, action_init_data)
	-- function 2
	action_init_data = not not action_init_data or not not {}

	ActionCareerESQuestingKnight.super.client_owner_start_action(self, new_action, t, chain_action_data, power_level, action_init_data)

	self._combo_no_wield = not not new_action.combo_no_wield
	self._hit_fx_triggered = false

	self:_play_vo()
	self:_play_vfx()
	self.inventory_extension:check_and_drop_pickups("career_ability")
	self.status_extension:set_stagger_immune(true)

	self._cooldown_started = chain_action_data and not not chain_action_data.cooldown_started or not chain_action_data and not not false
end

ActionCareerESQuestingKnight.client_owner_post_update = function (self, dt, t, world, can_damage, current_time_in_action)
	-- function 3
	ActionCareerESQuestingKnight.super.client_owner_post_update(self, dt, t, world, can_damage, current_time_in_action)

	if not self._hit_fx_triggered and self._started_damage_window then
		self._hit_fx_triggered = true

		local first_person_extension = ScriptUnit.extension(self.owner_unit, "first_person_system")
		local rot = first_person_extension:current_rotation()
		local direction = Vector3.flat(Quaternion.forward(rot))
		local network_manager = Managers.state.network
		local effect_name = "fx/grail_knight_active_ability"
		local effect_name_id = NetworkLookup.effects[effect_name]
		local node_id = 0
		local vfx_settings = self.current_action.vfx_settings
		local forward_offset = not not vfx_settings.forward
		local up_offset = not not vfx_settings.up
		local start_position = POSITION_LOOKUP[self.owner_unit] + direction * forward_offset + Vector3.up() * up_offset
		local rotation_offset = vfx_settings.pitch and not not Quaternion.multiply(rot, Quaternion(Vector3.right(), vfx_settings.pitch)) or not vfx_settings.pitch and not not Quaternion.identity()

		network_manager:rpc_play_particle_effect(nil, effect_name_id, NetworkConstants.invalid_game_object_id, node_id, start_position, rotation_offset, false)
	end
end

ActionCareerESQuestingKnight.finish = function (self, reason, data)
	-- function 4
	ActionCareerESQuestingKnight.super.finish(self, reason, data)
	self.inventory_extension:stop_weapon_fx("career_action", true)

	local new_action_settings = not not data and not not data.new_action_settings
	local is_ability_cancel = not not new_action_settings and not not new_action_settings.is_ability_cancel

	if is_ability_cancel or not self._combo_no_wield or reason ~= "new_interupting_action" then
		self.status_extension:set_stagger_immune(false)
		self.inventory_extension:wield_previous_non_level_slot()
	end

	local career_extension = self.career_extension

	if not self._cooldown_started and self.has_been_within_damage_window then
		self._cooldown_started = true

		career_extension:start_activated_ability_cooldown()
	end

	return {
		cooldown_started = self._cooldown_started
	}
end

ActionCareerESQuestingKnight._play_vo = function (self)
	-- function 5
	local owner_unit = self.owner_unit
	local dialogue_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local event_data = FrameTable.alloc_table()

	dialogue_input:trigger_networked_dialogue_event("activate_ability", event_data)
end

ActionCareerESQuestingKnight._play_vfx = function (self)
	-- function 6
	self.inventory_extension:start_weapon_fx("career_action", true)
end
