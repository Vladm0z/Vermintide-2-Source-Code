-- chunkname: @scripts/utils/navigation_path.lua

NavigationPath = class(NavigationPath)

NavigationPath.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._path = {}
	arg_1_0._current_index = 1
	arg_1_0._callback = arg_1_2

	for iter_1_0 = 1, #arg_1_1 do
		arg_1_0._path[iter_1_0] = Vector3Box(arg_1_1[iter_1_0])
	end
end

NavigationPath.current = function (arg_2_0)
	return arg_2_0._path[arg_2_0._current_index]:unbox()
end

NavigationPath.last = function (arg_3_0)
	return arg_3_0._path[#arg_3_0._path]:unbox()
end

NavigationPath.advance = function (arg_4_0)
	arg_4_0._current_index = arg_4_0._current_index + 1
end

NavigationPath.is_last = function (arg_5_0)
	return arg_5_0._current_index == #arg_5_0._path
end

NavigationPath.reset = function (arg_6_0)
	arg_6_0._current_index = 1
end

NavigationPath.reverse = function (arg_7_0)
	table.reverse(arg_7_0._path)
end

NavigationPath.callback = function (arg_8_0)
	return arg_8_0._callback
end

NavigationPath.path = function (arg_9_0)
	return arg_9_0._path
end

NavigationPath.draw = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Managers.state.debug:drawer({
		mode = "immediate",
		name = "nav_path"
	})
	local var_10_1 = arg_10_2 or Vector3(0, 0, 0)
	local var_10_2

	for iter_10_0, iter_10_1 in ipairs(arg_10_0._path) do
		var_10_0:sphere(iter_10_1:unbox() + Vector3.up() * 0.05 + var_10_1, 0.05, arg_10_1)
	end
end
