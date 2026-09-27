-- chunkname: @scripts/utils/visual_assert_log.lua

local script_data = script_data
local visual_assert_log_enabled = script_data.visual_assert_log_enabled

visual_assert_log_enabled = visual_assert_log_enabled or Development.parameter("visual_assert_log_enabled")
script_data.visual_assert_log_enabled = visual_assert_log_enabled

local VisualAssertLog = VisualAssertLog

VisualAssertLog = VisualAssertLog or {}
VisualAssertLog = VisualAssertLog

VisualAssertLog.setup = function (arg_1_0)
	-- function 1
	local VisualAssertLog = VisualAssertLog

	VisualAssertLog.world = arg_1_0
	VisualAssertLog.console_page_up_key = Keyboard.button_index("page up")
	VisualAssertLog.console_page_down_key = Keyboard.button_index("page down")
	VisualAssertLog.console_end_key = Keyboard.button_index("insert")

	if not arg_1_0 then
		VisualAssertLog.gui = World.create_screen_gui(arg_1_0, "material", "materials/fonts/gw_fonts", "immediate")
	end

	local asserts = VisualAssertLog.asserts

	asserts = asserts or {}
	VisualAssertLog.asserts = asserts

	local n_asserts = VisualAssertLog.n_asserts

	n_asserts = n_asserts or 0
	VisualAssertLog.n_asserts = n_asserts
	VisualAssertLog.current_visualized_assert = 1
	VisualAssertLog.display_asserts = false
end

VisualAssertLog.cleanup = function ()
	-- function 2
	local VisualAssertLog = VisualAssertLog

	if not VisualAssertLog.world and not VisualAssertLog.gui then
		World.destroy_gui(VisualAssertLog.world, VisualAssertLog.gui)

		VisualAssertLog.world = nil
		VisualAssertLog.gui = nil
	end
end

local num = 16
local str = "arial"
local str_2 = "materials/fonts/" .. str

VisualAssertLog.update = function ()
	-- function 3
	if not script_data.visual_assert_log_enabled then
		return
	end

	if VisualAssertLog.n_asserts > 0 then
		local gui = VisualAssertLog.gui
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local var_3_3 = Color(255, 204, 0)

		if not Keyboard.pressed(VisualAssertLog.console_end_key) then
			VisualAssertLog.display_asserts = not VisualAssertLog.display_asserts
		end

		if not VisualAssertLog.display_asserts then
			if not DEDICATED_SERVER then
				print("[VisualAssertLog] Dumping VisualAssertLog.asserts")

				for i, v in ipairs(VisualAssertLog.asserts) do
					local message = v.message

					print(message)

					local traceback = v.traceback

					for i_2, v_2 in ipairs(traceback) do
						print(v_2)
					end

					print("=========================================================")
				end

				VisualAssertLog.display_asserts = false
			else
				Gui.text(gui, "VAsrt:" .. tostring(VisualAssertLog.n_asserts), str_2, num, str, Vector3(res_w - 50, res_h - 20, 999), var_3_3)

				local n_asserts = VisualAssertLog.n_asserts
				local current_visualized_assert = VisualAssertLog.current_visualized_assert

				if not Keyboard.pressed(VisualAssertLog.console_page_up_key) then
					current_visualized_assert = current_visualized_assert + 1
					current_visualized_assert = not (n_asserts < current_visualized_assert) or not 1 or current_visualized_assert
				end

				if not Keyboard.pressed(VisualAssertLog.console_page_down_key) then
					current_visualized_assert = current_visualized_assert - 1
					current_visualized_assert = not (current_visualized_assert <= 0) or not n_asserts or current_visualized_assert
				end

				VisualAssertLog.current_visualized_assert = current_visualized_assert

				local var_3_8 = VisualAssertLog.asserts[current_visualized_assert]
				local num_2 = res_h - 50 - num
				local text_extents, var_3_11 = Gui.text_extents(gui, tostring(var_3_8.message), str_2, num)
				local num_3 = var_3_11.x - text_extents.x

				Gui.text(gui, tostring(var_3_8.message), str_2, num, str, Vector3(res_w / 2 - num_3 / 2, num_2, 999), var_3_3)

				for i_3, v_3 in ipairs(var_3_8.traceback) do
					local text_extents_2, var_3_14 = Gui.text_extents(gui, tostring(v_3), str_2, num)
					local num_4 = var_3_14.x - text_extents_2.x

					Gui.text(gui, tostring(v_3), str_2, num, str, Vector3(50, num_2 - i_3 * num, 999), var_3_3)
				end
			end
		end
	end
end

local function fn(self)
	-- function 4
	local count = #self

	table.remove(self, (count + 1) / 2 + 2)
	table.remove(self, 3)
	table.remove(self, 2)

	local var_4_1
	local num = 1

	for i, v in ipairs(self) do
		if not var_4_1 then
			if not string.find(v, "^local_variables%:$") then
				num = 1
			else
				local gsub = string.gsub(v, "^[ ]*%[(%d+)%] ([a-zA-Z0-9 :=,./%[%]]+)", "%2")

				self[i] = string.format("[%d] %s", num, gsub)
				num = num + 1
			end
		elseif not string.find(v, "^stack traceback%:$") then
			var_4_1 = true
		end
	end

	return self
end

function visual_assert(arg_5_0, arg_5_1, ...)
	-- function 5
	if not arg_5_0 then
		local num = VisualAssertLog.n_asserts + 1

		if num <= 50 then
			VisualAssertLog.n_asserts = num

			local tbl = {
				message = string.format(arg_5_1, ...),
				traceback = fn(string.split_deprecated(Script.callstack(), "\n"))
			}

			VisualAssertLog.asserts[num] = tbl

			if not DEDICATED_SERVER then
				arg_5_1 = string.format(arg_5_1, ...)

				Application.error("Visual Assert: " .. arg_5_1)
			end
		end
	end

	return arg_5_0
end
