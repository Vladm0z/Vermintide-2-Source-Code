-- chunkname: @scripts/unit_extensions/default_player_unit/third_person_idle_fullbody_animation_control.lua

ThirdPersonIdleFullbodyAnimationControl = class(ThirdPersonIdleFullbodyAnimationControl)

local num = 0.12
local num_2 = 0.25
local num_3 = 0.25
local num_4 = 1
local num_5 = 0

ThirdPersonIdleFullbodyAnimationControl.init = function (self, arg_1_1)
	-- function 1
	self._unit = arg_1_1
	self._idle_fullbody_variable = Unit.animation_find_variable(arg_1_1, "idle_fullbody")
	self._progress = 1
	self._is_moving = false
	self._is_crouching = false
	self._is_moving_transition_start_t = 0
	self._crouch_t = 0
end

ThirdPersonIdleFullbodyAnimationControl.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._locomotion_extension = ScriptUnit.extension(arg_2_2, "locomotion_system")
	self._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
end

ThirdPersonIdleFullbodyAnimationControl._total_time = function (arg_3_0, arg_3_1)
	-- function 3
	local var_3_0

	if not arg_3_1 then
		var_3_0 = num

		if not var_3_0 then
			-- Nothing
		end
	end

	var_3_0 = num_2

	::label_3_0::

	return var_3_0
end

ThirdPersonIdleFullbodyAnimationControl._calculate_start_time = function (self, arg_4_1, arg_4_2)
	-- function 4
	return arg_4_2 - self:_total_time(arg_4_1) * (1 - self._progress)
end

ThirdPersonIdleFullbodyAnimationControl._wanted_fullbody_value = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local _total_time = self:_total_time(arg_5_2)
	local clamp01 = math.clamp01(arg_5_1 / _total_time)
	local var_5_2 = clamp01

	if not arg_5_2 then
		clamp01 = 1 - clamp01
	end

	local lerp = math.lerp(num_4, num_5, clamp01)
	local flag

	flag = not arg_5_3 and 1 and 0

	local num = 1 - flag

	return lerp * math.clamp01(math.inv_lerp(flag, num, arg_5_4 / num_3)), var_5_2
end

ThirdPersonIdleFullbodyAnimationControl._percentage_done = function (arg_6_0, arg_6_1)
	-- function 6
	return 0
end

ThirdPersonIdleFullbodyAnimationControl.update = function (self, arg_7_1)
	-- function 7
	if not self._idle_fullbody_variable then
		return
	end

	local _unit = self._unit
	local is_crouching = self._status_extension:is_crouching()
	local length_squared = Vector3.length_squared(self._locomotion_extension:current_velocity())

	if length_squared < NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON then
		length_squared = 0
	end

	local _is_moving = self._is_moving

	if not (_is_moving or not (length_squared > 0)) then
		self._is_moving = true
		self._is_moving_transition_start_t = self:_calculate_start_time(self._is_moving, arg_7_1)
	elseif not (not _is_moving and length_squared ~= 0) then
		self._is_moving = false
		self._is_moving_transition_start_t = self:_calculate_start_time(self._is_moving, arg_7_1)
	end

	local _is_moving_2 = self._is_moving

	if is_crouching ~= self._is_crouching then
		self._crouch_t = arg_7_1
		self._is_crouching = is_crouching
	end

	local num = arg_7_1 - self._is_moving_transition_start_t
	local _wanted_fullbody_value, var_7_7 = self:_wanted_fullbody_value(num, _is_moving_2, is_crouching, arg_7_1 - self._crouch_t)

	Unit.animation_set_variable(_unit, self._idle_fullbody_variable, _wanted_fullbody_value)

	self._idle_fullbody_value = _wanted_fullbody_value
	self._progress = var_7_7
end
