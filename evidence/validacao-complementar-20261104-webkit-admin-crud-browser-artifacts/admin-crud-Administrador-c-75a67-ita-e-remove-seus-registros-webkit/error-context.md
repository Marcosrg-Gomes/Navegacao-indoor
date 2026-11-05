# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: admin-crud.spec.ts >> Administrador cadastra um piso navegável, edita e remove seus registros
- Location: tests\admin-crud.spec.ts:3:1

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: getByText('Grafo 100% Íntegro e Conexo', { exact: true })
Expected: visible
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" getByText('Grafo 100% Íntegro e Conexo', { exact: true }) with timeout 5000ms
  - waiting for getByText('Grafo 100% Íntegro e Conexo', { exact: true })

```

```yaml
- complementary:
  - text: Indoor Nav
  - strong: Painel Admin
  - navigation:
    - link "Dashboard":
      - /url: /admin
    - link "Shoppings":
      - /url: /admin/shoppings
    - link "Pisos":
      - /url: /admin/pisos
    - link "Editor de Nós":
      - /url: /admin/nos
    - link "Arestas":
      - /url: /admin/arestas
    - link "Lojas":
      - /url: /admin/lojas
    - link "Categorias":
      - /url: /admin/categorias
    - link "QR Codes":
      - /url: /admin/qr
    - link "Validação":
      - /url: /admin/validacao
  - button "Sair"
- main:
  - heading "Validação de Integridade do Grafo" [level=1]
  - paragraph: Análise automática de nós isolados, arestas inválidas, componentes desconectados e referências órfãs com links para correção.
  - button "↻ Revalidar Agora"
  - text: "Escopo:"
  - combobox:
    - option "Todo o Shopping (Todos os Pisos)" [selected]
    - option "Térreo (Nível 0)"
    - option "Piso superior (Nível 1)"
    - option "Piso webkit-1793755731736 (Nível 0)"
    - option "Piso firefox-1793755733327 (Nível 0)"
  - text: ⚠️
  - 'heading "Atenção: 1 Tipo(s) de Inconsistência Detectado(s)" [level=3]'
  - paragraph: Clique nos links dos elementos abaixo para navegar diretamente à tela de correção.
  - heading "Nós Isolados" [level=3]
  - text: 2 afetado(s)
  - paragraph: Nós navegáveis sem arestas ativas conectadas
  - link "#29 ↗ Corrigir":
    - /url: /admin/nos?id=29
  - link "#30 ↗ Corrigir":
    - /url: /admin/nos?id=30
```

# Test source

```ts
  17  |       (r) => new URL(r.url()).pathname === `/api/admin/${path}` && r.request().method() === method,
  18  |       { timeout: 10000 }
  19  |     );
  20  |     await dialog.getByRole("button", { name: button, exact: true }).click();
  21  |     try {
  22  |       const response = await pending;
  23  |       expect(response.ok(), await response.text()).toBeTruthy();
  24  |       const data = await response.json();
  25  |       if (method === "POST") created.push({ path, id: data.id });
  26  |       await expect(dialog).not.toBeVisible();
  27  |       return data;
  28  |     } catch (error) {
  29  |       throw new Error(`Falha ao salvar ${path} (${method}): ${error.message}`);
  30  |     }
  31  |   }
  32  |   async function remove(path: string, id: number, target: ReturnType<typeof row>) {
  33  |     page.once("dialog", (d) => d.accept());
  34  |     const pending = page.waitForResponse((r) => new URL(r.url()).pathname === `/api/admin/${path}/${id}` && r.request().method() === "DELETE");
  35  |     await target.getByRole("button", { name: "Excluir", exact: true }).click();
  36  |     expect((await pending).status()).toBe(204);
  37  |     if (path === "shoppings") await expect(target).toContainText("Inativo");
  38  |     else await expect(target).toHaveCount(0);
  39  |   }
  40  |   try {
  41  |     await page.goto("/admin/shoppings");
  42  |     await page.getByLabel("API key", { exact: true }).fill("audit-local-only");
  43  |     await page.getByRole("button", { name: "Entrar", exact: true }).click();
  44  |     await page.getByRole("button", { name: "Novo shopping", exact: true }).click();
  45  |     await dialog.getByLabel("Nome", { exact: true }).fill(mallName);
  46  |     const mall = await save("shoppings", "POST", "Salvar");
  47  |     await row(mallName).getByRole("button", { name: "Editar", exact: true }).click();
  48  |     await dialog.getByLabel("Endereço", { exact: true }).fill("Endereço de demonstração");
  49  |     expect((await save(`shoppings/${mall.id}`, "PUT", "Salvar")).endereco).toBe("Endereço de demonstração");
  50  | 
  51  |     await page.goto("/admin/pisos");
  52  |     await page.getByRole("button", { name: "+ Novo Piso", exact: true }).click();
  53  |     await dialog.getByLabel("Shopping Associado", { exact: false }).selectOption(String(mall.id));
  54  |     await dialog.getByLabel("Nome do Piso", { exact: false }).fill(floorName);
  55  |     const floor = await save("floors", "POST", "Criar Piso");
  56  |     await row(floorName).getByRole("button", { name: "Editar", exact: true }).click();
  57  |     await dialog.getByLabel("Largura Real (metros)", { exact: false }).fill("100");
  58  |     await dialog.getByLabel("Altura Real (metros)", { exact: false }).fill("60");
  59  |     await dialog.getByLabel("URL da Imagem da Planta Baixa", { exact: false }).fill("/static/plantas/demo.svg");
  60  |     expect((await save(`floors/${floor.id}`, "PUT", "Salvar Alterações")).imagem_planta_url).toBe("/static/plantas/demo.svg");
  61  | 
  62  |     await page.goto(`/admin/nos?piso=${floor.id}`);
  63  |     const nodes: { id: number; nome: string }[] = [];
  64  |     for (const [name, x] of [["Origem", "0.1"], ["Destino", "0.8"]]) {
  65  |       await page.getByRole("button", { name: "+ Novo Nó Manual", exact: true }).click();
  66  |       await dialog.getByLabel("Nome / Identificação do Local").fill(`${name} ${suffix}`);
  67  |       await dialog.getByLabel("Coordenada X", { exact: false }).fill(x);
  68  |       await dialog.getByLabel("Coordenada Y", { exact: false }).fill("0.5");
  69  |       nodes.push(await save("nodes", "POST", "Criar Nó"));
  70  |     }
  71  |     await row(nodes[1].nome).getByRole("button", { name: "Editar", exact: true }).click();
  72  |     await dialog.getByLabel("Tipo de Nó", { exact: false }).selectOption("loja");
  73  |     expect((await save(`nodes/${nodes[1].id}`, "PUT", "Salvar Alterações")).tipo).toBe("loja");
  74  | 
  75  |     await page.goto(`/admin/arestas?piso=${floor.id}`);
  76  |     await page.getByRole("button", { name: "+ Nova Aresta", exact: true }).click();
  77  |     await dialog.getByLabel("Nó de Origem", { exact: false }).selectOption(String(nodes[0].id));
  78  |     await dialog.getByLabel("Nó de Destino", { exact: false }).selectOption(String(nodes[1].id));
  79  |     const edge = await save("edges", "POST", "Criar Aresta");
  80  |     await row(`#${edge.id}`).getByRole("button", { name: "Editar", exact: true }).click();
  81  |     await dialog.getByLabel("Distância em metros", { exact: false }).fill("70");
  82  |     expect(Number((await save(`edges/${edge.id}`, "PUT", "Salvar Alterações")).distancia)).toBe(70);
  83  | 
  84  |     await page.goto("/admin/categorias");
  85  |     await page.getByRole("button", { name: "Nova categoria", exact: true }).click();
  86  |     await dialog.getByLabel("Nome", { exact: true }).fill(categoryName);
  87  |     const category = await save("categories", "POST", "Salvar");
  88  |     await row(categoryName).getByRole("button", { name: "Editar", exact: true }).click();
  89  |     await dialog.getByLabel("Ícone (slug)").fill("shop");
  90  |     expect((await save(`categories/${category.id}`, "PUT", "Salvar")).icone).toBe("shop");
  91  | 
  92  |     await page.goto("/admin/lojas");
  93  |     await page.getByRole("button", { name: "Nova loja", exact: true }).click();
  94  |     await page.getByRole("dialog").getByLabel("Nome *", { exact: true }).fill(storeName);
  95  |     await page.getByRole("dialog").getByLabel("Nó associado *").selectOption(String(nodes[1].id));
  96  |     await page.getByRole("dialog").getByLabel("Categoria *").selectOption(String(category.id));
  97  |     const store = await save("stores", "POST", "Salvar");
  98  |     await row(storeName).getByRole("button", { name: "Editar", exact: true }).click();
  99  |     await page.getByRole("dialog").getByLabel("Status operacional *").selectOption("fechado");
  100 |     expect((await save(`stores/${store.id}`, "PUT", "Salvar")).status_operacional).toBe("fechado");
  101 | 
  102 |     await page.goto("/admin/qr");
  103 |     await page.getByRole("button", { name: "+ Gerar QR Code", exact: true }).click();
  104 |     await page.getByRole("dialog").getByLabel("Nó de Origem Vinculado", { exact: false }).selectOption(String(nodes[0].id));
  105 |     await dialog.getByLabel("Token Personalizado", { exact: false }).fill(`QR-${suffix}`);
  106 |     const qr = await save("qr-codes", "POST", "Gerar QR Code");
  107 |     const qrCard = () => page.locator(".qr-card").filter({ hasText: `QR-${suffix}` });
  108 |     await expect(qrCard().locator("canvas")).toBeVisible();
  109 |     await qrCard().getByRole("button", { name: "Editar", exact: true }).click();
  110 |     await dialog.getByLabel("Token Personalizado", { exact: false }).fill(`QR-${suffix}-EDITADO`);
  111 |     const updatedQr = await save(`qr-codes/${qr.id}`, "PUT", "Salvar QR Code");
  112 |     expect((await (await request.get(`/api/qr-codes/${updatedQr.token}`)).json()).no.id).toBe(nodes[0].id);
  113 |     const route = await request.post("/api/routes", { data: { origem_no_id: nodes[0].id, destino_no_id: nodes[1].id } });
  114 |     expect(route.ok()).toBeTruthy();
  115 |     expect((await route.json()).distancia_total_metros).toBe(70);
  116 |     await page.goto(`/admin/validacao?piso=${floor.id}`);
> 117 |     await expect(page.getByText("Grafo 100% Íntegro e Conexo", { exact: true })).toBeVisible();
      |                                                                                  ^ Error: expect(locator).toBeVisible() failed
  118 | 
  119 |     await page.goto("/admin/qr");
  120 |     await remove("qr-codes", qr.id, qrCard());
  121 |     await page.goto("/admin/lojas");
  122 |     await remove("stores", store.id, row(storeName));
  123 |     await page.goto(`/admin/arestas?piso=${floor.id}`);
  124 |     await remove("edges", edge.id, row(`#${edge.id}`));
  125 |     await page.goto(`/admin/nos?piso=${floor.id}`);
  126 |     for (const node of nodes) await remove("nodes", node.id, row(node.nome));
  127 |     await page.goto("/admin/pisos");
  128 |     await remove("floors", floor.id, row(floorName));
  129 |     await page.goto("/admin/categorias");
  130 |     await remove("categories", category.id, row(categoryName));
  131 |     await page.goto("/admin/shoppings");
  132 |     await remove("shoppings", mall.id, row(mallName));
  133 |   } finally {
  134 |     // Only fixture records created by this test; reverse foreign-key order.
  135 |     for (const item of created.reverse()) {
  136 |       try {
  137 |         const cleanup = await request.delete(`/api/admin/${item.path}/${item.id}`, { headers });
  138 |         if (![204, 404].includes(cleanup.status())) {
  139 |           console.error(`Limpeza falhou para ${item.path}/${item.id}: status ${cleanup.status()}`);
  140 |         }
  141 |       } catch (error) {
  142 |         console.error(`Limpeza falhou para ${item.path}/${item.id}: ${error.message}`);
  143 |       }
  144 |     }
  145 |   }
  146 | });
  147 | 
```