/**
 * Astro 内容集合配置文件
 *
 * 内容集合（Content Collections）是 Astro 的核心特性之一，
 * 用于组织和管理结构化内容（如博客文章、产品信息等）。
 *
 * 这个文件定义了博客文章的"posts"集合：
 * - 如何加载文章文件
 * - 文章的 frontmatter 数据结构（schema）
 */

import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

/**
 * 定义 posts 内容集合
 *
 * loader: 使用 glob 模式从指定目录加载所有 .md 文件
 * schema: 使用 Zod 定义文章 frontmatter 的数据结构和验证规则
 */
const posts = defineCollection({
  // glob loader: 从 ./src/content/posts 目录加载所有 markdown 文件
  loader: glob({ pattern: '**/*.md', base: './src/content/posts' }),

  // Zod schema: 定义文章 frontmatter 必须包含的字段
  schema: z.object({
    title: z.string(),              // 文章标题（必填，字符串类型）
    date: z.coerce.date(),          // 发布日期（必填，自动将字符串转为 Date 对象）
    description: z.string().optional(), // 文章描述（可选）
  }),
});

// 导出集合配置，Astro 会自动识别
export const collections = { posts };