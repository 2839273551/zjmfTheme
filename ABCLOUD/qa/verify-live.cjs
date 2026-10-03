const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const { chromium } = require('playwright');
const sharp = require('sharp');

(async () => {
  const out = path.join(__dirname, 'results');
  fs.mkdirSync(out, { recursive: true });
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  const results = [];
  try {
  for (const size of [{ width:1440,height:900 },{ width:1280,height:900 },{ width:390,height:844 }]) {
    const context = await browser.newContext({ viewport:size, deviceScaleFactor:1 });
    await context.route('**/*', route => {
      const url = new URL(route.request().url());
      return url.hostname === '66.yunxnet.cn' ? route.continue() : route.abort();
    });
    const page = await context.newPage();
    const errors = [], failed = [];
    page.on('pageerror', error => errors.push(error.message));
    page.on('response', response => {
      if (response.status() >= 400) failed.push({url:response.url(),status:response.status()});
    });
    const response = await page.goto('https://66.yunxnet.cn/', {waitUntil:'domcontentloaded',timeout:60000});
    console.log('DOM ready at ' + size.width);
    assert.equal(response.status(), 200);
    await page.waitForFunction(() => document.querySelectorAll('#productTabs button').length > 0);
    await page.waitForFunction(() => document.querySelector('#newsFeatured .news-featured-title').textContent !== '加载中...');
    const catalog = await page.evaluate(() => window.apeFinance.catalog());
    assert.equal(await page.locator('#productTabs button').count(), catalog.length);
    const tabs = page.locator('#productTabs button');
    await page.locator('#productTabs').scrollIntoViewIfNeeded();
    const productCounts = [];
    for (let i=0; i<catalog.length; i++) {
      await tabs.nth(i).click();
      const pane = page.locator('#gppane-' + catalog[i].id);
      await pane.waitFor({state:'visible'});
      const expected = (catalog[i].group || []).map(g => g.name.replace(/^[a-z]+\|/i, '').trim());
      await page.waitForFunction(({id,count}) => document.querySelectorAll('#gppane-' + id + ' .card-title').length === count,
        {id:catalog[i].id,count:expected.length});
      const titles = await pane.locator('.card-title').allTextContents();
      assert.deepEqual(titles.map(t=>t.replace(/\s*售罄\s*$/,'').trim()), expected);
      productCounts.push(titles.length);
    }
    await tabs.first().click();
    await page.locator('.product-header').scrollIntoViewIfNeeded();
    await page.waitForTimeout(1000);
    await page.locator('.product-service-section').screenshot({path:path.join(out,'products-'+size.width+'.png')});
    for (const type of ['news','announce']) {
      await page.locator('.news-tab[data-type="'+type+'"]').click();
      const items = await page.evaluate(type => window.apeFinance.updates(type), type);
      await page.waitForFunction(title => document.querySelector('#newsFeatured .news-featured-title').textContent === title,
        items.length ? items[0].title : '未发布任何内容');
    }
    await page.locator('.news-section').scrollIntoViewIfNeeded();
    await page.locator('.news-section img').evaluateAll(async images => {
      await Promise.all(images.map(image => image.decode().catch(() => {})));
    });
    await page.waitForTimeout(900);
    await page.locator('.news-section').screenshot({path:path.join(out,'news-'+size.width+'.png')});
    assert.equal(await page.locator('.ape-service-directory').count(),0);
    assert.equal(await page.locator('script[src*="codex_framework"],link[href*="codex_framework"]').count(),0);
    const docs = await page.locator('#apeHelpSource').evaluate(el => [...el.content.querySelectorAll('a')].map(a=>({title:a.textContent,href:a.getAttribute('href')})));
    assert.ok(docs.length > 0);
    for (const doc of docs) {
      const detailUrl = new URL(doc.href,'https://66.yunxnet.cn').href;
      let detail;
      for (let attempt=0; attempt<3; attempt++) {
        try { detail = await context.request.get(detailUrl, {timeout:15000}); break; }
        catch (error) { if (attempt===2) throw error; }
      }
      assert.equal(detail.status(),200);
    }
    await page.locator('#globeToggle').scrollIntoViewIfNeeded();
    await page.waitForFunction(() => document.querySelector('#globeToggle [data-mode="flat"]').disabled === false, null, {timeout:30000});
    const maps = {};
    for (const mode of ['flat','globe']) {
      const button = page.locator('#globeToggle [data-mode="'+mode+'"]');
      assert.ok(await button.isEnabled(), mode + ' unavailable');
      await button.click();
      const scene = page.locator(mode === 'globe' ? '#globeSphere' : '#globeFlat');
      await scene.waitFor({state:'visible'});
      await page.waitForTimeout(1600);
      const canvas = scene.locator('canvas').first();
      assert.ok(await canvas.isVisible());
      const first = await scene.screenshot({path:path.join(out,mode+'-'+size.width+'.png')});
      const stats = await sharp(first).stats();
      assert.ok(stats.channels.some(c=>c.stdev>8), mode + ' is blank');
      await page.waitForTimeout(600);
      const second = await scene.screenshot();
      const a = await sharp(first).ensureAlpha().raw().toBuffer();
      const b = await sharp(second).ensureAlpha().raw().toBuffer();
      let changed=0;
      for(let n=0;n<Math.min(a.length,b.length);n+=4) if(Math.abs(a[n]-b[n])+Math.abs(a[n+1]-b[n+1])+Math.abs(a[n+2]-b[n+2])>12) changed++;
      maps[mode]={canvasCount:await scene.locator('canvas').count(),colorDeviation:stats.channels.map(c=>Math.round(c.stdev)),movingPixels:changed};
      assert.ok(changed>20, mode+' is not moving');
    }
    await page.locator('#apeNoticeFloatBtn').click();
    await page.locator('#popupOverlay').waitFor({state:'visible'});
    assert.ok(await page.locator('#popupOverlay a[href*="newsview"]').count()>0);
    await page.locator('#popupClose').click();
    if (size.width < 768) {
      await page.locator('.hamburger').click();
      assert.ok(await page.locator('body').evaluate(el=>el.classList.contains('menu-open')));
      assert.ok(await page.locator('.mobile-menu-right a[href*="fid="]').count()>0);
      await page.keyboard.press('Escape');
    } else {
      await page.locator('[data-product-menu] > .nav-parent').click();
      const menu = page.locator('[data-product-menu]');
      assert.ok(await menu.locator('.mega-product-card').count()>0);
      await menu.locator('.mega-cat-item').last().click();
      await page.screenshot({path:path.join(out,'menu-'+size.width+'.png')});
      await menu.locator('.mega-menu-close').click();
    }
    await page.locator('#closeNoticeBtn').click();
    assert.equal(await page.locator('.public-header').evaluate(el=>el.style.top),'0px');
    if (await page.locator('#backToTop').isVisible()) {
      await page.locator('#backToTop').click();
      await page.waitForFunction(()=>window.scrollY<10);
    }
    const overflow = await page.evaluate(()=>({scroll:document.documentElement.scrollWidth,client:document.documentElement.clientWidth}));
    const resources = await page.evaluate(()=>performance.getEntriesByType('resource').map(x=>x.name).filter(x=>/themes\/web\//.test(x)));
    const result={viewport:size,groups:catalog.length,productCounts,docs,maps,overflow,errors,failed,themeResources:resources.length};
    results.push(result);
    fs.writeFileSync(path.join(out,'live-checks.json'),JSON.stringify(results,null,2));
    console.log(JSON.stringify(result));
    assert.ok(overflow.scroll<=overflow.client+1,'Horizontal overflow');
    assert.deepEqual(errors,[]);
    assert.deepEqual(failed,[]);
    await context.close();
  }
  } finally { await browser.close(); }
})().catch(error=>{console.error(error);process.exitCode=1;});
