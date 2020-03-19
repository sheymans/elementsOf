const express = require('express');
const app = express();

app.get('/', (request, result) => result.send('Hi'));

app.listen(8111, () => console.log('hi: listening on port 8111'));