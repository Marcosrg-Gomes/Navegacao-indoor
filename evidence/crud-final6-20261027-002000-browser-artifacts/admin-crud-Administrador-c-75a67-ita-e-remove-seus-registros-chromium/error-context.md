# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: admin-crud.spec.ts >> Administrador cadastra um piso navegável, edita e remove seus registros
- Location: tests\admin-crud.spec.ts:3:1

# Error details

```
Test timeout of 180000ms exceeded.
```

```
Error: locator.selectOption: Test timeout of 180000ms exceeded.
Call log:
  - waiting for getByRole('dialog').getByLabel('Categoria *', { exact: true })

```

# Page snapshot

```yaml
- generic [ref=f5e3]:
  - complementary [ref=f5e4]:
    - generic [ref=f5e5]:
      - text: Indoor Nav
      - strong [ref=f5e6]: Painel Admin
    - navigation [ref=f5e7]:
      - link "Dashboard" [ref=f5e8] [cursor=pointer]:
        - /url: /admin
      - link "Shoppings" [ref=f5e9] [cursor=pointer]:
        - /url: /admin/shoppings
      - link "Pisos" [ref=f5e10] [cursor=pointer]:
        - /url: /admin/pisos
      - link "Editor de Nós" [ref=f5e11] [cursor=pointer]:
        - /url: /admin/nos
      - link "Arestas" [ref=f5e12] [cursor=pointer]:
        - /url: /admin/arestas
      - link "Lojas" [ref=f5e13] [cursor=pointer]:
        - /url: /admin/lojas
      - link "Categorias" [ref=f5e14] [cursor=pointer]:
        - /url: /admin/categorias
      - link "QR Codes" [ref=f5e15] [cursor=pointer]:
        - /url: /admin/qr
      - link "Validação" [ref=f5e16] [cursor=pointer]:
        - /url: /admin/validacao
    - button "Sair" [ref=f5e18] [cursor=pointer]
  - main [ref=f5e19]:
    - generic [ref=f5e20]:
      - generic [ref=f5e21]:
        - generic [ref=f5e22]:
          - heading "Lojas / POIs" [level=1] [ref=f5e23]
          - paragraph [ref=f5e24]: Cada loja fica vinculada a um nó do grafo.
        - button "Nova loja" [ref=f5e25] [cursor=pointer]
      - combobox [ref=f5e27]:
        - option "Todas as categorias" [selected]
        - option "Alimentação"
        - option "Moda"
        - option "Tecnologia"
        - option "Serviços"
        - option "Entretenimento"
        - option "Categoria chromium-1793139040954"
      - table [ref=f5e29]:
        - rowgroup [ref=f5e30]:
          - row [ref=f5e31]:
            - columnheader "Nome" [ref=f5e32]
            - columnheader "Categoria" [ref=f5e33]
            - columnheader "Nó" [ref=f5e34]
            - columnheader "Horário" [ref=f5e35]
            - columnheader "Status operacional" [ref=f5e36]
            - columnheader "Cadastro" [ref=f5e37]
            - columnheader [ref=f5e38]
        - rowgroup [ref=f5e39]:
          - row [ref=f5e40]:
            - cell "Moda Fashion" [ref=f5e41]
            - cell "Moda" [ref=f5e42]
            - cell "Loja Moda Fashion" [ref=f5e43]
            - cell "10:00 - 22:00" [ref=f5e44]
            - cell "Aberto" [ref=f5e45]
            - cell "Ativa" [ref=f5e47]
            - cell [ref=f5e49]:
              - button "Editar" [ref=f5e50] [cursor=pointer]
              - button "Excluir" [ref=f5e51] [cursor=pointer]
          - row [ref=f5e52]:
            - cell "TechStore" [ref=f5e53]
            - cell "Tecnologia" [ref=f5e54]
            - cell "TechStore" [ref=f5e55]
            - cell "10:00 - 22:00" [ref=f5e56]
            - cell "Aberto" [ref=f5e57]
            - cell "Ativa" [ref=f5e59]
            - cell [ref=f5e61]:
              - button "Editar" [ref=f5e62] [cursor=pointer]
              - button "Excluir" [ref=f5e63] [cursor=pointer]
          - row [ref=f5e64]:
            - cell "Restaurante Sabor" [ref=f5e65]
            - cell "Alimentação" [ref=f5e66]
            - cell "Restaurante Sabor" [ref=f5e67]
            - cell "10:00 - 22:00" [ref=f5e68]
            - cell "Aberto" [ref=f5e69]
            - cell "Ativa" [ref=f5e71]
            - cell [ref=f5e73]:
              - button "Editar" [ref=f5e74] [cursor=pointer]
              - button "Excluir" [ref=f5e75] [cursor=pointer]
          - row [ref=f5e76]:
            - cell "Cinema Star" [ref=f5e77]
            - cell "Entretenimento" [ref=f5e78]
            - cell "Cinema Star" [ref=f5e79]
            - cell "10:00 - 22:00" [ref=f5e80]
            - cell "Fechado" [ref=f5e81]
            - cell "Ativa" [ref=f5e83]
            - cell [ref=f5e85]:
              - button "Editar" [ref=f5e86] [cursor=pointer]
              - button "Excluir" [ref=f5e87] [cursor=pointer]
          - row [ref=f5e88]:
            - cell "Farmácia Saúde" [ref=f5e89]
            - cell "Serviços" [ref=f5e90]
            - cell "Farmácia Saúde" [ref=f5e91]
            - cell "10:00 - 22:00" [ref=f5e92]
            - cell "Aberto" [ref=f5e93]
            - cell "Ativa" [ref=f5e95]
            - cell [ref=f5e97]:
              - button "Editar" [ref=f5e98] [cursor=pointer]
              - button "Excluir" [ref=f5e99] [cursor=pointer]
          - row [ref=f5e100]:
            - cell "Café Aroma" [ref=f5e101]
            - cell "Alimentação" [ref=f5e102]
            - cell "Corredor A3" [ref=f5e103]
            - cell "10:00 - 22:00" [ref=f5e104]
            - cell "Aberto" [ref=f5e105]
            - cell "Ativa" [ref=f5e107]
            - cell [ref=f5e109]:
              - button "Editar" [ref=f5e110] [cursor=pointer]
              - button "Excluir" [ref=f5e111] [cursor=pointer]
          - row [ref=f5e112]:
            - cell "Ótica VIS" [ref=f5e113]
            - cell "Serviços" [ref=f5e114]
            - cell "Corredor Norte" [ref=f5e115]
            - cell "10:00 - 22:00" [ref=f5e116]
            - cell "Aberto" [ref=f5e117]
            - cell "Ativa" [ref=f5e119]
            - cell [ref=f5e121]:
              - button "Editar" [ref=f5e122] [cursor=pointer]
              - button "Excluir" [ref=f5e123] [cursor=pointer]
          - row [ref=f5e124]:
            - cell "Livraria Cultura" [ref=f5e125]
            - cell "Entretenimento" [ref=f5e126]
            - cell "Corredor Sul" [ref=f5e127]
            - cell "10:00 - 22:00" [ref=f5e128]
            - cell "Aberto" [ref=f5e129]
            - cell "Ativa" [ref=f5e131]
            - cell [ref=f5e133]:
              - button "Editar" [ref=f5e134] [cursor=pointer]
              - button "Excluir" [ref=f5e135] [cursor=pointer]
          - row [ref=f5e136]:
            - cell "Pet Shop Amigo" [ref=f5e137]
            - cell "Serviços" [ref=f5e138]
            - cell "Corredor Sul Central" [ref=f5e139]
            - cell "10:00 - 22:00" [ref=f5e140]
            - cell "Aberto" [ref=f5e141]
            - cell "Ativa" [ref=f5e143]
            - cell [ref=f5e145]:
              - button "Editar" [ref=f5e146] [cursor=pointer]
              - button "Excluir" [ref=f5e147] [cursor=pointer]
          - row [ref=f5e148]:
            - cell "Joalheria Brilho" [ref=f5e149]
            - cell "Moda" [ref=f5e150]
            - cell "Corredor Sul Leste" [ref=f5e151]
            - cell "10:00 - 22:00" [ref=f5e152]
            - cell "Em manutenção" [ref=f5e153]
            - cell "Ativa" [ref=f5e155]
            - cell [ref=f5e157]:
              - button "Editar" [ref=f5e158] [cursor=pointer]
              - button "Excluir" [ref=f5e159] [cursor=pointer]
          - row [ref=f5e160]:
            - cell "Banheiro" [ref=f5e161]
            - cell "Serviços" [ref=f5e162]
            - cell "Banheiro" [ref=f5e163]
            - cell "10:00 - 22:00" [ref=f5e164]
            - cell "Aberto" [ref=f5e165]
            - cell "Ativa" [ref=f5e167]
            - cell [ref=f5e169]:
              - button "Editar" [ref=f5e170] [cursor=pointer]
              - button "Excluir" [ref=f5e171] [cursor=pointer]
          - row [ref=f5e172]:
            - cell "Livraria Superior" [ref=f5e173]
            - cell "Moda" [ref=f5e174]
            - cell "Livraria Superior" [ref=f5e175]
            - cell "—" [ref=f5e176]
            - cell "Aberto" [ref=f5e177]
            - cell "Ativa" [ref=f5e179]
            - cell [ref=f5e181]:
              - button "Editar" [ref=f5e182] [cursor=pointer]
              - button "Excluir" [ref=f5e183] [cursor=pointer]
      - dialog [ref=f5e185]:
        - generic [ref=f5e186]:
          - heading "Nova loja" [level=3] [ref=f5e187]
          - button "Fechar" [ref=f5e188] [cursor=pointer]: ✕
        - generic [ref=f5e190]:
          - generic [ref=f5e191]:
            - generic [ref=f5e192]:
              - generic [ref=f5e193]: Nome *
              - textbox "Nome *" [active] [ref=f5e194]: Loja chromium-1793139040954
            - generic [ref=f5e195]:
              - generic [ref=f5e196]: Nó associado *
              - combobox "Nó associado *" [ref=f5e197]:
                - option "Selecione o nó…"
                - option "#1 Entrada Principal"
                - option "#2 Entrada Lateral"
                - option "#3 Corredor A1"
                - option "#4 Corredor A2"
                - option "#5 Corredor A3"
                - option "#6 Corredor Central"
                - option "#7 Corredor B1"
                - option "#8 Corredor B2"
                - option "#9 Corredor B3"
                - option "#10 Corredor Norte"
                - option "#11 Corredor Norte Central"
                - option "#12 Corredor Norte Leste"
                - option "#13 Corredor Sul"
                - option "#14 Corredor Sul Central"
                - option "#15 Corredor Sul Leste"
                - option "#16 Loja Moda Fashion"
                - option "#17 TechStore"
                - option "#18 Restaurante Sabor"
                - option "#19 Cinema Star"
                - option "#20 Farmácia Saúde"
                - option "#21 Banheiro"
                - option "#22 Escada Piso Superior"
                - option "#23 Elevador térreo"
                - option "#24 Elevador superior"
                - option "#25 Escada superior"
                - option "#26 Livraria Superior"
                - option "#27 Origem chromium-1793139040954"
                - option "#28 Destino chromium-1793139040954" [selected]
            - generic [ref=f5e198]:
              - generic [ref=f5e199]: Categoria *
              - combobox "Categoria *" [ref=f5e200]:
                - option "Selecione a categoria…"
                - option "Alimentação" [selected]
                - option "Moda"
                - option "Tecnologia"
                - option "Serviços"
                - option "Entretenimento"
                - option "Categoria chromium-1793139040954"
            - generic [ref=f5e201]:
              - generic [ref=f5e202]: Horário
              - textbox "Horário" [ref=f5e203]: 10:00 - 22:00
            - generic [ref=f5e204]:
              - generic [ref=f5e205]: Telefone
              - textbox "Telefone" [ref=f5e206]
            - generic [ref=f5e207]:
              - generic [ref=f5e208]: Status operacional *
              - combobox "Status operacional *" [ref=f5e209]:
                - option "Aberto" [selected]
                - option "Fechado"
                - option "Em manutenção"
            - generic [ref=f5e210]:
              - generic [ref=f5e211]: Cadastro ativo
              - combobox "Cadastro ativo" [ref=f5e212]:
                - option "Ativo (pode ser exibido)" [selected]
                - option "Inativo (oculto do visitante)"
            - generic [ref=f5e213]:
              - generic [ref=f5e214]: URL do logotipo
              - textbox "URL do logotipo" [ref=f5e215]:
                - /placeholder: https://exemplo.com/logo.png
            - generic [ref=f5e216]:
              - generic [ref=f5e217]: Descrição
              - textbox "Descrição" [ref=f5e218]
          - generic [ref=f5e219]:
            - button "Cancelar" [ref=f5e220] [cursor=pointer]
            - button "Salvar" [ref=f5e221] [cursor=pointer]
```

# Test source

```ts
  1   | import { test, expect } from "@playwright/test";
  2   | 
  3   | test("Administrador cadastra um piso navegável, edita e remove seus registros", async ({ page, request, browser }, info) => {
  4   |   test.setTimeout(180000);
  5   |   info.annotations.push({ type: "browser-version", description: `${info.project.name} ${browser.version()} (${process.platform})` });
  6   |   const headers = { "X-API-Key": "audit-local-only" };
  7   |   const suffix = `${info.project.name}-${Date.now()}`;
  8   |   const mallName = `Galeria ${suffix}`;
  9   |   const floorName = `Piso ${suffix}`;
  10  |   const categoryName = `Categoria ${suffix}`;
  11  |   const storeName = `Loja ${suffix}`;
  12  |   const created: { path: string; id: number }[] = [];
  13  |   const dialog = page.getByRole("dialog");
  14  |   const row = (name: string) => page.locator("tbody tr").filter({ has: page.getByText(name, { exact: true }) });
  15  |   async function save(path: string, method: string, button: string) {
  16  |     const pending = page.waitForResponse(
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
  63  |     const nodes = [];
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
  95  |     const noSelect = page.getByRole("dialog").locator("select").first();
  96  |     await noSelect.waitFor({ state: "visible" });
  97  |     await noSelect.selectOption(String(nodes[1].id));
> 98  |     await dialog.getByLabel("Categoria *", { exact: true }).selectOption(String(category.id));
      |                                                             ^ Error: locator.selectOption: Test timeout of 180000ms exceeded.
  99  |     const store = await save("stores", "POST", "Salvar");
  100 |     await row(storeName).getByRole("button", { name: "Editar", exact: true }).click();
  101 |     await dialog.getByLabel("Status operacional *", { exact: true }).selectOption("fechado");
  102 |     expect((await save(`stores/${store.id}`, "PUT", "Salvar")).status_operacional).toBe("fechado");
  103 | 
  104 |     await page.goto("/admin/qr");
  105 |     await page.getByRole("button", { name: "+ Gerar QR Code", exact: true }).click();
  106 |     await dialog.getByLabel("Nó de Origem Vinculado", { exact: false }).selectOption(String(nodes[0].id));
  107 |     await dialog.getByLabel("Token Personalizado", { exact: false }).fill(`QR-${suffix}`);
  108 |     const qr = await save("qr-codes", "POST", "Gerar QR Code");
  109 |     const qrCard = () => page.locator(".qr-card").filter({ hasText: `QR-${suffix}` });
  110 |     await expect(qrCard().locator("canvas")).toBeVisible();
  111 |     await qrCard().getByRole("button", { name: "Editar", exact: true }).click();
  112 |     await dialog.getByLabel("Token Personalizado", { exact: false }).fill(`QR-${suffix}-EDITADO`);
  113 |     const updatedQr = await save(`qr-codes/${qr.id}`, "PUT", "Salvar QR Code");
  114 |     expect((await (await request.get(`/api/qr-codes/${updatedQr.token}`)).json()).no.id).toBe(nodes[0].id);
  115 |     const route = await request.post("/api/routes", { data: { origem_no_id: nodes[0].id, destino_no_id: nodes[1].id } });
  116 |     expect(route.ok()).toBeTruthy();
  117 |     expect((await route.json()).distancia_total_metros).toBe(70);
  118 |     await page.goto(`/admin/validacao?piso=${floor.id}`);
  119 |     await expect(page.getByText("Grafo 100% Íntegro e Conexo", { exact: true })).toBeVisible();
  120 | 
  121 |     await page.goto("/admin/qr");
  122 |     await remove("qr-codes", qr.id, qrCard());
  123 |     await page.goto("/admin/lojas");
  124 |     await remove("stores", store.id, row(storeName));
  125 |     await page.goto(`/admin/arestas?piso=${floor.id}`);
  126 |     await remove("edges", edge.id, row(`#${edge.id}`));
  127 |     await page.goto(`/admin/nos?piso=${floor.id}`);
  128 |     for (const node of nodes) await remove("nodes", node.id, row(node.nome));
  129 |     await page.goto("/admin/pisos");
  130 |     await remove("floors", floor.id, row(floorName));
  131 |     await page.goto("/admin/categorias");
  132 |     await remove("categories", category.id, row(categoryName));
  133 |     await page.goto("/admin/shoppings");
  134 |     await remove("shoppings", mall.id, row(mallName));
  135 |   } finally {
  136 |     // Only fixture records created by this test; reverse foreign-key order.
  137 |     for (const item of created.reverse()) {
  138 |       try {
  139 |         const cleanup = await request.delete(`/api/admin/${item.path}/${item.id}`, { headers });
  140 |         if (![204, 404].includes(cleanup.status())) {
  141 |           console.error(`Limpeza falhou para ${item.path}/${item.id}: status ${cleanup.status()}`);
  142 |         }
  143 |       } catch (error) {
  144 |         console.error(`Limpeza falhou para ${item.path}/${item.id}: ${error.message}`);
  145 |       }
  146 |     }
  147 |   }
  148 | });
  149 | 
```