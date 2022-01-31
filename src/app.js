const express = require('express');

const app = express();
const version = '1.0.0';
app.get('/version', (req, res) => res.send(`The app version is ${version}`));
app.listen(80, () => console.log('Listening on port 80!'));