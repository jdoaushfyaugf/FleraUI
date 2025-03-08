-- Universal Flera UI Library
local Flera = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Safe GUI Creation for Executors
local function CreateScreenGui()
    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.Enabled = true
    gui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
    return gui
end

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function ApplyRoundCorners(instance, cornerRadius)
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(cornerRadius, 0),
        Parent = instance
    })
end

-- Fade Animation
local function FadeIn(instance)
    instance.Visible = true
    TweenService:Create(instance, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2
    }):Play()
end

local function FadeOut(instance, callback)
    local tween = TweenService:Create(instance, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        instance.Visible = false
        if callback then callback() end
    end)
end

-- Create Window
function Flera:CreateWindow(options)
    local window = {}
    options = options or {}
    local title = options.Title or "Flera UI"

    -- Create GUI
    local screenGui = CreateScreenGui()

    -- Main Frame
    local mainFrame = CreateInstance("Frame", {
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.2,
        Visible = true,
        Parent = screenGui
    })
    ApplyRoundCorners(mainFrame, 0.1)

    -- Title Bar
    local titleBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Parent = mainFrame
    })
    ApplyRoundCorners(titleBar, 0.1)

    -- Title Text
    local titleLabel = CreateInstance("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        Parent = titleBar
    })

    -- Close Button
    local closeButton = CreateInstance("TextButton", {
        Text = "X",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0.5, -12.5),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        Parent = titleBar
    })
    ApplyRoundCorners(closeButton, 0.5)

    -- Close UI Functionality
    closeButton.MouseButton1Click:Connect(function()
        FadeOut(mainFrame, function()
            screenGui.Enabled = false
        end)
    end)

    -- Show UI with Left Shift
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftShift then
            screenGui.Enabled = not screenGui.Enabled
            if screenGui.Enabled then
                FadeIn(mainFrame)
            end
        end
    end)

    -- Ensure UI is visible
    FadeIn(mainFrame)

    function window:AddTab(name)
        local tab = {}
        return tab
    end

    function window:AddButton(text, callback)
        local button = CreateInstance("TextButton", {
            Text = text,
            Size = UDim2.new(0.9, 0, 0, 40),
            Position = UDim2.new(0.05, 0, 0, (#mainFrame:GetChildren() - 1) * 45),
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SourceSansBold,
            Parent = mainFrame
        })
        ApplyRoundCorners(button, 0.2)

        button.MouseButton1Click:Connect(callback)
    end

    function window:AddSlider(text, min, max, callback)
        local slider = {}
        return slider
    end

    return window
end

return Flera
