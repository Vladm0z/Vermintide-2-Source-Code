-- chunkname: @scripts/ui/views/bonus_dice_ui_definitions.lua

local var_0_0 = {
	42,
	42
}
local var_0_1 = 5
local var_0_2 = {
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
			var_0_0[1],
			var_0_0[2]
		}
	}
}
local var_0_3 = {
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
local var_0_4 = {
	weighted = "dice_01",
	golden = "dice_01",
	normal = "dice_01"
}

local function var_0_5(arg_1_0)
	return var_0_4[arg_1_0] or "dice_01"
end

return {
	gap = 10,
	scenegraph_definition = var_0_2,
	dice_widget_definition = var_0_3,
	dice_size = table.clone(var_0_0),
	num_dice_columns = var_0_1,
	get_die_texture = var_0_5
}
