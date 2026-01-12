import chalk from "chalk";
import { execSync } from "child_process";
import { select } from "@inquirer/prompts";
import { readFile, readdir } from "fs/promises";
import { existsSync, lstatSync } from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { printTitle } from "../../../_utils/ts/print/titles.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

interface Script {
  name: string;
  type: "public" | "private";
  path: string;
  description?: string;
}

const clearAndShowTitle = () => {
  console.clear();
  printTitle("Run Script", "CYAN");
};

const getScriptsInDirectory = async (type: "public" | "private"): Promise<Script[]> => {
  const scripts: Script[] = [];
  const scriptsPath = path.join(__dirname, "../../..", type);

  if (!existsSync(scriptsPath)) {
    return scripts;
  }

  try {
    const items = await readdir(scriptsPath);

    for (const item of items) {
      const itemPath = path.join(scriptsPath, item);

      try {
        const stats = lstatSync(itemPath);
        if (stats.isDirectory() && item !== "_internal") {
          const mainShPath = path.join(itemPath, "main.sh");
          if (existsSync(mainShPath)) {
            let description: string | undefined;

            const readmePath = path.join(itemPath, "README.md");
            if (existsSync(readmePath)) {
              try {
                const readmeContent = await readFile(readmePath, "utf8");
                const lines = readmeContent.split("\n").filter((line) => line.trim().length > 0);
                description = lines.slice(0, 2).join(" ").trim();
                if (description.length > 80) {
                  description = description.substring(0, 77) + "...";
                }
              } catch {
                description = undefined;
              }
            }

            scripts.push({
              name: item,
              type,
              path: mainShPath,
              description,
            });
          }
        }
      } catch {
        continue;
      }
    }
  } catch (error) {
    console.error(chalk.red(`Error reading ${type} scripts:`), error);
  }

  return scripts;
};

const getAllScripts = async (): Promise<Script[]> => {
  const publicScripts = await getScriptsInDirectory("public");
  const privateScripts = await getScriptsInDirectory("private");
  return [...publicScripts, ...privateScripts];
};

async function main() {
  try {
    clearAndShowTitle();

    console.log(chalk.blue("📡 Loading available scripts...\n"));

    const scripts = await getAllScripts();

    if (scripts.length === 0) {
      console.log(chalk.yellow("⚠️  No scripts found"));
      process.exit(0);
    }

    const choices = scripts.map((script) => {
      const typeLabel = script.type === "public" ? chalk.green("[public]") : chalk.yellow("[private]");
      const name = chalk.bold(script.name);
      const description = script.description ? chalk.gray(` - ${script.description}`) : "";

      return {
        name: `${typeLabel} ${name}${description}`,
        value: script,
        description: script.path,
      };
    });

    const selectedScript = await select({
      message: "Select a script to run:",
      choices,
      pageSize: 15,
    });

    const action = await select({
      message: "What would you like to do?",
      choices: [
        { name: "Run script", value: "run" },
        { name: "Copy command to clipboard", value: "copy" },
      ],
    });

    if (action === "copy") {
      const command = `sh ${JSON.stringify(selectedScript.path)}`;
      try {
        execSync("pbcopy", {
          input: command,
        });
        console.log(chalk.green("\n✅ Command copied to clipboard:"));
        console.log(chalk.cyan(`   ${command}`));
      } catch {
        console.log(chalk.yellow("\n⚠️  Could not copy to clipboard. Here's the command:"));
        console.log(chalk.cyan(`   ${command}`));
      }
    } else {
      console.log(chalk.blue(`\n🚀 Running ${selectedScript.name}...\n`));

      execSync(`sh ${JSON.stringify(selectedScript.path)}`, {
        stdio: "inherit",
        cwd: process.cwd(),
      });
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
