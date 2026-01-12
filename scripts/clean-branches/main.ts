import chalk from "chalk";
import { execSync } from "child_process";
import { checkbox, input } from "@inquirer/prompts";
import { printTitle } from "../_utils/ts/print/titles.js";

const PROTECTED_BRANCHES = ["main", "staging"];

interface Branch {
  name: string;
  value: string;
}

const clearAndShowTitle = () => {
  console.clear();
  printTitle("Clean Local Branches", "CYAN");
};

const getLocalBranches = (): string[] => {
  try {
    const output = execSync("git branch --format='%(refname:short)'", {
      encoding: "utf8",
      stdio: ["pipe", "pipe", "pipe"],
    });

    return output
      .split("\n")
      .map((branch) => branch.trim())
      .filter((branch) => branch.length > 0);
  } catch (error) {
    console.error(chalk.red("❌ Error fetching branches:"), error);
    process.exit(1);
  }
};

const getCurrentBranch = (): string => {
  try {
    return execSync("git branch --show-current", {
      encoding: "utf8",
      stdio: ["pipe", "pipe", "pipe"],
    }).trim();
  } catch (error) {
    console.error(chalk.red("❌ Error getting current branch:"), error);
    process.exit(1);
  }
};

const deleteBranch = (branchName: string): boolean => {
  if (!/^[a-zA-Z0-9/_.-]+$/.test(branchName)) {
    console.error(chalk.red(`❌ Invalid branch name: ${branchName}`));
    return false;
  }

  try {
    execSync(`git branch -D ${branchName}`, {
      encoding: "utf8",
      stdio: ["pipe", "pipe", "pipe"],
    });
    return true;
  } catch (error) {
    return false;
  }
};

const cleanZshHistory = (activeBranches: string[]): void => {
  try {
    const homeDir = process.env.HOME;
    if (!homeDir) {
      console.log(
        chalk.gray(
          "  ℹ️  Could not determine home directory, skipping zsh history cleanup"
        )
      );
      return;
    }

    const historyPath = `${homeDir}/.zsh_history`;

    // Check if history file exists
    try {
      execSync(`test -f ${historyPath}`, { stdio: "pipe" });
    } catch {
      console.log(
        chalk.gray("  ℹ️  No zsh history file found, skipping cleanup")
      );
      return;
    }

    // Create a backup
    execSync(`cp ${historyPath} ${historyPath}.bak`, { stdio: "pipe" });

    // Build a pattern that matches git co/checkout commands with deleted branches
    // We'll keep commands that checkout existing branches or use other git checkout options
    const branchPattern = activeBranches
      .map((b) => b.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"))
      .join("|");

    // Filter history: keep all non-checkout commands, checkouts with existing branches, and checkouts with flags
    const awkScript = `
    BEGIN { RS=""; FS="\\n" }
    {
      line = $0;
      if (line ~ /: [0-9]+:[0-9]+;git (co|checkout) /) {
        if (match(line, /: [0-9]+:[0-9]+;git (co|checkout) +([^; ]+)/, arr)) {
          branch = arr[2];
          if (branch ~ /^-/ || branch ~ /^(${branchPattern})$/) {
            print line;
          }
        } else {
          print line;
        }
      } else {
        print line;
      }
    }
    `.trim();

    execSync(`awk '${awkScript}' ${historyPath}.bak > ${historyPath}`, {
      shell: "/bin/bash",
      stdio: "pipe",
    });

    console.log(chalk.green("  ✅ Cleaned zsh autocomplete history"));
  } catch (error) {
    console.log(
      chalk.yellow("  ⚠️  Could not clean zsh history (non-critical)")
    );
  }
};

async function main() {
  try {
    clearAndShowTitle();

    console.log(chalk.blue("📡 Fetching local branches...\n"));

    const currentBranch = getCurrentBranch();
    const allBranches = getLocalBranches();

    const availableBranches = allBranches.filter((branch) => {
      return !PROTECTED_BRANCHES.includes(branch) && branch !== currentBranch;
    });

    if (availableBranches.length === 0) {
      console.log(chalk.yellow("⚠️  No branches available to delete"));
      console.log(
        chalk.gray(
          `   Protected branches: ${PROTECTED_BRANCHES.join(
            ", "
          )}\n   Current branch: ${currentBranch}`
        )
      );
      process.exit(0);
    }

    console.log(
      chalk.blue(
        `Found ${availableBranches.length} branch(es) available for deletion`
      )
    );
    console.log(chalk.gray(`Protected: ${PROTECTED_BRANCHES.join(", ")}`));
    console.log(chalk.gray(`Current: ${currentBranch}\n`));

    const branchChoices: Branch[] = availableBranches.map((branch) => ({
      name: branch,
      value: branch,
    }));

    const selectedBranches = await checkbox({
      message:
        "Select branches to delete (use arrow keys and space to select):",
      choices: branchChoices,
      pageSize: 15,
    });

    if (selectedBranches.length === 0) {
      console.log(chalk.yellow("\n⚠️  No branches selected"));
      process.exit(0);
    }

    console.log(
      chalk.yellow(
        `\n⚠️  You are about to delete ${selectedBranches.length} branch(es):`
      )
    );
    selectedBranches.forEach((branch: string) => {
      console.log(chalk.red(`  • ${branch}`));
    });

    const confirmation = await input({
      message: 'Type "delete" to confirm:',
    });

    if (confirmation.toLowerCase() !== "delete") {
      console.log(chalk.yellow("\n🚫 Cancelled - branches were not deleted"));
      process.exit(0);
    }

    console.log(chalk.blue("\n🗑️  Deleting branches...\n"));

    let successCount = 0;
    let failCount = 0;

    for (const branch of selectedBranches) {
      const success = deleteBranch(branch);
      if (success) {
        console.log(chalk.green(`  ✅ ${branch}`));
        successCount++;
      } else {
        console.log(chalk.red(`  ❌ ${branch} (failed to delete)`));
        failCount++;
      }
    }

    console.log(chalk.green(`\n✅ Done! Deleted ${successCount} branch(es)`));
    if (failCount > 0) {
      console.log(chalk.red(`❌ Failed to delete ${failCount} branch(es)`));
    }

    // Clean zsh autocomplete history
    if (successCount > 0) {
      console.log(chalk.blue("\n🧹 Cleaning zsh autocomplete history..."));
      const remainingBranches = getLocalBranches();
      cleanZshHistory(remainingBranches);
    }
  } catch (error: unknown) {
    if (error && typeof error === "object" && "message" in error) {
      if ((error.message as string).includes("User force closed")) {
        console.log(chalk.yellow("\n\n🚫 Cancelled"));
        process.exit(0);
      }
    }

    const errorMessage = error instanceof Error ? error.message : String(error);
    console.error(chalk.red("\n❌ Error:"), errorMessage);
    process.exit(1);
  }
}

main();
