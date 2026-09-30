-- chunkname: @scripts/ui/ui_animations.lua

require("scripts/utils/varargs")

UIAnimation = UIAnimation

UIAnimation.init = function (...)
	-- function 35
	local data_array = {}
	local ui_animation = {
		current_index = 1,
		data_array = data_array
	}
	local num_varargs = select("#", ...)
	local i = 0
	local current_index = 0

	while i < num_varargs do
		i = i + 1

		local animation_type = select(i, ...)
		local num_args = animation_type.num_args

		data_array[current_index + 1] = animation_type

		for j = 1, num_args do
			data_array[current_index + 1 + j] = select(i + j, ...)
		end

		current_index = current_index + 1 + num_args + animation_type.num_data
		i = i + num_args
	end

	local num_args = data_array[1].num_args
	local num_data = data_array[1].num_data
	local pack_func = pack_index[num_data]
	local unpack_func = unpack_index[num_args]

	pack_func(data_array, 2 + num_args, data_array[1].init(unpack_func(data_array, 2)))

	return ui_animation
end

local function debug_print_ui_animation(...)
	-- function 36
	Application.error("########### ANIMATION ERROR ###########")

	local num_varargs = select("#", ...)

	for i = 1, num_varargs do
		local var = select(i, ...)

		Application.error(string.format("Variable %d: %s", i, tostring(var)))
	end

	Application.error("########### ANIMATION ERROR END ###########")
	print(debug.traceback())
end

UIAnimation.init_debug = function (...)
	-- function 37
	local data_array = {}
	local ui_animation = {
		current_index = 1,
		data_array = data_array
	}
	local num_varargs = select("#", ...)
	local i = 0
	local current_index = 0

	while i < num_varargs do
		i = i + 1

		local animation_type = select(i, ...)

		if not animation_type or type(animation_type) ~= "table" then
			debug_print_ui_animation(...)

			return nil
		end

		local num_args = animation_type.num_args

		data_array[current_index + 1] = animation_type

		for j = 1, num_args do
			data_array[current_index + 1 + j] = select(i + j, ...)
		end

		current_index = current_index + 1 + num_args + animation_type.num_data
		i = i + num_args
	end

	local num_args = data_array[1].num_args
	local num_data = data_array[1].num_data
	local pack_func = pack_index[num_data]
	local unpack_func = unpack_index[num_args]

	pack_func(data_array, 2 + num_args, data_array[1].init(unpack_func(data_array, 2)))

	return ui_animation
end

local function extract_continue_amount(pack_amount, array, index, continue, ...)
	-- function 38
	pack_index[pack_amount](array, index, ...)

	return continue
end

UIAnimation.update = function (ui_animation, dt)
	-- function 39
	local current_index = ui_animation.current_index
	local data_array = ui_animation.data_array
	local animation_type = data_array[current_index]

	if animation_type then
		local num_args, num_data = animation_type.num_args, animation_type.num_data
		local continue = extract_continue_amount(num_data, data_array, current_index + num_args + 1, animation_type.update(dt, unpack_index[num_args + num_data](data_array, current_index + 1)))

		if not continue then
			current_index = current_index + num_args + num_data + 1
			ui_animation.current_index = current_index

			local new_animation = data_array[current_index]

			if new_animation then
				local pack_func = pack_index[new_animation.num_data]
				local unpack_func = unpack_index[new_animation.num_args]

				pack_func(data_array, current_index + 1 + new_animation.num_args, new_animation.init(unpack_func(data_array, current_index + 1)))
			end
		end
	end
end

UIAnimation.completed = function (ui_animation)
	-- function 40
	return ui_animation.current_index >= #ui_animation.data_array
end
