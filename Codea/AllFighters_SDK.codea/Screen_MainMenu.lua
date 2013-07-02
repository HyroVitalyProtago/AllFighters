Screen_MainMenu = class(Screen)

function Screen_MainMenu:init()
    Screen.init(self, "MainMenu")
    
    self.currentIndex = 1
    self.nbFighters = 0
    self.showMakeFighter = false
    self:loadFighters()
    
    ------------------------------- Background -----------------------------
    ToolScreen.makeCustomBackground(self)
    ----------------------------------------------------------------------
    
    ------------------------------- Menu top -----------------------------
    ToolScreen.makeMenuTop(self)
    ToolScreen.makeCurrentLocation(self, "AllFighters - Source Development Kit")
    ToolScreen.makeInfos(self)
    -- Previous Location(s) || Exit
    ----------------------------------------------------------------------
    
    self.fighters = {}
    ------------------------------- Fighters -----------------------------
    local spr = image(200, 200)
    setContext(spr)
        local _img = readImage("Dropbox:SpriteAllFighters/SDK/tile")
        tint(0, 0, 0, 235)
        sprite(_img, spr.width/2, spr.height/2, _img.width*1, _img.height*1)
        noTint()
        local _img = readImage("Dropbox:SpriteAllFighters/SDK/add")
        tint(255,255,0,255)
        sprite(_img, spr.width/2, spr.height/2, _img.width*0.5, _img.height*0.5)
    setContext()
    
    for i = 1, self.nbFighters + 1 do
        self.fighters[i] = Mesh.makeMesh(spr, {})
        self.fighters[i].pos.x = 250/2 + 50 + ((i-1)%4)*225 + math.floor((i-1)/12)*WIDTH
        self.fighters[i].pos.y = HEIGHT - 60 - (250/2) - (math.ceil(i/4)-1)*225 + math.floor((i-1)/12)*(HEIGHT-90)
        self.fighters[i].pos.z = 5
        table.insert(self.meshes, self.fighters[i])
        
        -- To Optimize
        spr = image(200, 200)
        setContext(spr)
            local _img = readImage("Dropbox:SpriteAllFighters/SDK/tile")
            tint(math.random(255), math.random(255), math.random(255), 235)
            sprite(_img, spr.width/2, spr.height/2, _img.width*1, _img.height*1)
            
            noTint()
            -- self.listOfFighters[i]["directory"]
            -- self.listOfFighters[i]["nbImg"]
            local _img = readImage("Dropbox:SpriteAllFighters/TakeshiYamamoto/SDK/5")
            sprite(_img, spr.width/2, spr.height/2, _img.width*0.9, _img.height*0.9)
            
            local _img = readImage("Dropbox:SpriteAllFighters/SDK/shadow")
            sprite(_img, spr.width/2, 30, _img.width, _img.height)
            sprite(_img, spr.width/2, 30, _img.width, _img.height)
            
            fill(255, 255, 255)
            fontSize(18)
            -- self.listOfFighters[i]["name"]
            local _txt = "Takeshi Yamamoto"
            text(_txt, spr.width/2 - textSize(_txt)/2, 15)
        setContext()
        
    end
    ----------------------------------------------------------------------
    
    ------------------------------- Previous -----------------------------
    ToolScreen.makePrevious(self)
    ----------------------------------------------------------------------
    
    ------------------------------- Next -----------------------------
    ToolScreen.makeNext(self)
    ----------------------------------------------------------------------
    
    --self.backgroundColor = color(39, 39, 39)
end

function Screen_MainMenu:start()
    --[[
    self.x = 0
    self.y = 0
    self.z = -900
    self.eyeX = WIDTH/2
    self.eyeY = HEIGHT/2
    self.eyeZ = 150
    self.lookAtX = WIDTH/2
    self.lookAtY = HEIGHT/2
    self.lookAtZ = 0
    self.angle = {}
    self.angle.x = 0
    self.angle.y = 0
    self.angle.z = 0
    self.fieldOfView = 40
    ]]--
    --[[
    tween(1, self, {lookAtX = WIDTH/2 - 50}, tween.easing.quartInOut, function()
        tween(1, self, {lookAtX = WIDTH/2 + 50}, tween.easing.quartInOut, function()
            tween(1, self, {lookAtX = WIDTH/2}, tween.easing.quartInOut)
        end)
    end)
    ]]--
    if self.currentIndex*12 < self.nbFighters then
        tween(1, self.next.pos, {z = 15}, tween.easing.quartInOut)
    end
end

function Screen_MainMenu:previousFighters()
    if self.currentIndex == 1 then return end
    self.currentIndex = self.currentIndex - 1
    self.next.pos.z = 15
    if self.currentIndex == 1 then
        self.previous.pos.z = -5
    end
    for i, fighter in ipairs(self.fighters) do
        local x = fighter.pos.x
        tween(3, fighter.pos, {x = x + WIDTH}, tween.easing.quadInOut)
    end
end

function Screen_MainMenu:nextFighters()
    if self.currentIndex*12 >= self.nbFighters then return end
    self.currentIndex = self.currentIndex + 1
    self.previous.pos.z = 15
    if self.currentIndex*12 >= self.nbFighters then
        self.next.pos.z = -5
    end
    for i, fighter in ipairs(self.fighters) do
        local x = fighter.pos.x
        tween(3, fighter.pos, {x = x - WIDTH}, tween.easing.quadInOut)
    end
end

function Screen_MainMenu:loadFighters()
    self.listOfFighters = {"Takeshi_Yamamoto"}
    self.nbFighters = 20 --#self.listOfFighters
    local location = os.getenv("HOME").."/Documents/Dropbox.spritepack/SpriteAllFighters/fighters.xml"
    --local xml = XML(XML.fileToString(location))
    --print(xml)
end

function Screen_MainMenu:toggleInfos()
    alert('toggleInfos')
end

function Screen_MainMenu:makeFighter()
    alert("Make Fighter")
end

function Screen_MainMenu:modifyFighter()
    --alert("Modify Fighter")
    setCurrentState(MiniatureToRight(self, Screen_Fighter()))
end

function Screen_MainMenu:touched(touch)
    if touch.state == BEGAN then -- ENDED
        Screen.touched(self, touch)
        
        if (self.infos:isTouched(touch, {left=25, right=25, bottom=25, top=25})) then
            self:toggleInfos()
        end
        ----[[
        if (self.previous:isTouched(touch, {left=25, right=25, bottom=25, top=25})) then
            self:previousFighters()
        end
        if (self.next:isTouched(touch, {left=25, right=25, bottom=25, top=25})) then
            self:nextFighters()
        end
        --]]--
        
        for i,fighter in ipairs(self.fighters) do
            if (self.fighters[i]:isTouched(touch)) then
                if (i == 1) then -- make new Fighter
                    self:makeFighter()
                else -- modif Fighter
                    self:modifyFighter()
                end
            end
        end
    end
end