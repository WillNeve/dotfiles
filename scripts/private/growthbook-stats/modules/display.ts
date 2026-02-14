import chalk from "chalk";
import * as readline from "readline";
import { UserExperimentStats, WeeklyUserStats, WeeklyStats, UserOption, USER_ID_MAP } from "./types.js";

export function clearAndShowTitle(): void {
  console.clear();
  console.log(chalk.bgCyan.black.bold(" 📊 GrowthBook Stats "));
}

export function showHelp(): void {
  console.log(chalk.bgCyan.black.bold(" Help "));
  console.log();
  console.log(chalk.yellow("Usage:"));
  console.log("  npx tsx scripts/growthbook-stats/main.ts [options]");
  console.log();
  console.log(chalk.yellow("Options:"));
  console.log("  -u, --user <name>        User name (Ben, Will, James, etc.)");
  console.log("  -s, --start <date>       Start date (YYYY-MM-DD or DD-MM-YYYY)");
  console.log("  -e, --end <date>         End date (YYYY-MM-DD or DD-MM-YYYY)");
  console.log("  -w, --weekly             Show weekly breakdown");
  console.log("  -t, --table              Auto-show table format for copy-paste");
  console.log("  -h, --help               Show this help message");
  console.log();
  console.log(chalk.yellow("Examples:"));
  console.log("  npx tsx scripts/growthbook-stats/main.ts --user Will --start 2025-07-01 --end 2025-09-30");
  console.log("  npx tsx scripts/growthbook-stats/main.ts -u Ben -s 01-08-2024 -e 31-08-2024 -w");
  console.log("  npx tsx scripts/growthbook-stats/main.ts  # Interactive mode");
}

export function displayUserOptions(): UserOption[] {
  console.log(chalk.cyan("Experiment stats by user"));
  console.log(chalk.gray("═".repeat(50)));

  const userList: UserOption[] = [];
  let index = 1;

  Object.entries(USER_ID_MAP).forEach(([team, users]) => {
    console.log(chalk.bold.white(`${team} Team:`));
    Object.entries(users).forEach(([name, userId]) => {
      console.log(chalk.blue(`  ${index}. ${name}`));
      userList.push({ name, userId, team });
      index++;
    });
    console.log();
  });

  return userList;
}

export function askQuestion(question: string, info?: string, finalPrompt?: string): Promise<string> {
  return new Promise((resolve) => {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    let fullPrompt = chalk.yellow(`? ${question}`);
    if (info) {
      fullPrompt += ` \n ${chalk.gray(info)}`;
    }
    if (finalPrompt) {
      fullPrompt += ` ${finalPrompt}`;
    }

    rl.question(fullPrompt, (answer) => {
      rl.close();
      resolve(answer.trim());
    });
  });
}

export async function getUserSelection(userList: UserOption[]): Promise<string> {
  const input = await askQuestion("Enter user name or number:");

  const numberInput = parseInt(input, 10);
  if (!isNaN(numberInput) && numberInput >= 1 && numberInput <= userList.length) {
    const selectedUser = userList[numberInput - 1];
    console.log(chalk.green(`✅ Selected: ${selectedUser.name}`));
    return selectedUser.userId;
  }

  const foundUser = userList.find((user) => user.name.toLowerCase() === input.toLowerCase());

  if (foundUser) {
    console.log(chalk.green(`✅ Selected: ${foundUser.name}`));
    return foundUser.userId;
  } else {
    console.log(chalk.red(`❌ "${input}" not found. Please enter a valid name or number (1-${userList.length}).`));
    console.log();
    return getUserSelection(userList);
  }
}

export function printWeeklyBreakdown(
  stats: WeeklyUserStats,
  userName: string,
  dateRange: { startDate: Date; endDate: Date },
): void {
  console.log(chalk.gray("═".repeat(50)));
  console.log(chalk.bgGreen.black.bold(" 📅 Weekly Breakdown "));
  console.log(chalk.gray("═".repeat(50)));

  const periodString = `${dateRange.startDate.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  })} - ${dateRange.endDate.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  })}`;

  console.log(chalk.blue(`👤 User: ${chalk.white.bold(userName)}`));
  console.log(chalk.blue(`📅 Period: ${chalk.white.bold(periodString)}`));
  console.log();

  stats.weeklyStats.forEach((week: WeeklyStats) => {
    console.log(chalk.white.bold(`Week: ${week.weekLabel}`));
    console.log(chalk.blue(`  Launched: ${week.totalExperimentsLaunched} | Concluded: ${week.totalExperiments}`));

    if (week.totalExperiments > 0) {
      console.log(
        chalk.green(`  Won: ${week.won}`),
        chalk.red(`Lost: ${week.lost}`),
        chalk.gray(`DNF: ${week.dnf}`),
        chalk.yellow(`Inconclusive: ${week.inconclusive}`),
      );
    }
    console.log();
  });
}

export function printOverallSummary(
  stats: UserExperimentStats | WeeklyUserStats,
  userName: string,
  dateRange: { startDate: Date; endDate: Date },
): void {
  const periodString = `${dateRange.startDate.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  })} - ${dateRange.endDate.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  })}`;

  console.log(chalk.gray("═".repeat(50)));
  console.log(chalk.bgGreen.black.bold(" 📊 Overall Summary "));
  console.log(chalk.gray("═".repeat(50)));
  console.log(chalk.blue(`👤 User: ${chalk.white.bold(userName)}`));
  console.log(chalk.blue(`📅 Period: ${chalk.white.bold(periodString)}`));
  console.log();

  // Check if it's weekly stats (has overallStats property)
  const isWeeklyStats = "overallStats" in stats;
  const actualStats = isWeeklyStats ? (stats as WeeklyUserStats).overallStats : (stats as UserExperimentStats);

  console.log(chalk.blue(`Total Launched: ${actualStats.totalExperimentsLaunched}`));
  console.log(chalk.blue(`Total Concluded: ${actualStats.totalExperiments}`));
  console.log(
    chalk.green(`Won: ${actualStats.won}`),
    chalk.red(`Lost: ${actualStats.lost}`),
    chalk.gray(`DNF: ${actualStats.dnf}`),
    chalk.yellow(`Inconclusive: ${actualStats.inconclusive}`),
  );
  console.log(chalk.blue(`Overall Win Rate: ${actualStats.winRate.toFixed(2)}%`));
  console.log(chalk.magenta(`Overall Significant Win Rate: ${actualStats.significantWinRate.toFixed(2)}%`));

  if (actualStats.experimentsPerWeek) {
    console.log(chalk.cyan(`Experiments per Week: ${actualStats.experimentsPerWeek.toFixed(2)}`));
  }
}

export async function promptForTable(): Promise<boolean> {
  const answer = await askQuestion("Show plain text table (sheets export)? (y/n):", "(Default: No)");
  return answer.toLowerCase() === "y" || answer.toLowerCase() === "yes";
}

export function printTableFormat(
  stats: UserExperimentStats | WeeklyUserStats,
  userName: string,
  isWeekly: boolean,
  dateRange?: { startDate: Date; endDate: Date },
): void {
  console.log(chalk.gray("═".repeat(80)));
  console.log(chalk.bgYellow.black.bold(" 📋 Table Format (Copy-Paste Ready for Sheets) "));
  console.log(chalk.gray("═".repeat(80)));

  if (isWeekly && "weeklyStats" in stats) {
    const weeklyStats = stats as WeeklyUserStats;
    // Weekly table format
    const headers = [
      "User",
      "Week",
      "Launched",
      "Concluded",
      "Won",
      "Lost",
      "DNF",
      "Inconclusive",
      "Win Rate (%)",
      "Significant Win Rate (%)",
    ].join("\t");

    console.log(headers);

    // Add weekly data
    weeklyStats.weeklyStats.forEach((week: WeeklyStats) => {
      const row = [
        userName,
        week.weekLabel,
        week.totalExperimentsLaunched.toString(),
        week.totalExperiments.toString(),
        week.won.toString(),
        week.lost.toString(),
        week.dnf.toString(),
        week.inconclusive.toString(),
        week.winRate.toFixed(1),
        week.significantWinRate.toFixed(1),
      ].join("\t");
      console.log(row);
    });

    // Add overall summary row
    const overallRow = [
      userName,
      "TOTAL",
      weeklyStats.overallStats.totalExperimentsLaunched.toString(),
      weeklyStats.overallStats.totalExperiments.toString(),
      weeklyStats.overallStats.won.toString(),
      weeklyStats.overallStats.lost.toString(),
      weeklyStats.overallStats.dnf.toString(),
      weeklyStats.overallStats.inconclusive.toString(),
      weeklyStats.overallStats.winRate.toFixed(2),
      weeklyStats.overallStats.significantWinRate.toFixed(2),
    ].join("\t");
    console.log(overallRow);
  } else {
    const regularStats = stats as UserExperimentStats;
    // Regular table format
    const headers = [
      "User",
      "Period",
      "Launched",
      "Concluded",
      "Won",
      "Lost",
      "DNF",
      "Inconclusive",
      "Win Rate (%)",
      "Significant Win Rate (%)",
      "Experiments/Week",
    ].join("\t");

    console.log(headers);

    const periodString = dateRange
      ? `${dateRange.startDate.toLocaleDateString("en-US", {
          month: "short",
          day: "numeric",
          year: "numeric",
        })} - ${dateRange.endDate.toLocaleDateString("en-US", {
          month: "short",
          day: "numeric",
          year: "numeric",
        })}`
      : "TOTAL";

    const row = [
      userName,
      periodString,
      regularStats.totalExperimentsLaunched.toString(),
      regularStats.totalExperiments.toString(),
      regularStats.won.toString(),
      regularStats.lost.toString(),
      regularStats.dnf.toString(),
      regularStats.inconclusive.toString(),
      regularStats.winRate.toFixed(2),
      regularStats.significantWinRate.toFixed(2),
      regularStats.experimentsPerWeek?.toFixed(2) || "N/A",
    ].join("\t");
    console.log(row);
  }

  console.log(chalk.gray("═".repeat(80)));
  console.log(chalk.yellow("📋 The table format above is ready to copy-paste into Google Sheets or Excel!"));
  console.log(chalk.gray("   Simply select all the table text above and copy it."));
  console.log(chalk.gray("═".repeat(80)));
}
