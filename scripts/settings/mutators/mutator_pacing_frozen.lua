-- chunkname: @scripts/settings/mutators/mutator_pacing_frozen.lua

return {
	hide_from_player_ui = true,
	server_start_function = function (arg_1_0, arg_1_1)
		local var_1_0 = Managers.state.conflict

		if var_1_0.pacing:get_state() ~= "pacing_frozen" then
			var_1_0.pacing:disable()

			arg_1_1.disabled = true
		end
	end,
	server_stop_function = function (arg_2_0, arg_2_1)
		if arg_2_1.disabled then
			local var_2_0 = Managers.state.conflict

			if var_2_0 then
				var_2_0.pacing:enable()
			end
		end
	end
}
