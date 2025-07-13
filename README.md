# 🌐 Luau Webhook Library for Roblox Exploits

A lightweight Luau library for sending Discord webhooks directly from Roblox using supported exploits. Easily create rich embeds and send them with minimal code.

---

## 📦 Installation

```lua
local WebhookLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR-USERNAME/webhook-lib/main/main.lua"))()
```

> Replace `YOUR-USERNAME` with your actual GitHub username or repo owner.

---

## 🚀 Example Usage

```lua
-- 📦 Install the library
local WebhookLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR-USERNAME/webhook-lib/main/main.lua"))()

-- 🛠️ Create an embed with title and description
local embed = WebhookLib.Create_Embed_Data("🔔 New Event", "A player has joined the game!")

-- ➕ Add fields to the embed
embed:add_field("👤 Player", game.Players.LocalPlayer.Name, true)
embed:add_field("🕒 Time", os.date("%d/%m/%Y %H:%M:%S"), true)

-- 🖼️ Add image, footer, and author
embed:set_thumbnail("https://i.imgur.com/xyz1234.png")
embed:set_footer("Monitoring System", "https://i.imgur.com/icon.png")
embed:set_author("Log Bot", "https://discord.com", "https://i.imgur.com/bot-icon.png")

-- 📤 Send the webhook with the embed
WebhookLib.Send_New_Webhook("YOUR_WEBHOOK_URL_HERE", "📢 Automatic Notification:", {embed})
```

---

## 📘 API Documentation

### 🔧 `Create_Embed_Data(title: string, description: string)`

Creates a Discord embed object.

**Returns:** A table with additional methods to customize the embed.

#### Embed Methods:
```lua
embed:add_field(name: string, value: string, inline: boolean?)
embed:set_thumbnail(url: string)
embed:set_footer(text: string, icon_url: string?)
embed:set_image(url: string)
embed:set_author(name: string, url: string?, icon_url: string?)
```

---

### 📤 `Send_New_Webhook(url: string, content: string, embeds: table?)`

Sends a Discord webhook.

- `url` *(string)*: Webhook URL
- `content` *(string)*: Message content (outside the embed)
- `embeds` *(table?)*: A list of embed tables created with `Create_Embed_Data`

---

## ✅ Exploit Compatibility

This library works with popular Roblox exploits that support HTTP requests:

- `http_request`
- `request`
- `syn.request`
- `HttpPost`

> ❌ If your executor doesn't support HTTP requests, an error message will be printed with suggestions.

---

## 💡 Tips

- Use with Roblox events like `PlayerAdded`, `Touched`, or `Chatted` to build live logging tools.
- Embed multiple fields for structured and styled output.
- Send multiple embeds in a single webhook by passing an array to `Send_New_Webhook`.

---

## 📂 Library Structure

```lua
return {
    Create_Embed_Data = function,
    Send_New_Webhook = function
}
```

---

## 📄 License

See LICENSE file. This is private software. Unauthorized use or redistribution is strictly prohibited.
