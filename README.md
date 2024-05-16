了解您的需求后，我对介绍文档进行了更新，增加了对表格格式化支持的描述：

---

## 插件名称: NeoMarkPreview (请替换为您的插件实际名称)

NeoMarkPreview 是一款专为 Neovim 开发的 Markdown 插件，其设计理念在于提高文档编辑效率及实现实时预览功能。模仿 Emacs Org mode 的可靠体验，在纯 Lua 环境下使用 Treesitter 进行语法解析，插件保证了快速且仅限必要的文档更新，从而最大化了刷新效率。

### 特色功能：

- 实时预览：编辑 Markdown 同时即时查看内容变化，保持内容及格式同步更新。
- 碎片化更新技术：差异化更新实现最小化刷新，提升编辑效率，降低资源消耗。
- 图表与流程图实时预览：编辑流程图或UML图时，立即看到图形化结果。
- 数学公式实时预览：MathJax 集成让数学表达式的输入和预览变得直观。
- 代码块及语法高亮优化：优化代码编辑体验，支持多种编程语言的语法高亮。
- 表格格式化支持：快速整理和美化 Markdown 表格，使其既美观又易于阅读。
  
### 安装步骤：

1. 确保已安装最新版 Neovim。
2. 利用您的插件管理器进行安装，例如 packer.nvim 或 vim-plug。
   
   示例使用 packer.nvim：
      use {
       '你的github用户名/neo-mark-preview',
       requires = {
           {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
       }
   }
   
3. 安装后，请确保执行 :TSUpdate 获取最新 Treesitter 语法文件。

### 快速上手：

1. 打开 Markdown 文件。
2. 执行 :NeoMarkPreview 激活实时预览。
3. 尽情编辑，并观察窗口内预览实时更新。

### 配置选项：

NeoMarkPreview 提供了灵活的配置选项，可以定制用户体验。详细配置方法请查阅 :help neo-mark-preview。

### 用户支持：

欢迎您通过 GitHub 仓库提出问题或建议，帮助我们改进该插件。我们珍视每一位用户的反馈并致力于不断优化和完善我们的工具。

---

请根据您插件的特定功能和给出的命令进行任何必要的修改，希望这个文档能够满足您的需求！
