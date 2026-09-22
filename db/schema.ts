import { sqliteTable, text, integer, index } from 'drizzle-orm/sqlite-core';
export const comments = sqliteTable('comments', {
  id: text('id').primaryKey(),
  name: text('name').notNull(),
  body: text('body').notNull(),
  lecture: integer('lecture'),
  createdAt: integer('created_at').notNull(),
  deleteHash: text('delete_hash').notNull(),
  visitorHash: text('visitor_hash').notNull(),
}, table => [index('comments_created_idx').on(table.createdAt), index('comments_visitor_idx').on(table.visitorHash, table.createdAt)]);
