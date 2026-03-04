-- chunkname: @scripts/settings/breeds/breed_shadow_totem.lua

require("scripts/settings/dlcs/belakor/belakor_balancing")

local var_0_0 = {
	immediate_threat = true,
	height = 2.6,
	no_blood_splatter_on_damage = true,
	unit_template = "belakor_totem",
	flesh_material = "stone",
	poison_resistance = 100,
	ignore_activate_unit = true,
	race = "chaos",
	exchange_order = 1,
	animation_sync_rpc = "rpc_sync_anim_state_1",
	perception = "perception_no_seeing",
	debug_despawn_immunity = false,
	debug_spawn_category = "Misc",
	bot_melee_aim_node = "j_spine1",
	target_head_node = "c_blk_totem_01",
	far_off_despawn_immunity = true,
	override_bot_target_node = "j_spine1",
	behavior = "shadow_totem",
	base_unit = "units/props/blk/blk_totem_01",
	threat_value = 10,
	hit_effect_template = "HitEffectsShadowTotem",
	max_health = BelakorBalancing.totem_health,
	infighting = InfightingSettings.small,
	debug_color = {
		255,
		255,
		255,
		255
	},
	hit_zones = {
		full = {
			prio = 1,
			actors = {
				"enemy_hit_box"
			}
		}
	},
	modify_extension_init_data = function(arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = arg_1_2.death_system or {}

		var_1_0.death_reaction_template = "ai_default"
		var_1_0.is_husk = arg_1_1
		arg_1_2.death_system = var_1_0

		local var_1_1 = arg_1_2.hit_reaction_system or {}

		var_1_1.hit_reaction_template = "level_object"
		var_1_1.is_husk = arg_1_1
		arg_1_2.hit_reaction_system = var_1_1

		local var_1_2 = arg_1_2.ping_system or {}

		var_1_2.always_pingable = true
		arg_1_2.ping_system = var_1_2
	end,
	debug_spawn_optional_data = {
		prepare_func = function(arg_2_0, arg_2_1)
			local var_2_0 = false

			arg_2_0.modify_extension_init_data(arg_2_0, var_2_0, arg_2_1)
		end
	}
}

Breeds.shadow_totem = table.create_copy(Breeds.shadow_totem, var_0_0)
