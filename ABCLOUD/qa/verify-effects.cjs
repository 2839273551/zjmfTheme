const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {chromium}=require('playwright');

(async()=>{
  const browser=await chromium.launch({channel:'msedge',headless:true});
  const results={};
  try {
    const page=await browser.newPage({viewport:{width:1440,height:900}});
    const consoleErrors=[];
    page.on('pageerror',e=>consoleErrors.push(e.message));
    await page.goto('https://66.yunxnet.cn/',{waitUntil:'domcontentloaded'});
    await page.locator('.feature-buttons-section').scrollIntoViewIfNeeded();
    await page.waitForFunction(()=>document.querySelector('.feature-buttons-section').classList.contains('animate-in'));
    results.quickEntryReveal=true;
    const solutionTabs=page.locator('.is-tab');
    const count=await solutionTabs.count();
    for(let i=0;i<count;i++){
      await solutionTabs.nth(i).click();
      const id=await solutionTabs.nth(i).getAttribute('data-tab');
      const active=await solutionTabs.nth(i).evaluate(el=>el.classList.contains('active'));
      assert.ok(active);
      assert.ok(await page.locator('.is-panel.active').count()>0);
    }
    results.industryTabs=count;
    await page.locator('.container_bg1').scrollIntoViewIfNeeded();
    await page.waitForFunction(()=>[...document.querySelectorAll('.chooseUs-itme')].every(el=>el.classList.contains('visible')));
    await page.waitForFunction(()=>[...document.querySelectorAll('.chooseUs-itme')].every(el=>Number(getComputedStyle(el).opacity)>.99));
    results.chooseUs=await page.locator('.chooseUs-itme').evaluateAll(nodes=>nodes.map(n=>({opacity:getComputedStyle(n).opacity,transform:getComputedStyle(n).transform})));
    assert.ok(results.chooseUs.every(n=>Number(n.opacity)>.99));
    await page.locator('.partner-section').scrollIntoViewIfNeeded();
    const before=await page.locator('.partner-scroll-track').first().evaluate(el=>getComputedStyle(el).transform);
    await page.waitForTimeout(600);
    const after=await page.locator('.partner-scroll-track').first().evaluate(el=>getComputedStyle(el).transform);
    assert.notEqual(before,after);
    results.partnerMarquee=true;
    const fixture=await browser.newPage({viewport:{width:1440,height:900}});
    await fixture.route('https://66.yunxnet.cn/',async route=>{
      const response=await route.fetch();
      const html=await response.text();
      const clone=html.match(/<div class="banner-item[\s\S]*?<\/div>\s*<\/div>\s*<\/div>/);
      assert.ok(clone,'single slide fixture source');
      const second=clone[0].replace(' active"','"').replace(/data-index="0"/g,'data-index="1"');
      await route.fulfill({response,body:html.replace(clone[0],clone[0]+second)});
    });
    await fixture.goto('https://66.yunxnet.cn/',{waitUntil:'domcontentloaded'});
    await fixture.locator('#bannerNext').click();
    await fixture.waitForFunction(()=>document.querySelector('.banner-item.active').dataset.index==='1');
    await fixture.locator('#bannerPrev').click();
    await fixture.waitForFunction(()=>document.querySelector('.banner-item.active').dataset.index==='0');
    await fixture.mouse.move(20,880);
    await fixture.waitForFunction(()=>document.querySelector('.banner-item.active').dataset.index==='1',null,{timeout:8000});
    results.carousel={sourceSlides:1,fixtureSlides:2,manual:true,auto:true};
    await fixture.close();
    for(const state of ['empty','error']){
      const testPage=await browser.newPage();
      await testPage.route('**/cart/prolist',route=>route.fulfill({status:state==='error'?503:200,contentType:'application/json',body:JSON.stringify({status:200,data:{fgs:[]}})}));
      await testPage.goto('https://66.yunxnet.cn/',{waitUntil:'domcontentloaded'});
      await testPage.waitForFunction(state=>document.querySelector('#productTabsContent').textContent.includes(state==='empty'?'暂无产品分类':'暂时无法加载'),state);
      results['products_'+state]=true;
      await testPage.close();
    }
    results.consoleErrors=consoleErrors;
    assert.deepEqual(consoleErrors,[]);
    const out=path.join(__dirname,'results/effects-checks.json');
    fs.writeFileSync(out,JSON.stringify(results,null,2));
    console.log(JSON.stringify(results,null,2));
  }finally{await browser.close();}
})().catch(error=>{console.error(error);process.exitCode=1;});
