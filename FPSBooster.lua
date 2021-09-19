-- // MADE BY Blissful#4992 / CornCatCornDog on v3rmillion // --
_G.Settings = _G.Settings or {
    Change_Materials = true;
    Worse_Lighting = true;
    Hide_Decals = true;
    Change_Graphics = true;
    No_Shadows = true;
    No_Meshes = true;
    No_Mesh_Textures = true;
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

local function hasProperty(v, p)
    local r = pcall(function() local _=v[p] end)
    return r
end

local MUTEX = true
function _G.FPS_Boost(bool)
    if MUTEX then
        MUTEX = false
        _G.Activated = bool or not _G.Activated
        if (_G.Activated) then
            local SETTINGS = _G.Settings
            savedStates = {
                BasePart = {};
                Texture = {};
                Effect = {};
                Meshes = {};
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
                    if SETTINGS.Change_Materials or SETTINGS.No_Shadows then savedStates.BasePart[Identity] = {Material = v.Material, CastShadow = v.CastShadow} end

                    if SETTINGS.Change_Materials then v.Material = Enum.Material.SmoothPlastic end
                    if SETTINGS.No_Shadows then v.CastShadow = false end
                end

                if v.ClassName:match("Mesh") then
                    if (SETTINGS.No_Mesh_Textures and hasProperty(v, "TextureId")) or (SETTINGS.No_Meshes and hasProperty(v, "MeshId")) then savedStates.Meshes[Identity] = {} end
                    if SETTINGS.No_Mesh_Textures and hasProperty(v, "TextureId") then savedStates.Meshes[Identity].TextureId = v.TextureId v.TextureId = "" end
                    if SETTINGS.No_Meshes and hasProperty(v, "MeshId") then savedStates.Meshes[Identity].MeshId = v.MeshId v.MeshId = "" end
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
                    if SETTINGS.Change_Materials or SETTINGS.No_Shadows then savedStates.BasePart[Identity] = {Material = v.Material, CastShadow = v.CastShadow} end

                    if SETTINGS.Change_Materials then v.Material = Enum.Material.SmoothPlastic end
                    if SETTINGS.No_Shadows then v.CastShadow = false end
                end

                if v.ClassName:match("Mesh") then
                    if (SETTINGS.No_Mesh_Textures and hasProperty(v, "TextureId")) or (SETTINGS.No_Meshes and hasProperty(v, "MeshId")) then savedStates.Meshes[Identity] = {} end
                    if SETTINGS.No_Mesh_Textures and hasProperty(v, "TextureId") then savedStates.Meshes[Identity].TextureId = v.TextureId v.TextureId = "" end
                    if SETTINGS.No_Meshes and hasProperty(v, "MeshId") then savedStates.Meshes[Identity].MeshId = v.MeshId v.MeshId = "" end
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

            if savedStates["Technology"] and GHP then
                sethiddenproperty(Lighting, "Technology", savedStates["Technology"])
            end
            if savedStates["Shadows"] then
                Lighting.GlobalShadows = savedStates["Shadows"]
            end

            -- WORKSPACE
            local Objs = Space:GetDescendants()
            for i = 1, #Objs do
                local v = Objs[i]
                local Identity = v:GetFullName()
                if v:IsA("BasePart") then
                    local saved = savedStates.BasePart[Identity]
                    if saved then 
                        v.Material = saved.Material
                        v.CastShadow = saved.CastShadow
                    end
                end

                if v:IsA("Decal") or v:IsA("Texture") then
                    local saved = savedStates.Texture[Identity]
                    if saved then 
                        v.Transparency = saved.Transparency
                    end
                end

                if v.ClassName:match("Mesh") then
                    local saved = savedStates.Meshes[Identity]
                    if saved then 
                        if hasProperty(v, "TextureId") and saved["TextureId"] ~= nil then v.TextureId = saved.TextureId end
                        if hasProperty(v, "MeshId") and saved["MeshId"] ~= nil then v.MeshId = saved.MeshId end
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
                    if saved then 
                        v.Enabled = saved.Enabled
                    end
                end
            end

            savedStates = {}
        end
        MUTEX = true
    end
end

-- _G.FPS_Boost(<void> or <bool> true/false)
