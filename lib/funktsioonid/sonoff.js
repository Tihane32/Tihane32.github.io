const ewelink = require('ewelink-api');

const connection = new ewelink({
    email: 'jaakob.lambot@gmail.com', //muutub
    password: 'kalatraaler', //muutub
    region: 'eu',
    APP_ID: 'Uw83EKZFxdif7XFXEsrpduz5YyjP7nTl', //ei muutu
    APP_SECRET: 'mXLOjea0woSMvK9gw7Fjsy7YlFO4iSu6' //ei muutu
    });
//https://ewelink-api.vercel.app/docs/available-methods/toggledevice
(async () => {
    const status = await connection.toggleDevice('1001d4dc25');
    const bb = await connection.getDevices();
    console.log(status);
    console.log(bb);
})();