# ROV27

## Contributing

### Project Navigation

This is a monorepo. Every folder at the monorepo root level is treated as a separate subproject.

#### Opening a project

It is **not** recommended to directly open the monorepo root folder in your text editor or IDE. Please open the specific subproject folder you are working on.

#### Project list

| Project                          | Base Branch    | Description                                                             |
| -------------------------------- | -------------- | ----------------------------------------------------------------------- |
| [Monorepo](./)                   | `main`         | Structuring and root-level configuration of the monorepo                |
| [console](./console/README.md)   | `console/dev`  | GUI for remote control                                                  |
| [firmware](./firmware/README.md) | `firmware/dev` | Firmware for the on-board MCUs                                          |
| [network](./network/README.md)   | `network/dev`  | Configuration and scripts for network setup                             |
| [reports](./reports/README.md)   | `reports/dev`  | Deliverable documents required by the competition                       |
| [rov_ws](./rov_ws/README.md)     | `ros/dev`      | ROS2 project for on-board control, navigation, vision and communication |

---

### Branch Strategies

Each subproject isolates active development on its own base branch (`<base>`, e.g., `console/dev` or `ros/dev`), while `main` holds stable, integrated versions of all subprojects.

```mermaid
graph TD
    subgraph ProjectTrack ["Contributions Pipeline"]
        direction TB
        subgraph MaintainersSync ["Heads / Maintainers"]
            MainStart["main"] -->|"Create or Sync Base Branch"| ProjDev1["&lt;base&gt; (e.g., console/dev, ros/dev)"]
        end

        ProjDev1 -->|"New Feature Branch"| ProjFeature["&lt;project&gt;/&lt;FEATURE&gt;"]
        ProjFeature -->|"Open Feature PR"| FeaturePR["Feature PR"]

        subgraph ReviewersSub ["Heads / Maintainers"]
            direction TB
            ReviewStep["Feature Code Review"] -->|"Squash & Merge"| ProjDev2["&lt;base&gt;"]
            IntegrationPR["Integration PR"]
        end

        subgraph MaintainersSub ["Heads"]
            direction TB
            IntegrationPR -->|"Trigger"| FinalReview["Final Review"]
            FinalReview -->|"Merge Commit"| MainEnd["main"]
        end

        FeaturePR -->|"Trigger"| ReviewStep
        ProjDev2 -->|"Open PR to main"| IntegrationPR
    end

    classDef mainBranch fill:#070707,stroke:#373737,stroke-width:2px,color:#EDEFF0;
    classDef devBranch fill:#FA5F6C,stroke:#DD1F44,stroke-width:2px,color:#FEDFDF;
    classDef featureBranch fill:#DD1F44,stroke:#FA5F6C,stroke-width:2px,color:#FFFFFF;
    classDef reviewNode fill:#FCA6A7,stroke:#FEDFDF,stroke-width:2px,color:#070707;

    class MainStart,MainEnd mainBranch
    class ProjDev1,ProjDev2 devBranch
    class ProjFeature featureBranch
    class FeaturePR,ReviewStep,IntegrationPR,FinalReview reviewNode

```

---

### Merge Strategy

We use a **two-tier merge strategy** to keep day-to-day contributions simple while preserving clear integration milestones on `main`:

1. **Feature PRs (`<project>/<FEATURE>` → `<base>`): Squash and merge**
* All commits in a feature branch are squashed into a single, descriptive commit on `<base>` (enforced via GitHub Rulesets).
* You do **not** need to rebase your feature branch just to clean up commit history. Only sync with `<base>` if GitHub reports merge conflicts or you need recent changes from `<base>`.
* **Important:** Once a feature PR is squash-merged, **delete the feature branch** and create a fresh branch from `<base>` for any future work.


2. **Integration PRs (`<base>` → `main`): Create a merge commit**
* When merging tested subproject updates from `<base>` into `main`, maintainers use **Create a merge commit** (not squash) so individual feature commits remain traceable on `main`.


#### Feature PR Workflow

```mermaid
graph TD
    Start([1. Ready for Review]) --> OpenPR["2. Open Pull Request
    ───
    Target: &lt;base&gt; (e.g., ros/dev)"]

    OpenPR --> CheckConflicts{3. Merge Conflicts?}

    CheckConflicts -->|Yes| SyncBase["4. Update Branch Locally
    ───
    git checkout &lt;base&gt;
    git pull
    git checkout &lt;feature&gt;
    git merge &lt;base&gt;
    (Resolve conflicts &amp; git push)"]

    CheckConflicts -->|No| AskReview["5. Wait for Reviewer"]
    SyncBase --> AskReview

    AskReview --> CheckApproval{6. Approved?}

    CheckApproval -->|Changes Requested| DevEdits["6a. Push Fixes
    ───
    (Edit files)
    git add &lt;files&gt;
    git commit -m 'address feedback'
    git push"]

    DevEdits --> CheckConflicts

    CheckApproval -->|Yes| FinalMerge(["7. Reviewer Finishes Merge
    ───
    GitHub Web UI: 'Squash and merge'
    (Delete feature branch after merge)"])

    classDef mainBranch fill:#070707,stroke:#373737,stroke-width:2px,color:#EDEFF0;
    classDef modificationBranch fill:#383B3D,stroke:#191B1C,stroke-width:2px,color:#EDEFF0;
    classDef devBranch fill:#FA5F6C,stroke:#DD1F44,stroke-width:2px,color:#FEDFDF;
    classDef logicGate fill:#383B3D,stroke:#FA5F6C,stroke-width:1px,color:#EDEFF0;

    class Start,FinalMerge mainBranch;
    class OpenPR,SyncBase,DevEdits modificationBranch;
    class AskReview devBranch;
    class CheckConflicts,CheckApproval logicGate;

```

---

### Cross-Project Work

When a task spans multiple subprojects (for example, changing a message format in `rov_ws` and updating its UI in `console`), keep each subproject's changes on its own feature branch targeting its respective `<base>` branch.

#### Working on Multiple Branches Simultaneously

* **Git Worktrees (Recommended):** Check out different branches into separate folders without duplicating the `.git` history (uses the `.git` directory of the original repository). \
From the `ROV27` root folder:
```sh
git worktree add ../<worktree-name> <branch-name>
```

if is recommended to use a descriptive name for `<worktree-name>` (e.g. `git worktree add ../ROV27-WT-<project> <branch-name>`). \
You can then open the subproject folder inside `ROV27-WT-<project>` directly in your editor.

* **Multiple Clones:** Alternatively, clone the repository into a second directory if you prefer completely separate clones.

#### Coordinating Linked PRs

* Open separate feature PRs for each affected subproject (e.g., one targeting `ros/dev` and one targeting `console/dev`) and cross-reference them in the PR descriptions (`Depends on #<PR_NUMBER>`).
* Avoid sharing a single feature branch across multiple subproject base branches when using squash merges, as squashing rewrites commit hashes and makes cross-branch tracking unreliable.
