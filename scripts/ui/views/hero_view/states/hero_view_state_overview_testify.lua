-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_overview_testify.lua

local HeroViewStateOverviewTestify = {
	close_hero_view = function (hero_view_state_overview)
		-- function 1
		hero_view_state_overview:close_menu()
	end,
	set_hero_window_layout = function (hero_view_state_overview, index)
		-- function 2
		hero_view_state_overview:set_layout(index)
	end,
	wait_for_hero_view = function ()
		-- function 3
		return
	end
}

return HeroViewStateOverviewTestify
