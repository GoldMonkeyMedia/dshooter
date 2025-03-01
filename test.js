#!MCVM node ${file}
import fs from 'fs';

const wasm_bytes = fs.readFileSync("app.wasm");

(async () => {
  const wasm = await WebAssembly.compile(wasm_bytes);
  console.log(Object.entries(wasm));
})();
