-- chunkname: @scripts/imgui/imgui_ui_live_code.lua

require("scripts/utils/hash_utils")

ImguiUILiveCode = class(ImguiUILiveCode)

local num = -1
local tbl = {
	"definitions"
}

ImguiUILiveCode.init = function (self)
	-- function 1
	self._require_datas = {}
	self._file_hashes = {}
	self._dirty_packages = {}
	self._cache = {}
	self._target_fps = 60
end

local flag = true

ImguiUILiveCode.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not flag then
		self:init()

		flag = false
	end

	self:_clear_cache_if_dirty()
	self:_process_packages(arg_2_2)
	self:_safeguard_dirty_packages()
end

ImguiUILiveCode._safeguard_dirty_packages = function (self)
	-- function 3
	if not table.is_empty(self._dirty_packages) then
		return
	end

	local update = update

	function update(...)
		-- function 4
		local var_4_0, var_4_1 = pcall(update, ...)

		if not var_4_0 then
			self:_revert_dirty_packages(var_4_1)
		end

		table.clear(self._dirty_packages)

		update = update
	end
end

ImguiUILiveCode.on_show = function (arg_5_0)
	-- function 5
	return
end

local format = string.format("\n-------------------------------------------------\n\nFor a file to support live coding it must contain\none of the following words in thier filenames:\n\n[\n\t%s\n]\n\nand return a table, or specify 'live_code = true'\nin their return table.\n\n-------------------------------------------------\n\nIt's now running on a fairly naive solution of\nopening every relevant file in packages.loaded,\nreads it all, and diffs its content. This limits\nhow many files we can process each frame. If you\nhave the time, please implement a file watcher\ninstead.\n\n-------------------------------------------------\n\n", table.concat(tbl, ",\n\t"))

ImguiUILiveCode.draw = function (self)
	-- function 6
	local begin_window, var_6_1 = Imgui.begin_window("UI Live Code", "always_auto_resize")

	if not var_6_1 then
		return begin_window
	end

	Imgui.text("UI Live Coding is now active.")

	local text = Imgui.text
	local format_2 = string.format
	local str = "Files processed last frame: %s out of %s"
	local round = math.round
	local _last_printed_package_count = self._last_printed_package_count

	_last_printed_package_count = _last_printed_package_count or 0

	text(format_2(str, round(_last_printed_package_count), self:_num_processable_packages()))

	self._target_fps = Imgui.slider_int("FPS Throttle Limit", self._target_fps, 1, 120)

	Imgui.text(format)

	local num = 1
	local time = Managers.time:time("main")
	local _next_package_count_update_t = self._next_package_count_update_t

	_next_package_count_update_t = _next_package_count_update_t or 0

	if _next_package_count_update_t < time then
		self._next_package_count_update_t = time + num
		self._last_printed_package_count = self._last_num_packages
	end

	Imgui.text("Happy coding.")
	Imgui.end_window()

	return begin_window
end

ImguiUILiveCode.is_persistent = function (arg_7_0)
	-- function 7
	return true
end

ImguiUILiveCode._next_package = function (self)
	-- function 8
	local var_8_0 = next(package.loaded, self._next_package_name)

	var_8_0 = var_8_0 or next(package.loaded)
	self._next_package_name = var_8_0

	return self._next_package_name
end

ImguiUILiveCode._num_packages = function (self)
	-- function 9
	local _cache = self._cache
	local num_packages = self._cache.num_packages

	num_packages = num_packages or table.size(package.loaded)
	_cache.num_packages = num_packages

	return self._cache.num_packages
end

ImguiUILiveCode._num_processable_packages = function (self)
	-- function 10
	if not self._cache.num_processable_packages then
		local num = 0

		for k, v in pairs(package.loaded) do
			if not self:_is_live_code_file(k, v) then
				num = num + 1
			end
		end

		self._cache.num_processable_packages = num
	end

	return self._cache.num_processable_packages
end

ImguiUILiveCode._clear_cache_if_dirty = function (self)
	-- function 11
	if self:_num_packages() ~= table.size(package.loaded) then
		table.clear(self._cache)
	end
end

ImguiUILiveCode._process_packages = function (self, arg_12_1)
	-- function 12
	local _calculate_num_frame_packages = self:_calculate_num_frame_packages(arg_12_1)
	local num = 0
	local _num_packages = self:_num_packages()

	for i = 1, _num_packages do
		local _next_package = self:_next_package()

		if not self:_update_package(_next_package) then
			num = num + 1

			if _calculate_num_frame_packages <= num then
				break
			end
		end
	end
end

ImguiUILiveCode._update_package = function (self, arg_13_1)
	-- function 13
	local var_13_0 = package.loaded[arg_13_1]
	local flag = false

	if not self:_is_live_code_file(arg_13_1, var_13_0) then
		local _hash_file, var_13_3 = self:_hash_file(arg_13_1)

		if not ((_hash_file == num or not self._file_hashes[arg_13_1]) and self._file_hashes[arg_13_1] == _hash_file) then
			self:_merge_changes(arg_13_1, var_13_3)
		end

		self._file_hashes[arg_13_1] = _hash_file
		self._require_datas[arg_13_1] = var_13_0
		flag = true
	end

	return flag
end

ImguiUILiveCode._file_name = function (self, arg_14_1)
	-- function 14
	local _src_dir = self._src_dir

	_src_dir = _src_dir or string.gsub(Application.source_directory(), "\\", "/") .. "/"
	self._src_dir = _src_dir

	return self._src_dir .. arg_14_1 .. ".lua"
end

ImguiUILiveCode._is_live_code_file = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._cache.is_live_code_file then
		self._cache.is_live_code_file = {}
	end

	if not self._cache.is_live_code_file[arg_15_1] then
		self._cache.is_live_code_file[arg_15_1] = false

		if type(arg_15_2) == "table" then
			if not rawget(arg_15_2, "live_code") then
				self._cache.is_live_code_file[arg_15_1] = true
			else
				for k, v in pairs(tbl) do
					if not string.find(arg_15_1, v) then
						self._cache.is_live_code_file[arg_15_1] = true

						break
					end
				end
			end
		end
	end

	return self._cache.is_live_code_file[arg_15_1]
end

ImguiUILiveCode._hash_file = function (self, arg_16_1)
	-- function 16
	local open = io.open(self:_file_name(arg_16_1))

	if not open then
		local read = open:read("*all")

		open:close()

		return read, read
	end

	return num, ""
end

ImguiUILiveCode._mark_package_dirty = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	arg_17_0._dirty_packages[arg_17_1] = arg_17_2
end

ImguiUILiveCode._merge_changes = function (self, arg_18_1, arg_18_2)
	-- function 18
	local var_18_0 = loadstring(arg_18_2)
	local var_18_1, var_18_2 = pcall(var_18_0)

	if not var_18_1 and not var_18_2 then
		local clone = table.clone(self._require_datas[arg_18_1])

		self:_mark_package_dirty(arg_18_1, clone)
		table.merge_recursive(self._require_datas[arg_18_1], var_18_2)
		self:_handle_nil_recursive(clone, var_18_2, self._require_datas[arg_18_1])
		Managers.ui:reload_ingame_ui()
	end
end

ImguiUILiveCode._handle_nil_recursive = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	for k, v in pairs(arg_19_1) do
		if not arg_19_2[k] then
			arg_19_3[k] = nil
		end

		if not (type(v) ~= "table" or type(arg_19_2[k]) ~= "table") then
			self:_handle_nil_recursive(arg_19_1[k], arg_19_2[k], arg_19_3[k])
		end
	end
end

ImguiUILiveCode._revert_dirty_packages = function (self, arg_20_1)
	-- function 20
	for k, v in pairs(self._dirty_packages) do
		local clone = table.clone(self._require_datas[k])

		table.merge_recursive(self._require_datas[k], v)
		self:_handle_nil_recursive(clone, v, self._require_datas[k])
		printf("[ImguiUILiveCode] ERROR: %s", arg_20_1)
		Debug.sticky_text("Error detected last frame. Reverted changes in %s. See error in console.", k, "delay", 6)
	end

	table.clear(self._dirty_packages)
end

ImguiUILiveCode._calculate_num_frame_packages = function (self, arg_21_1)
	-- function 21
	local _last_num_packages = self._last_num_packages

	_last_num_packages = _last_num_packages or 0
	self._last_num_packages = _last_num_packages

	local num = 1 / self._target_fps
	local num_2

	if arg_21_1 > 0 then
		num_2 = num / arg_21_1

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = 0

	::label_21_0::

	if num < arg_21_1 then
		num_2 = num_2^3
		self._last_num_packages = self._last_num_packages - 1 / num_2
	elseif num_2 > 0 then
		self._last_num_packages = self._last_num_packages + 1
	end

	self._last_num_packages = math.clamp(self._last_num_packages, 1, self:_num_processable_packages())

	return self._last_num_packages
end
