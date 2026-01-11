local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "titi",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "titi",
   LoadingSubtitle = "by titi",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Light", -- Changed to Light for white background (instead of Default/black)

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
local MainTab = Window:CreateTab("Money inf 😭", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Money")

local InfiniteJumpEnabled = false
local connection

-- Changed to CreateToggle for on/off indicator
local InfiniteJumpToggle = MainTab:CreateToggle({
   Name = "inf jumps",
   CurrentValue = false,
   Flag = "InfiniteJump",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
      if InfiniteJumpEnabled then
         connection = game:GetService("UserInputService").JumpRequest:Connect(function()
            local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
            if humanoid then
               humanoid:ChangeState("Jumping")
            end
         end)
      else
         if connection then
            connection:Disconnect()
            connection = nil
         end
      end
   end,
})

local ESPEnabled = false
local ESPConnection

-- Changed to CreateToggle for on/off indicator
local ESPToggle = MainTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
      ESPEnabled = Value
      if ESPEnabled then
         for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
               local head = player.Character:FindFirstChild("Head")
               if head and not head:FindFirstChild("ESP") then
                  local billboard = Instance.new("BillboardGui")
                  billboard.Name = "ESP"
                  billboard.Adornee = head
                  billboard.Size = UDim2.new(0, 100, 0, 50)
                  billboard.StudsOffset = Vector3.new(0, 2, 0)
                  billboard.AlwaysOnTop = true
                  local text = Instance.new("TextLabel")
                  text.Text = player.Name
                  text.Size = UDim2.new(1, 0, 1, 0)
                  text.BackgroundTransparency = 1
                  text.TextColor3 = Color3.new(1, 1, 1)
                  text.TextStrokeTransparency = 0
                  text.Parent = billboard
                  billboard.Parent = head
               end
               -- Add white aura (Highlight) to the character
               if not player.Character:FindFirstChild("ESPHighlight") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "ESPHighlight"
                  highlight.FillColor = Color3.new(1, 1, 1) -- White fill
                  highlight.OutlineColor = Color3.new(1, 1, 1) -- White outline
                  highlight.FillTransparency = 0.5
                  highlight.OutlineTransparency = 0
                  highlight.Parent = player.Character
               end
            end
         end
         ESPConnection = game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Wait()
            local head = player.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("ESP") then
               local billboard = Instance.new("BillboardGui")
               billboard.Name = "ESP"
               billboard.Adornee = head
               billboard.Size = UDim2.new(0, 100, 0, 50)
               billboard.StudsOffset = Vector3.new(0, 2, 0)
               billboard.AlwaysOnTop = true
               local text = Instance.new("TextLabel")
               text.Text = player.Name
               text.Size = UDim2.new(1, 0, 1, 0)
               text.BackgroundTransparency = 1
               text.TextColor3 = Color3.new(1, 1, 1)
               text.TextStrokeTransparency = 0
               text.Parent = billboard
               billboard.Parent = head
            end
            -- Add white aura for new players
            if not player.Character:FindFirstChild("ESPHighlight") then
               local highlight = Instance.new("Highlight")
               highlight.Name = "ESPHighlight"
               highlight.FillColor = Color3.new(1, 1, 1)
               highlight.OutlineColor = Color3.new(1, 1, 1)
               highlight.FillTransparency = 0.5
               highlight.OutlineTransparency = 0
               highlight.Parent = player.Character
            end
         end)
      else
         for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
               local head = player.Character:FindFirstChild("Head")
               if head then
                  local esp = head:FindFirstChild("ESP")
                  if esp then
                     esp:Destroy()
                  end
               end
               local highlight = player.Character:FindFirstChild("ESPHighlight")
               if highlight then
                  highlight:Destroy()
               end
            end
         end
         if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
         end
      end
   end,
})

local HitboxSize = 5
local HitboxRange = 100
local HitboxEnabled = false
local HitboxConnection

local HitboxSizeSlider = MainTab:CreateSlider({
   Name = "Hitbox Size",
   Range = {1, 20},
   Increment = 0.1,
   Suffix = "Studs",
   CurrentValue = 5,
   Flag = "HitboxSize",
   Callback = function(Value)
      HitboxSize = Value
   end,
})

local HitboxRangeSlider = MainTab:CreateSlider({
   Name = "Hitbox Range",
   Range = {10, 500},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 100,
   Flag = "HitboxRange",
   Callback = function(Value)
      HitboxRange = Value
   end,
})

-- Changed to CreateToggle for on/off indicator
local HitboxToggle = MainTab:CreateToggle({
   Name = "Hitbox Expander",
   CurrentValue = false,
   Flag = "HitboxExpander",
   Callback = function(Value)
      HitboxEnabled = Value
      if HitboxEnabled then
         HitboxConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local localPlayer = game.Players.LocalPlayer
            local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not localRoot then return end
            for _, player in pairs(game.Players:GetPlayers()) do
               if player ~= localPlayer and player.Character then
                  local root = player.Character:FindFirstChild("HumanoidRootPart")
                  if root and (root.Position - localRoot.Position).Magnitude <= HitboxRange then
                     root.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                     root.Transparency = 0.7
                     root.BrickColor = BrickColor.new("Really blue")
                     root.Material = Enum.Material.Neon
                     root.CanCollide = false
                  end
               end
            end
         end)
      else
         if HitboxConnection then
            HitboxConnection:Disconnect()
            HitboxConnection = nil
         end
         for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
               local root = player.Character:FindFirstChild("HumanoidRootPart")
               if root then
                  root.Size = Vector3.new(2, 2, 1)
                  root.Transparency = 1
                  root.BrickColor = BrickColor.new("Medium stone grey")
                  root.Material = Enum.Material.Plastic
                  root.CanCollide = true
               end
            end
         end
      end
   end,
})

local AimbotEnabled = false
local FOV = 100
local AimbotConnection
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.new(1, 0, 0)
FOVCircle.Filled = false
FOVCircle.Visible = false
local AimbotKey = "E" -- Default key

local FOVSlider = MainTab:CreateSlider({
   Name = "Aimbot FOV",
   Range = {10, 200},
   Increment = 1,
   Suffix = "Degrees",
   CurrentValue = 100,
   Flag = "AimbotFOV",
   Callback = function(Value)
      FOV = Value
      local camera = workspace.CurrentCamera
      local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
      FOVCircle.Position = center
      FOVCircle.Radius = FOV * (camera.ViewportSize.Y / 180) / 2  -- approximate radius for half FOV
   end,
})

-- Dropdown to choose aimbot key
local AimbotKeyDropdown = MainTab:CreateDropdown({
   Name = "Aimbot Key",
   Options = {"E", "F", "Q", "R", "T", "Y"}, -- Add more if needed
   CurrentOption = "E",
   Flag = "AimbotKey",
   Callback = function(Option)
      AimbotKey = Option[1]
   end,
})

-- Changed to CreateToggle for on/off indicator
local AimbotToggle = MainTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(Value)
      AimbotEnabled = Value
      if AimbotEnabled then
         FOVCircle.Visible = true
         AimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local player = game.Players.LocalPlayer
            local camera = workspace.CurrentCamera
            local closest = nil
            local closestAngle = FOV / 2
            for _, p in pairs(game.Players:GetPlayers()) do
               if p ~= player and p.Character then
                  local head = p.Character:FindFirstChild("Head")
                  if head then
                     local direction = (head.Position - camera.CFrame.Position).Unit
                     local angle = math.acos(camera.CFrame.LookVector:Dot(direction)) * (180 / math.pi)
                     if angle < closestAngle then
                        closest = head
                        closestAngle = angle
                     end
                  end
               end
            end
            if closest then
               local targetCFrame = CFrame.new(camera.CFrame.Position, closest.Position)
               camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.3)  -- Increased strength (was 0.1)
            end
         end)
      else
         FOVCircle.Visible = false
         if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
         end
      end
   end,
})

-- Keybind listener (moved outside toggle callback to always work)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
   if not gameProcessed and input.KeyCode == Enum.KeyCode[AimbotKey] then
      AimbotToggle:Set(not AimbotEnabled)
   end
end)
