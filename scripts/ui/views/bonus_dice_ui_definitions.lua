-- chunkname: @scripts/ui/views/bonus_dice_ui_definitions.lua

local tbl = {
	42,
	42
}
local num = 5
local tbl_2 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			1920,
			1080
		}
	},
	bonus_dice_background = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			42,
			-42,
			1
		},
		size = {
			tbl[1],
			tbl[2]
		}
	}
}
local tbl_3 = {
	scenegraph_id = "bonus_dice_background",
	element = UIElements.SimpleTexture,
	content = {
		texture_id = "dice_01"
	},
	style = {
		offset = {
			0,
			0,
			0
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
}
local tbl_4 = {
	weighted = "dice_01",
	golden = "dice_01",
	normal = "dice_01"
}

local function fn(arg_1_0)
	-- function 1
	local var_1_0 = tbl_4[arg_1_0]

	var_1_0 = var_1_0 or "dice_01"

	return var_1_0
end

return {
	gap = 10,
	scenegraph_definition = tbl_2,
	dice_widget_definition = tbl_3,
	dice_size = table.clone(tbl),
	num_dice_columns = num,
	get_die_texture = fn
}
