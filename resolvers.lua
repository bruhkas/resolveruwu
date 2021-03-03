local enable_resolver = ui.new_checkbox("RAGE", "Other", "Resolver.lua")
local reset_plist = ui.reference("PLAYERS", "Players", "Reset all")
local function resolve(player)
    plist.set(player, "Correction Active", true) -- skeet resolver sucks, turn it off

    --[[]]-- our resolver start
    plist.set(player, "Force body yaw", true)
    plist.set(player, "Force body yaw value", math.random(18, 22, 33, 48))
end

local function on_setup_command()
    local enemies = entity.get_players(true)
    for i = 1, #enemies do
        local player = enemies[i]
        resolve(player)
    end
end

client.set_event_callback("destroy", function()
    ui.set(reset_plist)
end)

client.register_esp_flag("", 0, 255, 0 , function(entindex)
    if not entity.is_enemy(entindex) then
        return false
    end
    
    if plist.get(entindex, "Force body yaw") then
        return true
    end
end)

ui.set_callback(enable_resolver, function()
    if ui.get(enable_resolver) then
        client.set_event_callback("paint", on_setup_command)
    else
        client.unset_event_callback("paint", on_setup_command)
        ui.set(reset_plist)
    end
end)



--drink
local function resolve(player)
    plist.set(player, "Correction Active", true) -- skeet resolver sucks, turn it off

    --[[]]-- our resolver start
    plist.set(player, "Force body yaw", true)
    plist.set(player, "Force body yaw value", math.random(18, 22, 33, 48))
end

local function on_setup_command()
    local enemies = entity.get_players(true)
    for i = 1, #enemies do
        local player = enemies[i]
        resolve(player)
    end
end

client.set_event_callback("destroy", function()
    ui.set(reset_plist)
end)

client.register_esp_flag("", 0, 255, 0 , function(entindex)
    if not entity.is_enemy(entindex) then
        return false
    end
    
    if plist.get(entindex, "Force body yaw") then
        return true
    end
end)

ui.set_callback(enable_resolver, function()
    if ui.get(enable_resolver) then
        client.set_event_callback("paint", on_setup_command)
    else
        client.unset_event_callback("paint", on_setup_command)
        ui.set(reset_plist)
    end
end)




--blink
local function resolve(player)
    plist.set(player, "Correction Active", true) -- skeet resolver sucks, turn it off

    --[[]]-- our resolver start
    plist.set(player, "Force body yaw", true)
    plist.set(player, "Force body yaw value", math.random(48, 33, 22, 18))
end

local function on_setup_command()
    local enemies = entity.get_players(true)
    for i = 1, #enemies do
        local player = enemies[i]
        resolve(player)
    end
end

client.set_event_callback("destroy", function()
    ui.set(reset_plist)
end)

client.register_esp_flag("", 0, 255, 0 , function(entindex)
    if not entity.is_enemy(entindex) then
        return false
    end
    
    if plist.get(entindex, "Force body yaw") then
        return true
    end
end)

ui.set_callback(enable_resolver, function()
    if ui.get(enable_resolver) then
        client.set_event_callback("paint", on_setup_command)
    else
        client.unset_event_callback("paint", on_setup_command)
        ui.set(reset_plist)
    end
end)





-- INSERT YOUR OWN NAME BELOW
local user = "Resolver.lua | discord.gg/aFVXExcARG" -- INSERT YOUR OWN NAME HERE
-- INSERT YOUR OWN NAME ABOVE

local frametimes = { }
local fps_prev = 0
local last_update_time = 0

function AccumulateFps()
	local ft = globals.absoluteframetime()
	if ft > 0 then
		table.insert(frametimes, 1, ft)
	end
	local count = #frametimes
	if count == 0 then
		return 0
	end
	local i, accum = 0, 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end
	accum = accum / i
	while i < count do
		i = i + 1
		table.remove(frametimes)
	end
	local fps = 1 / accum
	local rt = globals.realtime()
	if math.abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end
	return math.floor(fps + 0.5)
end

local is_inside = function(a, b, x, y, w, h) 
	return a >= x and a <= w and b >= y - 4 and b <= h 
end

local pos = database.read("watermarkpos") or {300,30} 
local tX, tY = pos[1], pos[2] 
local oX, oY, _d 
local drag_menu = function(x, y, w, h)
	if not ui.is_menu_open() then 
		return tX, tY
	end
	local mouse_down = client.key_state(0x01)
	if mouse_down then 
		local X, Y = ui.mouse_position()
		if not _d then 
		local w, h = x + w, y + h 
		if is_inside(X, Y, x, y, w, h) then 
			oX, oY, _d = X - x, Y - y, true 
		end 
		else 
			tX, tY = X - oX, Y - oY 
		end 
		else 
			_d = false 
		end 
	local screenx, screeny = client.screen_size()
	local clampedX, clampedY
	if tX <= 0 then
		clampedX = 0
	elseif tX > (screenx - w) then
		clampedX = screenx - w
	else
		clampedX = tX
	end
	if tY <= 0 then
		clampedY = 0
	elseif tY > (screeny - h) then
		clampedY = screeny - h
	else
		clampedY = tY
	end
	tX, tY = clampedX, clampedY
	return clampedX, clampedY
end

watermarkcolorlbale = ui.new_label("Rage", "Other", "Watermark color")
watermarkcolor = ui.new_color_picker("Rage", "Other", "Watermark colorpicker", 200, 140, 56, 255)
watermarkmode = ui.new_combobox("Rage", "Other", "\n watermark mode", "Normal", "Only username")
watermarktextlabel = ui.new_label("Rage", "Other", "Custom watermark text")
watermarktext = ui.new_textbox("Rage", "Other", "\n custom text")

-----WATERMARK
local function watermarkvisible()

	watermode = ui.get(watermarkmode) == "Normal"

	ui.set_visible(watermarktextlabel, watermode)
	ui.set_visible(watermarktext, watermode)
end
ui.set_callback(watermarkmode, watermarkvisible)
watermarkvisible()

----------COOL WATERMARK----------
client.set_event_callback("paint_ui", function()
	if ui.get(watermarkmode) == "Only username" then
		local usertext_widht = renderer.measure_text(nil, "User: ")
		local user_widht = renderer.measure_text(nil, user)
		local w = usertext_widht + user_widht + 16
		local x, y = drag_menu(tX, tY, w, 26)
		local r, g, b = ui.get(watermarkcolor)
		renderer.rectangle(x, y, w, 26, 45, 45, 50, 255)
		renderer.rectangle(x, y, w, 4, r, g, b, 255)
  		renderer.text(x + 8, y + 8, 255, 255, 255, 255, "", 0, "User: ", user)
  	elseif ui.get(watermarkmode) == "Normal" then
		local fpsfunc = AccumulateFps()
		local customtext_widht = renderer.measure_text(nil, ui.get(watermarktext))
		local user_widht = renderer.measure_text(nil, user)
  		local pingtext_widht = renderer.measure_text(nil, " | rtt: ")
  		local ping_widht = renderer.measure_text(nil, Ping)
  		local fpstext_widht = renderer.measure_text(nil, " | fps: ")
  		local fps_widht = renderer.measure_text(nil, fpsfunc)
  		local line_widht = renderer.measure_text(nil, " | ")
  		local hour_widht = renderer.measure_text(nil, hours)
  		local dot_widht = renderer.measure_text(nil, ":")
  		local minute_widht = renderer.measure_text(nil, minutes)
  		local second_widht = renderer.measure_text(nil, seconds)
  		if ui.get(watermarktext) == "" then
  			w2 = user_widht + pingtext_widht + ping_widht + fpstext_widht + fps_widht + line_widht + hour_widht + dot_widht + minute_widht + dot_widht + second_widht + 16
		else
			w2 = customtext_widht + line_widht + user_widht + pingtext_widht + ping_widht + fpstext_widht + fps_widht + line_widht + hour_widht + dot_widht + minute_widht + dot_widht + second_widht + 16
		end
		local x2, y2 = drag_menu(tX, tY, w2, 26)
		local r, g, b = ui.get(watermarkcolor)
		Ping = math.floor(math.min(1000, client.latency() * 1000) + 0.5)
		local fpsfunc = AccumulateFps()
		renderer.rectangle(x2, y2, w2, 26, 45, 45, 50, 155)
		renderer.rectangle(x2, y2, w2, 4, r, g, b, 255)
		if ui.get(watermarktext) == "" then
  			renderer.text(x2 + 8, y2 + 8, 255, 255, 255, 255, "", 0, user, " | Fps: ", fpsfunc, " | Type: Dynamic")
  		else
  			renderer.text(x2 + 8, y2 + 8, 255, 255, 255, 255, "", 0, ui.get(watermarktext), " | ", user, " | Fps: ", fpsfunc, " | Type: Dynamic")
  		end
  	end
end)

client.set_event_callback("shutdown", function()
	database.write("watermarkpos", {tX, tY})
	database.write("watermarkcustom", ui.get(watermarktext))
end)

if database.read("watermarkcustom") == nil then
    ui.set(watermarktext, "")
else
    ui.set(watermarktext, database.read("watermarkcustom"))
end




---shot log
local color_log = client.color_log

-- hitgroup name creds: sapphyrus

local hitgroup_names = {
    "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "????",
    "gear"
}

local logging_section_label = ui.new_label( 'Rage', 'Other', 'Resolver Shot logger')
local logging_enabled_checkbox = ui.new_checkbox( 'Rage', 'Other', 'Shot logging' )

local function on_aim_missed( event )
    if ui.get( logging_enabled_checkbox ) then
      output = '[ Resolver.lua ] missed ' .. entity.get_player_name( event.target ) .. ' | reason: ' .. event.reason .. ' | target hitgroup: '.. hitgroup_names[ event.hitgroup + 1 ] .. ' | hitchance: ' .. event.hit_chance
  
      -- so we can tell what it is without reading it
      if event.reason == 'spread' then
        color_log( 255, 120, 0, output)
      elseif event.reason == 'resolver' then
        color_log( 255, 0, 0, output)
      else
        color_log( 255, 255, 255, output)
      end
    end
end

client.set_event_callback( "aim_miss", on_aim_missed )

local function on_aim_hit( event )
  if ui.get( logging_enabled_checkbox ) then
    output = '[ Resolver.lua ] hit ' .. entity.get_player_name( event.target ) .. ' for ' .. event.damage .. ' | ' .. entity.get_prop( event.target, 'm_iHealth' ) .. ' health left' .. ' | hitgroup: ' .. hitgroup_names[ event.hitgroup + 1 ] .. ' | hitchance: ' .. event.hit_chance
    color_log( 0, 255, 0, output )
  end
end

client.set_event_callback( "aim_hit", on_aim_hit )
