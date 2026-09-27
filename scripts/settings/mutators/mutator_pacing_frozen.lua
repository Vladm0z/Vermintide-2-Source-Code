-- chunkname: @scripts/settings/mutators/mutator_pacing_frozen.lua

return {
	hide_from_player_ui = true,
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		local conflict = Managers.state.conflict

		if conflict.pacing:get_state() ~= "pacing_frozen" then
			conflict.pacing:disable()

			arg_1_1.disabled = true
		end
	end,
	server_stop_function = function (arg_2_0, arg_2_1)
		-- function 2
		if not arg_2_1.disabled then
			local conflict = Managers.state.conflict

			if not conflict then
				conflict.pacing:enable()
			end
		end
	end
}
