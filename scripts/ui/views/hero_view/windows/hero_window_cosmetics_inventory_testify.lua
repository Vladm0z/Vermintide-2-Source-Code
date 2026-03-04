-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_inventory_testify.lua

return {
	get_hero_window_cosmetics_inventory_item_grid = function (arg_1_0)
		return arg_1_0._item_grid
	end,
	set_slot_hotspot_on_right_click = function (arg_2_0, arg_2_1)
		arg_2_0._item_grid._widget.content[arg_2_1.hotspot_name].on_right_click = arg_2_1.value
	end,
	wait_for_cosmetics_inventory_window = function ()
		return
	end
}
