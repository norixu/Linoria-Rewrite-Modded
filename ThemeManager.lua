local httpService = game:GetService('HttpService')
local ThemeManager = {} do
	ThemeManager.Folder = 'LinoriaLibSettings'
	ThemeManager.Library = nil
	ThemeManager.BuiltInThemes = {
		['Default'] 		= { 1, httpService:JSONDecode('{"FontColor":"BFBFBF","MainColor":"0F0F0F","AccentColor":"929667","SelectedTabColor":"101010","BackgroundColor":"1B1B1B","OutlineColor":"0B0B0B"}') },
		['GameSense'] 		= { 2, httpService:JSONDecode('{"FontColor":"919191","MainColor":"101010","AccentColor":"9CB819","SelectedTabColor":"101010","BackgroundColor":"111111","OutlineColor":"2D2D2D"}') },
		['Comet.pub'] 		= { 3, httpService:JSONDecode('{"FontColor":"5E5E5E","MainColor":"0F0F0F","AccentColor":"5D589D","SelectedTabColor":"1a191d","BackgroundColor":"0F0F0F","OutlineColor":"191919"}') },
		['Tokyohook.cc'] 	= { 4, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","SelectedTabColor":"1a1a29","BackgroundColor":"16161f","OutlineColor":"433e58"}') },
		['pandahook.cc'] 	= { 5, httpService:JSONDecode('{"FontColor":"AEAEAE","MainColor":"0F0F0F","AccentColor":"30406A","SelectedTabColor":"151515","BackgroundColor":"0F0F0F","OutlineColor":"171717"}') },
		['Mae.lua'] 	        = { 6, httpService:JSONDecode('{"FontColor":"c5c5c5","MainColor":"0F0F0F","AccentColor":"ffc6fe","SelectedTabColor":"171717","BackgroundColor":"0f0f0f","OutlineColor":"191919"}') },
	}

	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		local data = customThemeData or self.BuiltInThemes[theme]

		if not data then return end

		local scheme = data[2]
		for idx, col in next, customThemeData or scheme do
			-- FIX: pcall added for color loading safety
			local success, color = pcall(Color3.fromHex, col)
			if success then
				self.Library[idx] = color
				
				if Options[idx] then
					Options[idx]:SetValueRGB(color)
				end
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		local options = { "FontColor", "MainColor", "AccentColor", "SelectedTabColor", "BackgroundColor", "OutlineColor" }
		for i, field in next, options do
			if Options and Options[field] then
				self.Library[field] = Options[field].Value
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:LoadDefault()		
		local theme = 'Tokyohook.cc'
		local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

		local isDefault = true
		if content then
			if self.BuiltInThemes[content] then
				theme = content
			elseif self:GetCustomTheme(content) then
				theme = content
				isDefault = false;
			end
		elseif self.BuiltInThemes[self.DefaultTheme] then
			 theme = self.DefaultTheme
		end

		if isDefault then
			if Options.ThemeManager_ThemeList then
				Options.ThemeManager_ThemeList:SetValue(theme)
			end
		else
			self:ApplyTheme(theme)
		end
	end

	function ThemeManager:SaveDefault(theme)
		if (not theme) then return end
		writefile(self.Folder .. '/themes/default.txt', theme)
	end

	function ThemeManager:CreateThemeManager(groupbox)
        groupbox:AddDivider()
		groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('Main color')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
        groupbox:AddLabel('Selected tab color'):AddColorPicker('SelectedTabColor', { Default = self.Library.SelectedTabColor });
		groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('Font color')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });

		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })

		groupbox:AddButton('Set as default', function()
			local theme = Options.ThemeManager_ThemeList.Value
			if (not theme) then return end
			self:SaveDefault(theme)
			self.Library:Notify(string.format('Set default theme to %q', theme))
		end)

		Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
		end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'Custom themes', Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
		groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Custom theme name' })

		groupbox:AddButton('Load theme', function() 
			local theme = Options.ThemeManager_CustomThemeList.Value
			if (not theme) then return end
			self:ApplyTheme(theme) 
		end):AddButton('Save theme', function() 
			local name = Options.ThemeManager_CustomThemeName.Value
			if name:gsub(' ', '') == '' then 
				return self.Library:Notify('Invalid custom theme name', 2)
			end

			self:SaveCustomTheme(name)

			Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
			Options.ThemeManager_CustomThemeList:SetValues()
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddButton('Refresh list', function()
			Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
			Options.ThemeManager_CustomThemeList:SetValues()
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddButton('Set as default', function()
			local theme = Options.ThemeManager_CustomThemeList.Value
			if theme ~= nil and theme ~= '' then
				self:SaveDefault(theme)
				self.Library:Notify(string.format('Set default theme to %q', theme))
			end
		end)

		ThemeManager:LoadDefault()

		local function UpdateTheme()
			self:ThemeUpdate()
		end

		Options.BackgroundColor:OnChanged(UpdateTheme)
		Options.MainColor:OnChanged(UpdateTheme)
		Options.AccentColor:OnChanged(UpdateTheme)
        Options.SelectedTabColor:OnChanged(UpdateTheme)
		Options.OutlineColor:OnChanged(UpdateTheme)
		Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:GetCustomTheme(file)
		if (not file) then return end
		local path = self.Folder .. '/themes/' .. file .. '.json'
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(httpService.JSONDecode, httpService, data)
		
		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(' ', '') == '' then
			return self.Library:Notify('Invalid file name for theme (empty)', 3)
		end

		local theme = {}
		local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor", "SelectedTabColor" }

		for _, field in next, fields do
			theme[field] = Options[field].Value:ToHex()
		end

		writefile(self.Folder .. '/themes/' .. file .. '.json', httpService:JSONEncode(theme))
	end

	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. '/themes')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- FIX: improved path parsing to be more robust
				local parts = file:split('/')
				local name = parts[#parts]:sub(1, -6)
				table.insert(out, name)
			end
		end

		return out
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:BuildFolderTree()
		local paths = {}
		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end

		table.insert(paths, self.Folder .. '/themes')
		table.insert(paths, self.Folder .. '/settings')

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('Themes')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end
return ThemeManager
