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
			-- function 1
			if not ItemHelper.has_new_sign_in_reward("vt1_skins") then
				return true
			end
		end,
		removed_func = function (arg_2_0)
			-- function 2
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
			-- function 3
			if not ItemHelper.has_new_sign_in_reward("vt2_collectors_edition") then
				return true
			end
		end,
		removed_func = function (arg_4_0)
			-- function 4
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
			-- function 5
			if not ItemHelper.has_new_sign_in_reward("celebrate_2019") then
				return true
			end
		end,
		removed_func = function (arg_6_0)
			-- function 6
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
			-- function 7
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
			-- function 8
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
		condition_func = function (self)
			-- function 9
			if Managers.mechanism:current_mechanism_name() == "versus" then
				return false
			end

			local rarities_to_ignore = self.rarities_to_ignore

			if not ItemHelper.has_new_backend_ids_by_slot_type("trinket", rarities_to_ignore) then
				return true
			elseif not ItemHelper.has_new_backend_ids_by_slot_type("ring", rarities_to_ignore) then
				return true
			elseif not ItemHelper.has_new_backend_ids_by_slot_type("necklace", rarities_to_ignore) then
				return true
			else
				local hero_name = self.hero_name
				local var_9_2 = FindProfileIndex(hero_name)
				local careers = SPProfiles[var_9_2].careers

				for i, v in ipairs(careers) do
					local name = v.name

					if not ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(name, "melee", rarities_to_ignore) then
						return true
					elseif not ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(name, "ranged", rarities_to_ignore) then
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
			-- function 10
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
		condition_func = function (self)
			-- function 11
			local hero_name = self.hero_name
			local career_name = self.career_name
			local get_talents = Managers.backend:get_interface("talents"):get_talents(career_name)
			local num = 0

			if not get_talents then
				for i, v in ipairs(get_talents) do
					if v > 0 then
						num = num + 1
					end
				end
			end

			local get_experience = ExperienceSettings.get_experience(hero_name)
			local get_level = ExperienceSettings.get_level(get_experience)
			local num_2 = 0
			local parameter = Development.parameter("debug_unlock_talents")

			for k, v_2 in pairs(TalentUnlockLevels) do
				if ProgressionUnlocks.is_unlocked(k, get_level) or not parameter then
					num_2 = num_2 + 1
				end
			end

			return num < num_2
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
			-- function 12
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
		condition_func = function (self)
			-- function 13
			local career_name = self.career_name

			if not ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(career_name, "skin") then
				return true
			elseif not ItemHelper.has_new_backend_ids_by_slot_type("frame") then
				return true
			elseif not ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(career_name, "hat") then
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
			-- function 14
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
			-- function 15
			if not ItemHelper.has_new_sign_in_reward() then
				return true
			end
		end,
		added_func = function (arg_16_0)
			-- function 16
			local event = Managers.state.event
			local backend = Managers.backend

			if not event and not backend then
				local get_interface = backend:get_interface("items")

				if not get_interface then
					local tbl = {}

					for k, v in pairs(PlayerData.new_sign_in_rewards) do
						for i, v_2 in ipairs(v) do
							if get_interface:get_item_from_id(v_2) ~= nil then
								table.insert(tbl, {
									type = "item",
									backend_id = v_2
								})
							end
						end

						ItemHelper.unmark_sign_in_reward_as_new(k)
					end

					if #tbl > 0 then
						event:trigger("present_rewards", tbl)
					end
				end
			end
		end
	}
}

function FindNewsTemplateIndex(arg_17_0)
	-- function 17
	for k, v in pairs(NewsFeedTemplates) do
		if v.name == arg_17_0 then
			return k
		end
	end
end
