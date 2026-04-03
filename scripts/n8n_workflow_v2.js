const imoveis = [
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

// suncoast-1601 omitido por não ter exclusividade_id ainda

const workflow = {
  name: "Sync Pipedrive → Supabase (funil_snapshot)",
  nodes: [
    {
      parameters: {
        rule: {
          interval: [{
            field: "days",
            triggerAtHour: 0,
            triggerAtMinute: 0
          }]
        }
      },
      type: "n8n-nodes-base.scheduleTrigger",
      typeVersion: 1.3,
      position: [0, 0],
      name: "Schedule Trigger"
    },
    {
      parameters: {
        mode: "runOnceForAllItems",
        language: "javaScript",
        jsCode: `const imoveis = ${JSON.stringify(imoveis)};

const items = [];
for (const imovel of imoveis) {
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
return items;`
      },
      type: "n8n-nodes-base.code",
      typeVersion: 2,
      position: [250, 0],
      name: "Gerar Items por Filtro"
    },
    {
      parameters: {
        options: {}
      },
      type: "n8n-nodes-base.splitInBatches",
      typeVersion: 3,
      position: [500, 0],
      name: "Loop Over Items"
    },
    {
      parameters: {
        method: "GET",
        url: "=https://api.pipedrive.com/v1/deals?filter_id={{ $json.filter_id }}&limit=1",
        authentication: "predefinedCredentialType",
        nodeCredentialType: "pipedriveApi",
        options: {}
      },
      type: "n8n-nodes-base.httpRequest",
      typeVersion: 4.4,
      position: [750, 200],
      name: "Pipedrive GET Filter"
    },
    {
      parameters: {
        mode: "runOnceForEachItem",
        language: "javaScript",
        jsCode: `const totalCount = $json.additional_data?.pagination?.total_count ?? 0;
const prev = $('Loop Over Items').item.json;
return {
  json: {
    slug: prev.slug,
    exclusividade_id: prev.exclusividade_id,
    campo: prev.campo,
    filter_id: prev.filter_id,
    total_count: totalCount
  }
};`
      },
      type: "n8n-nodes-base.code",
      typeVersion: 2,
      position: [1000, 200],
      name: "Extrair Count"
    },
    {
      parameters: {
        mode: "runOnceForAllItems",
        language: "javaScript",
        jsCode: `const items = $input.all();
const grouped = {};

for (const item of items) {
  const { exclusividade_id, campo, total_count } = item.json;
  if (!grouped[exclusividade_id]) {
    grouped[exclusividade_id] = {
      exclusividade_id,
      atualizado_em: new Date().toISOString(),
      fonte: "pipedrive_n8n"
    };
  }
  grouped[exclusividade_id][campo] = total_count;
}

return Object.values(grouped).map(obj => ({ json: obj }));`
      },
      type: "n8n-nodes-base.code",
      typeVersion: 2,
      position: [1250, 0],
      name: "Agregar por Imóvel"
    },
    {
      parameters: {
        options: {}
      },
      type: "n8n-nodes-base.splitInBatches",
      typeVersion: 3,
      position: [1500, 0],
      name: "Loop Upsert"
    },
    {
      parameters: {
        method: "POST",
        url: "https://vtykzralkxlbqqkleofl.supabase.co/rest/v1/funil_snapshot",
        authentication: "predefinedCredentialType",
        nodeCredentialType: "supabaseApi",
        sendHeaders: true,
        headerParameters: {
          parameters: [
            { name: "Prefer", value: "resolution=merge-duplicates" },
            { name: "Content-Type", value: "application/json" }
          ]
        },
        sendQuery: true,
        queryParameters: {
          parameters: [
            { name: "on_conflict", value: "exclusividade_id" }
          ]
        },
        sendBody: true,
        contentType: "json",
        specifyBody: "json",
        jsonBody: "={{ JSON.stringify($json) }}",
        options: {}
      },
      type: "n8n-nodes-base.httpRequest",
      typeVersion: 4.4,
      position: [1750, 200],
      name: "Supabase Upsert"
    }
  ],
  connections: {
    "Schedule Trigger": { main: [[{ node: "Gerar Items por Filtro", type: "main", index: 0 }]] },
    "Gerar Items por Filtro": { main: [[{ node: "Loop Over Items", type: "main", index: 0 }]] },
    "Loop Over Items": { main: [[], [{ node: "Pipedrive GET Filter", type: "main", index: 0 }]] },
    "Pipedrive GET Filter": { main: [[{ node: "Extrair Count", type: "main", index: 0 }]] },
    "Extrair Count": { main: [[{ node: "Loop Over Items", type: "main", index: 0 }]] },
    "Agregar por Imóvel": { main: [[{ node: "Loop Upsert", type: "main", index: 0 }]] },
    "Loop Upsert": { main: [[], [{ node: "Supabase Upsert", type: "main", index: 0 }]] },
    "Supabase Upsert": { main: [[{ node: "Loop Upsert", type: "main", index: 0 }]] }
  }
};
