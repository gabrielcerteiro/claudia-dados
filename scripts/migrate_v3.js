#!/usr/bin/env node
const https = require('https');

const API_TOKEN = '9fdbe8a6df3bd98c083298d7287aa1844c0ae14b';
const CAMPANHA_KEY = 'ddd851a1bd147d41c448c8358c16a49d66ba5702';
const IMOVEL_KEY = '3e0a04f3b16e50b6843a0ce7ae1e76204c630ba3';

function apiCall(method, path, body = null) {
  return new Promise((resolve, reject) => {
    const url = `https://api.pipedrive.com/v1${path}${path.includes('?') ? '&' : '?'}api_token=${API_TOKEN}`;
    const parsed = new URL(url);
    const opts = { hostname: parsed.hostname, path: parsed.pathname + parsed.search, method, headers: { 'Content-Type': 'application/json' } };
    const req = https.request(opts, res => {
      let data = '';
      res.on('data', c => data += c);
      res.on('end', () => { try { resolve(JSON.parse(data)); } catch(e) { resolve({ success: false, error: data }); } });
    });
    req.on('error', reject);
    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

async function main() {
  // Step 1: Collect all deals
  console.log('=== Coletando deals ===');
  let allDeals = [];
  let start = 0;
  while (true) {
    const res = await apiCall('GET', `/deals?status=all_not_deleted&start=${start}&limit=500`);
    if (res.data) allDeals = allDeals.concat(res.data);
    if (!res.additional_data?.pagination?.more_items_in_collection) break;
    start = res.additional_data.pagination.next_start;
    console.log(`  Coletados: ${allDeals.length}...`);
  }
  console.log(`Total: ${allDeals.length} deals`);

  // Step 2: Filter deals that need update
  const toUpdate = allDeals.filter(d => d[CAMPANHA_KEY] || d[IMOVEL_KEY]);
  console.log(`Deals a atualizar: ${toUpdate.length}`);

  // Check which already had updates from batch 1 (deals < 52541 should be ok from previous run)
  // We'll just do all of them - idempotent operation

  let success = 0, failed = 0, skipped = 0;
  for (let i = 0; i < toUpdate.length; i++) {
    const deal = toUpdate[i];
    const body = {};
    if (deal[CAMPANHA_KEY]) body.channel_id = String(deal[CAMPANHA_KEY]);
    if (deal[IMOVEL_KEY]) body.product_name = String(deal[IMOVEL_KEY]);

    if (Object.keys(body).length === 0) { skipped++; continue; }

    const res = await apiCall('PUT', `/deals/${deal.id}`, body);
    if (res.success) {
      success++;
    } else {
      console.log(`❌ Deal ${deal.id}: ${res.error}`);
      failed++;
    }

    if ((i + 1) % 200 === 0) {
      console.log(`  Progresso: ${i + 1} / ${toUpdate.length} (✅ ${success} ❌ ${failed})`);
    }
    await sleep(50);
  }

  console.log('');
  console.log('=== RESULTADO ===');
  console.log(`✅ Atualizados: ${success}`);
  console.log(`⏭ Sem dados: ${skipped}`);
  console.log(`❌ Falhas: ${failed}`);
  console.log(`Total: ${success + failed + skipped} / ${toUpdate.length}`);
}

main().catch(console.error);
