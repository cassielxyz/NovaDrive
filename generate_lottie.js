const { spawn } = require('child_process');
const fs = require('fs');

const lottieScript = `
try {
  const scene = creator.activeScene;

  // Clear existing layers
  const layers = [...scene.layers];
  for (const layer of layers) {
      layer.remove();
  }

  scene.size = { width: 512, height: 512 };
  scene.framerate = 60;
  scene.duration = 3.5;
  scene.backgroundColor = null;

  const smooth = { type: 'CUBIC_BEZIER', x1: 0.42, y1: 0, x2: 0.58, y2: 1 };
  const bounce = { type: 'CUBIC_BEZIER', x1: 0.34, y1: 1.56, x2: 0.64, y2: 1 };
  const easeIn = { type: 'CUBIC_BEZIER', x1: 0.4, y1: 0, x2: 1, y2: 1 };
  const easeOut = { type: 'CUBIC_BEZIER', x1: 0, y1: 0, x2: 0.2, y2: 1 };

  const cPrimary = { r: 59, g: 130, b: 246 }; // Blue
  const cSecondary = { r: 139, g: 92, b: 246 }; // Purple
  const cVault = { r: 100, g: 116, b: 139 }; // Slate
  const cVaultDark = { r: 51, g: 65, b: 85 };
  const cText = { r: 30, g: 41, b: 59 };

  // Top -> Bottom render order (Foreground first)

  // 1. TEXT
  const textLayer = scene.createTextLayer({ text: "Connecting to Cloud", fontSize: 24, alignment: 'center' });
  textLayer.createFill({ type: 'SOLID', color: cText });
  textLayer.position.staticValue = { x: 256, y: 440 };
  textLayer.scale.addKeyframes([
      { frame: 0, value: {x: 0, y: 0}, easing: smooth },
      { frame: 160, value: {x: 0, y: 0}, easing: smooth },
      { frame: 180, value: {x: 100, y: 100}, easing: smooth }
  ]);

  // 2. INFINITY SYMBOL (Foreground)
  const infinityLayer = scene.createShapeLayer({ name: "Infinity" });
  infinityLayer.position.staticValue = { x: 256, y: 256 };
  const infGroup = infinityLayer.createGroup();
  const e1 = infGroup.createEllipse({ position: { x: -30, y: 0 }, size: { width: 60, height: 60 } });
  const e2 = infGroup.createEllipse({ position: { x: 30, y: 0 }, size: { width: 60, height: 60 } });
  const infStroke = infGroup.createStroke({ fill: { type: 'SOLID', color: cPrimary }, width: 12 });

  infinityLayer.scale.addKeyframes([
      { frame: 0, value: { x: 0, y: 0 }, easing: smooth },
      { frame: 160, value: { x: 0, y: 0 }, easing: bounce },
      { frame: 180, value: { x: 100, y: 100 }, easing: smooth }
  ]);
  infinityLayer.rotation.addKeyframes([
      { frame: 180, value: 0, easing: smooth },
      { frame: 210, value: 5, easing: smooth }
  ]);

  // 3. VAULT DOOR
  const vaultDoorLayer = scene.createShapeLayer({ name: "VaultDoor" });
  vaultDoorLayer.position.staticValue = { x: 256, y: 256 };
  const doorGroup = vaultDoorLayer.createGroup();
  doorGroup.createRectangle({ position: { x: 0, y: 0 }, size: { width: 120, height: 120 }, roundness: 20 });
  doorGroup.createFill({ type: 'SOLID', color: cVault });
  
  const doorKnobGroup = vaultDoorLayer.createGroup();
  doorKnobGroup.createEllipse({ position: { x: 30, y: 0 }, size: { width: 30, height: 30 } });
  doorKnobGroup.createFill({ type: 'SOLID', color: cVaultDark });

  vaultDoorLayer.scale.addKeyframes([
      { frame: 0, value: { x: 0, y: 0 }, easing: smooth },
      { frame: 50, value: { x: 0, y: 0 }, easing: bounce },
      { frame: 70, value: { x: 100, y: 100 }, easing: smooth },
      { frame: 160, value: { x: 100, y: 100 }, easing: smooth },
      { frame: 180, value: { x: 0, y: 0 }, easing: smooth }
  ]);
  vaultDoorLayer.position.addKeyframes([
      { frame: 70, value: { x: 256, y: 256 }, easing: smooth },
      { frame: 90, value: { x: 180, y: 256 }, easing: smooth },
      { frame: 130, value: { x: 180, y: 256 }, easing: smooth },
      { frame: 150, value: { x: 256, y: 256 }, easing: bounce }
  ]);

  // 4. PARTICLES
  const particlesLayer = scene.createShapeLayer({ name: "Particles" });
  particlesLayer.position.staticValue = { x: 256, y: 256 };
  const colors = [cPrimary, cSecondary, cPrimary, cSecondary, cPrimary, cSecondary];
  for(let i=0; i<6; i++) {
      const pGroup = particlesLayer.createGroup();
      pGroup.createEllipse({ position: { x: 0, y: 0 }, size: { width: 20, height: 20 } });
      pGroup.createFill({ type: 'SOLID', color: colors[i] });
      
      const angle = (i / 6) * Math.PI * 2;
      const dist = 80;
      const px = Math.cos(angle) * dist;
      const py = Math.sin(angle) * dist;
      
      pGroup.position.addKeyframes([
          { frame: 0, value: { x: 0, y: 0 }, easing: easeOut },
          { frame: 30, value: { x: 0, y: 0 }, easing: easeOut },
          { frame: 70, value: { x: px, y: py }, easing: smooth },
          { frame: 90, value: { x: px, y: py }, easing: easeIn },
          { frame: 130, value: { x: 0, y: 0 }, easing: smooth }
      ]);
      
      pGroup.scale.addKeyframes([
          { frame: 0, value: { x: 0, y: 0 }, easing: smooth },
          { frame: 30, value: { x: 0, y: 0 }, easing: smooth },
          { frame: 40, value: { x: 100, y: 100 }, easing: smooth },
          { frame: 110, value: { x: 100, y: 100 }, easing: smooth },
          { frame: 130, value: { x: 0, y: 0 }, easing: smooth }
      ]);
  }

  // 5. VAULT BODY
  const vaultBodyLayer = scene.createShapeLayer({ name: "VaultBody" });
  vaultBodyLayer.position.staticValue = { x: 256, y: 256 };
  const bodyGroup = vaultBodyLayer.createGroup();
  bodyGroup.createRectangle({ position: { x: 0, y: 0 }, size: { width: 140, height: 140 }, roundness: 24 });
  bodyGroup.createFill({ type: 'SOLID', color: cVaultDark });

  vaultBodyLayer.scale.addKeyframes([
      { frame: 0, value: { x: 0, y: 0 }, easing: smooth },
      { frame: 50, value: { x: 0, y: 0 }, easing: bounce },
      { frame: 70, value: { x: 100, y: 100 }, easing: smooth },
      { frame: 160, value: { x: 100, y: 100 }, easing: smooth },
      { frame: 180, value: { x: 0, y: 0 }, easing: smooth }
  ]);

  // 6. LOGO
  const logoLayer = scene.createShapeLayer({ name: "Logo" });
  logoLayer.position.staticValue = { x: 256, y: 256 };
  const logoGroup = logoLayer.createGroup();
  logoGroup.createRectangle({ position: { x: 0, y: 0 }, size: { width: 100, height: 100 }, roundness: 30 });
  logoGroup.createFill({ type: 'SOLID', color: cPrimary });

  logoLayer.scale.addKeyframes([
      { frame: 0, value: { x: 0, y: 0 }, easing: bounce },
      { frame: 20, value: { x: 100, y: 100 }, easing: smooth },
      { frame: 30, value: { x: 100, y: 100 }, easing: easeIn },
      { frame: 50, value: { x: 0, y: 0 }, easing: smooth }
  ]);

  console.log("Animation generation complete! You can now export this as a Lottie JSON and place it in the assets/animations folder.");
} catch (e) {
  console.log("SCRIPT ERROR:", e.name, e.message);
  console.log("STACK TRACE:", e.stack);
}
`;

const proc = spawn('npx.cmd', ['-y', '@lottiefiles/creator-mcp@latest'], {
  stdio: ['pipe', 'pipe', 'inherit'],
  shell: true
});

console.log("MCP Server started. Please click 'Connect' in the LottieFiles Creator UI now!");
console.log("Polling for connection every 3 seconds...");

const interval = setInterval(() => {
  console.log("Attempting to inject animation...");
  proc.stdin.write(JSON.stringify({
    jsonrpc: "2.0",
    id: 1,
    method: "tools/call",
    params: {
      name: "run_script",
      arguments: { 
        script: lottieScript
      }
    }
  }) + '\n');
}, 3000);

let buffer = '';
proc.stdout.on('data', (data) => {
  buffer += data.toString();
  try {
    const msgs = buffer.split('\n');
    for (let i = 0; i < msgs.length - 1; i++) {
      if (msgs[i].trim() === '') continue;
      const msg = JSON.parse(msgs[i]);
      
      // If it's an error about "No Creator tab is connected", just ignore and let it retry
      if (msg.result && msg.result.isError && msg.result.content[0].text.includes("No Creator tab is connected")) {
          // just wait for the next interval
      } else {
          console.log("Response from MCP:", JSON.stringify(msg, null, 2));
          if (msg.id === 1) {
            clearInterval(interval);
            setTimeout(() => process.exit(0), 1000); // give it a sec to flush
          }
      }
    }
    buffer = msgs[msgs.length - 1];
  } catch (e) {
  }
});
