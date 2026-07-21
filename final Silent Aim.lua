local ver = "2.0.0"

--// USERNAME WHITELIST - ONLY THESE USERS CAN USE THE SCRIPT
local authorizedUsers = {
    ["praisedracc"] = true,
    ["nomoremeaniespleasd"] = true,
    ["24zonia"] = true,
}

local plrs = game:GetService("Players")
local me = plrs.LocalPlayer

local myName = me.Name:lower()
local allowed = false
for user, _ in pairs(authorizedUsers) do
    if myName == user:lower() then
        allowed = true
        break
    end
end

if not allowed then
    me:Kick("Not authorized to use this script.")
    return
end

--// Rest of your script continues below...

local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local rep = game:GetService("ReplicatedStorage")
local sg = game:GetService("StarterGui")
local tw = game:GetService("TweenService")
local cg = game:GetService("CoreGui")
local gs = game:GetService("GuiService")
local teams = game:GetService("Teams")
local hs = game:GetService("HttpService")

local guardsT = teams:FindFirstChild("Guards")
local inmatesT = teams:FindFirstChild("Inmates")
local crimsT = teams:FindFirstChild("Criminals")

local wlFolder = "SilentAimWhitelist"
local wlFile = wlFolder .. "/whitelist.json"

local function loadWl()
	if not isfolder or not isfile then return {} end
	if not isfolder(wlFolder) then makefolder(wlFolder) end
	if not isfile(wlFile) then return {} end
	local ok, dat = pcall(function()
		return hs:JSONDecode(readfile(wlFile))
	end)
	if ok and typeof(dat) == "table" then return dat end
	return {}
end

local function saveWl(list)
	if not isfolder or not writefile then return end
	if not isfolder(wlFolder) then makefolder(wlFolder) end
	pcall(function()
		writefile(wlFile, hs:JSONEncode(list))
	end)
end

local wlPlrs = loadWl()

local function isWl(p)
	if not p then return false end
	return wlPlrs[tostring(p.UserId)] == true
end

local function toggleWl(p)
	if not p then return end
	local k = tostring(p.UserId)
	if wlPlrs[k] then wlPlrs[k] = nil else wlPlrs[k] = true end
	saveWl(wlPlrs)
end

local cfg = {
	enabled = true,
	teamcheck = true,
	wallcheck = true,
	deathcheck = true,
	ffcheck = true,
	hostilecheck = true,
	trespasscheck = true,
	vehiclecheck = true,
	criminalsnoinnmates = true,
	inmatesnocriminals = true,
	shieldbreaker = true,
	shieldfrontangle = 0.3,
	shieldrandomhead = true,
	shieldheadchance = 30,
	taserbypasshostile = false,
	taserbypasstrespass = false,
	taseralwayshit = true,
	ifplayerstill = false,
	stillthreshold = 0.5,
	hitchance = 65,
	hitchanceAutoOnly = false,
	distancebasedhitchance = false,
	distancehitchancepoints = {},
	distancehitchance1dist = 200,
	distancehitchance1value = 30,
	distancehitchance2dist = 350,
	distancehitchance2value = 20,
	distancehitchance3dist = 500,
	distancehitchance3value = 10,
	distancehitchance4dist = 650,
	distancehitchance4value = 5,
	distancehitchance5dist = 800,
	distancehitchance5value = 1,
	aimmaxdist = 100,
	missspread = 5,
	shotgunnaturalspread = true,
	shotgungamehandled = false,
	prioritizeclosest = true,
	prioritizecriminals = true,
	targetstickiness = false,
	targetstickinessduration = 0.6,
	targetstickinessrandom = false,
	targetstickinessmin = 0.3,
	targetstickinessmax = 0.7,
	fov = 150,
	showfov = true,
	staticfov = true,
	showtargetline = false,
	togglekey = Enum.KeyCode.RightShift,
	aimpart = "Head",
	randomparts = true,
	    partslist = {"Head", "Torso", "Upper Torso", "Lower Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart", "Left Upper Arm", "Left Lower Arm", "Right Upper Arm", "Right Lower Arm", "Left Upper Leg", "Left Lower Leg", "Right Upper Leg", "Right Lower Leg"},
	esp = true,
	espteamcheck = false,
	espshowteam = false,
	esptargets = {guards = true, inmates = true, criminals = true},
	espmaxdist = 500,
	espshowdist = true,
	esptoggle = Enum.KeyCode.RightControl,
	espcolor = Color3.fromRGB(0, 170, 255),
	espguards = Color3.fromRGB(0, 170, 255),
	espinmates = Color3.fromRGB(255, 150, 50),
	espcriminals = Color3.fromRGB(255, 60, 60),
	espteam = Color3.fromRGB(60, 255, 60),
	espuseteamcolors = true,
	autoshoot = false,
	autoshootweapon = "Any",
	autoshootdelay = 0.12,
	autoshootstartdelay = 0.2,
	autoshootlinger = true,
	autoshootlingermin = 0.8,
	autoshootlingermax = 1.8,
	autograb = true,
	autograbdistance = 12,
	autograbdelay = 1,
	autograbkeycard = true,
	autograbm9 = true,
	c4esp = true,
	c4esptoggle = Enum.KeyCode.B,
	c4espcolor = Color3.fromRGB(80, 255, 80),
	c4espmaxdist = 200,
	c4espshowdist = true,
	whitelistenabled = false,
	smoothing = 0.15,
	smoothingEnabled = true,
	smoothingDistEnabled = true,
	smoothingDistNear = 50,
	smoothingDistFar = 400,
	smoothingNearMult = 0.05,
	smoothingFarMult = 0.6,
	smoothingShootUntilOnTarget = true,
	smoothingOnTargetThreshold = 3,
	missFirstShot = true,
	missFirstShotChance = 100,
	reactionDelay = 0.12,
	reactionDelayEnabled = true,
	legitMode = false,
	dynamicHitchanceEnabled = false,
	movingMissPenalty = 15,
	jumpingMissPenalty = 25,
	stackBehaviorMiss = true,
	bodyPartWeightHead = 30,
	bodyPartWeightTorso = 25,
	bodyPartWeightArms = 10,
	bodyPartWeightLegs = 10,
	bodyPartWeightHRP = 15,
	bodyPartWeightUpperTorso = 20,
    bodyPartWeightLowerTorso = 15,
    bodyPartWeightUpperArm = 8,
    bodyPartWeightLowerArm = 6,
    bodyPartWeightUpperLeg = 8,
    bodyPartWeightLowerLeg = 6,
	jumpingTargetPart = "Torso",
	microCorrectionEnabled = true,
	microCorrectionAmount = 0.15,
	microCorrectionSpeed = 0.25,
	weaponProfiles = {
		Sniper = {hitchance = 85, smoothing = 0.05, fov = 60, missFirstShot = true},
		Shotgun = {hitchance = 90, smoothing = 0.3, fov = 70, missFirstShot = false},
		Taser = {hitchance = 60, smoothing = 0.4, fov = 100, missFirstShot = false},
		Automatic = {hitchance = 85, smoothing = 0.2, fov = 45, missFirstShot = true},
		Default = {hitchance = 65, smoothing = 0.15, fov = 50, missFirstShot = true},
	},
	weaponProfilesEnabled = true,
	--// NEW: Smart body part targeting
	smartBodyTargeting = false,
	jumpLegChance = 100,
	moveArmChance = 100,
	torsoBias = 35,
	torsoBiasEnabled = true,
	--// NEW: Mobile FOV
	mobileFovOffset = 0.14,
	--// NEW: Cross-team ESP
	crossTeamEsp = true,
	--// NEW: Criminal targeting filter
	crimTargetHostileOnly = true,
	crimTargetTrespassOnly = true,
	--// NEW: Target stickiness persist
	stickyPersistDeath = false,
	--// NEW: Target linger mode
	lingerLastVisible = true,
	--// Walkspeed + Noclip
	walkspeedEnabled = false,
	walkspeedValue = 28,
	walkspeedDefault = 16,
	noclipEnabled = false,
	targetSwitchCooldown = 0.3,
    targetSwitchCooldownEnabled = true,

}


local function deepCopy(v)
	if typeof(v) ~= "table" then return v end
	local c = {}
	for k, nv in pairs(v) do
		c[k] = deepCopy(nv)
	end
	return c
end

--// BYPASS ANTI-NOCLIP
--local function bypassAntiNoclip()
--	local charColl = rep:FindFirstChild("Scripts") and rep.Scripts:FindFirstChild("CharacterCollision")
--	if charColl then
	--	charColl:Destroy()
	--	local hd = me.Character and me.Character:FindFirstChild("Head")
	--	if hd then
	--		for _, conn in getconnections(hd:GetPropertyChangedSignal("CanCollide")) do
	--			conn:Disable()
	--		end
	--	end
--	end
--end--

--// APPLY NOCLIP
local function startNoclip()
	if noclipConn then noclipConn:Disconnect() end
	task.wait(0.05)
	noclipParts = {}
	noclipConn = rs.Stepped:Connect(function()
		if not cfg.noclipEnabled or not me.Character then return end
		for _, child in pairs(me.Character:GetDescendants()) do
			if child:IsA("BasePart") and child.CanCollide == true then
				child.CanCollide = false
				noclipParts[child] = true
			end
		end
	end)
end

--// STOP NOCLIP
local function stopNoclip()
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
	if me.Character then
		for _, child in pairs(me.Character:GetDescendants()) do
			if child:IsA("BasePart") and noclipParts[child] then
				child.CanCollide = true
			end
		end
	end
	noclipParts = {}
end

--// WALKSPEED
local function applySpeed(spd)
	local ch = me.Character
	if not ch then return false end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	if not hum then return false end
	hum.WalkSpeed = spd
	return true
end


local defaultCfg = deepCopy(cfg)

local wallParams = RaycastParams.new()
wallParams.FilterType = Enum.RaycastFilterType.Exclude
wallParams.IgnoreWater = true
wallParams.RespectCanCollide = false
wallParams.CollisionGroup = "ClientBullet"

local projParams = RaycastParams.new()
projParams.FilterType = Enum.RaycastFilterType.Exclude
projParams.IgnoreWater = true
projParams.RespectCanCollide = false
projParams.CollisionGroup = "ClientBullet"

local curGun = nil
local rng = Random.new()
local lastShot = 0
local lastShotRes = false
local shotCd = 1 / 30
local curTarget = nil
local targetSwitch = 0
local curSticky = 0
local partCache = {}
local lastTouchPos = nil
local activeTouch = nil
local mobGuiBtn = nil
local mobGuiDrag = nil
local lastAuto = 0
local cachedBulletsLbl = nil
local targetAcq = 0
local lastAutoTarget = nil
local lastReload = 0
local plrSettings = rep:FindFirstChild("PlayerSettings")
local mobCursorOff = 0
local inDynThumb = nil
local giverPressed = rep:FindFirstChild("Remotes") and rep.Remotes:FindFirstChild("GiverPressed")
local trackedGrab = {}
local firstSeenGrab = {}
local lastAutoGrab = 0

local firstShotMissed = {}
local lockStart = 0
local smoothPos = nil
local activeProf = nil
local lastTargetSwitchTime = 0

local microState = {
	active = false,
	start = 0,
	off = Vector3.zero,
	last = nil,
}

local linger = {
	active = false,
	endT = 0,
	lastTgt = nil,
	lastPos = nil,
	lastPart = nil,
}

local noDelaySwitch = {
	lastGun = nil,
	lastShoot = 0,
	acq = 0,
	lastTgt = nil,
}

--// Smart targeting state
local smartState = {
	jumpLegPicked = nil,
	moveArmPicked = nil,
	lastJumpState = false,
	lastMoveState = false,
}

do
	local shared = rep:FindFirstChild("SharedModules")
	local dyn = shared and shared:FindFirstChild("isInsideDynThumbFrame")
	if dyn then
		local ok, res = pcall(require, dyn)
		if ok and typeof(res) == "function" then inDynThumb = res end
	end
end

local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Radius = cfg.fov
fovCircle.Transparency = 0.8
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Thickness = 1
--// After this line:
fovCircle.Visible = cfg.showfov and cfg.enabled

--// ADD:
task.delay(0.5, function()
	local cam = workspace.CurrentCamera
	if cam then
		local vs = cam.ViewportSize
		fovCircle.Position = Vector2.new(vs.X / 2, vs.Y / 2)
	end
end)


local tgtLine = Drawing.new("Line")
tgtLine.Color = Color3.fromRGB(0, 255, 0)
tgtLine.Thickness = 1
tgtLine.Transparency = 0.5
tgtLine.Visible = false

local visuals = {container = nil}
local espCache = {}
local uiEls = {}
local resolveMacLibWin
local selDistPt = 1
local syncingDist = false
local storedAimMax = tonumber(cfg.aimmaxdist) or 0
local distForcesAimMax = false

local function fmtDistNum(v)
	if math.abs(v - math.floor(v)) < 0.001 then
		return tostring(math.floor(v))
	end
	return string.format("%.2f", v)
end

local function cloneDistPts(pts)
	local c = {}
	for _, p in ipairs(pts or {}) do
		c[#c + 1] = {distance = p.distance, chance = p.chance}
	end
	return c
end

local function normDistPts(pts)
	local base = math.clamp(tonumber(cfg.hitchance) or 0, 0, 100)
	local n = {}
	if typeof(pts) == "table" then
		for _, p in ipairs(pts) do
			if typeof(p) == "table" then
				n[#n + 1] = {
					distance = math.max(tonumber(p.distance or p.dist or p[1]) or 0, 0),
					chance = math.clamp(tonumber(p.chance or p.value or p[2]) or base, 0, 100)
				}
			end
		end
	end
	table.sort(n, function(a, b) return a.distance < b.distance end)
	return n
end

local function getDefDistPts()
	local base = math.clamp(tonumber(cfg.hitchance) or 0, 0, 100)
	return normDistPts({
		{distance = math.max(tonumber(cfg.distancehitchance1dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance1value) or base, 0, 100)},
		{distance = math.max(tonumber(cfg.distancehitchance2dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance2value) or base, 0, 100)},
		{distance = math.max(tonumber(cfg.distancehitchance3dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance3value) or base, 0, 100)},
		{distance = math.max(tonumber(cfg.distancehitchance4dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance4value) or base, 0, 100)},
		{distance = math.max(tonumber(cfg.distancehitchance5dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance5value) or base, 0, 100)}
	})
end

local function getDistPts()
	local pts = normDistPts(cfg.distancehitchancepoints)
	if #pts == 0 then pts = getDefDistPts() end
	return pts
end

local function ensureDistPts()
	local pts = getDistPts()
	if #pts == 0 then pts = {{distance = 200, chance = 30}} end
	cfg.distancehitchancepoints = cloneDistPts(pts)
	return cfg.distancehitchancepoints
end

local function distPtLbl(p, i)
	return string.format("%d. %s studs -> %s%%", i, fmtDistNum(p.distance), fmtDistNum(p.chance))
end

local function syncDistEditor()
	if syncingDist then return end
	syncingDist = true
	local pts = ensureDistPts()
	selDistPt = math.clamp(selDistPt, 1, math.max(#pts, 1))
	local lbls = {}
	for i, p in ipairs(pts) do lbls[i] = distPtLbl(p, i) end
	if uiEls.DistPtDrop then
		if uiEls.DistPtDrop.ClearOptions then uiEls.DistPtDrop:ClearOptions() end
		if uiEls.DistPtDrop.InsertOptions then uiEls.DistPtDrop:InsertOptions(lbls) end
		if lbls[selDistPt] and uiEls.DistPtDrop.UpdateSelection then
			uiEls.DistPtDrop:UpdateSelection(lbls[selDistPt])
		end
	end
	local sp = pts[selDistPt]
	if sp then
		if uiEls.SelDistSlider then uiEls.SelDistSlider:UpdateValue(sp.distance) end
		if uiEls.SelChanceSlider then uiEls.SelChanceSlider:UpdateValue(sp.chance) end
	end
	syncingDist = false
end

local function setDistEnabled(en)
	if en then
		if not distForcesAimMax then storedAimMax = tonumber(cfg.aimmaxdist) or 0 end
		cfg.distancebasedhitchance = true
		cfg.aimmaxdist = 0
		distForcesAimMax = true
	else
		cfg.distancebasedhitchance = false
		if distForcesAimMax then cfg.aimmaxdist = tonumber(storedAimMax) or 0 end
		distForcesAimMax = false
	end
end

local function syncDistAimMax()
	local cur = tonumber(cfg.aimmaxdist) or 0
	if cfg.distancebasedhitchance then
		if cur > 0 then storedAimMax = cur elseif storedAimMax <= 0 then storedAimMax = tonumber(defaultCfg.aimmaxdist) or 0 end
		cfg.aimmaxdist = 0
		distForcesAimMax = true
	else
		storedAimMax = cur
		distForcesAimMax = false
	end
end

local function loadLegitDist()
	cfg.hitchance = 94
	setDistEnabled(true)
	cfg.distancehitchancepoints = {
		{distance = 10,  chance = 94},
		{distance = 20,  chance = 85},
		{distance = 35,  chance = 78},
		{distance = 50,  chance = 73},
		{distance = 70,  chance = 66},
		{distance = 95,  chance = 60},
		{distance = 130, chance = 52},
		{distance = 155, chance = 48},
		{distance = 180, chance = 40},
		{distance = 200, chance = 36},
		{distance = 245, chance = 31},
		{distance = 270, chance = 28},
		{distance = 300, chance = 24},
	}
	selDistPt = 1
end




local function loadBlatantDist()
	cfg.hitchance = 99
	setDistEnabled(true)
	cfg.distancehitchancepoints = {
		{distance = 125, chance = 99}, {distance = 250, chance = 98}, {distance = 400, chance = 97},
		{distance = 600, chance = 95}, {distance = 850, chance = 92}, {distance = 1100, chance = 88},
		{distance = 1500, chance = 82}
	}
	selDistPt = 1
end

local function resetAim()
    lastTargetSwitchTime = 0
	lastShot = 0
	lastShotRes = false
	curTarget = nil
	targetSwitch = 0
	curSticky = 0
	lastAuto = 0
	lastAutoTarget = nil
	targetAcq = 0
	cachedBulletsLbl = nil
	linger.active = false
	linger.endT = 0
	linger.lastTgt = nil
	linger.lastPos = nil
	linger.lastPart = nil
	smoothPos = nil
	lockStart = 0
	microState.active = false
	microState.off = Vector3.zero
	microState.last = nil
	smartState.jumpLegPicked = nil
	smartState.moveArmPicked = nil
	smartState.lastJumpState = false
	smartState.lastMoveState = false
end

local function getHud()
	local pg = me:FindFirstChild("PlayerGui")
	local home = pg and pg:FindFirstChild("Home")
	return home and home:FindFirstChild("hud") or nil
end

local function getMobGunFrame()
	local h = getHud()
	return h and h:FindFirstChild("MobileGunFrame") or nil
end

local function getMobCursor()
	local f = getMobGunFrame()
	return f and f:FindFirstChild("MobileCursor") or nil
end

local function updMobCursorOff()
	if not plrSettings then mobCursorOff = 0 return end
	local off = plrSettings:GetAttribute("MobileCursorOffset")
	if typeof(off) == "number" then mobCursorOff = off * 15 else mobCursorOff = 0 end
end

if plrSettings then
	updMobCursorOff()
	plrSettings:GetAttributeChangedSignal("MobileCursorOffset"):Connect(updMobCursorOff)
end

local macLibBounds = nil

local function updateMacLibBounds()
	local wg = resolveMacLibWin and resolveMacLibWin()
	if not wg or not wg.Enabled then 
		macLibBounds = nil
		return 
	end
	local frame = wg:FindFirstChildOfClass("Frame") or wg:FindFirstChildWhichIsA("GuiObject")
	if frame then
		local ap = frame.AbsolutePosition
		local as = frame.AbsoluteSize
		macLibBounds = {X = ap.X, Y = ap.Y, W = as.X, H = as.Y}
	end
end

local function ignoreTouch(pos)
	if mobGuiDrag then return true end
	if inDynThumb and inDynThumb(pos.X, pos.Y) then return true end
	if mobGuiBtn and mobGuiBtn.Parent and mobGuiBtn.Visible then
		local ap = mobGuiBtn.AbsolutePosition
		local as = mobGuiBtn.AbsoluteSize
		if pos.X >= ap.X and pos.X <= ap.X + as.X 
		   and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y then
			return true
		end
	end
	if macLibBounds then
		if pos.X >= macLibBounds.X and pos.X <= macLibBounds.X + macLibBounds.W
		   and pos.Y >= macLibBounds.Y and pos.Y <= macLibBounds.Y + macLibBounds.H then
			return true
		end
	end
	local mf = getMobGunFrame()
	local ita = mf and mf:FindFirstChild("IgnoreTouchArea")
	if not ita then return false end
	local ap = ita.AbsolutePosition
	local as = ita.AbsoluteSize
	return pos.X >= ap.X and pos.X <= ap.X + as.X 
	   and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y
end

local function aimScreenPos(cam)
    cam = cam or workspace.CurrentCamera
    if not cam then return uis:GetMouseLocation() end

    if uis.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local vs = cam.ViewportSize
        return Vector2.new(vs.X / 2, vs.Y / 2)
    end

    local li = uis:GetLastInputType()
    if li == Enum.UserInputType.Touch then
        local mc = getMobCursor()
        if mc and mc.Visible then
            local p = mc.AbsolutePosition
            local s = mc.AbsoluteSize
            return Vector2.new(p.X + s.X / 2, p.Y + s.Y / 2)
        end
        --// FIX: On mobile with no cursor, use actual touch position instead of forcing center
        local tp = activeTouch and activeTouch.Position
        if tp then
            return Vector2.new(tp.X, tp.Y)
        end
        --// Only fallback to center if we genuinely have no touch data
        local vs = cam.ViewportSize
        return Vector2.new(vs.X / 2, vs.Y / 2)
    end

    return uis:GetMouseLocation()
end

local function screenCenter(cam)
	cam = cam or workspace.CurrentCamera
	if not cam then return Vector2.new(0, 0) end
	local vs = cam.ViewportSize
	return Vector2.new(vs.X / 2, vs.Y / 2)
end

local function fovScreenPos(cam)
	cam = cam or workspace.CurrentCamera
	if cfg.staticfov then
		return screenCenter(cam)
	end
	--// Non-static: use aim position (mouse/touch/cursor)
	local base = aimScreenPos(cam)
	
	--// Mobile offset for non-static FOV
	if uis.TouchEnabled and cfg.mobileFovOffset > 0 then
		local vp = cam and cam.ViewportSize
		if vp then
			local cx, cy = vp.X / 2, vp.Y / 2
			local dx, dy = base.X - cx, base.Y - cy
			local dist = math.sqrt(dx * dx + dy * dy)
			if dist > 0 then
				local off = cfg.mobileFovOffset * 100
				local ratio = math.max(0, (dist - off) / dist)
				return Vector2.new(cx + dx * ratio, cy + dy * ratio)
			end
		end
	end
	return base
end




local function isSniper(g) return g and g:GetAttribute("Behavior") == "Sniper" end
local function isTaser(g) return g and (g:GetAttribute("Behavior") == "Taser" or g:GetAttribute("Projectile") == "Taser") end
local function isShotgun(g) return g and (g:GetAttribute("IsShotgun") or g:GetAttribute("Behavior") == "Shotgun") end
local function isAuto(g) return g and g:GetAttribute("AutoFire") == true end

local function normWepSel(v) return tostring(v or ""):lower():gsub("%s+", "") end

local function gunMatchesAuto(g)
	if not g then return false end
	local sel = normWepSel(cfg.autoshootweapon)
	if sel == "" or sel == "any" or sel == "all" then return true end
	local gn = normWepSel(g.Name)
	local bh = normWepSel(g:GetAttribute("Behavior"))
	local pj = normWepSel(g:GetAttribute("Projectile"))
	if sel == "taser" then return isTaser(g) or gn:find("taser", 1, true) ~= nil end
	if sel == "shotgun" then return isShotgun(g) end
	if sel == "sniper" then return isSniper(g) end
	if sel == "auto" or sel == "automatic" then return isAuto(g) end
	return sel == gn or sel == bh or sel == pj
end

local function getAimOrigin()
	local ch = me.Character
	if not ch then return nil end
	return ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Head")
end

local function inAimDist(pos)
	local mx = tonumber(cfg.aimmaxdist) or 0
	if mx <= 0 or not pos then return true end
	local org = getAimOrigin()
	if not org then return true end
	return (pos - org.Position).Magnitude <= mx
end

local function bypassHitchance(g) return g ~= nil and cfg.hitchanceAutoOnly and not isAuto(g) end

local function getHum()
	local ch = me.Character
	return ch and ch:FindFirstChildOfClass("Humanoid") or nil
end

local function sniperStable(g)
	if not isSniper(g) then return true end
	if uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter then return false end
	local h = getHum()
	return not h or h:GetState() ~= Enum.HumanoidStateType.Freefall
end

local function fireOrigin()
	local ch = me.Character
	local hd = ch and ch:FindFirstChild("Head")
	if not hd then return nil end
	local mz = curGun and curGun:FindFirstChild("Muzzle")
	return mz and mz.Position or hd.Position
end

local function inGunRange(pos, org)
	if not curGun or not pos then return true end
	local r = curGun:GetAttribute("Range")
	if typeof(r) ~= "number" or r <= 0 then return true end
	org = org or fireOrigin()
	if not org then return true end
	return (pos - org).Magnitude <= r + 5
end

local function isGrabObj(o)
	if not o or not o:IsA("Model") then return false end
	local n = o.Name:lower()
	return n:find("keycard", 1, true) ~= nil or n == "m9"
end

local function shouldGrab(o)
	if not cfg.autograb or not o or not o:IsA("Model") then return false end
	local n = o.Name:lower()
	if n:find("keycard", 1, true) ~= nil then return cfg.autograbkeycard end
	if n == "m9" then return cfg.autograbm9 end
	return false
end

local function ownedGrab(o)
	local a = o and o.Parent
	while a and a ~= workspace do
		if a:FindFirstChildOfClass("Humanoid") then return true end
		if a.Name == "Backpack" then return true end
		a = a.Parent
	end
	return false
end

local function grabPart(m) return m and (m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart", true)) or nil end

local function distSq(a, b)
	local d = a - b
	return d.X * d.X + d.Y * d.Y + d.Z * d.Z
end

local function trackGrab(o)
	if isGrabObj(o) then trackedGrab[o] = true end
end

local function untrackGrab(o)
	trackedGrab[o] = nil
	firstSeenGrab[o] = nil
end

local function updAutoGrab(now)
	if not cfg.autograb or not giverPressed then return end
	if now - lastAutoGrab < 0.05 then return end
	local r = getAimOrigin()
	if not r then return end
	local gd = math.clamp(tonumber(cfg.autograbdistance) or 0, 0, 12)
	if gd <= 0 then return end
	local rd = math.max(tonumber(cfg.autograbdelay) or 0, 0)
	local gds = gd * gd
	for item in pairs(trackedGrab) do
		if not item or not item.Parent then untrackGrab(item)
		elseif not shouldGrab(item) then firstSeenGrab[item] = nil
		elseif ownedGrab(item) then firstSeenGrab[item] = nil
		else
			local p = grabPart(item)
			if p and distSq(r.Position, p.Position) <= gds then
				if not firstSeenGrab[item] then firstSeenGrab[item] = now
				elseif now - firstSeenGrab[item] >= rd then
					lastAutoGrab = now
					firstSeenGrab[item] = nil
					pcall(giverPressed.FireServer, giverPressed, item)
					return
				end
			else firstSeenGrab[item] = nil end
		end
	end
end

local function instantAcqDelay(g)
	if not g then return false end
	local li = uis:GetLastInputType()
	return li == Enum.UserInputType.Touch or li == Enum.UserInputType.Gamepad1 or isShotgun(g)
end

local function simProjImpact(sp, ap, g)
	if not g or not sp or not ap then return nil, ap end
	local bh = g:GetAttribute("Behavior")
	local spr = g:GetAttribute("SpreadRadius") or 0
	local r = g:GetAttribute("Range") or 1500
	local sc = rng:NextNumber()
	if bh == "Sniper" or bh == "Shotgun" then sc = math.sqrt(sc) end
	local base = CFrame.new(sp, ap)
	local ra = math.rad(360 - 720 * rng:NextNumber())
	local dir = (base * CFrame.Angles(0, 0, ra) * CFrame.Angles(0, sc * spr, 0)).LookVector * r
	projParams.FilterDescendantsInstances = {me.Character}
	local res = workspace:Raycast(sp, dir, projParams)
	if res then return res.Instance, res.Position end
	return nil, sp + dir
end


local function mkVisuals()
	local c
	local gp = (gethui and gethui()) or cg
	local ex = gp:FindFirstChild("SilentAimESP") or cg:FindFirstChild("SilentAimESP")
	if ex then ex:Destroy() end
	if gethui then
		local s = Instance.new("ScreenGui")
		s.Name = "SilentAimESP"
		s.ResetOnSpawn = false
		s.Parent = gethui()
		c = s
	elseif syn and syn.protect_gui then
		local s = Instance.new("ScreenGui")
		s.Name = "SilentAimESP"
		s.ResetOnSpawn = false
		syn.protect_gui(s)
		s.Parent = cg
		c = s
	else
		local s = Instance.new("ScreenGui")
		s.Name = "SilentAimESP"
		s.ResetOnSpawn = false
		s.Parent = cg
		c = s
	end
	visuals.container = c
end

local function mkEsp(p)
	if espCache[p] then return espCache[p] end
	local e = Instance.new("BillboardGui")
	e.Name = "ESP_" .. p.Name
	e.AlwaysOnTop = true
	e.Size = UDim2.new(0, 20, 0, 20)
	e.StudsOffset = Vector3.new(0, 3, 0)
	e.LightInfluence = 0
	local d = Instance.new("Frame")
	d.Name = "Diamond"
	d.BackgroundColor3 = cfg.espcolor
	d.BorderSizePixel = 0
	d.Size = UDim2.new(0, 10, 0, 10)
	d.Position = UDim2.new(0.5, -5, 0.5, -5)
	d.Rotation = 45
	d.Parent = e
	local st = Instance.new("UIStroke")
	st.Color = Color3.new(0, 0, 0)
	st.Thickness = 1.5
	st.Transparency = 0.3
	st.Parent = d
	local dl = Instance.new("TextLabel")
	dl.Name = "DistanceLabel"
	dl.BackgroundTransparency = 1
	dl.Size = UDim2.new(0, 60, 0, 16)
	dl.Position = UDim2.new(0.5, -30, 1, 2)
	dl.Font = Enum.Font.GothamBold
	dl.TextSize = 11
	dl.TextColor3 = Color3.new(1, 1, 1)
	dl.TextStrokeTransparency = 0.5
	dl.TextStrokeColor3 = Color3.new(0, 0, 0)
	dl.Text = ""
	dl.Parent = e
	local nl = Instance.new("TextLabel")
	nl.Name = "NameLabel"
	nl.BackgroundTransparency = 1
	nl.Size = UDim2.new(0, 100, 0, 14)
	nl.Position = UDim2.new(0.5, -50, 0, -16)
	nl.Font = Enum.Font.GothamBold
	nl.TextSize = 10
	nl.TextColor3 = Color3.new(1, 1, 1)
	nl.TextStrokeTransparency = 0.5
	nl.TextStrokeColor3 = Color3.new(0, 0, 0)
	nl.Text = p.Name
	nl.Parent = e
	espCache[p] = e
	return e
end

local function rmEsp(p)
	local e = espCache[p]
	if e then e:Destroy() espCache[p] = nil end
	if p and p.Character then partCache[p.Character] = nil end
	if curTarget == p then curTarget = nil end
	if lastAutoTarget == p then lastAutoTarget = nil end
end

local function shouldShowEsp(p)
	if not p or p == me or not p.Character then return false end
	local h = p.Character:FindFirstChildOfClass("Humanoid")
	if not h or h.Health <= 0 then return false end
	local hrp = p.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local myCh = me.Character
	if not myCh then return false end
	local myHrp = myCh:FindFirstChild("HumanoidRootPart")
	if not myHrp then return false end
	local d = (hrp.Position - myHrp.Position).Magnitude
	local em = tonumber(cfg.espmaxdist) or 0
	if em > 0 and d > em then return false end
	local myT = me.Team
	local theirT = p.Team
	if theirT == myT then
		if not cfg.espshowteam then return false end
		return true
	end
	if cfg.espteamcheck then
		local imCrimOrIn = (myT == crimsT or myT == inmatesT)
		local theyCrimOrIn = (theirT == crimsT or theirT == inmatesT)
		if imCrimOrIn and theyCrimOrIn then return false end
	end
	--// Cross-team ESP
	if cfg.crossTeamEsp then
		if myT == inmatesT and theirT == crimsT then return true end
		if myT == crimsT and theirT == inmatesT then return true end
	end
	if theirT == guardsT then return cfg.esptargets.guards
	elseif theirT == inmatesT then return cfg.esptargets.inmates
	elseif theirT == crimsT then return cfg.esptargets.criminals end
	return false
end

local function updEsp()
	if not cfg.esp or not visuals.container then
		for _, e in pairs(espCache) do e.Parent = nil end
		return
	end
	local myCh = me.Character
	local myHrp = myCh and myCh:FindFirstChild("HumanoidRootPart")
	for _, p in ipairs(plrs:GetPlayers()) do
		local show = shouldShowEsp(p)
		if show then
			local ch = p.Character
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			local hd = ch and ch:FindFirstChild("Head")
			if hrp and hd then
				local e = mkEsp(p)
				e.Adornee = hd
				e.Parent = visuals.container
				local d = e:FindFirstChild("Diamond")
				if d and cfg.espuseteamcolors then
					local t = p.Team
					if t == me.Team then d.BackgroundColor3 = cfg.espteam
					elseif t == guardsT then d.BackgroundColor3 = cfg.espguards
					elseif t == inmatesT then d.BackgroundColor3 = cfg.espinmates
					elseif t == crimsT then d.BackgroundColor3 = cfg.espcriminals
					else d.BackgroundColor3 = cfg.espcolor end
				end
				if cfg.espshowdist and myHrp then
					local l = e:FindFirstChild("DistanceLabel")
					if l then l.Text = math.floor((hrp.Position - myHrp.Position).Magnitude) .. "m" l.Visible = true end
				else
					local l = e:FindFirstChild("DistanceLabel")
					if l then l.Visible = false end
				end
			end
		else
			local e = espCache[p]
			if e then e.Parent = nil end
		end
	end
end

local c4Cache = {}

local function mkC4Esp(pt)
	if c4Cache[pt] then return c4Cache[pt] end
	local e = Instance.new("BillboardGui")
	e.Name = "C4ESP_" .. tostring(pt)
	e.AlwaysOnTop = true
	e.Size = UDim2.new(0, 24, 0, 24)
	e.StudsOffset = Vector3.new(0, 1, 0)
	e.LightInfluence = 0
	local i = Instance.new("Frame")
	i.Name = "Icon"
	i.BackgroundColor3 = cfg.c4espcolor
	i.BorderSizePixel = 0
	i.Size = UDim2.new(0, 14, 0, 14)
	i.Position = UDim2.new(0.5, -7, 0.5, -7)
	i.Rotation = 45
	i.Parent = e
	local st = Instance.new("UIStroke")
	st.Color = Color3.new(0, 0, 0)
	st.Thickness = 2
	st.Transparency = 0.2
	st.Parent = i
	local l = Instance.new("TextLabel")
	l.Name = "Label"
	l.BackgroundTransparency = 1
	l.Size = UDim2.new(0, 60, 0, 14)
	l.Position = UDim2.new(0.5, -30, 1, 2)
	l.Font = Enum.Font.GothamBold
	l.TextSize = 11
	l.TextColor3 = Color3.new(1, 1, 1)
	l.TextStrokeTransparency = 0.5
	l.TextStrokeColor3 = Color3.new(0, 0, 0)
	l.Text = "C4"
	l.Parent = e
	local dl = Instance.new("TextLabel")
	dl.Name = "DistLabel"
	dl.BackgroundTransparency = 1
	dl.Size = UDim2.new(0, 60, 0, 12)
	dl.Position = UDim2.new(0.5, -30, 1, 16)
	dl.Font = Enum.Font.GothamBold
	dl.TextSize = 10
	dl.TextColor3 = cfg.c4espcolor
	dl.TextStrokeTransparency = 0.5
	dl.TextStrokeColor3 = Color3.new(0, 0, 0)
	dl.Text = ""
	dl.Parent = e
	c4Cache[pt] = e
	return e
end

local trackedC4 = {}

local function isC4(pt)
    if not pt or not pt:IsA("BasePart") then return false end
    local n = pt.Name:lower()
    local pn = pt.Parent and pt.Parent.Name:lower() or ""
    
    --// FIX: Ignore anything parented under a player character
    local parent = pt.Parent
    while parent do
        if parent:FindFirstChildOfClass("Humanoid") then
            return false -- It's on a player's body
        end
        parent = parent.Parent
    end
    
    --// Only match actual C4 explosive parts, not random "c4" named things
    return n == "explosive" or n == "c4" or n == "clientc4" or pn == "c4" or pn == "explosive"
end


local function onDescAdd(desc)
    --// FIX: Don't track C4 if it's inside a player character
    if isC4(desc) then
        local parent = desc.Parent
        local isOnPlayer = false
        while parent do
            if parent:FindFirstChildOfClass("Humanoid") then
                isOnPlayer = true
                break
            end
            parent = parent.Parent
        end
        if not isOnPlayer then
            trackedC4[desc] = true
        end
    end
    trackGrab(desc)
end


local function onDescRem(desc)
	trackedC4[desc] = nil
	if c4Cache[desc] then c4Cache[desc]:Destroy() c4Cache[desc] = nil end
	untrackGrab(desc)
end

for _, d in ipairs(workspace:GetDescendants()) do
	if isC4(d) then trackedC4[d] = true end
	trackGrab(d)
end
workspace.DescendantAdded:Connect(onDescAdd)
workspace.DescendantRemoving:Connect(onDescRem)
workspace.DescendantAdded:Connect(trackGrab)
workspace.DescendantRemoving:Connect(untrackGrab)

local function updC4Esp()
	if not cfg.c4esp or not visuals.container then
		for _, e in pairs(c4Cache) do e.Parent = nil end
		return
	end
	local myCh = me.Character
	local myHrp = myCh and myCh:FindFirstChild("HumanoidRootPart")
	for pt in pairs(trackedC4) do
		if pt and pt:IsDescendantOf(workspace) then
			local d = 0
			if myHrp then d = (pt.Position - myHrp.Position).Magnitude end
			local cm = tonumber(cfg.c4espmaxdist) or 0
			if cm <= 0 or d <= cm then
				local e = mkC4Esp(pt)
				e.Adornee = pt
				e.Parent = visuals.container
				if cfg.c4espshowdist and myHrp then
					local dl = e:FindFirstChild("DistLabel")
					if dl then dl.Text = math.floor(d) .. "m" end
				else
					local dl = e:FindFirstChild("DistLabel")
					if dl then dl.Text = "" end
				end
			else
				local e = c4Cache[pt]
				if e then e.Parent = nil end
			end
		else
			trackedC4[pt] = nil
			if c4Cache[pt] then c4Cache[pt]:Destroy() c4Cache[pt] = nil end
		end
	end
end

mkVisuals()


local partMap = {
    Torso = {"Torso", "Upper Torso", "Lower Torso"},
    LeftArm = {"Left Arm", "Left Upper Arm", "Left Lower Arm"},
    RightArm = {"Right Arm", "Right Upper Arm", "Right Lower Arm"},
    LeftLeg = {"Left Leg", "Left Upper Leg", "Left Lower Leg"},
    RightLeg = {"Right Leg", "Right Upper Leg", "Right Lower Leg"}
}


local bpWeightMap = {
    Head = "bodyPartWeightHead",
    Torso = "bodyPartWeightTorso",
    ["Upper Torso"] = "bodyPartWeightUpperTorso",
    ["Lower Torso"] = "bodyPartWeightLowerTorso",
    ["Left Arm"] = "bodyPartWeightArms",
    ["Right Arm"] = "bodyPartWeightArms",
    ["Left Upper Arm"] = "bodyPartWeightUpperArm",
    ["Left Lower Arm"] = "bodyPartWeightLowerArm",
    ["Right Upper Arm"] = "bodyPartWeightUpperArm",
    ["Right Lower Arm"] = "bodyPartWeightLowerArm",
    ["Left Leg"] = "bodyPartWeightLegs",
    ["Right Leg"] = "bodyPartWeightLegs",
    ["Left Upper Leg"] = "bodyPartWeightUpperLeg",
    ["Left Lower Leg"] = "bodyPartWeightLowerLeg",
    ["Right Upper Leg"] = "bodyPartWeightUpperLeg",
    ["Right Lower Leg"] = "bodyPartWeightLowerLeg",
    HumanoidRootPart = "bodyPartWeightHRP",
}



local function normPart(n) return tostring(n or ""):gsub("%s+", "") end

local function getPart(ch, n)
	if not ch then return nil end
	local p = ch:FindFirstChild(n)
	if p then return p end
	local m = partMap[normPart(n)]
	if m then
		for _, nm in ipairs(m) do
			local fp = ch:FindFirstChild(nm)
			if fp then return fp end
		end
	end
	return ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Head")
end

local function getTaserPart(ch)
	if not ch then return nil end
	return ch:FindFirstChild("Torso") or ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Head")
end

local function getWgtRandPart(ch)
	local tw = 0
	local ent = {}
	for _, pn in ipairs(cfg.partslist) do
		local wk = bpWeightMap[pn]
		local w = wk and cfg[wk] or 10
		local p = getPart(ch, pn)
		if p then
			tw = tw + w
			ent[#ent + 1] = {part = p, name = pn, weight = w}
		end
	end
	if tw <= 0 or #ent == 0 then return getPart(ch, "Head") end
	local roll = rng:NextNumber(0, tw)
	local cum = 0
	for _, e in ipairs(ent) do
		cum = cum + e.weight
		if roll <= cum then
			partCache[ch] = {part = e.part, name = e.name, expires = os.clock() + 0.15}
			return e.part
		end
	end
	partCache[ch] = {part = ent[#ent].part, name = ent[#ent].name, expires = os.clock() + 0.15}
	return ent[#ent].part
end

local function isMoving(p)
	if not p or not p.Character then return false end
	local hrp = p.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local v = hrp.AssemblyLinearVelocity
	return Vector3.new(v.X, 0, v.Z).Magnitude > 2
end

local function isJumping(p)
	if not p or not p.Character then return false end
	local h = p.Character:FindFirstChildOfClass("Humanoid")
	if not h then return false end
	local s = h:GetState()
	return s == Enum.HumanoidStateType.Jumping or s == Enum.HumanoidStateType.Freefall
end

--// Smart body part targeting
local function getSmartPart(ch, p)
	if not cfg.smartBodyTargeting or not ch then return nil end
	local jumping = isJumping(p)
	local moving = isMoving(p)
	
	-- Reset picks on state change
	if jumping ~= smartState.lastJumpState then
		smartState.jumpLegPicked = nil
		smartState.lastJumpState = jumping
	end
	if moving ~= smartState.lastMoveState then
		smartState.moveArmPicked = nil
		smartState.lastMoveState = moving
	end
	
	if jumping then
		if rng:NextInteger(1, 100) <= cfg.jumpLegChance then
			if not smartState.jumpLegPicked then
				local ll = getPart(ch, "Left Leg")
				local rl = getPart(ch, "Right Leg")
				if ll and rl then
					smartState.jumpLegPicked = rng:NextInteger(1, 2) == 1 and ll or rl
				elseif ll then
					smartState.jumpLegPicked = ll
				elseif rl then
					smartState.jumpLegPicked = rl
				end
			end
			return smartState.jumpLegPicked
		end
	end
	
	if moving then
		if rng:NextInteger(1, 100) <= cfg.moveArmChance then
			if not smartState.moveArmPicked then
				local la = getPart(ch, "Left Arm")
				local ra = getPart(ch, "Right Arm")
				-- Pick visible arm, or random if both visible
				local cam = workspace.CurrentCamera
				if cam then
					local laVis = la and cam:WorldToViewportPoint(la.Position).Z > 0
					local raVis = ra and cam:WorldToViewportPoint(ra.Position).Z > 0
					if laVis and not raVis then
						smartState.moveArmPicked = la
					elseif raVis and not laVis then
						smartState.moveArmPicked = ra
					elseif laVis and raVis then
						smartState.moveArmPicked = rng:NextInteger(1, 2) == 1 and la or ra
					elseif la then
						smartState.moveArmPicked = la
					elseif ra then
						smartState.moveArmPicked = ra
					end
				else
					smartState.moveArmPicked = rng:NextInteger(1, 2) == 1 and la or ra
				end
			end
			return smartState.moveArmPicked
		end
	end
	
	-- Torso bias
	if cfg.torsoBiasEnabled and rng:NextInteger(1, 100) <= cfg.torsoBias then
		return getPart(ch, "Torso")
	end
	
	return nil
end

local function getTargetPart(ch)
	if not ch then return nil end
	if isTaser(curGun) then return getTaserPart(ch) end
	local p = plrs:GetPlayerFromCharacter(ch)
	
	-- Smart targeting first
	if p then
		local smart = getSmartPart(ch, p)
		if smart then return smart end
	end
	
	-- Jumping override
	if p and cfg.jumpingTargetPart ~= "" and isJumping(p) then
		local jp = getPart(ch, cfg.jumpingTargetPart)
		if jp then return jp end
	end
	
	if cfg.shieldbreaker then
		local sh = ch:FindFirstChild("RiotShieldPart")
		if sh and sh:IsA("BasePart") then
			local hp = sh:GetAttribute("Health")
			if hp and hp > 0 then
				local myCh = me.Character
				local myHrp = myCh and myCh:FindFirstChild("HumanoidRootPart")
				local th = ch:FindFirstChild("HumanoidRootPart")
				if myHrp and th then
					local tm = (myHrp.Position - th.Position).Unit
					local tl = th.CFrame.LookVector
					local dt = tm:Dot(tl)
					if dt > cfg.shieldfrontangle then
						if cfg.shieldrandomhead and rng:NextInteger(1, 100) <= cfg.shieldheadchance then
							return getPart(ch, "Head")
						end
						return sh
					end
				end
			end
		end
	end
	
	if cfg.randomparts then
		local c = partCache[ch]
		if c and c.part and c.part.Parent == ch and c.expires > os.clock() then return c.part end
		return getWgtRandPart(ch)
	end
	
	return getPart(ch, cfg.aimpart)
end

local function isDead(p)
	if not p or not p.Character then return true end
	local h = p.Character:FindFirstChildOfClass("Humanoid")
	return not h or h.Health <= 0
end

local function isStanding(p)
	if not p or not p.Character then return false end
	local hrp = p.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local v = hrp.AssemblyLinearVelocity
	return Vector2.new(v.X, v.Z).Magnitude <= cfg.stillthreshold
end

local function hasFF(p)
	if not p or not p.Character then return false end
	return p.Character:FindFirstChildOfClass("ForceField") ~= nil
end

local function inVehicle(p)
	if not p or not p.Character then return false end
	local h = p.Character:FindFirstChildOfClass("Humanoid")
	if not h then return false end
	return h.SeatPart ~= nil
end

local wallCheckParams = RaycastParams.new()
wallCheckParams.FilterType = Enum.RaycastFilterType.Blacklist
wallCheckParams.IgnoreWater = true

local function wallBetween(sp, ep, tc)
    if not sp or not ep then return true end
    local myCh = me.Character
    if not myCh or not tc then return true end
    wallCheckParams.FilterDescendantsInstances = {myCh}
    local dir = ep - sp
    local dist = dir.Magnitude
    if dist <= 0.001 then return false end
    local res = workspace:Raycast(sp, dir, wallCheckParams)
    if not res then return false end
    if res.Instance:IsDescendantOf(tc) then return false end
    return true
end


local function quickCheck(p)
	if not p or p == me or not p.Character then return false end
	if cfg.whitelistenabled then
		if isWl(p) then return false end
	end
	local tp = getTargetPart(p.Character)
	if not tp then return false end
	if not inAimDist(tp.Position) then return false end
	if not inGunRange(tp.Position) then return false end
	if cfg.deathcheck and isDead(p) then return false end
	if cfg.ffcheck and hasFF(p) then return false end
	if cfg.vehiclecheck and inVehicle(p) then return false end
	if cfg.teamcheck and p.Team == me.Team then return false end
	if cfg.criminalsnoinnmates then
		if me.Team == crimsT and p.Team == inmatesT then return false end
	end
	if cfg.inmatesnocriminals then
		if me.Team == inmatesT and p.Team == crimsT then return false end
	end
	if cfg.hostilecheck or cfg.trespasscheck then
		local isT = isTaser(curGun)
		local bypH = cfg.taserbypasshostile and isT
		local bypT = cfg.taserbypasstrespass and isT
		local tc = p.Character
		if me.Team == guardsT and p.Team == inmatesT then
			local hostile = tc:GetAttribute("Hostile")
			local trespass = tc:GetAttribute("Trespassing")
			if cfg.hostilecheck and cfg.trespasscheck then
				if not bypH and not bypT then
					if not hostile and not trespass then return false end
				end
			elseif cfg.hostilecheck and not bypH then
				if not hostile then return false end
			elseif cfg.trespasscheck and not bypT then
				if not trespass then return false end
			end
		end
	end
	--// Criminal targeting filter
	if me.Team == crimsT and p.Team == inmatesT and cfg.crimTargetHostileOnly then
		local tc = p.Character
		local hostile = tc:GetAttribute("Hostile")
		local trespass = tc:GetAttribute("Trespassing")
		if cfg.hostilecheck and cfg.trespasscheck then
			if not hostile and not trespass then return false end
		elseif cfg.hostilecheck then
			if not hostile then return false end
		elseif cfg.trespasscheck then
			if not trespass then return false end
		end
	end
	return true
end

local function fullCheck(p)
	if not quickCheck(p) then return false end
	if cfg.wallcheck then
		local myCh = me.Character
		local tp = getTargetPart(p.Character)
		if not tp then return false end
		local cam = workspace.CurrentCamera
		local org = cam and cam.CFrame.Position or nil
		if not org then
			local hd = myCh and myCh:FindFirstChild("Head")
			org = hd and hd.Position
		end
		if org and wallBetween(org, tp.Position, p.Character) then return false end
	end
	return true
end

local function rollHit(co)
	lastShot = os.clock()
	local c = math.clamp(tonumber(co) or tonumber(cfg.hitchance) or 0, 0, 100)
	if c >= 100 then lastShotRes = true
	elseif c <= 0 then lastShotRes = false
	else lastShotRes = rng:NextInteger(1, 100) <= c end
	return lastShotRes
end

local function getDistHitChance(tp, org)
	local base = math.clamp(tonumber(cfg.hitchance) or 0, 0, 100)
	if not cfg.distancebasedhitchance then return base end
	if not tp then return base end
	local o = org or fireOrigin()
	if not o then
		local ap = getAimOrigin()
		o = ap and ap.Position or nil
	end
	if not o then return base end
	local d = (tp.Position - o).Magnitude
	local sc = base
	local pts = getDistPts()
	for _, pt in ipairs(pts) do
		if pt.distance > 0 and d >= pt.distance then sc = pt.chance end
	end
	return sc
end

local function getDynHitChance(tp, org, tgt)
	local base = getDistHitChance(tp, org)
	if not cfg.dynamicHitchanceEnabled or not tgt then return base end
	local mv = isMoving(tgt)
	local jp = isJumping(tgt)
	if not mv and not jp then return base end
	local pen = 0
	if cfg.stackBehaviorMiss then
		if mv then pen = pen + cfg.movingMissPenalty end
		if jp then pen = pen + cfg.jumpingMissPenalty end
	else
		pen = math.max(mv and cfg.movingMissPenalty or 0, jp and cfg.jumpingMissPenalty or 0)
	end
	return math.clamp(base - pen, 0, 100)
end

local function getMissPos(sp, tpp)
	local tp = typeof(tpp) == "Instance" and tpp:IsA("BasePart") and tpp or nil
	local ep = tp and tp.Position or tpp
	if not ep then return sp end
	local tt = ep - sp
	if tt.Magnitude <= 0.001 then return ep + Vector3.new(cfg.missspread + 6, 0, 0) end
	local dir = tt.Unit
	local ref = math.abs(dir.Y) > 0.98 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0)
	local rt = dir:Cross(ref)
	if rt.Magnitude <= 0.001 then rt = Vector3.new(0, 0, 1) else rt = rt.Unit end
	local up = rt:Cross(dir)
	if up.Magnitude <= 0.001 then up = Vector3.new(0, 1, 0) else up = up.Unit end
	local rad = tp and math.max(tp.Size.X, tp.Size.Y, tp.Size.Z) * 0.75 or 2
	local mr = math.max(cfg.missspread, rad + 3)
	local ang = rng:NextNumber(0, math.pi * 2)
	local off = rt * math.cos(ang) * mr + up * math.sin(ang) * mr
	return ep + off
end

local function getFovPriority(p)
	if not cfg.prioritizecriminals then return 0 end
	if p.Team == crimsT then return 0 end
	if p.Team == inmatesT then return 1 end
	return 0
end

local function applyMicroCorr(tp, dt, tgt)
    if not cfg.microCorrectionEnabled or not tgt then return tp end
    
    --// FIX: Better overshoot that feels more human
    if microState.last ~= tgt then
        microState.last = tgt
        microState.active = true
        microState.start = os.clock()
        
        local ch = tgt.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local vel = hrp and hrp.AssemblyLinearVelocity or Vector3.zero
        
        --// Randomize overshoot direction more
        local hv = Vector3.new(vel.X, 0, vel.Z)
        local baseDir
        if hv.Magnitude > 0.5 then
            baseDir = hv.Unit
        else
            baseDir = Vector3.new(rng:NextNumber(-1, 1), 0, rng:NextNumber(-1, 1)).Unit
        end
        
        --// Add perpendicular offset for more realistic overshoot
        local perp = Vector3.new(-baseDir.Z, 0, baseDir.X)
        local perpAmount = rng:NextNumber(-0.5, 0.5)
        local finalDir = (baseDir + perp * perpAmount).Unit
        
        --// Randomize overshoot amount per-target
        local amount = cfg.microCorrectionAmount * rng:NextNumber(0.7, 1.4)
        microState.off = finalDir * amount
        microState.overshootAmount = amount
    end
    
    if not microState.active then return tp end
    
    local el = os.clock() - microState.start
    local dur = math.max(cfg.microCorrectionSpeed, 0.01)
    
    if el >= dur then 
        microState.active = false 
        return tp 
    end
    
    --// FIX: Better easing - overshoot then settle back
    local t = el / dur
    --// Use sine wave for oscillating overshoot effect
    local ease = math.sin(t * math.pi) * (1 - t)
    
    --// Decay the offset over time
    local decay = math.exp(-t * 3)
    
    return tp + microState.off * ease * decay
end


local function getSmoothPos(tp, dt, tgt)
	local cp = applyMicroCorr(tp, dt, tgt)
	if not cfg.smoothingEnabled or cfg.smoothing <= 0 then
		smoothPos = cp
		return cp
	end
	if not smoothPos then
		smoothPos = cp
		return cp
	end
	
	--// Distance-based smoothing
	local finalSmooth = cfg.smoothing
	if cfg.smoothingDistEnabled and tgt and tgt.Character then
		local myCh = me.Character
		local myHrp = myCh and myCh:FindFirstChild("HumanoidRootPart")
		local tgtHrp = tgt.Character:FindFirstChild("HumanoidRootPart")
		if myHrp and tgtHrp then
			local dist = (myHrp.Position - tgtHrp.Position).Magnitude
			local near = cfg.smoothingDistNear
			local far = cfg.smoothingDistFar
			
			local t
			if dist <= near then
				t = 0
			elseif dist >= far then
				t = 1
			else
				t = (dist - near) / (far - near)
			end
			
			local distMult = cfg.smoothingNearMult + (cfg.smoothingFarMult - cfg.smoothingNearMult) * t
			finalSmooth = math.clamp(cfg.smoothing * distMult, 0.001, 0.99)
		end
	end
	
	local spd = math.clamp((1.05 - finalSmooth) * 18, 0.5, 18)
	local a = 1 - math.exp(-dt * spd)
	smoothPos = smoothPos:Lerp(cp, a)
	return smoothPos
end


local function shouldMissFirst(tgt)
	if not cfg.missFirstShot then return false end
	local k = tostring(tgt.UserId)
	if firstShotMissed[k] then return false end
	firstShotMissed[k] = true
	return rng:NextInteger(1, 100) <= cfg.missFirstShotChance
end

local function resetMissFirst(tgt)
	if not tgt then return end
	firstShotMissed[tostring(tgt.UserId)] = nil
end

local function applyWepProf(g)
	if not cfg.weaponProfilesEnabled or not g then
		activeProf = nil
		return
	end
	local bh = g:GetAttribute("Behavior") or "Default"
	local pr = cfg.weaponProfiles[bh] or cfg.weaponProfiles.Default
	if not pr then return end
	activeProf = pr
	cfg.hitchance = pr.hitchance
	cfg.smoothing = pr.smoothing
	cfg.fov = pr.fov
	cfg.missFirstShot = pr.missFirstShot
end

--// Stickiness persist state
local stickyPersist = {
	target = nil,
	stickyEnd = 0,
	stickyVal = 0,
}

local function isOnTarget(tgt)
    if not cfg.smoothingShootUntilOnTarget then return true end
    if not cfg.smoothingEnabled then return true end
    if not tgt or not tgt.Character then return false end --// FIX: return false, not true
    
    local cam = workspace.CurrentCamera
    if not cam then return false end --// FIX: return false, not true
    
    local pt = getTargetPart(tgt.Character)
    if not pt then return false end --// FIX: return false, not true
    
    local sp, on = cam:WorldToViewportPoint(pt.Position)
    if not on then return false end
    
    local fp = fovScreenPos(cam)
    local dist = (Vector2.new(sp.X, sp.Y) - fp).Magnitude
    
    --// FIX: Use smoothPos if available to check where aim actually is
    if smoothPos then
        local smoothSp, smoothOn = cam:WorldToViewportPoint(smoothPos)
        if smoothOn then
            local smoothDist = (Vector2.new(smoothSp.X, smoothSp.Y) - fp).Magnitude
            return smoothDist <= cfg.smoothingOnTargetThreshold
        end
    end
    
    return dist <= cfg.smoothingOnTargetThreshold
end



local function getClosest(fovR, dt)
	fovR = fovR or cfg.fov
	local cam = workspace.CurrentCamera
	if not cam then return nil, nil end
	local ap = fovScreenPos(cam)
	local now = os.clock()
	
	-- Check persistent stickiness first
	if cfg.targetstickiness and cfg.stickyPersistDeath then
		if stickyPersist.target and now < stickyPersist.stickyEnd then
			if stickyPersist.target.Character then
				local pt = getTargetPart(stickyPersist.target.Character)
				if pt then
					local sp, on = cam:WorldToViewportPoint(pt.Position)
					if on and sp.Z > 0 then
						local d = (Vector2.new(sp.X, sp.Y) - ap).Magnitude
						if d < fovR then
							local s = getSmoothPos(pt.Position, dt or 0.016, stickyPersist.target)
							return stickyPersist.target, s
						end
					end
				end
			end
		end
	end
	
	if cfg.targetstickiness and curTarget and (now - targetSwitch) < curSticky then
		if fullCheck(curTarget) then
			local pt = getTargetPart(curTarget.Character)
			if pt then
				local sp, on = cam:WorldToViewportPoint(pt.Position)
				if on and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - ap).Magnitude
					if d < fovR then
						local s = getSmoothPos(pt.Position, dt or 0.016, curTarget)
						return curTarget, s
					end
				end
			end
		end
	end
	
	local cands = {}
	for _, p in ipairs(plrs:GetPlayers()) do
		if quickCheck(p) then
			local pt = getTargetPart(p.Character)
			if pt then
				local sp, on = cam:WorldToViewportPoint(pt.Position)
				if on and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - ap).Magnitude
					if d < fovR then
						cands[#cands + 1] = {p = p, dist = d, part = pt, pri = getFovPriority(p)}
					end
				end
			end
		end
	end
	
	if cfg.prioritizeclosest then
		table.sort(cands, function(a, b)
			if a.pri ~= b.pri then return a.pri < b.pri end
			return a.dist < b.dist
		end)
	else
		local bp = math.huge
		for _, c in ipairs(cands) do
			if c.pri < bp then bp = c.pri end
		end
		if bp < math.huge then
			local pc = {}
			for _, c in ipairs(cands) do
				if c.pri == bp then pc[#pc + 1] = c end
			end
			cands = pc
		end
		for i = #cands, 2, -1 do
			local j = rng:NextInteger(1, i)
			cands[i], cands[j] = cands[j], cands[i]
		end
	end
	
	for _, c in ipairs(cands) do
		if fullCheck(c.p) then
			local pt = getTargetPart(c.p.Character)
			if not pt then continue end
			if c.p ~= curTarget then
                --// FIX: Target switch cooldown
                if cfg.targetSwitchCooldownEnabled and (now - lastTargetSwitchTime) < cfg.targetSwitchCooldown then
                    continue -- Skip this candidate, cooldown active
                end
                curTarget = c.p
                targetSwitch = now
                lastTargetSwitchTime = now

				smoothPos = nil
				lockStart = now
				microState.active = false
				microState.last = nil
				if cfg.targetstickinessrandom then
					curSticky = rng:NextNumber(cfg.targetstickinessmin, cfg.targetstickinessmax)
				else
					curSticky = cfg.targetstickinessduration
				end
				-- Update persist state
				if cfg.stickyPersistDeath then
					stickyPersist.target = c.p
					stickyPersist.stickyEnd = now + curSticky
					stickyPersist.stickyVal = curSticky
				end
			end
			local s = getSmoothPos(pt.Position, dt or 0.016, c.p)
			return c.p, s
		end
	end
	
	curTarget = nil
	return nil, nil
end


local ShootEv = rep:WaitForChild("GunRemotes"):WaitForChild("ShootEvent")
local ReloadRem = rep:WaitForChild("GunRemotes"):WaitForChild("FuncReload")
local Debris = game:GetService("Debris")

local function mkTrail(sp, ep, isT)
	local dist = (ep - sp).Magnitude
	local t = Instance.new("Part")
	t.Name = "BulletTrail"
	t.Anchored = true
	t.CanCollide = false
	t.CanQuery = false
	t.CanTouch = false
	t.Material = Enum.Material.Neon
	t.Size = Vector3.new(0.1, 0.1, dist)
	t.CFrame = CFrame.new(sp, ep) * CFrame.new(0, 0, -dist / 2)
	t.Transparency = 0.5
	if isT then
		t.BrickColor = BrickColor.new("Cyan")
		t.Size = Vector3.new(0.2, 0.2, dist)
		local l = Instance.new("SurfaceLight")
		l.Color = Color3.fromRGB(0, 234, 255)
		l.Range = 7
		l.Brightness = 5
		l.Face = Enum.NormalId.Bottom
		l.Parent = t
	else
		t.BrickColor = BrickColor.Yellow()
	end
	t.Parent = workspace
	Debris:AddItem(t, isT and 0.8 or 0.1)
end

local function getBulletsLbl()
	if cachedBulletsLbl and cachedBulletsLbl.Parent then return cachedBulletsLbl end
	cachedBulletsLbl = nil
	local pg = me:FindFirstChild("PlayerGui")
	local home = pg and pg:FindFirstChild("Home")
	local hud = home and home:FindFirstChild("hud")
	local br = hud and hud:FindFirstChild("BottomRightFrame")
	local gf = br and br:FindFirstChild("GunFrame")
	cachedBulletsLbl = gf and gf:FindFirstChild("BulletsLabel") or nil
	return cachedBulletsLbl
end

local function reqReload(g)
	local now = os.clock()
	if now - lastReload < 0.5 then return end
	if not g or g:GetAttribute("Local_ReloadSession") ~= 0 then return end
	local sa = g:GetAttribute("StoredAmmo")
	if typeof(sa) == "number" and sa <= 0 then return end
	lastReload = now
	task.spawn(function()
		pcall(function() ReloadRem:InvokeServer() end)
	end)
end

local function autoShoot(dt)
	local g = curGun
	if not cfg.autoshoot or not cfg.enabled or not g then return end
	if g.Parent ~= me.Character then return end
	if not gunMatchesAuto(g) then
		lastAutoTarget = nil
		return
	end
	local now = os.clock()
	local rs = g:GetAttribute("Local_ReloadSession") or 0
	if rs ~= 0 or g:GetAttribute("Local_IsShooting") then return end
	if not sniperStable(g) then return end
	local fr = g:GetAttribute("FireRate") or 0
if now - lastAuto < fr then return end
	local myCh = me.Character
	if not myCh then return end
	local myHd = myCh:FindFirstChild("Head")
	if not myHd then return end
	local mz = curGun:FindFirstChild("Muzzle")
	local sp = mz and mz.Position or myHd.Position
	local tgt, tpos = getClosest(cfg.fov, dt)
	local usingLinger = false
	local ltgt = nil
	local lpos = nil
	local lpart = nil
	
	if tgt and fullCheck(tgt) then
    if tgt ~= lastAutoTarget then
        lastAutoTarget = tgt
    end
    if cfg.autoshootlinger then
        linger.active = true
        linger.endT = now + rng:NextNumber(cfg.autoshootlingermin, cfg.autoshootlingermax)
        linger.lastTgt = tgt
        local pt = getTargetPart(tgt.Character)
        linger.lastPart = pt
        linger.lastPos = pt and pt.Position or tpos
    end
else
    if cfg.autoshootlinger and linger.active and now < linger.endT then
        if linger.lastTgt then
            usingLinger = true
            ltgt = linger.lastTgt
            lpart = linger.lastPart
            if cfg.lingerLastVisible then
                --// FIX: Use last known position, don't track live player
                lpos = linger.lastPos
                --// Also verify the linger target is still valid (not dead/left)
                local lc = linger.lastTgt.Character
                local lh = lc and lc:FindFirstChildOfClass("Humanoid")
                if not lc or not lh or lh.Health <= 0 then
                    linger.active = false
                    usingLinger = false
                    ltgt = nil
                    lpos = nil
                end
            else
                local lc = linger.lastTgt.Character
                if lc then
                    local lhrp = lc:FindFirstChild("HumanoidRootPart")
                    local lh = lc:FindFirstChildOfClass("Humanoid")
                    if lhrp and lh and lh.Health > 0 then
                        if lpart and lpart.Parent then
                            lpos = lpart.Position
                        else
                            lpos = lhrp.Position
                        end
                    else
                        linger.active = false
                        usingLinger = false
                    end
                else
                    linger.active = false
                    usingLinger = false
                end
            end
        else
            linger.active = false
        end
    end
    if not usingLinger then
        lastAutoTarget = nil
        return
    end
end

	
	local st = usingLinger and ltgt or tgt
	local spos = usingLinger and lpos or tpos
	local spart
	if usingLinger and lpart and lpart.Parent then
		spart = lpart
	else
		spart = getTargetPart(st.Character)
	end
	if not st or not spos then return end
	local ad = 0
	local rd = 0
	if now - targetAcq < rd then return end
	if not spart then
		if usingLinger then
			local c = st.Character
			spart = c and (c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
		end
		if not spart then return end
	end
	local wr = g:GetAttribute("Range")
	if wr and (spart.Position - sp).Magnitude > wr + 5 then return end
	local ammo = g:GetAttribute("Local_CurrentAmmo") or g:GetAttribute("CurrentAmmo") or 0
	if ammo <= 0 then
		reqReload(g)
		return
	end
	lastAuto = now
	noDelaySwitch.lastGun = g
	noDelaySwitch.lastShoot = now
	noDelaySwitch.lastTgt = st
	noDelaySwitch.acq = targetAcq
	local isT = isTaser(g)
	local sn = isSniper(g)
	local sg = isShotgun(g)
    --// Smoothing: don't shoot until actually on target
    if cfg.smoothingShootUntilOnTarget and cfg.smoothingEnabled then
        if not isOnTarget(st) then
            --// FIX: Track how long we've been trying to get on target
            if not lockStart or (now - lockStart) < cfg.reactionDelay then
                return
            end
            --// Give it a bit more time if we're close
            local cam = workspace.CurrentCamera
            local pt = getTargetPart(st.Character)
            if cam and pt then
                local sp, on = cam:WorldToViewportPoint(pt.Position)
                if on then
                    local fp = fovScreenPos(cam)
                    local dist = (Vector2.new(sp.X, sp.Y) - fp).Magnitude
                    --// If within 3x threshold, allow shooting (close enough)
                    if dist > cfg.smoothingOnTargetThreshold * 3 then
                        return
                    end
                else
                    return
                end
            else
                return
            end
        end
    end

	
	local shouldHit = false
	if cfg.reactionDelayEnabled and (now - lockStart) < cfg.reactionDelay then return end
	if shouldMissFirst(st) then
		shouldHit = false
	else
		if cfg.taseralwayshit and isT then shouldHit = true
		elseif cfg.ifplayerstill and isStanding(st) then shouldHit = true
		elseif bypassHitchance(g) then shouldHit = true
		else shouldHit = rollHit(getDynHitChance(spart, sp, st)) end
	end
	local pc = curGun:GetAttribute("ProjectileCount") or 1
	local shots = {}
	for i = 1, pc do
		local ap
		if shouldHit then ap = spart.Position
		else
			if cfg.missspread > 0 then ap = getMissPos(sp, spart)
			else return end
		end
		local hp = shouldHit and spart or nil
		local fp = ap
		if shouldHit then
			if isT then
				local sh, sp2 = simProjImpact(sp, ap, g)
				fp = sp2
				hp = sh or spart
			elseif sg and cfg.shotgunnaturalspread then
				local sh, sp2 = simProjImpact(sp, ap, g)
				fp = sp2
				hp = sh or spart
			end
		end
		shots[i] = {myHd.Position, fp, hp}
		mkTrail(sp, fp, isT)
	end
	ShootEv:FireServer(shots)
	if g ~= curGun or g.Parent ~= me.Character then return end
	local na = ammo - 1
	g:SetAttribute("Local_CurrentAmmo", na)
	local bl = getBulletsLbl()
	if bl then
		if sn then bl.Text = na .. " | " .. (g:GetAttribute("StoredAmmo") or 0)
		else bl.Text = na .. "/" .. (g:GetAttribute("MaxAmmo") or 30) end
	end
	local hnd = g:FindFirstChild("Handle")
	if hnd then
		local ss = hnd:FindFirstChild("ShootSound")
		if ss then
			local s = ss:Clone()
			s.Parent = hnd
			s:Play()
			Debris:AddItem(s, 2)
		end
	end
end

local function getGun()
	local ch = me.Character
	if not ch then return nil end
	local c = ch:GetChildren()
	for i = #c, 1, -1 do
		local t = c[i]
		if t:IsA("Tool") and t:GetAttribute("ToolType") == "Gun" then return t end
	end
	return nil
end

local function notify(tl, tx, dur)
	pcall(function()
		sg:SetCore("SendNotification", {Title = tl, Text = tx, Duration = dur or 3})
	end)
end

local lastGun = nil

rs.Heartbeat:Connect(function(dt)
	local now = os.clock()
	local ng = getGun()
	if ng ~= lastGun then
		applyWepProf(ng)
		noDelaySwitch.lastGun = lastGun
		noDelaySwitch.lastTgt = lastAutoTarget
		noDelaySwitch.acq = targetAcq
		if not lastGun or not ng then targetAcq = now end
		lastGun = ng
		curGun = ng
	end
	curGun = ng
	updAutoGrab(now)
	autoShoot(dt)
end)

uis.InputBegan:Connect(function(inp, gp)
	if gp then return end
	--// Track touch for non-static FOV
	if inp.UserInputType == Enum.UserInputType.Touch then
		if not ignoreTouch(inp.Position) then
			activeTouch = inp
			lastTouchPos = Vector2.new(inp.Position.X, inp.Position.Y)
		end
	end
	--// Keybinds
	if inp.KeyCode == cfg.togglekey then
		cfg.enabled = not cfg.enabled
		if uiEls.SilentAimTog then uiEls.SilentAimTog:UpdateState(cfg.enabled) end
		notify("Silent Aim", "Enabled: " .. tostring(cfg.enabled), 3)
	elseif inp.KeyCode == cfg.esptoggle then
		cfg.esp = not cfg.esp
		if uiEls.EspTog then uiEls.EspTog:UpdateState(cfg.esp) end
		notify("ESP", "Enabled: " .. tostring(cfg.esp), 3)
	elseif inp.KeyCode == cfg.c4esptoggle then
		cfg.c4esp = not cfg.c4esp
		if uiEls.C4EspTog then uiEls.C4EspTog:UpdateState(cfg.c4esp) end
		notify("C4 ESP", "Enabled: " .. tostring(cfg.c4esp), 3)
	end
end)


rs.PreRender:Connect(function(dt)
	local cam = workspace.CurrentCamera
	local fp = fovScreenPos(cam)
	fovCircle.Position = fp
	fovCircle.Radius = cfg.fov
	fovCircle.Visible = cfg.showfov and cfg.enabled
	if cfg.showtargetline and cfg.enabled then
		local tgt, tpos = getClosest(cfg.fov, dt)
		if tgt and tpos and cam then
			local sp, on = cam:WorldToViewportPoint(tpos)
			if on then
				tgtLine.From = fp
				tgtLine.To = Vector2.new(sp.X, sp.Y)
				tgtLine.Visible = true
			else
				tgtLine.Visible = false
			end
		else
			tgtLine.Visible = false
		end
	else
		tgtLine.Visible = false
	end
	updEsp()
	updC4Esp()
end)

plrs.PlayerRemoving:Connect(rmEsp)

local function bindP(p)
	p.CharacterRemoving:Connect(function(ch)
		partCache[ch] = nil
		if curTarget and curTarget == p then curTarget = nil end
		if lastAutoTarget and lastAutoTarget == p then lastAutoTarget = nil end
	end)
end

for _, p in ipairs(plrs:GetPlayers()) do bindP(p) end
plrs.PlayerAdded:Connect(bindP)

local function clearEsp()
	for p, e in pairs(espCache) do
		if e then e:Destroy() end
		espCache[p] = nil
	end
	partCache = {}
	curTarget = nil
end

me:GetPropertyChangedSignal("Team"):Connect(function()
	resetAim()
	clearEsp()
end)

--// Reset walkspeed + noclip on death/respawn
me.CharacterAdded:Connect(function(ch)
	
	--// Restore walkspeed if enabled
	if cfg.walkspeedEnabled then
		task.delay(0.3, function()
			applySpeed(cfg.walkspeedValue)
		end)
	end
	
	--// Restore noclip if enabled
	if cfg.noclipEnabled then
		task.delay(0.3, startNoclip)
	end
end)


local function noUp(f) return function(...) return f(...) end end

local origCast
local hooked = false

local function setupHook()
	local castF = filtergc("function", {Name = "castRay"}, true)
	if not castF then return false end
	origCast = hookfunction(castF, noUp(function(sp, tp, ...)
		if not cfg.enabled then return origCast(sp, tp, ...) end
		local cl = getClosest(cfg.fov, 0.016)
		if cl and cl.Character then
			local g = curGun
			if not g then return origCast(sp, tp, ...) end
			local isT = isTaser(g)
			local sg = isShotgun(g)
			local snSt = sniperStable(g)
			local shouldHit = false
			local byp = bypassHitchance(g)
			local tpart = getTargetPart(cl.Character)
			if not tpart then return origCast(sp, tp, ...) end
			if not inGunRange(tpart.Position, sp) then return origCast(sp, tp, ...) end
			if cfg.wallcheck then
				local cam = workspace.CurrentCamera
				local org = cam and cam.CFrame.Position or nil
				if not org then
					local myCh = me.Character
					local myHd = myCh and myCh:FindFirstChild("Head")
					org = myHd and myHd.Position
				end
				if org and wallBetween(org, tpart.Position, cl.Character) then return origCast(sp, tp, ...) end
			end
			if cfg.shotgungamehandled and sg then return origCast(sp, tpart.Position, ...) end
			if shouldMissFirst(cl) then shouldHit = false
			else
				if cfg.taseralwayshit and isT then shouldHit = true
				elseif cfg.ifplayerstill and isStanding(cl) then shouldHit = true
				elseif byp then shouldHit = true
				else shouldHit = rollHit(getDynHitChance(tpart, sp, cl)) end
			end
			if shouldHit then
				if isSniper(g) and not snSt then return origCast(sp, tpart.Position, ...) end
				if isT then return origCast(sp, tpart.Position, ...) end
				if cfg.shotgunnaturalspread and sg then return origCast(sp, tpart.Position, ...) end
				return tpart, tpart.Position
			else
				if cfg.missspread > 0 then
					local mp = getMissPos(sp, tpart)
					return origCast(sp, mp, ...)
				end
				return origCast(sp, tp, ...)
			end
		end
		return origCast(sp, tp, ...)
	end))
	return true
end

if not setupHook() then
	task.spawn(function()
		while not hooked do
			task.wait(0.5)
			if setupHook() then hooked = true end
		end
	end)
else
	hooked = true
end
--// Initial bypass



notify("Silent Aim + ESP", "Loaded! RShift = Aim, RCtrl = ESP", 5)
notify("nutonmybalencii on discord", "dm me for suggestions/bugs", 15)

local function replaceFirst(src, old, new)
	local si = string.find(src, old, 1, true)
	if not si then return src, false end
	local ei = si + #old - 1
	return string.sub(src, 1, si - 1) .. new .. string.sub(src, ei + 1), true
end

local function loadPatchedMacLib()
	local src = game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt")
	src = select(1, replaceFirst(src, 'sliderBar.Size = UDim2.fromOffset(123, 3)', 'sliderBar.Size = UDim2.fromOffset(123, 10)\n\t\t\t\t\tsliderBar.Active = true'))
	src = select(1, replaceFirst(src, 'sliderHead.Size = UDim2.fromOffset(12, 12)', 'sliderHead.Size = UDim2.fromOffset(16, 16)'))
	src = select(1, replaceFirst(src, [[					sliderHead.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = true
							SetValue(input)
						end
					end)

					sliderHead.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = false
							if SliderFunctions.Settings.onInputComplete then
								SliderFunctions.Settings.onInputComplete(finalValue)
							end
						end
					end)]], [[					local function beginDrag(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = true
							SetValue(input)
						end
					end

					local function endDrag(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = false
							if SliderFunctions.Settings.onInputComplete then
								SliderFunctions.Settings.onInputComplete(finalValue)
							end
						end
					end

					sliderHead.InputBegan:Connect(beginDrag)
					sliderBar.InputBegan:Connect(beginDrag)
					sliderHead.InputEnded:Connect(endDrag)
					sliderBar.InputEnded:Connect(endDrag)]]))
	return loadstring(src)()
end

local function initUI()
	local MacLib = loadPatchedMacLib()
	local Folder = "Silent Aim"

	local function getWinSize()
		local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
		if uis.TouchEnabled then
			local mw = math.min(1520, math.max(760, vp.X - 20))
			local mh = math.min(860, math.max(420, vp.Y - 56))
			local miw = math.min(920, mw)
			local mih = math.min(520, mh)
			return UDim2.fromOffset(math.floor(math.clamp(vp.X * 0.9, miw, mw)), math.floor(math.clamp(vp.Y * 0.8, mih, mh)))
		end
		return UDim2.fromOffset(800, 600)
	end

	local Window = MacLib:Window({
		Title = "Prison Life Silent Aim",
		Subtitle = "Prison Life Exploit",
		Size = UDim2.fromOffset(800, 600),
		DragStyle = 1,
		DisabledWindowControls = {},
		ShowUserInfo = not uis.TouchEnabled,
		Keybind = Enum.KeyCode.RightAlt,
		AcrylicBlur = true,
	})

	MacLib:SetFolder(Folder)

	local function applyWinSize() Window:SetSize(getWinSize()) end
	applyWinSize()
	task.defer(applyWinSize)
	task.delay(0.25, applyWinSize)

	if uis.TouchEnabled then
		task.defer(function()
			pcall(function() Window:SetUserInfoState(false) end)
		end)
	end

	local clampMobBtnPos
	local curVpConn = nil
	local refreshMobBtnVis
	local syncMobLayer

	local function bindWinResize()
		if curVpConn then curVpConn:Disconnect() curVpConn = nil end
		local cam = workspace.CurrentCamera
		if not cam then return end
		curVpConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			if uis.TouchEnabled then
				applyWinSize()
				if clampMobBtnPos then clampMobBtnPos() end
			end
		end)
	end

	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		bindWinResize()
		if uis.TouchEnabled then task.defer(applyWinSize) end
	end)
	bindWinResize()

	local function getMobBtnParent() return (gethui and gethui()) or cg end

	local function getClampedCenter(raw, sz)
		local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
		local pd = 10
		local hw = sz.X * 0.5
		local hh = sz.Y * 0.5
		local mnX = hw + pd
		local mxX = math.max(mnX, vp.X - hw - pd)
		local mnY = hh + pd
		local mxY = math.max(mnY, vp.Y - hh - pd)
		return Vector2.new(math.clamp(raw.X, mnX, mxX), math.clamp(raw.Y, mnY, mxY))
	end

	local function getDefMobCenter(sz)
		local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
		local to = math.max(118, vp.Y * 0.12)
		local dc = Vector2.new(sz.X * 0.5 + 28, to + sz.Y * 0.5)
		return getClampedCenter(dc, sz)
	end

	local function getInpPos2D(inp)
		local p = inp and inp.Position
		if not p then return Vector2.zero end
		return Vector2.new(p.X, p.Y)
	end

	clampMobBtnPos = function()
		if not mobGuiBtn or not mobGuiBtn.Parent then return end
		local cc = Vector2.new(
			mobGuiBtn.AbsolutePosition.X + mobGuiBtn.AbsoluteSize.X * 0.5,
			mobGuiBtn.AbsolutePosition.Y + mobGuiBtn.AbsoluteSize.Y * 0.5
		)
		local cl = getClampedCenter(cc, mobGuiBtn.AbsoluteSize)
		mobGuiBtn.Position = UDim2.fromOffset(cl.X, cl.Y)
	end

	resolveMacLibWin = function()
		local tl = Window and Window.Settings and Window.Settings.Title or "Prison Life Silent Aim"
		local gp = getMobBtnParent()
		local cands = {gp}
		if gp ~= cg then cands[#cands + 1] = cg end
		for _, pr in ipairs(cands) do
			for _, d in ipairs(pr:GetDescendants()) do
				if d:IsA("TextLabel") and d.Text == tl then
					return d:FindFirstAncestorOfClass("ScreenGui")
				end
			end
		end
		return nil
	end

	refreshMobBtnVis = function()
		if not mobGuiBtn then return end
		mobGuiBtn.Visible = true
		mobGuiBtn.Active = true
	end

	syncMobLayer = function()
		if not mobGuiBtn then return end
		local sc = mobGuiBtn:FindFirstAncestorOfClass("ScreenGui")
		if not sc then return end
		local wg = resolveMacLibWin and resolveMacLibWin() or nil
		local tp = getMobBtnParent()
		if wg and wg.Parent then tp = wg.Parent end
		sc.ScreenInsets = Enum.ScreenInsets.None
		sc.DisplayOrder = wg and wg.DisplayOrder or 2147483647
		if sc.Parent ~= tp then sc.Parent = tp end
		sc.Parent = nil
		sc.Parent = tp
	end

	local function toggleWin()
		local wg = resolveMacLibWin()
		if not wg then
			Window:Notify({Title = Window.Settings.Title, Description = "Couldn't find the window to toggle yet.", Lifetime = 3})
			return
		end
		wg.Enabled = not wg.Enabled
		refreshMobBtnVis()
	end
	


	local function createMobBtn()
		if not uis.TouchEnabled then return end
		local ex = getMobBtnParent():FindFirstChild("SilentAimMobileButton")
		if ex then ex:Destroy() end
		local sc = Instance.new("ScreenGui")
		sc.Name = "SilentAimMobileButton"
		sc.ResetOnSpawn = false
		sc.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sc.IgnoreGuiInset = true
		sc.ScreenInsets = Enum.ScreenInsets.None
		sc.DisplayOrder = 2147483647
		sc.Parent = getMobBtnParent()
		local bsz = Vector2.new(68, 68)
		local dc = getDefMobCenter(bsz)
		local btn = Instance.new("ImageButton")
		btn.Name = "ToggleButton"
		btn.AnchorPoint = Vector2.new(0.5, 0.5)
		btn.Position = UDim2.fromOffset(dc.X, dc.Y)
		btn.Size = UDim2.fromOffset(bsz.X, bsz.Y)
		btn.BackgroundTransparency = 1
		btn.BorderSizePixel = 0
		btn.Image = "rbxassetid://100746642581984"
		btn.ScaleType = Enum.ScaleType.Fit
		btn.Active = true
		btn.ZIndex = 1000
		btn.Parent = sc
		mobGuiBtn = btn
		local dInp = nil
		local dStart = nil
		local sCenter = nil
		local moved = false
		local mvThresh = 14
		btn.InputBegan:Connect(function(inp)
			if inp.UserInputType ~= Enum.UserInputType.Touch and inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			dInp = inp
			mobGuiDrag = inp
			dStart = getInpPos2D(inp)
			sCenter = Vector2.new(
				btn.AbsolutePosition.X + btn.AbsoluteSize.X * 0.5,
				btn.AbsolutePosition.Y + btn.AbsoluteSize.Y * 0.5
			)
			activeTouch = nil
			lastTouchPos = nil
			moved = false
		end)
		--// Single global InputChanged - optimized to avoid per-frame garbage
local lastInpChanged = 0
		--// Single global InputChanged - throttled to prevent mobile FPS drops
		local lastMobInpChanged = 0
		uis.InputChanged:Connect(function(inp, gp)
			if gp then return end
			
			-- Throttle: InputChanged can fire 120+ times/sec on mobile
			local now = os.clock()
			if now - lastMobInpChanged < 0.008 then return end
			lastMobInpChanged = now
			
			--// Track active touch position for non-static FOV
			if inp.UserInputType == Enum.UserInputType.Touch and activeTouch == inp then
				lastTouchPos = Vector2.new(inp.Position.X, inp.Position.Y)
			end
			--// Mobile button drag
			if inp == mobGuiDrag and dStart and sCenter then
				local delta = getInpPos2D(inp) - dStart
				if not moved then
					if delta.Magnitude < mvThresh then return end
					moved = true
				end
				local nc = getClampedCenter(sCenter + delta, mobGuiBtn.AbsoluteSize)
				mobGuiBtn.Position = UDim2.fromOffset(nc.X, nc.Y)
			end
		end)

		--// Single global InputEnded
uis.InputEnded:Connect(function(inp)
	--// Clear touch tracking
	if inp.UserInputType == Enum.UserInputType.Touch then
		if activeTouch == inp then
			activeTouch = nil
			lastTouchPos = nil
		end
	end
	--// Mobile button drag end
	if inp ~= mobGuiDrag then return end
	local wasMoved = moved
	mobGuiDrag = nil
	dInp = nil
	dStart = nil
	sCenter = nil
	moved = false
	if wasMoved then
		clampMobBtnPos()
	else
		toggleWin()
	end
end)


		task.defer(clampMobBtnPos)
		task.defer(syncMobLayer)
		task.defer(refreshMobBtnVis)
	end

	createMobBtn()
	
--// MOBILE UTILITY BUTTONS (Walkspeed + Noclip)
local utilBtns = {}
local utilDragState = {}

local function setupUtilBtn(props)
	local sc = Instance.new("ScreenGui")
	sc.Name = props.name .. "_" .. tostring(math.random(1000, 9999))
	sc.ResetOnSpawn = false
	sc.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sc.IgnoreGuiInset = true
	sc.ScreenInsets = Enum.ScreenInsets.None
	sc.DisplayOrder = 2147483646
	sc.Parent = getMobBtnParent()
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 34)
	btn.Position = props.pos
	btn.AnchorPoint = Vector2.new(0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.BorderSizePixel = 0
	btn.Text = props.textOff
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.Parent = sc
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(80, 80, 80)
	stroke.Thickness = 1.5
	stroke.Parent = btn
	
	utilBtns[props.key] = {btn = btn, stroke = stroke, sc = sc, callback = props.callback}
	
	btn.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if utilDragState[props.key] and utilDragState[props.key].active then return end
		
		utilDragState[props.key] = {
			active = true,
			input = input,
			touchStart = os.clock(),
			startPos = Vector2.new(input.Position.X, input.Position.Y),
			isDragging = false,
			btnStartPos = btn.Position,
		}
	end)
	
	return btn, stroke
end

local lastUtilInpChanged = 0
uis.InputChanged:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	
	local now = os.clock()
	if now - lastUtilInpChanged < 0.016 then return end
	lastUtilInpChanged = now
	
	for key, state in pairs(utilDragState) do
		if not state.active or state.input ~= input then continue end
		
		local cur = Vector2.new(input.Position.X, input.Position.Y)
		local dist = (cur - state.startPos).Magnitude
		
		if not state.isDragging then
			if dist <= 10 then continue end
			state.isDragging = true
		end
		
		local delta = cur - state.startPos
		local btn = utilBtns[key] and utilBtns[key].btn
		if btn then
			btn.Position = UDim2.new(
				state.btnStartPos.X.Scale, state.btnStartPos.X.Offset + delta.X,
				state.btnStartPos.Y.Scale, state.btnStartPos.Y.Offset + delta.Y
			)
		end
	end
end)

uis.InputEnded:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	
	for key, state in pairs(utilDragState) do
		if not state.active or state.input ~= input then continue end
		
		local elapsed = os.clock() - state.touchStart
		local wasDragging = state.isDragging
		utilDragState[key] = nil
		
		if not wasDragging and elapsed < 0.4 then
			local data = utilBtns[key]
			if data and data.callback then
				data.callback()
			end
		end
	end
end)

local function updateUtilBtn(key, on, textOn, textOff)
	local u = utilBtns[key]
	if not u then return end
	if on then
		u.btn.Text = textOn
		u.btn.BackgroundColor3 = Color3.fromRGB(35, 85, 55)
		u.stroke.Color = Color3.fromRGB(60, 180, 90)
	else
		u.btn.Text = textOff
		u.btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		u.stroke.Color = Color3.fromRGB(80, 80, 80)
	end
end

local function createUtilBtns()
	if not uis.TouchEnabled then return end
	
	setupUtilBtn({
		key = "ws",
		name = "ws",
		textOff = "WS: OFF",
		pos = UDim2.new(1, -105, 0, 15),
		callback = function()
			cfg.walkspeedEnabled = not cfg.walkspeedEnabled
			if cfg.walkspeedEnabled then
				if applySpeed(cfg.walkspeedValue) then
					updateUtilBtn("ws", true, "WS: " .. cfg.walkspeedValue, nil)
				else
					cfg.walkspeedEnabled = false
				end
			else
				applySpeed(cfg.walkspeedDefault)
				updateUtilBtn("ws", false, nil, "WS: OFF")
			end
		end
	})
	
	setupUtilBtn({
		key = "nc",
		name = "nc",
		textOff = "NOCLIP: OFF",
		pos = UDim2.new(1, -105, 0, 55),
		callback = function()
			cfg.noclipEnabled = not cfg.noclipEnabled
			if cfg.noclipEnabled then
				startNoclip()
				updateUtilBtn("nc", true, "NOCLIP: ON", nil)
			else
				stopNoclip()
				updateUtilBtn("nc", false, nil, "NOCLIP: OFF")
			end
		end
	})
end

createUtilBtns()



	task.defer(function()
		local wg = resolveMacLibWin and resolveMacLibWin() or nil
		syncMobLayer()
		if wg then
			wg:GetPropertyChangedSignal("Enabled"):Connect(function()
				syncMobLayer()
				refreshMobBtnVis()
				updateMacLibBounds()
			end)
			--// Poll bounds at 5Hz (plenty for touch blocking)
			task.spawn(function()
				while wg and wg.Parent do
					updateMacLibBounds()
					task.wait(0.2)
				end
			end)
		end
	end)

	local globalSettings = {
		UIBlurToggle = Window:GlobalSetting({
			Name = "UI Blur",
			Default = Window:GetAcrylicBlurState(),
			Callback = function(bool)
				Window:SetAcrylicBlurState(bool)
				Window:Notify({Title = Window.Settings.Title, Description = (bool and "Enabled" or "Disabled") .. " UI Blur", Lifetime = 5})
			end,
		}),
		NotificationToggler = Window:GlobalSetting({
			Name = "Notifications",
			Default = Window:GetNotificationsState(),
			Callback = function(bool)
				Window:SetNotificationsState(bool)
				Window:Notify({Title = Window.Settings.Title, Description = (bool and "Enabled" or "Disabled") .. " Notifications", Lifetime = 5})
			end,
		}),
		ShowUserInfo = Window:GlobalSetting({
			Name = "Show User Info",
			Default = Window:GetUserInfoState(),
			Callback = function(bool)
				Window:SetUserInfoState(bool)
				Window:Notify({Title = Window.Settings.Title, Description = (bool and "Showing" or "Redacted") .. " User Info", Lifetime = 5})
			end,
		})
	}

	local MainGroup = Window:TabGroup()

	local AimbotTab = MainGroup:Tab({Name = "Aimbot", Image = "rbxassetid://4034483344"})
	local DistTab = MainGroup:Tab({Name = "Distance Hitchance", Image = "rbxassetid://4034483344"})
	local ESPTab = MainGroup:Tab({Name = "ESP", Image = "rbxassetid://4034483345"})
	local AutoTab = MainGroup:Tab({Name = "Autoshoot", Image = "rbxassetid://4034483346"})
	local WlTab = MainGroup:Tab({Name = "Whitelist", Image = "rbxassetid://4034483348"})
	local SetTab = MainGroup:Tab({Name = "Settings", Image = "rbxassetid://4034483347"})
	local LegitTab = MainGroup:Tab({Name = "Legit", Image = "rbxassetid://4034483349"})
	local SmartTab = MainGroup:Tab({Name = "Smart Target", Image = "rbxassetid://4034483350"})

	local sections = {
		aimL = AimbotTab:Section({Side = "Left"}),
		aimR = AimbotTab:Section({Side = "Right"}),
		distL = DistTab:Section({Side = "Left"}),
		distR = DistTab:Section({Side = "Right"}),
		espL = ESPTab:Section({Side = "Left"}),
		espR = ESPTab:Section({Side = "Right"}),
		autoL = AutoTab:Section({Side = "Left"}),
		autoR = AutoTab:Section({Side = "Right"}),
		wlL = WlTab:Section({Side = "Left"}),
		wlR = WlTab:Section({Side = "Right"}),
		setL = SetTab:Section({Side = "Left"}),
		setR = SetTab:Section({Side = "Right"}),
		legL = LegitTab:Section({Side = "Left"}),
		legR = LegitTab:Section({Side = "Right"}),
		smartL = SmartTab:Section({Side = "Left"}),
		smartR = SmartTab:Section({Side = "Right"}),
	}

	AimbotTab:Select()

	Window:Notify({
		Title = "Build Loaded",
		Description = string.format("GUI build %s loaded with Smart Targeting & Cross-Team ESP.", ver),
		Lifetime = 5
	})

	local cfgFolder = "SilentAimConfigs"
	local autoLoadFile = cfgFolder .. "/_autoload.txt"

	local function serCol3(c) return {R = c.R, G = c.G, B = c.B} end
	local function deserCol3(t)
		if t and t.R and t.G and t.B then return Color3.new(t.R, t.G, t.B) end
		return Color3.new(1, 1, 1)
	end

	local function serCfg()
		local d = {}
		for k, v in pairs(cfg) do
			if typeof(v) == "Color3" then d[k] = {type = "Color3", value = serCol3(v)}
			elseif typeof(v) == "EnumItem" then d[k] = {type = "EnumItem", value = tostring(v)}
			elseif typeof(v) == "table" then d[k] = {type = "table", value = v}
			else d[k] = {type = typeof(v), value = v} end
		end
		return hs:JSONEncode(d)
	end

	local function deserCfg(js)
    local ok, dat = pcall(function() return hs:JSONDecode(js) end)
    if not ok then return nil end
    local r = {}
    for k, e in pairs(dat) do
        --// FIX: Handle both old format (direct values) and new format (typed values)
        if typeof(e) == "table" and e.type and e.value ~= nil then
            if e.type == "Color3" then r[k] = deserCol3(e.value)
            elseif e.type == "EnumItem" then
                local ep = e.value:match("Enum%.(.+)")
                if ep then
                    local pts = ep:split(".")
                    if #pts == 2 then
                        local et = Enum[pts[1]]
                        if et then r[k] = et[pts[2]] end
                    end
                end
            elseif e.type == "table" then r[k] = e.value
            else r[k] = e.value end
        else
            --// Direct value (backward compatibility)
            r[k] = e
        end
    end
    return r
end


	local function saveCfg(name)
		if not isfolder then return false end
		if not isfolder(cfgFolder) then makefolder(cfgFolder) end
		writefile(cfgFolder .. "/" .. name .. ".json", serCfg())
		return true
	end

	local function loadCfg(name)
    if not isfolder or not isfile then return false end
    local p = cfgFolder .. "/" .. name .. ".json"
    if not isfile(p) then return false end
    local l = deserCfg(readfile(p))
    if not l then return false end
    
    --// FIX: Store old values for features that should persist
    local oldEnabled = cfg.enabled
    local oldEsp = cfg.esp
    local oldC4Esp = cfg.c4esp
    local oldAutoShoot = cfg.autoshoot
    
    --// FIX: Load each saved value independently
    for k, v in pairs(l) do
        --// Only load if the key exists in current cfg (prevents crash on removed features)
        if cfg[k] ~= nil then
            --// Type check to prevent corruption
            if typeof(v) == typeof(cfg[k]) then
                cfg[k] = v
            elseif typeof(cfg[k]) == "number" and typeof(v) == "string" then
                local num = tonumber(v)
                if num then cfg[k] = num end
            elseif typeof(cfg[k]) == "boolean" and typeof(v) == "string" then
                cfg[k] = v == "true"
            end
        end
    end
    
    --// FIX: Ensure all features have valid values (fallback to defaults)
    for k, v in pairs(defaultCfg) do
        if cfg[k] == nil then
            cfg[k] = deepCopy(v)
        end
    end
    
    --// FIX: Restore state toggles if they weren't in the config
    --// (so UI doesn't break if config is missing toggle states)
    if l.enabled == nil then cfg.enabled = oldEnabled end
    if l.esp == nil then cfg.esp = oldEsp end
    if l.c4esp == nil then cfg.c4esp = oldC4Esp end
    if l.autoshoot == nil then cfg.autoshoot = oldAutoShoot end
    
    --// FIX: Validate dependent values
    if cfg.smoothingDistNear >= cfg.smoothingDistFar then
        cfg.smoothingDistFar = cfg.smoothingDistNear + 50
    end
    if cfg.autoshootlingermin > cfg.autoshootlingermax then
        cfg.autoshootlingermin, cfg.autoshootlingermax = cfg.autoshootlingermax, cfg.autoshootlingermin
    end
    if cfg.targetstickinessmin > cfg.targetstickinessmax then
        cfg.targetstickinessmin, cfg.targetstickinessmax = cfg.targetstickinessmax, cfg.targetstickinessmin
    end
    
    syncDistAimMax()
    return true
end


	local function getCfgList()
		if not isfolder or not listfiles then return {} end
		if not isfolder(cfgFolder) then return {} end
		local f = listfiles(cfgFolder)
		local c = {}
		for _, p in ipairs(f) do
			local n = p:match("([^/\\]+)%.json$")
			if n then table.insert(c, n) end
		end
		return c
	end

	local function delCfg(name)
		if not isfolder or not isfile or not delfile then return false end
		local p = cfgFolder .. "/" .. name .. ".json"
		if isfile(p) then delfile(p) return true end
		return false
	end

	local function getAutoLoad()
		if not isfolder or not isfile or not readfile then return "" end
		if not isfolder(cfgFolder) or not isfile(autoLoadFile) then return "" end
		return tostring(readfile(autoLoadFile) or ""):gsub("^%s+", ""):gsub("%s+$", "")
	end

	local function setAutoLoad(name)
		if not isfolder or not writefile then return false end
		if not isfolder(cfgFolder) then makefolder(cfgFolder) end
		writefile(autoLoadFile, tostring(name or ""))
		return true
	end

	local function clearAutoLoad()
		if not isfolder or not isfile or not delfile then return false end
		if isfile(autoLoadFile) then delfile(autoLoadFile) end
		return true
	end

	local curAutoName = getAutoLoad()
	if curAutoName ~= "" then
		if loadCfg(curAutoName) then
			local ok = pcall(function()
				Window:Notify({Title = "Auto Load", Description = "Loaded config: " .. curAutoName, Lifetime = 4})
			end)
			if not ok then notify("Auto Load", "Loaded config: " .. curAutoName, 4) end
		else
			local ok = pcall(function()
				Window:Notify({Title = "Auto Load", Description = "Couldn't load config: " .. curAutoName, Lifetime = 4})
			end)
		end
	end

	syncDistAimMax()

	local wlPlrList = {}
	local selWlPlr = nil

	local function refreshWlList()
		wlPlrList = {}
		for _, p in ipairs(plrs:GetPlayers()) do
			if p ~= me then table.insert(wlPlrList, p) end
		end
	end

	local function getWlOpts()
		refreshWlList()
		local o = {}
		for i, p in ipairs(wlPlrList) do
			local s = isWl(p) and " [WHITELISTED]" or ""
			o[i] = p.Name .. s
		end
		return o
	end

	local function findPlrByDrop(n)
		for _, p in ipairs(plrs:GetPlayers()) do
			if p.Name == n or p.Name .. " [WHITELISTED]" == n then return p end
		end
		return nil
	end


	local function refreshUI()
		local els = {
			{"SilentAimTog", cfg.enabled},
			{"TeamCheckTog", cfg.teamcheck},
			{"WallCheckTog", cfg.wallcheck},
			{"DeathCheckTog", cfg.deathcheck},
			{"VehicleCheckTog", cfg.vehiclecheck},
			{"HostileCheckTog", cfg.hostilecheck},
			{"TrespassCheckTog", cfg.trespasscheck},
			{"CrimSkipInTog", cfg.criminalsnoinnmates},
			{"InSkipCrimTog", cfg.inmatesnocriminals},
			{"FFCheckTog", cfg.ffcheck},
			{"ShieldBreakTog", cfg.shieldbreaker},
			{"ShieldRandHeadTog", cfg.shieldrandomhead},
			{"TaserBypassHostTog", cfg.taserbypasshostile},
			{"TaserBypassTresTog", cfg.taserbypasstrespass},
			{"TaserAlwaysTog", cfg.taseralwayshit},
			{"HitStillTog", cfg.ifplayerstill},
			{"HitChanceAutoTog", cfg.hitchanceAutoOnly},
			{"DistHitTog", cfg.distancebasedhitchance},
			{"ShotgunNatTog", cfg.shotgunnaturalspread},
			{"ShotgunGameTog", cfg.shotgungamehandled},
			{"PriorCloseTog", cfg.prioritizeclosest},
			{"PriorCrimTog", cfg.prioritizecriminals},
			{"StickyTog", cfg.targetstickiness},
			{"StickyRandTog", cfg.targetstickinessrandom},
			{"ShowFovTog", cfg.showfov},
			{"StaticFovTog", cfg.staticfov},
			{"ShowTgtLineTog", cfg.showtargetline},
			{"RandPartsTog", cfg.randomparts},
			{"EspTog", cfg.esp},
			{"EspTeamCheckTog", cfg.espteamcheck},
			{"ShowTeamTog", cfg.espshowteam},
			{"ShowDistTog", cfg.espshowdist},
			{"UseTeamColTog", cfg.espuseteamcolors},
			{"C4EspTog", cfg.c4esp},
			{"C4ShowDistTog", cfg.c4espshowdist},
			{"AutoShootTog", cfg.autoshoot},
			{"AutoShootLingerTog", cfg.autoshootlinger},
			{"AutoGrabTog", cfg.autograb},
			{"GrabKeyTog", cfg.autograbkeycard},
			{"GrabM9Tog", cfg.autograbm9},
			{"WlEnabledTog", cfg.whitelistenabled},
			{"SmoothEnTog", cfg.smoothingEnabled},
			{"MissFirstTog", cfg.missFirstShot},
			{"ReactDelayEnTog", cfg.reactionDelayEnabled},
			{"DynHitTog", cfg.dynamicHitchanceEnabled},
			{"StackBehTog", cfg.stackBehaviorMiss},
			{"MicroCorrEnTog", cfg.microCorrectionEnabled},
			{"WepProfEnTog", cfg.weaponProfilesEnabled},
			{"LegitModeTog", cfg.legitMode},
			{"SmartTgtTog", cfg.smartBodyTargeting},
			{"JumpLegTog", cfg.jumpLegChance >= 50},
			{"MoveArmTog", cfg.moveArmChance >= 50},
			{"TorsoBiasTog", cfg.torsoBiasEnabled},
			{"CrossTeamEspTog", cfg.crossTeamEsp},
			{"CrimHostOnlyTog", cfg.crimTargetHostileOnly},
			{"CrimTresOnlyTog", cfg.crimTargetTrespassOnly},
			{"StickyPersistTog", cfg.stickyPersistDeath},
			{"SmoothDistEnTog", cfg.smoothingDistEnabled},
            {"SmoothShootTilTog", cfg.smoothingShootUntilOnTarget},

			{"LingerLastVisTog", cfg.lingerLastVisible},
            {"TargetSwitchCooldownTog", cfg.targetSwitchCooldownEnabled},
		}
		for _, e in ipairs(els) do
			pcall(function()
				if uiEls[e[1]] then uiEls[e[1]]:UpdateState(e[2]) end
			end)
		end
		local slds = {
			{"ShieldAngleSld", cfg.shieldfrontangle},
			{"ShieldHeadChanceSld", cfg.shieldheadchance},
			{"StillThreshSld", cfg.stillthreshold},
			{"HitChanceSld", cfg.hitchance},
			{"AimMaxDistSld", cfg.aimmaxdist},
			{"MissSpreadSld", cfg.missspread},
			{"StickyDurSld", cfg.targetstickinessduration},
			{"StickyMinSld", cfg.targetstickinessmin},
			{"StickyMaxSld", cfg.targetstickinessmax},
			{"FovSld", cfg.fov},
			{"EspMaxDistSld", cfg.espmaxdist},
			{"C4MaxDistSld", cfg.c4espmaxdist},
			{"AutoShootDelaySld", cfg.autoshootdelay},
			{"AutoShootStartSld", cfg.autoshootstartdelay},
			{"LingerMinSld", cfg.autoshootlingermin},
			{"LingerMaxSld", cfg.autoshootlingermax},
			{"GrabDistSld", cfg.autograbdistance},
			{"GrabDelaySld", cfg.autograbdelay},
			{"SmoothSld", cfg.smoothing},
			{"MissFirstChanceSld", cfg.missFirstShotChance},
			{"ReactDelaySld", cfg.reactionDelay},
			{"MovePenSld", cfg.movingMissPenalty},
			{"JumpPenSld", cfg.jumpingMissPenalty},
			{"WgtHeadSld", cfg.bodyPartWeightHead},
			{"WgtTorsoSld", cfg.bodyPartWeightTorso},
			{"WgtArmsSld", cfg.bodyPartWeightArms},
			{"WgtLegsSld", cfg.bodyPartWeightLegs},
			{"WgtHRPSld", cfg.bodyPartWeightHRP},
			{"MicroAmtSld", cfg.microCorrectionAmount},
			{"MicroSpdSld", cfg.microCorrectionSpeed},
			{"JumpLegChanceSld", cfg.jumpLegChance},
			{"MoveArmChanceSld", cfg.moveArmChance},
			{"SmoothDistNearSld", cfg.smoothingDistNear},
            {"SmoothDistFarSld", cfg.smoothingDistFar},
            {"SmoothNearMultSld", cfg.smoothingNearMult},
            {"SmoothFarMultSld", cfg.smoothingFarMult},
            {"SmoothOnTargetThreshSld", cfg.smoothingOnTargetThreshold},

			{"TorsoBiasSld", cfg.torsoBias},
			{"MobFovOffSld", cfg.mobileFovOffset},
            {"TargetSwitchCooldownSld", cfg.targetSwitchCooldown},
		}
		for _, e in ipairs(slds) do
			pcall(function()
				if uiEls[e[1]] then uiEls[e[1]]:UpdateValue(e[2]) end
			end)
		end
		local drops = {
			{"AimPartDrop", cfg.aimpart},
			{"JumpTgtDrop", cfg.jumpingTargetPart},
			{"AutoWepDrop", cfg.autoshootweapon},
		}
		for _, e in ipairs(drops) do
			pcall(function()
				if uiEls[e[1]] then uiEls[e[1]]:UpdateSelection(e[2]) end
			end)
		end
		local cols = {
			{"EspColPick", cfg.espcolor},
			{"GuardColPick", cfg.espguards},
			{"InmateColPick", cfg.espinmates},
			{"CrimColPick", cfg.espcriminals},
			{"TeamColPick", cfg.espteam},
			{"C4ColPick", cfg.c4espcolor},
		}
		for _, e in ipairs(cols) do
			pcall(function()
				if uiEls[e[1]] then uiEls[e[1]]:SetColor(e[2]) end
			end)
		end
		pcall(function()
			if uiEls.WlPlrDrop then
				local o = getWlOpts()
				if uiEls.WlPlrDrop.ClearOptions then uiEls.WlPlrDrop:ClearOptions() end
				if uiEls.WlPlrDrop.InsertOptions then uiEls.WlPlrDrop:InsertOptions(o) end
			end
		end)
		pcall(syncDistEditor)
		pcall(updEsp)
		pcall(updC4Esp)
	end

	--// AIMBOT LEFT
	uiEls.SilentAimTog = sections.aimL:Toggle({
		Name = "Silent Aim",
		Default = cfg.enabled,
		Callback = function(s) cfg.enabled = s end,
	}, "SilentAimTog")

	uiEls.TeamCheckTog = sections.aimL:Toggle({
		Name = "Team Check",
		Default = cfg.teamcheck,
		Callback = function(s) cfg.teamcheck = s end,
	}, "TeamCheckTog")

	uiEls.WallCheckTog = sections.aimL:Toggle({
		Name = "Wall Check",
		Default = cfg.wallcheck,
		Callback = function(s) cfg.wallcheck = s end,
	}, "WallCheckTog")

	uiEls.DeathCheckTog = sections.aimL:Toggle({
		Name = "Death Check",
		Default = cfg.deathcheck,
		Callback = function(s) cfg.deathcheck = s end,
	}, "DeathCheckTog")

	uiEls.VehicleCheckTog = sections.aimL:Toggle({
		Name = "Vehicle Check",
		Default = cfg.vehiclecheck,
		Callback = function(s) cfg.vehiclecheck = s end,
	}, "VehicleCheckTog")

	uiEls.HostileCheckTog = sections.aimL:Toggle({
		Name = "Hostile Check",
		Default = cfg.hostilecheck,
		Callback = function(s) cfg.hostilecheck = s end,
	}, "HostileCheckTog")

	uiEls.TrespassCheckTog = sections.aimL:Toggle({
		Name = "Trespass Check",
		Default = cfg.trespasscheck,
		Callback = function(s) cfg.trespasscheck = s end,
	}, "TrespassCheckTog")

	uiEls.CrimSkipInTog = sections.aimL:Toggle({
		Name = "Criminals Skip Inmates",
		Default = cfg.criminalsnoinnmates,
		Callback = function(s) cfg.criminalsnoinnmates = s end,
	}, "CrimSkipInTog")

	uiEls.InSkipCrimTog = sections.aimL:Toggle({
		Name = "Inmates Skip Criminals",
		Default = cfg.inmatesnocriminals,
		Callback = function(s) cfg.inmatesnocriminals = s end,
	}, "InSkipCrimTog")

	uiEls.FFCheckTog = sections.aimL:Toggle({
		Name = "ForceField Check",
		Default = cfg.ffcheck,
		Callback = function(s) cfg.ffcheck = s end,
	}, "FFCheckTog")

	--// AIMBOT RIGHT
	uiEls.ShieldBreakTog = sections.aimR:Toggle({
		Name = "Shield Breaker",
		Default = cfg.shieldbreaker,
		Callback = function(s) cfg.shieldbreaker = s end,
	}, "ShieldBreakTog")

	uiEls.ShieldAngleSld = sections.aimR:Slider({
		Name = "Shield Front Angle",
		Default = cfg.shieldfrontangle,
		Minimum = -1,
		Maximum = 1,
		Precision = 1,
		Callback = function(v) cfg.shieldfrontangle = v end,
	}, "ShieldAngleSld")

	uiEls.ShieldRandHeadTog = sections.aimR:Toggle({
		Name = "Shield Random Head",
		Default = cfg.shieldrandomhead,
		Callback = function(s) cfg.shieldrandomhead = s end,
	}, "ShieldRandHeadTog")

	uiEls.ShieldHeadChanceSld = sections.aimR:Slider({
		Name = "Shield Head Chance",
		Default = cfg.shieldheadchance,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.shieldheadchance = v end,
	}, "ShieldHeadChanceSld")

	uiEls.TaserBypassHostTog = sections.aimR:Toggle({
		Name = "Taser Bypass Hostile",
		Default = cfg.taserbypasshostile,
		Callback = function(s) cfg.taserbypasshostile = s end,
	}, "TaserBypassHostTog")

	uiEls.TaserBypassTresTog = sections.aimR:Toggle({
		Name = "Taser Bypass Trespass",
		Default = cfg.taserbypasstrespass,
		Callback = function(s) cfg.taserbypasstrespass = s end,
	}, "TaserBypassTresTog")

	uiEls.TaserAlwaysTog = sections.aimR:Toggle({
		Name = "Taser Always Hit",
		Default = cfg.taseralwayshit,
		Callback = function(s) cfg.taseralwayshit = s end,
	}, "TaserAlwaysTog")

	uiEls.HitStillTog = sections.aimR:Toggle({
		Name = "Hit If Player Still",
		Default = cfg.ifplayerstill,
		Callback = function(s) cfg.ifplayerstill = s end,
	}, "HitStillTog")

	uiEls.StillThreshSld = sections.aimR:Slider({
		Name = "Still Threshold",
		Default = cfg.stillthreshold,
		Minimum = 0,
		Maximum = 5,
		Precision = 1,
		Callback = function(v) cfg.stillthreshold = v end,
	}, "StillThreshSld")

	uiEls.HitChanceSld = sections.aimR:Slider({
		Name = "Hit Chance",
		Default = cfg.hitchance,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.hitchance = v end,
	}, "HitChanceSld")

	uiEls.HitChanceAutoTog = sections.aimR:Toggle({
		Name = "Hit Chance Auto Only",
		Default = cfg.hitchanceAutoOnly,
		Callback = function(s) cfg.hitchanceAutoOnly = s end,
	}, "HitChanceAutoTog")

	uiEls.DistHitTog = sections.distL:Toggle({
		Name = "Distance Based Hitchance",
		Default = cfg.distancebasedhitchance,
		Callback = function(s)
			setDistEnabled(s)
			if uiEls.AimMaxDistSld then uiEls.AimMaxDistSld:UpdateValue(cfg.aimmaxdist) end
		end,
	}, "DistHitTog")

	uiEls.DistPtDrop = sections.distL:Dropdown({
		Name = "Selected Point",
		Default = "1. 200 studs -> 30%",
		Options = {"1. 200 studs -> 30%"},
		Callback = function(v)
			if syncingDist then return end
			local si = tonumber(tostring(v):match("^(%d+)%."))
			if si then selDistPt = si syncDistEditor() end
		end,
	}, "DistPtDrop")

	sections.distL:Button({
		Name = "Add Point",
		Callback = function()
			local pts = ensureDistPts()
			local lp = pts[#pts]
			local np = {distance = lp and (lp.distance + 100) or 200, chance = lp and math.max(lp.chance - 8, 0) or 30}
			pts[#pts + 1] = np
			table.sort(pts, function(a, b) return a.distance < b.distance end)
			for i, pt in ipairs(pts) do
				if pt == np then selDistPt = i break end
			end
			setDistEnabled(true)
			refreshUI()
			Window:Notify({Title = "Distance Hitchance", Description = "Added a new distance point.", Lifetime = 4})
		end,
	})

	sections.distL:Button({
		Name = "Remove Selected",
		Callback = function()
			local pts = ensureDistPts()
			if #pts <= 1 then
				Window:Notify({Title = "Distance Hitchance", Description = "Keep at least one point in the list.", Lifetime = 4})
				return
			end
			table.remove(pts, selDistPt)
			selDistPt = math.clamp(selDistPt, 1, #pts)
			refreshUI()
			Window:Notify({Title = "Distance Hitchance", Description = "Removed the selected point.", Lifetime = 4})
		end,
	})

	sections.distL:Button({
		Name = "Load Legit Preset",
		Callback = function()
			loadLegitDist()
			refreshUI()
			Window:Notify({Title = "Distance Hitchance", Description = "Loaded a legit distance preset and set base hitchance to 82.", Lifetime = 5})
		end,
	})

	sections.distL:Button({
		Name = "Load Blatant Preset",
		Callback = function()
			loadBlatantDist()
			refreshUI()
			Window:Notify({Title = "Distance Hitchance", Description = "Loaded a blatant distance preset and set base hitchance to 99.", Lifetime = 5})
		end,
	})

	sections.distL:Button({
		Name = "Reset to Default",
		Callback = function()
			cfg.distancehitchancepoints = getDefDistPts()
			selDistPt = 1
			refreshUI()
			Window:Notify({Title = "Distance Hitchance", Description = "Reset the distance list back to the default build.", Lifetime = 4})
		end,
	})

	uiEls.SelDistSld = sections.distR:Slider({
		Name = "Selected Distance",
		Default = 200,
		Minimum = 0,
		Maximum = 5000,
		Precision = 0,
		Callback = function(v)
			if syncingDist then return end
			local pts = ensureDistPts()
			local pt = pts[selDistPt]
			if not pt then return end
			pt.distance = v
			table.sort(pts, function(a, b) return a.distance < b.distance end)
			for i, ep in ipairs(pts) do
				if ep == pt then selDistPt = i break end
			end
			syncDistEditor()
		end,
	}, "SelDistSld")

	uiEls.SelChanceSld = sections.distR:Slider({
		Name = "Selected Hitchance",
		Default = 30,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v)
			if syncingDist then return end
			local pts = ensureDistPts()
			local pt = pts[selDistPt]
			if not pt then return end
			pt.chance = v
			syncDistEditor()
		end,
	}, "SelChanceSld")

	uiEls.AimMaxDistSld = sections.aimR:Slider({
		Name = "Aim Max Distance (0 = Any)",
		Default = cfg.aimmaxdist,
		Minimum = 0,
		Maximum = 5000,
		Precision = 0,
		Callback = function(v)
			if cfg.distancebasedhitchance or distForcesAimMax then
				storedAimMax = v
				cfg.aimmaxdist = 0
				if uiEls.AimMaxDistSld and v ~= 0 then uiEls.AimMaxDistSld:UpdateValue(0) end
				return
			end
			cfg.aimmaxdist = v
		end,
	}, "AimMaxDistSld")

	uiEls.MissSpreadSld = sections.aimR:Slider({
		Name = "Miss Spread",
		Default = cfg.missspread,
		Minimum = 0,
		Maximum = 20,
		Precision = 1,
		Callback = function(v) cfg.missspread = v end,
	}, "MissSpreadSld")

	uiEls.ShotgunNatTog = sections.aimR:Toggle({
		Name = "Shotgun Natural Spread",
		Default = cfg.shotgunnaturalspread,
		Callback = function(s) cfg.shotgunnaturalspread = s end,
	}, "ShotgunNatTog")

	uiEls.ShotgunGameTog = sections.aimR:Toggle({
		Name = "Shotgun Game Handled",
		Default = cfg.shotgungamehandled,
		Callback = function(s) cfg.shotgungamehandled = s end,
	}, "ShotgunGameTog")

	uiEls.PriorCloseTog = sections.aimR:Toggle({
		Name = "Prioritize Closest",
		Default = cfg.prioritizeclosest,
		Callback = function(s) cfg.prioritizeclosest = s end,
	}, "PriorCloseTog")

	uiEls.PriorCrimTog = sections.aimR:Toggle({
		Name = "Prioritize Criminals",
		Default = cfg.prioritizecriminals,
		Callback = function(s) cfg.prioritizecriminals = s end,
	}, "PriorCrimTog")

	uiEls.StickyTog = sections.aimR:Toggle({
		Name = "Target Stickiness",
		Default = cfg.targetstickiness,
		Callback = function(s) cfg.targetstickiness = s end,
	}, "StickyTog")

	uiEls.StickyDurSld = sections.aimR:Slider({
		Name = "Stickiness Duration",
		Default = cfg.targetstickinessduration,
		Minimum = 0.1,
		Maximum = 2,
		Precision = 1,
		Callback = function(v) cfg.targetstickinessduration = v end,
	}, "StickyDurSld")

	uiEls.StickyRandTog = sections.aimR:Toggle({
		Name = "Target Stickiness Random",
		Default = cfg.targetstickinessrandom,
		Callback = function(s) cfg.targetstickinessrandom = s end,
	}, "StickyRandTog")

	uiEls.StickyMinSld = sections.aimR:Slider({
		Name = "Target Stickiness Min",
		Default = cfg.targetstickinessmin,
		Minimum = 0.1,
		Maximum = 2,
		Precision = 1,
		Callback = function(v) cfg.targetstickinessmin = v end,
	}, "StickyMinSld")

	uiEls.StickyMaxSld = sections.aimR:Slider({
		Name = "Target Stickiness Max",
		Default = cfg.targetstickinessmax,
		Minimum = 0.1,
		Maximum = 2,
		Precision = 1,
		Callback = function(v) cfg.targetstickinessmax = v end,
	}, "StickyMaxSld")

	uiEls.StickyPersistTog = sections.aimR:Toggle({
		Name = "Stickiness Persist After Death",
		Default = cfg.stickyPersistDeath,
		Callback = function(s) cfg.stickyPersistDeath = s end,
	}, "StickyPersistTog")

	uiEls.FovSld = sections.aimR:Slider({
		Name = "FOV",
		Default = cfg.fov,
		Minimum = 10,
		Maximum = 500,
		Precision = 0,
		Callback = function(v) cfg.fov = v end,
	}, "FovSld")

	uiEls.ShowFovTog = sections.aimR:Toggle({
		Name = "Show FOV",
		Default = cfg.showfov,
		Callback = function(s) cfg.showfov = s end,
	}, "ShowFovTog")

	uiEls.StaticFovTog = sections.aimR:Toggle({
		Name = "Static FOV",
		Default = cfg.staticfov,
		Callback = function(s) cfg.staticfov = s end,
	}, "StaticFovTog")

	uiEls.MobFovOffSld = sections.aimR:Slider({
		Name = "Mobile FOV Offset",
		Default = cfg.mobileFovOffset,
		Minimum = 0,
		Maximum = 0.5,
		Precision = 2,
		Callback = function(v) cfg.mobileFovOffset = v end,
	}, "MobFovOffSld")

	uiEls.ShowTgtLineTog = sections.aimR:Toggle({
		Name = "Show Target Line",
		Default = cfg.showtargetline,
		Callback = function(s) cfg.showtargetline = s end,
	}, "ShowTgtLineTog")

	uiEls.AimPartDrop = sections.aimR:Dropdown({
		Name = "Aim Part",
		Default = cfg.aimpart,
		Options = cfg.partslist,
		Callback = function(v) cfg.aimpart = v end,
	}, "AimPartDrop")

	uiEls.RandPartsTog = sections.aimR:Toggle({
		Name = "Random Parts",
		Default = cfg.randomparts,
		Callback = function(s) cfg.randomparts = s end,
	}, "RandPartsTog")

	--// ESP LEFT
	uiEls.EspTog = sections.espL:Toggle({
		Name = "ESP",
		Default = cfg.esp,
		Callback = function(s) cfg.esp = s updEsp() end,
	}, "EspTog")

	uiEls.EspTeamCheckTog = sections.espL:Toggle({
		Name = "ESP Team Check",
		Default = cfg.espteamcheck,
		Callback = function(s) cfg.espteamcheck = s updEsp() end,
	}, "EspTeamCheckTog")

	uiEls.ShowTeamTog = sections.espL:Toggle({
		Name = "Show Team",
		Default = cfg.espshowteam,
		Callback = function(s) cfg.espshowteam = s updEsp() end,
	}, "ShowTeamTog")

	uiEls.EspMaxDistSld = sections.espL:Slider({
		Name = "ESP Max Distance (0 = Any)",
		Default = cfg.espmaxdist,
		Minimum = 0,
		Maximum = 5000,
		Precision = 0,
		Callback = function(v) cfg.espmaxdist = v updEsp() end,
	}, "EspMaxDistSld")

	uiEls.ShowDistTog = sections.espL:Toggle({
		Name = "Show Distance",
		Default = cfg.espshowdist,
		Callback = function(s) cfg.espshowdist = s updEsp() end,
	}, "ShowDistTog")

	uiEls.UseTeamColTog = sections.espL:Toggle({
		Name = "Use Team Colors",
		Default = cfg.espuseteamcolors,
		Callback = function(s) cfg.espuseteamcolors = s updEsp() end,
	}, "UseTeamColTog")

	uiEls.EspColPick = sections.espL:Colorpicker({
		Name = "ESP Color",
		Default = cfg.espcolor,
		Callback = function(c) cfg.espcolor = c updEsp() end,
	}, "EspColPick")

	uiEls.GuardColPick = sections.espL:Colorpicker({
		Name = "Guards Color",
		Default = cfg.espguards,
		Callback = function(c) cfg.espguards = c updEsp() end,
	}, "GuardColPick")

	uiEls.InmateColPick = sections.espL:Colorpicker({
		Name = "Inmates Color",
		Default = cfg.espinmates,
		Callback = function(c) cfg.espinmates = c updEsp() end,
	}, "InmateColPick")

	uiEls.CrimColPick = sections.espL:Colorpicker({
		Name = "Criminals Color",
		Default = cfg.espcriminals,
		Callback = function(c) cfg.espcriminals = c updEsp() end,
	}, "CrimColPick")

	uiEls.TeamColPick = sections.espL:Colorpicker({
		Name = "Team Color",
		Default = cfg.espteam,
		Callback = function(c) cfg.espteam = c updEsp() end,
	}, "TeamColPick")

	uiEls.CrossTeamEspTog = sections.espL:Toggle({
		Name = "Cross-Team ESP (Crim<->Inmate)",
		Default = cfg.crossTeamEsp,
		Callback = function(s) cfg.crossTeamEsp = s updEsp() end,
	}, "CrossTeamEspTog")

	--// ESP RIGHT
	uiEls.C4EspTog = sections.espR:Toggle({
		Name = "C4 ESP",
		Default = cfg.c4esp,
		Callback = function(s) cfg.c4esp = s updC4Esp() end,
	}, "C4EspTog")

	uiEls.C4MaxDistSld = sections.espR:Slider({
		Name = "C4 ESP Max Distance (0 = Any)",
		Default = cfg.c4espmaxdist,
		Minimum = 0,
		Maximum = 5000,
		Precision = 0,
		Callback = function(v) cfg.c4espmaxdist = v updC4Esp() end,
	}, "C4MaxDistSld")

	uiEls.C4ShowDistTog = sections.espR:Toggle({
		Name = "C4 Show Distance",
		Default = cfg.c4espshowdist,
		Callback = function(s) cfg.c4espshowdist = s updC4Esp() end,
	}, "C4ShowDistTog")

	uiEls.C4ColPick = sections.espR:Colorpicker({
		Name = "C4 ESP Color",
		Default = cfg.c4espcolor,
		Callback = function(c) cfg.c4espcolor = c updC4Esp() end,
	}, "C4ColPick")

	--// AUTOSHOOT LEFT
	uiEls.AutoShootTog = sections.autoL:Toggle({
		Name = "Autoshoot",
		Default = cfg.autoshoot,
		Callback = function(s) cfg.autoshoot = s end,
	}, "AutoShootTog")

	uiEls.AutoShootDelaySld = sections.autoL:Slider({
		Name = "Autoshoot Delay",
		Default = cfg.autoshootdelay,
		Minimum = 0.05,
		Maximum = 0.5,
		Precision = 1,
		Callback = function(v) cfg.autoshootdelay = v end,
	}, "AutoShootDelaySld")

	uiEls.AutoShootStartSld = sections.autoL:Slider({
		Name = "Autoshoot Start Delay",
		Default = cfg.autoshootstartdelay,
		Minimum = 0,
		Maximum = 1,
		Precision = 1,
		Callback = function(v) cfg.autoshootstartdelay = v end,
	}, "AutoShootStartSld")

	uiEls.AutoShootLingerTog = sections.autoL:Toggle({
		Name = "Autoshoot Linger",
		Default = cfg.autoshootlinger,
		Callback = function(s) cfg.autoshootlinger = s end,
	}, "AutoShootLingerTog")

	uiEls.LingerMinSld = sections.autoL:Slider({
		Name = "Linger Min (s)",
		Default = cfg.autoshootlingermin,
		Minimum = 0.1,
		Maximum = 3,
		Precision = 1,
		Callback = function(v) cfg.autoshootlingermin = v end,
	}, "LingerMinSld")

	uiEls.LingerMaxSld = sections.autoL:Slider({
		Name = "Linger Max (s)",
		Default = cfg.autoshootlingermax,
		Minimum = 0.1,
		Maximum = 5,
		Precision = 1,
		Callback = function(v) cfg.autoshootlingermax = v end,
	}, "LingerMaxSld")

	uiEls.LingerLastVisTog = sections.autoL:Toggle({
		Name = "Linger At Last Visible Pos",
		Default = cfg.lingerLastVisible,
		Callback = function(s) cfg.lingerLastVisible = s end,
	}, "LingerLastVisTog")

	--// AUTOSHOOT RIGHT
	uiEls.AutoWepDrop = sections.autoR:Dropdown({
		Name = "Autoshoot Weapon",
		Default = cfg.autoshootweapon,
		Options = {"Any", "Taser", "M9", "AK-47", "M4A1", "Remington 870", "Revolver", "Shotgun", "Sniper", "Automatic"},
		Callback = function(v) cfg.autoshootweapon = v end,
	}, "AutoWepDrop")

	uiEls.AutoGrabTog = sections.autoR:Toggle({
		Name = "Auto Grab",
		Default = cfg.autograb,
		Callback = function(s) cfg.autograb = s end,
	}, "AutoGrabTog")

	uiEls.GrabDistSld = sections.autoR:Slider({
		Name = "Auto Grab Distance",
		Default = cfg.autograbdistance,
		Minimum = 0,
		Maximum = 12,
		Precision = 1,
		Callback = function(v) cfg.autograbdistance = v end,
	}, "GrabDistSld")

	uiEls.GrabDelaySld = sections.autoR:Slider({
		Name = "Auto Grab Delay",
		Default = cfg.autograbdelay,
		Minimum = 0,
		Maximum = 3,
		Precision = 1,
		Callback = function(v) cfg.autograbdelay = v end,
	}, "GrabDelaySld")

	uiEls.GrabKeyTog = sections.autoR:Toggle({
		Name = "Grab Keycards",
		Default = cfg.autograbkeycard,
		Callback = function(s) cfg.autograbkeycard = s end,
	}, "GrabKeyTog")

	uiEls.GrabM9Tog = sections.autoR:Toggle({
		Name = "Grab M9",
		Default = cfg.autograbm9,
		Callback = function(s) cfg.autograbm9 = s end,
	}, "GrabM9Tog")


	--// WHITELIST LEFT
	uiEls.WlEnabledTog = sections.wlL:Toggle({
		Name = "Whitelist Mode (Only WL'd = targets)",
		Default = cfg.whitelistenabled,
		Callback = function(s) cfg.whitelistenabled = s end,
	}, "WlEnabledTog")

	uiEls.WlPlrDrop = sections.wlL:Dropdown({
		Name = "Select Player",
		Default = "",
		Options = getWlOpts(),
		Callback = function(v) selWlPlr = findPlrByDrop(v) end,
	}, "WlPlrDrop")

	sections.wlL:Button({
		Name = "Toggle Whitelist (Selected)",
		Callback = function()
			if not selWlPlr then
				Window:Notify({Title = "Whitelist", Description = "Select a player first!", Lifetime = 3})
				return
			end
			toggleWl(selWlPlr)
			Window:Notify({
				Title = "Whitelist",
				Description = selWlPlr.Name .. (isWl(selWlPlr) and " is now WHITELISTED" or " removed from whitelist"),
				Lifetime = 3
			})
			if uiEls.WlPlrDrop then
				local o = getWlOpts()
				uiEls.WlPlrDrop:ClearOptions()
				uiEls.WlPlrDrop:InsertOptions(o)
			end
		end,
	})

	sections.wlL:Button({
		Name = "Refresh Player List",
		Callback = function()
			if uiEls.WlPlrDrop then
				local o = getWlOpts()
				uiEls.WlPlrDrop:ClearOptions()
				uiEls.WlPlrDrop:InsertOptions(o)
			end
			Window:Notify({Title = "Whitelist", Description = "Player list refreshed.", Lifetime = 2})
		end,
	})

	sections.wlR:Button({
		Name = "Clear All Whitelisted",
		Callback = function()
			wlPlrs = {}
			saveWl(wlPlrs)
			Window:Notify({Title = "Whitelist", Description = "Cleared all whitelisted players.", Lifetime = 3})
			if uiEls.WlPlrDrop then
				local o = getWlOpts()
				uiEls.WlPlrDrop:ClearOptions()
				uiEls.WlPlrDrop:InsertOptions(o)
			end
		end,
	})

	sections.wlR:Button({
		Name = "Show Protected Count",
		Callback = function()
			local c = 0
			for _ in pairs(wlPlrs) do c = c + 1 end
			Window:Notify({Title = "Whitelist", Description = c .. " player(s) protected. Persists across servers!", Lifetime = 4})
		end,
	})

	plrs.PlayerAdded:Connect(function()
		task.delay(0.5, function()
			if uiEls.WlPlrDrop then
				local o = getWlOpts()
				uiEls.WlPlrDrop:ClearOptions()
				uiEls.WlPlrDrop:InsertOptions(o)
			end
		end)
	end)

	plrs.PlayerRemoving:Connect(function()
		task.delay(0.5, function()
			if uiEls.WlPlrDrop then
				local o = getWlOpts()
				uiEls.WlPlrDrop:ClearOptions()
				uiEls.WlPlrDrop:InsertOptions(o)
			end
		end)
	end)

	--// LEGIT TAB LEFT
	uiEls.LegitModeTog = sections.legL:Toggle({
		Name = "Legit Mode (All Humanize)",
		Default = cfg.legitMode,
		Callback = function(s)
			cfg.legitMode = s
			if s then
				cfg.smoothingEnabled = true
				cfg.missFirstShot = true
				cfg.reactionDelayEnabled = true
				cfg.microCorrectionEnabled = true
				cfg.dynamicHitchanceEnabled = true
			else
				cfg.smoothingEnabled = false
				cfg.missFirstShot = false
				cfg.reactionDelayEnabled = false
				cfg.microCorrectionEnabled = false
				cfg.dynamicHitchanceEnabled = false
			end
			if uiEls.SmoothEnTog then uiEls.SmoothEnTog:UpdateState(cfg.smoothingEnabled) end
			if uiEls.MissFirstTog then uiEls.MissFirstTog:UpdateState(cfg.missFirstShot) end
			if uiEls.ReactDelayEnTog then uiEls.ReactDelayEnTog:UpdateState(cfg.reactionDelayEnabled) end
			if uiEls.MicroCorrEnTog then uiEls.MicroCorrEnTog:UpdateState(cfg.microCorrectionEnabled) end
			if uiEls.DynHitTog then uiEls.DynHitTog:UpdateState(cfg.dynamicHitchanceEnabled) end
		end,
	}, "LegitModeTog")

	uiEls.SmoothEnTog = sections.legL:Toggle({
		Name = "Smoothing Enabled",
		Default = cfg.smoothingEnabled,
		Callback = function(s) cfg.smoothingEnabled = s end,
	}, "SmoothEnTog")

	uiEls.SmoothSld = sections.legL:Slider({
		Name = "Smoothing (0=Instant, 1=Slow)",
		Default = cfg.smoothing,
		Minimum = 0,
		Maximum = 1,
		Precision = 2,
		Callback = function(v) cfg.smoothing = v end,
	}, "SmoothSld")
	
	uiEls.SmoothDistEnTog = sections.legL:Toggle({
	Name = "Distance-Based Smoothing",
	Default = cfg.smoothingDistEnabled,
	Callback = function(s) cfg.smoothingDistEnabled = s end,
}, "SmoothDistEnTog")

uiEls.SmoothDistNearSld = sections.legL:Slider({
	Name = "Near Distance (studs)",
	Default = cfg.smoothingDistNear,
	Minimum = 10,
	Maximum = 200,
	Precision = 0,
	Callback = function(v) cfg.smoothingDistNear = v end,
}, "SmoothDistNearSld")

uiEls.SmoothDistFarSld = sections.legL:Slider({
	Name = "Far Distance (studs)",
	Default = cfg.smoothingDistFar,
	Minimum = 100,
	Maximum = 1000,
	Precision = 0,
	Callback = function(v) cfg.smoothingDistFar = v end,
}, "SmoothDistFarSld")

uiEls.SmoothNearMultSld = sections.legL:Slider({
	Name = "Near Smooth Mult (fast)",
	Default = cfg.smoothingNearMult,
	Minimum = 0.01,
	Maximum = 1,
	Precision = 2,
	Callback = function(v) cfg.smoothingNearMult = v end,
}, "SmoothNearMultSld")

uiEls.SmoothFarMultSld = sections.legL:Slider({
	Name = "Far Smooth Mult (slow)",
	Default = cfg.smoothingFarMult,
	Minimum = 0.01,
	Maximum = 2,
	Precision = 2,
	Callback = function(v) cfg.smoothingFarMult = v end,
}, "SmoothFarMultSld")


	uiEls.MissFirstTog = sections.legL:Toggle({
		Name = "Miss First Shot",
		Default = cfg.missFirstShot,
		Callback = function(s) cfg.missFirstShot = s end,
	}, "MissFirstTog")

	uiEls.MissFirstChanceSld = sections.legL:Slider({
		Name = "Miss First Shot Chance",
		Default = cfg.missFirstShotChance,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.missFirstShotChance = v end,
	}, "MissFirstChanceSld")

	uiEls.ReactDelayEnTog = sections.legL:Toggle({
		Name = "Reaction Delay",
		Default = cfg.reactionDelayEnabled,
		Callback = function(s) cfg.reactionDelayEnabled = s end,
	}, "ReactDelayEnTog")

	uiEls.ReactDelaySld = sections.legL:Slider({
		Name = "Reaction Delay (seconds)",
		Default = cfg.reactionDelay,
		Minimum = 0,
		Maximum = 0.5,
		Precision = 2,
		Callback = function(v) cfg.reactionDelay = v end,
	}, "ReactDelaySld")

	--// LEGIT TAB RIGHT
	uiEls.MicroCorrEnTog = sections.legR:Toggle({
		Name = "Micro-Correction (Overshoot)",
		Default = cfg.microCorrectionEnabled,
		Callback = function(s) cfg.microCorrectionEnabled = s end,
	}, "MicroCorrEnTog")

	uiEls.MicroAmtSld = sections.legR:Slider({
		Name = "Micro-Correction Amount",
		Default = cfg.microCorrectionAmount,
		Minimum = 0,
		Maximum = 0.5,
		Precision = 2,
		Callback = function(v) cfg.microCorrectionAmount = v end,
	}, "MicroAmtSld")

	uiEls.MicroSpdSld = sections.legR:Slider({
		Name = "Micro-Correction Speed",
		Default = cfg.microCorrectionSpeed,
		Minimum = 0.01,
		Maximum = 1,
		Precision = 2,
		Callback = function(v) cfg.microCorrectionSpeed = v end,
	}, "MicroSpdSld")
	
	uiEls.SmoothShootTilTog = sections.legR:Toggle({
	Name = "Shoot Only When On Target",
	Default = cfg.smoothingShootUntilOnTarget,
	Callback = function(s) cfg.smoothingShootUntilOnTarget = s end,
}, "SmoothShootTilTog")

uiEls.TargetSwitchCooldownTog = sections.legR:Toggle({
    Name = "Target Switch Cooldown",
    Default = cfg.targetSwitchCooldownEnabled,
    Callback = function(s) cfg.targetSwitchCooldownEnabled = s end,
}, "TargetSwitchCooldownTog")

uiEls.TargetSwitchCooldownSld = sections.legR:Slider({
    Name = "Switch Cooldown (s)",
    Default = cfg.targetSwitchCooldown,
    Minimum = 0,
    Maximum = 2,
    Precision = 2,
    Callback = function(v) cfg.targetSwitchCooldown = v end,
}, "TargetSwitchCooldownSld")

uiEls.SmoothOnTargetThreshSld = sections.legR:Slider({
	Name = "On-Target Threshold (px)",
	Default = cfg.smoothingOnTargetThreshold,
	Minimum = 1,
	Maximum = 20,
	Precision = 0,
	Callback = function(v) cfg.smoothingOnTargetThreshold = v end,
}, "SmoothOnTargetThreshSld")


	uiEls.DynHitTog = sections.legR:Toggle({
		Name = "Dynamic Hitchance (Behavior)",
		Default = cfg.dynamicHitchanceEnabled,
		Callback = function(s) cfg.dynamicHitchanceEnabled = s end,
	}, "DynHitTog")

	uiEls.MovePenSld = sections.legR:Slider({
		Name = "Moving Miss Penalty",
		Default = cfg.movingMissPenalty,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.movingMissPenalty = v end,
	}, "MovePenSld")

	uiEls.JumpPenSld = sections.legR:Slider({
		Name = "Jumping Miss Penalty",
		Default = cfg.jumpingMissPenalty,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.jumpingMissPenalty = v end,
	}, "JumpPenSld")

	uiEls.StackBehTog = sections.legR:Toggle({
		Name = "Stack Behavior Penalties",
		Default = cfg.stackBehaviorMiss,
		Callback = function(s) cfg.stackBehaviorMiss = s end,
	}, "StackBehTog")

	uiEls.WepProfEnTog = sections.legR:Toggle({
		Name = "Weapon Profiles",
		Default = cfg.weaponProfilesEnabled,
		Callback = function(s)
			cfg.weaponProfilesEnabled = s
			applyWepProf(curGun)
		end,
	}, "WepProfEnTog")

	--// SMART TARGET LEFT
	uiEls.SmartTgtTog = sections.smartL:Toggle({
		Name = "Smart Body Targeting",
		Default = cfg.smartBodyTargeting,
		Callback = function(s) cfg.smartBodyTargeting = s end,
	}, "SmartTgtTog")

	uiEls.JumpLegTog = sections.smartL:Toggle({
	Name = "Shoot Legs On Jump",
	Default = cfg.jumpLegChance > 0,
	Callback = function(s)
		if s and cfg.jumpLegChance <= 0 then
			cfg.jumpLegChance = 100
		elseif not s then
			cfg.jumpLegChance = 0
		end
		if uiEls.JumpLegChanceSld then uiEls.JumpLegChanceSld:UpdateValue(cfg.jumpLegChance) end
	end,
}, "JumpLegTog")


	uiEls.JumpLegChanceSld = sections.smartL:Slider({
	Name = "Jump Leg Chance",
	Default = cfg.jumpLegChance,
	Minimum = 0,
	Maximum = 100,
	Precision = 0,
	Callback = function(v)
		cfg.jumpLegChance = v
		if uiEls.JumpLegTog then uiEls.JumpLegTog:UpdateState(v > 0) end
	end,
}, "JumpLegChanceSld")


	uiEls.MoveArmTog = sections.smartL:Toggle({
	Name = "Shoot Arms When Moving",
	Default = cfg.moveArmChance > 0,
	Callback = function(s)
		if s and cfg.moveArmChance <= 0 then
			cfg.moveArmChance = 100
		elseif not s then
			cfg.moveArmChance = 0
		end
		if uiEls.MoveArmChanceSld then uiEls.MoveArmChanceSld:UpdateValue(cfg.moveArmChance) end
	end,
}, "MoveArmTog")


	uiEls.MoveArmChanceSld = sections.smartL:Slider({
	Name = "Move Arm Chance",
	Default = cfg.moveArmChance,
	Minimum = 0,
	Maximum = 100,
	Precision = 0,
	Callback = function(v)
		cfg.moveArmChance = v
		if uiEls.MoveArmTog then uiEls.MoveArmTog:UpdateState(v > 0) end
	end,
}, "MoveArmChanceSld")


	uiEls.TorsoBiasTog = sections.smartL:Toggle({
		Name = "Torso Bias Enabled",
		Default = cfg.torsoBiasEnabled,
		Callback = function(s) cfg.torsoBiasEnabled = s end,
	}, "TorsoBiasTog")

	uiEls.TorsoBiasSld = sections.smartL:Slider({
		Name = "Torso Bias Chance",
		Default = cfg.torsoBias,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.torsoBias = v end,
	}, "TorsoBiasSld")

	--// SMART TARGET RIGHT
	uiEls.JumpTgtDrop = sections.smartR:Dropdown({
		Name = "Jumping Target Part",
		Default = cfg.jumpingTargetPart,
		Options = cfg.partslist,
		Callback = function(v) cfg.jumpingTargetPart = v end,
	}, "JumpTgtDrop")

	uiEls.WgtHeadSld = sections.smartR:Slider({
		Name = "Part Weight: Head",
		Default = cfg.bodyPartWeightHead,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.bodyPartWeightHead = v end,
	}, "WgtHeadSld")

	uiEls.WgtTorsoSld = sections.smartR:Slider({
		Name = "Part Weight: Torso",
		Default = cfg.bodyPartWeightTorso,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.bodyPartWeightTorso = v end,
	}, "WgtTorsoSld")

	uiEls.WgtArmsSld = sections.smartR:Slider({
		Name = "Part Weight: Arms",
		Default = cfg.bodyPartWeightArms,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.bodyPartWeightArms = v end,
	}, "WgtArmsSld")

	uiEls.WgtLegsSld = sections.smartR:Slider({
		Name = "Part Weight: Legs",
		Default = cfg.bodyPartWeightLegs,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.bodyPartWeightLegs = v end,
	}, "WgtLegsSld")

	uiEls.WgtHRPSld = sections.smartR:Slider({
		Name = "Part Weight: HRP",
		Default = cfg.bodyPartWeightHRP,
		Minimum = 0,
		Maximum = 100,
		Precision = 0,
		Callback = function(v) cfg.bodyPartWeightHRP = v end,
	}, "WgtHRPSld")

	--// CRIM TARGETING FILTERS (Smart Tab Right)
	uiEls.CrimHostOnlyTog = sections.smartR:Toggle({
		Name = "Crim: Target Hostile Inmates Only",
		Default = cfg.crimTargetHostileOnly,
		Callback = function(s) cfg.crimTargetHostileOnly = s end,
	}, "CrimHostOnlyTog")

	uiEls.CrimTresOnlyTog = sections.smartR:Toggle({
		Name = "Crim: Target Trespass Inmates Only",
		Default = cfg.crimTargetTrespassOnly,
		Callback = function(s) cfg.crimTargetTrespassOnly = s end,
	}, "CrimTresOnlyTog")

	--// SETTINGS LEFT - Config
	local cfgNameInp = curAutoName ~= "" and curAutoName or ""

	sections.setL:Input({
		Name = "Config Name",
		Placeholder = "Enter config name...",
		Callback = function(t) cfgNameInp = t end,
	}, "ConfigNameInp")

	sections.setL:Button({
		Name = "Save Config",
		Callback = function()
			if cfgNameInp == "" then
				Window:Notify({Title = "Config", Description = "Please enter a config name!", Lifetime = 3})
				return
			end
			if saveCfg(cfgNameInp) then
				Window:Notify({Title = "Config", Description = "Saved config: " .. cfgNameInp, Lifetime = 3})
			else
				Window:Notify({Title = "Config", Description = "Failed to save config!", Lifetime = 3})
			end
		end,
	})

	sections.setL:Button({
		Name = "Load Config",
		Callback = function()
			if cfgNameInp == "" then
				Window:Notify({Title = "Config", Description = "Please enter a config name!", Lifetime = 3})
				return
			end
			if loadCfg(cfgNameInp) then
				refreshUI()
				Window:Notify({Title = "Config", Description = "Loaded config: " .. cfgNameInp, Lifetime = 3})
			else
				Window:Notify({Title = "Config", Description = "Config not found: " .. cfgNameInp, Lifetime = 3})
			end
		end,
	})

	sections.setL:Button({
		Name = "Delete Config",
		Callback = function()
			if cfgNameInp == "" then
				Window:Notify({Title = "Config", Description = "Please enter a config name!", Lifetime = 3})
				return
			end
			if delCfg(cfgNameInp) then
				Window:Notify({Title = "Config", Description = "Deleted config: " .. cfgNameInp, Lifetime = 3})
			else
				Window:Notify({Title = "Config", Description = "Config not found: " .. cfgNameInp, Lifetime = 3})
			end
		end,
	})

	sections.setL:Button({
		Name = "List Configs",
		Callback = function()
			local c = getCfgList()
			if #c == 0 then
				Window:Notify({Title = "Configs", Description = "No configs found!", Lifetime = 5})
			else
				Window:Notify({Title = "Configs", Description = table.concat(c, ", "), Lifetime = 10})
			end
		end,
	})

	--// SETTINGS RIGHT - Auto Load & Reset
	sections.setR:Button({
		Name = "Set Auto Load",
		Callback = function()
			if cfgNameInp == "" then
				Window:Notify({Title = "Auto Load", Description = "Enter a config name first.", Lifetime = 3})
				return
			end
			if not isfile or not isfile(cfgFolder .. "/" .. cfgNameInp .. ".json") then
				Window:Notify({Title = "Auto Load", Description = "Config not found: " .. cfgNameInp, Lifetime = 3})
				return
			end
			if setAutoLoad(cfgNameInp) then
				curAutoName = cfgNameInp
				Window:Notify({Title = "Auto Load", Description = "Will auto load: " .. cfgNameInp, Lifetime = 4})
			else
				Window:Notify({Title = "Auto Load", Description = "Failed to save auto load config.", Lifetime = 3})
			end
		end,
	})

	sections.setR:Button({
		Name = "Load Auto Config Now",
		Callback = function()
			local an = getAutoLoad()
			if an == "" then
				Window:Notify({Title = "Auto Load", Description = "No auto load config set.", Lifetime = 3})
				return
			end
			if loadCfg(an) then
				curAutoName = an
				cfgNameInp = an
				refreshUI()
				Window:Notify({Title = "Auto Load", Description = "Loaded auto config: " .. an, Lifetime = 4})
			else
				Window:Notify({Title = "Auto Load", Description = "Config not found: " .. an, Lifetime = 3})
			end
		end,
	})

	sections.setR:Button({
		Name = "Clear Auto Load",
		Callback = function()
			if clearAutoLoad() then
				curAutoName = ""
				Window:Notify({Title = "Auto Load", Description = "Cleared auto load config.", Lifetime = 3})
			else
				Window:Notify({Title = "Auto Load", Description = "Failed to clear auto load config.", Lifetime = 3})
			end
		end,
	})

	sections.setR:Button({
		Name = "Reset to Defaults",
		Callback = function()
			for k, v in pairs(defaultCfg) do
				cfg[k] = deepCopy(v)
			end
			syncDistAimMax()
			resetAim()
			refreshUI()
			Window:Notify({Title = "Config", Description = "Reset to defaults!", Lifetime = 3})
		end,
	})

	refreshUI()
	return Window
end

local Window = initUI()
