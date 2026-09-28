-- chunkname: @scripts/settings/dlcs/bless/action_career_wh_priest_target.lua

ActionCareerWHPriestTarget = class(ActionCareerWHPriestTarget, ActionBase)

local crosshair_lookup = {
	target_self = "wh_priest_self",
	target_ally = "wh_priest_ally"
}

ActionCareerWHPriestTarget.init = function (self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)
	-- function 1
	ActionCareerWHPriestTarget.super.init(self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)

	self.first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self.inventory_extension = ScriptUnit.extension(owner_unit, "inventory_system")
	self._outline_system = Managers.state.entity:system("outline_system")
	self._weapon_extension = ScriptUnit.extension(weapon_unit, "weapon_system")
	self._marked_target = {}
end

ActionCareerWHPriestTarget.client_owner_start_action = function (self, new_action, t, chain_action_data, power_level, action_init_data)
	-- function 2
	ActionCareerWHPriestTarget.super.client_owner_start_action(self, new_action, t, chain_action_data, power_level, action_init_data)

	self.aim_timer = new_action.target_sticky_time
	self.aimed_target = not not chain_action_data and not not chain_action_data.target

	self._weapon_extension:set_mode(false)

	self.played_aim_sound = false

	local aim_sound_delay = new_action.aim_sound_delay

	aim_sound_delay = not not aim_sound_delay or not not 0
	self.aim_sound_time = t + aim_sound_delay
	self._max_range = new_action.max_range
	self._cone_cos_angle = math.cos(math.rad(new_action.target_cone_angle))

	self:_start_charge_sound()
end

ActionCareerWHPriestTarget._start_charge_sound = function (self)
	-- function 3
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local wwise_world = self.wwise_world
	local is_bot = self.is_bot

	if not is_bot then
		local owner_player = self.owner_player
		local is_local = not not owner_player and not not not owner_player.remote

		if is_local then
			local wwise_playing_id, wwise_source_id = ActionUtils.start_charge_sound(wwise_world, self.weapon_unit, owner_unit, current_action)

			self.charging_sound_id = wwise_playing_id
			self.wwise_source_id = wwise_source_id
		end
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_name, owner_unit, is_bot)
end

ActionCareerWHPriestTarget._stop_charge_sound = function (self)
	-- function 4
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local wwise_world = self.wwise_world
	local is_bot = self.is_bot

	if not is_bot then
		local owner_player = self.owner_player
		local is_local = not not owner_player and not not not owner_player.remote

		if is_local then
			ActionUtils.stop_charge_sound(wwise_world, self.charging_sound_id, self.wwise_source_id, current_action)

			self.charging_sound_id = nil
			self.wwise_source_id = nil
		end
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_stop_event, owner_unit, is_bot)
end

ActionCareerWHPriestTarget.client_owner_post_update = function (self, dt, t, world, can_damage)
	-- function 5
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local current_target = self.aimed_target
	local old_target = self.aimed_target
	local is_bot = self.is_bot
	local outline_system = self._outline_system

	if current_target and not HEALTH_ALIVE[current_target] then
		self:_mark_target(nil)

		current_target = nil
	end

	local target_sticky_time = current_action.target_sticky_time

	if not target_sticky_time then
		-- Nothing
	end

	target_sticky_time = 0

	local required_aim_time = target_sticky_time

	::label_5_0::

	if required_aim_time <= self.aim_timer then
		local hit_unit = self:_target_ally_from_crosshair()

		if current_target ~= hit_unit then
			self:_mark_target(hit_unit)

			self.aim_timer = 0
		end
	end

	if not is_bot then
		if not self.played_aim_sound and t >= self.aim_sound_time then
			local sound_event = current_action.aim_sound_event

			if sound_event then
				local wwise_world = self.wwise_world

				WwiseWorld.trigger_event(wwise_world, sound_event)
			end

			self.played_aim_sound = true
		end
	else
		local blackboard = BLACKBOARDS[owner_unit]
		local target_unit

		if blackboard then
			target_unit = blackboard.activate_ability_data.target_unit

			if not target_unit then
				-- Nothing
			end
		end

		target_unit = owner_unit

		local aimed_target = target_unit

		::label_5_1::

		self._weapon_extension:set_mode(aimed_target ~= owner_unit)
	end

	self.aim_timer = self.aim_timer + dt
end

ActionCareerWHPriestTarget._mark_target = function (self, new_target)
	-- function 6
	if self.is_bot then
		return
	end

	local old_marked_target = self._marked_target

	if old_marked_target.outline_extension then
		old_marked_target.outline_extension:remove_outline(old_marked_target.outline_id)

		old_marked_target.outline_extension = nil
		old_marked_target.outline_id = nil
	end

	if new_target and ALIVE[new_target] then
		local target_outline_extenson = ScriptUnit.has_extension(new_target, "outline_system")

		if target_outline_extenson then
			old_marked_target.outline_extension = target_outline_extenson
			old_marked_target.outline_id = target_outline_extenson:add_outline(OutlineSettings.templates.tutorial_highlight)
		end
	end

	local weapon_extension = self._weapon_extension
	local is_other_target = not not new_target and new_target ~= self.owner_unit

	weapon_extension:set_mode(is_other_target)

	if is_other_target then
		local owner = Managers.player:owner(new_target)
		local profile_index = owner:profile_index()
		local career_index = owner:career_index()
		local career_portrait = UIUtils.get_portrait_image_by_profile_index(profile_index, career_index)

		Managers.state.event:trigger("on_set_ability_target_name", "small_" .. career_portrait, crosshair_lookup.target_ally)
	else
		Managers.state.event:trigger("on_set_ability_target_name", nil, crosshair_lookup.target_self)
	end

	local current_action = self.current_action
	local target_other_anim_event

	if is_other_target then
		target_other_anim_event = current_action.target_other_anim_event

		if not target_other_anim_event then
			-- Nothing
		end
	end

	target_other_anim_event = current_action.target_self_anim_event

	local anim_event = target_other_anim_event

	::label_6_0::

	local first_person_unit = self.first_person_extension:get_first_person_unit()

	if anim_event then
		Unit.animation_event(first_person_unit, anim_event)
	end

	self.aimed_target = new_target
end

ActionCareerWHPriestTarget._target_ally_from_crosshair = function (self)
	-- function 7
	local range = self._max_range
	local range_sq = range * range
	local dot_threshold = self._cone_cos_angle
	local owner_unit = self.owner_unit
	local player_position, player_rotation = self.first_person_extension:camera_position_rotation()
	local player_direction = Vector3.normalize(Quaternion.forward(player_rotation))
	local side = Managers.state.side.side_by_unit[owner_unit]
	local friendly_units = not not side and not not side.PLAYER_AND_BOT_UNITS
	local count

	if friendly_units then
		count = #friendly_units

		if not count then
			-- Nothing
		end
	end

	count = 0

	local num_friendly_units = count

	::label_7_0::

	local best_target
	local best_distance = 0
	local best_dot_value = 0

	for i = 1, num_friendly_units do
		local friendly_unit = friendly_units[i]

		if friendly_unit ~= self.owner_unit and HEALTH_ALIVE[friendly_unit] then
			local is_valid, dot_value, distance_sq = self:_check_cone_from_crosshair(player_position, player_direction, friendly_unit, range_sq, dot_threshold)

			if is_valid and best_dot_value <= dot_value then
				best_dot_value = dot_value
				best_distance = distance_sq

				if distance_sq < range_sq then
					best_target = friendly_unit
				else
					best_target = nil
				end
			end
		end
	end

	return best_target, best_distance
end

ActionCareerWHPriestTarget._check_cone_from_crosshair = function (self, player_position, player_direction, target, range_sq, dot_threshold)
	-- function 8
	local target_position = Unit.world_position(target, Unit.node(target, "j_claw_attach"))
	local target_delta = target_position - player_position
	local distance_sq = Vector3.length_squared(target_delta)
	local target_direction = Vector3.normalize(target_delta)
	local target_cos_alpha = Vector3.dot(player_direction, target_direction)

	if dot_threshold <= target_cos_alpha then
		return true, target_cos_alpha, distance_sq
	end
end

ActionCareerWHPriestTarget.finish = function (self, reason, data)
	-- function 9
	local is_bot = self.is_bot
	local aimed_target_2 = self.aimed_target

	if not aimed_target_2 then
		-- Nothing
	end

	aimed_target_2 = self.owner_unit

	local aimed_target = aimed_target_2

	::label_9_0::

	if is_bot then
		local blackboard = BLACKBOARDS[self.owner_unit]

		aimed_target = (not blackboard or not blackboard.activate_ability_data.target_unit) and not not self.owner_unit
	end

	local chain_action_data = {
		target = aimed_target
	}
	local current_action = self.current_action

	if not is_bot then
		local sound_event = current_action.unaim_sound_event

		if sound_event then
			local wwise_world = self.wwise_world

			WwiseWorld.trigger_event(wwise_world, sound_event)
		end
	end

	if reason ~= "new_interupting_action" then
		self.inventory_extension:wield_previous_non_level_slot()
		self.first_person_extension:play_hud_sound_event("priest_book_loop_stop")
	end

	self:_stop_charge_sound()
	self:_mark_target(nil)

	return chain_action_data
end
