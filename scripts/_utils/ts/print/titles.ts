import { RED, GREEN, YELLOW, BLUE, CYAN, WHITE, NC } from "./colors";

const BORDER_LINE_THICK = "================================================";
const BORDER_LINE = "--------------------------------";
const NEW_LINE = "\n";

export let QUIET = false;

export function setQuiet(v: boolean) {
  QUIET = v;
}

export function printBorder(type?: "thick" | "thin") {
  if (QUIET) return;
  if (type === "thick") {
    console.log(BORDER_LINE_THICK);
  } else {
    console.log(BORDER_LINE);
  }
}

export function printNewLine() {
  if (QUIET) return;
  console.log(NEW_LINE);
}

function resolveColor(color?: string, defaultTo?: string) {
  if (!color) return defaultTo || CYAN;
  switch (color.toUpperCase()) {
    case "RED":
      return RED;
    case "GREEN":
      return GREEN;
    case "YELLOW":
      return YELLOW;
    case "BLUE":
      return BLUE;
    case "WHITE":
      return WHITE;
    case "CYAN":
      return CYAN;
    default:
      return defaultTo || CYAN;
  }
}

export function printTitle(text: string, color?: string) {
  if (QUIET) return;
  printBorder("thick");
  const clr = resolveColor(color, CYAN);
  console.log(`${clr}${text}${NC}`);
  printBorder("thick");
}

export function printSubtitle(text: string, color?: string) {
  if (QUIET) return;
  printBorder();
  const clr = resolveColor(color, BLUE);
  console.log(`${clr}${text}${NC}`);
  printBorder();
}
