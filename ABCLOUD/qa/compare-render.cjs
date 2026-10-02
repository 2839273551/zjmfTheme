const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');
const sharp = require('sharp');

(async () => {
  const project = path.resolve(__dirname, '../..');
  const source = path.join(project, 'APE云模板系统-整合包/ape');
  const theme = path.join(project, 'ABCLOUD/public/themes/web/ABCLOUD');
  const target = fs.readFileSync(path.join(theme, 'index.html'),'utf8');
  const modules = {
    'cloud-market':'.cloud-market-section','industry-solutions':'.industry-solutions-section',
    'global-infrastructure':'.global-infra-section','why-choose-us':'.container_bg1',
    partners:'.partner-section','join-banner':'.join-banner',
    'product-service':'.product-service-section',news:'.news-section'
  };
  const out = path.join(__dirname,'results');
  fs.mkdirSync(out,{recursive:true});
  const browser = await chromium.launch({headless:true,channel:'msedge'});
  const extractor = await browser.newPage({javaScriptEnabled:false});
  await extractor.route('**/*', route=>route.abort());
  await extractor.setContent(target);
  const targetModules = {};
  for (const [name,selector] of Object.entries(modules)) targetModules[name]=await extractor.locator(selector).evaluate(el=>el.outerHTML);
  await extractor.close();
  const results=[];
  try {
    for(const width of [1440,390]) {
      const pages=[];
      for(const kind of ['source','target']) {
        const page=await browser.newPage({viewport:{width,height:900}});
        await page.route('**/*',async route=>{
          const url=new URL(route.request().url());
          if(url.pathname==='/__ape_comparison') {
            const body=kind==='source'
              ? Object.keys(modules).map(name=>fs.readFileSync(path.join(source,'include',name+'.html'),'utf8')).join('\n')
              : Object.keys(modules).map(name=>targetModules[name]).join('\n');
            const css=['bootstrap.min.css','common.css','public.css','index.css'].map(name=>
              '<link rel="stylesheet" href="/themes/web/ABCLOUD/static/ape/css/'+name+'">').join('');
            const normalized=body.replace(/<script[\s\S]*?<\/script>/g,'')
              .replaceAll('/web/ape/','/themes/web/ABCLOUD/static/ape/')
              .replace(/(?<!\/)web\/ape\//g,'/themes/web/ABCLOUD/static/ape/')
              .replaceAll('loading="lazy"','');
            return route.fulfill({contentType:'text/html; charset=utf-8',body:'<!DOCTYPE html><html><head><meta charset="UTF-8">'+css+'</head><body>'+normalized+'</body></html>'});
          }
          const prefix='/themes/web/ABCLOUD/static/ape/';
          const sourcePrefix='/web/ape/';
          if(url.pathname.startsWith(prefix)||url.pathname.startsWith(sourcePrefix)) {
            const relative=url.pathname.slice(url.pathname.startsWith(prefix)?prefix.length:sourcePrefix.length);
            const root=kind==='source'?source:path.join(theme,'static/ape');
            const file=path.join(root,relative);
            if(fs.existsSync(file)) return route.fulfill({path:file});
          }
          return route.abort();
        });
        await page.goto('https://66.yunxnet.cn/__ape_comparison');
        await page.evaluate(()=>{
          document.querySelectorAll('.chooseUs-itme,.scroll-animate,.partner-section').forEach(n=>n.classList.add('visible'));
        });
        pages.push(page);
      }
      for(const [name,selector] of Object.entries(modules)) {
        const nodes=pages.map(page=>page.locator(selector));
        if(!await nodes[0].isVisible()) {
          results.push({width,module:name,sourceVisible:false,targetVisible:await nodes[1].isVisible()});
          continue;
        }
        const buffers=[];
        for(let index=0;index<nodes.length;index++) {
          buffers.push(await nodes[index].screenshot({animations:'disabled',path:path.join(out,name+'-'+(index?'target':'source')+'-'+width+'.png')}));
        }
        const raw=await Promise.all(buffers.map(buffer=>sharp(buffer).ensureAlpha().raw().toBuffer({resolveWithObject:true})));
        const equalSize=raw[0].info.width===raw[1].info.width&&raw[0].info.height===raw[1].info.height;
        let different=0;
        if(equalSize) for(let i=0;i<raw[0].data.length;i+=4) {
          const a=raw[0].data,b=raw[1].data;
          if(Math.abs(a[i]-b[i])+Math.abs(a[i+1]-b[i+1])+Math.abs(a[i+2]-b[i+2])>30) different++;
        }
        const ratio=equalSize?different/(raw[0].info.width*raw[0].info.height):1;
        results.push({width,module:name,equalSize,sourceSize:[raw[0].info.width,raw[0].info.height],targetSize:[raw[1].info.width,raw[1].info.height],pixelDifference:Number(ratio.toFixed(5))});
      }
      await Promise.all(pages.map(page=>page.close()));
    }
    fs.writeFileSync(path.join(out,'visual-comparison.json'),JSON.stringify(results,null,2));
    console.log(JSON.stringify(results,null,2));
    if(results.some(r=>r.sourceVisible===false?r.targetVisible:r.pixelDifference>.01)) process.exitCode=1;
  } finally { await browser.close(); }
})().catch(error=>{console.error(error);process.exitCode=1;});
