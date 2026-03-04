-- chunkname: @scripts/entity_system/systems/ai/ai_inventory_extension.lua

AIInventoryExtension = class(AIInventoryExtension)

local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = {}
	local var_1_1 = arg_1_1.wielded or arg_1_1

	for iter_1_0, iter_1_1 in ipairs(var_1_1) do
		local var_1_2 = iter_1_1.target

		if var_1_2 ~= 0 then
			local var_1_3 = type(var_1_2) == "string" and Unit.node(arg_1_0, var_1_2) or var_1_2

			var_1_0[#var_1_0 + 1] = {
				i = var_1_3,
				parent = Unit.scene_graph_parent(arg_1_0, var_1_3),
				local_pose = Matrix4x4Box(Unit.local_pose(arg_1_0, var_1_3))
			}
		end
	end

	Unit.set_data(arg_1_0, "scene_graph_data", var_1_0)
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		local var_2_0 = iter_2_1.source
		local var_2_1 = iter_2_1.target
		local var_2_2 = type(var_2_0) == "string" and Unit.node(arg_2_3, var_2_0) or var_2_0
		local var_2_3 = type(var_2_1) == "string" and Unit.node(arg_2_2, var_2_1) or var_2_1

		World.link_unit(arg_2_1, arg_2_2, var_2_3, arg_2_3, var_2_2)
	end
end

local function var_0_2(arg_3_0, arg_3_1)
	local var_3_0 = Unit.get_data(arg_3_0, "scene_graph_data") or {}

	World.unlink_unit(arg_3_1, arg_3_0)

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		Unit.scene_graph_link(arg_3_0, iter_3_1.i, iter_3_1.parent)
		Unit.set_local_pose(arg_3_0, iter_3_1.i, iter_3_1.local_pose:unbox())
	end
end

function AIInventoryExtension._setup_configuration(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_3.items
	local var_4_1 = arg_4_3.items_n
	local var_4_2 = arg_4_0.inventory_item_units
	local var_4_3 = arg_4_0.inventory_item_units_by_category
	local var_4_4 = arg_4_0.inventory_item_definitions
	local var_4_5 = Managers.state.unit_spawner
	local var_4_6 = arg_4_2

	for iter_4_0 = 1, var_4_1 do
		var_4_6 = var_4_6 + 1

		local var_4_7 = var_4_0[iter_4_0]
		local var_4_8 = var_4_7.count
		local var_4_9 = var_4_7.name
		local var_4_10 = var_4_7[math.random(1, var_4_8)]
		local var_4_11 = var_4_10.unit_name
		local var_4_12 = var_4_10.unit_extension_template or "ai_inventory_item"
		local var_4_13 = var_4_10.flow_event or nil

		if var_4_10.extension_init_data then
			for iter_4_1, iter_4_2 in pairs(var_4_10.extension_init_data) do
				arg_4_4[iter_4_1] = iter_4_2

				if iter_4_1 == "weapon_system" then
					arg_4_4[iter_4_1].owner_unit = arg_4_1
				end
			end
		end

		local var_4_14 = var_4_10.attachment_node_linking
		local var_4_15 = var_4_14.unwielded or var_4_14
		local var_4_16
		local var_4_17

		for iter_4_3, iter_4_4 in ipairs(var_4_15) do
			if iter_4_4.target == 0 then
				local var_4_18 = iter_4_4.source
				local var_4_19 = type(var_4_18) == "string" and Unit.node(arg_4_1, var_4_18) or var_4_18

				var_4_16 = Unit.world_position(arg_4_1, var_4_19)
				var_4_17 = Unit.world_rotation(arg_4_1, var_4_19)

				break
			end
		end

		local var_4_20 = var_4_5:spawn_local_unit_with_extensions(var_4_11, var_4_12, arg_4_4, var_4_16, var_4_17)

		var_0_0(var_4_20, var_4_14)
		var_0_1(var_4_15, arg_4_0.world, var_4_20, arg_4_1)

		var_4_2[var_4_6] = var_4_20
		var_4_3[var_4_9] = var_4_20
		var_4_4[var_4_6] = var_4_10

		if var_4_12 == "ai_shield_unit" then
			Unit.set_data(var_4_20, "shield_owner_unit", arg_4_1)

			arg_4_0.inventory_item_shield_unit = var_4_20

			table.insert(arg_4_0.inventory_item_weapon_units, var_4_20)
		elseif var_4_12 == "ai_skin_unit" then
			arg_4_0.inventory_item_skin_unit = var_4_20

			if Unit.has_animation_event(var_4_20, "enable") then
				Unit.animation_event(var_4_20, "enable")
			end
		elseif var_4_12 == "ai_helmet_unit" then
			table.insert(arg_4_0.inventory_item_helmet_units, var_4_20)
		elseif var_4_12 == "ai_outfit_unit" then
			table.insert(arg_4_0.inventory_item_outfit_units, var_4_20)
		else
			table.insert(arg_4_0.inventory_item_weapon_units, var_4_20)
		end

		if var_4_13 ~= nil then
			Unit.flow_event(arg_4_1, var_4_13)
		end

		if var_4_10.weak_spot and arg_4_0.is_server then
			arg_4_0.inventory_weak_spot = var_4_10.weak_spot
		end
	end

	Unit.flow_event(arg_4_1, "lua_spawned_inventory")

	return var_4_6
end

function AIInventoryExtension.init(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.world = arg_5_2.world
	arg_5_0.unit = arg_5_1
	arg_5_0.is_server = arg_5_2.is_server
	arg_5_0.current_item_set_index = 1
	arg_5_0.inventory_item_units_by_category = {}
	arg_5_0.inventory_item_units = {}
	arg_5_0.inventory_item_definitions = {}
	arg_5_0.inventory_item_outfit_units = {}
	arg_5_0.inventory_item_helmet_units = {}
	arg_5_0.inventory_item_weapon_units = {}
	arg_5_0.inventory_item_skin_unit = nil
	arg_5_0.dropped_items = {}
	arg_5_0.gib_items = {}
	arg_5_0.stump_items = {}
	arg_5_0.gibbed_nodes = {}
	arg_5_0.disabled_actors = {}

	local var_5_0 = arg_5_2.inventory_configuration_name

	if arg_5_2.is_server and not var_5_0 then
		local var_5_1 = arg_5_2.inventory_template or "default"

		var_5_0 = AIInventoryTemplates[var_5_1]()
	end

	local var_5_2 = {
		ai_inventory_item_system = {
			wielding_unit = arg_5_1
		}
	}
	local var_5_3 = InventoryConfigurations[var_5_0]
	local var_5_4 = 0
	local var_5_5 = var_5_3.multiple_configurations

	if var_5_5 then
		arg_5_0.item_sets = {}

		for iter_5_0 = 1, #var_5_5 do
			local var_5_6 = {
				start_index = var_5_4 + 1
			}

			arg_5_0.item_sets[#arg_5_0.item_sets + 1] = var_5_6
			var_5_3 = InventoryConfigurations[var_5_5[iter_5_0]]
			var_5_4 = arg_5_0:_setup_configuration(arg_5_1, var_5_4, var_5_3, var_5_2)
			var_5_6.end_index = var_5_4
			var_5_6.inventory_configuration = var_5_3
			var_5_6.equip_anim = var_5_3.equip_anim
		end

		var_5_3 = InventoryConfigurations[var_5_5[1]]
	else
		var_5_4 = arg_5_0:_setup_configuration(arg_5_1, 0, var_5_3, var_5_2)
	end

	arg_5_0.inventory_items_n = var_5_4
	arg_5_0.inventory_configuration_name = var_5_0

	local var_5_7 = var_5_3.anim_state_event

	if var_5_7 then
		Unit.animation_event(arg_5_1, var_5_7)
	end
end

function AIInventoryExtension.destroy(arg_6_0)
	local var_6_0 = Managers.state.unit_spawner
	local var_6_1 = arg_6_0.inventory_items_n
	local var_6_2 = arg_6_0.world

	for iter_6_0 = 1, var_6_1 do
		local var_6_3 = arg_6_0.inventory_item_units[iter_6_0]

		if Unit.alive(var_6_3) then
			var_0_2(var_6_3, var_6_2)
			var_6_0:mark_for_deletion(var_6_3)
			arg_6_0:destroy_dropped_items(iter_6_0)
		end
	end

	for iter_6_1 = 1, #arg_6_0.gib_items do
		var_6_0:mark_for_deletion(arg_6_0.gib_items[iter_6_1])
	end

	arg_6_0.gib_items = {}

	for iter_6_2 = 1, #arg_6_0.stump_items do
		var_6_0:mark_for_deletion(arg_6_0.stump_items[iter_6_2])
	end

	arg_6_0.stump_items = {}
end

function AIInventoryExtension.destroy_dropped_items(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.dropped_items[arg_7_1]
	local var_7_1 = arg_7_0.world

	if not var_7_0 then
		return
	end

	if type(var_7_0) == "table" then
		for iter_7_0, iter_7_1 in pairs(var_7_0) do
			World.destroy_unit(var_7_1, iter_7_1)
		end

		table.clear(var_7_0)
	else
		World.destroy_unit(var_7_1, var_7_0)
	end
end

function AIInventoryExtension.get_skin_unit(arg_8_0)
	return arg_8_0.inventory_item_skin_unit
end

function AIInventoryExtension.freeze(arg_9_0)
	local var_9_0 = Managers.state.unit_spawner
	local var_9_1 = arg_9_0.world
	local var_9_2 = arg_9_0.inventory_items_n
	local var_9_3 = arg_9_0.unit

	for iter_9_0 = 1, var_9_2 do
		local var_9_4 = arg_9_0.inventory_item_units[iter_9_0]

		if Unit.alive(var_9_4) then
			var_0_2(var_9_4, arg_9_0.world)
			var_9_0:mark_for_deletion(var_9_4)
			arg_9_0:destroy_dropped_items(iter_9_0)
		end
	end

	arg_9_0.inventory_items_n = 0
	arg_9_0.inventory_item_units = {}
	arg_9_0.inventory_item_outfit_units = {}
	arg_9_0.inventory_item_helmet_units = {}

	local var_9_5 = Vector3(1, 1, 1)

	for iter_9_1 = 1, #arg_9_0.gibbed_nodes do
		Unit.set_local_scale(var_9_3, arg_9_0.gibbed_nodes[iter_9_1], var_9_5)
	end

	arg_9_0.gibbed_nodes = {}

	for iter_9_2 = 1, #arg_9_0.disabled_actors do
		local var_9_6 = Unit.actor(var_9_3, arg_9_0.disabled_actors[iter_9_2])

		if var_9_6 then
			Actor.set_collision_filter(var_9_6, "filter_enemy_hit_box")
		end
	end

	arg_9_0.disabled_actors = {}

	for iter_9_3 = 1, #arg_9_0.gib_items do
		var_9_0:mark_for_deletion(arg_9_0.gib_items[iter_9_3])
	end

	arg_9_0.gib_items = {}

	for iter_9_4 = 1, #arg_9_0.stump_items do
		var_9_0:mark_for_deletion(arg_9_0.stump_items[iter_9_4])
	end

	arg_9_0.stump_items = {}
end

function AIInventoryExtension.unfreeze(arg_10_0)
	local var_10_0 = arg_10_0.unit

	arg_10_0.dropped = false
	arg_10_0.wielded = false

	local var_10_1 = {
		ai_inventory_item_system = {
			wielding_unit = var_10_0
		}
	}
	local var_10_2 = InventoryConfigurations[arg_10_0.inventory_configuration_name]
	local var_10_3 = 0
	local var_10_4 = var_10_2.multiple_configurations

	if var_10_4 then
		arg_10_0.item_sets = {}

		for iter_10_0 = 1, #var_10_4 do
			local var_10_5 = {
				start_index = var_10_3 + 1
			}

			arg_10_0.item_sets[#arg_10_0.item_sets + 1] = var_10_5
			var_10_2 = InventoryConfigurations[var_10_4[iter_10_0]]
			var_10_3 = arg_10_0:_setup_configuration(var_10_0, var_10_3, var_10_2, var_10_1)
			var_10_5.end_index = var_10_3
			var_10_5.inventory_configuration = var_10_2
			var_10_5.equip_anim = var_10_2.equip_anim
		end

		var_10_2 = InventoryConfigurations[var_10_4[1]]
	else
		var_10_3 = arg_10_0:_setup_configuration(var_10_0, 0, var_10_2, var_10_1)
	end

	arg_10_0.inventory_items_n = var_10_3

	local var_10_6 = var_10_2.anim_state_event

	if var_10_6 then
		Unit.animation_event(var_10_0, var_10_6)
	end
end

function AIInventoryExtension.show_single_item(arg_11_0, arg_11_1, arg_11_2)
	if script_data.ai_debug_inventory then
		printf("[AIInventorySystem] showing[%s] item_inventory_index[%d]", tostring(arg_11_2), arg_11_1)
	end

	local var_11_0 = arg_11_0.inventory_item_units[arg_11_1]

	arg_11_0.hidden_item_index = not arg_11_2 and arg_11_1 or nil

	Unit.set_unit_visibility(var_11_0, arg_11_2)
end

function AIInventoryExtension.get_unit(arg_12_0, arg_12_1)
	return arg_12_0.inventory_item_units_by_category[arg_12_1]
end

function AIInventoryExtension.get_item_inventory_index(arg_13_0, arg_13_1)
	for iter_13_0 = 1, arg_13_0.inventory_items_n do
		if arg_13_0.inventory_item_units[iter_13_0] == arg_13_1 then
			return iter_13_0
		end
	end

	assert(false, "item_unit not found in ai inventory")
end

function AIInventoryExtension.drop_single_item(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if script_data.ai_debug_inventory then
		printf("[AIInventorySystem] dropping item_inventory_index[%d] with [%d] total items in inventory", arg_14_1, arg_14_0.inventory_items_n)
	end

	assert(arg_14_0.inventory_item_units[arg_14_1], "item inventory index out of bounds")

	if arg_14_0.dropped_items[arg_14_1] ~= nil then
		return false
	end

	local var_14_0 = arg_14_0.inventory_item_units[arg_14_1]
	local var_14_1 = ScriptUnit.has_extension(var_14_0, "ai_inventory_item_system")
	local var_14_2 = arg_14_0.inventory_item_definitions[arg_14_1]
	local var_14_3 = var_14_2.unit_extension_template or "ai_inventory_item"

	if var_14_1 and not var_14_1.dropped and var_14_2.drop_reasons[arg_14_2] and var_14_3 ~= "ai_helmet_unit" and var_14_3 ~= "ai_outfit_unit" and var_14_3 ~= "ai_skin_unit" then
		if var_14_2.drop_unit_name ~= nil then
			arg_14_0:_drop_unit(var_14_2.drop_unit_name, var_14_0, var_14_2, arg_14_1, arg_14_2, false, arg_14_3)
			arg_14_0:disable_inventory_item(var_14_2, var_14_0)
		elseif var_14_2.drop_unit_names ~= nil and arg_14_2 == "shield_break" then
			local var_14_4 = var_14_2.drop_unit_names

			for iter_14_0 = 1, #var_14_4 do
				local var_14_5 = var_14_4[iter_14_0]

				arg_14_0:_drop_unit(var_14_5, var_14_0, var_14_2, arg_14_1, arg_14_2, true, arg_14_3)
			end

			arg_14_0:disable_inventory_item(var_14_2, var_14_0)
		else
			var_0_2(var_14_0, arg_14_0.world)
			Unit.set_flow_variable(var_14_0, "lua_drop_reason", arg_14_2)
			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(var_14_0, "outline_unit", false)
			Unit.flow_event(var_14_0, "lua_dropped")

			local var_14_6 = Unit.create_actor(var_14_0, "rp_dropped")

			Actor.add_angular_velocity(var_14_6, Vector3(math.random(), math.random(), math.random()) * 5)
			Actor.add_velocity(var_14_6, arg_14_3 or Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))

			var_14_1.wielding_unit = nil
			var_14_1.dropped = true
			var_14_2.dropped = true
		end

		return true, var_14_0
	else
		return false
	end
end

function AIInventoryExtension.disable_inventory_item(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = ScriptUnit.has_extension(arg_15_2, "ai_inventory_item_system")
	local var_15_1 = Unit.num_actors(arg_15_2)

	for iter_15_0 = 1, var_15_1 do
		local var_15_2 = Unit.actor(arg_15_2, iter_15_0)

		if var_15_2 then
			Actor.set_collision_enabled(var_15_2, false)
			Actor.set_scene_query_enabled(var_15_2, false)
		end
	end

	World.unlink_unit(arg_15_0.world, arg_15_2)
	Unit.set_unit_visibility(arg_15_2, false)

	var_15_0.wielding_unit = nil
	var_15_0.dropped = true
	arg_15_1.dropped = true

	if ScriptUnit.has_extension(arg_15_2, "projectile_linker_system") then
		Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_15_2)
	end
end

function AIInventoryExtension._drop_unit(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	local var_16_0 = Unit.world_position(arg_16_2, 0)
	local var_16_1 = Unit.world_rotation(arg_16_2, 0)
	local var_16_2 = World.spawn_unit(arg_16_0.world, arg_16_1, var_16_0, var_16_1, nil)

	Unit.set_flow_variable(var_16_2, "lua_drop_reason", arg_16_5)
	Unit.flow_event(var_16_2, "lua_dropped")

	local var_16_3 = Unit.create_actor(var_16_2, "rp_dropped")

	Actor.add_angular_velocity(var_16_3, Vector3(math.random(), math.random(), math.random()) * 5)
	Actor.add_velocity(var_16_3, arg_16_7 or Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))

	if arg_16_6 then
		arg_16_0.dropped_items[arg_16_4] = arg_16_0.dropped_items[arg_16_4] or {}

		local var_16_4 = arg_16_0.dropped_items[arg_16_4]

		arg_16_0.dropped_items[arg_16_4][#var_16_4 + 1] = var_16_2
	else
		arg_16_0.dropped_items[arg_16_4] = var_16_2
	end
end

function AIInventoryExtension.wield_item_set(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.unit
	local var_17_1 = Managers.state.network
	local var_17_2 = var_17_1:unit_game_object_id(var_17_0)

	var_17_1.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_17_2, arg_17_1)

	local var_17_3 = arg_17_0.item_sets[arg_17_1]
	local var_17_4 = var_17_3.inventory_configuration.anim_state_event

	if not arg_17_2 and var_17_4 then
		local var_17_5 = BLACKBOARDS[var_17_0]

		if var_17_4 == "to_combat" then
			AiUtils.enter_combat(var_17_0, var_17_5)
		elseif var_17_4 == "to_passive" then
			AiUtils.enter_passive(var_17_0, var_17_5)
		elseif var_17_4 then
			Managers.state.network:anim_event(var_17_0, var_17_4)
		end
	end

	local var_17_6 = var_17_3.equip_anim

	if not arg_17_2 and var_17_6 then
		Managers.state.network:anim_event(var_17_0, var_17_6)
	end
end

function AIInventoryExtension.unwield_set(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.item_sets[arg_18_1]

	for iter_18_0 = var_18_0.start_index, var_18_0.end_index do
		local var_18_1 = arg_18_0.inventory_item_definitions[iter_18_0].attachment_node_linking.unwielded

		if var_18_1 then
			local var_18_2 = arg_18_0.inventory_item_units[iter_18_0]

			var_0_2(var_18_2, arg_18_0.world)
			var_0_1(var_18_1, arg_18_0.world, var_18_2, arg_18_0.unit)
		end
	end
end

function AIInventoryExtension.play_hit_sound(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = Managers.player:owner(arg_19_1)
	local var_19_1 = var_19_0.remote or var_19_0.bot_player or false
	local var_19_2 = arg_19_0.world
	local var_19_3 = arg_19_0.inventory_configuration_name
	local var_19_4 = InventoryConfigurations[var_19_3].enemy_hit_sound

	if arg_19_2 == "blunt" then
		var_19_4 = "melee"
	end

	if var_19_4 then
		EffectHelper.play_melee_hit_effects_enemy("enemy_hit", var_19_4, var_19_2, arg_19_1, arg_19_2, var_19_1)
	end

	if arg_19_0._additional_hit_sounds then
		local var_19_5 = arg_19_0._additional_hit_sounds

		for iter_19_0 = 1, #var_19_5 do
			local var_19_6, var_19_7 = WwiseUtils.make_unit_auto_source(var_19_2, arg_19_1)

			WwiseWorld.set_switch(var_19_7, "husk", tostring(var_19_1), var_19_6)
			WwiseWorld.trigger_event(var_19_7, var_19_5[iter_19_0], var_19_6)
		end
	end
end

function AIInventoryExtension.hot_join_sync(arg_20_0, arg_20_1)
	local var_20_0 = PEER_ID_TO_CHANNEL[arg_20_1]

	if arg_20_0.hidden_item_index and ALIVE[arg_20_0.unit] then
		local var_20_1 = Managers.state.unit_storage:go_id(arg_20_0.unit)

		RPC.rpc_ai_show_single_item(var_20_0, var_20_1, arg_20_0.hidden_item_index, false)
	end

	if arg_20_0.dropped then
		-- block empty
	elseif arg_20_0.wielded then
		local var_20_2 = Managers.state.unit_storage:go_id(arg_20_0.unit)

		if var_20_2 then
			RPC.rpc_ai_inventory_wield(var_20_0, var_20_2, arg_20_0.current_item_set_index)
		end
	end
end

function AIInventoryExtension.add_additional_hit_sfx(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return nil
	end

	local var_21_0 = arg_21_0._additional_hit_sounds
	local var_21_1 = arg_21_0._additional_hit_sounds_ids

	if not var_21_0 then
		var_21_0 = {}
		arg_21_0._additional_hit_sounds = var_21_0
		var_21_1 = {}
		arg_21_0._additional_hit_sounds_ids = var_21_1
	end

	local var_21_2 = arg_21_0._unique_id or 1

	arg_21_0._unique_id = var_21_2 + 1

	if not var_21_1[arg_21_1] then
		var_21_0[#var_21_0 + 1] = arg_21_1
		var_21_1[arg_21_1] = {
			var_21_2
		}
		var_21_1[var_21_2] = arg_21_1
	else
		local var_21_3 = var_21_1[arg_21_1]

		var_21_3[#var_21_3 + 1] = var_21_2
		var_21_1[var_21_2] = arg_21_1
	end

	return var_21_2
end

function AIInventoryExtension.remove_additioanl_hit_sfx(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._additional_hit_sounds_ids

	if not var_22_0 then
		return
	end

	local var_22_1 = var_22_0[arg_22_1]

	if not var_22_1 then
		return
	end

	local var_22_2 = var_22_0[var_22_1]

	if not var_22_2 then
		return
	end

	local var_22_3 = table.index_of(var_22_2, arg_22_1)

	if var_22_3 > 0 then
		table.swap_delete(var_22_2, var_22_3)

		var_22_0[arg_22_1] = nil

		if #var_22_2 == 0 then
			var_22_0[var_22_1] = nil

			local var_22_4 = arg_22_0._additional_hit_sounds

			if var_22_4 then
				local var_22_5 = table.index_of(var_22_4, var_22_1)

				if var_22_5 > 0 then
					table.swap_delete(var_22_4, var_22_5)

					if #var_22_4 == 0 then
						arg_22_0._additional_hit_sounds = nil
					end
				end
			end
		end
	end
end
