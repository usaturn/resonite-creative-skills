# AGENTS.md

- 開発は [usaturn/agent-workspace](https://github.com/usaturn/agent-workspace) から行う。Git・Issue・PR の手順はワークスペースのスキルに従う。
- 検証入口: `./scripts/verify.sh`
- **Spec・Plan は agent-workspace の `docs_draft/superpowers/` に保存し、このリポジトリに commit しない。**
- GitHub Actions は無効。検証はローカルで行う。

## スキルの置き方

- このリポジトリには、Resonite・Blender の制作系スキルだけを置く。開発ワークフローのスキル（Issue・PR・レビューなど）は agent-workspace に置き、ここに置かない。
- スキルの実体は `.agents/skills/<name>/SKILL.md` に置く。`.claude/skills/<name>` は `../../.agents/skills/<name>` への相対 symlink にする。写しを置かない。
- 複数のスキルが使う参照文書は `.agents/skills/references/` に置き、`.claude/skills/references` も同じ形の symlink にする。SKILL.md からは `../references/<file>` で参照する。
- arjun988/blender-skills 由来の派生物を足すときは、`blender-skills-LICENSE.txt` を残し、`blender-skills-sources.json` の `documents` にその文書の項目を足す。
- create-reso-world から移すときは、移行元の commit の内容を無改変で写し、PR に移行元の commit を書く。create-reso-world 側のスキルは消さない。
- 読み込み方は `README.md` の「読み込み方」に従う。
