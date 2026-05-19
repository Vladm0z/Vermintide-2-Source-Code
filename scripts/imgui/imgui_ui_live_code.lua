-- chunkname: @scripts/imgui/imgui_ui_live_code.lua

require("scripts/utils/hash_utils")

ImguiUILiveCode = class(ImguiUILiveCode)

local var_0_0 = -1
local var_0_1 = {
	"definitions"
}

function ImguiUILiveCode.init(arg_1_0)
	arg_1_0._require_datas = {}
	arg_1_0._file_hashes = {}
	arg_1_0._dirty_packages = {}
	arg_1_0._cache = {}
	arg_1_0._target_fps = 60
end

local var_0_2 = true

function ImguiUILiveCode.update(arg_2_0, arg_2_1, arg_2_2)
	if var_0_2 then
		arg_2_0:init()

		var_0_2 = false
	end

	arg_2_0:_clear_cache_if_dirty()
	arg_2_0:_process_packages(arg_2_2)
	arg_2_0:_safeguard_dirty_packages()
end

function ImguiUILiveCode._safeguard_dirty_packages(arg_3_0)
	if table.is_empty(arg_3_0._dirty_packages) then
		return
	end

	local var_3_0 = update

	function update(...)
		local var_4_0, var_4_1 = pcall(var_3_0, ...)

		if not var_4_0 then
			arg_3_0:_revert_dirty_packages(var_4_1)
		end

		table.clear(arg_3_0._dirty_packages)

		update = var_3_0
	end
end

function ImguiUILiveCode.on_show(arg_5_0)
	return
end

local var_0_3 = string.format("\n-------------------------------------------------\n\nFor a file to support live coding it must contain\none of the following words in thier filenames:\n\n[\n\t%s\n]\n\nand return a table, or specify 'live_code = true'\nin their return table.\n\n-------------------------------------------------\n\nIt's now running on a fairly naive solution of\nopening every relevant file in packages.loaded,\nreads it all, and diffs its content. This limits\nhow many files we can process each frame. If you\nhave the time, please implement a file watcher\ninstead.\n\n-------------------------------------------------\n\n", table.concat(var_0_1, ",\n\t"))

function ImguiUILiveCode.draw(arg_6_0)
	local var_6_0, var_6_1 = Imgui.begin_window("UI Live Code", "always_auto_resize")

	if not var_6_1 then
		return var_6_0
	end

	Imgui.text("UI Live Coding is now active.")
	Imgui.text(string.format("Files processed last frame: %s out of %s", math.round(arg_6_0._last_printed_package_count or 0), arg_6_0:_num_processable_packages()))

	arg_6_0._target_fps = Imgui.slider_int("FPS Throttle Limit", arg_6_0._target_fps, 1, 120)

	Imgui.text(var_0_3)

	local var_6_2 = 1
	local var_6_3 = Managers.time:time("main")

	if var_6_3 > (arg_6_0._next_package_count_update_t or 0) then
		arg_6_0._next_package_count_update_t = var_6_3 + var_6_2
		arg_6_0._last_printed_package_count = arg_6_0._last_num_packages
	end

	Imgui.text("Happy coding.")
	Imgui.end_window()

	return var_6_0
end

function ImguiUILiveCode.is_persistent(arg_7_0)
	return true
end

function ImguiUILiveCode._next_package(arg_8_0)
	arg_8_0._next_package_name = next(package.loaded, arg_8_0._next_package_name) or next(package.loaded)

	return arg_8_0._next_package_name
end

function ImguiUILiveCode._num_packages(arg_9_0)
	arg_9_0._cache.num_packages = arg_9_0._cache.num_packages or table.size(package.loaded)

	return arg_9_0._cache.num_packages
end

function ImguiUILiveCode._num_processable_packages(arg_10_0)
	if not arg_10_0._cache.num_processable_packages then
		local var_10_0 = 0

		for iter_10_0, iter_10_1 in pairs(package.loaded) do
			if arg_10_0:_is_live_code_file(iter_10_0, iter_10_1) then
				var_10_0 = var_10_0 + 1
			end
		end

		arg_10_0._cache.num_processable_packages = var_10_0
	end

	return arg_10_0._cache.num_processable_packages
end

function ImguiUILiveCode._clear_cache_if_dirty(arg_11_0)
	if arg_11_0:_num_packages() ~= table.size(package.loaded) then
		table.clear(arg_11_0._cache)
	end
end

function ImguiUILiveCode._process_packages(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:_calculate_num_frame_packages(arg_12_1)
	local var_12_1 = 0
	local var_12_2 = arg_12_0:_num_packages()

	for iter_12_0 = 1, var_12_2 do
		local var_12_3 = arg_12_0:_next_package()

		if arg_12_0:_update_package(var_12_3) then
			var_12_1 = var_12_1 + 1

			if var_12_0 <= var_12_1 then
				break
			end
		end
	end
end

function ImguiUILiveCode._update_package(arg_13_0, arg_13_1)
	local var_13_0 = package.loaded[arg_13_1]
	local var_13_1 = false

	if arg_13_0:_is_live_code_file(arg_13_1, var_13_0) then
		local var_13_2, var_13_3 = arg_13_0:_hash_file(arg_13_1)

		if var_13_2 ~= var_0_0 and arg_13_0._file_hashes[arg_13_1] and arg_13_0._file_hashes[arg_13_1] ~= var_13_2 then
			arg_13_0:_merge_changes(arg_13_1, var_13_3)
		end

		arg_13_0._file_hashes[arg_13_1] = var_13_2
		arg_13_0._require_datas[arg_13_1] = var_13_0
		var_13_1 = true
	end

	return var_13_1
end

function ImguiUILiveCode._file_name(arg_14_0, arg_14_1)
	arg_14_0._src_dir = arg_14_0._src_dir or string.gsub(Application.source_directory(), "\\", "/") .. "/"

	return arg_14_0._src_dir .. arg_14_1 .. ".lua"
end

function ImguiUILiveCode._is_live_code_file(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0._cache.is_live_code_file then
		arg_15_0._cache.is_live_code_file = {}
	end

	if not arg_15_0._cache.is_live_code_file[arg_15_1] then
		arg_15_0._cache.is_live_code_file[arg_15_1] = false

		if type(arg_15_2) == "table" then
			if rawget(arg_15_2, "live_code") then
				arg_15_0._cache.is_live_code_file[arg_15_1] = true
			else
				for iter_15_0, iter_15_1 in pairs(var_0_1) do
					if string.find(arg_15_1, iter_15_1) then
						arg_15_0._cache.is_live_code_file[arg_15_1] = true

						break
					end
				end
			end
		end
	end

	return arg_15_0._cache.is_live_code_file[arg_15_1]
end

function ImguiUILiveCode._hash_file(arg_16_0, arg_16_1)
	local var_16_0 = io.open(arg_16_0:_file_name(arg_16_1))

	if var_16_0 then
		local var_16_1 = var_16_0:read("*all")

		var_16_0:close()

		return var_16_1, var_16_1
	end

	return var_0_0, ""
end

function ImguiUILiveCode._mark_package_dirty(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0._dirty_packages[arg_17_1] = arg_17_2
end

function ImguiUILiveCode._merge_changes(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = loadstring(arg_18_2)
	local var_18_1, var_18_2 = pcall(var_18_0)

	if var_18_1 and var_18_2 then
		local var_18_3 = table.clone(arg_18_0._require_datas[arg_18_1])

		arg_18_0:_mark_package_dirty(arg_18_1, var_18_3)
		table.merge_recursive(arg_18_0._require_datas[arg_18_1], var_18_2)
		arg_18_0:_handle_nil_recursive(var_18_3, var_18_2, arg_18_0._require_datas[arg_18_1])
		Managers.ui:reload_ingame_ui()
	end
end

function ImguiUILiveCode._handle_nil_recursive(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	for iter_19_0, iter_19_1 in pairs(arg_19_1) do
		if not arg_19_2[iter_19_0] then
			arg_19_3[iter_19_0] = nil
		end

		if type(iter_19_1) == "table" and type(arg_19_2[iter_19_0]) == "table" then
			arg_19_0:_handle_nil_recursive(arg_19_1[iter_19_0], arg_19_2[iter_19_0], arg_19_3[iter_19_0])
		end
	end
end

function ImguiUILiveCode._revert_dirty_packages(arg_20_0, arg_20_1)
	for iter_20_0, iter_20_1 in pairs(arg_20_0._dirty_packages) do
		local var_20_0 = table.clone(arg_20_0._require_datas[iter_20_0])

		table.merge_recursive(arg_20_0._require_datas[iter_20_0], iter_20_1)
		arg_20_0:_handle_nil_recursive(var_20_0, iter_20_1, arg_20_0._require_datas[iter_20_0])
		printf("[ImguiUILiveCode] ERROR: %s", arg_20_1)
		Debug.sticky_text("Error detected last frame. Reverted changes in %s. See error in console.", iter_20_0, "delay", 6)
	end

	table.clear(arg_20_0._dirty_packages)
end

function ImguiUILiveCode._calculate_num_frame_packages(arg_21_0, arg_21_1)
	arg_21_0._last_num_packages = arg_21_0._last_num_packages or 0

	local var_21_0 = 1 / arg_21_0._target_fps
	local var_21_1 = arg_21_1 > 0 and var_21_0 / arg_21_1 or 0

	if var_21_0 < arg_21_1 then
		var_21_1 = var_21_1^3
		arg_21_0._last_num_packages = arg_21_0._last_num_packages - 1 / var_21_1
	elseif var_21_1 > 0 then
		arg_21_0._last_num_packages = arg_21_0._last_num_packages + 1
	end

	arg_21_0._last_num_packages = math.clamp(arg_21_0._last_num_packages, 1, arg_21_0:_num_processable_packages())

	return arg_21_0._last_num_packages
end
