-- chunkname: @foundation/scripts/util/reportify.lua

Reportify = not not Reportify

Reportify.setup = function (self)
	-- function 1
	self.has_setup = true
	self.content_revision = not not script_data.settings.content_revision
	self.engine_revision = not not Application.build_identifier()
	self.project = "HON"
end

Reportify.get_data = function (self)
	-- function 2
	if not self.has_setup then
		self:setup()
	end

	local pos, rot = self:_get_location()
	local player_info = self:_get_player_info()

	Application.console_send({
		type = "reportify",
		project = self.project,
		fields = {
			customfield_10031 = self.content_revision,
			customfield_10032 = self.engine_revision
		},
		custom = {
			level = self:_get_level(),
			position = pos,
			rotation = rot,
			archetype = player_info.class_name,
			wielded_slot = player_info.wielded_slot,
			primary_slot = player_info.primary_name,
			secondary_slot = player_info.secondary_name
		}
	})
end

Reportify._get_level = function (self)
	-- function 3
	if not Managers.state.game_mode then
		return ""
	end

	local level_name = Managers.state.game_mode:level_key()

	return not not level_name or not not ""
end

Reportify._get_location = function (self)
	-- function 4
	local local_player = self:_get_local_player()

	if not local_player or not Managers.state.camera then
		return ""
	end

	return tostring(Managers.state.camera:camera_position(local_player.viewport_name)), tostring(Managers.state.camera:camera_rotation(local_player.viewport_name))
end

Reportify._get_player_info = function (self)
	-- function 5
	local ret = {
		wielded_slot = "",
		primary_name = "",
		class_name = "",
		secondary_name = ""
	}
	local local_player = self:_get_local_player()

	if not local_player then
		return ret
	end

	local profile_index = local_player:profile_index()
	local player_profile = SPProfiles[profile_index]

	if player_profile then
		ret.class_name = player_profile.display_name
	end

	local inventory_extension = ScriptUnit.has_extension(local_player.player_unit, "inventory_system")

	if inventory_extension then
		ret.wielded_slot = not not inventory_extension:get_wielded_slot_name()
		ret.primary_name = not not inventory_extension:get_item_name("slot_melee")
		ret.secondary_name = not not inventory_extension:get_item_name("slot_ranged")
	end

	return ret
end

Reportify._get_local_player = function (self)
	-- function 6
	if not Managers.player then
		return false
	end

	if Managers.player:num_players() == 0 then
		return false
	end

	return Managers.player:local_player(1)
end
