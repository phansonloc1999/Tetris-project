require("src/Dependencies")

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

    gStateMachine =
        StateMachine {
        ["title-screen"] = function()
            return TitleScreenState()
        end,
        ["menu"] = function()
            return MenuState()
        end,
        ["select-mode"] = function()
            return SelectModeState()
        end,
        ["play"] = function()
            return PlayState()
        end
    }
    gStateMachine:change("title-screen")

    gGamePaused = false
 
    gFPSCounter = love.graphics.newText(gFonts.small)
end

function love.draw()
    love.graphics.setColor(0, 1, 0)
    gFPSCounter:set("FPS: "..love.timer.getFPS())
    love.graphics.draw(gFPSCounter, 0, WINDOW_HEIGHT - gFPSCounter:getHeight())
    love.graphics.setColor(1, 1, 1)
    
    gStateMachine:render()
end

function love.update(dt)
    require("lib/lovebird").update()

    if (not gGamePaused) then
        Timer.update(dt)

        gStateMachine:update(dt)
    end

    if (love.keyboard.wasPressed("p")) then
        gGamePaused = not gGamePaused
    end

    -- Reset input
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end
