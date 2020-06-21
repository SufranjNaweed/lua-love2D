-- framework function
function love.load()
  sprites = {}
  sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.bullet = love.graphics.newImage('sprites/bullet.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')
  sprites.background = love.graphics.newImage('sprites/background.png')

  -- Game state [1 -> menu, 2 -> gameplay]
  game = {}
  game.windowTitle = "Zombie Shooter"
  game.font = love.graphics.newFont(28)
  game.state = 1
  game.pointPerKill = 20
  game.score = 0
  game.maxTime = 2
  game.timer = game.maxTime
  game.screenWidth = love.graphics.getWidth()
  game.screenHeight = love.graphics.getHeight()

  player = {}
  player.x =  love.graphics.getWidth() / 2
  player.y = love.graphics.getHeight() / 2
  player.centerX = sprites.player:getWidth() / 2
  player.centerY = sprites.player:getHeight() / 2
  player.speed = 180
  player.rotation = 0

  zombies = {}
  bullets = {}

  love.window.setTitle(game.windowTitle)
end

function love.update(dt)
  -- menu
  if game.state == 1 then
  end

  -- if the gameplay start
  if game.state == 2 then
    -- Moving character
    if(love.keyboard.isDown("s") and player.y < game.screenHeight) then
      player.y = player.y + player.speed * dt
    end
    if(love.keyboard.isDown("z") and player.y > 0) then
      player.y = player.y - player.speed * dt
    end
    if(love.keyboard.isDown("q") and player.x > 0) then
      player.x = player.x - player.speed * dt
    end
    if(love.keyboard.isDown("d") and player.x < game.screenWidth) then
      player.x = player.x + player.speed * dt
    end

    -- rotation character
    player.rotation = player_mouse_angle()

    -- rotation zombie & colision between a zombie & the player
    for i, zombie in ipairs(zombies)do
      zombie.x = zombie.x + math.cos(zombie_player_angle(zombie)) * zombie.speed * dt
      zombie.y = zombie.y + math.sin(zombie_player_angle(zombie)) * zombie.speed * dt
      -- check colision between a zombie & the player
      if (distanceBeetween(zombie.x, zombie.y, player.x, player.y) < 30) then
        -- destroy all zombies
       for i, z in ipairs(zombies) do
         zombies[i] = nil
       end
        -- back to menu
        game.state = 1
        resetGame();
      end
    end

    -- set bullet direction & speed
    for i,bullet in ipairs(bullets) do
      bullet.x =  bullet.x + math.cos(bullet.direction) * bullet.speed * dt
      bullet.y =  bullet.y + math.sin(bullet.direction) * bullet.speed * dt
    end

    -- clean unused bullets (offscreen bullets)
    for i=#bullets, 1, -1 do
      local b = bullets[i]
      if (b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight()) then
        table.remove(bullets, i)
      end
    end

    -- collision between a bullet & a zombie
    for i, z in ipairs(zombies) do
      for j, b in pairs(bullets) do
        if (distanceBeetween(z.x, z.y, b.x, b.y) < 20) then
          z.dead = true
          b.dead = true
          game.score = game.score + game.pointPerKill
        end
      end
    end

    -- cleaning dead zombies
    for i=#zombies, 1, -1 do
      local z = zombies[i]
      if (z.dead == true) then
        table.remove(zombies, i)
      end
    end

    -- cleaning collided bullets
    for i=#bullets, 1, -1 do
      local b = bullets[i]
      if (b.dead == true) then
        table.remove(bullets, i)
      end
    end

    -- spawn zombie overtime
    if (game.state == 2) then
      game.timer = game.timer - dt
      if game.timer <= 0 then
        spawnZombie()
        game.maxTime = game.maxTime * 0.95
        game.timer = game.maxTime
      end
    end
  end
end

function love.draw()
  love.graphics.setFont(game.font)
  -- if menu draw menu
  if game.state == 1 then
    -- love.graphics.printf( text, x, y, limit, align)
    love.graphics.printf('Zombie Shooter', 0,  game.screenWidth / 4, game.screenWidth, "center")
    love.graphics.printf('use ZQSD to move and mouse to aim & shoot', 0, (game.screenWidth / 4) + 100, game.screenWidth, "center")
    love.graphics.printf('click any where to start', 0, (game.screenWidth / 2), game.screenWidth, "center")
  end

  -- if the gameplay start draw  game
  if game.state == 2 then
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y, player.rotation, nil, nil, player.centerX, player.centerY)

    for i,zombie in ipairs(zombies) do
       love.graphics.draw(sprites.zombie, zombie.x, zombie.y, zombie_player_angle(zombie), nil, nil, zombie.centerX, zombie.centerY)
    end

    for i,bullet in ipairs(bullets) do
      love.graphics.draw(sprites.bullet, bullet.x, bullet.y, bullet.direction, 0.5, 0.5, bullet.centerX, bullet.centerY)
    end

    -- draw game ui
    love.graphics.printf("Score : " ..  game.score, 0, 50, game.screenWidth, "center")
  end
end

function love.keypressed(key, scancode, isrepeat)
  --[[
  if (key == "space") then
    spawnZombie();
  end
  ]]
end

function love.mousepressed(x, y, mouseButton, isTouch)
  -- click to start the game
  if (game.state == 1) then
    if (mouseButton == 1)then
      game.state = 2
      resetGame()
    end
  end
  if (game.state == 2) then
    if mouseButton == 1 then
      spawnBullet()
    end
  end
end

-- other function
function distanceBeetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 +  (x2 - x1)^2)
end

function resetGame()
  game.score = 0
  game.maxTime = 2
  game.timer = game.maxTime
  player.x = game.screenWidth / 2
  player.y = game.screenHeight / 2
end

function player_mouse_angle()
  return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function zombie_player_angle(enemy)
  return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
  zombie = {}
  zombie.x = 0
  zombie.y = 0
  zombie.centerX = sprites.zombie:getWidth() / 2
  zombie.centerY = sprites.zombie:getHeight() / 2
  zombie.speed = 100
  zombie.dead = false

  local side = math.random(1, 4)
  if side == 1 then
    zombie.x = -30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 2 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = -30
  elseif side == 3 then
    zombie.x = love.graphics.getWidth() + 30
    zombie.y =  math.random(0, love.graphics.getHeight())
  elseif side == 4 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight() + 30
  end

  table.insert(zombies, zombie)
end

function spawnBullet()
  bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.centerX = sprites.bullet:getWidth() / 2
  bullet.centerY = sprites.bullet:getHeight() / 2
  bullet.speed = 500
  bullet.direction = player.rotation
  bullet.dead = false

  table.insert(bullets, bullet)
end
