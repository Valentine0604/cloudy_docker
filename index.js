const http = require('http');
const os = require('os');
const packageJson = require('./package.json');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.write(`IP address: ${getIpAddress()}\n`);
  res.write(`Server name: ${os.hostname()}\n`);
  res.write(`App version: ${packageJson.version}\n`);
  res.end();
});

function getIpAddress() {
  const interfaces = os.networkInterfaces();
  for (const iface of Object.values(interfaces)) {
    for (const details of iface) {
      if (!details.internal && details.family === 'IPv4') {
        return details.address;
      }
    }
  }
  return 'Unknown';
}

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
