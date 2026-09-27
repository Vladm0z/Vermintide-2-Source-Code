-- chunkname: @scripts/settings/player_data.lua

require("scripts/settings/profiles/sp_profiles")

DefaultPlayerData = {
	controls_version = 18,
	new_item_data_version = 6,
	mission_selection_version = 3,
	new_keep_decoration_version = 1,
	seen_shop_items_version = 1,
	viewed_dialogues_version = 1,
	level_preferences_version = 1,
	bot_spawn_priority_version = 2,
	new_sign_in_rewards_data_version = 2,
	favorite_item_data_version = 1,
	mission_selection = {
		adventure = {
			difficulty_key = "normal"
		},
		custom = {
			area_name = "helmgart",
			difficulty_key = "normal",
			level_id = "military"
		}
	},
	favorite_item_ids = {},
	favorite_item_ids_by_career = {},
	new_item_ids = {},
	new_item_ids_by_career = {},
	new_sign_in_rewards = {},
	controls = {},
	recent_irc_channels = {},
	bot_spawn_priority = table.clone(ProfilePriority),
	viewed_dialogues = {},
	new_keep_decoration_ids = {},
	level_preferences = {
		{},
		{}
	},
	seen_shop_items = {}
}

local PlayerData = PlayerData

PlayerData = PlayerData or table.clone(DefaultPlayerData)
PlayerData = PlayerData

function populate_player_data_from_save(self, arg_1_1, arg_1_2)
	-- function 1
	if not self.player_data then
		self.player_data = {}
	end

	if not self.player_data[arg_1_1] then
		local clone = table.clone(DefaultPlayerData)

		if not self.controls then
			clone.controls = self.controls
			self.controls = nil
		end

		if not self.new_item_ids then
			clone.new_item_ids = self.new_item_ids
			self.new_item_ids = nil
		end

		if not self.recent_irc_channels then
			clone.recent_irc_channels = self.recent_irc_channels
			self.recent_irc_channels = nil
		end

		self.player_data[arg_1_1] = clone
	end

	local var_1_1 = self.player_data[arg_1_1]

	if not arg_1_2 then
		if DefaultPlayerData.mission_selection_version ~= var_1_1.mission_selection_version then
			var_1_1.mission_selection = {}

			print("Wrong mission_selection_version for save file, saved: ", var_1_1.mission_selection_version, " current: ", DefaultPlayerData.mission_selection_version)

			var_1_1.mission_selection_version = DefaultPlayerData.mission_selection_version
		end

		if DefaultPlayerData.controls_version ~= var_1_1.controls_version then
			var_1_1.controls = {}

			print("Wrong controls_version for save file, saved: ", var_1_1.controls_version, " current: ", DefaultPlayerData.controls_version)

			var_1_1.controls_version = DefaultPlayerData.controls_version
		end

		if DefaultPlayerData.new_keep_decoration_version ~= var_1_1.new_keep_decoration_version then
			print("Wrong new_keep_decoration_version for save file, saved: ", var_1_1.new_keep_decoration_version, " current: ", DefaultPlayerData.new_keep_decoration_version)

			var_1_1.new_keep_decoration_ids = {}
			var_1_1.new_keep_decoration_version = DefaultPlayerData.new_keep_decoration_version
		end

		if DefaultPlayerData.favorite_item_data_version ~= var_1_1.favorite_item_data_version then
			print("Wrong favorite_item_data_version for save file, saved: ", var_1_1.favorite_item_data_version, " current: ", DefaultPlayerData.favorite_item_data_version)

			var_1_1.favorite_item_ids = {}
			var_1_1.favorite_item_ids_by_career = {}
			var_1_1.favorite_item_data_version = DefaultPlayerData.favorite_item_data_version
		end

		if DefaultPlayerData.new_item_data_version ~= var_1_1.new_item_data_version then
			print("Wrong new_item_data_version for save file, saved: ", var_1_1.new_item_data_version, " current: ", DefaultPlayerData.new_item_data_version)

			var_1_1.new_item_ids = {}
			var_1_1.new_item_ids_by_career = {}
			var_1_1.new_item_data_version = DefaultPlayerData.new_item_data_version
		end

		if DefaultPlayerData.new_sign_in_rewards_data_version ~= var_1_1.new_sign_in_rewards_data_version then
			print("Wrong new_sign_in_rewards_data_version for save file, saved: ", var_1_1.new_sign_in_rewards_data_version, " current: ", DefaultPlayerData.new_sign_in_rewards_data_version)

			var_1_1.new_sign_in_rewards = {}
			var_1_1.new_sign_in_rewards_data_version = DefaultPlayerData.new_sign_in_rewards_data_version
		end

		if DefaultPlayerData.bot_spawn_priority_version ~= var_1_1.bot_spawn_priority_version then
			var_1_1.bot_spawn_priority = table.clone(ProfilePriority)

			print("Wrong bot_spawn_priority_version for save file, saved: ", var_1_1.bot_spawn_priority_version, " current: ", DefaultPlayerData.bot_spawn_priority_version)

			var_1_1.bot_spawn_priority_version = DefaultPlayerData.bot_spawn_priority_version
		end

		if DefaultPlayerData.viewed_dialogues_version ~= var_1_1.viewed_dialogues_version then
			var_1_1.viewed_dialogues = {}

			print("Wrong viewed_dialogues_version for save file, saved: ", var_1_1.viewed_dialogues_version, " current: ", DefaultPlayerData.viewed_dialogues_version)

			var_1_1.viewed_dialogues_version = DefaultPlayerData.viewed_dialogues_version
		end

		if DefaultPlayerData.level_preferences_version ~= var_1_1.level_preferences_version then
			var_1_1.level_preferences = {
				{},
				{}
			}

			print("Wrong level_preferences_version for save file, saved: ", tostring(var_1_1.level_preferences_version), " current: ", DefaultPlayerData.level_preferences_version)

			var_1_1.level_preferences_version = DefaultPlayerData.level_preferences_version
		end

		if DefaultPlayerData.seen_shop_items_version ~= var_1_1.seen_shop_items_version then
			var_1_1.seen_shop_items = {}

			print("Wrong seen_shop_items_version for save file, saved: ", var_1_1.seen_shop_items_version, " current: ", DefaultPlayerData.seen_shop_items_version)

			var_1_1.seen_shop_items_version = DefaultPlayerData.seen_shop_items_version
		end
	end

	PlayerData = var_1_1

	local input = Managers.input

	if not input then
		input:apply_saved_keymaps()
	end
end
