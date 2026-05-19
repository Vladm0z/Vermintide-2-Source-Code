-- chunkname: @scripts/settings/mutators/mutator_blessing_of_abundance.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

local var_0_0 = 1
local var_0_1 = {
	{
		drop_weight = 500,
		pickup_name = "frag_grenade_t1",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "frag_grenade_t2",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "fire_grenade_t1",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "fire_grenade_t2",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 10,
		pickup_name = "holy_hand_grenade",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 2000,
		pickup_name = "all_ammo_small",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "liquid_bravado_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "friendly_murderer_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "killer_in_the_shadows_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "pockets_full_of_bombs_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "hold_my_beer_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "moot_milk_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "vampiric_draught_potion",
		spawn_function = "spawn_pickup_at_unit"
	}
}
local var_0_2 = (function()
	local var_1_0 = {}
	local var_1_1 = 0

	for iter_1_0, iter_1_1 in ipairs(var_0_1) do
		var_1_1 = var_1_1 + iter_1_1.drop_weight
	end

	for iter_1_2 = 1, #var_0_1 do
		local var_1_2 = var_0_1[iter_1_2].drop_weight / var_1_1

		var_1_0[iter_1_2] = var_0_1[iter_1_2]
		var_1_0[iter_1_2].drop_weight = var_1_2
	end

	return var_1_0
end)()

local function var_0_3(arg_2_0, arg_2_1)
	local var_2_0 = 0

	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		var_2_0 = var_2_0 + iter_2_1.drop_weight

		if arg_2_1 < var_2_0 then
			return iter_2_1
		end
	end

	assert(arg_2_0[1], "Does not contain first entry. Something went wrong.")

	return arg_2_0[1]
end

local var_0_4 = {
	spawn_pickup_at_unit = function(arg_3_0, arg_3_1)
		local var_3_0 = POSITION_LOOKUP[arg_3_0] + Vector3.up() * 0.1
		local var_3_1 = true
		local var_3_2 = arg_3_1.pickup_name

		Managers.state.entity:system("pickup_system"):buff_spawn_pickup(var_3_2, var_3_0, var_3_1)
	end,
	spawn_ignited_barrel_at_unit = function(arg_4_0, arg_4_1)
		local var_4_0 = POSITION_LOOKUP[arg_4_0] + Vector3.up() * 0.1
		local var_4_1 = Quaternion.identity()
		local var_4_2 = AiAnimUtils.position_network_scale(var_4_0, true)
		local var_4_3 = AiAnimUtils.rotation_network_scale(var_4_1, true)
		local var_4_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_4_5 = arg_4_1.pickup_name
		local var_4_6 = Managers.time:time("game")
		local var_4_7 = {
			explode_time = var_4_6 + arg_4_1.explode_time,
			fuse_time = arg_4_1.fuse_time
		}
		local var_4_8 = {
			projectile_locomotion_system = {
				network_position = var_4_2,
				network_rotation = var_4_3,
				network_velocity = var_4_4,
				network_angular_velocity = var_4_4
			},
			death_system = {
				in_hand = false,
				death_data = var_4_7,
				item_name = var_4_5
			},
			health_system = {
				damage = 1,
				health_data = var_4_7,
				item_name = var_4_5
			},
			pickup_system = {
				has_physics = true,
				spawn_type = "loot",
				pickup_name = var_4_5
			}
		}
		local var_4_9 = AllPickups[var_4_5]
		local var_4_10 = var_4_9.unit_name
		local var_4_11 = var_4_9.unit_template_name or "pickup_unit"

		Managers.state.unit_spawner:spawn_network_unit(var_4_10, var_4_11, var_4_8, var_4_0, var_4_1)
	end
}

return {
	display_name = DeusBlessingSettings.blessing_of_abundance.display_name,
	description = DeusBlessingSettings.blessing_of_abundance.description,
	icon = DeusBlessingSettings.blessing_of_abundance.icon,
	server_start_function = function(arg_5_0, arg_5_1, arg_5_2)
		arg_5_1.seed = Managers.mechanism:get_level_seed("mutator")
	end,
	server_ai_killed_function = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		local var_6_0 = Unit.get_data(arg_6_2, "breed")

		if not var_6_0.special and not var_6_0.elite and not var_6_0.boss then
			return
		end

		local var_6_1
		local var_6_2

		arg_6_1.seed, var_6_2 = Math.next_random(arg_6_1.seed)

		if var_6_2 <= var_0_0 then
			local var_6_3

			arg_6_1.seed, var_6_3 = Math.next_random(arg_6_1.seed)

			local var_6_4 = table.clone(var_0_2)

			table.array_remove_if(var_6_4, function(arg_7_0)
				return arg_7_0.pickup_name == arg_6_1.last_dropped_pickup
			end)

			local var_6_5 = var_0_3(var_6_4, var_6_3)
			local var_6_6 = var_6_5.spawn_function

			var_0_4[var_6_6](arg_6_2, var_6_5)

			arg_6_1.last_dropped_pickup = var_6_5.pickup_name
		end
	end
}
