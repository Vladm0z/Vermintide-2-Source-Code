-- chunkname: @scripts/ui/views/level_end/states/end_view_state_summary_deus.lua

require("scripts/ui/views/level_end/states/end_view_state_summary")

EndViewStateSummaryDeus = class(EndViewStateSummaryDeus, EndViewStateSummary)
EndViewStateSummaryDeus.NAME = "EndViewStateSummaryDeus"

EndViewStateSummaryDeus.on_enter = function (arg_1_0, arg_1_1)
	arg_1_0.super.on_enter(arg_1_0, arg_1_1)

	arg_1_0._widgets_by_name.summary_title.content.text = Localize("expedition_summary")

	if arg_1_0.game_won then
		arg_1_0._widgets_by_name.deus_progress_reset_text.content.visible = false
	end

	local var_1_0 = Managers.backend:get_interface("deus"):get_rolled_over_soft_currency() or 0

	arg_1_0._widgets_by_name.coins_retained_total_text.content.coin_count_text = string.format("%d", var_1_0)
end

EndViewStateSummaryDeus._get_definitions = function (arg_2_0)
	return local_require("scripts/ui/views/level_end/states/definitions/end_view_state_summary_deus_definitions")
end
