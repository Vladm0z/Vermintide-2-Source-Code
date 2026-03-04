-- chunkname: @scripts/settings/dlcs/morris/twitch_vote_templates_morris.lua

local function var_0_0(arg_1_0, ...)
	if DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

local var_0_1 = {
	cost = 0,
	use_frame_texture = true,
	texture_id = "level_image_any",
	text = "twitch_vote_next_deus_level",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return Managers.state.game_mode:game_mode_key() == "map_deus"
	end,
	on_success = function(arg_3_0, arg_3_1, arg_3_2)
		if arg_3_0 then
			local var_3_0 = arg_3_2.level_name

			var_0_0("Level %s was selected", var_3_0)

			local var_3_1 = Managers.mechanism:game_mechanism():get_deus_run_controller()
			local var_3_2 = var_3_1:get_graph_data()
			local var_3_3 = var_3_1:get_current_node().next

			for iter_3_0, iter_3_1 in ipairs(var_3_3) do
				if var_3_2[iter_3_1].base_level == var_3_0 then
					var_3_1:set_twitch_level_vote(iter_3_1)

					return
				end
			end

			assert(false, "Couldn't find level that was voted on by twitch")
		end
	end
}

TwitchVoteDeusSelectLevelNames = TwitchVoteDeusSelectLevelNames or {}

for iter_0_0, iter_0_1 in pairs(DEUS_LEVEL_SETTINGS) do
	local var_0_2 = iter_0_1.base_level_name
	local var_0_3 = table.clone(var_0_1)

	var_0_3.text = iter_0_1.display_name
	var_0_3.level_name = var_0_2

	local var_0_4 = iter_0_1.texture_id

	if var_0_4 then
		var_0_3.texture_id = var_0_4
	end

	local var_0_5 = "twitch_vote_deus_select_level_" .. var_0_2

	TwitchVoteTemplates[var_0_5] = var_0_3
	TwitchVoteDeusSelectLevelNames[var_0_2] = var_0_5
end

for iter_0_2, iter_0_3 in pairs(DeusShopSettings.shop_types) do
	local var_0_6 = table.clone(var_0_1)

	var_0_6.text = iter_0_2 .. "_title"
	var_0_6.level_name = iter_0_2

	local var_0_7 = iter_0_3.twitch_icon

	if var_0_7 then
		var_0_6.texture_id = var_0_7
	end

	local var_0_8 = "twitch_vote_deus_select_level_" .. iter_0_2

	TwitchVoteTemplates[var_0_8] = var_0_6
	TwitchVoteDeusSelectLevelNames[iter_0_2] = var_0_8
end
