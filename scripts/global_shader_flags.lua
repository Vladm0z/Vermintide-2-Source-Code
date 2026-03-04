-- chunkname: @scripts/global_shader_flags.lua

local var_0_0 = 8388608
local var_0_1 = {
	"NECROMANCER_CAREER_REMAP",
	"EVENT_ANNIVERSARY",
	"EVENT_SKULLS",
	"EVENT_GEHEIMNISNACHT",
	"EVENT_GOTWF"
}
local var_0_2 = {
	NECROMANCER_CAREER_REMAP = {
		39,
		0,
		182,
		110
	},
	EVENT_ANNIVERSARY = {
		255,
		245,
		184,
		0
	},
	EVENT_SKULLS = {
		125,
		202,
		0,
		0
	},
	EVENT_GEHEIMNISNACHT = {
		125,
		0,
		217,
		116
	},
	EVENT_GOTWF = {
		125,
		0,
		207,
		244
	}
}

local function var_0_3(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if iter_1_1 == arg_1_1 then
			return iter_1_0
		end
	end

	return nil
end

local function var_0_4(arg_2_0, arg_2_1, arg_2_2)
	if GlobalShaderFlags.overridden_shader_flags[arg_2_2] == nil then
		Application.set_render_setting(arg_2_0, arg_2_1)
	end

	GlobalShaderFlags.stored_values[arg_2_0] = arg_2_1
end

local function var_0_5()
	local var_3_0 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_2) do
		local var_3_1 = var_0_3(var_0_1, iter_3_0)

		var_3_0[(var_3_1 - 1) * 4 + 1] = iter_3_1[2] / 255
		var_3_0[(var_3_1 - 1) * 4 + 2] = iter_3_1[3] / 255
		var_3_0[(var_3_1 - 1) * 4 + 3] = iter_3_1[4] / 255
		var_3_0[(var_3_1 - 1) * 4 + 4] = iter_3_1[1] / 255
	end

	var_0_4("particle_light_remapping_table", var_3_0)
end

local function var_0_6()
	var_0_4("global_shader_flags", var_0_0)
end

GlobalShaderFlags = GlobalShaderFlags or {}
GlobalShaderFlags.stored_values = GlobalShaderFlags.stored_values or {}
GlobalShaderFlags.overridden_shader_flags = GlobalShaderFlags.overridden_shader_flags or {}

GlobalShaderFlags.reset = function ()
	assert(#var_0_1 < 23, string.format("[GlobalShaderFlags] There is a maximum of 22 available shader flags. %q is out of scope", var_0_1[#var_0_1]))
	var_0_5()
	var_0_6()
end

local function var_0_7(arg_6_0, arg_6_1)
	local var_6_0 = var_0_3(var_0_1, arg_6_0)

	assert(var_6_0, string.format("[GlobalShaderFlags] There is no flag called %q setup in global_shader_flags.lua", arg_6_0))

	local var_6_1 = Application.render_config("settings", "global_shader_flags")
	local var_6_2

	if arg_6_1 then
		var_6_2 = bit.bor(var_6_1, bit.lshift(1, var_6_0 - 1))
	else
		var_6_2 = bit.band(var_6_1, bit.bnot(bit.lshift(1, var_6_0 - 1)))
	end

	return var_6_2
end

GlobalShaderFlags.set_global_shader_flag = function (arg_7_0, arg_7_1)
	local var_7_0 = var_0_7(arg_7_0, arg_7_1)

	var_0_4("global_shader_flags", var_7_0, arg_7_0)
end

GlobalShaderFlags.set_override_shader_flag = function (arg_8_0, arg_8_1)
	local var_8_0 = var_0_7(arg_8_0, arg_8_1)

	Application.set_render_setting("global_shader_flags", var_8_0)

	GlobalShaderFlags.overridden_shader_flags[arg_8_0] = arg_8_1
end

GlobalShaderFlags.remove_override_shader_flag = function (arg_9_0)
	local var_9_0 = GlobalShaderFlags.stored_values.global_shader_flags
	local var_9_1 = var_0_3(var_0_1, arg_9_0)
	local var_9_2 = bit.lshift(1, var_9_1 - 1)
	local var_9_3 = bit.band(var_9_0, var_9_2) > 0
	local var_9_4 = var_0_7(arg_9_0, var_9_3)

	Application.set_render_setting("global_shader_flags", var_9_4)

	GlobalShaderFlags.overridden_shader_flags[arg_9_0] = nil
end

GlobalShaderFlags.apply_settings = function ()
	for iter_10_0, iter_10_1 in pairs(GlobalShaderFlags.stored_values) do
		var_0_4(iter_10_0, iter_10_1)
	end
end

GlobalShaderFlags.print_debug = function ()
	if BUILD ~= "release" then
		local var_11_0 = Application.render_config("settings", "global_shader_flags")

		print("")
		print("##########################")
		print("[GlobalShaderFlags]")

		local var_11_1 = ""

		for iter_11_0 = 31, 0, -1 do
			local var_11_2 = bit.lshift(1, iter_11_0)
			local var_11_3 = bit.band(var_11_0, var_11_2)
			local var_11_4 = iter_11_0 % 8 == 0 and " " or ""

			var_11_1 = var_11_1 .. (var_11_3 >= 1 and 1 or 0) .. var_11_4
		end

		print("Bit Layout: " .. var_11_1)
		print("---------------------------")
		print("")
		print("Active Shader Flags:")

		for iter_11_1 = 1, #var_0_1 do
			local var_11_5 = var_0_1[iter_11_1]
			local var_11_6 = bit.lshift(1, iter_11_1 - 1)

			if bit.band(var_11_0, var_11_6) > 0 then
				print("- " .. var_11_5)
			end
		end

		print("---------------------------")
		print("")
		print("<AVAILABLE SHADER FLAGS>")

		for iter_11_2 = 1, #var_0_1 do
			print("\t" .. var_0_1[iter_11_2])
		end

		print("</AVAILABLE SHADER FLAGS>")
		print("##########################")
		print("")

		local var_11_7 = Application.render_config("settings", "particle_light_remapping_table")

		print("Particle light remapping table = [")

		for iter_11_3 = 1, #var_11_7, 4 do
			local var_11_8 = (iter_11_3 + 3) / 4
			local var_11_9 = "\tA: " .. var_11_7[iter_11_3 + 3] * 255
			local var_11_10 = "\tR: " .. var_11_7[iter_11_3] * 255
			local var_11_11 = "\tG: " .. var_11_7[iter_11_3 + 1] * 255
			local var_11_12 = "\tB: " .. var_11_7[iter_11_3 + 2] * 255 .. " // " .. var_0_1[var_11_8]

			if iter_11_3 > 1 then
				print("\t----------------------")
			end

			print(var_11_9)
			print(var_11_10)
			print(var_11_11)
			print(var_11_12)
		end

		print("]")
		print("##########################")
		print("")
	end
end
