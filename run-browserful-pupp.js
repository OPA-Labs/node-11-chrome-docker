const puppeteer = require('puppeteer');
process.env.CHROME_PATH = "/usr/bin/google-chrome-stable";
process.env.PUPPETEER_EXEC_PATH = "google-chrome-stable";
(async () => {

    if (process.env.IS_DOCKER == 'true') {

        var Xvfb = require('xvfb');
        var xvfb = new Xvfb({
            silent: true,
            xvfb_args: ["-screen", "0", '1280x720x24', "-ac"],
        });

        console.log('Launching XVFB');
        xvfb.startSync();
        console.log('Launched XVFB');


    }

    console.log('*************')

    const browser = await puppeteer.launch({
        headless: false,
        executablePath: process.env.CHROME_PATH,
        args: ['--no-sandbox '],
    });
    const page = await browser.newPage();
    await page.goto('https://example.com');
    await page.screenshot({ path: 'example.png' });

    await browser.close();
    console.log('*************')

})();