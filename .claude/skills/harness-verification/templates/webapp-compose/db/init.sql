-- 動作確認用 sandbox の初期スキーマ + シードデータ。
-- コンテナ初回起動時に postgres が自動実行する。

CREATE TABLE IF NOT EXISTS tasks (
  id         SERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  priority   TEXT NOT NULL CHECK (priority IN ('high', 'mid', 'low')),
  done       BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO tasks (title, priority, done) VALUES
  ('請求書を送付する',        'high', false),
  ('議事録をまとめる',        'mid',  false),
  ('備品を発注する',          'low',  false),
  ('契約書をレビューする',    'high', true),
  ('社内アンケートに回答する','low',  true);
