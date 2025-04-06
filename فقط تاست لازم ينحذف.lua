-- تحميل مكتبة OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- إنشاء نافذة OrionLib
local Window = OrionLib:MakeWindow({
    Name = "حرب الوقت🌙 | تحديث رمضان",               
    HidePremium = false,                 
    SaveConfig = true,                   
    ConfigFolder = "MemorizationFolder",  
    IntroEnabled = true,                 
    IntroText = "مرحبًا بك في السكربت!", 
    IntroIcon = "rbxassetid://126134195307252", 
    Icon = "rbxassetid://126134195307252",  
    CloseCallback = function()           
        print("تم إغلاق النافذة")
    end
})

local Tab6 = Window:MakeTab({
    Name = "🖥️ السيرفر",
    Icon = "rbxassetid://72014020558816",
    PremiumOnly = false
})
-- إنشاء التبويبات
local Tab1 = Window:MakeTab({
    Name = "⚔️ القتل",
    Icon = "rbxassetid://92250922486804",
    PremiumOnly = false
})

local Tab = Window:MakeTab({
	Name = "⏳ الميزات التلقائية",
	Icon = "rbxassetid://129435090120413",
	PremiumOnly = false
})

local Tab4 = Window:MakeTab({
	Name = "🛡️ الأمان",
	Icon = "rbxassetid://77954204526315",
	PremiumOnly = false
})

local Tab2 = Window:MakeTab({
    Name = "🌀 الانتقالات",
    Icon = "rbxassetid://113601298125949",
    PremiumOnly = false
})

local Tab5 = Window:MakeTab({
    Name = "🏦 البنك",
    Icon = "rbxassetid://92245131701845",
    PremiumOnly = false
})

local Tab3 = Window:MakeTab({
    Name = "معلومات السكربت/التحديث",
    Icon = "rbxassetid://134011743532285",
    PremiumOnly = false
})

-- 🛡️ قسم الحماية
Tab4:AddSection({ Name = "🛡️ الأمان" })

-- متغير لحالة التشغيل
local toggle = false 


-- زر تفعيل / إيقاف الحماية
Tab4:AddToggle({
    Name = "🚀 الحماية من سرقة الوقت (99%)",
    Default = false,
    Callback = function(Value)
        toggle = Value
        print("حالة الحماية:", toggle)
    end
})

-- المتغيرات الأساسية
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local targetPosition = Vector3.new(-7.13, 3.77, 1.05) -- إحداثيات النقل

-- وظيفة فحص الصحة والنقل عند الحاجة
local function checkHealth()
    if not toggle then return end

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health < humanoid.MaxHealth then -- تم التعديل هنا
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = CFrame.new(targetPosition)
            end
        end
    end
end

-- تحديث الحالة بانتظام
runService.Heartbeat:Connect(function()
    checkHealth()
end)

-- تشغيل الفحص كل إطار
runService.RenderStepped:Connect(checkHealth)

-----------------------------------------------
















local PlayerNameInput = ""
local FinalPlayerName = ""
local Amount = 1
local AutoTransfer = false
local AutoTransferConnection

function FindPlayerByPartialName(partial)
	local matches = {}
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Name:lower():sub(1, #partial) == partial:lower() then
			table.insert(matches, player.Name)
		end
	end
	if #matches == 1 then
		return matches[1] -- لاعب واحد فقط مطابق
	else
		return nil -- أكثر من لاعب أو مافي أحد
	end
end

Tab5:AddTextbox({
	Name = "اسم اللاعب",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
		PlayerNameInput = Value
		if #Value >= 2 then
			local foundName = FindPlayerByPartialName(Value)
			if foundName then
				FinalPlayerName = foundName
				OrionLib:MakeNotification({
					Name = "تم العثور على اللاعب",
					Content = "تم اختيار: "..FinalPlayerName,
					Image = "rbxassetid://4483345998",
					Time = 3
				})
			else
				FinalPlayerName = ""
			end
		else
			FinalPlayerName = ""
		end
	end
})

Tab5:AddTextbox({
	Name = "المبلغ",
	Default = "1",
	TextDisappear = false,
	Callback = function(Value)
		local number = tonumber(Value)
		if number then
			Amount = number
		else
			Amount = 1
		end
	end
})

Tab5:AddButton({
	Name = "تحويل المبلغ",
	Callback = function()
		if FinalPlayerName ~= "" then
			local args = {
				[1] = Amount,
				[2] = FinalPlayerName
			}
			game:GetService("ReplicatedStorage").Remote.RemoteEvents.Bank.Transfer:FireServer(unpack(args))
			OrionLib:MakeNotification({
				Name = "تم التحويل",
				Content = "تم تحويل "..Amount.." إلى "..FinalPlayerName,
				Image = "rbxassetid://4483345998",
				Time = 3
			})
		else
			OrionLib:MakeNotification({
				Name = "خطأ",
				Content = "الاسم غير مكتمل أو يوجد أكثر من لاعب متشابه!",
				Image = "rbxassetid://4483345998",
				Time = 3
			})
		end
	end    
})

Tab5:AddToggle({
	Name = "تحويل تلقائي(بشكل متكرر) ",
	Default = false,
	Callback = function(Value)
		AutoTransfer = Value
		if AutoTransfer then
			AutoTransferConnection = task.spawn(function()
				while AutoTransfer do
					if FinalPlayerName ~= "" then
						local args = {
							[1] = Amount,
							[2] = FinalPlayerName
						}
						game:GetService("ReplicatedStorage").Remote.RemoteEvents.Bank.Transfer:FireServer(unpack(args))
					end
					task.wait(1) -- تحويل كل ثانية (تقدر تغيرها لو تبغى)
				end
			end)
		else
			if AutoTransferConnection then
				task.cancel(AutoTransferConnection)
			end
		end
	end
})



















Tab5:AddSection({ Name = "" })




local withdrawalAmount = 10
local isWithdrawing = false
local withdrawDelay = 0.1  -- القيمة الافتراضية

-- خانة المبلغ
Tab5:AddTextbox({
    Name = "المبلغ للسحب",
    Default = tostring(withdrawalAmount),
    Description = "أدخل المبلغ (أرقام فقط)",
    Callback = function(Value)
        local filtered = Value:gsub("%D", "")
        local num = tonumber(filtered)

        if num then
            withdrawalAmount = num
            OrionLib:MakeNotification({
                Name = "تم التحديث",
                Content = "المبلغ الجديد للسحب: " .. tostring(withdrawalAmount),
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "خطأ",
                Content = "يرجى إدخال رقم فقط!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

-- القائمة المنسدلة لاختيار السرعة
Tab5:AddDropdown({
    Name = "سرعة السحب التلقائي",
    Default = "0.1 ثانية",
    Options = {"0.1 ثانية", "0.5 ثانية", "1 ثانية", "2 ثانية"},
    Callback = function(Selected)
        if Selected == "0.1 ثانية" then
            withdrawDelay = 0.1
        elseif Selected == "0.5 ثانية" then
            withdrawDelay = 0.5
        elseif Selected == "1 ثانية" then
            withdrawDelay = 1
        elseif Selected == "2 ثانية" then
            withdrawDelay = 2
        end
    end
})

-- زر لسحب مرة واحدة
Tab5:AddButton({
    Name = "سحب الآن",
    Callback = function()
        local args = {withdrawalAmount}
        game:GetService("ReplicatedStorage").Remote.RemoteEvents.Bank.Withdraw:FireServer(unpack(args))
        OrionLib:MakeNotification({
            Name = "تم السحب",
            Content = "سُحب " .. tostring(withdrawalAmount),
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

-- زر التشغيل التلقائي
Tab5:AddToggle({
    Name = "السحب التلقائي",
    Default = false,
    Callback = function(Value)
        isWithdrawing = Value
        if isWithdrawing then
            OrionLib:MakeNotification({
                Name = "بدأ السحب التلقائي",
                Content = "يتم السحب كل " .. tostring(withdrawDelay) .. " ثانية.",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
            task.spawn(function()
                while isWithdrawing do
                    local args = {withdrawalAmount}
                    game:GetService("ReplicatedStorage").Remote.RemoteEvents.Bank.Withdraw:FireServer(unpack(args))
                    task.wait(withdrawDelay)
                end
            end)
        else
            OrionLib:MakeNotification({
                Name = "إيقاف السحب",
                Content = "تم إيقاف السحب التلقائي.",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})



















Tab5:AddSection({ Name = "" })









local ToggleState = false

Tab5:AddToggle({
    Name = "💸حفظ الوقت في البنك (تلقائي)",
    Default = false,
    Callback = function(Value)
        ToggleState = Value
        if ToggleState then
            task.spawn(function()
                while ToggleState do
                    local args = {
                        [1] = 9000000000000000000
                    }
                    game:GetService("ReplicatedStorage").Remote.RemoteEvents.Bank.Deposit:FireServer(unpack(args))
                    task.wait(0.1)
                end
            end)
        end
    end
})










local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local isEnabled = false
local activeTags = {}
local tagConnections = {} -- لتخزين الاتصالات لكل لاعب
local maxDistance = 50

-- دالة تنسيق الرقم وإضافة الفاصلة
local function formatNumber(number)
    local formatted = tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return formatted:sub(1, 1) == "," and formatted:sub(2) or formatted
end

local function CreateBankTag(player)
    if player == LocalPlayer or activeTags[player] then return end  

    local function SetupTag()
        if not isEnabled then return end  
        
        local Character = player.Character
        if not Character then return end  

        -- التأكد من تحميل الرأس
        local Head = Character:WaitForChild("Head", 5)
        local BankValue = player:FindFirstChild("Bank")
        if not Head or not BankValue or not BankValue:IsA("NumberValue") then return end  

        -- حذف أي علامة سابقة والاتصال الخاص بها
        if activeTags[player] then
            activeTags[player]:Destroy()
            activeTags[player] = nil
        end
        if tagConnections[player] then
            tagConnections[player]:Disconnect()
            tagConnections[player] = nil
        end

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "BankTag"
        Billboard.Adornee = Head
        Billboard.Size = UDim2.new(4, 0, 1.5, 0)
        Billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        Billboard.AlwaysOnTop = true
        Billboard.Parent = Head

        local Frame = Instance.new("Frame", Billboard)
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BackgroundTransparency = 0.3
        Frame.BorderSizePixel = 0

        local UICorner = Instance.new("UICorner", Frame)
        UICorner.CornerRadius = UDim.new(0.2, 0)

        local UIStroke = Instance.new("UIStroke", Frame)
        UIStroke.Thickness = 2
        UIStroke.Color = Color3.fromRGB(255, 215, 0)
        UIStroke.Transparency = 0.3

        local TextLabel = Instance.new("TextLabel", Frame)
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextStrokeTransparency = 0.2
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.Text = player.Name .. "\n💰 بنك: " .. formatNumber(BankValue.Value)

        activeTags[player] = Billboard

        -- دالة تغيير اللون عند تحديث المال
        local function animateColorChange()
            local tweenGreen = TweenService:Create(TextLabel, TweenInfo.new(1.5), { TextColor3 = Color3.fromRGB(0, 255, 0) })
            tweenGreen:Play()
            tweenGreen.Completed:Connect(function()
                local tweenBack = TweenService:Create(TextLabel, TweenInfo.new(1.5), { TextColor3 = Color3.fromRGB(255, 255, 0) })
                tweenBack:Play()
            end)
        end

        BankValue:GetPropertyChangedSignal("Value"):Connect(function()
            TextLabel.Text = player.Name .. "\n💰 بنك: " .. formatNumber(BankValue.Value)
            animateColorChange()
        end)

        -- تحريك القائمة للأعلى والأسفل بشكل سلس
        task.spawn(function()
            while Billboard.Parent do
                local tweenUp = TweenService:Create(Billboard, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { StudsOffset = Vector3.new(0, 2.6, 0) })
                local tweenDown = TweenService:Create(Billboard, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { StudsOffset = Vector3.new(0, 2.4, 0) })
                tweenUp:Play()
                tweenUp.Completed:Wait()
                tweenDown:Play()
                tweenDown.Completed:Wait()
            end
        end)

        -- التحكم في ظهور القائمة حسب المسافة باستخدام اتصال واحد
        tagConnections[player] = RunService.RenderStepped:Connect(function()
            if not isEnabled or not player.Character or not LocalPlayer.Character then return end
            local PlayerRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local LocalRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if PlayerRoot and LocalRoot then
                local distance = (PlayerRoot.Position - LocalRoot.Position).Magnitude
                Billboard.Enabled = distance <= maxDistance
            end
        end)
    end

    -- إعادة إنشاء العلامة عند إعادة إحياء اللاعب
    player.CharacterAdded:Connect(function()
        task.wait(1)
        SetupTag()
    end)

    SetupTag()
end

local function RemoveAllBankTags()
    for player, tag in pairs(activeTags) do
        if tag then
            tag:Destroy()
        end
    end
    activeTags = {}
    for player, conn in pairs(tagConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    tagConnections = {}
end

-- زر تفعيل وإيقاف العلامات
Tab5:AddToggle({
    Name = "🏦 إظهار وقت اللاعبين داخل البنك",
    Default = false,
    Callback = function(value)
        isEnabled = value
        if isEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                CreateBankTag(player)
            end
        else
            RemoveAllBankTags()
        end
    end
})

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if isEnabled then
            CreateBankTag(player)
        end
    end)
end)






























Tab5:AddSection({ Name = "" })


















Tab5:AddButton({
    Name = "💸 حفظ جميع الوقت في البنك",
    Callback = function()
        local args = {
            [1] = 9000000000000000000  -- المبلغ الذي سيتم إيداعه
        }

        -- استدعاء الريموت إيفينت الخاص بالإيداع
        game:GetService("ReplicatedStorage").Remote.RemoteEvents.Bank.Deposit:FireServer(unpack(args))
    end
})











Tab5:AddButton({
    Name = "💰 سحب جميع الوقت",
    Callback = function()
        -- عملية سحب المال لمرة واحدة
        local args = {
            [1] = 9000000000000000000  -- المبلغ الذي سيتم سحبه
        }

        -- استدعاء الريموت إيفينت الخاص بالسحب
        game:GetService("ReplicatedStorage").Remote.RemoteEvents.Bank.Withdraw:FireServer(unpack(args))
    end
})








local protectionEnabled = false
local connection -- مرجع إلى وظيفة RenderStepped لإيقافها عند الحاجة

Tab4:AddToggle({
    Name = "🛡️ الحماية من الهجوم",
    Default = false,
    Callback = function(Value)
        protectionEnabled = Value
        print("🚀 حالة الحماية:", protectionEnabled)

        -- إذا تم تعطيل الحماية، قم بإيقاف تشغيل الوظيفة
        if not protectionEnabled then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            return
        end

        -- المتغيرات الأساسية
        local player = game.Players.LocalPlayer
        local runService = game:GetService("RunService")
        local safeTeleportPosition = Vector3.new(1.36, 4.00, 0.25) -- إحداثيات المنطقة الآمنة
        local detectionDistance = 20 -- المسافة المطلوبة لكشف المهاجم

        -- حدود المنطقة الآمنة (المربع)
        local safeZoneMin = Vector3.new(-40.51, 3.23, -41.38)
        local safeZoneMax = Vector3.new(40.59, 3.23, 40.56)

        -- دالة التحقق مما إذا كانت نقطة معينة داخل المنطقة الآمنة (نقوم بالمقارنة على X و Z فقط)
        local function isInsideSafeArea(position)
            return position.X >= safeZoneMin.X and position.X <= safeZoneMax.X and
                   position.Z >= safeZoneMin.Z and position.Z <= safeZoneMax.Z
        end

        -- وظيفة التحقق من وجود لاعب مهاجم قريب
        local function checkForPlayers()
            if not protectionEnabled then return end
            local character = player.Character
            if not character then return end

            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end

            -- إذا كان اللاعب المحلي داخل المنطقة المحمية، لا نقوم بأي شيء
            if isInsideSafeArea(rootPart.Position) then
                return
            end

            -- التحقق من كل لاعب آخر
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if otherRoot then
                        -- إذا كان اللاعب الآخر داخل المنطقة المحمية، نتجاهله
                        if isInsideSafeArea(otherRoot.Position) then
                            -- بدلاً من إنهاء الدالة، ننتقل إلى اللاعب التالي
                        else
                            local distance = (rootPart.Position - otherRoot.Position).Magnitude
                            if distance < detectionDistance then
                                -- نقل اللاعب المحلي إلى المنطقة الآمنة
                                rootPart.CFrame = CFrame.new(safeTeleportPosition)
                                game:GetService("StarterGui"):SetCore("SendNotification", {
                                    Title = "⚠️ خطر!",
                                    Text = "تم الانتقال إلى المنطقة الآمنة لتجنب الهجوم!",
                                    Duration = 3
                                })
                                return
                            end
                        end
                    end
                end
            end
        end

        -- تشغيل المراقبة كل إطار وإمكانية إيقافها عند تعطيل السكربت
        connection = runService.RenderStepped:Connect(checkForPlayers)
    end
})







-----------------------------------------------------------
local revengeActive = false
local lastDeathPosition = nil          -- موقع موت اللاعب
local safeZonePosition = Vector3.new(-7.13, 3.77, 1.05)  -- المنطقة الآمنة
local attackRange = 15                 -- نطاق البحث عن هدف
local killTimeout = 6                  -- المهلة قبل التوقف (ثوانٍ)
local attackLoopConnection = nil       -- لاتصال حلقة الهجوم
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-----------------------------------------------------------
-- دالة تجهيز الـ Tool (السيف)
-----------------------------------------------------------
local function equipTool()
    local character = LocalPlayer.Character
    if not character then return nil end

    local tool = character:FindFirstChildOfClass("Tool")
    if tool then 
        return tool 
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        local availableTool = backpack:FindFirstChildOfClass("Tool")
        if availableTool then
            availableTool.Parent = character
            return availableTool
        end
    end
    return nil
end

-- دالة تضمن تجهيز الـ Tool بشكل متكرر حتى يتم الحصول عليه
local function ensureToolEquipped(timeout)
    timeout = timeout or 2  -- مهلة افتراضية 2 ثانية
    local startTime = tick()
    local tool = equipTool()
    while not tool and tick() - startTime < timeout do
        task.wait(0.05)
        tool = equipTool()
    end
    return tool
end

-----------------------------------------------------------
-- دالة الهجوم على الهدف داخل النطاق
-----------------------------------------------------------
local function attackEnemy(enemy)
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- تجهيز الـ Tool بشكل متكرر حتى يتوفر
    local tool = ensureToolEquipped()
    if not tool or not tool:FindFirstChild("Handle") then return end

    -- بدء حلقة الهجوم باستخدام Heartbeat بدون تأخير
    attackLoopConnection = RunService.Heartbeat:Connect(function()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health > 0 then
            local enemyRoot = enemy.Character:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                -- نقل اللاعب فوق الهدف بمسافة 5 وحدات بشكل مستمر
                rootPart.CFrame = enemyRoot.CFrame + Vector3.new(0, 5, 0)
            end
            -- تأكد من تجهيز الـ Tool مرة أخرى إذا لزم الأمر
            tool = ensureToolEquipped()
            if tool and tool:FindFirstChild("Handle") then
                tool:Activate()
                for _, part in ipairs(enemy.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        firetouchinterest(tool.Handle, part, 0)
                        firetouchinterest(tool.Handle, part, 1)
                    end
                end
            end
        else
            -- عند عدم وجود هدف (أي الهدف مات أو خرج من النطاق)
            if rootPart then
                rootPart.CFrame = CFrame.new(safeZonePosition)
            end
            if attackLoopConnection then
                attackLoopConnection:Disconnect()
                attackLoopConnection = nil
            end
        end
    end)
end

-----------------------------------------------------------
-- دالة البحث عن هدف داخل النطاق
-----------------------------------------------------------
local function findTarget(deathPos)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - deathPos).Magnitude
            if dist <= attackRange then
                return p
            end
        end
    end
    return nil
end

-----------------------------------------------------------
-- تسجيل موقع موت اللاعب
-----------------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            lastDeathPosition = root.Position
        end
    end)
end)

-----------------------------------------------------------
-- عند إعادة إحياء اللاعب، النقل إلى موقع الموت والبدء بالهجوم
-----------------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(character)
    task.defer(function()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        if revengeActive and lastDeathPosition then
            -- نقل اللاعب فوراً إلى موقع الموت
            rootPart.CFrame = CFrame.new(lastDeathPosition)
            task.wait(0.01)  -- تأخير بسيط جدًا لضمان النقل
            -- البحث عن هدف ضمن النطاق attackRange
            local targetEnemy = findTarget(lastDeathPosition)
            if targetEnemy then
                attackEnemy(targetEnemy)
            else
                -- إذا لم يُوجد هدف فورًا، العودة إلى المنطقة الآمنة
                rootPart.CFrame = CFrame.new(safeZonePosition)
            end
        end
    end)
end)

-----------------------------------------------------------
-- زر تبديل لتفعيل / تعطيل النظام باستخدام OrionLib
-----------------------------------------------------------
Tab4:AddToggle({
    Name = "🛡️ نظام الانتقام عند الموت",
    Default = false,
    Callback = function(Value)
        revengeActive = Value
        if not revengeActive and attackLoopConnection then
            attackLoopConnection:Disconnect()
            attackLoopConnection = nil
        end
    end
})

Tab4:AddLabel("هناك شرط حتا يعمل (نظام الانتقام) وهو ان يتم قتلك مرة وحدة فقط و بعدها يمكنك تشغيه")






-----------------------------------------------------------
-- المتغيرات الأساسية
-----------------------------------------------------------
local returnActive = false
local lastDeathPosition = nil  -- موقع موت اللاعب
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-----------------------------------------------------------
-- تسجيل موقع موت اللاعب
-----------------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            lastDeathPosition = root.Position
        end
    end)
end)

-----------------------------------------------------------
-- عند إعادة الإحياء، النقل إلى موقع الموت بسرعة فائقة
-----------------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(character)
    task.defer(function()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        if returnActive and lastDeathPosition then
            -- النقل الفوري إلى موقع الموت
            rootPart.CFrame = CFrame.new(lastDeathPosition)
        end
    end)
end)

-----------------------------------------------------------
-- زر تبديل لتفعيل / تعطيل النظام باستخدام OrionLib
-----------------------------------------------------------
Tab4:AddToggle({
    Name = "⚡ العودة الفورية إلى موقع الموت",
    Default = false,
    Callback = function(Value)
        returnActive = Value
    end
})




-- الكود التالي يفترض أنك قمت بتحميل OrionLib وإنشاء نافذة وتبويب مسبقاً،
-- والآن نضيف فقط زر Toggle الخاص بنظام الكشف عن الغش ونظام المراقبة.

-- تحميل الخدمات الضرورية
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- إعداد المعايير
local killThreshold = 3         -- عدد القتلات المشبوهة خلال الإطار الزمني
local timeFrame = 6            -- الإطار الزمني (بالثواني) لحساب القتلات السريعة
local suspectDistance = 13       -- المسافة (بالمحاور) التي تُعتبر قتلًا عن بُعد إذا تجاوزتها
local notificationCooldown = 5  -- فترة التهدئة (بالثواني) بين الإشعارات لنفس اللاعب

-- جداول لتتبع القتلات وفترات التهدئة لكل لاعب
local killLog = {}
local notificationCooldowns = {}

-- متغير لتفعيل النظام
monitoringActive = false  -- يجب تعريفه كمتغير عام لاستخدامه في السكربتات الأخرى

-- دالة لإظهار الإشعارات على الشاشة؛ يظهر اسم اللاعب في العنوان ونوع الشبهة في النص
local function showNotification(playerName, reason)
    StarterGui:SetCore("SendNotification", {
        Title = playerName,
        Text = reason,
        Duration = 10
    })
end

-- دالة للتحقق من القتلات السريعة
local function checkRapidKills(killer)
    if not monitoringActive then return end
    local now = tick()
    if not killLog[killer.UserId] then
        killLog[killer.UserId] = {}
    end

    -- إضافة وقت القتل للسجل
    table.insert(killLog[killer.UserId], now)

    -- إزالة القتلات القديمة التي تجاوزت الإطار الزمني
    for i = #killLog[killer.UserId], 1, -1 do
        if now - killLog[killer.UserId][i] > timeFrame then
            table.remove(killLog[killer.UserId], i)
        end
    end

    local killsCount = #killLog[killer.UserId]
    local totalPlayers = #Players:GetPlayers()

    if killsCount >= killThreshold then
        if not notificationCooldowns[killer.UserId] or (now - notificationCooldowns[killer.UserId] > notificationCooldown) then
            showNotification(killer.Name, "قتل سريع مشبوه!")
            notificationCooldowns[killer.UserId] = now
        end
    end

    if killsCount >= (totalPlayers - 1) then
        if not notificationCooldowns[killer.UserId] or (now - notificationCooldowns[killer.UserId] > notificationCooldown) then
            showNotification(killer.Name, "يقتل جميع اللاعبين بشكل غير طبيعي!")
            notificationCooldowns[killer.UserId] = now
        end
    end
end

-- دالة لمعالجة حدث موت اللاعب
local function onPlayerDied(victim, killer)
    if not monitoringActive then return end
    if not killer or not victim then return end
    if killer == victim then return end  -- تجاهل حالات الانتحار

    local now = tick()

    local killerHRP = killer.Character and killer.Character:FindFirstChild("HumanoidRootPart")
    local victimHRP = victim.Character and victim.Character:FindFirstChild("HumanoidRootPart")
    if killerHRP and victimHRP then
        local distance = (killerHRP.Position - victimHRP.Position).Magnitude
        -- إذا كانت المسافة أكبر من suspectDistance، يعتبر القتل عن بُعد
        if distance > suspectDistance then
            if not notificationCooldowns[killer.UserId] or (now - notificationCooldowns[killer.UserId] > notificationCooldown) then
                showNotification(killer.Name, "قتل من مسافة بعيدة!")
                notificationCooldowns[killer.UserId] = now
            end
        end
    end

    -- التحقق من القتلات السريعة
    checkRapidKills(killer)
end

-- دالة لمراقبة اللاعبين عند دخولهم اللعبة
local function monitorPlayer(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            -- يُفترض وجود علامة "creator" في الـHumanoid تُشير إلى اللاعب الذي قام بالقتل
            local creatorTag = humanoid:FindFirstChild("creator")
            if creatorTag and creatorTag.Value then
                local killer = creatorTag.Value
                onPlayerDied(player, killer)
            end
        end)
    end)
end

-- بدء المراقبة للاعبين الجدد والحاليين
Players.PlayerAdded:Connect(monitorPlayer)
for _, player in ipairs(Players:GetPlayers()) do
    monitorPlayer(player)
end

-- زر Toggle من مكتبة OrionLib لتمكين/تعطيل نظام الكشف عن الغش
Tab4:AddToggle({
    Name = "🔄 تفعيل نظام الكشف عن الهكرات",
    Default = false,
    Callback = function(Value)
        monitoringActive = Value
        if monitoringActive then
            showNotification("نظام الحماية", "تم تفعيل نظام الكشف عن الهكرات!")
        else
            showNotification("نظام الحماية", "تم إيقاف نظام الكشف عن الهكرات!")
        end
    end
})






Tab1:AddSection({ Name = "الانتقال الى الهدف و قتله" })






local Players = game:GetService("Players")
local player = Players.LocalPlayer
local targetPlayer = nil
local originalPosition = nil
local attacking = false

-- الحصول على المناطق الآمنة
local safeZones = {}
local safeZonesFolder = workspace:FindFirstChild("SafeZones")
if safeZonesFolder then
    local safeZone1 = safeZonesFolder:FindFirstChild("SafeZone")
    if safeZone1 then table.insert(safeZones, safeZone1) end
end
local safeZone2 = workspace:FindFirstChild("SafeZone")
if safeZone2 then table.insert(safeZones, safeZone2) end

-- التحقق مما إذا كان اللاعب داخل أي منطقة آمنة
local function isPlayerInSafeZone(p)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local pos = p.Character.HumanoidRootPart.Position
        for _, zone in ipairs(safeZones) do
            if pos.X >= zone.Position.X - (zone.Size.X / 2) and pos.X <= zone.Position.X + (zone.Size.X / 2) and
               pos.Y >= zone.Position.Y - (zone.Size.Y / 2) and pos.Y <= zone.Position.Y + (zone.Size.Y / 2) and
               pos.Z >= zone.Position.Z - (zone.Size.Z / 2) and pos.Z <= zone.Position.Z + (zone.Size.Z / 2) then
                return true
            end
        end
    end
    return false
end

-- قائمة اللاعبين
local playerDropdown = Tab1:AddDropdown({
    Name = "اختر لاعب",
    Options = {},
    Callback = function(value)
        targetPlayer = Players:FindFirstChild(value)
        if targetPlayer then
            OrionLib:MakeNotification({
                Name = "تم الاختيار",
                Content = "تم اختيار اللاعب " .. targetPlayer.Name,
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

-- تحديث القائمة عند دخول أو خروج اللاعبين
local function updatePlayerList()
    local playerNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and not isPlayerInSafeZone(p) then
            table.insert(playerNames, p.Name)
        end
    end
    playerDropdown:Refresh(playerNames, true)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

spawn(function()
    while wait(1) do
        updatePlayerList()
    end
end)

-- وظيفة الهجوم المستمر
local function attackTarget()
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        OrionLib:MakeNotification({
            Name = "خطأ",
            Content = "اللاعب غير متاح!",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
        return
    end

    local tool = player.Character:FindFirstChildOfClass("Tool")
    if not tool then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    item.Parent = player.Character
                    tool = item
                    break
                end
            end
        end
    end

    if not tool or not tool:FindFirstChild("Handle") then
        OrionLib:MakeNotification({
            Name = "خطأ",
            Content = "لم يتم العثور على أداة للهجوم!",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
        return
    end

    originalPosition = player.Character.HumanoidRootPart.CFrame
    attacking = true

    local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")

    -- الانتقال فوق رأس اللاعب بشكل متكرر
    spawn(function()
        while attacking and targetHumanoid and targetHumanoid.Health > 0 do
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            wait(0.1)
        end
    end)

    -- الهجوم المستمر
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not attacking or not targetHumanoid or targetHumanoid.Health <= 0 then
            connection:Disconnect()
            return
        end

        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool:Activate()
            for _, part in next, targetPlayer.Character:GetChildren() do
                if part:IsA("BasePart") then
                    firetouchinterest(tool.Handle, part, 0)
                    firetouchinterest(tool.Handle, part, 1)
                end
            end
        end
    end)

    -- مراقبة وفاة الهدف للعودة فورًا
    spawn(function()
        while attacking do
            if targetHumanoid and targetHumanoid.Health <= 0 then
                attacking = false
                player.Character.HumanoidRootPart.CFrame = originalPosition
                OrionLib:MakeNotification({
                    Name = "تم القتل",
                    Content = "تم قتل اللاعب والعودة فورًا.",
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
                break
            end
            wait(0.1)
        end
    end)
end

-- إضافة زر القتل
Tab1:AddButton({
    Name = "قتل اللاعب",
    Callback = function()
        if targetPlayer then
            attackTarget()
        else
            OrionLib:MakeNotification({
                Name = "خطأ",
                Content = "اختر لاعبًا أولًا!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})















Tab1:AddSection({ Name = "طريقة قتل الاعب" })
















-- المتغيرات الأساسية
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local toggle = false          -- حالة تشغيل السكربت
local killMethod = "Behind"   -- طرق القتل: "Behind", "Above", "UnderThenAbove"
local range = 10              -- المدى الافتراضي
local originalPosition = nil
local isAttacking = false

-- دالة التحقق من المنطقة الآمنة باستخدام أسماء الكتل
local function isPlayerInSafeZone(plr)
    local char = plr.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local pos = hrp.Position

    -- SafeZone داخل مجلد SafeZones
    local safeZonesFolder = workspace:FindFirstChild("SafeZones")
    if safeZonesFolder then
        local safeZone1 = safeZonesFolder:FindFirstChild("SafeZone")
        if safeZone1 then
            local zonePos = safeZone1.Position
            local zoneSize = safeZone1.Size
            if pos.X >= zonePos.X - zoneSize.X/2 and pos.X <= zonePos.X + zoneSize.X/2 and
               pos.Y >= zonePos.Y - zoneSize.Y/2 and pos.Y <= zonePos.Y + zoneSize.Y/2 and
               pos.Z >= zonePos.Z - zoneSize.Z/2 and pos.Z <= zonePos.Z + zoneSize.Z/2 then
                return true
            end
        end
    end

    -- SafeZone الموجود مباشرة في Workspace
    local safeZone2 = workspace:FindFirstChild("SafeZone")
    if safeZone2 then
        local zonePos = safeZone2.Position
        local zoneSize = safeZone2.Size
        if pos.X >= zonePos.X - zoneSize.X/2 and pos.X <= zonePos.X + zoneSize.X/2 and
           pos.Y >= zonePos.Y - zoneSize.Y/2 and pos.Y <= zonePos.Y + zoneSize.Y/2 and
           pos.Z >= zonePos.Z - zoneSize.Z/2 and pos.Z <= zonePos.Z + zoneSize.Z/2 then
            return true
        end
    end
    return false
end

-- دالة التأكد من وجود أداة (Tool)
local function ensureTool()
    if not player.Character then return false end
    local tool = player.Character:FindFirstChildOfClass("Tool")
    if tool then return true end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        tool = backpack:FindFirstChildOfClass("Tool")
        if tool then
            tool.Parent = player.Character
            return true
        end
    end
    warn("لم يتم العثور على أداة (Tool)!")
    return false
end

-- التحقق من إمكانية مهاجمة الهدف (ويستبعد من المنطقة الآمنة)
local function canAttack(target)
    if not target.Character then return false end
    local humanoid = target.Character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0 and not isPlayerInSafeZone(target)
end

-- العثور على أقرب لاعب ضمن المدى وغير داخل المنطقة الآمنة
local function findClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    for _, target in ipairs(game:GetService("Players"):GetPlayers()) do
        if target ~= player and canAttack(target) then
            local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (targetHRP.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance <= range and distance < closestDistance then
                    closestPlayer = target
                    closestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- وظيفة الهجوم على الهدف مع تحديث الحركة وتوجيه الوجه نحو الهدف
local function attackTarget(target)
    if isAttacking or not ensureTool() then return end
    isAttacking = true

    local tool = player.Character:FindFirstChildOfClass("Tool")
    if not tool or not tool:FindFirstChild("Handle") then
        isAttacking = false
        return
    end

    originalPosition = player.Character.HumanoidRootPart.CFrame

    local targetHead = target.Character:FindFirstChild("Head")
    if not targetHead then
        isAttacking = false
        return
    end

    local moveConn
    moveConn = runService.RenderStepped:Connect(function()
        if not (toggle and canAttack(target)) then
            if moveConn then moveConn:Disconnect() end
            return
        end
        local newPos
        if killMethod == "Behind" then
            local offset = targetHead.CFrame.LookVector * -3
            newPos = targetHead.Position + offset
        elseif killMethod == "Above" then
            local offset = Vector3.new(0, 10, 0)
            newPos = targetHead.Position + offset
        elseif killMethod == "UnderThenAbove" then
            local offset = Vector3.new(0, -8, 0)
            newPos = targetHead.Position + offset
        end
        -- ضبط CFrame بحيث يكون اللاعب في newPos ووجهه نحو targetHead.Position
        player.Character.HumanoidRootPart.CFrame = CFrame.new(newPos, targetHead.Position)
    end)

    while canAttack(target) and toggle do
        tool:Activate()
        for _, part in ipairs(target.Character:GetChildren()) do
            if part:IsA("BasePart") then
                firetouchinterest(tool.Handle, part, 0)
                firetouchinterest(tool.Handle, part, 1)
            end
        end
        wait(0.1)
    end

    if moveConn then moveConn:Disconnect() end

    if originalPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = originalPosition
    end
    originalPosition = nil
    isAttacking = false
end

-- إنشاء مربع المدى مع تحسينات جمالية:
-- يُوضع عند مستوى رجل اللاعب باستخدام الـHumanoidRootPart مع إزاحة (0, -1, 0)
-- ويتتبع موقع الجسم مع الحفاظ على اتجاهه باستخدام HRP.CFrame
local rangeBox = nil
local rangeBoxConn = nil
local function createRangeBox()
    if rangeBox then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    rangeBox = Instance.new("Part", workspace)
    rangeBox.Name = "RangeBox"
    rangeBox.Size = Vector3.new(range * 2, 0.2, range * 2)
    rangeBox.CFrame = hrp.CFrame * CFrame.new(0, -1, 0)
    rangeBox.Anchored = true
    rangeBox.Transparency = 0.8
    rangeBox.Color = Color3.fromRGB(255, 0, 0)  -- اللون المبدئي، سيتغير بتأثير قوس قزح
    rangeBox.CanCollide = false
    rangeBox.Material = Enum.Material.Neon

    local selectionBox = Instance.new("SelectionBox", rangeBox)
    selectionBox.Adornee = rangeBox
    selectionBox.LineThickness = 0.05
    selectionBox.SurfaceTransparency = 0.3
    selectionBox.Color3 = Color3.fromRGB(255, 255, 255)

    rangeBoxConn = runService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            rangeBox.CFrame = hrp.CFrame * CFrame.new(0, -1, 0)
            rangeBox.Size = Vector3.new(range * 2, 0.2, range * 2)
        end
    end)

    spawn(function()
        local t = 0
        while rangeBox and rangeBox.Parent do
            local hue = (t % 1)
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            rangeBox.Color = rainbowColor
            selectionBox.Color3 = rainbowColor
            t = t + 0.005
            wait()
        end
    end)
end

local function destroyRangeBox()
    if rangeBox then
        rangeBox:Destroy()
        rangeBox = nil
    end
    if rangeBoxConn then
        rangeBoxConn:Disconnect()
        rangeBoxConn = nil
    end
end

-- واجهة المستخدم (الأزرار) باستخدام Tab1
Tab1:AddToggle({
    Name = "تشغيل/إطفاء السكربت",
    Default = false,
    Callback = function(Value)
        toggle = Value
        if toggle then
            createRangeBox()
        else
            destroyRangeBox()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and originalPosition then
                player.Character.HumanoidRootPart.CFrame = originalPosition
            end
        end
    end
})

Tab1:AddTextbox({
    Name = "المدى",
    Default = tostring(range),
    Description = "أدخل قيمة رقمية للمدى (مثال: 50)",
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            range = num
        end
    end
})

Tab1:AddDropdown({
    Name = "طريقة القتل",
    Options = {"خلف اللاعب", "فوق الرأس", "تحت ثم فوق"},
    Callback = function(Value)
        if Value == "خلف اللاعب" then
            killMethod = "Behind"
        elseif Value == "فوق الرأس" then
            killMethod = "Above"
        elseif Value == "تحت ثم فوق" then
            killMethod = "UnderThenAbove"
        end
    end
})

-- حلقة مستمرة للبحث عن أقرب لاعب وتنفيذ الهجوم
runService.RenderStepped:Connect(function()
    if toggle and not isAttacking and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local closestPlayer = findClosestPlayer()
        if closestPlayer then
            task.spawn(function()
                attackTarget(closestPlayer)
            end)
        end
    end
end)






Tab1:AddSection({ Name = "ميزات اخرى للقتل ⚔️" })













-- زر تشغيل ريتش السيف
Tab1:AddButton({
    Name = "🗡️ ريتش للسيف",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hkxrgjb/Script-library-/main/Rich%20from%20my%20difficulty"))()
        print("تم تشغيل ريتش السيف!")
    end    
})
























Tab1:AddButton({
    Name = "⚔️ هجوم سريع",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        if not character then return end

        -- تجهيز الأداة: إذا لم يكن اللاعب يحمل أداة، ننقلها من الحقيبة
        local tool = character:FindFirstChildOfClass("Tool")
        if not tool and backpack then
            tool = backpack:FindFirstChildOfClass("Tool")
            if tool then
                tool.Parent = character
            else
                warn("❌ لا يوجد Tool في الحقيبة!")
                return
            end
        end

        -- تنفيذ سكربت القتل لمدة 0.5 ثانية
        local startTime = tick() -- تسجيل وقت البدء
        local running = true

        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not running or (tick() - startTime) > 0.5 then
                -- إيقاف الهجوم بعد 0.5 ثانية
                running = false
                connection:Disconnect()
                
                -- إعادة Tool إلى الحقيبة
                if tool and backpack then
                    tool.Parent = backpack
                end
                
                return
            end

            -- سكربت القتل: الهجوم على جميع اللاعبين في السيرفر
            for _, target in ipairs(game:GetService("Players"):GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") then
                    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        tool:Activate()
                        for _, part in ipairs(target.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                firetouchinterest(tool.Handle, part, 0)
                                firetouchinterest(tool.Handle, part, 1)
                            end
                        end
                    end
                end
            end
        end)
    end
})







-- متغير التحكم في الدوران
local spinActive = false
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local rotationSpeed = 3600 -- سرعة الدوران (3600 درجة في الثانية)

-- زر تفعيل/إيقاف الدوران
Tab1:AddToggle({
    Name = "🔄 تفعيل الدوران 360°",
    Default = false,
    Callback = function(Value)
        spinActive = Value
    end
})

-- حلقة الدوران
RunService.RenderStepped:Connect(function(delta)
    if spinActive then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(rotationSpeed * delta), 0)
        end
    end
end)






-- متغير التحكم في الأوتو كليكر
local autoClickActive = false
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local autoClickCount = 110 -- عدد النقرات في كل إطار

-- زر تفعيل/إيقاف الأوتو كليكر
Tab1:AddToggle({
    Name = "🖱️ تفعيل الأوتو كليكر",
    Default = false,
    Callback = function(Value)
        autoClickActive = Value
    end
})

-- حلقة الأوتو كليكر
RunService.RenderStepped:Connect(function()
    if autoClickActive then
        local character = LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                for i = 1, autoClickCount do
                    tool:Activate()
                end
            end
        end
    end
end)


















-- المتغيرات الأساسية
local trackingActive = false
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local trackingRange = 15       -- النطاق الذي يتم البحث فيه عن الهدف
local autoClickCount = 10      -- عدد مرات تفعيل الـ Tool عندما يكون الهدف داخل النطاق
local angleOffset = math.rad(25)  -- 25 درجة إلى اليسار (حول المحور Y)

-- دالة لإيجاد أقرب لاعب ضمن النطاق (باستخدام المسافة الكاملة)
local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = trackingRange
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = LocalPlayer.Character.HumanoidRootPart

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPlayer = p
            end
        end
    end
    return nearestPlayer
end

-- حلقة RenderStepped لتتبع الهدف وتنفيذ الأوتو كليكر
RunService.RenderStepped:Connect(function(delta)
    if trackingActive then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local targetPlayer = getNearestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                -- نضبط قيمة Y لتكون نفس Y للـ hrp لتجاهل الفارق الرأسي
                targetPos = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)
                -- إنشاء CFrame جديد بحيث يتم توجيه الجسم نحو الهدف مع إضافة ميل 25 درجة إلى اليسار
                hrp.CFrame = CFrame.new(hrp.Position, targetPos) * CFrame.Angles(0, angleOffset, 0)
                
                -- حساب المسافة بين الـ hrp والهدف
                local distance = (targetPos - hrp.Position).Magnitude
                if distance <= trackingRange then
                    -- تجهيز الـ Tool إذا لم يكن موجودًا
                    local tool = character:FindFirstChildOfClass("Tool")
                    if not tool then
                        local backpack = LocalPlayer:FindFirstChild("Backpack")
                        if backpack then
                            tool = backpack:FindFirstChildOfClass("Tool")
                            if tool then
                                tool.Parent = character
                            end
                        end
                    end
                    if tool and tool:FindFirstChild("Handle") then
                        for i = 1, autoClickCount do
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)

-- زر تبديل لتفعيل / تعطيل النظام
Tab1:AddToggle({
    Name = "🔄 تفعيل تتبع اللاعبين",
    Default = false,
    Callback = function(Value)
        trackingActive = Value
        print("نظام التتبع:", trackingActive)
    end
})





















Tab1:AddSection({ Name = "أخرى" })






local ToggleState = false

Tab1:AddToggle({
    Name = "⚡ تمكين التصادم مع اللاعبين",
    Default = false,
    Callback = function(Value)
        ToggleState = Value
        if ToggleState then
            if game.Players.LocalPlayer.Character then
                for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true -- تفعيل التصادم
                    end
                end
            end
        else
            if game.Players.LocalPlayer.Character then
                for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false -- تعطيل التصادم
                    end
                end
            end
        end
    end
})








Tab1:AddToggle({
    Name = "🔊 صوت مزعج",
    Default = false,
    Callback = function(Value)
        autoEquipActive = Value
        print("نظام تبديل الـ Tool:", autoEquipActive and "مفعل" or "معطل")
        
        if autoEquipActive then
            task.spawn(function()
                while autoEquipActive do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character then
                        local backpack = player:FindFirstChild("Backpack")
                        local tool = character:FindFirstChildOfClass("Tool") or (backpack and backpack:FindFirstChildOfClass("Tool"))

                        if tool then
                            -- مسك الأداة
                            tool.Parent = character
                            task.wait(0.2) -- وقت قصير بين العمليات
                            
                            -- إرجاع الأداة إلى الحقيبة
                            tool.Parent = backpack
                            task.wait(0) -- تأخير بسيط لضمان الاستقرار
                        end
                    end
                end
            end)
        end
    end
})







-- دالة لفحص إذا كانت الأداة موجودة بالفعل في الحقيبة
local function toolExists(toolName)
    local localPlayer = game.Players.LocalPlayer
    local backpack = localPlayer:FindFirstChild("Backpack")

    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name == toolName then
                return true
            end
        end
    end

    return false
end

-- دالة لنسخ الأدوات من لاعب محدد بدون تكرار
local function copyToolsFromPlayer(targetPlayer)
    local localPlayer = game.Players.LocalPlayer
    local localBackpack = localPlayer:FindFirstChild("Backpack")
    if not localBackpack then return end

    -- نسخ الأدوات من شخصية اللاعب المستهدف
    if targetPlayer.Character then
        for _, item in ipairs(targetPlayer.Character:GetChildren()) do
            if item:IsA("Tool") and not toolExists(item.Name) then
                local clonedTool = item:Clone()
                clonedTool.Parent = localBackpack
            end
        end
    end

    -- نسخ الأدوات من حقيبة اللاعب المستهدف
    local targetBackpack = targetPlayer:FindFirstChild("Backpack")
    if targetBackpack then
        for _, item in ipairs(targetBackpack:GetChildren()) do
            if item:IsA("Tool") and not toolExists(item.Name) then
                local clonedTool = item:Clone()
                clonedTool.Parent = localBackpack
            end
        end
    end
end




Tab1:AddButton({
    Name = "🗡 امسك جميع السيوف",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character and player.Backpack then
            for _, tool in pairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = player.Character -- نقل الأداة إلى الشخصية لجعلها ظاهرة للجميع
                end
            end
        end
    end
})




-- زر لنسخ الأدوات من جميع اللاعبين بدون تكرار
Tab1:AddButton({
    Name = "🗡 نسخ جميع سيوف الاعبين(فقط مضهر)",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer then
                copyToolsFromPlayer(player)
            end
        end
        print("✅ تم نسخ جميع الأدوات الفريدة فقط من اللاعبين إلى حقيبتك.")
    end
})







local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local selectedPlayer = nil
local playerDropdown

local function updatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    if playerDropdown then
        playerDropdown:Refresh(playerNames, true)
        if #playerNames > 0 then
            selectedPlayer = playerNames[1]
        else
            selectedPlayer = nil
        end
    end
end

playerDropdown = Tab2:AddDropdown({
    Name = "اختر لاعب",
    Default = "",
    Options = {},
    Callback = function(value)
        selectedPlayer = value
    end
})

Tab2:AddButton({
    Name = "انتقل إلى اللاعب",
    Callback = function()
        if selectedPlayer then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            else
                OrionLib:MakeNotification({
                    Name = "خطأ",
                    Content = "لا يمكن الانتقال إلى هذا اللاعب!",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "خطأ",
                Content = "لم يتم تحديد لاعب!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()


Tab2:AddSection({ Name = "" })





-- 🛠️ الانتقالات
local function teleportToZone()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local StarterGui = game:GetService("StarterGui")

    local multiTime = game.Workspace:FindFirstChild("MultiTime")
    local multiTime2 = game.Workspace:FindFirstChild("MultiTime2")

    local zone1 = multiTime and multiTime:FindFirstChild("Zone") or nil
    local zone2 = multiTime2 and multiTime2:FindFirstChild("Zone") or nil

    if zone1 and zone2 then
        rootPart.CFrame = zone2.CFrame
        StarterGui:SetCore("SendNotification", {Title = "🚀 الانتقال", Text = "تم الانتقال إلى MultiTime2!", Duration = 3})
    elseif zone1 then
        rootPart.CFrame = zone1.CFrame
        StarterGui:SetCore("SendNotification", {Title = "🚀 الانتقال", Text = "تم الانتقال إلى MultiTime!", Duration = 3})
    else
        StarterGui:SetCore("SendNotification", {Title = "⚠️ خطأ", Text = "لا يوجد مناطق حالياً!", Duration = 3})
    end
end

-- زر الانتقال إلى منطقة الضعف
Tab2:AddButton({
    Name = "🔄 الانتقال الى منطقة الوقت",
    Callback = function()
        teleportToZone()
    end
})

-- زر الانتقال إلى عالم الصحراء
Tab2:AddButton({
    Name = "🏜️ الانتقال الى عالم الصحراء",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        rootPart.CFrame = CFrame.new(-685.84, 4.55, -8.09)
    end
})

-- زر الانتقال إلى المنطقة الآمنة مع إشعار
Tab2:AddButton({
    Name = "🛡️ الانتقال إلى المنطقة الآمنة",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        rootPart.CFrame = CFrame.new(1.36, 4.00, 0.25)

        -- عرض إشعار بالتنقل الناجح
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ نجاح!",
            Text = "تم الانتقال إلى المنطقة الآمنة",
            Duration = 3
        })
    end
})


Tab2:AddButton({
    Name = "🕵️ الانتقال إلى المكان السري",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        rootPart.CFrame = CFrame.new(-647.52, 4.59, 853.18)

        -- عرض إشعار بالتنقل الناجح
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✨ انتقال ناجح!",
            Text = "تم الانتقال إلى المكان السري!",
            Duration = 3
        })
    end
})







Tab2:AddButton({
    Name = "🔄 الانتقال الى قاعدة الزومبي",
    Callback = function()
        local modelName = "MagmaSpire"  -- اسم الملف الذي يحتوي على الجزء Top
        local targetPartName = "Top"  -- اسم الجزء المطلوب

        -- البحث عن الجزء "Top" داخل "MagmaSpire"
        local model = workspace:FindFirstChild(modelName)
        if model then
            local topPart = model:FindFirstChild(targetPartName)
            if topPart then
                -- نقل اللاعب إلى موقع "Top"
                game.Players.LocalPlayer.Character:MoveTo(topPart.Position)
            end
        end
    end
})













local autoKillEnabled = false
local connection
local errorNotified = false -- إشعار الخطأ يظهر مرة واحدة فقط
local teleportNotified = false -- إشعار النقل يظهر مرة واحدة فقط
local backNotified = false -- إشعار العودة يظهر مرة واحدة فقط
local originalPosition = nil -- حفظ الموقع الأصلي للاعب

Tab:AddToggle({
    Name = "⏳ فارم منطقة الضعف",
    Default = false,
    Callback = function(Value)
        autoKillEnabled = Value
        print("🚀 حالة القتل التلقائي:", autoKillEnabled)
        errorNotified, teleportNotified, backNotified = false, false, false
        originalPosition = nil -- إعادة تعيين الموقع الأصلي عند كل تشغيل

        -- إذا تم تعطيل القتل التلقائي، يرجع اللاعب إلى موقعه الأصلي
        if not autoKillEnabled then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            if originalPosition then
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = originalPosition
                        if not backNotified then
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "🔄 العودة!",
                                Text = "تمت العودة إلى الموقع الأصلي.",
                                Duration = 3
                            })
                            backNotified = true
                        end
                    end
                end
            end
            return
        end

        -- المتغيرات الأساسية
        local player = game.Players.LocalPlayer
        local runService = game:GetService("RunService")
        local detectionDistance = 25 -- المسافة المطلوبة لكشف المهاجم

        -- البحث عن جميع المناطق المتاحة
        local function findWeaknessZones()
            local zones = {}
            local multiTimeFolders = {"MultiTime", "MultiTime1", "MultiTime2", "MultiTime3"}

            for _, folderName in ipairs(multiTimeFolders) do
                local folder = workspace:FindFirstChild(folderName)
                if folder then
                    local zone = folder:FindFirstChild("Zone")
                    if zone and zone:IsA("Part") then
                        table.insert(zones, zone)
                    end
                end
            end

            return zones
        end

        -- اختيار المنطقة المناسبة للانتقال إليها
        local function getBestZone()
            local zones = findWeaknessZones()
            if #zones == 0 then
                if not errorNotified then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "⚠️ خطأ!",
                        Text = "لم يتم العثور على أي منطقة ضعف!",
                        Duration = 5
                    })
                    errorNotified = true
                end
                return nil
            elseif #zones == 1 then
                return zones[1]
            else
                for _, zone in ipairs(zones) do
                    if zone.Parent.Name == "MultiTime2" then
                        return zone
                    end
                end
                return zones[1]
            end
        end

        -- وظيفة تجهيز السلاح (Tool)
        local function getTool()
            local character = player.Character
            if not character then return nil end

            local tool = character:FindFirstChildOfClass("Tool")
            if not tool then
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    tool = backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        tool.Parent = character -- نقل الأداة إلى الشخصية
                    end
                end
            end
            return character:FindFirstChildOfClass("Tool")
        end

        -- وظيفة تنفيذ الهجوم
        local function attackNearbyPlayers()
            if not autoKillEnabled then return end
            local character = player.Character
            if not character then return end

            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end

            -- حفظ الموقع الأصلي قبل الانتقال
            if not originalPosition then
                originalPosition = rootPart.CFrame
            end

            -- تحديد المنطقة المناسبة للانتقال إليها
            local bestZone = getBestZone()

            -- إذا لم يتم العثور على أي منطقة، يتم العودة إلى الموقع الأصلي
            if not bestZone then
                if originalPosition then
                    rootPart.CFrame = originalPosition
                    if not backNotified then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "🔄 العودة!",
                            Text = "تمت العودة إلى الموقع الأصلي.",
                            Duration = 3
                        })
                        backNotified = true
                    end
                end
                return
            end

            -- نقل اللاعب إلى المنطقة المناسبة وإظهار إشعار النجاح مرة واحدة
            if rootPart.Position ~= bestZone.Position then
                rootPart.CFrame = bestZone.CFrame
                if not teleportNotified then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "✅ تم الانتقال!",
                        Text = "تم الانتقال إلى المنطقة بنجاح.",
                        Duration = 3
                    })
                    teleportNotified = true
                end
            end

            -- تجهيز الأداة إذا لم يكن يمسك واحدة
            local tool = getTool()
            if not tool then return end

            -- البحث عن اللاعبين القريبين وضربهم
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if otherRoot then
                        local distance = (rootPart.Position - otherRoot.Position).Magnitude
                        if distance < detectionDistance then
                            if tool and tool:FindFirstChild("Handle") then
                                tool:Activate()
                                for _, part in ipairs(otherPlayer.Character:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        firetouchinterest(tool.Handle, part, 0)
                                        firetouchinterest(tool.Handle, part, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- تشغيل الهجوم التلقائي كل إطار
        connection = runService.RenderStepped:Connect(attackNearbyPlayers)
    end
})















local runActive = false
local wasActive = false  -- متغير لتتبع ما إذا كان النظام مفعل مسبقاً
local killScriptConnection
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- الإحداثيات المطلوبة
local targetPosition = Vector3.new(-1.45, 34.70, -421.84)
local safeZonePosition = Vector3.new(1.36, 4.00, 0.25)

-- دالة لتفعيل سكربت القتل
local function startKillScript()
    killScriptConnection = RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                
                if humanoid.Health > 0 and hrp and tool and tool:FindFirstChild("Handle") then
                    tool:Activate()
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            firetouchinterest(tool.Handle, part, 0)
                            firetouchinterest(tool.Handle, part, 1)
                        end
                    end
                end
            end
        end
    end)
end

-- دالة لإيقاف سكربت القتل
local function stopKillScript()
    if killScriptConnection then
        killScriptConnection:Disconnect()
        killScriptConnection = nil
    end
end

-- حلقة RenderStepped للنقل المستمر وتجهيز الأداة أثناء تفعيل النظام
RunService.RenderStepped:Connect(function()
    if runActive then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            hrp.CFrame = CFrame.new(targetPosition)
            -- تجهيز الأداة تلقائيًا إذا لم تكن مجهزة
            local tool = character:FindFirstChildOfClass("Tool")
            if not tool then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    tool = backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        tool.Parent = character
                    end
                end
            end
        end
    end
end)

-- زر التبديل (Toggle) لتفعيل/تعطيل نظام القتل التلقائي
Tab:AddToggle({
    Name = "⚔️ تفعيل القتل التلقائي",
    Default = false,
    Callback = function(Value)
        if Value then
            runActive = true
            wasActive = true
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "⚔️ النظام مفعل",
                Text = "يتم الآن الانتقال والتجهيز والقتل التلقائي.",
                Duration = 3
            })
            startKillScript()
        elseif wasActive then  -- يتم تنفيذ هذا الكود فقط إذا كان النظام قد تم تفعيله سابقاً
            runActive = false
            wasActive = false
            stopKillScript()

            -- عند إيقاف النظام يتم النقل إلى المنطقة الآمنة
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local endTime = tick() + 3
                while tick() < endTime do
                    hrp.CFrame = CFrame.new(safeZonePosition)
                    RunService.RenderStepped:Wait()
                end
            end

            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "✅ تم الإيقاف",
                Text = "تم الرجوع إلى المنطقة الآمنة.",
                Duration = 3
            })
        end
    end
})















Tab:AddToggle({
	Name = "💰 جمع العملات تلقائيًا",
	Default = false,
	Callback = function(Value)
		local isRunning = Value
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local toucher = character:WaitForChild("HumanoidRootPart")

		local function touchCoin(coin)
			if toucher and coin and coin:IsA("BasePart") then
				firetouchinterest(toucher, coin, 0)
				task.wait(0.1)
				firetouchinterest(toucher, coin, 1)

				OrionLib:MakeNotification({
					Name = "تم لمس العملة",
					Content = "تم جمع عملة!",
					Image = "rbxassetid://4483345998",
					Time = 2
				})
			end
		end

		if isRunning then
			OrionLib:MakeNotification({
				Name = "جاري البحث عن العملات",
				Content = "سيتم جمع أي عملة تظهر تلقائيًا.",
				Image = "rbxassetid://4483345998",
				Time = 3
			})

			task.spawn(function()
				while isRunning do
					for _, coin in pairs(workspace:GetChildren()) do
						if coin:IsA("BasePart") and coin.Name == "EventCoin" then
							touchCoin(coin)
						end
					end
					task.wait(0.3)
				end
			end)
		end
	end
})
















Tab:AddToggle({
    Name = "🧟 القتال التلقائي ضد الزومبي",
    Default = false,
    Callback = function(Value)
        local isRunning = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local tool = nil
        local originalPosition = rootPart.Position
        local fighting = false

        -- تجهيز الأداة من الحقيبة
        local function equipTool()
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                tool = backpack:FindFirstChildOfClass("Tool")
                if tool then
                    tool.Parent = character
                end
            end
        end

        -- البحث عن أقرب زومبي
        local function findNearestZombie()
            local closestZombie = nil
            local minDistance = math.huge
            for _, zombie in pairs(workspace:GetChildren()) do
                if zombie:IsA("Model") and zombie:FindFirstChild("Head") and zombie.Name == "Zombie" and zombie:FindFirstChild("Humanoid") and zombie.Humanoid.Health > 0 then
                    local dist = (rootPart.Position - zombie.Head.Position).Magnitude
                    if dist < minDistance then
                        minDistance = dist
                        closestZombie = zombie
                    end
                end
            end
            return closestZombie
        end

        -- التشغيل
        if isRunning then
            task.spawn(function()
                while isRunning do
                    local zombie = findNearestZombie()
                    if zombie then
                        fighting = true
                        while isRunning and zombie.Parent and zombie:FindFirstChild("Humanoid") and zombie.Humanoid.Health > 0 do
                            if not tool or tool.Parent ~= character then
                                equipTool()
                            end
                            -- تحديث موقع اللاعب باستمرار خلف الزومبي
                            local behindPos = zombie.Head.Position - (zombie.Head.CFrame.LookVector * 3)
                            rootPart.CFrame = CFrame.new(behindPos, zombie.Head.Position)
                            -- الهجوم
                            if tool then
                                tool:Activate()
                            end
                            task.wait(0.01)
                        end
                    else
                        -- عند انتهاء جميع الزومبي، يعود اللاعب إلى موقعه الأصلي
                        if fighting then
                            rootPart.CFrame = CFrame.new(originalPosition)
                            fighting = false
                        end
                        task.wait(0.1)
                    end
                end
                -- عند إيقاف الزر، يتوقف القتال ويعود اللاعب لموقعه الأصلي
                rootPart.CFrame = CFrame.new(originalPosition)
                OrionLib:MakeNotification({
                    Name = "إيقاف القتال",
                    Content = "تم إيقاف القتال التلقائي ضد الزومبي.",
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
            end)
        else
            -- عند إيقاف الزر، يعود اللاعب مباشرة إلى موقعه الأصلي
            rootPart.CFrame = CFrame.new(originalPosition)
        end
    end
})























Tab6:AddButton({
    Name = "إعادة الدخول إلى نفس السيرفر 🔁",
    Callback = function()
        -- إعادة دخول اللاعب إلى نفس السيرفر باستخدام TeleportService
        local placeId = game.PlaceId
        local jobId = game.JobId
        game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
    end
})





local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local placeId = game.PlaceId  -- الحصول على Place ID للعبة الحالية

Tab6:AddButton({
    Name = "الانتقال إلى سيرفر آخر 🔀",
    Callback = function()
        local player = Players.LocalPlayer
        -- محاولة الانتقال إلى سيرفر آخر في نفس الماب
        TeleportService:Teleport(placeId, player)
    end
})








-- كود الماب الذي تريد نقل اللاعب إليه
Tab6:AddButton({
    Name = "نقل الى عالم الصحراء (بدون وقت) 🏜",
    Callback = function()
        -- كود الماب الذي ترغب في نقله إليه
        local mapCode = 82910095461681
        -- استخدام خدمة TeleportService لنقل اللاعب إلى الماب
        game:GetService("TeleportService"):Teleport(mapCode)
    end
})








local Lighting = game:GetService("Lighting")

-- دالة لتغيير الوقت إلى الصباح
local function setDayTime()
    Lighting.TimeOfDay = "14:00:00"  -- تعيين الوقت إلى الساعة 2 مساءً (الصباح الباكر)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)  -- تعيين الإضاءة الخارجية لتكون ساطعة
    Lighting.FogEnd = 5000  -- تعيين مدى الضباب
end

-- دالة لتغيير الوقت إلى الليل
local function setNightTime()
    Lighting.TimeOfDay = "00:00:00"  -- تعيين الوقت إلى منتصف الليل
    Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 50)  -- تعتيم الإضاءة الخارجية
    Lighting.FogEnd = 1000  -- تعيين مدى الضباب
end

-- إضافة زر لتغيير الوقت
Tab6:AddButton({
    Name = "🌞 تحويل إلى صباح",
    Callback = function()
        setDayTime()  -- تعيين الوقت إلى الصباح
    end
})

Tab6:AddButton({
    Name = "🌙 تحويل إلى ليل",
    Callback = function()
        setNightTime()  -- تعيين الوقت إلى الليل
    end
})











local UpdateSection = Tab3:AddSection({ Name = "🆕 التحديثات الجديدة" })
UpdateSection:AddLabel("✅ تم اضافة ميزة ايداع الوقت بشكل تلقائي")
UpdateSection:AddLabel("✅ تم اضافة ميزة الانتقال الى قاعدة الزومبي")
UpdateSection:AddLabel("✅ تم اضافة ميزة الانتقال الى العملة بشكل تلقائي")
UpdateSection:AddLabel("✅ تم اضافة ميزة قتل الزومبي بشكل تلقائي")
UpdateSection:AddLabel("✅ اصلاح بعض الاخطأ")





Tab3:AddParagraph("حسابي ديسكورد","(ahmedmohsen2282)")
Tab3:AddParagraph("حسابي تلجرام","@hacker8686")
Tab3:AddLabel("تم صناعة السكربت من الصفر , لذا ستكون هناك مشاكل في التصميم , وشكرا على استخدام السكربت")



wait(6)
OrionLib:MakeNotification({
    Name = "⚠️ تحذير!",
    Content = "❗ هذا السكربت قد يؤدي إلى حضرك بشكل دائم! نحن غير مسؤلين عن حسابك!",
    Image = "rbxassetid://134484331149838",
    Time = 10
})

-- تشغيل OrionLib
OrionLib:Init()