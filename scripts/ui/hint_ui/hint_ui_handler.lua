-- chunkname: @scripts/ui/hint_ui/hint_ui_handler.lua

require("scripts/ui/hint_ui/hint_templates")
require("scripts/ui/hint_ui/hint_ui_versus_how_to_play")

HintUIHandler = class(HintUIHandler)

local function fn()
	-- function 1
	print("HintUIHandler - save done")
end

local function fn_2(arg_2_0)
	-- function 2
	local SaveData = SaveData
	local viewed_hints = SaveData.viewed_hints

	viewed_hints = viewed_hints or {}
	viewed_hints[arg_2_0] = true
	SaveData.viewed_hints = viewed_hints

	Managers.save:auto_save(SaveFileName, SaveData, fn)
end

HintUIHandler.init = function (self, arg_3_1)
	-- function 3
	self._context = arg_3_1
	self._hints = {}
	self._n_hints = 0
	self._hints_ids = 0
	self._active_hint_lookup = {}
	self._unseen_hints = {}

	self:parse_unseen_hints()
	Managers.state.event:register(self, "ui_show_hint", "ui_show_hint")
end

HintUIHandler.destroy = function (self)
	-- function 4
	Managers.state.event:unregister("ui_show_popup", self)

	for i = 1, self._n_hints do
		local var_4_0 = self._hints[i]

		if not var_4_0 then
			var_4_0:destroy()

			self._hints[i] = nil
		end
	end
end

HintUIHandler.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_handle_condition_hints(arg_5_1, arg_5_2)

	local var_5_0 = self._hints[self._n_hints]

	if not var_5_0 then
		return
	end

	var_5_0:update(arg_5_1, arg_5_2)

	if not var_5_0:exit_done() then
		local get_hint_name = var_5_0:get_hint_name()
		local get_unseen_hint_index = self:get_unseen_hint_index(get_hint_name)

		var_5_0:delete()

		self._hints[self._n_hints] = nil
		self._n_hints = self._n_hints - 1

		fn_2(get_hint_name)
		table.swap_delete(self._unseen_hints, get_unseen_hint_index)

		self._active_hint_lookup[get_hint_name] = false
	end
end

HintUIHandler.queue_hint = function (self, arg_6_1)
	-- function 6
	local _n_hints = self._n_hints
	local _hints = self._hints
	local num = _n_hints + 1

	self._n_hints = num
	self._hints_ids = self._hints_ids + 1

	local var_6_3 = tostring(self._hints_ids)

	arg_6_1.hint_id = var_6_3

	if not (num > 1) or not _hints[num - 1]:is_hint_showing() then
		table.insert(_hints, 1, arg_6_1)

		self._hints = _hints

		return var_6_3
	end

	_hints[num] = arg_6_1
	self._hints = _hints

	return var_6_3
end

HintUIHandler.ui_show_hint = function (self, arg_7_1)
	-- function 7
	local var_7_0 = HintTemplates[arg_7_1]

	if not var_7_0 then
		printf("[HintUIHandler]No HintTemplate settings found for hint %q", arg_7_1)

		return
	end

	if not var_7_0.data.duration then
		printf("[HintUIHandler]No duration defined for hint %q, A duration must be set in the HintTemplates data", arg_7_1)

		return
	end

	self:new_hint(arg_7_1, var_7_0)
end

HintUIHandler.new_hint = function (self, arg_8_1, arg_8_2)
	-- function 8
	local data = arg_8_2.data
	local var_8_1 = rawget(_G, data.class_name):new(self._context, arg_8_1, arg_8_2)

	self._active_hint_lookup[arg_8_1] = true

	self:queue_hint(var_8_1)
end

HintUIHandler._handle_condition_hints = function (self, arg_9_1, arg_9_2)
	-- function 9
	for i = 1, #self._unseen_hints do
		local var_9_0 = self._unseen_hints[i]

		if not self._active_hint_lookup[var_9_0] then
			local var_9_1 = HintTemplates[var_9_0]
			local data = var_9_1.data

			if not var_9_1.condition_function(data, arg_9_1, arg_9_2) then
				self:new_hint(var_9_0, var_9_1)
			end
		end
	end
end

HintUIHandler.is_hint_active = function (self)
	-- function 10
	local flag

	flag = not self._hints[self._n_hints] and true and false

	return flag
end

HintUIHandler.parse_unseen_hints = function (self)
	-- function 11
	table.clear(self._unseen_hints)

	for k, v in pairs(HintTemplates) do
		if not SaveData.viewed_hints and SaveData.viewed_hints[k] or not v.condition_function then
			self._unseen_hints[#self._unseen_hints + 1] = k
		end
	end
end

HintUIHandler.get_unseen_hint_index = function (self, arg_12_1)
	-- function 12
	for i = 1, #self._unseen_hints do
		if arg_12_1 == self._unseen_hints[i] then
			return i
		end
	end
end
