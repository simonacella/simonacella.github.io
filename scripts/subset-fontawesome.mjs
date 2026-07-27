#!/usr/bin/env node
/**
 * Rebuild the self-hosted Font Awesome Free subset used on this site.
 *
 * Requires Node + npm once:
 *   cd /tmp && mkdir fa-subset && cd fa-subset
 *   npm init -y && npm install @fortawesome/fontawesome-free@7 fontawesome-subset
 * Or run from a throwaway dir that already has those packages.
 *
 * Usage (from repo root, with packages available via NODE_PATH or local node_modules):
 *   node scripts/subset-fontawesome.mjs
 *
 * Writes:
 *   assets/fonts/font-awesome/webfonts/fa-solid-900.woff2
 *   assets/fonts/font-awesome/webfonts/fa-brands-400.woff2
 *
 * CSS with the matching glyphs lives in
 *   assets/fonts/font-awesome/css/font-awesome.min.css
 * (edit that file if you add/remove icon names below).
 */

import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import fs from 'node:fs';

const require = createRequire(import.meta.url);
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const outDir = path.join(root, 'assets/fonts/font-awesome/webfonts');

const solid = ['bars', 'xmark', 'magnifying-glass', 'angle-left', 'angle-right', 'envelope'];
const brands = ['linkedin', 'github', 'instagram', 'facebook', 'reddit', 'imdb', 'substack'];

let fontawesomeSubset;
try {
  ({ fontawesomeSubset } = require('fontawesome-subset'));
} catch {
  console.error('Install deps first: npm install --no-save @fortawesome/fontawesome-free@7 fontawesome-subset');
  process.exit(1);
}

fs.mkdirSync(outDir, { recursive: true });
await fontawesomeSubset({ solid, brands }, outDir, {
  package: 'free',
  targetFormats: ['woff2']
});

const solidSize = fs.statSync(path.join(outDir, 'fa-solid-900.woff2')).size;
const brandsSize = fs.statSync(path.join(outDir, 'fa-brands-400.woff2')).size;
console.log(`Wrote subset to ${outDir}`);
console.log(`  fa-solid-900.woff2  ${solidSize} bytes`);
console.log(`  fa-brands-400.woff2 ${brandsSize} bytes`);
console.log(`  total fonts        ${solidSize + brandsSize} bytes`);
