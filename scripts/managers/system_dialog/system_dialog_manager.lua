-- chunkname: @scripts/managers/system_dialog/system_dialog_manager.lua

SystemDialogManager = class(SystemDialogManager)

local function var_0_0(...)
	print("[SystemDialogManager]", ...)
end

function SystemDialogManager.init(arg_2_0)
	arg_2_0._dialogs = {}
	arg_2_0._virtual_keyboards = {}
	arg_2_0._virtual_keyboard_results = {}
	arg_2_0._virtual_keyboard_index = 0
end

function SystemDialogManager.destroy(arg_3_0)
	return
end

function SystemDialogManager.update(arg_4_0, arg_4_1)
	arg_4_0:_handle_dialogs()
end

function SystemDialogManager.check_status(arg_5_0, arg_5_1)
	local var_5_0

	if #arg_5_0._dialogs > 0 then
		var_5_0 = arg_5_0._dialogs[1]
	end

	local var_5_1

	if var_5_0 then
		var_5_1 = arg_5_0:_get_status(arg_5_1)
	end

	return var_5_1
end

function SystemDialogManager._get_status(arg_6_0, arg_6_1)
	return (arg_6_1.update())
end

function SystemDialogManager._initialize(arg_7_0, arg_7_1)
	if arg_7_1.initialize() ~= PS4.SCE_OK then
		var_0_0("Failed to initialize " .. arg_7_1._name)

		return
	end

	return true
end

function SystemDialogManager._terminate(arg_8_0, arg_8_1)
	if arg_8_1.terminate() ~= PS4.SCE_OK then
		var_0_0("Failed to terminate " .. arg_8_1._name)

		return
	end

	return true
end

function SystemDialogManager._handle_dialogs(arg_9_0)
	local var_9_0

	if #arg_9_0._dialogs > 0 then
		var_9_0 = arg_9_0._dialogs[1]
	end

	if var_9_0 then
		local var_9_1 = var_9_0.dialog_instance
		local var_9_2 = arg_9_0:_get_status(var_9_1)

		arg_9_0:_abort_virtual_keyboard()

		if var_9_2 == var_9_1.NONE then
			arg_9_0:_initialize(var_9_1)
		elseif var_9_2 == var_9_1.INITIALIZED then
			local var_9_3 = var_9_0.open(var_9_0)

			if var_9_3 then
				if var_9_3 == PS4.SCE_OK then
					var_0_0("Opened dialog")
				else
					var_0_0("Failed to open dialog")
				end
			end
		elseif var_9_2 == var_9_1.RUNNING then
			-- block empty
		elseif var_9_2 == var_9_1.FINISHED then
			if var_9_0.callback then
				var_9_0.callback(var_9_2)
			end

			if arg_9_0:_terminate(var_9_1) then
				table.remove(arg_9_0._dialogs, 1)
			end
		end
	end

	arg_9_0:_handle_virtual_keyboards()
end

function SystemDialogManager._handle_virtual_keyboards(arg_10_0)
	local var_10_0 = arg_10_0._virtual_keyboards[1]

	if var_10_0 then
		if var_10_0.activated then
			if PS4ImeDialog.is_finished() then
				local var_10_1, var_10_2 = PS4ImeDialog.close()

				if var_10_0.aborted then
					var_10_0.aborted = nil
					var_10_0.activated = false
				else
					local var_10_3 = var_10_0.index
					local var_10_4 = arg_10_0._virtual_keyboard_results[var_10_3]

					if var_10_4 then
						var_10_4.text = var_10_1 == PS4ImeDialog.END_STATUS_OK and var_10_2 or var_10_0.text
						var_10_4.done = true
						var_10_4.success = var_10_1 == PS4ImeDialog.END_STATUS_OK
					end

					table.remove(arg_10_0._virtual_keyboards, 1)
				end
			end
		elseif not Managers.account:user_detached() and not arg_10_0:has_open_dialogs() then
			table.dump(var_10_0, "Virtual Keyboard", 3)
			PS4ImeDialog.show(var_10_0)

			var_10_0.activated = true
		end
	end
end

function SystemDialogManager._abort_virtual_keyboard(arg_11_0)
	local var_11_0 = arg_11_0._virtual_keyboards[1]

	if var_11_0 and var_11_0.activated then
		if PS4ImeDialog.is_showing() then
			PS4ImeDialog.abort()
		end

		var_11_0.aborted = true
	end
end

function SystemDialogManager.open_system_dialog(arg_12_0, arg_12_1, arg_12_2)
	local function var_12_0(arg_13_0)
		local var_13_0 = arg_13_0.dialog_instance

		var_0_0("open_system_dialog", unpack(arg_13_0.params))

		return var_13_0.open(unpack(arg_13_0.params))
	end

	local var_12_1 = {
		arg_12_1,
		arg_12_2
	}

	arg_12_0._dialogs[#arg_12_0._dialogs + 1] = {
		dialog_instance = MsgDialog,
		params = var_12_1,
		open = var_12_0
	}
end

function SystemDialogManager.open_save_dialog(arg_14_0, arg_14_1)
	local function var_14_0(arg_15_0)
		local var_15_0 = arg_15_0.dialog_instance

		var_0_0("open_save_dialog", arg_15_0.required_blocks)

		return var_15_0.open(arg_15_0.required_blocks)
	end

	arg_14_0._dialogs[#arg_14_0._dialogs + 1] = {
		dialog_instance = SaveSystemDialog,
		required_blocks = arg_14_1,
		open = var_14_0
	}
end

function SystemDialogManager.open_commerce_dialog(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local function var_16_0(arg_17_0)
		local var_17_0 = arg_17_0.dialog_instance
		local var_17_1 = arg_17_0.targets

		var_0_0("open_commerce_dialog", arg_16_1, arg_16_2, var_17_1 and unpack(var_17_1))

		return var_17_0.open2(arg_17_0.mode, arg_17_0.user_id, var_17_1 and unpack(var_17_1))
	end

	arg_16_0._dialogs[#arg_16_0._dialogs + 1] = {
		dialog_instance = NpCommerceDialog,
		mode = arg_16_1,
		user_id = arg_16_2,
		targets = arg_16_3,
		open = var_16_0
	}
end

function SystemDialogManager.open_error_dialog(arg_18_0, arg_18_1, arg_18_2)
	local function var_18_0(arg_19_0)
		local var_19_0 = arg_19_0.dialog_instance

		var_0_0("open_error_dialog", arg_19_0.error_code)

		return var_19_0.open(arg_19_0.error_code)
	end

	arg_18_0._dialogs[#arg_18_0._dialogs + 1] = {
		dialog_instance = ErrorDialog,
		error_code = arg_18_1,
		open = var_18_0,
		callback = arg_18_2
	}
end

function SystemDialogManager.open_virtual_keyboard(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	fassert(arg_20_1, "[SystemDialogManager] You need to provide a user_id")

	arg_20_0._virtual_keyboard_index = arg_20_0._virtual_keyboard_index + 1
	arg_20_0._virtual_keyboards[#arg_20_0._virtual_keyboards + 1] = {
		activated = false,
		user_id = arg_20_1,
		title = arg_20_2,
		text = arg_20_3,
		x = arg_20_4 and arg_20_4[1],
		y = arg_20_4 and arg_20_4[2],
		max_length = arg_20_5,
		index = arg_20_0._virtual_keyboard_index
	}
	arg_20_0._virtual_keyboard_results[arg_20_0._virtual_keyboard_index] = {
		success = false,
		done = false,
		text = arg_20_3 or ""
	}

	return arg_20_0._virtual_keyboard_index
end

function SystemDialogManager.poll_virtual_keyboard(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._virtual_keyboard_results[arg_21_1]

	if var_21_0 and var_21_0.done then
		arg_21_0._virtual_keyboard_results[arg_21_1] = nil

		return var_21_0.done, var_21_0.success, var_21_0.text
	end

	return false
end

function SystemDialogManager.has_open_dialogs(arg_22_0)
	return #arg_22_0._dialogs > 0
end
