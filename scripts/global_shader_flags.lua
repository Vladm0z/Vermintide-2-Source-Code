-- chunkname: @scripts/global_shader_flags.lua

local num = 8388608
local tbl = {
	"NECROMANCER_CAREER_REMAP",
	"EVENT_ANNIVERSARY",
	"EVENT_SKULLS",
	"EVENT_GEHEIMNISNACHT",
	"EVENT_GOTWF"
}
local tbl_2 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	for k, v in pairs(arg_1_0) do
		if v == arg_1_1 then
			return k
		end
	end

	return nil
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if GlobalShaderFlags.overridden_shader_flags[arg_2_2] == nil then
		Application.set_render_setting(arg_2_0, arg_2_1)
	end

	GlobalShaderFlags.stored_values[arg_2_0] = arg_2_1
end

local function fn_3()
	-- function 3
	local tbl_3 = {}

	for k, v in pairs(tbl_2) do
		local var_3_1 = fn(tbl, k)

		tbl_3[(var_3_1 - 1) * 4 + 1] = v[2] / 255
		tbl_3[(var_3_1 - 1) * 4 + 2] = v[3] / 255
		tbl_3[(var_3_1 - 1) * 4 + 3] = v[4] / 255
		tbl_3[(var_3_1 - 1) * 4 + 4] = v[1] / 255
	end

	fn_2("particle_light_remapping_table", tbl_3)
end

local function fn_4()
	-- function 4
	fn_2("global_shader_flags", num)
end

local GlobalShaderFlags = GlobalShaderFlags

GlobalShaderFlags = GlobalShaderFlags or {}
GlobalShaderFlags = GlobalShaderFlags

local GlobalShaderFlags_2 = GlobalShaderFlags
local stored_values = GlobalShaderFlags.stored_values

stored_values = stored_values or {}
GlobalShaderFlags_2.stored_values = stored_values

local GlobalShaderFlags_3 = GlobalShaderFlags
local overridden_shader_flags = GlobalShaderFlags.overridden_shader_flags

overridden_shader_flags = overridden_shader_flags or {}
GlobalShaderFlags_3.overridden_shader_flags = overridden_shader_flags

GlobalShaderFlags.reset = function ()
	-- function 5
	assert(#tbl < 23, string.format("[GlobalShaderFlags] There is a maximum of 22 available shader flags. %q is out of scope", tbl[#tbl]))
	fn_3()
	fn_4()
end

local function fn_5(arg_6_0, arg_6_1)
	-- function 6
	local var_6_0 = fn(tbl, arg_6_0)

	assert(var_6_0, string.format("[GlobalShaderFlags] There is no flag called %q setup in global_shader_flags.lua", arg_6_0))

	local render_config = Application.render_config("settings", "global_shader_flags")
	local var_6_2

	if not arg_6_1 then
		var_6_2 = bit.bor(render_config, bit.lshift(1, var_6_0 - 1))
	else
		var_6_2 = bit.band(render_config, bit.bnot(bit.lshift(1, var_6_0 - 1)))
	end

	return var_6_2
end

GlobalShaderFlags.set_global_shader_flag = function (arg_7_0, arg_7_1)
	-- function 7
	local var_7_0 = fn_5(arg_7_0, arg_7_1)

	fn_2("global_shader_flags", var_7_0, arg_7_0)
end

GlobalShaderFlags.set_override_shader_flag = function (arg_8_0, arg_8_1)
	-- function 8
	local var_8_0 = fn_5(arg_8_0, arg_8_1)

	Application.set_render_setting("global_shader_flags", var_8_0)

	GlobalShaderFlags.overridden_shader_flags[arg_8_0] = arg_8_1
end

GlobalShaderFlags.remove_override_shader_flag = function (arg_9_0)
	-- function 9
	local global_shader_flags = GlobalShaderFlags.stored_values.global_shader_flags
	local var_9_1 = fn(tbl, arg_9_0)
	local lshift = bit.lshift(1, var_9_1 - 1)
	local flag = bit.band(global_shader_flags, lshift) > 0
	local var_9_4 = fn_5(arg_9_0, flag)

	Application.set_render_setting("global_shader_flags", var_9_4)

	GlobalShaderFlags.overridden_shader_flags[arg_9_0] = nil
end

GlobalShaderFlags.apply_settings = function ()
	-- function 10
	for k, v in pairs(GlobalShaderFlags.stored_values) do
		fn_2(k, v)
	end
end

GlobalShaderFlags.print_debug = function ()
	-- function 11
	if BUILD ~= "release" then
		local render_config = Application.render_config("settings", "global_shader_flags")

		print("")
		print("##########################")
		print("[GlobalShaderFlags]")

		local str = ""

		for i = 31, 0, -1 do
			local lshift = bit.lshift(1, i)
			local band = bit.band(render_config, lshift)
			local flag

			flag = i % 8 ~= 0 or not " " or ""

			local var_11_5 = str
			local flag_2

			flag_2 = not (band >= 1) or not 1 or 0
			str = var_11_5 .. flag_2 .. flag
		end

		print("Bit Layout: " .. str)
		print("---------------------------")
		print("")
		print("Active Shader Flags:")

		for j = 1, #tbl do
			local var_11_7 = tbl[j]
			local lshift_2 = bit.lshift(1, j - 1)

			if bit.band(render_config, lshift_2) > 0 then
				print("- " .. var_11_7)
			end
		end

		print("---------------------------")
		print("")
		print("<AVAILABLE SHADER FLAGS>")

		for k = 1, #tbl do
			print("\t" .. tbl[k])
		end

		print("</AVAILABLE SHADER FLAGS>")
		print("##########################")
		print("")

		local render_config_2 = Application.render_config("settings", "particle_light_remapping_table")

		print("Particle light remapping table = [")

		for l = 1, #render_config_2, 4 do
			local num = (l + 3) / 4
			local str_2 = "\tA: " .. render_config_2[l + 3] * 255
			local str_3 = "\tR: " .. render_config_2[l] * 255
			local str_4 = "\tG: " .. render_config_2[l + 1] * 255
			local str_5 = "\tB: " .. render_config_2[l + 2] * 255 .. " // " .. tbl[num]

			if l > 1 then
				print("\t----------------------")
			end

			print(str_2)
			print(str_3)
			print(str_4)
			print(str_5)
		end

		print("]")
		print("##########################")
		print("")
	end
end
