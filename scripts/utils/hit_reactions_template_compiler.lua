-- chunkname: @scripts/utils/hit_reactions_template_compiler.lua

require("scripts/managers/status_effect/status_effect_templates")
dofile("scripts/settings/hit_effects/hit_effects_skaven_clan_rat")
dofile("scripts/settings/hit_effects/hit_effects_skaven_slave")
dofile("scripts/settings/hit_effects/hit_effects_skaven_clan_rat_shield")
dofile("scripts/settings/hit_effects/hit_effects_skaven_plague_monk")
dofile("scripts/settings/hit_effects/hit_effects_storm_vermin")
dofile("scripts/settings/hit_effects/hit_effects_storm_vermin_champion")
dofile("scripts/settings/hit_effects/hit_effects_gutter_runner")
dofile("scripts/settings/hit_effects/hit_effects_rat_ogre")
dofile("scripts/settings/hit_effects/hit_effects_stormfiend")
dofile("scripts/settings/hit_effects/hit_effects_grey_seer")
dofile("scripts/settings/hit_effects/hit_effects_grey_seer_mounted")
dofile("scripts/settings/hit_effects/hit_effects_poison_wind")
dofile("scripts/settings/hit_effects/hit_effects_ratling_gunner")
dofile("scripts/settings/hit_effects/hit_effects_critter_pig")
dofile("scripts/settings/hit_effects/hit_effects_critter_rat")
dofile("scripts/settings/hit_effects/hit_effects_chaos_troll")
dofile("scripts/settings/hit_effects/hit_effects_skaven_pack_master")
dofile("scripts/settings/hit_effects/hit_effects_skaven_loot_rat")
dofile("scripts/settings/hit_effects/hit_effects_chaos_marauder")
dofile("scripts/settings/hit_effects/hit_effects_chaos_berzerker")
dofile("scripts/settings/hit_effects/hit_effects_chaos_raider")
dofile("scripts/settings/hit_effects/hit_effects_chaos_marauder_shield")
dofile("scripts/settings/hit_effects/hit_effects_chaos_warrior")
dofile("scripts/settings/hit_effects/hit_effects_chaos_bulwark")
dofile("scripts/settings/hit_effects/hit_effects_chaos_exalted_champion")
dofile("scripts/settings/hit_effects/hit_effects_dummy_sorcerer")
dofile("scripts/settings/hit_effects/hit_effects_chaos_sorcerer")
dofile("scripts/settings/hit_effects/hit_effects_chaos_exalted_sorcerer")
dofile("scripts/settings/hit_effects/hit_effects_chaos_zombie")
dofile("scripts/settings/hit_effects/hit_effects_chaos_spawn")
dofile("scripts/settings/hit_effects/hit_effects_undead_ethereal_skeleton")
dofile("scripts/settings/hit_effects/hit_effects_training_dummy")
dofile("scripts/settings/breeds")
DLCUtils.dofile_list("hit_effects")

Dismemberments = {}
HitTemplates = {}
SoundEvents = {}
DismemberFlowEvents = {
	explode_head = true
}
AdditionalHitReactions = {
	"HitEffectsSkavenGreySeerMounted"
}

local function var_0_0(arg_1_0, arg_1_1)
	if not arg_1_1 then
		return
	end

	local var_1_0 = {}

	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		local var_1_1 = "dismember_" .. iter_1_0

		var_1_0[iter_1_0] = var_1_1
		DismemberFlowEvents[var_1_1] = true
	end

	Dismemberments[arg_1_0] = var_1_0
end

local function var_0_1(arg_2_0)
	if not SoundEvents[arg_2_0] then
		local var_2_0 = {
			["false"] = arg_2_0,
			["true"] = arg_2_0 .. "_husk"
		}

		SoundEvents[arg_2_0] = var_2_0
	end
end

local function var_0_2(arg_3_0, arg_3_1)
	local var_3_0 = ""

	for iter_3_0 = 1, #arg_3_0 do
		var_3_0 = var_3_0 .. sprintf("\t%q inherits from %q\n", arg_3_0[iter_3_0], arg_3_0[iter_3_0 + 1] or arg_3_1)
	end

	return var_3_0
end

local function var_0_3(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {}

	if arg_4_0.inherits then
		local var_4_1 = arg_4_0.inherits
		local var_4_2 = arg_4_1[var_4_1]

		assert(var_4_2, sprintf("Couldn't inherit from template %q; Template does not exist.", arg_4_0.inherits))
		assert(table.contains(arg_4_2, var_4_1) == false, sprintf("Cyclic inheritence in %q:\n%s", arg_4_2[1], var_0_2(arg_4_2, var_4_1)))

		arg_4_2[#arg_4_2 + 1] = var_4_1
		var_4_0 = var_0_3(var_4_2, arg_4_1, arg_4_2)
	end

	local var_4_3 = var_4_0.conditions or {}
	local var_4_4 = var_4_0.num_conditions or 0

	for iter_4_0, iter_4_1 in pairs(arg_4_0) do
		var_4_0[iter_4_0] = iter_4_1
	end

	if arg_4_0.extra_conditions then
		for iter_4_2, iter_4_3 in pairs(arg_4_0.extra_conditions) do
			if not var_4_3[iter_4_2] then
				var_4_4 = var_4_4 + 1
			end

			var_4_3[iter_4_2] = iter_4_3
		end

		var_4_0.extra_conditions = nil
	end

	var_4_0.conditions = var_4_3
	var_4_0.num_conditions = var_4_4

	return var_4_0
end

local function var_0_4(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.num_conditions

	for iter_5_0 = #arg_5_0 + 1, 1, -1 do
		if iter_5_0 == 1 or var_5_0 <= arg_5_0[iter_5_0 - 1].num_conditions then
			arg_5_0[iter_5_0] = arg_5_1

			break
		else
			arg_5_0[iter_5_0] = arg_5_0[iter_5_0 - 1]
		end
	end
end

local function var_0_5(arg_6_0)
	if not arg_6_0 or HitTemplates[arg_6_0] then
		return
	end

	local var_6_0 = {}
	local var_6_1 = rawget(_G, arg_6_0)

	for iter_6_0, iter_6_1 in pairs(var_6_1) do
		local var_6_2 = var_0_3(iter_6_1, var_6_1, {
			iter_6_0
		})

		var_6_2.template_name = iter_6_0

		var_0_4(var_6_0, var_6_2)

		if iter_6_1.sound_event then
			local var_6_3 = iter_6_1.sound_event

			if type(var_6_3) == "string" then
				var_0_1(var_6_3)
			else
				local var_6_4 = #var_6_3

				for iter_6_2 = 1, var_6_4 do
					var_0_1(var_6_3[iter_6_2])
				end
			end
		end
	end

	HitTemplates[arg_6_0] = var_6_0
end

;(function()
	for iter_7_0, iter_7_1 in pairs(Breeds) do
		var_0_0(iter_7_0, iter_7_1.hit_zones)
		var_0_5(iter_7_1.hit_effect_template)
	end

	for iter_7_2, iter_7_3 in pairs(PlayerBreeds) do
		var_0_0(iter_7_2, iter_7_3.hit_zones)
	end

	for iter_7_4, iter_7_5 in pairs(AdditionalHitReactions) do
		var_0_5(iter_7_5)
	end
end)()
