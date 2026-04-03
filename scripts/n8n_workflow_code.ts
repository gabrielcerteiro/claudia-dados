import { defineTriggerNode, defineNode, defineWorkflow } from 'n8n-workflow-builder';

// Imóveis com seus filter IDs e exclusividade_ids
const IMOVEIS = [
  {
    slug: "suncoast-1601",
    exclusividade_id: null, // ainda não cadastrado
    filtros: { total_leads: 7386, total_visitas: 7387, total_propostas: 7388, leads_abertos: 7389, leads_perdidos: 7390, leads_meta_ads: 7391, leads_google_ads: 7392, leads_indicacao: 7393, leads_corretor_parc: 7394 }
  },
  {
    slug: "cezanne-1701",
    exclusividade_id: "01d13be3-3021-439d-9f29-d91abf1b406b",
    filtros: { total_leads: 7395, total_visitas: 7396, total_propostas: 7397, leads_abertos: 7398, leads_perdidos: 7399, leads_meta_ads: 7400, leads_google_ads: 7401, leads_indicacao: 7402, leads_corretor_parc: 7403 }
  },
  {
    slug: "soho-1102",
    exclusividade_id: "f0a87fdd-301f-453a-95bf-18f965f7000e",
    filtros: { total_leads: 7404, total_visitas: 7405, total_propostas: 7406, leads_abertos: 7407, leads_perdidos: 7408, leads_meta_ads: 7409, leads_google_ads: 7410, leads_indicacao: 7411, leads_corretor_parc: 7412 }
  },
  {
    slug: "casa-ressacada",
    exclusividade_id: "7b29c9e1-fe78-4b18-a35e-4e7a7e925dc3",
    filtros: { total_leads: 7413, total_visitas: 7414, total_propostas: 7415, leads_abertos: 7416, leads_perdidos: 7417, leads_meta_ads: 7418, leads_google_ads: 7419, leads_indicacao: 7420, leads_corretor_parc: 7421 }
  },
  {
    slug: "marechiaro-402",
    exclusividade_id: "dfd39601-83ba-409d-a290-5a5cf93f48be",
    filtros: { total_leads: 7422, total_visitas: 7423, total_propostas: 7424, leads_abertos: 7425, leads_perdidos: 7426, leads_meta_ads: 7427, leads_google_ads: 7428, leads_indicacao: 7429, leads_corretor_parc: 7430 }
  }
];

export default defineWorkflow({
  name: "Sync Pipedrive → Supabase (funil_snapshot)",
  nodes: [
    defineTriggerNode({
      name: "Schedule Trigger",
      type: "n8n-nodes-base.scheduleTrigger",
      version: 1.3,
      config: {
        rule: {
          interval: [{
            field: "days",
            daysInterval: 1,
            triggerAtHour: 0,
            triggerAtMinute: 0
          }]
        }
      },
      position: [0, 0]
    }),

    defineNode({
      name: "Gerar Items por Filtro",
      type: "n8n-nodes-base.code",
      version: 2,
      config: {
        mode: "runOnceForAllItems",
        language: "javaScript",
        jsCode: `
const imoveis = ${JSON.stringify(IMOVEIS)};

const items = [];
for (const imovel of imoveis) {
  if (!imovel.exclusividade_id) continue;
  for (const [campo, filterId] of Object.entries(imovel.filtros)) {
    items.push({
      json: {
        slug: imovel.slug,
        exclusividade_id: imovel.exclusividade_id,
        campo: campo,
        filter_id: filterId
      }
    });
  }
}
return items;
`
      },
      position: [220, 0]
    }),

    defineNode({
      name: "Pipedrive - Get Filter Count",
      type: "n8n-nodes-base.httpRequest",
      version: 4.4,
      config: {
        method: "GET",
        url: '={{ "https://api.pipedrive.com/v1/deals?filter_id=" + $json.filter_id + "&limit=1" }}',
        authentication: "predefinedCredentialType",
        nodeCredentialType: "pipedriveApi",
        options: {
          batching: {
            batch: {
              batchSize: 5,
              batchInterval: 1000
            }
          }
        }
      },
      position: [440, 0]
    }),

    defineNode({
      name: "Extrair total_count",
      type: "n8n-nodes-base.code",
      version: 2,
      config: {
        mode: "runOnceForEachItem",
        language: "javaScript",
        jsCode: `
const inputItem = $input.item.json;
const totalCount = inputItem.additional_data?.pagination?.total_count ?? 0;
return {
  json: {
    slug: $('Gerar Items por Filtro').item.json.slug,
    exclusividade_id: $('Gerar Items por Filtro').item.json.exclusividade_id,
    campo: $('Gerar Items por Filtro').item.json.campo,
    total_count: totalCount
  }
};
`
      },
      position: [660, 0]
    }),

    defineNode({
      name: "Agregar por Imóvel",
      type: "n8n-nodes-base.code",
      version: 2,
      config: {
        mode: "runOnceForAllItems",
        language: "javaScript",
        jsCode: `
const items = $input.all();
const grouped = {};

for (const item of items) {
  const { exclusividade_id, campo, total_count } = item.json;
  if (!grouped[exclusividade_id]) {
    grouped[exclusividade_id] = {
      exclusividade_id: exclusividade_id,
      atualizado_em: new Date().toISOString(),
      fonte: "pipedrive_n8n"
    };
  }
  grouped[exclusividade_id][campo] = total_count;
}

return Object.values(grouped).map(obj => ({ json: obj }));
`
      },
      position: [880, 0]
    }),

    defineNode({
      name: "Supabase Upsert",
      type: "n8n-nodes-base.httpRequest",
      version: 4.4,
      config: {
        method: "POST",
        url: "https://vtykzralkxlbqqkleofl.supabase.co/rest/v1/funil_snapshot",
        authentication: "predefinedCredentialType",
        nodeCredentialType: "supabaseApi",
        sendHeaders: true,
        specifyHeaders: "keypair",
        headerParameters: {
          parameters: [
            { name: "Prefer", value: "resolution=merge-duplicates" },
            { name: "Content-Type", value: "application/json" }
          ]
        },
        sendQuery: true,
        specifyQuery: "keypair",
        queryParameters: {
          parameters: [
            { name: "on_conflict", value: "exclusividade_id" }
          ]
        },
        sendBody: true,
        contentType: "json",
        specifyBody: "json",
        jsonBody: "={{ JSON.stringify($json) }}"
      },
      position: [1100, 0]
    })
  ],

  connections: {
    "Schedule Trigger": { main: [[{ node: "Gerar Items por Filtro" }]] },
    "Gerar Items por Filtro": { main: [[{ node: "Pipedrive - Get Filter Count" }]] },
    "Pipedrive - Get Filter Count": { main: [[{ node: "Extrair total_count" }]] },
    "Extrair total_count": { main: [[{ node: "Agregar por Imóvel" }]] },
    "Agregar por Imóvel": { main: [[{ node: "Supabase Upsert" }]] }
  }
});
