-- // MADE BY Blissful#4992 / CornCatCornDog on v3rmillion // --
_G.Settings = _G.Settings or {
    Change_Materials = true;
    Worse_Lighting = true;
    Hide_Decals = true;
    Change_Graphics = true;
    No_Shadows = true;
}

if _G.Executed then warn("Already executed") return end
if not _G then warn("Exploit not compatible") return end
_G.Executed = true
_G.Activated = false

local Space = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local savedStates = {}

local workspaceAdded
local lightingAdded
local GHP = gethiddenproperty and sethiddenproperty

function _G.FPS_Boost(bool)
    _G.Activated = bool or not _G.Activated
    if (_G.Activated) then
        local SETTINGS = _G.Settings
        savedStates = {
            BasePart = {};
            Texture = {};
            Effect = {};
        }

        if SETTINGS.Change_Graphics and GHP then
            savedStates["Technology"] = gethiddenproperty(Lighting, "Technology")
            sethiddenproperty(Lighting, "Technology", "Compatibility")
        end
        if SETTINGS.No_Shadows then
            savedStates["Shadows"] = Lighting.GlobalShadows
            Lighting.GlobalShadows = false
        end

        -- WORKSPACE
        local Objs = Space:GetDescendants()
        for i = 1, #Objs do
            local v = Objs[i]
            local Identity = v:GetFullName()
            if v:IsA("BasePart") then
                savedStates.BasePart[Identity] = nil
                if SETTINGS.Change_Materials or SETTINGS.No_Shadows then savedStates.BasePart[Identity] = {Material = v.Material, CastShadow = v.CastShadow} end

                if SETTINGS.Change_Materials then v.Material = Enum.Material.SmoothPlastic end
                if SETTINGS.No_Shadows then v.CastShadow = false end
            end

            if SETTINGS.Hide_Decals and (v:IsA("Decal") or v:IsA("Texture")) then
                savedStates.Texture[Identity] = {Transparency = v.Transparency}
                v.Transparency = 1
            end
        end

        if workspaceAdded then workspaceAdded:Disconnect() end
        workspaceAdded = Space.DescendantAdded:Connect(function(v)
            local Identity = v:GetFullName()
            if v:IsA("BasePart") then
                savedStates.BasePart[Identity] = nil
                if SETTINGS.Change_Materials or SETTINGS.No_Shadows then savedStates.BasePart[Identity] = {Material = v.Material, CastShadow = v.CastShadow} end

                if SETTINGS.Change_Materials then v.Material = Enum.Material.SmoothPlastic end
                if SETTINGS.No_Shadows then v.CastShadow = false end
            end

            if SETTINGS.Hide_Decals and (v:IsA("Decal") or v:IsA("Texture")) then
                savedStates.Texture[Identity] = {Transparency = v.Transparency}
                v.Transparency = 1
            end
        end)

        -- LIGHTING
        if lightingAdded then lightingAdded:Disconnect() end
        if SETTINGS.Worse_Lighting then
            local LightObjs = Lighting:GetDescendants()
            for i = 1, #LightObjs do
                local v = LightObjs[i]
                local Identity = v:GetFullName()

                if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
                    savedStates.Effect[Identity] = {Enabled = v.Enabled}
                    v.Enabled = 0
                end
            end

            lightingAdded = Lighting.DescendantAdded:Connect(function(v)
                local Identity = v:GetFullName()

                if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
                    savedStates.Effect[Identity] = {Enabled = v.Enabled}
                    v.Enabled = 0
                end
            end)
        end
    else
        if workspaceAdded then workspaceAdded:Disconnect() end
        if lightingAdded then lightingAdded:Disconnect() end

        if savedStates["Technology"] ~= nil and GHP then
            sethiddenproperty(Lighting, "Technology", savedStates["Technology"])
        end
        if savedStates["Shadows"] ~= nil then
            Lighting.GlobalShadows = savedStates["Shadows"]
        end

        -- WORKSPACE
        local Objs = Space:GetDescendants()
        for i = 1, #Objs do
            local v = Objs[i]
            local Identity = v:GetFullName()
            if v:IsA("BasePart") then
                local saved = savedStates.BasePart[Identity]
                if saved ~= nil then 
                    v.Material = saved.Material
                    v.CastShadow = saved.CastShadow
                end
            end

            if v:IsA("Decal") or v:IsA("Texture") then
                local saved = savedStates.Texture[Identity]
                if saved ~= nil then 
                    v.Transparency = saved.Transparency
                end
            end
        end

        -- LIGHTING
        local LightObjs = Lighting:GetDescendants()
        for i = 1, #LightObjs do
            local v = LightObjs[i]
            local Identity = v:GetFullName()

            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
                local saved = savedStates.Effect[Identity]
                if saved ~= nil then 
                    v.Enabled = saved.Enabled
                end
            end
        end

        savedStates = {}
    end
end

-- _G.FPS_Boost(<bool> true/false)
