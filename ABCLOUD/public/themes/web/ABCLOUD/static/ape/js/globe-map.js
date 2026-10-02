/**
 * 全球基础设施 - 3D球体 / 平铺地图 切换展示
 * Dependencies are bundled with this theme; no CDN is required.
 */
(function () {
    'use strict';

    var elToggle = document.getElementById('globeToggle');
    var elSphere = document.getElementById('globeSphere');
    var elFlat = document.getElementById('globeFlat');
    if (!elToggle || !elSphere || !elFlat) return;

    /* 本地静态资源 */
    var ECHARTS = '/themes/web/ABCLOUD/static/ape/lib/echarts/echarts.min.js';
    var ECGL = '/themes/web/ABCLOUD/static/ape/lib/echarts-gl/echarts-gl.min.js';
    var WORLD_URL = '/themes/web/ABCLOUD/static/ape/lib/geo/world.json';

    /* 主要节点：[名称, 经度, 纬度, 可用区] */
    var MAJOR_NODES = [
        ['欧洲', 10, 50, 2],
        ['华北', 116, 39, 3],
        ['西北', 87, 43, 2],
        ['西南', 102, 29, 2],
        ['华东', 121, 31, 3],
        ['华南', 114, 23, 2],
        ['中国香港', 114.16, 22.3, 2],
        ['日本', 139, 36, 2],
        ['韩国', 127, 37, 1],
        ['泰国', 100, 15, 1],
        ['新加坡', 103.8, 1.35, 1],
        ['印度尼西亚', 106.8, -6.2, 1],
        ['中东', 45, 26, 1],
        ['美国西部', -122, 37, 2],
        ['美国东部', -74, 40, 3],
        ['圣保罗', -46.6, -23.5, 1]
    ];

    /* 平铺地图：按大洲的标准配色（淡色调），中国单独淡粉 */
    var REGION_MAP = [
        { color: '#fce4ec', countries: ['China'] },
        { color: '#fdf0d5', countries: ['Afghanistan', 'Armenia', 'Azerbaijan', 'Bangladesh', 'Bhutan', 'Brunei', 'Cambodia', 'India', 'Indonesia', 'Iran', 'Iraq', 'Israel', 'Japan', 'Jordan', 'Kazakhstan', 'Korea', 'Dem. Rep. Korea', 'Kuwait', 'Kyrgyzstan', 'Lao PDR', 'Lebanon', 'Malaysia', 'Mongolia', 'Myanmar', 'Nepal', 'Oman', 'Pakistan', 'Palestine', 'Philippines', 'Qatar', 'Saudi Arabia', 'Singapore', 'Sri Lanka', 'Syria', 'Tajikistan', 'Thailand', 'Timor-Leste', 'Turkey', 'Turkmenistan', 'United Arab Emirates', 'Uzbekistan', 'Vietnam', 'Yemen', 'Georgia', 'Siachen Glacier', 'Br. Indian Ocean Ter.'] },
        { color: '#dbeafe', countries: ['Albania', 'Andorra', 'Austria', 'Belarus', 'Belgium', 'Bosnia and Herz.', 'Bulgaria', 'Croatia', 'Cyprus', 'Czech Rep.', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Italy', 'Latvia', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Macedonia', 'Malta', 'Moldova', 'Montenegro', 'Netherlands', 'Norway', 'Poland', 'Portugal', 'Romania', 'Russia', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland', 'Ukraine', 'United Kingdom', 'N. Cyprus', 'Jersey', 'Isle of Man', 'Faeroe Is.'] },
        { color: '#fde4d0', countries: ['Algeria', 'Angola', 'Benin', 'Botswana', 'Burkina Faso', 'Burundi', 'Cameroon', 'Cape Verde', 'Central African Rep.', 'Chad', 'Comoros', 'Congo', 'Dem. Rep. Congo', 'Djibouti', 'Egypt', 'Eq. Guinea', 'Eritrea', 'Ethiopia', 'Gabon', 'Gambia', 'Ghana', 'Guinea', 'Guinea-Bissau', 'Kenya', 'Lesotho', 'Liberia', 'Libya', 'Madagascar', 'Malawi', 'Mali', 'Mauritania', 'Mauritius', 'Morocco', 'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda', 'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia', 'South Africa', 'S. Sudan', 'Sudan', 'Swaziland', 'Tanzania', 'Togo', 'Tunisia', 'Uganda', 'W. Sahara', 'Zambia', 'Zimbabwe'] },
        { color: '#dcefdc', countries: ['Antigua and Barb.', 'Bahamas', 'Barbados', 'Belize', 'Bermuda', 'Canada', 'Costa Rica', 'Cuba', 'Dominica', 'Dominican Rep.', 'El Salvador', 'Grenada', 'Greenland', 'Guatemala', 'Haiti', 'Honduras', 'Jamaica', 'Mexico', 'Nicaragua', 'Panama', 'Puerto Rico', 'Saint Lucia', 'St. Vin. and Gren.', 'Trinidad and Tobago', 'United States', 'Cayman Is.', 'Turks and Caicos Is.', 'U.S. Virgin Is.', 'St. Pierre and Miquelon', 'Montserrat'] },
        { color: '#d3eef0', countries: ['Argentina', 'Bolivia', 'Brazil', 'Chile', 'Colombia', 'Ecuador', 'Falkland Is.', 'Guyana', 'Paraguay', 'Peru', 'Suriname', 'Uruguay', 'Venezuela'] },
        { color: '#e8e0f5', countries: ['Australia', 'Fiji', 'Kiribati', 'Micronesia', 'N. Mariana Is.', 'New Caledonia', 'New Zealand', 'Niue', 'Palau', 'Papua New Guinea', 'Samoa', 'Solomon Is.', 'Tonga', 'Vanuatu', 'American Samoa', 'Guam', 'Heard I. and McDonald Is.', 'Fr. Polynesia'] },
        { color: '#eef0f2', countries: ['Fr. S. Antarctic Lands', 'S. Geo. and S. Sandw. Is.'] }
    ];

    var echarts = null;
    var chart = null;
    var landDots = [];
    var chinaDots = [];
    var majorData = [];
    var linkData = [];
    var mode = 'globe';
    var worldReady = false;
    var currentMode = null;
    var switchTimer = null;
    var ready = false;
    var globeReady = false;
    var scriptLoads = {};

    function loadScript(src) {
        if (window.echarts && src.indexOf('echarts.min.js') !== -1) {
            return Promise.resolve();
        }
        if (scriptLoads[src]) return scriptLoads[src];
        scriptLoads[src] = new Promise(function (resolve, reject) {
            var s = document.createElement('script');
            s.src = src;
            s.async = true;
            s.onload = resolve;
            s.onerror = function () { reject(new Error('加载失败: ' + src)); };
            document.head.appendChild(s);
        });
        return scriptLoads[src];
    }

    /* 从 GeoJSON 中按采样步长取大陆轮廓点，用于球体的“陆地光点” */
    function polygonRings(geom) {
        var rings = [];
        if (!geom) return rings;
        if (geom.type === 'Polygon') {
            rings = geom.coordinates;
        } else if (geom.type === 'MultiPolygon') {
            geom.coordinates.forEach(function (poly) {
                rings = rings.concat(poly);
            });
        }
        return rings;
    }

    function buildLandDots(geoJson) {
        var dots = [];
        var china = [];
        var step = 2; // 采样步长（度）
        geoJson.features.forEach(function (f) {
            var isChina = f.properties && f.properties.name === 'China';
            polygonRings(f.geometry).forEach(function (ring) {
                for (var i = 0; i < ring.length; i += step) {
                    var p = [ring[i][0], ring[i][1], 0.8];
                    if (isChina) china.push(p);
                    else dots.push(p);
                }
            });
        });
        return { dots: dots, china: china };
    }

    function buildMajorData() {
        var nodes = [];
        MAJOR_NODES.forEach(function (n) {
            if (n[1] < -185 || n[1] > 185 || n[2] < -85 || n[2] > 85) return;
            nodes.push({
                name: n[0],
                value: [n[1], n[2], n[3]]
            });
        });
        return nodes;
    }

    function buildLinkData() {
        var hub = [121, 31]; // 华东作为中心汇聚点
        var links = [];
        MAJOR_NODES.forEach(function (n) {
            if ((n[0] === '华北') || Math.abs(n[1] - hub[0]) < 3) return;
            links.push({
                coords: [[n[1], n[2]], hub]
            });
        });
        return links;
    }

    function buildRegions() {
        var regions = [];
        REGION_MAP.forEach(function (g) {
            g.countries.forEach(function (name) {
                regions.push({
                    name: name,
                    itemStyle: { areaColor: g.color }
                });
            });
        });
        return regions;
    }

    function disposeChart() {
        if (chart) {
            chart.dispose();
            chart = null;
        }
    }

    function hideRegionInfo() {}

    function showRegionInfo(params) {}

    function attachGlobeClick() {}

    function renderGlobe() {
        hideRegionInfo();
        disposeChart();
        var isMobile = window.innerWidth <= 768;
        chart = echarts.init(elSphere);
        chart.setOption({
            backgroundColor: 'transparent',
            globe: {
                globeRadius: isMobile ? 92 : 135,
                environment: 'none',
                shading: 'lambert',
                baseColor: '#0d1f3c',
                light: {
                    main: { intensity: 1.1, shadow: false, alpha: 45, beta: 10 },
                    ambient: { intensity: 0.4 }
                },
                atmosphere: {
                    show: true,
                    color: '#3a7bd5',
                    glowPower: 40
                },
                viewControl: {
                    autoRotate: !(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches),
                    autoRotateSpeed: 4,
                    roam: true,
                    distance: isMobile ? 175 : 210,
                    minDistance: 120,
                    maxDistance: 420,
                    damping: 0.85,
                    rotateSensitivity: 1.2,
                    zoomSensitivity: 2.2
                }
            },
            series: [
                {
                    name: '传输线路',
                    type: 'lines3D',
                    coordinateSystem: 'globe',
                    effect: {
                        show: true,
                        trailWidth: 4,
                        trailLength: 0.3,
                        trailOpacity: 0.9,
                        trailColor: '#9ee1ff'
                    },
                    lineStyle: {
                        color: '#1fa8ff',
                        width: 2.2,
                        opacity: 0.9
                    },
                    blendMode: 'lighter',
                    data: linkData
                },
                {
                    name: '全球节点',
                    type: 'scatter3D',
                    coordinateSystem: 'globe',
                    blendMode: 'lighter',
                    symbolSize: 2.0,
                    itemStyle: { color: '#4da3f7', opacity: 1 },
                    data: landDots
                },
                {
                    name: '中国节点',
                    type: 'scatter3D',
                    coordinateSystem: 'globe',
                    blendMode: 'lighter',
                    symbolSize: 2.6,
                    itemStyle: { color: '#ff4d4f', opacity: 1 },
                    data: chinaDots
                },
                {
                    name: '重点区域',
                    type: 'scatter3D',
                    coordinateSystem: 'globe',
                    symbol: 'circle',
                    symbolSize: function (v) { return 3.5 + v[2] * 0.6; },
                    itemStyle: { color: '#57b4ff', opacity: 1 },
                    label: { show: false },
                    emphasis: {
                        label: { show: false },
                        itemStyle: { color: '#1890ff' }
                    },
                    global: true,
                    data: majorData
                }
            ]
        });
        attachGlobeClick();
    }

    function renderFlat() {
        hideRegionInfo();
        disposeChart();
        var isMobile = window.innerWidth <= 768;
        chart = echarts.init(elFlat);
        chart.setOption({
            backgroundColor: 'transparent',
            geo: {
                map: 'world',
                roam: true,
                zoom: isMobile ? 1.4 : 1.6,
                left: 'center',
                top: 'middle',
                layoutCenter: ['50%', '50%'],
                layoutSize: '100%',
                itemStyle: {
                    areaColor: '#eef4fb',
                    borderColor: '#9fc4e8',
                    borderWidth: 1
                },
                regions: buildRegions(),
                emphasis: {
                    disabled: true
                },
                label: { show: false }
            },
            series: [
                {
                    name: '重点区域',
                    type: 'effectScatter',
                    coordinateSystem: 'geo',
                    symbolSize: function (v) { return Math.max(6, v[2] * 3); },
                    rippleEffect: { brushType: 'stroke', scale: 3 },
                    label: {
                        show: true,
                        position: 'right',
                        formatter: '{b}',
                        fontSize: 12,
                        color: '#333'
                    },
                    itemStyle: {
                        color: '#1890ff',
                        shadowBlur: 0
                    },
                    data: majorData.map(function (d) {
                        return { name: d.name, value: d.value };
                    })
                },
                {
                    name: '线路',
                    type: 'lines',
                    coordinateSystem: 'geo',
                    zlevel: 2,
                    effect: {
                        show: true,
                        period: 5,
                        trailLength: 0.25,
                        symbol: 'arrow',
                        symbolSize: 5
                    },
                    lineStyle: {
                        color: '#1890ff',
                        width: 1.6,
                        opacity: 0.7,
                        curveness: 0.3
                    },
                    data: linkData
                }
            ]
        });
    }

    function setMode(m) {
        if (!ready || (m !== 'globe' && m !== 'flat')) return;
        if (m === 'globe' && !globeReady) return;
        if (m === 'flat' && !worldReady) return;
        if (m === mode) return;

        if (switchTimer) clearTimeout(switchTimer);
        switchTimer = null;
        mode = m;

        var btns = elToggle.querySelectorAll('.globe-toggle-btn');
        btns.forEach(function (b) {
            b.classList.toggle('is-active', b.getAttribute('data-mode') === m);
        });

        var showEl = m === 'globe' ? elSphere : elFlat;
        var hideEl = m === 'globe' ? elFlat : elSphere;

        /* 目标画布可能尚未显示：先将旧画布淡出，随后构建新画布并淡入 */
        if (currentMode !== null && hideEl.style.display !== 'none') {
            hideEl.style.transition = 'opacity 0.2s ease';
            hideEl.style.opacity = '0';
            switchTimer = setTimeout(function () {
                doSwitch(hideEl, showEl, m);
            }, 200);
        } else {
            doSwitch(hideEl, showEl, m);
        }
    }

    function doSwitch(hideEl, showEl, m) {
        if (chart) {
            chart.dispose();
            chart = null;
        }
        hideEl.style.display = 'none';
        hideEl.style.opacity = '1';
        hideEl.style.transition = 'none';

        showEl.style.display = 'block';
        showEl.style.opacity = '0';
        showEl.style.transition = 'opacity 0.28s ease';

        if (m === 'globe') renderGlobe();
        else renderFlat();

        currentMode = m;

        requestAnimationFrame(function () {
            showEl.style.opacity = '1';
        });
        if (chart) chart.resize();
    }

    function resize() {
        if (chart) chart.resize();
    }

    function init() {
        majorData = buildMajorData();
        linkData = buildLinkData();
        elToggle.querySelectorAll('button').forEach(function (button) { button.disabled = true; });
        elSphere.setAttribute('aria-busy', 'true');

        elToggle.addEventListener('click', function (e) {
            var btn = e.target.closest('.globe-toggle-btn');
            if (!btn) return;
            setMode(btn.getAttribute('data-mode'));
        });

        window.addEventListener('resize', function () {
            if (chart) chart.resize();
        });
        if ('ResizeObserver' in window) {
            new ResizeObserver(resize).observe(elSphere.parentElement);
        }

        /* 顺序加载：先 echarts，再 echarts-gl，避免 echarts-gl 先于 echarts 执行导致 registerPostInit 报错 */
        loadScript(ECHARTS)
            .then(function () {
                echarts = window.echarts;
                if (!echarts) throw new Error('echarts 未正确加载');
                var map = fetch(WORLD_URL).then(function (r) {
                    if (!r.ok) throw new Error('世界地图数据加载失败');
                    return r.json();
                });
                var gl = loadScript(ECGL).then(function () {
                    var canvas = document.createElement('canvas');
                    var context = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
                    globeReady = !!context;
                    if (context) {
                        var loseContext = context.getExtension('WEBGL_lose_context');
                        if (loseContext) loseContext.loseContext();
                    }
                }).catch(function () { globeReady = false; });
                return Promise.all([map, gl]);
            })
            .then(function (results) {
                var geo = results[0];
                echarts.registerMap('world', geo);
                worldReady = true;
                var dots = buildLandDots(geo);
                landDots = dots.dots;
                chinaDots = dots.china;
                ready = true;
                if (globeReady) {
                    try { renderGlobe(); currentMode = 'globe'; }
                    catch (error) { globeReady = false; }
                }
                if (!globeReady) {
                    mode = 'globe';
                    setMode('flat');
                }
                elToggle.querySelectorAll('button').forEach(function (button) {
                    button.disabled = button.dataset.mode === 'globe' && !globeReady;
                });
                elSphere.setAttribute('aria-busy', 'false');
            })
            .catch(function (err) {
                elSphere.setAttribute('aria-busy', 'false');
                elSphere.textContent = '地图暂时无法加载，请刷新后重试';
                console.warn('global infra map:', err && err.message);
            });
    }

    init();
})();
