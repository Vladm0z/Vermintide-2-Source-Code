-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_wh_bountyhunter.lua

ActionCareerWHBountyhunter = class(ActionCareerWHBountyhunter, ActionBountyHunterHandgun)

ActionCareerWHBountyhunter.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerWHBountyhunter.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
end

ActionCareerWHBountyhunter.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	local var_2_0 = arg_2_0.talent_extension

	if var_2_0:has_talent("victor_bountyhunter_activated_ability_railgun") then
		arg_2_5.upper_barrel = "railgun"
		arg_2_5.lower_barrel = "railgun"
	elseif var_2_0:has_talent("victor_bountyhunter_activated_ability_blast_shotgun") then
		arg_2_5.upper_barrel = "shotgun"
		arg_2_5.lower_barrel = "shotgun"
	else
		arg_2_5.upper_barrel = "railgun"
		arg_2_5.lower_barrel = "shotgun"
	end

	arg_2_0.career_extension:reduce_activated_ability_cooldown_percent(-1)
	ActionCareerWHBountyhunter.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0:_play_vo()

	arg_2_0.start_activated_ability_cooldown_t = 0.1

	ScriptUnit.extension(arg_2_0.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

ActionCareerWHBountyhunter.client_owner_post_update = function (arg_3_0, arg_3_1, ...)
	if arg_3_0.start_activated_ability_cooldown_t then
		arg_3_0.start_activated_ability_cooldown_t = arg_3_0.start_activated_ability_cooldown_t - arg_3_1

		if arg_3_0.start_activated_ability_cooldown_t <= 0 then
			local var_3_0 = true

			arg_3_0.career_extension:start_activated_ability_cooldown(1, 0, 0, var_3_0)

			arg_3_0.start_activated_ability_cooldown_t = nil
		end
	end

	ActionCareerWHBountyhunter.super.client_owner_post_update(arg_3_0, arg_3_1, ...)
end

ActionCareerWHBountyhunter.finish = function (arg_4_0, arg_4_1)
	ActionCareerWHBountyhunter.super.finish(arg_4_0, arg_4_1)

	local var_4_0 = arg_4_0.talent_extension
	local var_4_1 = arg_4_0.inventory_extension

	if var_4_0:has_talent("victor_bountyhunter_activated_ability_reload", "witch_hunter", true) then
		local var_4_2 = "slot_ranged"
		local var_4_3 = var_4_1:get_slot_data(var_4_2)
		local var_4_4 = var_4_3.right_unit_1p
		local var_4_5 = var_4_3.left_unit_1p
		local var_4_6 = ScriptUnit.has_extension(var_4_4, "ammo_system")
		local var_4_7 = ScriptUnit.has_extension(var_4_5, "ammo_system")
		local var_4_8 = var_4_6 or var_4_7

		if var_4_8 then
			var_4_8:instant_reload(true)
		end
	end

	arg_4_0.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerWHBountyhunter._play_vo = function (arg_5_0)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = ScriptUnit.extension_input(var_5_0, "dialogue_system")
	local var_5_2 = FrameTable.alloc_table()

	var_5_1:trigger_networked_dialogue_event("activate_ability", var_5_2)
end
