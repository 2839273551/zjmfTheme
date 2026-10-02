    <!-- 服务保障条 -->
    <section class="footer-service-bar" id="service-assurance">
        <div class="container">
            <div class="service-bar-inner">
                <div class="service-bar-item"><img src="/themes/cart/ABCLOUD/static/ape/img/dbtb/4.png" alt="全天候售后服务" class="service-bar-icon"><div class="service-bar-text"><strong>全天候售后服务</strong><span>7*24小时专业工程师高品质服务</span></div></div>
                <div class="service-bar-item"><img src="/themes/cart/ABCLOUD/static/ape/img/dbtb/3.png" alt="极速服务应答" class="service-bar-icon"><div class="service-bar-text"><strong>极速服务应答</strong><span>秒级应答为业务保驾护航</span></div></div>
                <div class="service-bar-item"><img src="/themes/cart/ABCLOUD/static/ape/img/dbtb/1.png" alt="客户价值为先" class="service-bar-icon"><div class="service-bar-text"><strong>客户价值为先</strong><span>从服务价值到创造客户价值</span></div></div>
                <div class="service-bar-item"><img src="/themes/cart/ABCLOUD/static/ape/img/dbtb/2.png" alt="稳定合规运营" class="service-bar-icon"><div class="service-bar-text"><strong>稳定合规运营</strong><span>助力企业安全、高效上云</span></div></div>
            </div>
        </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer bg-white text-dark" id="footer">
        <div class="container">
            <div class="footer-main">
                <div class="footer-nav" id="footerNav">
                    <div class="footer-nav-col">
                        <h5 class="footer-title">服务指南</h5>
                        <ul class="footer-links list-unstyled">
                            <li><a href="{$setting.web_url|default=''}/cart">产品中心</a></li>
                            <li><a href="{$setting.web_url|default=''}/knowledgebase">帮助文档</a></li>
                            <li><a href="{$setting.web_url|default=''}/news">系统公告</a></li>
                            <li><a href="{$setting.web_url|default=''}/supporttickets">提交工单</a></li>
                        </ul>
                    </div>
                    <div class="footer-nav-col">
                        <h5 class="footer-title">账户服务</h5>
                        <ul class="footer-links list-unstyled">
                            <li><a href="{$setting.web_url|default=''}/clientarea">控制台</a></li>
                            <li><a href="{$setting.web_url|default=''}/billing">账单中心</a></li>
                            <li><a href="{$setting.web_url|default=''}/register">注册账户</a></li>
                        </ul>
                    </div>
                    <div class="footer-nav-col">
                        <h5 class="footer-title">帮助中心</h5>
                        <ul class="footer-links list-unstyled">
                            <li><a href="{$setting.web_url|default=''}/news">行业新闻</a></li>
                            <li><a href="{$setting.web_url|default=''}/knowledgebase">帮助中心</a></li>
                            <li><a href="{$setting.web_url|default=''}/supporttickets">服务支持</a></li>
                        </ul>
                    </div>
                    <div class="footer-nav-col">
                        <h5 class="footer-title">关于我们</h5>
                        <ul class="footer-links list-unstyled">
                            <li><a href="{$setting.web_url|default='/'}">公司简介</a></li>
                            <li><a href="{$setting.web_url|default=''}/supporttickets">联系我们</a></li>
                            <li><a href="{$setting.web_url|default=''}/news">公司动态</a></li>
                        </ul>
                    </div>
                </div>
                <div class="footer-contact">
                    <div class="footer-qr-codes">
                        <div class="qr-item"><img src="/themes/cart/ABCLOUD/static/ape/upload/local6626389782fe8.png" alt="微信二维码" class="footer-qr-img"><span>微信二维码</span></div>
                        <div class="qr-item"><img src="/themes/cart/ABCLOUD/static/ape/upload/local662638252e82d.png" alt="小程序二维码" class="footer-qr-img"><span>小程序二维码</span></div>
                    </div>
                    <div class="footer-contact-info">
                        {if $setting.company_phone}<p>服务热线：{$setting.company_phone}</p>{/if}
                        {if $setting.company_email}<p>电子邮箱：{$setting.company_email}</p>{/if}
                        {if $setting.company_address}<p>地址：{$setting.company_address}</p>{/if}
                    </div>
                </div>
            </div>
            <div class="footer-certs">
                <img src="/themes/cart/ABCLOUD/static/ape/img/dbtb/aqrz.png" alt="安全认证">
                <img src="/themes/cart/ABCLOUD/static/ape/img/dbtb/97ebqd4v.png" alt="安全网站">
                <img src="/themes/cart/ABCLOUD/static/ape/img/dbtb/foot02.png" alt="可信网站">
                <img src="/themes/cart/ABCLOUD/static/ape/img/dbtb/kyrdorvp.png" alt="行业认证">
            </div>
            <div class="footer-bottom">
                <p id="apeFooterCopyright">Copyright &copy; {:date('Y')} {if !empty($Setting.company_name)}{$Setting.company_name|htmlspecialchars}{else/}{$setting.company_name|default='ABCLOUD'|htmlspecialchars}{/if}. All Rights Reserved.</p>
                <div class="footer-icp" id="apeFooterIcpList">
                    {if $setting.company_record}<a class="footer-icp-item" href="https://beian.miit.gov.cn/" target="_blank" rel="noopener noreferrer"><span>{$setting.company_record}</span></a>{/if}
                </div>
            </div>
        </div>
    </footer>

    <!-- 脚本引用 -->
    <script src="/themes/cart/ABCLOUD/static/ape/js/bootstrap.min.js?v=3.0.0"></script>
    <script src="/themes/cart/ABCLOUD/static/ape/js/plugin-content.js?v=3.0.0"></script>
    <script src="/themes/cart/ABCLOUD/assets/js/cart.js?v=3.0.0"></script>
    <script>
    // 基础头部交互（用户面板、移动端菜单）
    document.addEventListener('DOMContentLoaded', function() {
        var userBtn = document.getElementById('apeUserBtn');
        var userBox = document.getElementById('apeUserBox');
        if (userBtn && userBox) {
            userBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                userBox.classList.toggle('active');
            });
            document.addEventListener('click', function(e) {
                if (!userBox.contains(e.target)) userBox.classList.remove('active');
            });
        }
        var mUserBtn = document.getElementById('apeMobileUserBtn');
        var mUserPanel = document.getElementById('apeMobileUserPanel');
        if (mUserBtn && mUserPanel) {
            mUserBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                mUserPanel.classList.toggle('active');
            });
            document.addEventListener('click', function(e) {
                if (!mUserPanel.contains(e.target) && e.target !== mUserBtn) mUserPanel.classList.remove('active');
            });
        }
        var hamburger = document.querySelector('.hamburger');
        var mOverlay = document.getElementById('mobileMenuOverlay');
        if (hamburger && mOverlay) {
            hamburger.addEventListener('click', function() {
                var open = mOverlay.classList.toggle('show');
                hamburger.classList.toggle('is-active', open);
                document.body.style.overflow = open ? 'hidden' : '';
            });
            mOverlay.addEventListener('click', function(e) {
                if (e.target === mOverlay) {
                    mOverlay.classList.remove('show');
                    hamburger.classList.remove('is-active');
                    document.body.style.overflow = '';
                }
            });
        }
    });
    </script>
</body>
</html>
