## Plugin Name: Styledoc.nvim

styledoc.nvim is an exquisite Markdown editing and preview plugin tailored for Neovim. This plugin offers a real-time editing and preview experience akin to the robust capabilities of Emacs Org mode. Crafted using pure Lua and leveraging the parsing prowess of Treesitter, NeoMarkPreview brings an unprecedented level of fluidity and efficiency to Markdown document editing.

![image](https://private-user-images.githubusercontent.com/57088952/331565788-a53c5ed5-7334-4b1c-919c-81353bd4ef1e.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjEzODI1MDYsIm5iZiI6MTcyMTM4MjIwNiwicGF0aCI6Ii81NzA4ODk1Mi8zMzE1NjU3ODgtYTUzYzVlZDUtNzMzNC00YjFjLTkxOWMtODEzNTNiZDRlZjFlLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA3MTklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNzE5VDA5NDMyNlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTIzMWMyMjMzNDY0NWJkMDVlZmNjYTc3MjFjZTBmYzNlNjQyNWE5MjUzMGUxYjAwNTUxNWE1NTg1MzAzNGI4ODcmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.YNugy99PQItFTG-Kg5IJKzc6muCSrOW2IoSmacv9Ih4)



---

### Core Features:

- [x] Real-Time Preview: Changes you make are reflected in real-time in the preview window, offering a clear view of your document’s content.
- [x] Fragmented Updating: With intelligent differential updating technology, only the altered parts of the document are refreshed, ensuring high editing efficiency and minimal system load.
- [ ] Interactive Diagrams and Flowchart Preview: Supports common diagram and flowchart editing with real-time preview, greatly enhancing workflow visualization.
- [ ] Math Symbols Support: Features real-time preview for mathematical symbols, making mathematical notation editing easy and precise.
- [x] Table Formatting Support: Quickly organize and beautify Markdown tables for both aesthetics and readability.

---

### Installation Guide:

1. Ensure you have the latest version of Neovim installed.
2. Install using your preferred plugin manager, such as packer.nvim or vim-plug.
   For packer.nvim users:

```lua
{
 "denstiny/styledoc.nvim",
 dependencies = {
  "nvim-treesitter/nvim-treesitter",
  "vhyrro/luarocks.nvim",
  "3rd/image.nvim",
 },
 opts = true,
 ft = "markdown",
}
```
   
3. After installation, you might need to run :TSUpdate to ensure Treesitter is up to date with the latest grammar files.


---
### Advanced Configuration:
```lua
{  
 ui = {  
   block = {enable = true,symbol =  "█"},
   list = {
    enable = true,
    syymbol = {
     list_minus = "",
     task_undo = " 󰄱 ",
     task_do = "  "
    }
   },
   title = {
    enable = true,
    symbol = {
     h1 = "○",
     h2 = " ○ ",
     h3 = "  ○ ",
     h4 = "   ○ ",
     h5 = "    ○ ",
     h6 = "     ○ ",
     h7 = "      ○ ",
   }
  },
  table = {
   enable = true,
   symbol = {
    leftalign = "󰘟",
    rightalign = "󰘠",
    line = "│"
   }
  },
  breakline = {  
   enable = true,  
   symbol = function(bufnr)  
    local winid = vim.fn.bufwinid(bufnr)  
    local width = vim.fn.winwidth(winid)  
    local str = string.rep("-", width)  
    return str  
    end,  
  },  
  codeblock = {  
   symbol = {  
   start = function(bufnr, lang)
    local winid = vim.fn.bufwinid(bufnr)
    local width = vim.fn.winwidth(winid)  
    local spe = string.rep("─", width / 2 - string.len(lang) / 2 - 6)  
    local str = "╭" .. spe .. string.format(" %s ", lang) .. spe .. "╮"  
    return str  
   end,  
   end_ = function(bufnr)  
    local winid = vim.fn.bufwinid(bufnr)  
    local width = vim.fn.winwidth(winid)  
    local spe = string.rep("─", math.ceil(width / 2) - 5)  
    local str = "╰" .. spe .. spe .. "╯"  
    return str  
   end,   
   }  
  }  
 }  
}  
```

---
### User Feedback:

We welcome feedback and suggestions! Please submit issues or pull requests in our GitHub repository so we can continually improve and provide a superior plugin experience.
