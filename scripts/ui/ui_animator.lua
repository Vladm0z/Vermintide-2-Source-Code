-- chunkname: @scripts/ui/ui_animator.lua

UIAnimator = class(UIAnimator)

UIAnimator.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._ui_scenegraph = arg_1_1
	arg_1_0._animation_definitions = arg_1_2
	arg_1_0._active_animations = {}
	arg_1_0._animation_id = 0
end

UIAnimator.start_animation = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0 = arg_2_0._ui_scenegraph
	local var_2_1 = {}

	arg_2_6 = arg_2_6 or 0

	local var_2_2 = arg_2_0._animation_definitions[arg_2_1]

	for iter_2_0 = 1, #var_2_2 do
		local var_2_3 = var_2_2[iter_2_0]

		var_2_3.is_completed = nil

		var_2_3.init(var_2_0, arg_2_3, arg_2_2, arg_2_4)

		local var_2_4
		local var_2_5

		if var_2_3.start_progress then
			var_2_4, var_2_5 = var_2_3.start_progress, var_2_3.end_progress
		else
			var_2_4 = var_2_3.delay or 0
			var_2_5 = var_2_4 + var_2_3.duration
		end

		var_2_1[iter_2_0 * 2 - 1] = arg_2_6 + var_2_4
		var_2_1[iter_2_0 * 2] = arg_2_6 + var_2_5
	end

	local var_2_6 = arg_2_0._animation_id + 1

	arg_2_0._animation_id = var_2_6
	arg_2_0._active_animations[var_2_6] = {
		time = 0,
		anim_name = arg_2_1,
		anim_def = var_2_2,
		widget = arg_2_2,
		scenegraph_def = arg_2_3,
		completed_animations = {},
		params = arg_2_4 or {},
		times = var_2_1
	}

	return var_2_6
end

UIAnimator.is_animation_completed = function (arg_3_0, arg_3_1)
	return arg_3_0._active_animations[arg_3_1] == nil
end

UIAnimator.stop_animation = function (arg_4_0, arg_4_1)
	arg_4_0._active_animations[arg_4_1] = nil
end

UIAnimator.update = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._ui_scenegraph

	for iter_5_0, iter_5_1 in pairs(arg_5_0._active_animations) do
		if not iter_5_1.completed then
			local var_5_1 = iter_5_1.widget
			local var_5_2 = iter_5_1.scenegraph_def
			local var_5_3 = iter_5_1.params
			local var_5_4 = iter_5_1.completed_animations
			local var_5_5 = iter_5_1.times
			local var_5_6 = iter_5_1.time + arg_5_1

			iter_5_1.time = var_5_6

			local var_5_7 = true
			local var_5_8 = iter_5_1.anim_def

			for iter_5_2 = 1, #var_5_8 do
				local var_5_9 = var_5_8[iter_5_2]
				local var_5_10 = var_5_5[iter_5_2 * 2 - 1]
				local var_5_11 = var_5_5[iter_5_2 * 2]

				if var_5_6 < var_5_11 then
					var_5_7 = false
				end

				if var_5_10 < var_5_6 and not var_5_4[var_5_9.name] then
					local var_5_12 = (var_5_6 - var_5_10) / (var_5_11 - var_5_10)

					if var_5_12 < 1 then
						var_5_9.update(var_5_0, var_5_2, var_5_1, var_5_12, var_5_3)
					else
						var_5_9.update(var_5_0, var_5_2, var_5_1, 1, var_5_3)
						var_5_9.on_complete(var_5_0, var_5_2, var_5_1, var_5_3)

						var_5_4[var_5_9.name] = true
					end
				end
			end

			if var_5_7 then
				arg_5_0._active_animations[iter_5_0] = nil
			end
		end
	end
end
