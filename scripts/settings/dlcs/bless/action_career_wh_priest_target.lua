-- chunkname: @scripts/settings/dlcs/bless/action_career_wh_priest_target.lua

ActionCareerWHPriestTarget = class(ActionCareerWHPriestTarget, ActionBase)

local tbl = {
	target_self = "wh_priest_self",
	target_ally = "wh_priest_ally"
}

ActionCareerWHPriestTarget.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerWHPriestTarget.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self._outline_system = Managers.state.entity:system("outline_system")
	self._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self._marked_target = {}
end

ActionCareerWHPriestTarget.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionCareerWHPriestTarget.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self.aim_timer = arg_2_1.target_sticky_time
	self.aimed_target = not arg_2_3 and arg_2_3.target

	self._weapon_extension:set_mode(false)

	self.played_aim_sound = false

	local aim_sound_delay = arg_2_1.aim_sound_delay

	aim_sound_delay = aim_sound_delay or 0
	self.aim_sound_time = arg_2_2 + aim_sound_delay
	self._max_range = arg_2_1.max_range
	self._cone_cos_angle = math.cos(math.rad(arg_2_1.target_cone_angle))

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

		if not (not owner_player and not owner_player.remote) then
			local start_charge_sound, var_3_6 = ActionUtils.start_charge_sound(wwise_world, self.weapon_unit, owner_unit, current_action)

			self.charging_sound_id = start_charge_sound
			self.wwise_source_id = var_3_6
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

		if not (not owner_player and not owner_player.remote) then
			ActionUtils.stop_charge_sound(wwise_world, self.charging_sound_id, self.wwise_source_id, current_action)

			self.charging_sound_id = nil
			self.wwise_source_id = nil
		end
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_stop_event, owner_unit, is_bot)
end

ActionCareerWHPriestTarget.client_owner_post_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local aimed_target = self.aimed_target
	local aimed_target_2 = self.aimed_target
	local is_bot = self.is_bot
	local _outline_system = self._outline_system

	if not (not aimed_target and HEALTH_ALIVE[aimed_target]) then
		self:_mark_target(nil)

		aimed_target = nil
	end

	local target_sticky_time = current_action.target_sticky_time

	target_sticky_time = target_sticky_time or 0

	if target_sticky_time <= self.aim_timer then
		local _target_ally_from_crosshair = self:_target_ally_from_crosshair()

		if aimed_target ~= _target_ally_from_crosshair then
			self:_mark_target(_target_ally_from_crosshair)

			self.aim_timer = 0
		end
	end

	if not is_bot then
		if not (self.played_aim_sound or not (arg_5_2 >= self.aim_sound_time)) then
			local aim_sound_event = current_action.aim_sound_event

			if not aim_sound_event then
				local wwise_world = self.wwise_world

				WwiseWorld.trigger_event(wwise_world, aim_sound_event)
			end

			self.played_aim_sound = true
		end
	else
		local var_5_10 = BLACKBOARDS[owner_unit]
		local target_unit

		if not var_5_10 then
			target_unit = var_5_10.activate_ability_data.target_unit

			if not target_unit then
				-- Nothing
			end
		end

		target_unit = owner_unit

		::label_5_0::

		self._weapon_extension:set_mode(target_unit ~= owner_unit)
	end

	self.aim_timer = self.aim_timer + arg_5_1
end

ActionCareerWHPriestTarget._mark_target = function (self, arg_6_1)
	-- function 6
	if not self.is_bot then
		return
	end

	local _marked_target = self._marked_target

	if not _marked_target.outline_extension then
		_marked_target.outline_extension:remove_outline(_marked_target.outline_id)

		_marked_target.outline_extension = nil
		_marked_target.outline_id = nil
	end

	if not arg_6_1 and not ALIVE[arg_6_1] then
		local has_extension = ScriptUnit.has_extension(arg_6_1, "outline_system")

		if not has_extension then
			_marked_target.outline_extension = has_extension
			_marked_target.outline_id = has_extension:add_outline(OutlineSettings.templates.tutorial_highlight)
		end
	end

	local _weapon_extension = self._weapon_extension
	local flag = not arg_6_1 and arg_6_1 ~= self.owner_unit

	_weapon_extension:set_mode(flag)

	if not flag then
		local owner = Managers.player:owner(arg_6_1)
		local profile_index = owner:profile_index()
		local career_index = owner:career_index()
		local get_portrait_image_by_profile_index = UIUtils.get_portrait_image_by_profile_index(profile_index, career_index)

		Managers.state.event:trigger("on_set_ability_target_name", "small_" .. get_portrait_image_by_profile_index, tbl.target_ally)
	else
		Managers.state.event:trigger("on_set_ability_target_name", nil, tbl.target_self)
	end

	local current_action = self.current_action
	local target_other_anim_event

	if not flag then
		target_other_anim_event = current_action.target_other_anim_event

		if not target_other_anim_event then
			-- Nothing
		end
	end

	target_other_anim_event = current_action.target_self_anim_event

	::label_6_0::

	local get_first_person_unit = self.first_person_extension:get_first_person_unit()

	if not target_other_anim_event then
		Unit.animation_event(get_first_person_unit, target_other_anim_event)
	end

	self.aimed_target = arg_6_1
end

ActionCareerWHPriestTarget._target_ally_from_crosshair = function (self)
	-- function 7
	local _max_range = self._max_range
	local num = _max_range * _max_range
	local _cone_cos_angle = self._cone_cos_angle
	local owner_unit = self.owner_unit
	local camera_position_rotation, var_7_5 = self.first_person_extension:camera_position_rotation()
	local normalize = Vector3.normalize(Quaternion.forward(var_7_5))
	local var_7_7 = Managers.state.side.side_by_unit[owner_unit]
	local flag = not var_7_7 and var_7_7.PLAYER_AND_BOT_UNITS
	local count

	if not flag then
		count = #flag

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_7_0::

	local var_7_10
	local num_2 = 0
	local num_3 = 0

	for i = 1, count do
		local var_7_13 = flag[i]

		if var_7_13 == self.owner_unit or not HEALTH_ALIVE[var_7_13] then
			local _check_cone_from_crosshair, var_7_15, var_7_16 = self:_check_cone_from_crosshair(camera_position_rotation, normalize, var_7_13, num, _cone_cos_angle)

			if not (not _check_cone_from_crosshair and not (num_3 <= var_7_15)) then
				num_3 = var_7_15
				num_2 = var_7_16

				if var_7_16 < num then
					var_7_10 = var_7_13
				else
					var_7_10 = nil
				end
			end
		end
	end

	return var_7_10, num_2
end

ActionCareerWHPriestTarget._check_cone_from_crosshair = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local num = Unit.world_position(arg_8_3, Unit.node(arg_8_3, "j_claw_attach")) - arg_8_1
	local length_squared = Vector3.length_squared(num)
	local normalize = Vector3.normalize(num)
	local dot = Vector3.dot(arg_8_2, normalize)

	if arg_8_5 <= dot then
		return true, dot, length_squared
	end
end

ActionCareerWHPriestTarget.finish = function (self, arg_9_1, arg_9_2)
	-- function 9
	local is_bot = self.is_bot
	local aimed_target = self.aimed_target

	aimed_target = aimed_target or self.owner_unit

	if not is_bot then
		local var_9_2 = BLACKBOARDS[self.owner_unit]

		aimed_target = not var_9_2 and var_9_2.activate_ability_data.target_unit and self.owner_unit
	end

	local tbl = {
		target = aimed_target
	}
	local current_action = self.current_action

	if not is_bot then
		local unaim_sound_event = current_action.unaim_sound_event

		if not unaim_sound_event then
			local wwise_world = self.wwise_world

			WwiseWorld.trigger_event(wwise_world, unaim_sound_event)
		end
	end

	if arg_9_1 ~= "new_interupting_action" then
		self.inventory_extension:wield_previous_non_level_slot()
		self.first_person_extension:play_hud_sound_event("priest_book_loop_stop")
	end

	self:_stop_charge_sound()
	self:_mark_target(nil)

	return tbl
end
