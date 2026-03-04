-- chunkname: @scripts/ui/ui_fonts.lua

local var_0_0 = Gui
local var_0_1 = math.floor
local var_0_2 = math.min
local var_0_3 = math.max

Fonts = {
	arial = {
		"materials/fonts/arial",
		14,
		"arial"
	},
	arial_masked = {
		"materials/fonts/arial",
		14,
		"arial",
		var_0_0.Masked
	},
	arial_write_mask = {
		"materials/fonts/arial",
		14,
		"arial",
		var_0_0.WriteMask
	},
	hell_shark_arial = {
		"materials/fonts/arial",
		14,
		"arial"
	},
	hell_shark_arial_masked = {
		"materials/fonts/arial",
		14,
		"arial",
		var_0_0.Masked
	},
	hell_shark_arial_write_mask = {
		"materials/fonts/arial",
		14,
		"arial",
		var_0_0.WriteMask
	},
	hell_shark = {
		"materials/fonts/gw_body",
		20,
		"gw_body"
	},
	hell_shark_masked = {
		"materials/fonts/gw_body",
		20,
		"gw_body",
		var_0_0.Masked
	},
	hell_shark_write_mask = {
		"materials/fonts/gw_body",
		20,
		"gw_body",
		var_0_0.WriteMask
	},
	hell_shark_header = {
		"materials/fonts/gw_head",
		20,
		"gw_head"
	},
	hell_shark_header_masked = {
		"materials/fonts/gw_head",
		20,
		"gw_head",
		var_0_0.Masked
	},
	hell_shark_header_write_mask = {
		"materials/fonts/gw_head",
		20,
		"gw_head",
		var_0_0.WriteMask
	},
	chat_output_font = {
		"materials/fonts/arial",
		14,
		"arial",
		var_0_0.MultiColor + var_0_0.ForceSuperSampling + var_0_0.FormatDirectives
	},
	chat_output_font_masked = {
		"materials/fonts/arial",
		14,
		"arial",
		var_0_0.MultiColor + var_0_0.ForceSuperSampling + var_0_0.FormatDirectives + var_0_0.Masked
	}
}

function UIFontByResolution(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.font_type
	local var_1_1 = arg_1_0.font_size
	local var_1_2 = RESOLUTION_LOOKUP.scale

	if arg_1_1 then
		var_1_2 = var_1_2 * arg_1_1
	end

	local var_1_3 = var_1_1 * var_1_2

	if not arg_1_0.allow_fractions then
		var_1_3 = var_0_1(var_1_3)
	end

	return Fonts[var_1_0], var_0_3(var_1_3, 1)
end

FontHeights = FontHeights or {}

function UISetupFontHeights(arg_2_0)
	local var_2_0 = FontHeights

	for iter_2_0, iter_2_1 in pairs(Fonts) do
		if var_2_0[iter_2_0] == nil then
			UIGetFontHeight(arg_2_0, iter_2_0, iter_2_1[2])
		end
	end
end

function UIGetFontHeight(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = FontHeights

	var_3_0[arg_3_1] = var_3_0[arg_3_1] or {}

	local var_3_1 = var_3_0[arg_3_1][arg_3_2]

	::label_3_0::

	if var_3_1 then
		local var_3_2 = RESOLUTION_LOOKUP.scale * var_0_2(arg_3_2 * 0.05, 1)
		local var_3_3 = 5 * var_3_2
		local var_3_4 = 4 * var_3_2

		return var_3_1[1] + (var_3_4 + var_3_3), var_3_1[2] - var_3_4, var_3_1[3] + var_3_3
	end

	local var_3_5 = Fonts[arg_3_1][1]
	local var_3_6, var_3_7 = var_0_0.text_extents(arg_3_0, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890", var_3_5, arg_3_2)
	local var_3_8, var_3_9 = var_0_0.text_extents(arg_3_0, "A", var_3_5, arg_3_2)

	var_3_1 = {
		var_3_9[2] - var_3_8[2],
		var_3_6[2],
		var_3_7[2]
	}
	var_3_0[arg_3_1][arg_3_2] = var_3_1

	goto label_3_0
end
