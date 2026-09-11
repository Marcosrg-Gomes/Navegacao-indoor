# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: scanner.spec.ts >> Scanner aceita outra leitura após voltar à aba (eventos simulados)
- Location: tests\scanner.spec.ts:3:1

# Error details

```
Error: expect(locator).toContainText(expected) failed

Locator: getByTestId('origin-label')
Expected substring: "Livraria Superior"
Received string:    "📍 Entrada Principal"
Timeout: 5000ms

Call log:
  - Expect "toContainText" getByTestId('origin-label') with timeout 5000ms
  - waiting for getByTestId('origin-label')
    14 × locator resolved to <div dir="auto" data-testid="origin-label" class="css-146c3p1 r-1syucbw r-ubezar r-1kfrs79">📍 Entrada Principal</div>
       - unexpected value "📍 Entrada Principal"

```

# Page snapshot

```yaml
- generic [ref=e9]:
  - generic [ref=e10]:
    - generic:
      - generic [aria-hidden]:
        - heading [level=1] [ref=e12]: Navegação Indoor
        - generic:
          - generic:
            - generic:
              - generic:
                - generic:
                  - generic:
                    - generic: 🔍
                    - textbox:
                      - /placeholder: Buscar loja, serviço ou categoria…
                - generic: 📍 Entrada Principal
                - generic:
                  - button:
                    - generic: Alterar origem
                  - button [active]:
                    - generic: Escanear QR
                  - switch:
                    - generic: "♿ Acessível: não"
                - generic:
                  - generic:
                    - button:
                      - generic: Térreo ✓
                    - button:
                      - generic: Piso superior
                - generic:
                  - generic: "Mapa: Térreo"
                  - button:
                    - generic: −
                  - generic: 1.0×
                  - button:
                    - generic: +
                  - button:
                    - generic: Centralizar
                - generic:
                  - generic: Corredor
                  - generic: Loja
                  - generic: Entrada
                  - generic: Escada
                  - generic: Elevador
                  - generic: Banheiro
                  - generic: Saída
    - generic [ref=e13]:
      - heading "Escanear QR Code" [level=1] [ref=e16]
      - generic [ref=e19]:
        - generic [ref=e20]: Encontre sua posição
        - generic [ref=e21]: Aponte a câmera para um QR Code do shopping ou informe o código da placa.
        - generic [ref=e23]: Código ou link do QR
        - textbox "Código ou link do QR" [ref=e24]:
          - /placeholder: ENTRADA-PRINCIPAL
        - button "Usar código" [disabled]
        - button "Selecionar ponto de partida manualmente" [ref=e26] [cursor=pointer]
  - tablist [ref=e29]:
    - tab "🗺️ 🗺️ Mapa" [ref=e31] [cursor=pointer]:
      - generic [ref=e32]:
        - generic [ref=e33]: 🗺️
        - generic [ref=e35]: 🗺️
      - generic [ref=e37]: Mapa
    - tab "📷 📷 Scan" [selected] [ref=e39] [cursor=pointer]:
      - generic [ref=e40]:
        - generic [ref=e41]: 📷
        - generic [ref=e43]: 📷
      - generic [ref=e45]: Scan
    - tab "📋 📋 Explorar" [ref=e47] [cursor=pointer]:
      - generic [ref=e48]:
        - generic [ref=e49]: 📋
        - generic [ref=e51]: 📋
      - generic [ref=e53]: Explorar
```

# Test source

```ts
  1  | import { test, expect } from "@playwright/test";
  2  | 
  3  | test("Scanner aceita outra leitura após voltar à aba (eventos simulados)", async ({ page, browser }, info) => {
  4  |   test.skip(info.project.name !== "chromium", "Fixture de MediaStream simulada para Chromium");
  5  |   info.annotations.push({ type: "browser-version", description: `chromium ${browser.version()} (${process.platform})` });
  6  |   info.annotations.push({ type: "scope", description: "Vídeo sintético e decoder simulado; não valida leitura óptica nem câmera física." });
  7  |   await page.addInitScript(() => {
  8  |     // Exercise CameraView and screen focus without accessing a real camera or CDN.
  9  |     const state = window as Window & { auditQrToken: string | null };
  10 |     state.auditQrToken = null;
  11 |     const query = navigator.permissions.query.bind(navigator.permissions);
  12 |     navigator.permissions.query = (descriptor) => descriptor.name === "camera"
  13 |       ? Promise.resolve({ state: "granted" } as PermissionStatus)
  14 |       : query(descriptor);
  15 |     navigator.mediaDevices.getUserMedia = async () => {
  16 |       const canvas = document.createElement("canvas");
  17 |       canvas.width = 320; canvas.height = 240;
  18 |       const paint = () => canvas.getContext("2d")!.fillRect(0, 0, 320, 240);
  19 |       paint();
  20 |       const timer = setInterval(paint, 100);
  21 |       const stream = canvas.captureStream(10);
  22 |       const track = stream.getVideoTracks()[0];
  23 |       const stop = track.stop.bind(track);
  24 |       track.stop = () => { clearInterval(timer); stop(); };
  25 |       return stream;
  26 |     };
  27 |     navigator.mediaDevices.enumerateDevices = async () => [];
  28 |     Object.defineProperty(window, "Worker", { value: class {
  29 |       onmessage: ((event: { data: unknown }) => void) | null = null;
  30 |       postMessage() {
  31 |         const token = state.auditQrToken;
  32 |         queueMicrotask(() => this.onmessage?.({ data: token ? {
  33 |           type: "qr", data: token, cornerPoints: [],
  34 |           bounds: { origin: { x: 0, y: 0 }, size: { width: 0, height: 0 } },
  35 |         } : null }));
  36 |       }
  37 |     } });
  38 |   });
  39 |   await page.goto("/scan");
  40 |   await expect(page.locator("video")).toBeVisible();
  41 |   await page.evaluate(() => { (window as Window & { auditQrToken: string }).auditQrToken = "ENTRADA-PRINCIPAL"; });
  42 |   await expect(page.getByTestId("origin-label")).toContainText("Entrada Principal");
  43 |   await page.evaluate(() => { (window as Window & { auditQrToken: string }).auditQrToken = "DESTINO-SUPERIOR"; });
  44 |   await page.getByRole("button", { name: "Escanear QR", exact: true }).click();
> 45 |   await expect(page.getByTestId("origin-label")).toContainText("Livraria Superior");
     |                                                  ^ Error: expect(locator).toContainText(expected) failed
  46 |   await expect(page.getByText("Mapa: Piso superior", { exact: true })).toBeVisible();
  47 | });
  48 | 
```