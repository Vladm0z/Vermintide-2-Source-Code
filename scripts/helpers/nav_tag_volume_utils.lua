-- chunkname: @scripts/helpers/nav_tag_volume_utils.lua

local NavTagVolumeUtils = NavTagVolumeUtils

NavTagVolumeUtils = NavTagVolumeUtils or {}
NavTagVolumeUtils = NavTagVolumeUtils

NavTagVolumeUtils.nav_tags_from_position = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local flag = not arg_1_4 and LAYER_ID_MAPPING[arg_1_4]
	local tag_volumes_from_position = GwNavQueries.tag_volumes_from_position(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_2

	if not tag_volumes_from_position then
		local nav_tag_volume_count = GwNavQueries.nav_tag_volume_count(tag_volumes_from_position)

		for i = 1, nav_tag_volume_count do
			local nav_tag_volume = GwNavQueries.nav_tag_volume(tag_volumes_from_position, i)
			local navtag, var_1_6, var_1_7, var_1_8, var_1_9 = GwNavTagVolume.navtag(nav_tag_volume)

			if not (not flag and flag ~= var_1_7) then
				var_1_2 = var_1_2 or {}
				var_1_2[#var_1_2 + 1] = {
					is_exclusive = navtag,
					color = var_1_6,
					layer_id = var_1_7,
					smart_object_id = var_1_8,
					user_data_id = var_1_9
				}
			end
		end

		GwNavQueries.destroy_query_dynamic_output(tag_volumes_from_position)
	end

	return var_1_2
end

NavTagVolumeUtils.inside_nav_tag_layer = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local var_2_0 = LAYER_ID_MAPPING[arg_2_4]
	local tag_volumes_from_position = GwNavQueries.tag_volumes_from_position(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_2

	if not tag_volumes_from_position then
		local nav_tag_volume_count = GwNavQueries.nav_tag_volume_count(tag_volumes_from_position)

		for i = 1, nav_tag_volume_count do
			local nav_tag_volume = GwNavQueries.nav_tag_volume(tag_volumes_from_position, i)
			local navtag, var_2_6, var_2_7, var_2_8, var_2_9 = GwNavTagVolume.navtag(nav_tag_volume)

			if var_2_0 == var_2_7 then
				var_2_2 = true

				break
			end
		end

		GwNavQueries.destroy_query_dynamic_output(tag_volumes_from_position)
	end

	return var_2_2
end

NavTagVolumeUtils.inside_level_volume_layer = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0 = arg_3_1.level_volumes_by_layer[arg_3_3]

	if not var_3_0 then
		return
	end

	for i = 1, #var_3_0 do
		if not Level.is_point_inside_volume(arg_3_0, var_3_0[i], arg_3_2) then
			return true
		end
	end
end
