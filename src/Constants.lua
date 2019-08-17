WINDOW_WIDTH, WINDOW_HEIGHT = 500, 500

math.randomseed(os.time())

gFonts = {
    small = love.graphics.newFont(12),
    medium = love.graphics.newFont(20),
    large = love.graphics.newFont(30)
}

gTextures = {
    buttons = {
        go = {
            selected = love.graphics.newImage("assets/buttons/go selected.png"),
            deselected = love.graphics.newImage("assets/buttons/go deselected.png")
        },
        quit = {
            selected = love.graphics.newImage("assets/buttons/quit selected.png"),
            deselected = love.graphics.newImage("assets/buttons/quit deselected.png")
        }
    },
    ["title-screen"] = love.graphics.newImage("assets/title screen.png")
}
