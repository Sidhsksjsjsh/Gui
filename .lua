local player = game.Players.LocalPlayer
local s = {}

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80) -- Menyesuaikan ukuran frame untuk bar volume
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(1, 1, 1)
frame.Name = "NowPlayingFrame"
frame.Parent = player["PlayerGui"]
frame.Visible = false

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0.5, 0) -- Menyesuaikan ukuran textLabel untuk judul lagu
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.Text = "Now Playing: Unknown by Unknown"
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.BackgroundTransparency = 1
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 18
textLabel.Parent = frame

local volumeBar = Instance.new("TextLabel")
volumeBar.Size = UDim2.new(1, 0, 0.5, 0) -- Menyesuaikan ukuran volumeBar untuk bar volume
volumeBar.Position = UDim2.new(0, 0, 0.5, 0)
volumeBar.Text = "Volume: 100%"
volumeBar.TextColor3 = Color3.new(1, 1, 1)
volumeBar.BackgroundTransparency = 0.5
volumeBar.BackgroundColor3 = Color3.new(0, 0, 0)
volumeBar.Font = Enum.Font.SourceSans
volumeBar.TextSize = 14
volumeBar.Parent = frame

function s:ShowMusicPlayer()
  frame.Visible = true
end

function s:HideMusicPlayer()
  frame.Visible = false
end


local function getNowPlaying()
    local soundService = game:GetService("SoundService")
    local currentSound = soundService:GetRespectiveSound()
    
    if currentSound then
        local soundName = currentSound.Name
        local soundArtist = currentSound:GetMetadata("Creator") or "Unknown Artist"
        
        return soundName, soundArtist, currentSound.Volume
    else
        return "No Song Playing", "", 0
    end
end

local function updateNowPlaying()
    local title, artist, volume = getNowPlaying()
    
    textLabel.Text = "Now Playing: " .. title .. " by " .. artist
    volumeBar.Text = "Volume: " .. math.floor(volume * 100) .. "%"
end

local function onAncestryChanged(child, parent)
    if not parent then
        updateNowPlaying()
    end
end

local function onSoundAdded(sound)
    sound.AncestryChanged:Connect(function(child, parent)
        onAncestryChanged(child, parent)
    end)
    updateNowPlaying()
end

local function onSoundPlaying(sound)
    updateNowPlaying()
end

local function onVolumeChanged(property)
    if property == "Volume" then
        updateNowPlaying()
    end
end

soundService = game:GetService("SoundService")
soundService.SoundAdded:Connect(onSoundAdded)
soundService.SoundPlaying:Connect(onSoundPlaying)

updateNowPlaying()

game:GetService("SoundService").SoundEnded:Connect(updateNowPlaying)
game:GetService("SoundService").SoundPaused:Connect(updateNowPlaying)
game:GetService("SoundService").SoundResumed:Connect(updateNowPlaying)
soundService.VolumeChanged:Connect(onVolumeChanged)

  return s
