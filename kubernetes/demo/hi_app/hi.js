const express = require('express');
const os = require('os');

const app = express();
const host = os.hostname();

app.get('/', (request, result) => result.send('Hi from ' + host));

app.listen(8111, () => console.log('hi: listening on port 8111 of host ' + host));
