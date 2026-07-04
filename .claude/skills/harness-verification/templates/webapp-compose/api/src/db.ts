import pg from "pg";

/**
 * DATABASE_URL に接続する共有の接続プール。
 * 永続化 (repositories 層) はこの pool 経由で DB を触る。
 */
export const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
});
