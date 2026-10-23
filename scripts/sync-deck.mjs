#!/usr/bin/env node
// Escribe en deck/index.html los pasos y los capítulos que dice guion-slides.md, para que el texto de
// la charla viva en un solo sitio. El diseño de cada slide sigue en deck/index.html.
//
//   node scripts/sync-deck.mjs          reescribe STEPS y CHAPTERS
//   node scripts/sync-deck.mjs --check  sale con 1 si el deck no está al día, sin escribir
//
// Cómo se lee el guion, que es como lo leía Claude Design:
// - "## Título (N min)" es un capítulo; "## Apertura y cierre" agrupa la portada y no cuenta.
// - "### N. Título <!-- ov=nombre [hide] -->" es una slide; ov es su data-ov en el deck, y hide
//   esconde la barra durante una demo.
// - Dentro de una slide, una línea en negrita abre el paso siguiente con ese nombre; si va justo
//   después del título, nombra el primero. [clic] es una pista para quien habla, no un paso. Los
//   bloques de código y las tablas no pasan a las notas.
//
// Falla, sin escribir nada, si una slide del guion no existe en el deck o si sus pasos no coinciden
// con los de su diseño: una slide con data-at hasta N tiene N + 1 pasos. Es la desalineación que
// dejaba el guion por delante de las slides sin que nadie lo viera.

import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const guionPath = root + 'guion-slides.md';
const deckPath = root + 'deck/index.html';
const check = process.argv.includes('--check');

const guion = readFileSync(guionPath, 'utf8');
const deck = readFileSync(deckPath, 'utf8');

const chapters = [];
const slides = [];
let ch = null;
let slide = null;
let fence = false;

for (const raw of guion.split('\n')) {
  const line = raw.trimEnd();
  if (line.startsWith('```')) { fence = !fence; continue; }
  if (fence) continue;

  const chap = line.match(/^## (.+?)(?: \((\d+) min\))?(?:\s*<!--\s*short=(.+?)\s*-->)?$/);
  if (chap) {
    slide = null;
    if (/^Apertura/.test(chap[1])) { ch = -1; continue; }
    ch = chapters.length;
    chapters.push({ long: chap[1].trim(), min: chap[2] ? +chap[2] : 0, short: chap[3] });
    continue;
  }
  const head = line.match(/^### [^ ]+\. (.+?)\s*(?:<!--\s*ov=(\S+)((?:\s+\w+)*)\s*-->)?$/);
  if (head) {
    if (ch === null) fail(`«${head[1]}» está antes del primer capítulo.`);
    if (!head[2]) fail(`«${head[1]}» no dice qué slide del deck es: añade <!-- ov=… --> al título.`);
    slide = { title: head[1], ov: head[2], hide: /\bhide\b/.test(head[3] || ''), ch, steps: [] };
    slide.steps.push({ name: head[1], paras: [], named: false });
    slides.push(slide);
    continue;
  }
  if (!slide) continue;
  if (line.startsWith('|') || line === '---') continue;

  const cur = slide.steps[slide.steps.length - 1];
  const bold = line.match(/^\*\*(.+)\*\*$/);
  if (bold) {
    if (note(cur.paras) === '' && !cur.named) { cur.name = bold[1]; cur.named = true; }
    else slide.steps.push({ name: bold[1], paras: [], named: true });
    continue;
  }
  cur.paras.push(line);
}

const steps = [];
for (const s of slides) {
  s.count = s.steps.length;
  s.steps.forEach((st, at) => {
    const step = { ov: s.ov, name: st.name, ch: s.ch, note: note(st.paras) };
    if (at) step.at = at;
    if (s.hide) step.hide = 1;
    steps.push(step);
  });
}

// Lo que el diseño de cada slide admite: su data-at más alto.
const blocks = [...deck.matchAll(/data-ov="([^"$]+)"/g)];
const maxAt = new Map();
blocks.forEach((m, i) => {
  const end = i + 1 < blocks.length ? blocks[i + 1].index : deck.length;
  const ats = [...deck.slice(m.index, end).matchAll(/data-at="(\d+)"/g)].map(a => +a[1]);
  maxAt.set(m[1], Math.max(maxAt.get(m[1]) ?? 0, ...ats, 0));
});

const problems = [];
for (const s of slides) {
  if (!maxAt.has(s.ov)) { problems.push(`«${s.title}»: el deck no tiene ninguna slide data-ov="${s.ov}".`); continue; }
  const want = maxAt.get(s.ov) + 1;
  if (s.count !== want) problems.push(`«${s.title}» (${s.ov}): el guion tiene ${s.count} pasos y el diseño ${want}.`);
}
if (problems.length) fail(problems.join('\n'));

// El nombre corto de la barra: el que declara el capítulo con <!-- short=… -->, o el que ya tenía en
// el deck el capítulo del mismo título o del mismo número ("02 · …").
const oldChapters = JSON.parse(deck.match(/const CHAPTERS = (\[.*?\]);/)[1].replace(/(\w+):/g, '"$1":').replace(/'/g, '"'));
const num = s => (s.match(/^(\d+) · /) || [])[1];
const newChapters = chapters.map(c => {
  const old = oldChapters.find(o => o.long === c.long) || (num(c.long) && oldChapters.find(o => num(o.long) === num(c.long)));
  const short = c.short || old?.short;
  if (!short) fail(`El capítulo «${c.long}» es nuevo: dale un nombre corto con <!-- short=… --> en su título.`);
  return { short, long: c.long, min: c.min };
});

const stepsJs = 'const STEPS = [\n' + steps.map(s => '  ' + JSON.stringify(s)).join(',\n') + '\n];';
const chaptersJs = 'const CHAPTERS = [' + newChapters.map(c => `{ short: ${q(c.short)}, long: ${q(c.long)}, min: ${c.min} }`).join(', ') + '];';

const next = deck
  .replace(/const STEPS = \[\n[\s\S]*?\n\];/, () => stepsJs)
  .replace(/const CHAPTERS = \[.*?\];/, () => chaptersJs);

if (next === deck) { console.log(`deck al día: ${slides.length} slides, ${steps.length} pasos.`); process.exit(0); }
if (check) { console.error('El deck no está al día con guion-slides.md: node scripts/sync-deck.mjs'); process.exit(1); }
writeFileSync(deckPath, next);
console.log(`deck reescrito: ${slides.length} slides, ${steps.length} pasos, ${chapters.length} capítulos.`);

function note(paras) {
  return paras.join('\n')
    .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1')
    .replace(/\*\*([^*]+)\*\*/g, '$1')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/\n{3,}/g, '\n\n')
    .trim();
}

function q(s) { return "'" + s.replace(/\\/g, '\\\\').replace(/'/g, "\\'") + "'"; }

function fail(msg) { console.error(msg); process.exit(1); }
