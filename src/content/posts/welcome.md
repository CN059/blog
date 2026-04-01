---
# Frontmatter 区域
# 这是 YAML 格式的元数据，位于文件顶部，由三个连字符包围
# 这些数据会在 content.config.ts 中定义的 schema 进行验证

title: 欢迎来到我的博客 # 文章标题（必填）
date: 2026-03-31 # 发布日期（必填，会被转换为 Date 对象）
description: 这是第一篇示例文章 # 文章描述（可选）
---

# 欢迎来到我的博客

这是一个简单的博客示例。

## 开始写作

你可以在这里使用 Markdown 语法来撰写你的文章。

```rust
fn main(){
    prinln!("Hello World!");
}
```

<!--
Markdown 文件说明：
- 文件位置：src/content/posts/ 目录下
- 文件格式：.md 或 .mdx
- 文件名会作为 URL 的一部分（例如：welcome.md → /posts/welcome）

支持的 Markdown 语法：
- 标题：# ## ### 等
- 列表：- * 1. 等
- 链接：[文本](URL)
- 图片：![alt](图片URL)
- 代码：`code` 或 ```代码块```
- 引用：> 引用文本
- 粗体：**文本**
- 斜体：*文本*
-->
