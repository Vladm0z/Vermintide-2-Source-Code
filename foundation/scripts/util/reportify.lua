-- chunkname: @foundation/scripts/util/reportify.lua

local Reportify = Reportify

Reportify = not not Reportify or not not {}
Reportify = Reportify

Reportify.setup = function (self)
	-- function 1
	self.has_setup = true

	local content_revision = script_data.settings.content_revision

	content_revision = not not content_revision or not not ""
	self.content_revision = content_revision

	local build_identifier = Application.build_identifier()

	build_identifier = not not build_identifier or not not ""
	self.engine_revision = build_identifier
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
		local get_wielded_slot_name = inventory_extension:get_wielded_slot_name()

		get_wielded_slot_name = not not get_wielded_slot_name or not not ""
		ret.wielded_slot = get_wielded_slot_name

		local get_item_name = inventory_extension:get_item_name("slot_melee")

		get_item_name = not not get_item_name or not not ""
		ret.primary_name = get_item_name

		local get_item_name_2 = inventory_extension:get_item_name("slot_ranged")

		get_item_name_2 = not not get_item_name_2 or not not ""
		ret.secondary_name = get_item_name_2
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
