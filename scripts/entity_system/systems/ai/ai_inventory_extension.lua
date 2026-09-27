-- chunkname: @scripts/entity_system/systems/ai/ai_inventory_extension.lua

AIInventoryExtension = class(AIInventoryExtension)

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local tbl = {}
	local wielded = arg_1_1.wielded

	wielded = wielded or arg_1_1

	for i, v in ipairs(wielded) do
		local target = v.target

		if target ~= 0 then
			local node

			if type(target) == "string" then
				node = Unit.node(arg_1_0, target)

				if not node then
					-- Nothing
				end
			end

			node = target

			::label_1_0::

			tbl[#tbl + 1] = {
				i = node,
				parent = Unit.scene_graph_parent(arg_1_0, node),
				local_pose = Matrix4x4Box(Unit.local_pose(arg_1_0, node))
			}
		end
	end

	Unit.set_data(arg_1_0, "scene_graph_data", tbl)
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	for i, v in ipairs(arg_2_0) do
		local source = v.source
		local target = v.target
		local node

		if type(source) == "string" then
			node = Unit.node(arg_2_3, source)

			if not node then
				-- Nothing
			end
		end

		node = source

		do
			local node_2
		end

		::label_2_0::

		if type(target) == "string" then
			node_2 = Unit.node(arg_2_2, target)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = target

		::label_2_1::

		World.link_unit(arg_2_1, arg_2_2, node_2, arg_2_3, node)
	end
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local get_data = Unit.get_data(arg_3_0, "scene_graph_data")

	get_data = get_data or {}

	World.unlink_unit(arg_3_1, arg_3_0)

	for i, v in ipairs(get_data) do
		Unit.scene_graph_link(arg_3_0, v.i, v.parent)
		Unit.set_local_pose(arg_3_0, v.i, v.local_pose:unbox())
	end
end

AIInventoryExtension._setup_configuration = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local items = arg_4_3.items
	local items_n = arg_4_3.items_n
	local inventory_item_units = self.inventory_item_units
	local inventory_item_units_by_category = self.inventory_item_units_by_category
	local inventory_item_definitions = self.inventory_item_definitions
	local unit_spawner = Managers.state.unit_spawner
	local var_4_6 = arg_4_2

	for i = 1, items_n do
		var_4_6 = var_4_6 + 1

		local var_4_7 = items[i]
		local count = var_4_7.count
		local name = var_4_7.name
		local var_4_10 = var_4_7[math.random(1, count)]
		local unit_name = var_4_10.unit_name
		local unit_extension_template = var_4_10.unit_extension_template

		unit_extension_template = unit_extension_template or "ai_inventory_item"

		local flow_event = var_4_10.flow_event

		flow_event = flow_event or nil

		if not var_4_10.extension_init_data then
			for k, v in pairs(var_4_10.extension_init_data) do
				arg_4_4[k] = v

				if k == "weapon_system" then
					arg_4_4[k].owner_unit = arg_4_1
				end
			end
		end

		local attachment_node_linking = var_4_10.attachment_node_linking
		local unwielded = attachment_node_linking.unwielded

		unwielded = unwielded or attachment_node_linking

		local var_4_16
		local var_4_17

		for i_2, v_2 in ipairs(unwielded) do
			if v_2.target == 0 then
				local source = v_2.source
				local node

				if type(source) == "string" then
					node = Unit.node(arg_4_1, source)

					if not node then
						-- Nothing
					end
				end

				node = source

				::label_4_0::

				var_4_16 = Unit.world_position(arg_4_1, node)
				var_4_17 = Unit.world_rotation(arg_4_1, node)

				break
			end
		end

		local spawn_local_unit_with_extensions = unit_spawner:spawn_local_unit_with_extensions(unit_name, unit_extension_template, arg_4_4, var_4_16, var_4_17)

		fn(spawn_local_unit_with_extensions, attachment_node_linking)
		fn_2(unwielded, self.world, spawn_local_unit_with_extensions, arg_4_1)

		inventory_item_units[var_4_6] = spawn_local_unit_with_extensions
		inventory_item_units_by_category[name] = spawn_local_unit_with_extensions
		inventory_item_definitions[var_4_6] = var_4_10

		if unit_extension_template == "ai_shield_unit" then
			Unit.set_data(spawn_local_unit_with_extensions, "shield_owner_unit", arg_4_1)

			self.inventory_item_shield_unit = spawn_local_unit_with_extensions

			table.insert(self.inventory_item_weapon_units, spawn_local_unit_with_extensions)
		elseif unit_extension_template == "ai_skin_unit" then
			self.inventory_item_skin_unit = spawn_local_unit_with_extensions

			if not Unit.has_animation_event(spawn_local_unit_with_extensions, "enable") then
				Unit.animation_event(spawn_local_unit_with_extensions, "enable")
			end
		elseif unit_extension_template == "ai_helmet_unit" then
			table.insert(self.inventory_item_helmet_units, spawn_local_unit_with_extensions)
		elseif unit_extension_template == "ai_outfit_unit" then
			table.insert(self.inventory_item_outfit_units, spawn_local_unit_with_extensions)
		else
			table.insert(self.inventory_item_weapon_units, spawn_local_unit_with_extensions)
		end

		if flow_event ~= nil then
			Unit.flow_event(arg_4_1, flow_event)
		end

		if not var_4_10.weak_spot and not self.is_server then
			self.inventory_weak_spot = var_4_10.weak_spot
		end
	end

	Unit.flow_event(arg_4_1, "lua_spawned_inventory")

	return var_4_6
end

AIInventoryExtension.init = function (self, arg_5_1, arg_5_2)
	-- function 5
	self.world = arg_5_2.world
	self.unit = arg_5_1
	self.is_server = arg_5_2.is_server
	self.current_item_set_index = 1
	self.inventory_item_units_by_category = {}
	self.inventory_item_units = {}
	self.inventory_item_definitions = {}
	self.inventory_item_outfit_units = {}
	self.inventory_item_helmet_units = {}
	self.inventory_item_weapon_units = {}
	self.inventory_item_skin_unit = nil
	self.dropped_items = {}
	self.gib_items = {}
	self.stump_items = {}
	self.gibbed_nodes = {}
	self.disabled_actors = {}

	local inventory_configuration_name = arg_5_2.inventory_configuration_name

	if not (not arg_5_2.is_server and inventory_configuration_name) then
		local inventory_template = arg_5_2.inventory_template

		inventory_template = inventory_template or "default"
		inventory_configuration_name = AIInventoryTemplates[inventory_template]()
	end

	local tbl = {
		ai_inventory_item_system = {
			wielding_unit = arg_5_1
		}
	}
	local var_5_3 = InventoryConfigurations[inventory_configuration_name]
	local num = 0
	local multiple_configurations = var_5_3.multiple_configurations

	if not multiple_configurations then
		self.item_sets = {}

		for i = 1, #multiple_configurations do
			local tbl_2 = {
				start_index = num + 1
			}

			self.item_sets[#self.item_sets + 1] = tbl_2
			var_5_3 = InventoryConfigurations[multiple_configurations[i]]
			num = self:_setup_configuration(arg_5_1, num, var_5_3, tbl)
			tbl_2.end_index = num
			tbl_2.inventory_configuration = var_5_3
			tbl_2.equip_anim = var_5_3.equip_anim
		end

		var_5_3 = InventoryConfigurations[multiple_configurations[1]]
	else
		num = self:_setup_configuration(arg_5_1, 0, var_5_3, tbl)
	end

	self.inventory_items_n = num
	self.inventory_configuration_name = inventory_configuration_name

	local anim_state_event = var_5_3.anim_state_event

	if not anim_state_event then
		Unit.animation_event(arg_5_1, anim_state_event)
	end
end

AIInventoryExtension.destroy = function (self)
	-- function 6
	local unit_spawner = Managers.state.unit_spawner
	local inventory_items_n = self.inventory_items_n
	local world = self.world

	for i = 1, inventory_items_n do
		local var_6_3 = self.inventory_item_units[i]

		if not Unit.alive(var_6_3) then
			fn_3(var_6_3, world)
			unit_spawner:mark_for_deletion(var_6_3)
			self:destroy_dropped_items(i)
		end
	end

	for j = 1, #self.gib_items do
		unit_spawner:mark_for_deletion(self.gib_items[j])
	end

	self.gib_items = {}

	for k = 1, #self.stump_items do
		unit_spawner:mark_for_deletion(self.stump_items[k])
	end

	self.stump_items = {}
end

AIInventoryExtension.destroy_dropped_items = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self.dropped_items[arg_7_1]
	local world = self.world

	if not var_7_0 then
		return
	end

	if type(var_7_0) == "table" then
		for k, v in pairs(var_7_0) do
			World.destroy_unit(world, v)
		end

		table.clear(var_7_0)
	else
		World.destroy_unit(world, var_7_0)
	end
end

AIInventoryExtension.get_skin_unit = function (self)
	-- function 8
	return self.inventory_item_skin_unit
end

AIInventoryExtension.freeze = function (self)
	-- function 9
	local unit_spawner = Managers.state.unit_spawner
	local world = self.world
	local inventory_items_n = self.inventory_items_n
	local unit = self.unit

	for i = 1, inventory_items_n do
		local var_9_4 = self.inventory_item_units[i]

		if not Unit.alive(var_9_4) then
			fn_3(var_9_4, self.world)
			unit_spawner:mark_for_deletion(var_9_4)
			self:destroy_dropped_items(i)
		end
	end

	self.inventory_items_n = 0
	self.inventory_item_units = {}
	self.inventory_item_outfit_units = {}
	self.inventory_item_helmet_units = {}

	local var_9_5 = Vector3(1, 1, 1)

	for j = 1, #self.gibbed_nodes do
		Unit.set_local_scale(unit, self.gibbed_nodes[j], var_9_5)
	end

	self.gibbed_nodes = {}

	for k = 1, #self.disabled_actors do
		local actor = Unit.actor(unit, self.disabled_actors[k])

		if not actor then
			Actor.set_collision_filter(actor, "filter_enemy_hit_box")
		end
	end

	self.disabled_actors = {}

	for l = 1, #self.gib_items do
		unit_spawner:mark_for_deletion(self.gib_items[l])
	end

	self.gib_items = {}

	for i4 = 1, #self.stump_items do
		unit_spawner:mark_for_deletion(self.stump_items[i4])
	end

	self.stump_items = {}
end

AIInventoryExtension.unfreeze = function (self)
	-- function 10
	local unit = self.unit

	self.dropped = false
	self.wielded = false

	local tbl = {
		ai_inventory_item_system = {
			wielding_unit = unit
		}
	}
	local var_10_2 = InventoryConfigurations[self.inventory_configuration_name]
	local num = 0
	local multiple_configurations = var_10_2.multiple_configurations

	if not multiple_configurations then
		self.item_sets = {}

		for i = 1, #multiple_configurations do
			local tbl_2 = {
				start_index = num + 1
			}

			self.item_sets[#self.item_sets + 1] = tbl_2
			var_10_2 = InventoryConfigurations[multiple_configurations[i]]
			num = self:_setup_configuration(unit, num, var_10_2, tbl)
			tbl_2.end_index = num
			tbl_2.inventory_configuration = var_10_2
			tbl_2.equip_anim = var_10_2.equip_anim
		end

		var_10_2 = InventoryConfigurations[multiple_configurations[1]]
	else
		num = self:_setup_configuration(unit, 0, var_10_2, tbl)
	end

	self.inventory_items_n = num

	local anim_state_event = var_10_2.anim_state_event

	if not anim_state_event then
		Unit.animation_event(unit, anim_state_event)
	end
end

AIInventoryExtension.show_single_item = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not script_data.ai_debug_inventory then
		printf("[AIInventorySystem] showing[%s] item_inventory_index[%d]", tostring(arg_11_2), arg_11_1)
	end

	local var_11_0 = self.inventory_item_units[arg_11_1]

	self.hidden_item_index = arg_11_2 or not arg_11_1 or nil

	Unit.set_unit_visibility(var_11_0, arg_11_2)
end

AIInventoryExtension.get_unit = function (self, arg_12_1)
	-- function 12
	return self.inventory_item_units_by_category[arg_12_1]
end

AIInventoryExtension.get_item_inventory_index = function (self, arg_13_1)
	-- function 13
	for i = 1, self.inventory_items_n do
		if self.inventory_item_units[i] == arg_13_1 then
			return i
		end
	end

	assert(false, "item_unit not found in ai inventory")
end

AIInventoryExtension.drop_single_item = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not script_data.ai_debug_inventory then
		printf("[AIInventorySystem] dropping item_inventory_index[%d] with [%d] total items in inventory", arg_14_1, self.inventory_items_n)
	end

	assert(self.inventory_item_units[arg_14_1], "item inventory index out of bounds")

	if self.dropped_items[arg_14_1] ~= nil then
		return false
	end

	local var_14_0 = self.inventory_item_units[arg_14_1]
	local has_extension = ScriptUnit.has_extension(var_14_0, "ai_inventory_item_system")
	local var_14_2 = self.inventory_item_definitions[arg_14_1]
	local unit_extension_template = var_14_2.unit_extension_template

	unit_extension_template = unit_extension_template or "ai_inventory_item"

	if not (not has_extension and has_extension.dropped and not var_14_2.drop_reasons[arg_14_2] and unit_extension_template == "ai_helmet_unit" and unit_extension_template == "ai_outfit_unit" and unit_extension_template == "ai_skin_unit") then
		if var_14_2.drop_unit_name ~= nil then
			self:_drop_unit(var_14_2.drop_unit_name, var_14_0, var_14_2, arg_14_1, arg_14_2, false, arg_14_3)
			self:disable_inventory_item(var_14_2, var_14_0)
		elseif not (var_14_2.drop_unit_names == nil or arg_14_2 ~= "shield_break") then
			local drop_unit_names = var_14_2.drop_unit_names

			for i = 1, #drop_unit_names do
				local var_14_5 = drop_unit_names[i]

				self:_drop_unit(var_14_5, var_14_0, var_14_2, arg_14_1, arg_14_2, true, arg_14_3)
			end

			self:disable_inventory_item(var_14_2, var_14_0)
		else
			fn_3(var_14_0, self.world)
			Unit.set_flow_variable(var_14_0, "lua_drop_reason", arg_14_2)
			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(var_14_0, "outline_unit", false)
			Unit.flow_event(var_14_0, "lua_dropped")

			local create_actor = Unit.create_actor(var_14_0, "rp_dropped")

			Actor.add_angular_velocity(create_actor, Vector3(math.random(), math.random(), math.random()) * 5)
			Actor.add_velocity(create_actor, arg_14_3 or Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))

			has_extension.wielding_unit = nil
			has_extension.dropped = true
			var_14_2.dropped = true
		end

		return true, var_14_0
	else
		return false
	end
end

AIInventoryExtension.disable_inventory_item = function (self, arg_15_1, arg_15_2)
	-- function 15
	local has_extension = ScriptUnit.has_extension(arg_15_2, "ai_inventory_item_system")
	local num_actors = Unit.num_actors(arg_15_2)

	for i = 1, num_actors do
		local actor = Unit.actor(arg_15_2, i)

		if not actor then
			Actor.set_collision_enabled(actor, false)
			Actor.set_scene_query_enabled(actor, false)
		end
	end

	World.unlink_unit(self.world, arg_15_2)
	Unit.set_unit_visibility(arg_15_2, false)

	has_extension.wielding_unit = nil
	has_extension.dropped = true
	arg_15_1.dropped = true

	if not ScriptUnit.has_extension(arg_15_2, "projectile_linker_system") then
		Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_15_2)
	end
end

AIInventoryExtension._drop_unit = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	-- function 16
	local world_position = Unit.world_position(arg_16_2, 0)
	local world_rotation = Unit.world_rotation(arg_16_2, 0)
	local spawn_unit = World.spawn_unit(self.world, arg_16_1, world_position, world_rotation, nil)

	Unit.set_flow_variable(spawn_unit, "lua_drop_reason", arg_16_5)
	Unit.flow_event(spawn_unit, "lua_dropped")

	local create_actor = Unit.create_actor(spawn_unit, "rp_dropped")

	Actor.add_angular_velocity(create_actor, Vector3(math.random(), math.random(), math.random()) * 5)
	Actor.add_velocity(create_actor, arg_16_7 or Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))

	if not arg_16_6 then
		local dropped_items = self.dropped_items
		local var_16_5 = self.dropped_items[arg_16_4]

		var_16_5 = var_16_5 or {}
		dropped_items[arg_16_4] = var_16_5

		local var_16_6 = self.dropped_items[arg_16_4]

		self.dropped_items[arg_16_4][#var_16_6 + 1] = spawn_unit
	else
		self.dropped_items[arg_16_4] = spawn_unit
	end
end

AIInventoryExtension.wield_item_set = function (self, arg_17_1, arg_17_2)
	-- function 17
	local unit = self.unit
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(unit)

	network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, arg_17_1)

	local var_17_3 = self.item_sets[arg_17_1]
	local anim_state_event = var_17_3.inventory_configuration.anim_state_event

	if arg_17_2 or not anim_state_event then
		local var_17_5 = BLACKBOARDS[unit]

		if anim_state_event == "to_combat" then
			AiUtils.enter_combat(unit, var_17_5)
		elseif anim_state_event == "to_passive" then
			AiUtils.enter_passive(unit, var_17_5)
		elseif not anim_state_event then
			Managers.state.network:anim_event(unit, anim_state_event)
		end
	end

	local equip_anim = var_17_3.equip_anim

	if arg_17_2 or not equip_anim then
		Managers.state.network:anim_event(unit, equip_anim)
	end
end

AIInventoryExtension.unwield_set = function (self, arg_18_1)
	-- function 18
	local var_18_0 = self.item_sets[arg_18_1]

	for i = var_18_0.start_index, var_18_0.end_index do
		local unwielded = self.inventory_item_definitions[i].attachment_node_linking.unwielded

		if not unwielded then
			local var_18_2 = self.inventory_item_units[i]

			fn_3(var_18_2, self.world)
			fn_2(unwielded, self.world, var_18_2, self.unit)
		end
	end
end

AIInventoryExtension.play_hit_sound = function (self, arg_19_1, arg_19_2)
	-- function 19
	local owner = Managers.player:owner(arg_19_1)
	local remote = owner.remote

	if not remote then
		remote = owner.bot_player
		remote = remote or false
	end

	local world = self.world
	local inventory_configuration_name = self.inventory_configuration_name
	local enemy_hit_sound = InventoryConfigurations[inventory_configuration_name].enemy_hit_sound

	if arg_19_2 == "blunt" then
		enemy_hit_sound = "melee"
	end

	if not enemy_hit_sound then
		EffectHelper.play_melee_hit_effects_enemy("enemy_hit", enemy_hit_sound, world, arg_19_1, arg_19_2, remote)
	end

	if not self._additional_hit_sounds then
		local _additional_hit_sounds = self._additional_hit_sounds

		for i = 1, #_additional_hit_sounds do
			local make_unit_auto_source, var_19_7 = WwiseUtils.make_unit_auto_source(world, arg_19_1)

			WwiseWorld.set_switch(var_19_7, "husk", tostring(remote), make_unit_auto_source)
			WwiseWorld.trigger_event(var_19_7, _additional_hit_sounds[i], make_unit_auto_source)
		end
	end
end

AIInventoryExtension.hot_join_sync = function (self, arg_20_1)
	-- function 20
	local var_20_0 = PEER_ID_TO_CHANNEL[arg_20_1]

	if not self.hidden_item_index and not ALIVE[self.unit] then
		local go_id = Managers.state.unit_storage:go_id(self.unit)

		RPC.rpc_ai_show_single_item(var_20_0, go_id, self.hidden_item_index, false)
	end

	if not self.dropped then
		-- Nothing
	elseif not self.wielded then
		local go_id_2 = Managers.state.unit_storage:go_id(self.unit)

		if not go_id_2 then
			RPC.rpc_ai_inventory_wield(var_20_0, go_id_2, self.current_item_set_index)
		end
	end
end

AIInventoryExtension.add_additional_hit_sfx = function (self, arg_21_1)
	-- function 21
	if not arg_21_1 then
		return nil
	end

	local _additional_hit_sounds = self._additional_hit_sounds
	local _additional_hit_sounds_ids = self._additional_hit_sounds_ids

	if not _additional_hit_sounds then
		_additional_hit_sounds = {}
		self._additional_hit_sounds = _additional_hit_sounds
		_additional_hit_sounds_ids = {}
		self._additional_hit_sounds_ids = _additional_hit_sounds_ids
	end

	local _unique_id = self._unique_id

	_unique_id = _unique_id or 1
	self._unique_id = _unique_id + 1

	if not _additional_hit_sounds_ids[arg_21_1] then
		_additional_hit_sounds[#_additional_hit_sounds + 1] = arg_21_1
		_additional_hit_sounds_ids[arg_21_1] = {
			_unique_id
		}
		_additional_hit_sounds_ids[_unique_id] = arg_21_1
	else
		local var_21_3 = _additional_hit_sounds_ids[arg_21_1]

		var_21_3[#var_21_3 + 1] = _unique_id
		_additional_hit_sounds_ids[_unique_id] = arg_21_1
	end

	return _unique_id
end

AIInventoryExtension.remove_additioanl_hit_sfx = function (self, arg_22_1)
	-- function 22
	local _additional_hit_sounds_ids = self._additional_hit_sounds_ids

	if not _additional_hit_sounds_ids then
		return
	end

	local var_22_1 = _additional_hit_sounds_ids[arg_22_1]

	if not var_22_1 then
		return
	end

	local var_22_2 = _additional_hit_sounds_ids[var_22_1]

	if not var_22_2 then
		return
	end

	local index_of = table.index_of(var_22_2, arg_22_1)

	if index_of > 0 then
		table.swap_delete(var_22_2, index_of)

		_additional_hit_sounds_ids[arg_22_1] = nil

		if #var_22_2 == 0 then
			_additional_hit_sounds_ids[var_22_1] = nil

			local _additional_hit_sounds = self._additional_hit_sounds

			if not _additional_hit_sounds then
				local index_of_2 = table.index_of(_additional_hit_sounds, var_22_1)

				if index_of_2 > 0 then
					table.swap_delete(_additional_hit_sounds, index_of_2)

					if #_additional_hit_sounds == 0 then
						self._additional_hit_sounds = nil
					end
				end
			end
		end
	end
end
