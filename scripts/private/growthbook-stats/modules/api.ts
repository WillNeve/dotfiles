import axios from "axios";
import chalk from "chalk";
import {
  GrowthBookExperiment,
  ExperimentsResponse,
  UserExperimentStats,
  WeeklyUserStats,
  ExperimentData,
  WeeklyStats,
  USER_ID_MAP,
} from "./types.js";

export async function fetchAllExperiments(
  apiKey: string,
  apiHost: string = "https://api.growthbook.io",
): Promise<GrowthBookExperiment[]> {
  const allExperiments: GrowthBookExperiment[] = [];
  let offset = 0;
  const limit = 100;

  while (true) {
    const response = await axios.get<ExperimentsResponse>(`${apiHost}/api/v1/experiments`, {
      headers: { Authorization: `Bearer ${apiKey}` },
      params: { limit, offset },
    });

    const { experiments, hasMore, nextOffset } = response.data;
    allExperiments.push(...experiments);

    if (!hasMore || nextOffset <= offset) break;
    offset = nextOffset;
  }

  return allExperiments;
}

export async function fetchUserExperimentStats(
  apiKey: string,
  userId: string,
  dateRange: { startDate: Date; endDate: Date },
): Promise<UserExperimentStats> {
  try {
    const allExperiments = await fetchAllExperiments(apiKey);

    const userExperiments = allExperiments.filter((exp) => {
      if (exp.owner !== userId) return false;
      if (!exp.phases?.length) return false;

      const mainPhase = exp.phases[0];
      const endDate = new Date(mainPhase.dateEnded);

      return endDate >= dateRange.startDate && endDate <= dateRange.endDate;
    });

    const userExperimentsLaunched = allExperiments.filter((exp) => {
      if (exp.owner !== userId) return false;
      if (!exp.phases?.length) return false;

      const mainPhase = exp.phases[0];
      const startDate = new Date(mainPhase.dateStarted);

      return startDate >= dateRange.startDate && startDate <= dateRange.endDate;
    });

    const stats = { won: 0, lost: 0, dnf: 0, inconclusive: 0 };
    const experiments: ExperimentData[] = [];

    userExperiments.forEach((exp) => {
      const status = exp.resultSummary?.status || "inconclusive";

      experiments.push({
        name: exp.name,
        id: exp.id,
        status: status as "won" | "lost" | "dnf" | "inconclusive",
      });

      stats[status as keyof typeof stats]++;
    });

    const totalExperiments = userExperiments.length;
    const totalExperimentsLaunched = userExperimentsLaunched.length;
    const winRate = totalExperiments > 0 ? (stats.won / totalExperiments) * 100 : 0;
    const significantWinRate = stats.won > 0 ? (stats.won / (stats.won + stats.lost)) * 100 : 0;

    const timeDifferenceMs = dateRange.endDate.getTime() - dateRange.startDate.getTime();
    const totalWeeks = timeDifferenceMs / (1000 * 60 * 60 * 24 * 7);
    const experimentsPerWeek = totalExperimentsLaunched / totalWeeks;

    return {
      userId,
      totalExperiments,
      totalExperimentsLaunched,
      won: stats.won,
      lost: stats.lost,
      dnf: stats.dnf,
      inconclusive: stats.inconclusive,
      winRate,
      significantWinRate,
      experimentsPerWeek,
      experiments,
    };
  } catch (error) {
    console.error(chalk.red("Error fetching experiments:"), error);
    throw new Error("Failed to fetch experiment data from GrowthBook API");
  }
}

export async function fetchUserWeeklyStats(
  apiKey: string,
  userId: string,
  dateRange: { startDate: Date; endDate: Date },
): Promise<WeeklyUserStats> {
  try {
    const allExperiments = await fetchAllExperiments(apiKey);

    const weeklyPeriods: Array<{ start: Date; end: Date; label: string }> = [];

    const firstWeekStart = new Date(dateRange.startDate);
    const dayOfWeek = firstWeekStart.getDay();
    const daysToSubtract = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
    firstWeekStart.setDate(firstWeekStart.getDate() - daysToSubtract);

    const currentWeekStart = new Date(firstWeekStart);

    while (currentWeekStart <= dateRange.endDate) {
      const weekStart = new Date(currentWeekStart);
      const weekEnd = new Date(currentWeekStart);
      weekEnd.setDate(weekEnd.getDate() + 6);
      weekEnd.setHours(23, 59, 59, 999);

      if (weekEnd >= dateRange.startDate && weekStart <= dateRange.endDate) {
        const label = `${weekStart.toLocaleDateString("en-US", { month: "short", day: "numeric" })} - ${weekEnd.toLocaleDateString("en-US", { month: "short", day: "numeric" })}`;

        weeklyPeriods.push({
          start: weekStart,
          end: weekEnd,
          label,
        });
      }

      currentWeekStart.setDate(currentWeekStart.getDate() + 7);
    }

    const weeklyStats: WeeklyStats[] = weeklyPeriods.map((period) => {
      const weekExperiments = allExperiments.filter((exp) => {
        if (exp.owner !== userId) return false;
        if (!exp.phases?.length) return false;

        const endDate = new Date(exp.phases[0].dateEnded);

        return (
          endDate >= period.start &&
          endDate <= period.end &&
          endDate >= dateRange.startDate &&
          endDate <= dateRange.endDate
        );
      });

      const weekExperimentsLaunched = allExperiments.filter((exp) => {
        if (exp.owner !== userId) return false;
        if (!exp.phases?.length) return false;

        const startDate = new Date(exp.phases[0].dateStarted);
        return (
          startDate >= period.start &&
          startDate <= period.end &&
          startDate >= dateRange.startDate &&
          startDate <= dateRange.endDate
        );
      });

      const stats = { won: 0, lost: 0, dnf: 0, inconclusive: 0 };

      weekExperiments.forEach((exp) => {
        const status = exp.resultSummary?.status || "inconclusive";
        stats[status as keyof typeof stats]++;
      });

      const totalExperiments = weekExperiments.length;
      const totalExperimentsLaunched = weekExperimentsLaunched.length;
      const winRate = totalExperiments > 0 ? (stats.won / totalExperiments) * 100 : 0;
      const significantWinRate = stats.won > 0 ? (stats.won / (stats.won + stats.lost)) * 100 : 0;

      return {
        weekLabel: period.label,
        totalExperiments,
        totalExperimentsLaunched,
        won: stats.won,
        lost: stats.lost,
        dnf: stats.dnf,
        inconclusive: stats.inconclusive,
        winRate,
        significantWinRate,
      };
    });

    const overallStats = await fetchUserExperimentStats(apiKey, userId, dateRange);

    return {
      userId,
      weeklyStats,
      overallStats,
    };
  } catch (error) {
    console.error(chalk.red("Error fetching weekly stats:"), error);
    throw new Error("Failed to fetch weekly experiment data from GrowthBook API");
  }
}

export function findUserIdByName(userName: string): string | null {
  const lowerName = userName.toLowerCase();
  for (const users of Object.values(USER_ID_MAP)) {
    for (const [name, id] of Object.entries(users)) {
      if (name.toLowerCase() === lowerName) {
        return id;
      }
    }
  }
  return null;
}

export function findUserName(userId: string): string {
  for (const users of Object.values(USER_ID_MAP)) {
    for (const [name, id] of Object.entries(users)) {
      if (id === userId) {
        return name;
      }
    }
  }
  return "Unknown User";
}
