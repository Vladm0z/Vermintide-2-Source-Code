-- chunkname: @scripts/settings/dlcs/morris/twitch_vote_templates_morris.lua

local function fn(arg_1_0, ...)
	-- function 1
	if not DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

local tbl = {
	cost = 0,
	use_frame_texture = true,
	texture_id = "level_image_any",
	text = "twitch_vote_next_deus_level",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 2
		return Managers.state.game_mode:game_mode_key() == "map_deus"
	end,
	on_success = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		if not arg_3_0 then
			local level_name = arg_3_2.level_name

			fn("Level %s was selected", level_name)

			local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
			local get_graph_data = get_deus_run_controller:get_graph_data()
			local next = get_deus_run_controller:get_current_node().next

			for i, v in ipairs(next) do
				if get_graph_data[v].base_level == level_name then
					get_deus_run_controller:set_twitch_level_vote(v)

					return
				end
			end

			assert(false, "Couldn't find level that was voted on by twitch")
		end
	end
}
local TwitchVoteDeusSelectLevelNames = TwitchVoteDeusSelectLevelNames

TwitchVoteDeusSelectLevelNames = TwitchVoteDeusSelectLevelNames or {}
TwitchVoteDeusSelectLevelNames = TwitchVoteDeusSelectLevelNames

for k, v in pairs(DEUS_LEVEL_SETTINGS) do
	local base_level_name = v.base_level_name
	local clone = table.clone(tbl)

	clone.text = v.display_name
	clone.level_name = base_level_name

	local texture_id = v.texture_id

	if not texture_id then
		clone.texture_id = texture_id
	end

	local str = "twitch_vote_deus_select_level_" .. base_level_name

	TwitchVoteTemplates[str] = clone
	TwitchVoteDeusSelectLevelNames[base_level_name] = str
end

for k_2, v_2 in pairs(DeusShopSettings.shop_types) do
	local clone_2 = table.clone(tbl)

	clone_2.text = k_2 .. "_title"
	clone_2.level_name = k_2

	local twitch_icon = v_2.twitch_icon

	if not twitch_icon then
		clone_2.texture_id = twitch_icon
	end

	local str_2 = "twitch_vote_deus_select_level_" .. k_2

	TwitchVoteTemplates[str_2] = clone_2
	TwitchVoteDeusSelectLevelNames[k_2] = str_2
end
