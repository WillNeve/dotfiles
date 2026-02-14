export const USER_ID_MAP: Record<string, Record<string, string>> = {
  Growth: {
    Ben: "u_19g621mcaxmgzb",
    Kameron: "u_19g623mcaklgls",
    James: "u_19g622mesejy4f",
    Will: "u_19g623mdd3rku5",
  },
  Product: {
    Aaron: "u_19g62amcd7k4ip",
    Joey: "u_19g621mclywvpv",
    Serafin: "u_19g622mclyfvcu",
  },
  Data: {
    Marco: "u_19g62cmcae6htg",
  },
};

export interface ExperimentData {
  name: string;
  id: string;
  status: "won" | "lost" | "dnf" | "inconclusive";
}

export interface UserExperimentStats {
  userId: string;
  totalExperiments: number;
  totalExperimentsLaunched: number;
  won: number;
  lost: number;
  dnf: number;
  inconclusive: number;
  winRate: number;
  significantWinRate: number;
  experimentsPerWeek?: number;
  experiments?: ExperimentData[];
}

export interface WeeklyStats {
  weekLabel: string;
  totalExperiments: number;
  totalExperimentsLaunched: number;
  won: number;
  lost: number;
  dnf: number;
  inconclusive: number;
  winRate: number;
  significantWinRate: number;
}

export interface WeeklyUserStats {
  userId: string;
  weeklyStats: WeeklyStats[];
  overallStats: UserExperimentStats;
}

export interface GrowthBookExperiment {
  id: string;
  name: string;
  owner: string;
  resultSummary: {
    status: "won" | "lost" | "dnf" | "inconclusive";
  };
  phases: Array<{
    dateStarted: string;
    dateEnded: string;
  }>;
}

export interface ExperimentsResponse {
  experiments: GrowthBookExperiment[];
  hasMore: boolean;
  nextOffset: number;
}

export interface CommandFlags {
  user?: string;
  startDate?: string;
  endDate?: string;
  weekly?: boolean;
  table?: boolean;
  help?: boolean;
}

export interface UserOption {
  name: string;
  userId: string;
  team: string;
}
