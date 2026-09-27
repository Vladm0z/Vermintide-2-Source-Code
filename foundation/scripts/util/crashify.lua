-- chunkname: @foundation/scripts/util/crashify.lua

return {
	print_property = function (arg_1_0, arg_1_1)
		-- function 1
		if arg_1_0 == nil then
			Application.warning("[Crashify] Property key can't be nil")

			return
		end

		if arg_1_1 == nil then
			Application.warning("[Crashify] Property value (%s) can't be nil", arg_1_0)

			return
		end

		local format = string.format("%s = %s", arg_1_0, arg_1_1)
		local format_2 = string.format("<<crashify-property>>%s<</crashify-property>>", format)

		if not IS_WINDOWS then
			Application.add_crash_property(arg_1_0, tostring(arg_1_1))
		end

		print(format_2)
	end,
	print_breadcrumb = function (arg_2_0)
		-- function 2
		if arg_2_0 == nil then
			Application.warning("[Crashify] Breadcrumb can't be nil")

			return
		end

		local format = string.format("<<crashify-breadcrumb>>\n\t\t\t<<timestamp>%f<</timestamp>>\n\t\t\t<<value>>%s<</value>>\n\t\t<</crashify-breadcrumb>>", Application.time_since_launch(), arg_2_0)

		print(format)
	end,
	print_exception = function (arg_3_0, arg_3_1, ...)
		-- function 3
		Application.set_exit_code(1, "silent_limited")

		if arg_3_0 == nil then
			Application.warning("[Crashify] System can't be nil")

			return
		end

		if arg_3_1 == nil then
			Application.warning("[Crashify] Message can't be nil")

			return
		end

		local var_3_0, var_3_1 = pcall(string.format, arg_3_1, ...)

		if not var_3_0 then
			Application.warning("[Crashify] Error formatting exception")

			return
		end

		local format = string.format("<<crashify-exception>>\n\t\t\t<<system>>%s<</system>>\n\t\t\t<<message>>%s<</message>>\n\t\t\t<<callstack>>%s<</callstack>>\n\t\t<</crashify-exception>>", arg_3_0, var_3_1, Script.callstack())

		print(format)

		if not Script.do_break then
			Script.do_break(script_data.break_on_crashify_exceptions)
		end
	end
}
