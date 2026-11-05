// Postcrate mark: single source of truth for every logo and icon asset.
// Run: node design/logo/generate.mjs  ->  writes SVGs into design/logo/out/
//
// Construction (24-unit grid), logo P1 "Orbit flight":
//   Orbit  ring centered at (12, 12), radius 8.5, stroke 2.5
//   Plane  dart M0 0 L11 4.5 L0 9 L2.6 4.5 Z (stroke 1.2, round joins),
//          scaled 0.78, centered on the ring at -45 degrees and rotated
//          +45 degrees so it flies clockwise along the orbit
//   Gap    the ring is an open arc whose round ends stop 1.5 units from the
//          plane's nose and wing
//   App icon tiles use superellipse corners (n = 5).

import { mkdirSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const N = 5;
const STEPS = 32;
const GAP = 1.5;

const INK = '#111111';
const PAPER = '#F2F2F2';
const ICON_BG_LIGHT = '#F4F4F4';
const ICON_BG_DARK = '#141414';

const fmt = (v) => Number(v.toFixed(3)).toString();

// Rounded rectangle with superellipse corners. r = [topLeft, topRight, bottomRight, bottomLeft].
export function squircleRect(x, y, w, h, r, n = N) {
  const e = 2 / n;
  const q = (v) => Math.pow(Math.abs(v), e);
  const pts = [];
  const sweep = (fn) => {
    for (let i = 0; i <= STEPS; i++) pts.push(fn((i / STEPS) * (Math.PI / 2)));
  };
  sweep((t) => [x + r[0] - r[0] * q(Math.cos(t)), y + r[0] - r[0] * q(Math.sin(t))]);
  sweep((t) => [x + w - r[1] + r[1] * q(Math.sin(t)), y + r[1] - r[1] * q(Math.cos(t))]);
  sweep((t) => [x + w - r[2] + r[2] * q(Math.cos(t)), y + h - r[2] + r[2] * q(Math.sin(t))]);
  sweep((t) => [x + r[3] - r[3] * q(Math.sin(t)), y + h - r[3] + r[3] * q(Math.cos(t))]);
  return 'M' + pts.map(([px, py]) => `${fmt(px)} ${fmt(py)}`).join('L') + 'Z';
}

const ORBIT_R = 8.5;
const ORBIT_W = 2.5;
const PLANE_SCALE = 0.78;
const PLANE_STROKE = 1.2;
const PLANE_ANGLE = -45; // where the plane sits on the orbit, degrees
export const PLANE = 'M0 0L11 4.5L0 9L2.6 4.5Z';

const rad = (d) => (d * Math.PI) / 180;
const PLANE_X = 12 + ORBIT_R * Math.cos(rad(PLANE_ANGLE));
const PLANE_Y = 12 + ORBIT_R * Math.sin(rad(PLANE_ANGLE));
export const PLANE_TRANSFORM = `translate(${fmt(PLANE_X)} ${fmt(PLANE_Y)}) rotate(45) scale(${PLANE_SCALE}) translate(-5.5 -4.5)`;

// The ring is an open arc. Each round end stops exactly GAP units from the
// plane's outline (including its stroke), solved numerically below.
const planePoints = (() => {
  const local = [[0, 0], [11, 4.5], [0, 9], [2.6, 4.5]];
  const c = Math.cos(rad(45)), s = Math.sin(rad(45));
  return local.map(([x, y]) => {
    const lx = (x - 5.5) * PLANE_SCALE, ly = (y - 4.5) * PLANE_SCALE;
    return [PLANE_X + lx * c - ly * s, PLANE_Y + lx * s + ly * c];
  });
})();
const distToPlane = ([px, py]) => {
  let best = Infinity;
  for (let k = 0; k < planePoints.length; k++) {
    const [ax, ay] = planePoints[k], [bx, by] = planePoints[(k + 1) % planePoints.length];
    const t = Math.max(0, Math.min(1, ((px - ax) * (bx - ax) + (py - ay) * (by - ay)) / ((bx - ax) ** 2 + (by - ay) ** 2)));
    best = Math.min(best, Math.hypot(px - (ax + t * (bx - ax)), py - (ay + t * (by - ay))));
  }
  return best;
};
const CLEARANCE = GAP + ORBIT_W / 2 + (PLANE_STROKE * PLANE_SCALE) / 2;
const onOrbit = (d) => [12 + ORBIT_R * Math.cos(rad(d)), 12 + ORBIT_R * Math.sin(rad(d))];
const solveEnd = (from, step) => {
  let d = from;
  while (distToPlane(onOrbit(d)) < CLEARANCE) d += step;
  return d;
};
export const ARC_START = solveEnd(PLANE_ANGLE, 0.05); // after the nose, clockwise
export const ARC_END = solveEnd(PLANE_ANGLE, -0.05) + 360; // before the wing
const point = (d) => `${fmt(12 + ORBIT_R * Math.cos(rad(d)))} ${fmt(12 + ORBIT_R * Math.sin(rad(d)))}`;
export const ORBIT_ARC = `M${point(ARC_START)}A${ORBIT_R} ${ORBIT_R} 0 1 1 ${point(ARC_END)}`;

// The mark as SVG elements in 24-unit space; the gap is real empty space.
function markElements(fill) {
  return [
    `<path d="${ORBIT_ARC}" fill="none" stroke="${fill}" stroke-width="${ORBIT_W}" stroke-linecap="round"/>`,
    `<path d="${PLANE}" transform="${PLANE_TRANSFORM}" fill="${fill}" stroke="${fill}" stroke-width="${PLANE_STROKE}" stroke-linejoin="round"/>`,
  ].join('');
}

const svg = (size, viewBox, body) =>
  `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="${viewBox}">${body}</svg>\n`;

// Mark centered in a square canvas of `canvas` units, occupying `ratio` of it.
function placedMark(canvas, ratio, fill) {
  const s = (canvas * ratio) / 24;
  const o = (canvas - canvas * ratio) / 2;
  return `<g transform="translate(${fmt(o)} ${fmt(o)}) scale(${fmt(s)})">${markElements(fill)}</g>`;
}

const ICON_MARK_RATIO = 0.6; // mark spans 60% of the app icon
const ADAPTIVE_MARK_RATIO = 0.4; // 40% of the 108dp Android adaptive canvas, inside the 66dp safe zone
const ICON_CORNER = 0.2237; // iOS app icon corner ratio, used for preview masks only

const files = {
  'mark-template.svg': svg(24, '0 0 24 24', markElements('currentColor')),
  'mark-ink.svg': svg(24, '0 0 24 24', markElements(INK)),
  'mark-paper.svg': svg(24, '0 0 24 24', markElements(PAPER)),

  // Full-bleed squares for platform export (iOS and macOS apply their own mask).
  'app-icon-light-1024.svg': svg(1024, '0 0 1024 1024',
    `<rect width="1024" height="1024" fill="${ICON_BG_LIGHT}"/>` + placedMark(1024, ICON_MARK_RATIO, INK)),
  'app-icon-dark-1024.svg': svg(1024, '0 0 1024 1024',
    `<rect width="1024" height="1024" fill="${ICON_BG_DARK}"/>` + placedMark(1024, ICON_MARK_RATIO, PAPER)),

  // Squircle-masked versions for previews, stores and docs.
  'app-icon-light-preview.svg': svg(1024, '0 0 1024 1024',
    `<path d="${squircleRect(0, 0, 1024, 1024, Array(4).fill(1024 * ICON_CORNER))}" fill="${ICON_BG_LIGHT}"/>` +
      placedMark(1024, ICON_MARK_RATIO, INK)),
  'app-icon-dark-preview.svg': svg(1024, '0 0 1024 1024',
    `<path d="${squircleRect(0, 0, 1024, 1024, Array(4).fill(1024 * ICON_CORNER))}" fill="${ICON_BG_DARK}"/>` +
      placedMark(1024, ICON_MARK_RATIO, PAPER)),

  // Android adaptive icon layers (108 x 108).
  'android-adaptive-foreground.svg': svg(108, '0 0 108 108', placedMark(108, ADAPTIVE_MARK_RATIO, INK)),
  'android-adaptive-foreground-dark.svg': svg(108, '0 0 108 108', placedMark(108, ADAPTIVE_MARK_RATIO, PAPER)),
  'android-monochrome.svg': svg(108, '0 0 108 108', placedMark(108, ADAPTIVE_MARK_RATIO, '#000000')),

  'construction.svg': construction(),
};

function construction() {
  const lines = [];
  for (let i = 0; i <= 24; i++) {
    const w = i % 6 === 0 ? 0.06 : 0.025;
    lines.push(`<path d="M${i} 0V24M0 ${i}H24" stroke="#111111" stroke-opacity=".22" stroke-width="${w}"/>`);
  }
    const label = (x, y, t) => `<text x="${x}" y="${y}" font-family="-apple-system, system-ui, sans-serif" font-size=".7" fill="#4A4A4A">${t}</text>`;
  return svg(720, '-2 -2 28 30', [
    `<rect x="-2" y="-2" width="28" height="30" fill="#FFFFFF"/>`,
    ...lines,
    markElements(INK),
    `<circle cx="12" cy="12" r="${ORBIT_R}" fill="none" stroke="#C0392B" stroke-width=".07" stroke-dasharray=".3 .3"/>`,
    `<path d="M12 12L${fmt(PLANE_X)} ${fmt(PLANE_Y)}" stroke="#C0392B" stroke-width=".07" stroke-dasharray=".3 .3"/>`,
    label(0, 25.3, 'Grid 24 · orbit r 8.5 at 12,12, stroke 2.5 · plane on the orbit at -45°'),
    label(0, 26.4, 'Plane dart 11×9, scale 0.78, rotated +45° · gap 1.5 · icon corners n = 5'),
  ].join(''));
}

const outDir = join(dirname(fileURLToPath(import.meta.url)), 'out');
mkdirSync(outDir, { recursive: true });
for (const [name, content] of Object.entries(files)) writeFileSync(join(outDir, name), content);
console.log(`Wrote ${Object.keys(files).length} files to ${outDir}`);
