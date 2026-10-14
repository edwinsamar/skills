# Edwin Skills

Engineering skills for coding agents. Each skill is one short `SKILL.md`. They work in Claude Code, Codex and other agents that read the `SKILL.md` format.

## Ceremony should match stakes

Use more process when the stakes are higher.

| Tier | Example | What to do | Skills |
|---|---|---|---|
| Small tweak | Typo, config value, one-line fix | Do it. Check it yourself. | none |
| Small feature | One clear behavior, a few files | Ask questions first. Write the test first. | `grill-me`, `tdd` |
| Big or unclear feature | Many files, new module, vague requirements | Spec and plan. Build in phases with a check after each. | `spec`, `build-plan` |
| Production, security, cannot undo | Deploy, migration, auth, secrets, delete | Doubt everything. Harden. Full review. | `full-review`, `security-hardening` |

## Skills

| Skill | Use it to |
|---|---|
| [`grill-me`](skills/grill-me/SKILL.md) | Ask questions in rounds until no decision is open |
| [`spec`](skills/spec/SKILL.md) | Write what to build and how to check it, before code |
| [`build-plan`](skills/build-plan/SKILL.md) | Break work into small units, each with a check |
| [`tdd`](skills/tdd/SKILL.md) | Write a failing test, then make it pass |
| [`security-hardening`](skills/security-hardening/SKILL.md) | Close the paths an attacker or bad input can use |
| [`full-review`](skills/full-review/SKILL.md) | Find what a change breaks and prove the key facts |

## Install

Link all skills into `~/.claude/skills` and `~/.agents/skills`:

```bash
git clone https://github.com/edwinsamar/skills.git
cd skills
./install.sh            # link
./install.sh --check    # verify
./install.sh --uninstall
```

Or, in Claude Code, as a plugin:

```
/plugin marketplace add edwinsamar/skills
/plugin install edwin-skills@edwin-skills
```

Use one method, not both. Two copies give two skills with the same name.

## Add to your agent instructions

Copy the tier table above into your `AGENTS.md` or `CLAUDE.md`. The agent then picks the tier and the skill for each task.

## Credits

These skills build on [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills), [mattpocock/skills](https://github.com/mattpocock/skills) and [pstack](https://github.com/backnotprop/pstack). See [NOTICE.md](NOTICE.md).

## License

MIT. See [LICENSE](LICENSE).
