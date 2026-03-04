-- chunkname: @scripts/settings/dlcs/belakor/belakor_ingame_challenge_settings.lua

local var_0_0 = DLCSettings.belakor
local var_0_1 = 1

var_0_0.ingame_challenge_templates = {}
var_0_0.challenge_categories = {
	"deus_mutator"
}
var_0_0.ingame_challenge_rewards = {
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
var_0_0.ingame_challenge_reward_types = {
	deus_power_up = function(arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

		if not var_1_0 then
			return
		end

		local var_1_1 = arg_1_0.granted_power_up_name
		local var_1_2 = arg_1_0.granted_power_up_rarity
		local var_1_3 = var_1_0:grant_party_power_up(var_1_1, var_1_2)
		local var_1_4 = Managers.player:human_players()
		local var_1_5 = Managers.state.entity:system("buff_system")
		local var_1_6 = Managers.backend:get_talents_interface()
		local var_1_7 = Managers.backend:get_interface("deus")

		for iter_1_0, iter_1_1 in pairs(var_1_4) do
			local var_1_8, var_1_9 = PlayerUtils.split_unique_player_id(arg_1_2)
			local var_1_10 = iter_1_1.player_unit
			local var_1_11, var_1_12 = var_1_0:get_player_profile(var_1_8, var_1_9)

			DeusPowerUpUtils.activate_deus_power_up(var_1_3, var_1_5, var_1_6, var_1_7, var_1_0, var_1_10, var_1_11, var_1_12)
		end

		return nil
	end
}
var_0_0.ingame_challenge_rewards_description = {
	deus_power_up_quest_test_reward_01 = "deus_power_up_quest_test_reward_01"
}
var_0_0.ingame_challenge_validation_functions = {
	deus_power_up = function(arg_2_0)
		fassert(arg_2_0.granted_power_up_name and arg_2_0.granted_power_up_rarity, "power_up challenges must set a power_up that is granting the challenge", arg_2_0.reward_id)
		fassert(DeusPowerUps[arg_2_0.granted_power_up_rarity], "reward power_up %s not valid: power_up rarity %s not found in power_ups list", arg_2_0.reward_id, arg_2_0.granted_power_up_rarity)
		fassert(DeusPowerUps[arg_2_0.granted_power_up_rarity][arg_2_0.granted_power_up_name], "reward power_up %s not valid: granted_power_up %s with rarity %s not found in power_ups list", arg_2_0.reward_id, arg_2_0.granted_power_up_name, arg_2_0.granted_power_up_rarity)
		fassert(not DeusPowerUps[arg_2_0.granted_power_up_rarity][arg_2_0.granted_power_up_name].talent, "reward power_up %s not valid: can't grant talent power_ups at the moment", arg_2_0.reward_id, arg_2_0.quest_power_up_rarity)

		return true
	end
}
