# resonite-creative-skills

種類: `generic`

開発は [usaturn/agent-workspace](https://github.com/usaturn/agent-workspace) の登録プロジェクトとして行います。

検証入口: `./scripts/verify.sh`

## 内容

Resonite のワールド・アイテムの制作で使う、Blender・制作系のエージェント用スキルを置くリポジトリです。

| スキル | 内容 |
|---|---|
| `blender-modeler` | Blender での汎用のメッシュモデリング。blockout、モディファイアの構成、整理、寸法・原点の決め方 |

移行元: [usaturn/create-reso-world](https://github.com/usaturn/create-reso-world) の commit `e347ac69238ebc563b1e4d31331037d7899cb01f` の `.agents/skills/`。残りのスキルは、このリポジトリの Issue で移します。

## 構成

```text
.agents/skills/blender-modeler/SKILL.md                   # 実体（create-reso-world から無改変で写した）
.agents/skills/references/modular-environment-design.md  # 共有の参照文書
.agents/skills/references/blender-skills-LICENSE.txt     # MIT の表記
.agents/skills/references/blender-skills-sources.json    # 出典の記録（移したものの項目だけ）
.claude/skills/blender-modeler -> ../../.agents/skills/blender-modeler  # Claude Code 用の相対 symlink
.claude/skills/references      -> ../../.agents/skills/references       # Claude Code 用の相対 symlink（共有の参照文書）
```

実体は `.agents/skills/<name>/` に置きます。Claude Code は `.claude/skills/` の相対 symlink を読み、Pi は `--skill` で渡したディレクトリを読みます。SKILL.md の `../references/...` は symlink のパスからも辿れます。

## 読み込み方

agent-workspace の main worktree（root）から起動するエージェントに、起動時にパスを足して読み込ませます。登録された clone（`projects/resonite-creative-skills`）は編集せず、その `origin/main` を空の一時ディレクトリに展開して使います。

```bash
# agent-workspace の checkout の root で実行する
PARENT="$(uv run --no-project python .agents/scripts/agent_tmp.py root)"
CLONE="$PARENT/projects/resonite-creative-skills"
# clone が無いときだけ実行する
(cd "$PARENT" && uv run --project tools/devenv --locked python -m tools.workspace prepare resonite-creative-skills)
```

```bash
CREATIVE_ROOT="$(mktemp -d)" &&
  git -C "$CLONE" fetch --no-tags origin main &&
  git -C "$CLONE" archive refs/remotes/origin/main | tar -x -C "$CREATIVE_ROOT"
```

`git archive` は symlink を保ち、clone の作業ツリーにも worktree の登録にも触れません。展開が成功した場合だけ次のブロックを実行します。

```bash
claude --add-dir "$CREATIVE_ROOT"
pi --skill "$CREATIVE_ROOT/.agents/skills"
```

確認: Claude Code は `/context`、Pi は起動時の一覧か `/skill:` の補完で `blender-modeler` が使えることを確かめます。同名のスキルと取り違えないよう、Pi は RPC の `get_commands` で `sourceInfo.path` が `$CREATIVE_ROOT/.agents/skills/` の下であることを、Claude Code は `--add-dir` を外した起動と比べます。

ResoLoop の同梱スキル（agent-workspace の `.agents/projects/resoloop.md` の「同梱スキル」で `SKILL_ROOT` に同期したもの）と一緒に使うときは、次のように並べます。

```bash
claude --add-dir "$SKILL_ROOT" --add-dir "$CREATIVE_ROOT"
pi --skill "$SKILL_ROOT/.agents/skills" --skill "$CREATIVE_ROOT/.agents/skills"
```

セッションの使用中は `CREATIVE_ROOT` を消さないでください。使い終わったら、`mktemp -d` で作った本人が消します。新しい版を読むときは、新しい一時ディレクトリに展開し直します。

## ライセンスと出典

- `blender-modeler` と `modular-environment-design.md` は [arjun988/blender-skills](https://github.com/arjun988/blender-skills)（commit `8f778d2405a214b508d4c7d80742be8e43acdd52`）の文書を元に create-reso-world で書き直した派生物で、MIT License の条件で配布します。表記は `.agents/skills/references/blender-skills-LICENSE.txt`、文書ごとの出典と改変の要約は `.agents/skills/references/blender-skills-sources.json` にあります。
- それ以外のファイルのライセンスは、まだ定めていません。
