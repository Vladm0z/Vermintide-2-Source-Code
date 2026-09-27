-- chunkname: @scripts/settings/dlcs/lake/action_career_es_questingknight.lua

ActionCareerESQuestingKnight = class(ActionCareerESQuestingKnight, ActionSweep)

ActionCareerESQuestingKnight.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerESQuestingKnight.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
end

ActionCareerESQuestingKnight.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerESQuestingKnight.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local combo_no_wield = arg_2_1.combo_no_wield

	combo_no_wield = combo_no_wield or false
	self._combo_no_wield = combo_no_wield
	self._hit_fx_triggered = false

	self:_play_vo()
	self:_play_vfx()
	self.inventory_extension:check_and_drop_pickups("career_ability")
	self.status_extension:set_stagger_immune(true)

	local cooldown_started

	if not arg_2_3 then
		cooldown_started = arg_2_3.cooldown_started

		if not cooldown_started then
			-- Nothing
		end
	end

	cooldown_started = false

	::label_2_0::

	self._cooldown_started = cooldown_started
end

ActionCareerESQuestingKnight.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	ActionCareerESQuestingKnight.super.client_owner_post_update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	if self._hit_fx_triggered or not self._started_damage_window then
		self._hit_fx_triggered = true

		local current_rotation = ScriptUnit.extension(self.owner_unit, "first_person_system"):current_rotation()
		local flat = Vector3.flat(Quaternion.forward(current_rotation))
		local network = Managers.state.network
		local str = "fx/grail_knight_active_ability"
		local var_3_4 = NetworkLookup.effects[str]
		local num = 0
		local vfx_settings = self.current_action.vfx_settings
		local forward = vfx_settings.forward

		forward = forward or 0

		local up = vfx_settings.up

		up = up or 0

		local num_2 = POSITION_LOOKUP[self.owner_unit] + flat * forward + Vector3.up() * up
		local multiply

		if not vfx_settings.pitch then
			multiply = Quaternion.multiply(current_rotation, Quaternion(Vector3.right(), vfx_settings.pitch))

			if not multiply then
				-- Nothing
			end
		end

		multiply = Quaternion.identity()

		::label_3_0::

		network:rpc_play_particle_effect(nil, var_3_4, NetworkConstants.invalid_game_object_id, num, num_2, multiply, false)
	end
end

ActionCareerESQuestingKnight.finish = function (self, arg_4_1, arg_4_2)
	-- function 4
	ActionCareerESQuestingKnight.super.finish(self, arg_4_1, arg_4_2)
	self.inventory_extension:stop_weapon_fx("career_action", true)

	local flag = not arg_4_2 and arg_4_2.new_action_settings

	if not ((not flag and flag.is_ability_cancel or not self._combo_no_wield) and arg_4_1 == "new_interupting_action") then
		self.status_extension:set_stagger_immune(false)
		self.inventory_extension:wield_previous_non_level_slot()
	end

	local career_extension = self.career_extension

	if self._cooldown_started or not self.has_been_within_damage_window then
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
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

ActionCareerESQuestingKnight._play_vfx = function (self)
	-- function 6
	self.inventory_extension:start_weapon_fx("career_action", true)
end
