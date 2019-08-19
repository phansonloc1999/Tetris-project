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
            selected = love.graphics.newImage("assets/buttons/title screen/go selected.png"),
            deselected = love.graphics.newImage("assets/buttons/title screen/go deselected.png")
        },
        quit = {
            selected = love.graphics.newImage("assets/buttons/title screen/quit selected.png"),
            deselected = love.graphics.newImage("assets/buttons/title screen/quit deselected.png")
        },
        start = {
            selected = love.graphics.newImage("assets/buttons/start selected.png"),
            deselected = love.graphics.newImage("assets/buttons/start deselected.png")
        },
        about = {
            selected = love.graphics.newImage("assets/buttons/about selected.png"),
            deselected = love.graphics.newImage("assets/buttons/about deselected.png")
        },
        option = {
            selected = love.graphics.newImage("assets/buttons/option selected.png"),
            deselected = love.graphics.newImage("assets/buttons/option deselected.png")
        },
        menu_quit = {
            selected = love.graphics.newImage("assets/buttons/quit selected.png"),
            deselected = love.graphics.newImage("assets/buttons/quit deselected.png")
        },
        oneplayer = {
            deselected = love.graphics.newImage("assets/buttons/1 player deselected.png"),
            selected = love.graphics.newImage("assets/buttons/1 player selected.png")
        },
        twoplayer = {
            deselected = love.graphics.newImage("assets/buttons/2 players deselected.png"),
            selected = love.graphics.newImage("assets/buttons/2 players selected.png")
        },
        back = {
            deselected = love.graphics.newImage("assets/buttons/back deselected.png"),
            selected = love.graphics.newImage("assets/buttons/back selected.png")
        }
    },
    titles = {
        menu = love.graphics.newImage("assets/titles/menu.png"),
        mode = love.graphics.newImage("assets/titles/game mode.png")
    },
    pet_emotes = {
        pet1 = {
            selected = love.graphics.newImage("assets/menu/pet 1 selected.png"),
            deselected = love.graphics.newImage("assets/menu/pet 1 deselected.png")
        },
        pet2 = {
            selected = love.graphics.newImage("assets/menu/pet 2 selected.png"),
            deselected = love.graphics.newImage("assets/menu/pet 2 deselected.png")
        }
    },
    mode_emotes = {
        oneplayer = {
            deselected = love.graphics.newImage("assets/select mode/1 player deselected.png"),
            selected = love.graphics.newImage("assets/select mode/1 player selected.png")
        },
        twoplayer = {
            deselected = love.graphics.newImage("assets/select mode/2 players deselected.png"),
            selected = love.graphics.newImage("assets/select mode/2 players selected.png")
        }
    },
    ["background"] = love.graphics.newImage("assets/background.png"),
    ["title-screen"] = love.graphics.newImage("assets/title screen.png")
}

TITLE_TOP_SPACING = 20
