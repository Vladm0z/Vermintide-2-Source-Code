-- chunkname: @scripts/ui/ui_fonts.lua

local Gui = Gui
local floor = math.floor
local min = math.min
local max = math.max

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
		Gui.Masked
	},
	arial_write_mask = {
		"materials/fonts/arial",
		14,
		"arial",
		Gui.WriteMask
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
		Gui.Masked
	},
	hell_shark_arial_write_mask = {
		"materials/fonts/arial",
		14,
		"arial",
		Gui.WriteMask
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
		Gui.Masked
	},
	hell_shark_write_mask = {
		"materials/fonts/gw_body",
		20,
		"gw_body",
		Gui.WriteMask
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
		Gui.Masked
	},
	hell_shark_header_write_mask = {
		"materials/fonts/gw_head",
		20,
		"gw_head",
		Gui.WriteMask
	},
	chat_output_font = {
		"materials/fonts/arial",
		14,
		"arial",
		Gui.MultiColor + Gui.ForceSuperSampling + Gui.FormatDirectives
	},
	chat_output_font_masked = {
		"materials/fonts/arial",
		14,
		"arial",
		Gui.MultiColor + Gui.ForceSuperSampling + Gui.FormatDirectives + Gui.Masked
	}
}

function UIFontByResolution(self, arg_1_1)
	-- function 1
	local font_type = self.font_type
	local font_size = self.font_size
	local scale = RESOLUTION_LOOKUP.scale

	if not arg_1_1 then
		scale = scale * arg_1_1
	end

	local num = font_size * scale

	if not self.allow_fractions then
		num = floor(num)
	end

	return Fonts[font_type], max(num, 1)
end

local FontHeights = FontHeights

FontHeights = FontHeights or {}
FontHeights = FontHeights

function UISetupFontHeights(arg_2_0)
	-- function 2
	local FontHeights = FontHeights

	for k, v in pairs(Fonts) do
		if FontHeights[k] == nil then
			UIGetFontHeight(arg_2_0, k, v[2])
		end
	end
end

function UIGetFontHeight(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local FontHeights = FontHeights
	local var_3_1 = FontHeights[arg_3_1]

	var_3_1 = var_3_1 or {}
	FontHeights[arg_3_1] = var_3_1

	local var_3_2 = FontHeights[arg_3_1][arg_3_2]

	::label_3_0::

	if not var_3_2 then
		local num = RESOLUTION_LOOKUP.scale * min(arg_3_2 * 0.05, 1)
		local num_2 = 5 * num
		local num_3 = 4 * num

		return var_3_2[1] + (num_3 + num_2), var_3_2[2] - num_3, var_3_2[3] + num_2
	end

	local var_3_6 = Fonts[arg_3_1][1]
	local text_extents, var_3_8 = Gui.text_extents(arg_3_0, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890", var_3_6, arg_3_2)
	local text_extents_2, var_3_10 = Gui.text_extents(arg_3_0, "A", var_3_6, arg_3_2)

	var_3_2 = {
		var_3_10[2] - text_extents_2[2],
		text_extents[2],
		var_3_8[2]
	}
	FontHeights[arg_3_1][arg_3_2] = var_3_2

	goto label_3_0
end
