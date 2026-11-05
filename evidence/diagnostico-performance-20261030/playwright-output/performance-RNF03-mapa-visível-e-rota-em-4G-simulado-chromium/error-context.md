# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: performance.spec.ts >> RNF03: mapa visível e rota em 4G simulado
- Location: tests\performance.spec.ts:4:1

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: getByTestId('floor-map')
Expected: visible
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" getByTestId('floor-map') with timeout 5000ms
  - waiting for getByTestId('floor-map')

```

```yaml
- text: "{\"detail\":\"Not Found\"}"
```

# Test source

```ts
  1  | import { test, expect } from "@playwright/test";
  2  | import { mkdirSync, writeFileSync } from "node:fs";
  3  | 
  4  | test("RNF03: mapa visível e rota em 4G simulado", async ({ browser }, info) => {
  5  |   test.skip(info.project.name !== "chromium", "Throttling CDP disponível no Chromium");
  6  |   const samples = [];
  7  |   for (let i = 0; i < 5; i++) {
  8  |     const context = await browser.newContext({ viewport: { width: 360, height: 640 } });
  9  |     const page = await context.newPage();
  10 |     const cdp = await context.newCDPSession(page);
  11 |     await cdp.send("Network.enable");
  12 |     await cdp.send("Network.setCacheDisabled", { cacheDisabled: true });
  13 |     await cdp.send("Network.emulateNetworkConditions", {
  14 |       offline: false, latency: 80, downloadThroughput: 9 * 1024 * 1024 / 8,
  15 |       uploadThroughput: 1024 * 1024 / 8, connectionType: "cellular4g",
  16 |     });
  17 |     await page.goto("/?qr=ENTRADA-PRINCIPAL");
> 18 |     await expect(page.getByTestId("floor-map")).toBeVisible();
     |                                                 ^ Error: expect(locator).toBeVisible() failed
  19 |     await expect(page.getByTestId("origin-label")).toContainText("Entrada Principal");
  20 |     const mapMs = await page.evaluate(async () => {
  21 |       const uri = document.querySelector("svg image")?.getAttribute("href");
  22 |       if (!uri) throw new Error("Planta não carregada");
  23 |       const image = new Image(); image.src = uri; await image.decode();
  24 |       return performance.now();
  25 |     });
  26 |     await page.getByLabel("Buscar destinos", { exact: true }).fill("Tech");
  27 |     await page.getByRole("button", { name: "TechStore, Aberto" }).click();
  28 |     const start = Date.now();
  29 |     await page.getByRole("button", { name: "Traçar rota", exact: true }).click();
  30 |     await expect(page.getByTestId("route-panel")).toBeVisible();
  31 |     samples.push({ mapMs: Math.round(mapMs), routeMs: Date.now() - start });
  32 |     await context.close();
  33 |   }
  34 |   mkdirSync("../evidence", { recursive: true });
  35 |   writeFileSync(`../evidence/performance-${process.env.AUDIT_PHASE || "after"}.json`, JSON.stringify({
  36 |     profile: "4G simulado: 9 Mbps down / 1 Mbps up / 80 ms, cache frio, Chromium, 360x640", samples,
  37 |   }, null, 2));
  38 |   console.log("RNF03", JSON.stringify(samples));
  39 |   for (const sample of samples) {
  40 |     expect(sample.mapMs).toBeLessThanOrEqual(3000);
  41 |     expect(sample.routeMs).toBeLessThanOrEqual(1000);
  42 |   }
  43 | });
  44 | 
```