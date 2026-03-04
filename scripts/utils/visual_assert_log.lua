-- chunkname: @scripts/utils/visual_assert_log.lua

script_data.visual_assert_log_enabled = script_data.visual_assert_log_enabled or Development.parameter("visual_assert_log_enabled")
VisualAssertLog = VisualAssertLog or {}

function VisualAssertLog.setup(arg_1_0)
	local var_1_0 = VisualAssertLog

	var_1_0.world = arg_1_0
	var_1_0.console_page_up_key = Keyboard.button_index("page up")
	var_1_0.console_page_down_key = Keyboard.button_index("page down")
	var_1_0.console_end_key = Keyboard.button_index("insert")

	if arg_1_0 then
		var_1_0.gui = World.create_screen_gui(arg_1_0, "material", "materials/fonts/gw_fonts", "immediate")
	end

	var_1_0.asserts = VisualAssertLog.asserts or {}
	var_1_0.n_asserts = VisualAssertLog.n_asserts or 0
	var_1_0.current_visualized_assert = 1
	var_1_0.display_asserts = false
end

function VisualAssertLog.cleanup()
	local var_2_0 = VisualAssertLog

	if VisualAssertLog.world and VisualAssertLog.gui then
		World.destroy_gui(VisualAssertLog.world, VisualAssertLog.gui)

		VisualAssertLog.world = nil
		VisualAssertLog.gui = nil
	end
end

local var_0_0 = 16
local var_0_1 = "arial"
local var_0_2 = "materials/fonts/" .. var_0_1

function VisualAssertLog.update()
	if not script_data.visual_assert_log_enabled then
		return
	end

	if VisualAssertLog.n_asserts > 0 then
		local var_3_0 = VisualAssertLog.gui
		local var_3_1 = RESOLUTION_LOOKUP.res_w
		local var_3_2 = RESOLUTION_LOOKUP.res_h
		local var_3_3 = Color(255, 204, 0)

		if Keyboard.pressed(VisualAssertLog.console_end_key) then
			VisualAssertLog.display_asserts = not VisualAssertLog.display_asserts
		end

		if VisualAssertLog.display_asserts then
			if DEDICATED_SERVER then
				print("[VisualAssertLog] Dumping VisualAssertLog.asserts")

				for iter_3_0, iter_3_1 in ipairs(VisualAssertLog.asserts) do
					local var_3_4 = iter_3_1.message

					print(var_3_4)

					local var_3_5 = iter_3_1.traceback

					for iter_3_2, iter_3_3 in ipairs(var_3_5) do
						print(iter_3_3)
					end

					print("=========================================================")
				end

				VisualAssertLog.display_asserts = false
			else
				Gui.text(var_3_0, "VAsrt:" .. tostring(VisualAssertLog.n_asserts), var_0_2, var_0_0, var_0_1, Vector3(var_3_1 - 50, var_3_2 - 20, 999), var_3_3)

				local var_3_6 = VisualAssertLog.n_asserts
				local var_3_7 = VisualAssertLog.current_visualized_assert

				if Keyboard.pressed(VisualAssertLog.console_page_up_key) then
					var_3_7 = var_3_7 + 1
					var_3_7 = var_3_6 < var_3_7 and 1 or var_3_7
				end

				if Keyboard.pressed(VisualAssertLog.console_page_down_key) then
					var_3_7 = var_3_7 - 1
					var_3_7 = var_3_7 <= 0 and var_3_6 or var_3_7
				end

				VisualAssertLog.current_visualized_assert = var_3_7

				local var_3_8 = VisualAssertLog.asserts[var_3_7]
				local var_3_9 = var_3_2 - 50 - var_0_0
				local var_3_10, var_3_11 = Gui.text_extents(var_3_0, tostring(var_3_8.message), var_0_2, var_0_0)
				local var_3_12 = var_3_11.x - var_3_10.x

				Gui.text(var_3_0, tostring(var_3_8.message), var_0_2, var_0_0, var_0_1, Vector3(var_3_1 / 2 - var_3_12 / 2, var_3_9, 999), var_3_3)

				for iter_3_4, iter_3_5 in ipairs(var_3_8.traceback) do
					local var_3_13, var_3_14 = Gui.text_extents(var_3_0, tostring(iter_3_5), var_0_2, var_0_0)
					local var_3_15 = var_3_14.x - var_3_13.x

					Gui.text(var_3_0, tostring(iter_3_5), var_0_2, var_0_0, var_0_1, Vector3(50, var_3_9 - iter_3_4 * var_0_0, 999), var_3_3)
				end
			end
		end
	end
end

local function var_0_3(arg_4_0)
	local var_4_0 = #arg_4_0

	table.remove(arg_4_0, (var_4_0 + 1) / 2 + 2)
	table.remove(arg_4_0, 3)
	table.remove(arg_4_0, 2)

	local var_4_1
	local var_4_2 = 1

	for iter_4_0, iter_4_1 in ipairs(arg_4_0) do
		if var_4_1 then
			if string.find(iter_4_1, "^local_variables%:$") then
				var_4_2 = 1
			else
				local var_4_3 = string.gsub(iter_4_1, "^[ ]*%[(%d+)%] ([a-zA-Z0-9 :=,./%[%]]+)", "%2")

				arg_4_0[iter_4_0] = string.format("[%d] %s", var_4_2, var_4_3)
				var_4_2 = var_4_2 + 1
			end
		elseif string.find(iter_4_1, "^stack traceback%:$") then
			var_4_1 = true
		end
	end

	return arg_4_0
end

function visual_assert(arg_5_0, arg_5_1, ...)
	if not arg_5_0 then
		local var_5_0 = VisualAssertLog.n_asserts + 1

		if var_5_0 <= 50 then
			VisualAssertLog.n_asserts = var_5_0

			local var_5_1 = {
				message = string.format(arg_5_1, ...),
				traceback = var_0_3(string.split_deprecated(Script.callstack(), "\n"))
			}

			VisualAssertLog.asserts[var_5_0] = var_5_1

			if DEDICATED_SERVER then
				arg_5_1 = string.format(arg_5_1, ...)

				Application.error("Visual Assert: " .. arg_5_1)
			end
		end
	end

	return arg_5_0
end
