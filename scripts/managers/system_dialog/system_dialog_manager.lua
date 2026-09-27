-- chunkname: @scripts/managers/system_dialog/system_dialog_manager.lua

SystemDialogManager = class(SystemDialogManager)

local function fn(...)
	-- function 1
	print("[SystemDialogManager]", ...)
end

SystemDialogManager.init = function (self)
	-- function 2
	self._dialogs = {}
	self._virtual_keyboards = {}
	self._virtual_keyboard_results = {}
	self._virtual_keyboard_index = 0
end

SystemDialogManager.destroy = function (arg_3_0)
	-- function 3
	return
end

SystemDialogManager.update = function (self, arg_4_1)
	-- function 4
	self:_handle_dialogs()
end

SystemDialogManager.check_status = function (self, arg_5_1)
	-- function 5
	local var_5_0

	if #self._dialogs > 0 then
		var_5_0 = self._dialogs[1]
	end

	local var_5_1

	if not var_5_0 then
		var_5_1 = self:_get_status(arg_5_1)
	end

	return var_5_1
end

SystemDialogManager._get_status = function (arg_6_0, arg_6_1)
	-- function 6
	return (arg_6_1.update())
end

SystemDialogManager._initialize = function (arg_7_0, arg_7_1)
	-- function 7
	if arg_7_1.initialize() ~= PS4.SCE_OK then
		fn("Failed to initialize " .. arg_7_1._name)

		return
	end

	return true
end

SystemDialogManager._terminate = function (arg_8_0, arg_8_1)
	-- function 8
	if arg_8_1.terminate() ~= PS4.SCE_OK then
		fn("Failed to terminate " .. arg_8_1._name)

		return
	end

	return true
end

SystemDialogManager._handle_dialogs = function (self)
	-- function 9
	local var_9_0

	if #self._dialogs > 0 then
		var_9_0 = self._dialogs[1]
	end

	if not var_9_0 then
		local dialog_instance = var_9_0.dialog_instance
		local _get_status = self:_get_status(dialog_instance)

		self:_abort_virtual_keyboard()

		if _get_status == dialog_instance.NONE then
			self:_initialize(dialog_instance)
		elseif _get_status == dialog_instance.INITIALIZED then
			local open = var_9_0.open(var_9_0)

			if not open then
				if open == PS4.SCE_OK then
					fn("Opened dialog")
				else
					fn("Failed to open dialog")
				end
			end
		elseif _get_status == dialog_instance.RUNNING then
			-- Nothing
		elseif _get_status == dialog_instance.FINISHED then
			if not var_9_0.callback then
				var_9_0.callback(_get_status)
			end

			if not self:_terminate(dialog_instance) then
				table.remove(self._dialogs, 1)
			end
		end
	end

	self:_handle_virtual_keyboards()
end

SystemDialogManager._handle_virtual_keyboards = function (self)
	-- function 10
	local var_10_0 = self._virtual_keyboards[1]

	if not var_10_0 then
		if not var_10_0.activated then
			if not PS4ImeDialog.is_finished() then
				local close, var_10_2 = PS4ImeDialog.close()

				if not var_10_0.aborted then
					var_10_0.aborted = nil
					var_10_0.activated = false
				else
					local index = var_10_0.index
					local var_10_4 = self._virtual_keyboard_results[index]

					if not var_10_4 then
						var_10_4.text = close ~= PS4ImeDialog.END_STATUS_OK or not var_10_2 or var_10_0.text
						var_10_4.done = true
						var_10_4.success = close == PS4ImeDialog.END_STATUS_OK
					end

					table.remove(self._virtual_keyboards, 1)
				end
			end
		elseif not (Managers.account:user_detached() or self:has_open_dialogs()) then
			table.dump(var_10_0, "Virtual Keyboard", 3)
			PS4ImeDialog.show(var_10_0)

			var_10_0.activated = true
		end
	end
end

SystemDialogManager._abort_virtual_keyboard = function (self)
	-- function 11
	local var_11_0 = self._virtual_keyboards[1]

	if not var_11_0 and not var_11_0.activated then
		if not PS4ImeDialog.is_showing() then
			PS4ImeDialog.abort()
		end

		var_11_0.aborted = true
	end
end

SystemDialogManager.open_system_dialog = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local function fn_2(self)
		-- function 13
		local dialog_instance = self.dialog_instance

		fn("open_system_dialog", unpack(self.params))

		return dialog_instance.open(unpack(self.params))
	end

	local tbl = {
		arg_12_1,
		arg_12_2
	}

	arg_12_0._dialogs[#arg_12_0._dialogs + 1] = {
		dialog_instance = MsgDialog,
		params = tbl,
		open = fn_2
	}
end

SystemDialogManager.open_save_dialog = function (arg_14_0, arg_14_1)
	-- function 14
	local function fn_2(self)
		-- function 15
		local dialog_instance = self.dialog_instance

		fn("open_save_dialog", self.required_blocks)

		return dialog_instance.open(self.required_blocks)
	end

	arg_14_0._dialogs[#arg_14_0._dialogs + 1] = {
		dialog_instance = SaveSystemDialog,
		required_blocks = arg_14_1,
		open = fn_2
	}
end

SystemDialogManager.open_commerce_dialog = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local function fn_2(self)
		-- function 17
		local dialog_instance = self.dialog_instance
		local targets = self.targets

		fn("open_commerce_dialog", arg_16_1, arg_16_2, not targets and unpack(targets))

		return dialog_instance.open2(self.mode, self.user_id, not targets and unpack(targets))
	end

	arg_16_0._dialogs[#arg_16_0._dialogs + 1] = {
		dialog_instance = NpCommerceDialog,
		mode = arg_16_1,
		user_id = arg_16_2,
		targets = arg_16_3,
		open = fn_2
	}
end

SystemDialogManager.open_error_dialog = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local function fn_2(self)
		-- function 19
		local dialog_instance = self.dialog_instance

		fn("open_error_dialog", self.error_code)

		return dialog_instance.open(self.error_code)
	end

	arg_18_0._dialogs[#arg_18_0._dialogs + 1] = {
		dialog_instance = ErrorDialog,
		error_code = arg_18_1,
		open = fn_2,
		callback = arg_18_2
	}
end

SystemDialogManager.open_virtual_keyboard = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	fassert(arg_20_1, "[SystemDialogManager] You need to provide a user_id")

	self._virtual_keyboard_index = self._virtual_keyboard_index + 1
	self._virtual_keyboards[#self._virtual_keyboards + 1] = {
		activated = false,
		user_id = arg_20_1,
		title = arg_20_2,
		text = arg_20_3,
		x = not arg_20_4 and arg_20_4[1],
		y = not arg_20_4 and arg_20_4[2],
		max_length = arg_20_5,
		index = self._virtual_keyboard_index
	}
	self._virtual_keyboard_results[self._virtual_keyboard_index] = {
		success = false,
		done = false,
		text = arg_20_3 or ""
	}

	return self._virtual_keyboard_index
end

SystemDialogManager.poll_virtual_keyboard = function (self, arg_21_1)
	-- function 21
	local var_21_0 = self._virtual_keyboard_results[arg_21_1]

	if not var_21_0 and not var_21_0.done then
		self._virtual_keyboard_results[arg_21_1] = nil

		return var_21_0.done, var_21_0.success, var_21_0.text
	end

	return false
end

SystemDialogManager.has_open_dialogs = function (self)
	-- function 22
	return #self._dialogs > 0
end
