-- chunkname: @scripts/settings/dlcs/belakor/belakor_ingame_challenge_settings.lua

local belakor = DLCSettings.belakor
local num = 1

belakor.ingame_challenge_templates = {}
belakor.challenge_categories = {
	"deus_mutator"
}
belakor.ingame_challenge_rewards = {
	deus_power_up_quest_test_reward_01 = {
		reward_id = "deus_power_up_quest_test_reward_01",
		sound = "Play_hud_grail_knight_stamina",
		consume_value = 1,
		type = "deus_power_up",
		consume_type = "round",
		target = "owner",
		granted_power_up_name = "deus_power_up_quest_granted_test_01",
		granted_power_up_rarity = "exotic",
		icon = "icon_objective_cdr"
	}
}
belakor.ingame_challenge_reward_types = {
	deus_power_up = function (self, arg_1_1, arg_1_2)
		-- function 1
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

		if not get_deus_run_controller then
			return
		end

		local granted_power_up_name = self.granted_power_up_name
		local granted_power_up_rarity = self.granted_power_up_rarity
		local grant_party_power_up = get_deus_run_controller:grant_party_power_up(granted_power_up_name, granted_power_up_rarity)
		local human_players = Managers.player:human_players()
		local system = Managers.state.entity:system("buff_system")
		local get_talents_interface = Managers.backend:get_talents_interface()
		local get_interface = Managers.backend:get_interface("deus")

		for k, v in pairs(human_players) do
			local split_unique_player_id, var_1_9 = PlayerUtils.split_unique_player_id(arg_1_2)
			local player_unit = v.player_unit
			local get_player_profile, var_1_12 = get_deus_run_controller:get_player_profile(split_unique_player_id, var_1_9)

			DeusPowerUpUtils.activate_deus_power_up(grant_party_power_up, system, get_talents_interface, get_interface, get_deus_run_controller, player_unit, get_player_profile, var_1_12)
		end

		return nil
	end
}
belakor.ingame_challenge_rewards_description = {
	deus_power_up_quest_test_reward_01 = "deus_power_up_quest_test_reward_01"
}
belakor.ingame_challenge_validation_functions = {
	deus_power_up = function (self)
		-- function 2
		local fassert = fassert
		local granted_power_up_name = self.granted_power_up_name

		granted_power_up_name = not granted_power_up_name and self.granted_power_up_rarity

		fassert(granted_power_up_name, "power_up challenges must set a power_up that is granting the challenge", self.reward_id)
		fassert(DeusPowerUps[self.granted_power_up_rarity], "reward power_up %s not valid: power_up rarity %s not found in power_ups list", self.reward_id, self.granted_power_up_rarity)
		fassert(DeusPowerUps[self.granted_power_up_rarity][self.granted_power_up_name], "reward power_up %s not valid: granted_power_up %s with rarity %s not found in power_ups list", self.reward_id, self.granted_power_up_name, self.granted_power_up_rarity)
		fassert(not DeusPowerUps[self.granted_power_up_rarity][self.granted_power_up_name].talent, "reward power_up %s not valid: can't grant talent power_ups at the moment", self.reward_id, self.quest_power_up_rarity)

		return true
	end
}
