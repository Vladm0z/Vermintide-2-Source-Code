-- chunkname: @scripts/ui/ui_animator.lua

UIAnimator = class(UIAnimator)

UIAnimator.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._ui_scenegraph = arg_1_1
	self._animation_definitions = arg_1_2
	self._active_animations = {}
	self._animation_id = 0
end

UIAnimator.start_animation = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	local _ui_scenegraph = self._ui_scenegraph
	local tbl = {}

	arg_2_6 = arg_2_6 or 0

	local var_2_2 = self._animation_definitions[arg_2_1]

	for i = 1, #var_2_2 do
		local var_2_3 = var_2_2[i]

		var_2_3.is_completed = nil

		var_2_3.init(_ui_scenegraph, arg_2_3, arg_2_2, arg_2_4)

		local var_2_4
		local var_2_5

		if not var_2_3.start_progress then
			var_2_4, var_2_5 = var_2_3.start_progress, var_2_3.end_progress
		else
			var_2_4 = var_2_3.delay or 0
			var_2_5 = var_2_4 + var_2_3.duration
		end

		tbl[i * 2 - 1] = arg_2_6 + var_2_4
		tbl[i * 2] = arg_2_6 + var_2_5
	end

	local num = self._animation_id + 1

	self._animation_id = num
	self._active_animations[num] = {
		time = 0,
		anim_name = arg_2_1,
		anim_def = var_2_2,
		widget = arg_2_2,
		scenegraph_def = arg_2_3,
		completed_animations = {},
		params = arg_2_4 or {},
		times = tbl
	}

	return num
end

UIAnimator.is_animation_completed = function (self, arg_3_1)
	-- function 3
	return self._active_animations[arg_3_1] == nil
end

UIAnimator.stop_animation = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0._active_animations[arg_4_1] = nil
end

UIAnimator.update = function (self, arg_5_1)
	-- function 5
	local _ui_scenegraph = self._ui_scenegraph

	for k, v in pairs(self._active_animations) do
		if not v.completed then
			local widget = v.widget
			local scenegraph_def = v.scenegraph_def
			local params = v.params
			local completed_animations = v.completed_animations
			local times = v.times
			local num = v.time + arg_5_1

			v.time = num

			local flag = true
			local anim_def = v.anim_def

			for k_2 = 1, #anim_def do
				local var_5_9 = anim_def[k_2]
				local var_5_10 = times[k_2 * 2 - 1]
				local var_5_11 = times[k_2 * 2]

				if num < var_5_11 then
					flag = false
				end

				if not (not (var_5_10 < num) or completed_animations[var_5_9.name]) then
					local num_2 = (num - var_5_10) / (var_5_11 - var_5_10)

					if num_2 < 1 then
						var_5_9.update(_ui_scenegraph, scenegraph_def, widget, num_2, params)
					else
						var_5_9.update(_ui_scenegraph, scenegraph_def, widget, 1, params)
						var_5_9.on_complete(_ui_scenegraph, scenegraph_def, widget, params)

						completed_animations[var_5_9.name] = true
					end
				end
			end

			if not flag then
				self._active_animations[k] = nil
			end
		end
	end
end
