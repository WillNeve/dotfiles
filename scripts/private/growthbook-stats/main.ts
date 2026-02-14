import * as dotenv from "dotenv";
import chalk from "chalk";
import { CommandFlags, USER_ID_MAP } from "./modules/types.js";
import { fetchUserExperimentStats, fetchUserWeeklyStats, findUserIdByName, findUserName } from "./modules/api.js";
import {
  clearAndShowTitle,
  showHelp,
  displayUserOptions,
  getUserSelection,
  askQuestion,
  printWeeklyBreakdown,
  printOverallSummary,
  promptForTable,
  printTableFormat,
} from "./modules/display.js";

dotenv.config({ quiet: true });

function parseArgs(): CommandFlags {
  const args = process.argv.slice(2);
  const flags: CommandFlags = {};

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === "--user" || arg === "-u") {
      flags.user = args[i + 1];
      i++;
    } else if (arg === "--start" || arg === "-s") {
      flags.startDate = args[i + 1];
      i++;
    } else if (arg === "--end" || arg === "-e") {
      flags.endDate = args[i + 1];
      i++;
    } else if (arg === "--weekly" || arg === "-w") {
      flags.weekly = true;
    } else if (arg === "--table" || arg === "-t") {
      flags.table = true;
    } else if (arg === "--help" || arg === "-h") {
      flags.help = true;
    }
  }

  return flags;
}

function parseDate(dateString: string): Date | null {
  let date: Date;

  if (dateString.match(/^\d{4}-\d{2}-\d{2}$/)) {
    date = new Date(dateString);
  } else if (dateString.match(/^\d{2}-\d{2}-\d{4}$/)) {
    const [day, month, year] = dateString.split("-").map(Number);
    date = new Date(year, month - 1, day);
  } else {
    return null;
  }

  return isNaN(date.getTime()) ? null : date;
}

async function getCustomDateRange(): Promise<{ startDate: Date; endDate: Date }> {
  const answer = await askQuestion("Use a custom date range? (y/n):", "(Default: Current quarter - Q3 2025)");

  const useCustom = answer.toLowerCase() === "y" || answer.toLowerCase() === "yes";

  if (!useCustom) {
    const startDate = new Date("2025-07-01");
    const endDate = new Date("2025-09-30");
    console.log(chalk.green(`✅ Using Q3 2025 dates: July 1, 2025 - September 30, 2025`));
    return { startDate, endDate };
  }

  const startInput = await askQuestion("Enter start date (DD-MM-YYYY):");
  const startDate = parseDate(startInput);
  if (!startDate) {
    console.log(chalk.red("❌ Invalid start date format. Please use DD-MM-YYYY"));
    return getCustomDateRange();
  }

  const endInput = await askQuestion("Enter end date (DD-MM-YYYY):");
  const endDate = parseDate(endInput);
  if (!endDate) {
    console.log(chalk.red("❌ Invalid end date format. Please use DD-MM-YYYY"));
    return getCustomDateRange();
  }

  if (startDate > endDate) {
    console.log(chalk.red("❌ Start date must be before end date"));
    return getCustomDateRange();
  }

  const formatDate = (date: Date): string => {
    return date.toLocaleDateString("en-US", {
      month: "short",
      day: "numeric",
      year: "numeric",
    });
  };

  console.log(chalk.green(`✅ Using custom dates: ${formatDate(startDate)} - ${formatDate(endDate)}`));
  return { startDate, endDate };
}

async function getWeeklyModeInteractive(): Promise<boolean> {
  const answer = await askQuestion("Show weekly breakdown? (y/n):", "(Default: No)");
  return answer.toLowerCase() === "y" || answer.toLowerCase() === "yes";
}

async function main() {
  clearAndShowTitle();

  const flags = parseArgs();

  if (flags.help) {
    showHelp();
    return;
  }

  const apiKey = process.env.GROWTHBOOK_PERSONAL_ACCESS_TOKEN;
  if (!apiKey) throw new Error("GROWTHBOOK_PERSONAL_ACCESS_TOKEN is not set");

  try {
    let selectedUserId: string;
    let userName: string;
    let dateRange: { startDate: Date; endDate: Date };
    let isWeekly: boolean;

    if (flags.user && flags.startDate && flags.endDate) {
      const userId = findUserIdByName(flags.user);
      if (!userId) {
        console.error(chalk.red(`❌ User "${flags.user}" not found. Available users:`));
        Object.entries(USER_ID_MAP).forEach(([team, users]) => {
          console.error(chalk.gray(`${team} Team: ${Object.keys(users).join(", ")}`));
        });
        process.exit(1);
      }

      const startDate = parseDate(flags.startDate);
      const endDate = parseDate(flags.endDate);

      if (!startDate) {
        console.error(chalk.red(`❌ Invalid start date "${flags.startDate}". Use YYYY-MM-DD or DD-MM-YYYY format.`));
        process.exit(1);
      }

      if (!endDate) {
        console.error(chalk.red(`❌ Invalid end date "${flags.endDate}". Use YYYY-MM-DD or DD-MM-YYYY format.`));
        process.exit(1);
      }

      if (startDate > endDate) {
        console.error(chalk.red("❌ Start date must be before end date"));
        process.exit(1);
      }

      selectedUserId = userId;
      userName = flags.user;
      dateRange = { startDate, endDate };
      isWeekly = flags.weekly || false;

      console.log(
        chalk.green(
          `✅ Using flags: User=${userName}, Dates=${flags.startDate} to ${flags.endDate}${isWeekly ? ", Weekly=true" : ""}`,
        ),
      );
    } else {
      const dateRangeResult = await getCustomDateRange();
      clearAndShowTitle();
      const userList = displayUserOptions();
      const selectedUserIdResult = await getUserSelection(userList);
      const userNameResult = findUserName(selectedUserIdResult);

      const weeklyResult = await getWeeklyModeInteractive();

      let showTable = false;
      if (weeklyResult) {
        showTable = await promptForTable();
      }

      clearAndShowTitle();

      selectedUserId = selectedUserIdResult;
      userName = userNameResult;
      dateRange = dateRangeResult;
      isWeekly = weeklyResult;

      flags.table = showTable;
    }

    console.log(chalk.yellow("🔄 Fetching experiment data..."));

    if (isWeekly) {
      const stats = await fetchUserWeeklyStats(apiKey, selectedUserId, dateRange);

      clearAndShowTitle();
      console.log(chalk.cyan("Weekly experiment stats by user"));

      printWeeklyBreakdown(stats, userName, dateRange);
      printOverallSummary(stats, userName, dateRange);

      if (flags.table) {
        printTableFormat(stats, userName, true, dateRange);
      }
    } else {
      const stats = await fetchUserExperimentStats(apiKey, selectedUserId, dateRange);

      clearAndShowTitle();
      console.log(chalk.cyan("Experiment stats by user"));

      printOverallSummary(stats, userName, dateRange);

      if (flags.table || (await promptForTable())) {
        printTableFormat(stats, userName, false, dateRange);
      }
    }
  } catch (error) {
    console.error(chalk.red("❌ Error:"), error);
  }
}

main();
