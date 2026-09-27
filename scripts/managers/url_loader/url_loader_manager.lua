-- chunkname: @scripts/managers/url_loader/url_loader_manager.lua

UrlLoaderManager = class(UrlLoaderManager)

if not UrlLoader then
	Application.warning("[UrlLoaderManager] UrlLoader doesnt exist in this engine branch!")

	UrlLoader = {}

	UrlLoader.init = function (arg_1_0)
		-- function 1
		return
	end

	UrlLoader.load_texture = function (arg_2_0, arg_2_1)
		-- function 2
		return 0
	end

	UrlLoader.unload = function (arg_3_0, arg_3_1)
		-- function 3
		return
	end

	UrlLoader.done = function (arg_4_0, arg_4_1)
		-- function 4
		return false
	end

	UrlLoader.success = function (arg_5_0, arg_5_1)
		-- function 5
		return false
	end

	UrlLoader.texture = function (arg_6_0, arg_6_1)
		-- function 6
		return nil
	end

	UrlLoader.update = function (arg_7_0)
		-- function 7
		return
	end

	UrlLoader.destroy = function (arg_8_0)
		-- function 8
		return
	end

	UrlLoader.is_stub = true
end

UrlLoaderManager.init = function (self)
	-- function 9
	if not UrlLoader.is_stub then
		self._url_loader = UrlLoader()
	end

	self._jobs = {}
	self._url_jobs = {}
	self._texture_resources = {}
	self._reference_counters = {}
	self._reference_callbacks = {}
	self._cleanup = false
end

UrlLoaderManager.load_resource = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	arg_10_4 = arg_10_4 or arg_10_2
	arg_10_5 = arg_10_5 or "1"
	arg_10_6 = arg_10_6 or "downloaded_textures"

	if not self._jobs[arg_10_4] then
		local load_texture = UrlLoader.load_texture(self._url_loader, arg_10_2, arg_10_4, arg_10_5, arg_10_6)
		local tbl = {
			url_job = load_texture,
			cache_key = arg_10_4,
			cache_version = arg_10_5,
			texture_category = arg_10_6
		}

		self._jobs[arg_10_4] = tbl
		self._url_jobs[arg_10_4] = load_texture
	end

	if not self._reference_counters[arg_10_4] then
		self._reference_counters[arg_10_4] = {}
	end

	if not self._reference_callbacks[arg_10_4] then
		self._reference_callbacks[arg_10_4] = {}
	end

	self._reference_counters[arg_10_4][arg_10_1] = true
	self._reference_callbacks[arg_10_4][arg_10_1] = arg_10_3
end

UrlLoaderManager.unload_resource = function (self, arg_11_1)
	-- function 11
	local _reference_counters = self._reference_counters
	local _reference_callbacks = self._reference_callbacks
	local var_11_2

	for k, v in pairs(_reference_counters) do
		if not v[arg_11_1] then
			var_11_2 = k
			v[arg_11_1] = nil
			_reference_callbacks[k][arg_11_1] = nil

			if not next(v) then
				return
			else
				break
			end
		end
	end

	fassert(var_11_2, "Could not find any Cache key for reference (%s)", arg_11_1)

	local _jobs = self._jobs
	local _url_jobs = self._url_jobs
	local var_11_5 = _url_jobs[var_11_2]
	local _url_loader = self._url_loader

	UrlLoader.unload(_url_loader, var_11_5)

	_jobs[var_11_2] = nil
	_url_jobs[var_11_2] = nil
	self._texture_resources[var_11_2] = nil
	self._cleanup = true
end

UrlLoaderManager._on_job_complete = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _url_loader = self._url_loader
	local url_job = arg_12_1.url_job
	local cache_key = arg_12_1.cache_key

	if not arg_12_2 then
		local texture = UrlLoader.texture(_url_loader, url_job)

		self._texture_resources[cache_key] = texture
	else
		local var_12_4 = self._reference_counters[cache_key]
		local var_12_5 = self._reference_callbacks[cache_key]

		for k, v in pairs(var_12_5) do
			v(nil)

			var_12_5[k] = nil
			var_12_4[k] = nil
		end

		UrlLoader.unload(_url_loader, url_job)

		self._url_jobs[cache_key] = nil
	end

	self._jobs[cache_key] = nil
end

UrlLoaderManager.update = function (self, arg_13_1)
	-- function 13
	local _url_loader = self._url_loader
	local _jobs = self._jobs

	for k, v in pairs(_jobs) do
		local url_job = v.url_job

		if not UrlLoader.done(_url_loader, url_job) then
			local success = UrlLoader.success(_url_loader, url_job)

			self:_on_job_complete(v, success)
		end
	end

	local _texture_resources = self._texture_resources
	local _reference_callbacks = self._reference_callbacks

	for k_2, v_2 in pairs(_reference_callbacks) do
		local var_13_6 = _texture_resources[k_2]

		if not var_13_6 then
			for k_3, v_3 in pairs(v_2) do
				v_3(var_13_6)

				v_2[k_3] = nil
			end
		end
	end
end

UrlLoaderManager.post_render = function (self)
	-- function 14
	if not self._cleanup then
		local _url_loader = self._url_loader

		UrlLoader.update(_url_loader)

		self._cleanup = false
	end
end

UrlLoaderManager.destroy = function (self)
	-- function 15
	local _url_loader = self._url_loader
	local _url_jobs = self._url_jobs
	local _texture_resources = self._texture_resources

	for k, v in pairs(_texture_resources) do
		local var_15_3 = _url_jobs[k]

		UrlLoader.unload(_url_loader, var_15_3)
	end

	local _reference_counters = self._reference_counters

	for k_2, v_2 in pairs(_reference_counters) do
		for k_3, v_3 in pairs(v_2) do
			Application.warning(string.format("[UrlLoaderManager] - [Destroy] - Found existing reference to Cache key: (%s), Reference name: (%s)", k_2, k_3))
		end
	end

	UrlLoader.update(_url_loader)
	UrlLoader.destroy(_url_loader)

	self._url_loader = nil
	self._jobs = nil
	self._url_jobs = nil
	self._texture_resources = nil
	self._reference_counters = nil
	self._reference_callbacks = nil
end
