-- chunkname: @scripts/unit_extensions/health/beastmen_standard_health_extension.lua

BeastmenStandardHealthExtension = class(BeastmenStandardHealthExtension, GenericHealthExtension)

BeastmenStandardHealthExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	BeastmenStandardHealthExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._unit = arg_1_2
end

BeastmenStandardHealthExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	return
end

BeastmenStandardHealthExtension.destroy = function (self)
	-- function 3
	BeastmenStandardHealthExtension.super.destroy(self)

	self.blackboard = nil
end

BeastmenStandardHealthExtension.apply_client_predicted_damage = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

local tbl = {
	grenade_frag_02 = true,
	torch = true,
	grenade_fire_01 = true,
	grenade_fire_02 = true,
	wpn_deus_relic_01 = true,
	grenade_frag_01 = true,
	explosive_barrel = true,
	markus_questingknight_career_skill_weapon = true,
	dr_deus_01 = true,
	shadow_torch = true
}

BeastmenStandardHealthExtension.add_damage = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	-- function 5
	if arg_5_7 == "suicide" then
		BeastmenStandardHealthExtension.super.add_damage(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	else
		local flag = false

		if not (not arg_5_15 and arg_5_15 == "heavy_attack" and arg_5_15 == "light_attack" or tbl[arg_5_7]) then
			BeastmenStandardHealthExtension.super.add_damage(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)

			local has_extension = ScriptUnit.has_extension(self._unit, "ai_supplementary_system")
			local standard_template = has_extension.standard_template

			if not standard_template then
				local sfx_taking_damage = standard_template.sfx_taking_damage

				WwiseUtils.trigger_unit_event(has_extension.world, sfx_taking_damage, self._unit, 0)
			end
		end
	end
end
