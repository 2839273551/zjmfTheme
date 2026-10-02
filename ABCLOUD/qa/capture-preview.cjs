const {chromium}=require('playwright');
const path=require('node:path');
(async()=>{
  const browser=await chromium.launch({channel:'msedge',headless:true});
  try{
    const page=await browser.newPage({viewport:{width:1440,height:900},deviceScaleFactor:1});
    await page.goto('https://66.yunxnet.cn/',{waitUntil:'domcontentloaded'});
    await page.waitForFunction(()=>document.querySelectorAll('#productTabs button').length>0);
    await page.locator('#banner').scrollIntoViewIfNeeded();
    await page.waitForTimeout(1300);
    await page.screenshot({path:path.resolve(__dirname,'../public/themes/web/ABCLOUD/theme.jpg'),type:'jpeg',quality:88});
  }finally{await browser.close();}
})().catch(error=>{console.error(error);process.exitCode=1;});
