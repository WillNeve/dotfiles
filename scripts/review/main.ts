import * as dotenv from "dotenv";
import chalk from "chalk";
import { readFile, writeFile, unlink } from "fs/promises";
import { execSync } from "child_process";
import path from "path";
import { fileURLToPath } from "url";
import { input } from "@inquirer/prompts";
import { printTitle } from "../_utils/ts/print/titles";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Store the original working directory before any cd operations
const ORIGINAL_CWD = process.env.ORIGINAL_CWD || process.cwd();

const clearAndShowTitle = () => {
  console.clear();
  printTitle("Code Review", "CYAN");
};

const checkToolInstalled = (): boolean => {
  try {
    execSync("opencode --version", { stdio: "pipe" });
    return true;
  } catch {
    return false;
  }
};

dotenv.config({ quiet: true });

async function main() {
  try {
    clearAndShowTitle();

    console.log(chalk.blue(`Using review tool: ${chalk.bold("opencode")}\n`));

    if (!checkToolInstalled()) {
      console.error(chalk.red("❌ Error: opencode is not installed or not in PATH"));
      console.log(chalk.yellow("💡 Please install opencode first"));
      process.exit(1);
    }

    const basePrompt = await readFile(path.join(__dirname, "base-prompt.txt"), "utf8");

    const branchName = await input({
      message: "Enter the branch name (empty for current):",
      default: "HEAD",
    });
    const baseBranchName = await input({
      message: "Enter the base branch name (empty for origin/staging):",
      default: "origin/staging",
    });

    const variableValues: Record<string, string> = {
      BRANCH_NAME: branchName,
      BASE_BRANCH_NAME: baseBranchName,
    };

    let finalPrompt = basePrompt;
    for (const [variable, value] of Object.entries(variableValues)) {
      const regex = new RegExp(`{{\\s*${variable.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\s*}}`, "g");
      finalPrompt = finalPrompt.replace(regex, value);
    }

    console.log(chalk.green("\n✅ Executing opencode review"));
    console.log(chalk.cyan(chalk.italic.gray("Prompt:", finalPrompt)));
    console.log(chalk.white("Prompt length:"), finalPrompt.length, "characters");

    const tmpFile = path.join(__dirname, `/temp/prompt-${Date.now()}.txt`);
    try {
      await writeFile(tmpFile, finalPrompt, "utf8");
      execSync(`opencode run -m github-copilot/claude-haiku-4.5 "$(cat ${tmpFile})"`, {
        stdio: "inherit",
        cwd: ORIGINAL_CWD,
        shell: "/bin/bash",
      });
    } finally {
      await unlink(tmpFile).catch(() => {});
    }
  } catch (error: unknown) {
    console.log(
      chalk.yellow("\n💡 If you're experiencing issues, please check if you have the latest version installed."),
    );

    const errorMessage = error instanceof Error ? error.message : String(error);
    console.error(chalk.red("❌ Error:"), errorMessage);
  }
}

main();
