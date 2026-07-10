const { spawn } = require('child_process');
const fs = require('fs');

const proc = spawn('npx.cmd', ['-y', '@lottiefiles/creator-mcp@latest'], {
  stdio: ['pipe', 'pipe', 'inherit'],
  shell: true
});

let buffer = '';

proc.stdout.on('data', (data) => {
  buffer += data.toString();
  try {
    const msgs = buffer.split('\n');
    for (let i = 0; i < msgs.length - 1; i++) {
      if (msgs[i].trim() === '') continue;
      const msg = JSON.parse(msgs[i]);
      if (msg.id === 1) {
        console.log(JSON.stringify(msg, null, 2));
        process.exit(0);
      }
    }
    buffer = msgs[msgs.length - 1];
  } catch (e) {
    // wait for more data
  }
});

proc.stdin.write(JSON.stringify({
  jsonrpc: "2.0",
  id: 1,
  method: "tools/call",
  params: {
    name: "run_script",
    arguments: { 
      script: `
        console.log("Creator API keys:", Object.keys(creator));
        console.log("Scene API keys:", Object.keys(creator.activeScene));
      ` 
    }
  }
}) + '\n');
