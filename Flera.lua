local Flera = {}

function Flera:CreateWindow(options)
    local window = {}
    local sections = {}
    local workareas = {}
    local notifs = {}
    local visible = true
    local dbcooper = false

    local function tween(instance, position, duration)
        game:GetService("TweenService"):Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = position}):Play()
    end

    -- Create the main window
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game:GetService("CoreGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.Position = UDim2.new(0.5, 0, 2, 0)
    mainFrame.Size = UDim2.new(0, 721, 0, 584)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = mainFrame

    -- Dragging functionality
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Workarea setup
    local workarea = Instance.new("Frame")
    workarea.Name = "Workarea"
    workarea.Parent = mainFrame
    workarea.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    workarea.Position = UDim2.new(0.364, 0, 0, 0)
    workarea.Size = UDim2.new(0, 458, 0, 584)

    local workareaCorner = Instance.new("UICorner")
    workareaCorner.CornerRadius = UDim.new(0, 18)
    workareaCorner.Parent = workarea

    -- Sidebar setup
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainFrame
    sidebar.BackgroundTransparency = 1
    sidebar.Position = UDim2.new(0.025, 0, 0.182, 0)
    sidebar.Size = UDim2.new(0, 233, 0, 463)
    sidebar.AutomaticCanvasSize = "Y"
    sidebar.ScrollBarThickness = 2

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = sidebar
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 5)

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = mainFrame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.389, 0, 0.035, 0)
    title.Size = UDim2.new(0, 400, 0, 15)
    title.Font = Enum.Font.Gotham
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextSize = 28
    title.Text = options.Title or "Flera Window"

    -- Toggle visibility
    function window:ToggleVisibility()
        if dbcooper then return end
        visible = not visible
        dbcooper = true
        if visible then
            tween(mainFrame, UDim2.new(0.5, 0, 0.5, 0), 0.5)
        else
            tween(mainFrame, mainFrame.Position + UDim2.new(0, 0, 2, 0), 0.5)
        end
        task.wait(0.5)
        dbcooper = false
    end

    -- Create a tab
    function window:CreateTab(name)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton"
        tabButton.Parent = sidebar
        tabButton.BackgroundColor3 = Color3.fromRGB(21, 103, 251)
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(0, 226, 0, 37)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        tabButton.TextSize = 21

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 9)
        tabCorner.Parent = tabButton

        local workareaFrame = Instance.new("ScrollingFrame")
        workareaFrame.Name = "WorkareaFrame"
        workareaFrame.Parent = workarea
        workareaFrame.BackgroundTransparency = 1
        workareaFrame.Position = UDim2.new(0.039, 0, 0.096, 0)
        workareaFrame.Size = UDim2.new(0, 422, 0, 512)
        workareaFrame.Visible = false
        workareaFrame.AutomaticCanvasSize = "Y"
        workareaFrame.ScrollBarThickness = 2

        local workareaLayout = Instance.new("UIListLayout")
        workareaLayout.Parent = workareaFrame
        workareaLayout.SortOrder = Enum.SortOrder.LayoutOrder
        workareaLayout.Padding = UDim.new(0, 5)

        table.insert(sections, tabButton)
        table.insert(workareas, workareaFrame)

        function tab:Select()
            for _, v in pairs(sections) do
                v.BackgroundTransparency = 1
                v.TextColor3 = Color3.fromRGB(0, 0, 0)
            end
            tabButton.BackgroundTransparency = 0
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            for _, v in pairs(workareas) do
                v.Visible = false
            end
            workareaFrame.Visible = true
        end

        tabButton.MouseButton1Click:Connect(function()
            tab:Select()
        end)

        -- Create a button
        function tab:CreateButton(name, callback)
            local button = Instance.new("TextButton")
            button.Name = "Button"
            button.Parent = workareaFrame
            button.BackgroundColor3 = Color3.fromRGB(216, 216, 216)
            button.BackgroundTransparency = 1
            button.Size = UDim2.new(0, 418, 0, 37)
            button.Font = Enum.Font.Gotham
            button.Text = name
            button.TextColor3 = Color3.fromRGB(21, 103, 251)
            button.TextSize = 21

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 9)
            buttonCorner.Parent = button

            local stroke = Instance.new("UIStroke")
            stroke.Parent = button
            stroke.Color = Color3.fromRGB(21, 103, 251)
            stroke.Thickness = 1

            if callback then
                button.MouseButton1Click:Connect(function()
                    callback()
                end)
            end
        end

        return tab
    end

    return window
end

return Flera
