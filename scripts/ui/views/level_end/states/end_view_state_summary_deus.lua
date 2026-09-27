-- chunkname: @scripts/ui/views/level_end/states/end_view_state_summary_deus.lua

require("scripts/ui/views/level_end/states/end_view_state_summary")

EndViewStateSummaryDeus = class(EndViewStateSummaryDeus, EndViewStateSummary)
EndViewStateSummaryDeus.NAME = "EndViewStateSummaryDeus"

EndViewStateSummaryDeus.on_enter = function (self, arg_1_1)
	-- function 1
	self.super.on_enter(self, arg_1_1)

	self._widgets_by_name.summary_title.content.text = Localize("expedition_summary")

	if not self.game_won then
		self._widgets_by_name.deus_progress_reset_text.content.visible = false
	end

	local get_rolled_over_soft_currency = Managers.backend:get_interface("deus"):get_rolled_over_soft_currency()

	get_rolled_over_soft_currency = get_rolled_over_soft_currency or 0
	self._widgets_by_name.coins_retained_total_text.content.coin_count_text = string.format("%d", get_rolled_over_soft_currency)
end

EndViewStateSummaryDeus._get_definitions = function (arg_2_0)
	-- function 2
	return local_require("scripts/ui/views/level_end/states/definitions/end_view_state_summary_deus_definitions")
end
