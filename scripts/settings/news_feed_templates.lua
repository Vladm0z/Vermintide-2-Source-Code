-- chunkname: @scripts/settings/news_feed_templates.lua

NewsFeedTemplates = {
	{
		description = "news_feed_vt1_skins_description",
		name = "vt1_skins",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_vt1_skins_title",
		condition_func = function (arg_1_0)
			if ItemHelper.has_new_sign_in_reward("vt1_skins") then
				return true
			end
		end,
		removed_func = function (arg_2_0)
			ItemHelper.unmark_sign_in_reward_as_new("vt1_skins")
		end
	},
	{
		hidden = true,
		name = "vt2_collectors_edition",
		cooldown = -1,
		infinite = false,
		duration = 0,
		condition_func = function (arg_3_0)
			if ItemHelper.has_new_sign_in_reward("vt2_collectors_edition") then
				return true
			end
		end,
		removed_func = function (arg_4_0)
			ItemHelper.unmark_sign_in_reward_as_new("vt2_collectors_edition")
		end
	},
	{
		hidden = true,
		name = "celebrate_frame",
		cooldown = -1,
		infinite = false,
		duration = 0,
		condition_func = function (arg_5_0)
			if ItemHelper.has_new_sign_in_reward("celebrate_2019") then
				return true
			end
		end,
		removed_func = function (arg_6_0)
			ItemHelper.unmark_sign_in_reward_as_new("celebrate_2019")
		end
	},
	{
		description = "news_feed_unclaimed_challenge_description",
		name = "unclaimed_challenge",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_unclaimed_challenge_title",
		condition_func = function (arg_7_0)
			return (Managers.state.achievement:has_any_unclaimed_achievement())
		end
	},
	{
		description = "news_feed_unclaimed_quest_description",
		name = "unclaimed_quest",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_unclaimed_quest_title",
		condition_func = function (arg_8_0)
			return (Managers.state.quest:has_any_unclaimed_quests())
		end
	},
	{
		description = "news_feed_equipment_description",
		name = "equipment",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_equipment_title",
		condition_func = function (arg_9_0)
			if Managers.mechanism:current_mechanism_name() == "versus" then
				return false
			end

			local var_9_0 = arg_9_0.rarities_to_ignore

			if ItemHelper.has_new_backend_ids_by_slot_type("trinket", var_9_0) then
				return true
			elseif ItemHelper.has_new_backend_ids_by_slot_type("ring", var_9_0) then
				return true
			elseif ItemHelper.has_new_backend_ids_by_slot_type("necklace", var_9_0) then
				return true
			else
				local var_9_1 = arg_9_0.hero_name
				local var_9_2 = FindProfileIndex(var_9_1)
				local var_9_3 = SPProfiles[var_9_2].careers

				for iter_9_0, iter_9_1 in ipairs(var_9_3) do
					local var_9_4 = iter_9_1.name

					if ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(var_9_4, "melee", var_9_0) then
						return true
					elseif ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(var_9_4, "ranged", var_9_0) then
						return true
					end
				end
			end
		end
	},
	{
		description = "news_feed_store_description",
		name = "new_shop_items",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_store_title",
		icon = "hud_store_icon",
		icon_offset = {
			40,
			20,
			3
		},
		icon_size = {
			40,
			40
		},
		condition_func = function (arg_10_0)
			return Managers.backend:get_interface("peddler"):get_login_rewards().next_claim_timestamp < os.time()
		end
	},
	{
		description = "news_feed_talent_description",
		name = "talent",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_talent_title",
		condition_func = function (arg_11_0)
			local var_11_0 = arg_11_0.hero_name
			local var_11_1 = arg_11_0.career_name
			local var_11_2 = Managers.backend:get_interface("talents"):get_talents(var_11_1)
			local var_11_3 = 0

			if var_11_2 then
				for iter_11_0, iter_11_1 in ipairs(var_11_2) do
					if iter_11_1 > 0 then
						var_11_3 = var_11_3 + 1
					end
				end
			end

			local var_11_4 = ExperienceSettings.get_experience(var_11_0)
			local var_11_5 = ExperienceSettings.get_level(var_11_4)
			local var_11_6 = 0
			local var_11_7 = Development.parameter("debug_unlock_talents")

			for iter_11_2, iter_11_3 in pairs(TalentUnlockLevels) do
				if ProgressionUnlocks.is_unlocked(iter_11_2, var_11_5) or var_11_7 then
					var_11_6 = var_11_6 + 1
				end
			end

			return var_11_3 < var_11_6
		end
	},
	{
		description = "news_feed_career_description",
		name = "career",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_career_title",
		condition_func = function (arg_12_0)
			return false
		end
	},
	{
		description = "news_feed_cosmetics_description",
		name = "cosmetics",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_cosmetics_title",
		condition_func = function (arg_13_0)
			local var_13_0 = arg_13_0.career_name

			if ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(var_13_0, "skin") then
				return true
			elseif ItemHelper.has_new_backend_ids_by_slot_type("frame") then
				return true
			elseif ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(var_13_0, "hat") then
				return true
			end
		end
	},
	{
		description = "news_feed_loot_chest_description",
		name = "loot_chest",
		duration = 5,
		cooldown = -1,
		infinite = false,
		title = "news_feed_loot_chest_title",
		condition_func = function (arg_14_0)
			return ItemHelper.has_new_backend_ids_by_slot_type("loot_chest")
		end
	},
	{
		hidden = true,
		name = "sign_in_rewards",
		cooldown = -1,
		infinite = false,
		duration = 0,
		condition_func = function (arg_15_0)
			if ItemHelper.has_new_sign_in_reward() then
				return true
			end
		end,
		added_func = function (arg_16_0)
			local var_16_0 = Managers.state.event
			local var_16_1 = Managers.backend

			if var_16_0 and var_16_1 then
				local var_16_2 = var_16_1:get_interface("items")

				if var_16_2 then
					local var_16_3 = {}

					for iter_16_0, iter_16_1 in pairs(PlayerData.new_sign_in_rewards) do
						for iter_16_2, iter_16_3 in ipairs(iter_16_1) do
							if var_16_2:get_item_from_id(iter_16_3) ~= nil then
								table.insert(var_16_3, {
									type = "item",
									backend_id = iter_16_3
								})
							end
						end

						ItemHelper.unmark_sign_in_reward_as_new(iter_16_0)
					end

					if #var_16_3 > 0 then
						var_16_0:trigger("present_rewards", var_16_3)
					end
				end
			end
		end
	}
}

function FindNewsTemplateIndex(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(NewsFeedTemplates) do
		if iter_17_1.name == arg_17_0 then
			return iter_17_0
		end
	end
end
