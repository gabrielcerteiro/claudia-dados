#!/usr/bin/env node

const imoveis = [
  {
    nome: "CASA RESSACADA",
    slug: "casa-ressacada",
    exclusividade_id: "7b29c9e1-fe78-4b18-a35e-4e7a7e925dc3",
    filtros: { total_leads: 7413, total_visitas: 7414, total_propostas: 7415, leads_abertos: 7416, leads_perdidos: 7417, leads_meta_ads: 7418, leads_google_ads: 7419, leads_indicacao: 7420, leads_corretor_parc: 7421 }
  },
  {
    nome: "SOHO 1102",
    slug: "soho-1102",
    exclusividade_id: "f0a87fdd-301f-453a-95bf-18f965f7000e",
    filtros: { total_leads: 7404, total_visitas: 7405, total_propostas: 7406, leads_abertos: 7407, leads_perdidos: 7408, leads_meta_ads: 7409, leads_google_ads: 7410, leads_indicacao: 7411, leads_corretor_parc: 7412 }
  },
  {
    nome: "MARECHIARO 402",
    slug: "marechiaro-402",
    exclusividade_id: "dfd39601-83ba-409d-a290-5a5cf93f48be",
    filtros: { total_leads: 7422, total_visitas: 7423, total_propostas: 7424, leads_abertos: 7425, leads_perdidos: 7426, leads_meta_ads: 7427, leads_google_ads: 7428, leads_indicacao: 7429, leads_corretor_parc: 7430 }
  },
  {
    nome: "CEZANNE 1701",
    slug: "cezanne-1701",
    exclusividade_id: "01d13be3-3021-439d-9f29-d91abf1b406b",
    filtros: { total_leads: 7395, total_visitas: 7396, total_propostas: 7397, leads_abertos: 7398, leads_perdidos: 7399, leads_meta_ads: 7400, leads_google_ads: 7401, leads_indicacao: 7402, leads_corretor_parc: 7403 }
  },
  {
    nome: "SUN COAST 1601",
    slug: "suncoast-1601",
    exclusividade_id: "91b794ef-1b99-454a-a533-d7c86f1b5261",
    filtros: { total_leads: 7386, total_visitas: 7387, total_propostas: 7388, leads_abertos: 7389, leads_perdidos: 7390, leads_meta_ads: 7391, leads_google_ads: 7392, leads_indicacao: 7393, leads_corretor_parc: 7394 }
  }
];

const campos = [
  "total_leads", "total_visitas", "total_propostas",
  "leads_abertos", "leads_perdidos",
  "leads_meta_ads", "leads_google_ads", "leads_indicacao", "leads_corretor_parc"
];

const nodes = [];
const connections = {};

// Base positions
const startX = 736;
const startY = -736;
const rowHeight = 200; // vertical spacing between blocks

let blockIndex = 0;

for (const imovel of imoveis) {
  for (const campo of campos) {
    const filterId = imovel.filtros[campo];
    const y = startY + (blockIndex * rowHeight);
    
    const pipedriveName = `${imovel.slug} | ${campo}`;
    const codeName = `Code ${blockIndex + 1}`;
    const supabaseName = `Update ${blockIndex + 1}`;
    
    // Node 1: Pipedrive getAll
    nodes.push({
      parameters: {
        operation: "getAll",
        filters: {
          filter_id: `=${filterId}`
        }
      },
      type: "n8n-nodes-base.pipedrive",
      typeVersion: 1,
      position: [startX, y],
      name: pipedriveName,
      credentials: {
        pipedriveApi: {
          id: "ymGXyxMyepVp84ks",
          name: "Pipedrive account"
        }
      }
    });
    
    // Node 2: Code
    nodes.push({
      parameters: {
        jsCode: `const deals = items.map(i => i.json);\nreturn [{ json: { total_leads: deals.length } }];`
      },
      type: "n8n-nodes-base.code",
      typeVersion: 2,
      position: [startX + 208, y],
      name: codeName
    });
    
    // Node 3: Supabase Update
    nodes.push({
      parameters: {
        operation: "update",
        tableId: "funil_snapshot",
        filters: {
          conditions: [
            {
              keyName: "exclusividade_id",
              condition: "eq",
              keyValue: imovel.exclusividade_id
            }
          ]
        },
        fieldsUi: {
          fieldValues: [
            {
              fieldId: campo,
              fieldValue: "={{ $json.total_leads }}"
            }
          ]
        }
      },
      type: "n8n-nodes-base.supabase",
      typeVersion: 1,
      position: [startX + 416, y],
      name: supabaseName,
      credentials: {
        supabaseApi: {
          id: "vBHJ2WcKv2fSDRev",
          name: "Supabase Dashboard"
        }
      }
    });
    
    // Connections
    connections[pipedriveName] = {
      main: [[{ node: codeName, type: "main", index: 0 }]]
    };
    connections[codeName] = {
      main: [[{ node: supabaseName, type: "main", index: 0 }]]
    };
    
    blockIndex++;
  }
}

// Add Schedule Trigger
nodes.unshift({
  parameters: {
    rule: {
      interval: [{ field: "days", triggerAtHour: 0, triggerAtMinute: 0 }]
    }
  },
  type: "n8n-nodes-base.scheduleTrigger",
  typeVersion: 1.3,
  position: [400, startY + (22 * rowHeight)], // middle-ish
  name: "Schedule Trigger"
});

// Connect Schedule Trigger to ALL first Pipedrive nodes
const triggerOutputs = [];
for (let i = 0; i < 45; i++) {
  const campo = campos[i % 9];
  const imovel = imoveis[Math.floor(i / 9)];
  triggerOutputs.push({ node: `${imovel.slug} | ${campo}`, type: "main", index: 0 });
}
connections["Schedule Trigger"] = {
  main: [triggerOutputs]
};

const workflow = {
  nodes,
  connections,
  settings: { executionOrder: "v1" }
};

console.log(JSON.stringify(workflow));
