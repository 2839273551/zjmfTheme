{include file="themes/cart/ABCLOUD/header.tpl" title="订单提交成功" /}
<!-- 核心交互依赖 -->
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/jquery/jquery.min.js?v=3.0.0"></script>
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/bootstrap/js/bootstrap.bundle.min.js?v=3.0.0"></script>
<link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/viewcart.css?v=3.0.0">

<main class="store-main-container viewcart-page-main">
  <div class="viewcart-layout-wrap">

    <!-- 顶部步骤指示条 (Stepper - 4 步全流程完成) -->
    <div class="viewcart-stepper-card">
      <div class="viewcart-stepper">
        <a href="{$setting.web_url|default=''}/cart" class="step-item is-completed">
          <span class="step-num">✓</span>
          <span class="step-text">选择产品规格</span>
        </a>
        <div class="step-divider"></div>
        <div class="step-item is-completed">
          <span class="step-num">✓</span>
          <span class="step-text">配置业务参数</span>
        </div>
        <div class="step-divider"></div>
        <div class="step-item is-completed">
          <span class="step-num">✓</span>
          <span class="step-text">确认订单结账</span>
        </div>
        <div class="step-divider"></div>
        <div class="step-item is-completed" style="color: #059669; font-weight: 700;">
          <span class="step-num" style="background: #059669; color: #fff; border-color: #059669;">✓</span>
          <span class="step-text">订单提交成功</span>
        </div>
      </div>
    </div>

    <!-- 成功结果大卡片 -->
    <div style="background: #ffffff; border: 1.5px solid #cbd5e1; border-radius: 16px; padding: 60px 24px; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.04); max-width: 800px; margin: 0 auto;">
      <div style="width: 80px; height: 80px; background: #ecfdf5; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 24px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
      </div>

      <h1 style="font-size: 24px; font-weight: 800; color: #0f172a; margin-bottom: 12px;">恭喜您，订单提交成功！</h1>
      <p style="font-size: 14px; color: #64748b; line-height: 1.6; max-width: 520px; margin: 0 auto 36px;">
        您的云服务订购需求已成功录入系统。若您尚未完成支付，请前往财务中心结清账单；支付完成后系统将自动为您调度并开通服务。
      </p>

      <div style="display: flex; align-items: center; justify-content: center; gap: 16px; flex-wrap: wrap;">
        <a href="{$setting.web_url|default=''}/billing" class="btn btn-primary" style="background: #2563eb; border-color: #2563eb; padding: 10px 24px; font-size: 14px; font-weight: 600; border-radius: 8px; box-shadow: 0 4px 12px rgba(37,99,235,0.25);">
          查看我的账单 / 前往支付
        </a>
        <a href="{$setting.web_url|default=''}/clientarea" class="btn btn-outline-primary" style="padding: 10px 24px; font-size: 14px; font-weight: 600; border-radius: 8px; border: 1.5px solid #2563eb; color: #2563eb;">
          进入用户控制台
        </a>
        <a href="{$setting.web_url|default=''}/cart" class="btn btn-outline-secondary" style="padding: 10px 24px; font-size: 14px; font-weight: 500; border-radius: 8px; border: 1.5px solid #cbd5e1; color: #475569;">
          继续选购产品
        </a>
      </div>
    </div>

  </div>
</main>

{include file="themes/cart/ABCLOUD/footer.tpl" /}
