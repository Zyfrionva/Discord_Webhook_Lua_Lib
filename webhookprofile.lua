repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local http = (syn and syn.request) or (http and http.request) or http_request or request
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local webhook = getgenv().webhook or ""

local PlayerGui = player:WaitForChild("PlayerGui")
local Interface = PlayerGui:WaitForChild("Interface")

-- Tabela das cores de raridade (BackgroundColor3)
local rarityColors = {
	["125,255,105"] = "🟢 Uncommon",
	["104,143,255"] = "🔵 Rare",
	["193,123,250"] = "🟣 Epic",
	["246,193,66"]  = "🟡 Legendary",
	["246,66,66"]     = "🔴 Mythical"
}

-- Tabela de Prestige por Image ID
local prestigeIcons = {
	["rbxassetid://15912127501"] = "PRESTIGE I",
	["rbxassetid://15912227453"] = "PRESTIGE II",
	["rbxassetid://15912229007"] = "PRESTIGE III"
}

-- Função para obter raridade via cor BackgroundColor3
local function getRarityFromColor(color)
	local key = string.format("%d,%d,%d", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
	return rarityColors[key] or "⚪ Unknown"
end

-- Função para extrair nome da família via Username.Text
local function getFamilyName()
	local char = workspace:FindFirstChild("Characters")
	if char then
		local playerChar = char:FindFirstChild(player.Name)
		if playerChar then
			local overhead = playerChar:FindFirstChild("Head") and playerChar.Head:FindFirstChild("Overhead")
			if overhead then
				local usernameText = overhead:FindFirstChild("Username")
				if usernameText and usernameText:IsA("TextLabel") then
					local fullText = usernameText.Text or ""
					local splitName = string.split(fullText, " ")
					if #splitName >= 2 then
						return splitName[2]
					end
				end
			end
		end
	end

	local fallbackChar = workspace:FindFirstChild(player.Name)
	if fallbackChar then
		local overhead = fallbackChar:FindFirstChild("Head") and fallbackChar.Head:FindFirstChild("Overhead")
		if overhead then
			local usernameText = overhead:FindFirstChild("Username")
			if usernameText and usernameText:IsA("TextLabel") then
				local fullText = usernameText.Text or ""
				local splitName = string.split(fullText, " ")
				if #splitName >= 2 then
					return splitName[2]
				end
			end
		end
	end

	return "Unknown"
end

-- Função para extrair os itens do inventário com raridade e quantidade
local function getInventoryItems()
	local itemsFolder = PlayerGui:FindFirstChild("Interface")
		and PlayerGui.Interface:FindFirstChild("Inventory")
		and PlayerGui.Interface.Inventory:FindFirstChild("Main")
		and PlayerGui.Interface.Inventory.Main:FindFirstChild("Holder")
		and PlayerGui.Interface.Inventory.Main.Holder:FindFirstChild("Items")

	if not itemsFolder then
		return "N/A"
	end

	local inventoryText = ""
	for _, itemFrame in pairs(itemsFolder:GetChildren()) do
		if itemFrame:IsA("Frame") then
			local itemNameFull = itemFrame.Name or ""
			local _, _, itemName = string.find(itemNameFull, "%d+%s*%-?%s*(.+)")
			itemName = itemName or itemNameFull

			local quantityText = "N/A"
			local mainInnerQuantity = itemFrame:FindFirstChild("Main")
				and itemFrame.Main:FindFirstChild("Inner")
				and itemFrame.Main.Inner:FindFirstChild("Quantity")
			if mainInnerQuantity and mainInnerQuantity:IsA("TextLabel") then
				quantityText = mainInnerQuantity.Text or "N/A"
			end

			local rarityText = "⚪ Unknown"
			local rarityObject = itemFrame:FindFirstChild("Main")
				and itemFrame.Main:FindFirstChild("Inner")
				and itemFrame.Main.Inner:FindFirstChild("Rarity")
			if rarityObject and rarityObject:IsA("Frame") then
				rarityText = getRarityFromColor(rarityObject.BackgroundColor3)
			end

			inventoryText ..= string.format("`%s | Rarity: %s | Quantity: %s`\n", itemName, rarityText, quantityText)
		end
	end

	return inventoryText ~= "" and inventoryText or "N/A"
end

-- Função para obter Prestige via imagem
local function getPrestigeTitle()
	local success, rankIcon = pcall(function()
		return Interface
			:WaitForChild("Gear_Up")
			:WaitForChild("Playerlist")
			:WaitForChild("Local")
			:WaitForChild("Side")
			:WaitForChild("Prestige")
			:WaitForChild("Rank")
	end)

	if success and rankIcon and rankIcon:IsA("ImageLabel") then
		local imageId = rankIcon.Image
		return prestigeIcons[imageId] or nil
	end
	return nil
end

-- Enviar estatísticas
local function sendPlayerStats()
	local success, result = pcall(function()
		local currencies = Interface:WaitForChild("Topbar"):WaitForChild("Main"):WaitForChild("Currencies")
		local gold = currencies:WaitForChild("Gold"):WaitForChild("Amount").Text
		local gems = currencies:WaitForChild("Gems"):WaitForChild("Amount").Text
		local spins = currencies:WaitForChild("Spins"):WaitForChild("Amount").Text

		local levelText = Interface:WaitForChild("Gear_Up"):WaitForChild("HUD"):WaitForChild("Level"):WaitForChild("Title").Text
		local prestigeText = getPrestigeTitle()

		local levelFinal = prestigeText and (levelText .. " | " .. prestigeText) or levelText

		return {
			Gold = gold,
			Gems = gems,
			Spins = spins,
			Level = levelFinal
		}
	end)

	if not success then
		warn("Erro stats:", result)
		return
	end

	local stats = result
	local family = getFamilyName()
	local inventoryItems = getInventoryItems()

	local embed = {
		title = "📊 PLAYER STATUS - DETAILS",
		color = 3447003,
		fields = {
			{ name = "🤖 User", value = "```".. player.name .."```", inline = true },
			{ name = "💰 Gold", value = "```".. stats.Gold .."```", inline = true },
			{ name = "💎 Gems", value = "```".. stats.Gems .."```", inline = true },
			{ name = "🎡 Spins", value = "```".. stats.Spins .."```", inline = true },
			{ name = "📈 Level", value = "```".. stats.Level .."```", inline = true },
			{ name = "🏠 Family", value = "```".. family .."```", inline = false },
			{ name = "🎒 Inventory", value = inventoryItems, inline = false }
		},
		footer = {
			text = "AOT:R TRACKER",
			icon_url = "https://cdn-icons-png.flaticon.com/512/190/190411.png"
		}
	}

	local data = {
		username = "User Stats",
		embeds = { embed }
	}

	local successSend, err = pcall(function()
		http({
			Url = webhook,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(data)
		})
	end)

	if not successSend then
		warn("Error webhook stats:", err)
	else
		print("Webhook sent!")
	end
end

-- Execução principal
sendPlayerStats()
:", err)
	else
		print("Webhook sent!")
	end
end

-- Execução principal
sendPlayerStats()
