require("src/Dependencies")

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

    gStateMachine =
        StateMachine {
        ["play"] = function()
            return PlayState()
        end,
        ["menu"] = function()
            return MenuState()
        end
    }
    gStateMachine:change("menu")

    gGamePaused = false
end

function love.draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, WINDOW_HEIGHT - 15)
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
